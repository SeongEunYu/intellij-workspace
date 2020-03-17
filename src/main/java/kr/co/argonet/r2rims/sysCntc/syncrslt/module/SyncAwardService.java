package kr.co.argonet.r2rims.sysCntc.syncrslt.module;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import kr.co.argonet.r2rims.constant.R2Constant;
import kr.co.argonet.r2rims.core.vo.AwardVo;
import kr.co.argonet.r2rims.core.vo.SyncLogVo;
import kr.co.argonet.r2rims.erp.mapper.ErpAwardMapper;

public class SyncAwardService extends SyncAward {

	Logger log = LoggerFactory.getLogger(SyncAwardService.class);

	private SqlSession erpSqlSession;
	private ErpAwardMapper erpAwardMapper;

	public void sync() {
		//get mapper
		erpSqlSession = (SqlSession)context.getBean("erpSqlSession");
		erpAwardMapper = erpSqlSession.getMapper(ErpAwardMapper.class);
		//count
		Integer trgtCo = 0;
		Integer insertCo = 0;
		Integer updateCo = 0;
		// 1) init log data

		String lastSyncDate = null;
		if(stdrDate != null && !"".equals(stdrDate))
		{
			lastSyncDate = stdrDate.replace("-","");
		}
		else
		{
			// 3) get last sync date from RI_SYNC_LOG
			lastSyncDate = syncLogMapper.findLastHarvestDateBySyncTarget(R2Constant.SYSCNTC_SYNC_TARGET_AWARD);
			if (lastSyncDate == null) {
				SimpleDateFormat sdf=new SimpleDateFormat("yyyyMMdd");
				Date nowDate = new Date();
				lastSyncDate = sdf.format(nowDate);
			}
		}

		SyncLogVo logVo = new SyncLogVo();
		logVo.setSyncTarget(R2Constant.SYSCNTC_SYNC_TARGET_AWARD);
		logVo.setSyncType(syncType);
		logVo.setStdrDate(lastSyncDate);
		logVo.setRegUserId(regUserId);
		syncLogMapper.add(logVo);

		log.debug("Award Sync log seq_no >>>>>> {}", logVo.getSeqNo());
		try {

			// 4) find target data from PERSON_UID table of erp system
			if(lastSyncDate != null)
			{
				List<AwardVo> erpAwardList = erpAwardMapper.findByModDate(lastSyncDate);
				trgtCo = erpAwardList.size();

				for(AwardVo award : erpAwardList)
				{
					List<AwardVo> chkAwardList = awardMapper.findByUserIdAndSrcId(award);

					if(chkAwardList != null && chkAwardList.size() > 0)
					{
						award.setAwardId(chkAwardList.get(0).getAwardId());
						awardMapper.update(award);
						updateCo++;
					}
					else
					{
						awardMapper.add(award);
						insertCo++;
					}
					awardMapper.updateBySelectOtherTable(award);
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
