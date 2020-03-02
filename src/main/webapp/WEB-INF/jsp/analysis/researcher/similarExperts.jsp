<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><spring:message code="menu.asrms.rsch.similar"/></title>
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

				 var color =  (i+1) % 2 == 1 ? "#ffffff" : "#eaeaff";
				 var $tr = $('<tr style="background-color: '+color+';" height="17px"></tr>');
				 $tr.append($('<td style="font-size: 10pt;" align="center" width="40">'+(i+1)+'</td>'));
				 var $td = $('<td class="link_td" style="font: normal 12px \'Malgun Gothic\';"></td>').append($('<a href="javascript:popArticle('+seqno+')"><b>'+esubject+'</b></a>'));
				 //var content = '<b>Journal</b>: '+magazine+' [v.'+vol+',&nbsp;no.'+no+',&nbsp; pp.'+strpage+'~'+endpage+',&nbsp;'+issueDate+']';
				 var content = '&nbsp;/ '+authors + '&nbsp;('+publisher+',&nbsp;' + magazine+',&nbsp;v.'+vol+',&nbsp;no.'+no+',&nbsp; pp.'+strpage+'~'+endpage+',&nbsp;'+issueDate+')';
				 $td.append(content);
				 $tr.append($td);
				 $('#publicationsTbl').append($tr);

			 }

			//alert(data[0].ESUBJECT);
		 }
	 }).done(function(){});



	 //$('#selectedYear').val(year);
	 //$('#frm').submit();

 }

 function gotoExcel(elemId, frmFldId)
 {
	 //alert('gotoExcel');
     //var obj = document.getElementById(elemId);
     //var oFld = document.getElementById(frmFldId);
     //oFld.value = obj.innerHTML;
     $('#'+frmFldId).val($('#publicationsTbl').parent().html());
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

 function exportExcel(){

	 var chartObject = getChartFromId('ChartId1');

	 if( chartObject.hasRendered() ) chartObject.exportChart( { exportFormat : 'png'} );
 }
 function saveExcel(fileName){
	 $('#tableHTML').val($('<table><tr style="height:350px;"><td style="height:350px;">&nbsp;<p style="text-align:center;"><img src="'+fileName+'" style="width: 730px; height: 350px;"/></p><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/></td></tr></tr><td>'+$('#publicationsTbl').parent().html()+'</td></tr></table>').html());
	 //$('#exportDiv').append($('<img src="'+fileName+'" />'));
	 //$('#exportDiv').append($('#publicationsTbl').parent().html());

	 //$('#tableHTML').val($('#exportDiv').html());
     $('#excelFrm').submit();
 }

   </script>
</head>
<body>

	<!-- content -->
	<form id="frm" name="frm" action="${contextPath}/analysis/researcher/similar.do" method="post" >
	<input type="hidden" id="topNm" name="topNm" value="<c:out value="${topNm}"/>"/>
	<input type="hidden" name="userId" id="userId" value="<c:out value="${parameter.userId}"/>"/>
	<input type="hidden" name="selectedYear" id="selectedYear" value="${selectedYear}"/>
	<input type="hidden" name="mode" id="mode" value="<c:out value="${parameter.mode}"/>"/>
	<input type="hidden" name="srchUserId" id="srchUserId" value="<c:out value="${parameter.srchUserId}"/>"/>
	<input type="hidden" name="srchUserPhotoUrl" id="srchUserPhotoUrl" value="<c:out value="${parameter.srchUserPhotoUrl}"/>"/>
	<input type="hidden" name="aslang" id="smiliar_lang" value="${sessionScope.aslang}"/>

	<h3><spring:message code="menu.asrms.rsch.similar"/></h3>

	<h2 class="circle_h3">Non-Coauthors</h2>
	<div class="help_text mgb_30"><spring:message code="asrms.researcher.similar.noncoauthor.desc"/></div>

	<div class="sub_content_wrapper">
		<table width="100%" id="publicationsTbl" class="list_tbl mgb_20">
			<colgroup>
				<col style="width: 5%;"/>
				<col style="width: 20%;"/>
				<col style="width: 50%"/>
				<col style="width: 15%"/>
			</colgroup>
			<c:if test="${fn:length(similarListNonCoauthors) > 0}">
			<thead>
				<tr>
					<th>NO</th>
					<th>Name</th>
					<th>Department</th>
					<th>Similarity</th>
				</tr>
			</thead>
			<c:forEach items="${similarListNonCoauthors}" var="item" varStatus="status">
				<tr style='height:17px;'>
					<td style='font-size: 10pt;' align="center" width="40">
						${status.count}</td>
					<td style='text-align:left; font: normal 12px 'Malgun Gothic';'>
							<b>${item.korNm }
							<%--
								<c:if test="${sessionScope.aslang eq 'KOR' }"> ${item.korNm }</c:if>
								<c:if test="${sessionScope.aslang eq 'ENG' }"> ${item.engNm }</c:if>
							 --%>
							</b>
					</td>
					<td style='padding-left:5px; font: normal 12px 'Malgun Gothic';'>
							${item.deptKorNm }
							<%--
								<c:if test="${sessionScope.aslang eq 'KOR' }"> ${item.deptKorNm }</c:if>
								<c:if test="${sessionScope.aslang eq 'ENG' }"> ${item.deptEngNm }</c:if>
							 --%>
					</td>
					<td style='text-align:left; font: normal 12px 'Malgun Gothic';'>
						  <img src="${contextPath}/images/icon/ico_star.png" alt="plus button" />
						  <img src="${contextPath}/images/icon/ico_star.png" alt="plus button" />
						  <img src="${contextPath}/images/icon/ico_star.png" alt="plus button" />
						  <c:if test="${item.similarity < 0.4 }">
							  <img src="${contextPath}/images/icon/ico_star_n.png" alt="plus button" />
							  <img src="${contextPath}/images/icon/ico_star_n.png" alt="plus button" />
						  </c:if>
						  <c:if test="${item.similarity >= 0.4 }">
						  	<img src="${contextPath}/images/icon/ico_star.png" alt="plus button" />
						  </c:if>
						  <c:if test="${item.similarity >= 0.4 and item.similarity < 0.5 }">
							  <img src="${contextPath}/images/icon/ico_star_n.png" alt="plus button" />
						  </c:if>
						  <c:if test="${item.similarity >= 0.5 }">
						  	<img src="${contextPath}/images/icon/ico_star.png" alt="plus button" />
						  </c:if>
					</td>
				</tr>
			</c:forEach>
		</c:if>
		<c:if test="${fn:length(similarListNonCoauthors) == 0}">
			<tr style='background-color: #ffffff;' height="17px">
				<td style='font-size: 10pt;' align="center" colspan=2>
				<img src="${contextPath}/images/layout/ico_info.png" />There are no experts working on similar research at ${instAbrv}.</td>
			</tr>
		</c:if>
		</table>
	</div>

	<h2 class="circle_h3">Coauthors</h2>
	<div class="help_text mgb_30"><spring:message code="asrms.researcher.similar.coauthor.desc"/></div>

	<div class="sub_content_wrapper">
		<table width="100%" id="publicationsTbl" class="list_tbl mgb_20">
				<colgroup>
					<col style="width: 5%;"/>
					<col style="width: 20%;"/>
					<col style="width: 50%"/>
					<col style="width: 15%"/>
				</colgroup>
				<c:if test="${fn:length(similarListCoauthors) > 0}">
				<thead>
					<tr>
						<th>NO</th>
						<th>Name</th>
						<th>Department</th>
						<th>Similarity</th>
					</tr>
				</thead>
				<c:forEach items="${similarListCoauthors}" var="item" varStatus="status">
					<tr style='height:17px;'>
						<td style='font-size: 10pt;' align="center" width="40">
							${status.count}</td>
						<td style='text-align:left; font: normal 12px 'Malgun Gothic';'>
								<b>
								${item.korNm }
								<%--
									<c:if test="${sessionScope.aslang eq 'KOR' }"> ${item.korNm }</c:if>
									<c:if test="${sessionScope.aslang eq 'ENG' }"> ${item.engNm }</c:if>
								 --%>
								</b>
						</td>
						<td style='padding-left:5px;font: normal 12px 'Malgun Gothic';'>
								${item.deptKorNm }
								<%--
									<c:if test="${sessionScope.aslang eq 'KOR' }"> ${item.deptKorNm }</c:if>
									<c:if test="${sessionScope.aslang eq 'ENG' }"> ${item.deptEngNm }</c:if>
								 --%>
							</td>
						<td style='text-align:left; padding-right:10px; font: normal 12px 'Malgun Gothic';'>
							  <img src="${contextPath}/images/icon/ico_star.png" alt="plus button" />
							  <img src="${contextPath}/images/icon/ico_star.png" alt="plus button" />
							  <img src="${contextPath}/images/icon/ico_star.png" alt="plus button" />
						  <c:if test="${item.similarity < 0.4 }">
							  <img src="${contextPath}/images/icon/ico_star_n.png" alt="plus button" />
							  <img src="${contextPath}/images/icon/ico_star_n.png" alt="plus button" />
						  </c:if>
							  <c:if test="${item.similarity >= 0.4 }">
							  	<img src="${contextPath}/images/icon/ico_star.png" alt="plus button" />
							  </c:if>
						  <c:if test="${item.similarity >= 0.4 and item.similarity < 0.5 }">
							  <img src="${contextPath}/images/icon/ico_star_n.png" alt="plus button" />
						  </c:if>
							  <c:if test="${item.similarity >= 0.5 }">
							  	<img src="${contextPath}/images/icon/ico_star.png" alt="plus button" />
							  </c:if>
						</td>
					</tr>
				</c:forEach>
			</c:if>
			<c:if test="${fn:length(similarListCoauthors) == 0}">
				<tr style='background-color: #ffffff;' height="17px">
					<td style='font-size: 10pt;' align="center" colspan=2><img
						src="${contextPath}/images/layout/ico_info.png" />You are not writing any articles with any other similar subject researchers at ${instAbrv}.</td>
				</tr>
			</c:if>
			</table>
	</div>
</form>

<form id="excelFrm" method="post" action="${contextPath}/jsp/excelExport.jsp">
      <input type="hidden" id="tableHTML" name="tableHTML" value="" />
      <input type="hidden" id="fileName" name="fileName" value="publication.xls" />
      <!--
      <input type="button" onclick="gotoExcel('tableData', 'tableHTML');" value="Export these results" />
       -->
</form>
<div id="exportDiv" style="display: none;"></div>
</body>
</html>
