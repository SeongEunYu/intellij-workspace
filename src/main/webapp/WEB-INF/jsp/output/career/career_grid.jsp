<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows total_count="${totalCount}" pos="${posStart}">
	 <c:if test="${not empty careerList}">
	 	<c:forEach items="${careerList}" var="cl" varStatus="st">
	 		<row id="${cl.userId}_${cl.careerId}">
	 			<cell>${posStart + st.count}</cell>
	 			<c:if test="${not gSessMode and sessionScope.auth.adminDvsCd ne 'R' and sessionScope.auth.adminDvsCd ne 'S' }">
					<cell>${cl.careerId}</cell>
					<cell><c:out value="${cl.userId}"/></cell>
					<cell><c:out value="${cl.korNm}"/></cell>
					<cell><c:out value="${rims:toDateFormatToken(cl.workSttYm,'.')}"/></cell>
					<cell><c:out value="${rims:toDateFormatToken(cl.workEndYm,'.')}"/></cell>
					<cell><c:out value="${fn:escapeXml(cl.workAgcNm)}"/></cell>
					<cell><c:out value="${fn:escapeXml(cl.posiNm)}"/></cell>
					<cell><c:out value="${empty cl.delDvsCd ? 'N' : cl.delDvsCd}"/></cell>
					<cell><c:out value="${empty cl.src and cl.src eq 'USER' ? '직접입력' : cl.src}"/></cell>
				</c:if>
				<c:if test="${gSessMode or (sessionScope.auth.adminDvsCd eq 'R' or sessionScope.auth.adminDvsCd eq 'S')}">
					<cell>${cl.careerId}</cell>
					<cell><c:out value="${rims:toDateFormatToken(cl.workSttYm,'.')}"/></cell>
					<cell><c:out value="${rims:toDateFormatToken(cl.workEndYm,'.')}"/></cell>
					<cell><c:out value="${fn:escapeXml(cl.workAgcNm)}"/></cell>
					<cell><c:out value="${fn:escapeXml(cl.posiNm)}"/></cell>
					<cell><c:out value="${fn:escapeXml(cl.chgBizNm)}"/></cell>
					<cell><c:out value="${empty cl.src and cl.src eq 'USER' ? '직접입력' : cl.src}"/></cell>
				</c:if>
	 		</row>
	 	</c:forEach>
	 </c:if>
</rows>