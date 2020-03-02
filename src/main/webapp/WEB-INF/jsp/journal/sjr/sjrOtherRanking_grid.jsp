<?xml version="1.0" encoding="UTF-8"?>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fn" uri="/WEB-INF/tld/fn.tld" %>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<rows>
<c:if test="${not empty sjrRankingList}">
<c:forEach items="${sjrRankingList}" var="sl" varStatus="st">
	<row id="${sl.id}">
		<cell>${fn:escapeXml(sl.description)}</cell>
		<cell>${fn:escapeXml(sl.ratio)}</cell>
		<cell>${fn:makeRating("Q", sl.ratio, 25)}</cell>
	</row>
</c:forEach>
</c:if>
</rows>
