<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fn" uri="/WEB-INF/tld/fn.tld" %>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld" %>
<%@ taglib prefix="rims" uri="/WEB-INF/tld/rims.tld" %>
<rows total_count="${totalCount}" pos="${posStart}">
 <c:if test="${not empty codeList}">
	<c:forEach items="${codeList}" var="cl" varStatus="st">

	<row id='${cl.gubun};${cl.codeValue}'>
		<cell>${fn:escapeXml(cl.codeDisp)}</cell>
		<cell>${fn:escapeXml(cl.codeDispEng)}</cell>
	</row>
	</c:forEach>
</c:if>
 <c:if test="${empty codeList}">
	<row id=''>
		<cell>검색된 데이터가 없습니다.</cell>
		<cell></cell>
	</row>
</c:if>
</rows>