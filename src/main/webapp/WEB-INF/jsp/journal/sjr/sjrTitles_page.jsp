<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../pageInit.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>SJR</title>
<script type="text/javascript" src="${contextPath}/js/mainLayout.js"></script>
<script type="text/javascript">
var dhxLayout, sjrGrid, sjrDp, histGrid, sbjtGrid, t;
$(document).ready(function(){
	if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
	else  window.addEventListener("resize",resizeLayout, false);
	//set layout
	dhxLayout = new dhtmlXLayoutObject("mainLayout","3L");
	dhxLayout.cells("a").hideHeader();
	dhxLayout.cells("b").setText("History");
	dhxLayout.cells("c").setText("Category");
    dhxLayout.cells("b").setWidth(300);
	dhxLayout.setSizes(false);
	dhxLayout.setAutoSize("a","a;b");

    loadSjrCellComponent();
	loadHistCellComponent();
	loadSbjtCellComponent();
	sjrGrid_load();
});

function loadSjrCellComponent(){
	sjrGrid = dhxLayout.cells("a").attachGrid();
	sjrGrid.setImagePath("${dhtmlXImagePath}");
	sjrGrid.setHeader("번호,Year,Journal Name,ISSN,SJR,H-index,Total Docs.,Total Refs,Ref. / Doc., Country", null, grid_head_center_bold);
    sjrGrid.setColumnIds("id,prodyear,title,issn,sjr,hindex,totalDocs,ttlRfs,refDoc,country");
	sjrGrid.setInitWidths("50,60,*,80,60,70,80,70,70,90,90");
	sjrGrid.setColAlign("center,center,left,center,center,center,center,center,center");
	sjrGrid.setColSorting("na,server,server,server,server,server,server,server,server,server");
	sjrGrid.setColTypes("ro,ro,ro,ro,ro,ro,ro,ro,ro,ro");
	sjrGrid.attachEvent("onRowSelect",sjrGrid_onRowSelect);
	sjrGrid.attachEvent("onBeforeSorting",sjrGrid_onBeforeSorting);
	sjrGrid.attachEvent("onPageChanged",doBeforeGridLoad);
	sjrGrid.attachEvent("onPaging",doOnGridLoaded);
	sjrGrid.attachEvent("onXLE", sjrGrid_onSelectPageFirstRow);
	sjrGrid.enablePaging(true,100,10,"pagingArea",true);
    sjrGrid.setPagingSkin("${dhtmlXPagingSkin}");
    sjrGrid.enableColSpan(true);
	sjrGrid.init();
	sjrGrid.setColumnHidden(0,true);
	sjrDp = new dataProcessor('<c:url value="/${preUrl}/sjr/updateSjrTitles.do"/>');
	sjrDp.init(sjrGrid);
	sjrDp.setTransactionMode("POST",false); //dataprocessing one by one , with GET method
	sjrDp.setUpdateMode("off"); //
    sjrDp.enableDataNames(true);
	sjrDp.setVerificator(1, sjrGrid_not_empty);
	sjrDp.attachEvent("onValidatationError", function(id, messages) {
		alert(messages.join("\n"));
		return true;
	});
}

function loadHistCellComponent(){
	histGrid = dhxLayout.cells("b").attachGrid();
	histGrid.setImagePath("${dhtmlXImagePath}");
	histGrid.setHeader("Year,SJR,H-index", null, grid_head_center_bold);
    histGrid.setColumnIds("prodyear,sjr,hindex");
	histGrid.setInitWidths("90,*,*");
	histGrid.setColAlign("center,center,center");
	histGrid.setColSorting("str,str,str");
	histGrid.setColTypes("ro,ro,ro");
	histGrid.setColumnColor("#FFFFFF,#FFFFFF,#FFFFFF");
	histGrid.init();
}

function loadSbjtCellComponent(){
	sbjtGrid = dhxLayout.cells("c").attachGrid();
	sbjtGrid.setImagePath("${dhtmlXImagePath}");
	sbjtGrid.setHeader("Code,Description", null, grid_head_center_bold);
    sbjtGrid.setColumnIds("categ","description");
	sbjtGrid.setInitWidths("40,*");
	sbjtGrid.setColAlign("center,left");
	sbjtGrid.setColSorting("str,str");
	sbjtGrid.setColTypes("ro,ro");
	sbjtGrid.setColumnColor("#FFFFFF,#FFFFFF");
	sbjtGrid.init();
	sbjtGrid.setColumnHidden(0,true);
}

function sjrGrid_onRowSelect(rowID,celInd){
	var rowInd = sjrGrid.getRowIndex(rowID);
	var cellObj2 = sjrGrid.cellByIndex(rowInd, 2 );
	var cellObj3 = sjrGrid.cellByIndex(rowInd, 3);
	var strJnl = cellObj2.getValue();
	var strIssn = cellObj3.getValue();
	if(strJnl !="" && strIssn != ""){
		showhistGrid(strJnl,strIssn);
	}
	if(rowID != ""){
		shwosbjtGrid(strIssn);
	}
}


function sjrGrid_onBeforeSorting(ind,type,direct){
	var url = getGridRequestURL();
	sjrGrid.clearAndLoad(url+"&orderby="+(sjrGrid.getColumnId(ind))+"&direct="+direct);
	sjrGrid.setSortImgState(true,ind,direct);
	return false;
}

function sjrGrid_load(){
	doBeforeGridLoad();
	var url = getGridRequestURL();
	histGrid.clearAll(); //clear history grid
	sbjtGrid.clearAll(); //clear subject grid
	sjrGrid.clearAndLoad(url, doOnGridLoaded);
}

function getGridRequestURL(){
	var url = '<c:url value="/${preUrl}/sjr/findSjrTitlesList.do"/>';
	url = comAppendQueryString(url,"maskTitle",	encodeURIComponent( $("#maskTitle").val() ));
	url = comAppendQueryString(url,"maskIssn",	encodeURIComponent( $("#maskIssn").val() ));
	url = comAppendQueryString(url,"maskYear",	$('#maskYear').val() );
	return url;
}

function sjrGrid_onSelectPageFirstRow(){
	var strIndex = (sjrGrid.currentPage-1) * sjrGrid.rowsBufferOutSize;
	sjrGrid.selectRow(strIndex,true,true,true);
	sjrGrid.showRow(sjrGrid.getRowId(strIndex))
	doOnGridLoaded();
}

function sjrGrid_not_empty(value, id, ind) {
    if (value == "") {
		return "Value at (" + id + ", " + ind + ") can't be empty";
	}
    return true;
}
function sjrGrid_greater_0(value, id, ind) {
    if (parseFloat(value) <= 0) {
        return "Value at (" + id + ", " + ind + ") must be greater than 0";
	}
    return true;
}

function showhistGrid(strJnl,strIssn){
	dhxLayout.cells("b").progressOn();
	var url = '<c:url value="/${preUrl}/sjr/findHistoryList.do?title="/>'+strJnl+"&issn="+strIssn;
	histGrid.clearAndLoad(url, function(){setTimeout(function() {dhxLayout.cells("b").progressOff();}, 50);});
}

function shwosbjtGrid(strIssn){
	dhxLayout.cells("c").progressOn();
	var url = '<c:url value="/${preUrl}/sjr/findSubjectList.do?issn="/>'+strIssn;
	sbjtGrid.clearAndLoad(url, function(){setTimeout(function() {dhxLayout.cells("c").progressOff();}, 50);});

}

function sjrGrid_addRow(){
	sjrGrid.addRow((new Date()).valueOf(),['','','',''],sjrGrid.getRowIndex(sjrGrid.getSelectedId()));
}
function sjrGrid_deleteSelectedItem(){
	var id=sjrGrid.getSelectedId();
	var gubun=sjrGrid.cells(id,11).getValue();
	if(gubun == 'I'){
		alert("기본 데이터는 삭제 불가능합니다.");
		return false;
	}
	sjrGrid.deleteSelectedItem();
}

function saveChanges(){
	sjrDp.sendData();
}

function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){ dhxLayout.setSizes(false); },200);}
function doOnGridLoaded(){setTimeout(function() {dhxLayout.cells("a").progressOff();}, 100);}
function doBeforeGridLoad(){dhxLayout.cells("a").progressOn();}
</script>
</head>
<body>
	<!-- Page Title -->
	<div class="title_box">
		<h3><spring:message code='menu.sjr'/></h3>
	</div>
	<!-- Main Content -->
	<div class="contents_box">
		<div class="formObj">
			<table class="view_tbl mgb_10">
				<colgroup>
					<col style="width: 15%"/>
					<col style="width: 35%"/>
					<col style="width: 15%"/>
					<col />
					<col style="width: 50px;"/>
				</colgroup>
				<tr>
					<th>년도</th>
					<td>
						<select class="select1" style="width:50%;" id="maskYear" onChange="sjrGrid_load();">
							<option selected='selected' value='ALL'><spring:message code='common.option.all'/></option>
							<c:if test="${not empty prodyearList }">
								<c:forEach items="${prodyearList}" var="yl" varStatus="st">
									<option value="${fn:escapeXml(yl.prodyear)}">${fn:escapeXml(yl.prodyear)}</option>
								</c:forEach>
							</c:if>
						</select>
					</td>
					<th>ISSN</th>
					<td>
						<input type="text" size=9 id="maskIssn" style="height:14px; width:78px;" onkeyup="javascript:if(event.keyCode=='13')sjrGrid_load();" />
					</td>
					<td rowspan="2" class="option_search_td" onclick="javascript: sjrGrid_load();"><em>search</em></td>
				</tr>
				<tr>
					<th>저널명</th>
					<td colspan="3">
						<input type="text" size=10 id="maskTitle" style="height:14px; width:100%;" onkeyup="javascript:if(event.keyCode=='13')sjrGrid_load();">
					</td>
				</tr>
			</table>
		</div>
		<div id="mainLayout" style="position: relative; width: 100%;height: 100%;"></div>
		<script type="text/javascript">setMainLayoutHeight($('#mainLayout'));</script>
		<div id="pagingObj" style="z-index: 1; height: 60px; margin-top: 5px;" >
			<div id="pagingArea" style="z-index: 1;"></div>
		</div>
</div>
</body>
</html>