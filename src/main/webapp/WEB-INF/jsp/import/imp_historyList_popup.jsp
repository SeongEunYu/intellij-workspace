<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@include file="../gridInit.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="${pageContext.request.contextPath}/css/analysis_${instAbrv}/layout.css" rel="stylesheet"  type="text/css" />
<script type="text/javascript" src="${contextPath}/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript">
function popupArticle(articleId){
	var wWidth = 1108;
	var screenWidth = screen.width;
	var screenHeight = screen.height;
	var wHeight = (screenHeight - 100);
	var leftPos = (screenWidth - wWidth)/2;
	var topPos = 0;
	var mappingPopup = window.open('about:blank', 'articlePopup', 'width='+wWidth+',height='+wHeight+',top='+topPos+',left='+leftPos+' location=no,scrollbars=yes,resizable=yes');
	var popFrm = $('#popFrm');
	popFrm.empty();
	popFrm.append($('<input type="hidden" name="articleId" value="'+articleId+'"/>'));
	popFrm.attr('action', '<c:url value="/${preUrl}/article/articlePopup.do"/>');
	popFrm.attr('target', 'articlePopup');
	popFrm.attr('method', 'POST');
	popFrm.submit();
	mappingPopup.focus();
}
</script>
</head>
<body style="overflow: auto;">
<form name="popFrm" id="popFrm" method="post"></form>
<div class="sub_content_wrapper">
<table width="100%" class="list_tbl mgb_20">
	<thead>
	<tr style="text-align: center;height:25px">
		<th class="header"><span>순번</span></th>
		<th class="header"><span>UT</span></th>
		<th class="header"><span>관리번호</span></th>
		<th class="header"><span>파일포맷</span></th>
		<th class="header"><span>상태</span></th>
		<th class="header"><span>비고</span></th>
	</tr>
	</thead>
	<tbody style="background:white;">
		<c:forEach items="${impHistoryList}" var="imp" varStatus="stat">
			<tr style="height:17px">
				<td class="center"><c:out value="${stat.count}"/></td>
				<td class="center"><c:out value="${imp.ut}"/></td>
				<td class="center"><a href="javascript:popupArticle('<c:out value="${imp.articleId}"/>');" style="color:blue;"><c:out value="${imp.articleId}"/></a></td>
				<td class="center"><c:out value="${imp.format}"/></td>
				<td class="center"><c:out value="${imp.status == 'I' ? '입력' : imp.status == 'E' ? '에러' : imp.status == 'D' ? '중복' : ''}"/></td>
				<td class="center"><c:out value="${imp.remarkCn}"/></td>
			</tr>
		</c:forEach>
	</tbody>
</table>
</div>
</body>
</html>