<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../gridInit.jsp" %>
<rows total_count="${totalCount}" pos="${posStart}">
	 <c:if test="${not empty authghstList}">
		<c:forEach items="${authghstList}" var="achl" varStatus="st">
			<row id='${achl.seqNo}'>
				<cell>${posStart + st.count}</cell>
				<cell>${fn:escapeXml(achl.trgterId)}</cell>
				<cell>${fn:escapeXml(achl.trgterKorNm)}</cell>
				<cell>
					<c:choose>
						<c:when test="${achl.trgterAuthorCd eq 'M'}">관리자</c:when>
						<c:when test="${achl.trgterAuthorCd eq 'D'}">학과관리자</c:when>
						<c:when test="${achl.trgterAuthorCd eq 'C'}">단과대관리자</c:when>
						<c:when test="${achl.trgterAuthorCd eq 'T'}">트랙관리자</c:when>
						<c:when test="${achl.trgterAuthorCd eq 'P'}">성과관리자</c:when>
						<c:when test="${achl.trgterAuthorCd eq 'V'}">성과열람자</c:when>
						<c:when test="${achl.trgterAuthorCd eq 'S'}">대리입력자</c:when>
						<c:otherwise>시스템</c:otherwise>
					</c:choose>
				</cell>
				<cell>${fn:escapeXml(achl.trgterAuthorWorkNm)}</cell>
				<cell>
					<c:choose>
						<c:when test="${achl.changeSe eq 'I'}">신규</c:when>
						<c:when test="${achl.changeSe eq 'U'}">수정</c:when>
						<c:when test="${achl.changeSe eq 'D'}">상실</c:when>
					</c:choose>
				</cell>
				<cell><fmt:formatDate value="${achl.authorAlwncDate}" pattern="yyyy-MM-dd" /></cell>
				<cell><fmt:formatDate value="${achl.authorFrftrDate}" pattern="yyyy-MM-dd" /></cell>
				<cell>${fn:escapeXml(achl.mngrResnCn)}</cell>
				<cell>${fn:escapeXml(achl.modUserId)}</cell>
				<cell>${achl.modUserId eq 'SYSTEM' ? '시스템' : achl.modUserNm}</cell>
				<cell>
					<c:choose>
						<c:when test="${achl.modUserAuthorCd eq 'M'}">관리자</c:when>
						<c:when test="${achl.modUserAuthorCd eq 'D'}">학과관리자</c:when>
						<c:when test="${achl.modUserAuthorCd eq 'C'}">단과대관리자</c:when>
						<c:when test="${achl.modUserAuthorCd eq 'T'}">트랙관리자</c:when>
						<c:when test="${achl.modUserAuthorCd eq 'P'}">성과관리자</c:when>
						<c:when test="${achl.modUserAuthorCd eq 'S'}">대리입력자</c:when>
						<c:otherwise>시스템</c:otherwise>
					</c:choose>
				</cell>
				<cell>${fn:escapeXml(achl.conectIp)}</cell>
			</row>
		</c:forEach>
	 </c:if>
</rows>
