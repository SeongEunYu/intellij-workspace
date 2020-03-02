<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@include file="../../pageInit.jsp" %>
<script type="text/javascript" src="${contextPath}/js/mainLayout.js"></script>
<script type="text/javascript">
var dhxLayout, myGrid, t;
$(document).ready(function(){

	setMainLayoutHeight($('#mainLayout'));
	if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
	else  window.addEventListener("resize",resizeLayout, false);
	//set layout
	dhxLayout = new dhtmlXLayoutObject("mainLayout","1C");
	dhxLayout.cells("a").hideHeader();
	dhxLayout.setSizes(false);

	myGrid = dhxLayout.cells("a").attachGrid();
	myGrid.setImagePath("${dhtmlXImagePath}");
	myGrid.setHeader("No,게재년월,논문명,저널명,사용자ID,저자명,처리상태", null, grid_head_center_bold);
	myGrid.setColumnIds("No,pblcYm,orgLangPprNm,scjnlNm,userId,korNm,isMig");
	myGrid.setInitWidths("40,100,*,150,90,90,70");
	myGrid.setColAlign("center,center,left,left,center,center,center");
	myGrid.setColSorting("int,str,str,str,str,str,str");
	myGrid.setColTypes("ro,ro,ro,ed,ed,ed,ed");
	//myGrid.setColumnColor("#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF");
	myGrid.setEditable(false);
	myGrid.attachEvent("onRowSelect",myGrid_onRowSelect);
	myGrid.attachEvent("onBeforeSorting",myGrid_onBeforeSorting);
	myGrid.attachEvent("onXLS", doBeforeGridLoad);
	myGrid.attachEvent("onXLE", doOnGridLoaded);
	//myGrid.attachEvent("onPaging",changeRowColor);
    myGrid.enablePaging(true,100,30,"pagingArea",true);
    myGrid.setPagingSkin("${dhtmlXPagingSkin}");
	myGrid.enableColSpan(true);
	myGrid.init();
	myGrid_load();
});

function myGrid_load(){
	var url = getGridRequestURL();
	myGrid.clearAndLoad(url);
}

function getGridRequestURL(){
	var url = "${contextPath}/kriCntc/nkrdd505TrgetList.do?q=kri_add_main";
	url += "&" + $('#srchFrm').serialize();
	return url;
}

function myGrid_onBeforeSorting(ind,type,direct){
	var url = getGridRequestURL();
	myGrid.clearAndLoad(url+"&orderby="+(myGrid.getColumnId(ind))+"&direct="+direct);
	myGrid.setSortImgState(true,ind,direct);
	return false;
}

function myGrid_onRowSelect(rowId,celInd){
	var param = "&mngNo="+rowId;

	var wWidth = 1100;
	var wHeight = (screenHeight - 100);
	var leftPos = (screenWidth - wWidth)/2;
	var topPos = 0;
	if(rowID == '0') return;

	var importPopup = window.open('about:blank', 'articlePopup', 'width='+wWidth+',height='+wHeight+',top='+topPos+',left='+leftPos+' location=no,scrollbars=yes,resizable=yes');
	var popFrm = $('#popFrm');
	popFrm.empty();
	popFrm.attr('action', '${contextPath}//articlePopup.do');
	popFrm.attr('target', 'articlePopup');
	popFrm.attr('method', 'POST');
	popFrm.submit();
	importPopup.focus();

}

function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){ setMainLayoutHeight($('#mainLayout')); dhxLayout.setSizes(false); },10);}
function doOnGridLoaded(){setTimeout(function() {dhxLayout.cells("a").progressOff();}, 100);}
function doBeforeGridLoad(){dhxLayout.cells("a").progressOn();}

</script>
</head>
<body>
	<div class="title_box">
		<h3>KRI 논문반입</h3>
	</div>
	<div class="contents_box">
		<form id="srchFrm" name="srchFrm" method="POST">
		<table class="view_tbl mgb_10">
			<colgroup>
				<col style="width:14%"/>
				<col style="width:35%"/>
				<col style="width:14%"/>
				<col />
				<col style="width:50px;"/>
			</colgroup>
			<tbody>
				<tr>
					<th>논문명</th>
					<td><input type="text" style="width:100%;" id="mask_article_ttl" class="input_type"></td>
					<th>작업상태</th>
					<td>
						<input type="radio" name="mask_pos" id="mask_pos_all" value="ALL" checked="checked" class="radio" onchange="javascript:myGRID_load();">
						<label for="mask_pos_all" class="radio_label">전체</label>
						<input type="radio" name="mask_pos" id="mask_pos_N" value="N" class="radio" onchange="javascript:myGRID_load();">
						<label for="mask_pos_N" class="radio_label">미작업</label>
						<input type="radio" name="mask_pos" id="mask_pos_Y" value="Y" class="radio" onchange="javascript:myGRID_load();">
						<label for="mask_pos_Y" class="radio_label">작업완료</label>
						<input type="radio" name="mask_pos" id="mask_pos_E" value="E" class="radio" onchange="javascript:myGRID_load();">
						<label for="mask_pos_E" class="radio_label">작업제외</label>
					</td>
					<td class="option_search_td" onclick="javascript: myGrid_load();"><em>search</em></td>
				</tr>
			</tbody>
		</table>
	</div>

	<div id="mainLayout" style="position: relative; width: 100%;height: 100%;"></div>
	<div id="pagingObj" style="z-index: 1; height: 60px; margin-top: 5px;" >
		<div id="pagingArea" style="z-index: 1;"></div>
	</div>
</body>
</html>