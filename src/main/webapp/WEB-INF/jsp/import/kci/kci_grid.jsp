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
					<cell>${fn:escapeXml(al.foreignRegistration)}</cell>
					<cell><![CDATA[
							<span style="font-weight: bold; color: #1d6dc6;padding: 0 0 0 13px;">${al.articleTtl}</span><br/>
						<c:if test="${not empty al.diffLangTtl}">
							<span style="font-weight: bold; color: #777;padding: 0 0 0 13px;"> (${al.diffLangTtl}) </span><br/>
						</c:if>
						<span style="font-weight: bold; color: #777;padding: 0 0 0 13px;">
							${al.ownInstAuthor}&nbsp;/&nbsp;${al.plscmpnNm}, &nbsp;${al.pblshrNm}, &nbsp;
							<c:if test="${not empty al.vlm}">v.${al.vlm},&nbsp;</c:if>
						    <c:if test="${not empty al.issue}">no.${al.issue},&nbsp;</c:if>
						    pp.${al.beginPage} ~ ${al.endPage},&nbsp;${al.pblcateYear}
						</span>
						]]></cell>
					<cell>${al.authrCount}</cell>
					<cell>
						<c:if test="${not empty al.doi  }">
							<c:set var="doiLink" value='확인^http://dx.doi.org/${al.doi}^_blank'/>
							${doiLink}
						</c:if>
					</cell>
					<cell>
						<c:set var="kciLink" value='확인^${al.wosSourceUrl}^_blank'/>
						${fn:escapeXml(kciLink)}
					</cell>
			</row>
			</c:if>
		</c:forEach>
	</c:if>
</rows>