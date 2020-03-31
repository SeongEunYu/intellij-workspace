package kr.co.argonet.r2rims.rss.main;

import kr.co.argonet.r2rims.analysis.utils.ChartUtils;
import kr.co.argonet.r2rims.core.mapper.ArticleMapper;
import kr.co.argonet.r2rims.core.mapper.UserMapper;
import kr.co.argonet.r2rims.core.vo.*;
import kr.co.argonet.r2rims.rss.mapper.MyAnalysisMapper;
import kr.co.argonet.r2rims.rss.mapper.RssMainMapper;
import kr.co.argonet.r2rims.rss.vo.RssBbsVo;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

/**
 * <pre>
 *  kr.co.argonet.r2rims.rss.main
 *      ┗ RssMainService.java
 *
 * </pre>
 *
 * @author : woosik
 * @date 2020-02-21
 */

@Service(value = "rssMainService")
public class RssMainService {

    @Resource(name = "rssMainMapper")
    private RssMainMapper rssMainMapper;
    @Resource(name = "userMapper")
    private UserMapper userMapper;
    @Resource(name = "myAnalysisMapper")
    private MyAnalysisMapper myAnalysisMapper;
    @Resource(name = "articleMapper")
    private ArticleMapper articleMapper;


    public List<Map<String, Object>> staticsArticleByUser(String userId){
        List<Map<String, Object>> staticsArticle = rssMainMapper.staticsArticleByUser(userId);
        return staticsArticle;
    }

    public List<Map<String,String>> findKeywordOfKeyword(String keyword){
        List<KeywordVo> keywordList = rssMainMapper.findKeywordOfKeyword(keyword);
        return ChartUtils.userKeywordList(keywordList);
    }

    public List<KeywordVo> findKeywordByUser(String userId){
        List<KeywordVo> keywordList = rssMainMapper.findKeywordByUser(userId);
        return keywordList;
    }

    public List<KeywordVo> findKeywordOfUserBySimilar(String userId, String smUserId){
        List<KeywordVo> keywordList = rssMainMapper.findKeywordOfUserBySimilar(userId, smUserId);
        return keywordList;
    }

    public UserVo findSimilarUserList(String userId){
        return rssMainMapper.findSimilarUserList(userId);
    }

    public List<RssBbsVo> findLatestBBS(){
        return rssMainMapper.findLatestBBS();
    }

    public UserVo findUserById(String userId){
        UserVo userVo = userMapper.findUserById(userId);

        return userVo;
    }
    public UserVo findUserById2(String userId){
        UserVo userVo = userMapper.findAllByUserId2(userId);

        return userVo;
    }
    public List<AnalysisVo> findPublicationGroup(RimsSearchVo searchVo){
        return myAnalysisMapper.findPublicationGroup(searchVo);
    }

    public List<AnalysisVo> findArticleCitationByUserId(RimsSearchVo searchVo){
        return myAnalysisMapper.findArticleCitationByUserId(searchVo);
    }

    public List<ArticleVo> findArticleListByUserId(RimsSearchVo searchVo){
        return myAnalysisMapper.findArticleListBySearchVo(searchVo);
    }
}
