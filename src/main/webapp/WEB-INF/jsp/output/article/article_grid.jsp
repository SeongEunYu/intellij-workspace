<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows total_count="${totalCount}" pos="${posStart}">
	 <c:if test="${not empty articleList}">
		<c:forEach items="${articleList}" var="al" varStatus="st">
			<c:set var="apprDvsCd"  value="${empty al.apprDvsCd ? '1' : al.apprDvsCd}"/>
			<row id='admin_${al.articleId}_<c:out value="${param.appr}"/>_N' <c:if test="${al.recordStatus eq '0'}">class="appr"</c:if>>
				<cell>${posStart + st.count}</cell>
				<c:if test="${not gSessMode and sessionScope.auth.adminDvsCd ne 'R' and sessionScope.auth.adminDvsCd ne 'S' }">
					<cell>${al.articleId }</cell>
					<cell>${rims:codeValue('1100',al.scjnlDvsCd)}</cell>
					<cell><c:out value="${rims:toDateFormatToken(al.pblcYm, '.')}"/></cell>
					<cell><c:out value="${fn:escapeXml(al.orgLangPprNm)}"/></cell>
					<cell><c:out value="${fn:escapeXml(al.scjnlNm)}"/></cell>
					<%--
					<cell><%=StringUtils.defaultString(code1420.get(ObjectUtils.toString(articleList.get(i).get("VRFC_DVS_CD"))))</cell>
					--%>
					<cell><c:out value="${al.idSci}"/></cell>
					<cell><c:out value="${al.idScopus}"/></cell>
					<cell><c:out value="${al.idKci}"/></cell>
					<cell><c:out value="${al.doi}"/></cell>
					<cell><c:out value="${al.authorCo}"/></cell>
					<cell>${rims:codeValue('1420',al.vrfcDvsCd)}</cell>
					<cell>${rims:codeValue('art.appr.dvs',apprDvsCd)}</cell>
					<cell><fmt:formatDate value="${al.modDate}" pattern="yyyy-MM-dd" /></cell>
					<cell>${al.delDvsCd eq 'Y' ? 'Y' : 'N'}</cell>
					<cell>${not empty al.postFileId ? 'Y' : 'N' }</cell>
					<cell>${not empty al.pubFileId ? 'Y' : 'N' }</cell>
				</c:if>
				<c:if test="${gSessMode or (sessionScope.auth.adminDvsCd eq 'R' or sessionScope.auth.adminDvsCd eq 'S')}">
					<cell>${al.articleId }</cell>
					<cell><c:out value="${rims:toDateFormatToken(al.pblcYm, '.')}"/></cell>
					<cell><c:out value="${fn:escapeXml(al.orgLangPprNm)}"/></cell>
					<cell><c:out value="${fn:escapeXml(al.scjnlNm)}"/></cell>
					<cell><c:out value="${al.isReprsntArticle}"/></cell>
					<cell>${not empty al.recordStatus and al.recordStatus eq '1' ? 'Y' : 'N'}</cell>
					<cell>${al.fundingCo!=0 or al.relateFundingAt=='N' ? 'Y' : 'N'}</cell>
					<cell>${rims:codeValue('art.appr.dvs', apprDvsCd)}</cell>
					<cell>${not empty al.postFileId or not empty al.pubFileId ? 'Y' : 'N'}</cell>
				</c:if>
			</row>
		</c:forEach>
	 </c:if>
</rows>
