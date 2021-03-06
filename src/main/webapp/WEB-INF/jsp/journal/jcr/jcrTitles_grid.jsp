<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows total_count="${totalCount}" pos="${posStart}">
<c:if test="${not empty jcrTitlesList}">
<c:forEach items="${jcrTitlesList}" var="tl" varStatus="st">
	<row id="${tl.id}">
		<cell>${fn:escapeXml(tl.id)}</cell>
		<cell>${fn:escapeXml(tl.prodyear)}</cell>
		<cell>${fn:escapeXml(tl.title20)}</cell>
		<cell>${fn:escapeXml(tl.title)}</cell>
		<cell>${fn:escapeXml(tl.issn)}</cell>
		<cell><fmt:formatNumber value="${tl.totalcites}" maxFractionDigits="3" /></cell>
		<cell>${fn:escapeXml(tl.impact)}</cell>
		<cell>${fn:escapeXml(tl.prodedition)}</cell>
	</row>
</c:forEach>
</c:if>
<c:if test="${empty jcrTitlesList }">
	<row>
		<cell colspan="7">No Results. Try Again!</cell>
	</row>
</c:if>
</rows>
