<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fn" uri="/WEB-INF/tld/fn.tld" %>
<%@ taglib prefix="rims" uri="/WEB-INF/tld/rims.tld" %>
<rows>
	<c:if test="${not empty rankingList}">
		<c:forEach items="${rankingList}" var="rn" varStatus="idx">
			<row id="${rn.jcrCatRankid}_${rn.sjrCatRankid}_${rn.esiCatRankid}">
				<cell>${fn:escapeXml(rn.jcrCatName)}</cell>
				<cell>${fn:escapeXml(rn.jcrCatRatio)}</cell>
				<cell>${rims:makeRating("L",rn.jcrCatRatio, 25)}</cell>
				<cell>${fn:escapeXml(rn.sjrCatName)}</cell>
				<cell>${fn:escapeXml(rn.sjrCatRatio)}</cell>
				<cell>${rims:makeRating("L",rn.sjrCatRatio, 25)}</cell>
				<cell>${fn:escapeXml(rn.esiCatName)}</cell>
				<cell>${fn:escapeXml(rn.esiCatRatio)}</cell>
				<cell>${rims:makeRating("L",rn.esiCatRatio, 25)}</cell>
			</row>
		</c:forEach>
	</c:if>
	<c:if test="${empty rankingList}">
		<row>
			<cell colspan="9">No Results. Try Again!</cell>
		</row>
	</c:if>
</rows>