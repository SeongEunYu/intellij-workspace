<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows total_count="${totalCount}" pos="${posStart}">
 <c:if test="${not empty bookList}">
	<c:forEach items="${bookList}" var="bl" varStatus="st">
		<row id='${bl.userId}_${bl.bookId}'>
			<cell>${posStart + st.count}</cell>
			<c:if test="${not gSessMode and sessionScope.auth.adminDvsCd ne 'R' and sessionScope.auth.adminDvsCd ne 'S' }">
				<cell>${bl.bookId }</cell>
				<cell><c:out value="${fn:escapeXml(bl.orgLangBookNm)}"/></cell>
				<cell><c:out value="${fn:escapeXml(bl.pblcPlcNm)}"/></cell>
				<cell><c:out value="${rims:toDateFormatToken(bl.bookPblcYm,'.')}"/></cell>
				<cell>${rims:codeValue('1420',bl.vrfcDvsCd)}</cell>
				<cell>${rims:codeValue('1400',bl.apprDvsCd)}</cell>
				<cell><fmt:formatDate value="${bl.modDate}" pattern="yyyy-MM-dd" /></cell>
				<cell>${bl.delDvsCd eq 'Y' ? 'Y' : 'N'}</cell>
			</c:if>
			<c:if test="${gSessMode or (sessionScope.auth.adminDvsCd eq 'R' or sessionScope.auth.adminDvsCd eq 'S')}">
				<cell>${bl.bookId }</cell>
				<cell>${rims:codeValue('1110',bl.bookDvsCd)}</cell>
				<cell><c:out value="${fn:escapeXml(bl.orgLangBookNm)}"/></cell>
				<cell><c:out value="${fn:escapeXml(bl.pblcPlcNm)}"/></cell>
				<cell><c:out value="${rims:toDateFormatToken(bl.bookPblcYm,'.')}"/></cell>
				<cell>${rims:codeValue('1400',bl.apprDvsCd)}</cell>
			</c:if>
		</row>
	</c:forEach>
 </c:if>
</rows>
