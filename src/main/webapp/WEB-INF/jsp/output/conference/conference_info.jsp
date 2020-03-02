<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.commons.lang3.ObjectUtils"%>
<%@ page import="kr.co.argonet.r2rims.util.LanguageUtil"%>
<%@include file="../../pageInit.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Conference Detail</title>
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
	<h3>Conference 상세</h3>
</div>
<div class="contents_box" style="width:1002px;">
	<table class="write_tbl mgb_10" >
		<colgroup>
			<col style="width:15%;" />
			<col style="width:20%;" />
			<col style="width:15%;" />
			<col style="width:20%;" />
			<col style="width:15%;" />
			<col style="width:20%;" />
			<col style="width:20%;" />
		</colgroup>
		<tbody>
		<tr>
			<th class="add_help">
				<spring:message code='con.cfrc.dvs.cd'/>
			</th>
			<td>
				<c:out value="${conference.scjnlDvsCd eq '1' ? '국내': '국제'}" />
			</td>
			<th>
				<spring:message code='con.cfrc.hctr.cd'/>
			</th>
			<td>
				<c:out value="${rims:codeValue('2000',conference.pblcNtnCd)}"/>
			</td>
			<th>ISSN</th>
			<td colspan="2">
				<c:out value="${conference.issnNo}"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code='con.hld.date'/></th>
			<td colspan="3">
				<c:if test="${conference.hldSttYear != null}"><c:out value="${conference.hldSttYear}"/><spring:message code='common.year'/>&nbsp;</c:if>
				<c:if test="${conference.hldSttMonth != null}"><c:out value="${conference.hldSttMonth}"/><spring:message code='common.month'/>&nbsp;</c:if>
				<c:if test="${conference.hldSttDay != null}"><c:out value="${conference.hldSttDay}"/><spring:message code='common.day'/>&nbsp;</c:if>

				<c:if test="${conference.hldEndYear != null}">~<c:out value="${conference.hldEndYear}"/><spring:message code='common.year'/>&nbsp;</c:if>
				<c:if test="${conference.hldEndMonth != null}"><c:out value="${conference.hldEndMonth}"/><spring:message code='common.month'/>&nbsp;</c:if>
				<c:if test="${conference.hldEndDay != null}"><c:out value="${conference.hldEndDay}"/><spring:message code='common.day'/>&nbsp;</c:if>
			</td>
			<th>
				<spring:message code='con.ancm.date'/>
			</th>
			<td colspan="2">
				<c:if test="${conference.ancmYear != null}"><c:out value="${conference.ancmYear}"/><spring:message code='common.year'/>&nbsp;</c:if>
				<c:if test="${conference.ancmMonth != null}"><c:out value="${conference.ancmMonth}"/><spring:message code='common.month'/>&nbsp;</c:if>
				<c:if test="${conference.ancmDay != null}"><c:out value="${conference.ancmDay}"/><spring:message code='common.day'/>&nbsp;</c:if>
			</td>
		</tr>
		<tr>
			<th>
				<spring:message code='con.hld.agc.nm'/>
			</th>
			<td colspan="6">
				<c:out value="${conference.pblcPlcNm}"/>
			</td>
		</tr>
		<c:if test="${sessionScope.auth.adminDvsCd eq 'M' or sessionScope.auth.adminDvsCd eq 'P' or sessionScope.sess_user.deptCode eq '2783'  or sessionScope.sess_user.deptCode eq '2785' }">
			<tr>
				<th><spring:message code='con.cfrc.nm'/>(BK)</th>
				<td colspan="4">
					<c:out value="${conference.schlshpCnfrncNm}"/>
				</td>
				<th><spring:message code="con.regarded.if"/></th>
				<td>
					<c:out value="${conference.impctFctr}"/>
				</td>
			</tr>
		</c:if>
		<tr>
			<th>
				<spring:message code='con.cfrc.nm'/>
			</th>
			<td colspan="6">
				<c:out value="${conference.cfrcNm}"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code="con.sctf.cfrc.ancm.clct.ppr.nm"/></th>
			<td colspan="3">
				<c:out value="${conference.scjnlNm}"/>
			</td>
			<th><spring:message code='con.ancm.plc.nm'/></th>
			<td colspan="2">
				<c:out value="${conference.ancmPlcNm}"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code="con.ancm.stle"/></th>
			<td>
				<c:out value="${rims:codeValue('con.ancm.stle',conference.ancmStleCd)}"/>
			</td>
			<th><spring:message code='con.language'/></th>
			<td>
				<c:out value="${rims:codeValue('2020',conference.pprLangDvsCd)}"/>
			</td>
			<th>
				<spring:message code='con.page'/>
			</th>
			<td colspan="2">
				<c:out value="${conference.sttPage}"/>
				<c:if test="${conference.endPage}">
					-&nbsp;&nbsp;<c:out value="${conference.endPage}"/>
				</c:if>
			</td>
		</tr>
		<tr>
			<th>
				<spring:message code='con.title.org'/>
			</th>
			<td colspan="6">
				<c:out value="${conference.orgLangPprNm}"/>
			</td>
		</tr>
		<tr>
			<th>
				<spring:message code='con.title.etc'/>
			</th>
			<td colspan="6">
				<c:out value="${conference.diffLangPprNm}"/>
			</td>
		</tr>
		<tr>
			<th class="add_help">
				<spring:message code='con.rsrchacps'/>
			</th>
			<td>
				<c:out value="${pageContext.response.locale eq 'en' ? conference.rsrchacpsStdySpheEngValue : conference.rsrchacpsStdySpheValue }"/>
			</td>
			<th class="add_help">
				<spring:message code='con.sbjt.no'/>
			</th>
			<td colspan="4">
				<c:choose>
					<c:when test="${conference.relateFundingAt eq 'N'}">
						없음
					</c:when>
					<c:when test="${conference.fundingMapngList != null && conference.fundingMapngList[0].sbjtNo != null}">
						<table class="in_tbl">
							<colgroup>
								<col style="width:115px;" />
								<col style="width:281px;" />
							</colgroup>
							<tbody>
							<c:forEach items="${conference.fundingMapngList}" var="fml" varStatus="idx">
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
			<th><spring:message code='con.authors'/></th>
			<td colspan="6">
				<div class="writer_td_inner">
					<em class="td_left_ex">ex) Eng : Hong, Gil dong / Kor : 홍길동</em>
					<p>
						<spring:message code="con.total.athr.cnt" />
						<c:out value="${conference.totalAthrCnt}"/>
					</p>
				</div>
			</td>
		</tr>
		<tr>
			<td colspan="7" class="inner_tbl_td">
				<table class="inner_tbl move_tbl" id="prtcpntTbl" style="height: 50px;">
					<thead>
					<tr>
						<th colspan="2" style="width: 50px;"><spring:message code='con.order'/></th>
						<th style="width: 100px;"><spring:message code='con.abbr.nm'/></th>
						<th style="width: 100px;"><spring:message code='con.full.nm'/></th>
						<th style="width: 80px;"><spring:message code='con.tpi.dvs.cd'/></th>
						<th style="width: 160px;"><spring:message code='con.user.id'/></th>
						<th style="width: 160px;"><spring:message code='con.blng.agc.nm'/></th>
						<th style="width: 100px;"><spring:message code='con.author.dept'/></th>
					</tr>
					</thead>
					<tbody>
					<c:if test="${not empty conference.partiList}">
						<c:forEach items="${conference.partiList}" var="pl" varStatus="idx">
							<tr <c:if test="${sessionScope.sess_user.userId eq pl.prtcpntId}">style="background-color: #FFCC66;"</c:if>>
								<td style="width:10px;text-align: left;"><img src="<c:url value='/images/icon/dragpoint.png' />" /></td>
								<td style="width:40px;text-align: center;">
									<span id="order_${idx.count}">${idx.count}</span>
								</td>
								<td style="width:100px;">
									<c:out value="${pl.prtcpntNm}"/>
								</td>
								<td style="width:100px">
									<c:out value="${pl.prtcpntFullNm}"/>
								</td>
								<td style="width:80px;">
									<c:out value="${rims:codeValue('1180',pl.tpiDvsCd)}"/>
								</td>
								<td style="width:160px">
									<c:out value="${pl.prtcpntId}"/>
								</td>
								<td style="width:160px">
									<c:out value="${pl.blngAgcCd}"/>
								</td>
								<td style="width:100px" class="dispDept">
									<c:if test="${not empty pl.blngAgcNm and pl.blngAgcNm eq instName}"><c:out value="${pl.deptKor}"/></c:if>
								</td>
							</tr>
							<c:set var="prtcpntIdx" value="${idx.count}"/>
						</c:forEach>
					</c:if>
					<script type="text/javascript">var prtcpntIdx = '${prtcpntIdx}';</script>
					</tbody>
				</table>
			</td>
		</tr>
		<tr>
			<th>
				<spring:message code='con.abstract'/>
			</th>
			<td colspan="6">
				<c:out value="${conference.abstCntn}"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code='con.file.open.at'/></th>
			<td>
				<c:choose>
					<c:when test="${empty conference.isOpen and conference.isOpen eq 'Y'}">
						<spring:message code='file.ir.open.y'/>
					</c:when>
					<c:otherwise>
						<spring:message code='file.ir.open.n'/>
					</c:otherwise>
				</c:choose>
			</td>
			<th><spring:message code='con.org.file'/></th>
			<td colspan="4">
				<div class="fileupload_box">
					<c:forEach items="${conference.fileList}" var="fd" varStatus="idx">
						<p class="upload_file_text">
							<a href="<c:url value="/servlet/download.do?fileid=${fd.fileId}"/>"><c:out value="${fd.fileNm}"/></a>&nbsp;&nbsp;
						</p>
					</c:forEach>
				</div>
			</td>
		</tr>
		<tr> <!--  논문 외부정보원 ID -->
			<th class="add_help">
				WOS ID
			</th>
			<td>
				<c:out value="${conference.idSci}"/>
			</td>
			<th class="add_help">
				SCOPUS ID
			</th>
			<td>
				<c:out value="${conference.idScopus}"/>
			</td>
			<th>KCI ID</th>
			<td colspan="2">
				<c:out value="${conference.idKci}"/>
			</td>
		</tr>
		<tr>
			<th>DOI</th>
			<td colspan="4">
				<c:if test="${conference.doi != null}">
					http://dx.doi.org/<c:out value="${conference.doi}"/>
				</c:if>
			</td>
			<td></td>
			<td></td>
		</tr>
		<tr>
			<th>URL</th>
			<td colspan="4">
				<c:if test="${conference.url != null}">
					<c:out value="${conference.url}"/>
				</c:if>
			</td>
			<td></td>
			<td></td>
		</tr>
		<tr>
			<th><spring:message code='con.author.keyword'/></th>
			<td colspan="6">
				<c:out value="${conference.authorKeyword}"/>
			</td>
		</tr>
		<c:if test="${sessionScope.login_user.adminDvsCd eq 'M'}">
			<tr>
				<th><spring:message code='con.appr.dvs'/></th>
				<td>
						${rims:codeValue('1400',conference.apprDvsCd)}
				</td>
				<th><spring:message code='con.appr.dvs.date'/></th>
				<td>
					<fmt:formatDate var="apprDate" value="${conference.apprDate}" pattern="yyyy-MM-dd" /><c:out value="${apprDate}"/>
				</td>
				<th>
					<spring:message code='con.rtrn'/><br/>
				</th>
				<td colspan="2">
					<c:out value="${conference.apprRtrnCnclRsnCntn}"/>
				</td>
			</tr>
		</c:if>
		<c:if test="${sessionScope.login_user.adminDvsCd ne 'M'}">
			<tr>
				<th><spring:message code='art.appr.dvs'/></th>
				<td>
						${rims:codeValue('1400',conference.apprDvsCd)}
				</td>
				<th><spring:message code='con.appr.dvs.date'/></th>
				<td>
					<fmt:formatDate var="apprDate" value="${conference.apprDate}" pattern="yyyy-MM-dd" /><c:out value="${apprDate}"/>
				</td>
				<th><spring:message code='con.rtrn'/></th>
				<td colspan="2">
					<c:out value="${conference.apprRtrnCnclRsnCntn}"/>
				</td>
			</tr>
		</c:if>
		<tr>
			<th><spring:message code='common.reg.date'/></th>
			<td>
				<fmt:formatDate var="regDate" value="${conference.regDate}" pattern="yyyy-MM-dd" /> <c:out value="${regDate}"/> ( <c:out value="${empty conference.regUserNm ? 'ADMIN' : conference.regUserNm}"/> )
			</td>
			<th><spring:message code='common.mod.date'/></th>
			<td>
				<fmt:formatDate var="modDate" value="${conference.modDate}" pattern="yyyy-MM-dd" /> <c:out value="${modDate}"/> ( <c:out value="${empty conference.modUserNm ? 'ADMIN' : conference.modUserNm}"/> )
			</td>
			<td></td>
			<td colspan="2"></td>
		</tr>
		</tbody>
	</table>
</div>
</body>
</html>