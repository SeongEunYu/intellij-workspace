<?xml version="1.0" encoding="UTF-8"?>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fn" uri="/WEB-INF/tld/fn.tld" %>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<rows total_count="${totalCount}" pos="${posStart}">
<c:if test="${not empty sjrRankingList}">
<c:forEach items="${sjrRankingList}" var="sl" varStatus="st">
	<row id="${sl.id}">
		<cell>${fn:escapeXml(sl.prodyear)}</cell>
		<cell>${fn:escapeXml(sl.title)}</cell>
		<cell>${fn:escapeXml(sl.issn)}</cell>
		<cell>${fn:escapeXml(sl.description)}</cell>
		<cell>${fn:escapeXml(sl.sjr)}</cell>
		<cell>${fn:escapeXml(sl.ratio)}</cell>
	</row>
</c:forEach>
</c:if>
</rows>
