<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows total_count="${totalCount}" pos="${posStart}">
	 <c:if test="${not empty lectureList}">
	 	<c:forEach items="${lectureList}" var="ll" varStatus="st">
		 <row id="${ll.profsrEmpno}_${posStart + st.count}">
		 	<cell>${posStart + st.count}</cell>
		 	<cell>${fn:escapeXml(ll.profsrEmpno)}</cell>
		 	<cell>${fn:escapeXml(ll.profsrNm)}</cell>
		 	<cell>${fn:escapeXml(ll.estblYear)}</cell>
		 	<cell>${fn:escapeXml(ll.estblSemstr)}</cell>
		 	<cell>${fn:escapeXml(ll.estblDeptKor)}</cell>
		 	<cell>${fn:escapeXml(ll.sbjectSe)}</cell>
		 	<cell>${fn:escapeXml(ll.sbjectNmKor)}</cell>
		 	<cell>${fn:escapeXml(ll.sbjectNmEng)}</cell>
		 	<cell>${fn:escapeXml(ll.lctre)}</cell>
		 	<cell>${fn:escapeXml(ll.exper)}</cell>
		 	<cell>${fn:escapeXml(ll.point)}</cell>
		 	<cell>${fn:escapeXml(ll.atnlcNmpr)}</cell>
		 	<cell>${fn:escapeXml(ll.sbjectNo)}</cell>
		 	<cell>${fn:escapeXml(ll.sbjectCode)}</cell>
		 	<cell>${fn:escapeXml(ll.lctreClass)}</cell>
		 	<cell>${fn:escapeXml(ll.engLctreAt)}</cell>
		 </row>
	 	</c:forEach>
	 </c:if>
	 <c:if test="${empty lectureList}">
		<row id="0">
				<cell colspan="8">No Results. Try Again!</cell>
		</row>
	 </c:if>
</rows>