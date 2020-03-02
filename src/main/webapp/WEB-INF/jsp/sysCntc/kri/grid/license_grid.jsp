<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../../gridInit.jsp" %>
<rows>
	<head>
		<column width="50" type="ro" align="center" sort="na" id="no"><![CDATA[<div style='text-align:center;font-weight:bold;'>NO</div>]]></column>
		<column width="70" type="ro" align="center" sort="na" id="licenseId"><![CDATA[<div style='text-align:center;font-weight:bold;'>관리번호</div>]]></column>
		<column width="80" type="ro" align="center" sort="na" id="userId"><![CDATA[<div style='text-align:center;font-weight:bold;'>사번</div>]]></column>
		<column width="120" type="ro" align="center" sort="na" id="korNm"><![CDATA[<div style='text-align:center;font-weight:bold;'>성명(한글)</div>]]></column>
		<column width="*" type="ro" align="left" sort="na" id="qlfAcqsYm"><![CDATA[<div style='text-align:center;font-weight:bold;'>자격취득년월</div>]]></column>
		<column width="*" type="ro" align="center" sort="na" id="crQfcNm"><![CDATA[<div style='text-align:center;font-weight:bold;'>자격증명</div>]]></column>
		<column width="*" type="ro" align="center" sort="na" id="qlfGrntAgcNm"><![CDATA[<div style='text-align:center;font-weight:bold;'>자격부여기관</div>]]></column>
		<column width="100" type="ro" align="center" sort="na" id="delDvsCd"><![CDATA[<div style='text-align:center;font-weight:bold;'>삭제여부</div>]]></column>
		<column width="100" type="ro" align="center" sort="na" id="src"><![CDATA[<div style='text-align:center;font-weight:bold;'>소스원</div>]]></column>
	</head>
	 <c:if test="${not empty licenseList}">
	 	<c:forEach items="${licenseList}" var="ll" varStatus="st">
		 <row id="license_${ll.licenseId}">
			<cell>${st.count}</cell>
			<cell>${ll.licenseId}</cell>
			<cell><c:out value="${ll.userId}"/></cell>
			<cell><c:out value="${ll.korNm}"/></cell>
			<cell><c:out value="${rims:toDateFormatToken(ll.qlfAcqsYm,'.')}"/></cell>
			<cell><c:out value="${fn:escapeXml(ll.crQfcNm)}"/></cell>
			<cell><c:out value="${fn:escapeXml(ll.qlfGrntAgcNm)}"/></cell>
			<cell><c:out value="${empty ll.delDvsCd ? 'N' : ll.delDvsCd}"/></cell>
			<cell><c:out value="${empty ll.src and al.src eq 'USER' ? '직접입력' : ll.src}"/></cell>
		 </row>
	 	</c:forEach>
	 </c:if>
</rows>