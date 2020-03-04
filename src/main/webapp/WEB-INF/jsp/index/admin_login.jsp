<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<title>${sysConf['system.rss.jsp.title']} 로그인</title>
<%@include file="../pageInit.jsp" %>
<link rel="shortcut icon" href="${pageContext.request.contextPath}/images/${sysConf['shortcut.icon']}">
<link type="text/css" href="${contextPath}/js/dhtmlx/skins/${sysConf['dhtmlx.skin']}/dhtmlx.css" rel="stylesheet" />
<script type="text/javascript" src="${contextPath}/js/dhtmlx/dhtmlx.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript">
$(document).ready(function()
{
	if("${sysConf['login.page.used.at']}" == 'N'){
		$('body').empty().removeClass('login_wrap');
		location.href = "${sysConf['system.url']}";
	}
	<c:if test="${not empty msg}">
		dhtmlx.alert({type:"alert-error",text:"${msg}",callback:function(){}})
	</c:if>
	//$('#id').focus();
});
function loginClick(){ if (event.keyCode == 13) $('#loginForm').submit(); }
</script>
<link href="${pageContext.request.contextPath}/css/layout.css" rel="stylesheet" type="text/css"/>
</head>
<body class="login_wrap">
<form action="${pageContext.request.contextPath}/login.do" name="login_form" id="loginForm" method="post" onkeypress="loginClick();">
	<div class="login_box">
		<%--<h1>${sysConf['system.abbr']}<span>${sysConf['system.full']}</span></h1>--%>
		<h1>RSS<span>Research Support System</span></h1>
		<div class="login_inner">
			<h2>Member Login</h2>
			<div class="login_int_box">
				<dl>
				<dt>아이디</dt>
				<dd><input type="text" name="id" id="id" style="height:19px; width:220px;" /></dd>
				</dl>
				<dl class="pw_int_dl">
				<dt>비밀번호</dt>
				<dd><input type="password" name="pwd" id="pwd" style="height:19px; width:220px;" autocomplete="off"/></dd>
				</dl>
				<a href="#" class="login_btn" onclick="javascript:$('#loginForm').submit();">Log in</a>
			</div>
		</div>
	</div>
	<span class="deco_box"></span>
	<span class="bottom_span"></span>
</form>
</body>
</html>
