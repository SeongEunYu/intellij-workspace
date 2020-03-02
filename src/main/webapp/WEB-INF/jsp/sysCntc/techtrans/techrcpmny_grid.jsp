<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows>
<c:if test="${not empty rcpmnyList}">
	<c:forEach items="${rcpmnyList}" var="rl" varStatus="idx">
		<row id='${rl.srcId}_${rl.srcTme}'>
			<cell type="sub_row_grid">${contextPath}/techtransCntc/findPmsTechtransPartiDstbamtListAjax.do?srcId=${rl.srcId}&amp;srcTme=${rl.srcTme}</cell>
			<cell>${rl.collectionType}</cell>
			<cell>${rl.rpmDate}</cell>
			<cell>${rl.rpmTme}</cell>
			<cell>${rl.rpmAmt}</cell>
			<cell>${rl.ddcAmt}</cell>
			<cell>${fn:escapeXml(rl.ddcResn)}</cell>
			<cell>${rl.diffAmt}</cell>
			<cell>${rl.invnterDstbAmt}</cell>
			<cell>${rl.univDstbAmt}</cell>
			<cell>${rl.deptDstbAmt}</cell>
			<cell>${rl.acdincpDstbAmt}</cell>
		</row>
	</c:forEach>
</c:if>
<c:if test="${empty  rcpmnyList}">
		<row id="0">
			<cell colspan="11">No Results.</cell>
		</row>
</c:if>
</rows>