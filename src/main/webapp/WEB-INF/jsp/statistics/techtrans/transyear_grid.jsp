<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows>
<c:if test="${not empty transStatList}">
<c:forEach items="${transStatList}" var="ts" varStatus="st">
	<row id="${ts.transYear}">
		<cell>${ts.transYear}</cell>
		<cell><fmt:formatNumber value="${ts.patentTransfrAmt}" type="number" /></cell>
		<cell><fmt:formatNumber value="${ts.patentTransfrCo}" type="number" /></cell>
		<cell><fmt:formatNumber value="${ts.dvrOprtnAmt}" type="number" /></cell>
		<cell><fmt:formatNumber value="${ts.dvrOprtnCo}" type="number" /></cell>
		<cell><fmt:formatNumber value="${ts.cmercOprtnAmt}" type="number" /></cell>
		<cell><fmt:formatNumber value="${ts.cmercOprtnCo}" type="number" /></cell>
		<cell><fmt:formatNumber value="${ts.knowHowAmt}" type="number" /></cell>
		<cell><fmt:formatNumber value="${ts.knowHowCo}" type="number" /></cell>
		<cell><fmt:formatNumber value="${ts.cnsutAmt}" type="number" /></cell>
		<cell><fmt:formatNumber value="${ts.cnsutCo}" type="number" /></cell>
		<cell>
			<fmt:formatNumber value="${ts.patentTransfrAmt+ts.dvrOprtnAmt+ts.cmercOprtnAmt+ts.knowHowAmt+ts.cnsutAmt}" type="number" />
		</cell>
		<cell>
			<fmt:formatNumber value="${ts.patentTransfrCo+ts.dvrOprtnCo+ts.cmercOprtnCo+ts.knowHowCo+ts.cnsutCo}" type="number" />
		</cell>
	</row>
</c:forEach>
</c:if>
<c:if test="${empty transStatList}">
	<row id="0">
		<cell colspan="7">No Results. Try Again!</cell>
	</row>
</c:if>
</rows>
