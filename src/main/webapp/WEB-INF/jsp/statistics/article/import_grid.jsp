<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows>
<c:if test="${not empty impStatList}">
<c:forEach items="${impStatList}" var="im" varStatus="st">
	<row id="${im.impRegym}">
		<cell>${im.impRegym}</cell>
		<cell>${im.totalCount}</cell>
		<cell>${im.totImpCount}</cell>
		<cell>${im.totDupCount}</cell>
		<cell>${im.totInsCount}</cell>
		<cell>${im.totNCount}</cell>
		<cell>${im.totPCount}</cell>
		<cell>${im.totCCount}</cell>
		<cell>${im.totECount}</cell>
	</row>
</c:forEach>
</c:if>
<c:if test="${empty impStatList}">
	<row id="0">
		<cell colspan="7">No Results. Try Again!</cell>
	</row>
</c:if>
</rows>