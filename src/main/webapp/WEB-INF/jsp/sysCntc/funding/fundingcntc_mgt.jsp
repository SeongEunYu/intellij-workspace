<%@page import="kr.co.argonet.r2rims.util.LanguageUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="cache-Control" content="co-cache" />
<title></title>
<%@include file="../../pageInit.jsp" %>
<jsp:useBean id="now" class="java.util.Date" />
<fmt:formatDate value="${now}" var="thisYear" pattern="yyyy" />
<style type="text/css">
.list_bt_area{border: 0px solid;}
div.gridbox_dhx_terrace.gridbox table.hdr td{vertical-align: middle;}
</style>
<script type="text/javascript" src="${contextPath}/js/mainLayout.js"></script>
<script type="text/javascript">
var dhxLayout, myTabbar,  overallGrid, taskGrid, t;
$(document).ready(function(){
	var callType = '${callType}';
	setMainLayoutHeight($('#mainLayout'), -150);
	if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
	else  window.addEventListener("resize",resizeLayout, false);
	// set layout
	dhxLayout = new dhtmlXLayoutObject("mainLayout","1C");
	dhxLayout.cells("a").hideHeader();
	dhxLayout.setSizes(false);
	// set tab
	myTabbar = dhxLayout.cells("a").attachTabbar();
	myTabbar.setArrowsMode("auto");
	myTabbar.enableAutoReSize(true);
	myTabbar.addTab('a1','총괄');
	myTabbar.addTab('a2','Task');
	myTabbar.tabs('a1').attachObject('overallArea');
	myTabbar.tabs('a2').attachObject('taskArea');
	myTabbar.tabs('a1').setActive();
	// set grid
	loadOverallGrid();
	loadTaskGrid();

});
function loadOverallGrid(){
	setGridHeight($('#overallLayout'));
	overallGrid = new dhtmlXGridObject('overallLayout');
	overallGrid.setImagePath("${dhtmlXImagePath}");
	overallGrid.setHeader("선택,번호,관리번호,연구기간,연구과제명,과제번호(지원기관),과제번호(KAIST),연구비지원기관,승인여부,연구책임자,최종갱신일",null,grid_head_center_bold);
	overallGrid.setInitWidths("30,30,50,130,*,100,100,100,50,55,65");
	overallGrid.setColAlign("center,center,right,center,left,left,left,left,center,left,left");
	overallGrid.setColTypes("ch,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro");
	overallGrid.attachEvent("onXLS", doBeforeGridLoad);
	overallGrid.attachEvent("onXLE", doOnGridLoaded);
	overallGrid.attachEvent("onRowSelect", function(id, ind) {
		window.open('<c:url value="/fundingCntc/fundingCntcPopup.do?overallFlag=T&erpId="/>' + id, 'fundingcntc');
	});
	overallGrid.init();
}
function loadTaskGrid(){
	setGridHeight($('#taskLayout'));
	taskGrid = new dhtmlXGridObject('taskLayout');
	taskGrid.setImagePath("${dhtmlXImagePath}");
	taskGrid.setHeader("선택,번호,관리번호,연구기간,연구과제명,과제번호(지원기관),과제번호(KAIST),연구비지원기관,승인여부,연구책임자,최종갱신일",null,grid_head_center_bold);
	taskGrid.setInitWidths("30,30,50,130,*,100,100,100,50,55,65");
	taskGrid.setColAlign("center,center,right,center,left,left,left,left,center,left,left");
	taskGrid.setColTypes("ch,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro");
	taskGrid.attachEvent("onXLS", doBeforeGridLoad);
	taskGrid.attachEvent("onXLE", doOnGridLoaded);
	taskGrid.attachEvent("onRowSelect", function(id, ind) {
		window.open('<c:url value="/fundingCntc/fundingCntcPopup.do?overallFlag=S&erpId="/>' + id, 'fundingcntc');
	});
	taskGrid.init();
}
function overallGrid_load(){
	overallGrid.clearAndLoad('<c:url value="/fundingCntc/findOverallList.do?"/>' + $('#overallFormArea').serialize());
}
function taskGrid_load(){
	taskGrid.clearAndLoad('<c:url value="/fundingCntc/findTaskList.do?"/>' + $('#taskFormArea').serialize());
}

function resizeLayout() {
	window.clearTimeout(t);
	t = window.setTimeout(function() {
		setMainLayoutHeight($('#mainLayout'), -150);
		setGridHeight($('#overallLayout'));
		setGridHeight($('#taskLayout'));
		dhxLayout.setSizes(false);
	}, 80);
}

function doOnGridLoaded(){setTimeout(function() {dhxLayout.cells("a").progressOff();}, 100);}
function doBeforeGridLoad(){dhxLayout.cells("a").progressOn();}

function setGridHeight(obj){
	$(obj).css({'height':($('#mainLayout').height()-(20+$('.title_box').height()+$('#overallFormArea').height()))+"px"});
}
function syncData(){
	var syncUrl = "${contextPath}${sysConf['sync.funding.uri']}";
	$.ajax({ url: syncUrl, dataType: 'json' }).done(function(data){
		dhtmlx.alert(data.msg);
	});
}
</script>
</head>
<body>
<div class="title_box">
	<h3>연구비(연구과제) 연계</h3>
</div>
<div id="contents_box" class="contents_box">

	<div class="list_bt_area">
		<div class="list_set">
			<ul>
			<c:if test="${not empty sysConf['sync.funding.uri'] and sessionScope.auth.adminDvsCd eq 'M' }">
				<li><a href="#" onclick="javascript:syncData();" class="list_icon18"><spring:message code='common.button.sync'/></a></li>
			</c:if>
			</ul>
		</div>
	</div>

	<div id="overallArea">
		<form id="overallFormArea" >
			<table class="view_tbl mgb_10" >
				<colgroup>
					<col style="width: 15%;"/>
					<col style="width: 34%;"/>
					<col style="width: 15%;"/>
					<col />
					<col style="width: 50px;"/>
				</colgroup>
				<tbody>
				<tr>
					<th>상태</th>
					<td>
						<input type="radio" id="is_completedN" name="is_completed" value="N" checked="checked"/><label for="is_completedN" class="radio_label">신규</label>
						<input type="radio" id="is_completedU" name="is_completed" value="U" /><label for="is_completedU" class="radio_label">업데이트</label>
					</td>
					<th>승인여부</th>
					<td>
						<input type="radio" id="projectStatusCode0" name="project_status_code" value="" /><label for="projectStatusCode0" class="radio_label">전체</label>
						<input type="radio" id="projectStatusCode1" name="project_status_code" value="APPROVED" checked="checked" /><label for="projectStatusCode1" class="radio_label">승인</label>
						<input type="radio" id="projectStatusCode2" name="project_status_code" value="UNAPPROVED" /><label for="projectStatusCode2" class="radio_label">미승인</label>
						<input type="radio" id="projectStatusCode3" name="project_status_code" value="REJECTED" /><label for="projectStatusCode3" class="radio_label">거절</label>
						<input type="radio" id="projectStatusCode4" name="project_status_code" value="CLOSED" /><label for="projectStatusCode4" class="radio_label">종료</label>
					</td>
					<td rowspan="4" class="option_search_td" onclick="javascript:overallGrid_load();"><em>search</em></td>
				</tr>
				<tr>
					<th>과제번호(KAIST)</th>
					<td><input type="text" name="project_code" class="input2" onKeyup="javascript:if(event.keyCode=='13')overallGrid_load();"/></td>
					<th>입력년월일</th>
					<td>
						<input type="text" name="startDate" class="input2" maxlength="8" style="width: 80px;" value="${thisYear}0101" onKeyup="javascript:if(event.keyCode=='13')overallGrid_load();"/>
						~ <input type="text" name="endDate" class="input2" maxlength="8" style="width: 80px;" onKeyup="javascript:if(event.keyCode=='13')overallGrid_load();"/>
					</td>
				</tr>
				<tr>
					<th>연구책임자 성명</th>
					<td><input type="text" name="project_pm" class="input2" onKeyup="javascript:if(event.keyCode=='13')overallGrid_load();"/></td>
					<th>연구책임자 사번</th>
					<td><input type="text" name="project_pmnum" class="input2" onKeyup="javascript:if(event.keyCode=='13')overallGrid_load();"/></td>
				</tr>
				<tr>
					<th>연구과제명</th>
					<td colspan="3"><input type="text" name="project_name" class="input2" style="width: 100%;" onKeyup="javascript:if(event.keyCode=='13')overallGrid_load();"/></td>
				</tr>
				</tbody>
			</table>
		</form>
		<div id="overallLayout" style="width: 100%;"></div>
	</div>
	<div id="taskArea">
		<form id="taskFormArea" >
			<table class="view_tbl mgb_10" >
				<colgroup>
					<col style="width: 15%;"/>
					<col style="width: 34%;"/>
					<col style="width: 15%;"/>
					<col />
					<col style="width: 50px;"/>
				</colgroup>
				<tbody>
				<tr>
					<th>상태</th>
					<td>
						<input type="radio" id="is_completedN" name="is_completed" value="N" checked="checked"/><label for="is_completedN" class="radio_label">신규</label>
						<input type="radio" id="is_completedU" name="is_completed" value="U" /><label for="is_completedU" class="radio_label">업데이트</label>
					</td>
					<th>승인여부</th>
					<td>
						<input type="radio" id="projectStatusCode0" name="project_status_code" value="" /><label for="projectStatusCode0" class="radio_label">전체</label>
						<input type="radio" id="projectStatusCode1" name="project_status_code" value="APPROVED" checked="checked" /><label for="projectStatusCode1" class="radio_label">승인</label>
						<input type="radio" id="projectStatusCode2" name="project_status_code" value="UNAPPROVED" /><label for="projectStatusCode2" class="radio_label">미승인</label>
						<input type="radio" id="projectStatusCode3" name="project_status_code" value="REJECTED" /><label for="projectStatusCode3" class="radio_label">거절</label>
						<input type="radio" id="projectStatusCode4" name="project_status_code" value="CLOSED" /><label for="projectStatusCode4" class="radio_label">종료</label>
					</td>
					<td rowspan="4" class="option_search_td" onclick="javascript:taskGrid_load();"><em>search</em></td>
				</tr>
				<tr>
					<th>과제번호(KAIST)</th>
					<td><input type="text" name="project_code" class="input2" onKeyup="javascript:if(event.keyCode=='13')taskGrid_load();"/></td>
					<th>입력년월일</th>
					<td>
						<input type="text" name="startDate" class="input2" maxlength="8" style="width: 80px;" value="20180101" onKeyup="javascript:if(event.keyCode=='13')taskGrid_load();"/>
						~ <input type="text" name="endDate" class="input2" maxlength="8" style="width: 80px;" onKeyup="javascript:if(event.keyCode=='13')taskGrid_load();"/>
					</td>
				</tr>
				<tr>
					<th>연구책임자 성명</th>
					<td><input type="text" name="task_manager" class="input2" onKeyup="javascript:if(event.keyCode=='13')taskGrid_load();"/></td>
					<th>연구책임자 사번</th>
					<td><input type="text" name="project_pmnum" class="input2" onKeyup="javascript:if(event.keyCode=='13')taskGrid_load();"/></td>
				</tr>
				<tr>
					<th>연구과제명</th>
					<td colspan="3"><input type="text" name="project_name" class="input2" style="width: 100%;" onKeyup="javascript:if(event.keyCode=='13')taskGrid_load();"/></td>
				</tr>
				</tbody>
			</table>
		</form>
		<div id="taskLayout" style="width: 100%;"></div>
	</div>
	<div id="mainLayout" style="position: relative; width: 100%;height: 100%;"></div>
</div>
<form id="findItem" action="${contextPath}/article/article.do" method="post" target="item">
	<input type="hidden" id=userId name="srchUserId" value=""/>
	<input type="hidden" id="item_id" name="item_id" value=""/>
</form>
</body>
</html>