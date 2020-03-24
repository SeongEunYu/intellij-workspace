package kr.co.argonet.r2rims.rss.mapper;

import kr.co.argonet.r2rims.core.vo.BbsVo;
import kr.co.argonet.r2rims.core.vo.FileVo;
import kr.co.argonet.r2rims.rss.vo.FavoriteVo;
import kr.co.argonet.r2rims.rss.vo.RssBbsVo;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * <pre>
 *  kr.co.argonet.r2rims.myRSS.mapper
 *      ┗ MyRssMapper.java
 *
 * </pre>
 *
 * @author : woosik
 * @date 2020-02-21
 */
@Repository(value = "myRssMapper")
public interface MyRssMapper {

    List<FavoriteVo> findFavorite(@Param("userId") String userId, @Param("page") int ps, @Param("count") int ct, @Param("sort") String sort, @Param("order") String order);

    List<FavoriteVo> findAllFavorite(@Param("userId") String userId, @Param("svcgrp") String svcgrp);

    Integer totalFavorite(@Param("userId") String userId);

    String findByItemId(@Param("dataId") String dataId, @Param("svcgrp") String svcgrp, @Param("userId") String userId);

    void addFavorite(FavoriteVo favoriteVo);

    void deleteFavorite(@Param("userId") String userId, @Param("svcgrp") String svcgrp, @Param("dataId") String dataId);

    Integer totalBoardCount(@Param("deptCode") String deptCode);

    List<BbsVo> findBoardLIst(@Param("deptCode") String deptCode, @Param("page") int ps, @Param("count") int ct, @Param("sort") String sort, @Param("order") String order);

    BbsVo findBoardDetail(@Param("bbsId") String bbsId, @Param("deptCode") String deptCode);

    List<FileVo> findFile(@Param("bbsId") String bbsId);

    void increaseBoardCount(@Param("bbsId") String bbsId);

    Integer totalBoardCountN();

    List<RssBbsVo> findBoardLIstN(@Param("page") int ps, @Param("count") int ct, @Param("sort") String sort, @Param("order") String order);

    RssBbsVo findBoardDetailN(@Param("bbsId") String bbsId);

    void increaseBoardCountN(@Param("bbsId") String bbsId);
}
