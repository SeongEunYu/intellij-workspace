package kr.co.argonet.r2rims.analysis.rawdata;

import kr.co.argonet.r2rims.analysis.rawdata.module.RawdataUpdateThread;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

/**
 * <pre>
 * Rawdata 업데이트 관리를 위한 스케줄 클래스
 * </pre>
 * @date 2018. 08. 08.
 * @version
 * @author : woo
 */
@Service
public class RawdataScheduleUpdate {

	Logger log = LoggerFactory.getLogger(RawdataScheduleUpdate.class);

	@Value("#{sysConf['cron.rawdata.update.at']}")
	private String rawdataUpdateAt;

	@Scheduled(cron="${cron.rawdata.update}")
	public void rawdataScheduleUpdate(){

		if(rawdataUpdateAt != null && "Y".equals(rawdataUpdateAt))
		{
			log.info("Start Rawdata Schedule Update ~ ");
			RawdataUpdateThread rawdataUpdateThread = new RawdataUpdateThread();
			Thread t = new Thread(rawdataUpdateThread);
			t.start();
			log.info("Finish Rawdata Schedule Update ~ ");
		}
		else
		{
			log.info("Not Configure Rawdata Update Schedule (cron.tc.update.rawdata.at) ~ ");
		}
	}
}
