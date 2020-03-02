<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp"%>
<rows>
	<head>
		<c:if test="${param.jnlGubun eq 'byPerson' or param.jnlGubun eq 'byDeptApplyear' or param.jnlGubun eq 'byDeptItlyear'}">
			<column width="120" type="ro" sort="na" id="groupDept"><![CDATA[<div style='text-align:center;font-weight:bold;'>학(부)과</div>]]></column>
		</c:if>
		<c:if test="${param.jnlGubun eq 'byPerson'}">
			<column width="60" type="ro" sort="na" id="prtcpntId"><![CDATA[<div style='text-align:center;font-weight:bold;'>사번</div>]]></column>
			<column width="120" type="ro" sort="na" id="userNm"><![CDATA[<div style='text-align:center;font-weight:bold;'>성명</div>]]></column>
		</c:if>
		<c:if test="${param.jnlGubun eq 'byApplyear' or param.jnlGubun eq 'byApplyearItlcnt' or param.jnlGubun eq 'byDeptApplyear'}">
			<column width="*" type="ro" sort="str" id="applyear"><![CDATA[<div style='text-align:center;font-weight:bold;'><spring:message code='grid.stats.patent.applyear'/></div>]]></column>
		</c:if>
		<c:if test="${param.jnlGubun eq 'byApplyear' or param.jnlGubun eq 'byApplyearItlcnt' or param.jnlGubun eq 'byPerson' or param.jnlGubun eq 'byDeptApplyear'}">
			<column width="*" type="ron" sort="int" format="0,000" id="aIntl"><![CDATA[<div style='text-align:center;font-weight:bold;'><spring:message code='grid.stats.patent.application'/></div>]]></column>
			<column width="*" type="ron" sort="int" format="0,000" id="aDmst">#cspan</column>
			<column width="*" type="ron" sort="int" format="0,000" id="aTotal">#cspan</column>
		</c:if>
		<c:if test="${param.jnlGubun eq 'byItlyear' or param.jnlGubun eq 'byDeptItlyear'}">
			<column width="*" type="ro" sort="str" id="itlyear"><![CDATA[<div style='text-align:center;font-weight:bold;'><spring:message code='grid.stats.patent.itlyear'/></div>]]></column>
		</c:if>
		<c:if test="${param.jnlGubun eq 'byItlyear' or param.jnlGubun eq 'byApplyearItlcnt' or param.jnlGubun eq 'byPerson' or param.jnlGubun eq 'byDeptItlyear'}">
			<c:if test="${param.jnlGubun eq 'byApplyearItlcnt' or param.jnlGubun eq 'byPerson'}">
			<column width="*" type="ron" sort="int" format="0,000" id="iIntl"><![CDATA[<div style='text-align:center;font-weight:bold;'>등록(출원특허중 등록된 건수)</div>]]></column>
			</c:if>
			<c:if test="${param.jnlGubun eq 'byItlyear' or param.jnlGubun eq 'byDeptItlyear'}">
			<column width="*" type="ron" sort="int" format="0,000" id="iIntl"><![CDATA[<div style='text-align:center;font-weight:bold;'><spring:message code='grid.stats.patent.registration'/></div>]]></column>
			</c:if>
			<column width="*" type="ron" sort="int" format="0,000" id="iDmst">#cspan</column>
			<column width="*" type="ron" sort="int" format="0,000" id="iTotal">#cspan</column>
		</c:if>
		<afterInit>
			<call command="attachHeader">
				<param>#rspan,<c:if test="${param.jnlGubun eq 'byDeptApplyear' or param.jnlGubun eq 'byDeptItlyear'}">#rspan,</c:if><c:if test="${param.jnlGubun eq 'byPerson'}">#rspan,#rspan,</c:if>
					<spring:message code='grid.stats.patent.intl'/>,<spring:message code='grid.stats.patent.dmst'/>,<spring:message code='grid.common.total'/>
					<c:if test="${param.jnlGubun eq 'byApplyearItlcnt' or param.jnlGubun eq 'byPerson'}">
					,<spring:message code='grid.stats.patent.intl'/>,<spring:message code='grid.stats.patent.dmst'/>,<spring:message code='grid.common.total'/>
					</c:if>
				</param>
				<param>text-align:center;,
					<c:if test="${param.jnlGubun eq 'byDeptApplyear' or param.jnlGubun eq 'byDeptItlyear'}">,</c:if>
					<c:if test="${param.jnlGubun eq 'byPerson'}">,,</c:if>
					text-align:center;,text-align:center;,text-align:center;
					<c:if test="${param.jnlGubun eq 'byApplyearItlcnt' or param.jnlGubun eq 'byPerson'}">
					,text-align:center;,text-align:center;,text-align:center;
					</c:if>
				</param>
			</call>
			<call command="attachFooter">
				<param>
					<c:if test="${param.jnlGubun eq 'byApplyearItlcnt' or param.jnlGubun eq 'byApplyear' or param.jnlGubun eq 'byItlyear'}"><spring:message code='grid.common.total'/>,</c:if>
					<c:if test="${param.jnlGubun eq 'byDeptApplyear' or param.jnlGubun eq 'byDeptItlyear'}"><spring:message code='grid.common.total'/>,#cspan,</c:if>
					<c:if test="${param.jnlGubun eq 'byPerson'}"><spring:message code='grid.common.total'/>,#cspan,#cspan,</c:if>
					<c:if test="${param.jnlGubun eq 'byApplyearItlcnt' or param.jnlGubun eq 'byPerson' or param.jnlGubun eq 'byDeptApplyear' or param.jnlGubun eq 'byDeptItlyear' or param.jnlGubun eq 'byApplyear' or param.jnlGubun eq 'byItlyear'}">
					&lt;span onclick="footerClick('fAcqsNtnDvsCd=2');"&gt;{#stat_total}&lt;/a&gt;,
					&lt;span onclick="footerClick('fAcqsNtnDvsCd=1');"&gt;{#stat_total}&lt;/a&gt;,
					&lt;span onclick="footerClick('');"&gt;{#stat_total}&lt;/a&gt;,
					</c:if>
					<c:if test="${param.jnlGubun eq 'byApplyearItlcnt' or param.jnlGubun eq 'byPerson'}">
					&lt;span onclick="footerClick('fAcqsNtnDvsCd=2&amp;fAcqsDvsCd=1');"&gt;{#stat_total}&lt;/a&gt;,
					&lt;span onclick="footerClick('fAcqsNtnDvsCd=1&amp;fAcqsDvsCd=1');"&gt;{#stat_total}&lt;/a&gt;,
					&lt;span onclick="footerClick('fAcqsDvsCd=1');"&gt;{#stat_total}&lt;/a&gt;,
					</c:if>
				</param>
				<param>text-align:center;,
					<c:if test="${param.jnlGubun eq 'byDeptApplyear' or param.jnlGubun eq 'byDeptItlyear'}">,</c:if>
					<c:if test="${param.jnlGubun eq 'byPerson'}">,,</c:if>
					text-align:center;,text-align:center;,text-align:center;
					<c:if test="${param.jnlGubun eq 'byApplyearItlcnt' or param.jnlGubun eq 'byPerson'}">
					,text-align:center;,text-align:center;,text-align:center;
					</c:if>
				</param>
			</call>
		</afterInit>
	</head>
	<c:if test="${not empty list}">
		<c:forEach items="${list}" var="stats" varStatus="st">
			<row id="${st.count}">
				<c:if test="${param.jnlGubun eq 'byPerson' or param.jnlGubun eq 'byDeptApplyear' or param.jnlGubun eq 'byDeptItlyear'}">
					<cell align="left">${stats.groupDept}</cell>
				</c:if>
				<c:if test="${param.jnlGubun eq 'byPerson'}">
					<cell align="left">${stats.prtcpntId}</cell>
					<cell align="left">${stats.korNm}</cell>
				</c:if>
				<c:if test="${param.jnlGubun eq 'byApplyear' or param.jnlGubun eq 'byApplyearItlcnt' or param.jnlGubun eq 'byDeptApplyear'}">
					<cell>${stats.applyear}</cell>
				</c:if>
				<c:if test="${param.jnlGubun eq 'byApplyear' or param.jnlGubun eq 'byApplyearItlcnt' or param.jnlGubun eq 'byPerson' or param.jnlGubun eq 'byDeptApplyear'}">
				<cell align="center">${stats.applIntrlCo}</cell>
				<cell align="center">${stats.applDmstcCo}</cell>
				<cell align="center">${stats.applTotal}</cell>
				</c:if>
				<c:if test="${param.jnlGubun eq 'byItlyear' or param.jnlGubun eq 'byDeptItlyear'}">
					<cell>${stats.itlyear}</cell>
				</c:if>
				<c:if test="${param.jnlGubun eq 'byItlyear' or param.jnlGubun eq 'byApplyearItlcnt' or param.jnlGubun eq 'byPerson' or param.jnlGubun eq 'byDeptItlyear'}">
				<cell align="center">${stats.itlIntrlCo}</cell>
				<cell align="center">${stats.itlDmstcCo}</cell>
				<cell align="center">${stats.itlTotal}</cell>
				</c:if>
			</row>
		</c:forEach>
	</c:if>
</rows>