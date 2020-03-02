<%@page import="kr.co.argonet.r2rims.constant.R2Constant"%>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../gridInit.jsp" %>
<rows total_count="${totalCount}" pos="${posStart}">
	<c:if test="${not empty conferenceList}">
		<c:forEach items="${conferenceList}" var="cl" varStatus="st">
			<c:set var="ancmDate" value="${cl.ancmDate}"/>
			<c:set var="hldSttDate" value="${cl.hldSttDate}"/>
			<c:set var="hldEndDate" value="${cl.hldEndDate}"/>
			<c:if test="${fn:length(cl.ancmDate) eq 8}">
				<c:set var="ancmDate" value="${fn:substring(cl.ancmDate,0,4)}-${fn:substring(cl.ancmDate,4,6)}-${fn:substring(cl.ancmDate,6,8)}" />
			</c:if>
			<c:if test="${fn:length(cl.ancmDate) eq 6}">
				<c:set var="ancmDate" value="${fn:substring(cl.ancmDate,0,4)}-${fn:substring(cl.ancmDate,4,6)}" />
			</c:if>
			<c:if test="${fn:length(cl.hldSttDate) eq 8}">
				<c:set var="hldSttDate" value="${fn:substring(cl.hldSttDate,0,4)}-${fn:substring(cl.hldSttDate,4,6)}-${fn:substring(cl.hldSttDate,6,8)}" />
			</c:if>
			<c:if test="${fn:length(cl.hldSttDate) eq 6}">
				<c:set var="hldSttDate" value="${fn:substring(cl.hldSttDate,0,4)}-${fn:substring(cl.hldSttDate,4,6)}" />
			</c:if>
			<c:if test="${fn:length(cl.hldEndDate) eq 8 }">
				<c:set var="hldEndDate" value="${fn:substring(cl.hldEndDate,0,4)}-${fn:substring(cl.hldEndDate,4,6)}-${fn:substring(cl.hldEndDate,6,8)}" />
			</c:if>
			<c:if test="${fn:length(cl.hldEndDate) eq 6 }">
				<c:set var="hldEndDate" value="${fn:substring(cl.hldEndDate,0,4)}-${fn:substring(cl.hldEndDate,4,6)}" />
			</c:if>
			
			<row id="${fn:escapeXml(cl.conferenceId)}">
				<cell>${posStart + st.count}</cell>
				<cell>${cl.conferenceId }</cell>
				<cell>
					<c:if test="${cl.scjnlDvsCd eq '1'}">국내</c:if>
					<c:if test="${cl.scjnlDvsCd eq '2'}">국제</c:if>
				</cell>
				<cell>${rims:codeValue('2000',cl.pblcNtnCd)}</cell>
				<cell><c:out value="${fn:escapeXml(cl.cfrcNm)}"/></cell>
				<cell><c:out value="${fn:escapeXml(cl.orgLangPprNm)}"/></cell>
				<cell><c:out value="${rims:toDateFormatToken(cl.ancmDate, '.')}"/></cell>
				<cell><c:out value="${cl.isReprsntConference}"/></cell>
				<cell><![CDATA[
					<span style="font-weight: bold;">${cl.orgLangPprNm}</span><br/>
					<span style="font-weight: bold; color: #777;">
						<c:if test="${not empty cl.scjnlNm}">${cl.scjnlNm},&nbsp;</c:if>
						<c:if test="${not empty cl.scjnlNm}">${cl.pblcPlcNm},&nbsp;</c:if>
						<c:if test="${not empty cl.volume}">v.${cl.volume},&nbsp;</c:if>
					    <c:if test="${not empty cl.issue}">no.${cl.issue},&nbsp;</c:if>
					    <c:if test="${not empty hldSttDate}">${hldSttDate} </c:if>
					    <c:if test="${not empty hldEndDate}">~ ${hldEndDate}</c:if>
					</span>
					]]>
				</cell>
			</row>
		</c:forEach>
	</c:if>
</rows>