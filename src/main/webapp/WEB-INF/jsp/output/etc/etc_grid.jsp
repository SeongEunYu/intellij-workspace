<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows total_count="${totalCount}" pos="${posStart}">
	 <c:if test="${not empty etcList}">
	 	<c:forEach items="${etcList}" var="el" varStatus="st">
		 <row id="${el.userId}_${el.etcId}">
			<cell>${posStart + st.count}</cell>
			<c:if test="${not gSessMode and sessionScope.auth.adminDvsCd ne 'R' and sessionScope.auth.adminDvsCd ne 'S' }">
				<cell>${el.etcId}</cell>
				<cell><c:out value="${el.userId}"/></cell>
				<cell><c:out value="${el.korNm}"/></cell>
				<c:set var="yearmonth" value="${el.year}${el.month}"/>
				<cell><c:out value="${rims:toDateFormatToken(yearmonth,'.')}"/></cell>
				<cell><c:out value="${fn:escapeXml(el.subject)}"/></cell>
			</c:if>
			<c:if test="${gSessMode or (sessionScope.auth.adminDvsCd eq 'R' or sessionScope.auth.adminDvsCd eq 'S')}">
				<cell>${el.etcId}</cell>
				<c:set var="yearmonth" value="${el.year}${el.month}"/>
				<cell><c:out value="${rims:toDateFormatToken(yearmonth,'.')}"/></cell>
				<cell><c:out value="${fn:escapeXml(el.subject)}"/></cell>
			</c:if>
		 </row>
		</c:forEach>
	 </c:if>
</rows>