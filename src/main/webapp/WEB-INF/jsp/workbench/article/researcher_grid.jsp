<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows total_count="${totalCount}" pos="${posStart}">
<c:if test="${not empty researcherList}">
	<c:forEach items="${researcherList}" var="rl" varStatus="st">
		<row id="${rl.userId}|${rl.authrSeq }">
			<cell>${fn:escapeXml(rl.korNm)}</cell>
			<cell>${fn:escapeXml(rl.engNm)}</cell>
			<cell>${fn:escapeXml(rl.deptKor)}</cell>
			<cell>${fn:escapeXml(rl.aptmDate)}</cell>
			<cell>${fn:escapeXml(rl.userId)}</cell>
		</row>
	</c:forEach>
</c:if></rows>
