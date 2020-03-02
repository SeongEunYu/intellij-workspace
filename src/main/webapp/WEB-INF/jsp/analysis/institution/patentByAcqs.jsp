<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><spring:message code="menu.asrms.inst.patentByAcqs"/></title>
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
<script type="text/javascript" src="${contextPath}/js/jquery/jquery.tablesorter.min.js"></script>
<script>
$(document).ready(function(){
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

	patentByAcqsAjax('0');
});


function patentByAcqsAjax(idx){
    if(!validateRange()){errorMsg(this); return false;}
	
    $.ajax({
		url:"<c:url value="/analysis/institution/patentByAcqsAjax.do"/>",
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
		var fromY = $("#fromYear").val();
		var toY = $("#toYear").val();
		var index = 0;

		for(var i=fromY; i<=toY; i++) {
			var check = 0;
			var check2 = 0;

			var $tr = '<tr id="tr' + index + '" >';
			$tr += '<td><span>' + i + '</span></td>';

			for (var j = 0; j < data.applListGroupYear.length; j++) {
				var appl = data.applListGroupYear[j];
				if (i == appl.patYear) {
					$tr += '<td class="center">' + appl.aplcCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + '</td>';
					$tr += '<td class="center">' + appl.aplcStatus1Co.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + '</td>';
					$tr += '<td class="center">' + appl.aplcStatus2Co.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + '</td>';
					$tr += '<td class="center">' + appl.aplcStatus3Co.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + '</td>';
					$tr += '<td class="center">' + appl.aplcStatus4Co.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + '</td>';
					$tr += '<td class="center">' + appl.aplcStatus5Co.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + '</td>';
					$tr += '<td class="center">' + appl.aplcPatentCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + '</td>';
					check = 1;
				}
			}

			if (check == 0) {
				$tr += '<td><span>0</span></td>';
				$tr += '<td><span>0</span></td>';
				$tr += '<td><span>0</span></td>';
				$tr += '<td><span>0</span></td>';
				$tr += '<td><span>0</span></td>';
				$tr += '<td><span>0</span></td>';
				$tr += '<td><span>0</span></td>';
			}

			for (var k = 0; k < data.regListGroupYear.length; k++) {
				var reg = data.regListGroupYear[k];

				if (reg.patYear == i) {
					$tr += '<td class="center">' + reg.registPatentCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + '</td>';
					check2 = 1;
				}
			}

			if (check2 == 0) {
				$tr += '<td><span>0</span></td>';
			}

			$tbody += $tr;
			index++;
		}

		$("#patentTbl tbody").html($tbody);

        if(data.applListGroupYear.length > 0 || data.regListGroupYear.length > 0){
            if(idx == '0'){
                $("#patentTbl").tablesorter({
                    sortList:[[0,0]],
                    headers: {
                        1: { sorter:'numFmt'},
                        2: { sorter:'numFmt'},
                        3: { sorter:'numFmt'},
                        4: { sorter:'numFmt'},
                        5: { sorter:'numFmt'},
                        6: { sorter:'numFmt'},
                        7: { sorter:'numFmt'},
                        8: { sorter:'numFmt'},
                    }
                });
            }else{
                $("#patentTbl th").removeClass('headerSortUp');
                $("#patentTbl th").removeClass('headerSortDown');
                $("#patentTbl th").eq(0).addClass('headerSortDown');
            }

            $("#patentTbl").trigger("update");
        }

		$('.wrap-loading').css('display', 'none');
	});
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
	var chartTitle = $('<tr><td style="text-align:center;"><h1><p>Institution - '+$('.page_title').html()+'</p></h1></td></tr>');
	//append chart image
	var chartTr = $('<tr><td><img src="'+fileName+'" height="350" /></td></tr>');
	var dataTbl = $('<tr><td><h1>Chart Data</h1></td></tr><tr><td>'+$('#patentTbl').clone().wrapAll('<div/>').parent().html()+'</td></tr>');
	table.append(chartTitle)
		.append(chartTr)
		.append(dataTbl);
	//make table with data of checked researcher
	div.append(table);
	$('#tableHTML').val(div.html());
	var excelFileName = "patentByAcq_from_" + $('#fromYear').val() +"_to_" + $('#toYear').val() + ".xls";
	$('#fileName').val(excelFileName);
	exportLog($('#frm'), excelFileName + "|" +  fileName);
	$('#excelFrm').submit();
}

</script>
</head>
<body>
<h3 class="page_title"><spring:message code="menu.asrms.inst.patentByAcqs"/></h3>
<div class="help_text mgb_30"><spring:message code="asrms.institution.patentByAcqs.desc"/></div>

<form id="frm" name="frm" action="${contextPath}/analysis/institution/patentByAcqs.do" method="post">
	<input type="hidden" id="topNm" name="topNm" value="${topNm}"/>

	<div class="top_option_box">
		<div class="to_inner">
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
		</div>

		<p class="ts_bt_box">
			<a href="javascript:patentByAcqsAjax();" class="to_search_bt"><span>Search</span></a>
		</p>
	</div>
	<h3 class="circle_h3">Chart</h3>

	<div id="chartdiv1" class="chart_box mgb_10"></div>

	<p class="bt_box mgb_10"><a href="#" onclick="exportExcel();" class="black_bt"><em class="export_icon">Export</em></a></p>

	<h3 class="circle_h3" id="list_title">Patent</h3>
	<div style="width: 100%;overflow: auto;">
		<table width="100%" id="patentTbl" class="list_tbl mgb_20">
			<col>
			<colgroup span="7"></colgroup>
			<thead>
			<tr>
				<th rowspan="2"><span>연도</span></th>
				<th colspan="7" scope="colgroup"><span>출원</span></th>
				<th rowspan="2"><span>등록</span></th>
			</tr>
			<tr>
				<th scope="col"><span>정상</span></th>
				<th scope="col"><span>거절</span></th>
				<th scope="col"><span>포기/취하/종결</span></th>
				<th scope="col"><span>소멸</span></th>
				<th scope="col"><span>이관/양도</span></th>
				<th scope="col"><span>심판/소송/보류</span></th>
				<th scope="col"><span>합계</span></th>
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
