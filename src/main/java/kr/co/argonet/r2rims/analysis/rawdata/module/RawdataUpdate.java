package kr.co.argonet.r2rims.analysis.rawdata.module;

import kr.co.argonet.r2rims.core.mapper.*;
import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.ContextLoaderListener;

import java.util.Properties;


/**
 * <pre>
 * Rawdata 업데이트 모듈
 * </pre>
 * @date 2018. 08. 08.
 * @version
 * @author : woo
 */
public class RawdataUpdate {

	Logger log = LoggerFactory.getLogger(RawdataUpdate.class);

	//mapper
	private SqlSession sqlSession;
	private StatsArticleRawdataMapper statsArticleRawdataMapper;
	private StatsConferenceRawdataMapper statsConferenceRawdataMapper;
	private StatsFundingRawdataMapper statsFundingRawdataMapper;
	private StatsPatentRawdataMapper statsPatentRawdataMapper;
	private ExportUserStatsMapper exportUserStatsMapper;
	//env
	private Properties sysConf;

	public RawdataUpdate() {
		initVariable();
	}

	private void initVariable(){
		ApplicationContext context = ContextLoaderListener.getCurrentWebApplicationContext();
		sqlSession =  (SqlSession) context.getBean("sqlSession");
		statsArticleRawdataMapper = sqlSession.getMapper(StatsArticleRawdataMapper.class);
		statsConferenceRawdataMapper = sqlSession.getMapper(StatsConferenceRawdataMapper.class);
		statsFundingRawdataMapper = sqlSession.getMapper(StatsFundingRawdataMapper.class);
		statsPatentRawdataMapper = sqlSession.getMapper(StatsPatentRawdataMapper.class);
		exportUserStatsMapper = sqlSession.getMapper(ExportUserStatsMapper.class);
	}

	public void rawdataUpdate(){
		statsArticleRawdataMapper.deleteAll();
		statsConferenceRawdataMapper.deleteAll();
		statsFundingRawdataMapper.deleteAll();
		statsPatentRawdataMapper.deleteAll();
		log.info("Rawdata deleteAll Finish >>>>> \n" );

		statsArticleRawdataMapper.addAll();
		statsConferenceRawdataMapper.addAll();
		statsFundingRawdataMapper.addAll();
		statsPatentRawdataMapper.addAll();
		log.info("Rawdata addAll Finish >>>>> \n" );

		exportUserStatsMapper.deleteAll();
		log.info("exportUserStats deleteAll Finish >>>>> \n" );

		exportUserStatsMapper.addAll();
		log.info("exportUserStats addAll Finish >>>>> \n" );
	}
}
