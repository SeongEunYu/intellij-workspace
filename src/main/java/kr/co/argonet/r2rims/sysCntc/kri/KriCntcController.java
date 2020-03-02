/*
 * Copyright www.argonet.co.kr
 * All rights reserved.
 *
 */
package kr.co.argonet.r2rims.sysCntc.kri;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import kr.co.argonet.r2rims.core.vo.AcessModeVo;
import kr.co.argonet.r2rims.core.vo.ArticleVo;
import kr.co.argonet.r2rims.core.vo.RimsSearchVo;

/**
 * <pre>
 *  kr.co.argonet.r2rims.sysCntc.kri
 *      ┗ KriCntcController.java
 *
 * </pre>
 * @date 2017. 2. 8.
 * @version
 * @author : KIMHOJIN
 */
@RequestMapping("/kriCntc")
@Controller(value = "kriCntcController")
public class KriCntcController {

	Logger log = LoggerFactory.getLogger(KriCntcController.class);

	@Resource(name="kriCntcService")
	private KriCntcService kriCntcService;

	@Value("#{sysConf['inst.blng.agc.code']}")
	private String insttAgcId;
	@Value("#{sysConf['anlaysis.user.dept.field']}")
	private String deptField;
	@Value("#{sysConf['anlaysis.user.college.field']}")
	private String clgField;

	@RequestMapping("/importTarget")
	public String importTarget(ModelMap model){
		return "sysCntc/kri/kricntc_import";
	}

	@RequestMapping("/nkrdd505TrgetList")
	public ModelAndView nkrdd505TrgetList(
			@ModelAttribute AcessModeVo acessModeVo,
			@RequestParam(value = "posStart", required = false, defaultValue = "0") String posStart,
			@RequestParam(value = "count", required = false, defaultValue = "100") String count,
			@ModelAttribute RimsSearchVo searchVo,
			HttpServletRequest req
			){
		ModelAndView mvo = new ModelAndView("");

		int ps = Integer.parseInt(posStart); // 페이지 숫자
		int ct = Integer.parseInt(count); 	 // 페이지당 row수
		searchVo.setPs(ps);
		searchVo.setCt(ct);
		searchVo.setClgField(clgField);
		searchVo.setDeptField(deptField);
		searchVo.setInsttAgcId(insttAgcId);

		int totalCount = kriCntcService.countNkrdd505ByCond(searchVo);
		List<ArticleVo> nrkdd505List = kriCntcService.findNkrdd505ListByCond(searchVo);

		mvo.addObject("totalCount", totalCount);
		mvo.addObject("posStart", posStart);
		mvo.addObject("nrkdd505List", nrkdd505List);
		mvo.setViewName("sysCntc/kri/kricntc_import_grid");
		return mvo;
	}


}
