<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows total_count="${totalCount}" pos="${posStart}">
	<c:if test="${not empty techtransList}">
		<c:forEach items="${techtransList}" var="tl" varStatus="st">
			<row id='${tl.userId}_${tl.techtransId}'>
				<cell>${posStart + st.count}</cell>
				<c:if test="${not gSessMode and sessionScope.auth.adminDvsCd ne 'R' and sessionScope.auth.adminDvsCd ne 'S' }">
					<cell>${tl.techtransId}</cell>
					<cell><c:out value="${rims:toDateFormatToken(tl.techTransrYm,'.')}"/></cell>
					<cell><c:out value="${fn:escapeXml(tl.techTransrNm)}"/></cell>
					<cell><c:out value="${fn:escapeXml(tl.techTransrCorpNm)}"/></cell>
					<cell>${rims:codeValue('1400',tl.apprDvsCd)}</cell>
					<cell><fmt:formatDate value="${tl.modDate}" pattern="yyyy.MM.dd" /></cell>
					<cell><c:out value="${tl.src == null ? '직접입력' : tl.src}"/></cell>
					<cell>${tl.delDvsCd eq 'Y' ? 'Y' : 'N'}</cell>
				</c:if>
				<c:if test="${gSessMode or (sessionScope.auth.adminDvsCd eq 'R' or sessionScope.auth.adminDvsCd eq 'S')}">
					<cell>${tl.techtransId}</cell>
					<cell><c:out value="${rims:toDateFormatToken(tl.techTransrYm,'.')}"/></cell>
					<cell><c:out value="${fn:escapeXml(tl.techTransrNm)}"/></cell>
					<cell><c:out value="${fn:escapeXml(tl.techTransrCorpNm)}"/></cell>
					<cell>${rims:codeValue('1400',tl.apprDvsCd)}</cell>
				</c:if>
			</row>
		</c:forEach>
	</c:if>
</rows>