<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows>
	<head>
		<column width="80" type="ro" align="center" sort="na" id="prtcpntNm"><![CDATA[<div style='text-align:center;font-weight:bold;'>성명</div>]]></column>
		<column width="80" type="ro" align="left" sort="na" id="qotaRate"><![CDATA[<div style='text-align:center;font-weight:bold;'>지분률</div>]]></column>
		<column width="80" type="ro" align="left" sort="na" id="dstbAmt"><![CDATA[<div style='text-align:center;font-weight:bold;'>배분금액</div>]]></column>
		<settings>
			<colwidth>px</colwidth>
		</settings>
	</head>

	 <c:if test="${not empty dstbamtList}">
		<c:forEach items="${dstbamtList}" var="dl" varStatus="st">
			<row id='${dl.srcId}_${dl.srcTme}_${dl.srcSeq}'>
				<cell>${fn:escapeXml(dl.prtcpntNm)}</cell>
				<cell>${dl.qotaRate}</cell>
				<cell>${dl.dstbAmt}</cell>
			</row>
		</c:forEach>
	 </c:if>
	 <c:if test="${empty dstbamtList}">
		<row id="0">
				<cell colspan="7">No Results. Try Again!</cell>
		</row>
	 </c:if>
</rows>
