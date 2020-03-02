<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../../gridInit.jsp" %>
<rows>
	<head>
		<column width="50" type="ro" align="center" sort="na" id="no"><![CDATA[<div style='text-align:center;font-weight:bold;'>NO</div>]]></column>
		<column width="70" type="ro" align="center" sort="na" id="degreeId"><![CDATA[<div style='text-align:center;font-weight:bold;'>관리번호</div>]]></column>
		<column width="80" type="ro" align="center" sort="na" id="userId"><![CDATA[<div style='text-align:center;font-weight:bold;'>사번</div>]]></column>
		<column width="100" type="ro" align="center" sort="na" id="korNm"><![CDATA[<div style='text-align:center;font-weight:bold;'>성명(한글)</div>]]></column>
		<column width="100" type="ro" align="center" sort="na" id="dgrAcqsYm"><![CDATA[<div style='text-align:center;font-weight:bold;'>학위취득년월</div>]]></column>
		<column width="100" type="ro" align="center" sort="na" id="acqsDgrDvsCd"><![CDATA[<div style='text-align:center;font-weight:bold;'>학위구분</div>]]></column>
		<column width="*" type="ro" align="left" sort="na" id="dgrAcqsAgcNm"><![CDATA[<div style='text-align:center;font-weight:bold;'>학위취득기관</div>]]></column>
		<column width="120" type="ro" align="left" sort="na" id="dgrAcqsNtnCd"><![CDATA[<div style='text-align:center;font-weight:bold;'>학위취득국가</div>]]></column>
		<column width="100" type="ro" align="center" sort="na" id="lastDgrSlctCd"><![CDATA[<div style='text-align:center;font-weight:bold;'>최종학위여부</div>]]></column>
		<column width="100" type="ro" align="center" sort="na" id="modDate"><![CDATA[<div style='text-align:center;font-weight:bold;'>최종수정일</div>]]></column>
		<column width="100" type="ro" align="center" sort="na" id="delDvsCd"><![CDATA[<div style='text-align:center;font-weight:bold;'>삭제여부</div>]]></column>
		<column width="80" type="ro" align="center" sort="na" id="src"><![CDATA[<div style='text-align:center;font-weight:bold;'>소스원</div>]]></column>
	</head>
	 <c:if test="${not empty degreeList}">
	 	<c:forEach items="${degreeList}" var="dl" varStatus="st">
		 <row id="degree_${dl.degreeId}">
		 	<cell>${st.count}</cell>
			<cell>${dl.degreeId}</cell>
			<cell><c:out value="${dl.userId}"/></cell>
			<cell><c:out value="${dl.korNm}"/></cell>
			<cell><c:out value="${rims:toDateFormatToken(dl.dgrAcqsYm,'.')}"/></cell>
			<cell>${rims:codeValue('1240',dl.acqsDgrDvsCd)}</cell>
			<cell><c:out value="${fn:escapeXml(dl.dgrAcqsAgcNm)}"/></cell>
			<cell>${rims:codeValue('2000',dl.dgrAcqsNtnCd)}</cell>
			<cell>${not empty dl.lastDgrSlctCd and dl.lastDgrSlctCd eq '1' ? 'Y' : 'N'}</cell>
			<cell><fmt:formatDate value="${dl.modDate}" pattern="yyyy-MM-dd" /></cell>
			<cell><c:out value="${empty dl.delDvsCd ? 'N' : dl.delDvsCd}"/></cell>
			<cell><c:out value="${empty dl.src and dl.src eq 'USER' ? '직접입력' : dl.src}"/></cell>
		 </row>
	 	</c:forEach>
	 </c:if>
</rows>