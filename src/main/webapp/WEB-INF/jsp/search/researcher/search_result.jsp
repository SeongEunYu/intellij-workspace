<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="../../pageInit.jsp" %>
<script type="text/javascript" src="${contextPath}/js/mainLayout.js"></script>
<script type="text/javascript" src="${contextPath}/js/jquery/jquery.filedownload.js"></script>
<script type="text/javascript">
var dhxLayout, myGrid, t;
$(document).ready(function(){
	if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
	else  window.addEventListener("resize",resizeLayout, false);
	//set layout
	dhxLayout = new dhtmlXLayoutObject("mainLayout","1C");
	dhxLayout.cells("a").hideHeader();
	dhxLayout.setSizes(false);

	myGrid = dhxLayout.cells("a").attachGrid();
	myGrid.setImagePath("${dhtmlXImagePath}");
	myGrid.setHeader("no,Name,Name(Eng),Department,Position,Research Area(Korean),Research Area(English)",null,grid_head_center_bold);
	myGrid.setColumnIds("no,korNm,engNm,groupDept,posiNm,");
	myGrid.setInitWidths("50,150,250,250,150,*,*");
	myGrid.setColAlign("center,center,left,left,center,left,left");
	myGrid.setColTypes("ro,ro,ro,ro,ro,ro,ro");
	myGrid.setColSorting("na,na,na,na,na,na,na");
	myGrid.attachEvent("onXLS", doBeforeGridLoad);
	myGrid.attachEvent("onXLE", doOnGridLoaded);
	myGrid.attachEvent("onRowSelect", myGrid_onRowSelect);
	//myGrid.attachEvent("onBeforeSorting", myGrid_onBeforeSorting);
	myGrid.setPagingSkin("${dhtmlXPagingSkin}");
	myGrid.enableMultiselect(true);
	myGrid.enableColSpan(true);
	myGrid.init();
	myGrid_load();
});
function myGrid_load(){
	var url = getGridRequestURL();
	myGrid.clearAndLoad(url);
}
function myGrid_onBeforeSorting(ind,type,direct){
	var url = getGridRequestURL();
	myGrid.clearAndLoad(url+"&orderby="+(myGrid.getColumnId(ind))+"&direct="+direct);
	myGrid.setSortImgState(true,ind,direct);
	return false;
}
function getGridRequestURL(){
	var url = "${contextPath}/search/findResearcherList.do";
	url = comAppendQueryString(url,"appr",	'<c:out value="${param.appr}"/>');
	url += "&"  + $('#formArea').serialize();
	return url;
}

function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){ dhxLayout.setSizes(false); },200);}
function doOnGridLoaded(){setTimeout(function() {dhxLayout.cells("a").progressOff();}, 100);}
function doBeforeGridLoad(){dhxLayout.cells("a").progressOn();}

function myGrid_onRowSelect(rowID,celInd){
	var wWidth = 949;
	var wHeight = 852;
	var leftPos = (screenWidth - wWidth)/2;
	var topPos = (screenHeight - wHeight)/2;
	if(rowID == '0') return;
	var str = rowID.split('_');
	var mappingPopup = window.open('about:blank', 'articlePopup', 'width='+wWidth+'px,height='+wHeight+'px,top='+topPos+',left='+leftPos+' location=no,scrollbars=yes,resizable=yes');
	var popFrm = $('#popFrm');
	popFrm.empty();
	popFrm.append($('<input type="hidden" name="srchUserId" value="'+str[1]+'"/>'));
	popFrm.attr('action', '${contextPath}/search/researcherInfoPopup.do');
	popFrm.attr('target', 'articlePopup');
	popFrm.attr('method', 'POST');
	popFrm.submit();
	mappingPopup.focus();
}
</script>
</head>
<body>

	<div class="title_box">
		<h3>검색결과</h3>
	</div>
	<div class="contents_box">
		<!-- START 테이블 1 -->
		<form id="formArea" onsubmit="return false;">
			<table class="view_tbl mgb_10" >
				<colgroup>
					<col style="width: 15%;"/>
					<col style="width: 37%;"/>
					<col style="width: 15%;"/>
					<col />
					<col style="width: 50px;"/>
				</colgroup>
				<tbody>
				<tr>
					<th>검색어</th>
					<td colspan="3">
						<input type="text" id="srchKeyword" name="srchKeyword" class="input_type" value="<c:out value="${param.keyword}"/>" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();" />
					</td>
					<td class="option_search_td" onclick="javascript:myGrid_load();"><em>search</em></td>
				</tr>
				</tbody>
			</table>
		</form>
		<!--
		<div class="list_bt_area">
			<div class="list_set">
				<ul>
					<li><a href="#" onclick="javascript:toExcel();" class="list_icon20">엑셀</a></li>
				</ul>
			</div>
		</div>
		 -->
		<!-- layout (grid,paging)  -->
		<div id="mainLayout" style="position: relative; width: 100%;height: 100%;"></div>
		<script type="text/javascript">setMainLayoutHeight($('#mainLayout'));</script>
		<div id="pagingObj" style="z-index: 1; height: 40px; margin-top: 5px;" >
			<div id="pagingArea" style="z-index: 1;"></div>
		</div>
 	</div>
</body>
</html>