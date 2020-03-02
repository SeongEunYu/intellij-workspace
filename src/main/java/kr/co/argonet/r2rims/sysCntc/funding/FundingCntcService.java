/*
 * Copyright www.argonet.co.kr
 * All rights reserved.
 *
 */
package kr.co.argonet.r2rims.sysCntc.funding;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import kr.co.argonet.r2rims.core.mapper.FundingCntcMapper;
import kr.co.argonet.r2rims.core.mapper.FundingMapper;
import kr.co.argonet.r2rims.core.vo.FundingDetailVo;
import kr.co.argonet.r2rims.core.vo.FundingPartiVo;
import kr.co.argonet.r2rims.core.vo.FundingVo;

@Service(value="fundingCntcService")
public class FundingCntcService {

	Logger log = LoggerFactory.getLogger(FundingCntcService.class);

	@Resource(name="fundingCntcMpper")
	private FundingCntcMapper fundingCntcMapper;
	@Resource(name="fundingMapper")
	private FundingMapper fundingMapper;

	public List<FundingVo> findOverallList(Map param) {
		return fundingCntcMapper.findOverallList(param);
	}
	public List<FundingVo> findTaskList(Map param) {
		return fundingCntcMapper.findTaskList(param);
	}

	public FundingVo findOverallFunding(Map param) {
		return fundingCntcMapper.findOverallFunding(param);
	}
	public List<FundingPartiVo> findOverallFundingParti(Map param) {
		return fundingCntcMapper.findOverallFundingParti(param);
	}
	public List<FundingDetailVo> findOverallFundingDetail(Map param) {
		return fundingCntcMapper.findOverallFundingDetail(param);
	}
	public FundingVo findTaskFunding(Map param) {
		return fundingCntcMapper.findTaskFunding(param);
	}
	public List<FundingPartiVo> findTaskFundingParti(Map param) {
		return fundingCntcMapper.findTaskFundingParti(param);
	}
	public List<FundingDetailVo> findTaskFundingDetail(Map param) {
		return fundingCntcMapper.findTaskFundingDetail(param);
	}

	public Integer findFundingIdByErpId(Map<String, Object> param) {
		return fundingMapper.findFundingIdByErpId(param);
	}

	public void updateOverallStatus(String[] erpIds) {
		fundingCntcMapper.updateOverallStatus(erpIds);
	}
	public void updateTaskStatus(String[] erpIds) {
		fundingCntcMapper.updateTaskStatus(erpIds);
	}

}

