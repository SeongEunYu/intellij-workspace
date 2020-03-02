<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows>
	 <c:if test="${not empty rsrchrList}">
		<c:forEach items="${rsrchrList}" var="rl" varStatus="st">
			<row id='admin_${rl.userId}'>
				<cell>${st.count}</cell>
				<cell>${fn:escapeXml(rl.korNm)}</cell>
				<cell>
					<c:if test="${not empty rl.lastName}">
						${rl.lastName}, ${rl.firstName}
					</c:if>
				</cell>
				<cell>${fn:escapeXml(rl.groupDept)}</cell>
				<cell>${fn:escapeXml(rl.posiNm)}</cell>
				<cell>${fn:escapeXml(rl.majorKor1)}
					<c:if test="${not empty rl.majorKor2}">, ${fn:escapeXml(rl.majorKor2)}</c:if>
					<c:if test="${not empty rl.majorKor3}">, ${fn:escapeXml(rl.majorKor3)}</c:if>
				</cell>
				<cell>${fn:escapeXml(rl.majorEng1)}
					<c:if test="${not empty rl.majorEng2}">, ${fn:escapeXml(rl.majorEng2)}</c:if>
					<c:if test="${not empty rl.majorEng3}">, ${fn:escapeXml(rl.majorEng3)}</c:if>
				</cell>
			</row>
		</c:forEach>
	 </c:if>
	 <c:if test="${empty rsrchrList}">
		<row id="0">
				<cell colspan="4">No Results. Try Again!</cell>
		</row>
	 </c:if>
</rows>
