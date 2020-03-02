<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../gridInit.jsp" %>
<?xml version="1.0" encoding="UTF-8"?>
<rows>
<c:if test="${not empty resAreaList}">
	<c:forEach items="${resAreaList}" var="ral" varStatus="idx">
		<row id="${ral.codeValue}_${ral.codeDisp}">
			<cell>${ral.codeDisp}</cell>
		</row>
	</c:forEach>
</c:if>
<c:if test="${ empty resAreaList}">
	<row>
		<cell style="text-align: center;">No Results. Try Again!</cell>
	</row>
</c:if>
</rows>