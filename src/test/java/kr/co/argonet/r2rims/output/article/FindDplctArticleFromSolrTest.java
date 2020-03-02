package kr.co.argonet.r2rims.output.article;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.solr.client.solrj.SolrClient;
import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.impl.HttpSolrClient;
import org.apache.solr.client.solrj.response.QueryResponse;
import org.apache.solr.common.SolrDocument;
import org.junit.Test;

import kr.co.argonet.r2rims.AbstractApplicationContextTest;
import kr.co.argonet.r2rims.core.vo.ArticleVo;

public class FindDplctArticleFromSolrTest extends AbstractApplicationContextTest {

	@Test
	public void findArticleFromLocalSolrServer() throws Exception{
		SolrClient solrServer = new HttpSolrClient("http://localhost:8983/solr/collection1/");
		SolrQuery query = new SolrQuery();
		query.setRequestHandler("/select");

		//String keyword = "\"*:memory\" OR \"*:processor\" OR \"*:Hierarchy\"";
		String keyword = "PARALLEL";
		//keyword = keyword.replace(" ", " OR ");
		System.out.println(keyword);
		query.set("q", keyword);
		//query.set("fq", "PBLC_Y:2015");
		//query.set("q", "alpha amplitude and phase locking in obsessive-compulsive disorder during working memory");
		query.set("defType", "arirang");
		query.set("qf", "QTITLE^4.0 QAUTHOR QJOURNAL QKEYWORD^2.0");
		query.set("qf.2", "QAUTHOR QKEYWORD^2.0");
		// 검색어가 두개 이상일 때 검색어 전체를 하나의 필드에 적용하여
		/*
		// 검색어가 두개 이상의 단어일 경우 구문 검색으로 더 높은 점수를
		query.set("pf", "QTITLE^5.0 QKEYWORD^3.0");
		// 검색어가 텍스트의 첫번째 위치에 있을 경우 더 높은 점수를
		query.set("p.boostFirst", "QTITLE^3.0 QJOURNAL");
		// 토큰의 개수에 따라. 그러니까 더 짧은 텍스트가 더 높은 점수를
		query.set("p.boostNorm", "QTITLE^3.0");
		 */
		// 페이징
		query.setStart(0);
		query.setRows(30);
		System.out.println(getData(solrServer.query(query)));
	}

	private List<ArticleVo> getData(QueryResponse result) {
		// 하이라이트는 아래 doc과는 따로 저장됨
		Map<String, Map<String, List<String>>> highlighting = result.getHighlighting();
		List<ArticleVo> list = new ArrayList<ArticleVo>();
		for (SolrDocument doc : result.getResults()) {
			// doc별 하이라이트. KEY 필드(여기서는 ID)로 가져오기
			Map<String, List<String>> highlight = highlighting.get(doc.get("ID"));
			// 필드별 하이라이트. 필드별로도 N개의 하이라이트가 가능하나 현재는 하나만 반환.
			List<String> highlightedTitles = highlight.get("TITLE");
			// 하이라이트가 없을 수 있으며 그때는 원본값을 사용
			String title = highlightedTitles != null ? highlightedTitles.get(0) : (String)doc.get("TITLE");
			// 하이라이트는 다른 필드도 위와 같은 방법으로가져올 수 있고, 현재 설정된 필드는
			System.out.println("TITLE: " + title);
			System.out.println("\tAUTHOR: " + doc.get("AUTHOR"));
			System.out.println("\tJOURNAL: " + doc.get("JOURNAL"));
			System.out.println("\tKEYWORD: " + doc.get("KEYWORD"));
			System.out.println("\tPBLC_YM: " + doc.get("PBLC_YM"));

			ArticleVo article = new ArticleVo();
			article.setArticleId(Integer.parseInt(doc.get("ARTICLE_ID").toString()));
			article.setOrgLangPprNm(title);
			if(doc.get("JOURNAL") != null) article.setScjnlDvsNm(doc.get("JOURNAL").toString());
			if(doc.get("VOLUME") != null) article.setVolume(doc.get("VOLUME").toString());
			if(doc.get("ISSUE") != null) article.setIssue(doc.get("ISSUE").toString());
			if(doc.get("STT_PAGE") != null) article.setSttPage(doc.get("STT_PAGE").toString());
			list.add(article);
		}
		return list;
	}

}
