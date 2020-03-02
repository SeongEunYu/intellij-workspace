<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%><%@
include file="../../gridInit.jsp" %>
<rows total_count="${totalCount}" pos="${posStart}">
	 <c:if test="${not empty patentList}">
		<c:forEach items="${patentList}" var="pl" varStatus="st">
			<row id='${pl.patentId}'>
				<cell>${posStart + st.count}</cell>
				<c:if test="${not gSessMode and sessionScope.auth.adminDvsCd ne 'R' and sessionScope.auth.adminDvsCd ne 'S' }">
					<cell>${pl.patentId}</cell>
					<cell>${rims:codeValue('1080',pl.itlPprRgtDvsCd)}</cell>
					<cell>${rims:codeValue('2000',pl.applRegNtnCd)}</cell>
					<cell><c:out value="${fn:escapeXml(pl.itlPprRgtNm)}"/></cell>
					<cell class="num_text"><c:out value="${pl.applRegNo}" /></cell>
					<cell class="num_text"><c:out value="${rims:toDateFormatToken(pl.applRegDate,'-')}"/></cell>
					<cell class="num_text"><c:out value="${pl.itlPprRgtRegNo}" /></cell>
					<cell class="num_text"><c:out value="${rims:toDateFormatToken(pl.itlPprRgtRegDate,'-')}"/></cell>
					<cell>${rims:codeValue('1420',pl.vrfcDvsCd)}</cell>
					<cell>${rims:codeValue('1400',pl.apprDvsCd)}</cell>
					<cell class="num_text"><fmt:formatDate value="${pl.modDate}" pattern="yyyy-MM-dd" /></cell>
					<cell><c:out value="${fn:escapeXml(pl.familyCode)}"/></cell>
					<cell><c:out value="${rims:codeValue('patent.appldvs',pl.applDvsCd)}"/></cell>
					<cell>${empty pl.srcId ? '직접입력' : 'PPMS'}</cell>
					<cell>${pl.delDvsCd eq 'Y' ? '삭제' : ''}</cell>
				</c:if>
				<c:if test="${gSessMode or (sessionScope.auth.adminDvsCd eq 'R' or sessionScope.auth.adminDvsCd eq 'S')}">
					<cell>${pl.patentId}</cell>
					<cell>${rims:codeValue('1080',pl.itlPprRgtDvsCd)}</cell>
					<cell>${rims:codeValue('2000',pl.applRegNtnCd)}</cell>
					<cell><c:out value="${fn:escapeXml(pl.itlPprRgtNm)}"/></cell>
					<cell><c:out value="${pl.applRegNo}" /></cell>
					<cell class="num_text"><c:out value="${rims:toDateFormatToken(pl.applRegDate,'-')}"/></cell>
					<cell><c:out value="${pl.itlPprRgtRegNo}" /></cell>
					<cell class="num_text"><c:out value="${rims:toDateFormatToken(pl.itlPprRgtRegDate,'-')}"/></cell>
					<cell>${rims:codeValue('1420',pl.vrfcDvsCd)}</cell>
					<cell><c:out value="${pl.isReprsntPatent}"/></cell>
					<cell>${rims:codeValue('1400',pl.apprDvsCd)}</cell>
					<cell><c:out value="${fn:escapeXml(pl.familyCode)}"/></cell>
					<cell><c:out value="${rims:codeValue('patent.appldvs',pl.applDvsCd)}"/></cell>
					<cell>${empty pl.srcId ? '직접입력' : 'PPMS'}</cell>
				</c:if>
			</row>
		</c:forEach>
	 </c:if>
</rows>