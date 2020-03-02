<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows>
<c:if test="${not empty articleFundingList}">
	<c:forEach items="${articleFundingList}" var="afl" varStatus="st">
		<row id="${afl.rsrchUserId}">
			<cell>${afl.rsrchUserId}</cell>
			<cell>${afl.rsrchUserNm}</cell>
			<cell>
				<c:choose>
					<c:when test="${afl.rsrchUserHldofYn eq '1'}">재직</c:when>
					<c:when test="${afl.rsrchUserHldofYn eq '2'}">퇴직</c:when>
					<c:otherwise>미입력</c:otherwise>
				</c:choose>
			</cell>
			<cell>${afl.rsrchUserSclpst}</cell>
			<cell>${afl.rsrchUserDept}</cell>
			<cell>${afl.articleTotal}</cell>
			<cell>${afl.relateFundingInputCo}</cell>
			<cell>${afl.relateFundingUninputCo}</cell>
			<cell><fmt:parseNumber value="${(afl.relateFundingInputCo/afl.articleTotal)*100}" integerOnly="true" />%</cell>
		</row>
	</c:forEach>
</c:if>
</rows>