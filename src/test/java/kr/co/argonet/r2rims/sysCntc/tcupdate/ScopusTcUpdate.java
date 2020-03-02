/*
 * Copyright www.argonet.co.kr
 * All rights reserved.
 *
 */
package kr.co.argonet.r2rims.sysCntc.tcupdate;

import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.junit.Test;

import kr.co.argonet.dto.ScopusBean;
import kr.co.argonet.r2rims.AbstractApplicationContextTest;
import kr.co.argonet.r2rims.constant.R2Constant;
import kr.co.argonet.r2rims.core.mapper.ArticleMapper;
import kr.co.argonet.r2rims.core.vo.ArticleVo;
import kr.co.argonet.r2rims.core.vo.RimsSearchVo;
import kr.co.argonet.scopus.ScpModule;

/**
 * <pre>
 *  kr.co.argonet.r2rims.sysCntc.tcupdate
 *      ┗ ScopusTcUpdate.java
 *
 * </pre>
 * @date 2016. 10. 25.
 * @version
 * @author : hojkim
 */
public class ScopusTcUpdate extends AbstractApplicationContextTest {

	@Resource(name="articleMapper")
	private ArticleMapper articleMapper;

	private String apiKey = "b699f1bafc7fa2e5a03b979a6601be29";
	private String paramName = "EID";

	@Test
	public void findScopusBeanByUts(){
		RimsSearchVo searchVo = new RimsSearchVo();
		searchVo.setSourceGubun("SCP");
		List<ArticleVo> scpIdList = articleMapper.findSourcIdListBySourceGubun(searchVo);

		ScpModule module = new ScpModule(R2Constant.SCOPUS_API_URL, apiKey);

		String paramValue = "";
		for(int i = 0 ; i < scpIdList.size(); i++)
		{
			paramValue += scpIdList.get(i).getIdScopus() + ";";

			if(i != 0 && (i+1)%25 == 0 )
			{
				paramValue = StringUtils.strip(paramValue, ";");
				System.out.println("■ paramValue >>>>>>>> " +  paramValue);
				List<ScopusBean> beanList = module.getScopusDataList(paramName, paramValue);
				if(beanList != null && beanList.size() > 0)
				{
					for(ScopusBean bean : beanList)
						System.out.println(bean.getUt() + " >>> " + bean.getTc());
				}
				paramValue = "";

				break;
			}
		}
	}
}
