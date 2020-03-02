<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><spring:message code="menu.asrms.clg.fundingByDvs"/></title>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/chart/opts/fusioncharts.opts.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/chart/fusioncharts.js"></script>
<script type="text/javascript" src="${contextPath}/js/jquery/jquery.tablesorter.min.js"></script>
<script type="text/javascript">
$(function() {
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

	fundingByDvsAjax('0');
});

function fundingByDvsAjax(idx){
    if(!validateRange()){errorMsg(this); return false;}

    $.ajax({
        url:"<c:url value="/analysis/college/fundingByDvsAjax.do"/>",
        dataType: "json",
        data: $('#frm').serialize(),
        method: "POST",
        beforeLoad: $('.wrap-loading').css('display', '')

    }).done(function(data){

        if(FusionCharts('fundingChart1')) {
            FusionCharts('fundingChart1').dispose();
            $('#chartdiv1').disposeFusionCharts().empty();
        }
        if(FusionCharts('fundingChart2')) {
            FusionCharts('fundingChart2').dispose();
            $('#chartdiv2').disposeFusionCharts().empty();
        }

        var fundingChartOpt = $.extend(true, {}, chartOpt);
        fundingChartOpt['id'] = 'fundingChart1';
        fundingChartOpt['type'] = 'msstackedcolumn2dlinedy';
        fundingChartOpt['renderAt'] = 'chartdiv1';
        fundingChartOpt['width'] = '100%';
        fundingChartOpt['height'] = '350';

        //    fundingChartOpt.dataSource.chart['plottooltext'] ="$label년{br}$seriesname: $value";
        fundingChartOpt.dataSource.chart['exportCallBack'] ='myFN_Co';
        fundingChartOpt.dataSource.chart['exportHandler'] = '${contextPath}/servlet/FCExporter/export.do';
        fundingChartOpt.dataSource.chart['interactiveLegend'] ='0';
        fundingChartOpt.dataSource.chart['xAxisName'] ='연도';
        fundingChartOpt.dataSource.chart['pYAxisName'] ='건수';
        fundingChartOpt.dataSource.chart['sYAxisName'] ='총 금액(단위:백만원)';
        //    fundingChartOpt.dataSource.chart['sNumberSuffix'] ='백만원';

        fundingChartOpt.dataSource['categories'] = data.categories1;
        fundingChartOpt.dataSource['dataset'] = data.dataset1;
        fundingChartOpt.dataSource['lineset'] = data.lineset1;

        new FusionCharts(fundingChartOpt).render();

        var fundingChartOpt2 = $.extend(true, {}, chartOpt);
        fundingChartOpt2['id'] = 'fundingChart2';
        fundingChartOpt2['type'] = 'msstackedcolumn2dlinedy';
        fundingChartOpt2['renderAt'] = 'chartdiv2';
        fundingChartOpt2['width'] = '100%';
        fundingChartOpt2['height'] = '350';

        //    fundingChartOpt2.dataSource.chart['plottooltext'] ="$label년{br}$seriesname: $value";
        fundingChartOpt2.dataSource.chart['exportCallBack'] ='myFN_Fund';
        fundingChartOpt2.dataSource.chart['exportHandler'] = '${contextPath}/servlet/FCExporter/export.do';
        fundingChartOpt2.dataSource.chart['interactiveLegend'] ='0';
        fundingChartOpt2.dataSource.chart['theme'] ='fint';
        fundingChartOpt2.dataSource.chart['xAxisName'] ='연도';
        fundingChartOpt2.dataSource.chart['pYAxisName'] ='총금액 및 간접비(단위:백만원)';
        fundingChartOpt2.dataSource.chart['sYAxisName'] ='건수';
        //    fundingChartOpt2.dataSource.chart['sNumberSuffix'] ='백만원';

        fundingChartOpt2.dataSource['categories'] = data.categories2;
        fundingChartOpt2.dataSource['dataset'] = data.dataset2;
        fundingChartOpt2.dataSource['lineset'] = data.lineset2;

        new FusionCharts(fundingChartOpt2).render();

        var $tbody = "";
        if(data.fundingDetailList.length > 0){
            for(var i=0; i<data.fundingDetailList.length; i++){
                var fd = data.fundingDetailList[i];
                var rsrcctDvs;

                if(fd.rsrcctSpptDvsCd == '1')rsrcctDvs = '정부'
                else if(fd.rsrcctSpptDvsCd == '2')rsrcctDvs = '지자체'
                else if(fd.rsrcctSpptDvsCd == '3')rsrcctDvs = '민간'
                else if(fd.rsrcctSpptDvsCd == '4')rsrcctDvs = '교내'
                else if(fd.rsrcctSpptDvsCd == '5')rsrcctDvs = '국외'
                else if(fd.rsrcctSpptDvsCd == '6')rsrcctDvs = '기타'

                var $tr = '<tr style="height:17px;">';
                $tr += '<td class="center">'+fd.rsrcctContYr+'</td>';
                $tr += '<td class="center">'+rsrcctDvs+'</td>';
                $tr += '<td class="center">'+fd.totRsrcct.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+'</td>';
                $tr += '<td class="center">'+(fd.indrfee ? fd.indrfee : "").toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+'</td>';
                $tr += '<td class="center">'+fd.rsrcctSum.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+'</td>';
                $tr += "</tr>";
                $tbody += $tr;
            }
        }else{
            var $tr = '<tr><td colspan="99" style="padding-left:5px;"><img src="${contextPath}/images/layout/ico_info.png" /> 검색된 Data가 없습니다.</td></tr>';
            $tbody += $tr;
        }

        $("#fundingTbl tbody").html($tbody);

		if(data.fundingDetailList.length > 0){
			if(idx == '0'){
				$("#fundingTbl").tablesorter({
					sortList:[[0,0]],
					headers: {
						2: { sorter:'numFmt'},
						3: { sorter:'numFmt'},
						4: { sorter:'numFmt'}
					}
				});
			}else{
				$("#fundingTbl th").removeClass('headerSortUp');
				$("#fundingTbl th").removeClass('headerSortDown');
				$("#fundingTbl th").eq(0).addClass('headerSortDown');
			}

			$("#fundingTbl").trigger("update");
		}

        $('#fromYear').data('prev', $('#fromYear').val());
        $('#toYear').data('prev', $('#toYear').val());

        $('.wrap-loading').css('display', 'none');
    });
}

var chartFileArr = new Array();
function exportExcel(){
	$("#tabs").tabs({active:0});
	setTimeout(function() {
		var chartObject1 = getChartFromId('fundingChart1');
		if( chartObject1.hasRendered() ) chartObject1.exportChart( { exportFormat : 'png'} );
	}, 1000);
}

function myFN_Co(objRtn){
	if (objRtn.statusCode=="1"){
		$("#tabs").tabs({active:1});
		chartFileArr.push(objRtn.fileName);
		setTimeout(function() {
			var chartObject = getChartFromId('fundingChart2');
			if( chartObject.hasRendered() ) chartObject.exportChart( { exportFormat : 'png'} );
		}, 1000);

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
	var chartTitle = $('<tr><td style="text-align:center;"><h1><p>College - '+$('.page_title').html()+'</p></h1></td></tr>');
	//append chart image
	var chart1Tr = $('<tr><td style="height:230px;"><img src="'+chartFileArr[0]+'" height="350"/></td></tr>');
	var chart2Tr = $('<tr><td style="height:230px;"><img src="'+chartFileArr[1]+'" height="350"/></td></tr>');
	var dataTbl = $('<tr><td><h1>Chart Data</h1></td></tr><tr><td>'+$('#fundingTbl').clone().wrapAll('<div/>').parent().html()+'</td></tr>');
	table.append(chartTitle)
		.append(chart1Tr)
		.append(chart2Tr)
		.append(dataTbl);
	//make table with data of checked researcher
	div.append(table);
	$('#tableHTML').val(div.html());
	var excelFileName = "fundingByDvs_from_" + $('#fromYear').val() +"_to_" + $('#toYear').val() + ".xls";
	$('#fileName').val(excelFileName);
	exportLog($('#frm'), excelFileName + "|" +  chartFileArr);
	chartFileArr = new Array();
	$('#excelFrm').submit();
}
 </script>
</head>
<body>
<h3 class="page_title"><spring:message code="menu.asrms.clg.fundingByDvs"/></h3>
<div class="help_text mgb_30"><spring:message code="asrms.college.fundingByDvs.desc"/></div>
<form id="frm" name="frm">
	<input type="hidden" id="topNm" name="topNm" value="${topNm}"/>
	<input type="hidden" name="clgCd" id="clgCd" value="${parameter.clgCd}"/>
<!--START page_function-->
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
			<a href="javascript:fundingByDvsAjax();" class="to_search_bt"><span>Search</span></a>
		</p>
	</div>

<h3 class="circle_h3">Chart</h3>

<div class="sub_content_wrapper">
	<div id="tabs" class="tab_wrap" style="display: none;">
	  <ul>
		<li><a href="#tabs-1">건수/총 금액</a></li>
		<li><a href="#tabs-2">총 금액,간접비/건수</a></li>
	  </ul>
		<div id="tabs-1">
			<div class="chart_box">
				<div id="chartdiv1"></div>
			</div>
		</div>
		<div id="tabs-2">
			<div class="chart_box">
				<div id="chartdiv2"></div>
			</div>
		</div>
	</div>
</div>

<p class="bt_box mgb_30"><a href="#" onclick="exportExcel();" class="black_bt"><em class="export_icon">Export</em></a></p>

<h3 class="circle_h3">Data</h3>

<div class="sub_content_wrapper">
	<table width="100%" id="fundingTbl" class="list_tbl mgb_20">
		<colgroup>
			<col style="width: 11%"/>
			<col style="width: 11%"/>
			<col style="width: 11%"/>
			<col style="width: 11%"/>
			<col style="width: 11%"/>
		</colgroup>
		<thead>
			<tr style="text-align: center;height:25px">
				<th><span>연도</span></th>
				<th><span>연구비<br/>지원 기관</span></th>
				<th><span>총 금액</span></th>
				<th><span>간접비</span></th>
				<th><span>총 건수</span></th>
			</tr>
		</thead>
		<tbody></tbody>
	</table>
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
