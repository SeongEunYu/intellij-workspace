<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows total_count="${fn:length(statsList)}">
<c:if test="${not empty statsList}">
<c:forEach items="${statsList}" var="statsVo" varStatus="st">
	<row id="${statsVo.sn}">
		<cell>${st.count}</cell>
		<cell>${fn:escapeXml(statsVo.statsGubun == 'ART' ? '논문' : statsVo.statsGubun == 'CON' ? '학술활동' : statsVo.statsGubun == 'BOOK' ? '저역서' : '특허')}</cell>
		<cell>${fn:escapeXml(statsVo.title)}</cell>
		<cell>${fn:escapeXml(statsVo.titleEng)}</cell>
		<cell>${fn:escapeXml(statsVo.remark)}</cell>
	</row>
</c:forEach>
</c:if>
</rows>