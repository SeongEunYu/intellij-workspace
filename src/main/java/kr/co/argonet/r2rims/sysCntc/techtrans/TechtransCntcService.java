package kr.co.argonet.r2rims.sysCntc.techtrans;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import kr.co.argonet.r2rims.core.mapper.TechtransCntcMpper;
import kr.co.argonet.r2rims.core.mapper.TechtransMapper;
import kr.co.argonet.r2rims.core.mapper.TechtransPartiMapper;
import kr.co.argonet.r2rims.core.mapper.TechtransRoyaltyMapper;
import kr.co.argonet.r2rims.core.mapper.UserMapper;
import kr.co.argonet.r2rims.core.vo.RimsSearchVo;
import kr.co.argonet.r2rims.core.vo.RsltPatentMapngVo;
import kr.co.argonet.r2rims.core.vo.TechtransCntcVo;
import kr.co.argonet.r2rims.core.vo.TechtransPartiDstbamtVo;
import kr.co.argonet.r2rims.core.vo.TechtransPartiVo;
import kr.co.argonet.r2rims.core.vo.TechtransRoyaltyVo;
import kr.co.argonet.r2rims.core.vo.TechtransVo;
import kr.co.argonet.r2rims.core.vo.UserVo;
import kr.co.argonet.r2rims.pms.mapper.PmsTechtransferMapper;

/**
 * <pre>
 * 기술이전 연계 워크벤치 서비스클래스
 *  kr.co.argonet.r2rims.sysCntc.techtrans
 *      ┗ TechtransCntcService.java
 *
 * </pre>
 * @date 2016. 12. 20.
 * @version
 * @author : hojkim
 */
@Service(value="techtransCntcService")
public class TechtransCntcService {

	Logger log = LoggerFactory.getLogger(TechtransCntcService.class);

	@Resource(name="techtransCntcMpper")
	private TechtransCntcMpper techtransCntcMpper;
	@Resource(name="pmsTechtransferMapper")
	private PmsTechtransferMapper pmsTechtransferMapper;
	@Resource(name="techtransMapper")
	private TechtransMapper techtransMapper;
	@Resource(name="techtransPartiMapper")
	private TechtransPartiMapper techtransPartiMapper;
	@Resource(name="techtransRoyaltyMapper")
	private TechtransRoyaltyMapper techtransRoyaltyMapper;
	@Resource(name="userMapper")
	private UserMapper userMapper;

	public Integer countBySearchVo(RimsSearchVo searchVo){
		return techtransCntcMpper.countBySearchVo(searchVo);
	}

	public List<TechtransCntcVo> findBySearchVo(RimsSearchVo searchVo) {
		
		List<TechtransCntcVo> techtransCntcList = techtransCntcMpper.findBySearchVo(searchVo);

		List<Integer> srcIds = new ArrayList<Integer>();
		for (TechtransCntcVo cntcVo : techtransCntcList) srcIds.add(cntcVo.getSrcId());
		searchVo.setSrcIds(srcIds);
		List<TechtransVo> techtransList = pmsTechtransferMapper.findTechtransListBySrcIds(srcIds);
		
		for (TechtransCntcVo cntcVo : techtransCntcList) {
			for (TechtransVo vo : techtransList) {
				if ((cntcVo.getSrcId()+"").equals(vo.getSrcId())) {
					cntcVo.setCntrctManageNo(vo.getCntrctManageNo());
					cntcVo.setTechTransrNm(vo.getTechTransrNm());
					cntcVo.setCntrctSttDate(vo.getCntrctSttDate());
					cntcVo.setCntrctEndDate(vo.getCntrctEndDate());
					cntcVo.setCntrctAmt(vo.getCntrctAmt());
					cntcVo.setRpmAmtUnit(vo.getRpmAmtUnit());
					continue;
				}
			}
		}
		
		return techtransCntcList;
	}

	public TechtransVo findPmsTechtransferBySrcId(Integer srcId){
		return pmsTechtransferMapper.findTechtransferBySrcId(srcId);
	}

	public TechtransVo findTechtransByTechtransId(Integer techtransId){
		return techtransMapper.findByTechtransId(techtransId, null);
	}

	public List<TechtransPartiVo> findPmsTechtransferPartiBySrcId(Integer srcId){
		List<TechtransPartiVo> partiList = pmsTechtransferMapper.findTechtransferPartiListBySrcId(srcId);
		for(int i = 0; i <  partiList.size() ; i++){
			TechtransPartiVo parti = partiList.get(i);
			if(parti.getPrtcpntId() == null && parti.getUId() != null)
			{
				List<UserVo> userList = userMapper.findByUId(parti.getUId());
				if(userList != null && userList.size() > 0)
				{
					partiList.get(i).setPrtcpntId(userList.get(0).getUserId());
					partiList.get(i).setDeptKor(userList.get(0).getGroupDept());
				}
			}
			if(parti.getPrtcpntId() == null && parti.getEmalAddr() != null)
			{
				List<UserVo> userList = userMapper.findByEmailAdres(parti.getEmalAddr());
				if(userList != null && userList.size() > 0)
				{
					partiList.get(i).setPrtcpntId(userList.get(0).getUserId());
					partiList.get(i).setDeptKor(userList.get(0).getGroupDept());
				}
			}
		}
		return pmsTechtransferMapper.findTechtransferPartiListBySrcId(srcId);
	}

	public List<TechtransPartiVo> findTechtransPartiListByTechtransId(String techtransId){
		return techtransPartiMapper.findByTechtransId(techtransId);
	}

	public List<TechtransRoyaltyVo> findPmsTransferRcpmnyListBySrcId(Integer srcId){
		return pmsTechtransferMapper.findTechtransferRcpmnyListBySrcId(srcId);
	}

	public List<TechtransRoyaltyVo> findTechtransRcpmnyListByTechtransId(String techtransId){
		return techtransRoyaltyMapper.findByTechtransId(techtransId);
	}

	public List<TechtransPartiDstbamtVo> findPmsTransferPartiDstbamtListBySrcIdAndSrcTme(String srcId, String srcTme){
		List<TechtransPartiDstbamtVo> retDstbamtList = null;
		if(srcId != null && srcTme != null)
		{
			retDstbamtList = pmsTechtransferMapper.findTechtransferPartiDstbamtListBySrcIdAndRpmTme(Integer.parseInt(srcId), Integer.parseInt(srcTme));
		}
		return retDstbamtList;
	}

	public List<RsltPatentMapngVo> findPmsTechtransPatentListBySrcId(String srcId){
		List<RsltPatentMapngVo> patentMapngList = null;
		if (srcId != null) {
			patentMapngList = pmsTechtransferMapper.findPatentListBySrcId(Integer.parseInt(srcId));
			for (RsltPatentMapngVo patentMapngVo : patentMapngList) {
				patentMapngVo.setPatentId(techtransCntcMpper.findPatentIdByPmsId(patentMapngVo.getPmsId()));
			}
		}
		return patentMapngList;
	}

	public void syncTechtransFromPmsTechtransfer(){
		Date lastSrcModDate = techtransCntcMpper.findLastSrcModDate();
		List<TechtransVo> pmsTransferList = pmsTechtransferMapper.findTechtransferByModDate(lastSrcModDate);

		if(pmsTransferList != null && pmsTransferList.size() > 0)
		{
			for(TechtransVo pmsTransfer : pmsTransferList)
			{
				TechtransCntcVo cntcVo = new TechtransCntcVo();
				cntcVo.setSrcId(Integer.parseInt(pmsTransfer.getSrcId()));
				cntcVo.setTechTransrNm(pmsTransfer.getTechTransrNm());
				cntcVo.setSrcModDate(pmsTransfer.getModDate());
				cntcVo.setSrcRegDate(pmsTransfer.getRegDate());

				TechtransCntcVo chkCntcVo = techtransCntcMpper.findBySrcId(pmsTransfer.getSrcId());
				if(chkCntcVo == null)
				{
					cntcVo.setCntcStatus("I");
					techtransCntcMpper.add(cntcVo);
				}
				else
				{
					if(!"I".equals(chkCntcVo.getCntcStatus()))
						cntcVo.setCntcStatus("U");
					cntcVo.setSeqNo(chkCntcVo.getSeqNo());
					techtransCntcMpper.update(cntcVo);
				}
			}
		}
	}
	
	public Integer findTechtransIdBySrcId(Integer srcId) {
		return techtransCntcMpper.findTechtransIdBySrcId(srcId);
	}
	public void completeCntc(TechtransVo techtransVo) {
		techtransCntcMpper.completeCntc(techtransVo);
	}
	
	public void updateStatus(String[] srcIds, String modUserId) {
		techtransCntcMpper.updateStatus(srcIds, modUserId);
	}

}
