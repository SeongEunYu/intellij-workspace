<?xml version="1.0" encoding="UTF-8"?>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<results>
	<result>
		<code><c:out value="${code}"></c:out></code>
		<msg><c:out value="${msg}"></c:out></msg>
		<rowId><c:out value="${rowId}"></c:out></rowId>
	</result>
</results>