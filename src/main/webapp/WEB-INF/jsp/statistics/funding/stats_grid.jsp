<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp"%>
<rows>
	<head>
		<column width="50" type="ro" sort="str" id="fundingId"><![CDATA[<div style='text-align:center;font-weight:bold;'>관리번호</div>]]></column>
		<c:if test="${param.statsGubun eq 'F'}">
		<column width="70" type="ro" sort="str" id="sbjtNo"><![CDATA[<div style='text-align:center;font-weight:bold;'>과제번호</div>]]></column>
		<column width="70" type="ro"  sort="str" id="agcSbjtNo">#cspan</column>
		<column width="100" type="ro" sort="str" id="rschYm"><![CDATA[<div style='text-align:center;font-weight:bold;'>수행기간</div>]]></column>
		<column width="*" type="ro" sort="str" id="rschSbjtNm"><![CDATA[<div style='text-align:center;font-weight:bold;'>과제명</div>]]></column>
		<column width="30" type="ro" sort="str" id="rsrcctSpptDvsCd"><![CDATA[<div style='text-align:center;font-weight:bold;'>지원<br/>구분</div>]]></column>
		<column width="90" type="ron" sort="int" format="0,000" id="totRsrcct"><![CDATA[<div style='text-align:center;font-weight:bold;'>과제금액</div>]]></column>
		<column width="80" type="ro" sort="str" id="cptGovOfficNm"><![CDATA[<div style='text-align:center;font-weight:bold;'>소관정부부처명</div>]]></column>
		<column width="80" type="ro" sort="str" id="rsrcctSpptAgcNm"><![CDATA[<div style='text-align:center;font-weight:bold;'>연구비지원기관</div>]]></column>
		<column width="80" type="ro" sort="str" id="bizNm"><![CDATA[<div style='text-align:center;font-weight:bold;'>지원사업명</div>]]></column>
		<column width="40" type="ro" sort="str" id="prtcpntId"><![CDATA[<div style='text-align:center;font-weight:bold;'>연구책임자</div>]]></column>
		<column width="40" type="ro" sort="str" id="korNm">#cspan</column>
		<column width="70" type="ro" sort="str" id="deptKor">#cspan</column>
		<column width="40" type="ro" sort="int" id="artCnt" ><![CDATA[<div style='text-align:center;font-weight:bold;'>논문</div>]]></column>
		<column width="40" type="ro" sort="int" id="conCnt"><![CDATA[<div style='text-align:center;font-weight:bold;'>학술<br/>활동</div>]]></column>
		<column width="40" type="ro" sort="int" id="patCnt"><![CDATA[<div style='text-align:center;font-weight:bold;'>지식<br/>재산</div>]]></column>
		<column width="40" type="ro" sort="int" id="totalCnt"><![CDATA[<div style='text-align:center;font-weight:bold;'>합계</div>]]></column>
		</c:if>
		<c:if test="${param.statsGubun eq 'A'}">
		<column width="120" type="txt" sort="str" id="ut"><![CDATA[<div style='text-align:center;font-weight:bold;'>UT</div>]]></column>
		<column width="80" type="ro" sort="str" id="pblcYm"><![CDATA[<div style='text-align:center;font-weight:bold;'>출판년월</div>]]></column>
		<column width="*" type="ro" sort="str" id="orgLangPprNm"><![CDATA[<div style='text-align:center;font-weight:bold;'>논문명</div>]]></column>
		<column width="200" type="ro" sort="str" id="scjnlNm"><![CDATA[<div style='text-align:center;font-weight:bold;'>학술지명</div>]]></column>
		<column width="80" type="ro" sort="str" id="relateFundingAt"><![CDATA[<div style='text-align:center;font-weight:bold;'>연구과제없음</div>]]></column>
		<column width="80" type="ro" sort="int" id="fundCnt" ><![CDATA[<div style='text-align:center;font-weight:bold;'>연구과제(건)</div>]]></column>
		</c:if>
		<afterInit>
			<c:if test="${param.statsGubun eq 'F'}">
			<call command="attachHeader">
				<param>#rspan,기관,CAU,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,사번,성명,소속,#rspan,#rspan,#rspan,#rspan</param>
				<param>text-align:center;,text-align:center;,text-align:center;,text-align:center;,text-align:center;,
					text-align:center;,text-align:center;,text-align:center;,text-align:center;,text-align:center;,text-align:center;,
					text-align:center;,text-align:center;,text-align:center;,text-align:center;,text-align:center;,text-align:center;
				</param>
			</call>
			</c:if>
			<call command="attachFooter">
				<param>
					<c:if test="${param.statsGubun eq 'F'}">
					합계,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,
					&lt;a href='javascript:downloadListXlsx("type=A");'&gt;{#stat_total}&lt;/a&gt;,&lt;a href='javascript:downloadListXlsx("type=C");'&gt;{#stat_total}&lt;/a&gt;,&lt;a href='javascript:downloadListXlsx("type=P");'&gt;{#stat_total}&lt;/a&gt;,{#stat_total}
					</c:if>
					<c:if test="${param.statsGubun eq 'A'}">
					합계,#cspan,#cspan,#cspan,#cspan,#cspan,&lt;a href='javascript:downloadListXlsx("type=F");'&gt;{#stat_total}&lt;/a&gt;
					</c:if>
				</param>
				<param>
					<c:if test="${param.statsGubun eq 'F'}">
					text-align:center;,,,,,,,,,,,,,text-align:right;,text-align:right;,text-align:right;,text-align:right;
					</c:if>
					<c:if test="${param.statsGubun eq 'A'}">
					text-align:center;,,,,,,text-align:right;,text-align:right;
					</c:if>
				</param>
			</call>
		</afterInit>
	</head>
	<c:if test="${not empty list}">
		<c:forEach items="${list}" var="stats">
			<c:if test="${param.statsGubun eq 'F'}">
			<row id="${stats.fundingId}">
				<cell>${stats.fundingId}</cell>
				<cell align="left"><c:out value="${fn:escapeXml(stats.sbjtNo)}"/></cell>
				<cell align="left"><c:out value="${fn:escapeXml(stats.agcSbjtNo)}"/></cell>
				<cell align="left">${stats.rschCmcmYm}~${stats.rschEndYm}</cell>
				<cell align="left"><c:out value="${fn:escapeXml(stats.rschSbjtNm)}"/></cell>
				<cell align="center">${rims:codeValue('1280',stats.rsrcctSpptDvsCd)}</cell>
				<cell align="right"><c:out value="${fn:escapeXml(stats.totRsrcct)}"/></cell>
				<cell align="left"><c:out value="${fn:escapeXml(stats.cptGovOfficNm)}"/></cell>
				<cell align="left"><c:out value="${fn:escapeXml(stats.rsrcctSpptAgcNm)}"/></cell>
				<cell align="left"><c:out value="${fn:escapeXml(stats.bizNm)}"/></cell>
				<c:set var="info" value="${fn:split(stats.principalManagerInfo,';')}" />
				<cell align="left"><c:out value="${info[0]}"/></cell>
				<cell align="left"><c:out value="${info[1]}"/></cell>
				<cell align="left"><c:out value="${info[2]}"/></cell>
				<cell align="right">${stats.articleCnt}</cell>
				<cell align="right">${stats.conCnt}</cell>
				<cell align="right">${stats.patentCnt}</cell>
				<cell align="right">${stats.articleCnt+stats.conCnt+stats.patentCnt}</cell>
			</row>
			</c:if>
			<c:if test="${param.statsGubun eq 'A'}">
			<row id="${stats.articleId}">
				<cell align="center">${stats.articleId}</cell>
				<cell align="center">${stats.idSci}</cell>
				<cell align="center">${stats.pblcYm}</cell>
				<cell align="left"><c:out value="${fn:escapeXml(stats.orgLangPprNm)}" /></cell>
				<cell align="left"><c:out value="${fn:escapeXml(stats.scjnlNm)}" /></cell>
				<cell align="center">${stats.relateFundingAt eq 'N' ? 'X' : ''}</cell>
				<cell align="right">${stats.fundingCnt}</cell>
			</row>
			</c:if>
		</c:forEach>
	</c:if>
	<c:if test="${empty list}">
		<row id="0"><cell colspan="9">No Results. Try Again!</cell></row>
	</c:if>
</rows>