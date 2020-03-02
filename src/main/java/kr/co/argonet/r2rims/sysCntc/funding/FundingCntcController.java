/*
 * Copyright www.argonet.co.kr
 * All rights reserved.
 *
 */
package kr.co.argonet.r2rims.sysCntc.funding;

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

import kr.co.argonet.r2rims.constant.R2Constant;
import kr.co.argonet.r2rims.core.service.LogService;
import kr.co.argonet.r2rims.core.vo.DeleteHistoryVo;
import kr.co.argonet.r2rims.core.vo.FundingDetailVo;
import kr.co.argonet.r2rims.core.vo.FundingPartiVo;
import kr.co.argonet.r2rims.core.vo.FundingVo;
import kr.co.argonet.r2rims.core.vo.UserVo;
import kr.co.argonet.r2rims.funding.FundingService;

@RequestMapping("/fundingCntc")
@Controller(value = "fundingCntcController")
public class FundingCntcController {

	Logger log = LoggerFactory.getLogger(FundingCntcController.class);

	@Resource(name="fundingCntcService")
	private FundingCntcService fundingCntcService;
	@Resource(name = "fundingService")
	private FundingService fundingService;
    @Resource(name="logService")
    private  LogService logService;


	@RequestMapping("/fundingTarget")
	public String targetMgt(ModelMap model){
		return "sysCntc/funding/fundingcntc_mgt";
	}

	@RequestMapping("/findOverallList")
	public String overallList(@RequestParam Map<String, Object> param, ModelMap model) {
		model.addAttribute("fundingList", fundingCntcService.findOverallList(param));
		return "sysCntc/funding/fundingcntc_grid";
	}
	@RequestMapping("/findTaskList")
	public String taskList(@RequestParam Map<String, Object> param, ModelMap model) {
		model.addAttribute("fundingList", fundingCntcService.findTaskList(param));
		return "sysCntc/funding/fundingcntc_grid";
	}
	@RequestMapping("/fundingCntcPopup")
	public String fundingCntc(@RequestParam Map<String, Object> param, ModelMap model) {
		// ERP 과제정보 영역
		FundingVo funding = new FundingVo();
		// ERP 과제데이터 조회
		if ("T".equals(param.get("overallFlag"))) {
			funding =  fundingCntcService.findOverallFunding(param);
			funding.setPartiList(fundingCntcService.findOverallFundingParti(param));
			funding.setDetailList(fundingCntcService.findOverallFundingDetail(param));
		} else if ("S".equals(param.get("overallFlag"))) {
			funding =  fundingCntcService.findTaskFunding(param);
			funding.setPartiList(fundingCntcService.findTaskFundingParti(param));
			funding.setDetailList(fundingCntcService.findTaskFundingDetail(param));
		}
		model.addAttribute("overallFlag",param.get("overallFlag"));
		model.addAttribute("funding",funding);
		model.addAttribute("fundingId", fundingCntcService.findFundingIdByErpId(param));
		return "sysCntc/funding/fundingcntc";
	}
	@RequestMapping("/updateStatusAjax")
	public String updateStatus(HttpServletRequest req,
			@RequestParam("overallFlag") String overallFlag,
			ModelMap model) {
		String[] erpIds = req.getParameterValues("erpId");
		if ("T".equals(overallFlag)) fundingCntcService.updateOverallStatus(erpIds);
		else if ("S".equals(overallFlag)) fundingCntcService.updateTaskStatus(erpIds);
		model.addAttribute("content", "true");
		return "result/html";
	}

	@RequestMapping("/addFundingAjax")
	public String addFunding(@ModelAttribute FundingVo fundingVo,
			/* funding parti start */
			@RequestParam(value = "prtcpntId", required = false) String[] prtcpntId,
			@RequestParam(value = "prtcpntNm", required = false) String[] prtcpntNm,
			@RequestParam(value = "pcnRschrRegNo", required = false) String[] pcnRschrRegNo,
			@RequestParam(value = "tpiDvsCd", required = false) String[] tpiDvsCd,
			@RequestParam(value = "blngAgcNm", required = false) String[] blngAgcNm,
			@RequestParam(value = "tpiRate", required = false) String[] tpiRate,
			@RequestParam(value = "tpiSttYear", required = false) String[] tpiSttYear,
			@RequestParam(value = "tpiSttMonth", required = false) String[] tpiSttMonth,
			@RequestParam(value = "tpiEndYear", required = false) String[] tpiEndYear,
			@RequestParam(value = "tpiEndMonth", required = false) String[] tpiEndMonth,
			/* funding parti end */
			/* funding detail start */
			@RequestParam(value = "rsrcctContYr", required = false) String[] rsrcctContYr,
			@RequestParam(value = "totRsrcct", required = false) String[] totRsrcct,
			@RequestParam(value = "prtyRsrcct", required = false) String[] prtyRsrcct,
			@RequestParam(value = "indrfee", required = false) String[] indrfee,
			@RequestParam(value = "sclgrndCorrFund", required = false) String[] sclgrndCorrFund,
			@RequestParam(value = "schoutCorrFund", required = false) String[] schoutCorrFund,
			@RequestParam(value = "assoRschrCnt", required = false) String[] assoRschrCnt,
			@RequestParam(value = "asstRschrCnt", required = false) String[] asstRschrCnt,
			@RequestParam(value = "detailApprRtrnCnclRsnCntn", required = false) String[] detailApprRtrnCnclRsnCntn,
			@RequestParam(value = "detailApprDvsCd", required = false) String[] detailApprDvsCd,
			/* funding detail end */
			HttpServletRequest req, ModelMap model) {

		Map<String, String> authMap = (Map<String, String>) req.getSession().getAttribute("auth");
		UserVo loginUser = (UserVo) req.getSession().getAttribute(R2Constant.LOGIN_USER);
		// funding add
		fundingVo.setModUserId(loginUser.getUserId());
		fundingVo.setRegUserId(loginUser.getUserId());
		fundingService.add(fundingVo);
		// funding parti add
		FundingPartiVo fundingPartiVo = null;
		if (prtcpntNm != null) {
			for (int i = 0; i < prtcpntNm.length; i++) {
				fundingPartiVo = new FundingPartiVo();
				fundingPartiVo.setFundingId(fundingVo.getFundingId());
				fundingPartiVo.setPrtcpntId(prtcpntId[i]);
				fundingPartiVo.setPrtcpntNm(prtcpntNm[i]);
				fundingPartiVo.setTpiDvsCd(tpiDvsCd[i]);
				fundingPartiVo.setBlngAgcNm(blngAgcNm[i]);
				if (!"_blank".equals(pcnRschrRegNo[i]))
					fundingPartiVo.setPcnRschrRegNo(pcnRschrRegNo[i]);
				fundingPartiVo.setTpiSttYear(tpiSttYear[i]);
				fundingPartiVo.setTpiSttMonth(tpiSttMonth[i]);
				fundingPartiVo.setTpiEndYear(tpiEndYear[i]);
				fundingPartiVo.setTpiEndMonth(tpiEndMonth[i]);
				fundingPartiVo.setRegUserId(loginUser.getUserId());
				fundingPartiVo.setModUserId(loginUser.getUserId());
				fundingService.addFundingParti(fundingPartiVo);
			}
		}
		// funding detail add
		FundingDetailVo fundingDetailVo = null;
		if (rsrcctContYr != null) {
			for (int i = 0; i < rsrcctContYr.length; i++) {
				fundingDetailVo = new FundingDetailVo();
				fundingDetailVo.setFundingId(fundingVo.getFundingId());
				fundingDetailVo.setRsrcctContYr(rsrcctContYr[i]);
				fundingDetailVo.setTotRsrcct(totRsrcct[i]);
				fundingDetailVo.setPrtyRsrcct(prtyRsrcct[i]);
				fundingDetailVo.setIndrfee(indrfee[i]);
				fundingDetailVo.setSclgrndCorrFund(sclgrndCorrFund[i]);
				fundingDetailVo.setSchoutCorrFund(schoutCorrFund[i]);
				fundingDetailVo.setAssoRschrCnt(assoRschrCnt[i]);
				fundingDetailVo.setAsstRschrCnt(asstRschrCnt[i]);
				if (detailApprRtrnCnclRsnCntn != null && detailApprRtrnCnclRsnCntn.length > 0) fundingDetailVo.setApprRtrnCnclRsnCntn(detailApprRtrnCnclRsnCntn[i]);
				if (detailApprDvsCd != null && detailApprDvsCd.length > 0) fundingDetailVo.setApprDvsCd(detailApprDvsCd[i]);
				fundingDetailVo.setModUserId(loginUser.getUserId());
				fundingDetailVo.setRegUserId(loginUser.getUserId());
				fundingService.addFundingDetail(fundingDetailVo);
			}
		}
		logService.addRsltTrtmntLogByAuthMapAndRsltTypeAndRsltIdAndWorkSeCd(authMap, "funding", fundingVo.getFundingId(), "INS", req.getRequestedSessionId());
		// 연구과제 상태를 완료로 변경
		String[] erpIds = req.getParameterValues("erpId");
		if ("T".equals(fundingVo.getOverallFlag())) fundingCntcService.updateOverallStatus(erpIds);
		else if ("S".equals(fundingVo.getOverallFlag())) fundingCntcService.updateTaskStatus(erpIds);
		model.addAttribute("content", "저장되었습니다.");
		return "result/html";
	}

	@RequestMapping("/modifyFundingAjax")
	public String modifyFunding(@ModelAttribute FundingVo fundingVo,
			@RequestParam(value = "listUrl", required = false, defaultValue = "") String listUrl,
			@RequestParam(value ="deleteUser", required = false, defaultValue = "") String[] deleteUser,
			@RequestParam(value ="relisUser", required = false, defaultValue = "") String[] relisUser,
			/* funding parti start */
			@RequestParam(value = "seqAuthor", required = false) String[] seqParti,
			@RequestParam(value = "prtcpntId", required = false) String[] prtcpntId,
			@RequestParam(value = "prtcpntNm", required = false) String[] prtcpntNm,
			@RequestParam(value = "pcnRschrRegNo", required = false) String[] pcnRschrRegNo,
			@RequestParam(value = "tpiDvsCd", required = false) String[] tpiDvsCd,
			@RequestParam(value = "blngAgcNm", required = false) String[] blngAgcNm,
			@RequestParam(value = "tpiRate", required = false) String[] tpiRate,
			@RequestParam(value = "tpiSttYear", required = false) String[] tpiSttYear,
			@RequestParam(value = "tpiSttMonth", required = false) String[] tpiSttMonth,
			@RequestParam(value = "tpiEndYear", required = false) String[] tpiEndYear,
			@RequestParam(value = "tpiEndMonth", required = false) String[] tpiEndMonth,
			/* funding parti end */
			/* funding detail start */
			@RequestParam(value = "seqFunding", required = false) String[] seqFunding,
			@RequestParam(value = "rsrcctContYr", required = false) String[] rsrcctContYr,
			@RequestParam(value = "totRsrcct", required = false) String[] totRsrcct,
			@RequestParam(value = "prtyRsrcct", required = false) String[] prtyRsrcct,
			@RequestParam(value = "indrfee", required = false) String[] indrfee,
			@RequestParam(value = "sclgrndCorrFund", required = false) String[] sclgrndCorrFund,
			@RequestParam(value = "schoutCorrFund", required = false) String[] schoutCorrFund,
			@RequestParam(value = "assoRschrCnt", required = false) String[] assoRschrCnt,
			@RequestParam(value = "asstRschrCnt", required = false) String[] asstRschrCnt,
			@RequestParam(value = "detailApprRtrnCnclRsnCntn", required = false) String[] detailApprRtrnCnclRsnCntn,
			@RequestParam(value = "detailApprDvsCd", required = false) String[] detailApprDvsCd,
			/* funding detail end */
			HttpServletRequest req, ModelMap model) {

		Map<String, String> authMap = (Map<String, String>) req.getSession().getAttribute("auth");
		UserVo loginUser = (UserVo) req.getSession().getAttribute(R2Constant.LOGIN_USER);
		// funding add
		fundingVo.setModUserId(loginUser.getUserId());
		fundingService.update(fundingVo);
		// funding parti remove and add/update
		FundingPartiVo fundingPartiVo = new FundingPartiVo();
		fundingPartiVo.setModUserId(loginUser.getUserId());
		fundingPartiVo.setFundingId(fundingVo.getFundingId());

		if(deleteUser != null && deleteUser.length > 0)
		{
			for(String delAuthor : deleteUser)
			{
				if(!"".equals(delAuthor) && !"N".equals(delAuthor))
				{
					fundingPartiVo = new FundingPartiVo();
					fundingPartiVo.setFundingId(fundingVo.getFundingId());
					fundingPartiVo.setSeqParti(Integer.parseInt(delAuthor));
					fundingPartiVo.setModUserId(loginUser.getUserId());
					fundingService.deleteFundingPartiByFundingIdAndSeqParti(fundingPartiVo);
				}
			}
		}

		if(relisUser != null && relisUser.length > 1){
			for(String rUser : relisUser)
			{
				if(!"".equals(rUser) && !"N".equals(rUser))
				{
					DeleteHistoryVo historyVo = new DeleteHistoryVo();
					historyVo.setItemType("RI_CONFERENCE");
					historyVo.setItemId(fundingVo.getFundingId());
					historyVo.setUserId(rUser);
					historyVo.setModUserId(loginUser.getUserId());
					fundingService.addDeleteHistory(historyVo);
				}
			}
		}
		//fundingService.deleteFundigParti(fundingPartiVo);
		if (prtcpntNm != null) {
			for (int i = 0; i < prtcpntNm.length; i++) {
				fundingPartiVo = new FundingPartiVo();
				fundingPartiVo.setFundingId(fundingVo.getFundingId());
				fundingPartiVo.setPrtcpntId(prtcpntId[i]);
				fundingPartiVo.setPrtcpntNm(prtcpntNm[i]);
				fundingPartiVo.setTpiDvsCd(tpiDvsCd[i]);
				fundingPartiVo.setBlngAgcNm(blngAgcNm[i]);
				if (!"_blank".equals(pcnRschrRegNo[i]))
					fundingPartiVo.setPcnRschrRegNo(pcnRschrRegNo[i]);
				fundingPartiVo.setTpiSttYear(tpiSttYear[i]);
				fundingPartiVo.setTpiSttMonth(tpiSttMonth[i]);
				fundingPartiVo.setTpiEndYear(tpiEndYear[i]);
				fundingPartiVo.setTpiEndMonth(tpiEndMonth[i]);
				fundingPartiVo.setRegUserId(loginUser.getUserId());
				fundingPartiVo.setModUserId(loginUser.getUserId());
				if ("N".equals(seqParti[i])) {
					fundingService.addFundingParti(fundingPartiVo);
				} else {
					fundingPartiVo.setSeqParti(Integer.parseInt(seqParti[i]));
					fundingService.updateFundingParti(fundingPartiVo);
				}
			}
		}
		// funding detail remove and add/update
		FundingDetailVo fundingDetailVo = new FundingDetailVo();
		fundingDetailVo.setFundingId(fundingVo.getFundingId());
		fundingDetailVo.setModUserId(loginUser.getUserId());
		fundingService.deleteFundingDetail(fundingDetailVo);
		if (rsrcctContYr != null) {
			for (int i = 0; i < rsrcctContYr.length; i++) {
				fundingDetailVo = new FundingDetailVo();
				fundingDetailVo.setFundingId(fundingVo.getFundingId());
				fundingDetailVo.setRsrcctContYr(rsrcctContYr[i]);
				fundingDetailVo.setTotRsrcct(totRsrcct[i]);
				fundingDetailVo.setPrtyRsrcct(prtyRsrcct[i]);
				fundingDetailVo.setIndrfee(indrfee[i]);
				fundingDetailVo.setSclgrndCorrFund(sclgrndCorrFund[i]);
				fundingDetailVo.setSchoutCorrFund(schoutCorrFund[i]);
				fundingDetailVo.setAssoRschrCnt(assoRschrCnt[i]);
				fundingDetailVo.setAsstRschrCnt(asstRschrCnt[i]);
				if (detailApprRtrnCnclRsnCntn != null && detailApprRtrnCnclRsnCntn.length > 0)
					fundingDetailVo.setApprRtrnCnclRsnCntn(detailApprRtrnCnclRsnCntn[i]);
				if (detailApprDvsCd != null && detailApprDvsCd.length > 0)
					fundingDetailVo.setApprDvsCd(detailApprDvsCd[i]);
				fundingDetailVo.setModUserId(loginUser.getUserId());
				fundingDetailVo.setRegUserId(loginUser.getUserId());
				if ("N".equals(seqFunding[i])) {
					fundingService.addFundingDetail(fundingDetailVo);
				} else {
					fundingDetailVo.setSeqFunding(Integer.parseInt(seqFunding[i]));
					fundingService.updateFundingDetail(fundingDetailVo);
				}
			}
		}
		logService.addRsltTrtmntLogByAuthMapAndRsltTypeAndRsltIdAndWorkSeCd(authMap, "funding", fundingVo.getFundingId(), "MOD", req.getRequestedSessionId());
		String[] erpIds = req.getParameterValues("erpId");
		if ("T".equals(fundingVo.getOverallFlag())) fundingCntcService.updateOverallStatus(erpIds);
		else if ("S".equals(fundingVo.getOverallFlag())) fundingCntcService.updateTaskStatus(erpIds);
		model.addAttribute("content", "수정되었습니다.");
		return "result/html";
	}


}
