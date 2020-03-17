package kr.co.argonet.r2rims.sysCntc.blncUpdate.module;

/**
 * <pre>
 * ArticleParti BlngAgcNm 업데이트 관리를 위한 쓰레드클래스
 * </pre>
 * @date 2019. 03. 29.
 * @version
 * @author : woo
 */
public class ArticlePartiBlncAgcNmUpdateThread implements Runnable{

	@Override
	public void run() {
		articlePartiBlngAgcNmUpdate();
	}

	private void articlePartiBlngAgcNmUpdate (){
		ArticlePartiBlncAgcNmUpdate articlePartiBlncAgcNmUpdate = new ArticlePartiBlncAgcNmUpdate();
		articlePartiBlncAgcNmUpdate.updateArticlePartiBlngAgcNm();
	}
}
