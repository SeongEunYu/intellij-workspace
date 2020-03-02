<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="../pageInit.jsp" %>
<script type="text/javascript" src="${contextPath}/js/mainLayout.js"></script>
<script type="text/javascript">
var dhxLayout, myTabbar, t;
$(document).ready(function(){
	setMainLayoutHeight($('#mainLayout'), -40);
	if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
	else  window.addEventListener("resize",resizeLayout, false);
	//set layout
	dhxLayout = new dhtmlXLayoutObject("mainLayout","1C");
	dhxLayout.cells("a").hideHeader();
	dhxLayout.setSizes(false);
	myTabbar = dhxLayout.cells("a").attachTabbar();
	myTabbar.setArrowsMode("auto");
	myTabbar.enableAutoReSize(true);
	myTabbar.addTab('a1','<spring:message code="menu.notice"/>');
	myTabbar.addTab('a2','<spring:message code="menu.manual"/>');
	myTabbar.addTab('a3','<spring:message code="menu.scilist"/>');
	myTabbar.tabs('a1').attachObject('noticeArea');
	myTabbar.cells('a1').showInnerScroll();
	myTabbar.tabs('a2').attachObject('manualArea');
	myTabbar.cells('a2').showInnerScroll();
	myTabbar.tabs('a3').attachObject('scilistArea');
	myTabbar.cells('a3').showInnerScroll();
	<c:if test="${param.cateId eq '1'}">
	myTabbar.tabs('a1').setActive();
	</c:if>
	<c:if test="${param.cateId eq '2'}">
	myTabbar.tabs('a2').setActive();
	</c:if>
	<c:if test="${param.cateId eq '3'}">
	myTabbar.tabs('a3').setActive();
	</c:if>
});
function resizeLayout() {window.clearTimeout(t);t = window.setTimeout(function() {setMainLayoutHeight($('#mainLayout'), -40);dhxLayout.setSizes(false);}, 80);}
</script>
</head>
<body>
<div class="title_box">
	<h3><spring:message code='menu.resource'/></h3>
</div>
<div class="contents_box">
	<div id="noticeArea" style="overflow: auto;width: 100%;height: 100%;">
		<script type="text/javascript" src="https://board.kaist.ac.kr/javascript/apiboard.jsp?boardId=ri_notice&bltnCateId1=1&langKnd=${pageContext.response.locale eq 'ko'?'ko':'en'}&isMobile=0"></script>
	</div>
	<div id="manualArea" style="overflow: auto;width: 100%;height: 100%;">
		<script type="text/javascript" src="https://board.kaist.ac.kr/javascript/apiboard.jsp?boardId=ri_notice&bltnCateId1=2&langKnd=${pageContext.response.locale eq 'ko'?'ko':'en'}&isMobile=0"></script>
	</div>
	<div id="scilistArea" style="overflow: auto;width: 100%;height: 100%;">
		<script type="text/javascript" src="https://board.kaist.ac.kr/javascript/apiboard.jsp?boardId=ri_notice&bltnCateId1=3&langKnd=${pageContext.response.locale eq 'ko'?'ko':'en'}&isMobile=0"></script>
	</div>
	<div id="mainLayout" style="position: relative; width: 100%;height: 100%;"></div>
</div>
</body>
</html>