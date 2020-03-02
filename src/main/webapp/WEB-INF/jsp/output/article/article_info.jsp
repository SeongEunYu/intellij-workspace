<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@	page import="kr.co.argonet.r2rims.util.StringUtil"%><%@
    page import="org.apache.commons.lang3.ObjectUtils"%><%@
    page import="kr.co.argonet.r2rims.util.LanguageUtil"%><%@
    page import="org.apache.commons.lang3.StringUtils"%><%@
    page import="java.util.Map"%><%@
    page import="java.util.HashMap"%><%@
    page import="java.util.List"%><%@
    page import="java.util.ArrayList"%><%@
    page import="kr.co.argonet.r2rims.core.code.CodeConfiguration"%><%
	String contextPath = application.getInitParameter("contextPath");
	Map<String, String> code1100 = CodeConfiguration.getCode("1100");
    Map<String, String> code1180 = CodeConfiguration.getCode("1180");	// 참여구분코드
	Map<String, String> code1380 = CodeConfiguration.getCode("1380");
    Map<String, String> code1390 = CodeConfiguration.getCode("1390");
    Map<String, String> code1400 = CodeConfiguration.getCode("1400");	// 승인구분코드
	Map<String, String> code1420 = CodeConfiguration.getCode("1420");	// 검증구분코드
	Map<String, String> code2000 = CodeConfiguration.getCode("2000");	// 국가코드
	Map<String, String> code2020 = CodeConfiguration.getCode("2020");
	Map<String, String> code2040 = CodeConfiguration.getCode("2040");	// 연구분야분류코드
	Map<String, String> code4001 = CodeConfiguration.getCode("4001");
%>
<%@include file="../../pageInit.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
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

<body style="background: none;padding-left: 20px;width: 1002px;" style="overflow-y: auto;">
<div class="title_box">
	<h3>Article 상세</h3>
</div>
<div class="contents_box" style="width:1002px;">
<table class="write_tbl mgb_10">
	<colgroup>
		<col style="width:150px;" />
		<col style="width:181px;" />
		<col style="width:150px" />
		<col style="width:181px;" />
		<col style="width:150px" />
		<col style="" />
	</colgroup>
	<tbody>
		<c:if test="${sysConf['modifiy.show.mngno'] eq 'Y' and not empty article.mngNo }">
		<tr>
			<th>URP 제어번호</th>
			<td colspan="5">
				${article.mngNo}
				<p class="tbl_addbt_p">URP 시스템과 연계 결과로 생성된 논문 제어번호입니다.</p>
			</td>
		</tr>
		</c:if>
		<tr>
			<th><spring:message code='art.scjnl.dvs.cd'/></th>
			<td>${rims:codeValue('1100',article.scjnlDvsCd)}</td>
	        <th <c:if test="${article.scjnlDvsCd eq 3 or article.scjnlDvsCd eq 4 }" >style="display:none;"</c:if> >
	        	<spring:message code='art.ovrs.exclnc.scjnl'/>
	        </th>
	        <td <c:if test="${article.scjnlDvsCd eq 3 or article.scjnlDvsCd eq 4 }" >style="display:none;"</c:if> >
	        	${rims:codeValue('1380',article.ovrsExclncScjnlPblcYn)}
	        </td>
	        <th <c:if test="${article.scjnlDvsCd ne 3 and article.scjnlDvsCd ne 4 }" >style="display:none;"</c:if> >
	        	<spring:message code='art.krf.reg.pblc'/>
	        </th>
	        <td <c:if test="${article.scjnlDvsCd ne 3 and article.scjnlDvsCd ne 4 }" >style="display:none;"</c:if> >
	        	${rims:codeValue('1390',article.krfRegPblcYn)}
	        </td>
	        <th><spring:message code='art.doc.type.cd'/></th>
	        <td>${article.docType}</td>
		</tr>
		<tr>
			<th><spring:message code='art.scjnl.nm'/></th>
			<td colspan="3">${article.scjnlNm}</td>
			<th><spring:message code='art.issn.no'/></th>
			<td>${article.issnNo}</td>
		</tr>
		<tr>
			<th><spring:message code='art.pblc.plc'/></th>
			<td colspan="3">${article.pblcPlcNm}</td>
			<th><spring:message code='art.pblc.ntn'/></th>
			<td>${rims:codeValue('2000',article.pblcNtnCd)}</td>
		</tr>
		<tr>
			<th><spring:message code='art.pblc.ym'/></th>
			<td colspan="5"><ui:dateformat value="${article.pblcYm}" pattern="yyyy.MM.dd" /></td>
		</tr>
		<tr>
			<th><spring:message code='art.volume'/></th>
			<td>Vol. ${article.volume}</td>
			<th><spring:message code='art.issue'/></th>
			<td>No. ${article.issue}</td>
			<th><spring:message code='art.page'/></th>
			<td>${article.sttPage} - ${article.endPage}
			</td>
		</tr>
		<tr>
			<th><spring:message code='art.pblc.language'/></th>
			<td>${rims:codeValue('2020',article.pprLangDvsCd)}</td>
			<th>ImpactFactor(Official)</th>
			<td>${empty article.impctFctr ? '없음' : article.impctFctr}</td>
			<th>ImpactFactor(Private)</th>
			<td>${fn:escapeXml(article.impctFctrUsr)}</td>
		</tr>
		<tr>
			<th><spring:message code='art.title.org'/></th>
			<td colspan="5">${fn:escapeXml(article.orgLangPprNm)}</td>
		</tr>
		<tr>
			<th><spring:message code='art.title.diff'/></th>
			<td colspan="5">${article.diffLangPprNm}</td>
		</tr>
		<tr>
			<th><spring:message code='art.authors'/></th>
			<td colspan="5">
				<div class="writer_td_inner">
				  <p>전체저자수 : ${article.totalAthrCnt}</p>
				</div>
			</td>
		</tr>
		<tr>
			<td colspan="6" class="inner_tbl_td">
				<table class="inner_tbl" id="prtcpntTbl" style="height: 50px;">
					<colgroup>
						<col style="width:80px;" />
						<col style="width:175px;" />
						<col style="width:190px" />
						<col style="width:150px;" />
						<%--
						<col style="width:170px" />
						 --%>
						<col style="" />
						<col style="width:100px;" />
					</colgroup>
					<thead>
					  <tr>
						<th>No</th>
						<th><spring:message code='art.short.name'/></th>
						<th><spring:message code='art.full.name'/></th>
						<th><spring:message code='art.tpi.dvs'/></th>
						<%--
						<th>개인번호</th>
						 --%>
						<th><spring:message code='art.agc.nm'/></th>
						<th><spring:message code='art.author.dept'/></th>
					  </tr>
					</thead>
					<tbody>
				<c:if test="${not empty article.partiList}">
					<c:forEach items="${article.partiList}" var="parti" varStatus="idx">
						<tr id="prtcpnt${idx.count}" class="prtcpnt">
							<td style="text-align: center;">${idx.count}</td>
							<td style="text-align: center;">${fn:escapeXml(parti.prtcpntNm)}</td>
							<td style="text-align: center;">${fn:escapeXml(parti.prtcpntFullNm)}</td>
							<td style="text-align: center;">${rims:codeValue('1180', parti.tpiDvsCd) }</td>
							<%--
							<td style="text-align: center;">${fn:escapeXml(parti.prtcpntId)}</td>
							 --%>
							<td style="text-align: left;">${fn:escapeXml(parti.blngAgcNm)}</td>
							<td style="text-align: left;">${parti.deptKor}</td>
						</tr>
					</c:forEach>
				</c:if>
					</tbody>
			  </table>
			</td>
		</tr>
		<tr>
			<th><spring:message code='art.author.keyword'/></th>
			<td colspan="5">${article.authorKeyword}</td>
		</tr>
		<tr>
			<th><spring:message code='art.plus.keyword'/></th>
			<td colspan="5">${article.plusKeyword}</td>
		</tr>
		<tr>
			<th>DOI</th>
			<td colspan="5">
				<c:if test="${not empty article.doi}">
					<a href="http://dx.doi.org/${article.doi}" target="_blank">http://dx.doi.org/${article.doi}</a>
				</c:if>
			</td>
		</tr>
		<tr>
			<th>URL</th>
			<td colspan="5">
				<c:if test="${not empty article.url}">
					<a href="${article.url}" target="_blank">${article.url}</a>
				</c:if>
			</td>
		</tr>
		<tr>
			<th>WOS ID</th>
			<td>${article.idSci}</td>
			<th>SCOPUS ID</th>
			<td>${article.idScopus}</td>
			<th>KCI ID</th>
			<td>${article.idKci}</td>
		</tr>
		<tr>
			<th class="add_help"><spring:message code='art.tc'/></th>
			<td colspan="5">
				<div class="tbl_num_box">
					WOS&nbsp;:&nbsp;
					<c:if test="${not empty article.idSci and article.idSci != ''}">
						<span>${article.tc}</span>&nbsp;
						<em><fmt:formatDate var="tcDate" value="${article.tcDate}" pattern="yyyy-MM-dd" />${tcDate}</em>
					</c:if>
					<c:if test="${empty article.idSci}">
						<span>-</span>&nbsp;
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					</c:if>
					SCOPUS&nbsp;:&nbsp;
					<c:if test="${not empty article.idScopus and article.idScopus != ''}">
						<span>${article.scpTc}</span>&nbsp;
						<em><fmt:formatDate var="scpTcDate" value="${article.scpTcDate}" pattern="yyyy-MM-dd" />${scpTcDate}</em>
					</c:if>
					<c:if test="${empty article.idScopus}">
						<span>-</span>&nbsp;
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					</c:if>
					KCI&nbsp;:&nbsp;
					<c:if test="${not empty article.idKci and article.idKci != ''}">
						<span>${article.kciTc}</span>&nbsp;
						<em><fmt:formatDate var="kciTcDate" value="${article.kciTcDate}" pattern="yyyy-MM-dd" />${kciTcDate}</em>
					</c:if>
					<c:if test="${empty article.idKci}">
						<span>-</span>&nbsp;
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					</c:if>
				</div>
			</td>
		</tr>
		<tr>
			<th><spring:message code='art.abst'/></th>
			<td colspan="5">${article.abstCntn}</td>
		</tr>
		<tr>
			<th><spring:message code='art.org.file'/></th>
			<td colspan="5">
				<c:forEach items="${fileData}" var="fd" varStatus="idx">
					<p class="upload_file_text">
						<a href="<c:url value="/servlet/download.do?fileid=${fd.fileId}"/>">${fd.fileNm}</a>&nbsp;&nbsp;
					</p>
				</c:forEach>
			</td>
		</tr>
		<%--
		<tr>
			<th><spring:message code='art.appr.rtrn'/></th>
			<td colspan="5">${article.apprRtrnCnclRsnCntn}</td>
		</tr>
		 --%>
		<tr>
			<th><spring:message code='art.appr.dvs'/></th>
			<td colspan="2">${rims:codeValue('1400',article.apprDvsCd)}</td>
			<th><spring:message code='art.appr.dvs.date'/></th>
			<td colspan="2"><fmt:formatDate var="apprDate" value="${article.apprDate}" pattern="yyyy-MM-dd" />${apprDate}</td>
		</tr>
		<tr>
			<th><spring:message code='common.reg.date'/></th>
			<td colspan="2">
				<fmt:formatDate var="regDate" value="${article.regDate}" pattern="yyyy-MM-dd" /> ${regDate} ( ${empty article.regUserId ? 'ADMIN' : article.regUserId} )
			</td>
			<th><spring:message code='common.mod.date'/></th>
			<td colspan="2">
				<fmt:formatDate var="modDate" value="${article.modDate}" pattern="yyyy-MM-dd" /> ${modDate} ( ${empty article.modUserId ? 'ADMIN' : article.modUserId} )
			</td>
		</tr>
	</tbody>
</table>
</div>
<script type="text/javascript">
	function rawDataLink(url){
		window.open(url,"rawDataWin","height=720px, width=1000px,location=no, resizable =yes,scrollbars=yes");
	}
</script>
</body>
</html>