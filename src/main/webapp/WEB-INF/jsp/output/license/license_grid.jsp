<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows total_count="${totalCount}" pos="${posStart}">
	 <c:if test="${not empty licenseList}">
	 	<c:forEach items="${licenseList}" var="ll" varStatus="st">
		 <row id="${ll.userId}_${ll.licenseId}">
			<cell>${posStart + st.count}</cell>
			<c:if test="${not gSessMode and sessionScope.auth.adminDvsCd ne 'R' and sessionScope.auth.adminDvsCd ne 'S' }">
				<cell>${ll.licenseId}</cell>
				<cell><c:out value="${ll.userId}"/></cell>
				<cell><c:out value="${ll.korNm}"/></cell>
				<cell><c:out value="${rims:toDateFormatToken(ll.qlfAcqsYm,'.')}"/></cell>
				<cell><c:out value="${fn:escapeXml(ll.crQfcNm)}"/></cell>
				<cell><c:out value="${fn:escapeXml(ll.qlfGrntAgcNm)}"/></cell>
				<cell><c:out value="${empty ll.delDvsCd ? 'N' : ll.delDvsCd}"/></cell>
			</c:if>
			<c:if test="${gSessMode or (sessionScope.auth.adminDvsCd eq 'R' or sessionScope.auth.adminDvsCd eq 'S')}">
				<cell>${ll.licenseId}</cell>
				<cell><c:out value="${rims:toDateFormatToken(ll.qlfAcqsYm,'.')}"/></cell>
				<cell><c:out value="${fn:escapeXml(ll.crQfcNm)}"/></cell>
				<cell><c:out value="${fn:escapeXml(ll.qlfGrntAgcNm)}"/></cell>
			</c:if>
				<cell><c:out value="${empty ll.src and al.src eq 'USER' ? '직접입력' : ll.src}"/></cell>
		 </row>
	 	</c:forEach>
	 </c:if>
</rows>