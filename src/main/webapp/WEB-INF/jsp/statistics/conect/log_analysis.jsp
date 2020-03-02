<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="../../pageInit.jsp" %>
<script type="text/javascript" src="${contextPath}/js/mainLayout.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/chart/fusioncharts.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/chart/fusioncharts-jquery-plugin.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/chart/opts/fusioncharts.opts.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery/jquery.filedownload.js"></script>
<script type="text/javascript">
var dhxLayout, myTabbar, t, dhxSttDateCal, dhxEndDateCal, chartHeight = '350';
$(document).ready(function(){
	setMainLayoutHeight($('#mainLayout'), -40);
	if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
	else  window.addEventListener("resize",resizeLayout, false);
	//set layout
	dhxLayout = new dhtmlXLayoutObject("mainLayout","1C");
	dhxLayout.cells("a").hideHeader();
	dhxLayout.setSizes(false);

	myTabbar = dhxLayout.cells("a").attachTabbar();
	myTabbar.setArrowsMode("auto");
	myTabbar.enableAutoReSize(true);

	myTabbar.addTab('a1','전체');
	myTabbar.addTab('a2','권한별');
	myTabbar.addTab('a3','신분별');
	myTabbar.addTab('a6','학과별');
	myTabbar.addTab('a4','주요성과별');
	myTabbar.addTab('a5','기타성과별');
	myTabbar.tabs('a4').hide();
	myTabbar.tabs('a5').hide();

	myTabbar.tabs('a1').attachObject('allTab');
	myTabbar.cells('a1').showInnerScroll();
	myTabbar.tabs('a2').attachObject('authorTab');
	myTabbar.cells('a2').showInnerScroll();
	myTabbar.tabs('a3').attachObject('sclpstTab');
	myTabbar.cells('a3').showInnerScroll();
	myTabbar.tabs('a4').attachObject('mainRsltTab');
	myTabbar.cells('a4').showInnerScroll();
	myTabbar.tabs('a5').attachObject('etcRsltTab');
	myTabbar.cells('a5').showInnerScroll();
	myTabbar.tabs('a6').attachObject('deptTab');
	myTabbar.cells('a6').showInnerScroll();

	myTabbar.tabs('a1').setActive();
	myTabbar.attachEvent("onSelect", loadTabCnts);

	setObjectHeight($('#allTabCnts'));
	setObjectHeight($('#authorTabCnts'));
	setObjectHeight($('#sclpstTabCnts'));
	setObjectHeight($('#conectrTabCnts'));
	setObjectHeight($('#mainRsltTabCnts'));
	setObjectHeight($('#etcRsltTabCnts'));
	setObjectHeight($('#deptTabCnts'));

	dhxSttDateCal = new dhtmlXCalendarObject("sttDate");
	dhxSttDateCal.hideTime();
	dhxSttDateCal.loadUserLanguage("ko");
	dhxEndDateCal = new dhtmlXCalendarObject("endDate");
	dhxEndDateCal.hideTime();
	dhxEndDateCal.loadUserLanguage("ko");

	//myTabbar_load();
	changeDateFormat($('#dateFormat_ymd'));
});

function myTabbar_load(){

	if($('#adminSrchDeptTrack').length)
	{
		var val = $('#adminSrchDeptTrack').val();
		if(val != null && val != '')
		{
			if(val.indexOf('DEPT_') != -1 ){
				$('#adminSrchDeptKor').val(val.replace('DEPT_',''));
				$('#adminSrchTrack').val('');
			}
			if(val.indexOf('TRACK_') != -1 ){
				$('#adminSrchDeptKor').val('');
				$('#adminSrchTrack').val(val.replace('TRACK_',''));
			}
		}
		else
		{
			$('#adminSrchDeptKor').val('');
			$('#adminSrchTrack').val('');
		}
	}

	loadTabCnts(myTabbar.getActiveTab());
}

function loadTabCnts(id, lastId){
	detoryChart();

	if(id == 'a1')
	{
		drowAllTabChart();
	}
	else if(id == 'a2')
	{
		drowAuthTabChart();
	}
	else if(id == 'a3')
	{
		drowSclpstTabChart();
	}
	else if(id == 'a4')
	{
		drowMainRsltTabChart();
	}
	else if(id == 'a5')
	{
		drowEtcRsltTabChart();
	}
	else if(id == 'a6')
	{
		drowDeptTabChart();
	}

	return true;
}

function exportExcel(tabId){
	doBeforeTabLoad(tabId);
	var chartObject = getChartFromId(tabId + 'Chart');
	if( chartObject.hasRendered() ){
		chartObject.exportChart( { exportFormat : 'png'} );
	}
	else
	{
		doOnTabLoaded(tabId);
	}
}

function exportAfter(objRtn){
 	if (objRtn.statusCode=="1"){
		 //saveExcel(objRtn.fileName);
		 download_file(objRtn.fileName);
		 //alert("The chart was successfully saved on server. The file can be accessed from " + objRtn.fileName);
	}else{
		alert("The chart could not be saved on server. There was an error. Description : " + objRtn.statusMessage);
		doOnTabLoaded(myTabbar.getActiveTab());
	}
}

function download_file(imageUrl){
	var url = "";
	var tableData = encodeURIComponent($('#'+myTabbar.getActiveTab()+'_data_tbl').clone().wrapAll('<div/>').parent().html());
	url = "${contextPath}/statistics/conect/downloadExcelFile.do?imageUrl="+encodeURIComponent(imageUrl)+'&tableData='+ tableData;
	var expAnchor = $('<a class="exp_anchor" href="'+url+'"></a>');
	$("body").append(expAnchor);
	$('a.exp_anchor').bind('click',function(){
		$.fileDownload($(this).prop('href'),{
			successCallback: function (url) {
				$('a.exp_anchor').remove();
				doOnTabLoaded(myTabbar.getActiveTab());
			},
			failCallback: function (responseHtml, url) {
				$('a.exp_anchor').remove();
				doOnTabLoaded(myTabbar.getActiveTab());
            }
		});
	}).triggerHandler('click');
}

function detoryChart(){
	$('.list_tbl').empty();
	$('#all_tab_chart_container').disposeFusionCharts();
	$('#author_tab_chart_container').disposeFusionCharts();
	$('#sclpst_tab_chart_container').disposeFusionCharts();
	$('#mainRslt_tab_chart_container').disposeFusionCharts();
	$('#etcRslt_tab_chart_container').disposeFusionCharts();
	$('#dept_tab_chart_container').disposeFusionCharts();
}

var drowDeptTabChart = function(){
	doBeforeTabLoad('a6');
	setObjectHeight($('#deptTabCnts'));
	var a6ChartOpt = $.extend(true, {}, chartOpt);
	a6ChartOpt['id'] = 'a6Chart';
	a6ChartOpt['type'] = 'msline';
	a6ChartOpt['renderAt'] = 'dept_tab_chart_container';
	a6ChartOpt['height'] = chartHeight;
	a6ChartOpt.dataSource.chart['xAxisName'] = 'Date';
	a6ChartOpt.dataSource.chart['exportHandler'] = '${contextPath}/servlet/FCExporter/export.do';

	$.post("${contextPath}/statistics/conect/deptTabChartData.do", $('#formArea').serializeArray(),null,'json').done(function(data){

		$('#dept_tab_chart_container').off('fusionchartsrendercomplete').on('fusionchartsrendercomplete',function (eventObj, dataObj){
			renderDataTable(getChartFromId('a6Chart'), 'a6_data_tbl', 'a6');
		});

		a6ChartOpt.dataSource['categories'] = data.categories;
		a6ChartOpt.dataSource['dataset'] = data.dataset;
		$('#dept_tab_chart_container').insertFusionCharts(a6ChartOpt);

	});
}

var drowMainRsltTabChart = function(){
	doBeforeTabLoad('a4');
	setObjectHeight($('#mainRsltTabCnts'));
	var a4ChartOpt = $.extend(true, {}, chartOpt);
	a4ChartOpt['id'] = 'a4Chart';
	a4ChartOpt['type'] = 'msline';
	a4ChartOpt['renderAt'] = 'mainRslt_tab_chart_container';
	a4ChartOpt['height'] = chartHeight;
	a4ChartOpt.dataSource.chart['xAxisName'] = 'Date';
	a4ChartOpt.dataSource.chart['exportHandler'] = '${contextPath}/servlet/FCExporter/export.do';

	$.post("${contextPath}/statistics/conect/mainRsltTabChartData.do", $('#formArea').serializeArray(),null,'json').done(function(data){

		$('#mainRslt_tab_chart_container').off('fusionchartsrendercomplete').on('fusionchartsrendercomplete',function (eventObj, dataObj){
			renderDataTable(getChartFromId('a4Chart'), 'a4_data_tbl', 'a4');
		});

		a4ChartOpt.dataSource['categories'] = data.categories;
		a4ChartOpt.dataSource['dataset'] = data.dataset;
		$('#mainRslt_tab_chart_container').insertFusionCharts(a4ChartOpt);

	});
}
var drowEtcRsltTabChart = function(){
	doBeforeTabLoad('a5');
	setObjectHeight($('#etcRsltTabCnts'));
	var a5ChartOpt = $.extend(true, {}, chartOpt);
	a5ChartOpt['id'] = 'a5Chart';
	a5ChartOpt['type'] = 'msline';
	a5ChartOpt['renderAt'] = 'etcRslt_tab_chart_container';
	a5ChartOpt['height'] = chartHeight;
	a5ChartOpt.dataSource.chart['xAxisName'] = 'Date';
	a5ChartOpt.dataSource.chart['exportHandler'] = '${contextPath}/servlet/FCExporter/export.do';

	$.post("${contextPath}/statistics/conect/etcRsltTabChartData.do", $('#formArea').serializeArray(),null,'json').done(function(data){

		$('#etcRslt_tab_chart_container').off('fusionchartsrendercomplete').on('fusionchartsrendercomplete',function (eventObj, dataObj){
			renderDataTable(getChartFromId('a5Chart'), 'a5_data_tbl', 'a5');
		});

		a5ChartOpt.dataSource['categories'] = data.categories;
		a5ChartOpt.dataSource['dataset'] = data.dataset;
		$('#etcRslt_tab_chart_container').insertFusionCharts(a5ChartOpt);

	});
}

var drowSclpstTabChart = function(){
	doBeforeTabLoad('a3');
	setObjectHeight($('#sclpstTabCnts'));
	var a3ChartOpt = $.extend(true, {}, chartOpt);
	a3ChartOpt['id'] = 'a3Chart';
	a3ChartOpt['type'] = 'mscolumn2d';
	a3ChartOpt['renderAt'] = 'sclpst_tab_chart_container';
	a3ChartOpt['height'] = chartHeight;
	a3ChartOpt.dataSource.chart['xAxisName'] = 'Date';
	a3ChartOpt.dataSource.chart['yAxisName'] = 'Count';
	a3ChartOpt.dataSource.chart['exportHandler'] = '${contextPath}/servlet/FCExporter/export.do';

	$.post("${contextPath}/statistics/conect/sclpstTabChartData.do", $('#formArea').serializeArray(),null,'json').done(function(data){

		$('#sclpst_tab_chart_container').off('fusionchartsrendercomplete').on('fusionchartsrendercomplete',function (eventObj, dataObj){
			renderDataTable(getChartFromId('a3Chart'), 'a3_data_tbl', 'a3');
		});

		a3ChartOpt.dataSource['categories'] = data.categories;
		a3ChartOpt.dataSource['dataset'] = data.dataset;
		$('#sclpst_tab_chart_container').insertFusionCharts(a3ChartOpt);

	});
}

var drowAuthTabChart = function(){
	doBeforeTabLoad('a2');
	setObjectHeight($('#authorTabCnts'));
	var a2ChartOpt = $.extend(true, {}, chartOpt);
	a2ChartOpt['id'] = 'a2Chart';
	a2ChartOpt['type'] = 'msline';
	a2ChartOpt['renderAt'] = 'author_tab_chart_container';
	a2ChartOpt['height'] = chartHeight;
	a2ChartOpt.dataSource.chart['xAxisName'] = 'Date';
	a2ChartOpt.dataSource.chart['yAxisName'] = 'Count';
	a2ChartOpt.dataSource.chart['exportHandler'] = '${contextPath}/servlet/FCExporter/export.do';

	$.post("${contextPath}/statistics/conect/authorityTabChartData.do", $('#formArea').serializeArray(),null,'json').done(function(data){

		$('#author_tab_chart_container').off().on('fusionchartsrendercomplete',function (eventObj, dataObj){
			renderDataTable(getChartFromId('a2Chart'), 'a2_data_tbl', 'a2');
		});

		a2ChartOpt.dataSource['categories'] = data.categories;
		a2ChartOpt.dataSource['dataset'] = data.dataset;
		$('#author_tab_chart_container').insertFusionCharts(a2ChartOpt);

	});

}

var drowAllTabChart = function(){
	doBeforeTabLoad('a1');
	setObjectHeight($('#allTabCnts'));
	var a1ChartOpt = $.extend(true, {}, chartOpt);
	a1ChartOpt['id'] = 'a1Chart';
	a1ChartOpt['type'] = 'line';
	a1ChartOpt['renderAt'] = 'all_tab_chart_container';
	a1ChartOpt['height'] = chartHeight;
	a1ChartOpt.dataSource.chart['xAxisName'] = 'Date';
	a1ChartOpt.dataSource.chart['yAxisName'] = 'Count';
	a1ChartOpt.dataSource.chart['exportHandler'] = '${contextPath}/servlet/FCExporter/export.do';

	$.post("${contextPath}/statistics/conect/allTabChartData.do", $('#formArea').serializeArray(),null,'json').done(function(data){

		$('#all_tab_chart_container').off().on('fusionchartsrendercomplete',function (eventObj, dataObj){
			renderDataTable(getChartFromId('a1Chart'), 'a1_data_tbl', 'a1');
		});

		a1ChartOpt.dataSource['data'] = data.chartdata;

		$('#all_tab_chart_container').insertFusionCharts(a1ChartOpt);

	});
}

// Render Data Table from Chart CSV Data
var renderDataTable = function(chart, tblId, tabId){
	$('#' + tblId).empty();
	var data = chart.getDataAsCSV(),
	    rows,
	    row,
	    i,
	    length,
	    colgroup = $('<colgroup></colgroup>'),
	    thead = $('<thead></thead>'),
	    tbody = $('<tbody></tbody>');

	// Get all the rows by splitting data with '\n' seperator
	rows = data.replace(/"/g, '').split('\n');

    // Retrieve the data from the rows and compute body string from the data rows
    for (i = 1, length = rows.length; i < length; i++) {
        row = rows[i].split(',');
        var $tbodyTr = $('<tr></tr>');
        for(var j = 0; j < row.length; j++)$tbodyTr.append($('<td>'+row[j]+'</td>'));
        tbody.append($tbodyTr);
    }

    // Compute header string from first row
    row = rows[0].split(',');
    var $theadTr = $('<tr></tr>');
    for(var k = 0; k < row.length; k++){
    	colgroup.append($('<col style="width: '+(100/row.length)+'%;"/>'));
    	$theadTr.append($('<th>'+row[k]+'</th>'));
    }
	thead.append($theadTr);

    // Create the table string and append it to the table container
    $('#' + tblId).append(colgroup).append(thead).append(tbody);
    doOnTabLoaded(tabId);
}

function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){
		setMainLayoutHeight($('#mainLayout'), -40);
		setObjectHeight($('#allTabCnts'));
		setObjectHeight($('#authorTabCnts'));
		setObjectHeight($('#sclpstTabCnts'));
		setObjectHeight($('#rsltTabCnts'));
		//fundingGrid.setSizes();
		dhxLayout.setSizes(false);
	},10);
}

function setObjectHeight(obj){
	var layoutHeight = $('#mainLayout').height();
	layoutHeight -= 16;
	if($('.title_box') != undefined )
		layoutHeight -= $('.dhxtabbar_tab').height();
	if($('.list_bt_area') != undefined )
		layoutHeight -= $('.list_bt_area').height();
	$(obj).css('height',layoutHeight+"px");
}

function changeDateFormat(rdo){
	var nowDate = new Date();
	$('#endDate').val(getDateStr(nowDate));
	var value = rdo.val();
	if(value == "y")
	{
		//alert(nowDate.getYear -5);
		nowDate.setMonth(nowDate.getMonth() - (12*5));
	}
	else if(value == 'ym')
	{
		nowDate.setMonth(nowDate.getMonth() - 12 );
	}
	else if(value == 'ymd')
	{
		nowDate.setMonth(nowDate.getMonth() - 1 );
	}
	$('#sttDate').val(getDateStr(nowDate));
	myTabbar_load();
}
var doOnTabLoaded = function(tabId){setTimeout(function() { myTabbar.tabs(tabId).progressOff();}, 100);}
var doBeforeTabLoad = function(tabId){ myTabbar.tabs(tabId).progressOn(); }
function doOnGridLoaded(){setTimeout(function() {dhxLayout.cells("a").progressOff();}, 100);}
function doBeforeGridLoad(){dhxLayout.cells("a").progressOn();}
function getDateStr(myDate){  return (myDate.getFullYear() + '-' +  fn_lpad(String((myDate.getMonth() + 1)),"0",2) + '-' + fn_lpad(String(myDate.getDate()),"0",2)) }
function changeConectTrget(radio){
	if(radio.val() == 'login')
	{
		myTabbar.tabs('a4').hide();
		myTabbar.tabs('a5').hide();
		$('.rsltSelect').css('display','none');
		$('.emptyTd').css('display','');
	}
	else if(radio.val() == 'rslt')
	{
		myTabbar.tabs('a4').show();
		myTabbar.tabs('a5').show();
		$('#rsltMenuNm').val('');
		$('.rsltSelect').css('display','');
		$('.emptyTd').css('display','none');
	}
	myTabbar_load();
}
function changeClg(clgObj){
	$('.dept_select').val('');
	if(clgObj.val() != '')
	{
		$('.dept_select option').css('display','none');
		$('.optTrack').css('display','none');
		$('.dept_select option[clgCd='+clgObj.val()+']').css('display','')
	}
	else
	{
		$('.dept_select option').css('display','');
		$('.optTrack').css('display','');
	}
	myTabbar_load();
}
</script>
</head>
<body>
	<div class="title_box">
		<h3>접속로그분석</h3>
	</div>
	<div class="contents_box">
		<!-- START 테이블 1 -->
		<form id="formArea" >
			<c:if test="${not sessMode and sessionScope.auth.adminDvsCd ne 'R' and  sessionScope.auth.adminDvsCd ne 'S' }">
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
					<th>접속구분</th>
					<td>
						<input type="radio" id="conectTrgetLogin" name="conectTrget"  value="login"  checked="checked" onchange="javascript: changeConectTrget($(this));" class="radio"/>
							<label for="conectTrgetLogin" class="radio_label">접속</label>
						<input type="radio" id="conectTrgetOutput" name="conectTrget"  value="rslt" onchange="javascript: changeConectTrget($(this));" class="radio"/>
							<label for="conectTrgetOutput" class="radio_label">성과</label>
					</td>
					<th class="rsltSelect" style="display: none;">성과구분</th>
					<td class="rsltSelect" style="display: none;">
						<select id="rsltMenuNm" name="rsltMenuNm" class="select_type" style="width: 50%;" onchange="javascript:myTabbar_load();" >
							<option value="" selected="selected">전체</option>
							<option value="article">논문게재(저널)</option>
							<option value="conference">학술활동(학술대회)</option>
							<option value="book">저역서</option>
							<option value="funding">연구비(연구과제)</option>
							<option value="patent">지식재산(특허)</option>
							<option value="techtrans">기술이전</option>
							<option value="exhibition">전시작품</option>
							<option value="report">연구보고서</option>
							<option value="career">경력사항</option>
							<option value="degree">취득학위</option>
							<option value="award">수상사항</option>
							<option value="license">자격사항</option>
							<option value="lecture">강의실적</option>
							<option value="student">학생배출실적</option>
							<option value="etc">기타연구실적</option>
							<option value="activity">기타활동실적</option>
						</select>
					</td>
					<th class="emptyTd"></th>
					<td class="emptyTd"></td>
					<td rowspan="5" class="option_search_td" onclick="javascript:myTabbar_load();"><em>search</em></td>
				</tr>
				<tr>
					<th>접속자권한</th>
					<td colspan="3">
						<input type="radio" id="conectrAuthorCd_A" name="conectrAuthorCd" class="radio" value=""  checked="checked" onclick="javascript:myTabbar_load();" />
							<label for="conectrAuthorCd_A" class="radio_label">전체</label>
						<input type="radio" id="conectrAuthorCd_R" name="conectrAuthorCd" class="radio" value="R" onclick="javascript:myTabbar_load();" />
							<label for="conectrAuthorCd_R" class="radio_label">연구자</label>
						<input type="radio" id="conectrAuthorCd_M" name="conectrAuthorCd" class="radio" value="M" onclick="javascript:myTabbar_load();" />
							<label for="conectrAuthorCd_M" class="radio_label">관리자</label>
						<input type="radio" id="conectrAuthorCd_P" name="conectrAuthorCd" class="radio" value="P" onclick="javascript:myTabbar_load();" />
							<label for="conectrAuthorCd_P" class="radio_label">성과관리자</label>
						<input type="radio" id="conectrAuthorCd_C" name="conectrAuthorCd" class="radio" value="C" onclick="javascript:myTabbar_load();" />
							<label for="conectrAuthorCd_C" class="radio_label">단과대학관리자</label>
						<input type="radio" id="conectrAuthorCd_D" name="conectrAuthorCd" class="radio" value="D" onclick="javascript:myTabbar_load();" />
							<label for="conectrAuthorCd_D" class="radio_label">학(부)과관리자</label>
						<input type="radio" id="conectrAuthorCd_T" name="conectrAuthorCd" class="radio" value="T" onclick="javascript:myTabbar_load();" />
							<label for="conectrAuthorCd_T" class="radio_label">트랙관리자</label>
						<input type="radio" id="conectrAuthorCd_S" name="conectrAuthorCd" class="radio" value="S" onclick="javascript:myTabbar_load();" />
							<label for="conectrAuthorCd_S" class="radio_label">대리입력자</label>
						<input type="radio" id="conectrAuthorCd_V" name="conectrAuthorCd" class="radio" value="V" onclick="javascript:myTabbar_load();" />
							<label for="conectrAuthorCd_V" class="radio_label">열람자</label>
					</td>
				</tr>
				<%--
				<tr>
					<th>접속자사번</th>
					<td><input type="text" id="srchUserId" name="srchUserId" class="input2" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/></td>
					<th>접속자성명</th>
					<td><input type="text" name="srchUserNm" id="srchUserNm" class="input2" maxlength="10" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/></td>
				</tr>
				 --%>
				<tr>
					<th>접속자신분</th>
					<td colspan="3">
						<input type="radio" id="gubun_A" name="gubun"  value=""  checked="checked" onchange="javascript:myTabbar_load();" class="radio"/>
							<label for="전체" class="radio_label">전체</label>
						<input type="radio" id="gubun_M" name="gubun"  value="M" onchange="javascript:myTabbar_load();" class="radio"/>
							<label for="전임" class="radio_label">전임</label>
						<input type="radio" id="gubun_U" name="gubun"  value="U" onchange="javascript:myTabbar_load();" class="radio"/>
							<label for="비전임" class="radio_label">비전임</label>
						<input type="radio" id="gubun_S" name="gubun"  value="S" onchange="javascript:myTabbar_load();" class="radio"/>
							<label for="학생" class="radio_label">학생</label>
					</td>
				</tr>
				<tr>
					<th>단과대학</th>
					<td>
						<select name="srchClg" onchange="javascript:changeClg($(this));" class="select_type" style="width: 50%;" >
							<option value="">전체</option>
							<c:forEach items="${clgList}" var="cl" varStatus="idx">
								<c:if test="${not empty cl.codeValue }">
									<option value="${fn:escapeXml(cl.codeValue)}">${fn:escapeXml(cl.codeDisp)}</option>
								</c:if>
							</c:forEach>
						</select>
					</td>
					<th>
						<c:if test="${sessionScope.auth.adminDvsCd eq 'M'}">학과 및 트랙</c:if>
						<c:if test="${sessionScope.auth.adminDvsCd eq 'D' or sessionScope.login_user.adminDvsCd eq 'C'}">학과</c:if>
						<c:if test="${sessionScope.login_user.adminDvsCd eq 'T'}">트랙</c:if>
					</th>
					<td>
						<c:if test="${sessionScope.login_user.adminDvsCd ne 'M'}">
							<c:if test="${sessionScope.auth.adminDvsCd eq 'D'}">
								<input type="hidden" name="srchDeptKor" value="${sessionScope.auth.workTrgetNm}" />
								<input type="hidden" name="srchDept" value="${sessionScope.auth.workTrget}" />
								${sessionScope.auth.workTrgetNm}
							</c:if>
							<c:if test="${sessionScope.auth.adminDvsCd eq 'T'}">
								<input type="hidden" name="srchTrack" value="${sessionScope.auth.workTrget}" />
								${sessionScope.auth.workTrgetNm}
							</c:if>
							<c:if test="${sessionScope.auth.adminDvsCd eq 'C'}">
								<select name="srchDeptKor" onchange="javascript:myTabbar_load();" class="dept_select select_type" style="width: 50%;" >
									<option value="">전체</option>
									<c:forEach items="${deptList}" var="dl" varStatus="idx">
										<c:if test="${not empty dl.deptKor }">
											<option value="${fn:escapeXml(dl.deptKor)}" clgCd="${dl.clgCd}">${fn:escapeXml(dl.deptKor)}</option>
										</c:if>
									</c:forEach>
								</select>
							</c:if>
						</c:if>
						<c:if test="${sessionScope.auth.adminDvsCd eq 'M'}">
							<select  name="adminSrchDeptTrack" id="adminSrchDeptTrack"  onchange="javascript:myTabbar_load();" class="dept_select select_type" style="width: 50%;" >
								<option value="">전체</option>
								<optgroup label="학과(부)" class="optDept">
									<c:forEach var="item" items="${deptList}">
									<option value="DEPT_${item.deptKor}" clgCd="${item.clgCd}">${item.deptKor}</option>
									</c:forEach>
								</optgroup>
								<optgroup label="트랙" class="optTrack">
									<c:forEach var="item" items="${trackList}">
									<option value="TRACK_${item.trackId}" clgCd="">${item.trackName}</option>
									</c:forEach>
								</optgroup>
							</select>
							<input type="hidden" name="srchDeptKor"  id="adminSrchDeptKor"/>
							<input type="hidden" name="srchTrack"  id="adminSrchTrack"/>
						</c:if>
					</td>
				</tr>
				<tr>
					<th>기간구분</th>
					<td>
						<input type="radio" id="dateFormat_ymd" name="dateFormat"  value="ymd" checked="checked" onclick="javascript:changeDateFormat($(this));" class="radio"/>
							<label for="dateFormat_ymd" class="radio_label">일자별</label>
						<input type="radio" id="dateFormat_ym" name="dateFormat"  value="ym"  onclick="javascript:changeDateFormat($(this));" class="radio"/>
							<label for="dateFormat_ym" class="radio_label">월별</label>
						<input type="radio" id="dateFormat_y" name="dateFormat"  value="y"  onclick="javascript:changeDateFormat($(this));" class="radio"/>
							<label for="dateFormat_y" class="radio_label">년도별</label>
					</td>
					<th>기간</th>
					<td>
						<input type="text" id="sttDate" name="sttDate" class="input2"  maxlength="8" style="width: 80px;"  onKeyup="javascript:if(event.keyCode=='13')myTabbar_load();" value=""/>
						~ <input type="text" id="endDate" name="endDate" class="input2" maxlength="8" style="width: 80px;" onKeyup="javascript:if(event.keyCode=='13')myTabbar_load();" value=""/>
						(예:2016-11-22)
					</td>
				</tr>
				</tbody>
			</table>
			</c:if>
		</form>

		<!-- layout (grid,paging)  -->
		<div id="mainLayout" style="position: relative; width: 100%;height: 100%;"></div>
		<div id="allTab" style="display: none;">
			<div class="list_bt_area">
				<div class="list_set">
					<ul>
						<li><a href="#" onclick="javascript:exportExcel('a1');" class="list_icon20">엑셀</a></li>
					</ul>
				</div>
			</div>
			<div id="allTabCnts">
				<h3 class="circle_h3">Chart</h3>
				<div id="all_tab_chart_container" class="chart_box mgb_10"></div>
				<h3 class="circle_h3" id="list_title">Data</h3>
				<table id="a1_data_tbl" width="100%" class="list_tbl mgb_20"></table>
			</div>
		</div>
		<div id="authorTab" style="display: none;">
			<div class="list_bt_area">
				<div class="list_set">
					<ul>
						<li><a href="#" onclick="javascript:exportExcel('a2');" class="list_icon20">엑셀</a></li>
					</ul>
				</div>
			</div>
			<div id="authorTabCnts">
				<h3 class="circle_h3">Chart</h3>
				<div id="author_tab_chart_container" class="chart_box mgb_10"></div>
				<h3 class="circle_h3" id="list_title">Data</h3>
				<table id="a2_data_tbl" width="100%" class="list_tbl mgb_20"></table>
			</div>
		</div>
		<div id="sclpstTab" style="display: none;">
			<div class="list_bt_area">
				<div class="list_set">
					<ul>
						<li><a href="#" onclick="javascript:exportExcel('a3');" class="list_icon20">엑셀</a></li>
					</ul>
				</div>
			</div>
			<div id="sclpstTabCnts">
				<h3 class="circle_h3">Chart</h3>
				<div id="sclpst_tab_chart_container" class="chart_box mgb_10"></div>
				<h3 class="circle_h3" id="list_title">Data</h3>
				<table id="a3_data_tbl" width="100%" class="list_tbl mgb_20"></table>
			</div>
		</div>
		<div id="deptTab" style="display: none;">
			<div class="list_bt_area">
				<div class="list_set">
					<ul>
						<li><a href="#" onclick="javascript:exportExcel('a6');" class="list_icon20">엑셀</a></li>
					</ul>
				</div>
			</div>
			<div id="deptTabCnts">
				<h3 class="circle_h3">Chart</h3>
				<div id="dept_tab_chart_container" class="chart_box mgb_10"></div>
				<h3 class="circle_h3" id="list_title">Data</h3>
				<table id="a6_data_tbl" width="100%" class="list_tbl mgb_20"></table>
			</div>
		</div>
		<div id="mainRsltTab" style="display: none;">
			<div class="list_bt_area">
				<div class="list_set">
					<ul>
						<li><a href="#" onclick="javascript:exportExcel('a4');" class="list_icon20">엑셀</a></li>
					</ul>
				</div>
			</div>
			<div id="mainRsltTabCnts">
				<h3 class="circle_h3">Chart</h3>
				<div id="mainRslt_tab_chart_container" class="chart_box mgb_10"></div>
				<h3 class="circle_h3" id="list_title">Data</h3>
				<table id="a4_data_tbl" width="100%" class="list_tbl mgb_20"></table>
			</div>
		</div>
		<div id="etcRsltTab" style="display: none;">
			<div class="list_bt_area">
				<div class="list_set">
					<ul>
						<li><a href="#" onclick="javascript:exportExcel('a5');" class="list_icon20">엑셀</a></li>
					</ul>
				</div>
			</div>
			<div id="etcRsltTabCnts">
				<h3 class="circle_h3">Chart</h3>
				<div id="etcRslt_tab_chart_container" class="chart_box mgb_10"></div>
				<h3 class="circle_h3" id="list_title">Data</h3>
				<table id="a5_data_tbl" width="100%" class="list_tbl mgb_20"></table>
			</div>
		</div>
 	</div>
</body>
</html>
