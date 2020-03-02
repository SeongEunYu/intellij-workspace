<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%><!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${sysConf['system.rims.jsp.title']} Session Out</title>
<%@include file="../pageInit.jsp" %>
<link rel="shortcut icon" href="${pageContext.request.contextPath}/images/${sysConf['shortcut.icon']}">
<link type="text/css" href="${pageContext.request.contextPath}/css/errorpage.css" rel="stylesheet" />
<link type="text/css" href="${pageContext.request.contextPath}/js/dhtmlx/skins/${sysConf['dhtmlx.skin']}/dhtmlx.css" rel="stylesheet" />
<style type="text/css">
.error_box { width: 650px; margin: 0 auto; background: url(../images/common/error_icon.png) no-repeat 50% 38px; padding: 220px 0 0 0;}
.error_box .top_error_text { border-top: 1px solid #95c8e0; font-size: 17px; font-weight: bold; color: #3b3b3b; padding: 20px 0 0 0; margin-bottom: 20px;}
.error_box .top_error_text strong { font-size: 23px; color: #305eb3; display: block; }
</style>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/dhtmlx/dhtmlx.js"></script>
<script type="text/javascript">
$(document).ready(function()
{
	window.setTimeout(function(){ location.href = "${sysConf['system.url']}";   },1000);
	/*
	dhtmlx.alert({type:"alert-error",text:"${msg}",callback:function(){
		top.window.close();
	}})
	*/
});
</script>
</head>
<body>
	<div class="error_wrap">
		<div class="error_box">
			<div class="top_error_text">
				<strong>세션종료되었습니다.</strong>
			</div>
			<div class="error_text_box">
			</div>
		</div>
	</div>

</body>
</html>
