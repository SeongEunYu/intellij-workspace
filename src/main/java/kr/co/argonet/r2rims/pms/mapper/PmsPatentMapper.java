/*
 * Copyright www.argonet.co.kr
 * All rights reserved.
 *
 */
package kr.co.argonet.r2rims.pms.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import kr.co.argonet.r2rims.core.annotation.PmsMapperScan;
import kr.co.argonet.r2rims.core.vo.PatentCntcVo;
import kr.co.argonet.r2rims.core.vo.PatentPartiVo;
import kr.co.argonet.r2rims.core.vo.PatentVo;
import kr.co.argonet.r2rims.core.vo.RimsSearchVo;
import kr.co.argonet.r2rims.core.vo.RsltFundingMapngVo;

/**
 * <pre>
 *  kr.co.argonet.r2rims.pms.mapper
 *      ┗ PmsPatentMapper.java
 *
 * </pre>
 * @date 2016. 12. 5.
 * @version
 * @author : hojkim
 */
@PmsMapperScan
@Repository(value="pmsPatentMapper")
public interface PmsPatentMapper {

	List<PatentVo> findGreaterThanBySrcId(@Param("srcId") Integer maxSrcId);

	List<PatentVo> findNewPatentBySrcId(@Param("srcId") Integer srcId);

	List<PatentCntcVo> findGreaterThanByModHistId(PatentCntcVo cntcVo);

	Integer countBySrcIds(@Param("srcIds") List<Integer> srcIds);

	Integer countBySrcIds(RimsSearchVo searchVo);

	List<PatentVo> findBySrcIds(@Param("srcIds") List<Integer> srcIds);

	List<PatentVo> findBySrcIds(RimsSearchVo searchVo);

	PatentVo findBySrcId(@Param("srcId") Integer srcId);

	List<PatentPartiVo> findCoInventerBySrcId(@Param("srcId") Integer srcId);
	
	List<Map> findFundingMapngListBySrcId(@Param("srcId") Integer srcId);

}
