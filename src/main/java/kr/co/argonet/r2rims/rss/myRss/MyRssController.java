package kr.co.argonet.r2rims.rss.myRss;

import kr.co.argonet.r2rims.constant.R2Constant;
import kr.co.argonet.r2rims.core.vo.RimsSearchVo;
import kr.co.argonet.r2rims.core.vo.UserVo;
import kr.co.argonet.r2rims.rss.vo.FavoriteVo;
import kr.co.argonet.r2rims.share.ShareUserService;
import org.apache.solr.client.solrj.SolrServerException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
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

    // My Favorite 리스트
    @RequestMapping(value = "/personal/myRss/myFavorite")
    private String findMyFavorite(ModelMap model, HttpServletRequest req,
                                  @RequestParam(value = "page", defaultValue = "1") String page,
                                  @RequestParam(value = "sort", defaultValue = "regDate") String sort,
                                  @RequestParam(value = "order", defaultValue = "desc") String order){

        UserVo sessUser = (UserVo) req.getSession().getAttribute(R2Constant.SESSION_USER);
        String userId = sessUser.getUserId();

        int ct = 5;
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

        return "/share/myrss/myFavorite";
    }

    // edit Favorite
    @RequestMapping(value = "/editFavorite")
    private @ResponseBody void editFavorite(HttpServletRequest req,
                                            @RequestParam("itemId") String itemId,
                                            @RequestParam("svcgrp") String svcgrp,
                                            @RequestParam("type") String type,
                                            @RequestParam("url") String url){

        UserVo sessUser = (UserVo) req.getSession().getAttribute(R2Constant.SESSION_USER);
        String userId = sessUser.getUserId();

        myRssService.editFavorite(itemId, svcgrp, userId, type, url);
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

    // My Archivements 페이지
    @RequestMapping(value = "/personal/myRss/myArchivements")
    public String userDetail(HttpServletRequest req, ModelMap model) {

        UserVo sessUser = (UserVo) req.getSession().getAttribute(R2Constant.SESSION_USER);
        String userId = sessUser.getUserId();

        UserVo userVo = userService.findUserById(userId);

        model.addAttribute("userId", userVo.getEncptUserId());

        return "share/myrss/myArchivements";
    }

    // My Archivements 컨텐츠
    @RequestMapping(value = "/personal/myRss/myArchivements/contents")
    public @ResponseBody
    Map<String,Object> myArchivements(@RequestParam("tabId") String tabId,
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
}
