package kr.co.argonet.r2rims.user.rid;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.junit.Test;

import kr.co.argonet.amr.profile.MakeWosProfileXML;
import kr.co.argonet.amr.profile.WOSProfile;
import kr.co.argonet.r2rims.AbstractApplicationContextTest;
import kr.co.argonet.r2rims.core.mapper.ConfigMapper;
import kr.co.argonet.r2rims.core.vo.ConfigVo;

public class WosProfileUploadTest extends AbstractApplicationContextTest {

	@Resource(name = "configMapper")
	private ConfigMapper configMapper;

	@Test
	public void makeWosProfileByUserId() throws Exception{

		List<ConfigVo> ridConfigList = configMapper.findByGubun("RID");

		ConfigVo ridcfg = getRidConfigFromList(ridConfigList);
		MakeWosProfileXML makeWosProfileXML = new MakeWosProfileXML();
		makeWosProfileXML.setUserName(ridcfg.getId());
		makeWosProfileXML.setPassword(ridcfg.getPassword());
		makeWosProfileXML.setFirstName(ridcfg.getFirstNm());
		makeWosProfileXML.setLastName(ridcfg.getLastNm());
		makeWosProfileXML.setEmail(ridcfg.getEmail());
		makeWosProfileXML.setEmailCC(ridcfg.getEmailCc());
		makeWosProfileXML.setRESMAIL(ridcfg.getResmail());
		makeWosProfileXML.setType("Profile");

		List<WOSProfile> profileList = new ArrayList<WOSProfile>();
		WOSProfile profile = new WOSProfile();
		profile.setFirstName("Son-Goo");
		profile.setLastName("Kim");
		profile.setEmail("kimsongoo@kaist.ac.kr");
		profile.setDept("Satellite Technology Research Center");
		profile.setEmployeeID("1294");
		profile.setStartDate("20050901");
		profile.setCity("Daejeon");
		profile.setInstName("KAIST");
		profile.setAddressLine("291 Daehak-ro, Yuseong-gu");
		profile.setCountry("Korea, Republic of");
		profile.setPostalcode("305701");
		profileList.add(profile);
		profile = new WOSProfile();
		profile.setFirstName("KAB-JIN");
		profile.setLastName("Kim");
		profile.setEmail("kabjin@kaist.ac.kr");
		profile.setDept("Department of Physics");
		profile.setEmployeeID("2071");
		profile.setStartDate("20161001");
		profile.setCity("Daejeon");
		profile.setInstName("KAIST");
		profile.setAddressLine("291 Daehak-ro, Yuseong-gu");
		profile.setCountry("Korea, Republic of");
		profile.setPostalcode("305701");
		profileList.add(profile);

		makeWosProfileXML.setProfileList(profileList);

		System.out.println(makeWosProfileXML.makeXMLDocument() + makeWosProfileXML.getEndTag());

	}


	private ConfigVo getRidConfigFromList(List<ConfigVo> ridConfigList){
		ConfigVo cfg = new ConfigVo();
		for(ConfigVo config : ridConfigList)
		{
			if(config.getCodeValue() != null && "ID".equals(config.getCodeValue()))
				cfg.setId(config.getCodeDisp());
			if(config.getCodeValue() != null && "PASSWORD".equals(config.getCodeValue()))
				cfg.setPassword(config.getCodeDisp());
			if(config.getCodeValue() != null && "FIRST_NM".equals(config.getCodeValue()))
				cfg.setFirstNm(config.getCodeDisp());
			if(config.getCodeValue() != null && "LAST_NM".equals(config.getCodeValue()))
				cfg.setLastNm(config.getCodeDisp());
			if(config.getCodeValue() != null && "EMAIL".equals(config.getCodeValue()))
				cfg.setEmail(config.getCodeDisp());
			if(config.getCodeValue() != null && "EMAIL_CC".equals(config.getCodeValue()))
				cfg.setEmailCc(config.getCodeDisp());
			if(config.getCodeValue() != null && "INST".equals(config.getCodeValue()))
				cfg.setInst(config.getCodeDisp());
			if(config.getCodeValue() != null && "RESMAIL".equals(config.getCodeValue()))
				cfg.setResmail(config.getCodeDisp());
		}
		return cfg;
	}


}
