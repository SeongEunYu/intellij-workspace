<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows total_count="${totalCount}" pos="${posStart}">
	 <c:if test="${not empty requestList}">
		<c:forEach items="${requestList}" var="rl" varStatus="st">
			<row id='${rl.seqNo}'>
				<cell>${posStart + st.count}</cell>
				<c:if test="${not gSessMode and sessionScope.auth.adminDvsCd ne 'R' and sessionScope.auth.adminDvsCd ne 'S' }">
					<cell><fmt:formatDate value="${rl.requestDate}" pattern="yyyy-MM-dd" /></cell>
					<cell>${fn:escapeXml(rl.trgetRsltType)}</cell>
					<cell>${fn:escapeXml(rl.trgetRsltId)}</cell>
					<cell>${rims:codeValue('request.se',rl.requestSeCd)}</cell>
					<cell>${fn:escapeXml(rl.requestUserId)}</cell>
					<cell>${rims:codeValue('request.status',rl.requestStatus)}</cell>
					<cell><fmt:formatDate value="${rl.tretDate}" pattern="yyyy-MM-dd" /></cell>
				</c:if>
				<c:if test="${gSessMode or (sessionScope.auth.adminDvsCd eq 'R' or sessionScope.auth.adminDvsCd eq 'S')}">
					<cell><fmt:formatDate value="${rl.requestDate}" pattern="yyyy-MM-dd" /></cell>
					<cell>${fn:escapeXml(rl.trgetRsltType)}</cell>
					<cell>${fn:escapeXml(rl.trgetRsltId)}</cell>
					<cell>${rims:codeValue('request.se',rl.requestSeCd)}</cell>
					<cell>${fn:escapeXml(rl.requestCn)}</cell>
					<cell>${rims:codeValue('request.status',rl.requestStatus)}</cell>
					<cell>${fn:escapeXml(rl.tretResultCn)}</cell>
					<cell><fmt:formatDate value="${rl.tretDate}" pattern="yyyy-MM-dd" /></cell>
				</c:if>
			</row>
		</c:forEach>
	 </c:if>
</rows>
