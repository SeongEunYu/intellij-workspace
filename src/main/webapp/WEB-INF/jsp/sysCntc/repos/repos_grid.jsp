<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fn" uri="/WEB-INF/tld/fn.tld" %>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld" %>
<%@ taglib prefix="rims" uri="/WEB-INF/tld/rims.tld" %>
<rows total_count="${totalCount}" pos="${posStart}">
<c:if test="${not empty openFileList}">
	<c:forEach items="${openFileList}" var="ol" varStatus="idx">
		<row id='${ol.articleId}'>
			<cell></cell>
			<cell>${idx.count}</cell>
			<cell>${ol.articleId}</cell>
			<cell>${fn:escapeXml(ol.orgLangPprNm)}</cell>
			<cell>${fn:escapeXml(ol.scjnlNm)}</cell>
			<cell>${rims:toDateFormatToken(ol.pblcYm, '.')}</cell>
			<cell>
				<c:if test="${empty ol.isOpenFiles}">작업대기</c:if>
				<c:if test="${ol.isOpenFiles eq 'Y'}">원문공개</c:if>
				<c:if test="${ol.isOpenFiles eq 'N'}">원문미공개</c:if>
			</cell>
			<cell>
				<c:if test="${empty ol.koaFlag}">연계대기</c:if>
				<c:if test="${not empty ol.koaFlag and  ol.koaFlag eq 'Y'}">연계완료</c:if>
			</cell>
		</row>
	</c:forEach>
</c:if>
</rows>