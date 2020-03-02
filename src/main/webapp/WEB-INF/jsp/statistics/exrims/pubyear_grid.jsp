<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows>
<c:if test="${not empty articleStatList}">
<c:forEach items="${articleStatList}" var="as" varStatus="st">
	<row id="${as.impRegym}">
		<cell>${as.pubyear}</cell>
		<cell>${as.pc1}</cell>
		<cell>${as.pc11}</cell>
		<cell>${as.pc4}</cell>
		<cell>${as.pc5}</cell>
		<cell>${as.pc13}</cell>
		<cell>${as.ifsum}</cell>
		<cell>${as.tcsum}</cell>
		<cell>${as.jifTot}</cell>
		<cell>${as.tcTot}</cell>
	</row>
</c:forEach>
</c:if>
<c:if test="${empty articleStatList}">
	<row id="0">
		<cell colspan="7">No Results. Try Again!</cell>
	</row>
</c:if>
</rows>