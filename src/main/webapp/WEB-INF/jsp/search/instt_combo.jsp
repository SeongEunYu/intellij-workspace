<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../gridInit.jsp" %>
<complete>
	<c:forEach items="${coInsttList}" var="cl" varStatus="st">
		<option value="${fn:escapeXml(cl.insttname)}"><![CDATA[${fn:escapeXml(cl.insttname)}]]></option>
	</c:forEach>
</complete>
