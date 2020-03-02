package kr.co.argonet.r2rims.core.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import kr.co.argonet.r2rims.core.vo.PatentCntcVo;
import kr.co.argonet.r2rims.core.vo.PatentVo;
import kr.co.argonet.r2rims.core.vo.RimsSearchVo;

@Repository(value="patentCntcMpper")
public interface PatentCntcMpper {

	PatentCntcVo findBySrcId(@Param("srcId")String srcId);

	List<PatentCntcVo> findByCntcStatus(@Param("cntcStatus")String cntcStatus);

	Integer findLastedInputSrcId();

	Integer findLastedModHistId();

	Integer findPatentIdBySrcId(@Param("srcId")Integer srcId);

	Integer findPatentIdBySrcId(@Param("srcId")String srcId);

	Integer countBySearchVo(RimsSearchVo searchVo);

	List<PatentCntcVo> findBySearchVo(RimsSearchVo searchVo);

	void add(PatentCntcVo patentCntcVo);

	void update(PatentCntcVo patentCntcVo);

	void updateCntcStatusBySrcId(@Param("srcId")Integer srcId, @Param("cntcStatus")String cntcStatus);

	void updateCntcStatusBySrcId(@Param("srcId")String srcId, @Param("cntcStatus")String cntcStatus);

	void updateModHistIdBySrcId(@Param("srcId")Integer srcId, @Param("modHistId")Integer modHistId);

	void updateModHistIdBySrcId(PatentCntcVo patentCntcVo);

	void updatePatentIdBySrcId(@Param("srcId")Integer srcId, @Param("patentId")Integer modHistId);

	void delete(PatentCntcVo patentCntcVo);

	void completeCntc(PatentVo patentVo);
	
	void updateStatus(@Param("srcIds") String[] srcIds, @Param("modUserId") String modUserId);

}
