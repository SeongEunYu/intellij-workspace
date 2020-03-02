<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../../gridInit.jsp" %>
<rows>
	<head>
		<column width="50" type="ro" align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>NO</div>]]></column>
		<column width="80" type="ro" align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>RIMS관리번호</div>]]></column>
		<column width="80" type="ro" align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>개최일자</div>]]></column>
		<column width="*" type="ro" align="left" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>논문명</div>]]></column>
		<column width="200" type="ro" align="left" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>개최기관명</div>]]></column>
		<column width="100" type="ro" align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>승인상태</div>]]></column>
		<column width="100" type="ro" align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>최종수정일자</div>]]></column>
		<column width="80" type="ro" align="center" sort="na"><![CDATA[<div style='text-align:center;font-weight:bold;'>삭제여부</div>]]></column>
	</head>
	 <c:if test="${not empty conferenceList}">
		<c:forEach items="${conferenceList}" var="cl" varStatus="st">
			<row id='conference_${cl.conferenceId}' <c:if test="${cl.recordStatus eq '0'}">class="appr"</c:if>>
				<cell>${st.count}</cell>
				<cell>${fn:escapeXml(cl.conferenceId)}</cell>
				<cell>${rims:toDateFormatToken(cl.ancmDate, '.')}</cell>
				<cell>${fn:escapeXml(cl.orgLangPprNm)}</cell>
				<cell>${fn:escapeXml(cl.cfrcNm)}</cell>
				<cell>${rims:codeValue('1400',cl.apprDvsCd)}</cell>
				<fmt:formatDate var="modDate" value="${cl.modDate}" pattern="yyyy-MM-dd" />
				<cell>${fn:escapeXml(modDate)}</cell>
				<cell>${fn:escapeXml(cl.delDvsCd) eq 'Y' ? 'Y' : 'N'}</cell>
			</row>
		</c:forEach>
	 </c:if>
	 <c:if test="${empty conferenceList}">
		<row id="0">
				<cell colspan="8">No Results. Try Again!</cell>
		</row>
	 </c:if>
</rows>
