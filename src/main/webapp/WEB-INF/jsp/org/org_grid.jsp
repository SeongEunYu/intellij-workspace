<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8"
    pageEncoding="UTF-8"%><%@
    page import="java.util.Map"%><%@
		page import="java.util.List"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fn" uri="/WEB-INF/tld/fn.tld" %>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld" %>
<%@ taglib prefix="rims" uri="/WEB-INF/tld/rims.tld" %>
<rows>
	<c:if test="${not empty orgChartListHTML}">
		${orgChartListHTML}
	</c:if>
	<c:if test="${empty orgChartListHTML}">

	<row colspan="3">no result! try again
		</row>
	</c:if>
</rows>