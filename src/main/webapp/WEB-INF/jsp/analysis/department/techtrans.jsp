<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><spring:message code="menu.asrms.dept.techtrans"/></title>
<style type="text/css" rel="stylesheet">
th.header {
    cursor: pointer;
    background-repeat: no-repeat;
    background-position: center right;
    padding-right: 13px;
    margin-right: -1px;
}
</style>
<script type="text/javascript" src="${contextPath}/js/jquery/jquery.tablesorter.min.js"></script>
<script>
var djArr;

$(document).ready(function(){
	tcntrnsAjax('0');
});

function tcntrnsAjax(idx){
    if(!validateRange()){errorMsg(this); return false;}

    $.ajax({
        url:"<c:url value="/analysis/department/tcntrnsAjax.do"/>",
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

        new FusionCharts({
            id: 'ChartId1',
            type:'msline',
            renderAt:'chartdiv1',
            width:'100%',
            height:'350',
            dataFormat:'xml',
            dataSource:data.chartXML
        }).render();

        printDataTable();

        if(idx == '0'){
            $("#publicationsTbl").tablesorter();
        }else{
            $("#publicationsTbl th").removeClass('headerSortUp');
            $("#publicationsTbl th").removeClass('headerSortDown');
            $("#publicationsTbl th").eq(0).addClass('headerSortDown');
        }

        $("#publicationsTbl").trigger("update");

        $('#fromYear').data('prev', $('#fromYear').val());
        $('#toYear').data('prev', $('#toYear').val());

        $('.wrap-loading').css('display', 'none');
    });
}

function printDataTable(){

	var transBody = $('#transBody');
	transBody.empty();
	var fy = parseInt($('#fromYear').val(),10);
	var ty = parseInt($('#toYear').val(),10);
	var val;
	for(var i=fy; i <= ty; i++){
		var totRpmt = 0;
		var tr = $('<tr></tr>');
		var rpmtJson = getYearJson(i);
		tr.append($('<td>'+i+'</td>'));

		val = rpmtJson.patentTransfrCo == undefined ? '0' : rpmtJson.patentTransfrCo;
		totRpmt += Number(val);
		tr.append($('<td>'+commaNum(val)+'</td>'));

		val = rpmtJson.dvrOprtnCo == undefined ? '0' : rpmtJson.dvrOprtnCo;
		totRpmt += Number(val);
		tr.append($('<td>'+commaNum(val)+'</td>'));

		val = rpmtJson.cmercOprtnCo == undefined ? '0' : rpmtJson.cmercOprtnCo;
		totRpmt += Number(val);
		tr.append($('<td>'+commaNum(val)+'</td>'));

		val = rpmtJson.knowHowCo == undefined ? '0' : rpmtJson.knowHowCo;
		totRpmt += Number(val);
		tr.append($('<td>'+commaNum(val)+'</td>'));

		val = rpmtJson.cnsutCo == undefined ? '0' : rpmtJson.cnsutCo;
		totRpmt += Number(val);
		tr.append($('<td>'+commaNum(val)+'</td>'));

		val = rpmtJson.etcCo == undefined ? '0' : rpmtJson.etcCo;
		totRpmt += Number(val);
		tr.append($('<td>'+commaNum(val)+'</td>'));

		tr.append($('<td>'+commaNum(totRpmt)+'</td>'));

		transBody.append(tr);

	}
	/*
	 if(djArr.length > 0){
	 }else{
		 transBody.append($('<tr><td ></td></tr>')) $('#disp_txt').text('No data to display');
	 }
	*/

}

function getYearJson(year){
	 var retString = "{";
	 for(var i=0; i < djArr.length; i++){
		 if(djArr[i].transYear == year){
			 if(djArr[i].techTransrCd == '1')
			 	retString += "'patentTransfrCo':'" + djArr[i].transCo + "',";
			 if(djArr[i].techTransrCd == '2')
			 	retString += "'dvrOprtnCo':'" + djArr[i].transCo + "',";
			 if(djArr[i].techTransrCd == '3')
			 	retString += "'cmercOprtnCo':'" + djArr[i].transCo + "',";
			 if(djArr[i].techTransrCd == '4')
			 	retString += "'knowHowCo':'" + djArr[i].transCo + "',";
			 if(djArr[i].techTransrCd == '5')
			 	retString += "'cnsutCo':'" + djArr[i].transCo + "',";
			 if(djArr[i].techTransrCd == '9')
			 	retString += "'etcCo':'" + djArr[i].transCo + "',";
		 }
	 }
	 if(retString.length == 1) retString += "'nodata':'nodata',";
	 retString = retString.substring(0, retString.length-1) + "}";
	 return eval('('+retString+')');
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
	 var pageTitle = $('<tr><td style="text-align:center;"><h1><p>Department(${item.deptKor}) - '+$('.page_title').html()+'</p></h1></td></tr>');
	 //append chart image
	 var chartTr = $('<tr><td><img src="'+fileName+'" height="350" /></td></tr>');
	 var dataTbl = $('<tr><td><h1>Chart Data</h1></td></tr><tr><td>'+$('#publicationsTbl').clone().wrapAll('<div/>').parent().html().replace(/<(\/a|a)([^>]*)>/gi,"")+'</td></tr>');
	 table.append(pageTitle)
     .append(chartTr)
     .append(dataTbl);
	 div.append(table);
	 $('#tableHTML').val(div.html());
	 var excelFileName = "Tcntrns_from_" + $('#fromYear').val() +"_to_" + $('#toYear').val() + ".xls";
	 $('#fileName').val(excelFileName);
	 exportLog($('#frm'), excelFileName + "|" +  fileName);
	 $('#excelFrm').submit();
 }

   </script>
</head>
<body>
	<h3 class="page_title"><spring:message code="menu.asrms.dept.techtrans"/></h3>
	<div class="help_text mgb_30"><spring:message code="asrms.department.techtrans.desc"/></div>

	<form id="frm" name="frm">
	<input type="hidden" id="topNm" name="topNm" value="<c:out value="${topNm}"/>"/>
	<input type="hidden" name="deptKor" id="deptKor" value="<c:out value="${parameter.deptKor}"/>"/>
	<input type="hidden" name="trackId" id="trackId" value="<c:out value="${parameter.trackId}"/>"/>

		<div class="top_option_box">
			<div class="to_inner">
				<span>기술이전형태</span>
				<em>
					<select name="techTransrCd" id="techTransrCd">
						<option value="">전체</option>
						<option value="1">특허양도</option>
						<option value="2">전용실시</option>
						<option value="3">통상실시</option>
						<option value="4">노하우</option>
						<option value="5">자문</option>
						<option value="9">기타</option>
					</select>
				</em>
				<span>실적기간</span>
				<em>
					<select name="fromYear" id="fromYear">
						<c:forEach var="yl" items="${transYearList}" varStatus="idx">
							<option value="${yl.transYear }" ${idx.index == 5 ? 'selected="selected"' : '' }>${yl.transYear }</option>
						</c:forEach>
					</select>
				</em>
				~
				<em>
					<select name="toYear" id="toYear">
						<c:forEach var="yl" items="${transYearList}" varStatus="idx">
							<option value="${yl.transYear }">${yl.transYear }</option>
						</c:forEach>
					</select>
				</em>
			</div>

			<p class="ts_bt_box">
				<a href="javascript:tcntrnsAjax();" class="to_search_bt"><span>Search</span></a>
			</p>
		</div>

		<h3 class="circle_h3">Chart</h3>

		<div id="chartdiv1" class="chart_box mgb_10"></div>

		<p class="bt_box mgb_10"><a href="#" onclick="exportExcel();" class="black_bt"><em class="export_icon">Export</em></a></p>

		<h3 class="circle_h3" id="list_title">Data</h3>

		<table width="100%" id="publicationsTbl" class="list_tbl mgb_20">
			<colgroup>
				<col style="width: 12%"/>
				<col style="width: 12%"/>
				<col style="width: 12%"/>
				<col style="width: 12%"/>
				<col style="width: 12%"/>
				<col style="width: 12%"/>
				<col style="width: 12%"/>
				<col style="width: 12%"/>
			</colgroup>
			<thead>
			<tr>
				<th><span>이전연도</span></th>
				<th><span>특허양도</span></th>
				<th><span>전용실시</span></th>
				<th><span>통상실시</span></th>
				<th><span>노하우</span></th>
				<th><span>자문</span></th>
				<th><span>기타</span></th>
				<th><span>합계</span></th>
			</tr>
			</thead>
			<tbody id="transBody">
			</tbody>
		</table>
</form>

<form id="excelFrm" method="post" action="${contextPath}/jsp/excelExport.jsp">
      <input type="hidden" id="tableHTML" name="tableHTML" value="" />
      <input type="hidden" id="fileName" name="fileName" value="trends.xls" />
</form>
</body>
</html>
