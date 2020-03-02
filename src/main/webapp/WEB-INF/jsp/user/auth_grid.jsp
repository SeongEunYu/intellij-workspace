<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../gridInit.jsp" %>
<rows>
	<c:if test="${not empty deptUserList }">
		<c:forEach items="${deptUserList}" var="auth" varStatus="idx">
			<row id="${auth.id}">
				<cell>${idx.count}</cell>
				<cell>${auth.userId}</cell>
				<cell>${auth.cn}</cell>
				<cell>${auth.korNm}</cell>
				<cell>${auth.adminDvsCd}</cell>
				<cell>${auth.workDeptKor}</cell>
				<cell>${auth.emalAddr}</cell>
				<cell>${auth.telno}</cell>
				<cell>${fn:trim(auth.mgtAt)}</cell>
				<cell>${auth.etc}</cell>
				<cell>${auth.password}</cell>
				<cell>${sessionScope.login_user.userId}</cell>
				<cell>${sessionScope.login_user.userId}</cell>
			</row>
		</c:forEach>
	</c:if>
</rows>

<%--
	if (deptUserList != null && deptUserList.size() > 0) {
		for (int i = 0; i < deptUserList.size(); i++) {

	<row id='<%=deptUserList.get(i).getCn() %>'>
		<cell><%=i + 1 %></cell>
		<cell><%=StringUtils.defaultString(deptUserList.get(i).getUserId()) %></cell>
		<cell><%=StringUtils.defaultString(deptUserList.get(i).getCn()) %></cell>
		<cell><%=StringUtils.defaultString(deptUserList.get(i).getKorNm()) %></cell>
		<cell><%=StringUtils.defaultString(deptUserList.get(i).getWorkDeptKor()) %></cell>
		<cell><%=StringUtils.defaultString(deptUserList.get(i).getEmalAddr()) %></cell>
		<cell><%=StringUtils.defaultString(deptUserList.get(i).getTelno()) %></cell>
		<cell><%=StringUtils.defaultString(deptUserList.get(i).getAdminDvsCd()) %></cell>
		<cell><%=StringUtils.defaultString(deptUserList.get(i).getEtc()) %></cell>
	</row><%
		}
	}
--%>