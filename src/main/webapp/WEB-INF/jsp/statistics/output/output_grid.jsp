<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows>
	<head>
		<column width="120" type="ro" align="center" sort="na" id="regDate"><![CDATA[<div style='text-align:center;font-weight:bold;'>등록일</div>]]></column>
		<c:if test="${param.trgetOutput eq 'article' or param.trgetOutput eq 'conference' or param.trgetOutput eq 'book' or param.trgetOutput eq 'funding' or param.trgetOutput eq 'patent'}">
			<column width="*" type="link" align="right" sort="na" format="0,000" id="rsltApprvCo"><![CDATA[<div style='text-align:center;font-weight:bold;'>승인</div>]]></column>
			<column width="*" type="link" align="right" sort="na" format="0,000" id="rsltUnApprvCo"><![CDATA[<div style='text-align:center;font-weight:bold;'>미승인(승인이 아닌 성과)</div>]]></column>
			<column width="*" type="link" align="right" sort="na" format="0,000" id="rsltDeleteCo"><![CDATA[<div style='text-align:center;font-weight:bold;'>삭제</div>]]></column>
			<column width="*" type="link" align="right" sort="na" format="0,000" id="rlstTotalCo"><![CDATA[<div style='text-align:center;font-weight:bold;'>합계(승인+미승인)</div>]]></column>
			<c:if test="${param.trgetOutput eq 'article'}">
				<column width="*" type="link" align="right" sort="na" format="0,000" id="rlstTotalCo"><![CDATA[<div style='text-align:center;font-weight:bold;'>원문구축</div>]]></column>
			</c:if>
		</c:if>
		<c:if test="${param.trgetOutput eq 'techtrans' or param.trgetOutput eq 'exhibition' or param.trgetOutput eq 'career' or param.trgetOutput eq 'degree' or param.trgetOutput eq 'award' or param.trgetOutput eq 'license'}">
			<column width="*" type="link" align="right" sort="na" format="0,000" id="rsltUnDeleteCo"><![CDATA[<div style='text-align:center;font-weight:bold;'>미삭제</div>]]></column>
			<column width="*" type="link" align="right" sort="na" format="0,000" id="rsltDeleteCo"><![CDATA[<div style='text-align:center;font-weight:bold;'>삭제</div>]]></column>
			<column width="*" type="link" align="right" sort="na" format="0,000" id="rlstTotalCo"><![CDATA[<div style='text-align:center;font-weight:bold;'>소계</div>]]></column>
		</c:if>
		<afterInit>
			<call command="attachFooter">
				<param>합계,
					   &lt;a href=''&gt;{#stat_sum}&lt;/a&gt;,
					   &lt;a href=''&gt;{#stat_sum}&lt;/a&gt;,
					   <c:if test="${param.trgetOutput eq 'article' or param.trgetOutput eq 'conference' or param.trgetOutput eq 'book' or param.trgetOutput eq 'funding' or param.trgetOutput eq 'patent'}">
					   &lt;a href=''&gt;{#stat_sum}&lt;/a&gt;,
					   <c:if test="${param.trgetOutput eq 'article'}">
					   &lt;a href=''&gt;{#stat_sum}&lt;/a&gt;,
					   </c:if>
					   </c:if>
					   &lt;a href=''&gt;{#stat_sum}&lt;/a&gt;
				</param>
				<param>text-align:center;,
					text-align:right;,text-align:right;,text-align:right;,text-align:right;,text-align:right;
				</param>
			</call>
		</afterInit>
	</head>
<c:if test="${not empty rsltList}">
	<c:forEach items="${rsltList}" var="rl" varStatus="st">
		<row id="${rl.regDate}">
			<cell>${rl.regDate}</cell>
			<c:if test="${param.trgetOutput eq 'article' or param.trgetOutput eq 'conference' or param.trgetOutput eq 'book' or param.trgetOutput eq 'funding' or param.trgetOutput eq 'patent'}">
				<cell><![CDATA[<fmt:formatNumber value="${rl.rsltApprvCo}" type="number"/>^javascript:exportRslt("${rl.regDate}","apprv")^_self]]></cell>
				<cell><![CDATA[<fmt:formatNumber value="${rl.rsltUnApprvCo}" type="number"/>^javascript:exportRslt("${rl.regDate}","unApprv")^_self]]></cell>
				<cell><![CDATA[<fmt:formatNumber value="${rl.rsltDeleteCo}" type="number"/>^javascript:exportRslt("${rl.regDate}","delete")^_self]]></cell>
				<cell><![CDATA[<fmt:formatNumber value="${rl.rsltTotalCo}" type="number"/>^javascript:exportRslt("${rl.regDate}","total")^_self]]></cell>
				<c:if test="${param.trgetOutput eq 'article'}">
				<cell><![CDATA[<fmt:formatNumber value="${rl.fileCo}" type="number"/>^javascript:exportRslt("${rl.regDate}","file")^_self]]></cell>
				</c:if>
			</c:if>
			<c:if test="${param.trgetOutput eq 'techtrans' or param.trgetOutput eq 'exhibition' or param.trgetOutput eq 'career' or param.trgetOutput eq 'degree' or param.trgetOutput eq 'award' or param.trgetOutput eq 'license'}">
				<cell><![CDATA[<fmt:formatNumber value="${rl.rsltUnDeleteCo}" type="number"/>^javascript:exportRslt("${rl.regDate}","unDelete")^_self]]></cell>
				<cell><![CDATA[<fmt:formatNumber value="${rl.rsltDeleteCo}" type="number"/>^javascript:exportRslt("${rl.regDate}","delete")^_self]]></cell>
				<cell><![CDATA[<fmt:formatNumber value="${rl.rsltTotalCo}" type="number"/>^javascript:exportRslt("${rl.regDate}","total")^_self]]></cell>
			</c:if>
		</row>
	</c:forEach>
</c:if>
</rows>