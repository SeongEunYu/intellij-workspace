package kr.co.argonet.r2rims.erp.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import kr.co.argonet.r2rims.core.annotation.ErpMapperScan;
import kr.co.argonet.r2rims.erp.vo.CboPaBudgetNoteVo;
import kr.co.argonet.r2rims.erp.vo.CboPaContractMstNoteVo;
import kr.co.argonet.r2rims.erp.vo.CboPaLaborNoteVo;
import kr.co.argonet.r2rims.erp.vo.CboPaTaskBudgetNoteVo;
import kr.co.argonet.r2rims.erp.vo.CboPaTaskConMstNoteVo;
import kr.co.argonet.r2rims.erp.vo.CboPaTaskLaborNoteVo;

@ErpMapperScan
@Repository(value="erpFundingMapper")
public interface ErpFundingMapper {

	//총괄과제
	List<CboPaContractMstNoteVo> findCboPaContractMstNoteVByLastHarvestDate(@Param("lastHarvestDate")String lastHarvestDate);
	//총괄과제참여자
	List<CboPaLaborNoteVo> findCboPaLaborNoteVByLastHarvestDate(@Param("lastHarvestDate")String lastHarvestDate);
	//총괄과제연구비
	List<CboPaBudgetNoteVo> findCboPaBudgetNoteVByLastHarvestDate(@Param("lastHarvestDate")String lastHarvestDate);
	//Task연구과제
	List<CboPaTaskConMstNoteVo> findCboPaTaskConMstNoteVByLastHarvestDate(@Param("lastHarvestDate")String lastHarvestDate);
	//Task연구과제참여자
	List<CboPaTaskLaborNoteVo> findCboPaTaskLaborNoteVByLastHarvestDate(@Param("lastHarvestDate")String lastHarvestDate);
	//Task연구과제연구비
	List<CboPaTaskBudgetNoteVo> findCboPaTaskBudgetNoteVByLastHarvestDate(@Param("lastHarvestDate")String lastHarvestDate);

	CboPaTaskBudgetNoteVo findCboPaTaskBudgetNoteVByTaskId(@Param("taskId")String taskId);

}
