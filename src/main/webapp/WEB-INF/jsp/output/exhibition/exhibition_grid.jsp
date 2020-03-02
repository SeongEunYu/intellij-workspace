<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows total_count="${totalCount}" pos="${posStart}">
	 <c:if test="${not empty exhibitionList}">
	 	<c:forEach items="${exhibitionList}" var="el" varStatus="st">
		 <row id="${el.userId}_${el.exhibitionId}">
			<cell>${posStart + st.count}</cell>
			<c:if test="${not gSessMode and sessionScope.auth.adminDvsCd ne 'R' and sessionScope.auth.adminDvsCd ne 'S' }">
				<cell>${el.exhibitionId}</cell>
				<cell><c:out value="${el.userId}"/></cell>
				<cell><c:out value="${el.korNm}"/></cell>
				<cell><c:out value="${fn:escapeXml(el.orgLangXhbtAncmNm)}"/></cell>
				<cell>${rims:codeValue('1170',el.ancmAcpsDvsCd)}</cell>
				<cell><c:out value="${rims:toDateFormatToken(el.ancmYm,'.')}"/></cell>
				<cell><c:out value="${fn:escapeXml(el.ancmPlcNm)}"/></cell>
				<cell><c:out value="${fn:escapeXml(el.planMngCrpNm)}"/></cell>
				<cell>${rims:codeValue('1400',el.apprDvsCd)}</cell>
				<cell><c:out value="${empty el.delDvsCd ? 'N' : el.delDvsCd}"/></cell>
			</c:if>
			<c:if test="${gSessMode or (sessionScope.auth.adminDvsCd eq 'R' or sessionScope.auth.adminDvsCd eq 'S')}">
				<cell>${el.exhibitionId}</cell>
				<cell><c:out value="${fn:escapeXml(el.orgLangXhbtAncmNm)}"/></cell>
				<cell>${rims:codeValue('1170',el.ancmAcpsDvsCd)}</cell>
				<cell><c:out value="${rims:toDateFormatToken(el.ancmYm,'.')}"/></cell>
				<cell><c:out value="${fn:escapeXml(el.ancmPlcNm)}"/></cell>
				<cell><c:out value="${fn:escapeXml(el.planMngCrpNm)}"/></cell>
				<cell>${rims:codeValue('1400',el.apprDvsCd)}</cell>
			</c:if>
		 </row>
	 	</c:forEach>
	 </c:if>
</rows>