package kr.co.argonet.r2rims.sysCntc.blncUpdate;

import kr.co.argonet.r2rims.sysCntc.blncUpdate.module.ArticlePartiBlncAgcNmUpdateThread;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

/**
 * <pre>
 * Rawdata 업데이트 관리를 위한 스케줄 클래스
 * </pre>
 * @date 2019. 03. 29.
 * @version
 * @author : woo
 */
@Service
public class BlncAgcNmScheduleUpdate {

	Logger log = LoggerFactory.getLogger(BlncAgcNmScheduleUpdate.class);

	@Value("#{sysConf['cron.articleParti.blncAgcNm.update.at']}")
	private String articlePartiBlncAgcNmUpdateAt;

	@Scheduled(cron="${cron.articleParti.blncAgcNm.update}")
	public void articlePartiBlncAgcNmScheduleUpdate(){

		if(articlePartiBlncAgcNmUpdateAt != null && "Y".equals(articlePartiBlncAgcNmUpdateAt))
		{
			log.info("Start ArticleParti BlncAgcNm Schedule Update ~ ");
			ArticlePartiBlncAgcNmUpdateThread articlePartiBlncAgcNmUpdateThread = new ArticlePartiBlncAgcNmUpdateThread();
			Thread t = new Thread(articlePartiBlncAgcNmUpdateThread);
			t.start();
			log.info("Finish ArticleParti BlncAgcNm Schedule Update ~ ");
		}
		else
		{
			log.info("Not Configure ArticleParti BlncAgcNm Update Schedule (cron.articleParti.blncAgcNm.update.at) ~ ");
		}
	}
}
