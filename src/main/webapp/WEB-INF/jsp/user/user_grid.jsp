<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../gridInit.jsp" %>

<rows total_count="${totalCount}" pos="${posStart}">
<c:if test="${not empty userList }">
	<c:forEach items="${userList}" var="user" varStatus="idx">
		<row id="${user.userId}">
			<cell>${posStart + idx.count}</cell>
			<cell id="identity">${fn:escapeXml(user.userId)}</cell>
			<cell>${fn:escapeXml(user.korNm)}</cell>
			<c:if test="${not empty user.firstName}">
				<cell>${fn:escapeXml(user.lastName)}, ${fn:escapeXml(user.firstName)}</cell>
			</c:if>
			<c:if test="${empty user.firstName}">
				<cell></cell>
			</c:if>
				<cell>${fn:escapeXml(user.deptKor)}</cell>
				<cell>${fn:escapeXml(user.rid)}</cell>
				<cell>${fn:escapeXml(user.rschrRegNo)}</cell>
				<cell>${fn:escapeXml(user.aptmDate)}</cell>
				<cell>${fn:escapeXml(user.emalAddr)}</cell>
				<cell>${fn:escapeXml(user.grade1)}</cell>
				<cell>${fn:escapeXml(user.grade2)}</cell>
				<cell>${rims:codeValue('1010',  user.hldofYn)}</cell>
				<c:if test="${r2Conf['usr.rims.info.lab'] eq '3' }">
					<cell>
						${rims:codeValue('lab.appr.state', user.labApprDvsCd)}
						<c:out value='<span class="r_span_box"><a href="javascript:sendMailLab(\'${user.userId}\');" class="tbl_icon_a tbl_mail_icon">전송</a></span>'/>
					</cell>
				</c:if>
				<cell>${fn:escapeXml(user.ofcTelno)}</cell>
				<cell>${fn:escapeXml(user.userIdntfr)}</cell>
				<cell>${fn:escapeXml(user.stdntNo)}</cell>
		</row>
	</c:forEach>
</c:if>
</rows>