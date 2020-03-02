<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../gridInit.jsp" %>
<rows total_count="${totalCount}" pos="${posStart}">
	<c:if test="${not empty memberList}">
		<c:forEach items="${memberList}" var="member" varStatus="idx">
			<row id="${member.userId}_${member.authorId}">
				<cell>${idx.count}</cell>
				<cell>${member.userId}</cell>
				<cell>${member.korNm}</cell>
				<cell>${rims:codeValue('auth.type',member.adminDvsCd)}</cell>
				<cell>${member.adminDvsCd}</cell>
				<cell>${member.workTrgetNm}</cell>
				<cell>${member.workTrget}</cell>
				<cell>${member.workTrgetDept}</cell>
				<cell><fmt:formatDate value="${member.authorAlwncDate}" pattern="yyyy-MM-dd" /></cell>
				<cell>${member.emailAdres}</cell>
				<cell>${member.telno}</cell>
				<cell>${member.mngrResnCn}</cell>
				<c:if test="${sysConf['mail.use.auth.at'] eq 'Y'}">
					<cell><c:if test="${emailCount[idx.index] == 0}"><c:out value='<span class="r_span_box"><a href="javascript:sendMailAuth(\'${member.authorId}\');" class="tbl_icon_a tbl_mail_icon">전송</a></span>'/></c:if></cell>
				</c:if>
				<cell>${sessionScope.login_user.userId}</cell>
				<cell>${sessionScope.login_user.userId}</cell>
			</row>
		</c:forEach>
	</c:if>
</rows>
