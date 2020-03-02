<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows>
<c:if test="${not empty historyList}">
<c:forEach items="${historyList}" var="hl" varStatus="st">
	<row id="${hl.id}">
		<cell>${fn:escapeXml(hl.prodyear)}</cell>
		<cell>${fn:escapeXml(hl.sjr)}</cell>
		<cell>${fn:escapeXml(fn:replace(hl.hindex,".0",""))}</cell>
	</row>
</c:forEach>
</c:if>
</rows>