<%@page import="kr.co.argonet.r2rims.constant.R2Constant"%>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows>

	<head>
		<column width="50" type="ro" align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>NO</div>]]></column>
		<column width="80" type="ro" align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>기술이전제어번호</div>]]></column>
		<column width="100" type="ro"  align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>기술이전년월</div>]]></column>
		<column width="250" type="ro" align="left" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>기술이전명</div>]]></column>
		<column width="150" type="ro" align="left" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>이전기업명</div>]]></column>
		<column width="100" type="ro" align="left" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>기술이전형태</div>]]></column>
		<!-- 
		<column width="150" type="txt" align="right" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>기술이전료(단위:천원)</div>]]></column>
		-->
		<column width="150" type="txt" align="right" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>계약금액</div>]]></column>
	   	<settings>
	   		<colwidth>PX</colwidth>
	   	</settings>
	</head>

	<c:if test="${not empty techtransList}">
		<c:forEach items="${techtransList}" var="tl" varStatus="st">
			<c:if test="${not empty techtransList }">
			<row id="${fn:escapeXml(tl.techtransId)}">
					<cell><![CDATA[${st.count} ]]></cell>
					<cell><![CDATA[${tl.techtransId} ]]></cell>
					<cell><![CDATA[ ${rims:toDateFormatToken(tl.techTransrYm,'.')} ]]></cell>
					<cell><![CDATA[${tl.techTransrNm} ]]></cell>
					<cell><![CDATA[${tl.techTransrCorpNm} ]]></cell>
					<cell>
						<c:choose>
							<c:when test="${tl.techTransrCd eq '1' }">특허양도</c:when>
							<c:when test="${tl.techTransrCd eq '2' }">전용실시</c:when>
							<c:when test="${tl.techTransrCd eq '3' }">통상실시</c:when>
							<c:when test="${tl.techTransrCd eq '4' }">노하우</c:when>
							<c:when test="${tl.techTransrCd eq '5' }">자문</c:when>
						</c:choose>
					</cell>
					<!-- 
					<cell><![CDATA[fn:trim(tl.rpmAmt)]]></cell>
					-->
					<cell><![CDATA[<fmt:formatNumber value="${fn:trim(tl.cntrctAmt)}" type="number" />]]></cell>
			</row>
			</c:if>
		</c:forEach>
	</c:if>
	 <c:if test="${empty techtransList}">
		<row id="0">
				<cell colspan="6">검색된 데이터가 없습니다.</cell>
		</row>
	 </c:if>
</rows>