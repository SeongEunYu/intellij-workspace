<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../../gridInit.jsp" %>
<rows>
	<head>
		<column width="50" type="ro" align="center" sort="na" id="no"><![CDATA[<div style='text-align:center;font-weight:bold;'>NO</div>]]></column>
		<column width="80" type="ro" align="center" sort="na" id="degreeId"><![CDATA[<div style='text-align:center;font-weight:bold;'>관리번호</div>]]></column>
		<column width="80" type="ro" align="center" sort="na" id="userId"><![CDATA[<div style='text-align:center;font-weight:bold;'>사번</div>]]></column>
		<column width="100" type="ro" align="center" sort="na" id="korNm"><![CDATA[<div style='text-align:center;font-weight:bold;'>성명(한글)</div>]]></column>
		<column width="100" type="ro" align="center" sort="na" id="awrdYm"><![CDATA[<div style='text-align:center;font-weight:bold;'>수상년월</div>]]></column>
		<column width="*" type="ro" align="left" sort="na" id="awrdNm"><![CDATA[<div style='text-align:center;font-weight:bold;'>수상명</div>]]></column>
		<column width="100" type="ro" align="center" sort="na" id="awrdDvsCd"><![CDATA[<div style='text-align:center;font-weight:bold;'>수상구분</div>]]></column>
		<column width="120" type="ro" align="left" sort="na" id="cfmtAgcNm"><![CDATA[<div style='text-align:center;font-weight:bold;'>수여기관</div>]]></column>
		<column width="100" type="ro" align="center" sort="na" id="cfmtNtnCd"><![CDATA[<div style='text-align:center;font-weight:bold;'>수여국가</div>]]></column>
		<column width="80" type="ro" align="center" sort="na" id="delDvsCd"><![CDATA[<div style='text-align:center;font-weight:bold;'>삭제여부</div>]]></column>
		<column width="80" type="ro" align="center" sort="na" id="src"><![CDATA[<div style='text-align:center;font-weight:bold;'>소스원</div>]]></column>
	</head>
	 <c:if test="${not empty awardList}">
	 	<c:forEach items="${awardList}" var="al" varStatus="st">
		 <row id="award_${al.awardId}">
			<cell>${st.count}</cell>
			<cell>${al.awardId}</cell>
			<cell><c:out value="${al.userId}"/></cell>
			<cell><c:out value="${al.korNm}"/></cell>
			<cell><c:out value="${rims:toDateFormatToken(al.awrdYm,'.')}"/></cell>
			<cell><c:out value="${fn:escapeXml(al.awrdNm)}"/></cell>
			<cell>${rims:codeValue('1210',al.awrdDvsCd)}</cell>
			<cell><c:out value="${fn:escapeXml(al.cfmtAgcNm)}"/></cell>
			<cell>${rims:codeValue('2000',al.cfmtNtnCd)}</cell>
			<cell><c:out value="${empty al.delDvsCd ? 'N' : al.delDvsCd}"/></cell>
			<cell><c:out value="${empty al.src and al.src eq 'USER' ? '직접입력' : al.src}"/></cell>
		 </row>
	 	</c:forEach>
	 </c:if>
</rows>