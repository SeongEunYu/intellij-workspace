package kr.co.argonet.r2rims.scholar.lecture;


import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import kr.co.argonet.r2rims.constant.R2Constant;
import kr.co.argonet.r2rims.core.annotation.NoLocaleSet;
import kr.co.argonet.r2rims.core.service.KaistResumeDownloadService;
import kr.co.argonet.r2rims.core.service.LogService;
import kr.co.argonet.r2rims.core.service.XlsxDownloadService;
import kr.co.argonet.r2rims.core.view.XlsxView;
import kr.co.argonet.r2rims.core.vo.AcessModeVo;
import kr.co.argonet.r2rims.core.vo.RimsSearchVo;
import kr.co.argonet.r2rims.core.vo.UserVo;
import kr.co.argonet.r2rims.scholar.vo.LectureVo;
import kr.co.argonet.r2rims.util.DateUtils;

/**
 * <pre>
 * 강의실적 관리를 위한 컨트롤러클래스
 *  kr.co.argonet.r2rims.scholar.lecture
 *      ┗ LectureController.java
 *
 * </pre>
 * @date 2016. 12. 20.
 * @version
 * @author : hojkim
 */
@Controller(value="lectureController")
public class LectureController {

	Logger log = LoggerFactory.getLogger(LectureController.class);

	@Resource(name="lectureService")
	private LectureService lectureService;
    @Resource(name="logService")
    private  LogService logService;
	//export용
	@Resource(name="xlsxDownloadService")
	private  XlsxDownloadService xlsxDownloadService;
	@Resource(name="kaistResumeDownloadService")
	private  KaistResumeDownloadService kaistResumeDownloadService;

	@Autowired
	XlsxView xlsxView;

	@RequestMapping({"/auth/lecture/lecture","/{acessMode}/lecture/lecture"})
	public ModelAndView adminLecture(@ModelAttribute AcessModeVo acessModeVo,
			HttpServletRequest req){
		ModelAndView mvo = new ModelAndView();
		Map<String, String> authMap = (Map<String, String>) req.getSession().getAttribute("auth");
		mvo.addObject("acessMode", acessModeVo.getAcessMode());
		mvo.setViewName("output/lecture/lecture_mgt");
		logService.addAccessLogByAuthMapAndMenuNm(authMap, "lecture", req.getRequestedSessionId());
		return mvo;
	}

	@NoLocaleSet
	@RequestMapping({"/auth/lecture/findAdminLectureList","/{acessMode}/lecture/findAdminLectureList"})
	public ModelAndView findAdminLectureList(
			@ModelAttribute AcessModeVo acessModeVo,
			@RequestParam(value = "posStart", required = false, defaultValue = "0") String posStart,
			@RequestParam(value = "count", required = false, defaultValue = "100") String count,
			@ModelAttribute RimsSearchVo searchVo,
			HttpServletRequest req){
		ModelAndView mvo = new ModelAndView();

		int ps = Integer.parseInt(posStart); // 페이지 숫자
		int ct = Integer.parseInt(count); // 페이지당 row수
		searchVo.setPs(ps);
		searchVo.setCt(ct);

        if(acessModeVo.getAcessMode() != null && R2Constant.SESSION_USER_MODE.equals(acessModeVo.getAcessMode()))
        {
        	UserVo sessUser = (UserVo) req.getSession().getAttribute(R2Constant.SESSION_USER);
        	searchVo.setSrchUserId(sessUser.getUserId());
        	searchVo.setSrchUId(sessUser.getuId());
        }
        else
        {
        	Map<String, String> authMap = (Map<String, String>) req.getSession().getAttribute("auth");
        	if(R2Constant.RESEARCHER_DVS_CD.equals(authMap.get("adminDvsCd"))
        			|| R2Constant.SITTER_DVS_CD.equals(authMap.get("adminDvsCd"))
        			)
        	{
        		searchVo.setSrchUserId(authMap.get("workTrget"));
        		searchVo.setSrchUId(authMap.get("workTrgetUId"));
        	}
        	else if(R2Constant.DEPT_DVS_CD.equals(authMap.get("adminDvsCd")))
        	{
        		searchVo.setSrchDept(authMap.get("workTrget"));
        		searchVo.setSrchDeptKor(authMap.get("workTrgetNm"));
        	}
        	else if(R2Constant.COLLEGE_DVS_CD.equals(authMap.get("adminDvsCd")))
        	{
        		searchVo.setSrchClg(authMap.get("workTrget"));
        	}
        	else if(R2Constant.TRACK_DVS_CD.equals(authMap.get("adminDvsCd")))
        	{
        		searchVo.setSrchTrack(authMap.get("workTrget"));
        	}
        }

		Integer totalCount = lectureService.countBySearchVo(searchVo);
		List<LectureVo> lectureList = lectureService.findLetureListWithPagingBySearchVo(searchVo);
		mvo.addObject("totalCount", totalCount);
		mvo.addObject("posStart", posStart);
		mvo.addObject("lectureList", lectureList);
		mvo.addObject("acessMode", acessModeVo.getAcessMode());
		mvo.setViewName("output/lecture/lecture_grid");
		return mvo;
	}

	@NoLocaleSet
	@RequestMapping({"/lecture/excelExport","/auth/lecture/excelExport","/{acessMode}/lecture/excelExport"})
	public Object excelExport(
			@ModelAttribute AcessModeVo acessModeVo,
			@ModelAttribute RimsSearchVo searchVo,
			Model model, HttpServletRequest req ){

        if(acessModeVo.getAcessMode() != null && R2Constant.SESSION_USER_MODE.equals(acessModeVo.getAcessMode()))
        {
        	UserVo sessUser = (UserVo) req.getSession().getAttribute(R2Constant.SESSION_USER);
        	searchVo.setSrchUserId(sessUser.getUserId());
        	searchVo.setSrchUId(sessUser.getuId());
        }
        else
        {
        	Map<String, String> authMap = (Map<String, String>) req.getSession().getAttribute("auth");
        	if(R2Constant.RESEARCHER_DVS_CD.equals(authMap.get("adminDvsCd"))
        			|| R2Constant.SITTER_DVS_CD.equals(authMap.get("adminDvsCd"))
        			)
        	{
        		searchVo.setSrchUserId(authMap.get("workTrget"));
        		searchVo.setSrchUId(authMap.get("workTrgetUId"));
        	}
        	else if(R2Constant.DEPT_DVS_CD.equals(authMap.get("adminDvsCd")))
        	{
        		searchVo.setSrchDept(authMap.get("workTrget"));
        		searchVo.setSrchDeptKor(authMap.get("workTrgetNm"));
        	}
        	else if(R2Constant.COLLEGE_DVS_CD.equals(authMap.get("adminDvsCd")))
        	{
        		searchVo.setSrchClg(authMap.get("workTrget"));
        	}
        	else if(R2Constant.TRACK_DVS_CD.equals(authMap.get("adminDvsCd")))
        	{
        		searchVo.setSrchTrack(authMap.get("workTrget"));
        	}
        }

		List<LectureVo> lectureList = lectureService.findLetureListBySearchVo(searchVo);
		model.addAttribute("path", "output/lecture/export_lecture");
		model.addAttribute("lectureList", lectureList);
		model.addAttribute("name", "export_lecture_" + DateUtils.format(new Date(), "yyyyMMdd"));
		return xlsxView;
	}

	@NoLocaleSet
	@RequestMapping({"/auth/lecture/export", "/{acessMode}/lecture/export"})
	public void exportLectureFile(
			@ModelAttribute AcessModeVo acessModeVo,
			@RequestParam(value = "exportFmt", required = false, defaultValue = "") String exportFmt,
			@ModelAttribute RimsSearchVo searchVo,
			HttpServletRequest req, HttpServletResponse res) throws Exception{

		Map<String, String> authMap = (Map<String, String>) req.getSession().getAttribute("auth");
		UserVo sessUser = (UserVo) req.getSession().getAttribute(R2Constant.SESSION_USER);
		UserVo loginUser = (UserVo) req.getSession().getAttribute(R2Constant.LOGIN_USER);
		if(sessUser == null) sessUser = loginUser;
		searchVo.setSrchUserId(sessUser.getUserId());
		searchVo.setSrchUId(sessUser.getuId());
		searchVo.setPs(0);
		searchVo.setCt(999999);

        if(acessModeVo.getAcessMode() != null && R2Constant.SESSION_USER_MODE.equals(acessModeVo.getAcessMode()))
        {
        	searchVo.setSrchUserId(sessUser.getUserId());
        	searchVo.setSrchUId(sessUser.getuId());
        }
        else
        {
        	if(R2Constant.RESEARCHER_DVS_CD.equals(authMap.get("adminDvsCd"))
        			|| R2Constant.SITTER_DVS_CD.equals(authMap.get("adminDvsCd"))
        			)
        	{
        		searchVo.setSrchUserId(authMap.get("workTrget"));
        		searchVo.setSrchUId(authMap.get("workTrgetUId"));
        	}
        	else if(R2Constant.DEPT_DVS_CD.equals(authMap.get("adminDvsCd")))
        	{
        		searchVo.setSrchDept(authMap.get("workTrget"));
        		searchVo.setSrchDeptKor(authMap.get("workTrgetNm"));
        	}
        	else if(R2Constant.COLLEGE_DVS_CD.equals(authMap.get("adminDvsCd")))
        	{
        		searchVo.setSrchClg(authMap.get("workTrget"));
        	}
        	else if(R2Constant.TRACK_DVS_CD.equals(authMap.get("adminDvsCd")))
        	{
        		searchVo.setSrchTrack(authMap.get("workTrget"));
        	}
        }

        List<LectureVo> lectureList = lectureService.findLetureListBySearchVo(searchVo);
		if("excel".equals(exportFmt))
		{
			if (acessModeVo.getAcessMode() != null && R2Constant.SESSION_USER_MODE.equals(acessModeVo.getAcessMode())) {
				searchVo.setLang(sessUser.getLanguageFlag());
			} else {
				searchVo.setLang(authMap.get("locale"));
			}
			String tableHtml = lectureService.makeExportLectureTable(lectureList, searchVo, sessUser);
			xlsxDownloadService.downloadExcel("lecture_export_excel_format", tableHtml, req, res);
		}
		else if("rtf".equals(exportFmt))
		{
			kaistResumeDownloadService.downloadLectureResume("lecture_export_resume_format", lectureList, sessUser, req, res);
		}
	}

}