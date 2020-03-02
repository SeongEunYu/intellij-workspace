<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../../gridInit.jsp" %>
<rows>
	<head>
		<column width="50" type="ro" align="center" sort="na" id="no"><![CDATA[<div style='text-align:center;font-weight:bold;'>NO</div>]]></column>
		<column width="100" type="ro" align="center" sort="na" id="techtransId"><![CDATA[<div style='text-align:center;font-weight:bold;'>관리번호</div>]]></column>
		<column width="100" type="ro" align="center" sort="na" id="techTransrYm"><![CDATA[<div style='text-align:center;font-weight:bold;'>기술이전년월</div>]]></column>
		<column width="*" type="ro" align="left" sort="na" id="techTransrNm"><![CDATA[<div style='text-align:center;font-weight:bold;'>이전기술명</div>]]></column>
		<column width="*" type="ro" align="center" sort="na" id="techTransrCorpNm"><![CDATA[<div style='text-align:center;font-weight:bold;'>이전기업명</div>]]></column>
		<column width="80" type="ro" align="center" sort="na" id="apprDvsCd"><![CDATA[<div style='text-align:center;font-weight:bold;'>승인여부</div>]]></column>
		<column width="80" type="ro" align="center" sort="na" id="src"><![CDATA[<div style='text-align:center;font-weight:bold;'>소스원</div>]]></column>
		<column width="80" type="ro" align="center" sort="na" id="delDvsCd"><![CDATA[<div style='text-align:center;font-weight:bold;'>삭제여부</div>]]></column>
	</head>
	<c:if test="${not empty techtransList}">
		<c:forEach items="${techtransList}" var="tl" varStatus="st">
			<row id='techtrans_${tl.techtransId}'>
				<cell>${st.count}</cell>
				<cell>${tl.techtransId}</cell>
				<cell><c:out value="${rims:toDateFormatToken(tl.techTransrYm,'.')}"/></cell>
				<cell><c:out value="${fn:escapeXml(tl.techTransrNm)}"/></cell>
				<cell><c:out value="${fn:escapeXml(tl.techTransrCorpNm)}"/></cell>
				<cell>${rims:codeValue('1400',tl.apprDvsCd)}</cell>
				<cell><c:out value="${tl.src}"/></cell>
				<cell>${tl.delDvsCd eq 'Y' ? 'Y' : 'N'}</cell>
			</row>
		</c:forEach>
	</c:if>
</rows>