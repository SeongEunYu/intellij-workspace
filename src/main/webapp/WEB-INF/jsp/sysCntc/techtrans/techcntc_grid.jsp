<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows total_count="${totalCount}" pos="${posStart}">
<c:if test="${not empty techtransCntcList}">
	<c:forEach items="${techtransCntcList}" var="tl" varStatus="idx">
		<row id='${tl.seqNo}'>
			<cell>${posStart + idx.count}</cell>
			<cell>${tl.srcId}</cell>
			<cell>${tl.cntrctManageNo}</cell>
			<cell>${tl.cntrctSttDate} ${empty tl.cntrctSttDate and empty tl.cntrctEndDate ? '' : '~'} ${tl.cntrctEndDate}</cell>
			<cell><fmt:formatNumber value="${tl.cntrctAmt}"/>${tl.rpmAmtUnit}</cell>
			<cell>${fn:escapeXml(tl.techTransrNm)}</cell>
			<cell><fmt:formatDate value="${tl.srcModDate}" pattern="yyyy-MM-dd" /></cell>
			<cell>
				<c:if test="${tl.cntcStatus eq 'I'}">신규</c:if>
				<c:if test="${tl.cntcStatus eq 'U'}">수정</c:if>
				<c:if test="${tl.cntcStatus eq 'Y'}">완료</c:if>
			</cell>
			<cell>${tl.techtransId}</cell>
		</row>
	</c:forEach>
</c:if>
<c:if test="${empty  techtransCntcList}">
		<row id="0">
				<cell colspan="5">No Results. Try Again!</cell>
		</row>
</c:if>
</rows>