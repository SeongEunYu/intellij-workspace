<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../gridInit.jsp" %>
<rows>
	<c:if test="${not empty sitterList}">
	<c:forEach items="${sitterList }" var="sl" varStatus="idx">
	<row id='${sl.empNo}' >
		<cell id="identity">${sl.empNo}</cell>
		<cell>${fn:escapeXml(sl.empKorNm)}</cell>
		<cell>${fn:escapeXml(sl.deptKorNm)}</cell>
		<cell>${fn:escapeXml(sl.clsfNm)}</cell>
		<cell>${fn:escapeXml(sl.emailAdres)}</cell>
	</row>
	</c:forEach>
	</c:if>
	<c:if test="${empty sitterList}">
		<row>
			<cell colspan="5">No Result. Try Again!!</cell>
		</row>
	</c:if>
</rows>