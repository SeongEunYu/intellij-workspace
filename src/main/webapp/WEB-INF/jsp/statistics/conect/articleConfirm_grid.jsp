<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows>
<c:if test="${not empty articleConfirmList}">
	<c:forEach items="${articleConfirmList}" var="acl" varStatus="st">
		<row id="${acl.rsrchUserId}">
			<cell>${acl.rsrchUserId}</cell>
			<cell>${acl.rsrchUserNm}</cell>
			<cell>
				<c:choose>
					<c:when test="${acl.rsrchUserHldofYn eq '1'}">재직</c:when>
					<c:when test="${acl.rsrchUserHldofYn eq '2'}">퇴직</c:when>
					<c:otherwise>미입력</c:otherwise>
				</c:choose>
			</cell>
			<cell>${acl.rsrchUserSclpst}</cell>
			<cell>${acl.rsrchUserDept}</cell>
			<cell>${acl.allCnfirmArtCo}</cell>
			<cell>${acl.allUncnfrmArtCo}</cell>
			<cell>${acl.sciCnfirmArtCo}</cell>
			<cell>${acl.sciUncnfrmArtCo}</cell>
			<cell>${acl.etcCnfirmArtCo}</cell>
			<cell>${acl.etcUncnfrmArtCo}</cell>
			<cell>
				<c:choose>
					<c:when test="${acl.allCnfirmArtCo eq 0}">0</c:when>
					<c:otherwise>
						<fmt:parseNumber value="${acl.allCnfirmArtCo/(acl.allCnfirmArtCo + acl.allUncnfrmArtCo)*100}" integerOnly="true" />
					</c:otherwise>
				</c:choose>
				%
			</cell>
		</row>
	</c:forEach>
</c:if>
</rows>