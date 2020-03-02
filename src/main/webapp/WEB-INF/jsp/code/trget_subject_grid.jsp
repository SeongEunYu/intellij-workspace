<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../gridInit.jsp" %>
<rows>
	<c:if test="${not empty trgetSubjectList }">
		<c:forEach items="${trgetSubjectList}" var="ts" varStatus="idx">
			<row id="${ts.id}">
				<cell><c:out value="${ts.catcode}"/></cell>
				<cell><c:out value="${ts.description}"/></cell>
				<cell><c:out value="${param.prodcode}"/></cell>
				<cell><c:out value="${param.srchDeptCode}"/></cell>
				<cell><c:out value="${param.srchDeptKor}"/></cell>
				<cell><c:out value="${ts.id}"/></cell>
			</row>
		</c:forEach>
	</c:if>
</rows>