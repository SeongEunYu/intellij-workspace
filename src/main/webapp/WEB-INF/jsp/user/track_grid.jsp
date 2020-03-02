<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../gridInit.jsp" %>

<rows total_count="${totalCount}" pos="${posStart}">
	<c:if test="${not empty trackList }">
		<c:forEach items="${trackList}" var="track" varStatus="idx">
			<row id="${track.trackId}">
				<cell>${posStart + idx.count}</cell>
				<cell>${track.trackId}</cell>
				<cell>${empty track.trackName ? '해당없음' : track.trackName}</cell>
				<cell><fmt:formatDate var="regDate" value="${track.regDate}" pattern="yyyy-MM-dd" />${regDate}</cell>
				<cell>${fn:length(track.userList)}</cell>
			</row>
		</c:forEach>
	</c:if>
	<c:if test="${empty trackList }">
		<row>
			<cell colspan="4" style="text-align: center;">No Results. Try Again!</cell>
		</row>
	</c:if>
</rows>