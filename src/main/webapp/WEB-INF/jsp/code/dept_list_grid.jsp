<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../gridInit.jsp" %>

<rows>
	<c:if test="${not empty deptList }">
		<c:forEach items="${deptList}" var="dl" varStatus="idx">
			<row id="${dl.deptCode}">
				<cell>${idx.count}</cell>
				<cell>${dl.deptKor}</cell>
				<cell>${dl.deptCode}</cell>
				<cell></cell>
			</row>
		</c:forEach>
	</c:if>
</rows>