<%@page import="kr.co.argonet.r2rims.util.LanguageUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="../pageInit.jsp" %>
<style type="text/css">
div.gridbox_dhx_terrace.gridbox table.hdr td {vertical-align: middle;}
</style>
<script type="text/javascript" src="${contextPath}/js/jquery/jquery.filedownload.js"></script>
<script type="text/javascript" src="${contextPath}/js/mainLayout.js"></script>
<script type="text/javascript">
var dhxLayout, myGrid, t;
$(document).ready(function(){
	setMainLayoutHeight($('#mainLayout'));
	if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
	else  window.addEventListener("resize",resizeLayout, false);

	dhxLayout = new dhtmlXLayoutObject("mainLayout","1C");
	dhxLayout.cells("a").hideHeader();
	dhxLayout.setSizes(false);

	//attach myGrid
	myGrid = dhxLayout.cells("a").attachGrid();
	myGrid.setImagePath("${dhtmlXImagePath}");
	myGrid.setHeader("번호,대상자,#cspan,구분,접속일자,접속자,#cspan,#cspan,#cspan",null,grid_head_center_bold);
	myGrid.attachHeader("#rspan,사번,성명,#rspan,#rspan,사번,성명,권한,접속IP",grid_head_center_bold);
	myGrid.setColumnIds("No,trgterId,trgterNm,workSeCd,regDate,conectrId,conectrNm,conectrAuthorCd,conectIp");
	myGrid.setInitWidths("50,100,*,80,*,100,*,*,*");
	myGrid.setColAlign("center,center,center,center,center,center,center,center,center");
	myGrid.setColTypes("ro,ro,ro,ro,ro,ro,ro,ro,ro");
	myGrid.setColSorting("na,str,str,str,str,str,str,str,str");
	myGrid.attachEvent("onBeforeSorting", myGrid_onBeforeSorting);
	myGrid.attachEvent("onXLS", doBeforeGridLoad);
	myGrid.attachEvent("onXLE", doOnGridLoaded);
	myGrid.enablePaging(true,100,10,"pagingArea",true);
	myGrid.setPagingSkin("${dhtmlXPagingSkin}");
	myGrid.enableColSpan(true);
	myGrid.enableColumnAutoSize(true);
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
	var url = "${contextPath}/indvdlinfo/findIndvdlinfoTrtmntList.do";
	url += "?"  + $('#formArea').serialize();
	return url;
}

function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){ setMainLayoutHeight($('#mainLayout')); dhxLayout.setSizes(false); },10);}
function doOnGridLoaded(){setTimeout(function() {dhxLayout.cells("a").progressOff();}, 100);}
function doBeforeGridLoad(){dhxLayout.cells("a").progressOn();}

function toExcel(){
	location.href = "${contextPath}/indvdlinfo/indvdlinfoTrtmntExport.do?" + $('#formArea').serialize();
}
</script>
</head>
<body>
	<form name="popFrm" id="popFrm" method="post"></form>
	<div class="title_box">
		<h3>개인정보취급관리</h3>
	</div>
	<div class="contents_box">
	<!-- START 테이블 1 -->
		<form id="formArea">
		<input type="hidden" name="expFileExt" value="xls">
		<table class="view_tbl mgb_10" >
			<colgroup>
				<col style="width: 15%;"/>
				<col style="width: 27%;"/>
				<col style="width: 15%;"/>
				<col />
				<col style="width: 50px;"/>
			</colgroup>
			<tbody>
			<tr>
				<th>구분</th>
				<td>
					<select name="workSeCd" class="select_type" onchange="javascript:myGrid_load();">
						<option value="">전체</option>
						<option value="SRCH">열람</option>
						<option value="EXP">반출</option>
						<option value="INS">등록</option>
						<option value="MOD">수정</option>
					</select>
				</td>
				<th>대상자권한</th>
				<td>
					<select name="trgterSeCd" class="select_type" style="width:50%;" onchange="javascript:myGrid_load();">
						<option value="">전체</option>
						<option value="U">이용자</option>
						<option value="M">관리자</option>
						<option value="TM">트랙관리자</option>
						<option value="TS">트랙이용자</option>
						<option value="S">대리입력자</option>
					</select>
				</td>
				<td rowspan="3" class="option_search_td" onclick="javascript:myGrid_load();"><em>search</em></td>
			</tr>
			<tr>
				<th>대상자사번</th>
				<td><input type="text" id="trgetUserId" name="trgetUserId" class="input2" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/></td>
				<th>접속일자</th>
				<td>
					<input type="text" id="sttDate" name="sttDate" class="input2" style="width: 80px;" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();" />
					~ <input type="text" id="endDate" name="endDate" class="input2" style="width: 80px;" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/>
				</td>
			</tr>
			<tr>
				<th>접속자사번</th>
				<td><input type="text" id="srchUserId" name="srchUserId" class="input2" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/></td>
				<th>접속자권한</th>
				<td>
					<select name="srchAdminDvsCd" class="select_type" style="width:50%;" onchange="javascript:myGrid_load();">
						<option value="">전체</option>
						<option value="M">관리자</option>
						<option value="D">학과관리자</option>
						<option value="T">트랙관리자</option>
						<option value="P">성과관리자</option>
						<option value="S">대리입력자</option>
					</select>
				</td>
			</tr>
			</tbody>
		</table>
		<div class="list_bt_area">
			<div class="list_set">
				<ul>
					<li><a href="#" onclick="javascript:toExcel();" class="list_icon20">엑셀</a></li>
				</ul>
			</div>
		</div>
		<!-- layout (grid,paging)  -->
		<div id="mainLayout" style="position: relative; width: 100%;height: 100%;"></div>
		<div id="pagingObj" style="z-index: 1; height: 40px; margin-top: 5px;" >
			<div id="pagingArea" style="z-index: 1;"></div>
		</div>
 	</div>
</body>
</html>