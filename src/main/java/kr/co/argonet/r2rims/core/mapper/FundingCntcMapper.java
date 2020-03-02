package kr.co.argonet.r2rims.core.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import kr.co.argonet.r2rims.core.vo.FundingDetailVo;
import kr.co.argonet.r2rims.core.vo.FundingPartiVo;
import kr.co.argonet.r2rims.core.vo.FundingVo;
import kr.co.argonet.r2rims.core.vo.PatentCntcVo;
import kr.co.argonet.r2rims.core.vo.RimsSearchVo;
import kr.co.argonet.r2rims.erp.vo.CboPaBudgetNoteVo;
import kr.co.argonet.r2rims.erp.vo.CboPaContractMstNoteVo;
import kr.co.argonet.r2rims.erp.vo.CboPaLaborNoteVo;
import kr.co.argonet.r2rims.erp.vo.CboPaTaskBudgetNoteVo;
import kr.co.argonet.r2rims.erp.vo.CboPaTaskConMstNoteVo;
import kr.co.argonet.r2rims.erp.vo.CboPaTaskLaborNoteVo;

@Repository(value="fundingCntcMpper")
public interface FundingCntcMapper {

	List<FundingVo> findOverallList(Map param);
	List<FundingVo> findTaskList(Map param);

	FundingVo findOverallFunding(Map param);
	List<FundingPartiVo> findOverallFundingParti(Map param);
	List<FundingDetailVo> findOverallFundingDetail(Map param);

	FundingVo findTaskFunding(Map param);
	List<FundingPartiVo> findTaskFundingParti(Map param);
	List<FundingDetailVo> findTaskFundingDetail(Map param);

	void updateOverallStatus(@Param("erpIds") String[] erpIds);
	void updateTaskStatus(@Param("erpIds") String[] erpIds);

	List<CboPaContractMstNoteVo> findContractMstNoteVByPorjectId(CboPaContractMstNoteVo contractMstNoteVo);

	void addCboPaContractMstNoteV(CboPaContractMstNoteVo contractMstNoteVo);

	void updateCboPaContractMstNoteV(CboPaContractMstNoteVo contractMstNoteVo);

	List<CboPaLaborNoteVo> findLaborNoteVByHeaderId(CboPaLaborNoteVo laborNoteVo);

	void addCboPaLaborNoteV(CboPaLaborNoteVo laborNoteVo);

	void updateCboPaLaborNoteV(CboPaLaborNoteVo laborNoteVo);

	List<CboPaBudgetNoteVo> findBudgetNoteVByContractId(CboPaBudgetNoteVo budgetNoteVo);

	void addCboPaBudgetNoteV(CboPaBudgetNoteVo budgetNoteVo);

	void updateCboPaBudgetNoteV(CboPaBudgetNoteVo budgetNoteVo);

	List<CboPaTaskConMstNoteVo> findTaskConMstNoteVByTaskId(CboPaTaskConMstNoteVo taskConMstNoteVo);

	void addCboPaTaskConMstNoteV(CboPaTaskConMstNoteVo taskConMstNoteVo);

	void updateCboPaTaskConMstNoteV(CboPaTaskConMstNoteVo taskConMstNoteVo);

	List<CboPaTaskLaborNoteVo> findTaskLaborNoteVByHeaderId(CboPaTaskLaborNoteVo taskLaborNoteVo);

	void addCboPaTaskLaborNoteV(CboPaTaskLaborNoteVo taskLaborNoteVo);

	void updateCboPaTaskLaborNoteV(CboPaTaskLaborNoteVo taskLaborNoteVo);

	List<CboPaTaskBudgetNoteVo> findTaskBudgetNoteVByTaskId(CboPaTaskBudgetNoteVo taskBudgetNoteVo);

	void addCboPaTaskBudgetNoteV(CboPaTaskBudgetNoteVo taskBudgetNoteVo);

	void updateCboPaTaskBudgetNoteV(CboPaTaskBudgetNoteVo taskBudgetNoteVo);

	List<String> findTaskIdByProjectNameIsNull();
}
