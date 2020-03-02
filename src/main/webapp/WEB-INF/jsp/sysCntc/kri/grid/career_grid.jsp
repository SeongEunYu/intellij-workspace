<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../../gridInit.jsp" %>
<rows>
	<head>
		<column width="50" type="ro" align="center" sort="na" id="no"><![CDATA[<div style='text-align:center;font-weight:bold;'>NO</div>]]></column>
		<column width="70" type="ro" align="center" sort="na" id="careerId"><![CDATA[<div style='text-align:center;font-weight:bold;'>관리번호</div>]]></column>
		<column width="80" type="ro" align="center" sort="na" id="userId"><![CDATA[<div style='text-align:center;font-weight:bold;'>사번</div>]]></column>
		<column width="100" type="ro" align="center" sort="na" id="korNm"><![CDATA[<div style='text-align:center;font-weight:bold;'>성명(한글)</div>]]></column>
		<column width="100" type="ro" align="center" sort="na" id="workSttYm"><![CDATA[<div style='text-align:center;font-weight:bold;'>시작년월</div>]]></column>
		<column width="100" type="ro" align="left" sort="na" id="workEndYm"><![CDATA[<div style='text-align:center;font-weight:bold;'>종료년월</div>]]></column>
		<column width="*" type="ro" align="left" sort="na" id="workAgcNm"><![CDATA[<div style='text-align:center;font-weight:bold;'>근무처</div>]]></column>
		<column width="*" type="ro" align="left" sort="na" id="posiNm"><![CDATA[<div style='text-align:center;font-weight:bold;'>직위</div>]]></column>
		<column width="100" type="ro" align="center" sort="na" id="delDvsCd"><![CDATA[<div style='text-align:center;font-weight:bold;'>삭제여부</div>]]></column>
		<column width="80" type="ro" align="center" sort="na" id="src"><![CDATA[<div style='text-align:center;font-weight:bold;'>소스원</div>]]></column>
	</head>
	 <c:if test="${not empty careerList}">
	 	<c:forEach items="${careerList}" var="cl" varStatus="st">
	 		<row id="career_${cl.careerId}">
	 			<cell>${st.count}</cell>
				<cell>${cl.careerId}</cell>
				<cell><c:out value="${cl.userId}"/></cell>
				<cell><c:out value="${cl.korNm}"/></cell>
				<cell><c:out value="${rims:toDateFormatToken(cl.workSttYm,'.')}"/></cell>
				<cell><c:out value="${rims:toDateFormatToken(cl.workEndYm,'.')}"/></cell>
				<cell><c:out value="${fn:escapeXml(cl.workAgcNm)}"/></cell>
				<cell><c:out value="${fn:escapeXml(cl.posiNm)}"/></cell>
				<cell><c:out value="${empty cl.delDvsCd ? 'N' : cl.delDvsCd}"/></cell>
				<cell><c:out value="${empty cl.src and cl.src eq 'USER' ? '직접입력' : cl.src}"/></cell>
	 		</row>
	 	</c:forEach>
	 </c:if>
</rows>