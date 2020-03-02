<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../pageInit.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<head>
	<title>Journal Master</title>
<script type="text/javascript" src="${contextPath}/js/mainLayout.js"></script>
<script type="text/javascript">
var dhxLayout, myGrid, myDp, t;
$(document).ready(function(){
	if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
	else  window.addEventListener("resize",resizeLayout, false);
	//set layout
	dhxLayout = new dhtmlXLayoutObject("mainLayout","1C");
	dhxLayout.cells("a").hideHeader();
	dhxLayout.setSizes(false);
	//attach myGrid
	myGrid = dhxLayout.cells("a").attachGrid();
	myGrid.setImagePath("${dhtmlXImagePath}");
	myGrid.setHeader("관리번호,저널명,주기,ISSN,SCI,SCIE,SSCI,AHCI,SCOPUS,KCI,KCI구분,WOS출판사,SCOPUS출판사,KCI출판사,국가",null,grid_head_center_bold);
	myGrid.setColumnIds("jrnlId,title,frequency,issn,sci,scie,ssci,ahci,scopus,kci,kciGubun,puWos,puScopus,puKci,pc");
	myGrid.setInitWidths("100,*,80,80,50,50,50,50,60,50,60,100,100,100,90");
	myGrid.setColAlign("center,left,left,center,center,center,center,center,center,center,center,left,left,left,center");
	myGrid.setColSorting("na,str,str,str,na,na,na,na,na,na,na,na,na,na,na");
	myGrid.setColTypes("ro,ed,ed,ed,ch,ch,ch,ch,ch,ch,ed,ed,ed,ed,ed");
	myGrid.enableEditEvents(true,false,true);
	myGrid.attachEvent("onRowDblClicked", myGrid_onRowDblClicked);
	myGrid.attachEvent("onBeforeSorting",myGrid_onBeforeSorting);
	myGrid.attachEvent("onXLS", doBeforeGridLoad);
	myGrid.attachEvent("onXLE", doOnGridLoaded);
	myGrid.enablePaging(true,100,10,"pagingArea",true);
	myGrid.setPagingSkin("${dhtmlXPagingSkin}");
	//myGrid.setColumnHidden(0,true);
    myGrid.setColumnHidden(10, true);
	myGrid.init();
    //myGrid.splitAt(2);
	myDp = new dataProcessor("${contextPath}/journal/masterCUD.do");
	myDp.init(myGrid);
	myDp.setTransactionMode("POST",false);
	myDp.setUpdateMode("off");
	myDp.enableDataNames(true);
	myDp.attachEvent("onValidatationError", function(id, messages) {
		alert(messages.join("\n"));
		return true;
	});
	myGrid_load();
});

function getGridRequestURL(){
	var reqUrl  =  "${contextPath}/journal/findJournalList.do?";
	reqUrl += "maskTitle="+ encodeURIComponent($('#maskTitle').val());
	reqUrl += "&maskIssn="+ encodeURIComponent($('#maskIssn').val());
	reqUrl += "&maskSource="+ $(':radio[name="source"]:checked').val();
	reqUrl += "&howSearch="+$(':input:radio[name="howSearch"]:checked').val();
	return reqUrl;
}

function myGrid_onBeforeSorting(ind,type,direct){
	var url = getGridRequestURL();
	myGrid.clearAndLoad(url+"&orderby="+(myGrid.getColumnId(ind))+"&direct="+direct);
	myGrid.setSortImgState(true,ind,direct);
	return false;
}

function myGrid_load(){
	doBeforeGridLoad();
	var url = getGridRequestURL();
	myGrid.clearAndLoad(url, doOnGridLoaded);
}
function myGrid_not_empty(value, id, ind) {
    if (value == "") {
		return "Value at (" + id + ", " + ind + ") can't be empty";
	}
    return true;
}
function myGrid_greater_0(value, id, ind) {
    if (parseFloat(value) <= 0) {
        return "Value at (" + id + ", " + ind + ") must be greater than 0";
	}
    return true;
}
function myGrid_onRowDblClicked(rowID,celInd){
	var detailPopup = window.open('about:blank', 'detailPopup', 'height=600px,width=830px,location=no,scrollbars=no');
	var popFrm = $('#popFrm');
	popFrm.empty();
	popFrm.append($('<input type="hidden" name="jrnlId" value="'+rowID+'"/>'));
	popFrm.append($('<input type="hidden" name="issn" value="'+myGrid.cells(myGrid.getSelectedId(),3).getValue()+'"/>'));
	popFrm.attr('action', '${contextPath}/journal/journalDetailPopup.do');
	popFrm.attr('target', 'detailPopup');
	popFrm.attr('method', 'POST');
	popFrm.submit();
}

function myGrid_addRow(){
	myGrid.addRow((new Date()).valueOf(),['','','',''],myGrid.getRowIndex(myGrid.getSelectedId()));
}
function myGrid_deleteSelectedItem(){
	myGrid.deleteSelectedItem();
}
function saveChanges(){
	myDp.sendData();
}

function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){ dhxLayout.setSizes(false); },200);}
function doOnGridLoaded(){setTimeout(function() {dhxLayout.cells("a").progressOff();}, 100);}
function doBeforeGridLoad(){dhxLayout.cells("a").progressOn();}
</script>


</head>
<body>
	<!-- Page Title -->
	<div class="title_box">
		<h3><spring:message code='menu.journal.master'/></h3>
	</div>
	<!-- Main Content -->
	<div class="contents_box">

		<!-- START 탑 툴바
		<div class="top_toolbar">
			<div class="top_toolbar_ttl"></div>
			<div class="top_toolbar_btn">
				<div style="float: right;margin-right: 10px;"><a href="#" onclick="myGrid_addRow();">추가등록</a></div>
				<div style="float: right;margin-right: 10px;"><a href="#" onclick="myGrid_deleteSelectedItem();">삭제</a></div>
				<div style="float: right;margin-right: 10px;"><a href="#" onclick="saveChanges();">저장</a></div>
				<div style="float: right;margin-right: 10px;"><a href="#" onclick="statsExportData();">&nbsp;엑셀</a></div>
			</div>
		</div>
		-->

		<!-- START 테이블 1 -->
		<form id="formArea" >
			<table class="view_tbl mgb_10">
				<colgroup>
					<col style="width: 13%"/>
					<col style="width: 45%"/>
					<col style="width: 13% "/>
					<col />
					<col style="width: 50px;"/>
				</colgroup>
				<tbody>
					<tr>
						<th>제목</th>
						<td>
							<input type="text" id="maskTitle" style="width:100%;" class="input2" value="${param.type eq 'title' ? param.keyword : '' }" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();">
						</td>
						<th>검색방법</th>
						<td>
							<span>
								<input type="radio" id="front" name="howSearch" value="front" ${ param.how_search eq 'front' or empty how_search  ? 'checked="checked"': ''} class="radio" onchange="javascript:myGrid_load();">
								<label for="front" class="radio_label">Starts With</label>
								<input type="radio" id="contain" name="howSearch" value="contain" ${ param.how_search eq 'contain' ? 'checked="checked"': ''} class="radio" onchange="javascript:myGrid_load();">
								<label for="contain" class="radio_label">Contains</label>
								<input type="radio" id="exact" name="howSearch" value="exact" ${ param.how_search eq 'exact' ? 'checked="checked"': ''} class="radio" onchange="javascript:myGrid_load();">
								<label for="exact" class="radio_label">Exact Match</label>
							</span>
						</td>
						<td rowspan="2" class="option_search_td" onclick="javascript:myGrid_load();"><em>search</em></td>
					</tr>
					<tr>
						<th>구분</th>
						<td>
							<span>
								<input type="radio" id="allSource" name="source" value="" class="radio" ${empty param.source ? 'checked="checked"': ''} onchange="javascript:myGrid_load();">
								<label for="allSource" class="radio_label">ALL</label>
								<input type="radio" id="sci" name="source" value="SCI" class="radio" ${ param.source eq 'SCI' ? 'checked="checked"': ''} onchange="javascript:myGrid_load();">
								<label for="sci" class="radio_label">SCI</label>
								<input type="radio" id="scie" name="source" value="SCIE" class="radio" ${ param.source eq 'SCIE' ? 'checked="checked"': ''} onchange="javascript:myGrid_load();">
								<label for="scie" class="radio_label">SCIE</label>
								<input type="radio" id="ssci" name="source" value="SSCI" class="radio" ${ param.source eq 'SSCI' ? 'checked="checked"': ''} onchange="javascript:myGrid_load();">
								<label for="ssci" class="radio_label">SSCI</label>
								<input type="radio" id="ahci" name="source" value="AHCI" class="radio" ${ param.source eq 'AHCI' ? 'checked="checked"': ''} onchange="javascript:myGrid_load();">
								<label for="ahci" class="radio_label">AHCI</label>
								<input type="radio" id="jcr" name="source" value="JCR" class="radio" onchange="javascript:myGrid_load();">
								<label for="jcr" class="radio_label">JCR</label>
								<input type="radio" id="scopus" name="source" value="SCOPUS" class="radio" ${ param.source eq 'SCOPUS' ? 'checked="checked"': ''} onchange="javascript:myGrid_load();">
								<label for="scopus" class="radio_label">SCOPUS</label>
								<input type="radio" id="sjr" name="source" value="SJR" class="radio" onchange="javascript:myGrid_load();">
								<label for="sjr" class="radio_label">SJR</label>
								<input type="radio" id="kci" name="source" value="KCI" class="radio" ${ param.source eq 'KCI' ? 'checked="checked"': ''} onchange="javascript:myGrid_load();">
								<label for="kci" class="radio_label">KCI</label>
							</span>
						</td>
						<th>ISSN</th>
						<td>
							<input type="text" id="maskIssn" style="width:100px;" class="input2" value="${param.type eq 'issn' ? param.keyword : '' }" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();">
						</td>
					</tr>
				</tbody>
			</table>
		</form>
		<!-- END 테이블 1 -->
		<div class="list_bt_area">
			<div class="list_set">
				<ul>
					<li><a href="#" onclick="javascript:saveChanges();" class="list_icon02">저장</a></li>
					<li><a href="#" onclick="javascript:myGrid_deleteSelectedItem();" class="list_icon10">삭제</a></li>
				</ul>
			</div>
		</div>

		<div id="mainLayout" style="position: relative; width: 100%;height: 100%;"></div>
		<script type="text/javascript">setMainLayoutHeight($('#mainLayout'));</script>
		<div id="pagingObj" style="z-index: 1; height: 60px; margin-top: 5px;" >
			<div id="pagingArea" style="z-index: 1;"></div>
		</div>
	</div>
</body>
</HTML>