<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows total_count="${totalCount}" pos="${posStart}">
	 <c:if test="${not empty studentList}">
	 	<c:forEach items="${studentList}" var="sl" varStatus="st">
		 <row id="${sl.profsrEmpno}_${posStart + st.count}">
			<cell>${posStart + st.count}</cell>
			<c:if test="${not gSessMode and sessionScope.auth.adminDvsCd ne 'R' and sessionScope.auth.adminDvsCd ne 'S' }">
				<cell>${fn:escapeXml(sl.profsrEmpno)}</cell>
				<cell>${fn:escapeXml(sl.profsrNm)}</cell>
			</c:if>
			<cell>${fn:escapeXml(sl.stdntNo)}</cell>
			<cell>${fn:escapeXml(sl.stdntNm)}</cell>
			<cell>${fn:escapeXml(sl.stdntLastNm)}, ${fn:escapeXml(sl.stdntFirstNm)}</cell>
			<cell>${fn:escapeXml(sl.deptKor)}</cell>
			<cell>${fn:escapeXml(sl.crseSeNm)}</cell>
			<cell>${fn:escapeXml(sl.sknrgsStatus)}</cell>
			<cell>${rims:toDateFormatToken(sl.grdtnDate,'.')}</cell>
			<cell>${fn:escapeXml(sl.coachingSe)}</cell>
		 </row>
	 	</c:forEach>
	 </c:if>
</rows>