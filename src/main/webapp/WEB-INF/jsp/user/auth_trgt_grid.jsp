<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../gridInit.jsp" %>
<rows>
	<c:if test="${not empty trgtUserList}">
	<c:forEach items="${trgtUserList }" var="tul" varStatus="idx">
	<row id='${tul.empId}' >
		<cell id="identity">${tul.empId}</cell>
		<cell>${fn:escapeXml(tul.korNm)}</cell>
		<cell>${fn:escapeXml(tul.deptKor)}</cell>
		<cell>${fn:escapeXml(tul.posiNm)}</cell>
		<cell>${fn:escapeXml(tul.emailAddr)}</cell>
	</row>
	</c:forEach>
	</c:if>
	<c:if test="${empty trgtUserList}">
		<row>
			<cell colspan="5">No Result. Try Again!!</cell>
		</row>
	</c:if>
</rows>