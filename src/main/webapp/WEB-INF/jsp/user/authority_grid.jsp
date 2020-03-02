<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../gridInit.jsp" %>
<rows>
	<c:if test="${not empty authorityList}">
		<c:forEach items="${authorityList}" var="auth" varStatus="idx">
			<row id="${auth.userId}_${auth.authorId}">
				<cell>${idx.count}</cell>
				<cell>${auth.userId}</cell>
				<cell>${rims:codeValue('auth.type',auth.adminDvsCd)}</cell>
				<cell>${auth.adminDvsCd}</cell>
				<cell>${empty auth.workTrgetNm ? '해당없음' : auth.workTrgetNm}</cell>
				<cell>${auth.authorStatus}</cell>
				<cell>
					<c:if test="${auth.authorStatus eq 'Y'}"><fmt:formatDate value="${auth.authorAlwncDate}" pattern="yyyy-MM-dd" /></c:if>
					<c:if test="${auth.authorStatus eq 'F'}"><fmt:formatDate value="${auth.authorFrftrDate}" pattern="yyyy-MM-dd" /></c:if>
				</cell>
				<cell>${auth.mngrResnCn}</cell>
				<cell>${sessionScope.login_user.userId}</cell>
				<cell>${auth.workTrget}</cell>
			</row>
		</c:forEach>
	</c:if>
</rows>
