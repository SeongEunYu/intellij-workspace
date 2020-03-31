package kr.co.argonet.r2rims.rss.main;


import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import kr.co.argonet.r2rims.analysis.utils.CacheUtils;
import kr.co.argonet.r2rims.constant.R2Constant;
import kr.co.argonet.r2rims.core.code.CodeConfiguration;
import kr.co.argonet.r2rims.core.index.IndexService;
import kr.co.argonet.r2rims.core.main.MainService;
import kr.co.argonet.r2rims.core.service.LogService;
import kr.co.argonet.r2rims.core.vo.*;
import kr.co.argonet.r2rims.rss.account.RssLoginService;
import kr.co.argonet.r2rims.rss.utils.RssChartUtils;
import kr.co.argonet.r2rims.rss.vo.RssBbsVo;
import kr.co.argonet.r2rims.share.*;
import net.sf.json.JSONArray;
import org.apache.commons.lang3.StringUtils;
import org.apache.solr.client.solrj.SolrServerException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.*;

/**
 * <pre>
 *  kr.co.argonet.r2rims.rss.main
 *      ┗ RssWidgetController.java
 *
 * RSS widget 컨트롤러 클래스
 *
 * </pre>
 * @date 2020. 03. 25.
 * @version
 * @author : woosik
 */

@Controller(value="rssWidgetController")
public class RssWidgetController {

	Logger log = LoggerFactory.getLogger(RssWidgetController.class);

	@Resource(name="shareUserService")
	private ShareUserService userService;
    @Resource(name="rssMainService")
    private RssMainService rssMainService;

	// My Research Output 컨텐츠
	@RequestMapping(value = "/widget/myResearchOutput")
	public @ResponseBody
	Map<String,Object> myResearchOutput(HttpServletRequest req, @RequestParam("tabId") String tabId, ModelMap model) {

		UserVo sessUser = (UserVo) req.getSession().getAttribute(R2Constant.SESSION_USER);
		String userId = sessUser.getUserId();

		RimsSearchVo rimsSearchVo = new RimsSearchVo();
		int totalContent; //총 컨텐츠 갯수
		int ps = 1;
		int ct = 5; 	 // 페이지당 row수
		Map<String, Integer> pageCount = new HashMap<>();

		ps = (ps-1)*ct; // 페이지 시작부분 index

		rimsSearchVo.setUserId(userId);
		rimsSearchVo.setPs(ps);
		rimsSearchVo.setCt(ct);
		rimsSearchVo.setText("date");
		rimsSearchVo.setType("desc");

		Map<String,Object> resultMap = null;
		Map<String,Object> contentPagemap = new HashMap<>();

		// 성과 리스트 및 성과 총개수
		try {
			resultMap = userService.findContents(tabId, rimsSearchVo);
		} catch (IOException e) {
			e.printStackTrace();
		} catch (SolrServerException e) {
			e.printStackTrace();
		}

		contentPagemap.put("content",resultMap.get("contentList"));

		return contentPagemap;
	}

	// 연구성과 분석 논문수
	@RequestMapping("/widget/getArticleAjax")
	public @ResponseBody Map<String, Object> getArticleAjax(HttpServletRequest req){
		UserVo sessionUser = (UserVo)req.getSession().getAttribute(R2Constant.SESSION_USER);
		String userId = sessionUser.getUserId();
		List<Map<String, Object>> data = rssMainService.staticsArticleByUser(userId);

		Map<String, Object> result = new HashMap<>();
		result.put("statics", data);

		return result;
	}

    // 연구성과 분석 논문수
	@RequestMapping("/widget/getCitedAjax")
	public @ResponseBody Map<String,Object> getCitedAjax(HttpServletRequest req){
		RimsSearchVo searchVo = new RimsSearchVo();

		UserVo sessionUser = (UserVo)req.getSession().getAttribute(R2Constant.SESSION_USER);
		searchVo.setSrchUId(sessionUser.getuId());

//		String uri = req.getRequestURI();
//		uri = uri.substring(uri.indexOf("/"), uri.lastIndexOf("/"));
//		String topNm = uri.substring(uri.lastIndexOf("/")+1);
		searchVo.setTopNm("researcher");
		searchVo.setGroupKey("");
		searchVo.setGroupKey2("pubYear");
		searchVo.setGubun("");
		searchVo.setTpiDispDvsCd("");

		if( searchVo.getPosiNm() != null && !searchVo.getPosiNm().isEmpty())searchVo.setPosiList(Arrays.asList(searchVo.getPosiNm().split(",")));
		searchVo.setPosiNm("");

		UserVo userVo = rssMainService.findUserById2(sessionUser.getUserId());
		searchVo.setUserId(userVo.getUserId());

		String fromYear = userVo.getFromYm();
		String toYear = userVo.getToYm();

		if(fromYear.length() > 4)
			fromYear = fromYear.substring(0,4);
		if(toYear.length() > 4)
			toYear = toYear.substring(0,4);

		if(!fromYear.equals(""))
			searchVo.setFromYear(fromYear);
		if(!toYear.equals(""))
			searchVo.setToYear(toYear);

		List<AnalysisVo> yearAllList = rssMainService.findPublicationGroup(searchVo);

		List<Map<String, Object>> staticsMap = new ArrayList<>();
		Map<String, Object> resultMap = new HashMap<>();

		for(AnalysisVo analysis : yearAllList){
			if(analysis.getPubYear() != null){
				Map<String, Object> map = new HashMap<>();
				map.put("year", analysis.getPubYear());
				map.put("wos", analysis.getWosCitedSum());
				map.put("scp", analysis.getScpCitedSum());
				map.put("kci", analysis.getKciCitedSum());
				staticsMap.add(map);
			} else {
				continue;
			}
		}

		resultMap.put("statics", staticsMap);

		return resultMap;
	}

	@RequestMapping("/widget/hindexAjax")
	public @ResponseBody Map<String,Object> hindexAjax(
			@ModelAttribute RimsSearchVo searchVo,
			HttpServletRequest req
	){
		UserVo sessionUser = (UserVo)req.getSession().getAttribute(R2Constant.SESSION_USER);
		searchVo.setSrchUId(sessionUser.getuId());
		searchVo.setUserId(sessionUser.getuId());
		searchVo.setTopNm("researcher");
		searchVo.setGubun("");

		Map<String,Object> resultMap = new HashMap<>();
		List<Map<String, Object>> hindexList = new ArrayList<>();

		List<AnalysisVo> citations =  rssMainService.findArticleCitationByUserId(searchVo);
		List<ArticleVo> articleList = rssMainService.findArticleListByUserId(searchVo);

		for (AnalysisVo analysis : citations) {
			Map<String, Object> map = new HashMap<>();
			map.put("citation", analysis.getTc());
			int articleCount = 0;
			for (ArticleVo article : articleList) {
				if(article.getTc() == null)
					article.setTc(0);
				if(article.getTc() >= analysis.getTc()){
					articleCount++;
				}
			}
			map.put("article", articleCount);
			articleCount = 0;

			hindexList.add(map);
		}

		int hindex = CacheUtils.calHIndex(citations);
		resultMap.put("hindex", hindex);
		resultMap.put("hindexList", hindexList);

		return resultMap;
	}
}