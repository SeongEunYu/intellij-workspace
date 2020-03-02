<%@page import="kr.co.argonet.r2rims.constant.R2Constant"%>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../gridInit.jsp" %>
<rows>
	<c:if test="${not empty fundingList}">
		<c:forEach items="${fundingList}" var="fl" varStatus="st">
			<c:set var="cmcmYm" value="${fl.rschCmcmYm}"/>
			<c:set var="endYm" value="${fl.rschEndYm}"/>
			<c:if test="${fn:length(cmcmYm) > 4}">
				<c:set var="cmcmYm" value="${fn:substring(fl.rschCmcmYm,0,4)}-${fn:substring(fl.rschCmcmYm,4,8)}" />
			</c:if>
			<c:if test="${fn:length(endYm) > 4}">
				<c:set var="endYm" value="${fn:substring(fl.rschEndYm,0,4)}-${fn:substring(fl.rschEndYm,4,8)}" />
			</c:if>
			<row id="${fn:escapeXml(fl.fundingId)}">
				<cell>${posStart + st.count}</cell>
				<cell>${fl.fundingId}</cell>
				<cell><c:out value="${rims:toDateFormatToken(fl.rschCmcmYm,'.')}"/> ~ <c:out value="${rims:toDateFormatToken(fl.rschEndYm,'.')}"/></cell>
				<cell>${rims:codeValue('1280',fl.rsrcctSpptDvsCd)}</cell>
				<cell><c:out value="${fn:escapeXml(fl.rschSbjtNm)}"/></cell>
				<cell><c:out value="${fn:escapeXml(fl.rsrcctSpptAgcNm)}"/></cell>
				<cell><fmt:formatNumber value="${fn:trim(fl.sumTotRsrcct)}" type="number"/></cell>
				<cell><![CDATA[
					<span style="font-weight: bold;">${fl.rschSbjtNm}</span><br/>
					<span style="font-weight: bold; color: #777;">
						${fl.cptGovOfficNm}, &nbsp;${fl.bizNm}, &nbsp;
						<c:if test="${not empty fl.korNm}">${fl.korNm},&nbsp;</c:if>
					    ${cmcmYm} ~ ${endYm}
					</span>
					]]>
				</cell>
			</row>
		</c:forEach>
	</c:if>
</rows>