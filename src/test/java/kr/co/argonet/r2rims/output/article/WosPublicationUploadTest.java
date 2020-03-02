package kr.co.argonet.r2rims.output.article;

import java.io.StringReader;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathFactory;

import org.apache.commons.lang.ObjectUtils;
import org.apache.commons.lang3.StringEscapeUtils;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Value;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.xml.sax.InputSource;

import kr.co.argonet.amr.publication.PublicationXML;
import kr.co.argonet.amr.publication.Record;
import kr.co.argonet.amr.publication.SponsorXML;
import kr.co.argonet.r2rims.AbstractApplicationContextTest;
import kr.co.argonet.r2rims.core.mapper.ArticleMapper;
import kr.co.argonet.r2rims.core.mapper.ArticlePartiMapper;
import kr.co.argonet.r2rims.core.mapper.ConfigMapper;
import kr.co.argonet.r2rims.core.mapper.UserMapper;
import kr.co.argonet.r2rims.core.vo.ArticlePartiVo;
import kr.co.argonet.r2rims.core.vo.ArticleVo;
import kr.co.argonet.r2rims.core.vo.ConfigVo;
import kr.co.argonet.r2rims.core.vo.RimsSearchVo;
import kr.co.argonet.r2rims.core.vo.UserVo;

public class WosPublicationUploadTest extends AbstractApplicationContextTest {

	@Resource(name = "configMapper")
	private ConfigMapper configMapper;
	@Resource(name = "userMapper")
	private UserMapper userMapper;
	@Resource(name = "articleMapper")
	private ArticleMapper articleMapper;
	@Resource(name = "articlePartiMapper")
	private ArticlePartiMapper articlePartiMapper;

	@Value("#{sysConf['inst.name.eng']}")
	private String instEngName;

	@Test
	public void makeWosPublicationByUserId() throws Exception{

		RimsSearchVo searchVo = new RimsSearchVo();
		searchVo.setTrgetUserId("1001");

		List<ConfigVo> ridConfigList = configMapper.findByGubun("RID");
		List<UserVo> trgetUserList = userMapper.findRidIsNotNullUserListFromUserLeftOuterJoinUserIdntfr(searchVo.getTrgetUserId());
		if(trgetUserList != null && trgetUserList.size() > 0)
		{
			int addCnt = 0;
			List<Map<String,Object>> pubRsltList = new ArrayList<Map<String,Object>>();
			ConfigVo ridcfg = getRidConfigFromList(ridConfigList);
			SponsorXML sponsor = new SponsorXML();
			sponsor.setName(instEngName);
			sponsor.setFirstName(ridcfg.getFirstNm());
			sponsor.setLastName(ridcfg.getLastNm());
			sponsor.setEmail("rims@kaist.ac.kr");
			sponsor.addEmail(ridcfg.getEmailCc());
			sponsor.addEmail(ridcfg.getEmail());

			String xmlDoc = "";
			for(int i = 0; i < trgetUserList.size(); i++)
			{
				UserVo user = trgetUserList.get(i);
				PublicationXML pubXml = new PublicationXML();
				pubXml.setUserName(ridcfg.getId());
				pubXml.setPassword(ridcfg.getPassword());
				pubXml.setType("Publication");
				pubXml.setSponsor(sponsor);
				pubXml.setEmployeeID(user.getUserId());
				pubXml.setUploading_institution_name(instEngName);

				searchVo.setUserId(user.getUserId());
				List<ArticleVo> trgetArticleList = articleMapper.findPublicationArticleList(searchVo);
				if(trgetArticleList != null && trgetArticleList.size() > 0)
				{
					Record record = null;
					for(ArticleVo article : trgetArticleList)
					{
						record = new Record();
						record.setAccession_num("WOS:" + article.getIdSci());
						record.setRef_type(pubXml.setTypes(article.getDocType()));
						record.setTitle(StringEscapeUtils.escapeXml10(article.getOrgLangPprNm()).replace("-", "").replace("", ""));
						//저자
						List<ArticlePartiVo> partis = articlePartiMapper.findByArticleId(article.getArticleId());
						if(partis != null && partis.size() > 0)
						{
							String[] authors = new String[partis.size()];
							for(int k = 0; k < partis.size(); k++) authors[k] = partis.get(k).getPrtcpntNm();
							record.setAuthors(authors);
						}
						record.setStartPage(ObjectUtils.toString(article.getSttPage()));
						record.setEndPage(ObjectUtils.toString(article.getEndPage()));
						record.setVolume(ObjectUtils.toString(article.getVolume()));
						record.setNumber(StringEscapeUtils.escapeXml10(ObjectUtils.toString(article.getIssue())));
						record.setYear(ObjectUtils.toString(article.getPblcYear()));
						record.setPublisher(StringEscapeUtils.escapeXml10(ObjectUtils.toString(article.getScjnlNm())));
						record.setDoi(StringEscapeUtils.escapeXml10(ObjectUtils.toString(article.getDoi())));

						pubXml.addRecord(record);

						Map<String,Object> pubRslt = new HashMap<String,Object>();
						pubRslt.put("userId", user.getUserId());
						pubRslt.put("articleId", article.getArticleId());
						pubRsltList.add(pubRslt);
					}
					xmlDoc += pubXml.personRecodes();
					addCnt++;
				}

				if( ((addCnt%20 == 0) || (i+1 == trgetUserList.size())) && !"".equals(xmlDoc) )
				{
					try {
						//HTTPSmanager httpSmanager = new HTTPSmanager();
						//String retMsg = httpSmanager.responseHTTPS(R2Constant.RID_PUBLICATION_UPLOAD_URL, pubXml.headTag() + xmlDoc + pubXml.endTag());
						System.out.println(pubXml.headTag() + xmlDoc + pubXml.endTag());
						pubXml.makeFile(pubXml.headTag() + xmlDoc + pubXml.endTag(), "KAIST_"+i);
						//pubXml.makeFile("USER_ID : " + user.getUserId() + "\n" + retMsg, "errorMsg");

						if(pubRsltList != null && pubRsltList.size() > 0)
						{
							for(Map<String,Object> rslt : pubRsltList)
							{
								//articlePartiMapper.updateRidUploadFlag(ObjectUtils.toString(rslt.get("articleId")), ObjectUtils.toString(rslt.get("userId")));
								System.out.println("Update Result : UserId - " + ObjectUtils.toString(rslt.get("userId")) + ", ArticleId - " + ObjectUtils.toString(rslt.get("articleId")));
							}
							pubRsltList = new ArrayList<Map<String,Object>>();
						}

					} catch (Exception e) {
						//e.printStackTrace();
					}
					xmlDoc = "";
				}

			}// end for trgetUserList
		}//end if trgetUserList
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

	@Test
	public void getResultFromResponseMessage(){
		String result = "";
		String errMsg = "";
		//String retMsg = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?><response xmlns=\"http://www.isinet.com/xrpc41\"><fn name=\"AuthorResearch.uploadRIDData\" rc=\"Server.authorization\"><error code=\"Server.authorization\">User khspark@kaist.ac.kr is not authorized to this functionality</error></fn></response>";
		String retMsg = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?><response xmlns=\"http://www.isinet.com/xrpc41\"><fn name=\"AuthorResearch.uploadRIDData\" rc=\"OK\"></fn></response>";

		DocumentBuilderFactory factory = null;
		DocumentBuilder builder = null;
		Document doc = null;

		try{
			factory = DocumentBuilderFactory.newInstance();
			builder = factory.newDocumentBuilder();
			doc = builder.parse(new InputSource(new StringReader(retMsg)));
			doc.getDocumentElement().normalize();

			this.printDocument(doc);

			XPathFactory pathFactory = XPathFactory.newInstance();
			XPath xPath = pathFactory.newXPath();
			XPathExpression expr = null;
			Node node = null;
			Node fn = null;
			Node error = null;

			expr = xPath.compile("//fn");
			fn = (Node) expr.evaluate(doc, XPathConstants.NODE);

			if(fn != null)
			{
				node = (Node) xPath.evaluate("@rc", fn, XPathConstants.NODE);
				System.out.println(node.getNodeValue());

				error = (Node) xPath.evaluate("./error/text()", fn, XPathConstants.NODE);
				if(error != null)
				{
					System.out.println(error.getNodeValue());
				}
			}

		} catch (Exception e) {
			// TODO: handle exception
		}


	}

	private void printDocument(Document doc) throws Exception{
		DOMSource domSource = new DOMSource(doc);
		StringWriter writer = new StringWriter();
		StreamResult result = new StreamResult(writer);
		TransformerFactory factory = TransformerFactory.newInstance();
		Transformer tf = factory.newTransformer();
		tf.transform(domSource, result);
		System.out.println("XML in String format is : \n" + writer.toString());
	}

}
