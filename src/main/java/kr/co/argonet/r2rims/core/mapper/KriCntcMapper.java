/*
 * Copyright www.argonet.co.kr
 * All rights reserved.
 *
 */
package kr.co.argonet.r2rims.core.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import kr.co.argonet.r2rims.core.vo.ArticlePartiVo;
import kr.co.argonet.r2rims.core.vo.ArticleVo;
import kr.co.argonet.r2rims.core.vo.RimsSearchVo;

/**
 * <pre>
 *  kr.co.argonet.r2rims.core.mapper
 *      ┗ KriCntcMapper.java
 *
 * </pre>
 * @date 2017. 2. 6.
 * @version
 * @author : KIMHOJIN
 */
@Repository(value="kriCntcMapper")
public interface KriCntcMapper {

	public Integer countNkrdd505ByCond(RimsSearchVo searchVo);

	public List<ArticleVo> findNkrdd505ListByCond(RimsSearchVo searchVo);

	public ArticleVo findNkrdd505ByMngNo(@Param("mngNo")String mngNo);

	public List<ArticlePartiVo> findNkrdd506ByMngNo(@Param("mngNo")String mngNo);

}
