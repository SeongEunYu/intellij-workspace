<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%><%@
include file="../../gridInit.jsp" %>
<rows>
	 <c:if test="${not empty patentList}">
		<c:forEach items="${patentList}" var="pl" varStatus="st">
			<row id='${pl.patentId}'>
				<cell>${st.count}</cell>
				<cell>${pl.patentId}</cell>
				<cell>${fn:escapeXml(pl.itlPprRgtNm)}</cell>
				<cell class="num_text">${rims:toDateFormatToken(pl.applRegDate,'-')}</cell>
				<cell class="num_text"><c:out value="${pl.applRegNo}" /></cell>
				<cell class="num_text">${rims:toDateFormatToken(pl.itlPprRgtRegDate,'-')}</cell>
				<cell class="num_text"><c:out value="${pl.itlPprRgtRegNo}" /></cell>
			</row>
		</c:forEach>
	 </c:if>
	 <c:if test="${empty patentList}">
		<row id="0">
				<cell colspan="7">No Results. Try Again!</cell>
		</row>
	 </c:if>
</rows>