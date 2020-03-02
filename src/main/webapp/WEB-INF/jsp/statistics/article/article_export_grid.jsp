<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows>
	<head>
		<column width="10" type="ro" align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>NO</div>]]></column>
		<column width="10" type="ro" align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>Article ID.</div>]]></column>
		<c:if test="${param.statsGubun eq 'person'}">
		<column width="10" type="ro" align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>Pay Roll</div>]]></column>
		<column width="10" type="ro" align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>Name</div>]]></column>
		<column width="10" type="ro" align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>Role</div>]]></column>
		<column width="10" type="ro" align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>Position</div>]]></column>
		<column width="10" type="ro" align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>Department</div>]]></column>
		</c:if>
		<column width="10" type="ro" align="left" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>Journal*</div>]]></column>
		<column width="10" type="ro" align="left" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>Title*</div>]]></column>
		<column width="10" type="ro" align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>Publisher Country</div>]]></column>
		<column width="10" type="ro" align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>ISBN or ISSN*</div>]]></column>
		<column width="10" type="ro" align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>Year</div>]]></column>
		<column width="10" type="ro" align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>Month</div>]]></column>
		<column width="10" type="ro" align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>Day</div>]]></column>
		<column width="10" type="ro" align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>Vol.</div>]]></column>
		<column width="10" type="ro" align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>No</div>]]></column>
		<column width="10" type="ro" align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>Journal Classification</div>]]></column>
		<column width="10" type="ro" align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>SCI or SCOPUS Classification</div>]]></column>
		<column width="10" type="ro" align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>Start Page*</div>]]></column>
		<column width="10" type="ro" align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>End Page</div>]]></column>
		<column width="10" type="ro" align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>SCI TC</div>]]></column>
		<column width="10" type="ro" align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>SCOPUS TC</div>]]></column>
		<column width="10" type="ro" align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>KCI TC</div>]]></column>
		<column width="10" type="ro" align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>SCI ID</div>]]></column>
		<column width="10" type="ro" align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>SCOPUS ID</div>]]></column>
		<column width="10" type="ro" align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>KCI ID</div>]]></column>
		<column width="10" type="ro" align="left" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>Abstarct</div>]]></column>
		<column width="10" type="ro" align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>DOI</div>]]></column>
		<column width="10" type="ro" align="left" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>First Author</div>]]></column>
		<column width="10" type="ro" align="left" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>All Authors</div>]]></column>
		<column width="10" type="ro" align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>No. of Authors</div>]]></column>
		<column width="10" type="ro" align="right" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>ImpactFactor</div>]]></column>
		<column width="10" type="ro" align="right" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>SJR</div>]]></column>
		<column width="10" type="ro" align="right" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>KCI IF</div>]]></column>
		<afterInit>
			<call command="attachHeader"><param>번호,논문번호,<c:if test="${param.statsGubun eq 'person'}">개인번호,성명,참여역할,신분,학(부)과명</c:if>,저널명,논문제목,출판국,ISBN or ISSN*,게재년도,게재월,게재일,권,호,저널구분,SCI구분,시작페이지,종료페이지,SCI인용횟수,SCOPUS인용횟수,KCI인용횟수,SCI ID,SCOPUS ID,KCI ID,초록,DOI,제1저자,전체저자,저자수,실적구분,IF(출판년 ed.),SJR,KCI IF </param></call>
		</afterInit>
	</head>
<c:if test="${not empty articleList}">
<c:forEach items="${articleList}" var="al" varStatus="st">
	<row id="${al.articleId}<c:if test="${param.statsGubun eq 'person'}">;${al.userId}</c:if>">
		<cell>${st.count}</cell>
		<cell><![CDATA[${fn:escapeXml(al.articleId)}]]></cell>
		<c:if test="${param.statsGubun eq 'person'}">
		<cell><![CDATA[${fn:escapeXml(al.empId)}]]></cell>
		<cell><![CDATA[${fn:escapeXml(al.korNm)}]]></cell>
		<cell><![CDATA[${fn:escapeXml(al.tpiDvsKor)}]]></cell>
		<cell><![CDATA[${fn:escapeXml(al.grade1)}]]></cell>
		<cell><![CDATA[${fn:escapeXml(al.deptKor)}]]></cell>
		</c:if>
		<cell><![CDATA[${fn:escapeXml(al.scjnlNm)}]]></cell>
		<cell><![CDATA[${fn:escapeXml(al.orgLangPprNm)}]]></cell>
		<cell><![CDATA[${fn:escapeXml(al.pblcNtnKor)}]]></cell>
		<cell><![CDATA[${fn:escapeXml(al.issnNo)}]]></cell>
		<cell><![CDATA[${fn:escapeXml(al.pblcYear)}]]></cell>
		<cell><![CDATA[${fn:escapeXml(al.pblcMonth)}]]></cell>
		<cell><![CDATA[${fn:escapeXml(al.pblcDay)}]]></cell>
		<cell><![CDATA[${fn:escapeXml(al.volume)}]]></cell>
		<cell><![CDATA[${fn:escapeXml(al.issue)}]]></cell>
		<cell><![CDATA[${fn:escapeXml(al.scjnlDvsKor)}]]></cell>
		<cell><![CDATA[${fn:escapeXml(al.ovrsExclncScjnlKor)}]]></cell>
		<cell><![CDATA[${fn:escapeXml(al.sttPage)}]]></cell>
		<cell><![CDATA[${fn:escapeXml(al.endPage)}]]></cell>
		<cell><![CDATA[${fn:escapeXml(al.tc)}]]></cell>
		<cell><![CDATA[${fn:escapeXml(al.scpTc)}]]></cell>
		<cell><![CDATA[${fn:escapeXml(al.kciTc)}]]></cell>
		<cell><![CDATA[${fn:escapeXml(al.idSci)}]]></cell>
		<cell><![CDATA[${fn:escapeXml(al.idScopus)}]]></cell>
		<cell><![CDATA[${fn:escapeXml(al.idKci)}]]></cell>
		<cell><![CDATA[]]></cell>
		<cell><![CDATA[${fn:escapeXml(al.doi)}]]></cell>
		<cell><![CDATA[${fn:escapeXml(al.firstAuthr)}]]></cell>
		<cell><![CDATA[${fn:escapeXml(al.allAuthors)}]]></cell>
		<cell><![CDATA[${fn:escapeXml(al.totalAthrCnt)}]]></cell>
		<cell><![CDATA[${fn:escapeXml(al.impctFctr)}]]></cell>
		<cell><![CDATA[${fn:escapeXml(al.sjr)}]]></cell>
		<cell><![CDATA[${fn:escapeXml(al.kciIf)}]]></cell>
	</row>
</c:forEach>
</c:if>
<c:if test="${empty articleList}">
	<row id="0">
		<cell colspan="7">No Results. Try Again!</cell>
	</row>
</c:if>
</rows>