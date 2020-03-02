<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="${pageContext.request.contextPath}/css/analysis_${instAbrv}/layout.css" rel="stylesheet"  type="text/css" />
<title>전임교원</title>
<script type="text/javascript" src="${contextPath}/js/jquery/jquery-1.11.3.min.js"></script>
</head>
<body scroll=auto style="overflow-x:hidden">
<div class="sub_content_wrapper">
<table width="100%" class="list_tbl mgb_20">
	<thead>
	<tr style="text-align: center;height:25px">
		<th class="header"><span>순번</span></th>
		<th class="header"><span>이름</span></th>
		<th class="header"><span>사번</span></th>
		<th class="header"><span>단과대</span></th>
		<th class="header"><span>학과</span></th>
	</tr>
	</thead>
	<tbody style="background:white;">
		<c:forEach items="${exportUserList}" var="user" varStatus="stat">
			<tr style="height:17px">
				<td class="center"><c:out value="${stat.count}"/></td>
				<td class="center"><c:out value="${user.korNm}"/></td>
				<td class="center"><c:out value="${user.userId}"/></td>
				<td class="center"><c:out value="${user.clgNm}"/></td>
				<td class="center"><c:out value="${user.deptKor}"/></td>
			</tr>
		</c:forEach>
	</tbody>
</table>
</div>
</body>
</html>