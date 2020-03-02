<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><spring:message code="menu.asrms.dept.patentByIPC"/></title>
<style type="text/css" rel="stylesheet">
	th.header {
		cursor: pointer;
		background-repeat: no-repeat;
		background-position: center right;
		padding-right: 15px;
		margin-right: -1px;
	}
</style>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/chart/opts/fusioncharts.opts.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/chart/fusioncharts.js"></script>
<script type="text/javascript">
var chart_ChartId1;
var djArr;
var fc = 0;

$(function() {
    $("#acqsDvsCd option").eq(0).remove();
    patentByIPCAjax();
});

function patentByIPCAjax(){

    $.ajax({
        url:"<c:url value="/analysis/department/patentByIPCAjax.do"/>",
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
        patentChartOpt.dataSource.chart['exportHandler'] = '${contextPath}/servlet/FCExporter/export.do';
        patentChartOpt.dataSource.chart['exportCallBack'] ='myFN';
        patentChartOpt.dataSource['categories'] = data.chartMap.categories;
        patentChartOpt.dataSource['dataset'] = data.chartMap.dataset;
        patentChartOpt.dataSource['styles'] = data.chartMap.styles;

        chart_ChartId1 = new FusionCharts(patentChartOpt).render();

        printDataTable();
        $('input:checkbox').bind('click', function(){ clickCheckbox($(this));});

        $('.wrap-loading').css('display', 'none');
    });
}

function printDataTable(){
    $('#dataTbl').html("");
	var fy = parseInt($('#fromYear').val(),10);
	var ty = parseInt($('#toYear').val(),10);
	var thead = $('<thead></thead>');
	var trTh = $('<tr style="height:20px;"><th style="padding-left: 12px;"><span><input type="checkbox" name="toggleChkbox" id="toggleChkbox" value="0"/></span></th><th><span>IPC</span></th></tr>');
	var countCol = 0;
	for(var i=fy; i <= ty; i++){
		trTh.append($('<th class="center">'+i+'</th>'));
		countCol++;
	}
	trTh.append($('<th><span>합계</span></th>'));
	countCol++;

	$('#dataTbl').css('width',"100%");
	thead.append(trTh);
	$('#dataTbl').append(thead);

    fc = 0;
	var tbody  = $('<tbody></tbody>');
	for(var j=0; j < djArr.length; j++){
		var name = djArr[j].ipcContent;
		if(name == null)name = "";

		var id = djArr[j].ipc;
		var trTd = $('<tr id="data_'+id+'"></tr>');
		trTd.append('<td style="text-align: center;"><input type="checkbox"  id="no_chkbox_'+id+'" value="'+id+'" checked="checked"/>' +
			'<input type="hidden" name="no_fillColorIndex_'+id+'" id="no_fillColorIndex_'+id+'" value="'+fc+'"/>' +
			'</td>');
		trTd.append($('<td style="text-align:center;">'+name+'</td>'));
		var sum = 0;
		for(var i=fy; i <= ty; i++){
			var val = djArr[j][i] == undefined ? 0 : djArr[j][i];
			trTd.append($('<td style="text-align:center;">'+commaNum(val)+'</td>'));
			sum += Number(val);
		}
		trTd.append($('<td style="text-align:center;">'+commaNum(sum)+'</td>'));
		if(fc++ > fillColors.length-1) fc = 0;
		tbody.append(trTd);
	}
	$('#dataTbl').append(tbody);
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
		if($('#no_chkbox_'+djArr[i].ipc).is(':checked')){
			var color = fillColors[$('#no_fillColorIndex_'+djArr[i].ipc).val()];
			dataset += "<dataset seriesName='"+djArr[i].ipcContent+"' color='"+color+"' id='"+djArr[i].ipc+"' >";
			for(var j=fy; j <= ty; j++){
				var val = djArr[i][j] == undefined ? 0 : djArr[i][j];
				var toolText = djArr[i].ipcContent+" "+j+" :" + val;
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
	if( chart_ChartId1.hasRendered() ) chart_ChartId1.exportChart( { exportFormat : 'png'} );
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
	var tThead = $('#dataTbl > thead').clone();
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
	var excelFileName = "patentByIPC_from_" + $('#fromYear').val() +"_to_" + $('#toYear').val() + ".xls";
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

    patentByIPCAjax();
}
</script>
</head>
<body>
<h3 class="page_title"><spring:message code="menu.asrms.dept.patentByIPC"/></h3>
<div class="help_text mgb_30"><spring:message code="asrms.department.patentByIPC.desc"/></div>

<form id="frm" name="frm">
	<input type="hidden" id="topNm" name="topNm" value="${topNm}"/>
	<input type="hidden" name="trackId" id="trackId" value="${parameter.trackId}"/>
	<input type="hidden" name="deptKor" id="deptKor" value="${parameter.deptKor}"/>

	<!--START page_function-->
	<div class="sub_top_box">
		<span class="select_text">취득구분</span>
		<span class="select_span">
		  	<select name="acqsDvsCd" id="acqsDvsCd" onchange="javascript:acqsChange();">${rims:makeCodeList('1090',true,parameter.acqsDvsCd)}</select>
		</span>
		<span class="select_span" style="display:none;">
			<select name="status" id="status" mode="checkbox" onchange="javascript:patentByIPCAjax();">${rims:makeCodeList('patent.status',true,parameter.status)}</select>
		</span>
		<span class="select_text mgl_20">신분</span>
		<span class="select_span">
			<select name="isFulltime" id="isFulltime" onchange="javascript:patentByIPCAjax();">
				<option value="ALL">전체</option>
				<option value="M" selected="selected">전임</option>
				<option value="U">비전임</option>
			</select>
		</span>
		<span class="select_text mgl_20">실적구분</span>
		<span class="select_span">
		   <select name="insttRsltAt" id="insttRsltAt" onchange="javascript:patentByIPCAjax();">
				<option value="" selected="selected">전체</option>
				<option value="Y">${sysConf['inst.abrv']}</option>
				<option value="N">타기관</option>
			</select>
		</span>
		<span class="select_text mgl_20">실적기간</span>
		<span class="select_span">
			<select name="fromYear" id="fromYear" onchange="javascript:if(validateRange()){ patentByIPCAjax();}else{ errorMsg(this); $(this).val($(this).data('prev')); return false;}">
				<c:forEach var="yl" items="${patentYearList}" varStatus="idx" end="50">
					<option value="${yl.patYear }" ${idx.index == 5 ? 'selected="selected"' : '' }>${yl.patYear }</option>
				</c:forEach>
			</select>
		</span>
		~
		<span class="select_span">
			<select name="toYear" id="toYear" onchange="javascript:if(validateRange()){ patentByIPCAjax();}else{ errorMsg(this); $(this).val($(this).data('prev')); return false;}">
				<c:forEach var="yl" items="${patentYearList}" varStatus="idx" end="50">
					<option value="${yl.patYear }">${yl.patYear }</option>
				</c:forEach>
			</select>
		</span>
	</div>

	<div class="chart_box">
		<div id="chartdiv1" align="left"></div>
	</div>

	<p class="bt_box mgb_20"><a href="#" onclick="exportExcel();" class="black_bt"><em class="export_icon">Export</em></a></p>

	<div style="width: 100%;overflow: auto;">
		<table width="100%" id="dataTbl" class="list_tbl mgb_20"></table>
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
