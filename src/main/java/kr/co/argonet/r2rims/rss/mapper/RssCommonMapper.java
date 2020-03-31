package kr.co.argonet.r2rims.rss.mapper;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * <pre>
 *  kr.co.argonet.r2rims.myRSS.mapper
 *      ┗ RssCommonMapper.java
 *
 * </pre>
 *
 * @author : woosik
 * @date 2020-03-30
 */
@Repository(value = "rssCommonMapper")
public interface RssCommonMapper {

    List<Map<String, Object>> findPrtcpntIdListByArticleId(@Param("articleId")String articleId);
}
