<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows total_count="${totalCount}" pos="${posStart}">
<c:if test="${not empty patentCntcList}">
	<c:forEach items="${patentCntcList}" var="pl" varStatus="idx">
		<row id='${pl.srcId}'>
			<cell>${posStart + idx.count}</cell>
			<cell>${pl.srcId}</cell>
			<cell>${fn:escapeXml(pl.itlPprRgtNm)}</cell>
			<cell>${fn:escapeXml(pl.applRegNo)}</cell>
			<cell>${pl.applRegDate}</cell>
			<cell>${fn:escapeXml(pl.itlPprRgtRegNo)}</cell>
			<cell>${pl.itlPprRgtRegDate}</cell>
			<cell>${pl.status}</cell>
			<cell>${pl.familyCode}</cell>
			<cell><c:choose>
				<c:when test="${pl.applDvsCd=='1'}">국내</c:when>
				<c:when test="${pl.applDvsCd=='2'}">해외</c:when>
				<c:when test="${pl.applDvsCd=='3'}">PCT</c:when>
				<c:when test="${pl.applDvsCd=='4'}">변경</c:when>
				<c:when test="${pl.applDvsCd=='5'}">분할</c:when>
				<c:when test="${pl.applDvsCd=='6'}">우선권</c:when>
			</c:choose></cell>
			<cell><fmt:formatDate value="${pl.modDate}" pattern="yyyy-MM-dd" /></cell>
			<cell>${pl.patentId}</cell>
			<cell>${pl.delDvsCd}</cell>
		</row>
	</c:forEach>
</c:if>
</rows>