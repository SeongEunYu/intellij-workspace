<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows>
	<c:if test="${not empty journalMasterList}">
		<c:forEach items="${journalMasterList}" var="jm" varStatus="idx">
			<c:set var="subject" value="" />
			<c:set var="subject" value="${jm.sci eq '1' ? '1' : subject}" />
			<c:set var="subject" value="${jm.sci ne '1' and jm.scie eq '1' ? '2' : subject}" />
			<c:set var="subject" value="${jm.sci ne '1' and jm.scie ne '1' and jm.ssci eq '1' ? '3' : subject}" />
			<c:set var="subject" value="${jm.sci ne '1' and jm.scie ne '1' and jm.ssci ne '1' and jm.ahci eq '1' ? '4' : subject}" />
			<c:set var="subject" value="${jm.sci ne '1' and jm.scie ne '1' and jm.ssci ne '1' and jm.ahci ne '1' and jm.scopus eq '1' ? '5' : subject}" />
			<c:set var="subject" value="${jm.sci ne '1' and jm.scie ne '1' and jm.ssci ne '1' and jm.ahci ne '1' and jm.scopus ne '1' and jm.kci eq '1' ? '6' : subject}" />
			<row id="${idx.count}_${subject}_${jm.conCode}">
				<cell>${fn:escapeXml(jm.issn)}</cell>
				<cell>${fn:escapeXml(jm.title)}</cell>
				<cell>${fn:escapeXml(jm.puWos)}${fn:escapeXml(jm.puScopus)}${fn:escapeXml(jm.puKci)}</cell>
				<cell>
					<c:choose>
					  <c:when test="${subject eq '5'}">SCOPUS</c:when>
					  <c:when test="${subject eq '6'}">KCI</c:when>
					  <c:otherwise>${rims:codeValue('1380',subject)}</c:otherwise>
					</c:choose>
				</cell>
			</row>
		</c:forEach>
	</c:if>
	<c:if test="${empty journalMasterList}">
		<row>
			<cell colspan="4">No Results. Try Again!</cell>
		</row>
	</c:if>
</rows>
