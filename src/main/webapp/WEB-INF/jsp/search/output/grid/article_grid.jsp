<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../../gridInit.jsp" %>
<rows total_count="${totalCount}" pos="${posStart}">
<c:if test="${not empty articleList}">
<c:forEach items="${articleList}" var="al" varStatus="st">
	<row id='admin_${al.articleId}_<c:out value="${param.appr}"/>_N' <c:if test="${al.recordStatus eq '0'}">class="appr"</c:if>>
		<cell>${st.count}</cell>
		<cell>${fn:escapeXml(al.orgLangPprNm)}</cell>
		<cell>${fn:escapeXml(al.scjnlNm)}</cell>
		<cell>${fn:escapeXml(al.keyword)}</cell>
		<cell>${rims:toDateFormatToken(al.pblcYm, '.')}</cell>
	</row>
</c:forEach>
</c:if>
</rows>
