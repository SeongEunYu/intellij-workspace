<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fn" uri="/WEB-INF/tld/fn.tld" %>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld" %>
<%@ taglib prefix="rims" uri="/WEB-INF/tld/rims.tld" %>
<rows>
	<c:if test="${not empty codeList}">
	<c:forEach items="${codeList }" var="cl" varStatus="idx">
		<row id='${cl.codeGubun}'>
			<cell>${cl.codeGubun}</cell>
			<cell>${cl.codeCont}</cell>
		</row>
	</c:forEach>
	</c:if>
</rows>