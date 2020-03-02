<%@page import="kr.co.argonet.r2rims.constant.R2Constant"%>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows>
	<c:if test="${not empty articleList}">
		<c:forEach items="${articleList}" var="al" varStatus="st">
			<c:if test="${not empty al }">
			<row id="admin_${fn:escapeXml(al.articleId)}_${param.appr}_N">
				<cell>${st.count}</cell>
				<cell><![CDATA[
						<span style="font-weight: bold; color: #1d6dc6;padding: 0 0 0 13px;">${al.orgLangPprNm}</span><br/>
					<c:if test="${not empty al.diffLangPprNm}">
						<span style="font-weight: bold; color: #777;padding: 0 0 0 13px;"> (${al.diffLangPprNm}) </span><br/>
					</c:if>
					<span style="font-weight: bold; color: #777;padding: 0 0 0 13px;">
						${al.authors}&nbsp;/&nbsp;${al.scjnlNm}, &nbsp;${al.pblcPlcNm}, &nbsp;
						<c:if test="${not empty al.volume}">v.${al.volume},&nbsp;</c:if>
					    <c:if test="${not empty al.issue}">no.${al.issue},&nbsp;</c:if>
					    pp.${al.sttPage} ~ ${al.endPage},&nbsp;${rims:toDateFormatToken(al.pblcYm, '.')}
					</span>
					]]></cell>
				<cell><![CDATA[<div class="tbl_num_box"><span <c:if test="${orderby ne 'sciTc'}">style="background:#808080;"</c:if>>${al.tc}</span></div>]]></cell>
				<cell><![CDATA[<div class="tbl_num_box"><span <c:if test="${orderby ne 'scpTc'}">style="background:#808080;"</c:if>>${al.scpTc}</span></div>]]></cell>
			</row>
			</c:if>
		</c:forEach>
	</c:if>
</rows>