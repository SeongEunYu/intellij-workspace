<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows>
	<head>
		<column width="60" type="ro" align="center" sort="str" id="dispOrder"><![CDATA[<div style='text-align:center;font-weight:bold;'>순서</div>]]></column>
		<column width="100" type="co" align="center" sort="str" id="tpiDvsCd"><![CDATA[<div style='text-align:center;font-weight:bold;'>참여역할</div>]]>
			${rims:makeCodeList('1180',true,null)}
		</column>
		<column width="130" type="ed" align="center" sort="str" id="prtcpntNm"><![CDATA[<div style='text-align:center;font-weight:bold;'>저자명(Abbr.)</div>]]></column>
		<column width="21" type="img" align="center" sort="str" id="prtcontSerach">#cspan</column>
		<column width="130" type="ed"  align="center" sort="str" id="prtcpntFullNm"><![CDATA[<div style='text-align:center;font-weight:bold;'>저자명(Full)</div>]]></column>
		<column width="100" type="ed" align="center" sort="str" id="prtcpntId"><![CDATA[<div style='text-align:center;font-weight:bold;'>직번</div>]]></column>
		<column width="80" type="ch" align="center" sort="str" id="isRecord"><![CDATA[<div style='text-align:center;font-weight:bold;'>실적여부</div>]]></column>
		<column width="*" type="ed" align="center" sort="str" id="blngAgcNm"><![CDATA[<div style='text-align:center;font-weight:bold;'>소속기관</div>]]></column>
		<column width="24" type="img" align="left" sort="str" id="prtcontSerach">#cspan</column>
		<column width="10" type="ro" align="center" sort="na" id="articleId" hidden="true"><![CDATA[<div style='text-align:center;font-weight:bold;'>논문제어번호</div>]]></column>
		<column width="10" type="ro" align="center" sort="na" id="seqAuthor" hidden="true"><![CDATA[<div style='text-align:center;font-weight:bold;'>저자일련번호</div>]]></column>
		<column width="10" type="ro" align="center" sort="na" id="blngAgcCd" hidden="true"><![CDATA[<div style='text-align:center;font-weight:bold;'>소속기관코드</div>]]></column>
	   	<settings>
	   		<colwidth>PX</colwidth>
	   	</settings>
	</head>
 <c:if test="${not empty articlePartiList}">
	<c:forEach items="${articlePartiList}" var="pl" varStatus="st">
		<row id='${pl.articleId}_${pl.seqAuthor}'>
			<cell>${st.count}</cell>
			<cell>${pl.tpiDvsCd}</cell>
			<cell>${fn:escapeXml(pl.prtcpntNm)}</cell>
			<cell>${contextPath}/images/common/icon/btn_search.png^Author search^javascript:findAuthor("${pl.articleId}_${pl.seqAuthor}");^_self</cell>
			<cell>${fn:escapeXml(pl.prtcpntFullNm)}</cell>
			<cell>${pl.prtcpntId}</cell>
			<cell><c:if test="${pl.isRecord eq 'Y' }" >1</c:if><c:if test="${pl.isRecord ne 'Y' }" >0</c:if></cell>
			<cell>${fn:escapeXml(pl.blngAgcNm)}</cell>
			<cell>${contextPath}/images/common/icon/btn_search.png^Inst. search^javascript:findInst("${pl.articleId}_${pl.seqAuthor}");^_self</cell>
			<cell>${fn:escapeXml(pl.articleId)}</cell>
			<cell>${fn:escapeXml(pl.seqAuthor)}</cell>
			<cell>${fn:escapeXml(pl.blngAgcCd)}</cell>
		</row>
	</c:forEach>
 </c:if>
</rows>
