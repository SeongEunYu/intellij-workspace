package kr.co.argonet.r2rims.sysCntc.techtrans;

import java.util.List;

import javax.annotation.Resource;

import org.junit.Test;

import kr.co.argonet.r2rims.AbstractApplicationContextTest;
import kr.co.argonet.r2rims.core.vo.TechtransVo;
import kr.co.argonet.r2rims.pms.mapper.PmsTechtransferMapper;

public class PmsTechtransferTest extends AbstractApplicationContextTest{

	@Resource(name="pmsTechtransferMapper")
	private PmsTechtransferMapper pmsTechtransferMapper;

	@Test
	public void findByModDate(){
		List<TechtransVo> cntcList = pmsTechtransferMapper.findTechtransferByModDate(null);
		System.out.println(cntcList.size());
	}

}
