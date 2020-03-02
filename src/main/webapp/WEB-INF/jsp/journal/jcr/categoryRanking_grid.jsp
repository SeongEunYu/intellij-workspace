<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows>
<c:if test="${not empty historyList}">
<c:forEach items="${historyList}" var="hl" varStatus="st">
	<row id="${st.index}">
		<cell>${fn:escapeXml(hl.catname)}</cell>
		<cell>${fn:escapeXml(hl.ratio)}</cell>
		<cell>${fn:makeRating("Q", hl.ratio, 25)}</cell>
	</row>
</c:forEach>
</c:if>
</rows>