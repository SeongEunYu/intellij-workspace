<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows total_count="${totalCount}" pos="${posStart}">
<c:if test="${not empty userDegreeList}">
	<c:forEach items="${userDegreeList}" var="userDegree" varStatus="st">
		<row id="${userDegree.userId}">
			<cell>${posStart + st.count}</cell>
			<cell><c:out value="${userDegree.userId}"/></cell>
			<cell><c:out value="${userDegree.korNm}"/></cell>
			<cell><c:out value="${userDegree.groupDept}"/></cell>
			<cell>${fn:replace(fn:replace(userDegree.acqsDgrDvsCd, '1', '박사'),'3','석사')}</cell>
			<cell><c:out value='<span class="r_span_box"><a href="javascript:parent.sendMailUserDegree(\'${userDegree.userId}\',\'${userDegree.degreeIdStr}\',\'${userDegree.dgrAcqsYm}\',\'${userDegree.tutorNm}\',\'${userDegree.dgrSpclNm}\',\'${userDegree.dgrDtlSpclNm}\',\'${userDegree.korNm}\',\'${fn:replace(fn:replace(userDegree.acqsDgrDvsCd, \'1\', \'박사\'),\'3\',\'석사\')}\');" class="tbl_icon_a tbl_mail_icon">전송</a></span>'/></cell>
		</row>
	</c:forEach>
</c:if>
<c:if test="${empty userDegreeList}">
	<row id="0">
        <cell colspan="8">No Results. Try Again!</cell>
	</row>
</c:if>
</rows>