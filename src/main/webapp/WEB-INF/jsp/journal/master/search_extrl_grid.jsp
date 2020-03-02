<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows total_count="${totalCount}" pos="${posStart}">
	<c:if test="${not empty journalMasterList}">
		<c:forEach items="${journalMasterList}" var="jm" varStatus="idx">
			<row id="${jm.jid}">
				<cell><c:out value="${jm.issn}"/></cell>
				<cell>
					<c:choose>
						<c:when test="#{not empty jm.isSciClass and jm.isSciClass eq 'Y'}">
							<c:out value="${fn:escapeXml(jm.engTitle)}"/>
						</c:when>
						<c:otherwise>
							<c:out value="${fn:escapeXml(jm.title)}"/>
						</c:otherwise>
					</c:choose>
				</cell>
				<cell><c:out value="${fn:escapeXml(jm.publisher)}"/></cell>
				<cell><c:out value="${fn:escapeXml(jm.registDesc)}"/></cell>
			</row>
		</c:forEach>
	</c:if>
	<c:if test="${empty journalMasterList}">
		<row>
			<cell colspan="4">No Results. Try Again!</cell>
		</row>
	</c:if>
</rows>
