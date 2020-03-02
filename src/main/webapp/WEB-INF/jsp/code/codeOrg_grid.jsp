<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../gridInit.jsp" %>
<rows total_count="${totalCount}" pos="${posStart}">
    <c:if test="${not empty codeOrgList}">
        <c:forEach items="${codeOrgList}" var="co" varStatus="idx">
            <row id="<c:out value="${co.id}"/>">
                <cell><c:out value="${co.codeValue}"/></cell>
                <c:choose>
                    <c:when test="${pageContext.response.locale eq 'en'}">
                        <cell><c:out value="${co.codeDispEng}"/></cell>
                    </c:when>
                    <c:otherwise>
                        <cell><c:out value="${co.codeDisp}"/></cell>
                    </c:otherwise>
                </c:choose>
            </row>
        </c:forEach>
    </c:if>
    <c:if test="${not empty codeOrgList}">

    </c:if>
</rows>