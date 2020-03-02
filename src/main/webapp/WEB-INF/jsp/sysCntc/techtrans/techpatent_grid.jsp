<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows>
<c:if test="${not empty patentList}">
	<c:forEach items="${patentList}" var="pl" varStatus="idx">
		<row id='${pl.caseId}_${pl.pCode}'>
			<cell>${pl.caseId}</cell>
			<cell>${pl.pCode}</cell>
			<cell>${pl.itlPprRgtNm}</cell>
			<cell>${pl.invtNm}</cell>
			<cell>${pl.applRegNo}</cell>
			<cell>${pl.itlPprRgtRegNo}</cell>
		</row>
	</c:forEach>
</c:if>
<c:if test="${empty  patentList}">
		<row id="0">
			<cell colspan="11">No Results.</cell>
		</row>
</c:if>
</rows>