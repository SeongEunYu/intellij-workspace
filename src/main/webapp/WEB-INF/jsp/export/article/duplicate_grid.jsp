<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows total_count="${totalCount}" pos="${posStart}">
<c:if test="${not empty dplctArticleList}">
	<c:forEach items="${dplctArticleList}" var="al" varStatus="st">
		<row id="${fn:escapeXml(al.sourcIdntfcNo)}|${fn:escapeXml(al.gubun)}">
			<cell>0</cell>
			<cell>${fn:escapeXml(al.sourcIdntfcNo)}</cell>
			<cell>${fn:escapeXml(al.articleTtl)}</cell>
			<cell>${fn:escapeXml(al.plscmpnNm)}</cell>
			<cell>${fn:escapeXml(al.issn)}</cell>
			<cell>${fn:escapeXml(al.vlm)}</cell>
			<cell>${fn:escapeXml(al.beginPage)}</cell>
			<cell>${fn:escapeXml(al.dplctSourcIdntfcNo)}</cell>
		</row>
	</c:forEach>
</c:if>
</rows>