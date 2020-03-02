<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../../gridInit.jsp" %>
<rows>
	<head>
		<column width="50" type="ro" align="center" sort="na" id="no"><![CDATA[<div style='text-align:center;font-weight:bold;'>NO</div>]]></column>
		<column width="90" type="ro" align="center" sort="na" id="bookId"><![CDATA[<div style='text-align:center;font-weight:bold;'>관리번호</div>]]></column>
		<column width="*" type="ro" align="left" sort="na" id="orgLangBookNm"><![CDATA[<div style='text-align:center;font-weight:bold;'>저역서명</div>]]></column>
		<column width="200" type="ro" align="center" sort="na" id="pblcPlcNm"><![CDATA[<div style='text-align:center;font-weight:bold;'>발행처명</div>]]></column>
		<column width="90" type="ro" align="center" sort="na" id="bookPblcYm"><![CDATA[<div style='text-align:center;font-weight:bold;'>발행년월</div>]]></column>
		<column width="90" type="ro" align="center" sort="na" id="vrfcDvsCd"><![CDATA[<div style='text-align:center;font-weight:bold;'>검증여부</div>]]></column>
		<column width="90" type="ro" align="center" sort="na" id="apprDvsCd"><![CDATA[<div style='text-align:center;font-weight:bold;'>승인여부</div>]]></column>
		<column width="90" type="ro" align="center" sort="na" id="modDate"><![CDATA[<div style='text-align:center;font-weight:bold;'>최종수정일</div>]]></column>
		<column width="90" type="ro" align="center" sort="na" id="delDvsCd"><![CDATA[<div style='text-align:center;font-weight:bold;'>삭제여부</div>]]></column>
	</head>
 <c:if test="${not empty bookList}">
	<c:forEach items="${bookList}" var="bl" varStatus="st">
		<row id='book_${bl.bookId}'>
			<cell>${st.count}</cell>
			<cell>${bl.bookId }</cell>
			<cell><c:out value="${fn:escapeXml(bl.orgLangBookNm)}"/></cell>
			<cell><c:out value="${fn:escapeXml(bl.pblcPlcNm)}"/></cell>
			<cell><c:out value="${rims:toDateFormatToken(bl.bookPblcYm,'.')}"/></cell>
			<cell>${rims:codeValue('1420',bl.vrfcDvsCd)}</cell>
			<cell>${rims:codeValue('1400',bl.apprDvsCd)}</cell>
			<cell><fmt:formatDate value="${bl.modDate}" pattern="yyyy-MM-dd" /></cell>
			<cell>${bl.delDvsCd eq 'Y' ? 'Y' : 'N'}</cell>
		</row>
	</c:forEach>
 </c:if>
</rows>
