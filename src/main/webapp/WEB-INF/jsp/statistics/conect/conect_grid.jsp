<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows>
<c:if test="${not empty loginStatusList}">
	<c:forEach items="${loginStatusList}" var="lsl" varStatus="st">
		<row id="${lsl.conectrId}">
			<cell>${lsl.rsrchUserId}</cell>
			<cell>${lsl.rsrchUserNm}</cell>
			<cell>
				<c:choose>
					<c:when test="${lsl.rsrchUserHldofYn eq '1'}">재직</c:when>
					<c:when test="${lsl.rsrchUserHldofYn eq '2'}">퇴직</c:when>
					<c:otherwise>미입력</c:otherwise>
				</c:choose>
			</cell>
			<cell>${lsl.rsrchUserSclpst}</cell>
			<cell>${lsl.conectrId}</cell>
			<cell>${lsl.conectrNm}</cell>
			<cell>${lsl.loginCo}</cell>
			<cell>
				<c:choose>
					<c:when test="${lsl.conectrAuthorCd eq 'R'}">연구자</c:when>
					<c:when test="${lsl.conectrAuthorCd eq 'S'}">대리입력자</c:when>
				</c:choose>
			</cell>
		</row>
	</c:forEach>
</c:if>
</rows>