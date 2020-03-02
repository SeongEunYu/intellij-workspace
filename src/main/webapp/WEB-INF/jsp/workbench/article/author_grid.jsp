<?xml version="1.0" encoding="UTF-8"?>
<%@include file="../../gridInit.jsp" %>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<rows total_count="${totalCount}" pos="${posStart}">
<c:if test="${not empty authrList }">
	<c:forEach items="${authrList}" var="al" varStatus="st">
		<row id="${al.sourcIdntfcNo};${al.authrSeq};${al.articleId};${al.isOwnInst}" disableCheckbox="true">
			<c:if test="${fn:escapeXml(al.isOwnInst) eq '0' }">
				<c:set var="isChk" value=""/>
			</c:if>
			<c:if test="${fn:escapeXml(al.isOwnInst) eq '1'}">
				<c:set var="isChk" value="V"/>
			</c:if>
			<cell>${isChk}</cell>
			<cell type="sub_row_ajax">${contextPath}/workbench/findAuthrAddressAjax.do?articleId=${al.articleId}&amp;authrSeq=${al.authrSeq}&amp;rowId=${al.sourcIdntfcNo};${al.authrSeq};${al.articleId};${al.isOwnInst}</cell>
			<cell>${fn:escapeXml(al.authrSeq)}</cell>
			<cell>${fn:escapeXml(al.authrAbrv)}</cell>
			<cell>${fn:escapeXml(al.authrNm)}</cell>
			<cell>${fn:escapeXml(al.rePername)}</cell>
			<cell>${fn:escapeXml(al.rePerno)}</cell>
			<cell>${fn:escapeXml(al.tpiDvsCd)}</cell>
		</row>
	</c:forEach>
</c:if>
</rows>
