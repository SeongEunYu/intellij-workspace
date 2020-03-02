<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows total_count="${totalCount}" pos="${posStart}">
<c:if test="${not empty jcrRankingList}">
<c:forEach items="${jcrRankingList}" var="rl" varStatus="st">
	<row id="${rl.id}_${rl.issn}">
		<cell>${fn:escapeXml(rl.prodyear)}</cell>
		<cell>${fn:escapeXml(rl.title)}</cell>
		<cell>${fn:escapeXml(rl.issn)}</cell>
		<cell>${fn:escapeXml(rl.description)}</cell>
		<cell>${fn:escapeXml(rl.impact)}</cell>
		<cell>${fn:escapeXml(rl.ratio)}</cell>
	</row>
</c:forEach>
</c:if>
<c:if test="${empty jcrRankingList }">
	<row id="0">
		<cell colspan="5">No Results. Try Again!</cell>
	</row>
</c:if>
</rows>
