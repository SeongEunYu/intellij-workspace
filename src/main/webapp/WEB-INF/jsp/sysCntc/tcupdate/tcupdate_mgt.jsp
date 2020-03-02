<%@page import="kr.co.argonet.r2rims.constant.R2Constant"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@
    page import="java.util.Map"%><%@
    page import="java.util.List"%><%@
    page import="kr.co.argonet.r2rims.core.code.CodeConfiguration"%><%@
    page import="org.apache.commons.lang3.StringUtils"%><%@
    page import="org.apache.commons.lang3.ObjectUtils"%><%
	String contextTitle = application.getInitParameter("contextTitle");
	String type = request.getParameter("type")==null?"":request.getParameter("type");
%><!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=contextTitle %></title>
<%@include file="../../pageInit.jsp" %>
<script type="text/javascript" src="${contextPath}/js/mainLayout.js"></script>
<script type="text/javascript">
var dhxLayout, myGrid, myDp, t;
var autoRefreshHistory;
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
    myGrid.setHeader("번호,설명,대상구분,작업형태,작업시작일자,작업종료일자,총작업시간,전체건수,작업건수,에러건수,상태,비고", null, grid_head_center_bold);
    myGrid.setColumnIds("number,description,sourcDvsnCd,workType,workStart,workEnd,leadTime,trgtCnt,workedCnt,errCnt,status,error");
    myGrid.setInitWidths("40,*,80,80,80,80,80,80,80,80,80,100");
    myGrid.setColAlign("center,left,center,center,center,center,center,center,center,center,center,center,center");
	myGrid.setColSorting("na,na,na,na,na,na,na,na,na,na,na,na,na");
	myGrid.setColTypes("ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro");
	myGrid.attachEvent("onBeforeSorting",myGrid_onBeforeSorting);
	myGrid.attachEvent("onXLS", doBeforeGridLoad);
	myGrid.attachEvent("onXLE", doOnGridLoaded);
	myGrid.enableMultiselect(true);
    myGrid.enablePaging(true,100,10,"pagingArea",true,"infoArea");
    myGrid.setPagingSkin("${dhtmlXPagingSkin}");
    myGrid.enableColSpan(true);
	myGrid.init();
	myGrid_load();
});


function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){ dhxLayout.setSizes(false); },200);}
function doOnGridLoaded(){ setTimeout(function() {dhxLayout.cells("a").progressOff();}, 100);}
function doBeforeGridLoad(){dhxLayout.cells("a").progressOn();}

function myGrid_onBeforeSorting(ind, gridObj, direct) {
	var indObj = '';
	if 		(ind == 3) indObj = 'org_lang_ppr_nm';
	else if (ind == 4) indObj = 'scjnl_nm';
	else if (ind == 5) indObj = 'pblc_ym';
	else if (ind == 6) indObj = 'is_open_files';
	else if (ind == 7) indObj = 'koa_flag';
	else return false;
	myGrid.clearAndLoad("${contextPath}/tcUpdate/findTcUpdateList.do?" + $('#formArea').serialize() + "&orderby=" + indObj + "&direct=" + direct);
	myGrid.setSortImgState(true, ind, direct);
}

function myGrid_load() {
	myGrid.clearAndLoad("${contextPath}/tcUpdate/findTcUpdateList.do?" + $('#formArea').serialize());
}

function tcUpdate(gubun){
	var url = "${contextPath}/tcUpdate/";
	if(gubun == '<%=R2Constant.SOURC_TYPE_WOS%>')
		url += 'wosTcUpdate.do';
	else if(gubun == '<%=R2Constant.SOURC_TYPE_SCOPUS%>')
		url += 'scopusTcUpdate.do';
	else if(gubun == '<%=R2Constant.SOURC_TYPE_KCI%>')
		url += 'kciTcUpdate.do';

	$.ajax({
		url: url,
		dataType: 'json',
		method:'GET',
	}).done(function(data) {
		if(data.code == '001')
		{
			dhtmlx.alert({type:"alert-warning",text:"TC Update 중에 에러가 발생하였습니다. <br/> 개발자에게 문의하세요.",callback:function(){}})
		}
		else if(data.code == '002')
		{
			dhtmlx.alert({type:"alert-warning",text:"업데이트 진행 중인 작업이 있습니다. <br/> 작업 완료 후 다시 실행해주세요. ",callback:function(){}})
		}
		else if(data.code == '010')
		{
			$('#chkAutoRefresh').prop('checked','checked');
			toggleAutoRefresh();
			dhtmlx.alert({type:"alert-warning",text:"TC Update 정상적으로 실행하였습니다.",callback:function(){}})
		}
	});

}
function toggleAutoRefresh(){
	if($('#chkAutoRefresh').prop("checked") == true)
	{
		autoRefreshHistory = setInterval(function(){myGrid_load();}, 5000);
	}
	else
	{
		clearTimeout(autoRefreshHistory);
	}
}
</script>
</head>
<body>

	<div class="title_box" >
		<h3>Times Cited</h3>
	</div>

	<!-- Main Content -->
	<div class="contents_box">
	<form id="formArea">
		<table class="view_tbl mgb_10">
			<colgroup>
				<col style="width: 10%;"/>
				<col style="width: 37%;"/>
				<col style="width: 10%;"/>
				<col />
				<col style="width: 50px;"/>
			</colgroup>
			<tbody>
			<tr>
				<th>대상구분</th>
				<td>
					<input type="radio" name="sourcDvsnCd" id="sourcDvsnCd1" onclick="myGrid_load();" value="" class="radio" checked="checked"/>
						<label for="sourcDvsnCd1" class="radio_label">전체</label>
					<input type="radio" name="sourcDvsnCd" id="sourcDvsnCd2" onclick="myGrid_load();" value="<%=R2Constant.SOURC_TYPE_WOS%>" class="radio" />
						<label for="sourcDvsnCd2" class="radio_label">WOS</label>
					<input type="radio" name="sourcDvsnCd" id="sourcDvsnCd3" onclick="myGrid_load();" value="<%=R2Constant.SOURC_TYPE_SCOPUS%>" class="radio" />
						<label for="sourcDvsnCd3" class="radio_label">SCOPUS</label>
					<input type="radio" name="sourcDvsnCd" id="sourcDvsnCd4" onclick="myGrid_load();" value="<%=R2Constant.SOURC_TYPE_KCI%>" class="radio" />
						<label for="sourcDvsnCd4" class="radio_label">KCI</label>
				</td>
				<th>시작일자</th>
				<td>
					<input type="text" name="sttDate" id="sttDate" class="input2"  maxlength="8" style="width: 80px;"  onKeyup="javascript:if(event.keyCode=='13')myGrid_load();" />
						~ <input type="text" name="endDate" id="endDate"  class="input2" maxlength="8" style="width: 80px;" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/>
				</td>
				<td rowspan="3" class="option_search_td" onclick="javascript: myGrid_load();"><em>search</em></td>
			</tr>
			<tr>
			</tr>
			<tr>
				<th>작업형태</th>
				<td>
					<input type="radio" name="workType" id="workType1" value="" onclick="myGrid_load();" class="radio" checked="checked"/>
						<label for="workType1" class="radio_label">전체</label>
					<input type="radio" name="workType" id="workType2" value="<%=R2Constant.TCUPDATE_WORKTYPE_MANUAL %>"  onclick="myGrid_load();" class="radio" />
						<label for="workType2" class="radio_label">Manual</label>
					<input type="radio" name="workType" id="workType3" value="<%=R2Constant.TCUPDATE_WORKTYPE_SCHEDULE %>" onclick="myGrid_load();" class="radio" />
						<label for="workType3" class="radio_label">Schedule</label>
					<input type="radio" name="workType" id="workType4" value="<%=R2Constant.TCUPDATE_WORKTYPE_COMMAND %>" onclick="myGrid_load();" class="radio" />
						<label for="workType4" class="radio_label">Command</label>
				</td>
				<th>작업상태</th>
				<td>
					<input type="radio" name="status" id="status1" value="" onclick="myGrid_load();" class="radio" checked="checked"/>
						<label for="status1" class="radio_label">전체</label>
					<input type="radio" name="status" id="status2" value="<%=R2Constant.TCUPDATE_STATUS_WORKING %>" onclick="myGrid_load();" class="radio" />
						<label for="status2" class="radio_label">작업중</label>
					<input type="radio" name="status" id="status3" value="<%=R2Constant.TCUPDATE_STATUS_FINISH %>" onclick="myGrid_load();" class="radio" />
						<label for="status3" class="radio_label">작업완료</label>
					<input type="radio" name="status" id="status4" value="<%=R2Constant.TCUPDATE_STATUS_ERROR %>" onclick="myGrid_load();" class="radio" />
						<label for="status4" class="radio_label">에러</label>
				</td>
			</tr>
			<tr>
			</tr>
			</tbody>
		</table>
	</form>

		<div class="list_bt_area">
			<div style="float: left;vertical-align: bottom;margin-top: 8px;">
				<input type="checkbox" id="chkAutoRefresh" value="R" class="radio" onclick="javascript:toggleAutoRefresh();"/>
				<label for="" class="radio_label" style="margin: 0 7px 0 2px;">Auto Refresh(5초간격)</label>
			</div>
			<div class="list_set">
				<ul>
					<li><a href="#" onclick="javascript:tcUpdate('WOS');" class="list_icon14">WOS Update</a></li>
					<li><a href="#" onclick="javascript:tcUpdate('SCP');" class="list_icon14">SCOPUS Update</a></li>
					<li><a href="#" onclick="javascript:tcUpdate('KCI');" class="list_icon14">KCI Update</a></li>
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
</html>