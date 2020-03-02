<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%><!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${sysConf['system.rims.jsp.title']} No Authority</title>
<%@include file="../pageInit.jsp" %>
<link type="text/css" href="${pageContext.request.contextPath}/js/dhtmlx/skins/${sysConf['dhtmlx.skin']}/dhtmlx.css" rel="stylesheet" />
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/dhtmlx/dhtmlx.js"></script>
<script type="text/javascript">
$(document).ready(function()
{
	dhtmlx.alert({type:"alert-error",text:"${msg}",callback:function(){
		top.window.close();
	}})
});
</script>
</head>
<body>
</body>
</html>
