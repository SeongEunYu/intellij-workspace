package kr.co.argonet.r2rims.sysCntc.syncrslt.module;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import kr.co.argonet.r2rims.constant.R2Constant;
import kr.co.argonet.r2rims.core.vo.ActivityVo;
import kr.co.argonet.r2rims.core.vo.SyncLogVo;
import kr.co.argonet.r2rims.core.vo.UserVo;
import kr.co.argonet.r2rims.erp.mapper.ErpActivityMapper;

public class SyncActivityService extends SyncActivity {

	Logger log = LoggerFactory.getLogger(SyncActivityService.class);

	public void sync() {
		SqlSession erpSqlSession =  (SqlSession) context.getBean("erpSqlSession");
		ErpActivityMapper erpActivityMapper = erpSqlSession.getMapper(ErpActivityMapper.class);

		int trgtCo = 0;
		int insertCo = 0;
		int updateCo = 0;

		String lastSyncDate = null;
		if (stdrDate != null && !"".equals(stdrDate)) {
			lastSyncDate =stdrDate.replace("-", "");
		} else {
			lastSyncDate = syncLogMapper.findLastHarvestDateBySyncTarget(R2Constant.SYSCNTC_SYNC_TARGET_ACTIVITY);
			if (lastSyncDate == null) {
				SimpleDateFormat sdf=new SimpleDateFormat("yyyyMMdd");
				Date nowDate = new Date();
				lastSyncDate = sdf.format(nowDate);
			}
		}

		SyncLogVo logVo = new SyncLogVo();
		logVo.setSyncTarget(R2Constant.SYSCNTC_SYNC_TARGET_ACTIVITY);
		logVo.setSyncType(syncType);
		logVo.setStdrDate(lastSyncDate);
		logVo.setRegUserId(regUserId);
		int seqNo = syncLogMapper.add(logVo);

		log.debug("Activity Sync log seq_no >>>>>> {}", seqNo);
		try {
			// 4) find target data from PERSON_UID table of erp system
			if (lastSyncDate != null) {
				List<ActivityVo> erpActivityList = erpActivityMapper.findByModDate(lastSyncDate);
				trgtCo = erpActivityList.size();
				for (ActivityVo activity : erpActivityList) {
					UserVo userVo = userMapper.findSimpleByUserId(activity.getUserId());
					if (userVo == null) continue;

					List<ActivityVo> chkActivityList = activityMapper.findByUserIdAndSrcId(activity);

					if (chkActivityList != null && chkActivityList.size() > 0) {
						activity.setModUserId("system");
						activity.setActivityId(chkActivityList.get(0).getActivityId());
						activityMapper.update(activity);
						updateCo++;
					} else {
						activity.setModUserId("system");
						activity.setRegUserId("system");
						activityMapper.add(activity);
						insertCo++;
					}
				}
				logVo.setTrgtCo(trgtCo);
				logVo.setInsertCo(insertCo);
				logVo.setUpdateCo(updateCo);
				logVo.setSyncEnd(new Date());
				logVo.setSyncRm("Success!");
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
