<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.argonet.r2rims.util.LanguageUtil"%>
<%@include file="../../../pageInit.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="cache-Control" content="co-cache" />
<title>Article Detail</title>
<link type="text/css" href="${contextPath}/css/layout.css" rel="stylesheet" />
<link type="text/css" href="${contextPath}/js/dhtmlx/skins/${sysConf['dhtmlx.skin']}/dhtmlx.css" rel="stylesheet" />
<style type="text/css">
.dhxwins_vp_dhx_terrace {overflow: auto;}
.dhxwins_vp_dhx_terrace div.dhxwin_active div.dhx_cell_wins div.dhx_cell_toolbar_def, .dhxwins_vp_dhx_terrace div.dhxwin_inactive div.dhx_cell_wins div.dhx_cell_toolbar_def { padding: 10px 0px 0; }
.dhx_toolbar_dhx_terrace { padding: 0 0px; }
table {font-size: 12px;}
</style>
</head>
<body style="background: none;padding-left: 20px;width: 1002px;" class="dhxwins_vp_dhx_terrace">
<div class="title_box">
	<h3>논문정보</h3>
</div>
<div class="contents_box" style="width:887px;">
<table class="write_tbl mgb_10">
	<colgroup>
		<col style="width:150px;" />
		<col style="" />
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code='art.title.org'/></th>
			<td>${fn:escapeXml(article.orgLangPprNm)}</td>
		</tr>
		<tr>
			<th><spring:message code='art.authors'/></th>
			<td>${fn:escapeXml(article.authors)}</td>
		</tr>
		<tr>
			<th><spring:message code='art.keyword'/></th>
			<td>${article.keyword}</td>
		</tr>
		<tr>
			<th><spring:message code='art.pblc.ym'/></th>
			<td><ui:dateformat value="${article.pblcYm}" pattern="yyyy.MM.dd" /></td>
		</tr>
		<tr>
			<th><spring:message code='art.pblc.plc'/></th>
			<td>${article.pblcPlcNm}</td>
		</tr>
		<tr>
			<th>Ciatiton</th>
			<td>
				${article.scjnlNm}, v.${article.volume}, no.${article.issue}, pp.${article.sttPage}~${article.endPage}
			</td>
		</tr>
		<tr>
			<th>Times Cited</th>
			<td>
				<div class="tbl_num_box" style="text-align: left;">
					<c:if test="${not empty article.idSci and article.idSci != ''}">
					WOS&nbsp;:&nbsp;<span id="sciTcSpan">${empty article.tc ? '0' : article.tc}</span>&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;
					</c:if>
					<c:if test="${not empty article.idScopus and article.idScopus != ''}">
					SCOPUS&nbsp;:&nbsp;<span id="scpTcSpan" style="background-color: #808080;">${article.scpTc}</span>&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;
					</c:if>
				</div>
			</td>
		</tr>
		<tr>
			<th><spring:message code='art.abst'/></th>
			<td>${article.abstCntn}</td>
		</tr>
		<tr>
			<th><spring:message code='art.issn.no'/></th>
			<td>${article.issnNo}</td>
		</tr>
		<tr>
			<th>DOI</th>
			<td>
				<c:if test="${not empty article.doi}">
				<div class="r_add_bt"><a href="http://dx.doi.org/${article.doi}" target="_blank">http://dx.doi.org/${article.doi}</a>
					<a href="http://dx.doi.org/${article.doi}" class="tbl_icon_a tbl_link_icon" target="_blank">링크</a>
				</div>
			 	</c:if>
			</td>
		</tr>
	</tbody>
</table>
</div>
</body>
</html>