package kr.co.argonet.r2rims.sysCntc.blncUpdate.module;

import kr.co.argonet.r2rims.core.mapper.ArticlePartiMapper;
import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.ContextLoaderListener;


/**
 * <pre>
 * Article Parti 업데이트 모듈
 * </pre>
 * @date 2019. 03. 29.
 * @version
 * @author : woo
 */
public class ArticlePartiBlncAgcNmUpdate {

	Logger log = LoggerFactory.getLogger(ArticlePartiBlncAgcNmUpdate.class);

	//mapper
	private SqlSession sqlSession;
	private ArticlePartiMapper articlePartiMapper;

	public ArticlePartiBlncAgcNmUpdate() {
		initVariable();
	}

	private void initVariable(){
		ApplicationContext context = ContextLoaderListener.getCurrentWebApplicationContext();
		sqlSession =  (SqlSession) context.getBean("sqlSession");
		articlePartiMapper = sqlSession.getMapper(ArticlePartiMapper.class);
	}

	public void updateArticlePartiBlngAgcNm(){
		articlePartiMapper.updateArticlePartiBlngAgcNm();
		log.info("ArticleParti blngAgcNm updateAll Finish >>>>> \n" );
	}
}
