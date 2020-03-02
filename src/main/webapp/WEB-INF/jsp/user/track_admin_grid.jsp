<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../gridInit.jsp" %>
<rows>
	<c:if test="${not empty trackAdminList }">
		<c:forEach items="${trackAdminList}" var="admin" varStatus="idx">
			<row id="${admin.userId}_${admin.authorId}">
				<cell>${idx.count}</cell>
				<cell>${admin.userId}</cell>
				<cell>${admin.korNm}</cell>
				<cell>${admin.psitnDeptNm}</cell>
				<cell>${admin.gubun}</cell>
			</row>
		</c:forEach>
	</c:if>
</rows>