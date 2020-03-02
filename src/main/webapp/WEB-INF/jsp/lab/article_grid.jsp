<%@page import="kr.co.argonet.r2rims.constant.R2Constant"%>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../gridInit.jsp" %>
<rows total_count="${totalCount}" pos="${posStart}">
	<c:if test="${not empty articleList}">
		<c:forEach items="${articleList}" var="al" varStatus="st">
			<c:set var="apprDvsCd"  value="${empty al.apprDvsCd ? '1' : al.apprDvsCd}"/>
			<c:set var="pblcYm" value="${al.pblcYm}"/>
			<c:if test="${fn:length(pblcYm) > 4}">
				<c:set var="pblcYm" value="${fn:substring(al.pblcYm,0,4)}-${fn:substring(al.pblcYm,4,8)}" />
			</c:if>
			<row id="${fn:escapeXml(al.articleId)}">
				<cell>${posStart + st.count}</cell>
				<cell>${al.articleId }</cell>
				<cell><c:out value="${rims:toDateFormatToken(al.pblcYm, '.')}"/></cell>
				<cell><c:out value="${fn:escapeXml(al.orgLangPprNm)}"/></cell>
				<cell><c:out value="${fn:escapeXml(al.scjnlNm)}"/></cell>
				<cell><c:out value="${al.isReprsntArticle}"/></cell>
				<cell>${not empty al.recordStatus and al.recordStatus eq '1' ? 'Y' : 'N'}</cell>
				<cell><![CDATA[
					<span style="font-weight: bold;">${al.orgLangPprNm}</span><br/>
					<span style="font-weight: bold; color: #777;">
						${al.scjnlNm}, &nbsp;
						<c:if test="${not empty al.volume}">v.${al.volume},&nbsp;</c:if>
					    <c:if test="${not empty al.issue}">no.${al.issue},&nbsp;</c:if>
					    pp.${al.sttPage} ~ ${al.endPage},&nbsp;${pblcYm}
					</span>
					]]>
				</cell>
			</row>
		</c:forEach>
	</c:if>
</rows>