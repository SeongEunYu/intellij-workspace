<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows>

	<head>
		<column width="40" type="ro" align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>NO</div>]]></column>
		<column width="70" type="ro" align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>논문제어번호</div>]]></column>
		<column width="500" type="ro" align="left" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>논문명</div>]]></column>
		<column width="250" type="ro" align="left" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>저널명</div>]]></column>
		<column width="100" type="ro" align="left" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>발행처</div>]]></column>
		<column width="60" type="ro"  align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>발행국가</div>]]></column>
		<column width="60" type="ro"  align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>ISSN번호</div>]]></column>
		<column width="60" type="txt"  align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>발행년</div>]]></column>
		<column width="60" type="txt"  align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>발행월</div>]]></column>
		<column width="60" type="ro"  align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>권</div>]]></column>
		<column width="60" type="ro"  align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>호</div>]]></column>
		<column width="60" type="ro"  align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>시작페이지</div>]]></column>
		<column width="60" type="ro"  align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>종료페이지</div>]]></column>
		<column width="60" type="ro"  align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>저널구분</div>]]></column>
		<column width="60" type="ro"  align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>SCI구분</div>]]></column>
		<column width="60" type="ro"  align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>학진등재여부</div>]]></column>
		<column width="60" type="ro"  align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>SCI피인용수</div>]]></column>
		<column width="60" type="ro"  align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>SCOPUS피인용수</div>]]></column>
		<column width="60" type="ro"  align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>KCI피인용수</div>]]></column>
		<column width="60" type="ro"  align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>Impact Factor</div>]]></column>
		<column width="60" type="txt"  align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>SCI ID</div>]]></column>
		<column width="60" type="txt"  align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>SCOPUS ID</div>]]></column>
		<column width="60" type="txt"  align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>KCI ID</div>]]></column>
		<column width="60" type="ro"  align="left" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>초록</div>]]></column>
		<column width="60" type="ro"  align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>제1저자</div>]]></column>
		<column width="60" type="ro"  align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>교신저자</div>]]></column>
		<column width="60" type="ro"  align="left" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>전체저자</div>]]></column>
		<column width="60" type="ro"  align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>저자수</div>]]></column>


	   	<settings>
	   		<colwidth>PX</colwidth>
	   	</settings>
	</head>

	<c:if test="${not empty articleList}">
		<c:forEach items="${articleList}" var="al" varStatus="st">
			<c:if test="${not empty al }">
			<c:set var="partList" value="${al.partiList}"/>
			<c:set var="firstAuthor" value=""/>
			<c:set var="rpntAuthor" value=""/>
			<c:set var="allAuthor" value=""/>
			<c:if test="${not empty partList}">
				<c:forEach var="pl" items="${partList }">
				  <c:if test="${pl.tpiDvsCd eq '1' or pl.tpiDvsCd eq '2' }"><c:set var="firstAuthor" value="${pl.prtcpntNm}"/></c:if>
				  <c:if test="${pl.tpiDvsCd eq '3'}"><c:set var="rpntAuthor" value="${rpntAuthor};${pl.prtcpntNm}"/></c:if>
				  <c:set var="allAuthor" value="${allAuthor};${pl.prtcpntNm}"/>
				</c:forEach>
			</c:if>
			<row id="${al.articleId}">
				<cell>${st.count}</cell>
				<cell>${al.articleId}</cell>
				<cell><![CDATA[ ${al.orgLangPprNm} ]]></cell>
				<cell><![CDATA[ ${al.scjnlNm} ]]></cell>
				<cell><![CDATA[ ${al.pblcPlcNm} ]]></cell>
				<cell><![CDATA[ ${rims:codeValue('2000',al.pblcNtnCd)}]]></cell>
				<cell><![CDATA[ ${al.issnNo} ]]></cell>
				<cell><![CDATA[ ${fn:substring(al.pblcYm,0,4)} ]]></cell>
				<cell><![CDATA[ ${fn:substring(al.pblcYm,4,6)} ]]></cell>
				<cell><![CDATA[ ${al.volume} ]]></cell>
				<cell><![CDATA[ ${al.issue} ]]></cell>
				<cell><![CDATA[ ${al.sttPage} ]]></cell>
				<cell><![CDATA[ ${al.endPage} ]]></cell>
				<cell><![CDATA[ ${rims:codeValue('1100', al.scjnlDvsCd)} ]]></cell>
				<cell><![CDATA[ ${rims:codeValue('1380', al.ovrsExclncScjnlPblcYn)} ]]></cell>
				<cell><![CDATA[ ${rims:codeValue('1390', al.krfRegPblcYn)} ]]></cell>
				<cell><![CDATA[ ${al.tc} ]]></cell>
				<cell><![CDATA[ ${al.scpTc} ]]></cell>
				<cell><![CDATA[ ${al.kciTc} ]]></cell>
				<cell><![CDATA[ ${al.impctFctr} ]]></cell>
				<cell><![CDATA[ ${al.idSci} ]]></cell>
				<cell><![CDATA[ ${al.idScopus} ]]></cell>
				<cell><![CDATA[ ${al.idKci} ]]></cell>
				<cell><![CDATA[ ${al.abstCntn} ]]></cell>
				<cell><![CDATA[ ${firstAuthor} ]]></cell>
				<cell><![CDATA[ ${fn:substringAfter(rpntAuthor,';')} ]]></cell>
				<cell><![CDATA[ ${fn:substringAfter(allAuthor,';')} ]]></cell>
				<cell><![CDATA[ ${al.totalAthrCnt} ]]></cell>
			</row>
			</c:if>
		</c:forEach>
	</c:if>
	<c:if test="${empty articleList}">
	   <row id="0"><cell colspan="27">검색된 데이터가 없습니다.</cell></row>
	 </c:if>
</rows>