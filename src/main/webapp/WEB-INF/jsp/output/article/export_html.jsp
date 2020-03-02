<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../pageInit.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
	<div style="color:#000000; font-size: 28px ; margin-left: 20px; text-decoration:none; text-align:center;"><b>Journal Papers</b></div>
	<br/>
	<div>
		<b>Department : ${user.deptKor}&nbsp;&nbsp;&nbsp;&nbsp;Pay Roll : ${user.userId}&nbsp;&nbsp;&nbsp;&nbsp;Researcher : ${user.korNm}(${user.lastName}, ${user.firstName})</b>
	</div>
	<div>
		<table border="1" cellpadding="3" cellspacing="0" bordercolor="#a2bacc" style="border-collapse:collapse; margin-top:20px; ">
			<thead>
				<tr style="color:#000000; font: 12px 'Dotum'; text-decoration:none; text-align:center; background-color:#dae5ed;">
					<th style="width: 5%" height="40"><b>NO</b></th>
					<c:if test="${parameter.articleTitle eq 'Y'}">
						<th style="width:40%"><b>Article Title</b></th>
					</c:if>
					<c:if test="${parameter.journalTitle eq 'Y'}">
						<th style="width:30%"><b>Journal Title</b></th>
					</c:if>
					<c:if test="${parameter.pubDate eq 'Y'}">
						<th style="width:7%"><b>Pub Date</b></th>
					</c:if>
					<c:if test="${parameter.issn eq 'Y'}">
						<th style="width:7%"><b>ISSN</b></th>
					</c:if>
					<c:if test="${parameter.jif eq 'Y'}">
						<th style="width:5%"><b>JIF</b></th>
					</c:if>
					<c:if test="${parameter.citation eq 'Y'}">
						<th style="width:5%"><b>Citation</b></th>
					</c:if>
					<c:if test="${parameter.abstCntn eq 'Y'}">
						<th style="width:20%"><b>Abstract</b></th>
					</c:if>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${articleList}" var="al" varStatus="idx">
				<tr>
					<td style="text-align: center;">${idx.count}</td>
					<c:if test="${parameter.articleTitle eq 'Y'}">
						<td>
							${al.orgLangPprNm}
							<c:if test="${not empty al.partiList and fn:length(al.partiList) > 0 }">
								/ <c:forEach items="${al.partiList}" var="pl" varStatus="pidx">
									${pl.prtcpntNm}
									<c:if test="${not empty pl.prtcpntFullNm and pl.prtcpntFullNm ne pl.prtcpntNm }">[${pl.prtcpntFullNm}]</c:if>
									<c:if test="${pidx.count < fn:length(al.partiList) }">,&nbsp;</c:if>
								  </c:forEach>
							</c:if>
						</td>
					</c:if>
					<c:if test="${parameter.journalTitle eq 'Y'}">
						<td>
							${al.scjnlNm}
							<c:if test="${not empty al.volume}">, v.${al.volume}</c:if>
							<c:if test="${not empty al.issue}">, no.${al.issue}</c:if>
							<c:if test="${not empty al.sttPage}">, pp.${al.sttPage}<c:if test="${not empty al.endPage}">-${al.endPage}</c:if></c:if>
						</td>
					</c:if>
					<c:if test="${parameter.pubDate eq 'Y'}">
						<td style="text-align: center;">${rims:toDateFormatToken(al.pblcYm, '.')}</td>
					</c:if>
					<c:if test="${parameter.issn eq 'Y'}">
						<td style="text-align: center;">${al.issnNo}</td>
					</c:if>
					<c:if test="${parameter.jif eq 'Y'}">
						<td style="text-align: center;">${al.impctFctr}</td>
					</c:if>
					<c:if test="${parameter.citation eq 'Y'}">
						<td style="text-align: center;">${al.tc}</td>
					</c:if>
					<c:if test="${parameter.abstCntn eq 'Y'}">
						<td>${al.abstCntn}</td>
					</c:if>
				</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
</body>
</html>