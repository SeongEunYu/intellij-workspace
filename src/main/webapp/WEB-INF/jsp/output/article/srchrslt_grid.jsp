<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows>
	 <c:if test="${not empty articleList}">
		<c:forEach items="${articleList}" var="al" varStatus="st">
			<row id='${al.articleId}'>
				<cell>${st.count}</cell>
				<cell>${al.articleId}</cell>
				<cell>${not empty al.articleId ? 'RIMS' : al.originSe}</cell>
				<cell>${fn:escapeXml(al.orgLangPprNm)}</cell>
				<cell>${rims:toDateFormatToken(al.pblcYm,".")}</cell>
				<cell>${fn:escapeXml(al.volume)}</cell>
				<cell>${fn:escapeXml(al.issue)}</cell>
				<cell>${fn:escapeXml(al.sttPage)}</cell>
				<cell>${fn:escapeXml(al.endPage)}</cell>
				<cell>${fn:escapeXml(al.issnNo)}</cell>
				<cell>${fn:escapeXml(al.scjnlNm)}</cell>
				<cell>${fn:escapeXml(al.pblcPlcNm)}</cell>
				<cell>${fn:escapeXml(al.authors)}</cell>
				<cell>${not empty al.articleId ? 'dplct' : 'search'}</cell>
			</row>
		</c:forEach>
	 </c:if>
	 <c:if test="${empty articleList}">
		<row id="nodata">
				<cell colspan="7">No Results. Try Again!</cell>
		</row>
	 </c:if>
</rows>
