<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Latest Articles</title>
<script>
 function changeLatestDept(){
	 $('#publicationsTbl > tbody').empty();

	 $.ajax({
		 url : "${contextPath}/analysis/home/findLatestArticleListAjax.do",
		 type: 'POST',
		 dataType : 'json',
		 data : { "searchDept":$('#latestDept').val(), "rownum": $('#rownum').val(), "gubun": "SCI"},
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
				 var $td = $('<td class="link_td" style="font: normal 12px \'Malgun Gothic\';"></td>').append($('<div class="style_12pt">'+esubjectLink+'</div>'));
				 //var content = '<b>Journal</b>: '+magazine+' [v.'+vol+',&nbsp;no.'+no+',&nbsp; pp.'+strpage+'~'+endpage+',&nbsp;'+issueDate+']';
				 var content = '<span>'+authors + '&nbsp;('+publisher+',&nbsp;' + magazine+',&nbsp;'+vol+',&nbsp;'+no+',&nbsp; pp.'+strpage+'~'+endpage+',&nbsp;'+issueDate+')</span>';
				 $td.append(content);
				 $tr.append($td);
				 $('#publicationsTbl > tbody').append($tr);

			 }
		 }
	 });
 }
   </script>
</head>
<body>

	<form id="frm" name="frm" action="${contextPath}/analysis/home/latestArticles.do" method="post">
	<input type="hidden" id="topNm" name="topNm" value="<c:out value="${topNm}"/>"/>
	

	<h3><spring:message code="menu.asrms.about.latest"/></h3>

	
			<!--START page_function-->
			<div class="sub_top_box">

			<span class="select_text">학술지구분</span>
			<span class="select_span">
				<select name="gubun" id="gubun" onchange="javascript:$('#frm').submit();">
					<option value="ALL" ${parameter.gubun eq 'ALL' ? 'selected="selected"' : '' }>전체</option>
					<option value="SCI" ${parameter.gubun eq 'SCI' ? 'selected="selected"' : '' }>SCI</option>
					<option value="SCOPUS" ${parameter.gubun eq 'SCOPUS' ? 'selected="selected"' : '' }>SCOPUS</option>
					<option value="KCI" ${parameter.gubun eq 'KCI' ? 'selected="selected"' : '' }>KCI</option>
				</select>
			</span>

				<%--
				<span class="select_text">Department</span>
				<span class="select_span">
					<select id="latestDept" name="searchDept" onchange="javascript:changeLatestDept();">
						<c:forEach items="${deptList}" var="dl">
						<option value="${dl.deptCode }"  <c:if test="${dl.deptCode eq parameter.searchDept}">selected="selected"</c:if>   >
								<c:if test="${sessionScope.aslang eq 'KOR' }"> ${dl.deptKor }</c:if>
								<c:if test="${sessionScope.aslang eq 'ENG' }"> ${dl.deptKor }</c:if>
								<!--
								<c:if test="${sessionScope.lang eq 'ENG' }"> ${dl.deptEngMostAbbr }</c:if>
								 -->
						</option>
						</c:forEach>
					</select>
				</span>
				<span style="margin-top: 5px;">
						<a href="#" onclick="javascript:changeLang($('#frm'));">
							<c:if test="${sessionScope.aslang eq 'KOR'}"><img src="${contextPath}/images/common/btn_ENG.png" style="vertical-align: text-bottom;"/></c:if>
							<c:if test="${sessionScope.aslang eq 'ENG'}"><img src="${contextPath}/images/common/btn_KOR.png" style="vertical-align: text-bottom;"/></c:if>
						</a>
				</span>
				 --%>
				<span class="select_text mgl_40">목록수</span>
				<span class="select_span">
					<select name="rownum" id="rownum" onchange="javascript:$('#frm').submit();">
						<option value="10" ${parameter.rownum eq '10' ? 'selected="selected"' : '' }>10</option>
						<option value="50" ${parameter.rownum eq '50' ? 'selected="selected"' : '' }>50</option>
						<option value="100" ${parameter.rownum eq '100' ? 'selected="selected"' : '' }>100</option>
					</select>
				</span>
			</div>
			<!--END page_function-->

			<div class="help_text mgb_30"><spring:message code="asrms.aboutsci.latest_article.desc"/></div>

			<table width="100%" id="publicationsTbl" class="list_tbl mgb_20">
				<thead>
					<tr>
						<th><span>No</span></th>
						<th><span>Article</span></th>
					</tr>
				</thead>
				<tbody>
				<c:if test="${fn:length(lastedArtList) > 0}">
					<c:forEach items="${lastedArtList}" var="item" varStatus="status">
						<tr>
							<td width="35" class="center">
								${status.count}</td>
							<td class="link_td">
								<div class="style_12pt">
									<c:set var="link" value=""/>
									<c:choose>
										<c:when test="${not empty item.scjnlDvsCd and item.scjnlDvsCd eq '1'}">
											<c:if test="${not empty item.doi}"><c:set var="link" value="http://dx.doi.org/${item.doi}"/></c:if>
											<c:if test="${empty item.doi and not empty item.url}"><c:set var="link" value="${item.url}"/></c:if>
											<c:if test="${empty item.doi and empty item.url and not empty item.idSci}"><c:set var="link" value="${item.wosSourceUrl}"/></c:if>
											<c:if test="${empty item.doi and empty item.url and empty item.idSci}"><c:set var="link" value=""/></c:if>
										</c:when>
										<c:when test="${not empty item.scjnlDvsCd and item.scjnlDvsCd eq '6'}">
											<c:if test="${not empty item.doi}"><c:set var="link" value="http://dx.doi.org/${item.doi}"/></c:if>
											<c:if test="${empty item.doi and not empty item.url}"><c:set var="link" value="${item.url}"/></c:if>
											<c:if test="${empty item.doi and empty item.url and not empty item.idScopus}"><c:set var="link" value="${sysConf['scopus.search.view.url']}&origin=inward&scp=${fn:replace(item.idScopus,'2-s2.0-','')}"/></c:if>
											<c:if test="${empty item.doi and empty item.url and empty item.idScopus}"><c:set var="link" value=""/></c:if>
										</c:when>
										<c:when test="${not empty item.scjnlDvsCd and item.scjnlDvsCd eq '3'}">
											<c:if test="${not empty item.idKci}"><c:set var="link" value="${sysConf['kci.search.view.url']}?sereArticleSearchBean.artiId=${item.idKci}"/></c:if>
											<c:if test="${empty item.idKci and not empty item.doi}"><c:set var="link" value="http://dx.doi.org/${item.doi}"/></c:if>
											<c:if test="${empty item.idKci and empty item.doi}"><c:set var="link" value="${item.url}"/></c:if>
											<c:if test="${empty item.idKci and empty item.doi and empty item.url}"><c:set var="link" value=""/></c:if>
										</c:when>
										<c:otherwise>
											<c:if test="${not empty item.doi}"><c:set var="link" value="http://dx.doi.org/${item.doi}"/></c:if>
											<c:if test="${empty item.doi and not empty item.url}"><c:set var="link" value="${item.url}"/></c:if>
											<c:if test="${empty item.doi and empty item.url}"><c:set var="link" value=""/></c:if>
										</c:otherwise>
									</c:choose>
									<c:if test="${not empty link }">
										<a href="${link}" target="_blank"><b>${item.orgLangPprNm}</b></a>
									</c:if>
									<c:if test="${empty link }">
										<a href="javascript:dhtmlx.alert('링크가 존재하지않습니다.');" target="_self"><b>${item.orgLangPprNm}</b></a>
									</c:if>
								</div>
								<span>
									${item.authors }&nbsp;(
									<c:if test="${not empty item.pblcPlcNm }" >${item.pblcPlcNm },&nbsp;</c:if>${item.scjnlNm},&nbsp;v.${item.volume},&nbsp;no.${item.issue},&nbsp;pp.${item.sttPage}~${item.endPage},&nbsp;<ui:dateformat value="${item.pblcYm}" pattern="yyyy.MM.dd" />
									)
								 </span>
							</td>
						</tr>
					</c:forEach>
				</c:if>
				<c:if test="${fn:length(lastedArtList) == 0}">
					<tr>
						<td colspan="2"><img src="${contextPath}/images/layout/ico_info.png" /> 검색된 논문이 없습니다.</td>
					</tr>
				</c:if>
				</tbody>
		 </table>
	</div>
</form>
</body>
</html>
