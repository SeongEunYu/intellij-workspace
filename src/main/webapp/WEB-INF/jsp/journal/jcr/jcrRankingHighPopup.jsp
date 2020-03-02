<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@include file="../../pageInit.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${sysConf['system.rims.jsp.title']}</title>
<link type="text/css" href="${contextPath}/css/layout.css" rel="stylesheet" />
<link type="text/css" href="${contextPath}/js/dhtmlx/skins/${sysConf['dhtmlx.skin']}/dhtmlx.css" rel="stylesheet" />
<script type="text/javascript" src="${contextPath}/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="${contextPath}/js/dhtmlx/dhtmlx.js"></script>
<script type="text/javascript" src="${contextPath}/js/script.js"></script>
<script type="text/javascript" src="${contextPath}/js/mainLayout.js"></script>
<script type="text/javascript">
var dhxLayout, jcrGrid, t;
$(document).ready(function(){

	setMainLayoutHeight($('#mainLayout'), -110);
	if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
	else  window.addEventListener("resize",resizeLayout, false);
	//set layout
	dhxLayout = new dhtmlXLayoutObject("mainLayout","1C");
	dhxLayout.cells("a").hideHeader();
	dhxLayout.setSizes(false);
	jcrGrid = dhxLayout.cells("a").attachGrid();
	jcrGrid.setImagePath("${dhtmlXImagePath}");
	jcrGrid.setHeader("Year,Journal Name,ISSN,Category Description,I.F,I.F(%)순위", null, grid_head_center_bold);
	jcrGrid.setColumnIds("prodYear,title,issn,cateDesc,impact,ratio");
	jcrGrid.setInitWidths("70,*,100,180,100,100");
	jcrGrid.setColAlign("center,left,center,left,center,center");
	jcrGrid.setColSorting("server,server,server,server,server,server");
	jcrGrid.attachEvent("onBeforeSorting",jcrGrid_onBeforeSorting);
	jcrGrid.setColTypes("ro,ro,ro,ro,ro,ro");
	jcrGrid.attachEvent("onPageChanged",doBeforeGridLoad);
	jcrGrid.attachEvent("onPaging",doOnGridLoaded);
	jcrGrid.enablePaging(true,100,10,"pagingArea",true);
	jcrGrid.setPagingSkin("${dhtmlXPagingSkin}");
	jcrGrid.init();
	jcrGrid_load();
});

function jcrGrid_load(){
	doBeforeGridLoad();
	var url = getGridRequestURL();
	jcrGrid.clearAndLoad(url, doOnGridLoaded);
}

function jcrGrid_onBeforeSorting(ind,type,direct){
	var url = getGridRequestURL();
	jcrGrid.clearAndLoad(url+"&orderby="+(jcrGrid.getColumnId(ind))+"&direct="+direct);
	jcrGrid.setSortImgState(true,ind,direct);
	return false;
}

function getGridRequestURL(){
	var url = '<c:url value="/${preUrl}/jcr/findJcrRankingList.do" />';
	url = comAppendQueryString(url,"maskRatio",	encodeURIComponent( $("#maskRatio").val() ));
	url = comAppendQueryString(url,"maskYear",	encodeURIComponent( $("#maskYear").val() ));
	url = comAppendQueryString(url,"maskCateg",	encodeURIComponent( $("#maskCateg").val() ));
	return url;
}
function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){ dhxLayout.setSizes(false); },200);}
function doOnGridLoaded(){setTimeout(function() {dhxLayout.cells("a").progressOff();}, 100);}
function doBeforeGridLoad(){dhxLayout.cells("a").progressOn();}
</script>

</head>
<body>

	<!-- Page Title -->
	<div class="title_box">
		<h3><spring:message code='jcr.popup.title'/></h3>
	</div>

	<!-- Main Content -->
	<div class="formObj">
		<form id="searchForm" name="searchForm" method="post">
			<table class="view_tbl mgb_10">
				<colgroup>
					<col style="width: 10%"/>
					<col style="width: 15%"/>
					<col style="width: 10%"/>
					<col style="width: 15%"/>
					<col style="width: 10%"/>
					<col />
					<col style="width: 50px;"/>
				</colgroup>
				<tbody>
					<tr>
						<th>Year</th>
						<td>
							<select id="maskYear" name="maskYear" style="width: 60px;font-family: Arial;font-size: 9pt;">
								<c:if test="${not empty prodyearList}">
									<c:forEach items="${prodyearList}" var="tl" varStatus="st">
											<option value="${tl.prodyear }" ${tl.prodyear eq param.maskYear ?'selected=\"selected\"':'' }>${tl.prodyear  }</option>
									</c:forEach>
								</c:if>
							</select>
						</td>
						<th>Percentile</th>
						<td>
							<input type="text" name="maskRatio" id="maskRatio"  value="${param.maskRatio}" style="height:17px; width:120px;">
						</td>
						<th>Category</th>
						<td>
							<select id="maskCateg" name="maskCateg" style="width: 200px; margin-top: 5px;" >
								<option value="" selected="selected"></option>
								<c:if test="${not empty categList}">
									<c:forEach items="${categList}" var="tl" varStatus="st">
											<option value="${tl.catcode }" ${tl.catcode == param.maskCateg ? "selected=\"selected\"" : ""} >${tl.description  }</option>
									</c:forEach>
								</c:if>
							</select>
						</td>
						<td class="option_search_td" onclick="javascript:jcrGrid_load();"><em>search</em></td>
					</tr>
				</tbody>
			</table>
		</form>
	</div>

	<div id="mainLayout" style="position: relative; width: 100%;height: 100%;"></div>
	<div id="pagingObj" style="z-index: 1; height: 60px; margin-top: 5px;" >
		<div id="pagingArea" style="z-index: 1;"></div>
	</div>
</body>
</html>