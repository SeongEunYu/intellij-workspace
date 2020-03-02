<?xml version="1.0" encoding="UTF-8"?>
<%--
  Created by IntelliJ IDEA.
  User: hojkim
  Date: 2017-07-27
  Time: 오후 1:43
  To change this template use File | Settings | File Templates.
--%>
<%@include file="../gridInit.jsp"%>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<rows <c:if test="${not empty totalCount}">total_count="${totalCount}"</c:if> <c:if test="${not empty posStart}">pos="${posStart}"</c:if> >
    <c:forEach items="${sndngHistList}" var="shl" varStatus="idx">
        <row id="${shl.sn}">
            <cell>${idx.count}</cell>
            <cell><c:out value="${shl.rsltSe}"/></cell>
            <cell><c:out value="${shl.rsltId}"/></cell>
            <cell>
                <c:forEach items="${shl.rcverUserNmEmailAdres}" var="userNmEmail" varStatus="stats">
                    <c:out value="${stats.index != 0 ? ', ' : ''}"/><c:out value="${userNmEmail}"/>
                </c:forEach>
            </cell>
            <cell><c:out value="${shl.emailTitle}"/></cell>
            <cell><fmt:formatDate value="${shl.regDate}" pattern="yyyy-MM-dd HH:mm:ss" /></cell>
        </row>
    </c:forEach>
</rows>
