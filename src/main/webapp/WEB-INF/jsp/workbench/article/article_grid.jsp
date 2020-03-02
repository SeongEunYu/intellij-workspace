<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows total_count="${totalCount}" pos="${posStart}">
<c:if test="${not empty artclList}">
<c:forEach items="${artclList}" var="al" varStatus="st">
	<row id="${fn:escapeXml(al.sourcIdntfcNo)}|${al.articleId}|${al.migCompleted}|${al.sourcDvsnCd}">
		<cell>${posStart + st.count}</cell>
		<cell>${fn:escapeXml(al.sourcIdntfcNo)}</cell>
		<cell>${fn:escapeXml(al.dplctSourcIdntfcNos)}</cell>
		<cell>${fn:escapeXml(al.articleTtl)}</cell>
		<cell>${fn:escapeXml(al.docType)}</cell>
		<cell>${fn:escapeXml(al.authrCount)}</cell>
		<cell>
			<c:choose>
				<c:when test="${fn:escapeXml(al.migCompleted) eq 'P' }">보류</c:when>
				<c:when test="${fn:escapeXml(al.migCompleted) eq 'Y' }">작업완료</c:when>
				<c:when test="${fn:escapeXml(al.migCompleted) eq 'E' }">작업제외</c:when>
				<c:when test="${fn:escapeXml(al.migCompleted) eq 'D' }">중복제외</c:when>
				<c:otherwise>미작업</c:otherwise>
			</c:choose>
		</cell>
		<cell>${fn:escapeXml(al.migCompleted)}</cell>
	</row>
</c:forEach>
</c:if>
<c:if test="${empty artclList}">
	<row id="0">
		<cell colspan="7">No Results. Try Again!</cell>
	</row>
</c:if>
</rows>