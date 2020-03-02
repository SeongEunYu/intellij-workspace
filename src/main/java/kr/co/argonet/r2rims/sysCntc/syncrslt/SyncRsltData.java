package kr.co.argonet.r2rims.sysCntc.syncrslt;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import kr.co.argonet.r2rims.constant.R2Constant;
import kr.co.argonet.r2rims.sysCntc.syncrslt.module.SyncData;
import kr.co.argonet.r2rims.sysCntc.syncrslt.module.SyncUserThread;

import java.text.SimpleDateFormat;
import java.util.Calendar;

@Service
public class SyncRsltData {

	Logger log = LoggerFactory.getLogger(SyncRsltData.class);

	@Resource(name="syncUser")
	private SyncData syncUser;
	@Resource(name="syncFunding")
	private SyncData syncFunding;

	@Value("#{sysConf['cron.sync.user.at']}")
	private String cronUserAt;
	@Value("#{sysConf['cron.sync.funding.at']}")
	private String cronFundingAt;
	@Value("#{sysConf['cron.sync.funding.byDate.at']}")
	private String cronFundingByDateAt;

	@Scheduled(cron="${cron.sync.user}")
	public void erpUserDataScheduleSync(){

		if(cronUserAt != null && "Y".equals(cronUserAt))
		{
			log.info("Start User Data Schedule Sync ~ ");
			syncUser.setEnv(R2Constant.SYSCNTC_SYNC_TYPE_SCHEDULE, "system");
			Runnable runnable = new SyncUserThread(syncUser);
			Thread thread = new Thread(runnable);
			thread.start();
			log.info("End User Data Schedule Sync ~ ");
		}
		else
		{
			log.info("Not Configure User Data Schedule ~ ");
		}

	}

	@Scheduled(cron="${cron.sync.funding}")
	public void erpFundingDataScheduleSync(){
		if(cronFundingAt != null && "Y".equals(cronFundingAt))
		{
			log.info("Start Funding Data Schedule Sync ~ ");
			syncFunding.setEnv(R2Constant.SYSCNTC_SYNC_TYPE_SCHEDULE, "system");
			Runnable runnable = new SyncUserThread(syncFunding);
			Thread thread = new Thread(runnable);
			thread.start();
			log.info("End Funding Data Schedule Sync ~ ");
		}
		else
		{
			log.info("Not Configure Funding Data Schedule ~ ");
		}
	}

	@Scheduled(cron="${cron.sync.funding.byDate}")
	public void erpFundingDataScheduleSyncByDate(){
		if(cronFundingByDateAt != null && "Y".equals(cronFundingByDateAt))
		{
			log.info("Start Funding Data Schedule Sync ~ ");

			Calendar cal = Calendar.getInstance();
			cal.add(cal.MONTH,-6);		//6개월 전
			SimpleDateFormat sdf=new SimpleDateFormat("yyyyMMdd");
			String stdrDate = sdf.format(cal.getTime());

			syncFunding.setEnv(R2Constant.SYSCNTC_SYNC_TYPE_SCHEDULE, "system", stdrDate);
			Runnable runnable = new SyncUserThread(syncFunding);
			Thread thread = new Thread(runnable);
			thread.start();
			log.info("End Funding Data Schedule Sync ~ ");
		}
		else
		{
			log.info("Not Configure Funding Data Schedule ~ ");
		}
	}


}
