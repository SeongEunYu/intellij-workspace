<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows total_count="${totalCount}" pos="${posStart}">
	<c:if test="${not empty targetList}">
		<c:forEach items="${targetList}" var="tl" varStatus="st">
			<row id="${fn:escapeXml(tl.resultId)}">
					<cell></cell>
					<cell>
						<![CDATA[
						<span style="font-weight: bold; color: #1d6dc6;padding: 0 0 0 13px;"><c:out value="${tl.articleTtl}"/></span><br/>
						<c:if test="${not empty tl.diffLangTtl}">
							<span style="font-weight: bold; color: #777;padding: 0 0 0 13px;"> (<c:out value="${tl.diffLangTtl}"/>) </span><br/>
						</c:if>
						<span style="font-weight: bold; color: #777;padding: 0 0 0 13px;">
							<c:if test="${not empty tl.plscmpnNm}"><c:out value="${tl.plscmpnNm}"/>, &nbsp;</c:if>
							<c:if test="${not empty tl.pblshrNm}"><c:out value="${tl.pblshrNm}"/>, &nbsp;</c:if>
							<c:if test="${not empty tl.vlm}">v.<c:out value="${tl.vlm}"/>,&nbsp;</c:if>
						    <c:if test="${not empty tl.issue}">no.<c:out value="${tl.issue}"/>,&nbsp;</c:if>
							<c:if test="${not empty tl.beginPage}">pp.<c:out value="${tl.beginPage}"/> ~ <c:out value="${tl.endPage}"/>, &nbsp; </c:if>
							<c:out value="${tl.pblcateYear}"/>
						</span>
						<c:if test="${not empty tl.cfrncNm and tl.cfrncNm ne tl.plscmpnNm}">
						<br/> <span style="font-weight: bold; color: #777;padding: 0 0 0 13px;"><c:out value="${tl.cfrncNm}"/></span></c:if>
						]]>
					</cell>
					<cell>
						<c:if test="${not empty tl.docTypeNm}">${fn:escapeXml(tl.docTypeNm)}</c:if>
						<c:if test="${empty tl.docTypeNm}">${fn:escapeXml(tl.docType)}</c:if>
					</cell>
					<c:if test="${not empty tl.similrItemId }">
						<c:set var="dupWorkbenchLink" value='확인^javascript:dupWorkbench("${tl.resultId}","${tl.similrItemId}");^_self'/>
						<cell>${fn:escapeXml(dupWorkbenchLink)}</cell>
					</c:if>
					<c:if test="${empty tl.similrItemId }">
						<cell></cell>
					</c:if>
					<c:if test="${not empty tl.conSimilrItemId }">
						<c:set var="dupConWorkbenchLink" value='확인^javascript:dupConWorkbench("${tl.resultId}","${tl.conSimilrItemId }");^_self'/>
						<cell>${fn:escapeXml(dupConWorkbenchLink)}</cell>
					</c:if>
					<c:if test="${empty tl.conSimilrItemId  }">
						<cell></cell>
					</c:if>
				</row>
		</c:forEach>
	</c:if>
</rows>