<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><spring:message code="menu.asrms.rsch.patent"/></title>
<style type="text/css" rel="stylesheet">
th.header {
    cursor: pointer;
    background-repeat: no-repeat;
    background-position: center right;
    padding-right: 13px;
    margin-right: -1px;
}
</style>
<script>
$(document).ready(function(){
    $("#acqsDvsCd option").eq(0).remove();
    patentTrendAjax();
});


function patentTrendAjax(){
    if(!validateRange()){errorMsg(this); return false;}

    $.ajax({
        url:"<c:url value="/analysis/researcher/patentTrendAjax.do"/>",
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

        new FusionCharts({
            id: 'ChartId1',
            type:'msline',
            renderAt:'chartdiv1',
            width:'100%',
            height:'350',
            dataFormat:'xml',
            dataSource:data.chartXML+""
        }).render();

        $('#patentTbl > tbody').empty();
        makeArticleList(data.patentList);

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

function regNtnChange(){
    if($("#acqsNtnDvsCd").val() == "1"){
        $("#applRegNtnCd").parent().css("display","none");
    }else{
        $("#applRegNtnCd").parent().css("display","");
    }
}

 function clickChart(args){

	 var param = args.split(";");
	 var isCited = param[0];
	 var year = param[1];

	 $('#list_title').text('Publication ( '+year+'년)');
	 $('#patentTbl > tbody').empty();

	 $.ajax({
		 url : "${contextPath}/analysis/researcher/findPatentListByUserIdAjax.do",
		 dataType : 'json',
		 data : { "selectedYear" : year,
			      "userId": $('#userId').val(),
			      "fromYear": $('#fromYear').val(),
			      "toYear": $('#toYear').val(),
			      "gubun" : $('#gubun').val(),
			      "applStatus" : $('#applStatus').val(),
			      "applRegNtnCd" : $('#applRegNtnCd').val(),
			      "acqsNtnDvsCd" : $('#acqsNtnDvsCd').val(),
			      "acqsDvsCd" : $('#acqsDvsCd').val(),
			      "status" : $('#status').val(),
			      "topNm"   :'researcher'
			     },
		 success : function(data, textStatus, jqXHR){
             makeArticleList(data);
		 }
	 }).done(function(){});
 }



function makeArticleList(data){

	for(var i=0; i < data.length; i++){

		var patentId = data[i].patentId;
		var itlPprRgtNm = data[i].itlPprRgtNm;
		var applRegNtnNm = data[i].applRegNtnNm;
		var applRegtNm = data[i].applRegtNm;
		var applRegNo = data[i].applRegNo;
		var applRegDate = data[i].applRegDate;
		var itlPprRgtRegNo = data[i].itlPprRgtRegNo;
		var itlPprRgtRegDate = data[i].itlPprRgtRegDate;
		var invtNm = data[i].invtNm;
		var invtCnt = data[i].invtCnt;

		var $tr = $('<tr style="height:17px;"></tr>');
		$tr.append($('<td style="font-size: 10pt;" align="center" width="40">'+(i+1)+'</td>'));
		var $td = $('<td class="link_td" style="font-size: 10pt;"></td>')
			.append($('<div class="style_12pt"><a href="javascript:popPatent('+patentId+')"><b>'+itlPprRgtNm+'</b></a></div>'));
		var content = '<span>'+applRegNtnNm + ' | 출원인 : '+applRegtNm;
		if(applRegNo != null && applRegNo != '')
			content += '| 출원번호 :' + applRegNo + "(" + applRegDate +")";
		if(itlPprRgtRegNo != null && itlPprRgtRegNo != '')
			content += '| 등록번호 :' + itlPprRgtRegNo + "(" + itlPprRgtRegDate +")";
		content += ' | 발명인 : ' + invtNm + "(" +invtCnt+ ")</span>";
		$td.append(content);
		$tr.append($td);
		$('#patentTbl > tbody').append($tr);
	}

	if(data.length == 0){
		var $tr = "<tr style='background-color: #ffffff;' height='17px'>";
		$tr += '<td colspan="3"><img src="${contextPath}/images/layout/ico_info.png" />There is no Patent.</td></tr>';
		$('#patentTbl > tbody').append($tr);
	}

	//alert(data[0].ESUBJECT);
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
	var pageTitle = $('<tr><td style="text-align:center;" colspan="5"><h1><p>Researcher(${item.korNm}) - '+$('.page_title').html()+'</p></h1></td></tr>');
	//append chart image
	var chartTr = $('<tr><td><img src="'+fileName+'" height="400"/></td></tr>');
	var dataTbl = $('<tr><td><h1>Data</h1></td></tr><tr><td>'+$('#patentTbl').clone().wrapAll('<div/>').parent().html().replace(/<td class=\"link_td\"/g,"<td class=\"link_td\" colspan='10'").replace("<th><span>Patent","<th colspan='10'><span>Patent")+'</td></tr>');
	table.append(pageTitle)
			.append(chartTr)
			.append(dataTbl);
	div.append(table);
	$('#tableHTML').val(div.html());
	var excelFileName = "Patent by Year_from_" + $('#fromYear').val() +"_to_" + $('#toYear').val() + ".xls";
	$('#fileName').val(excelFileName);
	exportLog($('#frm'), excelFileName + "|" +  fileName);
	$('#excelFrm').submit();
}

   </script>
</head>
<body>

	<h3 class="page_title"><spring:message code="menu.asrms.rsch.patent"/></h3>
	<div class="help_text mgb_30"><spring:message code="asrms.researcher.patent.desc"/></div>

	<form id="frm" name="frm">
	<input type="hidden" id="topNm" name="topNm" value="<c:out value="${topNm}"/>"/>
	<input type="hidden" name="userId" id="userId" value="<c:out value="${parameter.userId}"/>"/>
	<input type="hidden" name="mode" id="mode" value="<c:out value="${parameter.mode}"/>"/>
	<input type="hidden" name="srchUserId" id="srchUserId" value="<c:out value="${parameter.srchUserId}"/>"/>
	<input type="hidden" name="srchUserPhotoUrl" id="srchUserPhotoUrl" value="<c:out value="${parameter.srchUserPhotoUrl}"/>"/>

	<div class="top_option_box">
		<div class="to_inner">
			<span>Class</span>
			<em>
				<select name="acqsDvsCd" id="acqsDvsCd" onchange="javascript:acqsChange();">${rims:makeCodeList('1090',true,parameter.acqsDvsCd)}</select>
			</em>
			<em style="display:none;">
				<select name="status" id="status" mode="checkbox" >${rims:makeCodeList('patent.status',true,parameter.status)}</select>
			</em>
			<span>Type</span>
			<em>
				<select name="acqsNtnDvsCd" id="acqsNtnDvsCd" onchange="javascript:regNtnChange();">
					<option value=""><spring:message code="common.option.all"/></option>
					<option value="1">국내</option>
					<option value="2">해외</option>
				</select>
			</em>
			<em style="display:none;">
				<select name="applRegNtnCd" id="applRegNtnCd">
					<option value=""><spring:message code="common.option.all"/></option>
					<c:forEach var="nc" items="${applRegNtnCdList}" varStatus="idx">
						<option value="${nc.applRegNtnCd }">${nc.applRegNtnNm}</option>
					</c:forEach>
				</select>
			</em>
			<span>Year Range</span>
			<em>
				<select name="fromYear" id="fromYear">
					<c:forEach var="yl" items="${patYearList}" varStatus="idx" end="50">
						<c:choose>
							<c:when test="${fn:length(patYearList) > 5}">
								<option value="${yl.patYear }" ${idx.index == 5 ? 'selected="selected"' : '' }>${yl.patYear }</option>
							</c:when>
							<c:otherwise>
								<option value="${yl.patYear }" ${idx.last == true? 'selected="selected"' : '' }>${yl.patYear }</option>
							</c:otherwise>
						</c:choose>
					</c:forEach>
				</select>
			</em>
			~
			<em>
				<select name="toYear" id="toYear">
					<c:forEach var="yl" items="${patYearList}" varStatus="idx" end="50">
						<option value="${yl.patYear }">${yl.patYear }</option>
					</c:forEach>
				</select>
			</em>
		</div>

		<p class="ts_bt_box">
			<a href="javascript:patentTrendAjax();" class="to_search_bt"><span>Search</span></a>
		</p>
	</div>

	<h3 class="circle_h3">Chart</h3>

	<div id="chartdiv1" class="chart_box mgb_10"></div>

	<p class="bt_box mgb_10"><a href="#" onclick="exportExcel();" class="black_bt"><em class="export_icon">Export</em></a></p>

	<h3 class="circle_h3" id="list_title">Patent</h3>

	<table width="100%" id="patentTbl" class="list_tbl mgb_20">
		<colgroup>
			<col style="width: 10%"/>
			<col/>
		</colgroup>
		<thead>
		<tr>
			<th><span>NO</span></th>
			<th><span>Patent</span></th>
		</tr>
		</thead>
		<tbody></tbody>
	</table>
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
