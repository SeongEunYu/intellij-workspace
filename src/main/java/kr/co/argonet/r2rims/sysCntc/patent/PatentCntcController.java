/*
 * Copyright www.argonet.co.kr
 * All rights reserved.
 *
 */
package kr.co.argonet.r2rims.sysCntc.patent;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import kr.co.argonet.r2rims.constant.R2Constant;
import kr.co.argonet.r2rims.core.annotation.NoLocaleSet;
import kr.co.argonet.r2rims.core.service.LogService;
import kr.co.argonet.r2rims.core.vo.DeleteHistoryVo;
import kr.co.argonet.r2rims.core.vo.PatentPartiVo;
import kr.co.argonet.r2rims.core.vo.PatentVo;
import kr.co.argonet.r2rims.core.vo.RimsSearchVo;
import kr.co.argonet.r2rims.core.vo.RsltFundingMapngVo;
import kr.co.argonet.r2rims.core.vo.UserVo;
import kr.co.argonet.r2rims.patent.PatentService;
import kr.co.argonet.r2rims.util.StringUtil;

/**
 * <pre>
 * 지식재산(특허) 연계 워크벤치 컨트롤러클래스
 *  kr.co.argonet.r2rims.sysCntc.patent
 *      ┗ PatentCntcController.java
 *
 * </pre>
 * @date 2016. 12. 5.
 * @version
 * @author : hojkim
 */
@RequestMapping("/patentCntc")
@Controller(value = "patentCntcController")
public class PatentCntcController {

	Logger log = LoggerFactory.getLogger(PatentCntcController.class);

	@Resource(name="patentCntcService")
	private PatentCntcService patentCntcService;
	@Resource(name="patentService")
	private PatentService patentService;
	@Resource(name="logService")
    private  LogService logService;

	@RequestMapping("/patentTarget")
	public ModelAndView targetMgt(){
		ModelAndView mvo = new ModelAndView();
		mvo.setViewName("sysCntc/patent/patentcntc_mgt");
		patentCntcService.takeinPatentFromPms();
		return mvo;
	}

	@RequestMapping("/findPatentTargetList")
	public ModelAndView findTargetList(
			@RequestParam(value = "posStart", required = false, defaultValue = "0") String posStart,
			@RequestParam(value = "count", required = false, defaultValue = "100") String count,
			@ModelAttribute RimsSearchVo searchVo
			){
		ModelAndView mvo = new ModelAndView();

		int ps = Integer.parseInt(posStart); // 페이지 숫자
		int ct = Integer.parseInt(count); 	 // 페이지당 row수
		searchVo.setPs(ps);
		searchVo.setCt(ct);

		int totalCount  = patentCntcService.countBySearchVo(searchVo);
		List<PatentVo> patentCntcList = patentCntcService.findBySearchVo(searchVo);

		mvo.addObject("totalCount", totalCount);
		mvo.addObject("posStart", posStart);
		mvo.addObject("patentCntcList", patentCntcList);

		mvo.setViewName("sysCntc/patent/patentcntc_grid");
		return mvo;
	}


	@RequestMapping({"/patentCntc","/patentCntcPopup"})
	public String techCntc(
			@RequestParam(value = "srcId", required = false, defaultValue = "") String srcId,
			@RequestParam(value = "patentId", required = false, defaultValue = "") String patentId, 
			ModelMap model) {
		if (srcId != null && !"".equals(srcId)) {
			PatentVo pmsPatent = patentCntcService.findPmsPatentBySrcId(Integer.parseInt(srcId));
			model.addAttribute("pmsPatent", pmsPatent);
			model.addAttribute("patentId", patentCntcService.findPatentIdBySrcId(Integer.parseInt(srcId)));
			if (pmsPatent != null) model.addAttribute("fundingMapngList",  patentCntcService.findFundingMapngListBySrcId(Integer.parseInt(srcId)));
		}
		return "sysCntc/patent/patentcntc";
	}

	@RequestMapping("/findPmsPatentPartiList")
	public ModelAndView findPmsPatentPartiList(
			@RequestParam(value = "srcId", required = false, defaultValue = "") String srcId,
			@ModelAttribute RimsSearchVo searchVo
			){
		ModelAndView mvo = new ModelAndView();

		List<PatentPartiVo> pmsPatentPartiList = patentCntcService.findPmsPatentPartiListByPatentId(Integer.parseInt(srcId));
		mvo.addObject("pmsPatentPartiList", pmsPatentPartiList);

		mvo.setViewName("sysCntc/patent/patentParti_grid");
		return mvo;
	}
	
	@RequestMapping("/updateStatusAjax")
	public String updateStatus(HttpServletRequest req, 
			ModelMap model) {
		UserVo loginUser = (UserVo) req.getSession().getAttribute(R2Constant.LOGIN_USER);
		String[] srcIds = req.getParameterValues("srcId");
		patentCntcService.updateStatus(srcIds, loginUser.getUserId());
		model.addAttribute("content", "true");
		return "result/html";
	}
	
	@RequestMapping("/addPatentAjax")
	public String addPatent(@ModelAttribute PatentVo patentVo, 
			/* patent parti start */
			@RequestParam(value="prtcpntNm",required=false) String[] prtcpntNm,
			@RequestParam(value="prtcpntId",required=false) String[] prtcpntId,
			@RequestParam(value="pcnRschrRegNo",required=false) String[] pcnRschrRegNo,
			@RequestParam(value="tpiDvsCd",required=false) String[] tpiDvsCd,
			@RequestParam(value="blngAgcNm",required=false) String[] blngAgcNm,
			@RequestParam(value="blngAgcCd",required=false) String[] blngAgcCd,
			@RequestParam(value="tpiRate",required=false) String[] tpiRate,
			/* patent funding start*/
			@RequestParam(value="seqNo",required=false) String[] seqNo,
			@RequestParam(value="sbjtNo",required=false) String[] sbjtNo,
			@RequestParam(value="fundingId",required=false) String[] fundingId,
			@RequestParam(value="rschSbjtNm",required=false) String[] rschSbjtNm,
			HttpServletRequest req, ModelMap model) {
		
		Map<String, String> authMap = (Map<String, String>) req.getSession().getAttribute("auth");
		UserVo loginUser = (UserVo) req.getSession().getAttribute(R2Constant.LOGIN_USER);

		patentVo.setModUserId(loginUser.getUserId());
		patentVo.setRegUserId(loginUser.getUserId());
		Integer patentId = patentService.add(patentVo);
		//patent parti add
		PatentPartiVo patentPartiVo = null;
		String inventorList = "";
		for (int i=0; i < prtcpntNm.length; i++) {
			patentPartiVo = new PatentPartiVo();
			patentPartiVo.setPatentId(patentId);
			patentPartiVo.setPrtcpntId(prtcpntId[i]);
			if(prtcpntNm != null) patentPartiVo.setPrtcpntNm(prtcpntNm[i]);
			if(tpiDvsCd != null) patentPartiVo.setTpiDvsCd(tpiDvsCd[i]);
			if(blngAgcNm != null) patentPartiVo.setBlngAgcNm(blngAgcNm[i]);
			if(blngAgcCd != null) patentPartiVo.setBlngAgcCd(blngAgcCd[i]);
			if(pcnRschrRegNo != null && !"_blank".equals(pcnRschrRegNo[i])) patentPartiVo.setPcnRschrRegNo(pcnRschrRegNo[i]);
			if(tpiRate != null && !"_blank".equals(tpiRate[i])) patentPartiVo.setTpiRate(tpiRate[i]);
			patentPartiVo.setRegUserId(loginUser.getUserId());
			patentPartiVo.setModUserId(loginUser.getUserId());
			patentPartiVo.setDispOrder(i+1);
			patentService.addPatentParti(patentPartiVo);
			inventorList += StringUtil.authorSwap(prtcpntNm[i], ",");
		}

		if (!"".equals(inventorList)) {
			inventorList = inventorList.substring(0,inventorList.lastIndexOf(","));
			patentVo.setInvtNm(inventorList);
			patentService.updateInvtNm(patentVo);
		}

		//funding
		if (sbjtNo != null) {
			for(int j = 0; j < sbjtNo.length; j++) {
				if(sbjtNo[j] != null && !"".equals(sbjtNo[j])) {
					RsltFundingMapngVo fundingMapng = new RsltFundingMapngVo();
					fundingMapng.setRsltType("PAT");
					fundingMapng.setRsltId(patentVo.getPatentId());
					fundingMapng.setSbjtNo(sbjtNo[j]);
					fundingMapng.setRschSbjtNm(rschSbjtNm[j]);
					if (fundingId[j] != null && !"".equals(fundingId[j])) fundingMapng.setFundingId(Integer.parseInt(fundingId[j]));
					if (seqNo[j] != null && !"".equals(seqNo[j]) && !"_blank".equals(seqNo[j])) fundingMapng.setSeqNo(Integer.parseInt(seqNo[j]));
					fundingMapng.setRegUserId(loginUser.getUserId());
					fundingMapng.setModUserId(loginUser.getUserId());
					patentService.mergeRsltFundingMapng(fundingMapng);
				}
			}
		}
		logService.addRsltTrtmntLogByAuthMapAndRsltTypeAndRsltIdAndWorkSeCd(authMap, "patent", patentVo.getPatentId(), "INS", req.getRequestedSessionId());
		
		patentCntcService.completeCntc(patentVo);
		model.addAttribute("content", "저장되었습니다.");
		return "result/html";
	}

	@RequestMapping("/modifyPatentAjax")
	public String modifyPatent(@ModelAttribute PatentVo patentVo,
			@RequestParam(value = "listUrl", required = false, defaultValue = "") String listUrl,
			@RequestParam(value ="deleteUser", required = false, defaultValue = "") String[] deleteUser,
			@RequestParam(value ="relisUser", required = false, defaultValue = "") String[] relisUser,
			/* patent parti start */
			@RequestParam(value="seqAuthor",required=false) String[] seqAuthor,
			@RequestParam(value="prtcpntNm",required=false) String[] prtcpntNm,
			@RequestParam(value="prtcpntId",required=false) String[] prtcpntId,
			@RequestParam(value="pcnRschrRegNo",required=false) String[] pcnRschrRegNo,
			@RequestParam(value="tpiDvsCd",required=false) String[] tpiDvsCd,
			@RequestParam(value="blngAgcNm",required=false) String[] blngAgcNm,
			@RequestParam(value="blngAgcCd",required=false) String[] blngAgcCd,
			@RequestParam(value="tpiRate",required=false) String[] tpiRate,
			/* patent funding start*/
			@RequestParam(value="seqNo",required=false) String[] seqNo,
			@RequestParam(value="sbjtNo",required=false) String[] sbjtNo,
			@RequestParam(value="fundingId",required=false) String[] fundingId,
			@RequestParam(value="rschSbjtNm",required=false) String[] rschSbjtNm, 
			HttpServletRequest req, ModelMap model) {

		Map<String, String> authMap = (Map<String, String>) req.getSession().getAttribute("auth");
		UserVo loginUser = (UserVo) req.getSession().getAttribute(R2Constant.LOGIN_USER);

		patentVo.setModUserId(loginUser.getUserId());
		patentService.update(patentVo);
		//patent parti remove and add/update
		String inventorList = "";
		PatentPartiVo patentPartiVo;
		if (deleteUser != null && deleteUser.length > 0) {
			for (String delAuthor : deleteUser) {
				if (!"".equals(delAuthor) && !"N".equals(delAuthor)) {
					patentPartiVo = new PatentPartiVo();
					patentPartiVo.setPatentId(patentVo.getPatentId());
					patentPartiVo.setSeqAuthor(Integer.parseInt(delAuthor));
					patentPartiVo.setModUserId(loginUser.getUserId());
					patentService.deletePatentPartiByPatentIdAndSeqAuthor(patentPartiVo);
				}
			}
		}

		if (relisUser != null && relisUser.length > 1) {
			for (String rUser : relisUser) {
				if (!"".equals(rUser) && !"N".equals(rUser)) {
					DeleteHistoryVo historyVo = new DeleteHistoryVo();
					historyVo.setItemType("RI_PATENT");
					historyVo.setItemId(patentVo.getPatentId());
					historyVo.setUserId(rUser);
					historyVo.setModUserId(loginUser.getUserId());
					patentService.addDeleteHistory(historyVo);
				}
			}
		}

		if (prtcpntNm != null) {
			for (int i=0; i < prtcpntNm.length; i++) {
				patentPartiVo = new PatentPartiVo();
				patentPartiVo.setPatentId(patentVo.getPatentId());
				patentPartiVo.setPrtcpntId(prtcpntId[i]);
				if(prtcpntNm != null) patentPartiVo.setPrtcpntNm(prtcpntNm[i]);
				if(tpiDvsCd != null) patentPartiVo.setTpiDvsCd(tpiDvsCd[i]);
				if(blngAgcNm != null) patentPartiVo.setBlngAgcNm(blngAgcNm[i]);
				if(blngAgcCd != null) patentPartiVo.setBlngAgcCd(blngAgcCd[i]);
				if(pcnRschrRegNo != null && !"_blank".equals(pcnRschrRegNo[i])) patentPartiVo.setPcnRschrRegNo(pcnRschrRegNo[i]);
				if(tpiRate != null && !"_blank".equals(tpiRate[i])) patentPartiVo.setTpiRate(tpiRate[i]);
				patentPartiVo.setRegUserId(loginUser.getUserId());
				patentPartiVo.setModUserId(loginUser.getUserId());
				patentPartiVo.setDispOrder(i+1);
				if("N".equals(seqAuthor[i])){
					patentService.addPatentParti(patentPartiVo);
				}
				else{
					patentPartiVo.setSeqAuthor(Integer.parseInt(seqAuthor[i]));
					patentService.updatePatentParti(patentPartiVo);
				}
				inventorList += StringUtil.authorSwap(prtcpntNm[i], ",");
			}
		}

		if(!"".equals(inventorList)){
			inventorList = inventorList.substring(0,inventorList.lastIndexOf(","));
			patentVo.setInvtNm(inventorList);
			patentService.updateInvtNm(patentVo);
		}

		//funding
		patentService.deleteRsltFundingMapngByArticleId(patentVo.getPatentId(), seqNo);
		if(sbjtNo != null)
		{
			for(int j = 0; j < sbjtNo.length; j++)
			{
				if(sbjtNo[j] != null && !"".equals(sbjtNo[j]))
				{
					RsltFundingMapngVo fundingMapng = new RsltFundingMapngVo();
					fundingMapng.setRsltType("PAT");
					fundingMapng.setRsltId(patentVo.getPatentId());
					fundingMapng.setSbjtNo(sbjtNo[j]);
					fundingMapng.setRschSbjtNm(rschSbjtNm[j]);
					if(fundingId[j] != null && !"".equals(fundingId[j]))
						fundingMapng.setFundingId(Integer.parseInt(fundingId[j]));
					if(seqNo[j] != null && !"".equals(seqNo[j]) && !"_blank".equals(seqNo[j]))
						fundingMapng.setSeqNo(Integer.parseInt(seqNo[j]));
					fundingMapng.setRegUserId(loginUser.getUserId());
					fundingMapng.setModUserId(loginUser.getUserId());
					patentService.mergeRsltFundingMapng(fundingMapng);
				}
			}
		}
		logService.addRsltTrtmntLogByAuthMapAndRsltTypeAndRsltIdAndWorkSeCd(authMap, "patent", patentVo.getPatentId(), "MOD", req.getRequestedSessionId());
		patentCntcService.completeCntc(patentVo);

		model.addAttribute("content", "수정되었습니다.");
		return "result/html";
	}



}
