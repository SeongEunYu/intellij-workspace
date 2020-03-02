<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows total_count="${totalCount}" pos="${posStart}">
	<c:if test="${not empty extractTargetList}">
		<c:forEach items="${extractTargetList}" var="el" varStatus="st">
			<row id="${fn:escapeXml(al.articleId)}">
					<cell>${st.count}</cell>
					<cell>${fn:escapeXml(el.sourcIdntfcNo)}</cell>
					<cell>${fn:escapeXml(el.articleTtl)}</cell>
					<cell>${fn:escapeXml(el.plscmpnNm)}</cell>
					<cell>${fn:escapeXml(el.docType)}</cell>
					<cell>${fn:escapeXml(el.nameKor)}</cell>
				</row>
		</c:forEach>
	</c:if>
</rows>