<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Top Researchers By Publications</title>
<script>
 function popArticle(seqno) {
		var url = "${contextPath}/jsp/viewDetail.jsp?seqno="+seqno;
		var PopUP = window.open(url, "detail", "width=670,height=700,directories=no,status=no,toolbar=no,menubar=no,scrollbars=yes,resizable=yes");
 }
 function chartClick(year, gubun){
	 //alert("chartClick event execute !!" + year);
	 $('#publicationsTbl').empty();
	 //loading publication list of year by ajax

	 $.ajax({
		 url : "${contextPath}/researcher/getArtListAjax.do",
		 dataType : 'json',
		 data : { "selectedYear":year,
			      "userid": $('#userid').val(),
			      "fromYear": $('#fromYear').val(),
			      "toYear": $('#toYear').val(),
			      "gubun" : gubun
			     },
		 success : function(data, textStatus, jqXHR){

			 var thHtml = $('#excelExportDiv > table > tbody > tr').eq(0).html();
			 $('#excelExportDiv').empty();
			 $('#excelExportDiv').append($('<table><tr>'+thHtml+'</tr></table>'));
			 for(var i=0; i < data.length; i++){

				 var seqno = data[i].articleId;
				 var esubject = data[i].orgLangPprNm == null ? '' : data[i].orgLangPprNm;
			     var authors = data[i].authors == null ? '' : data[i].authors;
			     var publisher = data[i].pblcPlcNm == null ? '' : data[i].pblcPlcNm;
				 var magazine = data[i].scjnlNm == null ? '' : data[i].scjnlNm;
			     var vol = data[i].volume == null ? '' : data[i].volume;
			     var no = data[i].issue == null ? '' : data[i].issue
				 var strpage = data[i].sttPage == null ? '' : data[i].sttPage;
			     var endpage = data[i].endPage == null ? '' : data[i].endPage;
			     var issueDate = data[i].pblcYm == null ? '' : dateFormat(data[i].pblcYm);
			     var impctFctr = data[i].impctFctr == null ? '' : data[i].impctFctr;
			     var sciTc = data[i].tc == null ? '' : data[i].tc;
			     var scpTc = data[i].scpTc == null ? '' : data[i].scpTc;

				 var className =  (i+1) % 2 == 1 ? "" : "par";
				 var $tr = $('<tr style="height:17px;" class="'+className+'"></tr>');
				 $tr.append($('<td style="font-size: 10pt;" align="center" width="40">'+(i+1)+'</td>'));
				 var $td = $('<td class="link_td" style="font: normal 12px \'Malgun Gothic\';"></td>').append($('<a href="javascript:popArticle('+seqno+')"><b>'+esubject+'</b></a>'));
				 //var content = '<b>Journal</b>: '+magazine+' [v.'+vol+',&nbsp;no.'+no+',&nbsp; pp.'+strpage+'~'+endpage+',&nbsp;'+issueDate+']';
				 var content = '&nbsp;/ '+authors + '&nbsp;('+publisher+',&nbsp;' + magazine+',&nbsp;v.'+vol+',&nbsp;no.'+no+',&nbsp; pp.'+strpage+'~'+endpage+',&nbsp;'+issueDate+')';
				 $td.append(content);
				 $tr.append($td);
				 $('#publicationsTbl').append($tr);

				 //create table for excel export
				 var eTr = $('<tr style="height:17px;" class="'+className+'"></tr>');
				 eTr.append($('<td style="font-size: 10pt;" align="center" width="40">'+(i+1)+'</td>'));
				 eTr.append($('<td align="left" style="font: normal 12px \'Malgun Gothic\';"><b>'+esubject+'</b></td>'));
				 eTr.append($('<td align="left" style="font: normal 12px \'Malgun Gothic\';">'+authors+'</td>'));
				 eTr.append($('<td align="left" style="font: normal 12px \'Malgun Gothic\';">'+publisher+'</td>'));
				 eTr.append($('<td align="left" style="font: normal 12px \'Malgun Gothic\';">'+magazine+'</td>'));
				 eTr.append($('<td align="left" style="font: normal 12px \'Malgun Gothic\';">v.'+vol+'</td>'));
				 eTr.append($('<td align="left" style="font: normal 12px \'Malgun Gothic\';">no.'+no+'</td>'));
				 eTr.append($('<td align="left" style="font: normal 12px \'Malgun Gothic\';">'+strpage+'</td>'));
				 eTr.append($('<td align="left" style="font: normal 12px \'Malgun Gothic\';">'+endpage+'</td>'));
				 eTr.append($('<td align="right" style="font: normal 12px \'Malgun Gothic\';">'+sciTc+'</td>'));
				 eTr.append($('<td align="right" style="font: normal 12px \'Malgun Gothic\';">'+scpTc+'</td>'));
				 eTr.append($('<td align="left" style="font: normal 12px \'Malgun Gothic\';">'+issueDate+'</td>'));
				 $('#excelExportDiv > table').append(eTr);
			 }

			//alert(data[0].ESUBJECT);
		 }
	 }).done(function(){});



	 //$('#selectedYear').val(year);
	 //$('#frm').submit();

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
 		saveExcel(objRtn.fileName);
 		//alert("The chart was successfully saved on server. The file can be accessed from " + objRtn.fileName);
 	}else{
 		alert("The chart could not be saved on server. There was an error. Description : " + objRtn.statusMessage);
 	}
 }

 $(document).ready(function(){
	 var myExportComponent = new FusionChartsExportObject("fcExporter1", "${contextPath}/Charts/flash/FusionCharts/FCExporter.swf");
	 $('#fromYear').data('prev', $('#fromYear').val());
	 $('#toYear').data('prev', $('#toYear').val());
 });

 function exportExcel(){

	 var chartObject = getChartFromId('ChartId1');

	 if( chartObject.hasRendered() ) chartObject.exportChart( { exportFormat : 'png'} );
 }
 function saveExcel(fileName){
	 $('#tableHTML').val($('<table><tr style="height:350px;"><td style="height:350px;">&nbsp;<p style="text-align:center;"><img src="'+fileName+'" style="width: 730px; height: 350px;"/></p><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/></td></tr></tr><td>'+$('#excelExportDiv').html()+'</td></tr></table>').html());
	 //$('#exportDiv').append($('<img src="'+fileName+'" />'));
	 //$('#exportDiv').append($('#publicationsTbl').parent().html());

	 //$('#tableHTML').val($('#exportDiv').html());
     $('#excelFrm').submit();
 }
    </script>
</head>
<body>

	<form id="frm" name="frm" action="${contextPath}/analysis/college/byPublications.do" method="post">
	<input type="hidden" name="selectedYear" id="selectedYear" value="${param.selectedYear}"/>
	<input type="hidden" name="isUserChanged" id="isUserChanged" value="true"/>
	<input type="hidden" name="clgCd" id="clgCd" value="<c:out value="${clgCd}"/>"/>

	<h3>Top Researchers By Publication</h3>

	<!--START page_function-->
	<div class="sub_top_box">
		<span>재직</span>
		<span class="select_span">
			<select name="hldofYn" id="hldofYn" onchange="javascript:$('#frm').submit();">
				<option value="ALL" ${parameter.hldofYn eq 'ALL' ? 'selected="selected"' : '' }>전체</option>
				<option value="1" ${parameter.hldofYn eq '1' ? 'selected="selected"' : '' }>재직</option>
				<option value="2" ${parameter.hldofYn eq '2' ? 'selected="selected"' : '' }>퇴직</option>
			</select>
		</span>
		<span style="margin-left:10px;">Position</span>
		<span class="select_span">
			<select name="position" id="position" onchange="javascript:$('#frm').submit();">
				<option value="ALL" ${parameter.position eq 'ALL' ? 'selected="selected"' : '' }>전체</option>
				<c:forEach var="pl" items="${positionList}" varStatus="idx">
				  <option value="${pl.codeValue }" ${parameter.position eq pl.codeValue ? 'selected="selected"' : '' }>${pl.codeDisp }</option>
				</c:forEach>
			</select>
		</span>
		<span style="margin-left:10px;">Journal</span>
		<span class="select_span">
			<select name="gubun" id="gubun" onchange="javascript:$('#frm').submit();">
				<option value="ALL" ${parameter.gubun eq 'ALL' ? 'selected="selected"' : '' }>전체</option>
				<option value="SCI" ${parameter.gubun eq 'SCI' ? 'selected="selected"' : '' }>SCI</option>
				<option value="SCOPUS" ${parameter.gubun eq 'SCOPUS' ? 'selected="selected"' : '' }>SCOPUS</option>
			</select>
		</span>
		<span style="margin-left:10px;">실적기간</span>
		<span class="select_span">
			<select name="fromYear" id="fromYear" onchange="javascript:if(validateRange()){ $('#frm').submit();}else{ errorMsg(this); $(this).val($(this).data('prev')); return false;}">
				<c:forEach var="yl" items="${pubYearList}" varStatus="idx">
				  <option value="${yl.pubYear }" ${parameter.fromYear eq yl.pubYear ? 'selected="selected"' : '' }>${yl.pubYear }</option>
				</c:forEach>
			</select>
		</span>					~<span class="select_span">
			<select name="toYear" id="toYear" onchange="javascript:if(validateRange()){ $('#frm').submit();}else{ errorMsg(this); $(this).val($(this).data('prev')); return false;}">
				<c:forEach var="yl" items="${pubYearList}" varStatus="idx">
				  <option value="${yl.pubYear }" ${parameter.toYear eq yl.pubYear ? 'selected="selected"' : '' }>${yl.pubYear }</option>
				</c:forEach>
			</select>
		</span>
		<span style="margin-left:10px;">목록수</span>
		<span class="select_span">
			<select name="rownum" onchange="javascript:$('#frm').submit();">
				<option value="ALL" ${rownum eq 'ALL' ? 'selected="selected"' : '' }>전체</option>
				<option value="20" ${rownum eq '20' ? 'selected="selected"' : '' }>20</option>
				<option value="50" ${rownum eq '50' ? 'selected="selected"' : '' }>50</option>
			</select>
		</span>
	</div>

	<div class="sub_content_wrapper">
		<table width="100%" id="publicationsTbl" class="list_tbl mgb_20">
			   <colgroup>
			   	 <col style="width: 7%"/>
			   	 <col style="width: 15%"/>
			   	 <col style="width: 15%"/>
			   	 <col style="width: 15%"/>
			   	 <col style="width: 30%"/>
			   	 <col style="width: 25%"/>
			   </colgroup>
				<thead>
					<tr style="height: 25px;">
						<th><span>NO</span></th>
						<th><span>성명</span></th>
						<th><span>ID</span></th>
						<th><span>직급</span></th>
						<th><span>학(부)과</span></th>
						<th><span>No. of Publications</span></th>
					</tr>
				</thead>
				<c:if test="${fn:length(topList) > 0}">
					<c:forEach items="${topList}" var="item" varStatus="status">
						<c:if test="${status.count mod 2 eq 1}">
							<tr style='height:25px;'>
						</c:if>
						<c:if test="${status.count mod 2 eq 0}">
							<tr style='height:25px;' class="par">
						</c:if>
						<td style='font-size: 10pt;' align="center">${status.count}</td>
						<td align="center" style='font: normal 12px 'Malgun Gothic';'>${item.KORNM }</td>
						<td align="center" style='font: normal 12px 'Malgun Gothic';'>${item.USERID }</td>
						<td style="text-align: center;">${item.GRADE1}</td>
						<td style="text-align: left; padding-left: 5px;">${item.SBJT_CD_NM }</td>
						<td style="text-align: center;padding-right: 5px;">${item.TOTAL }</td>

						</tr>
					</c:forEach>
				</c:if>
				<c:if test="${fn:length(topList) == 0}">
					<tr style='background-color: #ffffff;' height="17px">
						<td style='font-size: 10pt;' align="center" colspan=2><img
							src="${contextPath}/images/layout/ico_info.png" /> 검색된 논문이 없습니다.</td>
					</tr>
				</c:if>
			</table>
	</form>
<form id="excelFrm" method="post" action="${contextPath}/jsp/excelExport.jsp">
      <input type="hidden" id="tableHTML" name="tableHTML" value="" />
      <input type="hidden" id="fileName" name="fileName" value="publication.xls" />
      <div style="display: none;" id="excelExportDiv">
      	<table>
      		<tr>
      			<th><span>No</span></th>
      			<th><span>Title</span></th>
      			<th><span>Authors</span></th>
      			<th><span>Publisher</span></th>
      			<th><span>Journal</span></th>
      			<th><span>Volume</span></th>
      			<th><span>Issue</span></th>
      			<th><span>startPage</span></th>
      			<th><span>endPage</span></th>
      			<th><span>TC(SCI)</span></th>
      			<th><span>TC(SCOPUS)</span></th>
      			<th><span>IssueDate</span></th>
      		</tr>
		<c:if test="${fn:length(artList) > 0}">
			<c:forEach items="${artList}" var="item" varStatus="status">
				<c:if test="${status.count mod 2 eq 1}">
					<tr style='background-color: #ffffff;' height="17px">
				</c:if>
				<c:if test="${status.count mod 2 eq 0}">
					<tr style='background-color: #eaeaff;' height="17px">
				</c:if>
				<td style='font-size: 10pt;' align="center" width="40">${status.count}</td>
				<td align="left" style='font: normal 12px 'Malgun Gothic';'><b>${item.ESUBJECT}</b></td>
				<td align="left" style='font: normal 12px 'Malgun Gothic';'>${item.AUTHORS }</td>
				<td align="left" style='font: normal 12px 'Malgun Gothic';'>${item.PUBLISHER }</td>
				<td align="left" style='font: normal 12px 'Malgun Gothic';'>${item.MAGAZINE}</td>
				<td align="left" style='font: normal 12px 'Malgun Gothic';'>v.${item.VOL}</td>
				<td align="left" style='font: normal 12px 'Malgun Gothic';'>no.${item.NO}</td>
				<td align="left" style='font: normal 12px 'Malgun Gothic';'>${item.STRPAGE}</td>
				<td align="left" style='font: normal 12px 'Malgun Gothic';'>${item.ENDPAGE}</td>
				<td align="right" style='font: normal 12px 'Malgun Gothic'; '>${item.SCI_TC}</td>
				<td align="right" style='font: normal 12px 'Malgun Gothic';'>${item.SCP_TC}</td>
				<td align="left" style='font: normal 12px 'Malgun Gothic';'><ui:dateformat value="${item.ISSUEDATE}" pattern="yyyy.MM.dd" /></td>
				</tr>
			</c:forEach>
		</c:if>
		<c:if test="${fn:length(artList) == 0}">
			<tr style='background-color: #ffffff;' height="17px">
				<td style='font-size: 10pt;' align="center" colspan=2><img
					src="${contextPath}/images/layout/ico_info.png" /> 검색된 논문이 없습니다.</td>
			</tr>
		</c:if>
      	</table>
      </div>
      <!--
      <input type="button" onclick="gotoExcel('tableData', 'tableHTML');" value="Export these results" />
       -->
</form>
<div id="exportDiv" style="display: none;"></div>
</body>
</html>
