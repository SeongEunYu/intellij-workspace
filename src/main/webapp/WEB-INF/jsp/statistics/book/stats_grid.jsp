<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp"%>
<rows>
	<head>
		<c:if test="${param.jnlGubun eq 'byPerson' or param.jnlGubun eq 'byDept' or param.jnlGubun eq 'byDeptYear'}">
			<column width="120" type="ro" sort="na" id="groupDept"><![CDATA[<div style='text-align:center;font-weight:bold;'>학(부)과</div>]]></column>
		</c:if>
		<c:if test="${param.jnlGubun eq 'byPerson'}">
			<column width="60" type="ro" sort="na" id="prtcpntId"><![CDATA[<div style='text-align:center;font-weight:bold;'>사번</div>]]></column>
			<column width="120" type="ro" sort="na" id="userNm"><![CDATA[<div style='text-align:center;font-weight:bold;'>성명</div>]]></column>
		</c:if>
		<c:if test="${param.jnlGubun eq 'byYear' or param.jnlGubun eq 'byDeptYear'}">
			<column width="*" type="ro" sort="str" id="pubyear"><![CDATA[<div style='text-align:center;font-weight:bold;'><spring:message code='stats.book.pubyear'/></div>]]></column>
		</c:if>
		<column width="*" type="ron" sort="int" format="0,000" id="intl"><![CDATA[<div style='text-align:center;font-weight:bold;'><spring:message code='grid.stats.book.intl'/></div>]]></column>
		<column width="*" type="ron" sort="int" format="0,000" id="dmst"><![CDATA[<div style='text-align:center;font-weight:bold;'><spring:message code='grid.stats.book.dmst'/></div>]]></column>
		<column width="*" type="ron" sort="int" format="0,000" id="other"><![CDATA[<div style='text-align:center;font-weight:bold;'><spring:message code='grid.common.none'/></div>]]></column>
		<column width="*" type="ron" sort="int" format="0,000" id="total"><![CDATA[<div style='text-align:center;font-weight:bold;'><spring:message code='grid.common.total'/></div>]]></column>
		<afterInit>
			<call command="attachFooter">
				<param>
					<c:if test="${param.jnlGubun eq 'byYear' or param.jnlGubun eq 'byDept'}"><spring:message code='grid.common.total'/>,</c:if>
					<c:if test="${param.jnlGubun eq 'byDeptYear'}"><spring:message code='grid.common.total'/>,#cspan,</c:if>
					<c:if test="${param.jnlGubun eq 'byPerson'}"><spring:message code='grid.common.total'/>,#cspan,#cspan,</c:if>
					&lt;span onclick="footerClick('jnlDvsCd=2');"&gt;{#stat_total}&lt;/a&gt;,
					&lt;span onclick="footerClick('jnlDvsCd=1');"&gt;{#stat_total}&lt;/a&gt;,
					&lt;span onclick="footerClick('jnlDvsCd=0');"&gt;{#stat_total}&lt;/a&gt;,
					&lt;span onclick="footerClick('');"&gt;{#stat_total}&lt;/a&gt;
				</param>
				<param>text-align:center;,
					<c:if test="${param.jnlGubun eq 'byDeptYear'}">,</c:if>
					<c:if test="${param.jnlGubun eq 'byPerson'}">,,</c:if>
					text-align:center;,text-align:center;,text-align:center;,text-align:center;
				</param>
			</call>
		</afterInit>
	</head>
	<c:if test="${not empty list}">
		<c:forEach items="${list}" var="stats" varStatus="st">
			<row id="${st.count}">
				<c:if test="${param.jnlGubun eq 'byPerson' or param.jnlGubun eq 'byDept' or param.jnlGubun eq 'byDeptYear'}">
					<cell align="left">${stats.groupDept}</cell>
				</c:if>
				<c:if test="${param.jnlGubun eq 'byPerson'}">
					<cell align="left">${stats.prtcpntId}</cell>
					<cell align="left">${stats.korNm}</cell>
				</c:if>
				<c:if test="${param.jnlGubun eq 'byYear' or param.jnlGubun eq 'byDeptYear'}">
					<cell>${stats.pubyear}</cell>
				</c:if>
				<cell align="center">${stats.intrlCo}</cell>
				<cell align="center">${stats.dmstcCo}</cell>
				<cell align="center">${stats.othersCo}</cell>
				<cell align="center">${stats.bookTotal}</cell>
			</row>
		</c:forEach>
	</c:if>
</rows>