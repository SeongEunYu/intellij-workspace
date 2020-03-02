<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><spring:message code="menu.asrms.dept.patentTrend"/></title>
<style type="text/css" rel="stylesheet">
	th.header {
		cursor: pointer;
		background-repeat: no-repeat;
		background-position: center right;
		padding-right: 13px;
		margin-right: -1px;
	}
</style>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/chart/opts/fusioncharts.opts.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/chart/fusioncharts.js"></script>
<script>
$(document).ready(function(){
	$("#acqsDvsCd option").eq(0).remove();
	patentTrendAjax();
});

function patentTrendAjax(){
    if(!validateRange()){errorMsg(this); return false;}

    $.ajax({
        url:"<c:url value="/analysis/department/patentTrendAjax.do"/>",
        dataType: "json",
        data: $('#frm').serialize(),
        method: "POST",
        beforeLoad: $('.wrap-loading').css('display', '')

    }).done(function(data){
        $('#fromYear').data('prev', $('#fromYear').val());
        $('#toYear').data('prev', $('#toYear').val());

        if(FusionCharts('ChartId1')) {
            FusionCharts('ChartId1').dispose();
            $('#chartdiv1').disposeFusionCharts().empty();
        }

        var patentChartOpt = $.extend(true, {}, chartOpt);
        patentChartOpt['id'] = 'ChartId1';
        patentChartOpt['type'] = 'msstackedcolumn2d';
        patentChartOpt['renderAt'] = 'chartdiv1';
        patentChartOpt['width'] = '100%';
        patentChartOpt['height'] = '350';

        patentChartOpt.dataSource.chart['interactiveLegend'] ='0';
        patentChartOpt.dataSource.chart['exportHandler'] = '${contextPath}/servlet/FCExporter/export.do';
        patentChartOpt.dataSource.chart['exportCallBack'] ='myFN';
        patentChartOpt.dataSource['categories'] = data.categories;
        patentChartOpt.dataSource['dataset'] = data.dataset;
        patentChartOpt.dataSource['styles'] = data.styles;

        new FusionCharts(patentChartOpt).render();

        var $tbody = "";
        if(data.patentListGroupYear.length > 0){

            for(var i=0; i<data.patentListGroupYear.length; i++){
                var patent = data.patentListGroupYear[i];

                var $tr = '<tr>';
                $tr += '<td><span>'+patent.patYear+'</span></td>';
                $tr += '<td><span>'+patent.dmstcPatentCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+'</span></td>';
                $tr += '<td><span>'+patent.ovseaPatentCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+'</span></td>';
                $tr += '<td><span>'+patent.patentCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+'</span></td>';
                $tr += '</tr>';
                $tbody += $tr;
            }
        }else{
            var $tr = '<tr><td colspan="99" style="padding-left:5px;"><img src="${contextPath}/images/layout/ico_info.png" /> 검색된 Data가 없습니다.</td></tr>';
            $tbody += $tr;
        }

        $("#patentTbl tbody").html($tbody);

        $('.wrap-loading').css('display', 'none');
    });
}

function acqsChange(){
    if($("#acqsDvsCd").val() == "1"){
        $("#status").parent().css("display","none");
    }else{
        $("#status").parent().css("display","");
    }
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
	var dataTbl = $('<tr><td><h1>Chart Data</h1></td></tr><tr><td>'+$('#patentTbl').clone().wrapAll('<div/>').parent().html()+'</td></tr>');
	table.append(chartTitle)
		.append(chartTr)
		.append(dataTbl);
	//make table with data of checked researcher
	div.append(table);
	$('#tableHTML').val(div.html());
	var excelFileName = "patentTrend_from_" + $('#fromYear').val() +"_to_" + $('#toYear').val() + ".xls";
	$('#fileName').val(excelFileName);
	exportLog($('#frm'), excelFileName + "|" +  fileName);
	$('#excelFrm').submit();
}

</script>
</head>
<body>
<h3 class="page_title"><spring:message code="menu.asrms.dept.patentTrend"/></h3>
<div class="help_text mgb_30"><spring:message code="asrms.department.patentTrend.desc"/></div>

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
			<a href="javascript:patentTrendAjax();" class="to_search_bt"><span>Search</span></a>
		</p>
	</div>


	<h3 class="circle_h3">Chart</h3>

	<div id="chartdiv1" class="chart_box mgb_10"></div>

	<p class="bt_box mgb_10"><a href="#" onclick="exportExcel();" class="black_bt"><em class="export_icon">Export</em></a></p>

	<h3 class="circle_h3" id="list_title">Patent</h3>
	<div style="width: 100%;overflow: auto;">
	<table width="100%" id="patentTbl" class="list_tbl mgb_20">
		<thead>
			<tr>
				<th><span>연도</span></th>
				<th><span>국내</span></th>
				<th><span>해외</span></th>
				<th><span>전체</span></th>
			</tr>
		</thead>
		<tbody></tbody>
	</table>
	</div>
</form>

<form id="excelFrm" method="post" action="${contextPath}/jsp/excelExport.jsp">
	<input type="hidden" id="tableHTML" name="tableHTML" value="" />
	<input type="hidden" id="fileName" name="fileName" value="trends.xls" />
	<div style="display: none;" id="excelExportDiv" class="tabl_datos">
		<table class="list_tbl mgb_20">
			<tr>
			</tr>
		</table>
	</div>
	<!--
    <input type="button" onclick="gotoExcel('tableData', 'tableHTML');" value="Export these results" />
     -->
</form>
</body>
</html>
