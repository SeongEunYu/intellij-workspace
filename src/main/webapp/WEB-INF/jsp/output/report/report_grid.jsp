<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows total_count="${totalCount}" pos="${posStart}">
	 <c:if test="${not empty reportList}">
	 	<c:forEach items="${reportList}" var="rl" varStatus="st">
		 <row id="report_${rl.reportId}">
			<cell>${posStart + st.count}</cell>
			<c:if test="${not gSessMode and sessionScope.auth.adminDvsCd ne 'R' and sessionScope.auth.adminDvsCd ne 'S' }">
				<cell>${rl.reportId}</cell>
				<cell><c:out value="${rims:toDateFormatToken(rl.pblicteYm,'.')}"/></cell>
				<cell><c:out value="${fn:escapeXml(rl.reportTitle)}"/></cell>
				<cell><c:out value="${fn:escapeXml(rl.orderInsttNm)}"/></cell>
				<cell><c:out value="${fn:escapeXml(rl.sbjtNo)}"/></cell>
				<cell><fmt:formatDate value="${rl.modDate}" pattern="yyyy-MM-dd" /></cell>
				<cell>${fn:escapeXml(rl.delDvsCd) eq 'Y' ? 'Y' : 'N'}</cell>
			</c:if>
			<c:if test="${gSessMode or (sessionScope.auth.adminDvsCd eq 'R' or sessionScope.auth.adminDvsCd eq 'S')}">
				<cell>${rl.reportId}</cell>
				<cell><c:out value="${rims:toDateFormatToken(rl.pblicteYm,'.')}"/></cell>
				<cell><c:out value="${fn:escapeXml(rl.reportTitle)}"/></cell>
				<cell><c:out value="${fn:escapeXml(rl.orderInsttNm)}"/></cell>
			</c:if>
		</row>
	   </c:forEach>
	 </c:if>
</rows>