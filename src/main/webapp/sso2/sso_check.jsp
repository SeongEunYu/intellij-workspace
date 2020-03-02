<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.commons.lang3.StringUtils" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.springframework.context.ApplicationContext" %>
<%@ page import="org.springframework.web.context.ContextLoaderListener" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery/jquery-1.11.3.min.js"></script>
	<%

		ApplicationContext context = ContextLoaderListener.getCurrentWebApplicationContext();
		Properties sysConf = (Properties) context.getBean("sysConf");

		String  ssoServerUrl = sysConf.getProperty("iam.sso.server.url");
		String  ssoClientId = sysConf.getProperty("iam.sso.client.id");
		String  ssoClientSecret =  sysConf.getProperty("iam.sso.client.secret");
		String  redirectUrl = sysConf.getProperty("system.url") + "/rims/sso2/RIMS_autologin.jsp";

		String userId = "";
		String stdNo = "";
		String uId = "";

		//파라미터 체크
		String success = request.getParameter("success");

		if(StringUtils.isNotBlank(success) && "true".equals(success)) //로그인 정보 존재하는 경우
		{
			/*
			*
			*  {"dataMap":{"USER_INFO":{"kaist_uid":"00081582","ku_home_phone":null,"c":"KOR","telephoneNumber":null,"facsimiletelephonenumber":null,"mail":null,"ku_employee_number":null,"ku_sex":"M","postalCode":"34036","mobile":"010-3237-4391","ku_kname":"김호진","ku_std_no":null,"uid":"argonet2","ku_position_kor":null,"ku_postaladdress2":"2층","givenname":"Kim","ku_postaladdress1":"대전광역시 유성구 테크노10로 51 ( 탑립동 )","ku_campus":"/","sn":"Ho Jin","ku_user_status_kor":null}},"error":false,"errorCode":null,"errorMessage":null}
			*
			* */

			String result = request.getParameter("result");
			System.out.println("result >>> \n" + result);

			JSONObject resultJson = new JSONObject(result);
			if(resultJson != null)
			{
				JSONObject userInfo = resultJson.getJSONObject("dataMap").getJSONObject("USER_INFO");
				if(userInfo.has("ku_std_no") &&  userInfo.get("ku_std_no") != null)
					stdNo = Objects.toString(userInfo.get("ku_std_no"));
				if(userInfo.has("ku_employee_number") && userInfo.get("ku_employee_number") != null)
					userId = Objects.toString(userInfo.get("ku_employee_number"));
				if(userInfo.has("kaist_uid") && userInfo.get("kaist_uid") != null)
					uId = Objects.toString(userInfo.get("kaist_uid"));
	%>
	<script type="text/javascript">
		$(document).ready(function(){
			var ssoUserId = "<%=userId%>";
			var ssoStdNo = "<%=stdNo%>";
			var ssoUId = "<%=uId%>";
			$('#ssoUserId').val(ssoUserId);
			$('#ssoStdNo').val(ssoStdNo);
			$('#ssoUId').val(ssoUId);
			$('#formArea').submit();
		});
	</script>
	<%
	}
	else // 사용자 정보가 없는 경우
	{
	%>
	<script type="text/javascript">
		$(document).ready(function(){ $('#formIam').submit(); });
	</script>
	<%
		}
	}
	else
	{
	%>
	<script type="text/javascript">
		$(document).ready(function(){ $('#formIam').submit(); });
	</script>
	<%
		}
	%>
</head>
<body>
<form id="formArea" action="${pageContext.request.contextPath}/index/ssologin.do" method="post">
	<input type="hidden" name="userId" id="ssoUserId"/>
	<input type="hidden" name="stdNo" id="ssoStdNo"/>
	<input type="hidden" name="uId" id="ssoUId"/>
</form>
<form id="formIam" action="<%=ssoServerUrl%>" method="post">
	<input type="hidden" name="client_id" value="<%=ssoClientId%>" />
	<input type="hidden" name="client_secret" value="<%=ssoClientSecret%>" />
	<input type="hidden" name="redirect_url" value="<%=redirectUrl%>" />
</form>
</body>
</html>