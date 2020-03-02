<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows total_count="${fn:length(fieldVoList)}">
<c:if test="${not empty fieldVoList}">
<c:forEach items="${fieldVoList}" var="fieldVo" varStatus="st">
	<row id="${fieldVo.sn}:${fileId}">
		<cell>${st.count}</cell>
		<cell>${fn:escapeXml(fieldVo.rschField)}</cell>
		<cell>${fn:escapeXml(fieldVo.paperCo)}</cell>
		<cell>${fn:escapeXml(fieldVo.tc)}</cell>
		<cell>${fn:escapeXml(fieldVo.tcPerPaper)}</cell>
		<cell>${fn:escapeXml(fieldVo.topPaperCo)}</cell>
	</row>
</c:forEach>
</c:if>
</rows>