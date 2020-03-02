<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Latest Articles</title>
<script>
 function changeLatestDept(){
	 $('#publicationsTbl > tbody').empty();

	 $.ajax({
		 url : "${asrimsContextPath}/home/findLatestArticleListAjax.do",
		 type: 'POST',
		 dataType : 'json',
		 data : { "searchGroupDept":$('#searchGroupDept').val(), "rownum": $('#rownum').val(), "gubun": "SCI"},
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
			     var esubjectLink = data[i].doi == null ? '<a href="javascript:popArticle(\''+seqno+'\');"><b>' + esubject + '</b></a>' : '<a href="http://dx.doi.org/'+data[i].doi+'" target="_blank"><b>'+esubject+'</b></a>';

				 var $tr = $('<tr style="height:17px;"></tr>');
				 $tr.append($('<td style="font-size: 10pt;" align="center" width="40">'+(i+1)+'</td>'));
				 var $td = $('<td align="left" style="font: normal 12px \'Malgun Gothic\';"></td>').append($('<div class="style_12pt">'+esubjectLink+'</div>'));
				 //var content = '<b>Journal</b>: '+magazine+' [v.'+vol+',&nbsp;no.'+no+',&nbsp; pp.'+strpage+'~'+endpage+',&nbsp;'+issueDate+']';
				 var content = '<div>&nbsp;/ '+authors + '&nbsp;('+publisher+',&nbsp;' + magazine+',&nbsp;v.'+vol+',&nbsp;no.'+no+',&nbsp; pp.'+strpage+'~'+endpage+',&nbsp;'+issueDate+')</div>';
				 $td.append(content);
				 $tr.append($td);
				 $('#publicationsTbl > tbody').append($tr);

			 }
			 //$('#list_title').text('Publication ('+year+')');
			//alert(data[0].ESUBJECT);
		 }
	 });
 }
   </script>
</head>
<body>

	<h3 class="page_title">Latest SCI Articles by Dept.</h3>
	<div class="help_text mgb_30"><spring:message code="asrms.aboutsci.latest_article.desc"/></div>

	<form id="frm" name="frm" action="${asrimsContextPath}/home/latestArticles.do" method="post">
	<input type="hidden" id="topNm" name="topNm" value="<c:out value="${topNm}"/>"/>
	<input type="hidden" id="gubun" name="gubun" value="SCI"/>

		<!--START page_function-->
		<div class="page_function">
			<span>Department</span>
			<span>
				<select id="searchGroupDept" name="searchGroupDept" onchange="javascript:changeLatestDept();">
					<c:forEach items="${deptList}" var="dl">
					<option value="${dl.deptKor }"  <c:if test="${dl.deptKor eq parameter.searchGroupDept}">selected="selected"</c:if>   >
							<c:if test="${sessionScope.aslang eq 'KOR' }"> ${dl.deptKor }</c:if>
							<c:if test="${sessionScope.aslang eq 'ENG' }"> ${dl.deptEngMostAbbr}</c:if>
					</option>
					</c:forEach>
				</select>
			</span>
			<span style="margin-top: 5px;">
					<a href="#" onclick="javascript:changeLang($('#frm'));">
						<c:if test="${sessionScope.aslang eq 'KOR'}"><img src="${asrimsImagePath}/common/btn_ENG.png" style="vertical-align: text-bottom;"/></c:if>
						<c:if test="${sessionScope.aslang eq 'ENG'}"><img src="${asrimsImagePath}/common/btn_KOR.png" style="vertical-align: text-bottom;"/></c:if>
					</a>
			</span>
			<span style="margin-left:10px;">Row</span>
			<span>
				<select name="rownum" id="rownum" onchange="javascript:$('#frm').submit();">
					<option value="10" ${parameter.rownum  eq '10' ? 'selected="selected"' : '' }>10</option>
					<option value="50" ${parameter.rownum  eq '50' ? 'selected="selected"' : '' }>50</option>
					<option value="100" ${parameter.rownum  eq '100' ? 'selected="selected"' : '' }>100</option>
				</select>
			</span>
		</div>
		<!--END page_function-->

		<!--START sub_content_wrapper-->
		<div class="sub_content_wrapper" style="width: 735px;overflow: auto;">
			<table width="100%" id="publicationsTbl" class="sub_list">
				<thead>
					<tr>
						<th>No</th>
						<th>Article</th>
					</tr>
				</thead>
				<tbody>
				<c:if test="${fn:length(lastedArtList) > 0}">
					<c:forEach items="${lastedArtList}" var="item" varStatus="status">
						<tr>
							<td width="35" class="center">
								${status.count}</td>
							<td>
								<div class="style_12pt">
									<c:set var="doiUrl" value="${not empty item.doi ? item.doi : '' }"/>
										<c:if test="${doiUrl ne '' }">
											<a href="http://dx.doi.org/${doiUrl}" target="_blank"><b>${item.orgLangPprNm}</b></a>
										</c:if>
										<c:if test="${doiUrl eq '' }">
											<a href="javascript:popArticle('${item.SEQNO}');"><b>${item.orgLangPprNm}</b></a>
										</c:if>
								</div>
								<div>
									&nbsp;/ ${item.authors }&nbsp;(
									<c:if test="${not empty item.pblcPlcNm }" >${item.pblcPlcNm },&nbsp;</c:if>${item.scjnlNm},&nbsp;v.${item.volume},&nbsp;no.${item.issue},&nbsp;pp.${item.sttPage}~${item.endPage},&nbsp;<ui:dateformat value="${item.pblcYm}" pattern="yyyy.MM.dd" />
								)
								 </div>
							</td>
						</tr>
					</c:forEach>
				</c:if>
				<c:if test="${fn:length(lastedArtList) == 0}">
					<tr>
						<td><img src="${asrimsImagePath}/layout/ico_info.png" /> 검색된 논문이 없습니다.</td>
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
      			<th>No</th>
      			<th>Title</th>
      			<th>Authors</th>
      			<th>Publisher</th>
      			<th>Journal</th>
      			<th>Volume</th>
      			<th>Issue</th>
      			<th>startPage</th>
      			<th>endPage</th>
      			<th>TC(SCI)</th>
      			<th>TC(SCOPUS)</th>
      			<th>IssueDate</th>
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
					src="${asrimsImagePath}/layout/ico_info.png" /> 검색된 논문이 없습니다.</td>
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
