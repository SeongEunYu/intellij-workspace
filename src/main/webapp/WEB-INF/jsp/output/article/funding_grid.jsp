<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows>
	<c:if test="${not empty fundingList}">
		<c:forEach items="${fundingList}" var="fl" varStatus="idx">
		  <row id="${fl.fundingId}">
		  	<cell>${fl.fundingId}</cell>
		  	<cell>${fn:escapeXml(fl.rschYm)}</cell>
		  	<cell>${fn:escapeXml(fl.rschSbjtNm)}</cell>
		  	<cell>${fn:escapeXml(fl.agcSbjtNo)}</cell>
		  	<cell>${fn:escapeXml(fl.sbjtNo)}</cell>
		  	<cell>${fn:escapeXml(fl.rschCmcmYm)}</cell>
		  	<cell>${fn:escapeXml(fl.rschEndYm)}</cell>
		  	<cell>${fn:escapeXml(fl.rsrcctSpptAgcNm)}</cell>
		  	<cell>${fn:escapeXml(fl.blngUnivNm)}</cell>
		  	<cell>${fn:escapeXml(fl.cptGovOfficNm)}</cell>
		  </row>
		</c:forEach>
	</c:if>
	<c:if test="${empty fundingList}">
		<row id="0">
		   <cell colspan="4">No Results. Try Again!</cell>
		</row>
	</c:if>
</rows>