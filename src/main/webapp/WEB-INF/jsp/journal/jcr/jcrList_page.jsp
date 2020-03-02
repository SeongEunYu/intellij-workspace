<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>JCR List </title>
<%@include file="../../pageInit.jsp" %>
<script type="text/javascript" src="${contextPath}/js/mainLayout.js"></script>
<script type="text/javascript">
    $(document).ready(function(){
        setMainLayoutHeight($('#mainLayout'),-50);
        $("iframe").prop("src", "${sysConf['s2journal.page.url']}/rank/jcr/list.do?key=${sysConf['s2journal.api.key']}&frameWidth=&frameHeight=");
    });
</script>
</head>
<body style="overflow-y: hidden;">
	<!-- Page Title -->
	<div class="title_box">
		<h3><spring:message code='menu.jcr.list'/></h3>
	</div>
	<!-- Main Content -->
	<div class="contents_box">
		<div id="mainLayout" style="position: relative; width: 100%;height: 100%;">
			<iframe width="100%" height="100%" scrolling="no" src="" frameborder="0" style="display:block;"></iframe>
		</div>
	</div>

</body>
</html>