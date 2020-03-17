package kr.co.argonet.r2rims.rss.main;


import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import kr.co.argonet.r2rims.analysis.utils.ChartUtils;
import kr.co.argonet.r2rims.constant.R2Constant;
import kr.co.argonet.r2rims.core.annotation.NoAuthCheck;
import kr.co.argonet.r2rims.core.annotation.NoInfoPrtcAgreCheck;
import kr.co.argonet.r2rims.core.annotation.NoLocaleSet;
import kr.co.argonet.r2rims.core.annotation.NoLoginCheck;
import kr.co.argonet.r2rims.core.code.CodeConfiguration;
import kr.co.argonet.r2rims.core.index.IndexService;
import kr.co.argonet.r2rims.core.main.MainService;
import kr.co.argonet.r2rims.core.service.LogService;
import kr.co.argonet.r2rims.core.util.LocaleUtil;
import kr.co.argonet.r2rims.core.util.SessionUtil;
import kr.co.argonet.r2rims.core.vo.*;
import kr.co.argonet.r2rims.rss.account.RssLoginService;
import kr.co.argonet.r2rims.share.*;
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
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;

/**
 * <pre>
 *  kr.co.argonet.r2rims.rss.main
 *      ┗ RssMainController.java
 *
 * RSS main 컨트롤러 클래스
 *
 * </pre>
 * @date 2017. 07. 13.
 * @version
 * @author : woosik
 */

@Controller(value="rssMainController")
public class RssMainController {

	Logger log = LoggerFactory.getLogger(RssMainController.class);

	@Resource(name="shareUserService")
	private ShareUserService userService;
	@Resource(name="shareArticleService")
	private ShareArticleService articleService;

	@Resource(name="shareConferenceService")
	private ShareConferenceService conferenceService;
	@Resource(name="shareFundingService")
	private ShareFundingService fundingService;
	@Resource(name="sharePatentService")
	private SharePatentService patentService;

	@Resource(name="indexService")
	private IndexService indexService;

	@Resource(name="logService")
	private LogService logService;

	@Value("#{sysConf['inst.name']}")
	private String instName;

	@Resource(name="mainService")
	private MainService mainService;

	@Resource(name="rssMainService")
	private RssMainService rssMainService;

	@Resource(name="rssLoginService")
	private RssLoginService rssLoginService;

	@Value("#{sysConf['main.top.notice.service.at']}")
	private String topNoticeAt;
	@Value("#{sysConf['main.maxCount']}")
	private String maxCount; //리스트 표시갯수

	@Value("#{r2Conf['mode']}")
	private String mode;
	@Value("#{r2Conf['inst']}")
	private String inst;
	@Value("#{sysConf['dis.limit.ip']}")
	private String limitedIp;

	@Value("#{sysConf['user.intro.page']}")
	private String introPage;

	@Value("#{sysConf['default.language']}")
	private String defaultLanguage;

	@Value("#{sysConf['admin.mgt.intro.page']}")
	private String adminMgtIntroPage;

    @RequestMapping("/home")
    public String main(ModelMap model, HttpServletRequest req, HttpServletResponse res, WebRequest webReq,
					   @RequestParam(value = "user_id", defaultValue = "") String userId,
					   @RequestParam(value = "user_name", defaultValue = "") String userName,
					   @RequestParam(value = "user_email", defaultValue = "") String userEmail,
					   @RequestParam(value = "user_dept", defaultValue = "") String userDept,
					   @RequestParam(value = "solutions", defaultValue = "") String solutions) {

		log.debug("SSO LOGIN : RssMainController");

		UserVo user = null;
		user = rssLoginService.loginById(userId);
		userId = user.getUserId();

		SessionUtil.clearSessionByWebRequest(webReq);
		sessionSetting(req, res, webReq, user, model);

		model.addAttribute("inst", inst);

		JsonParser jsonParser = new JsonParser();
		JsonArray jsonArray = (JsonArray) jsonParser.parse(solutions);
		for (int i = 0 ; i < jsonArray.size() ; i++) {
			JsonObject object = (JsonObject) jsonArray.get(i);
			Map<String, Object> map = new HashMap<>();
			String moduleName = object.get("module").getAsString();
			String adminValue = object.get("admin").getAsString();
			String userValue = object.get("user").getAsString();
			map.put("module", moduleName);
			map.put("admin", adminValue);
			map.put("user", userValue);

			model.addAttribute(moduleName, map);
			req.getSession().setAttribute(moduleName, map);
		}

		// 유사연구자(연구자 추천)
		UserVo similarUser = null;
		similarUser = rssMainService.findSimilarUserList(userId);
		if(similarUser != null){
			model.addAttribute("smUser", similarUser);
			List<Map<String,String>> simKeywordList = userService.findKeywordOfUser(similarUser.getUserId());
			if(simKeywordList != null || !simKeywordList.isEmpty()){
				model.addAttribute("simKeywordList", simKeywordList);
			}
		}

		List<BbsVo> bbsList = null;
		bbsList = rssMainService.findLatestBBS();
		if(!bbsList.isEmpty() || bbsList != null){
			model.addAttribute("bbsList", bbsList);
		}

		String currentLang = null;
		String applcAuthor = "";
		String srchUserId = "";

		if("".equals(userId)) {
			if(user != null) {
				userId = user.getUserId();
				currentLang = user.getLanguageFlag();
			}
		}

		List<Map<String,String>> keywordList = userService.findKeywordOfUser(userId);
		if(keywordList != null || !keywordList.isEmpty()){
			model.addAttribute("keywordList", keywordList);
		}


		// 최근 등록 논문 검색
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
			resultMap = userService.findContents("journal", rimsSearchVo);
		} catch (IOException e) {
			e.printStackTrace();
		} catch (SolrServerException e) {
			e.printStackTrace();
		}

		model.addAttribute("userInfo", user);
		model.addAttribute("recentArticle", resultMap.get("contentList"));

		List<Map<String, Object>> staticsArticle = rssMainService.staticsArticleByUser(userId);
		model.addAttribute("staticsArticle", staticsArticle);

		return "home";
    }

    public void sessionSetting(HttpServletRequest req, HttpServletResponse res, WebRequest webReq, UserVo user, ModelMap model){

		String userId = user.getUserId();

		model.addAttribute("inst", inst);
		String returnPage = "";

		// 0. clear Session
		SessionUtil.clearSessionByWebRequest(webReq);

		// 1. flag check
//		if("".equals(flag)){
//			returnPage = "index/loginFail";
//		}else{
//			if("S".equals(flag)) returnPage = "index/loginFail";
//			else if("admin".equals(flag)) returnPage = "index/loginFail";
//		}


		if(!"".equals(userId)){
			//IP Check
			String userIp;
			String xforwardedFor = req.getHeader(R2Constant.HTTP_HEADER_FORWARDED);
			if(xforwardedFor != null){
				xforwardedFor = xforwardedFor.trim();
				if(xforwardedFor.indexOf(",") != -1)
					xforwardedFor = xforwardedFor.substring(0, xforwardedFor.indexOf(","));
				userIp = xforwardedFor;
			}
			else
			{
				userIp = req.getRemoteAddr();
			}

			req.getSession().setAttribute(R2Constant.IP_CHECK, indexService.limitedIpCheck(userIp, limitedIp));
			if(user != null)
			{
				//mvo.addObject(R2Constant.LOGIN_USER, user); // session setAttribute
				req.getSession().setAttribute(R2Constant.LOGIN_USER, user);

				String language = user.getLanguageFlag();
				if(language == null || "".equals(language)) language = defaultLanguage;
				String mgtAt = user.getMgtAt();
				if(mgtAt == null || "".equals(mgtAt)) mgtAt = "1";

				List<MemberAuthorVo> authorityList = indexService.findAutorityListByUserIdOrStdntNoOrUid(userId, null, null);

				if(authorityList == null || authorityList.size() == 0)
				{

				}
				else if(authorityList.size() == 1 ) // 권한이 1개인 경우 auth setSession 후 페이지로 이동
				{
					String adminDvsCd = authorityList.get(0).getAdminDvsCd();
					String workTrget = authorityList.get(0).getWorkTrget();
					String workTrgetNm = authorityList.get(0).getWorkTrgetNm();
					//연구자인가?
					if(adminDvsCd != null && R2Constant.RESEARCHER_DVS_CD.equals(adminDvsCd))
					{
						req.getSession().setAttribute(R2Constant.SESSION_USER , user);
					}
					//대리입력자인가?
					else if(adminDvsCd != null && R2Constant.SITTER_DVS_CD.equals(adminDvsCd) && workTrget != null && !"".equals(workTrget))
					{
						UserVo sessUser = indexService.findUserById(workTrget);
						req.getSession().setAttribute(R2Constant.SESSION_USER , sessUser);
					}
					else
					{
						UserVo authUser = indexService.findUserByUserIdAndAdminDvsCdAndWorkTrget(user.getUserId(), adminDvsCd, workTrget);
						if(authUser != null) req.getSession().setAttribute(R2Constant.SESSION_USER, authUser);
						else req.getSession().setAttribute(R2Constant.SESSION_USER, user);

					}
					user.setAdminDvsCd(adminDvsCd);
					user.setWorkTrget(workTrget);
					user.setWorkTrgetNm(workTrgetNm);
					user.setWorkUserId(workTrget);
					user.setWorkDeptKor(workTrgetNm);
					user.setWorkUserNm(workTrgetNm);
					req.getSession().setAttribute(R2Constant.LOGIN_USER, user);
					req.getSession().setAttribute(R2Constant.SHARE_USER, user);

					//setSession
					MemberAuthorVo authorVo = authorityList.get(0);
					authorVo.setGubun(user.getGubun());
					setSessionAuthorDetailByAuthorId(req, authorVo);
					addAccessLog(req, "IDP");

					//setLocale
					String authorLangFlag = authorityList.get(0).getLanguageFlag();
					if(authorLangFlag != null && !"".equals(authorLangFlag)) language = authorLangFlag;
					LocaleUtil.setLocale(req, res, language);


				}
//				req.getSession().setMaxInactiveInterval(60*60);
			}
		}
		indexService.loadLanguage();
		indexService.loadComment();
		indexService.loadCode();
		//indexService.loadMessage();
	}

	/*
   		전체 검색
    */
	@RequestMapping("/search/all")
	public String searchAll(@RequestParam(value = "searchAllName", defaultValue = "") String searchAllName,
							@RequestParam(value = "searchAllType", defaultValue = "everything") String searchAllType,
							@RequestParam(value = "sort", defaultValue = "date") String sort,
							@RequestParam(value = "order", defaultValue = "desc") String order,
							HttpServletRequest req, ModelMap model) {

		String language = ((UserVo) req.getSession().getAttribute(R2Constant.SHARE_USER)).getLanguageFlag();
		RimsSearchVo rimsSearchVo = new RimsSearchVo();
		int totalUser; //총 연구자 수
		int totalArticle; //총 논문 수
		int totalConference; //총 학술활동 수
		int totalFunding; //총 연구비 수
		int totalPatent; //총 특허 수
		int ps = 0;
		int ct = 8; 	 // 페이지당 연구자 수

		rimsSearchVo.setPs(ps);
		rimsSearchVo.setCt(ct);
		rimsSearchVo.setSearchName(searchAllName);
		rimsSearchVo.setSearchWord(searchAllType);
		rimsSearchVo.setText(sort);
		rimsSearchVo.setType(order);
		rimsSearchVo.setLanguage(language);

		Map<String, Object> userListMap = userService.findUserList(rimsSearchVo);

		totalUser = (int) userListMap.get("totalUser");

		Map<String, Object> articleListMap = new HashMap<>();
		Map<String, Object> conferenceListMap = new HashMap<>();
		Map<String, Object> fundingListMap = new HashMap<>();
		Map<String, Object> patentListMap = new HashMap<>();

		rimsSearchVo.setCt(4);

		try {
			articleListMap = articleService.findArticleList(rimsSearchVo);
			conferenceListMap = conferenceService.findConferenceList(rimsSearchVo);
			fundingListMap = fundingService.findFundingList(rimsSearchVo);
			patentListMap = patentService.findPatentList(rimsSearchVo);
		} catch (IOException e) {
			e.printStackTrace();
		} catch (SolrServerException e) {
			e.printStackTrace();
		} catch (NullPointerException e) {
			e.printStackTrace();
		}

		totalArticle = (int) articleListMap.get("totalArticle");
		totalConference = (int) conferenceListMap.get("totalConference");
		totalFunding = (int) fundingListMap.get("totalFunding");
		totalPatent = (int) patentListMap.get("totalPatent");

		model.addAttribute("searchAllName",searchAllName);
		model.addAttribute("userList", userListMap.get("userList"));
		model.addAttribute("articleList", articleListMap.get("articleList"));
		model.addAttribute("conferenceList", conferenceListMap.get("conferenceList"));
		model.addAttribute("fundingList", fundingListMap.get("fundingList"));
		model.addAttribute("patentList", patentListMap.get("patentList"));
		model.addAttribute("totalUser",totalUser);
		model.addAttribute("totalArticle",totalArticle);
		model.addAttribute("totalConference",totalConference);
		model.addAttribute("totalFunding",totalFunding);
		model.addAttribute("totalPatent",totalPatent);

		if(!searchAllName.equals("")){
			List<Map<String, String>> keywordList = rssMainService.findKeywordOfKeyword(searchAllName);
			model.addAttribute("keywordList",keywordList);
		}

		return "share/user/searchAll";
	}

	private void setSessionAuthorDetailByAuthorId(HttpServletRequest req, MemberAuthorVo author){
		Map<String, String> authMap = new HashMap<String, String>();
		if(author != null)
		{
			authMap.put("userId", author.getUserId());
			authMap.put("uId", author.getuId());
			authMap.put("adminDvsCd", author.getAdminDvsCd());
			authMap.put("workTrget", author.getWorkTrget());
			authMap.put("workTrgetNm", author.getWorkTrgetNm());
			authMap.put("workTrgetUId", author.getWorkTrgetUId());
			authMap.put("authorId", author.getAuthorId().toString());
			authMap.put("locale", author.getLanguageFlag());
			authMap.put("infoPrtcAgreAt", author.getInfoPrtcAgreAt());

			//set conect_ip
			String xforwardedFor = req.getHeader(R2Constant.HTTP_HEADER_FORWARDED);
			if(xforwardedFor != null){
				xforwardedFor = xforwardedFor.trim();
				if(xforwardedFor.indexOf(",") != -1)
					xforwardedFor = xforwardedFor.substring(0, xforwardedFor.indexOf(","));
				authMap.put("conectIp",xforwardedFor);
			}
			else
			{
				authMap.put("conectIp",req.getRemoteAddr());
			}
		}
		List<MemberAuthorDetailVo> authorDetailList = indexService.findAuthorityDetail(author.getAuthorId());
		if(authorDetailList != null && authorDetailList.size() > 0 )
		{
			for(MemberAuthorDetailVo detailVo : authorDetailList)
			{
				authMap.put(detailVo.getMgtTrget(), detailVo.getMgtLvl());
				authMap.put(detailVo.getProperty(), detailVo.getMgtLvl());
			}
		}
		List<MemberAuthorDetailVo> otherAuthorDetailList = indexService.findOtherAuthorityDetail(author);
		if(otherAuthorDetailList != null && otherAuthorDetailList.size() > 0)
		{
			for(MemberAuthorDetailVo detailVo : otherAuthorDetailList)
			{
				authMap.put(detailVo.getMgtTrget(), detailVo.getMgtLvl());
			}
		}
		req.getSession().setAttribute("auth", authMap);
	}

	private void addAccessLog(HttpServletRequest req, String conectMth){
		Map<String, String> authMap = (Map<String, String>) req.getSession().getAttribute("auth");
		AccessLogVo accessLogVo = new AccessLogVo();
		accessLogVo.setMenuNm("login");
		accessLogVo.setConectMth(conectMth);
		accessLogVo.setConectrId(authMap.get("userId"));
		accessLogVo.setConectrUId(authMap.get("uId"));
		accessLogVo.setConectrAuthorCd(authMap.get("adminDvsCd"));
		accessLogVo.setConectrAuthorId(authMap.get("authorId"));
		accessLogVo.setConectIp(authMap.get("conectIp"));
		accessLogVo.setConectrDetailAuthor(makeDetailAuthorFromAuthMap(authMap));
		String sessionId = req.getRequestedSessionId();
		if(sessionId != null) accessLogVo.setSessionId(sessionId);
		logService.addAccessLog(accessLogVo);
	}

	private String makeDetailAuthorFromAuthMap(Map<String, String> authMap){
		StringBuffer dAuthor = new StringBuffer();
		Map<String, String> authItem = CodeConfiguration.getCode("auth.item");
		if(authItem != null){
			Set<String> set = authItem.keySet();
			Iterator<String> it = set.iterator();
			while(it.hasNext()){
				String code = it.next();
				String mgtLvl = authMap.get(code) == null ? "0" : authMap.get(code);
				dAuthor.append(authItem.get(code)).append(":").append(mgtLvl).append(";");
			}
		}
		return org.apache.commons.lang.StringUtils.stripEnd(dAuthor.toString(), ";");
	}

	@RequestMapping(value = "/goGoogleScholar")
	private @ResponseBody String goGoogleScholar(@RequestParam("userId") String encptUserId,
												@RequestParam("smUserId") String encptSmUserId){


		UserVo user = userService.findByEncptUserId(encptUserId);
		UserVo smUser = userService.findByEncptUserId(encptSmUserId);

		List<KeywordVo> keywordList = rssMainService.findKeywordOfUserBySimilar(user.getUserId(), smUser.getUserId());
		String result = "";
		for (KeywordVo keywordVo : keywordList) {
			String keyword = keywordVo.getKeywordRegx();
			if(!keyword.equals("")){

			}
		}


		return result;
	}



	// 개발 서버 반영시 삭제
//	@RequestMapping("/home")
//	public String main(ModelMap model, HttpServletRequest req) {
//
//		UserVo loginUser = (UserVo) req.getSession().getAttribute(R2Constant.LOGIN_USER);
//		UserVo user = userService.findUserById(loginUser.getUserId());
//		String userId = user.getUserId();
//
//		String solutionList = "[{\"module\":\"GOTIT\",\"admin\":\"N\",\"user\":\"Y\"}\n" +
//				",{\"module\":\"RIMS\",\"admin\":\"N\",\"user\":\"Y\"},{\"module\":\"RSS\",\"admin\":\"N\",\"user\":\"Y\"},{\"module\":\"S2JOURNAL\",\"admin\":\"N\",\"user\":\"N\"},{\"module\":\"DISCOVERY\",\"admin\":\"N\",\"user\":\"N\"},{\"module\":\"PRISM\",\"admin\":\"N\",\"user\":\"N\"},{\"module\":\"BOARD\",\"admin\":\"N\",\"user\":\"N\"},{\"module\":\"SCHOLARWORKS\",\"admin\":\"N\",\"user\":\"N\"}]";
//
//		// 개발 서버에 반영할 메소드에 추가
//		JsonParser jsonParser = new JsonParser();
//		JsonArray jsonArray = (JsonArray) jsonParser.parse(solutionList);
//		for (int i = 0 ; i < jsonArray.size() ; i++) {
//			JsonObject object = (JsonObject) jsonArray.get(i);
//			Map<String, Object> map = new HashMap<>();
//			String moduleName = object.get("module").getAsString();
//			String adminValue = object.get("admin").getAsString();
//			String userValue = object.get("user").getAsString();
//			map.put("module", moduleName);
//			map.put("admin", adminValue);
//			map.put("user", userValue);
//
//			model.addAttribute(moduleName, map);
//			req.getSession().setAttribute(moduleName, map);
//		}
//
//		// 유사연구자(연구자 추천)
//		UserVo similarUser = null;
//		similarUser = rssMainService.findSimilarUserList(userId);
//		if(similarUser != null){
//			model.addAttribute("smUser", similarUser);
////			List<KeywordVo> simKeywordList = rssMainService.findKeywordByUser(similarUser.getUserId());
////			if(simKeywordList != null || !simKeywordList.isEmpty()){
////				model.addAttribute("simKeywordList", simKeywordList);
////			}
//			List<Map<String,String>> simKeywordList = userService.findKeywordOfUser(similarUser.getUserId());
//			if(simKeywordList != null || !simKeywordList.isEmpty()){
//				model.addAttribute("simKeywordList", simKeywordList);
//			}
//		}
//
//		List<BbsVo> bbsList = null;
//		bbsList = rssMainService.findLatestBBS();
//		if(!bbsList.isEmpty() || bbsList != null){
//			model.addAttribute("bbsList", bbsList);
//		}
//
//
//
//
//		// 개발서버 반영 메소드 끝
//
//		String currentLang = null;
//		String applcAuthor = "";
//		String srchUserId = "";
//
//		if("".equals(userId)) {
//			if(user != null) {
//				userId = user.getUserId();
//				currentLang = user.getLanguageFlag();
//			}
//		}
//
//		List<Map<String,String>> keywordList = userService.findKeywordOfUser(userId);
//		if(keywordList != null || !keywordList.isEmpty()){
//			model.addAttribute("keywordList", keywordList);
//		}
//
//
//		// 최근 등록 논문 검색
//		RimsSearchVo rimsSearchVo = new RimsSearchVo();
//		int totalContent; //총 컨텐츠 갯수
//		int ps = 1;
//		int ct = 5; 	 // 페이지당 row수
//		Map<String, Integer> pageCount = new HashMap<>();
//
//		ps = (ps-1)*ct; // 페이지 시작부분 index
//
//		rimsSearchVo.setUserId(userId);
//		rimsSearchVo.setPs(ps);
//		rimsSearchVo.setCt(ct);
//		rimsSearchVo.setText("date");
//		rimsSearchVo.setType("desc");
//
//		Map<String,Object> resultMap = null;
//		Map<String,Object> contentPagemap = new HashMap<>();
//
//		// 성과 리스트 및 성과 총개수
//		try {
//			resultMap = userService.findContents("journal", rimsSearchVo);
//		} catch (IOException e) {
//			e.printStackTrace();
//		} catch (SolrServerException e) {
//			e.printStackTrace();
//		}
//
//		model.addAttribute("userInfo", user);
//		model.addAttribute("recentArticle", resultMap.get("contentList"));
//
//		List<Map<String, Object>> staticsArticle = rssMainService.staticsArticleByUser(userId);
//		model.addAttribute("staticsArticle", staticsArticle);
//
//		return "home";
//	}

}