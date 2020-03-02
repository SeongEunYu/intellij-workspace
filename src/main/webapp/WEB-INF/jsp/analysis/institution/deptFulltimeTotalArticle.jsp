<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Department Indicator Compare</title>
<script type="text/javascript">
 var toggle = true;
 var fc = 0;
 var if_fc = 0;
 $(function() {
	$( "#tabs" ).tabs({});
	$("#tabs").css("display", "block");

     deptFulltimeArticleAjax();
  });

 var chartFileArr = new Array();

 
 function deptFulltimeArticleAjax(){

     $.ajax({
         url:"<c:url value="/analysis/institution/deptFulltimeArticleAjax.do"/>",
         dataType: "json",
         data: $('#frm').serialize(),
         method: "POST",
         beforeLoad: $('.wrap-loading').css('display', '')

     }).done(function(data){

         if(FusionCharts('ChartId1')) {
             FusionCharts('ChartId1').dispose();
             $('#chartdiv1').disposeFusionCharts().empty();
         }
         if(FusionCharts('ChartId2')) {
             FusionCharts('ChartId2').dispose();
             $('#chartdiv2').disposeFusionCharts().empty();
         }
         if(FusionCharts('ChartId3')) {
             FusionCharts('ChartId3').dispose();
             $('#chartdiv3').disposeFusionCharts().empty();
         }
         if(FusionCharts('ChartId4')) {
             FusionCharts('ChartId4').dispose();
             $('#chartdiv4').disposeFusionCharts().empty();
         }

         new FusionCharts({
             id: 'ChartId1',
             type:'Column2D',
             renderAt:'chartdiv1',
             width:'100%',
             height:'350',
             dataFormat:'xml',
             dataSource:data.chartXML1+""
         }).render();

         new FusionCharts({
             id: 'ChartId2',
             type:'Column2D',
             renderAt:'chartdiv2',
             width:'100%',
             height:'350',
             dataFormat:'xml',
             dataSource:data.chartXML2+""
         }).render();

         new FusionCharts({
             id: 'ChartId3',
             type:'Column2D',
             renderAt:'chartdiv3',
             width:'100%',
             height:'350',
             dataFormat:'xml',
             dataSource:data.chartXML3+""
         }).render();

         new FusionCharts({
             id: 'ChartId4',
             type:'Column2D',
             renderAt:'chartdiv4',
             width:'100%',
             height:'350',
             dataFormat:'xml',
             dataSource:data.chartXML4+""
         }).render();


         if(data.fulltimeArticleSelectedYearList.length > 0){
             var $tbody = "";

             for(var j=0; j < data.fulltimeArticleSelectedYearList.length; j++){
                 var fl = data.fulltimeArticleSelectedYearList[j];

                 var $tr = '<tr style="height:17px;">';
                 $tr += '<td style="padding-left: 10px;">'+fl.deptKor+'</td>';
                 $tr += '<td class="center">'+fl.pubYear+'</td>';
                 $tr += '<td class="center">'+fl.intrlJnalArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+'</td>';
                 $tr += '<td class="center">'+fl.intrlGnalArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+'</td>';
                 $tr += '<td class="center">'+fl.dmstcKciArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+'</td>';
                 $tr += '<td class="center">'+fl.dmstcGnalArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+'</td>';
                 $tr += '<td class="center">'+fl.artsTotal.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+'</td>';
                 $tr += '</tr>';

                 $tbody += $tr;
             }
         }else{
             var $tr = "<tr>";
             $tr += '<td colspan="99" style="padding-left:5px;"><img src="${contextPath}/images/layout/ico_info.png" /> 검색된 Data가 없습니다.</td></tr>';
             $tbody += $tr;
         }

         $("#publicationsTbl tbody").html($tbody);

         $('.wrap-loading').css('display', 'none');
     });
 }
 
 function exportExcel(){
	 $("#tabs").tabs({active:0});
	  setTimeout(function() {
		var chartObject2 = getChartFromId('ChartId1');
		if( chartObject2.hasRendered() ) chartObject2.exportChart( { exportFormat : 'png'} );
	  }, 1000);
 }

 function myFN_SCI(objRtn){
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
 function myFN_INT(objRtn){
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
 function myFN_KCI(objRtn){
	 if (objRtn.statusCode=="1"){
 		chartFileArr.push(objRtn.fileName);
 		//if(chartFileArr.length == 2) saveExcel();
 		$("#tabs").tabs({active:3});

 		setTimeout(function() {
		 	var chartObject = getChartFromId('ChartId4');
		 	if( chartObject.hasRendered() ) chartObject.exportChart( { exportFormat : 'png'} );
 		}, 1000);

 		//alert("The chart was successfully saved on server. The file can be accessed from " + objRtn.fileName);
 	}else{
 		alert("The chart could not be saved on server. There was an error. Description : " + objRtn.statusMessage);
 	}
 }

 function myFN_NAT(objRtn){
	 	if (objRtn.statusCode=="1"){
	 		chartFileArr.push(objRtn.fileName);
	 		if(chartFileArr.length == 4) saveExcel();
	 		//alert("The chart was successfully saved on server. The file can be accessed from " + objRtn.fileName);
	 	}else{
	 		alert("The chart could not be saved on server. There was an error. Description : " + objRtn.statusMessage);
	 	}
}

 function saveExcel(fileName){

	 var div = $('<div></div>');
	 var table = $('<table></table>');
	 //append document title
	 var chartTitle = $('<tr><td style="text-align:center;"><h1><p>Institution - '+$('.page_title').html()+'</p></h1></td></tr>');
	 //append chart image
	 var chart1Tr = $('<tr><td style="height:340px;"><img src="'+chartFileArr[0]+'" height="350"/></td></tr>');
	 var chart2Tr = $('<tr><td style="height:340px;"><img src="'+chartFileArr[1]+'" height="350"/></td></tr>');
	 var chart3Tr = $('<tr><td style="height:340px;"><img src="'+chartFileArr[2]+'" height="350"/></td></tr>');
	 var chart4Tr = $('<tr><td style="height:340px;"><img src="'+chartFileArr[3]+'" height="350"/></td></tr>');
	 var dataTbl = $('<tr><td><h1>Chart Data</h1></td></tr><tr><td>'+$('#publicationsTbl').clone().wrapAll('<div/>').parent().html()+'</td></tr>');
	 table.append(chartTitle)
	      .append(chart1Tr)
	      .append(chart2Tr)
	      .append(chart3Tr)
	      .append(chart4Tr)
	      .append(dataTbl);
	 //make table with data of checked researcher
	 div.append(table);
	 $('#tableHTML').val(div.html());
	 var excelFileName = "CollegeFulltimeArticle_"+$('#stndMonthDay').val() + "_selectYear_" + $('#selectYear').val() + ".xls";
	 $('#fileName').val(excelFileName);
	 exportLog($('#frm'), excelFileName + "|" +  chartFileArr);
	 chartFileArr = new Array();
	 $('#excelFrm').submit();
 }
 </script>
</head>
<body>
	<h3 class="page_title"><spring:message code="menu.asrms.inst.deptFulltimeArticle"/></h3>
	<div class="help_text mgb_30"><spring:message code="asrms.institution.fulltime.article.desc"/></div>

	<form id="frm" name="frm">
	<input type="hidden" id="topNm" name="topNm" value="<c:out value="${topNm}"/>"/>
	<input type="hidden" name="isStndChanged" id="isStndChanged" value="false"/>

		<div class="top_option_box">
			<div class="to_inner">
				<span>실적구분</span>
				<em>
					<select name="insttRsltAt" id="insttRsltAt">
						<option value="ALL">전체</option>
						<option value="Y">${sysConf['inst.abrv']}</option>
						<option value="N">타기관</option>
					</select>
				</em>
				<span>기준연도</span>
				<em>
					<select name="selectedYear" id="selectedYear">
						<c:forEach items="${stndYearList}" var="stndY" varStatus="stats">
							<option value="<c:out value="${stndY.stndYear}"/>" ${stats.index == 1 ? 'selected="selected"' : ''}><c:out value="${stndY.stndYear}"/></option>
						</c:forEach>
					</select>
				</em>
				<span>기준일자</span>
				<em>
					<select name="stndMonthDay" id="stndMonthDay" onchange="javascript: $('#isStndChanged').val('true');">
						<c:forEach items="${stndMonthDayList}" var="stndMD" varStatus="stats">
							<option value="<c:out value="${stndMD.stndMonth}"/>-<c:out value="${stndMD.stndDay}"/>" ${stats.last == true ? 'selected="selected"' : ''}><c:out value="${stndMD.stndMonth}"/>월 <c:out value="${stndMD.stndDay}"/>일</option>
						</c:forEach>
					</select>
				</em>
			</div>
			<p class="ts_bt_box">
				<a href="javascript:deptFulltimeArticleAjax();" class="to_search_bt"><span>Search</span></a>
			</p>
		</div>

  		<h3 class="circle_h3">Chart</h3>

		<div class="sub_content_wrapper">
			<div id="tabs" class="tab_wrap" style="display: none;">
			  <ul>
			    <li><a href="#tabs-1">SCI급</a></li>
			    <li><a href="#tabs-2">국제일반</a></li>
			    <li><a href="#tabs-3">국내KCI급</a></li>
			    <li><a href="#tabs-4">국내일반</a></li>
			  </ul>
				<div id="tabs-1">
					<div id="chartdiv1" class="chart_box"></div>
				</div>
				<div id="tabs-2">
					<div id="chartdiv2" class="chart_box"></div>
				</div>
				<div id="tabs-3">
					<div id="chartdiv3" class="chart_box"></div>
				</div>
				<div id="tabs-4">
					<div id="chartdiv4" class="chart_box"></div>
				</div>
			</div>
		</div>

		<p class="bt_box mgb_30"><a href="#" onclick="exportExcel();" class="black_bt"><em class="export_icon">Export</em></a></p>

		<h3 class="circle_h3">Data</h3>

		<div class="sub_content_wrapper">
			<table width="100%" id="publicationsTbl" class="list_tbl mgb_20">
				<colgroup>
					<col style="width: 18%;"/>
					<col style="width: 7%"/>
					<col style="width: 12%"/>
					<col style="width: 12%"/>
					<col style="width: 12%"/>
					<col style="width: 11%"/>
					<col style="width: 10%"/>
				</colgroup>
				<thead>
					<tr style="text-align: center;height:25px">
						<th><span>학(부)과명</span></th>
						<th><span>Year</span></th>
						<th><span>SCI급 논문 <br/>(SCI+SCOPUS)</span></th>
						<th><span>국제일반</span></th>
						<th><span>국내KCI급 논문</span></th>
						<th><span>국내일반</span></th>
						<th><span>합계</span></th>
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
