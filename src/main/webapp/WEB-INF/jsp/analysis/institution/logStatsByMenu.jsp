<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ taglib prefix="fc" uri="/WEB-INF/tld/fusioncharts.tld"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Department Full Time SCI Average Citation </title>
<style type="text/css">
.tab_wrap ul li a{width: 120px;}
</style>
<%@ include file="../../pageInit.jsp" %>
<script type="text/javascript">
 var toggle = true;
 var fc = 0;
 var if_fc = 0;
 //var article_djArr = eval('('+ '${article_dataJson}'+')');
 //var citation_djArr = eval('('+ '${citation_dataJson}'+')');
 //var impact_djArr = eval('('+ '${impact_dataJson}'+')');
 var chart_ChartId1, chart_ChartId2, chart_ChartId3, chart_ChartId4, chart_ChartId5, chart_ChartId6;
 $(function() {
		$( "#tabs" ).tabs({
			active: '<c:out value="${sTabIdx}"/>',
		});
		$("#tabs").css("display", "block");
		//article_printDataTable();
		//citation_printDataTable();
		//impact_printDataTable();
	    //$('input:checkbox').bind('click', function(){ clickCheckbox($(this));});
		renderChart();
  });

 function renderChart(){

	   var chartWidth = "100%";
	   if(browserType() == "I") chartWidth = "748";

	   chart_ChartId1 =  new FusionCharts({
		 	  type:'column2d',
		 	  renderAt:'chartdiv1',
		 	  width:chartWidth,
		 	  height:'350',
		 	  dataFormat:'xml',
		 	  dataSource:"${chartXML}"
	   }).render();


	   /*chart_ChartId2 =  new FusionCharts({
		 	  type:'column2d',
		 	  renderAt:'chartdiv2',
		 	  width:chartWidth,
		 	  height:'350',
		 	  dataFormat:'xml',
		 	  dataSource:"${chartXML1}"
	   }).render();*/


	   chart_ChartId3 =  new FusionCharts({
		 	  type:'column2d',
		 	  renderAt:'chartdiv3',
		 	  width:chartWidth,
		 	  height:'350',
		 	  dataFormat:'xml',
		 	  dataSource:"${chartXML1}"
	   }).render();

	   chart_ChartId4 =  new FusionCharts({
		 	  type:'column2d',
		 	  renderAt:'chartdiv4',
		 	  width:chartWidth,
		 	  height:'350',
		 	  dataFormat:'xml',
		 	  dataSource:"${chartXML2}"
	   }).render();

	   chart_ChartId5 =  new FusionCharts({
		 	  type:'column2d',
		 	  renderAt:'chartdiv5',
		 	  width:chartWidth,
		 	  height:'350',
		 	  dataFormat:'xml',
		 	  dataSource:"${chartXML3}"
	   }).render();

	   chart_ChartId6 =  new FusionCharts({
		 	  type:'column2d',
		 	  renderAt:'chartdiv6',
		 	  width:chartWidth,
		 	  height:'350',
		 	  dataFormat:'xml',
		 	  dataSource:"${chartXML4}"
	   }).render();

 }


 var chartFileArr = new Array();
//Callback handler method which is invoked after the chart has saved image on server.
 function myFN_IF(objRtn){
 	if (objRtn.statusCode=="1"){
 		chartFileArr.push(objRtn.fileName);
 		if(chartFileArr.length == 3) saveExcel();
 		//alert("The chart was successfully saved on server. The file can be accessed from " + objRtn.fileName);
 	}else{
 		alert("The chart could not be saved on server. There was an error. Description : " + objRtn.statusMessage);
 	}
 }
 function myFN_TC(objRtn){
 	if (objRtn.statusCode=="1"){
 		chartFileArr.push(objRtn.fileName);
 		//if(chartFileArr.length == 2) saveExcel();
 		$("#tabs").tabs({active:2});

 		setTimeout(function() {
		 	var chartObject = getChartFromId('ChartId3');
		 	if( chartObject.hasRendered() ) chartObject.exportChart( { exportFormat : 'png'} );
 		}, 1000);

 		//alert("The chart was successfully saved on server. The file can be accessed from " + objRtn.fileName);
 	}else{
 		alert("The chart could not be saved on server. There was an error. Description : " + objRtn.statusMessage);
 	}
 }
 function myFN_ART(objRtn){
	 if (objRtn.statusCode=="1"){
 		chartFileArr.push(objRtn.fileName);
 		//if(chartFileArr.length == 2) saveExcel();
 		$("#tabs").tabs({active:1});

 		setTimeout(function() {
		 	var chartObject = getChartFromId('ChartId2');
		 	if( chartObject.hasRendered() ) chartObject.exportChart( { exportFormat : 'png'} );
 		}, 1000);

 		//alert("The chart was successfully saved on server. The file can be accessed from " + objRtn.fileName);
 	}else{
 		alert("The chart could not be saved on server. There was an error. Description : " + objRtn.statusMessage);
 	}
 }
 function exportExcel(){
	 $("#tabs").tabs({active:0});
	  setTimeout(function() {
		var chartObject2 = getChartFromId('ChartId1');
		if( chartObject2.hasRendered() ) chartObject2.exportChart( { exportFormat : 'png'} );
	  }, 1000);
 }
 function saveExcel(){

	 var div = $('<div></div>');
	 var table = $('<table></table>');
	 //append document title
	 var chartTitle = $('<tr><td style="text-align:center;"><h1><p>College(${item.codeDisp}) - '+$('.page_title').html()+'</p></h1></td></tr>');
	 table.append(chartTitle);
	 //append chart image & data
	 	//Article
	 var chart1Title = $('<tr><td></td></tr><tr><td><h3>전임교원 1인당 평균 논문수 Chart</h3></td></tr>');
	 var chart1Tr = $('<tr style="height:360px;"><td style="width:694px;height:360px;"><img src="'+chartFileArr[0]+'" style="width: 694px; height: 350px;"/></td></tr>');
	 var artDataTitle = $('<tr><td><h3>전임교원 1인당 평균 논문수 Data</h3></td></tr>');
	 table.append(chart1Title)
	      .append(chart1Tr)
	      .append(artDataTitle);


	 //make table with data of checked department
	 var artDataTbl = $('<table class="list_tbl mgb_20"></table>');
	 var artThead = $('#article_dataTbl > thead').clone();
	 artThead.find('tr th:first-child').remove();
	 artDataTbl.append(artThead.wrapAll('<div/>').parent().html());
	 var artTbody = $('<tbody></tbody>');
	 var chb = $('input[id^="article_chkbox_"]:checked');
	 for(var i=0; i < chb.length ; i++){
		 var id = chb.eq(i).val();
		 var artTr = $('#art_data_'+id).clone();
		 artTr.find('td:first-child').remove();
		 artTbody.append(artTr.wrapAll('<div/>').parent().html());
	 }
	 artDataTbl.append(artTbody);
	 table.append($('<tr><td>'+artDataTbl.wrapAll('<div/>').parent().html()+'</td></tr>'));

	 	//Citation
	 var chart2Title = $('<tr><td></td></tr><tr><td><h3>전임교원 1인당 평균 피인용횟수 Chart</h3></td></tr>');
	 var chart2Tr = $('<tr style="height:360px;"><td style="width:694px;height:360px;"><img src="'+chartFileArr[1]+'" style="width: 694px; height: 350px;"/></td></tr>');
	 var tcDataTitle = $('<tr><td><h3>전임교원 1인당 평균 피인용횟수 Data</h3></td></tr>');
	 table.append(chart2Title)
	      .append(chart2Tr)
	      .append(tcDataTitle);


	 //make table with data of checked department
	 var tcDataTbl = $('<table class="list_tbl mgb_20"></table>');
	 var tcThead = $('#citation_dataTbl > thead').clone();
	 tcThead.find('tr th:first-child').remove();
	 tcDataTbl.append(tcThead.wrapAll('<div/>').parent().html());
	 var tcTbody = $('<tbody></tbody>');
	     chb = $('input[id^="citation_chkbox_"]:checked');
	 for(var i=0; i < chb.length ; i++){
		 var id = chb.eq(i).val();
		 var tcTr = $('#tc_data_'+id).clone();
		 tcTr.find('td:first-child').remove();
		 tcTbody.append(tcTr.wrapAll('<div/>').parent().html());
	 }
	 tcDataTbl.append(tcTbody);
	 table.append($('<tr><td>'+tcDataTbl.wrapAll('<div/>').parent().html()+'</td></tr>'));

	 	//Impact Factor
	 var chart3Title = $('<tr><td></td></tr><tr><td><h3>전임교원 1인당 평균 Impact Factor Chart</h3></td></tr>');
	 var chart3Tr = $('<tr style="height:360px;"><td style="width:694px;height:360px;"><img src="'+chartFileArr[2]+'" style="width: 694px; height: 350px;"/></td></tr>');
	 var ifDataTitle = $('<tr><td><h3>전임교원 1인당 평균 Impact Factor Data</h3></td></tr>');
	 table.append(chart3Title)
	      .append(chart3Tr)
          .append(ifDataTitle);

	 //make table with data of checked department
	 var ifDataTbl = $('<table class="list_tbl mgb_20"></table>');
	 var ifThead = $('#impact_dataTbl > thead').clone();
	 ifThead.find('tr th:first-child').remove();
	 ifDataTbl.append(ifThead.wrapAll('<div/>').parent().html());
	 var ifTbody = $('<tbody></tbody>');
	     chb = $('input[id^="citation_chkbox_"]:checked');
	 for(var i=0; i < chb.length ; i++){
		 var id = chb.eq(i).val();
		 var ifTr = $('#if_data_'+id).clone();
		 ifTr.find('td:first-child').remove();
		 ifTbody.append(ifTr.wrapAll('<div/>').parent().html());
	 }
	 ifDataTbl.append(ifTbody);
	 table.append($('<tr><td>'+ifDataTbl.wrapAll('<div/>').parent().html()+'</td></tr>'));

	 div.append(table);
	 $('#tableHTML').val(div.html());

	 var excelFileName = "DepartmentFulltimeStats_"+$('#stnd').val() + "_from_" + $('#fromYear').val() +"_to_" + $('#toYear').val() + ".xls";
	 $('#fileName').val(excelFileName);
	 exportLog($('#frm'), excelFileName + "|" +  chartFileArr);
	 chartFileArr = new Array();
	 $('#excelFrm').submit();
 }
 </script>
</head>
<body>
	<h3 class="page_title">로그 분석 by Menu</h3>
	<%--<div class="help_text mgb_30"><spring:message code="asrms.institution.logStatsByMenu.desc"/></div>--%>

	<form id="frm" name="frm" action="${contextPath}/analysis/institution/logStatsByMenu.do" method="post">
	<input type="hidden" id="topNm" name="topNm" value="<c:out value="${topNm}"/>"/>
	<input type="hidden" name="sTabIdx" id="sTabIdx" value="${empty sTabIdx ? '0' : sTabIdx }"/>
	<input type="hidden" name="isStndChanged" id="isStndChanged" value="false"/>

		<div class="sub_top_box">

			<span class="select_text">접속유저</span>
			<span class="select_span">
				<select name="userId" id="userId" onchange="javascript:$('#frm').submit();">
					<option value="" ${empty parameter.userId ? 'selected="selected"' : '' }>전체</option>
					<c:forEach var="ul" items="${userList}" varStatus="idx">
					  <option value="${ul.userId }" ${parameter.userId eq ul.userId ? 'selected="selected"' : '' }>${ul.korNm }</option>
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

	<div id="tabs" class="tab_wrap" style="display: none;">
	  <ul>
	    <li><a href="#tabs-1">TopMenu</a></li>
	    <%--<li><a href="#tabs-2"><spring:message code="menu.asrms.about"/></a></li>--%>
	    <li><a href="#tabs-3"><spring:message code="menu.asrms.rsch"/></a></li>
	    <li><a href="#tabs-4"><spring:message code="menu.asrms.dept"/></a></li>
	    <li><a href="#tabs-5"><spring:message code="menu.asrms.clg"/></a></li>
	    <li><a href="#tabs-6"><spring:message code="menu.asrms.inst"/></a></li>
	  </ul>
		<div id="tabs-1">
			 <div id="chartdiv1" class="chart_box mgb_20" align="left">FusionCharts. </div>

			<h3 class="circle_h3">Data</h3>
			<div class="sub_content_wrapper" style="width: 100%;overflow: auto;">
				<table width="100%" id="topMenu_dataTbl" class="list_tbl mgb_20" style="table-layout: fixed;">
					<thead>
						<tr>
							<th><span>Menu</span></th>
							<th><span>Click Count</span></th>
						</tr>
					</thead>
					<tbody>
						<c:if test="${not empty  topMenuStats}">
						<c:forEach items="${topMenuStats }" var="ts" varStatus="idx">
						<tr>
							<td style="text-align: center;">${ts.menuNm }</td>
							<td style="text-align: center;"><fmt:formatNumber value="${fn:trim(ts.clickCo)}" type="number" /></td>
						</tr>
						</c:forEach>
						</c:if>
						<c:if test="${empty  topMenuStats}">
							<tr>
								<td colspan="2">No data to display</td>
							</tr>
						</c:if>
					</tbody>
				</table>
			</div>
			<!--END sub_content_wrapper-->
		</div>

		<%--<div id="tabs-2">
		   <div id="chartdiv2" class="chart_box mgb_20" align="left">FusionCharts. </div>

			<h3 class="circle_h3">Data</h3>

			<div class="sub_content_wrapper" style="width: 100%;overflow: auto;">
				<table width="100%" id="homeMenu_dataTbl" class="list_tbl mgb_20" style="table-layout: fixed;">
					<thead>
						<tr>
							<th><span>Menu</span></th>
							<th><span>Click Count</span></th>
						</tr>
					</thead>
					<tbody>
						<c:if test="${not empty  homeStats}">
						<c:forEach items="${homeStats }" var="hs" varStatus="idx">
						<tr>
							<td style="text-align: center;">${hs.menuNm }</td>
							<td style="text-align: center;"><fmt:formatNumber value="${fn:trim(hs.clickCo)}" type="number" /></td>
						</tr>
						</c:forEach>
						</c:if>
						<c:if test="${empty  homeStats}">
							<tr>
								<td colspan="2">No data to display</td>
							</tr>
						</c:if>
					</tbody>
				</table>
			</div>
			<!--END sub_content_wrapper-->
		</div>--%>

		<div id="tabs-3">
		   <div id="chartdiv3" class="chart_box mgb_20" align="left">FusionCharts. </div>

			<h3 class="circle_h3">Data</h3>

			<div class="sub_content_wrapper" style="width: 100%;overflow: auto;">
				<table width="100%" id="researcherMenu_dataTbl" class="list_tbl mgb_20" style="table-layout: fixed;">
					<thead>
						<tr>
							<th><span>Menu</span></th>
							<th><span>Click Count</span></th>
						</tr>
					</thead>
					<tbody>
						<c:if test="${not empty  researcherStats}">
						<c:forEach items="${researcherStats }" var="rs" varStatus="idx">
						<tr>
							<td style="text-align: center;">${rs.menuNm }</td>
							<td style="text-align: center;"><fmt:formatNumber value="${fn:trim(rs.clickCo)}" type="number" /></td>
						</tr>
						</c:forEach>
						</c:if>
						<c:if test="${empty  researcherStats}">
							<tr>
								<td colspan="2">No data to display</td>
							</tr>
						</c:if>
					</tbody>
				</table>
			</div>
			<!--END sub_content_wrapper-->
		</div>

		<div id="tabs-4">
		   <div id="chartdiv4" class="chart_box mgb_20" align="left">FusionCharts. </div>

			<h3 class="circle_h3">Data</h3>

			<!--START sub_content_wrapper-->
			<div class="sub_content_wrapper" style="width: 100%;overflow: auto;">
				<table width="100%" id="departmentMenu_dataTbl" class="list_tbl mgb_20" style="table-layout: fixed;">
					<thead>
						<tr>
							<th><span>Menu</span></th>
							<th><span>Click Count</span></th>
						</tr>
					</thead>
					<tbody>
						<c:if test="${not empty  departmentStats}">
						<c:forEach items="${departmentStats }" var="ds" varStatus="idx">
						<tr>
							<td style="text-align: center;">${ds.menuNm }</td>
							<td style="text-align: center;"><fmt:formatNumber value="${fn:trim(ds.clickCo)}" type="number" /></td>
						</tr>
						</c:forEach>
						</c:if>
						<c:if test="${empty  departmentStats}">
							<tr>
								<td colspan="2">No data to display</td>
							</tr>
						</c:if>
					</tbody>
				</table>
			</div>
			<!--END sub_content_wrapper-->
		</div>

		<div id="tabs-5">
		   <div id="chartdiv5" class="chart_box mgb_20" align="left">FusionCharts. </div>

			<h3 class="circle_h3">Data</h3>

			<div class="sub_content_wrapper" style="width: 100%;overflow: auto;">
				<table width="100%" id="collegeMenu_dataTbl" class="list_tbl mgb_20" style="table-layout: fixed;">
					<thead>
						<tr>
							<th><span>Menu</span></th>
							<th><span>Click Count</span></th>
						</tr>
					</thead>
					<tbody>
						<c:if test="${not empty  collegeStats}">
						<c:forEach items="${collegeStats }" var="cs" varStatus="idx">
						<tr>
							<td style="text-align: center;">${cs.menuNm }</td>
							<td style="text-align: center;"><fmt:formatNumber value="${fn:trim(cs.clickCo)}" type="number" /></td>
						</tr>
						</c:forEach>
						</c:if>
						<c:if test="${empty  collegeStats}">
							<tr>
								<td colspan="2">No data to display</td>
							</tr>
						</c:if>
					</tbody>
				</table>
			</div>
		</div>

		<div id="tabs-6">
		   <div id="chartdiv6" class="chart_box mgb_20" align="left">FusionCharts. </div>

			<h3 class="circle_h3">Data</h3>

			<!--START sub_content_wrapper-->
			<div class="sub_content_wrapper" style="width: 100%;overflow: auto;">
				<table width="100%" id="institutionMenu_dataTbl" class="list_tbl mgb_20" style="table-layout: fixed;">
					<thead>
						<tr>
							<th><span>Menu</span></th>
							<th><span>Click Count</span></th>
						</tr>
					</thead>
					<tbody>
						<c:if test="${not empty  institutionStats}">
						<c:forEach items="${institutionStats }" var="is" varStatus="idx">
						<tr>
							<td style="text-align: center;">${is.menuNm }</td>
							<td style="text-align: center;"><fmt:formatNumber value="${fn:trim(is.clickCo)}" type="number" /></td>
						</tr>
						</c:forEach>
						</c:if>
						<c:if test="${empty  institutionStats}">
							<tr>
								<td colspan="2">No data to display</td>
							</tr>
						</c:if>
					</tbody>
				</table>
			</div>
			<!--END sub_content_wrapper-->
		</div>
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
