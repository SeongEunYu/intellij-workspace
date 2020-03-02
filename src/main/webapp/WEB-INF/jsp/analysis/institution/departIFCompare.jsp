<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><spring:message code="menu.asrms.inst.avgif"/></title>
<style type="text/css" rel="stylesheet">
	th.header {
		cursor: pointer;
		background-repeat: no-repeat;
		background-position: center right;
		padding-right: 15px;
		margin-right: -1px;
	}
	.to_inner span {min-width: 70px;}
</style>
<script type="text/javascript" src="${contextPath}/js/jquery/jquery.tablesorter.min.js"></script>
<script type="text/javascript">
var djArr;
var chart_ChartId1;
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

$(function() {
	$( "#tabs" ).tabs({
		activate: function( event, ui ) {
		}
	});
	$("#tabs").css("display", "block");

	departIFAjax('0');

});

function departIFAjax(idx){
    if(!validateRange()){errorMsg(this); return false;}

	$.ajax({
		url:"<c:url value="/analysis/institution/departIFAjax.do"/>",
		dataType: "json",
		data: $('#frm').serialize(),
		method: "POST",
		beforeLoad: $('.wrap-loading').css('display', '')

	}).done(function(data){
		djArr = eval('('+ data.dataJson+')');

		if(FusionCharts('ChartId1')) {
			FusionCharts('ChartId1').dispose();
		 $('#chartdiv1').disposeFusionCharts().empty();
		 }

		chart_ChartId1 = new FusionCharts({
			id: 'ChartId1',
			type:'Column2D',
			renderAt:'chartdiv1',
			width:'100%',
			height:'400',
			dataFormat:'xml',
			dataSource:data.chartXML
        }).render();

		var $tbody = "";
		if(data.departList.length > 0){

			for(var i=0; i<data.departList.length; i++){
				var item = data.departList[i];
				var artNo_IF;
				var sumIF;
				var avgIF;
				var avgIF_Ex;

				if(data.parameter.gubun == "SCI"){
					artNo_IF = item.impctFctrExsArtsCo;
					sumIF = (item.impctFctrSum.toFixed(2)*1).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
                    avgIF = (item.impctFctrAvrg.toFixed(2)*1).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
                    avgIF_Ex = (item.impctFctrExsAvrg.toFixed(2)*1).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
				}else if(data.parameter.gubun == "SCOPUS"){
					artNo_IF = item.sjrExsArtsCo;
                    sumIF = (item.sjrSum.toFixed(2)*1).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
                    avgIF = (item.sjrAvrg.toFixed(2)*1).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
                    avgIF_Ex = (item.sjrExsAvrg.toFixed(2)*1).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');

				}else if(data.parameter.gubun == "KCI"){
					artNo_IF = item.kciIFExsArtsCo;
                    sumIF = (item.kciIFSum.toFixed(2)*1).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
                    avgIF = (item.kciIFAvrg.toFixed(2)*1).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
                    avgIF_Ex = (item.kciIFExsAvrg.toFixed(2)*1).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
				}

				var $tr = '<tr style="height:17px;" id="data_'+item.deptCode+'" >';
				$tr += '<td style="text-align: center;">';
				$tr += '<input type="checkbox"  id="no_chkbox_'+item.deptCode+'" value="'+item.deptCode+'" /></td>';
				$tr += '<td style="text-align: left;">'+item.deptKor+'</td>';
				$tr += '<td class="center">'+item.userCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+'</td>';
				$tr += '<td class="center">'+item.artsTotal.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+'</td>';
				$tr += '<td class="center">'+artNo_IF.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+'</td>';
				$tr += '<td class="center">'+sumIF+'</td>';
				$tr += '<td class="center">'+avgIF+'</td>';
				$tr += '<td class="center">'+avgIF_Ex+'</td>';
				$tr += "</tr>";
				$tbody += $tr;
			}
		}else{
			var $tr = '<tr><td colspan="99" style="padding-left:5px;"><img src="${contextPath}/images/layout/ico_info.png" /> 검색된 Data가 없습니다.</td></tr>';
			$tbody += $tr;
		}

		$("#dataTbl tbody").html($tbody);

		if(data.departList.length > 0){
			if(idx == '0'){
				var avgIFType = data.parameter.avgIFType;
				$("#dataTbl").tablesorter({
					sortList:[[6,1]],
					headers: {
						0: { sorter: false },
						2: { sorter:'numFmt'},
						3: { sorter:'numFmt'},
						4: { sorter:'numFmt'},
						5: { sorter:'numFmt'},
						6: { sorter:'numFmt'},
						7: { sorter:'numFmt'}
					}
				});
			}else{
				$("#dataTbl th").removeClass('headerSortUp');
				$("#dataTbl th").removeClass('headerSortDown');
				if($('#avgIFType').val() == "wh"){
					$("#dataTbl th").eq(6).addClass('headerSortUp');
				}else{
					$("#dataTbl th").eq(7).addClass('headerSortUp');
				}
			}

			$("#dataTbl").trigger("update");

			$('input:checkbox').bind('click', function(){ clickCheckbox($(this));});

			if(data.departList.length <= 12)$("#dataTbl thead tr th").eq(0).find("input").attr("checked","checked");

			for(var j=1;j<13;j++)$("#dataTbl input").eq(j).attr("checked","checked");

		}

		$('#fromYear').data('prev', $('#fromYear').val());
		$('#toYear').data('prev', $('#toYear').val());

		$('.wrap-loading').css('display', 'none');
	});
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

	var chartId = 'ChartId1';
	var avgIFType = $('#avgIFType').val();
	var artGubun = $('#gubun').val();
	var dataset = "";
	for(var i=0; i < djArr.length; i++){
		var fcIdx = i % 23;
		if($('#no_chkbox_'+djArr[i].deptCode).is(':checked')){
			var color = fillColors[fcIdx];
			var value = '';

			if("wh" == avgIFType)
			{
				if(artGubun == "SCI") value = djArr[i].impctFctrAvrg;
				else if(artGubun == "SCOPUS") value = djArr[i].sjrAvrg;
				else if(artGubun == "KCI") value = djArr[i].kciIFAvrg;
			}
			else if("ex" == avgIFType)
			{
				if(artGubun == "SCI") value = djArr[i].impctFctrExsAvrg;
				else if(artGubun == "SCOPUS") value = djArr[i].sjrExsAvrg;
				else if(artGubun == "KCI") value = djArr[i].kciIFExsAvrg;
			}

			if(value == undefined)	value = 0;
			value = value / 1;
            value = (value.toFixed(2)*1).toString();

			var toolText = djArr[i].deptKor+" :" + value;
			dataset += "<set label='"+djArr[i].deptKor+"' value='"+value+"' toolText='"+toolText+"' color='"+color+"' />";
		}
	}

	var flashvars = "";

	if(jQuery.browser.msie == true && parseInt(jQuery.browser.version) <= 10){
		$('#'+chartId).children().each(function(){ if($(this).attr('name') == 'flashvars')  flashvars = $(this).attr('value'); });
	}else{
		flashvars = $('#'+chartId).attr('flashvars');
	}

	var chartData = chart_ChartId1.getChartData('xml');
	if(chartData.indexOf("<set") != -1)
	{
		chartData = chartData.replace(/(<chart .* >)(<set .*>)(<styles.*)/, '$1'+dataset+'$3');
	}
	else
	{
		chartData = chartData.replace(/(<chart .* >)(<styles.*)/, '$1'+dataset+'$2');
	}
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
	var chartTitle = $('<tr><td style="text-align:center;"><h1><p>Institution - '+$('.page_title').html()+'</p></h1></td></tr>');
	//append chart image
	var chartTr = $('<tr><td><img src="'+fileName+'" height="350" /></td></tr>');
	var dataTitle = $('<tr><td><h1>Chart Data</h1></td></tr>');
	table.append(chartTitle)
		.append(chartTr)
		.append(dataTitle);
	//make table with data of checked researcher
	var dTbl = $('<table class="list_tbl mgb_20"></table>');

	var thead = $('#dataTbl > thead').clone();
	thead.find('tr th:first-child').remove();
	dTbl.append(thead.wrapAll('<div/>').parent().html());
	var dataTbody = $('<tbody></tbody>');
	var chb = $('input[id^="no_chkbox_"]:checked');
	for(var i=0; i < chb.length ; i++){
		var id = chb.eq(i).val();
		var dataTr = $('#data_'+id).clone();
		dataTr.find('td:first-child').remove();
		dataTbody.append(dataTr.wrapAll('<div/>').parent().html());
	}
	dTbl.append(dataTbody);
	table.append($('<tr><td>'+dTbl.clone().wrapAll('<div/>').parent().html()+'</td></tr>'));
	div.append(table);
	$('#tableHTML').val(div.html());
	var excelFileName = "DepartmentAverageOfImpactFactorCompare_"+$('#gubun').val() + "_from_" + $('#fromYear').val() +"_to_" + $('#toYear').val() + ".xls";
	$('#fileName').val(excelFileName);
	exportLog($('#frm'), excelFileName + "|" +  fileName);
	$('#excelFrm').submit();
}
</script>
</head>
<body>
<h3 class="page_title"><spring:message code="menu.asrms.inst.avgif"/></h3>
<div class="help_text mgb_30"><spring:message code="asrms.institution.impactfactor.desc"/></div>

<form id="frm" name="frm">
	<input type="hidden" id="topNm" name="topNm" value="<c:out value="${topNm}"/>"/>
	<input type="hidden" name="avgIFType" id="avgIFType" value="wh"/>

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
			<span>학술지구분</span>
			<em>
				<select name="gubun" id="gubun">
					<option value="SCI" selected="selected">SCI</option>
					<option value="SCOPUS">SCOPUS</option>
					<option value="KCI">KCI</option>
				</select>
			</em>
			<span>실적구분</span>
			<em>
				<select name="insttRsltAt" id="insttRsltAt">
					<option value="" selected="selected">전체</option>
					<option value="Y">${sysConf['inst.abrv']}</option>
					<option value="N">타기관</option>
				</select>
			</em>
			<span>실적기간</span>
			<em>
				<select name="fromYear" id="fromYear">
					<c:forEach var="yl" items="${pubYearList}" varStatus="idx" end="50">
						<option value="${yl.pubYear }" ${idx.index == 5 ? 'selected="selected"' : '' }>${yl.pubYear }</option>
					</c:forEach>
				</select>
			</em>
			~
			<em>
				<select name="toYear" id="toYear">
					<c:forEach var="yl" items="${pubYearList}" varStatus="idx" end="50">
						<option value="${yl.pubYear }">${yl.pubYear }</option>
					</c:forEach>
				</select>
			</em>
		</div>
		<p class="ts_bt_box">
			<a href="javascript:departIFAjax();" class="to_search_bt"><span>Search</span></a>
		</p>
	</div>

	<div style="float: right;margin-top: 5px;">
		<input type="radio" name="avgIFTypeW" id="avgIFTypeW" value="wh"  checked="checked"style="vertical-align: -5px;" onchange="javascript: $('#avgIFType').val($(this).val()); departIFAjax(); $('#avgIFTypeE').removeAttr('checked');" /><span> IF 평균1 (IF합/전체 논문수)&nbsp;&nbsp;</span>
		<input type="radio" name="avgIFTypeE" id="avgIFTypeE" value="ex" style="vertical-align: -5px;" onchange="javascript: $('#avgIFType').val($(this).val()); departIFAjax(); $('#avgIFTypeW').removeAttr('checked');"/><span> IF 평균2 (IF합/IF 제공 논문수)</span>
	</div>

	<h3 class="circle_h3">Chart</h3>

	<div id="chartdiv1" class="chart_box mgb_10"></div>

	<p class="bt_box mgb_20"><a href="#" onclick="exportExcel();" class="black_bt"><em class="export_icon">Export</em></a></p>

	<h3 class="circle_h3">Data</h3>
	<table width="100%" id="dataTbl" class="list_tbl mgb_20">
		<colgroup>
			<col style="width: 4%"/>
			<col style="width: 21%"/>
			<col style="width: 9%"/>
			<col style="width: 9%"/>
			<col style="width: 9%"/>
			<col style="width: 10%"/>
			<col style="width: 19%"/>
			<col style="width: 23%"/>
		</colgroup>
		<thead>
		<tr>
			<th style="padding-left: 12px;"><span><input type="checkbox" name="toggleChkbox" id="toggleChkbox" value="0"/> </span></th>
			<th><span>학(부)과명</span></th>
			<th><span>교원수</span></th>
			<th><span>전체<br/>논문수</span></th>
			<th><span>IF제공<br/>논문수</span></th>
			<th><span>IF합계</span></th>
			<th><span>IF평균1<br/>(IF합/전체 논문수)</span></th>
			<th><span>IF평균2<br/>(IF합/IF 제공 논문수)</span></th>
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
