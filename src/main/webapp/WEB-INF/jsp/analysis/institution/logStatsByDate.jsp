<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Department Trend Compare</title>
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
 var toggle = true;
 var fc = 0;
 var if_fc = 0;
 //var djArr = eval('('+ '${dataJson}'+')');
 var chart_ChartId1;
 $(document).ready(function(){
	$('#only_data_div').css('display','none');
	$('#chart_data_div').css('display','');

	 $( "#tabs" ).tabs({
		active: '<c:out value="${sTabIdx}"/>',
		activate: function( event, ui ) {
			//clickCheckbox();
			if(ui.newPanel.is('#tabs-1')) $('#sTabIdx').val('0');
			if(ui.newPanel.is('#tabs-2')) $('#sTabIdx').val('1');
		},
		beforeActivate:function( event, ui ) {
			if(ui.newPanel.is('#tabs-1')) $('#prefix').val('no_');
			if(ui.newPanel.is('#tabs-2')) $('#prefix').val('if_');
		}
	});
	 $("#tabs").css("display", "block");

	 $('#fromYear').data('prev', $('#fromYear').val());
	 $('#toYear').data('prev', $('#toYear').val());

	 renderChart();
  });

function renderChart(){

	   var chartWidth = "100%";
	   if(browserType() == "I") chartWidth = "748";

	   chart_ChartId1 =  new FusionCharts({
		 	  type:'msline',
		 	  renderAt:'chartdiv1',
		 	  width:chartWidth,
		 	  height:'350',
		 	  dataFormat:'xml',
		 	  dataSource:"${chartXML}"
		   }).render();
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
	 $("#tabs").tabs({active:0});
	 setTimeout(function() {
	 	var chartObject = getChartFromId('ChartId1');
	 	if( chartObject.hasRendered() ) chartObject.exportChart( { exportFormat : 'png'} );
	  }, 1000);
 }
 function saveExcel(fileName){
	 var isAnonymous = $('#anonymous').is(':checked');
	 var div = $('<div></div>');
	 var table = $('<table></table>');
	 //append document title
	 var chartTitle = $('<tr><td style="text-align:center;"><h1><p>Department(${item.DEPT_KOR}) - '+$('.page_title').html()+'</p></h1></td></tr>');
	 //append chart image

var chartTr = $('<tr><td><img src="'+fileName+'" height="350"/></td></tr>');
	 var dataTitle = $('<tr><td><h1>Chart Data</h1></td></tr>');
	 table.append(chartTitle)
	      .append(chartTr)
	      .append(dataTitle);
	 //make table with data of checked researcher
	 var dTbl = $('<table class="list_tbl mgb_20"></table>');
	 var thead = $('#dataTbl > thead').clone();
	 if(isAnonymous) thead.find('tr th').eq(1).remove();
	 dTbl.append(thead.wrapAll('<div/>').parent().html());
	 //dTbl.append($('#dataTbl > thead').clone().wrapAll('<div/>').parent().html());
	 var dataTbody = $('<tbody></tbody>');
	 var chb = $('input[id^="no_chkbox_"]:checked');
	 for(var i=0; i < chb.length ; i++){
		 var id = chb.eq(i).val();
		 var dataTr = $('#data_'+id).clone();
		 if(isAnonymous) dataTr.find('td').eq(1).remove();
		 dataTbody.append(dataTr.wrapAll('<div/>').parent().html());
		 //dataTbody.append($('#data_'+id).clone().wrapAll('<div/>').parent().html());
	 }
	 dTbl.append(dataTbody);
	 table.append($('<tr><td>'+dTbl.clone().wrapAll('<div/>').parent().html()+'</td></tr>'));
	 div.append(table);
	 $('#tableHTML').val(div.html());
	 var excelFileName = "NumberOfPublicationCompare_"+$('#gubun').val() + "_from_" + $('#fromYear').val() +"_to_" + $('#toYear').val() + ".xls";
	 $('#fileName').val(excelFileName);
	 exportLog($('#frm'), excelFileName + "|" +  fileName);
	 $('#excelFrm').submit();
 }
 </script>
</head>
<body>

	<h3 class="page_title">로그 분석 by Date</h3>
	<%--<div class="help_text mgb_30"><spring:message code="asrms.institution.logStatsByDate.desc"/></div>--%>

		<form id="frm" name="frm" action="${contextPath}/analysis/institution/logStatsByDate.do" method="post">
		<input type="hidden" id="topNm" name="topNm" value="<c:out value="${topNm}"/>"/>

			<!--START page_function-->
			<div class="sub_top_box">

				<span class="select_text">Access User</span>
				<span class="select_span">
					<select name="userId" id="userId" onchange="javascript:$('#frm').submit();">
						<option value="" ${empty parameter.userId ? 'selected="selected"' : '' }>전체</option>
						<c:forEach var="ul" items="${userList}" varStatus="idx">
						  <option value="${ul.userId }" ${parameter.userId eq ul.userId ? 'selected="selected"' : '' }>${ul.korNm }</option>
						</c:forEach>
					</select>
				</span>

				<span class="select_text mgl_20">Top Menu</span>
				<span class="select_span">
					<select name="searchTopMenu" id="searchTopMenu" onchange="javascript:$('#frm').submit();">
						<option value="" ${empty parameter.searchTopMenu ? 'selected="selected"' : '' }>전체</option>
						<c:forEach var="tl" items="${topMenuList}" varStatus="idx">
						  <option value="${tl.codeValue }" ${parameter.searchTopMenu eq tl.codeValue ? 'selected="selected"' : '' }>${tl.codeDisp }</option>
						</c:forEach>
					</select>
				</span>

				<span class="select_text mgl_20">Year-Month range</span>
				<span class="select_span">
					<select name="fromYm" id="fromYm" onchange="javascript:if(validateRange()){ $('#frm').submit();}else{ errorMsg(this); $(this).val($(this).data('prev')); return false;}">
						<c:forEach var="yl" items="${regymList}" varStatus="idx">
						  <option value="${yl.regym }" ${parameter.fromYm eq yl.regym ? 'selected="selected"' : '' }>${yl.regym }</option>
						</c:forEach>
					</select>

				</span>
				~
				<span class="select_span">
					<select name="toYm" id="toYm" onchange="javascript:if(validateRange()){ $('#frm').submit();}else{ errorMsg(this); $(this).val($(this).data('prev')); return false;}">
						<c:forEach var="yl" items="${regymList}" varStatus="idx">
						  <option value="${yl.regym }" ${parameter.toYm eq yl.regym ? 'selected="selected"' : '' }>${yl.regym }</option>
						</c:forEach>
					</select>
				</span>
			</div>

		</form>

		<div id="chart_data_div">
			<div class="sub_content_wrapper">
				<div id="tabs" class="tab_wrap" style="display: none;">
				  <ul>
				    <li><a href="#tabs-1">Chart</a></li>
				    <li><a href="#tabs-2">Data</a></li>
				  </ul>
			  		<div id="tabs-1">
					   <div id="chartdiv1" class="chart_box" align="left">FusionCharts. </div>
					</div>
					<div id="tabs-2">
						<div id="content_wrap" style="width: 794px;overflow: auto;">
							<span id="disp_txt"></span>
							<table id="dataTbl" class="list_tbl mgb_20" style="table-layout: fixed;">
								<thead>
									<tr>
										<th style="width: 300px;">Year-Month</th>
										<th style="width: 200px;">Click Count</th>
									</tr>
								</thead>
								<tbody>
									<c:if test="${not empty  regYmStatsList}">
									<c:forEach items="${regYmStatsList }" var="rl" varStatus="idx">
									<tr>
										<td style="text-align: center;">${rl.regym }</td>
										<td style="text-align: center;"><fmt:formatNumber value="${fn:trim(rl.clickCo)}" type="number" /></td>
									</tr>
									</c:forEach>
									</c:if>
									<c:if test="${empty  regYmStatsList}">
										<tr>
											<td colspan="2">No data to display</td>
										</tr>
									</c:if>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>

<form id="excelFrm" method="post" action="${contextPath}/jsp/excelExport.jsp">
      <input type="hidden" id="tableHTML" name="tableHTML" value="" />
      <input type="hidden" id="fileName" name="fileName" value="test.xls" />
      <!--
      <input type="button" onclick="gotoExcel('tableData', 'tableHTML');" value="Export these results" />
       -->
</form>
</body>
</html>
