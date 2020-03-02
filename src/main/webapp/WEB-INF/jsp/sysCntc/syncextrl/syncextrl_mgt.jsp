<%@page import="kr.co.argonet.r2rims.constant.R2Constant"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@include file="../../pageInit.jsp" %>
<jsp:useBean id="now" class="java.util.Date" />
<fmt:formatDate value="${now}" var="thisDate" pattern="yyyy-MM-dd" />
<style type="text/css">
.list_bt_area .stdr_text {float: right;  line-height: 26px; padding: 0 0 0 14px; }
</style>
<script type="text/javascript" src="${contextPath}/js/mainLayout.js"></script>
<script type="text/javascript">
var dhxLayout, myGrid, myDp, t;
var autoRefreshHistory, dhxCanlendar;
$(document).ready(function(){

	setMainLayoutHeight($('#mainLayout'));
	if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
	else  window.addEventListener("resize",resizeLayout, false);
	//set layout
	dhxLayout = new dhtmlXLayoutObject("mainLayout","1C");
	dhxLayout.cells("a").hideHeader();
	dhxLayout.setSizes(false);
	//attach myGrid
    myGrid = dhxLayout.cells("a").attachGrid();
    myGrid.setImagePath("${dhtmlXImagePath}");
    myGrid.setHeader("번호,작업형태,대상구분,기준일자,동기화시작일자,동기화종료일자,총작업시간,전체,신규,수정,비고", null, grid_head_center_bold);
    myGrid.setColumnIds("number,syncType,stdrDate,syncTarget,syncStart,syncEnd,leadTime,trgtCo,insertCo,updateCo,syncRm");
    myGrid.setInitWidths("40,100,120,120,130,130,130,100,100,80,*");
    myGrid.setColAlign("center,center,center,center,center,center,center,center,center,center,left");
	myGrid.setColSorting("na,na,na,na,na,na,na,na,na,na,na");
	myGrid.setColTypes("ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro");
	myGrid.attachEvent("onBeforeSorting",myGrid_onBeforeSorting);
	myGrid.attachEvent("onXLS", doBeforeGridLoad);
	myGrid.attachEvent("onXLE", doOnGridLoaded);
	myGrid.enableMultiselect(true);
    myGrid.enablePaging(true,100,10,"pagingArea",true,"infoArea");
    myGrid.setPagingSkin("${dhtmlXPagingSkin}");
    myGrid.enableColSpan(true);
	myGrid.init();
	myGrid_load();

	dhxCanlendar = new dhtmlXCalendarObject("stdrDate");
	dhxCanlendar.hideTime();
	// dhxCanlendar.loadUserLanguage("ko");
	dhxCanlendar.setPosition("bottom");
	dhxCanlendar.setWeekStartDay(7); // 달력을 일요일부터 시작
});


function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){ setMainLayoutHeight($('#mainLayout')); dhxLayout.setSizes(false); },200);}
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
	myGrid.clearAndLoad("${contextPath}/syncExtrl/findSyncHistList.do?" + $('#formArea').serialize() + "&orderby=" + indObj + "&direct=" + direct);
	myGrid.setSortImgState(true, ind, direct);
}

function myGrid_load() {
	myGrid.clearAndLoad("${contextPath}/syncExtrl/findSyncHistList.do?" + $('#formArea').serialize());
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

function syncData(){

	var syncUrl = "";
	var syncTrgetNm = "";
	var syncTrget = $('input:radio[name="syncTarget"]:checked').val();

	if(syncTrget == 'USR')
	{
		syncUrl = "${contextPath}${sysConf['sync.user.uri']}";
		syncTrgetNm = "교원";
	}
	else if(syncTrget == 'ACT')
	{
		syncUrl = "${contextPath}${sysConf['sync.activity.uri']}";
		syncTrgetNm = "기타활동실적";
	}
	else if(syncTrget == 'LCN')
	{
		syncUrl = "${contextPath}${sysConf['sync.license.uri']}";
		syncTrgetNm = "자격사항";
	}
	else if(syncTrget == 'DGR')
	{
		syncUrl = "${contextPath}${sysConf['sync.degree.uri']}";
		syncTrgetNm = "취득학위";
	}
	else if(syncTrget == 'AWD')
	{
		syncUrl = "${contextPath}${sysConf['sync.award.uri']}";
		syncTrgetNm = "수상사항";
	}
	else if(syncTrget == 'CAR')
	{
		syncUrl = "${contextPath}${sysConf['sync.career.uri']}";
		syncTrgetNm = "경력사항";
	}
	else if(syncTrget == 'OFUD' || syncTrget == 'TFUD')
	{
		syncUrl = "${contextPath}${sysConf['sync.funding.uri']}";
		syncTrgetNm = "연구과제";
	}

	if(syncUrl == null || syncUrl == '')
	{
		dhtmlx.alert({type:"alert-warning",text:"동기화대상을 선택하지 않았거나<br/>동기화를 지원하지 않는 대상입니다.",callback:function(){return;}});
		return;
	}
	else
	{
		dhtmlx.confirm({
			title:"동기화 실행",
			ok:"Yes", cancel:"No",
			text: syncTrgetNm + " 동기화 실행하시겠습니까?<br/>(기준일자:"+$('#stdrDate').val()+")",
			callback:function(result){
				if(result){
					$.get(syncUrl, {'stdrDate':$('#stdrDate').val()},null,'json').done(function(data){
						dhtmlx.alert(data.msg);
						myGrid_load();
					});
				}
				else return;
			}
		});
		//alert($('#stdrDate').val());
		/*
		$.post(syncUrl, {'stdrDate':$('#stdrDate').val()},null,'json').done(function(data){
			dhtmlx.alert(data.msg);
			myGrid_load();
		});

		$.ajax({ url: syncUrl, dataType: 'json' }).done(function(data){
			dhtmlx.alert(data.msg);
		});
		*/
	}


}

</script>
</head>
<body>

	<div class="title_box" >
		<h3><spring:message code='menu.cntc.syncextrl'/></h3>
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
				<td colspan="3">
					<input type="radio" name="syncTarget" id="syncTargetAll" onclick="myGrid_load();" value="" class="radio" checked="checked"/>
						<label for="syncTargetAll" class="radio_label">전체</label>
					<input type="radio" name="syncTarget" id="syncTarget1" onclick="myGrid_load();" value="USR" class="radio" />
						<label for="syncTarget1" class="radio_label">교원</label>
					<input type="radio" name="syncTarget" id="syncTarget2" onclick="myGrid_load();" value="ACT" class="radio" />
						<label for="syncTarget2" class="radio_label">기타활동실적</label>
					<input type="radio" name="syncTarget" id="syncTarget3" onclick="myGrid_load();" value="LCN" class="radio" />
						<label for="syncTarget3" class="radio_label">자격사항</label>
					<input type="radio" name="syncTarget" id="syncTarget4" onclick="myGrid_load();" value="DGR" class="radio" />
						<label for="syncTarget4" class="radio_label">취득학위</label>
					<input type="radio" name="syncTarget" id="syncTarget5" onclick="myGrid_load();" value="AWD" class="radio" />
						<label for="syncTarget5" class="radio_label">수상사항</label>
					<input type="radio" name="syncTarget" id="syncTarget6" onclick="myGrid_load();" value="CAR" class="radio" />
						<label for="syncTarget6" class="radio_label">경력사항</label>
					<input type="radio" name="syncTarget" id="syncTarget7" onclick="myGrid_load();" value="OFUD" class="radio" />
						<label for="syncTarget7" class="radio_label">연구과제(총괄)</label>
					<input type="radio" name="syncTarget" id="syncTarget8" onclick="myGrid_load();" value="TFUD" class="radio" />
						<label for="syncTarget8" class="radio_label">연구과제(Task)</label>
					<input type="radio" name="syncTarget" id="syncTarget9" onclick="myGrid_load();" value="RID" class="radio" />
						<label for="syncTarget9" class="radio_label">WOS_RID(Profile)</label>
					<input type="radio" name="syncTarget" id="syncTarget10" onclick="myGrid_load();" value="PUB" class="radio" />
						<label for="syncTarget10" class="radio_label">WOS_RID(Publication)</label>
				</td>
				<td rowspan="3" class="option_search_td" onclick="javascript: myGrid_load();"><em>search</em></td>
			</tr>
			<tr>
				<th>작업형태</th>
				<td>
					<input type="radio" name="syncType" id="syncType1" value="" onclick="myGrid_load();" class="radio" checked="checked"/>
						<label for="" class="radio_label">전체</label>
					&nbsp;<input type="radio" name="syncType" id="syncType2" value="<%=R2Constant.TCUPDATE_WORKTYPE_MANUAL %>"  onclick="myGrid_load();" class="radio" />
						<label for="" class="radio_label">Manual</label>
					&nbsp;<input type="radio" name="syncType" id="syncType3" value="<%=R2Constant.TCUPDATE_WORKTYPE_SCHEDULE %>" onclick="myGrid_load();" class="radio" />
						<label for="" class="radio_label">Schedule</label>
					&nbsp;<input type="radio" name="syncType" id="syncType4" value="<%=R2Constant.TCUPDATE_WORKTYPE_COMMAND %>" onclick="myGrid_load();" class="radio" />
						<label for="" class="radio_label">Command</label>
				</td>
				<th>동기화시작일자</th>
				<td>
					<input type="text" name="sttDate" id="sttDate" class="input2"  maxlength="8" style="width: 80px;"  onKeyup="javascript:if(event.keyCode=='13')myGrid_load();" />
						~ <input type="text" name="endDate" id="endDate"  class="input2" maxlength="8" style="width: 80px;" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/>
				</td>
			</tr>
			</tbody>
		</table>
	</form>
		<div class="list_bt_area">
			<div class="list_set">
				<ul>
					<li><a href="#" onclick="javascript:syncData();" class="list_icon18">동기화</a></li>
				</ul>
			</div>
			<span class="stdr_text">
				기준일자:<input type="text" id="stdrDate" name="stdrDate" class="input_type" style="height: 27px; width: 150px;" value="${thisDate}"/>
			</span>
		</div>
		<div id="mainLayout" style="position: relative; width: 100%;height: 100%;"></div>
		<div id="pagingObj" style="z-index: 1; height: 60px; margin-top: 5px;" >
			<div id="pagingArea" style="z-index: 1;"></div>
		</div>
	</div>
</body>
</html>