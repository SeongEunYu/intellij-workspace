<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows total_count="${totalCount}" pos="${posStart}">
	 <c:if test="${not empty awardList}">
	 	<c:forEach items="${awardList}" var="al" varStatus="st">
		 <row id="${al.userId}_${al.awardId}">
			<cell>${posStart + st.count}</cell>
			<c:if test="${not gSessMode and sessionScope.auth.adminDvsCd ne 'R' and sessionScope.auth.adminDvsCd ne 'S' }">
				<cell>${al.awardId}</cell>
				<cell><c:out value="${al.userId}"/></cell>
				<cell><c:out value="${al.korNm}"/></cell>
				<cell><c:out value="${rims:toDateFormatToken(al.awrdYm,'.')}"/></cell>
				<cell><c:out value="${fn:escapeXml(al.awrdNm)}"/></cell>
				<cell>${rims:codeValue('1210',al.awrdDvsCd)}</cell>
				<cell><c:out value="${fn:escapeXml(al.cfmtAgcNm)}"/></cell>
				<cell>${rims:codeValue('2000',al.cfmtNtnCd)}</cell>
				<cell><c:out value="${empty al.delDvsCd ? 'N' : al.delDvsCd}"/></cell>
				<cell><c:out value="${empty al.src and al.src eq 'USER' ? '직접입력' : al.src}"/></cell>
			</c:if>
			<c:if test="${gSessMode or (sessionScope.auth.adminDvsCd eq 'R' or sessionScope.auth.adminDvsCd eq 'S')}">
				<cell>${al.awardId}</cell>
				<cell><c:out value="${rims:toDateFormatToken(al.awrdYm,'.')}"/></cell>
				<cell><c:out value="${fn:escapeXml(al.awrdNm)}"/></cell>
				<cell>${rims:codeValue('1210',al.awrdDvsCd)}</cell>
				<cell><c:out value="${fn:escapeXml(al.cfmtAgcNm)}"/></cell>
				<cell>${rims:codeValue('2000',al.cfmtNtnCd)}</cell>
				<cell><c:out value="${empty al.src and al.src eq 'USER' ? '직접입력' : al.src}"/></cell>
			</c:if>
		 </row>
	 	</c:forEach>
	 </c:if>
	 <c:if test="${empty awardList}">
		<row id="0">
				<cell colspan="8">No Results. Try Again!</cell>
		</row>
	 </c:if>
</rows>