<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp"%>
<rows>
	<head>
		<c:if test="${(param.statsGubun eq 'P' and (param.jnlGubun eq 'byPerson' or param.jnlGubun eq 'byDept' or param.jnlGubun eq 'byDeptHldof' or param.jnlGubun eq 'byDeptYear') or (param.statsGubun eq 'A' and param.jnlGubun eq 'byDept') )}">
			<column width="120" type="ro" sort="na" id="groupDept"><![CDATA[<div style='text-align:center;font-weight:bold;'>학(부)과</div>]]></column>
		</c:if>
		<c:if test="${param.statsGubun eq 'P' and param.jnlGubun eq 'byPerson'}">
			<column width="60" type="ro" sort="na" id="prtcpntId"><![CDATA[<div style='text-align:center;font-weight:bold;'>사번</div>]]></column>
			<column width="120" type="ro" sort="na" id="userNm"><![CDATA[<div style='text-align:center;font-weight:bold;'>성명</div>]]></column>
		</c:if>
		<c:if test="${param.statsGubun eq 'P' and param.jnlGubun eq 'byDeptHldof'}">
			<column width="*" type="ro" sort="na" id="hldofYn"><![CDATA[<div style='text-align:center;font-weight:bold;'>재직여부</div>]]></column>
		</c:if>
		<c:if test="${param.jnlGubun eq 'byYear' or param.jnlGubun eq 'byYearEnter' or param.jnlGubun eq 'byDeptYear'}">
			<column width="*" type="ro" sort="str" id="pubyear"><![CDATA[<div style='text-align:center;font-weight:bold;'><spring:message code='stats.article.pubyear'/></div>]]></column>
		</c:if>
		<c:if test="${param.jnlGubun eq 'byYearEnter'}">
			<c:if test="${param.scjnlGubun eq ''}">
				<column width="*" type="ron" sort="int" format="0,000" id="bIntl_j"><![CDATA[<div style='text-align:center;font-weight:bold;'><spring:message code='grid.org.before'/></div>]]></column>
				<column width="*" type="ron" sort="int" format="0,000" id="bIntl_g">#cspan</column>
				<column width="*" type="ron" sort="int" format="0,000" id="bDmst_j">#cspan</column>
				<column width="*" type="ron" sort="int" format="0,000" id="bDmst_g">#cspan</column>
				<column width="*" type="ron" sort="int" format="0,000" id="aIntl_j"><![CDATA[<div style='text-align:center;font-weight:bold;'><spring:message code='grid.org.after'/></div>]]></column>
				<column width="*" type="ron" sort="int" format="0,000" id="aScie">#cspan</column>
				<column width="*" type="ron" sort="int" format="0,000" id="aSsci">#cspan</column>
				<column width="*" type="ron" sort="int" format="0,000" id="aAhci">#cspan</column>
				<column width="*" type="ron" sort="int" format="0,000" id="intl_j"><![CDATA[<div style='text-align:center;font-weight:bold;'><spring:message code='grid.common.total'/></div>]]></column>
				<column width="*" type="ron" sort="int" format="0,000" id="intl_g">#cspan</column>
				<column width="*" type="ron" sort="int" format="0,000" id="dmst_j">#cspan</column>
				<column width="*" type="ron" sort="int" format="0,000" id="dmst_g">#cspan</column>
			</c:if>
			<c:if test="${param.scjnlGubun eq 'S'}">
				<column width="*" type="ron" sort="int" format="0,000" id="bSci"><![CDATA[<div style='text-align:center;font-weight:bold;'><spring:message code='grid.org.before'/></div>]]></column>
				<column width="*" type="ron" sort="int" format="0,000" id="bScie">#cspan</column>
				<column width="*" type="ron" sort="int" format="0,000" id="bSsci">#cspan</column>
				<column width="*" type="ron" sort="int" format="0,000" id="bAhci">#cspan</column>
				<column width="*" type="ron" sort="int" format="0,000" id="aSci"><![CDATA[<div style='text-align:center;font-weight:bold;'><spring:message code='grid.org.after'/></div>]]></column>
				<column width="*" type="ron" sort="int" format="0,000" id="aScie">#cspan</column>
				<column width="*" type="ron" sort="int" format="0,000" id="aSsci">#cspan</column>
				<column width="*" type="ron" sort="int" format="0,000" id="aAhci">#cspan</column>
				<column width="*" type="ron" sort="int" format="0,000" id="sci"><![CDATA[<div style='text-align:center;font-weight:bold;'><spring:message code='grid.common.total'/></div>]]></column>
				<column width="*" type="ron" sort="int" format="0,000" id="scie">#cspan</column>
				<column width="*" type="ron" sort="int" format="0,000" id="ssci">#cspan</column>
				<column width="*" type="ron" sort="int" format="0,000" id="ahci">#cspan</column>
			</c:if>
			<c:if test="${param.scjnlGubun eq 'SCOPUS'}">
				<column width="*" type="ron" sort="int" format="0,000" id="bScopus"><![CDATA[<div style='text-align:center;font-weight:bold;'><spring:message code='grid.org.before'/></div>]]></column>
				<column width="*" type="ron" sort="int" format="0,000" id="aScopus"><![CDATA[<div style='text-align:center;font-weight:bold;'><spring:message code='grid.org.after'/></div>]]></column>
				<column width="*" type="ron" sort="int" format="0,000" id="scopus"><![CDATA[<div style='text-align:center;font-weight:bold;'><spring:message code='grid.common.total'/></div>]]></column>
			</c:if>
		</c:if>
		<c:if test="${param.jnlGubun ne 'byYearEnter'}">
			<c:if test="${param.scjnlGubun eq ''}">
				<column width="*" type="ron" sort="int" format="0,000" id="intl_j" ><![CDATA[<div style='text-align:center;font-weight:bold;'>국제저명학술지<br/>(SCI & SCOPUS)</div>]]></column>
				<column width="*" type="ron" sort="int" format="0,000" id="intl_g"><![CDATA[<div style='text-align:center;font-weight:bold;'>국제일반학술지</div>]]></column>
				<column width="*" type="ron" sort="int" format="0,000" id="dmst_j"><![CDATA[<div style='text-align:center;font-weight:bold;'>국내저명학술지<br/>(KCI)</div>]]></column>
				<column width="*" type="ron" sort="int" format="0,000" id="dmst_g"><![CDATA[<div style='text-align:center;font-weight:bold;'>국내일반학술지</div>]]></column>
				<column width="*" type="ron" sort="int" format="0,000" id="other"><![CDATA[<div style='text-align:center;font-weight:bold;'>기타</div>]]></column>
				<column width="*" type="ron" sort="int" format="0,000" id="total"><![CDATA[<div style='text-align:center;font-weight:bold;'><spring:message code='grid.common.total'/></div>]]></column>
				<column width="*" type="ron" sort="int" format="0,000.000" id="total_if"><![CDATA[<div style='text-align:center;font-weight:bold;'><spring:message code='grid.stats.article.totalif'/></div>]]></column>
				<column width="*" type="ron" sort="int" format="0,000" id="total_tc"><![CDATA[<div style='text-align:center;font-weight:bold;'><spring:message code='grid.stats.article.totaltc'/></div>]]></column>
				<column width="*" type="ron" sort="int" format="0,000" id="co_has_if"><![CDATA[<div style='text-align:center;font-weight:bold;'><spring:message code='grid.stats.article.includeif'/></div>]]></column>
				<column width="*" type="ron" sort="int" format="0,000" id="co_has_tc"><![CDATA[<div style='text-align:center;font-weight:bold;'><spring:message code='grid.stats.article.includetc'/></div>]]></column>
			</c:if>
			<c:if test="${param.scjnlGubun eq 'S'}">
				<column width="*" type="ron" sort="int" format="0,000" id="sci"><![CDATA[<div style='text-align:center;font-weight:bold;'>SCI</div>]]></column>
				<column width="*" type="ron" sort="int" format="0,000" id="scie"><![CDATA[<div style='text-align:center;font-weight:bold;'>SCIE</div>]]></column>
				<column width="*" type="ron" sort="int" format="0,000" id="ssci"><![CDATA[<div style='text-align:center;font-weight:bold;'>SSCI</div>]]></column>
				<column width="*" type="ron" sort="int" format="0,000" id="ahci"><![CDATA[<div style='text-align:center;font-weight:bold;'>A&HCI</div>]]></column>
				<column width="*" type="ron" sort="int" format="0,000" id="total"><![CDATA[<div style='text-align:center;font-weight:bold;'><spring:message code='grid.common.total'/></div>]]></column>
				<column width="*" type="ron" sort="int" format="0,000.000" id="total_if"><![CDATA[<div style='text-align:center;font-weight:bold;'><spring:message code='grid.stats.article.totalif'/></div>]]></column>
				<column width="*" type="ron" sort="int" format="0,000" id="total_tc"><![CDATA[<div style='text-align:center;font-weight:bold;'><spring:message code='grid.stats.article.totaltc'/></div>]]></column>
				<column width="*" type="ron" sort="int" format="0,000" id="co_has_if"><![CDATA[<div style='text-align:center;font-weight:bold;'><spring:message code='grid.stats.article.includeif'/></div>]]></column>
				<column width="*" type="ron" sort="int" format="0,000" id="co_has_tc"><![CDATA[<div style='text-align:center;font-weight:bold;'><spring:message code='grid.stats.article.includetc'/></div>]]></column>
			</c:if>
			<c:if test="${param.scjnlGubun eq 'SCOPUS'}">
				<column width="*" type="ron" sort="int" format="0,000" id="scopus"><![CDATA[<div style='text-align:center;font-weight:bold;'><spring:message code='grid.stats.article.scopus'/></div>]]></column>
				<column width="*" type="ron" sort="int" format="0,000" id="total_tc"><![CDATA[<div style='text-align:center;font-weight:bold;'><spring:message code='grid.stats.article.totaltc'/></div>]]></column>
				<column width="*" type="ron" sort="int" format="0,000" id="co_has_tc"><![CDATA[<div style='text-align:center;font-weight:bold;'><spring:message code='grid.stats.article.includetc'/></div>]]></column>
			</c:if>
		</c:if>
		<afterInit>
			<c:if test="${param.jnlGubun eq 'byYearEnter' and param.scjnlGubun eq 'S'}">
				<call command="attachHeader">
					<param>#rspan,SCI,SCIE,SSCI,A&amp;HCI,SCI,SCIE,SSCI,A&amp;HCI,SCI,SCIE,SSCI,A&amp;HCI</param>
					<param>text-align:center;,
						text-align:center;,text-align:center;,text-align:center;,text-align:center;,text-align:center;,text-align:center;,
						text-align:center;,text-align:center;,text-align:center;,text-align:center;,text-align:center;,text-align:center;
					</param>
				</call>
			</c:if>
			<c:if test="${param.jnlGubun eq 'byYearEnter' and param.scjnlGubun eq 'SCOPUS'}">
				<call command="attachHeader">
					<param>#rspan,SCOPUS,SCOPUS,SCOPUS</param>
					<param>text-align:center;,
						text-align:center;,text-align:center;,text-align:center;
					</param>
				</call>
			</c:if>
			<c:if test="${param.jnlGubun eq 'byYearEnter' and param.scjnlGubun eq ''}">
				<call command="attachHeader">
					<param>#rspan,국제저명학술지&lt;br/&gt;(SCI &amp; SCOPUS),국제일반학술지,국내저명학술지&lt;br/&gt;(KCI),국내일반학술지,국제저명학술지&lt;br/&gt;(SCI &amp; SCOPUS),국제일반학술지,국내저명학술지&lt;br/&gt;(KCI),국내일반학술지,국제저명학술지&lt;br/&gt;(SCI &amp; SCOPUS),국제일반학술지,국내저명학술지&lt;br/&gt;(KCI),국내일반학술지</param>
					<param>text-align:center;,
						text-align:center;,text-align:center;,text-align:center;,text-align:center;,text-align:center;,text-align:center;,
						text-align:center;,text-align:center;,text-align:center;,text-align:center;,text-align:center;,text-align:center;
					</param>
				</call>
			</c:if>
			<call command="attachFooter">
				<param>
					<c:if test="${param.statsGubun eq 'A' or (param.statsGubun eq 'P' and (param.jnlGubun eq 'byYear' or param.jnlGubun eq 'byDept' or param.jnlGubun eq 'byYearEnter'))}"><spring:message code='grid.common.total'/>,</c:if>
					<c:if test="${param.statsGubun eq 'P' and (param.jnlGubun eq 'byDeptYear' or param.jnlGubun eq 'byDeptHldof')}"><spring:message code='grid.common.total'/>,#cspan,</c:if>
					<c:if test="${param.statsGubun eq 'P' and param.jnlGubun eq 'byPerson'}">합계,#cspan,#cspan,</c:if>
					<c:if test="${param.jnlGubun eq 'byYearEnter'}">
						<c:if test="${param.scjnlGubun eq ''}">
							&lt;span onclick="footerClick('scjnlDvsCd=1&amp;enterGubun=B');"&gt;{#stat_total}&lt;/span&gt;
							,&lt;span onclick="footerClick('scjnlDvsCd=2&amp;enterGubun=B');"&gt;{#stat_total}&lt;/span&gt;
							,&lt;span onclick="footerClick('scjnlDvsCd=3&amp;enterGubun=B');"&gt;{#stat_total}&lt;/span&gt;
							,&lt;span onclick="footerClick('scjnlDvsCd=4&amp;enterGubun=B');"&gt;{#stat_total}&lt;/span&gt;
							,&lt;span onclick="footerClick('scjnlDvsCd=1&amp;enterGubun=A');"&gt;{#stat_total}&lt;/span&gt;
							,&lt;span onclick="footerClick('scjnlDvsCd=2&amp;enterGubun=A');"&gt;{#stat_total}&lt;/span&gt;
							,&lt;span onclick="footerClick('scjnlDvsCd=3&amp;enterGubun=A');"&gt;{#stat_total}&lt;/span&gt;
							,&lt;span onclick="footerClick('scjnlDvsCd=4&amp;enterGubun=A');"&gt;{#stat_total}&lt;/span&gt;
							,&lt;span onclick="footerClick('scjnlDvsCd=1');"&gt;{#stat_total}&lt;/span&gt;
							,&lt;span onclick="footerClick('scjnlDvsCd=2');"&gt;{#stat_total}&lt;/span&gt;
							,&lt;span onclick="footerClick('scjnlDvsCd=3');"&gt;{#stat_total}&lt;/span&gt;
							,&lt;span onclick="footerClick('scjnlDvsCd=4');"&gt;{#stat_total}&lt;/span&gt;
						</c:if>
						<c:if test="${param.scjnlGubun eq 'S'}">
							&lt;span onclick="footerClick('ovrsExclncScjnlPblcYn=1&amp;enterGubun=B');"&gt;{#stat_total}&lt;/span&gt;
							,&lt;span onclick="footerClick('ovrsExclncScjnlPblcYn=2&amp;enterGubun=B');"&gt;{#stat_total}&lt;/span&gt;
							,&lt;span onclick="footerClick('ovrsExclncScjnlPblcYn=3&amp;enterGubun=B');"&gt;{#stat_total}&lt;/span&gt;
							,&lt;span onclick="footerClick('ovrsExclncScjnlPblcYn=4&amp;enterGubun=B');"&gt;{#stat_total}&lt;/span&gt;
							,&lt;span onclick="footerClick('ovrsExclncScjnlPblcYn=1&amp;enterGubun=A');"&gt;{#stat_total}&lt;/span&gt;
							,&lt;span onclick="footerClick('ovrsExclncScjnlPblcYn=2&amp;enterGubun=A');"&gt;{#stat_total}&lt;/span&gt;
							,&lt;span onclick="footerClick('ovrsExclncScjnlPblcYn=3&amp;enterGubun=A');"&gt;{#stat_total}&lt;/span&gt;
							,&lt;span onclick="footerClick('ovrsExclncScjnlPblcYn=4&amp;enterGubun=A');"&gt;{#stat_total}&lt;/span&gt;
							,&lt;span onclick="footerClick('ovrsExclncScjnlPblcYn=1');"&gt;{#stat_total}&lt;/span&gt;
							,&lt;span onclick="footerClick('ovrsExclncScjnlPblcYn=2');"&gt;{#stat_total}&lt;/span&gt;
							,&lt;span onclick="footerClick('ovrsExclncScjnlPblcYn=3');"&gt;{#stat_total}&lt;/span&gt;
							,&lt;span onclick="footerClick('ovrsExclncScjnlPblcYn=4');"&gt;{#stat_total}&lt;/span&gt;
						</c:if>
						<c:if test="${param.scjnlGubun eq 'SCOPUS'}">
							&lt;span onclick="footerClick('enterGubun=B');"&gt;{#stat_total}&lt;/span&gt;
							,&lt;span onclick="footerClick('enterGubun=A');"&gt;{#stat_total}&lt;/span&gt;
							,&lt;span onclick="footerClick('');"&gt;{#stat_total}&lt;/span&gt;
						</c:if>
					</c:if>
					<c:if test="${param.jnlGubun ne 'byYearEnter'}">
						<c:if test="${param.scjnlGubun eq ''}">
							&lt;span onclick="footerClick('scjnlDvsCd=1');"&gt;{#stat_total}&lt;/span&gt;
							,&lt;span onclick="footerClick('scjnlDvsCd=2');"&gt;{#stat_total}&lt;/span&gt;
							,&lt;span onclick="footerClick('scjnlDvsCd=3');"&gt;{#stat_total}&lt;/span&gt;
							,&lt;span onclick="footerClick('scjnlDvsCd=4');"&gt;{#stat_total}&lt;/span&gt;
							,&lt;span onclick="footerClick('scjnlDvsCd=5');"&gt;{#stat_total}&lt;/span&gt;
							,&lt;span onclick="footerClick('');"&gt;{#stat_total}&lt;/span&gt;
							,{#stat_total}
							,{#stat_total}
							,{#stat_total}
							,{#stat_total}
						</c:if>
						<c:if test="${param.scjnlGubun eq 'S'}">
							&lt;span onclick="footerClick('ovrsExclncScjnlPblcYn=1');"&gt;{#stat_total}&lt;/span&gt;
							,&lt;span onclick="footerClick('ovrsExclncScjnlPblcYn=2');"&gt;{#stat_total}&lt;/span&gt;
							,&lt;span onclick="footerClick('ovrsExclncScjnlPblcYn=3');"&gt;{#stat_total}&lt;/span&gt;
							,&lt;span onclick="footerClick('ovrsExclncScjnlPblcYn=4');"&gt;{#stat_total}&lt;/span&gt;
							,&lt;span onclick="footerClick('');"&gt;{#stat_total}&lt;/span&gt;
							,{#stat_total}
							,{#stat_total}
							,{#stat_total}
							,{#stat_total}
						</c:if>
						<c:if test="${param.scjnlGubun eq 'SCOPUS'}">
							&lt;span onclick="footerClick('');"&gt;{#stat_total}&lt;/span&gt;
							,{#stat_total}
							,{#stat_total}
						</c:if>
					</c:if>
				</param>
				<param>text-align:center;,
					<c:if test="${param.scjnlGubun ne 'SCOPUS'}">
						<c:if test="${param.statsGubun eq 'P' and (param.jnlGubun eq 'byDeptYear' or param.jnlGubun eq 'byDeptHldof')}">,</c:if>
						<c:if test="${param.statsGubun eq 'P' and param.jnlGubun eq 'byPerson'}">,,</c:if>
						text-align:right;,text-align:right;,text-align:right;,text-align:right;,text-align:right;,text-align:right;,text-align:right;,text-align:right;,text-align:right;
						<c:if test="${param.scjnlGubun eq '' or param.jnlGubun eq 'byYearEnter'}">,text-align:right;</c:if>
						<c:if test="${param.jnlGubun eq 'byYearEnter'}">,text-align:right;,text-align:right;</c:if>
					</c:if>
					<c:if test="${param.scjnlGubun eq 'SCOPUS'}">
						<c:if test="${param.statsGubun eq 'P' and (param.jnlGubun eq 'byDeptYear' or param.jnlGubun eq 'byDeptHldof')}">,</c:if>
						<c:if test="${param.statsGubun eq 'P' and param.jnlGubun eq 'byPerson'}">,,</c:if>
						text-align:center;,text-align:center;,text-align:center;,text-align:center;,text-align:center;,text-align:center;,text-align:center;,text-align:center;,text-align:center;
						<c:if test="${param.scjnlGubun eq '' or param.jnlGubun eq 'byYearEnter'}">,text-align:center;</c:if>
						<c:if test="${param.jnlGubun eq 'byYearEnter'}">,text-align:center;,text-align:center;</c:if>
						<c:if test="${param.jnlGubun eq 'byYear'}">,text-align:center;,text-align:center;align:center;</c:if>
					</c:if>
				</param>
			</call>
		</afterInit>
	</head>
	<c:if test="${not empty list}">
		<c:forEach items="${list}" var="stats" varStatus="st">
			<row id="${st.count}">
				<c:if test="${(param.statsGubun eq 'P' and (param.jnlGubun eq 'byPerson' or param.jnlGubun eq 'byDept' or param.jnlGubun eq 'byDeptHldof' or param.jnlGubun eq 'byDeptYear') or (param.statsGubun eq 'A' and param.jnlGubun eq 'byDept') )}">
					<cell align="left">${stats.groupDept}</cell>
				</c:if>
				<c:if test="${param.statsGubun eq 'P' and param.jnlGubun eq 'byPerson'}">
					<cell align="left">${stats.prtcpntId}</cell>
					<cell align="left">${stats.korNm}</cell>
				</c:if>
				<c:if test="${param.statsGubun eq 'P' and param.jnlGubun eq 'byDeptHldof'}">
					<cell align="center">${stats.hldofYn}</cell>
				</c:if>
				<c:if test="${param.jnlGubun eq 'byYear' or param.jnlGubun eq 'byYearEnter' or param.jnlGubun eq 'byDeptYear'}">
					<cell align="center">${stats.pubyear eq 'ACCE' ? 'ACCEPT' : stats.pubyear}</cell>
				</c:if>
				<c:if test="${param.jnlGubun eq 'byYearEnter' and param.scjnlGubun eq 'S'}">
					<cell align="right">${stats.beforeSciCo}</cell>
					<cell align="right">${stats.beforeScieCo}</cell>
					<cell align="right">${stats.beforeSsciCo}</cell>
					<cell align="right">${stats.beforeAhciCo}</cell>
					<cell align="right">${stats.afterSciCo}</cell>
					<cell align="right">${stats.afterScieCo}</cell>
					<cell align="right">${stats.afterSsciCo}</cell>
					<cell align="right">${stats.afterAhciCo}</cell>
					<cell align="right">${stats.sciCo}</cell>
					<cell align="right">${stats.scieCo}</cell>
					<cell align="right">${stats.ssciCo}</cell>
					<cell align="right">${stats.ahciCo}</cell>
				</c:if>
				<c:if test="${param.jnlGubun eq 'byYearEnter' and param.scjnlGubun eq 'SCOPUS'}">
					<cell align="center">${stats.beforeScopusCo}</cell>
					<cell align="center">${stats.afterScopusCo}</cell>
					<cell align="center">${stats.scopusCo}</cell>
				</c:if>
				<c:if test="${param.jnlGubun eq 'byYearEnter' and param.scjnlGubun eq ''}">
					<cell align="right">${stats.beforeIntrlJnalArtsCo}</cell>
					<cell align="right">${stats.beforeIntrlGnalArtsCo}</cell>
					<cell align="right">${stats.beforeDmstcKciArtsCo}</cell>
					<cell align="right">${stats.beforeDmstcGnalArtsCo}</cell>
					<cell align="right">${stats.afterIntrlJnalArtsCo}</cell>
					<cell align="right">${stats.afterIntrlGnalArtsCo}</cell>
					<cell align="right">${stats.afterDmstcKciArtsCo}</cell>
					<cell align="right">${stats.afterDmstcGnalArtsCo}</cell>
					<cell align="right">${stats.intrlJnalArtsCo}</cell>
					<cell align="right">${stats.intrlGnalArtsCo}</cell>
					<cell align="right">${stats.dmstcKciArtsCo}</cell>
					<cell align="right">${stats.dmstcGnalArtsCo}</cell>
				</c:if>
				<c:if test="${param.jnlGubun ne 'byYearEnter'}">
					<c:if test="${param.scjnlGubun eq ''}">
						<cell align="right">${stats.intrlJnalArtsCo}</cell>
						<cell align="right">${stats.intrlGnalArtsCo}</cell>
						<cell align="right">${stats.dmstcKciArtsCo}</cell>
						<cell align="right">${stats.dmstcGnalArtsCo}</cell>
						<cell align="right">${stats.othersArtsCo}</cell>
						<cell align="right">${stats.artsTotal}</cell>
						<cell align="right">${stats.ifsum}</cell>
						<cell align="right">${stats.tcsum}</cell>
						<cell align="right">${stats.jifTot}</cell>
						<cell align="right">${stats.tcTot}</cell>
					</c:if>
					<c:if test="${param.scjnlGubun eq 'S'}">
						<cell align="right">${stats.sciCo}</cell>
						<cell align="right">${stats.scieCo}</cell>
						<cell align="right">${stats.ssciCo}</cell>
						<cell align="right">${stats.ahciCo}</cell>
						<cell align="right">${stats.artsTotal}</cell>
						<cell align="right">${stats.ifsum}</cell>
						<cell align="right">${stats.tcsum}</cell>
						<cell align="right">${stats.jifTot}</cell>
						<cell align="right">${stats.tcTot}</cell>
					</c:if>
					<c:if test="${param.scjnlGubun eq 'SCOPUS'}">
						<cell align="center">${stats.scopusCo}</cell>
						<cell align="center">${stats.tcsum}</cell>
						<cell align="center">${stats.tcTot}</cell>
					</c:if>
				</c:if>
			</row>
		</c:forEach>
	</c:if>
</rows>