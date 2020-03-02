<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../../gridInit.jsp" %>
<rows>
	<head>
		<column width="50" type="ro" align="center" sort="na" id="no"><![CDATA[<div style='text-align:center;font-weight:bold;'>NO</div>]]></column>
		<c:if test="${sysConf['modifiy.show.mngno'] eq 'Y'}">
			<column width="30" type="ro" align="center" sort="na" id="mngNo"><![CDATA[<div style='text-align:center;font-weight:bold;'>Erp No.</div>]]></column>
		</c:if>
		<column width="80" type="ro" align="center" sort="na" id="pblcYm"><![CDATA[<div style='text-align:center;font-weight:bold;'>출판년</div>]]></column>
		<column width="*" type="ro" align="left" sort="na" id="orgLangPprNm"><![CDATA[<div style='text-align:center;font-weight:bold;'>논문명</div>]]></column>
		<column width="200" type="ro" align="left" sort="na" id="scjnlNm"><![CDATA[<div style='text-align:center;font-weight:bold;'>저널명</div>]]></column>
		<column width="100" type="ro" align="center" sort="na" id="apprDvsCd"><![CDATA[<div style='text-align:center;font-weight:bold;'>승인상태</div>]]></column>
		<column width="100" type="ro" align="center" sort="na" id="modDate"><![CDATA[<div style='text-align:center;font-weight:bold;'>최종수정일자</div>]]></column>
		<column width="80" type="ro" align="center" sort="na" id="delDvsCd"><![CDATA[<div style='text-align:center;font-weight:bold;'>삭제여부</div>]]></column>
	</head>

	 <c:if test="${not empty articleList}">
		<c:forEach items="${articleList}" var="al" varStatus="st">
			<row id='article_${al.articleId}' <c:if test="${al.recordStatus eq '0'}">class="appr"</c:if>>
				<cell>${st.count}</cell>
				<c:if test="${sysConf['modifiy.show.mngno'] eq 'Y'}">
				<cell>${fn:escapeXml(al.mngNo)}</cell>
				</c:if>
				<cell>${rims:toDateFormatToken(al.pblcYm, '.')}</cell>
				<cell>${fn:escapeXml(al.orgLangPprNm)}</cell>
				<cell>${fn:escapeXml(al.scjnlNm)}</cell>
				<%--
				<cell><%=StringUtils.defaultString(code1420.get(ObjectUtils.toString(articleList.get(i).get("VRFC_DVS_CD"))))</cell>
				--%>
				<cell>${rims:codeValue('1400',al.apprDvsCd)}</cell>
				<fmt:formatDate var="modDate" value="${al.modDate}" pattern="yyyy-MM-dd" />
				<cell>${fn:escapeXml(modDate)}</cell>
				<cell>${fn:escapeXml(al.delDvsCd) eq 'Y' ? 'Y' : 'N'}</cell>
			</row>
		</c:forEach>
	 </c:if>
	 <c:if test="${empty articleList}">
		<row id="0">
				<cell colspan="7">No Results. Try Again!</cell>
		</row>
	 </c:if>
</rows>
