<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../gridInit.jsp" %>
<rows total_count="${totalCount}" pos="${posStart}">
	 <c:if test="${not empty userchghstList}">
		<c:forEach items="${userchghstList}" var="uchl" varStatus="st">
			<row id='${uchl.seqNo}'>
				<cell>${posStart + st.count}</cell>
				<cell>${fn:escapeXml(uchl.trgterId)}</cell>
				<cell>${fn:escapeXml(uchl.trgterKorNm)}</cell>
				<cell>${fn:escapeXml(uchl.trgterDeptKor)}</cell>
				<cell>${not empty uchl.trgterAuthorCd and uchl.trgterAuthorCd eq 'M' ? '관리대상자' : '미관리대상자'}</cell>
				<cell><fmt:formatDate value="${uchl.modDate}" pattern="yyyy-MM-dd" /></cell>
				<cell>${fn:escapeXml(uchl.modUserId)}</cell>
				<cell>${uchl.modUserId eq 'SYSTEM' ? '시스템' : uchl.modUserNm}</cell>
				<cell>
					<c:choose>
						<c:when test="${uchl.modUserAuthorCd eq 'M'}">관리자</c:when>
						<c:when test="${uchl.modUserAuthorCd eq 'D'}">학과관리자</c:when>
						<c:when test="${uchl.modUserAuthorCd eq 'C'}">단과대관리자</c:when>
						<c:when test="${uchl.modUserAuthorCd eq 'T'}">트랙관리자</c:when>
						<c:when test="${uchl.modUserAuthorCd eq 'P'}">성과관리자</c:when>
						<c:when test="${uchl.modUserAuthorCd eq 'S'}">대리입력자</c:when>
						<c:when test="${uchl.modUserAuthorCd eq 'Y'}">시스템(동기화)</c:when>
						<c:otherwise>연구자</c:otherwise>
					</c:choose>
				</cell>
			</row>
		</c:forEach>
	 </c:if>
</rows>
