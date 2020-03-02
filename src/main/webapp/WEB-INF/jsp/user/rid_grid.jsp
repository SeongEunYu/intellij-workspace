<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fn" uri="/WEB-INF/tld/fn.tld" %>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld" %>
<%@ taglib prefix="rims" uri="/WEB-INF/tld/rims.tld" %>

<rows  total_count="${totalCount}" pos="${posStart}">
  <c:if test="${not empty userList}">
  	<c:forEach items="${userList}" var="ul" varStatus="idx">
		<row id='${ul.userId}_${ul.ridStatus}' >
			<cell>${posStart + idx.count}</cell>
			<cell>${ul.userId}</cell>
			<cell>${ul.rid}</cell>
			<cell>${fn:escapeXml(ul.korNm)}</cell>
			<cell>
				<c:if test="${not empty ul.firstName }" >
					${fn:escapeXml(ul.firstName)}, ${fn:escapeXml(ul.lastName)}
				</c:if>
			</cell>
			<cell>${fn:escapeXml(ul.deptKor)}</cell>
			<cell>${fn:escapeXml(ul.emalAddr)}</cell>
			<cell>${rims:codeValue('1010',  ul.hldofYn)}</cell>
			<cell>${fn:escapeXml(ul.ridStatus)}</cell>
			<cell>
				<c:if test="${not empty ul.rid }">
					Link^http://www.researcherid.com/rid/${ul.rid}
				</c:if>
			</cell>
			<cell>${fn:escapeXml(ul.idntfrSeqNo)}</cell>
			<cell>RID</cell>
		</row>
  	</c:forEach>
  </c:if>
</rows>