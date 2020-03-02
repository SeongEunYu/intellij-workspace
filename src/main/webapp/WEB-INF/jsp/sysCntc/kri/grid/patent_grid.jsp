<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%><%@
include file="../../../gridInit.jsp" %>
<rows>
	<head>
		<column width="50" type="ro" align="center" sort="na" id="no"><![CDATA[<div style='text-align:center;font-weight:bold;'>NO</div>]]></column>
		<column width="50" type="ro" align="center" sort="na" id="patentId"><![CDATA[<div style='text-align:center;font-weight:bold;'>관리번호</div>]]></column>
		<column width="50" type="ro" align="center" sort="na" id="itlPprRgtDvsCd"><![CDATA[<div style='text-align:center;font-weight:bold;'>재산권명</div>]]></column>
		<column width="100" type="ro" align="center" sort="na" id="applRegNtnCd"><![CDATA[<div style='text-align:center;font-weight:bold;'>국가</div>]]></column>
		<column width="*" type="ro" align="left" sort="na" id="itlPprRgtNm"><![CDATA[<div style='text-align:center;font-weight:bold;'>지식재산권명</div>]]></column>
		<column width="100" type="ro" align="center" sort="na" id="applRegNo"><![CDATA[<div style='text-align:center;font-weight:bold;'>출원번호</div>]]></column>
		<column width="100" type="ro" align="center" sort="na" id="applRegDate"><![CDATA[<div style='text-align:center;font-weight:bold;'>출원일자</div>]]></column>
		<column width="100" type="ro" align="center" sort="na" id="itlPprRgtRegNo"><![CDATA[<div style='text-align:center;font-weight:bold;'>등록번호</div>]]></column>
		<column width="100" type="ro" align="center" sort="na" id="itlPprRgtRegDate"><![CDATA[<div style='text-align:center;font-weight:bold;'>등록일자</div>]]></column>
		<column width="80" type="ro" align="center" sort="na" id="vrfcDvsCd"><![CDATA[<div style='text-align:center;font-weight:bold;'>KRI검증</div>]]></column>
		<column width="80" type="ro" align="center" sort="na" id="apprDvsCd"><![CDATA[<div style='text-align:center;font-weight:bold;'>승인여부</div>]]></column>
		<column width="80" type="ro" align="center" sort="na" id="modDate"><![CDATA[<div style='text-align:center;font-weight:bold;'>최종수정일</div>]]></column>
		<column width="80" type="ro" align="center" sort="na" id="pCode"><![CDATA[<div style='text-align:center;font-weight:bold;'>P-CODE</div>]]></column>
		<column width="80" type="ro" align="center" sort="na" id="srcId"><![CDATA[<div style='text-align:center;font-weight:bold;'>Source</div>]]></column>
		<column width="50" type="ro" align="center" sort="na" id="delDvsCd"><![CDATA[<div style='text-align:center;font-weight:bold;'>삭제여부</div>]]></column>
	</head>
	 <c:if test="${not empty patentList}">
		<c:forEach items="${patentList}" var="pl" varStatus="st">
			<row id='patent_${pl.patentId}'>
				<cell>${st.count}</cell>
				<cell>${pl.patentId}</cell>
				<cell>${rims:codeValue('1080',pl.itlPprRgtDvsCd)}</cell>
				<cell>${rims:codeValue('2000',pl.applRegNtnCd)}</cell>
				<cell><c:out value="${fn:escapeXml(pl.itlPprRgtNm)}"/></cell>
				<cell class="num_text"><c:out value="${pl.applRegNo}" /></cell>
				<cell class="num_text"><c:out value="${rims:toDateFormatToken(pl.applRegDate,'-')}"/></cell>
				<cell class="num_text"><c:out value="${pl.itlPprRgtRegNo}" /></cell>
				<cell class="num_text"><c:out value="${rims:toDateFormatToken(pl.itlPprRgtRegDate,'-')}"/></cell>
				<cell>${rims:codeValue('1420',pl.vrfcDvsCd)}</cell>
				<cell>${rims:codeValue('1400',pl.apprDvsCd)}</cell>
				<cell class="num_text"><fmt:formatDate value="${pl.modDate}" pattern="yyyy-MM-dd" /></cell>
				<cell><c:out value="${fn:escapeXml(pl.pCode)}"/></cell>
				<cell>${empty pl.srcId ? '직접입력' : 'PPMS'}</cell>
				<cell>${pl.delDvsCd eq 'Y' ? '삭제' : ''}</cell>
			</row>
		</c:forEach>
	 </c:if>
</rows>