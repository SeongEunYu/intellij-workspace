<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../gridInit.jsp" %>
<rows total_count="${totalCount}" pos="${posStart}">
	<c:if test="${not empty i18nDetailList}">
	<c:forEach items="${i18nDetailList }" var="il" varStatus="idx">
		<row id='${il.code}|${il.language}'>
			<cell>${il.language}</cell>
			<cell>${il.languageName}</cell>
			<cell><![CDATA[${il.code}]]></cell>
			<cell><![CDATA[${il.description}]]></cell>
			<cell><![CDATA[${il.message}]]></cell>
		</row>
	</c:forEach>
	</c:if>
</rows>