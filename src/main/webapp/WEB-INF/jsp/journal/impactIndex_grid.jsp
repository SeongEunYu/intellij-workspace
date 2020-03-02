<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../gridInit.jsp" %>
<rows>
<c:if test="${not empty impactIndexList}">
<c:forEach items="${impactIndexList}" var="impact" varStatus="st">
	<row id="${impact.sn}">
		<cell>${fn:escapeXml(impact.prodyear)}</cell>
		<cell>${fn:escapeXml(impact.indexValue)}</cell>
	</row>
</c:forEach>
</c:if>
<c:if test="${empty impactIndexList}">
	<row>
		<cell colspan="3">No Results. Try Again!</cell>
	</row>
</c:if>
</rows>
