<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><spring:message code="menu.asrms.inst.fundingByDepart"/></title>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/chart/opts/fusioncharts.opts.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/chart/fusioncharts.js"></script>
 <script type="text/javascript" src="${contextPath}/js/jquery/jquery.tablesorter.min.js"></script>
<style type="text/css" rel="stylesheet">
th.header {
    cursor: pointer;
    background-repeat: no-repeat;
    background-position: center right;
    padding-right: 15px;
    margin-right: -1px;
}
</style>
<script type="text/javascript">
var fc = 0;
var chart_ChartId1;
var chart_ChartId2;
var djArr;
var djArrWithY;

$(document).ready(function(){
	$( "#tabs" ).tabs({});
	$("#tabs").css("display", "block");

	 $.tablesorter.addParser({
		 // set a unique id
		 id: 'numFmt',
		 is: function(s) {
			 // return false so this parser is not auto detected
			 return false;
		 },
		 format: function(s) {
			 return NumberWithoutComma(s);
		 },
		 // set type, either numeric or text
		 type: 'numeric'
	 });

	fundingByDepartAjax('0');
});

function fundingByDepartAjax(idx){
    if(!validateRange()){errorMsg(this); return false;}

	$.ajax({
		url:"<c:url value="/analysis/institution/fundingByDepartAjax.do"/>",
		dataType: "json",
		data: $('#frm').serialize(),
		method: "POST",
		beforeLoad: $('.wrap-loading').css('display', '')

	}).done(function(data){

		djArr = eval('('+ data.dataJson+')');
		djArrWithY = eval('('+ data.dataJsonWithY+')');

		if(FusionCharts('fundingChart1')) {
			FusionCharts('fundingChart1').dispose();
			$('#chartdiv1').disposeFusionCharts().empty();
		}
		if(FusionCharts('fundingChart2')) {
			FusionCharts('fundingChart2').dispose();
			$('#chartdiv2').disposeFusionCharts().empty();
		}

		// Chart(건수)
		var chartWidth = "100%";
		if(browserType() == "I"){
			chartWidth = "748";
		}

		var fundingChartOpt = $.extend(true, {}, chartOpt);
		fundingChartOpt['id'] = 'fundingChart1';
		fundingChartOpt['type'] = 'MSLine';
		fundingChartOpt['renderAt'] = 'chartdiv1';
		fundingChartOpt['width'] = chartWidth;
		fundingChartOpt['height'] = '350';
		fundingChartOpt.dataSource.chart['exportHandler'] = '${contextPath}/servlet/FCExporter/export.do';
		fundingChartOpt.dataSource.chart['exportCallBack'] = 'myFN_Co';
		fundingChartOpt.dataSource.chart['interactiveLegend'] ='0';

		fundingChartOpt.dataSource['categories'] = data.categories1;
		fundingChartOpt.dataSource['dataset'] = data.dataset1;
		fundingChartOpt.dataSource['styles'] = data.styles1;

		chart_ChartId1 = new FusionCharts(fundingChartOpt).render();

		// Chart(금액)
		fundingChartOpt['id'] = 'fundingChart2';
		fundingChartOpt['renderAt'] = 'chartdiv2';
		fundingChartOpt.dataSource.chart['exportCallBack'] = 'myFN_Fund';
		fundingChartOpt.dataSource['categories'] = data.categories2;
		fundingChartOpt.dataSource['dataset'] = data.dataset2;
		fundingChartOpt.dataSource['styles'] = data.styles2;

		chart_ChartId2 = new FusionCharts(fundingChartOpt).render();

		printDataTable();

		var $tbody = "";
        fc = 0;
		if(data.fundingDetailList.length > 0){

			for(var i=0; i<data.fundingDetailList.length; i++){
				var fd = data.fundingDetailList[i];

				var $tr = '<tr>';
				$tr += '<td style="text-align: center;">';
				$tr += '<input type="checkbox"  id="no_chkbox_'+fd.deptCode+'" value="'+fd.deptKorNm+'"';
				if(i < 5) $tr += 'checked="checked"';
				$tr += '/><input type="hidden" name="no_fillColorIndex_'+fd.deptCode+'" id="no_fillColorIndex_'+fd.deptCode+'" value="'+fc+'" /></td>';
				$tr += '<td class="center">'+fd.deptKorNm+'</td>';
				$tr += '<td class="center">'+fd.rsrcctSum.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+'</td>';
				$tr += '<td class="center">'+fd.totRsrcct.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+'</td>';
				if(fc++ > fillColors.length-1) fc = 0;
				$tr += "</tr>";
				$tbody += $tr;
			}
		}else{
			var $tr = '<tr><td colspan="99" style="padding-left:5px;"><img src="${contextPath}/images/layout/ico_info.png" /> 검색된 Data가 없습니다.</td></tr>';
			$tbody += $tr;
		}

		$("#publicationsTbl tbody").html($tbody);

		if(data.fundingDetailList.length > 0){
			if(idx == '0'){
				$("#publicationsTbl").tablesorter({
					sortList:[[2,1]],
					headers: {
						0: { sorter: false },
						2: { sorter:'numFmt'},
						3: { sorter:'numFmt'}
					}
				});

				$("#dataTbl").tablesorter();
				$("#dataTbl2").tablesorter();
			}else{
				$("#publicationsTbl th").removeClass('headerSortUp');
				$("#publicationsTbl th").removeClass('headerSortDown');
				$("#publicationsTbl th").eq(2).addClass('headerSortUp');
			}

			$("#publicationsTbl").trigger("update");
			$("#dataTbl").trigger("update");
			$("#dataTbl2").trigger("update");

			$('input:checkbox').bind('click', function(){ clickCheckbox($(this));});
		}

		$('#fromYear').data('prev', $('#fromYear').val());
		$('#toYear').data('prev', $('#toYear').val());

		$('.wrap-loading').css('display', 'none');
	});
}

function printDataTable(){
    $('#dataTbl').html("");
    $('#dataTbl2').html("");
	var fy = parseInt($('#fromYear').val(),10);
	var ty = parseInt($('#toYear').val(),10);
	var thead = $('<thead></thead>');
	var trTh = $('<tr style="height:20px;"><th><span>학과</span></th>');
	var countCol = 0;
	for(var i=fy; i <= ty; i++){
		trTh.append($('<th><span>'+i+'</span></th>'));
		countCol++;
	}
	var width = 500 + countCol*50;
	var width2 = 500 + countCol*100;
	$('#dataTbl').css('width',width+"px");
	$('#dataTbl2').css('width',width2+"px");

	thead.append(trTh)
	var thead2 = thead.clone();
	$('#dataTbl').append(thead);
	$('#dataTbl2').append(thead2);

	var tbody  = $('<tbody></tbody>');
	var tbody2  = tbody.clone();
	for(var j=0; j < djArr.length; j++){
	 var name = djArr[j].deptKorNm ;
	 var trTd = $('<tr style="height:17px;" id="data1_'+name+'"><td>'+name+'</td></tr>');
	 var trTd2 = $('<tr style="height:17px;" id="data2_'+name+'"><td>'+name+'</td></tr>');
	 var standardY = "";
	 var count = 0;

	 for(var t=0; t < djArrWithY.length; t++){
		 if(t < djArrWithY.length-1){
			 standardY = djArrWithY[t+1].rsrcctContYr;
		 }else{
			 standardY = String(1 + Number(djArrWithY[t].rsrcctContYr));
		 }

		 if(name == djArrWithY[t].deptKorNm){
			 trTd.append($('<td style="text-align:center;padding-right:5px;">'+djArrWithY[t].rsrcctSum.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")+'</td>'));
			 trTd2.append($('<td style="text-align:center;padding-right:5px;">'+djArrWithY[t].totRsrcct.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")+'</td>'));
			 count++;
		 }

		 //건수가 없을때 건수,금액을 0으로 채우기
		 if(djArrWithY[t].rsrcctContYr != standardY && count != (Number(standardY)-Number(djArrWithY[0].rsrcctContYr))){
			 trTd.append($('<td style="text-align:center;padding-right:5px;">0</td>'));
			 trTd2.append($('<td style="text-align:center;padding-right:5px;">0</td>'));
			 count++;
		 }

	 }
	 tbody.append(trTd);
	 tbody2.append(trTd2);
	}
	$('#dataTbl').append(tbody);
	$('#dataTbl2').append(tbody2);
}

function clickCheckbox(obj){

	if($(obj).prop('id') == "toggleChkbox")
	{
		if($(obj).prop("checked") == true)
		{
			$('input[id^="no_chkbox_"]').prop('checked', true);
		}
		else
		{
			$('input[id^="no_chkbox_"]').prop('checked', false);
		}
	}

	//(.*dataXML=)(<chart .*>)(<categories.*)(<styles.*)
	var chartId = "ChartId1";
	var category = "<categories>";
	var fy = parseInt($('#fromYear').val(),10);
	var ty = parseInt($('#toYear').val(),10);

	for(var i=fy; i <= ty; i++){
		category += "<category label='"+i+"' />";
	}
	category += "</categories>";

	var dataset = "";
	var dataset2 = "";

	for(var i=0; i < djArr.length; i++){
		var size = djArr[i].deptKorNm.length;
		var standardY = "";
		var count = 0;
		if($('#no_chkbox_'+djArr[i].deptCode).is(':checked')){
			var color = fillColors[$('#no_fillColorIndex_'+djArr[i].deptCode).val()];
			dataset += "<dataset seriesName='"+djArr[i].deptKorNm+"' color='"+color+"' id='"+djArr[i].deptCode+"' >";
			dataset2 += "<dataset seriesName='"+djArr[i].deptKorNm+"' color='"+color+"' id='"+djArr[i].deptCode+"' >";

			for(var j=0; j < djArrWithY.length; j++){

				if(j < djArrWithY.length-1){
					standardY = djArrWithY[j+1].rsrcctContYr;
				}else{
					standardY = String(1 + Number(djArrWithY[j].rsrcctContYr));
				}

				if(djArr[i].deptKorNm == djArrWithY[j].deptKorNm){
					var val = djArrWithY[j].rsrcctSum == undefined ? 0 : djArrWithY[j].rsrcctSum;
					var toolText = djArrWithY[j].deptKorNm+" ("+djArrWithY[j].rsrcctContYr+") :" + val.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
					var val2 = djArrWithY[j].totRsrcct == undefined ? 0 : parseInt(Number(djArrWithY[j].totRsrcct)/1000000);
					var toolText2 = djArrWithY[j].deptKorNm+" ("+djArrWithY[j].rsrcctContYr+") :" + val2.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")+"(단위:백만원)";

					dataset += "<set value='"+val+"' toolText='"+toolText+"' />";
					dataset2 += "<set value='"+val2+"' toolText='"+toolText2+"' />";
					count++;
				}

				//건수가 없을때 0으로 채우기
				if(djArrWithY[j].rsrcctContYr != standardY && count != (Number(standardY)-Number(djArrWithY[0].rsrcctContYr))){
					toolText = djArr[i].deptKorNm+" ("+djArrWithY[j].rsrcctContYr+") : 0";
					dataset += "<set value='0' toolText='"+toolText+"' />";
					dataset2 += "<set value='0' toolText='"+toolText+"' />";
					count++;
				}

			}
			dataset += "</dataset>";
			dataset2 += "</dataset>";
		}
	}

	var chartData = chart_ChartId1.getChartData('xml');
	var chartData2 = chart_ChartId2.getChartData('xml');

	chartData = chartData.replace(/(<chart .*>)(<categories.*)(<styles.*)/, '$1'+category+dataset+'<styles>$3');
	chartData2 = chartData2.replace(/(<chart .*>)(<categories.*)(<styles.*)/, '$1'+category+dataset2+'<styles>$3');

	chart_ChartId1.setDataXML(chartData);
	chart_ChartId2.setDataXML(chartData2);
}

var chartFileArr = new Array();

function exportExcel(){
	$("#tabs").tabs({active:0});
	setTimeout(function() {
		if( chart_ChartId1.hasRendered() ) chart_ChartId1.exportChart( { exportFormat : 'png'} );
	},1000);
}

//Callback hanfder method which is invoked after the chart has saved image on server.
function myFN_Co(objRtn){
	if (objRtn.statusCode=="1"){
		$("#tabs").tabs({active:2});
		chartFileArr.push(objRtn.fileName);
		setTimeout(function() {
			if (chart_ChartId2.hasRendered()) chart_ChartId2.exportChart({exportFormat: 'png'});
		},1000);
		//alert("The chart was successfully saved on server. The file can be accessed from " + objRtn.fileName);
	}else{
		alert("The chart could not be saved on server. There was an error. Description : " + objRtn.statusMessage);
	}
}

function myFN_Fund(objRtn){
	if (objRtn.statusCode=="1"){
		chartFileArr.push(objRtn.fileName);
		if(chartFileArr.length == 2) saveExcel();
		//alert("The chart was successfully saved on server. The file can be accessed from " + objRtn.fileName);
	}else{
		alert("The chart could not be saved on server. There was an error. Description : " + objRtn.statusMessage);
	}
}

function saveExcel(){

	var div = $('<div></div>');
	var table = $('<table></table>');
	//append document title
	var chartTitle = $('<tr><td style="text-align:center;"><h1><p>Institution - '+$('.page_title').html()+'</p></h1></td></tr>');
	//append chart image
	var chart1Tr = $('<tr><td><img src="'+chartFileArr[0]+'" height="350"/></td></tr>');
	var data1Title = $('<tr><td><h1>Chart Data(건수)</h1></td></tr>');
	table.append(chartTitle)
		.append(chart1Tr)
		.append(data1Title);
	//make table with data of checked researcher
	var dTbl = $('<table class="list_tbl mgb_20"></table>');
	dTbl.append($('#dataTbl > thead').clone().wrapAll('<div/>').parent().html());
	var dataTbody = $('<tbody></tbody>');
	var chb = $('input[id^="no_chkbox_"]:checked');
	for(var i=0; i < chb.length ; i++){
		var id = chb.eq(i).val();
		dataTbody.append($('#data1_'+id).clone().wrapAll('<div/>').parent().html());
	}
	dTbl.append(dataTbody);
	table.append($('<tr><td>'+dTbl.clone().wrapAll('<div/>').parent().html()+'</td></tr>'));

	var chart2Tr = $('<tr><td><img src="'+chartFileArr[1]+'" height="350"/></td></tr>');
	var data2Title = $('<tr><td><h1>Chart Data(금액)</h1></td></tr>');
	table.append(chart2Tr)
		.append(data2Title);
	//make table with data of checked researcher
	var dTbl2 = $('<table class="list_tbl mgb_20"></table>');
	dTbl2.append($('#dataTbl2 > thead').clone().wrapAll('<div/>').parent().html());
	var dataTbody2 = $('<tbody></tbody>');
	for(var i=0; i < chb.length ; i++){
		var id = chb.eq(i).val();
		dataTbody2.append($('#data2_'+id).clone().wrapAll('<div/>').parent().html());
	}
	dTbl2.append(dataTbody2);
	table.append($('<tr><td>'+dTbl2.clone().wrapAll('<div/>').parent().html()+'</td></tr>'));
	div.append(table);

	$('#tableHTML').val(div.html());
	var excelFileName = "fundingByDepart_from_" + $('#fromYear').val() +"_to_" + $('#toYear').val() + ".xls";
	$('#fileName').val(excelFileName);
    exportLog($('#frm'), excelFileName + "|" +  chartFileArr);
    chartFileArr = new Array();
	$('#excelFrm').submit();
}

</script>
</head>
<body>
<h3 class="page_title"><spring:message code="menu.asrms.inst.fundingByDepart"/></h3>
<div class="help_text mgb_30"><spring:message code="asrms.institution.fundingByDepart.desc"/></div>

<form id="frm" name="frm">
	<input type="hidden" id="topNm" name="topNm" value="${topNm}"/>
	<div class="top_option_box">
		<div class="to_inner">
			<span>재직구분</span>
			<em>
				<select name="hldofYn" id="hldofYn">
					<option value="ALL">전체</option>
					<option value="1" selected="selected">재직</option>
					<option value="2">퇴직</option>
				</select>
			</em>
			<span>신분구분</span>
			<em>
				<select name="isFulltime" id="isFulltime">
					<option value="ALL">전체</option>
					<option value="M" selected="selected">전임</option>
					<option value="U">비전임</option>
				</select>
			</em>
			<span>계약기간</span>
			<em>
				<select name="fromYear" id="fromYear">
					<c:forEach var="yl" items="${rsrcctContYrList}" varStatus="idx">
						<option value="${yl.rsrcctContYr }" ${idx.index == 5 ? 'selected="selected"' : '' }>${yl.rsrcctContYr }</option>
					</c:forEach>
				</select>
			</em>
			~
			<em>
				<select name="toYear" id="toYear">
					<c:forEach var="yl" items="${rsrcctContYrList}" varStatus="idx">
						<option value="${yl.rsrcctContYr }">${yl.rsrcctContYr }</option>
					</c:forEach>
				</select>
			</em>
		</div>
		<p class="ts_bt_box">
			<a href="javascript:fundingByDepartAjax();" class="to_search_bt"><span>Search</span></a>
		</p>
	</div>

	<div id="tabs" class="tab_wrap mgb_10" style="display: none;">
	  <ul>
	    <li><a href="#tabs-1">Chart(건수)</a></li>
	    <li><a href="#tabs-2">Data(건수)</a></li>
	    <li><a href="#tabs-3">Chart(금액)</a></li>
	    <li><a href="#tabs-4">Data(금액)</a></li>
	  </ul>
  		<div id="tabs-1">
		   <div id="chartdiv1" class="chart_box" align="left"></div>
		</div>
		<div id="tabs-2">
			<div id="content_wrap" style="width: 100%;overflow: auto;">
				<table height="370px" id="dataTbl" class="tab_tbl mgb_20">
				</table>
			</div>
		</div>
  		<div id="tabs-3">
		   <div id="chartdiv2" class="chart_box" align="left">
		   	</div>
		</div>
		<div id="tabs-4">
			<div id="content_wrap2" style="width: 100%;overflow: auto;">
				<table height="370px" id="dataTbl2" class="tab_tbl mgb_20">
				</table>
			</div>
		</div>
	</div>

	<p class="bt_box mgb_20"><a href="#" onclick="exportExcel();" class="black_bt"><em class="export_icon">Export</em></a></p>

	<table width="100%" id="publicationsTbl" class="list_tbl mgb_20">
		<colgroup>
			<col style="width: 5%"/>
			<col style="width: 15%"/>
			<col style="width: 12%"/>
			<col style="width: 12%"/>
		</colgroup>
		<thead>
			<tr>
				<th style="padding-left: 12px;"><span><input type="checkbox" name="toggleChkbox" id="toggleChkbox" value="0"/></span></th>
				<th><span>학과</span></th>
				<th><span>총 건수</span></th>
				<th><span>총 금액</span></th>
			</tr>
		</thead>
		<tbody></tbody>
	</table>
</form>

<form id="excelFrm" method="post" action="${contextPath}/jsp/excelExport.jsp">
      <input type="hidden" id="tableHTML" name="tableHTML" value="" />
      <input type="hidden" id="fileName" name="fileName" value="test.xls" />
      <!--
      <input type="button" onclick="gotoExcel('tableData', 'tableHTML');" value="Export these results" />
       -->
</form>
</body>
</html>
