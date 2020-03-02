<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows>
<c:if test="${not empty historyList}">
<c:forEach items="${historyList}" var="hl" varStatus="st">
	<row id="${hl.id}">
		<cell>${fn:escapeXml(hl.prodyear)}</cell>
		<cell><fmt:formatNumber value="${hl.totalcites}" maxFractionDigits="3" /></cell>
		<cell>${fn:escapeXml(hl.impact)}</cell>
	</row>
</c:forEach>
</c:if>
</rows>