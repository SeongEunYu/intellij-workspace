<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows total_count="${totalCount}" pos="${posStart}">
 <c:if test="${not empty activityList}">
 	<c:forEach items="${activityList}" var="al" varStatus="st">
 		<row id="${al.userId}_${al.activityId}">
			<cell>${posStart + st.count}</cell>
			<c:if test="${not gSessMode and sessionScope.auth.adminDvsCd ne 'R' and sessionScope.auth.adminDvsCd ne 'S' }">
				<cell>${al.activityId}</cell>
				<cell><c:out value="${al.userId}"/></cell>
				<cell><c:out value="${al.korNm}"/></cell>
				<cell><c:out value="${rims:toDateFormatToken(al.sttDate,'.')}"/></cell>
				<cell><c:out value="${rims:toDateFormatToken(al.endDate,'.')}"/></cell>
				<cell>${rims:codeValue('act.scope',al.actScopeCd)}</cell>
				<cell>${rims:codeValue('ACT_TYPE',al.actvtyDvsCd)}</cell>
				<cell><c:out value="${fn:escapeXml(al.actvtyNm)}"/></cell>
				<cell><c:out value="${fn:escapeXml(al.mngtInsttNm)}"/></cell>
				<cell><c:choose><c:when test="${al.src eq 'CMT'}">ERP</c:when><c:when test="${al.src eq 'ADJ'}">ERP</c:when><c:otherwise>USER</c:otherwise></c:choose></cell>
			</c:if>
			<c:if test="${gSessMode or (sessionScope.auth.adminDvsCd eq 'R' or sessionScope.auth.adminDvsCd eq 'S')}">
				<cell>${al.activityId}</cell>
				<cell><c:out value="${rims:toDateFormatToken(al.sttDate,'.')}"/></cell>
				<cell><c:out value="${rims:toDateFormatToken(al.endDate,'.')}"/></cell>
				<cell>${rims:codeValue('act.scope',al.actScopeCd)}</cell>
				<cell>${rims:codeValue('ACT_TYPE',al.actvtyDvsCd)}</cell>
				<cell><c:out value="${fn:escapeXml(al.actvtyNm)}"/></cell>
				<cell><c:out value="${fn:escapeXml(al.mngtInsttNm)}"/></cell>
			</c:if>
 		</row>
 	</c:forEach>
 </c:if>
</rows>
