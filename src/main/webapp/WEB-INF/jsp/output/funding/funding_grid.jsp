<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows total_count="${totalCount}" pos="${posStart}">
	 <c:if test="${not empty fundingList}">
	 	<c:forEach items="${fundingList}" var="fl" varStatus="st">
	 	  <row id="admin_${fl.fundingId}">
	 		<cell>${posStart + st.count}</cell>
	 		<c:if test="${not gSessMode and sessionScope.auth.adminDvsCd ne 'R' and sessionScope.auth.adminDvsCd ne 'S' }">
		 		<cell>${fl.fundingId}</cell>
		 		<cell><c:out value="${rims:toDateFormatToken(fl.rschCmcmYm,'.')}"/> ~ <c:out value="${rims:toDateFormatToken(fl.rschEndYm,'.')}"/></cell>
		 		<cell>${rims:codeValue('1280',fl.rsrcctSpptDvsCd)}</cell>
		 		<cell><c:out value="${fn:escapeXml(fl.rschSbjtNm)}"/></cell>
		 		<cell><c:out value="${fn:escapeXml(fl.sbjtNo)}"/></cell>
		 		<cell><c:out value="${fn:escapeXml(fl.agcSbjtNo)}"/></cell>
		 		<cell><c:out value="${fn:escapeXml(fl.rsrcctSpptAgcNm)}"/></cell>
		 		<cell>${rims:codeValue('1400',fl.apprDvsCd)}</cell>
				<cell><fmt:formatDate value="${fl.modDate}" pattern="yyyy-MM-dd" /></cell>
				<cell>${fl.delDvsCd eq 'Y' ? 'Y' : 'N'}</cell>
	 		</c:if>
	 		<c:if test="${gSessMode or (sessionScope.auth.adminDvsCd eq 'R' or sessionScope.auth.adminDvsCd eq 'S')}">
		 		<cell>${fl.fundingId}</cell>
	 			<cell><c:out value="${rims:toDateFormatToken(fl.rschCmcmYm,'.')}"/> ~ <c:out value="${rims:toDateFormatToken(fl.rschEndYm,'.')}"/></cell>
		 		<cell>${rims:codeValue('1280',fl.rsrcctSpptDvsCd)}</cell>
		 		<cell><c:out value="${fn:escapeXml(fl.rschSbjtNm)}"/></cell>
	 			<cell><c:out value="${fn:escapeXml(fl.rsrcctSpptAgcNm)}"/></cell>
	 			<cell><fmt:formatNumber value="${fn:trim(fl.sumTotRsrcct)}" type="number"/></cell>
	 		</c:if>
	 			<cell>
	 				<c:choose>
		    			<c:when test="${fl.overallFlag eq 'T'}">Principal</c:when>
		    			<c:when test="${fl.overallFlag eq 'S'}">Task</c:when>
		    			<c:otherwise>Manual</c:otherwise>
	 				</c:choose>
	 			</cell>
	 	  </row>
	 	</c:forEach>
	 </c:if>
</rows>