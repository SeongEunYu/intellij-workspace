<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows>
	<c:if test="${not empty cnfrncMasterList}">
		<c:forEach items="${cnfrncMasterList}" var="cm" varStatus="idx">
			<row id="${idx.count}_${cm.sn}_${cm.schlshpCnfrncCode}">
				<cell>${fn:escapeXml(cm.schlshpCnfrncCode)}</cell>
				<cell>${fn:escapeXml(cm.schlshpCnfrncFullNm)}</cell>
				<cell>${fn:escapeXml(cm.opmtInsttFullNm)}</cell>
				<cell>${fn:escapeXml(cm.impact)}</cell>
				<cell>${fn:escapeXml(cm.note)}</cell>
				<cell>${fn:escapeXml(cm.schlshpCnfrncAbbrNm)}</cell>
				<cell>${fn:escapeXml(cm.opmtInsttAbbrNm)}</cell>
			</row>
		</c:forEach>
	</c:if>
</rows>
