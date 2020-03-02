<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows total_count="${totalCount}" pos="${posStart}">
	 <c:if test="${not empty articleList}">
		<c:forEach items="${articleList}" var="al" varStatus="st">
			<row id='admin_${al.articleId}_<c:out value="${param.appr}"/>_N' <c:if test="${al.recordStatus eq '0'}">class="appr"</c:if>>
				<cell>${posStart + st.count}</cell>
				<cell>
				<![CDATA[
					<span style="font-size: 13px; font-weight: bold; color: #1d6dc6;padding: 0 0 0 13px;">${al.orgLangPprNm}</span><br/>
					<c:if test="${not empty al.diffLangPprNm}">
						<span style="font-weight: bold; color: #777;padding: 0 0 0 13px;"> (${al.diffLangPprNm}) </span><br/>
					</c:if>
					<span style="font-weight: bold; color: #777;padding: 0 0 0 13px;">
						${al.authors}&nbsp;/&nbsp;${al.scjnlNm}, &nbsp;${al.pblcPlcNm}, &nbsp;
						<c:if test="${not empty al.volume}">v.${al.volume},&nbsp;</c:if>
					    <c:if test="${not empty al.issue}">no.${al.issue},&nbsp;</c:if>
					    <c:if test="${not empty al.sttPage}">pp.${al.sttPage} ~ ${al.endPage},&nbsp;</c:if>
					    <c:if test="${not empty al.doi}">doi : <a href="http://dx.doi.org/${al.doi}" target="_blank">${al.doi}</a></c:if>
					</span>
				]]>
				</cell>
				<cell>
					${rims:toDateFormatToken(al.pblcYm, '.')}
				</cell>
			</row>
		</c:forEach>
	 </c:if>
</rows>
