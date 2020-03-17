package kr.co.argonet.r2rims.rss.myRss;

import kr.co.argonet.r2rims.core.mapper.*;
import kr.co.argonet.r2rims.core.util.HashMap2;
import kr.co.argonet.r2rims.core.vo.*;
import kr.co.argonet.r2rims.rss.mapper.MyRssMapper;
import kr.co.argonet.r2rims.rss.vo.FavoriteVo;
import kr.co.argonet.util.StringUtil;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import javax.annotation.Resource;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathException;
import javax.xml.xpath.XPathFactory;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * <pre>
 *  kr.co.argonet.r2rims.rss.myRSS
 *      ┗ MyRssService.java
 *
 * </pre>
 *
 * @author : woosik
 * @date 2020-02-21
 */

@Service(value = "myRssService")
public class MyRssService {

    @Resource(name = "myRssMapper")
    private MyRssMapper myRssMapper;

    @Resource(name = "articleMapper")
    private ArticleMapper articleMapper;

    @Resource(name = "userMapper")
    private UserMapper userMapper;

    @Resource(name = "conferenceMapper")
    private ConferenceMapper conferenceMapper;

    @Resource(name = "patentMapper")
    private PatentMapper patentMapper;

    @Resource(name = "fundingMapper")
    private FundingMapper fundingMapper;


    @Value("#{sysConf['s2journal.api.url2']}")
    private String s2JournalUrl;
    @Value("#{sysConf['s2journal.api.key']}")
    private String s2JournalKey;
    @Value("#{sysConf['upload.file.path2']}")
    private String filePath;


    public List<FavoriteVo> findFavorite (String userId, int ps, int ct, String sort, String order){
        List<FavoriteVo> favoriteList = new ArrayList<>();
        favoriteList = myRssMapper.findFavorite(userId, ps, ct, sort, order);
        return favoriteList;
    }

    public int totalFavorite (String userId){
        int total = myRssMapper.totalFavorite(userId);
        return total;
    }

    public void editFavorite (String itemId, String svcgrp, String userId, String type, String url){
        if(type.equals("add")){
            FavoriteVo favorite = new FavoriteVo();

            if(svcgrp.equals("VUSER")){
                // 연구자
                UserVo user = userMapper.findByEncptUserId(itemId);
                favorite.setTitle(user.getKorNm());
                favorite.setDataId(user.getUserId());
            } else if(svcgrp.equals("VART")){
                // 논문
                ArticleVo article = articleMapper.findForDetail(itemId);
                favorite.setTitle(article.getOrgLangPprNm());
                favorite.setDataId(Integer.toString(article.getArticleId()));
            } else if(svcgrp.equals("VPAT")){
                // 특허
                PatentVo patent = patentMapper.findAllById(itemId);
                favorite.setTitle(patent.getItlPprRgtNm());
                favorite.setDataId(Integer.toString(patent.getPatentId()));
            } else if(svcgrp.equals("VPROJ")){
                // 연구과제
                FundingVo funding = fundingMapper.findByFundingId(itemId);
                favorite.setTitle(funding.getRschSbjtNm());
                favorite.setDataId(Integer.toString(funding.getFundingId()));
            } else {
                // 학술활동
                RimsSearchVo rimsSearchVo = new RimsSearchVo();
                rimsSearchVo.setConferenceId(itemId);
                ConferenceVo conference = conferenceMapper.findAllById(rimsSearchVo);
                favorite.setTitle(conference.getOrgLangPprNm());
                favorite.setDataId(Integer.toString(conference.getConferenceId()));
            }
            favorite.setSolution("rss");
            favorite.setSvcgrp(svcgrp);
            favorite.setUrl(url);
            favorite.setUserId(userId);
            myRssMapper.addFavorite(favorite);

        } else {
            if(svcgrp.equals("VUSER")){
                // 연구자
                UserVo user = userMapper.findByEncptUserId(itemId);
                itemId = user.getUserId();
            }
            myRssMapper.deleteFavorite(userId, svcgrp, itemId);
        }
    }

    public int checkFavorite (String itemId, String svcgrp, String userId){
        int result = 0;
        if(svcgrp.equals("VUSER")){
            UserVo user = userMapper.findByEncptUserId(itemId);
            itemId = user.getUserId();
        }
        String favoriteId = myRssMapper.findByItemId(itemId, svcgrp, userId);
        if(favoriteId != null){
            int id = StringUtil.parseInt(favoriteId, 0);
            result = id;
        }
        return result;
    }

    public Map<String, Object> selectionJournal(String title, String keyword, String abstracts) throws MalformedURLException, ParserConfigurationException, SAXException, UnsupportedEncodingException {
//        String url = s2JournalUrl;
        Map<String, Object> returnMap = new HashMap<>();
        HashMap2 summaryMap = new HashMap2();
        List<HashMap2> journalsMapList = new ArrayList<>();

        String url = "http://s2journal.bwise.kr:8081/api/v1/selection.do";
        String key = s2JournalKey;
        String searchUrl = "";
        if(!title.equals("")) {
            title = URLEncoder.encode(title, "UTF-8");
            title = title.replaceAll("\\+","%20");
        }
        if(!keyword.equals("")) {
            keyword = URLEncoder.encode(keyword, "UTF-8");
            keyword = keyword.replaceAll("\\+","%20");
        }
        if(!abstracts.equals("")) {
            abstracts = URLEncoder.encode(abstracts, "UTF-8");
            abstracts = abstracts.replaceAll("\\+","%20");
        }
        searchUrl = url + "?abstracts=" + abstracts + "&recom_keyword=" + keyword + "&title=" + title + "&key=" + key;

        URL callUrl = new URL(searchUrl);
        try(InputStream input = callUrl.openStream()){
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            DocumentBuilder documentBuilder = factory.newDocumentBuilder();
            Document document = documentBuilder.parse(input);

            document.getDocumentElement().normalize();

            XPath xpath = XPathFactory.newInstance().newXPath();

            // criteria
            NodeList criteriaList = (NodeList) xpath.evaluate("//response/criteria", document, XPathConstants.NODESET);
            // journals
            NodeList journalsList = (NodeList) xpath.evaluate("//response/journals/journal", document, XPathConstants.NODESET);

            // criteria parsing
            Node criteriaNode = criteriaList.item(0);
            NodeList criteriaChild = criteriaNode.getChildNodes();
            for(int c = 0; c < criteriaChild.getLength(); ++c){
                Node child = criteriaChild.item(c);
                if(child.getNodeName().equals("ranking")){
                    NodeList rankingList = child.getChildNodes();
                    for (int rl = 0; rl < rankingList.getLength(); ++rl){
                        Node rankingChild = rankingList.item(rl);
                        if(rankingChild.getNodeType() != 3){
                            summaryMap.put(rankingChild.getNodeName(), rankingChild.getTextContent());
                        }
                    }
                } else if(child.getNodeName().equals("listing")) {
                    NodeList listingList = child.getChildNodes();
                    for (int li = 0; li < listingList.getLength(); ++li){
                        Node listChild = listingList.item(li);
                        if(listChild.getNodeType() != 3){
                            summaryMap.put(listChild.getNodeName(), listChild.getTextContent());
                        }
                    }
                } else if(child.getNodeName().equals("open_access")){
                    NodeList oaList = child.getChildNodes();
                    for (int ol = 0; ol < oaList.getLength(); ++ol){
                        Node oaChild = oaList.item(ol);
                        if(oaChild.getNodeType() != 3){
                            summaryMap.put(oaChild.getNodeName(), oaChild.getTextContent());
                        }
                    }
                }
            }

            for(int jn = 0; jn < journalsList.getLength(); ++jn){
                Node journalsNode = journalsList.item(jn);
                NodeList journalsChild = journalsNode.getChildNodes();
                HashMap2 journalMap = new HashMap2();
                for(int j = 0; j < journalsChild.getLength(); ++j){
                    Node child = journalsChild.item(j);
                    if(child.getNodeName().equals("jrnl_id")){
                        if(child.getNodeType() != 3)
                            journalMap.put(child.getNodeName(), child.getTextContent());
                    } else if(child.getNodeName().equals("title")){
                        if(child.getNodeType() != 3)
                            journalMap.put(child.getNodeName(), child.getTextContent());
                    } else if(child.getNodeName().equals("is_oa")){
                        if(child.getNodeType() != 3)
                            journalMap.put(child.getNodeName(), child.getTextContent());
                    } else if(child.getNodeName().equals("publisher")) {
                        if(child.getNodeType() != 3)
                            journalMap.put(child.getNodeName(), child.getTextContent());
                    } else if(child.getNodeName().equals("issn_1")){
                        if(child.getNodeType() != 3)
                            journalMap.put(child.getNodeName(), child.getTextContent());
                    } else if(child.getNodeName().equals("issn_2")){
                        if(child.getNodeType() != 3)
                            journalMap.put(child.getNodeName(), child.getTextContent());
                    } else if(child.getNodeName().equals("listed_on")) {
                        if(child.getNodeType() != 3) {
                            String nodeValue = child.getTextContent();
                            if(!nodeValue.equals("")){
                                String[] valueList = nodeValue.split(";;;");
                                if(valueList.length > 0){
                                    for (String value : valueList) {
                                        String[] valueSplit = value.split(";;");
                                        String name = valueSplit[0];
//                                        String data = valueSplit[1];
                                        if(name.equals("KCI;;(Master)")){
                                            name = "IS_KCI_REG";
                                        } else if (name.equals("KCI Candidate;;(Master)")){
                                            name = "IS_KCI_REG_CAN";
                                        }
                                        journalMap.put("IS_" + name, "Y");
                                    }
                                }
                            }
                            journalMap.put(child.getNodeName(), nodeValue);
                        }
                    } else if(child.getNodeName().equals("score")) {
                        if(child.getNodeType() != 3){
                            double score = Double.parseDouble(child.getTextContent());
                            double roundScore = Math.round(score*100)/100.0;
                            journalMap.put(child.getNodeName(), roundScore);
                        }

                    }
                }
                if(journalMap != null || !journalMap.isEmpty()){
                    journalsMapList.add(journalMap);
                }
            }

            returnMap.put("criteria", summaryMap);
            returnMap.put("journals", journalsMapList);

        } catch (IOException e) {
            e.printStackTrace();
        } catch (XPathException xe){
            xe.printStackTrace();
        }

        return returnMap;
    }

    public int totalBoardCount (String deptCode){
        int total = myRssMapper.totalBoardCount(deptCode);
        return total;
    }

    public List<BbsVo> getBoardList (String deptCode, int ps, int ct, String sort, String order){
        List<BbsVo> bbsList = new ArrayList<>();
        bbsList = myRssMapper.findBoardLIst(deptCode, ps, ct, sort, order);
        return bbsList;
    }

    public BbsVo findBbs (String bbsId, String deptCode) {
        BbsVo bbs = myRssMapper.findBoardDetail(bbsId, deptCode);
        if(bbs.getBbsId() != null){
            List<FileVo> file = myRssMapper.findFile(bbsId);
            bbs.setFileList(file);
        }
        return bbs;
    }

    public void increaseBoardCount(String bbsId){
        myRssMapper.increaseBoardCount(bbsId);
    }

    public InputStream openPdf(String fileUrl) throws IOException {
        File target = new File("/data/gotit/files/resume.pdf");
        if(target.exists()){
            return new FileInputStream(target);
        } else {
           return null;
        }
    }
}
