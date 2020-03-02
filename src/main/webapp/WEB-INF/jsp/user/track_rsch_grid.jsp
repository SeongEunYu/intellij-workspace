<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../gridInit.jsp" %>

<rows total_count="${totalCount}" pos="${posStart}">
	<c:if test="${not empty researcherList }">
		<c:forEach items="${researcherList}" var="rsch" varStatus="idx">
			<row id="${trackId};${rsch.userId}">
				<cell></cell>
				<cell>${rsch.userId}</cell>
				<cell>${rsch.korNm}</cell>
				<cell>${rsch.deptKor}</cell>
			</row>
		</c:forEach>
	</c:if>
</rows>