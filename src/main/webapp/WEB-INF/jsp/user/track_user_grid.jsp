<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../gridInit.jsp" %>

<rows>
	<c:if test="${not empty trackUserList }">
		<c:forEach items="${trackUserList}" var="user" varStatus="idx">
			<row id="${user.trackId};${user.id}">
				<cell>${idx.count}</cell>
				<cell>${user.userId}</cell>
				<cell>${user.userName}</cell>
				<cell>${user.dept}</cell>
			</row>
		</c:forEach>
	</c:if>
</rows>