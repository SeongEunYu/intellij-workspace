<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows>
<c:if test="${not empty patentStatList}">
<c:forEach items="${patentStatList}" var="ps" varStatus="st">
	<row id="${ps.patyear}">
		<cell>${ps.patyear}</cell>
		<cell><fmt:formatNumber value="${ps.dmstcAplcCo}" type="number" /></cell>
		<cell><fmt:formatNumber value="${ps.ovseaAplcCo}" type="number" /></cell>
		<cell><fmt:formatNumber value="${ps.dmstcAplcCo + ps.ovseaAplcCo}" type="number" /></cell>
		<cell><fmt:formatNumber value="${ps.dmstcRegistCo}" type="number" /></cell>
		<cell><fmt:formatNumber value="${ps.ovseaRegistCo}" type="number" /></cell>
		<cell><fmt:formatNumber value="${ps.dmstcRegistCo + ps.ovseaRegistCo}" type="number" /></cell>
	</row>
</c:forEach>
</c:if>
<c:if test="${empty patentStatList}">
	<row id="0">
		<cell colspan="7">No Results. Try Again!</cell>
	</row>
</c:if>
</rows>