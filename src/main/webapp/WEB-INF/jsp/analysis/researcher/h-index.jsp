<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><spring:message code="menu.asrms.rsch.hindex"/></title>
 <script type="text/javascript">
 $(document).ready(function(){
	 hindexAjax();
 });

 function hindexAjax(){
     if(!validateRange()){errorMsg(this); return false;}

     $.ajax({
         url:"<c:url value="/analysis/researcher/hindexAjax.do"/>",
         dataType: "json",
         data: $('#frm').serialize(),
         method: "POST",
         beforeLoad: $('.wrap-loading').css('display', '')

     }).done(function(data){

         if(FusionCharts('ChartId1')) {
             FusionCharts('ChartId1').dispose();
             $('#chartdiv1').disposeFusionCharts().empty();
         }

         var avgCitation;
         if(data.tot_no_arts == 0 || data.tot_no_arts == null || data.tot_citation == 0 || data.tot_citation == null){
             avgCitation = 0;
         }else{
             avgCitation = data.tot_citation / data.tot_no_arts;
		 }

         var $tbody = "";
		 var $tr = "<tr>";
		 $tr += '<td style="vertical-align: top;">';
		 $tr += '<p>&nbsp;■&nbsp;h-index :   '+data.hindex+'</p><br/>';
		 $tr += '<p>&nbsp;■&nbsp;Total Articles in Publication List : '+data.tot_no_arts.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+'</p><br/>';
		 $tr += '<p>&nbsp;■&nbsp;Articles With Citation Data : '+data.cited_no_arts.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+'</p><br/>';
		 $tr += '<p>&nbsp;■&nbsp;Sum of the Times Cited : '+data.tot_citation.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+'</p><br/>';
		 $tr += '<p>&nbsp;■&nbsp;Average Citations per Article : '+avgCitation.toFixed(2).replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+' </p>';
		 $tr += '</td>';
		 $tr += '<td>';
		 $tr += '<div align="right" class="chart_box">';
		 $tr += '<div id="chartdiv1" class="mgb_10">';
		 $tr += '</div>';
		 $tr += '</div>';
		 $tr += '<td>';
		 $tr += "</tr>";
		 $tbody += $tr;
         $("#hindexTbl tbody").html($tbody);


         new FusionCharts({
             id: 'ChartId1',
             type:'MSLine',
             renderAt:'chartdiv1',
             width:'490',
             height:'350',
             dataFormat:'xml',
             dataSource:data.chartXML+""
         }).render();

         $('#fromYear').data('prev', $('#fromYear').val());
         $('#toYear').data('prev', $('#toYear').val());

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
	 var pageTitle = $('<tr><td style="text-align:center;" colspan="5"><h1><p>Researcher(${item.korNm}) - '+$('.page_title').html()+'</p></h1></td></tr>');
     var chartTr = $('<tr><td><img src="'+fileName+'" height="480"/></td></tr>');
     var dataTbl = $('<tr><td colspan="5"><h1>Data</h1></td></tr><tr>'+$('#hindexTbl td').eq(0).clone().wrapAll('<div/>').parent().html().replace(/<p>/g,"").replace(/<\/p>/g,"")+'</tr>');

	 table.append(pageTitle)
     .append(chartTr)
     .append(dataTbl);
	 div.append(table);

	 $('#tableHTML').val(div.html());
	 var excelFileName = "H-index_"+$('#gubun').val() + "_from_" + $('#fromYear').val() +"_to_" + $('#toYear').val() + ".xls";
	 $('#fileName').val(excelFileName);
	 exportLog($('#frm'), excelFileName + "|" +  fileName);
     $('#excelFrm').submit();
 }
 </script>
</head>
<body>
	<h3 class="page_title"><spring:message code="menu.asrms.rsch.hindex"/></h3>
	<div class="help_text"><spring:message code="asrms.researcher.hindex.desc"/></div>

	<form id="frm" name="frm" method="post">
	<input type="hidden" id="topNm" name="topNm" value="<c:out value="${topNm}"/>"/>
	<input type="hidden" name="userId" id="userId" value="<c:out value="${parameter.userId}"/>"/>
	<input type="hidden" name="mode" id="mode" value="<c:out value="${parameter.mode}"/>"/>
	<input type="hidden" name="srchUserId" id="srchUserId" value="<c:out value="${parameter.srchUserId}"/>"/>
	<input type="hidden" name="srchUserPhotoUrl" id="srchUserPhotoUrl" value="<c:out value="${parameter.srchUserPhotoUrl}"/>"/>

	<div class="top_option_box">
		<div class="to_inner">
			<span><spring:message code="asrms.researcher.publications.classification" /></span>
			<em>
				<select name="gubun" id="gubun">
					<option value="SCI">SCI</option>
					<option value="SCOPUS">SCOPUS</option>
					<option value="KCI">KCI</option>
				</select>
			</em>
			<span><spring:message code="asrms.researcher.publications.yearrange" /></span>
			<em>
				<select name="fromYear" id="fromYear">
					<c:forEach var="yl" items="${pubYearList}" varStatus="idx" end="50">
						<option value="${yl.pubYear }" ${idx.last == true? 'selected="selected"' : '' }>${yl.pubYear }</option>
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
			<a href="javascript:hindexAjax();" class="to_search_bt"><span>Search</span></a>
		</p>
	</div>

	<table id="hindexTbl" class="mgb_10">
		<colgroup>
			<col style="width:40%" />
			<col style="width:60%" />
		</colgroup>
		<tbody></tbody>
	</table>
	<p class="bt_box mgb_10"><a href="#" onclick="exportExcel();" class="black_bt"><em class="export_icon">Export</em></a></p>
</form>
<form id="excelFrm" method="post" action="${contextPath}/jsp/excelExport.jsp">
      <input type="hidden" id="tableHTML" name="tableHTML" value="" />
      <input type="hidden" id="fileName" name="fileName" value="citation.xls" />
</form>
</body>
</html>
