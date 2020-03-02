<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><spring:message code="menu.asrms.rsch.artco"/></title>
<script>
$(document).ready(function(){
	publicationAjax();
});

function publicationAjax(){
    if(!validateRange()){errorMsg(this); return false;}

	$.ajax({
		url:"<c:url value="/analysis/researcher/publicationAjax.do"/>",
		dataType: "json",
		data: $('#frm').serialize(),
		method: "POST",
		beforeLoad: $('.wrap-loading').css('display', '')

	}).done(function(data){

        if(FusionCharts('pubChart')) {
            FusionCharts('pubChart').dispose();
            $('#chartdiv1').disposeFusionCharts().empty();
        }

        new FusionCharts({
            id: 'pubChart',
            type:'MSLine',
            renderAt:'chartdiv1',
            width:'100%',
            height:'350',
            dataFormat:'xml',
            dataSource:data.chartXML1+""
        }).render();

        $('#list_title').text('Publication');
        $('#publicationsTbl > tbody').empty();

        makeArticleList(data.articleList);

		$('#fromYear').data('prev', $('#fromYear').val());
		$('#toYear').data('prev', $('#toYear').val());

		$('.wrap-loading').css('display', 'none');
	});
}

function chartClick(args){
 var param = args.split(";");
 var year = param[0];
 var gubun = param[1];
 $('#list_title').text('Publication ( '+year+' - '+gubun+' )');
 $('#publicationsTbl > tbody').empty();
 $.ajax({
	 url : "${contextPath}/analysis/researcher/findArticleListByUserIdAjax.do",
	 dataType : 'json',
	 data : { "selectedYear":year,
			  "userId": $('#userId').val(),
			  "fromYear": $('#fromYear').val(),
			  "toYear": $('#toYear').val(),
			  "gubun" : gubun,
			  "page"  : 'publication',
			  "topNm" : '${parameter.topNm}'
			 },
	 success : function(data, textStatus, jqXHR){
         makeArticleList(data);
	 }
 }).done(function(){});

 //$('#selectedYear').val(year);
 //publicationAjax();

 }

 function makeArticleList(data){
     var thHtml = $('#excelExportDiv > table > tbody > tr').eq(0).html();
     $('#excelExportDiv').empty();
     $('#excelExportDiv').append($('<table class="list_tbl mgb_20"><tr>'+thHtml+'</tr></table>'));
     for(var i=0; i < data.length; i++){

         var seqno = data[i].articleId;
         var esubject = data[i].orgLangPprNm == null ? '' : data[i].orgLangPprNm;
         var authors = data[i].authors == null ? '' : data[i].authors;
         var publisher = data[i].pblcPlcNm == null ? '' : data[i].pblcPlcNm;
         var magazine = data[i].scjnlNm == null ? '' : data[i].scjnlNm;
         var vol = data[i].volume == null ? '' : 'v.' + data[i].volume;
         var no = data[i].issue == null ? '' : 'no.' + data[i].issue;
         var strpage = data[i].sttPage == null ? '' : data[i].sttPage;
         var endpage = data[i].endPage == null ? '' : data[i].endPage;
         var issueDate = data[i].pblcYm == null ? '' : dateFormat(data[i].pblcYm);
         var impctFctr = data[i].impctFctr == null ? '' : data[i].impctFctr;
         var sciTc = data[i].tc == null ? '' : data[i].tc;
         var scpTc = data[i].scpTc == null ? '' : data[i].scpTc;
         var kciTc = data[i].kciTc == null ? '' : data[i].kciTc;

         var $tr = $('<tr style="height:17px;"></tr>');
         $tr.append($('<td style="font-size: 10pt;" align="center" width="40">'+(i+1)+'</td>'));
         var $td = $('<td class="link_td" align="left"></td>').append($('<div class="style_12pt"><a href="javascript:popArticle('+seqno+')"><b>'+esubject+'</b></a></div>'));
         //var content = '<b>Journal</b>: '+magazine+' [v.'+vol+',&nbsp;no.'+no+',&nbsp; pp.'+strpage+'~'+endpage+',&nbsp;'+issueDate+']';
         var content = '<span>'+authors + '&nbsp;('+publisher+',&nbsp;' + magazine+',&nbsp;'+vol+',&nbsp;'+no+',&nbsp; pp.'+strpage+'~'+endpage+',&nbsp;'+issueDate+')</span>';
         $td.append(content);
         $tr.append($td);
         $('#publicationsTbl > tbody').append($tr);

         //create table for excel export
         var eTr = $('<tr style="height:100%;"></tr>');
         eTr.append($('<td style="text-align:center;font-size: 10pt;" width="40">'+(i+1)+'</td>'));
         eTr.append($('<td style="text-align:left;font: normal 12px \'Malgun Gothic\';"><b>'+esubject+'</b></td>'));
         eTr.append($('<td style="text-align:left;font: normal 12px \'Malgun Gothic\';">'+authors+'</td>'));
         eTr.append($('<td style="text-align:left;font: normal 12px \'Malgun Gothic\';">'+publisher+'</td>'));
         eTr.append($('<td style="text-align:left;font: normal 12px \'Malgun Gothic\';">'+magazine+'</td>'));
         eTr.append($('<td style="text-align:left;font: normal 12px \'Malgun Gothic\';">'+vol+'</td>'));
         eTr.append($('<td style="text-align:left;font: normal 12px \'Malgun Gothic\';">'+no+'</td>'));
         eTr.append($('<td style="text-align:left;font: normal 12px \'Malgun Gothic\';">'+strpage+'</td>'));
         eTr.append($('<td style="text-align:left;font: normal 12px \'Malgun Gothic\';">'+endpage+'</td>'));
         eTr.append($('<td style="text-align:center;font: normal 12px \'Malgun Gothic\';">'+impctFctr+'</td>'));
         eTr.append($('<td style="text-align:center;font: normal 12px \'Malgun Gothic\';">'+sciTc+'</td>'));
         eTr.append($('<td style="text-align:center;font: normal 12px \'Malgun Gothic\';">'+scpTc+'</td>'));
         eTr.append($('<td style="text-align:center;font: normal 12px \'Malgun Gothic\';">'+kciTc+'</td>'));
         eTr.append($('<td style="text-align:left; font: normal 12px \'Malgun Gothic\';">'+issueDate+'</td>'));
         $('#excelExportDiv > table').append(eTr);
     }
     if(data.length == 0){
         var $tr = "<tr style='background-color: #ffffff;' height='17px'>";
         $tr += '<td colspan=99><img src="${contextPath}/images/layout/ico_info.png" /> There is no Article.</td></tr>';
         $('#publicationsTbl > tbody').append($tr);
	 }
     //alert(data[0].ESUBJECT);
 }

 function gotoExcel(elemId, frmFldId)
 {
     $('#'+frmFldId).val($('#excelExportDiv').html());
     $('#excelFrm').submit();
 }

 function FC_ExportReady(DOMId){
     alert("The chart with DOM ID as " + DOMId + " has finished capture mode. It's now ready to be downloaded");
 }

//Callback handler method which is invoked after the chart has saved image on server.
 function myFN(objRtn){
 	if (objRtn.statusCode=="1"){
 		//console.log(objRtn.fileName);
 		saveExcel(objRtn.fileName);
 		//alert("The chart was successfully saved on server. The file can be accessed from " + objRtn.fileName);
 	}else{
 		alert("The chart could not be saved on server. There was an error. Description : " + objRtn.statusMessage);
 	}
 }

 function exportExcel(){
	 var chartObject = getChartFromId('pubChart');
	 if( chartObject.hasRendered() ) chartObject.exportChart( { exportFormat : 'png'} );
 }
 function saveExcel(fileName){
	 var div = $('<div></div>');
	 var table = $('<table></table>');
	 //append document title
	 var pageTitle = $('<tr><td style="text-align:center;" colspan="7"><h1><p>Researcher(${item.korNm}) - '+$('.page_title').html()+'</p></h1></td></tr>');
	 //append chart image
	 var dataTbl = $('<tr><td colspan="5"><h1>Data</h1></td></tr><tr><td>'+$('#excelExportDiv > table').clone().wrapAll('<div/>').parent().html()+'</td></tr>');
	 var chartTr = $('<tr><td><img src="'+fileName+'" height="350" /></td></tr>');
	 table.append(pageTitle)
     .append(chartTr)
     .append(dataTbl);
	 div.append(table);
	 $('#tableHTML').val(div.html());
	 var excelFileName = "Publications_"+$('#gubun').val() + "_from_" + $('#fromYear').val() +"_to_" + $('#toYear').val() + ".xls";
	 $('#fileName').val(excelFileName);
	 exportLog($('#frm'), excelFileName + "|" +  fileName);
     $('#excelFrm').submit();
 }
  </script>
</head>
<body>
<h3 class="page_title"><spring:message code="menu.asrms.rsch.artco"/></h3>
<div class="help_text"><spring:message code="asrms.researcher.publications.desc" /></div>

<form id="frm" name="frm">
<input type="hidden" id="topNm" name="topNm" value="<c:out value="${topNm}"/>"/>
<input type="hidden" name="userId" id="userId" value="<c:out value="${parameter.userId}"/>"/>
<input type="hidden" name="mode" id="mode" value="<c:out value="${parameter.mode}"/>"/>
<input type="hidden" name="srchUserId" id="srchUserId" value="<c:out value="${parameter.srchUserId}"/>"/>
<input type="hidden" name="srchUserPhotoUrl" id="srchUserPhotoUrl" value="<c:out value="${srchUserPhotoUrl}"/>"/>

<div class="top_option_box">
	<div class="to_inner">
		<span><spring:message code="asrms.researcher.publications.classification" /></span>
		<em>
			<select name="gubun" id="gubun">
				<option value="ALL">전체</option>
				<option value="SCI">SCI</option>
				<option value="SCOPUS">SCOPUS</option>
				<option value="KCI">KCI</option>
			</select>
		</em>
		<span><spring:message code="asrms.researcher.publications.yearrange" /></span>
		<em>
			<select name="fromYear" id="fromYear">
				<c:forEach var="yl" items="${pubYearList}" varStatus="idx" end="50">
					<c:choose>
						<c:when test="${fn:length(pubYearList) > 5}">
							<option value="${yl.pubYear }" ${idx.index == 5 ? 'selected="selected"' : '' }>${yl.pubYear }</option>
						</c:when>
						<c:otherwise>
							<option value="${yl.pubYear }" ${idx.last == true? 'selected="selected"' : '' }>${yl.pubYear }</option>
						</c:otherwise>
					</c:choose>
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
		<a href="javascript:publicationAjax();" class="to_search_bt"><span>Search</span></a>
	</p>
</div>

<h3 class="circle_h3">Chart</h3>

<div id="chartdiv1" class="chart_box mgb_10"></div>

<p class="bt_box mgb_10"><a href="#" onclick="exportExcel();" class="black_bt"><em class="export_icon">Export</em></a></p>

<h3 class="circle_h3" id="list_title">Publication</h3>
<table width="100%" id="publicationsTbl" class="list_tbl mgb_20">
	<colgroup>
		<col style="width: 9%"/>
		<col style="width: 91%"/>
	</colgroup>
	<thead>
	<tr>
		<th><span>NO</span></th>
		<th><span>Article</span></th>
	</tr>
	</thead>
	<tbody></tbody>
</table>

</form>

<form id="excelFrm" method="post" action="${contextPath}/jsp/excelExport.jsp">
	<input type="hidden" id="tableHTML" name="tableHTML" value="" />
	<input type="hidden" id="fileName" name="fileName" value="publication.xls" />
	<div style="display: none;" id="excelExportDiv">
		<table class="list_tbl mgb_20">
			<thead>
			<tr>
				<th><span>No</span></th>
				<th><span>Title</span></th>
				<th><span>Authors</span></th>
				<th><span>Publisher</span></th>
				<th><span>Journal</span></th>
				<th><span>Volume</span></th>
				<th><span>Issue</span></th>
				<th><span>StartPage</span></th>
				<th><span>EndPage</span></th>
				<th><span>Imapct Factor</span></th>
				<th><span>TC(SCI)</span></th>
				<th><span>TC(SCOPUS)</span></th>
				<th><span>TC(KCI)</span></th>
				<th><span>IssueDate</span></th>
			</tr>
			</thead>
			<tbody></tbody>
		</table>
	</div>
</form>
<div id="exportDiv" style="display: none;"></div>
</body>
</html>
