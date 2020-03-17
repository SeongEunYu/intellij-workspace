package kr.co.argonet.r2rims.pms.mapper;

import java.util.Date;
import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import kr.co.argonet.r2rims.core.annotation.PmsMapperScan;
import kr.co.argonet.r2rims.core.vo.RsltPatentMapngVo;
import kr.co.argonet.r2rims.core.vo.TechtransPartiDstbamtVo;
import kr.co.argonet.r2rims.core.vo.TechtransPartiVo;
import kr.co.argonet.r2rims.core.vo.TechtransRoyaltyVo;
import kr.co.argonet.r2rims.core.vo.TechtransVo;

@PmsMapperScan
@Repository(value="pmsTechtransferMapper")
public interface PmsTechtransferMapper {

	List<TechtransVo> findTechtransferByModDate(@Param("lastHarvestDate")Date lastHarvestDate);

	List<TechtransVo> findTechtransListBySrcIds(@Param("srcIds") List<Integer> srcIds);
	TechtransVo findTechtransferBySrcId(@Param("srcId") Integer srcId);

	List<TechtransRoyaltyVo> findTechtransferRcpmnyListBySrcId(@Param("srcId")Integer srcId);

	List<TechtransPartiVo> findTechtransferPartiListBySrcId(@Param("srcId")Integer srcId);

	List<TechtransPartiDstbamtVo> findTechtransferPartiDstbamtListBySrcIdAndRpmTme(@Param("srcId")Integer srcId, @Param("srcTme")Integer srcTme);

	List<RsltPatentMapngVo> findPatentListBySrcId(@Param("srcId")Integer srcId);

}
