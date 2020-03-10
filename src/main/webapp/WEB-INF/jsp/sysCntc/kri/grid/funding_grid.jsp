<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../../gridInit.jsp" %>
<rows>
	<head>
		<column width="40" type="ro" align="center" sort="na" id="no"><![CDATA[<div style='text-align:center;font-weight:bold;'>NO</div>]]></column>
		<column width="70" type="ro" align="center" sort="na" id="fundingId"><![CDATA[<div style='text-align:center;font-weight:bold;'>관리번호</div>]]></column>
		<column width="120" type="ro" align="center" sort="na" id="rschCmcmYm"><![CDATA[<div style='text-align:center;font-weight:bold;'>연구기간</div>]]></column>
		<column width="120" type="ro" align="center" sort="na" id="rsrcctSpptDvsCd"><![CDATA[<div style='text-align:center;font-weight:bold;'>연구비지원구분</div>]]></column>
		<column width="*" type="ro" align="left" sort="na" id="rschSbjtNm"><![CDATA[<div style='text-align:center;font-weight:bold;'>연구과제명</div>]]></column>
		<column width="100" type="ro" align="center" sort="na" id="sbjtNo"><![CDATA[<div style='text-align:center;font-weight:bold;'>과제번호</div>]]></column>
		<column width="100" type="ro" align="center" sort="na" id="agcSbjtNo"><![CDATA[<div style='text-align:center;font-weight:bold;'>과제번호</div>]]></column>
		<column width="110" type="ro" align="center" sort="na" id="rsrcctSpptAgcNm"><![CDATA[<div style='text-align:center;font-weight:bold;'>연구비지원기관</div>]]></column>
		<column width="75" type="ro" align="center" sort="na" id="apprDvsCd"><![CDATA[<div style='text-align:center;font-weight:bold;'>승인여부</div>]]></column>
		<column width="78" type="ro" align="center" sort="na" id="modDate"><![CDATA[<div style='text-align:center;font-weight:bold;'>최종수정일</div>]]></column>
		<column width="60" type="ro" align="center" sort="na" id="delDvsCd"><![CDATA[<div style='text-align:center;font-weight:bold;'>삭제여부</div>]]></column>
		<column width="53" type="ro" align="center" sort="na" id="overallFlag"><![CDATA[<div style='text-align:center;font-weight:bold;'>Source</div>]]></column>
	</head>
	 <c:if test="${not empty fundingList}">
	 	<c:forEach items="${fundingList}" var="fl" varStatus="st">
	 	  <row id="funding_${fl.fundingId}">
	 		<cell>${st.count}</cell>
	 		<cell>${fl.fundingId}</cell>
	 		<cell><c:out value="${rims:toDateFormatToken(fl.rschCmcmYm,'.')}"/> ~ <c:out value="${rims:toDateFormatToken(fl.rschEndYm,'.')}"/></cell>
	 		<cell>${rims:codeValue('1280',fl.rsrcctSpptDvsCd)}</cell>
	 		<cell><c:out value="${fn:escapeXml(fl.rschSbjtNm)}"/></cell>
	 		<cell><c:out value="${fn:escapeXml(fl.sbjtNo)}"/></cell>
	 		<cell><c:out value="${fn:escapeXml(fl.agcSbjtNo)}"/></cell>
	 		<cell><c:out value="${fn:escapeXml(fl.rsrcctSpptAgcNm)}"/></cell>
	 		<cell>${rims:codeValue('1400',fl.apprDvsCd)}</cell>
			<cell><fmt:formatDate value="${fl.modDate}" pattern="yyyy-MM-dd" /></cell>
			<cell>${fl.delDvsCd eq 'Y' ? 'Y' : 'N'}</cell>
	 		<cell>${fl.overallFlag eq 'T' ? '총괄' : '태스크'}</cell>
	 	  </row>
	 	</c:forEach>
	 </c:if>
</rows>