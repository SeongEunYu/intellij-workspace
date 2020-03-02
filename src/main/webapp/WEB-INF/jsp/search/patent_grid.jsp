<%@page import="kr.co.argonet.r2rims.constant.R2Constant"%>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../gridInit.jsp" %>
<rows>

	<head>
		<column width="40" type="ro" align="center" sort="na" id="no"><![CDATA[<div style='text-align:center;font-weight:bold;'>NO</div>]]></column>
		<column width="*" type="ro" align="left" sort="na" id="articleInfo"><![CDATA[<div style='text-align:center;font-weight:bold;'>특허정보</div>]]></column>
	   	<settings>
	   		<colwidth>PX</colwidth>
	   	</settings>
	</head>

	<c:if test="${not empty patentList}">
		<c:forEach items="${patentList}" var="pl" varStatus="st">
			<row id="${fn:escapeXml(pl.patentId)}">
				<cell>${st.count}</cell>
				<cell><![CDATA[
					<span style="font-weight: bold; color: #1d6dc6;padding: 0 0 0 13px;">${pl.itlPprRgtNm}</span><br/>
					<span style="font-weight: bold; color: #777;padding: 0 0 0 13px;">
						${pl.applRegNtnNm}&nbsp;|&nbsp;출원인:${pl.applRegtNm}&nbsp;|&nbsp;
						<c:if test="${not empty pl.applRegNo}">출원번호:${pl.applRegNo}(${pl.applRegDate})&nbsp;|&nbsp;</c:if>
						<c:if test="${not empty pl.itlPprRgtRegNo}">등록번호:${pl.itlPprRgtRegNo}(${pl.itlPprRgtRegDate})&nbsp;|&nbsp;</c:if>
					    발명인:${pl.invtNm}(${pl.invtCnt})
					</span>
					]]>
				</cell>
			</row>
		</c:forEach>
	</c:if>
</rows>