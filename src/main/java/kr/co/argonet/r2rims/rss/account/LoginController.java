package kr.co.argonet.r2rims.rss.account;

import kr.co.argonet.r2rims.constant.R2Constant;
import kr.co.argonet.r2rims.core.account.Account;
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
import kr.co.argonet.r2rims.rss.main.RssMainService;
import kr.co.argonet.r2rims.share.*;
import org.apache.commons.lang3.StringUtils;
import org.apache.solr.client.solrj.SolrServerException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;

/**
 * <pre>
 *  kr.co.argonet.r2rims.rss.account
 *      ┗ LoginController.java
 *
 * </pre>
 *
 * @author : woo
 * @date 2020-03-02
 */

@Controller(value = "loginController")
public class LoginController {

    Logger log = LoggerFactory.getLogger(LoginController.class);

    @Resource(name="indexService")
    private IndexService indexService;
    @Resource(name="logService")
    private LogService logService;
    @Resource(name="accountService")
    private Account accountService;
    @Resource(name="rssLoginService")
    private RssLoginService rssLoginService;

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

    @Value("#{sysConf['inst.name']}")
    private String instName;

    @Resource(name="mainService")
    private MainService mainService;

    @Resource(name="rssMainService")
    private RssMainService rssMainService;

    @Value("#{sysConf['main.top.notice.service.at']}")
    private String topNoticeAt;
    @Value("#{sysConf['main.maxCount']}")
    private String maxCount; //리스트 표시갯수


    @Value("#{sysConf['default.language']}")
    private String defaultLanguage;
    @Value("#{sysConf['user.intro.page']}")
    private String introPage;
    @Value("#{sysConf['dept.mgt.intro.page']}")
    private String deptMgtIntroPage;
    @Value("#{sysConf['dept.nomgt.intro.page']}")
    private String deptNomgtIntroPage;
    @Value("#{sysConf['college.mgt.intro.page']}")
    private String collegeMgtIntroPage;
    @Value("#{sysConf['college.nomgt.intro.page']}")
    private String collegeNomgtIntroPage;
    @Value("#{sysConf['admin.mgt.intro.page']}")
    private String adminMgtIntroPage;
    @Value("#{sysConf['admin.nomgt.intro.page']}")
    private String adminNomgtIntroPage;
    @Value("#{sysConf['analysis.search.dpet.field']}")
    private String searchDeptField;
    @Value("#{sysConf['anlaysis.user.dept.field']}")
    private String deptField;
    @Value("#{sysConf['anlaysis.user.college.field']}")
    private String clgField;
    @Value("#{sysConf['analysis.default.url']}")
    private String defaultPage;
    @Value("#{sysConf['analysis.clg.default.url']}")
    private String clgDefaultPage;
    @Value("#{sysConf['analysis.dept.default.url']}")
    private String deptDefaultPage;
    @Value("#{sysConf['analysis.rsch.default.url']}")
    private String rschDefaultPage;
    @Value("#{sysConf['discovery.service.at']}")
    private String discoveryServiceAt;

    @Value("#{r2Conf['mode']}")
    private String mode;
    @Value("#{r2Conf['inst']}")
    private String inst;
    @Value("#{sysConf['dis.limit.ip']}")
    private String limitedIp;


    @NoLoginCheck @NoAuthCheck @NoLocaleSet @NoInfoPrtcAgreCheck
    @RequestMapping("/admin_login")
    public ModelAndView admin_loginForm(){ return  new ModelAndView("index/admin_login"); }

    @NoLoginCheck @NoAuthCheck @NoLocaleSet @NoInfoPrtcAgreCheck
    @RequestMapping(value="/login", method=RequestMethod.GET)
    public ModelAndView loginGet(){
		return new ModelAndView("admin_login");
        //return new ModelAndView(accountService.getLoginPage());
    }

    /*
    sso login
     */
    @NoLoginCheck @NoAuthCheck @NoLocaleSet
    @RequestMapping(value="/home/login")
    public ModelAndView loginHome(@RequestParam(value = "data", required = true, defaultValue = "") String data,
                                 @RequestParam(value = "success", required = true, defaultValue = "") String success,
                                 HttpServletRequest req, HttpServletResponse res) throws Exception {

        ModelAndView mav = new ModelAndView();
        req.setAttribute("success", success);
        mav.addObject("data", data); // 사용자 정보 데이터(json)
        mav.setViewName("/sso_check");

        return mav;
    }


    /**
     * <pre>
     * 1. 개     요 : Logout 처리
     * 2. 처리내용 : session 값을 remove 하여 Logout를 진행함.
     * </pre>
     * @Method Name : logout
     * @param request
     * @param model
     * @return
     */
//    @NoLoginCheck @NoAuthCheck @NoInfoPrtcAgreCheck
//    @RequestMapping(value="/logout")
//    public ModelAndView logout( WebRequest request, Model model){
//        ModelAndView mvo = new ModelAndView("index/logout");
//        SessionUtil.clearSessionByWebRequest(request);
//        return mvo;
//    }

    /**
     * <pre>
     * 1. 개     요 : sso Logout 처리
     *
     * </pre>
     * @Method Name : logout
     * @param request
     * @param model
     * @return
     */
    @NoLoginCheck @NoAuthCheck @NoInfoPrtcAgreCheck
    @RequestMapping(value="/home/logout")
    public ModelAndView logout( WebRequest request, Model model, HttpServletResponse res){
        ModelAndView mvo = new ModelAndView("index/logout");
        SessionUtil.clearSessionByWebRequest(request);
        Cookie cookie = new Cookie("ARM_UC", null);
        cookie.setMaxAge(0);
        cookie.setPath("/");
        cookie.setDomain("bwise.kr");
        res.addCookie(cookie);
        return mvo;
    }


    /**
     * <pre>
     * 임시 loginPost
     * 개발 서버 반영시 삭제
     * </pre>
     * @Method Name : loginPost
     * @param id
     * @param pwd
     * @param flag
     * @param pathname
     * @param mode
     * @param inst
     * @param req
     * @param webReq
     * @return
     */
    @NoLoginCheck @NoAuthCheck @NoLocaleSet @NoInfoPrtcAgreCheck
    @RequestMapping(value="/login", method=RequestMethod.POST)
    public ModelAndView loginPost(
            @RequestParam(value="id", required=true, defaultValue="")String id,
            @RequestParam(value="pwd", required=true, defaultValue="")String pwd,
            @RequestParam(value="flag", required=true, defaultValue="")String flag,
            @RequestParam(value="pathname", required=false, defaultValue="")String pathname,
            @Value("#{r2Conf['mode']}")String mode,
            @Value("#{r2Conf['inst']}")String inst,
            @Value("#{sysConf['dis.limit.ip']}")String limitedIp,
            HttpServletRequest req, HttpServletResponse res, WebRequest webReq
    ){
        ModelAndView mvo = new ModelAndView("");
        UserVo user = (UserVo) req.getSession().getAttribute(R2Constant.SESSION_USER);
        UserVo loginUser = (UserVo) req.getSession().getAttribute(R2Constant.LOGIN_USER);

        mvo.addObject("inst", inst);
        String returnPage = "";

        // 0. clear Session
        SessionUtil.clearSessionByWebRequest(webReq);

        // 1. flag check
        if("".equals(flag)){
            returnPage = "index/loginFail";
        }else{
            if("S".equals(flag)) returnPage = "index/loginFail";
            else if("admin".equals(flag)) returnPage = "index/loginFail";
        }

        // 2. id & password value check
        id = StringUtils.defaultString(id).trim();
        pwd = StringUtils.defaultString(pwd).trim();

        if(!"".equals(id) && !"".equals(pwd)){
            user = rssLoginService.loginById2(id); // 연구자 or Member 인지 확인
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

                List<MemberAuthorVo> authorityList = indexService.findAutorityListByUserIdOrStdntNoOrUid(id, null, null);

                if(authorityList == null || authorityList.size() == 0)
                {
                    mvo.addObject("MSG", "시스템 접근 권한이 없습니다.");
                    mvo.addObject("USER_ID", "");
                    mvo.setViewName("index/loginFail");
                }
//                else if(authorityList.size() == 1 ) // 권한이 1개인 경우 auth setSession 후 페이지로 이동
                else
                {
                    String adminDvsCd = authorityList.get(0).getAdminDvsCd();
                    String workTrget = authorityList.get(0).getWorkTrget();
                    String workTrgetNm = authorityList.get(0).getWorkTrgetNm();

                    user.setAdminDvsCd(adminDvsCd);
                    user.setWorkTrget(workTrget);
                    user.setWorkTrgetNm(workTrgetNm);
                    user.setWorkUserId(workTrget);
                    user.setWorkDeptKor(workTrgetNm);
                    user.setWorkUserNm(workTrgetNm);
                    req.getSession().setAttribute(R2Constant.LOGIN_USER, user);
                    req.getSession().setAttribute(R2Constant.SHARE_USER, user);
                    req.getSession().setAttribute(R2Constant.SESSION_USER, user);

                    //setSession
                    MemberAuthorVo authorVo = authorityList.get(0);
                    authorVo.setGubun(user.getGubun());
                    setSessionAuthorDetailByAuthorId(req, authorVo);
                    addAccessLog(req, "IDP");

                    //setLocale
                    String authorLangFlag = authorityList.get(0).getLanguageFlag();
                    if(authorLangFlag != null && !"".equals(authorLangFlag)) language = authorLangFlag;
                    LocaleUtil.setLocale(req, res, language);

                    returnPage = getReturnPageByAdminDvsCd(adminDvsCd, mgtAt);
                    mvo.setViewName("redirect:"+returnPage);
                }

                req.getSession().setMaxInactiveInterval(60*60);
            }
            else
            {
                mvo.addObject("msg","존재하지 않는 사용자 ID 또는 패스워드가 맞지 않습니다.");
                mvo.addObject("pathname", pathname);
                mvo.setViewName(returnPage);
                return mvo;
            }
        }else{
            mvo.setViewName(returnPage);
        }
        indexService.loadLanguage();
        indexService.loadComment();
        indexService.loadCode();
        //indexService.loadMessage();
        return mvo;
    }

    private String getReturnPageByAdminDvsCd(String adminDvsCd, String mgtAt){
        String returnPage = "";

        if( (R2Constant.ADMIN_DVS_CD.equals(adminDvsCd) || R2Constant.MANAGE_DVS_CD.equals(adminDvsCd) || R2Constant.VIEW_DVS_CD.equals(adminDvsCd)) && "1".equals(mgtAt))
            returnPage = adminMgtIntroPage;
        else if( (R2Constant.ADMIN_DVS_CD.equals(adminDvsCd) || R2Constant.MANAGE_DVS_CD.equals(adminDvsCd) || R2Constant.VIEW_DVS_CD.equals(adminDvsCd)) && "0".equals(mgtAt))
            returnPage = adminNomgtIntroPage;
        else if( ( R2Constant.DEPT_DVS_CD.equals(adminDvsCd) || R2Constant.TRACK_DVS_CD.equals(adminDvsCd)) && "1".equals(mgtAt))
            returnPage = deptMgtIntroPage;
        else if( ( R2Constant.DEPT_DVS_CD.equals(adminDvsCd) || R2Constant.TRACK_DVS_CD.equals(adminDvsCd) ) && "0".equals(mgtAt))
            returnPage = deptNomgtIntroPage;
        else if(R2Constant.COLLEGE_DVS_CD.equals(adminDvsCd) && "1".equals(mgtAt) )
            returnPage = collegeMgtIntroPage;
        else if(R2Constant.COLLEGE_DVS_CD.equals(adminDvsCd) && "0".equals(mgtAt) )
            returnPage = collegeNomgtIntroPage;
        else
            returnPage = introPage;

        return returnPage;
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

}
