<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows>
<c:if test="${not empty partiList}">
	<c:forEach items="${partiList}" var="pl" varStatus="idx">
		<row id='${pl.prtcpntNm}'>
			<cell>${pl.prtcpntId}</cell>
			<cell>${fn:escapeXml(pl.prtcpntNm)}</cell>
			<cell>${fn:escapeXml(pl.prtcpntEngNm)}</cell>
			<cell>${pl.deptKor}</cell>
		</row>
	</c:forEach>
</c:if>
<c:if test="${empty  partiList}">
		<row id="0">
				<cell colspan="4">No Results. Try Again!</cell>
		</row>
</c:if>
</rows>