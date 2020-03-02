<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>학과 주제별 JCR 랭킹</title>
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

 $(document).ready(function(){
	 var myExportComponent = new FusionChartsExportObject("fcExporter1", "${contextPath}/Charts/flash/FusionCharts/FCExporter.swf");
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
		<form id="frm" name="frm" action="${contextPath}/home/subjectDepartJcrRanking.do"  method="post">
		<input type="hidden" name="mask_year" id="mask_year" value="${mask_year}"/>
			<!--START page_title-->
	<h3>JCR Ranking by Dept. and Category</h3>
			<!--END page_title-->


	
			<!--START page_function-->
			<div class="sub_top_box">

				<span style="margin-left:10px;">Department</span>
				<span class="select_span">
					<select id="deptSubject" name="deptKor" onchange="javascript:$('#frm').submit();">
						<c:forEach items="${deptList}" var="dl">
						<option value="${dl.DEPT_KOR }" <c:if test="${dl.DEPT_KOR eq deptKor}">selected="selected"</c:if> >
								<c:if test="${lang eq 'KOR' }"> ${dl.DEPT_KOR }</c:if>
								<c:if test="${lang eq 'ENG' }"> ${dl.DEPT_ENG_MOST_ABBR }</c:if>
						</option>
						</c:forEach>
					</select>
				</span>
				<span style="margin-top: 5px;">
						<a href="#" onclick="javascript:changeLang($('#frm'));">
							<c:if test="${lang eq 'KOR'}"><img src="${contextPath}/images/common/btn_ENG.png" style="vertical-align: text-bottom;"/></c:if>
							<c:if test="${lang eq 'ENG'}"><img src="${contextPath}/images/common/btn_KOR.png" style="vertical-align: text-bottom;"/></c:if>
						</a>
				</span>
				<span style="margin-left:10px;">Category</span>
				<span class="select_span">
					<select id="dept_categ" name="dept_categ" onchange="javascript:$('#frm').submit();">
						<c:if test="${not empty deptSubject}">
							<c:forEach items="${deptSubject}" var="ds" varStatus="st">
									<option value="${ds.CATCODE }"  <c:if test="${ds.CATCODE eq dept_categ}">selected="selected"</c:if> >${ds.DESCRIPTION  }</option>
							</c:forEach>
						</c:if>
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
				</p>
			</div>
			<!--END page_function-->

			<div class="help_text mgb_30"><spring:message code="asrms.aboutsci.jcr_ranking_dept.desc"/></div>

			<!--START sub_content_wrapper-->
			<div class="sub_content_wrapper">
				<table width="100%" id="publicationsTbl" class="list_tbl mgb_20" <c:if test="${fn:length(deptJcrHighList) != 0}">style="table-layout: fixed;"</c:if>>
						<colgroup>
							<col style="width: 5%;" />
							<col style="width: 45%" />
							<col style="width: 15%" />
							<col style="width: 25%" />
							<col style="width: 10%" />
						</colgroup>
						<thead>
							<tr style="height: 25px;">
								<th><span>NO</span></th>
								<th><span>Journal</span></th>
								<th><span>ISSN</span></th>
								<th><span>Impact Factor</span></th>
								<th><span>Rank(%)</span></th>
							</tr>
						</thead>
						<tbody>
							<c:if test="${fn:length(deptJcrHighList) > 0}">
								<c:forEach items="${deptJcrHighList}" var="item" varStatus="status">
									<tr style='height:25px;'>
										<td style="text-align: center;">${status.count }</td>
										<td align="left" style='font-size: 8pt;width:45%; overflow: hidden; text-overflow:ellipsis; white-space:nowrap;' title="${item.TITLE}">
											${item.TITLE}</a>
										</td>
										<td style="text-align: center;font-size: 8pt;">${item.ISSN}</td>
										<td style="text-align: center;font-size: 8pt;">${item.IMPACT}</td>
										<td style="text-align: center;font-size: 8pt;">${item.RATIO}</td>
									</tr>
								</c:forEach>
							</c:if>
						<c:if test="${fn:length(deptJcrHighList) == 0}">
							<tr style='background-color: #ffffff;' height="17px">
								<td style='font-size: 10pt;' align="center" colspan=99><img
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
