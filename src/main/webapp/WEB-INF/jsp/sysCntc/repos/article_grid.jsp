<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<c:set var="now" value="<%=new java.util.Date()%>" />
<fmt:formatDate value="${now}" pattern="yyyyMMdd" var="nowDate" />
<fmt:formatNumber value="${nowDate}" type="number" var="nowDay" />
<rows total_count="${totalCount}" pos="${posStart}">
<c:if test="${not empty openFileList}">
	<c:forEach items="${openFileList}" var="ol" varStatus="idx">
		<row id='${ol.articleId}'>
			<%--<cell></cell>--%>
			<cell>${idx.count}</cell>
			<cell>${ol.articleId}</cell>
			<cell>${fn:escapeXml(ol.orgLangPprNm)}</cell>
			<cell>${fn:escapeXml(ol.scjnlNm)}</cell>
			<cell>${rims:toDateFormatToken(ol.pblcYm, '.')}</cell>
			<cell>
                <c:choose>
                    <c:when test="${empty ol.pubFileId}">없음</c:when>
                    <c:when test="${ol.pubIrOpen eq 'Y'}">공개</c:when>
                    <c:otherwise>
                        <c:if test="${not empty ol.pubIrOpenDate}">
                            <fmt:formatNumber value="${fn:replace(fn:substring(ol.pubIrOpenDate,0,10 ),'-','') }" type="number" var="pubIrOpenDate" />
                            <c:if test="${pubIrOpenDate <= nowDay}">
                                공개
                            </c:if>
                            <c:if test="${pubIrOpenDate > nowDay}">
                                비공개
                            </c:if>
                        </c:if>
                        <c:if test="${empty ol.pubIrOpenDate}">
                            비공개
                        </c:if>
                    </c:otherwise>
                </c:choose>
			</cell>
			<cell>
                <c:choose>
                    <c:when test="${ol.koaFlag eq 'U' or ol.koaFlag eq 'N'}">대기</c:when>
                    <c:when test="${ol.koaFlag eq 'Y'}">완료</c:when>
                    <c:otherwise>제외</c:otherwise>
                </c:choose>
			</cell>
		</row>
	</c:forEach>
</c:if>
</rows>