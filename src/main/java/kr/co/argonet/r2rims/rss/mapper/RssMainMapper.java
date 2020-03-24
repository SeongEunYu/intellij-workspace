package kr.co.argonet.r2rims.rss.mapper;

import kr.co.argonet.r2rims.core.vo.BbsVo;
import kr.co.argonet.r2rims.core.vo.KeywordVo;
import kr.co.argonet.r2rims.core.vo.UserVo;
import kr.co.argonet.r2rims.rss.vo.RssBbsVo;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * <pre>
 *  kr.co.argonet.r2rims.myRSS.mapper
 *      ┗ RssMainMapper.java
 *
 * </pre>
 *
 * @author : woosik
 * @date 2020-02-21
 */
@Repository(value = "rssMainMapper")
public interface RssMainMapper {

    List<Map<String, Object>> staticsArticleByUser(@Param("userId") String userId);

    List<KeywordVo> findKeywordOfKeyword(@Param("keyword") String keyword);

    List<KeywordVo> findKeywordByUser(@Param("userId") String userId);

    List<KeywordVo> findKeywordOfUserBySimilar(@Param("userId") String userId, @Param("smUserId") String smUserId);

    UserVo findSimilarUserList(@Param("userId") String userId);

    List<RssBbsVo> findLatestBBS();
}
