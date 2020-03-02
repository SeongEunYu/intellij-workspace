<%@page import="kr.co.argonet.r2rims.constant.R2Constant"%>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../gridInit.jsp" %>
<rows>

	<head>
		<column width="40" type="ro" align="center" sort="na" id="no"><![CDATA[<div style='text-align:center;font-weight:bold;'>NO</div>]]></column>
		<column width="*" type="ro" align="left" sort="na" id="articleInfo"><![CDATA[<div style='text-align:center;font-weight:bold;'>논문정보</div>]]></column>
	   	<settings>
	   		<colwidth>PX</colwidth>
	   	</settings>
	</head>

	<c:if test="${not empty articleList}">
		<c:forEach items="${articleList}" var="al" varStatus="st">
			<c:if test="${not empty al }">
			<row id="${fn:escapeXml(al.articleId)}">
				<cell>${st.count}</cell>
				<cell><![CDATA[
						<span style="font-weight: bold; color: #1d6dc6;padding: 0 0 0 13px;">${al.orgLangPprNm}</span><br/>
					<c:if test="${not empty al.diffLangPprNm}">
						<span style="font-weight: bold; color: #777;padding: 0 0 0 13px;"> (${al.diffLangPprNm}) </span><br/>
					</c:if>
					<span style="font-weight: bold; color: #777;padding: 0 0 0 13px;">
						${al.scjnlNm}, &nbsp;${al.pblcPlcNm}, &nbsp;
						<c:if test="${not empty al.volume}">v.${al.volume},&nbsp;</c:if>
					    <c:if test="${not empty al.issue}">no.${al.issue},&nbsp;</c:if>
					    pp.${al.sttPage} ~ ${al.endPage},&nbsp;${al.pblcYm}
					</span>
					]]>
				</cell>
			</row>
			</c:if>
		</c:forEach>
	</c:if>
</rows>