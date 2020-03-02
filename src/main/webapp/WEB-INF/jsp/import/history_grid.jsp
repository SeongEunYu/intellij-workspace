<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../gridInit.jsp" %>
<rows total_count="${totalCount}" pos="${posStart}">
<c:if test="${not empty rdHistoryList}">
<c:forEach items="${rdHistoryList}" var="rhl" varStatus="st">
	<row id="${rhl.id}">
		<cell id="historyId">${rhl.id}</cell>
		<cell id="format">
		  <c:choose>
			<c:when test="${rhl.format eq 'PLN' }" >Plain Text</c:when>
			<c:when test="${rhl.format eq 'TAB' }" >Tab-delimited </c:when>
			<c:when test="${rhl.format eq 'CSV' }" >CSV</c:when>
			<c:when test="${rhl.format eq 'XML' }" >XML</c:when>
		  	<c:otherwise>${fn:escapeXml(rhl.format)}</c:otherwise>
		  </c:choose>
		</cell>
		<cell id="title">${fn:escapeXml(rhl.title)}</cell>
		<cell id="query">${fn:escapeXml(rhl.query)}</cell>
		<cell id="totCount">${fn:escapeXml(rhl.totCount)}</cell>
		<cell id="dupCount">${fn:escapeXml(rhl.dupCount)}</cell>
		<cell id="errCount">${fn:escapeXml(rhl.errCount)}</cell>
		<cell id="insCount">${fn:escapeXml(rhl.insCount)}</cell>
		<cell id="regdate"><fmt:formatDate value="${rhl.regdate}" var="regdate" pattern="yyyy-MM-dd"/>${regdate}</cell>
		<cell id="status">
			<c:if test="${rhl.status eq '1' }">대기</c:if>
			<c:if test="${rhl.status eq '2' }">반입중</c:if>
			<c:if test="${rhl.status eq '9' }">완료</c:if>
		</cell>
		<cell id="errorLog" style="color:red;">${fn:escapeXml(rhl.errorLog)}</cell>
	</row>
</c:forEach>
</c:if>
<c:if test="${empty rdHistoryList}">
	<row id="0">
			<cell colspan="10" style="text-align:center;">No Results. Try Again!</cell>
	</row>
</c:if>
</rows>