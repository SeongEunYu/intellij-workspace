<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../gridInit.jsp" %>
<rows>
	<c:if test="${not empty userList }">
		<c:forEach items="${userList }" var="ul" varStatus="idx">

			<c:if test="${empty ul.lastName}">
				<c:set var="engNm" value="${ul.firstName}"/>
			</c:if>
			<c:if test="${not empty ul.lastName}">
				<c:set var="engNm" value="${ul.lastName}, ${ul.firstName}"/>
			</c:if>

			<c:if test="${empty ul.abbrLastName}">
				<c:set var="engAbbrNm" value="${ul.abbrFirstName}"/>
			</c:if>
			<c:if test="${not empty ul.abbrLastName}">
				<c:set var="engAbbrNm" value="${ul.abbrLastName}, ${ul.abbrFirstName}"/>
			</c:if>

			<row id='${ul.userId};${ul.korNm};${engNm};${engAbbrNm};${ul.deptKor};${ul.posiMapngCd}' >
				<cell style="color: blue; <c:if test="${not empty ul.userId}"> text-decoration: underline;cursor: pointer;</c:if>">${ul.userId}</cell>
				<cell style="color: blue; <c:if test="${not empty engAbbrNm}"> text-decoration: underline;cursor: pointer;</c:if>">${engAbbrNm}</cell>
				<cell style="color: blue; <c:if test="${not empty engNm}"> text-decoration: underline;cursor: pointer;</c:if>">${engNm}</cell>
				<cell style="color: blue; <c:if test="${not empty ul.korNm}">text-decoration: underline;cursor: pointer;</c:if>">${fn:escapeXml(ul.korNm)}</cell>
				<cell>${fn:escapeXml(ul.deptKor)}</cell>
				<cell>${fn:escapeXml(ul.posiNm)}</cell>
				<cell>${fn:escapeXml(ul.posiMapngCd)}</cell>
			</row>
		</c:forEach>
	</c:if>
	<c:if test="${empty userList }">
		<row>
			<cell colspan="6">No Results. Try Again!</cell>
		</row>
	</c:if>
</rows>
