<%@page import="kr.co.argonet.r2rims.constant.R2Constant"%>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows total_count="${totalCount}" pos="${posStart}">
	<c:if test="${not empty articleList}">
		<c:forEach items="${articleList}" var="al" varStatus="st">
			<c:if test="${not empty al }">
			<row id="${fn:escapeXml(al.sourcIdntfcNo)}">
					<cell>
						<c:if test="${empty al.isDplctArticle}">1</c:if>
						<c:if test="${not empty al.isDplctArticle and al.isDplctArticle eq 'Y'}">0</c:if>
					</cell>
					<cell>
						<c:if test="${empty al.isDplctArticle}">N</c:if>
						<c:if test="${not empty al.isDplctArticle and al.isDplctArticle eq 'Y'}">Y</c:if>
					</cell>
					<cell>${fn:escapeXml(al.sourcIdntfcNo)}</cell>
					<cell><![CDATA[
							<span style="font-weight: bold; color: #1d6dc6;padding: 0 0 0 13px;">${fn:escapeXml(al.articleTtl)}</span><br/>
						<c:if test="${not empty al.diffLangTtl}">
							<span style="font-weight: bold; color: #777;padding: 0 0 0 13px;"> (${fn:escapeXml(al.diffLangTtl)}) </span><br/>
						</c:if>
						<span style="font-weight: bold; color: #777;padding: 0 0 0 13px;">
							<c:if test="${not empty al.plscmpnNm}">${fn:escapeXml(al.plscmpnNm)}, &nbsp;</c:if>
							<c:if test="${not empty al.pblshrNm}">${fn:escapeXml(al.pblshrNm)}, &nbsp;</c:if>
							<c:if test="${not empty al.vlm}">v.${fn:escapeXml(al.vlm)},&nbsp;</c:if>
						    <c:if test="${not empty al.issue}">no.${fn:escapeXml(al.issue)},&nbsp;</c:if>
							<c:if test="${not empty al.beginPage}">pp.${al.beginPage} ~ ${al.endPage},&nbsp;</c:if>
						    ${fn:escapeXml(al.pblcateYear)}
						</span>
						]]></cell>
					<cell><c:out value="${al.docType}"/></cell>
					<cell>
						<c:if test="${not empty al.doi  }">
							<c:set var="doiLink" value='${al.doi}^http://dx.doi.org/${al.doi}^_blank'/>
							${doiLink}
						</c:if>
					</cell>
					<cell>
						<c:set var="wosLink" value='확인^${al.wosSourceUrl}^_blank'/>
						${fn:escapeXml(wosLink)}
					</cell>
			</row>
			</c:if>
		</c:forEach>
	</c:if>
</rows>