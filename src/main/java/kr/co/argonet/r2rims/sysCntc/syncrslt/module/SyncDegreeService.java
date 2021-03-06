package kr.co.argonet.r2rims.sysCntc.syncrslt.module;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import kr.co.argonet.r2rims.constant.R2Constant;
import kr.co.argonet.r2rims.core.vo.CodeMapVo;
import kr.co.argonet.r2rims.core.vo.DegreeVo;
import kr.co.argonet.r2rims.core.vo.SyncLogVo;
import kr.co.argonet.r2rims.erp.mapper.ErpDegreeMapper;

public class SyncDegreeService extends SyncDegree {

	Logger log = LoggerFactory.getLogger(SyncDegreeService.class);

	private SqlSession erpSqlSession;
	private ErpDegreeMapper erpDegreeMapper;

	public void sync() {
		//get mapper
		erpSqlSession = (SqlSession)context.getBean("erpSqlSession");
		erpDegreeMapper = erpSqlSession.getMapper(ErpDegreeMapper.class);

		//count
		Integer trgtCo = 0;
		Integer insertCo = 0;
		Integer updateCo = 0;

		String lastSyncDate = null;
		if(stdrDate != null && !"".equals(stdrDate))
		{
			lastSyncDate =stdrDate.replace("-","");
		}
		else
		{
			// 3) get last sync date from RI_SYNC_LOG
			lastSyncDate = syncLogMapper.findLastHarvestDateBySyncTarget(R2Constant.SYSCNTC_SYNC_TARGET_DEGREE);
			if (lastSyncDate == null) {
				SimpleDateFormat sdf=new SimpleDateFormat("yyyyMMdd");
				Date nowDate = new Date();
				lastSyncDate = sdf.format(nowDate);
			}
		}

		// 1) init log data
		SyncLogVo logVo = new SyncLogVo();
		logVo.setSyncTarget(R2Constant.SYSCNTC_SYNC_TARGET_DEGREE);
		logVo.setSyncType(syncType);
		logVo.setStdrDate(lastSyncDate);
		logVo.setRegUserId(regUserId);
		syncLogMapper.add(logVo);

		try {
			// 4) find target data from PERSON_UID table of erp system
			if(lastSyncDate != null)
			{
				List<DegreeVo> erpDegreeList = erpDegreeMapper.findByModDate(lastSyncDate);
				trgtCo = erpDegreeList.size();

				for(DegreeVo degree : erpDegreeList)
				{
					List<CodeMapVo> nationCodeList = codeMapMapper.findCodeaByGubunbAndCodeb(degree.getNtntGubunB(), degree.getCountry());
					if(nationCodeList != null && nationCodeList.size() > 0)
						degree.setDgrAcqsNtnCd(nationCodeList.get(0).getCodea());

					String dgrAcqsAgcCd = comOrgAliasMapper.findOrgCodeByOrgNameJoinRiCode(degree.getDgrAcqsAgcNm());
					if(dgrAcqsAgcCd !=  null) degree.setDgrAcqsAgcCd(dgrAcqsAgcCd);

					List<DegreeVo> chkDegreeList = degreeMapper.findBySrcId(degree);

					if(chkDegreeList != null && chkDegreeList.size() > 0)
					{
						degree.setDegreeId(chkDegreeList.get(0).getDegreeId());
						degreeMapper.updateSync(degree);
						updateCo++;
					}
					else
					{
						degreeMapper.add(degree);
						insertCo++;
					}
				}

				logVo.setTrgtCo(trgtCo);
				logVo.setInsertCo(insertCo);
				logVo.setUpdateCo(updateCo);
				logVo.setSyncEnd(new Date());
				logVo.setSyncRm("Success!");
				syncLogMapper.update(logVo);

			}
			else
			{
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
			if(e != null && e.getMessage() != null && e.getMessage().length() > 900)
				logVo.setSyncRm("Error >>> " + e.getMessage().substring(0, 900));
			else if(e != null)
				logVo.setSyncRm("Error >>> " + e.getMessage());
			syncLogMapper.update(logVo);
		}
	}

}
