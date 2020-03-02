<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><spring:message code="menu.asrms.dept.patentByNation"/></title>
<style type="text/css" rel="stylesheet">
	th.header {
		cursor: pointer;
		background-repeat: no-repeat;
		background-position: center right;
		padding-right: 15px;
		margin-right: -1px;
	}
</style>
<script type="text/javascript" src="${contextPath}/js/jquery/jquery.tablesorter.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/chart/opts/fusioncharts.opts.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/chart/fusioncharts.js"></script>
<script type="text/javascript">
var chart_ChartId1;
var djArr;
var fc = 0;

$(function() {
    $("#acqsDvsCd option").eq(0).remove();
    patentByNationAjax();
});

function patentByNationAjax(){
    if(!validateRange()){errorMsg(this); return false;}

    $.ajax({
        url:"<c:url value="/analysis/department/patentByNationAjax.do"/>",
        dataType: "json",
        data: $('#frm').serialize(),
        method: "POST",
        beforeLoad: $('.wrap-loading').css('display', '')

    }).done(function(data){
        djArr = eval('('+ data.dataJson+')');

        $('#fromYear').data('prev', $('#fromYear').val());
        $('#toYear').data('prev', $('#toYear').val());

        if(FusionCharts('ChartId1')) {
            FusionCharts('ChartId1').dispose();
            $('#chartdiv1').disposeFusionCharts().empty();
        }
        var patentChartOpt = $.extend(true, {}, chartOpt);
        patentChartOpt['id'] = 'ChartId1';
        patentChartOpt['type'] = 'MSLine';
        patentChartOpt['renderAt'] = 'chartdiv1';
        patentChartOpt['width'] = '100%';
        patentChartOpt['height'] = '350';

        patentChartOpt.dataSource.chart['interactiveLegend'] ='0';
        patentChartOpt.dataSource.chart['exportCallBack'] ='myFN';
        patentChartOpt.dataSource.chart['exportHandler'] = '${contextPath}/servlet/FCExporter/export.do';
        patentChartOpt.dataSource['categories'] = data.categories;
        patentChartOpt.dataSource['dataset'] = data.dataset;
        patentChartOpt.dataSource['styles'] = data.styles;

        chart_ChartId1 = new FusionCharts(patentChartOpt).render();

        printDataTable();
        $('input:checkbox').bind('click', function(){ clickCheckbox($(this));});

        $('.wrap-loading').css('display', 'none');
    });
}

function printDataTable(){
    $('#patentTbl').html("");
	var fy = parseInt($('#fromYear').val(),10);
	var ty = parseInt($('#toYear').val(),10);
	var thead = $('<thead></thead>');
	var trTh = $('<tr style="height:20px;"><th style="padding-left: 12px;"><span><input type="checkbox" name="toggleChkbox" id="toggleChkbox" value="0"/></span></th><th><span>국가</span></th></tr>');
	var countCol = 0;
	for(var i=fy; i <= ty; i++){
		trTh.append($('<th class="center">'+i+'</th>'));
		countCol++;
	}
	trTh.append($('<th><span>합계</span></th>'));
	countCol++;

	$('#patentTbl').css('width',"100%");
	thead.append(trTh);
	$('#patentTbl').append(thead);

    fc = 0;
	var tbody  = $('<tbody></tbody>');
	for(var j=0; j < djArr.length; j++){
		var name = djArr[j].applRegNtnNm;
		var code = djArr[j].applRegNtnCd;
		var trTd = $('<tr style="height:17px;" id="data_'+code+'"></tr>');
		if(j < 5){
			trTd.append('<td style="text-align: center;">' +
				'<input type="checkbox"  id="no_chkbox_'+code+'" value="'+code+'" checked="checked"/>' +
				'<input type="hidden" name="no_fillColorIndex_'+code+'" id="no_fillColorIndex_'+code+'" value="'+fc+'"/>' +
				'</td>');
		}else{
			trTd.append('<td style="text-align: center;">' +
				'<input type="checkbox"  id="no_chkbox_'+code+'" value="'+code+'"/>' +
				'<input type="hidden" name="no_fillColorIndex_'+code+'" id="no_fillColorIndex_'+code+'" value="'+fc+'"/>' +
				'</td>');
		}

		trTd.append($('<td style="text-align:center;">'+name+'</td>'));
		var sum = 0;
		for(var i=fy; i <= ty; i++){
			var val = djArr[j][i] == undefined ? 0 : djArr[j][i];
			trTd.append($('<td style="text-align:center;padding-right:5px;">'+commaNum(val)+'</td>'));
			sum += Number(val);
		}
		trTd.append($('<td style="text-align:center;">'+commaNum(sum)+'</td>'));
		if(fc++ > fillColors.length-1) fc = 0;
		tbody.append(trTd);
	}
	$('#patentTbl').append(tbody);
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
	for(var i=0; i < djArr.length; i++){
		if($('#no_chkbox_'+djArr[i].applRegNtnCd).is(':checked')){
			var color = fillColors[$('#no_fillColorIndex_'+djArr[i].applRegNtnCd).val()];
			dataset += "<dataset seriesName='"+djArr[i].applRegNtnNm+"' color='"+color+"' id='"+djArr[i].applRegNtnCd+"' >";
			for(var j=fy; j <= ty; j++){
				var val = djArr[i][j] == undefined ? 0 : djArr[i][j];
				var toolText = djArr[i].applRegNtnNm+" "+j+" :" + val;
				dataset += "<set value='"+val+"' toolText='"+toolText+"' />";
			}
			dataset += "</dataset>";
		}
	}
	var chartData = chart_ChartId1.getChartData('xml');
	chartData = chartData.replace(/(<chart .*>)(<categories.*)(<styles.*)/, '$1'+category+dataset+'<styles>$3');
	chart_ChartId1.setDataXML(chartData);
}


//Callback handler method which is invoked after the chart has saved image on server.
function myFN(objRtn){
	if (objRtn.statusCode=="1"){
		saveExcel(objRtn.fileName);
		//alert("The chart was successfully saved on server. The file can be accessed from " + objRtn.fileName);
	}else{
		alert("The chart could not be saved on server. There was an error. Description : " + objRtn.statusMessage);
	}
}
function exportExcel(){

	var chartObject = getChartFromId('ChartId1');

	if( chartObject.hasRendered() ) chartObject.exportChart( { exportFormat : 'png'} );
}

function saveExcel(fileName){

	var div = $('<div></div>');
	var table = $('<table></table>');
	//append document title
	var chartTitle = $('<tr><td style="text-align:center;"><h1><p>Department - '+$('.page_title').html()+'</p></h1></td></tr>');
	//append chart image
	var chartTr = $('<tr><td><img src="'+fileName+'" height="350" /></td></tr>');
	var dataTitle = $('<tr><td><h1>Chart Data</h1></td></tr>');
	table.append(chartTitle)
		.append(chartTr)
		.append(dataTitle);
	//make table with data of checked researcher
	var dTbl = $('<table class="list_tbl mgb_20"></table>');
	var tThead = $('#patentTbl > thead').clone();
	tThead.find("th")[0].remove();
	dTbl.append(tThead.wrapAll('<div/>').parent().html());
	var dataTbody = $('<tbody></tbody>');
	var chb = $('input[id^="no_chkbox_"]:checked');
	for(var i=0; i < chb.length ; i++){
		var id = chb.eq(i).val();
		var data = $('#data_'+id).clone();
		data.find("td")[0].remove();
		dataTbody.append(data.wrapAll('<div/>').parent().html());
	}
	dTbl.append(dataTbody);
	table.append($('<tr><td>'+dTbl.clone().wrapAll('<div/>').parent().html()+'</td></tr>'));

	//make table with data of checked researcher
	div.append(table);
	$('#tableHTML').val(div.html());
	var excelFileName = "patentByNation_from_" + $('#fromYear').val() +"_to_" + $('#toYear').val() + ".xls";
	$('#fileName').val(excelFileName);
	exportLog($('#frm'), excelFileName + "|" +  fileName);
	$('#excelFrm').submit();
}

function acqsChange(){
    if($("#acqsDvsCd").val() == "1"){
        $("#status").parent().css("display","none");
    }else{
        $("#status").parent().css("display","");
    }
}
</script>
</head>
<body>
<h3 class="page_title"><spring:message code="menu.asrms.dept.patentByNation"/></h3>
<div class="help_text mgb_30"><spring:message code="asrms.department.patentByNation.desc"/></div>

<form id="frm" name="frm">
	<input type="hidden" id="topNm" name="topNm" value="${topNm}"/>
	<input type="hidden" name="trackId" id="trackId" value="${parameter.trackId}"/>
	<input type="hidden" name="deptKor" id="deptKor" value="${parameter.deptKor}"/>
	<div class="top_option_box">
		<div class="to_inner">
			<span>취득구분</span>
			<em>
				<select name="acqsDvsCd" id="acqsDvsCd" onchange="javascript:acqsChange();">${rims:makeCodeList('1090',true,parameter.acqsDvsCd)}</select>
			</em>
			<em style="display:none;">
				<select name="status" id="status" mode="checkbox" >${rims:makeCodeList('patent.status',true,parameter.status)}</select>
			</em>
			<span>신분구분</span>
			<em>
				<select name="isFulltime" id="isFulltime">
					<option value="ALL">전체</option>
					<option value="M" selected="selected">전임</option>
					<option value="U">비전임</option>
				</select>
			</em>
			<span>실적구분</span>
			<em>
				<select name="insttRsltAt" id="insttRsltAt">
					<option value="ALL">전체</option>
					<option value="Y">${sysConf['inst.abrv']}</option>
					<option value="N">타기관</option>
				</select>
			</em>
			<p style="margin-top: 5px;">
				<span>실적기간</span>
				<em>
					<select name="fromYear" id="fromYear">
						<c:forEach var="yl" items="${patentYearList}" varStatus="idx" end="50">
							<option value="${yl.patYear }" ${idx.index == 5 ? 'selected="selected"' : '' }>${yl.patYear }</option>
						</c:forEach>
					</select>
				</em>
				~
				<em>
					<select name="toYear" id="toYear">
						<c:forEach var="yl" items="${patentYearList}" varStatus="idx" end="50">
							<option value="${yl.patYear }">${yl.patYear }</option>
						</c:forEach>
					</select>
				</em>
			</p>
		</div>

		<p class="ts_bt_box">
			<a href="javascript:patentByNationAjax();" class="to_search_bt"><span>Search</span></a>
		</p>
	</div>

	<h3 class="circle_h3">Chart</h3>

	<div class="chart_box mgb_20">
		<div id="chartdiv1" align="left"></div>
	</div>

	<h3 class="circle_h3">Data</h3>
	<p class="bt_box mgb_10"><a href="#" onclick="exportExcel();" class="black_bt"><em class="export_icon">Export</em></a></p>
	<div style="width: 100%;overflow: auto;">
		<table width="100%" id="patentTbl" class="list_tbl mgb_20"></table>
	</div>
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
