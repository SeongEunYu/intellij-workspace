<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../../gridInit.jsp" %>
<rows>
	<head>
		<column width="50" type="ro" align="center" sort="na" id="no"><![CDATA[<div style='text-align:center;font-weight:bold;'>NO</div>]]></column>
		<column width="70" type="ro" align="center" sort="na" id="degreeId"><![CDATA[<div style='text-align:center;font-weight:bold;'>관리번호</div>]]></column>
		<column width="80" type="ro" align="center" sort="na" id="userId"><![CDATA[<div style='text-align:center;font-weight:bold;'>사번</div>]]></column>
		<column width="100" type="ro" align="left" sort="na" id="korNm"><![CDATA[<div style='text-align:center;font-weight:bold;'>성명(한글)</div>]]></column>
		<column width="*" type="ro" align="left" sort="na" id="orgLangXhbtAncmNm"><![CDATA[<div style='text-align:center;font-weight:bold;'>전시발표명</div>]]></column>
		<column width="130" type="ro" align="center" sort="na" id="ancmAcpsDvsCd"><![CDATA[<div style='text-align:center;font-weight:bold;'>실적구분</div>]]></column>
		<column width="120" type="ro" align="center" sort="na" id="ancmYm"><![CDATA[<div style='text-align:center;font-weight:bold;'>발표년월</div>]]></column>
		<column width="120" type="ro" align="left" sort="na" id="ancmPlcNm"><![CDATA[<div style='text-align:center;font-weight:bold;'>발표장소명</div>]]></column>
		<column width="120" type="ro" align="left" sort="na" id="planMngCrpNm"><![CDATA[<div style='text-align:center;font-weight:bold;'>기획주관처명</div>]]></column>
		<column width="100" type="ro" align="center" sort="na" id="apprDvsCd"><![CDATA[<div style='text-align:center;font-weight:bold;'>승인여부</div>]]></column>
		<column width="100" type="ro" align="center" sort="na" id="delDvsCd"><![CDATA[<div style='text-align:center;font-weight:bold;'>삭제여부</div>]]></column>
	</head>
	 <c:if test="${not empty exhibitionList}">
	 	<c:forEach items="${exhibitionList}" var="el" varStatus="st">
		 <row id="exhibition_${el.exhibitionId}">
			<cell>${st.count}</cell>
			<cell>${el.exhibitionId}</cell>
			<cell><c:out value="${el.userId}"/></cell>
			<cell><c:out value="${el.korNm}"/></cell>
			<cell><c:out value="${fn:escapeXml(el.orgLangXhbtAncmNm)}"/></cell>
			<cell>${rims:codeValue('1170',el.ancmAcpsDvsCd)}</cell>
			<cell><c:out value="${rims:toDateFormatToken(el.ancmYm,'.')}"/></cell>
			<cell><c:out value="${fn:escapeXml(el.ancmPlcNm)}"/></cell>
			<cell><c:out value="${fn:escapeXml(el.planMngCrpNm)}"/></cell>
			<cell>${rims:codeValue('1400',el.apprDvsCd)}</cell>
			<cell><c:out value="${empty el.delDvsCd ? 'N' : el.delDvsCd}"/></cell>
		 </row>
	 	</c:forEach>
	 </c:if>
</rows>