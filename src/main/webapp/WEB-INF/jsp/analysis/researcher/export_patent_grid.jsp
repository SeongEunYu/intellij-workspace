<%@page import="kr.co.argonet.r2rims.constant.R2Constant"%>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows>

	<head>
		<column width="50" type="ro" align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>NO</div>]]></column>
		<column width="80" type="ro" align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>특허제어번호</div>]]></column>
		<column width="100" type="ro" align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>구분</div>]]></column>
		<column width="50" type="ro" align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>상태</div>]]></column>
		<column width="100" type="ro" align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>취득국가구분</div>]]></column>
		<column width="100" type="ro" align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>출원/등록국가</div>]]></column>
		<column width="500" type="ro" align="left" sort="na" ><![CDATA[<div style='text-align:center;font-weight:bold;'>특허명</div>]]></column>
		<column width="80" type="ro"  align="center" sort="na" ><![CDATA[<div style='text-align:center;font-weight:bold;'>출원일자</div>]]></column>
		<column width="120" type="txt"  align="center" sort="na" ><![CDATA[<div style='text-align:center;font-weight:bold;'>출원번호</div>]]></column>
		<column width="80" type="ro"  align="center" sort="na" ><![CDATA[<div style='text-align:center;font-weight:bold;'>등록일자</div>]]></column>
		<column width="120" type="txt"  align="center" sort="na" ><![CDATA[<div style='text-align:center;font-weight:bold;'>등록번호</div>]]></column>
		<column width="60" type="ro"  align="left" sort="na" ><![CDATA[<div style='text-align:center;font-weight:bold;'>출원/등록인</div>]]></column>
		<column width="200" type="txt"  align="left" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>청구항</div>]]></column>
		<column width="200" type="txt"  align="left" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>요약</div>]]></column>
		<column width="200" type="ro"  align="left" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>발명자</div>]]></column>
		<column width="60" type="ro"  align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>발명자수</div>]]></column>
	   	<settings>
	   		<colwidth>PX</colwidth>
	   	</settings>
	</head>

	<c:if test="${not empty patentList}">
		<c:forEach items="${patentList}" var="pl" varStatus="st">
			<c:if test="${not empty pl }">
			<row id="${fn:escapeXml(pl.patentId)}">
					<cell><![CDATA[ ${st.count}]]></cell>
					<cell><![CDATA[ ${pl.patentId}]]></cell>
					<cell><![CDATA[ ${rims:codeValue('1080',pl.itlPprRgtDvsCd)}]]></cell>
					<cell>
						<c:choose>
							<c:when test="${pl.applStatus eq '1'}">발명신고</c:when>
							<c:when test="${pl.applStatus eq '2'}">발명승인</c:when>
							<c:when test="${pl.applStatus eq '3'}">출원</c:when>
							<c:when test="${pl.applStatus eq '4'}">등록</c:when>
							<c:when test="${pl.applStatus eq '5'}">소멸</c:when>
						</c:choose>
					</cell>
					<cell><![CDATA[ ${rims:codeValue('1140',pl.acqsNtnDvsCd)}]]></cell>
					<cell><![CDATA[ ${rims:codeValue('2080',pl.applRegNtnCd)}]]></cell>
					<cell><![CDATA[ ${pl.itlPprRgtNm}]]></cell>
					<cell><![CDATA[ ${rims:toDateFormatToken(pl.applRegDate, '.')}]]></cell>
					<cell><![CDATA[ ${pl.applRegNo}]]></cell>
					<cell><![CDATA[ ${rims:toDateFormatToken(pl.itlPprRgtRegDate, '.')}]]></cell>
					<cell><![CDATA[ ${pl.itlPprRgtRegNo}]]></cell>
					<cell><![CDATA[ ${pl.applRegtNm}]]></cell>
					<cell><![CDATA[ ${pl.claimtext}]]></cell>
					<cell><![CDATA[ ${pl.smmrCntn}]]></cell>
					<cell><![CDATA[ ${pl.invtNm}]]></cell>
					<cell><![CDATA[ ${pl.invtCnt}]]></cell>
			</row>
			</c:if>
		</c:forEach>
	</c:if>
	<c:if test="${empty patentList}">
	   <row id="0"><cell colspan="16">검색된 데이터가 없습니다.</cell></row>
	 </c:if>
</rows>