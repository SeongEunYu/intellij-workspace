<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@
    taglib prefix="c" uri="/WEB-INF/tld/c.tld" %><%@
    taglib prefix="fn" uri="/WEB-INF/tld/fn.tld" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>학술지 정보</title>
<link rel="stylesheet" type="text/css" href="/rims/css/busan_test.css">
</head>
<body style="font-size: 11px;">
<div id="body_content">

<h2 class="bin pd0">* Journal Info.</h2>
	<table class="newsli" style="width: 800px;">
		<tbody>
		<tr>
			<th scope="row" class="tar" style="width: 150px;">Journal Title</th>
			<td><B>${masterInfo.title }</B></td>
		</tr>
		<tr>
			<th scope="row"class="tar">ISSN</th>
			<td>${masterInfo.issn }</td>
		</tr>
		<tr>
			<th scope="row"class="tar">Publisher</th>
			<td>
				<c:if test="${not empty masterInfo.puWos }"></c:if>
				<c:choose>
					<c:when test="${not empty masterInfo.puWos }">${masterInfo.puWos}</c:when>
					<c:when test="${not empty masterInfo.puScopus }">${masterInfo.puScopus}</c:when>
					<c:when test="${not empty masterInfo.puKci }">${masterInfo.puKci}</c:when>
				</c:choose>
			</td>
		</tr>
		<tr>
			<th scope="row"class="tar">Citation Databases</th>
			<td>
				<c:if test="${masterInfo.scie eq '1' }">SCIE</c:if>
				<c:if test="${masterInfo.sci eq '1' }">SCI</c:if>
				<c:if test="${masterInfo.ssci eq '1' }">SSCI</c:if>
				<c:if test="${masterInfo.ahci eq '1' }">AH&CI</c:if>
				<c:if test="${masterInfo.scopus eq '1' }">SCOPUS</c:if>
				<c:if test="${masterInfo.kci eq '1' }">KCI</c:if>
			</td>
		</tr>
		<tr>
			<th scope="row"class="tar">Country</th>
			<td>
				${masterInfo.pc }
			</td>
		</tr>
		</tbody>
	</table>
<h2 class="bin pd0">* Journal Impact Factor from Web of Science</h2>
	<h3 class="bin pd0">- Journal Rank in Categories</h3>
	<table class="t3" style="width: 800px;">
		<thead>
			<tr>
			  <th scope="col" width="50">Year</th>
			   <th scope="col" width="350">Category Name</th>
			   <th scope="col" width="50">JCR Edition</th>
			   <th scope="col" width="65">I/F</th>
			   <th scope="col" width="65">Rank</th>
			   <th scope="col" width="90">I/F(%)</th>
			   <th scope="col" width="50">Rating</th>
			</tr>
		</thead>
		<tbody>
			<c:if test="${not empty jcrCatRankList }">
				<c:forEach items="${jcrCatRankList }" var="al" varStatus="st">
					<tr>
					  <td align="center">${al.prodyear}</td>
					  <td >${al.catname}</td>
					  <td align="center">${al.prodedition}</td>
					  <td align="center">${al.impact}</td>
					  <td align="center">${al.rank}</td>
					  <td align="center">${al.ratio}%</td>
					  <td align="center">${fn:makeRating("L", al.ratio, 25)}</td>
					</tr>
				</c:forEach>
			</c:if>
		</tbody>
	</table>

	<h3 class="bin pd0">- JCR(Journal Citation Reports) Indicators by Year</h3>
	<table class="t3" style="width: 800px;">
		<thead>
			<tr>
			  <th scope="col" width="50">Year</th>
			   <th scope="col" width="100">I/F(Impact Factor)</th>
			   <th scope="col" width="50">Immediacy Index</th>
			   <th scope="col" width="65">Cited Half-Life</th>
			   <th scope="col" width="65">Total Cited</th>
			</tr>
		</thead>
		<tbody>
			<c:if test="${not empty jcrTitleList }">
				<c:forEach items="${jcrTitleList }" var="al" varStatus="st">
					<tr>
					  <td align="center">${al.prodyear}</td>
					  <td align="center">${al.impact}</td>
					  <td align="center">${al.immediacy}</td>
					  <td align="center">${al.citedhalf}</td>
					  <td align="center">${al.totalcites}</td>
					</tr>
				</c:forEach>
			</c:if>
		</tbody>
	</table>
	<div><b>*Immediacy Index: The average number of times an article is cited in the year it is published.</b></div>
	<div><b>*Cited Half-Life: The median age of the articles that were cited in the JCR year.</b></div>

	<h2 class="bin pd0">* Journal Impact Factors form SCOPUS</h2>
		<h3 class="bin pd0">- Journal Rank in Categories</h3>
			<table class="t3" style="width: 800px;">
				<thead>
					<tr>
					  <th scope="col" width="50">Year</th>
					   <th scope="col" width="350">Category Name</th>
					   <th scope="col" width="50">SJR</th>
					   <th scope="col" width="65">Rank</th>
					   <th scope="col" width="90">SJR(%)</th>
					   <th scope="col" width="50">Rating</th>
					</tr>
				</thead>
				<tbody>
					<c:if test="${not empty sjrCatRankList }">
						<c:forEach items="${sjrCatRankList }" var="al" varStatus="st">
							<tr>
							  <td align="center">${al.prodyear}</td>
							  <td >${al.catname}</td>
							  <td align="center">${al.sjr}</td>
							  <td align="center">${al.rank}</td>
							  <td align="center">${al.ratio}%</td>
							  <td align="center">${fn:makeRating("L", al.ratio, 25)}</td>
							</tr>
						</c:forEach>
					</c:if>
				</tbody>
			</table>
		<h3 class="bin pd0">- SJR Detail Info.</h3>
			<table class="t3" style="width: 800px;">
				<thead>
					<tr>
					  <th scope="col" width="50">Year</th>
					   <th scope="col" width="50">SJR</th>
					   <th scope="col" width="50">H-index</th>
					   <th scope="col" width="70">Total Docs.</th>
					   <th scope="col" width="70">Total Docs.<br>(3years)</th>
					   <th scope="col" width="70">Total Refs.</th>
					   <th scope="col" width="70">Total Cites<br>(3years)</th>
					   <th scope="col" width="70">Citable Docs.<br>(3years)</th>
					   <th scope="col" width="70">Cites / Doc.<br>(2years)</th>
					   <th scope="col" width="70">Ref. / Doc.</th>
					</tr>
				</thead>
				<tbody>
					<c:if test="${not empty sjrTitleList }">
						<c:forEach items="${sjrTitleList }" var="al" varStatus="st">
							<tr>
							  <td align="center">${al.prodyear}</td>
							  <td align="center">${al.sjr}</td>
							  <td align="center">${al.hindex}</td>
							  <td align="center">${al.totalDocs}</td>
							  <td align="center">${al.ttlDcs3yrs}</td>
							  <td align="center">${al.ttlRfs}</td>
							  <td align="center">${al.ttlRfs3yrs}</td>
							  <td align="center">${al.ctblDcs3yrs}</td>
							  <td align="center">${al.ctsDcs2yrs}</td>
							  <td align="center">${al.refDoc}</td>
							</tr>
						</c:forEach>
					</c:if>
				</tbody>
			</table>
		<div><b>*SJR: SCImago Journal Rank(SJR) is a measure of scientific influence of scholarly journals that accounts for both the number of citations received by a journal and the importance or prestige of the journals where such citations come from.</b></div>
	<div><b>*SNIP: Source Normalized Impact per Paper(SNIP) measures contextual citation impact by weighting citations based on the total number of citations in a subject field.</b></div>
			<br>
			<br>
			<br>
			<br>
</div>
</body>
</html>