<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../gridInit.jsp" %>
<complete>
	<c:forEach items="${orgNameList}" var="ol" varStatus="st">
		<option value="${fn:escapeXml(ol.orgName)}"><![CDATA[${fn:escapeXml(ol.orgName)}]]></option>
	</c:forEach>
</complete>
