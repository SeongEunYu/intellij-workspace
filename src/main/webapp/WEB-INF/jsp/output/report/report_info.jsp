<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.commons.lang3.ObjectUtils"%>
<%@ page import="kr.co.argonet.r2rims.util.LanguageUtil"%>
<%@include file="../../pageInit.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>연구리포트 Detail</title>
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
	<h3>연구리포트 상세</h3>
</div>
<div class="contents_box" style="width:1002px;">
	<table class="write_tbl mgb_10" >
		<colgroup>
			<col style="width:170px;" />
			<col style="width:296px;" />
			<col style="width:170px" />
			<col style="" />
		</colgroup>
		<tbody>
		<tr>
			<th><spring:message code='rprt.date'/></th>
			<td>
				<c:if test="${report.pblicteYear != null}"><c:out value="${report.pblicteYear}"/>&nbsp;<spring:message code='common.year'/>&nbsp;&nbsp;</c:if>
				<c:if test="${report.pblicteMonth != null}"><c:out value="${report.pblicteMonth}"/>&nbsp;<spring:message code='common.month'/>&nbsp;&nbsp;</c:if>
			</td>
			<th><spring:message code='rprt.ntn.cd'/></th>
			<td>
				<c:out value="${report.pblicteNationNm}"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code='rprt.nm'/></th>
			<td colspan="3">
				<c:out value="${report.reportTitle}"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code='rprt.related.projt.nm'/></th>
			<td colspan="3">
				<c:out value="${report.rschSbjtNm}"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code='rprt.agc.nm'/></th>
			<td>
				<c:out value="${report.orderInsttNm}"/>
			</td>
			<th><spring:message code='rprt.type'/></th>
			<td>
				<c:out value="${rims:codeValue('report.type',report.reportTypeCode)}"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code='rprt.sbjt.no'/></th>
			<td>
				<c:out value="${report.sbjtNo}"/>
			</td>
			<th><spring:message code='rprt.instt.sbjt.no'/></th>
			<td>
				<c:out value="${report.detailSbjtNo}"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code='rprt.this.year.stt.date'/></th>
			<td>
				<c:if test="${report.thsyrRsrchSttYear != null}"><c:out value="${report.thsyrRsrchSttYear}"/>&nbsp;<spring:message code='common.year'/>&nbsp;&nbsp;</c:if>
				<c:if test="${report.thsyrRsrchSttMonth != null}"><c:out value="${report.thsyrRsrchSttMonth}"/>&nbsp;<spring:message code='common.month'/>&nbsp;&nbsp;</c:if>
				<c:if test="${report.thsyrRsrchSttDay != null}"><c:out value="${report.thsyrRsrchSttDay}"/>&nbsp;<spring:message code='common.day'/>&nbsp;&nbsp;</c:if>
			</td>
			<th><spring:message code='rprt.this.year.end.date'/></th>
			<td>
				<c:if test="${report.thsyrRsrchEndYear != null}"><c:out value="${report.thsyrRsrchEndYear}"/>&nbsp;<spring:message code='common.year'/>&nbsp;&nbsp;</c:if>
				<c:if test="${report.thsyrRsrchEndMonth != null}"><c:out value="${report.thsyrRsrchEndMonth}"/>&nbsp;<spring:message code='common.month'/>&nbsp;&nbsp;</c:if>
				<c:if test="${report.thsyrRsrchEndDay != null}"><c:out value="${report.thsyrRsrchEndDay}"/>&nbsp;<spring:message code='common.day'/>&nbsp;&nbsp;</c:if>
			</td>
		</tr>
		<tr>
			<th><spring:message code='rprt.total.stt.date'/></th>
			<td>
				<c:if test="${report.totRsrchSttYear != null}"><c:out value="${report.totRsrchSttYear}"/>&nbsp;<spring:message code='common.year'/>&nbsp;&nbsp;</c:if>
				<c:if test="${report.totRsrchSttMonth != null}"><c:out value="${report.totRsrchSttMonth}"/>&nbsp;<spring:message code='common.month'/>&nbsp;&nbsp;</c:if>
				<c:if test="${report.totRsrchSttDay != null}"><c:out value="${report.totRsrchSttDay}"/>&nbsp;<spring:message code='common.day'/>&nbsp;&nbsp;</c:if>
			</td>
			<th><spring:message code='rprt.total.end.date'/></th>
			<td>
				<c:if test="${report.totRsrchEndYear != null}"><c:out value="${report.totRsrchEndYear}"/>&nbsp;<spring:message code='common.year'/>&nbsp;&nbsp;</c:if>
				<c:if test="${report.totRsrchEndMonth != null}"><c:out value="${report.totRsrchEndMonth}"/>&nbsp;<spring:message code='common.month'/>&nbsp;&nbsp;</c:if>
				<c:if test="${report.totRsrchEndDay != null}"><c:out value="${report.totRsrchEndDay}"/>&nbsp;<spring:message code='common.day'/>&nbsp;&nbsp;</c:if>
			</td>
		</tr>
		<tr>
			<th><spring:message code='rprt.exec.instt.nm'/></th>
			<td>
				<c:out value="${report.sbjtExcInsttNm}"/>
			</td>
			<th><spring:message code='rprt.mgt.instt.nm'/></th>
			<td>
				<c:out value="${report.sbjtManageInsttNm}"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code='rprt.authors'/></th>
			<td colspan="3"></td>
		</tr>
		<tr>
			<td colspan="4" class="inner_tbl_td">
				<table class="inner_tbl move_tbl" id="prtcpntTbl" style="height: 50px;">
					<colgroup>
						<col style="width: 8%;" />
						<col style="width: 16%;" />
						<col style="width: 16%;" />
						<col style="width: 10%;" />
						<col style="width: 18%;" />
						<col />
					</colgroup>
					<thead>
					<tr>
						<th><spring:message code='rprt.order'/></th>
						<th><spring:message code='rprt.abbr.nm'/></th>
						<th><spring:message code='rprt.full.nm'/></th>
						<th><spring:message code='rprt.tpi.dvs.cd'/></th>
						<th><spring:message code='rprt.user.id'/></th>
						<th><spring:message code='rprt.aff.nm'/></th>
					</tr>
					</thead>
					<tbody id="prtcpntTbody">
					<c:if test="${not empty report.partiList}">
						<c:forEach items="${report.partiList}" var="pl" varStatus="idx">
							<tr <c:if test="${sessionScope.sess_user.userId eq pl.prtcpntId}">style="background-color: #FFCC66;"</c:if> >
								<td style="text-align: center;">
									<span id="order_${idx.count}">${idx.count}</span>
								</td>
								<td>
									<c:out value="${pl.prtcpntNm}"/>
								</td>
								<td>
									<c:out value="${pl.prtcpntFullNm}"/>
								</td>
								<td>
									<c:out value="${rims:codeValue('1340',pl.tpiDvsCd)}"/>
								</td>
								<td>
 					  			<span class="dk_bt_box">
									<c:out value="${pl.prtcpntId}"/>
								</span>
								</td>
								<td>
									<c:out value="${pl.blngAgcNm}"/>
								</td>
							</tr>
						</c:forEach>
					</c:if>
					</tbody>
				</table>
			</td>
		</tr>
		<tr>
			<th><spring:message code='rprt.keyword'/></th>
			<td colspan="3">
				<c:out value="${report.keyword}"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code='con.org.file'/></th>
			<td colspan="5">
				<div class="fileupload_box">
					<c:forEach items="${report.fileList}" var="fd" varStatus="idx">
						<p class="upload_file_text">
							<a href="<c:url value="/servlet/download.do?fileid=${fd.fileId}"/>"><c:out value="${fd.fileNm}"/></a>&nbsp;&nbsp;
						</p>
					</c:forEach>
				</div>
			</td>
		</tr>
		<tr>
			<th><spring:message code='rprt.file.open.at'/></th>
			<td>
				<c:choose>
					<c:when test="${report.orginlOthbcAt eq 'Y'}">
						&nbsp;<spring:message code='rprt.open.y'/>&nbsp;&nbsp;
					</c:when>
					<c:otherwise>
						&nbsp;<spring:message code='rprt.open.n'/>&nbsp;&nbsp;
					</c:otherwise>
				</c:choose>
			</td>
			<th><spring:message code='rprt.security.at'/></th>
			<td>
				<c:choose>
					<c:when test="${report.scrtySbjtAt eq 'Y'}">
						&nbsp;<spring:message code='common.radio.yes'/>&nbsp;&nbsp;
					</c:when>
					<c:otherwise>
						&nbsp;<spring:message code='common.radio.no'/>&nbsp;&nbsp;
					</c:otherwise>
				</c:choose>
			</td>
		</tr>
		<c:if test="${sessionScope.login_user.adminDvsCd eq 'M'}">
			<tr>
				<th><spring:message code='rprt.appr.dvs'/></th>
				<td>
					<c:out value="${rims:codeValue('1400',report.apprDvsCd)}"/>
				</td>
				<th rowspan="2"><spring:message code='rprt.appr.rtrn'/></th>
				<td rowspan="2">
					<c:out value="${report.apprRtrnCnclRsnCntn}"/>
				</td>
			</tr>
			<tr>
				<th><spring:message code='rprt.appr.dvs.date'/></th>
				<td><fmt:formatDate value="${report.apprDate}" pattern="yyyy-MM-dd" /></td>
			</tr>
		</c:if>
		<c:if test="${sessionScope.login_user.adminDvsCd ne 'M'}">
			<tr>
				<th><spring:message code='rprt.appr.dvs'/></th>
				<td>
					<c:out value="${rims:codeValue('1400',report.apprDvsCd)}"/>
				</td>
				<th rowspan="2"><spring:message code='rprt.appr.rtrn'/></th>
				<td rowspan="2">
					<c:out value="${report.apprRtrnCnclRsnCntn}"/>
				</td>
			</tr>
			<tr>
				<th><spring:message code='rprt.appr.dvs.date'/></th>
				<td><fmt:formatDate value="${report.apprDate}" pattern="yyyy-MM-dd" /></td>
			</tr>
		</c:if>
		<tr>
			<th><spring:message code='common.reg.date'/></th>
			<td>
				<fmt:formatDate var="regDate" value="${report.regDate}" pattern="yyyy-MM-dd" /> <c:out value="${regDate}"/> ( <c:out value="${empty report.regUserNm ? 'ADMIN' : report.regUserNm}"/> )
			</td>
			<th><spring:message code='common.mod.date'/></th>
			<td>
				<fmt:formatDate var="modDate" value="${report.modDate}" pattern="yyyy-MM-dd" /> <c:out value="${modDate}"/> ( <c:out value="${empty report.modUserNm ? 'ADMIN' : report.modUserNm}"/> )
			</td>
		</tr>
		</tbody>
	</table>
</div>
</body>
</html>