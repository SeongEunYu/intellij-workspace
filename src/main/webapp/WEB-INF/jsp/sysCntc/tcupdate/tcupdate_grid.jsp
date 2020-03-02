<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows total_count="${totalCount}" pos="${posStart}">
<c:if test="${not empty histMasterList}">
	<c:forEach items="${histMasterList}" var="hl" varStatus="idx">
		<row id='${hl.histSeq}'>
			<cell>${idx.count}</cell>
			<cell>${hl.description}</cell>
			<cell>
				<c:if test="${hl.sourcDvsnCd eq 'WOS' }">WOS</c:if>
				<c:if test="${hl.sourcDvsnCd eq 'SCP' }">Scopus</c:if>
				<c:if test="${hl.sourcDvsnCd eq 'KCI' }">KCI</c:if>
			</cell>
			<cell>${fn:escapeXml(hl.workType)}</cell>
			<cell>
				<fmt:formatDate value="${hl.workStart}" var="workStart" pattern="yyyy-MM-dd"/>${workStart}
			</cell>
			<cell>
				<fmt:formatDate value="${hl.workEnd}" var="workEnd" pattern="yyyy-MM-dd"/>${workEnd}
			</cell>
			<cell>${hl.leadTime}</cell>
			<cell><fmt:formatNumber value="${fn:trim(hl.trgtCnt)}" type="number" /></cell>
			<cell><fmt:formatNumber value="${fn:trim(hl.workedCnt)}" type="number" /></cell>
			<cell><fmt:formatNumber value="${fn:trim(hl.errorCnt)}" type="number" /></cell>
			<cell>
				<c:if test="${hl.status eq '1' }">작업대기</c:if>
				<c:if test="${hl.status eq '2' }">작업중</c:if>
				<c:if test="${hl.status eq '3' }">에러</c:if>
				<c:if test="${hl.status eq '9' }">완료</c:if>
			</cell>
			<cell>${fn:escapeXml(hl.error)}</cell>
		</row>
	</c:forEach>
</c:if>
</rows>