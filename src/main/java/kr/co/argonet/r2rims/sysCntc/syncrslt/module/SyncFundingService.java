package kr.co.argonet.r2rims.sysCntc.syncrslt.module;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import kr.co.argonet.r2rims.constant.R2Constant;
import kr.co.argonet.r2rims.core.mapper.FundingCntcMapper;
import kr.co.argonet.r2rims.core.vo.SyncLogVo;
import kr.co.argonet.r2rims.erp.mapper.ErpFundingMapper;
import kr.co.argonet.r2rims.erp.vo.CboPaBudgetNoteVo;
import kr.co.argonet.r2rims.erp.vo.CboPaContractMstNoteVo;
import kr.co.argonet.r2rims.erp.vo.CboPaLaborNoteVo;
import kr.co.argonet.r2rims.erp.vo.CboPaTaskBudgetNoteVo;
import kr.co.argonet.r2rims.erp.vo.CboPaTaskConMstNoteVo;
import kr.co.argonet.r2rims.erp.vo.CboPaTaskLaborNoteVo;

public class SyncFundingService extends SyncFunding {

	Logger log = LoggerFactory.getLogger(SyncFundingService.class);

	public void sync() {

		SqlSession sqlSession =  (SqlSession) context.getBean("sqlSession");
		FundingCntcMapper fundingCntcMapper = sqlSession.getMapper(FundingCntcMapper.class);

		SqlSession erpSqlSession =  (SqlSession) context.getBean("erpSqlSession");
		ErpFundingMapper erpFundingMapper = erpSqlSession.getMapper(ErpFundingMapper.class);

		// 1) 총괄과제 Sync
		int trgtCo = 0;
		int insertCo = 0;
		int updateCo = 0;

		int mstCo = 0;
		int mstInsCo = 0;
		int mstUpdateCo = 0;

		int laborCo = 0;
		int laborInsCo = 0;
		int laborUpdateCo = 0;

		int budgetCo = 0;
		int budgetInsCo = 0;
		int budgetUpdateCo = 0;


		String lastSyncDate = null;
		StringBuffer rm = new StringBuffer();

		if (stdrDate != null && !"".equals(stdrDate)) {
			lastSyncDate =stdrDate.replace("-","");
		} else {
			lastSyncDate = syncLogMapper.findLastHarvestDateBySyncTarget(R2Constant.SYSCNTC_SYNC_TARGET_OVERALL_FUNDING);
			if (lastSyncDate == null) {
				SimpleDateFormat sdf=new SimpleDateFormat("yyyyMMdd");
				Date nowDate = new Date();
				lastSyncDate = sdf.format(nowDate);
			}
		}

		SyncLogVo logVo = new SyncLogVo();
		logVo.setSyncTarget(R2Constant.SYSCNTC_SYNC_TARGET_OVERALL_FUNDING);
		logVo.setSyncType(syncType);
		logVo.setStdrDate(lastSyncDate);
		logVo.setRegUserId(regUserId);
		int seqNo = syncLogMapper.add(logVo);

		log.debug("Overall Funding Sync log seq_no >>>>>> {}", seqNo);

		try {

			if (lastSyncDate != null) {
				//과제정보
				List<CboPaContractMstNoteVo> contractMstList = erpFundingMapper.findCboPaContractMstNoteVByLastHarvestDate(lastSyncDate);
				if(contractMstList != null && contractMstList.size() > 0)
				{
					trgtCo += contractMstList.size();
					mstCo = contractMstList.size();

					for(CboPaContractMstNoteVo contractMstNoteVo : contractMstList )
					{
						List<CboPaContractMstNoteVo> checkConstractMstNote = fundingCntcMapper.findContractMstNoteVByPorjectId(contractMstNoteVo);

						if(checkConstractMstNote != null && checkConstractMstNote.size() > 0)
						{
							fundingCntcMapper.updateCboPaContractMstNoteV(contractMstNoteVo);
							updateCo++;
							mstUpdateCo++;
						}
						else
						{
							fundingCntcMapper.addCboPaContractMstNoteV(contractMstNoteVo);
							insertCo++;
							mstInsCo++;
						}
					}
				}
				//참여자정보
				List<CboPaLaborNoteVo> laborList = erpFundingMapper.findCboPaLaborNoteVByLastHarvestDate(lastSyncDate);
				if(laborList != null && laborList.size() > 0)
				{
					trgtCo += laborList.size();
					laborCo = laborList.size();

					for(CboPaLaborNoteVo laborNoteVo : laborList )
					{
						List<CboPaLaborNoteVo> checkLaborNote = fundingCntcMapper.findLaborNoteVByHeaderId(laborNoteVo);

						if(checkLaborNote != null && checkLaborNote.size() > 0)
						{
							fundingCntcMapper.updateCboPaLaborNoteV(laborNoteVo);
							updateCo++;
							laborUpdateCo++;
						}
						else
						{
							fundingCntcMapper.addCboPaLaborNoteV(laborNoteVo);
							insertCo++;
							laborInsCo++;
						}
					}

				}
				//연구비정보
				List<CboPaBudgetNoteVo> budgeList = erpFundingMapper.findCboPaBudgetNoteVByLastHarvestDate(lastSyncDate);
				if(budgeList != null && budgeList.size() > 0)
				{
					trgtCo += budgeList.size();
					budgetCo = budgeList.size();
					for(CboPaBudgetNoteVo budgetNoteVo : budgeList )
					{
						List<CboPaBudgetNoteVo> checkBudgetNote = fundingCntcMapper.findBudgetNoteVByContractId(budgetNoteVo);

						if(checkBudgetNote != null && checkBudgetNote.size() > 0)
						{
							fundingCntcMapper.updateCboPaBudgetNoteV(budgetNoteVo);
							updateCo++;
							budgetUpdateCo++;
						}
						else
						{
							fundingCntcMapper.addCboPaBudgetNoteV(budgetNoteVo);
							insertCo++;
							budgetInsCo++;
						}
					}
				}

				// Finish 처리
				logVo.setTrgtCo(trgtCo);
				logVo.setInsertCo(insertCo);
				logVo.setUpdateCo(updateCo);
				logVo.setSyncEnd(new Date());
				rm.append("o 총괄과제(").append(mstCo).append("건):").append("Insert-").append(mstInsCo).append("건,Update-").append(mstUpdateCo).append("건 ")
				  .append("o 참여자(").append(laborCo).append("건):").append("Insert-").append(laborInsCo).append("건,Update-").append(laborUpdateCo).append("건 ")
				  .append("o 연구비(").append(budgetCo).append("건):").append("Insert-").append(budgetInsCo).append("건,Update-").append(budgetUpdateCo).append("건");
				logVo.setSyncRm(rm.toString());
				syncLogMapper.update(logVo);

			} else {
				logVo.setTrgtCo(trgtCo);
				logVo.setInsertCo(insertCo);
				logVo.setUpdateCo(updateCo);
				logVo.setSyncRm("Error >>> search date : " + stdrDate);
				syncLogMapper.update(logVo);
			}

		} catch (Exception e) {
			//e.printStackTrace();
			// update ri_sync_log error
			logVo.setTrgtCo(trgtCo);
			logVo.setInsertCo(insertCo);
			logVo.setUpdateCo(updateCo);
			logVo.setSyncRm("Error >>> " + StringUtils.substringBefore(e.toString(), ":"));
			syncLogMapper.update(logVo);
		}

		// 2) Task과제 Sync
		trgtCo = 0;
		insertCo = 0;
		updateCo = 0;

		mstCo = 0;
		mstInsCo = 0;
		mstUpdateCo = 0;

		laborCo = 0;
		laborInsCo = 0;
		laborUpdateCo = 0;

		budgetCo = 0;
		budgetInsCo = 0;
		budgetUpdateCo = 0;

		lastSyncDate = null;

		if (stdrDate != null && !"".equals(stdrDate)) {
			lastSyncDate =stdrDate.replace("-","");
		} else {
			lastSyncDate = syncLogMapper.findLastHarvestDateBySyncTarget(R2Constant.SYSCNTC_SYNC_TARGET_TASK_FUNDING);
			if (lastSyncDate == null) {
				SimpleDateFormat sdf=new SimpleDateFormat("yyyyMMdd");
				Date nowDate = new Date();
				lastSyncDate = sdf.format(nowDate);
			}
		}

		logVo = new SyncLogVo();
		logVo.setSyncTarget(R2Constant.SYSCNTC_SYNC_TARGET_TASK_FUNDING);
		logVo.setSyncType(syncType);
		logVo.setStdrDate(lastSyncDate);
		logVo.setRegUserId(regUserId);
		seqNo = syncLogMapper.add(logVo);

		log.debug("Task Funding Sync log seq_no >>>>>> {}", seqNo);

		try {


			if (lastSyncDate != null) {
				//과제정보
				List<CboPaTaskConMstNoteVo> taskConMstList = erpFundingMapper.findCboPaTaskConMstNoteVByLastHarvestDate(lastSyncDate);
				if(taskConMstList != null && taskConMstList.size() > 0)
				{
					trgtCo += taskConMstList.size();
					mstCo = taskConMstList.size();

					for(CboPaTaskConMstNoteVo taskConMstNoteVo : taskConMstList )
					{
						List<CboPaTaskConMstNoteVo> checkTaskConMstNote = fundingCntcMapper.findTaskConMstNoteVByTaskId(taskConMstNoteVo);

						if(checkTaskConMstNote != null && checkTaskConMstNote.size() > 0)
						{
							fundingCntcMapper.updateCboPaTaskConMstNoteV(taskConMstNoteVo);
							updateCo++;
							mstUpdateCo++;
						}
						else
						{
							fundingCntcMapper.addCboPaTaskConMstNoteV(taskConMstNoteVo);
							insertCo++;
							mstInsCo++;
						}

					}
				}
				//참여자정보
				List<CboPaTaskLaborNoteVo> taskLaborList = erpFundingMapper.findCboPaTaskLaborNoteVByLastHarvestDate(lastSyncDate);
				if(taskConMstList != null && taskConMstList.size() > 0)
				{
					trgtCo += taskLaborList.size();
					laborCo = taskLaborList.size();
					for(CboPaTaskLaborNoteVo taskLaborNoteVo : taskLaborList )
					{
						List<CboPaTaskLaborNoteVo> checkTaskLaborNote = fundingCntcMapper.findTaskLaborNoteVByHeaderId(taskLaborNoteVo);

						if(checkTaskLaborNote != null && checkTaskLaborNote.size() > 0)
						{
							fundingCntcMapper.updateCboPaTaskLaborNoteV(taskLaborNoteVo);
							updateCo++;
							laborUpdateCo++;
						}
						else
						{
							fundingCntcMapper.addCboPaTaskLaborNoteV(taskLaborNoteVo);
							insertCo++;
							laborInsCo++;
						}
					}
				}
				//연구비정보
				List<CboPaTaskBudgetNoteVo> taskBudgetList = erpFundingMapper.findCboPaTaskBudgetNoteVByLastHarvestDate(lastSyncDate);
				if(taskBudgetList != null && taskBudgetList.size() > 0)
				{
					trgtCo += taskBudgetList.size();
					budgetCo = taskBudgetList.size();

					for(CboPaTaskBudgetNoteVo taskBudgetNoteVo  : taskBudgetList )
					{
						List<CboPaTaskBudgetNoteVo> checkTaskBudgetNote = fundingCntcMapper.findTaskBudgetNoteVByTaskId(taskBudgetNoteVo);

						if(checkTaskBudgetNote != null && checkTaskBudgetNote.size() > 0)
						{
							fundingCntcMapper.updateCboPaTaskBudgetNoteV(taskBudgetNoteVo);
							updateCo++;
							budgetUpdateCo++;
						}
						else
						{
							fundingCntcMapper.addCboPaTaskBudgetNoteV(taskBudgetNoteVo);
							insertCo++;
							budgetInsCo++;
						}
					}
				}

				// Task Budget 수정날짜 변경되지 않음에 따른 추가 로직임 (2017. 1. 11. by hojin)
				List<String> trgetTaskIdList = fundingCntcMapper.findTaskIdByProjectNameIsNull();
				if(trgetTaskIdList != null && trgetTaskIdList.size() > 0)
				{
					for(String taskId : trgetTaskIdList)
					{
						CboPaTaskBudgetNoteVo taskBudget = erpFundingMapper.findCboPaTaskBudgetNoteVByTaskId(taskId);

						if(taskBudget != null && taskId.equals(taskBudget.getTaskId()))
						{
							trgtCo++;
							budgetCo++;
							List<CboPaTaskBudgetNoteVo> checkTaskBudget = fundingCntcMapper.findTaskBudgetNoteVByTaskId(taskBudget);
							if(checkTaskBudget != null && checkTaskBudget.size() > 0)
							{
								fundingCntcMapper.updateCboPaTaskBudgetNoteV(taskBudget);
								updateCo++;
								budgetUpdateCo++;
							}
							else
							{
								fundingCntcMapper.addCboPaTaskBudgetNoteV(taskBudget);
								insertCo++;
								budgetInsCo++;
							}
						}
					}
				}

				logVo.setTrgtCo(trgtCo);
				logVo.setInsertCo(insertCo);
				logVo.setUpdateCo(updateCo);
				logVo.setSyncEnd(new Date());
				rm = new StringBuffer();
				rm.append("o TASK과제(").append(mstCo).append("건):").append("Insert-").append(mstInsCo).append("건,Update-").append(mstUpdateCo).append("건 ")
				  .append("o 참여자(").append(laborCo).append("건):").append("Insert-").append(laborInsCo).append("건,Update-").append(laborUpdateCo).append("건 ")
				  .append("o 연구비(").append(budgetCo).append("건):").append("Insert-").append(budgetInsCo).append("건,Update-").append(budgetUpdateCo).append("건");
				logVo.setSyncRm(rm.toString());
				syncLogMapper.update(logVo);

			} else {
				logVo.setTrgtCo(trgtCo);
				logVo.setInsertCo(insertCo);
				logVo.setUpdateCo(updateCo);
				logVo.setSyncRm("Error >>> search date : " + stdrDate);
				syncLogMapper.update(logVo);
			}

		} catch (Exception e) {
			// update ri_sync_log error
			logVo.setTrgtCo(trgtCo);
			logVo.setInsertCo(insertCo);
			logVo.setUpdateCo(updateCo);
			logVo.setSyncRm("Error >>> " + StringUtils.substringBefore(e.toString(), ":"));
			syncLogMapper.update(logVo);
		}
	}

}
