<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows>
<c:if test="${not empty subjectList}">
<c:forEach items="${subjectList}" var="sl" varStatus="st">
	<row id="${sl.categ}">
		<cell>${fn:escapeXml(sl.categ)}</cell>
		<cell>${fn:escapeXml(sl.upCatname)}  >  ${fn:escapeXml(sl.description)}</cell>
	</row>
</c:forEach>
</c:if>
</rows>
