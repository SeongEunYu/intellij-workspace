<%@page import="kr.co.argonet.r2rims.util.LanguageUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="../pageInit.jsp" %>
<style type="text/css">
.dhxlayout_base_dhx_terrace div.dhx_cell_layout div.dhx_cell_cont_layout {border: 0 solid #fff;}
.dhxlayout_base_dhx_terrace div.dhx_cell_layout div.dhx_cell_hdr{border: 0 solid #fff;}
div.gridbox_dhx_terrace.gridbox table.hdr td {vertical-align: middle;}
</style>
<script type="text/javascript" src="${contextPath}/js/jquery/jquery.filedownload.js"></script>
<script type="text/javascript" src="${contextPath}/js/mainLayout.js"></script>
<script type="text/javascript">
var dhxLayout, myGrid, t;
$(document).ready(function(){
	setLayoutHeight();
	if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
	else  window.addEventListener("resize",resizeLayout, false);

	dhxLayout = new dhtmlXLayoutObject("mainLayout","2U");
	dhxLayout.cells("a").hideHeader();
	dhxLayout.cells("b").hideHeader();
	dhxLayout.setSizes(false);
	dhxLayout.cells("a").setWidth(screenWidth*0.7);

	//attach myGrid
	dhxLayout.cells("a").attachObject('listbox');
	dhxLayout.cells("b").attachHTMLString('<div id="userchghstInfo" style="width:100%;height:100%;overflow:auto;"></div>');
	setGridHeight();
	myGrid = new dhtmlXGridObject('gridbox');
	myGrid.attachEvent("onRowSelect", load_overview);
	myGrid.setImagePath("${dhtmlXImagePath}");
	myGrid.setHeader("번호,대상자,#cspan,#cspan,#cspan,수정일자,수정자,#cspan,#cspan",null,grid_head_center_bold);
	myGrid.attachHeader("#rspan,사번,성명,학과,구분,#rspan,사번,성명,권한",grid_head_center_bold);
	myGrid.setColumnIds("No,trgterId,trgterKorNm,trgterDeptKor,trgterAuthorCd,modDate,modUserId,modUserNm,modUserAuthorCd");
	myGrid.setInitWidths("50,100,*,*,*,100,100,*,*");
	myGrid.setColAlign("center,center,center,center,center,center,center,center,center");
	myGrid.setColTypes("ro,ro,ro,ro,ro,ro,ro,ro,ro");
	myGrid.setColSorting("na,str,na,na,str,str,str,na,str");
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
	var url = "${contextPath}/indvdlinfo/findUserchghstList.do";
	url += "?"  + $('#formArea').serialize();
	return url;
}

function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){ dhxLayout.setSizes(false); },10);}
function doOnGridLoaded(){
	var strIndex = (myGrid.currentPage-1) * myGrid.rowsBufferOutSize;
	var myGridRows = myGrid.getRowsNum();

	if(myGridRows > 0)
	{
		myGrid.selectRow(strIndex,true,true,true);
	}
	else
	{
		$('#userchghstInfo').empty();
	}
	setTimeout(function() {dhxLayout.cells("a").progressOff();}, 100);
}
function doBeforeGridLoad(){dhxLayout.cells("a").progressOn();}

function load_overview(rowID,celInd){
	$.post('${contextPath}/indvdlinfo/userchghstForm.do',{'seqNo' : rowID},null,'text').done(function(data){
		$('#userchghstInfo').html(data);
		var cnTrHeight = $('#mainLayout').height();
		cnTrHeight = cnTrHeight - 138;
		cnTrHeight = cnTrHeight - (35*($('#userchghstTbl tbody tr').length - 1 ));
		$('.cnTr').css('height', cnTrHeight);
	});
}

function toExcel(){
	location.href = "${contextPath}/indvdlinfo/userchghstExport.do?" + $('#formArea').serialize();
}

function setLayoutHeight(){
	var layoutHeight = $(window).height();
	layoutHeight -= 120;
	if($('.title_box') != undefined )
		layoutHeight -= $('.title_box').height();
	if($('.header_wrap') != undefined )
		layoutHeight -= $('.header_wrap').height();
	if($('.list_bt_area') != undefined )
		layoutHeight -= $('.list_bt_area').height();
	if($('.nav_wrap') != undefined )
		layoutHeight -= $('.nav_wrap').height();
	$('#mainLayout').css('height',layoutHeight+"px");
}

function setGridHeight(){
	var gridHeight = $('#mainLayout').height();
	gridHeight -= 95;
	if($('.view_tbl') != undefined )
		gridHeight -= $('.nav_wrap').height();
	$('#gridbox').css('height',gridHeight+"px");
}

</script>
</head>
<body>
	<form name="popFrm" id="popFrm" method="post"></form>
	<div class="title_box">
		<h3>이용자변경이력</h3>
	</div>
	<div class="contents_box">
	<!-- START 테이블 1 -->
		<form id="formArea">
		<input type="hidden" name="expFileExt" value="csv">
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
				<th>대상구분</th>
				<td>
					<select name="gubun" class="select_type" onchange="javascript:myGrid_load();">
						<option value="">전체</option>
						<option value="M">관리대상자</option>
						<option value="S">미관리대상자</option>
					</select>
				</td>
				<th>학과(부)</th>
				<td>
					<select name="searchDept" onchange="javascript:myGrid_load();" class="select_type" style="width:100%;">
						<option value="">전체</option>
						<c:forEach items="${sbjtCdList}" var="sc" varStatus="idx">
							<c:if test="${not empty sc.deptKor and sc.deptKor ne '' }">
								<option value="${fn:escapeXml(sc.deptKor)}">${fn:escapeXml(sc.deptKor)}</option>
							</c:if>
						</c:forEach>
					</select>
				</td>
				<td rowspan="3" class="option_search_td" onclick="javascript:myGrid_load();"><em>search</em></td>
			</tr>
			<tr>
				<th>대상자사번</th>
				<td><input type="text" id="trgterId" name="trgterId" class="input2" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/></td>
				<th>수정일자</th>
				<td>
					<input type="text" id="sttDate" name="sttDate" class="input2" style="width: 80px;"  onKeyup="javascript:if(event.keyCode=='13')myGrid_load();" />
					~ <input type="text" id="endDate" name="endDate" class="input2" style="width: 80px;" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/>
				</td>
			</tr>
			<tr>
				<th>수정자사번</th>
				<td><input type="text" id="modUserId" name="modUserId" class="input2" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/></td>
				<th>수정자권한</th>
				<td>
					<select name="modUserAuthorCd" class="select_type" style="width:50%;" onchange="javascript:myGrid_load();">
						<option value="">전체</option>
						<option value="M">관리자</option>
						<option value="D">학과관리자</option>
						<option value="C">단과대관리자</option>
						<option value="T">트랙관리자</option>
						<option value="P">성과관리자</option>
						<option value="S">대리입력자</option>
						<option value="Y">시스템(동기화)</option>
					</select>
				</td>
			</tr>
			</tbody>
		</table>
		<div class="list_bt_area">
			<div class="list_set">
				<ul>
					<li><a href="#" onclick="javascript:toExcel();" class="list_icon20">CSV</a></li>
				</ul>
			</div>
		</div>
		<div id="listbox">
			<div id="gridbox" style="position: relative; width: 100%;height: 100%;"></div>
			<div id="pagingObj" style="z-index: 1; height: 40px; margin-top: 5px;" >
				<div id="pagingArea" style="z-index: 1;"></div>
			</div>
		</div>
		<!-- layout (grid,paging)  -->
		<div id="mainLayout" style="position: relative; width: 100%;height: 100%;"></div>
 	</div>
</body>
</html>