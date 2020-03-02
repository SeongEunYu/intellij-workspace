package kr.co.argonet.r2rims.gotit.mapper;

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

    List<Map<String, Object>> findTop5 (String userId);

    List<Map<String, Object>> findFavorite (String userId);
}
