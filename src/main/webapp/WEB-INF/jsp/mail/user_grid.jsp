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
        <c:forEach items="${userList}" var="ul" varStatus="idx">
            <row id="${ul.userId}">
                <cell>${idx.count}</cell>
                <cell>TO</cell>
                <cell><c:out value="${ul.korNm}"/></cell>
                <c:choose>
                    <c:when test="${rsltSe eq 'AUTHORITY'}">
                        <cell><c:out value="${ul.adminDvsCd eq 'M' ? '관리자' : ul.adminDvsCd eq 'P' ? '성과관리자' : ul.adminDvsCd eq 'D'? '학(부)과관리자' : ul.adminDvsCd eq 'C' ? '단과대학관리자' : ul.adminDvsCd eq 'T' ? '트랙관리자' : ul.adminDvsCd eq 'S' ? '대리입력자' : ul.adminDvsCd eq 'V' ? '열람자' : ''}"/></cell>
                    </c:when>
                    <c:otherwise>
                        <cell><c:out value="${ul.workTrgetNm != null ? '대리입력자':'연구자'}"/></cell>
                     </c:otherwise>
                </c:choose>
                <cell><c:out value="${ul.workTrgetNm != null ? ul.workTrgetNm:'본인'}"/></cell>
                <cell><c:out value="${ul.emalAddr}"/></cell>
                <cell><c:out value="${ul.groupDept}"/></cell>
                <cell><c:out value="${ul.userId}"/></cell>
            </row>
        </c:forEach>
        <%--<row id="99998">
            <cell>CC</cell>
            <cell>RIMS관리자</cell>
            <cell>${sysConf['system.admin.email']}</cell>
            <cell>${sysConf['inst.name']}</cell>
            <cell>99998</cell>
        </row>--%>
</rows>
