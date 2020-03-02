package kr.co.argonet.r2rims.jcr;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

import javax.annotation.Resource;

import org.json.JSONArray;
import org.json.JSONObject;
import org.junit.Test;

import kr.co.argonet.r2rims.AbstractApplicationContextTest;
import kr.co.argonet.r2rims.core.mapper.SubjectMapper;
import kr.co.argonet.r2rims.core.vo.SubjectVo;

public class FindJCRCategoriesTest extends AbstractApplicationContextTest {

	@Resource(name = "subjectMapper")
	private SubjectMapper subjectMapper;
	private static final String JCR_PRODCODE = "JCR_ALL";

	@Test
	public void getJcrCategories(){
		int jcrYear = 1997;
		for(int i = jcrYear; i < 2016; i++ )
		{
			JSONArray catArr = getJcrCategoryByJcrYear(i);
			if(catArr != null)
			{
				for(int j=0; j < catArr.length(); j++)
				{
					JSONObject data = (JSONObject) catArr.get(j);
					String catcode = data.getString("categoryId");
					String description = data.getString("categoryName");

					SubjectVo chkSubject = subjectMapper.findByProdcodeAndCatcodeAndDescription(JCR_PRODCODE, catcode, description);

					if(chkSubject != null && chkSubject.getId() != null)
					{
						System.out.println(JCR_PRODCODE + " : " + catcode + " : " + description + " >>> 존재함.");
					}
					else
					{
						SubjectVo  sbjt = new SubjectVo();
						sbjt.setCatcode(catcode);
						sbjt.setDescription(description);
						sbjt.setProdcode(JCR_PRODCODE);
						subjectMapper.add(sbjt);
					}
				}
			}
		}
	}


	private JSONArray getJcrCategoryByJcrYear(Integer jcrYear){

		String jcrUrl = "https://jcr.incites.thomsonreuters.com/AllCategoriesJson.action?_dc=1473230804360&jcrYear="+jcrYear+"&edition=Both&subjectCategoryScheme=WoS&oAFlag=N&page=1&start=0&limit=25";
		HttpURLConnection con = null;
		JSONArray jarr = null;
		   try {
			   System.out.println(jcrUrl);
	            String userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36";
			    URL url = new URL(jcrUrl);
				con = (HttpURLConnection) url.openConnection();

				// optional default is GET
				con.setRequestMethod("GET");

				//add request header
				con.setRequestProperty("User-Agent", userAgent);
				con.setRequestProperty("Accept", "text/html, application/xhtml+xml, */*");
				con.setRequestProperty("Accept-Language", "ko-KR,ko;q=0.8,en-US;q=0.6,en;q=0.4");
				con.setRequestProperty("Referer", "google.com");
				//con.setRequestProperty("Cookie", "jcrvisualization=hide; JSESSIONID=7598018EF8C00AD1E707A4F8DF1B580E; BIGipServerJCR-WEB-APP-1080=1379522314.14340.0000; jcr.breadCrumb=Home#./JCRJournalHomeAction.action?year=&edition=&journal=; jcr.cb1=true; jcr.cb2=true; jcr.cb3=true; jcr.cb4=true; jcr.cb5=true; jcr.cb6=true; jcr.cb7=true; jcr.cb8=true; jcr.cb9=true; jcr.cb10=true; jcr.cb11=true; jcr.cb12=true; jcr.cb13=true; jcr.cb14=true; jcr.journalHomeStickOAFlag=N; jcr.journalHomeStickEdition=SCIE; jcr.journalHomeStickFullJournalTitles=; jcr.journalHomeStickPublishers=; jcr.journalHomeStickCountries=; jcr.journalHomeStickCats=AA; jcr.journalHomeStickJifQuartile=undefined; jcr.journalHomeStickCatScheme=WoS; jcr.journalHomeStickImpactFrom=null; jcr.journalHomeStickImpactTo=null; jcr.journalHomeStickAverageJifFrom=null; jcr.journalHomeStickAverageJifTo=null; jcr.journalHomeStickJCRYear=2015; PSSID=\"A1-xxBx2FxxDSaqx2B0WJmbPH4mekXlji4x2BUTk3IO-18x2dvAECuxxfTKhIeA24DqhpckAx3Dx3DK3PCAiht8iqx2FGHtEGlmFMAx3Dx3D-YwBaX6hN5JZpnPCj2lZNMAx3Dx3D-jywguyb6iMRLFJm7wHskHQx3Dx3D\"; CUSTOMER=\"KAIST KOREA ADV INST OF SCI & TECH\"; E_GROUP_NAME=\"IC2 Platform\"");
				con.setRequestProperty("Cookie", "PSSID=\"A1-xxoGq4UVHVPRZx2BCXZpkVy7gPScHdgAAne-18x2dzx2BtGR6Fo1Xrsoix2BefrHXeAx3Dx3DeNxxbY5jxxOmu9xxjnlTmPVRQx3Dx3D-YwBaX6hN5JZpnPCj2lZNMAx3Dx3D-jywguyb6iMRLFJm7wHskHQx3Dx3D\"");

				//SID=A1-xxoGq4UVHVPRZx2BCXZpkVy7gPScHdgAAne-18x2dzx2BtGR6Fo1Xrsoix2BefrHXeAx3Dx3DeNxxbY5jxxOmu9xxjnlTmPVRQx3Dx3D-YwBaX6hN5JZpnPCj2lZNMAx3Dx3D-jywguyb6iMRLFJm7wHskHQx3Dx3D&SrcApp=IC2LS&Init=Yes#

				int responseCode = con.getResponseCode();
				System.out.println("\nSending 'GET' request to URL : " + jcrUrl);
				System.out.println("Response Code : " + responseCode);

				BufferedReader in = new BufferedReader(
				        new InputStreamReader(con.getInputStream()));
				String inputLine;
				StringBuffer response = new StringBuffer();

				while ((inputLine = in.readLine()) != null) {
					response.append(inputLine);
				}
				in.close();

				//print result
				System.out.println(response.toString());

				JSONObject obj = new JSONObject(response.toString());

				System.out.println(obj.get("totalCount"));
				System.out.println(obj.get("status"));

				if(Integer.parseInt(obj.get("totalCount").toString()) > 0 && "SUCCESS".equals(obj.get("status")))
					jarr = (JSONArray) obj.get("data");

				/*
				for(int i=0; i < jarr.length(); i++)
				{
					JSONObject data = (JSONObject) jarr.get(i);
					System.out.println(data.get("categoryId") + " : " + data.get("categoryName"));
					//System.out.println(data.get("categoryName"));
				}
				*/

			} catch (Exception e) {

			} finally {
				if(con != null) con.disconnect();
			}

		   return jarr;
	}

}
