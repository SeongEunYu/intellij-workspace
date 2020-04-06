package kr.co.argonet.r2rims.rss.mapper;

import kr.co.argonet.r2rims.core.vo.*;
import kr.co.argonet.r2rims.rss.vo.RssBbsVo;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

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

    List<Map<String, String>> findWidgetList();

    String findWidgetByUser(@Param("userId") String userId, @Param("name") String name);

    void delWidgetByUser(@Param("userId") String userId, @Param("name") String name);

    void insertWidgetByUser(@Param("widget") String widget, @Param("userId") String userId, @Param("name") String name);

}
