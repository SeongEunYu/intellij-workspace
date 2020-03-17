package kr.co.argonet.r2rims.gotit.mapper;

import kr.co.argonet.r2rims.gotit.vo.SvcMessageVo;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * <pre>
 *  kr.co.argonet.r2rims.gotit
 *      ┗ GotitMapper.java
 *
 * </pre>
 *
 * @author : woosik
 * @date 2020-02-25
 */
@Repository(value = "gotitMapper")
public interface GotitMapper {

    List<Map<String, Object>> findTop5 (@Param("userId") String userId);

    List<Map<String, Object>> findFavorite (@Param("userId") String userId);

    List<Map<String, Object>> findMailingTop5 (@Param("userId") String userId);

    List<Map<String, Object>> findMailList (@Param("userId") String userId, @Param("page") int ps, @Param("count") int ct, @Param("sort") String sort, @Param("order") String order);

    Integer totalMail (@Param("userId") String userId);

    List<Map<String, Object>> getMailArticle(@Param("msgId") String msgId, @Param("userId") String userId);
}
