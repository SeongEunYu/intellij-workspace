<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows total_count="${totalCount}" pos="${posStart}">
<c:if test="${not empty sjrTitlesList}">
<c:forEach items="${sjrTitlesList}" var="tl" varStatus="st">
	<row id="${tl.id}">
		<cell>${st.count}</cell>
		<cell>${fn:escapeXml(tl.prodyear)}</cell>
		<cell>${fn:escapeXml(tl.title)}</cell>
		<cell>${fn:escapeXml(tl.issn)}</cell>
		<cell>${fn:escapeXml(tl.sjr)}</cell>
		<cell>${fn:escapeXml(tl.hindex)}</cell>
		<cell>${fn:escapeXml(tl.totalDocs)}</cell>
		<cell>${fn:escapeXml(tl.ttlRfs)}</cell>
		<cell>${fn:escapeXml(tl.refDoc)}</cell>
		<cell>${fn:escapeXml(tl.country)}</cell>
	</row>
</c:forEach>
</c:if>
</rows>