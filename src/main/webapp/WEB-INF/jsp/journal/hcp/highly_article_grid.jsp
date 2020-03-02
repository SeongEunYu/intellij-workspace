<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows total_count="${fn:length(highlyCitedPaperVoList)}">
<c:if test="${not empty highlyCitedPaperVoList}">
<c:forEach items="${highlyCitedPaperVoList}" var="paperVo" varStatus="st">
	<row id="${paperVo.idSci}_${paperVo.articleId}">
		<cell>${st.count}</cell>
		<cell>${fn:escapeXml(paperVo.articleId)}</cell>
		<cell>${fn:escapeXml(paperVo.idSci)}</cell>
		<cell>${fn:escapeXml(paperVo.orgLangPprNm)}</cell>
		<cell>${fn:escapeXml(paperVo.tc)}</cell>
		<cell>${fn:escapeXml(paperVo.pubDate)}</cell>
	</row>
</c:forEach>
</c:if>
</rows>