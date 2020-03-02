<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows total_count="${totalCount}" pos="${posStart}">
	 <c:if test="${not empty degreeList}">
	 	<c:forEach items="${degreeList}" var="dl" varStatus="st">
		 <row id="${dl.userId}_${dl.degreeId}">
		 	<cell>${posStart + st.count}</cell>
		 	<c:if test="${not gSessMode and sessionScope.auth.adminDvsCd ne 'R' and sessionScope.auth.adminDvsCd ne 'S' }">
				<cell>${dl.degreeId}</cell>
				<cell><c:out value="${dl.userId}"/></cell>
				<cell><c:out value="${dl.korNm}"/></cell>
				<cell><c:out value="${rims:toDateFormatToken(dl.dgrAcqsYm,'.')}"/></cell>
				<cell>${rims:codeValue('1240',dl.acqsDgrDvsCd)}</cell>
				<cell><c:out value="${fn:escapeXml(dl.dgrAcqsAgcNm)}"/></cell>
				<cell>${rims:codeValue('2000',dl.dgrAcqsNtnCd)}</cell>
				<cell>${not empty dl.lastDgrSlctCd and dl.lastDgrSlctCd eq '1' ? 'Y' : 'N'}</cell>
				<cell><fmt:formatDate value="${dl.modDate}" pattern="yyyy-MM-dd" /></cell>
				<cell><c:out value="${empty dl.delDvsCd ? 'N' : dl.delDvsCd}"/></cell>
				<cell><c:out value="${empty dl.src and dl.src eq 'USER' ? '직접입력' : dl.src}"/></cell>
			</c:if>
			<c:if test="${gSessMode or (sessionScope.auth.adminDvsCd eq 'R' or sessionScope.auth.adminDvsCd eq 'S')}">
				<cell>${dl.degreeId}</cell>
				<cell><c:out value="${rims:toDateFormatToken(dl.dgrAcqsYm,'.')}"/></cell>
				<cell>${rims:codeValue('1240',dl.acqsDgrDvsCd)}</cell>
				<cell><c:out value="${fn:escapeXml(dl.dgrAcqsAgcNm)}"/></cell>
				<cell>${rims:codeValue('2000',dl.dgrAcqsNtnCd)}</cell>
				<cell><c:out value="${fn:escapeXml(dl.orgLangDgrPprNm)}"/></cell>
				<cell><c:out value="${empty dl.src and dl.src eq 'USER' ? '직접입력' : dl.src}"/></cell>
				<cell>${not empty dl.lastDgrSlctCd and dl.lastDgrSlctCd eq '1' ? 'Y' : 'N'}</cell>
			</c:if>
		 </row>
	 	</c:forEach>
	 </c:if>
	 <c:if test="${empty degreeList}">
		<row id="0">
				<cell colspan="8">No Results. Try Again!</cell>
		</row>
	 </c:if>
</rows>