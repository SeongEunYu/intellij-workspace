package kr.co.argonet.r2rims.sysCntc.syncrslt.module;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import kr.co.argonet.r2rims.constant.R2Constant;
import kr.co.argonet.r2rims.core.vo.CareerVo;
import kr.co.argonet.r2rims.core.vo.SyncLogVo;
import kr.co.argonet.r2rims.erp.mapper.ErpCareerMapper;

public class SyncCareerService extends SyncCareer {

	Logger log = LoggerFactory.getLogger(SyncCareerService.class);

	private SqlSession erpSqlSession;
	private ErpCareerMapper erpCareerMapper;

	public void sync() {
		//get mapper
		erpSqlSession = (SqlSession)context.getBean("erpSqlSession");
		erpCareerMapper = erpSqlSession.getMapper(ErpCareerMapper.class);
		//count
		Integer trgtCo = 0;
		Integer insertCo = 0;
		Integer updateCo = 0;

		String lastSyncDate = null;
		if(stdrDate != null && !"".equals(stdrDate))
		{
			lastSyncDate = stdrDate.replace("-","");
		}
		else
		{
			// 3) get last sync date from RI_SYNC_LOG
			lastSyncDate = syncLogMapper.findLastHarvestDateBySyncTarget(R2Constant.SYSCNTC_SYNC_TARGET_CAREER);
			if (lastSyncDate == null) {
				SimpleDateFormat sdf=new SimpleDateFormat("yyyyMMdd");
				Date nowDate = new Date();
				lastSyncDate = sdf.format(nowDate);
			}
		}

		// 1) init log data
		SyncLogVo logVo = new SyncLogVo();
		logVo.setSyncTarget(R2Constant.SYSCNTC_SYNC_TARGET_CAREER);
		logVo.setSyncType(syncType);
		logVo.setStdrDate(lastSyncDate);
		logVo.setRegUserId(regUserId);
		syncLogMapper.add(logVo);

		try {
			// 4) find target data from PERSON_UID table of erp system
			if(lastSyncDate != null)
			{
				List<CareerVo> erpCareerList = erpCareerMapper.findByModDate(lastSyncDate);
				trgtCo = erpCareerList.size();

				for(CareerVo career : erpCareerList)
				{
					List<CareerVo> chkCareerList = careerMapper.findByUserIdAndSrcId(career);

					if(chkCareerList != null && chkCareerList.size() > 0)
					{
						career.setCareerId(chkCareerList.get(0).getCareerId());
						careerMapper.update(career);
						updateCo++;
					}
					else
					{
						careerMapper.add(career);
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
