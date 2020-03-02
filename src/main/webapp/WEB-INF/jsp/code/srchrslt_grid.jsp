<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../gridInit.jsp" %>
<?xml version="1.0" encoding="UTF-8"?>
<rows>
<c:if test="${not empty codeList}">
	<c:forEach items="${codeList}" var="cl" varStatus="idx">
		<row id="${cl.codeValue}_${cl.codeDisp}">
			<cell>${cl.codeDisp}</cell>
		</row>
	</c:forEach>
</c:if>
<c:if test="${ empty codeList}">
	<row>
		<cell style="text-align: center;">No Results. Try Again!</cell>
	</row>
</c:if>
</rows>