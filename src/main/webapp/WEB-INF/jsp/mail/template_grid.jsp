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
<rows <c:if test="${not empty totalCount}">total_count="${totalCount}"</c:if> <c:if test="${not empty posStart}">pos="${posStart}"</c:if>>
    <c:forEach items="${templateList}" var="tl" varStatus="idx">
        <row id="${tl.sn}">
            <cell><c:out value="${tl.sn}"/></cell>
            <cell><c:out value="${tl.jobGubun}"/></cell>
            <cell><c:out value="${tl.title}"/></cell>
            <cell><c:out value="${tl.contents}"/></cell>
        </row>
    </c:forEach>
</rows>