package kr.co.argonet.r2rims.rss.mapper;

import kr.co.argonet.r2rims.core.vo.*;
import kr.co.argonet.r2rims.rss.vo.RssBbsVo;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * <pre>
 *  kr.co.argonet.r2rims.myRSS.mapper
 *      ┗ MyAnalysisMapper.java
 *
 * </pre>
 *
 * @author : woosik
 * @date 2020-03-27
 */
@Repository(value = "myAnalysisMapper")
public interface MyAnalysisMapper {

    List<AnalysisVo> findPublicationGroup(RimsSearchVo searchVo);

    List<AnalysisVo> findArticleCitationByUserId(RimsSearchVo searchVo);

    List<ArticleVo> findArticleListBySearchVo(RimsSearchVo searchVo);
}
