<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><spring:message code="menu.asrms.about.ranking"/></title>
<script>
 function popArticle(seqno) {
		var url = "${contextPath}/jsp/viewDetail.jsp?seqno="+seqno;
		var PopUP = window.open(url, "detail", "width=670,height=700,directories=no,status=no,toolbar=no,menubar=no,scrollbars=yes,resizable=yes");
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

 $(document).ready(function(){ });

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
 $(document).ready(function(){
	 var collegeName = "";
		<c:forEach var="cl" items="${collegeList}" varStatus="idx">
			<c:if test="${cl.CODE_VALUE  eq param.clgCd}"> collegeName = '${cl.CODE_DISP}';</c:if>
		</c:forEach>
	 $('#collegeName').text(collegeName);
 });
   </script>
</head>
<body>
	<form id="frm" name="frm" action="${contextPath}/analysis/home/jcrRankingByCategory.do" method="post">
	<input type="hidden" id="topNm" name="topNm" value="<c:out value="${topNm}"/>"/>
			<!--START page_title-->
	<h3><spring:message code="menu.asrms.about.ranking"/></h3>
			<!--END page_title-->


	
			<!--START page_function-->
			<div class="sub_top_box">

				<span class="select_text">학술지구분</span>
				<span class="select_span">
					<select name="gubun" id="gubun" onchange="javascript:$('#frm').submit();">
						<option value="SCI" ${parameter.gubun eq 'SCI' ? 'selected="selected"' : '' }>SCI</option>
						<option value="SCOPUS" ${parameter.gubun eq 'SCOPUS' ? 'selected="selected"' : '' }>SCOPUS</option>
						<option value="KCI" ${parameter.gubun eq 'KCI' ? 'selected="selected"' : '' }>KCI</option>
					</select>
				</span>

				<span class="select_text mgl_10">분야</span>
				<span class="select_span" style="width:200px;">
					<select id="maskCateg" name="maskCateg" onchange="javascript:$('#frm').submit();">
						<option value="" >선택</option>
						<c:if test="${not empty ctgryList}">
							<c:forEach items="${ctgryList}" var="tl" varStatus="st">
									<option value="${tl.catcode }" ${parameter.maskCateg eq tl.catcode ? 'selected="selected"' : '' } >${tl.description  }</option>
							</c:forEach>
						</c:if>
					</select>
				</span>
				<span class="select_text mgl_10">연도</span>
				<span class="select_span">
					<select id="maskYear" name="maskYear" onchange="javascript:$('#frm').submit();">
						<c:if test="${not empty prodyearList}">
							<c:forEach items="${prodyearList}" var="tl" varStatus="st">
									<option value="${tl.prodYear }" ${parameter.maskYear eq tl.prodYear ? 'selected="selected"' : '' } >${tl.prodYear  }</option>
							</c:forEach>
						</c:if>
					</select>
				</span>
				<span class="select_text mgl_10">백분율(%)</span>
				<span class="select_span">
					<select id="maskRatio" name="maskRatio" onchange="javascript:$('#frm').submit();">
						<option value="10" ${parameter.maskRatio eq 10 ? 'selected="selected"' : '' }>10%</option>
						<option value="20" ${parameter.maskRatio eq 20 ? 'selected="selected"' : '' }>20%</option>
						<option value="30" ${parameter.maskRatio eq 30 ? 'selected="selected"' : '' }>30%</option>
						<option value="40" ${parameter.maskRatio eq 40 ? 'selected="selected"' : '' }>40%</option>
						<option value="50" ${parameter.maskRatio eq 50 ? 'selected="selected"' : '' }>50%</option>
						<option value="60" ${parameter.maskRatio eq 60 ? 'selected="selected"' : '' }>60%</option>
						<option value="70" ${parameter.maskRatio eq 70 ? 'selected="selected"' : '' }>70%</option>
						<option value="80" ${parameter.maskRatio eq 80 ? 'selected="selected"' : '' }>80%</option>
						<option value="90" ${parameter.maskRatio eq 90 ? 'selected="selected"' : '' }>90%</option>
						<option value="100" ${parameter.maskRatio eq 100 ? 'selected="selected"' : '' }>100%</option>
					</select>
				</span>
				<%--
				<span style="margin-left:10px;">목록수</span>
				<span class="select_span">
					<select name="rownum" onchange="javascript:$('#frm').submit();">
						<option value="ALL" ${rownum eq 'ALL' ? 'selected="selected"' : '' }>전체</option>
						<option value="20" ${rownum eq '20' ? 'selected="selected"' : '' }>20</option>
					</select>
				</span>
				 --%>
			</div>
			<!--END page_function-->

	<div class="help_text mgb_30"><spring:message code="asrms.aboutsci.jcr_ranking.desc"/></div>

			<!--START sub_content_wrapper-->
			<div class="sub_content_wrapper">
				<table width="100%" id="publicationsTbl" class="list_tbl mgb_20"  <c:if test="${fn:length(catRankingList) != 0}">style="table-layout: fixed;"</c:if>>
						<colgroup>
							<col style="width: 8%;" />
							<col style="width: 45%" />
							<col style="width: 10%" />
							<col style="width: 10%" />
							<col style="width: 10%" />
						</colgroup>
						<thead>
							<tr style="height: 25px;">
								<th><span>NO</span></th>
								<th><span>Journal</span></th>
								<th><span>ISSN</span></th>
								<th><span>I.F</span></th>
								<th><span>백분율(%)</span></th>
							</tr>
						</thead>
						<tbody>
						<c:if test="${fn:length(catRankingList) > 0}">
							<c:forEach items="${catRankingList}" var="item" varStatus="status">
								<tr style='height:20px;'>
									<td style="text-align: center;">${status.count }</td>
									<td class="link_td" align="left" style='width:45%; overflow: hidden; text-overflow:ellipsis; white-space:nowrap;' title="${item.title}">
										${item.title}</a>
									</td>
									<td style="text-align: center;font-size: 9pt;">${item.issn}</td>
									<td style="text-align: center;font-size: 9pt;">
										<c:if test="${parameter.gubun eq 'SCI'}"><c:set var="indicator" value="${item.impact}" /></c:if>
										<c:if test="${parameter.gubun eq 'SCOPUS'}"><c:set var="indicator" value="${item.sjr}" /></c:if>
										<c:if test="${parameter.gubun eq 'KCI'}">
											<fmt:formatNumber var="indicator" value="${item.kciIf}" pattern="#,##0.0##"/>
										</c:if>
										${indicator}
									</td>
									<td style="text-align: center;font-size: 9pt;">${item.ratio}</td>
								</tr>
							</c:forEach>
						</c:if>
						<c:if test="${fn:length(catRankingList) == 0}">
							<tr style='background-color: #ffffff;' height="17px">
								<td style='font-size: 10pt;width:100%; overflow: hidden; text-overflow:ellipsis; white-space:nowrap;' align="center" colspan="99"><img
									src="${contextPath}/images/layout/ico_info.png" />There are no journals.</td>
							</tr>
						</c:if>
						</tbody>
					</table>
			</div>
			<!--END sub_content_wrapper-->
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
