package kr.co.argonet.r2rims.code;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import javax.annotation.Resource;

import org.apache.solr.client.solrj.SolrClient;
import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.SolrServerException;
import org.apache.solr.client.solrj.impl.HttpSolrClient;
import org.apache.solr.client.solrj.response.QueryResponse;
import org.apache.solr.common.SolrDocument;
import org.apache.solr.common.SolrDocumentList;
import org.junit.Test;

import kr.co.argonet.r2rims.AbstractApplicationContextTest;
import kr.co.argonet.r2rims.core.mapper.CodeResAreaMapper;
import kr.co.argonet.r2rims.core.vo.CodeVo;

public class MakeCodeResAreaTreeXmlTest extends AbstractApplicationContextTest {

	@Resource(name = "codeResAreaMapper")
	private CodeResAreaMapper codeResAreaMapper;

	@Test
	public void makeCodeResAreaTreeXml(){
		StringBuffer xml = new StringBuffer();
		xml.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>").append("\n");
		xml.append("<tree id=\"codeResArea\">");
		List<CodeVo> codeResAreaList = codeResAreaMapper.findTreeList();
		List<CodeVo> topElementList = findChildList(codeResAreaList, "0");
		for(CodeVo top : topElementList )
		{
			//xml.append("<item text=\""+top.getCodeDisp()+"\" id=\""+top.getCodeValue()+"\"/>").append("\n");
			xml.append(elementXml(codeResAreaList, top));
		}
		xml.append("</tree>");

		System.out.println(xml.toString());

	}

	private String elementXml(List<CodeVo> source,CodeVo element){
		StringBuffer elementXml = new StringBuffer();
		List<CodeVo> childList = findChildList(source, element.getCodeValue());
		String isChild = "0";
		if(childList != null && childList.size() > 0)
		{
			isChild = "1";
			elementXml.append("<item text=\""+element.getCodeDispEng()+"\" id=\""+element.getCodeValue()+"\" child=\""+isChild+"\">").append("\n");
			for(CodeVo child : childList)
			{
				elementXml.append(elementXml(source, child));
			}
			elementXml.append("</item>").append("\n");
		}
		else
		{
			elementXml.append("<item text=\""+element.getCodeDispEng()+"\" id=\""+element.getCodeValue()+"\" child=\""+isChild+"\" />").append("\n");
		}

		return elementXml.toString();
	}

	private List<CodeVo> findChildList(List<CodeVo> source,  String upCode){
		List<CodeVo> childList = null;
		for(CodeVo codeResArea : source)
		{
			if(codeResArea.getUpCode().equals(upCode))
			{
				if(childList == null) childList = new ArrayList<CodeVo>();
				childList.add(codeResArea);
			}
		}
		return childList;
	}

	@Test
	public void makeCodeResAreaTreeXmlFromSolrServer(){

		long startTime = System.currentTimeMillis();
		System.out.println("##  시작시간 : " + formatTime(startTime));

		SolrClient solrClient = new HttpSolrClient("http://143.248.118.21:8983/solr/code_res_area");
		SolrQuery q = new SolrQuery("*:*");
		q.set("sort", "code_value asc");
		q.setRows(5000);

		List<CodeVo> resAreaList = new ArrayList<CodeVo>();
		try {
			QueryResponse qr = solrClient.query(q);
			SolrDocumentList docList = qr.getResults();
			System.out.println(docList.size());
			for(int i=0; i < docList.size(); i++)
			{
				CodeVo resArea = new CodeVo();
				SolrDocument doc = docList.get(i);
				resArea.setCodeValue(doc.get("code_value").toString());
				resArea.setCodeDisp(doc.get("code_disp").toString());

				if(doc.get("code_disp_eng") == null) resArea.setCodeDispEng("");
				else resArea.setCodeDispEng(doc.get("code_disp_eng").toString());

				resArea.setParentCode(doc.get("parent_code").toString());

				resArea.setChildCo(Integer.parseInt(doc.get("child_co").toString()));

				if(doc.get("child_co") == null) resArea.setChildCo(0);
				else resArea.setChildCo(Integer.parseInt(doc.get("child_co").toString()));
				resAreaList.add(resArea);
			}

		} catch (SolrServerException e) {
			
			e.printStackTrace();
		} catch (IOException e) {
			
			e.printStackTrace();
		}

		// 종료 시간
        long endTime = System.currentTimeMillis();
        System.out.println("##  종료시간 : " + formatTime(endTime));

        // 시간 출력
        System.out.println("##  소요시간(초.0f) : " + ( endTime - startTime )/1000.0f +"초");

	}

    private String formatTime(long lTime) {
        Calendar c = Calendar.getInstance();
        c.setTimeInMillis(lTime);
        return (c.get(Calendar.HOUR_OF_DAY) + "시 " + c.get(Calendar.MINUTE) + "분 " + c.get(Calendar.SECOND) + "." + c.get(Calendar.MILLISECOND) + "초");
    }    // end function formatTime()

}
