<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../gridInit.jsp" %>
<rows>
	<c:if test="${not empty agncyList}">
		<c:forEach items="${agncyList}" var="agncy" varStatus="idx">
			<row id="${agncy.userId}_${agncy.authorId}">
				<cell>${idx.count}</cell>
				<cell>${agncy.userId}</cell>
				<cell>${agncy.korNm}</cell>
				<cell>${rims:codeValue('auth.type',agncy.adminDvsCd)}</cell>
				<cell>${not empty agncy.authorStatus and agncy.authorStatus eq 'Y' ? '부여':'회수'}</cell>
				<cell><fmt:formatDate value="${not empty agncy.authorStatus and agncy.authorStatus eq 'Y' ? agncy.authorAlwncDate : agncy.authorFrftrDate}" pattern="yyyy-MM-dd" /></cell>
				<cell>${agncy.emailAdres}</cell>
				<cell>${agncy.telno}</cell>
				<cell>${agncy.remarkCn}</cell>
				<cell>${sessionScope.login_user.userId}</cell>
				<cell>${sessionScope.login_user.userId}</cell>
				<cell>${agncy.adminDvsCd}</cell>
				<cell>${agncy.workTrget}</cell>
				<cell>${agncy.workTrgetNm}</cell>
				<cell>${agncy.mngrResnCn}</cell>
			</row>
		</c:forEach>
	</c:if>
</rows>
