package kr.co.argonet.r2rims.rss.myRss;

import kr.co.argonet.r2rims.core.mapper.*;
import kr.co.argonet.r2rims.core.vo.*;
import kr.co.argonet.r2rims.rss.mapper.MyRssMapper;
import kr.co.argonet.r2rims.rss.vo.FavoriteVo;
import kr.co.argonet.util.StringUtil;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

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


    public List<FavoriteVo> findFavorite (String userId, int ps, int end, String sort, String order){
        List<FavoriteVo> favoriteList = new ArrayList<>();
        favoriteList = myRssMapper.findFavorite(userId, ps, end, sort, order);
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
}
