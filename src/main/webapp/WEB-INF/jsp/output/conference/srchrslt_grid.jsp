<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows>
	 <c:if test="${not empty conferenceList}">
		<c:forEach items="${conferenceList}" var="cl" varStatus="st">
			<row id='${param.srchTrget eq "rims" ? cl.conferenceId : cl.mngNo}'>
				<cell>${st.count}</cell>
				<cell>${cl.conferenceId}</cell>
				<cell>${fn:escapeXml(cl.orgLangPprNm)}</cell>
				<cell>${rims:toDateFormatToken(cl.ancmYear,".")}</cell>
				<cell>${fn:escapeXml(cl.volume)}</cell>
				<cell>${fn:escapeXml(cl.issue)}</cell>
				<cell>${fn:escapeXml(cl.sttPage)}</cell>
				<cell>${fn:escapeXml(cl.endPage)}</cell>
				<cell>${fn:escapeXml(cl.issnNo)}</cell>
				<cell>${fn:escapeXml(cl.scjnlNm)}</cell>
				<cell>${fn:escapeXml(cl.pblcPlcNm)}</cell>
				<cell>${fn:escapeXml(cl.authors)}</cell>
				<cell>${not empty cl.conferenceId ? 'dplct' : 'search'}</cell>
			</row>
		</c:forEach>
	 </c:if>
	 <c:if test="${empty conferenceList}">
		<row id="nodata">
				<cell colspan="7">No Results. Try Again!</cell>
		</row>
	 </c:if>
</rows>
