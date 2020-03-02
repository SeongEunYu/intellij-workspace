<%@page import="kr.co.argonet.r2rims.constant.R2Constant"%>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../gridInit.jsp" %>
<rows>

	<head>
		<column width="40" type="ro" align="center" sort="na" id="no"><![CDATA[<div style='text-align:center;font-weight:bold;'>NO</div>]]></column>
		<column width="*" type="ro" align="left" sort="na" id="articleInfo"><![CDATA[<div style='text-align:center;font-weight:bold;'>연구과제정보</div>]]></column>
	   	<settings>
	   		<colwidth>PX</colwidth>
	   	</settings>
	</head>

	<c:if test="${not empty fundingList}">
		<c:forEach items="${fundingList}" var="fl" varStatus="st">
			<row id="${fn:escapeXml(fl.fundingId)}">
				<cell>${st.count}</cell>
				<cell><![CDATA[
					<span style="font-weight: bold; color: #1d6dc6;padding: 0 0 0 13px;">${fl.rschSbjtNm}</span><br/>
					]]>
				</cell>
			</row>
		</c:forEach>
	</c:if>
</rows>