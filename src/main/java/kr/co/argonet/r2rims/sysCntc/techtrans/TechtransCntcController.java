package kr.co.argonet.r2rims.sysCntc.techtrans;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.math.NumberUtils;
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
import kr.co.argonet.r2rims.core.vo.RimsSearchVo;
import kr.co.argonet.r2rims.core.vo.RsltPatentMapngVo;
import kr.co.argonet.r2rims.core.vo.TechtransCntcVo;
import kr.co.argonet.r2rims.core.vo.TechtransPartiDstbamtVo;
import kr.co.argonet.r2rims.core.vo.TechtransPartiVo;
import kr.co.argonet.r2rims.core.vo.TechtransRoyaltyVo;
import kr.co.argonet.r2rims.core.vo.TechtransVo;
import kr.co.argonet.r2rims.core.vo.UserVo;
import kr.co.argonet.r2rims.techtrans.TechtransService;

/**
 * <pre>
 * 기술이전 연계 워크벤치 컨트롤러클래스
 *  kr.co.argonet.r2rims.sysCntc.techtrans
 *      ┗ TechtransCntcController.java
 *
 * </pre>
 * @date 2016. 12. 20.
 * @version
 * @author : hojkim
 */
@RequestMapping("/techtransCntc")
@Controller(value = "techtransCntcController")
public class TechtransCntcController {

	Logger log = LoggerFactory.getLogger(TechtransCntcController.class);

	@Resource(name="techtransCntcService")
	private TechtransCntcService techtransCntcService;
	@Resource(name="techtransService")
    private TechtransService techtransService;
	@Resource(name="logService")
    private  LogService logService;

	@RequestMapping("/techTarget")
	public ModelAndView targetMgt(){
		ModelAndView mvo = new ModelAndView();
		techtransCntcService.syncTechtransFromPmsTechtransfer();
		mvo.setViewName("sysCntc/techtrans/techcntc_mgt");
		return mvo;
	}

	@RequestMapping("/findTechTargetList")
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

		int totalCount  = techtransCntcService.countBySearchVo(searchVo);
		List<TechtransCntcVo> techtransCntcList = techtransCntcService.findBySearchVo(searchVo);

		mvo.addObject("totalCount", totalCount);
		mvo.addObject("posStart", posStart);
		mvo.addObject("techtransCntcList", techtransCntcList);

		mvo.setViewName("sysCntc/techtrans/techcntc_grid");
		return mvo;
	}

	@RequestMapping({"/techCntc","/techCntcPopup"})
	public String techCntc(
			@RequestParam(value = "srcId", required = false, defaultValue = "") String srcId,
			@RequestParam(value = "techtransId", required = false, defaultValue = "") String techtransId, 
			ModelMap model){
		
		ModelAndView mvo = new ModelAndView();
		if (srcId != null && !"".equals(srcId)) {
			
			TechtransVo pmsTechtransfer = techtransCntcService.findPmsTechtransferBySrcId(Integer.parseInt(srcId));
			List<TechtransPartiVo> partiList = techtransCntcService.findPmsTechtransferPartiBySrcId(Integer.parseInt(srcId));
			pmsTechtransfer.setPartiList(partiList);
			List<TechtransRoyaltyVo> rcpmnyList = techtransCntcService.findPmsTransferRcpmnyListBySrcId(Integer.parseInt(srcId));
			pmsTechtransfer.setRoyaltyList(rcpmnyList);
			List<RsltPatentMapngVo> patentMapngList = techtransCntcService.findPmsTechtransPatentListBySrcId(srcId);
			pmsTechtransfer.setPatentMapngList(patentMapngList);
			model.addAttribute("pmsTechtrans", pmsTechtransfer);
			model.addAttribute("techtransId", techtransCntcService.findTechtransIdBySrcId(Integer.parseInt(srcId)));
		}
//		if(srcId != null && !"".equals(srcId))
//		{
//			List<TechtransPartiVo> partiList = techtransCntcService.findPmsTechtransferPartiBySrcId(Integer.parseInt(srcId));
//			mvo.addObject("partiList", partiList);
//		}

		/*
		if(techtransId != null && !"".equals(techtransId))
		{
			TechtransVo techtrans = techtransCntcService.findTechtransByTechtransId(Integer.parseInt(techtransId));
			mvo.addObject("techtrans", techtrans);
		}
		*/
		return "sysCntc/techtrans/techcntc";
	}
	// pms 파티만들기?
	@RequestMapping("findPmsTechtransPartiList")
	public ModelAndView techCntcPmsPartiListBySrcId(
			@RequestParam(value = "srcId", required = false, defaultValue = "") String srcId){
		ModelAndView mvo = new ModelAndView();
		if(srcId != null && !"".equals(srcId))
		{
			List<TechtransPartiVo> partiList = techtransCntcService.findPmsTechtransferPartiBySrcId(Integer.parseInt(srcId));
			mvo.addObject("partiList", partiList);
		}
		mvo.setViewName("sysCntc/techtrans/techparti_grid");
		return mvo;
	}
	// 일반 파티 
	@RequestMapping("findTechtransPartiList")
	public ModelAndView techCntcPartiListByTechtransId(
			@RequestParam(value = "techtransId", required = false, defaultValue = "") String techtransId){
		ModelAndView mvo = new ModelAndView();
		if(techtransId != null && !"".equals(techtransId))
		{
			List<TechtransPartiVo> partiList = techtransCntcService.findTechtransPartiListByTechtransId(techtransId);
			mvo.addObject("partiList", partiList);
		}
		mvo.setViewName("sysCntc/techtrans/techparti_grid");
		return mvo;
	}

	@RequestMapping("findPmsTechtransRcpmnyList")
	public ModelAndView techCntcPmsRcpmnyListBySrcId(
			@RequestParam(value = "srcId", required = false, defaultValue = "") String srcId){
		ModelAndView mvo = new ModelAndView();
		if(srcId != null && !"".equals(srcId))
		{
			List<TechtransRoyaltyVo> rcpmnyList = techtransCntcService.findPmsTransferRcpmnyListBySrcId(Integer.parseInt(srcId));
			mvo.addObject("rcpmnyList", rcpmnyList);
		}
		mvo.setViewName("sysCntc/techtrans/techrcpmny_grid");
		return mvo;
	}

	@RequestMapping("findTechtransRcpmnyList")
	public ModelAndView techCntcRcpmnyListByTechtransId(
			@RequestParam(value = "techtransId", required = false, defaultValue = "") String techtransId){
		ModelAndView mvo = new ModelAndView();
		if(techtransId != null && !"".equals(techtransId))
		{
			List<TechtransRoyaltyVo> rcpmnyList = techtransCntcService.findTechtransRcpmnyListByTechtransId(techtransId);
			mvo.addObject("rcpmnyList", rcpmnyList);
		}
		mvo.setViewName("sysCntc/techtrans/techrcpmny_grid");
		return mvo;
	}


	@RequestMapping({"findPmsTechtransPartiDstbamtList","findPmsTechtransPartiDstbamtListAjax"})
	public ModelAndView techCntcPmsPartiDstbamtListBySrcIdAndSrcTme(
			@RequestParam(value = "srcId", required = false, defaultValue = "") String srcId,
			@RequestParam(value = "srcTme", required = false, defaultValue = "") String srcTme){
		ModelAndView mvo = new ModelAndView();
		List<TechtransPartiDstbamtVo> dstbamtList = techtransCntcService.findPmsTransferPartiDstbamtListBySrcIdAndSrcTme(srcId, srcTme);
		mvo.addObject("dstbamtList", dstbamtList);
		mvo.setViewName("sysCntc/techtrans/techdstbamt_grid");
		return mvo;
	}

	@RequestMapping("findPmsTechtransPatentList")
	public ModelAndView techCntcPmsTechtransferPatentListBySrcId(
			@RequestParam(value = "srcId", required = false, defaultValue = "") String srcId){
		ModelAndView mvo = new ModelAndView();
		List<RsltPatentMapngVo> patentList = techtransCntcService.findPmsTechtransPatentListBySrcId(srcId);
		mvo.addObject("patentList", patentList);
		mvo.setViewName("sysCntc/techtrans/techpatent_grid");
		return mvo;
	}
	
	@RequestMapping("/updateStatusAjax")
	public String updateStatus(HttpServletRequest req, 
			ModelMap model) {
		UserVo loginUser = (UserVo) req.getSession().getAttribute(R2Constant.LOGIN_USER);
		String[] srcIds = req.getParameterValues("srcId");
		techtransCntcService.updateStatus(srcIds, loginUser.getUserId());
		model.addAttribute("content", "true");
		return "result/html";
	}
	
	
	@RequestMapping("/addTechtransAjax")
	public String addTechtrans(@ModelAttribute TechtransVo techtransVo, 
			/*parti start*/
			@RequestParam(value="prtcpntId",required=false) String[] prtcpntId,
			@RequestParam(value="prtcpntNm",required=false) String[] prtcpntNm,
			@RequestParam(value="prtcpntFullNm",required=false) String[] prtcpntFullNm,
			@RequestParam(value="tpiDvsCd",required=false) String[] tpiDvsCd,
			@RequestParam(value="tpiRate",required=false) String[] tpiRate,
			@RequestParam(value="blngAgcNm",required=false) String[] blngAgcNm,
			@RequestParam(value="blngAgcCd",required=false) String[] blngAgcCd,
			/*techtrans royalty start*/
			@RequestParam(value="collectionType",required=false) String[] collectionType,
			@RequestParam(value="rpmTme",required=false) String[] rpmTme,
			@RequestParam(value="rpmDate",required=false) String[] rpmDate,
			@RequestParam(value="rpmYr",required=false) String[] rpmYr,
			@RequestParam(value="rpmAmt",required=false) String[] rpmAmt,
			@RequestParam(value="ddcAmt",required=false) String[] ddcAmt,
			@RequestParam(value="ddcResn",required=false) String[] ddcResn,
			@RequestParam(value="diffAmt",required=false) String[] diffAmt,
			@RequestParam(value="invnterDstbAmt",required=false) String[] invnterDstbAmt,
			@RequestParam(value="univDstbAmt",required=false) String[] univDstbAmt,
			@RequestParam(value="deptDstbAmt",required=false) String[] deptDstbAmt,
			@RequestParam(value="acdincpDstbAmt",required=false) String[] acdincpDstbAmt,
			@RequestParam(value="royaltyApprDvsCd",required=false) String[] apprDvsCd,
			@RequestParam(value="royaltyApprRtrnCnclRsnCntn",required=false) String[] apprRtrnCnclRsnCntn,
			@RequestParam(value="patentId",required=false) String[] patentIds,
			HttpServletRequest req, ModelMap model) {
		
		Map<String, String> authMap = (Map<String, String>) req.getSession().getAttribute("auth");
		UserVo loginUser = (UserVo) req.getSession().getAttribute(R2Constant.LOGIN_USER);
		
		techtransVo.setModUserId(loginUser.getUserId());
		techtransVo.setRegUserId(loginUser.getUserId());
		Integer techtransId = techtransService.add(techtransVo);
		//techtrans parti add
		TechtransPartiVo techtransPartiVo;
		if (prtcpntNm != null) {
			for (int j=0; j < prtcpntNm.length; j++) {
				if (prtcpntNm[j] != null && !"".equals(prtcpntNm[j])) {
					techtransPartiVo = new TechtransPartiVo();
					techtransPartiVo.setTechtransId(techtransVo.getTechtransId());
					techtransPartiVo.setPrtcpntId(prtcpntId[j]);
					techtransPartiVo.setPrtcpntNm(prtcpntNm[j]);
					techtransPartiVo.setPrtcpntFullNm(prtcpntFullNm[j]);
					techtransPartiVo.setTpiDvsCd(tpiDvsCd[j]);
					techtransPartiVo.setBlngAgcNm(blngAgcNm[j]);
					techtransPartiVo.setBlngAgcCd(blngAgcCd[j]);
					techtransPartiVo.setModUserId(loginUser.getUserId());
					techtransPartiVo.setRegUserId(loginUser.getUserId());
					techtransPartiVo.setDispOrder(j+1);								// 정렬 기능 추가
					if (!"_blank".equals(tpiRate[j])) techtransPartiVo.setTpiRate(tpiRate[j]);
					techtransService.addTechtransParti(techtransPartiVo);
				}
			}
		}

		TechtransRoyaltyVo techtransRoyaltyVo = null;
		if(rpmAmt != null){
			for(int i=0; i < rpmAmt.length; i++){
				if(rpmAmt[i] != null && !"".equals(rpmAmt[i])) {
					techtransRoyaltyVo = new TechtransRoyaltyVo();
					techtransRoyaltyVo.setTechtransId(techtransVo.getTechtransId());
					//techtransRoyaltyVo.setRpmYr(rpmYr[i]);
					techtransRoyaltyVo.setCollectionType(collectionType[i]);
					if(rpmTme[i] != null && !"".equals(rpmTme[i])) techtransRoyaltyVo.setRpmTme(Integer.parseInt(rpmTme[i]));
					techtransRoyaltyVo.setRpmAmt(rpmAmt[i]);
					techtransRoyaltyVo.setRpmDate(rpmDate[i]);
					techtransRoyaltyVo.setDdcAmt(ddcAmt[i]);
					techtransRoyaltyVo.setDdcResn(ddcResn[i]);
					techtransRoyaltyVo.setDiffAmt(diffAmt[i]);
					techtransRoyaltyVo.setInvnterDstbAmt(invnterDstbAmt[i]);
					techtransRoyaltyVo.setUnivDstbAmt(univDstbAmt[i]);
					techtransRoyaltyVo.setDeptDstbAmt(deptDstbAmt[i]);
					techtransRoyaltyVo.setAcdincpDstbAmt(acdincpDstbAmt[i]);
					techtransRoyaltyVo.setApprDvsCd(apprDvsCd[i]);
					techtransRoyaltyVo.setApprRtrnCnclRsnCntn(apprRtrnCnclRsnCntn[i]);
					techtransRoyaltyVo.setModUserId(loginUser.getUserId());
					techtransRoyaltyVo.setRegUserId(loginUser.getUserId());
					techtransRoyaltyVo.setDispOrder(i+1);								// 정렬 기능 추가
					techtransService.addTechtransRoyalty(techtransRoyaltyVo);
				}
			}
		}
		// 관련특허
		if (patentIds != null && patentIds.length > 0) {
			for (int i = 0; i < patentIds.length; i++) {
				int patentId = NumberUtils.toInt(patentIds[i]);
				if (patentId != 0) {
					RsltPatentMapngVo patentMapngVo = new RsltPatentMapngVo();
					patentMapngVo.setPatentId(patentId);
					patentMapngVo.setRsltId(techtransVo.getTechtransId());
					patentMapngVo.setRsltType(R2Constant.SYSCNTC_SYNC_TARGET_TECHTRANS);
					patentMapngVo.setModUserId(loginUser.getUserId());
					patentMapngVo.setRegUserId(loginUser.getUserId());
					techtransService.mergeRsltPatentMapng(patentMapngVo);
				}
			}
		}
		logService.addRsltTrtmntLogByAuthMapAndRsltTypeAndRsltIdAndWorkSeCd(authMap, "techtrans", techtransVo.getTechtransId(), "INS", req.getRequestedSessionId());

		techtransCntcService.completeCntc(techtransVo);
		model.addAttribute("content", "저장되었습니다.");
		return "result/html";
    }

    @RequestMapping("/modifyTechtransAjax")
    public String modifyTechtrans( @ModelAttribute TechtransVo techtransVo, 
            @RequestParam(value ="deleteUser", required = false, defaultValue = "") String[] deleteUser,
			@RequestParam(value ="relisUser", required = false, defaultValue = "") String[] relisUser,
			/*parti start*/
            @RequestParam(value="seqAuthor",required=false) String[] seqAuthor,
			@RequestParam(value="prtcpntId",required=false) String[] prtcpntId,
			@RequestParam(value="prtcpntNm",required=false) String[] prtcpntNm,
			@RequestParam(value="prtcpntFullNm",required=false) String[] prtcpntFullNm,
			@RequestParam(value="tpiDvsCd",required=false) String[] tpiDvsCd,
			@RequestParam(value="tpiRate",required=false) String[] tpiRate,
			@RequestParam(value="blngAgcNm",required=false) String[] blngAgcNm,
			@RequestParam(value="blngAgcCd",required=false) String[] blngAgcCd,
            /*techtrans royalty start*/
			@RequestParam(value="deleteRoyalty",required=false) String[] deleteRoyaltys,
            @RequestParam(value="seqRoyalty",required=false) String[] seqRoyalty,
            @RequestParam(value="collectionType",required=false) String[] collectionType,
            @RequestParam(value="rpmTme",required=false) String[] rpmTme,
            @RequestParam(value="rpmDate",required=false) String[] rpmDate,
            @RequestParam(value="rpmYr",required=false) String[] rpmYr,
            @RequestParam(value="rpmAmt",required=false) String[] rpmAmt,
            @RequestParam(value="ddcAmt",required=false) String[] ddcAmt,
            @RequestParam(value="ddcResn",required=false) String[] ddcResn,
            @RequestParam(value="diffAmt",required=false) String[] diffAmt,
            @RequestParam(value="invnterDstbAmt",required=false) String[] invnterDstbAmt,
            @RequestParam(value="univDstbAmt",required=false) String[] univDstbAmt,
            @RequestParam(value="deptDstbAmt",required=false) String[] deptDstbAmt,
            @RequestParam(value="acdincpDstbAmt",required=false) String[] acdincpDstbAmt,
            @RequestParam(value="royaltyApprDvsCd",required=false) String[] apprDvsCd,
            @RequestParam(value="royaltyApprRtrnCnclRsnCntn",required=false) String[] apprRtrnCnclRsnCntn,
            @RequestParam(value="patentId",required=false) String[] patentIds,
            /*techtrans royalty end*/
            HttpServletRequest req, ModelMap model){

    	Map<String, String> authMap = (Map<String, String>) req.getSession().getAttribute("auth");
        UserVo loginUser = (UserVo) req.getSession().getAttribute(R2Constant.LOGIN_USER);
        // update TechTrans
        techtransVo.setModUserId(loginUser.getUserId());
        techtransService.update(techtransVo);
        // add/update parti
        TechtransPartiVo techtransPartiVo;
        if(deleteUser != null && deleteUser.length > 0) {
        	for(String delAuthor : deleteUser) {
        		if(!"".equals(delAuthor) && !"N".equals(delAuthor)) {
        			techtransPartiVo = new TechtransPartiVo();
        			techtransPartiVo.setTechtransId(techtransVo.getTechtransId());
        			techtransPartiVo.setSeqAuthor(Integer.parseInt(delAuthor));
        			techtransPartiVo.setModUserId(loginUser.getUserId());
        			techtransService.deleteByTechtransIdAndSeqAuthor(techtransPartiVo);
				}
        	}
        }

		if(relisUser != null && relisUser.length > 1){
			for(String rUser : relisUser) {
				if(!"".equals(rUser) && !"N".equals(rUser)) {
					DeleteHistoryVo historyVo = new DeleteHistoryVo();
					historyVo.setItemType("RI_TECHTRANS");
					historyVo.setItemId(techtransVo.getTechtransId());
					historyVo.setUserId(rUser);
					historyVo.setModUserId(loginUser.getUserId());
					techtransService.addDeleteHistory(historyVo);
				}
			}
		}

        if(prtcpntNm != null){
        	for(int j=0; j < prtcpntNm.length; j++) {
        		if(prtcpntNm[j] != null && !"".equals(prtcpntNm[j])) {
	        		techtransPartiVo = new TechtransPartiVo();
	        		techtransPartiVo.setTechtransId(techtransVo.getTechtransId());
	        		techtransPartiVo.setPrtcpntId(prtcpntId[j]);
	        		techtransPartiVo.setPrtcpntNm(prtcpntNm[j]);
					techtransPartiVo.setPrtcpntFullNm(prtcpntFullNm[j]);
					techtransPartiVo.setTpiDvsCd(tpiDvsCd[j]);
					techtransPartiVo.setBlngAgcNm(blngAgcNm[j]);
					techtransPartiVo.setBlngAgcCd(blngAgcCd[j]);
					techtransPartiVo.setModUserId(loginUser.getUserId());
					techtransPartiVo.setRegUserId(loginUser.getUserId());
					techtransPartiVo.setDispOrder(j+1);								// 정렬 기능 추가
					if(!"_blank".equals(tpiRate[j])) techtransPartiVo.setTpiRate(tpiRate[j]);
					if("N".equals(seqAuthor[j])){
						techtransService.addTechtransParti(techtransPartiVo);
					}else{
						techtransPartiVo.setSeqAuthor(Integer.parseInt(seqAuthor[j]));
						techtransService.updateTechtransParti(techtransPartiVo);
					}
        		}
        	}
        }
        // add/update royalty
        TechtransRoyaltyVo techtransRoyaltyVo;
        if(deleteRoyaltys != null && deleteRoyaltys.length > 0) {
        	for(String delRoyalty : deleteRoyaltys) {
        		if(delRoyalty != null && !"N".equals(delRoyalty)) {
        			techtransRoyaltyVo = new TechtransRoyaltyVo();
        			techtransRoyaltyVo.setTechtransId(techtransVo.getTechtransId());
        			techtransRoyaltyVo.setSeqRoyalty(Integer.parseInt (delRoyalty));
        			techtransRoyaltyVo.setModUserId(loginUser.getUserId());
        			techtransService.deleteByTechtransIdAndSeqRoyalty(techtransRoyaltyVo);
        		}
        	}
        }
        if(rpmAmt != null){
            for(int i=0; i < rpmAmt.length; i++){
            	if(rpmAmt[i] != null && !"".equals(rpmAmt[i])) {
            		techtransRoyaltyVo = new TechtransRoyaltyVo();
            		techtransRoyaltyVo.setTechtransId(techtransVo.getTechtransId());
            		//techtransRoyaltyVo.setRpmYr(rpmYr[i]);
            		techtransRoyaltyVo.setCollectionType(collectionType[i]);
            		if(rpmTme[i] != null && !"".equals(rpmTme[i])) techtransRoyaltyVo.setRpmTme(Integer.parseInt(rpmTme[i]));
            		techtransRoyaltyVo.setRpmAmt(rpmAmt[i]);
            		techtransRoyaltyVo.setRpmDate(rpmDate[i]);
            		techtransRoyaltyVo.setDdcAmt(ddcAmt[i]);
            		techtransRoyaltyVo.setDdcResn(ddcResn[i]);
            		techtransRoyaltyVo.setDiffAmt(diffAmt[i]);
            		techtransRoyaltyVo.setInvnterDstbAmt(invnterDstbAmt[i]);
            		techtransRoyaltyVo.setUnivDstbAmt(univDstbAmt[i]);
            		techtransRoyaltyVo.setDeptDstbAmt(deptDstbAmt[i]);
            		techtransRoyaltyVo.setAcdincpDstbAmt(acdincpDstbAmt[i]);
            		techtransRoyaltyVo.setApprDvsCd(apprDvsCd[i]);
            		techtransRoyaltyVo.setApprRtrnCnclRsnCntn(apprRtrnCnclRsnCntn[i]);
            		techtransRoyaltyVo.setModUserId(loginUser.getUserId());
            		techtransRoyaltyVo.setRegUserId(loginUser.getUserId());
					techtransRoyaltyVo.setDispOrder(i+1);								// 정렬 기능 추가
            		if("N".equals(seqRoyalty[i])){
            			techtransService.addTechtransRoyalty(techtransRoyaltyVo);
            		}else{
            			techtransRoyaltyVo.setSeqRoyalty(Integer.parseInt(seqRoyalty[i]));
            			techtransService.updateTechtransRoyalty(techtransRoyaltyVo);
            		}
            	}
            }
        }
        
        // 관련특허
        List<RsltPatentMapngVo> rsltPatentMapngList = techtransService.findByRlstTypeAndTechtransId(techtransVo.getTechtransId());
        // 관련특허 자동 삭제 (입력된 특허와 비교하여 없는 특허는 삭제)
        if (rsltPatentMapngList != null && rsltPatentMapngList.size() > 0 && patentIds != null && patentIds.length > 0) {
            for (RsltPatentMapngVo rsltPatentMapngVo : rsltPatentMapngList) {
            	boolean delDvsCd = true;
            	for (int i = 0; i < patentIds.length; i++) {
            		int patentId = NumberUtils.toInt(patentIds[i]);
            		if (rsltPatentMapngVo.getPatentId() == patentId) {
            			delDvsCd = false;
            			continue;
            		}
            	}
            	if (delDvsCd) techtransService.deleteRsltPatentMapngByTechtransId(techtransVo.getTechtransId(), rsltPatentMapngVo.getPatentId());
            }
        }
        // 관련특허 자동 추가 (기존에 없는 특허만 추가)
		if (patentIds != null && patentIds.length > 0) {
			for (int i = 0; i < patentIds.length; i++) {
				int patentId = NumberUtils.toInt(patentIds[i]);
				if (patentId != 0 && rsltPatentMapngList != null && rsltPatentMapngList.size() > 0) {
					boolean hasRslt = false;
					for (RsltPatentMapngVo rsltPatentMapngVo : rsltPatentMapngList) {
						if (rsltPatentMapngVo.getPatentId() == patentId) {
							hasRslt = true;
	            			continue;							
						}
					}
					if (!hasRslt) {
						RsltPatentMapngVo patentMapngVo = new RsltPatentMapngVo();
						patentMapngVo.setPatentId(patentId);
						patentMapngVo.setRsltId(techtransVo.getTechtransId());
						patentMapngVo.setRsltType(R2Constant.SYSCNTC_SYNC_TARGET_TECHTRANS);
						patentMapngVo.setModUserId(loginUser.getUserId());
						patentMapngVo.setRegUserId(loginUser.getUserId());
						techtransService.mergeRsltPatentMapng(patentMapngVo);
					}
				}
			}
		}
		logService.addRsltTrtmntLogByAuthMapAndRsltTypeAndRsltIdAndWorkSeCd(authMap, "techtrans", techtransVo.getTechtransId(), "MOD", req.getRequestedSessionId());
		techtransCntcService.completeCntc(techtransVo);
		
		model.addAttribute("content", "수정되었습니다.");
		return "result/html";
    }



}