package kr.co.argonet.r2rims.core.mapper;

import java.util.Date;
import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import kr.co.argonet.r2rims.core.annotation.PmsMapperScan;
import kr.co.argonet.r2rims.core.vo.PatentVo;
import kr.co.argonet.r2rims.core.vo.RimsSearchVo;
import kr.co.argonet.r2rims.core.vo.TechtransCntcVo;
import kr.co.argonet.r2rims.core.vo.TechtransVo;

@PmsMapperScan
@Repository(value="techtransCntcMpper")
public interface TechtransCntcMpper {

	TechtransCntcVo findBySrcId(@Param("srcId")String srcId);

	List<TechtransCntcVo> findByCntcStatus(@Param("cntcStatus")String cntcStatus);

	Date findLastSrcModDate();

	Integer countBySearchVo(RimsSearchVo searchVo);

	List<TechtransCntcVo> findBySearchVo(RimsSearchVo searchVo);

	void add(TechtransCntcVo techtransCntcVo);

	void update(TechtransCntcVo techtransCntcVo);

	void delete(TechtransCntcVo techtransCntcVo);
	
	Integer findTechtransIdBySrcId(@Param("srcId")Integer srcId);
	void completeCntc(TechtransVo techtransVo);
	void updateStatus(@Param("srcIds") String[] srcIds, @Param("modUserId") String modUserId);
	
//	Integer findPatentIdByApplRegNo(String applRegNo);
	Integer findPatentIdByPmsId(@Param("pmsId") int pmsId);

}
