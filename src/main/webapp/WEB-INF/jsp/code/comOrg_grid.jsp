<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../gridInit.jsp" %>
<rows total_count="${totalCount}" pos="${posStart}">
	<c:if test="${not empty comOrgAliasList }">
		<c:forEach items="${comOrgAliasList}" var="comOrg" varStatus="idx">
			<row id="${comOrg.id}">
				<cell>${idx.count}</cell>
				<cell>${comOrg.gubun}</cell>
				<cell><![CDATA[${comOrg.orgName}]]></cell>
				<cell><![CDATA[${comOrg.orgAlias}]]></cell>
				<cell><![CDATA[${comOrg.country}]]></cell>
				<cell><c:if test="${empty comOrg.matchCount}">0</c:if><c:if test="${not empty comOrg.matchCount}"><fmt:formatNumber value="${fn:trim(comOrg.matchCount)}" type="number" /></c:if></cell>
				<cell><![CDATA[${comOrg.remark}]]></cell>
				<cell><fmt:formatDate value="${comOrg.modDate}" pattern="yyyy-MM-dd" /></cell>
			</row>
		</c:forEach>
	</c:if>
</rows>
