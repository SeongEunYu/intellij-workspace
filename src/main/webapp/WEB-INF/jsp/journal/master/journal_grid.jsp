<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows total_count="${totalCount}" pos="${posStart}">
	<c:if test="${not empty journalList}">
	<c:forEach items="${journalList}" var="tl" varStatus="st">
		<row id="${tl.jrnlId}">
			<cell>${fn:escapeXml(tl.jrnlId)}</cell>
			<cell>${fn:escapeXml(tl.title)}</cell>
			<cell>${fn:escapeXml(tl.frequency)}</cell>
			<cell>${fn:escapeXml(tl.issn)}</cell>
			<cell>${fn:escapeXml(tl.sci)}</cell>
			<cell>${fn:escapeXml(tl.scie)}</cell>
			<cell>${fn:escapeXml(tl.ssci)}</cell>
			<cell>${fn:escapeXml(tl.ahci)}</cell>
			<cell>${fn:escapeXml(tl.scopus)}</cell>
			<cell>${fn:escapeXml(tl.kci)}</cell>
			<cell>${fn:escapeXml(tl.kciGubun)}</cell>
			<cell>${fn:escapeXml(tl.puWos)}</cell>
			<cell>${fn:escapeXml(tl.puScopus)}</cell>
			<cell>${fn:escapeXml(tl.puKci)}</cell>
			<cell>${fn:escapeXml(tl.pc)}</cell>
		</row>
	</c:forEach>
	</c:if>
</rows>