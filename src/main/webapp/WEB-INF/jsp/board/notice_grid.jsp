<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../gridInit.jsp" %>
<rows total_count="${totalCount}" pos="${posStart}">
 <c:if test="${not empty bbsList}">
 	<c:forEach items="${bbsList}" var="bbs" varStatus="st">
 		<row id="${bbs.bbsId}">
			<cell>${posStart + st.count}</cell>
			<cell><c:out value="${bbs.title}"/></cell>
			<cell><c:out value="${bbs.content}"/></cell>
			<cell>
				<c:choose>
					<c:when test="${bbs.languageFlag eq 'KOR'}">한국어</c:when>
					<c:when test="${bbs.languageFlag eq 'ENG'}">영어</c:when>
				</c:choose>
			</cell>
			<cell>
				<c:choose>
					<c:when test="${bbs.delDvsCd eq 'N'}">게시</c:when>
					<c:when test="${bbs.delDvsCd eq 'Y'}">게시종료</c:when>
				</c:choose>
			</cell>
			<cell><c:out value="${rims:toDateFormatToken(bbs.noticeSttDate,'-')}"/> ~ <c:out value="${rims:toDateFormatToken(bbs.noticeEndDate,'-')}"/></cell>
 		</row>
 	</c:forEach>
 </c:if>
</rows>
