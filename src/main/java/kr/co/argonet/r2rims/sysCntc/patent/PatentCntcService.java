/*
 * Copyright www.argonet.co.kr
 * All rights reserved.
 *
 */
package kr.co.argonet.r2rims.sysCntc.patent;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import kr.co.argonet.r2rims.core.mapper.CodeMapMapper;
import kr.co.argonet.r2rims.core.mapper.PatentCntcMpper;
import kr.co.argonet.r2rims.core.mapper.PatentMapper;
import kr.co.argonet.r2rims.core.mapper.PatentPartiMapper;
import kr.co.argonet.r2rims.core.mapper.UserIdntfrMapper;
import kr.co.argonet.r2rims.core.vo.CodeMapVo;
import kr.co.argonet.r2rims.core.vo.PatentCntcVo;
import kr.co.argonet.r2rims.core.vo.PatentPartiVo;
import kr.co.argonet.r2rims.core.vo.PatentVo;
import kr.co.argonet.r2rims.core.vo.RimsSearchVo;
import kr.co.argonet.r2rims.core.vo.RsltFundingMapngVo;
import kr.co.argonet.r2rims.core.vo.UserIdntfrVo;
import kr.co.argonet.r2rims.pms.mapper.PmsPatentMapper;

/**
 * <pre>
 * 지식재산(특허) 연계 워크벤치 서비스클래스
 *  kr.co.argonet.r2rims.sysCntc.patent
 *      ┗ PatentCntcService.java
 *
 * </pre>
 * @date 2016. 12. 5.
 * @version
 * @author : hojkim
 */
@Service(value="patentCntcService")
public class PatentCntcService {

	Logger log = LoggerFactory.getLogger(PatentCntcService.class);

	@Resource(name="patentCntcMpper")
	private PatentCntcMpper patentCntcMpper;
	@Resource(name="pmsPatentMapper")
	private PmsPatentMapper pmsPatentMapper;
	@Resource(name="patentMapper")
	private PatentMapper patentMapper;
	@Resource(name="patentPartiMapper")
	private PatentPartiMapper patentPartiMapper;
	@Resource(name="userIdntfrMapper")
	private UserIdntfrMapper userIdntfrMapper;
	@Resource(name="codeMapMapper")
	private CodeMapMapper codeMapMapper;

	public void takeinPatentFromPms(){

		Integer lastedSrcId = patentCntcMpper.findLastedInputSrcId();

		List<PatentVo> insertPatentList = pmsPatentMapper.findGreaterThanBySrcId(lastedSrcId);
		if(insertPatentList != null && insertPatentList.size() > 0)
		{
			for(PatentVo patent : insertPatentList)
			{
				PatentCntcVo cntcVo = new PatentCntcVo();
				if(StringUtils.isNotBlank(patent.getSrcId()))
					cntcVo.setSrcId( Integer.parseInt(patent.getSrcId()));
				cntcVo.setPmsId(patent.getPmsId());
				cntcVo.setFamilyCode(patent.getFamilyCode());
				cntcVo.setCntcStatus("I");
				cntcVo.setSrcRegDate(patent.getRegDate());
				cntcVo.setSrcModDate(patent.getModDate());
				cntcVo.setRegUserId("system");
				cntcVo.setModUserId("system");
				patentCntcMpper.add(cntcVo);
			}
		}

		List<PatentVo> newPatentList = pmsPatentMapper.findNewPatentBySrcId(lastedSrcId);
		if(newPatentList != null && newPatentList.size() > 0)
		{
			for(PatentVo patent : newPatentList)
			{
				patentCntcMpper.updateCntcStatusBySrcId(patent.getSrcId(), "N");
			}
		}

	}

	public Integer countBySearchVo(RimsSearchVo searchVo){
		Integer count = 0;
		String srchStatus = searchVo.getSrchStatus();

		if("N".equals(srchStatus))
		{
			Integer lastedSrcId = patentCntcMpper.findLastedInputSrcId();
			Integer lastedModHistId = patentCntcMpper.findLastedModHistId();

			List<PatentCntcVo> newPatentCntcList =  patentCntcMpper.findByCntcStatus("N");
			if(newPatentCntcList != null && newPatentCntcList.size() > 0)
			{
				List<Integer> srcIds = new ArrayList<Integer>();
				for(PatentCntcVo cntcVo : newPatentCntcList) srcIds.add(cntcVo.getSrcId());

				PatentCntcVo param = new PatentCntcVo();
				param.setSrcId(lastedSrcId);
				param.setModHistId(lastedModHistId);
				param.setSrcIds(srcIds);

				List<PatentCntcVo> modHistList = pmsPatentMapper.findGreaterThanByModHistId(param);

				if(modHistList != null && modHistList.size() > 0)
				{
					for(PatentCntcVo modHist : modHistList) patentCntcMpper.updateModHistIdBySrcId(modHist);
				}
				searchVo.setSrcIds(srcIds);
				count = pmsPatentMapper.countBySrcIds(searchVo);
			}
		}
		else if("U".equals(srchStatus))
		{
			List<PatentCntcVo> modPatentCntcList =  patentCntcMpper.findByCntcStatus("U");

			if(modPatentCntcList != null && modPatentCntcList.size() > 0)
			{
				List<Integer> srcIds = new ArrayList<Integer>();
				for(PatentCntcVo cntcVo : modPatentCntcList) srcIds.add(cntcVo.getSrcId());
				searchVo.setSrcIds(srcIds);
				count = pmsPatentMapper.countBySrcIds(searchVo);
			}
		}

		return count;
	}

	public List<PatentVo> findBySearchVo(RimsSearchVo searchVo){
		List<PatentVo> trgetPatentList = new ArrayList<PatentVo>();
		String srchStatus = searchVo.getSrchStatus();

		if("N".equals(srchStatus))
		{
			List<PatentCntcVo> newPatentCntcList =  patentCntcMpper.findByCntcStatus("N");
			if(newPatentCntcList != null && newPatentCntcList.size() > 0)
			{
				List<Integer> srcIds = new ArrayList<Integer>();
				for(PatentCntcVo cntcVo : newPatentCntcList) srcIds.add(cntcVo.getSrcId());
				searchVo.setSrcIds(srcIds);
				trgetPatentList  = pmsPatentMapper.findBySrcIds(searchVo);
			}
		}
		else if("U".equals(srchStatus))
		{
			List<PatentCntcVo> modPatentCntcList =  patentCntcMpper.findByCntcStatus("U");

			if(modPatentCntcList != null && modPatentCntcList.size() > 0)
			{
				List<Integer> srcIds = new ArrayList<Integer>();
				for(PatentCntcVo cntcVo : modPatentCntcList) srcIds.add(cntcVo.getSrcId());
				searchVo.setSrcIds(srcIds);
				trgetPatentList  = pmsPatentMapper.findBySrcIds(searchVo);
			}
		}

		if(trgetPatentList != null && trgetPatentList.size() > 0)
		{
			for(int i = 0; i < trgetPatentList.size(); i++)
			{
				String applRegNtnCd = trgetPatentList.get(i).getApplRegNtnCd();
				if(applRegNtnCd != null && !"".equals(applRegNtnCd))
				{
					List<CodeMapVo> nationCodeList = codeMapMapper.findCodebByGubunaAndCodea("PMS_CODE", applRegNtnCd);
					if(nationCodeList != null && nationCodeList.size() > 0)
						trgetPatentList.get(i).setApplRegNtnCd(nationCodeList.get(0).getCodeb());
				}
				trgetPatentList.get(i).setPatentId(patentCntcMpper.findPatentIdBySrcId(trgetPatentList.get(i).getSrcId()));
			}
		}

		return trgetPatentList;
	}

	public PatentVo findPmsPatentBySrcId(Integer srcId){
		PatentVo pmsPatent = pmsPatentMapper.findBySrcId(srcId);
		if(pmsPatent != null)
		{
			List<CodeMapVo> nationCodeList = codeMapMapper.findCodebByGubunaAndCodea("PMS_CODE", pmsPatent.getApplRegNtnCd());
			if(nationCodeList != null && nationCodeList.size() > 0) pmsPatent.setApplRegNtnCd(nationCodeList.get(0).getCodeb());

			List<PatentPartiVo> patentPartiList = pmsPatentMapper.findCoInventerBySrcId(srcId);
			if(patentPartiList != null && patentPartiList.size() > 0)
			{
				for(int i=0; i < patentPartiList.size(); i++)
				{
					String prtcpntId = patentPartiList.get(0).getPrtcpntId();
					String email = patentPartiList.get(0).getEmail();
					if((prtcpntId == null || "".equals(prtcpntId)) &&  email != null && !"".equals(email))
					{
						List<UserIdntfrVo> idntfrs = userIdntfrMapper.findByIdntfrSeAndIdntfr("EMAIL", email);
						if(idntfrs != null && idntfrs.size() > 0)
							patentPartiList.get(0).setPrtcpntId(idntfrs.get(0).getUserId());
					}
				}

				pmsPatent.setPartiList(patentPartiList);
			}

		}
		return pmsPatent;
	}
	public List<Map> findFundingMapngListBySrcId(Integer srcId) {
		return pmsPatentMapper.findFundingMapngListBySrcId(srcId);
	}

	public PatentVo findPatentByPatentId(String patentId){
		return patentMapper.findByPatentId(patentId, "");
	}

	public List<PatentPartiVo> findPmsPatentPartiListByPatentId(Integer srcId){
		List<PatentPartiVo> patentPartiList = pmsPatentMapper.findCoInventerBySrcId(srcId);
		if(patentPartiList != null && patentPartiList.size() > 0)
		{
			for(int i=0; i < patentPartiList.size(); i++)
			{
				String prtcpntId = patentPartiList.get(0).getPrtcpntId();
				String email = patentPartiList.get(0).getEmail();
				if((prtcpntId == null || "".equals(prtcpntId)) &&  email != null && !"".equals(email))
				{
					List<UserIdntfrVo> idntfrs = userIdntfrMapper.findByIdntfrSeAndIdntfr("EMAIL", email);
					if(idntfrs != null && idntfrs.size() > 0)
						patentPartiList.get(0).setPrtcpntId(idntfrs.get(0).getUserId());
				}
			}
		}
		return patentPartiList;
	}
	public Integer findPatentIdBySrcId(Integer srcId) {
		return patentCntcMpper.findPatentIdBySrcId(srcId);
	}
	public void completeCntc(PatentVo patentVo) {
		patentCntcMpper.completeCntc(patentVo);
	}
	
	public void updateStatus(String[] srcIds, String modUserId) {
		patentCntcMpper.updateStatus(srcIds, modUserId);
	}

}

