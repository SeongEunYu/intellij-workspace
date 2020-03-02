<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows total_count="${totalCount}" pos="${posStart}">
<c:if test="${not empty syncHistList}">
	<c:forEach items="${syncHistList}" var="sh" varStatus="idx">
		<row id='${sh.seqNo}'>
			<cell>${idx.count}</cell>
			<cell>${sh.syncType}</cell>
			<cell>${rims:codeValue('sync.target', sh.syncTarget)}</cell>
			<cell>${rims:toDateFormatToken(sh.stdrDate,'-')}</cell>
			<cell><fmt:formatDate value="${sh.syncStart}" pattern="yyyy-MM-dd"/></cell>
			<cell><fmt:formatDate value="${sh.syncEnd}" pattern="yyyy-MM-dd"/></cell>
			<cell>${sh.leadTime}</cell>
			<cell><fmt:formatNumber value="${fn:trim(sh.trgtCo)}" type="number" /></cell>
			<cell><fmt:formatNumber value="${fn:trim(sh.insertCo)}" type="number" /></cell>
			<cell><fmt:formatNumber value="${fn:trim(sh.updateCo)}" type="number" /></cell>
			<cell>
				<c:if test="${sh.syncTarget eq 'OFUD' or sh.syncTarget eq 'TFUD' or sh.syncTarget eq 'PUB' }">${sh.syncRm}</c:if>
			</cell>
		</row>
	</c:forEach>
</c:if>
</rows>