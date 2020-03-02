<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../gridInit.jsp" %>
<rows total_count="${totalCount}" pos="${posStart}">
	 <c:if test="${not empty indvdlinfoList}">
		<c:forEach items="${indvdlinfoList}" var="utl" varStatus="st">
			<row id='${utl.logId}'>
				<cell>${posStart + st.count}</cell>
				<cell>${fn:escapeXml(utl.trgterId)}</cell>
				<cell>${fn:escapeXml(utl.trgterNm)}</cell>
				<cell>
					<c:choose>
						<c:when test="${utl.workSeCd eq 'SRCH'}">열람</c:when>
						<c:when test="${utl.workSeCd eq 'EXP'}">반출</c:when>
						<c:when test="${utl.workSeCd eq 'INS'}">입력</c:when>
						<c:when test="${utl.workSeCd eq 'MOD'}">수정</c:when>
					</c:choose>
				</cell>
				<cell><fmt:formatDate value="${utl.regDate}" pattern="yyyy-MM-dd HH:mm:ss" /></cell>
				<cell>${fn:escapeXml(utl.conectrId)}</cell>
				<cell>${fn:escapeXml(utl.conectrNm)}</cell>
				<cell>
					<c:choose>
						<c:when test="${utl.conectrAuthorCd eq 'M'}">관리자</c:when>
						<c:when test="${utl.conectrAuthorCd eq 'D'}">학과관리자</c:when>
						<c:when test="${utl.conectrAuthorCd eq 'C'}">단과대관리자</c:when>
						<c:when test="${utl.conectrAuthorCd eq 'T'}">트랙관리자</c:when>
						<c:when test="${utl.conectrAuthorCd eq 'P'}">성과관리자</c:when>
						<c:when test="${utl.conectrAuthorCd eq 'S'}">대리입력자</c:when>
						<c:otherwise>연구자</c:otherwise>
					</c:choose>
				</cell>
				<cell>${fn:escapeXml(utl.conectIp)}</cell>
			</row>
		</c:forEach>
	 </c:if>
</rows>
