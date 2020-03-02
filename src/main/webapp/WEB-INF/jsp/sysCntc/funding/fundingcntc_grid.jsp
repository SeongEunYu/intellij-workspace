<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows>
<c:if test="${not empty fundingList}">
	<c:forEach items="${fundingList}" var="fl" varStatus="idx">
		<row id='${fl.erpId}'>
			<cell></cell>
			<cell>${idx.count}</cell>
			<cell>${fl.erpId}</cell>
			<cell><c:out value="${fl.rschCmcmYm}"/> ~ <c:out value="${fl.rschEndYm}"/></cell>
			<cell><c:out value="${fn:escapeXml(fl.rschSbjtNm)}"/></cell>
			<cell><c:out value="${fl.sbjtNo}"/></cell>
			<cell><c:out value="${fl.agcSbjtNo}"/></cell>
			<cell><c:out value="${fl.rsrcctSpptAgcNm}"/></cell>
			<cell>
			<c:choose>
				<c:when test="${fl.apprDvsCd == 'APPROVED'}">승인</c:when>
				<c:when test="${fl.apprDvsCd == 'UNAPPROVED'}">미승인</c:when>
				<c:when test="${fl.apprDvsCd == 'REJECTED'}">거절</c:when>
				<c:when test="${fl.apprDvsCd == 'CLOSED'}">종료</c:when>
			</c:choose>
			</cell>
			<cell><c:out value="${fl.userId}"/></cell>
			<cell><fmt:formatDate var="modDate" value="${fl.modDate}" pattern="yyyyMMdd" /><c:out value="${modDate}"/></cell>
		</row>
	</c:forEach>
</c:if>
</rows>