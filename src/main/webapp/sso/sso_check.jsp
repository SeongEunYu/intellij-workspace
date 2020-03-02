<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="org.apache.commons.lang.ObjectUtils"%>
<%@page import="java.io.*, javax.servlet.*, java.util.*, javax.servlet.http.*"%>
<%
	String contextPath = request.getContextPath();
	Cookie[] cookie = request.getCookies();
	String cookieName = "ObSSOCookie";
	int cookieFind = -1;
	// 해당 쿠기가 있는지 확인한다.
	for (int i = 0; i < cookie.length; i++) {
		if (cookie[i].getName().equals(cookieName)) {
			cookieFind = i;
			break;
		} // End if
	} // End For
	String sso_cookie = "";
	if (cookieFind != -1) {
		sso_cookie = cookie[cookieFind].getValue();
		if (!sso_cookie.equals("logouted") || sso_cookie.length() > 50) {
			String userId = ObjectUtils.toString(request.getHeader("EMPLOYEE_NUMBER"));
			String stdNo = ObjectUtils.toString(request.getHeader("STD_NO"));
			String uId = ObjectUtils.toString(request.getHeader("KAIST_UID"));
			//IndexController.user_id 	= ObjectUtils.toString(request.getHeader("EMPLOYEE_NUMBER"));
			//IndexController.std_id 		= ObjectUtils.toString(request.getHeader("STD_NO"));
			//IndexController.u_id 		= ObjectUtils.toString(request.getHeader("KAIST_UID"));
			//IndexController.IP 			= ObjectUtils.toString(request.getHeader("X-Forwarded-For"));
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery/jquery-1.11.3.min.js"></script>
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
	} else {
%>
<script type="text/javascript">
	location.href = "/sso/RIMS_autologin.jsp";
</script>
<%
	}
	} else {
%>
<script type="text/javascript">
	location.href = "/sso/RIMS_autologin.jsp";
</script>
<%
	} // End if
%>
</head>
<body>
	<form id="formArea" action="${pageContext.request.contextPath}/index/ssologin.do" method="post">
		<input type="hidden" name="userId" id="ssoUserId"/>
		<input type="hidden" name="stdNo" id="ssoStdNo"/>
		<input type="hidden" name="uId" id="ssoUId"/>
	</form>
</body>
</html>