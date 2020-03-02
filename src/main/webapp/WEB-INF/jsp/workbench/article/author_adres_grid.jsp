<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fn" uri="/WEB-INF/tld/fn.tld" %>
<ul style="margin:2px 0px 2px 0px;font-size: 11px;font-weight: normal;">
<c:if test="${not empty authrAdresList }">
	<c:forEach items="${authrAdresList}" var="ar" varStatus="st">
		<li onclick="authorGrid.selectRowById('${param.rowId}',true,true,true);">${fn:escapeXml(ar.add1)} <c:if test="${not empty ar.reInst }"> (${ar.reInst})</c:if></li>
	</c:forEach>
</c:if>
</ul>
