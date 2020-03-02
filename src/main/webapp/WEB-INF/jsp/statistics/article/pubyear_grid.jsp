<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows>
<c:if test="${not empty articleStatList}">
<c:forEach items="${articleStatList}" var="as" varStatus="st">
	<row id="${as.impRegym}">
		<cell>${as.pubyear}</cell>
		<cell><fmt:formatNumber value="${as.intrlJnalArtsCo}" type="number"/></cell>
		<cell><fmt:formatNumber value="${as.intrlGnalScpArtsCo}" type="number"/></cell>
		<cell><fmt:formatNumber value="${as.dmstcKciArtsCo}" type="number"/></cell>
		<cell><fmt:formatNumber value="${as.dmstcGnalArtsCo}" type="number"/></cell>
		<cell><fmt:formatNumber value="${as.othersArtsCo}" type="number"/></cell>
		<cell><fmt:formatNumber value="${as.artsTotal}" type="number"/></cell>
		<cell><fmt:formatNumber value="${as.ifsum}" type="number"/></cell>
		<cell><fmt:formatNumber value="${as.tcsum}" type="number"/></cell>
		<cell><fmt:formatNumber value="${as.jifTot}" type="number"/></cell>
		<cell><fmt:formatNumber value="${as.tcTot}" type="number"/></cell>
	</row>
</c:forEach>
</c:if>
<c:if test="${empty articleStatList}">
	<row id="0">
		<cell colspan="7">No Results. Try Again!</cell>
	</row>
</c:if>
</rows>