<?xml version="1.0" encoding="UTF-8"?>
<%@page import="kr.co.argonet.r2rims.util.LanguageUtil"%>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows total_count="${totalCount}" pos="${posStart}">
	 <c:if test="${not empty conferenceList}">
		<c:forEach items="${conferenceList}" var="cl" varStatus="st">
			<row id='admin_${cl.conferenceId}_<c:out value="${param.appr}"/>_N' <c:if test="${cl.recordStatus eq '0'}">class="appr"</c:if>>
				<cell>${posStart + st.count}</cell>
				<c:if test="${not gSessMode and sessionScope.auth.adminDvsCd ne 'R' and sessionScope.auth.adminDvsCd ne 'S' }">
					<cell>${cl.conferenceId }</cell>
					<cell><c:out value="${rims:toDateFormatToken(cl.ancmDate, '.')}"/></cell>
					<cell><c:out value="${fn:escapeXml(cl.orgLangPprNm)}"/></cell>
					<cell><c:out value="${fn:escapeXml(cl.cfrcNm)}"/></cell>
					<cell>${rims:codeValue('1400',cl.apprDvsCd)}</cell>
					<cell><fmt:formatDate value="${cl.modDate}" pattern="yyyy-MM-dd" /></cell>
					<cell>${cl.delDvsCd eq 'Y' ? 'Y' : 'N'}</cell>
				</c:if>
				<c:if test="${gSessMode or (sessionScope.auth.adminDvsCd eq 'R' or sessionScope.auth.adminDvsCd eq 'S') }">
					<cell>${cl.conferenceId }</cell>
					<cell>
						<c:if test="${cl.scjnlDvsCd eq '1'}"><spring:message code='con.domestic'/></c:if>
						<c:if test="${cl.scjnlDvsCd eq '2'}"><spring:message code='con.international'/></c:if>
					</cell>
					<cell>${rims:codeValue('2000',cl.pblcNtnCd)}</cell>
					<cell><c:out value="${fn:escapeXml(cl.cfrcNm)}"/></cell>
					<cell><c:out value="${fn:escapeXml(cl.orgLangPprNm)}"/></cell>
					<cell><c:out value="${rims:toDateFormatToken(cl.ancmDate, '.')}"/></cell>
					<cell><c:out value="${cl.isReprsntConference}"/></cell>
					<cell>${rims:codeValue('1400',cl.apprDvsCd)}</cell>
				</c:if>
			</row>
		</c:forEach>
	 </c:if>
</rows>
