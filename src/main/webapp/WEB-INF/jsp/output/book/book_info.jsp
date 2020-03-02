<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.commons.lang3.ObjectUtils"%>
<%@ page import="kr.co.argonet.r2rims.util.LanguageUtil"%>
<%@include file="../../pageInit.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Book Detail</title>
	<link type="text/css" href="${contextPath}/css/layout.css" rel="stylesheet" />
	<link type="text/css" href="${contextPath}/js/dhtmlx/skins/${sysConf['dhtmlx.skin']}/dhtmlx.css" rel="stylesheet" />
	<style type="text/css">
		.dhxwins_vp_dhx_terrace {overflow: auto;}
		.dhxwins_vp_dhx_terrace div.dhxwin_active div.dhx_cell_wins div.dhx_cell_toolbar_def, .dhxwins_vp_dhx_terrace div.dhxwin_inactive div.dhx_cell_wins div.dhx_cell_toolbar_def { padding: 10px 0px 0; }
		.dhx_toolbar_dhx_terrace { padding: 0 0px; }
		table {font-size: 12px;}
	</style>
</head>

<body style="background: none;padding-left: 20px;width: 1002px;" style="overflow-y: auto;">
<div class="title_box">
	<h3>Book 상세</h3>
</div>
<div class="contents_box" style="width:1002px;">
	<table class="write_tbl mgb_10" >
		<colgroup>
			<col style="width:140px;" />
			<col style="width:171px;" />
			<col style="width:140px" />
			<col style="width:171px;" />
			<col style="width:140px" />
			<col style="" />
		</colgroup>
		<tbody>
		<tr>
			<th>
				<spring:message code='book.dvs.cd'/>
			</th>
			<td>
				<c:out value="${rims:codeValue('1110',book.bookDvsCd)}"/>
				<c:if test="${book.chapter == 'Y'}">
					(Chapter로 참여)
				</c:if>
			</td>
			<th>
				<spring:message code='book.char.cd'/>
			</th>
			<td>
				<c:out value="${rims:codeValue('1330',book.bookCharCd)}"/>
			</td>
			<th>
				<spring:message code='book.rvsn.yn'/>
			</th>
			<td>
				<c:out value="${rims:codeValue('1120',book.rvsnYn)}"/>
			</td>
		</tr>
		<tr>
			<th>
				<spring:message code='book.title.org'/>
			</th>
			<td colspan="5">
				<c:out value="${book.orgLangBookNm}"/>
			</td>
		</tr>
		<tr>
			<th>
				<spring:message code='book.chapter.title'/>
			</th>
			<td colspan="5">
				<c:out value="${book.chapterTitle}"/>
			</td>
		</tr>
		<tr>
			<th>
				<spring:message code='book.title.etc'/>
			</th>
			<td colspan="5">
				<c:out value="${book.diffLangBookNm}"/>
			</td>
		</tr>
		<tr>
			<th>
				<spring:message code='book.series'/>
			</th>
			<td colspan="5">
				<c:out value="${book.seriesNm}"/>
			</td>
		</tr>
		<tr>
			<th>
				<spring:message code='book.pblc.date'/>
			</th>
			<td>
				<c:if test="${book.bookPblcYear != null}">
					<c:out value="${book.bookPblcYear}"/>&nbsp;<spring:message code='common.year'/>&nbsp;&nbsp;
				</c:if>
				<c:if test="${book.bookPblcMonth != null}">
					<c:set var="trimBookPblcMonth" value="${fn:trim(book.bookPblcMonth)}"/>
					<c:out value="${trimBookPblcMonth}"/>&nbsp;<spring:message code='common.month'/>&nbsp;&nbsp;
				</c:if>
			</td>
			<th>
				<spring:message code='book.pblc.plc.nm'/>
			</th>
			<td colspan="3">
				<c:out value="${book.pblcPlcNm}"/>
			</td>
		</tr>
		<tr>
			<th>
				<spring:message code='book.jnl.dvs.cd'/>
			</th>
			<td>
				<c:out value="${rims:codeValue('1140',book.jnlDvsCd)}"/>
			</td>
			<th>
				<spring:message code='book.total.page'/>
			</th>
			<td>
				<c:out value="${book.totalPage}"/>
			</td>
			<th><spring:message code='book.wrt.page'/></th>
			<td>
				<c:out value="${book.wrtSttEndPage}"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code='book.mkout.lang.cd'/></th>
			<td>
				<c:out value="${rims:codeValue('1130',book.mkoutLangCd)}"/>
			</td>
			<th>ISBN</th>
			<td>
				<c:out value="${book.isbnNo}"/>
			</td>
			<th>ISSN</th>
			<td>
				<c:out value="${book.issnNo}"/>
			</td>
		</tr>
		<tr>
			<th>
				<spring:message code='book.dlgt.athr.nm'/>
			</th>
			<td>
				<c:out value="${book.dlgtAthrNm}"/>
			</td>
			<th>
				<spring:message code='book.sbjt.no'/>
			</th>
			<td colspan="4">
				<c:choose>
					<c:when test="${book.relateFundingAt eq 'N'}">
						없음
					</c:when>
					<c:when test="${book.fundingMapngList != null && book.fundingMapngList[0].sbjtNo != null}">
						<table class="in_tbl">
							<colgroup>
								<col style="width:115px;" />
								<col style="width:281px;" />
							</colgroup>
							<tbody>
							<c:forEach items="${book.fundingMapngList}" var="fml" varStatus="idx">
								<tr>
									<td>
										<c:out value="${fml.sbjtNo}"/>
									</td>
									<td>
										<c:out value="${fml.rschSbjtNm}"/>
									</td>
								</tr>
							</c:forEach>
							</tbody>
						</table>
					</c:when>
				</c:choose>
			</td>
		</tr>
		<tr>
			<th><spring:message code='book.authors'/></th>
			<td colspan="5">
				<div class="writer_td_inner">
					<em class="td_left_ex">ex) Eng : Hong, Gil dong / Kor : 홍길동</em>
					<p>
						<span style="font-weight: bold;"><spring:message code="book.total.athr.cnt"/></span>
						<em><c:out value="${book.totalAthrCnt}"/></em>
					</p>
				</div>
			</td>
		</tr>
		<tr>
			<td colspan="6" class="inner_tbl_td">
				<table class="inner_tbl move_tbl" id="prtcpntTbl" style="height: 50px;">
					<thead>
					<tr>
						<th colspan="2" style="width: 50px;"><spring:message code='book.order'/></th>
						<th style="width:150px;"><spring:message code='book.abbr.nm'/></th>
						<th style="width:150px;"><spring:message code='book.full.nm'/></th>
						<th style="width:80px;"><spring:message code='book.tpi.dvs.cd'/></th>
						<th style="width:160px"><spring:message code='book.user.id'/></th>
						<th style="width:160px"><spring:message code='book.agc.nm'/></th>
					</tr>
					</thead>
					<tbody id="prtcpntTbody">
					<c:if test="${not empty book.partiList}">
						<c:forEach items="${book.partiList}" var="pl" varStatus="idx">
							<tr <c:if test="${sessionScope.sess_user.userId eq pl.prtcpntId}">style="background-color: #FFCC66;"</c:if> >
								<td style="width:10px;text-align: left;"><img src="<c:url value='/images/icon/dragpoint.png' />" /></td>
								<td style="width:40px;text-align: center;">
									<span id="order_${idx.count}">${idx.count}</span>
								</td>
								<td style="width:150px;">
									<c:out value="${pl.prtcpntNm}"/>
								</td>
								<td style="width:150px;">
									<c:out value="${pl.prtcpntFullNm}"/>
								</td>
								<td style="width:80px;">
									<c:out value="${rims:codeValue('1340', pl.tpiDvsCd)}"/>
								</td>
								<td style="width:160px;">
 					  			<span class="ck_bt_box">
									<c:out value="${pl.prtcpntId}"/>
								</span>
								</td>
								<td style="width:160px;">
									<div class="r_add_bt">
										<c:out value="${pl.blngAgcNm}"/>
									</div>
								</td>
							</tr>
						</c:forEach>
					</c:if>
					</tbody>
				</table>
			</td>
		</tr>
		<tr>
			<th><spring:message code='book.org.file'/></th>
			<td colspan="5">
				<div class="fileupload_box">
					<c:forEach items="${book.fileList}" var="fd" varStatus="idx">
						<p class="upload_file_text">
							<a href="<c:url value="/servlet/download.do?fileid=${fd.fileId}"/>"><c:out value="${fd.fileNm}"/></a>&nbsp;&nbsp;
						</p>
					</c:forEach>
				</div>
			</td>
		</tr>
		<tr>
			<th>URL</th>
			<td colspan="5">
				<c:out value="${book.url}"/>
			</td>
		</tr>
		<c:choose>
			<c:when test="${sessionScope.login_user.adminDvsCd eq 'M' || sessionScope.login_user.adminDvsCd eq 'P'}">
				<tr>
					<th><spring:message code='book.author.keyword'/></th>
					<td colspan="5">
						<c:out value="${book.authorKeyword}"/>
					</td>
				</tr>
				<tr>
					<th>
						<spring:message code='book.vrfc.dvs.cd'/>
					</th>
					<td>
						<c:set var="vrfcDvsCd"  value="${empty book.vrfcDvsCd ? '1' : book.vrfcDvsCd}"/>
						<c:out value="${rims:codeValue('1420', vrfcDvsCd)}"/>
					</td>
					<th>
						<spring:message code='book.vrfc.date'/>
					</th>
					<td>
						<fmt:formatDate value="${book.vrfcDate}" pattern="yyyy-MM-dd" />
					</td>
					<th rowspan="2">
						<spring:message code='book.rtrn'/><br/>
					</th>
					<td rowspan="2">
						<c:out value="${book.apprRtrnCnclRsnCntn}"/>
					</td>
				</tr>
				<tr>
					<th><spring:message code='book.appr.dvs.cd'/></th>
					<td>
						<c:out value="${rims:codeValue('1400', book.apprDvsCd)}"/>
					</td>
					<th><spring:message code='book.appr.dvs.date'/></th>
					<td>
						<fmt:formatDate var="apprDate" value="${book.apprDate}" pattern="yyyy-MM-dd" /> <c:out value="${apprDate}"/>
					</td>
				</tr>
			</c:when>
			<c:otherwise>
				<tr>
					<th>
						<spring:message code='book.vrfc.dvs.cd'/>
					</th>
					<td>
						${rims:codeValue('1420', (empty book.vrfcDvsCd ? '1' : book.vrfcDvsCd))}
					</td>
					<th>
						<spring:message code='book.vrfc.date'/>
					</th>
					<td>
						<fmt:formatDate var="vrfcDate" value="${book.vrfcDate}" pattern="yyyy-MM-dd" /> <c:out value="${vrfcDate}"/>
					</td>
					<th rowspan="2">
						<spring:message code='book.rtrn'/><br/>
					</th>
					<td rowspan="2">
						<c:out value="${book.apprRtrnCnclRsnCntn}"/>
					</td>
				</tr>
				<tr>
					<th><spring:message code='book.appr.dvs.cd'/></th>
					<td>
						${rims:codeValue('1400', (empty book.apprDvsCd ? '1' : book.apprDvsCd))}
					</td>
					<th><spring:message code='book.appr.dvs.date'/></th>
					<td>
						<fmt:formatDate var="apprDate" value="${book.apprDate}" pattern="yyyy-MM-dd"/> <c:out value="${apprDate}"/>
					</td>
				</tr>
			</c:otherwise>
		</c:choose>
		<tr>
			<th><spring:message code='common.reg.date'/></th>
			<td>
				<fmt:formatDate var="regDate" value="${book.regDate}" pattern="yyyy-MM-dd" /> <c:out value="${regDate}"/> ( <c:out value="${empty book.regUserNm ? 'ADMIN' : book.regUserNm}"/> )
			</td>
			<th><spring:message code='common.mod.date'/></th>
			<td colspan="3">
				<fmt:formatDate var="modDate" value="${book.modDate}" pattern="yyyy-MM-dd" /> <c:out value="${modDate}"/> ( <c:out value="${empty book.modUserNm ? 'ADMIN' : book.modUserNm}"/> )
			</td>
		</tr>
		</tbody>
	</table>
</div>
</body>
</html>