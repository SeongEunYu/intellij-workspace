<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
<script type="text/javascript">
var dhxLayout, sjrGrid, sbjtGrid, t;

$(document).ready(function(){
	if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
	else  window.addEventListener("resize",resizeLayout, false);
	//set layout
	dhxLayout = new dhtmlXLayoutObject("mainLayout","1C");
	dhxLayout.cells("a").hideHeader();
	dhxLayout.setSizes(false);
	sjrGrid = dhxLayout.cells("a").attachGrid();
	sjrGrid.setImagePath("${dhtmlXImagePath}");
	sjrGrid.setHeader("Year,Journal Name,ISSN,Category Description,SJR,<spring:message code='grid.sjr1'/>", null, grid_head_center_bold);
	sjrGrid.setColumnIds("prodyear,title,issn,cateDesc,sjr,ratio");
	sjrGrid.setInitWidths("70,240,100,180,100,100");
	sjrGrid.setColAlign("center,left,center,left,center,center");
	sjrGrid.setColTypes("ro,ro,ro,ro,ro,ro");
	sjrGrid.setColSorting("na,server,server,na,server,server");
	sjrGrid.attachEvent("onBeforeSorting",sjrGrid_onBeforeSorting);
	sjrGrid.attachEvent("onPageChanged",doBeforeGridLoad);
	sjrGrid.attachEvent("onPaging",doOnGridLoaded);
	sjrGrid.enablePaging(true,100,10,"pagingArea",true);
	sjrGrid.setPagingSkin("${dhtmlXPagingSkin}");
	sjrGrid.init();
	sjrGrid_load();

});
function sjrGrid_load(){
	doBeforeGridLoad();
	var url = getGridRequestURL();
	sjrGrid.clearAndLoad(url, doOnGridLoaded);
}

function getGridRequestURL(){
	var url = '<c:url value="/${preUrl}/sjr/findSjrRankingList.do"/>';
	url = comAppendQueryString(url,"maskRatio",	encodeURIComponent( $("#maskRatio").val() ));
	url = comAppendQueryString(url,"maskYear",	encodeURIComponent( $("#maskYear").val() ));
	url = comAppendQueryString(url,"maskCateg",	encodeURIComponent( $("#maskCateg").val() ));
	return url;
}

function sjrGrid_onBeforeSorting(ind,gridObj,direct){
	var url = getGridRequestURL();
	sjrGrid.clearAndLoad(url+"&orderby="+(sjrGrid.getColumnId(ind))+"&direct="+direct);
	sjrGrid.setSortImgState(true,ind,direct);
	return false;
}
function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){ dhxLayout.setSizes(false); },200);}
function doOnGridLoaded(){setTimeout(function() {dhxLayout.cells("a").progressOff();}, 100);}
function doBeforeGridLoad(){dhxLayout.cells("a").progressOn();}

function onChangeArea(){
	$.ajax({
		url: '<c:url value="/${preUrl}/sjr/findCategoryListByAreaCodeAjax.do"/>',
		dataType: "json",
		method: "POST",
		data: {"maskArea":$('#maskArea').val()},
		success: function(data,textStatus,jqXHR){}
	}).done(function(data){
		if(data != null && data.length > 0)
		{
			$('#maskCateg > option').remove();
			$('#maskCateg').append($('<option value="">All categories of selected Area</option>'));
			for(var i=0; i < data.length; i++)
			{
				$('#maskCateg').append($('<option value="'+data[i].catcode+'">'+data[i].description+'</option>'))
			}
			sjrGrid_load();
		}
	});
}

</script>
</head>
<body>

	<!-- Page Title -->
	<div class="title_box">
		<h3><spring:message code='sjr.popup.title'/></h3>
	</div>

	<!-- Main Content -->
	<div class="formObj">
		<form id="searchForm" name="searchForm" method="post">
			<table class="view_tbl mgb_10">
				<colgroup>
					<col style="width: 15%"/>
					<col style="width: 35%"/>
					<col style="width: 15%"/>
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
						<th>순위</th>
						<td>
							<input type="text" name="maskRatio" id="maskRatio"  value="${param.maskRatio }" style="height:16px; width:120px;">
						</td>
						<td rowspan="2" class="option_search_td" onclick="javascript:sjrGrid_load();"><em>search</em></td>
					</tr>
					<tr>
						<th>Subject Area</th>
						<td>
							<select id="maskArea" name="maskArea" style="width: 90%;font-family: Arial;font-size: 9pt;" onchange="javascript:onChangeArea();">
								<option value=""><spring:message code='common.option.select'/></option>
								<c:if test="${not empty areaList}">
									<c:forEach items="${areaList}" var="tl" varStatus="st">
											<option value="${tl.catcode }">${tl.description  }</option>
									</c:forEach>
								</c:if>
							</select>
						</td>
						<th>Subject Category</th>
						<td>
							<select id="maskCateg" name="maskCateg" style="width: 90%;font-family: Arial;font-size: 9pt;" onchange="javascript:sjrGrid_load();">
								<option value=""><spring:message code='common.option.select'/></option>
								<c:if test="${not empty categList}">
									<c:forEach items="${categList}" var="cl" varStatus="st">
											<option value="${cl.catcode }">${cl.description  }</option>
									</c:forEach>
								</c:if>
							</select>
						</td>
					</tr>
				</tbody>
			</table>
		</form>
	</div>
	<div id="mainLayout" style="position: relative; width: 100%;height: 100%;"></div>
	<script type="text/javascript">setMainLayoutHeight($('#mainLayout'));</script>
	<div id="pagingObj" style="z-index: 1; height: 60px; margin-top: 5px;" >
		<div id="pagingArea" style="z-index: 1;"></div>
	</div>
</body>
</html>