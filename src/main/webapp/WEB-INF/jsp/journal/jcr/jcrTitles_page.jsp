<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>JCR</title>
<%@include file="../../pageInit.jsp" %>
<script type="text/javascript" src="${contextPath}/js/mainLayout.js"></script>
<script type="text/javascript">
var dhxLayout, jcrGrid, jcrDp, histGrid, sbjtGrid, t;
$(document).ready(function(){
	if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
	else  window.addEventListener("resize",resizeLayout, false);
	//set layout
	dhxLayout = new dhtmlXLayoutObject("mainLayout","3L");
	dhxLayout.cells("a").hideHeader();
	dhxLayout.cells("b").setText("History");
	dhxLayout.cells("c").setText("Category");
    dhxLayout.cells("b").setWidth(360);
	dhxLayout.setSizes(false);
	dhxLayout.setAutoSize("a","a;b");

    loadJcrCellComponent();
	loadHistCellComponent();
	loadSbjtCellComponent();
	jcrGrid_load();
});

function loadJcrCellComponent(){
	jcrGrid = dhxLayout.cells("a").attachGrid();
	jcrGrid.setImagePath("${dhtmlXImagePath}");
	jcrGrid.setHeader("번호,Year,Journal Name 20,Journal Name,ISSN,Citation,I.F.,EDITION", null, grid_head_center_bold);
    jcrGrid.setColumnIds("id,prodyear,title20,title,issn,totalcites,impact,prodedition");
	jcrGrid.setInitWidths("50,60,140,*,80,80,60,80");
	jcrGrid.setColAlign("left,center,left,left,center,center,center,center");
	jcrGrid.setColSorting("na,server,server,server,server,server,server,server");
	jcrGrid.setColTypes("ro,ed,ed,ed,ed,ed,ed,ed");
	jcrGrid.attachEvent("onRowSelect",jcrGrid_onRowSelect);
	jcrGrid.attachEvent("onBeforeSorting",jcrGrid_onBeforeSorting);
	jcrGrid.attachEvent("onPageChanged",doBeforeGridLoad);
	jcrGrid.attachEvent("onPaging",doOnGridLoaded);
	jcrGrid.attachEvent("onXLE", jcrGrid_onSelectPageFirstRow);
	jcrGrid.enablePaging(true,100,10,"pagingArea",true);
    jcrGrid.setPagingSkin("${dhtmlXPagingSkin}");
	jcrGrid.init();
	jcrGrid.setColumnHidden(0,true);
	jcrDp = new dataProcessor("${contextPath}/jcr/updateJcrTitle.do");
	jcrDp.init(jcrGrid);
	jcrDp.setTransactionMode("POST",false); //dataprocessing one by one , with GET method
	jcrDp.setUpdateMode("off"); //
    jcrDp.enableDataNames(true);
	jcrDp.setVerificator(1, jcrGrid_not_empty);
	jcrDp.attachEvent("onValidatationError", function(id, messages) {
		alert(messages.join("\n"));
		return true;
	});
}

function loadHistCellComponent(){
	histGrid = dhxLayout.cells("b").attachGrid();
	histGrid.setImagePath("${dhtmlXImagePath}");
	histGrid.setHeader("Year,Citation,I.F.", null, grid_head_center_bold);
    histGrid.setColumnIds("prodyear,totalcites,impact");
	histGrid.setInitWidths("80,*,*");
	histGrid.setColAlign("center,center,center");
	histGrid.setColSorting("str,str,str");
	histGrid.setColTypes("ro,ro,ro");
	histGrid.setColumnColor("#FFFFFF,#FFFFFF,#FFFFFF");
	histGrid.init();
}

function loadSbjtCellComponent(){
	sbjtGrid = dhxLayout.cells("c").attachGrid();
	sbjtGrid.setImagePath("${dhtmlXImagePath}");
	sbjtGrid.setHeader("Code,Description,#", null, grid_head_center_bold);
    sbjtGrid.setColumnIds("id,categ,description");
	sbjtGrid.setInitWidths("60,*,*");
	sbjtGrid.setColAlign("center,left,left");
	sbjtGrid.setColSorting("str,str,str");
	sbjtGrid.setColTypes("ro,ro,ro");
	sbjtGrid.setColumnColor("#FFFFFF,#FFFFFF,#FFFFFF");
	sbjtGrid.setColumnHidden(0,true);
	sbjtGrid.setColumnHidden(2,true);
	sbjtGrid.init();
}

function jcrGrid_onRowSelect(rowID,celInd){
	var rowInd = jcrGrid.getRowIndex(rowID);
	var strJnl = jcrGrid.cellByIndex(rowInd, 3 ).getValue();
	var strIssn = jcrGrid.cellByIndex(rowInd, 4 ).getValue();
	if(strJnl !="" && strIssn != ""){
		showhistGrid(strJnl,strIssn);
	}
	if(rowID != ""){
		shwosbjtGrid(rowID);
	}
}

function jcrGrid_onBeforeSorting(ind,type,direct){
	var url = getGridRequestURL();
	jcrGrid.clearAndLoad(url+"&orderby="+(jcrGrid.getColumnId(ind))+"&direct="+direct);
	jcrGrid.setSortImgState(true,ind,direct);
	return false;
}

function jcrGrid_load(){
	doBeforeGridLoad();
	var url = getGridRequestURL();
	histGrid.clearAll(); //clear history grid
	sbjtGrid.clearAll(); //clear subject grid
	jcrGrid.clearAndLoad(url, doOnGridLoaded);
}

function getGridRequestURL(){
	var url = '<c:url value="/${preUrl}/jcr/findJcrTitlesList.do"/>';
	url = comAppendQueryString(url,"maskTitle",	encodeURIComponent( $("#maskTitle").val() ));
	url = comAppendQueryString(url,"maskIssn",		encodeURIComponent( $("#maskIssn").val() ));
	url = comAppendQueryString(url,"maskYear",	$("#maskYear option:selected").val() );
	//url = comAppendQueryString(url,"mask_categ",	arr_categ.join(","));
	return url;
}

function jcrGrid_onSelectPageFirstRow(){
	var strIndex = (jcrGrid.currentPage-1) * jcrGrid.rowsBufferOutSize;
	jcrGrid.selectRow(strIndex,true,true,true);
	jcrGrid.showRow(jcrGrid.getRowId(strIndex))
	doOnGridLoaded();
}

function jcrGrid_not_empty(value, id, ind) {
    if (value == "") {
		return "Value at (" + id + ", " + ind + ") can't be empty";
	}
    return true;
}
function jcrGrid_greater_0(value, id, ind) {
    if (parseFloat(value) <= 0) {
        return "Value at (" + id + ", " + ind + ") must be greater than 0";
	}
    return true;
}

function showhistGrid(strJnl,strIssn){
	dhxLayout.cells("b").progressOn();
	var url = '<c:url value="/${preUrl}/jcr/findHistoryList.do?title="/>'+strJnl+"&issn="+strIssn;
	histGrid.clearAndLoad(url, function(){setTimeout(function() {dhxLayout.cells("b").progressOff();}, 50);});
}

function shwosbjtGrid(rowInd){
	dhxLayout.cells("c").progressOn();
	var url = '<c:url value="/${preUrl}/jcr/findSubjectList.do?id="/>'+rowInd;
	sbjtGrid.clearAndLoad(url, function(){setTimeout(function() {dhxLayout.cells("c").progressOff();}, 50);});
}

function jcrGrid_addRow(){
	jcrGrid.addRow((new Date()).valueOf(),['','','',''],jcrGrid.getRowIndex(jcrGrid.getSelectedId()));
}
function jcrGrid_deleteSelectedItem(){
	var id=jcrGrid.getSelectedId();
	var gubun=jcrGrid.cells(id,11).getValue();
	if(gubun == 'I'){
		alert("기본 데이터는 삭제 불가능합니다.");
		return false;
	}
	jcrGrid.deleteSelectedItem();
}

function saveChanges(){
	if(confirm("저장 하시겠습니까?")){
		jcrDp.sendData();
	}
}

function exportData(){
	var url = "${contextPath}/jcr/exportJCRTit.do?";
	url = comAppendQueryString(url,"maskTitle", encodeURIComponent( $("#maskTitle").val() ));
	url = comAppendQueryString(url,"maskIssn",	 encodeURIComponent( $("#maskIssn").val() ));
	url = comAppendQueryString(url,"maskYear",	 $("#maskYear option:selected").val() );
	window.open(url, "report_excel", "height=600, width=800, scrollbars=yes, resizable=yes, menubar=yes");

}
function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){ dhxLayout.setSizes(false); },200);}
function doOnGridLoaded(){setTimeout(function() {dhxLayout.cells("a").progressOff();}, 100);}
function doBeforeGridLoad(){dhxLayout.cells("a").progressOn();}
</script>

</head>
<body>
	<!-- Page Title -->
	<div class="title_box">
		<h3><spring:message code='menu.jcr'/></h3>
	</div>
	<!-- Main Content -->
	<div class="contents_box">
		<!-- START 테이블 1 -->
		<table class="view_tbl mgb_10">
			<colgroup>
				<col style="width: 13%"/>
				<col style="width: 35%"/>
				<col style="width: 13%"/>
				<col />
				<col style="width: 50px;"/>
			</colgroup>
			<tbody>
			<tr>
				<th>Year</th>
				<td class="borderRight">
					<select class="select1" style="width:100%;" id="maskYear" onChange="jcrGrid_load();">
						<option selected='selected' value='ALL'>전체</option>
						<c:if test="${not empty prodyearList }">
							<c:forEach items="${prodyearList}" var="yl" varStatus="st">
								<option value="${fn:escapeXml(yl.prodyear)}"  <c:if test="${st.count eq 1}" >selected="selected"</c:if>>${fn:escapeXml(yl.prodyear)}</option>
							</c:forEach>
						</c:if>
					</select>
				</td>
				<th>ISSN</th>
				<td class="borderRight">
					<input type="text" size=4 id="maskIssn" style="width:100%;" class="input2" onKeyup="javascript:if(event.keyCode=='13')jcrGrid_load();">
				</td>
				<td rowspan="2" class="option_search_td" onclick="javascript: jcrGrid_load();"><em>search</em></td>
			</tr>
			<tr>
				<th>Journal Title</th>
				<td colspan="3">
					<input type="text" size=10 id="maskTitle" style="width:100%;" class="input2" onKeyup="javascript:if(event.keyCode=='13')jcrGrid_load();">
				</td>
			</tr>
			</tbody>
		</table>
		<!-- END 테이블 1 -->
		<div id="mainLayout" style="position: relative; width: 100%;height: 100%;"></div>
		<script type="text/javascript">setMainLayoutHeight($('#mainLayout'));</script>
		<div id="pagingObj" style="z-index: 1; height: 60px; margin-top: 5px;" >
			<div id="pagingArea" style="z-index: 1;"></div>
		</div>
	</div>
</body>
</html>