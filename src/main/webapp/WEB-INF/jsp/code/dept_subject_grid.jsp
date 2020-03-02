<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../gridInit.jsp" %>
<rows>
	<c:if test="${not empty deptSubjectList }">
		<c:forEach items="${deptSubjectList}" var="ds" varStatus="idx">
			<row id="${ds.seqNo}">
				<cell><c:out value="${ds.catcode}"/></cell>
				<cell><c:out value="${ds.description}"/></cell>
				<cell><c:out value="${ds.prodcode}"/></cell>
				<cell><c:out value="${ds.deptCode}"/></cell>
				<cell><c:out value="${ds.deptKor}"/></cell>
				<cell><c:out value="${ds.seqNo}"/></cell>
			</row>
		</c:forEach>
	</c:if>
</rows>