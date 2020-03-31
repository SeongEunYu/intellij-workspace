package kr.co.argonet.r2rims.rss.myRss;

import kr.co.argonet.r2rims.constant.R2Constant;
import kr.co.argonet.r2rims.core.annotation.NoAuthCheck;
import kr.co.argonet.r2rims.core.annotation.NoShareSessionCheck;
import kr.co.argonet.r2rims.core.util.HashMap2;
import kr.co.argonet.r2rims.core.vo.BbsVo;
import kr.co.argonet.r2rims.core.vo.FileVo;
import kr.co.argonet.r2rims.core.vo.RimsSearchVo;
import kr.co.argonet.r2rims.core.vo.UserVo;
import kr.co.argonet.r2rims.gotit.GotitService;
import kr.co.argonet.r2rims.rss.vo.FavoriteVo;
import kr.co.argonet.r2rims.rss.vo.RssBbsVo;
import kr.co.argonet.r2rims.share.ShareUserService;
import org.apache.solr.client.solrj.SolrServerException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.http.ResponseEntity.BodyBuilder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;
import org.xml.sax.SAXException;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.ParserConfigurationException;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * <pre>
 *  kr.co.argonet.r2rims.rss.myRSS
 *      ┗ MyRssController.java
 *
 * </pre>
 *
 * @author : woosik
 * @date 2020-02-21
 */

@Controller(value="myRssController")
public class MyRssController {

    @Resource(name = "myRssService")
    private MyRssService myRssService;
    @Resource(name="shareUserService")
    private ShareUserService userService;
    @Resource(name="gotitService")
    private GotitService gotitService;

    @Value("#{sysConf['s2journal.url']}")
    private String s2JournalUrl;
    @Value("#{sysConf['s2journal.api.url']}")
    private String s2JournalApiUrl;


    // My Favorite 리스트
    @RequestMapping(value = "/personal/myRss/myFavorite")
    private String findMyFavorite(ModelMap model, HttpServletRequest req,
                                  @RequestParam(value = "page", defaultValue = "1") String page,
                                  @RequestParam(value = "sort", defaultValue = "regDate") String sort,
                                  @RequestParam(value = "order", defaultValue = "desc") String order){

        UserVo sessUser = (UserVo) req.getSession().getAttribute(R2Constant.SESSION_USER);
        String userId = sessUser.getUserId();

        int ct = 10;
        int ps = Integer.parseInt(page);
        int totalFavorite;
        int end;

        ps = (ps-1)*ct;   // 페이지 시작부분 index

        totalFavorite = myRssService.totalFavorite(userId);

        if(ps+ct > totalFavorite){
            end = totalFavorite;
        }else{
            end = ps+ct;
        }

        List<FavoriteVo> favoriteList = myRssService.findFavorite(userId, ps, ct, sort, order);


        model.addAttribute("pageList", userService.drawPages(Integer.parseInt(page), (double)ct, (double)totalFavorite));

        model.addAttribute("favoriteList",favoriteList);

        model.addAttribute("ps",ps+1);
        model.addAttribute("end",end);
        model.addAttribute("totalFavorite",totalFavorite);
        model.addAttribute("page",page);
        model.addAttribute("sort", sort);
        model.addAttribute("order", order);
        model.addAttribute("s2jUrl", s2JournalUrl);

        return "/share/myrss/myFavorite";
    }

    // edit Favorite
    @RequestMapping(value = "/editFavorite")
    private @ResponseBody void editFavorite(HttpServletRequest req,
                                            @RequestParam("itemId") String itemId,
                                            @RequestParam("svcgrp") String svcgrp,
                                            @RequestParam("type") String type,
                                            @RequestParam("url") String url,
                                            @RequestParam("elseList") String elseList){

        UserVo sessUser = (UserVo) req.getSession().getAttribute(R2Constant.SESSION_USER);
        String userId = sessUser.getUserId();

        myRssService.editFavorite(itemId, svcgrp, userId, type, url, elseList);
    }

    // Favorite 체크(연구자, 논문 등의 상세페이지 부분)
    // r2Rims_share를 통해 불러올 때 같이 불러오기?? 현재는 ajax로 favorite 체크
    @RequestMapping(value = "/checkFavorite")
    private @ResponseBody boolean checkFavorite(@RequestParam("itemId") String itemId,
                                               @RequestParam("svcgrp") String svcgrp,
                                               HttpServletRequest req){

        UserVo sessUser = (UserVo) req.getSession().getAttribute(R2Constant.SESSION_USER);
        String userId = sessUser.getUserId();
        boolean result = false;

        int favorite = myRssService.checkFavorite(itemId, svcgrp, userId);
        if(favorite > 0){
            result = true;
        }
        return result;
    }

    // My Research Output 페이지
    @RequestMapping(value = "/personal/myRss/myResearchOutput")
    public String userDetail(HttpServletRequest req, ModelMap model) {

        UserVo sessUser = (UserVo) req.getSession().getAttribute(R2Constant.SESSION_USER);
        String userId = sessUser.getUserId();

        UserVo userVo = userService.findUserById(userId);

        model.addAttribute("userId", userVo.getEncptUserId());

        return "share/myrss/myResearchOutput";
    }

    // My Research Output 컨텐츠
    @RequestMapping(value = "/personal/myRss/myResearchOutput/contents")
    public @ResponseBody
    Map<String,Object> myResearchOutput(@RequestParam("tabId") String tabId,
                               @RequestParam("id") String encptUserId,
                               @RequestParam(value = "page", defaultValue = "1") String page, //현재 페이지
                               @RequestParam(value = "count", required = false, defaultValue = "10") String count,
                               @RequestParam("sort") String sort,
                               @RequestParam("order") String order,
                               ModelMap model) {

        RimsSearchVo rimsSearchVo = new RimsSearchVo();
        int totalContent; //총 컨텐츠 갯수
        int ps = Integer.parseInt(page);
        int ct = Integer.parseInt(count); 	 // 페이지당 row수
        Map<String, Integer> pageCount = new HashMap<>();

        ps = (ps-1)*ct; // 페이지 시작부분 index


        UserVo userVo = userService.findByEncptUserId(encptUserId);
        String userId = userVo.getUserId();

        rimsSearchVo.setUserId(userId);
        rimsSearchVo.setPs(ps);
        rimsSearchVo.setCt(ct);
        rimsSearchVo.setText(sort);
        rimsSearchVo.setType(order);

        Map<String,Object> resultMap = null;
        Map<String,Object> contentPagemap = new HashMap<>();

        // 성과 리스트 및 성과 총개수
        try {
            resultMap = userService.findContents(tabId, rimsSearchVo);
        } catch (IOException e) {
            e.printStackTrace();
        } catch (SolrServerException e) {
            e.printStackTrace();
        }

        contentPagemap.put("content",resultMap.get("contentList"));

        totalContent = (int)resultMap.get("totalNum");

        contentPagemap.put("pageList", userService.drawPages(Integer.parseInt(page), (double)ct, (double)totalContent));

        pageCount.put("ps",ps+1);
        if(ps+ct > totalContent){
            pageCount.put("end",totalContent);
        }else{
            pageCount.put("end",ps+ct);
        }
        pageCount.put("total",totalContent);

        contentPagemap.put("count",pageCount);
        return contentPagemap;
    }

    @RequestMapping(value = "/personal/selection")
    public String searchRecommendJournal(ModelMap modelMap, HttpServletRequest req,
                                         @RequestParam(value = "recom_title", defaultValue = "") String title,
                                         @RequestParam(value = "recom_keyword", defaultValue = "") String keyword,
                                         @RequestParam(value = "abstracts", defaultValue = "") String abstracts,
                                         @RequestParam(value = "isSearch", defaultValue = "N") String isSearch,
                                         @RequestParam(value = "rank_jcr", defaultValue = "N") String rank_jcr,
                                         @RequestParam(value = "rank_sjr", defaultValue = "N") String rank_sjr,
                                         @RequestParam(value = "rank_cs", defaultValue = "N") String rank_cs,
                                         @RequestParam(value = "rank_kci", defaultValue = "N") String rank_kci,
                                         @RequestParam(value = "list_sci", defaultValue = "N") String list_sci,
                                         @RequestParam(value = "list_scie", defaultValue = "N") String list_scie,
                                         @RequestParam(value = "list_ssci", defaultValue = "N") String list_ssci,
                                         @RequestParam(value = "list_ahci", defaultValue = "N") String list_ahci,
                                         @RequestParam(value = "list_esci", defaultValue = "N") String list_esci,
                                         @RequestParam(value = "list_cc", defaultValue = "N") String list_cc,
                                         @RequestParam(value = "list_scopus", defaultValue = "N") String list_scopus,
                                         @RequestParam(value = "list_medline", defaultValue = "N") String list_medline,
                                         @RequestParam(value = "list_doaj", defaultValue = "N") String list_doaj,
                                         @RequestParam(value = "list_kci_reg", defaultValue = "N") String list_kci_reg,
                                         @RequestParam(value = "list_kci_reg_can", defaultValue = "N") String list_kci_reg_can,
                                         @RequestParam(value = "list_embase", defaultValue = "N") String list_embase,
                                         @RequestParam(value = "etc_oa", defaultValue = "N") String etc_oa,
                                         @RequestParam(value = "under_per", defaultValue = "100") String under_per)
            throws MalformedURLException, ParserConfigurationException, SAXException, UnsupportedEncodingException {

        UserVo sessUser = (UserVo) req.getSession().getAttribute(R2Constant.SESSION_USER);
        String userId = sessUser.getUserId();

        if(isSearch.equals("Y")) {
            Map<String, Object> s2journalReturnMap = myRssService.selectionJournal(title, keyword, abstracts);

            if (s2journalReturnMap.get("criteria") != null)
                req.setAttribute("summaryMap", s2journalReturnMap.get("criteria"));
            if (s2journalReturnMap.get("journals") != null){
                List<HashMap2> journalList = (List<HashMap2>) s2journalReturnMap.get("journals");
                modelMap.addAttribute("allCount", journalList.size());

                //filter
                List<String> filterList = new ArrayList<>();
                if(rank_jcr.equals("Y"))
                    filterList.add("IS_JCR");
                if(rank_sjr.equals("Y"))
                    filterList.add("IS_SJR");
                if(rank_cs.equals("Y"))
                    filterList.add("IS_CiteScore");
                if(rank_kci.equals("Y"))
                    filterList.add("IS_KCI");
                if(list_sci.equals("Y"))
                    filterList.add("IS_SCI");
                if(list_scie.equals("Y"))
                    filterList.add("IS_SCIE");
                if(list_ssci.equals("Y"))
                    filterList.add("IS_SSCI");
                if(list_ahci.equals("Y"))
                    filterList.add("IS_A&HCI");
                if(list_esci.equals("Y"))
                    filterList.add("IS_ESCI");
                if(list_cc.equals("Y"))
                    filterList.add("IS_CC");
                if(list_scopus.equals("Y"))
                    filterList.add("IS_SCOPUS");
                if(list_medline.equals("Y"))
                    filterList.add("IS_MEDLINE");
                if(list_doaj.equals("Y"))
                    filterList.add("IS_DOAJ");
                if(list_kci_reg.equals("Y"))
                    filterList.add("IS_KCI_REG");
                if(list_kci_reg_can.equals("Y"))
                    filterList.add("IS_KCI_REG_CAN");
                if(list_embase.equals("Y"))
                    filterList.add("IS_EMBASE");
                if(etc_oa.equals("Y"))
                    filterList.add("is_oa");

                filterJournalList(req, journalList, filterList, under_per);
            }

            modelMap.addAttribute("recom_title", title);
            modelMap.addAttribute("recom_keyword", keyword);
            modelMap.addAttribute("abstracts", abstracts);

            modelMap.addAttribute("s2jUrl", s2JournalUrl);

        }
        modelMap.addAttribute("isSearch", isSearch);
        modelMap.addAttribute("under_per", under_per);

        List<FavoriteVo> favoriteList = myRssService.findAllFavorite(userId, "VJOUR");
        String favoriteString = "";
        int index = 0;
        for (FavoriteVo favorite:favoriteList) {
            if(index > 0)
                favoriteString += ",";
            favoriteString += favorite.getDataId();
        }
        req.setAttribute("favoriteString", favoriteString);

        return "share/recommand/selection";
    }

    public void filterJournalList(HttpServletRequest req, List<HashMap2> journalList, List<String> filterList, String under_per){

        if(under_per.contains(".")){
            under_per = under_per.substring(0, under_per.indexOf("."));
        }
        int per = Integer.parseInt(under_per);
        if(per > 100)
            per = 100;

        if(filterList.size() > 0){
            List<HashMap2> filterJournal = new ArrayList<HashMap2>();
            for (String filter : filterList) {
                for (HashMap2 journal : journalList) {
                    if(journal.get(filter) != null){
                        filterJournal.add(journal);
                    }
                }
                journalList = filterJournal;
            }

            if(filterList.contains("IS_JCR") || filterList.contains("IS_SJR") || filterList.contains("IS_CiteScore") || filterList.contains("IS_KCI")){
                if(per < 100){
                    int resultCount = filterJournal.size();
                    int x = resultCount * per / 100;
                    List<HashMap2> filterJournalByPer = new ArrayList<HashMap2>();
                    int index = 0;
                    for (HashMap2 journal2 : filterJournal) {
                        if(index < x){
                            filterJournalByPer.add(journal2);
                            index++;
                        } else {
                            break;
                        }
                    }
                    req.setAttribute("resultList", filterJournalByPer);
                } else {
                    req.setAttribute("resultList", filterJournal);
                }
            } else {
                req.setAttribute("resultList", filterJournal);
            }
        } else {
            req.setAttribute("resultList", journalList);
        }

    }

    @RequestMapping(value = "/personal/compare")
    private String compare (ModelMap modelMap, HttpServletRequest req){
        UserVo sessUser = (UserVo) req.getSession().getAttribute(R2Constant.SESSION_USER);
        String userId = sessUser.getUserId();

        List<FavoriteVo> favoriteJournalList = myRssService.findAllFavorite(userId, "VJOUR");
        modelMap.addAttribute("journalList", favoriteJournalList);

        modelMap.addAttribute("s2jApiUrl", s2JournalApiUrl);

        return "share/recommand/compare";
    }

    @RequestMapping(value = "/personal/toc")
    private String mailingList (ModelMap model, HttpServletRequest req,
                                @RequestParam(value = "page", defaultValue = "1") String page,
                                @RequestParam(value = "sort", defaultValue = "regDate") String sort,
                                @RequestParam(value = "order", defaultValue = "desc") String order){

        UserVo sessUser = (UserVo) req.getSession().getAttribute(R2Constant.SESSION_USER);
        String userId = sessUser.getUserId();

        int ct = 10;
        int ps = Integer.parseInt(page);
        int total;
        int end;

        ps = (ps-1)*ct;   // 페이지 시작부분 index

        total = gotitService.totalMailCount(userId);

        if(ps+ct > total){
            end = total;
        }else{
            end = ps+ct;
        }

        List<Map<String, Object>> mailList = gotitService.getMailList(userId, ps, ct, sort, order);


        model.addAttribute("pageList", userService.drawPages(Integer.parseInt(page), (double)ct, (double)total));

        model.addAttribute("mailList",mailList);

        model.addAttribute("ps",ps+1);
        model.addAttribute("end",end);
        model.addAttribute("total",total);
        model.addAttribute("page",page);
        model.addAttribute("sort", sort);
        model.addAttribute("order", order);

        return "share/myrss/tocList";
    }

    @RequestMapping(value = "/personal/toc/article")
    public String mailingDetail (HttpServletRequest req, ModelMap modelMap, @RequestParam(value = "msgId") String msgId,
                                 @RequestParam(value = "page", defaultValue = "1") String page,
                                 @RequestParam(value = "sort", defaultValue = "regDate") String sort,
                                 @RequestParam(value = "order", defaultValue = "desc") String order){

        UserVo sessUser = (UserVo) req.getSession().getAttribute(R2Constant.SESSION_USER);
        String userId = sessUser.getUserId();

        List<Map<String, Object>> articleList = gotitService.getMailArticle(msgId, userId);
        modelMap.addAttribute("articleList", articleList);

        modelMap.addAttribute("page",page);
        modelMap.addAttribute("sort", sort);
        modelMap.addAttribute("order", order);

        return "share/myrss/tocArticleList";
    }

    @RequestMapping(value = "/personal/myRss/nBoard")
    private String nboardList (ModelMap model, HttpServletRequest req,
                              @RequestParam(value = "page", defaultValue = "1") String page,
                              @RequestParam(value = "sort", defaultValue = "regDate") String sort,
                              @RequestParam(value = "order", defaultValue = "desc") String order){

        UserVo sessUser = (UserVo) req.getSession().getAttribute(R2Constant.SESSION_USER);
        String userId = sessUser.getUserId();

        int ct = 10;
        int ps = Integer.parseInt(page);
        int total;
        int end;

        ps = (ps-1)*ct;   // 페이지 시작부분 index

        total = myRssService.totalBoardCountN();

        if(ps+ct > total){
            end = total;
        }else{
            end = ps+ct;
        }

        List<RssBbsVo> boardList = myRssService.getBoardListN(ps, ct, sort, order);


        model.addAttribute("pageList", userService.drawPages(Integer.parseInt(page), (double)ct, (double)total));

        model.addAttribute("boardList",boardList);

        model.addAttribute("ps",ps+1);
        model.addAttribute("end",end);
        model.addAttribute("total",total);
        model.addAttribute("page",page);
        model.addAttribute("sort", sort);
        model.addAttribute("order", order);

        return "share/myrss/nboard";
    }

    @RequestMapping(value = "/personal/myRss/nBoardDetail")
    private String nboardListView (ModelMap model, HttpServletRequest req,
                                  @RequestParam(value = "bbsId", defaultValue = "") String bbsId,
                                  @RequestParam(value = "page", defaultValue = "1") String page,
                                  @RequestParam(value = "sort", defaultValue = "regDate") String sort,
                                  @RequestParam(value = "order", defaultValue = "desc") String order){

        UserVo sessUser = (UserVo) req.getSession().getAttribute(R2Constant.SESSION_USER);

        // 조회수 +
        myRssService.increaseBoardCountN(bbsId);

        RssBbsVo bbs = myRssService.findBbsN(bbsId);

        model.addAttribute("bbs", bbs);
        model.addAttribute("page",page);
        model.addAttribute("sort", sort);
        model.addAttribute("order", order);

        return "share/myrss/nboardView";
    }

    @RequestMapping(value = "/personal/myRss/rBoard")
    private String boardList (ModelMap model, HttpServletRequest req,
                                @RequestParam(value = "page", defaultValue = "1") String page,
                                @RequestParam(value = "sort", defaultValue = "regDate") String sort,
                                @RequestParam(value = "order", defaultValue = "desc") String order){

        UserVo sessUser = (UserVo) req.getSession().getAttribute(R2Constant.SESSION_USER);
        String userId = sessUser.getUserId();
        String deptCode = sessUser.getDeptCode();

        int ct = 10;
        int ps = Integer.parseInt(page);
        int total;
        int end;

        ps = (ps-1)*ct;   // 페이지 시작부분 index

        total = myRssService.totalBoardCount(deptCode);

        if(ps+ct > total){
            end = total;
        }else{
            end = ps+ct;
        }

        List<BbsVo> boardList = myRssService.getBoardList(deptCode, ps, ct, sort, order);


        model.addAttribute("pageList", userService.drawPages(Integer.parseInt(page), (double)ct, (double)total));

        model.addAttribute("boardList",boardList);

        model.addAttribute("ps",ps+1);
        model.addAttribute("end",end);
        model.addAttribute("total",total);
        model.addAttribute("page",page);
        model.addAttribute("sort", sort);
        model.addAttribute("order", order);

        return "share/myrss/board";
    }

    @RequestMapping(value = "/personal/myRss/rBoardDetail")
    private String boardListView (ModelMap model, HttpServletRequest req,
                              @RequestParam(value = "bbsId", defaultValue = "") String bbsId,
                              @RequestParam(value = "page", defaultValue = "1") String page,
                              @RequestParam(value = "sort", defaultValue = "regDate") String sort,
                              @RequestParam(value = "order", defaultValue = "desc") String order){

        UserVo sessUser = (UserVo) req.getSession().getAttribute(R2Constant.SESSION_USER);
        String deptCode = sessUser.getDeptCode();

        // 조회수 +
        myRssService.increaseBoardCount(bbsId);

        BbsVo bbs = myRssService.findBbs(bbsId, deptCode);

        model.addAttribute("bbs", bbs);
        model.addAttribute("page",page);
        model.addAttribute("sort", sort);
        model.addAttribute("order", order);

        return "share/myrss/boardView";
    }

    @NoAuthCheck @NoShareSessionCheck
    @RequestMapping(value = "/pdf/{bbsId}/{pdfName}", method = RequestMethod.GET, produces={MediaType.TEXT_HTML_VALUE, "application/pdf"})
    public @ResponseBody
    ResponseEntity<InputStreamResource> pdfFile(HttpServletRequest req, HttpServletResponse res,
                                                @PathVariable("bbsId") String bbsId) throws IOException{

        UserVo sessUser = (UserVo) req.getSession().getAttribute(R2Constant.SESSION_USER);
        String deptCode = sessUser.getDeptCode();

        BbsVo bbsVo = null;
        FileVo file = null;

        if(bbsId != null){
            bbsVo = myRssService.findBbs(bbsId, deptCode);
            List<FileVo> fileList = bbsVo.getFileList();
            if(fileList != null || !fileList.isEmpty()){
                file = fileList.get(0);
            }
        }

        InputStream resource = myRssService.openPdf(file.getFileUrl());
        BodyBuilder r = ResponseEntity.ok();
        if(file.getFileSize() > 0)
            r.contentLength(file.getFileSize());
//        r.header("Content-Type", "application/pdf");
        r.contentType(MediaType.parseMediaType("application/pdf"));
        return r.body(new InputStreamResource(resource));
    }

}
