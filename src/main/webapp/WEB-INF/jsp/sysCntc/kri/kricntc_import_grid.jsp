<?xml version="1.0" encoding="UTF-8"?>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fn" uri="/WEB-INF/tld/fn.tld" %>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<rows total_count="${totalCount}" pos="${posStart}">
<c:if test="${not empty nrkdd505List}">
<c:forEach items="${nrkdd505List}" var="al" varStatus="st">
	<row id="${al.mngNo}">
		<cell>${posStart + st.count}</cell>
		<cell>${fn:escapeXml(al.pblcYm)}</cell>
		<cell>${fn:escapeXml(al.orgLangPprNm)}</cell>
		<cell>${fn:escapeXml(al.scjnlNm)}</cell>
		<cell>${fn:escapeXml(al.prtcpntId)}</cell>
		<cell>${fn:escapeXml(al.korNm)}</cell>
		<cell></cell>
	</row>
</c:forEach>
</c:if>
</rows>