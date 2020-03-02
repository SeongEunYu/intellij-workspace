<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.argonet.r2rims.util.LanguageUtil"%>
<%@include file="../../pageInit.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Article Detail</title>
<link type="text/css" href="<c:url value="/css/layout.css"/>" rel="stylesheet" />
<link type="text/css" href="<c:url value="/js/dhtmlx/skins/${sysConf['dhtmlx.skin']}/dhtmlx.css"/>" rel="stylesheet" />
<style type="text/css">
.dhxwins_vp_dhx_terrace {overflow: auto;}
.dhxwins_vp_dhx_terrace div.dhxwin_active div.dhx_cell_wins div.dhx_cell_toolbar_def, .dhxwins_vp_dhx_terrace div.dhxwin_inactive div.dhx_cell_wins div.dhx_cell_toolbar_def { padding: 10px 0px 0; }
.dhx_toolbar_dhx_terrace { padding: 0 0px; }
table {font-size: 12px;}
</style>
</head>
<body style="background: none;padding-left: 20px;width: 1002px;" style="overflow-y: auto;">
<div class="contents_box" style="width:887px;">
<div class="list_bt_area">
	<div class="list_set">
		<ul>
			<c:if test="${not empty param.mode and param.mode eq 'dplct'}">
			<li><a href="javascript:conferenceMove('${conference.conferenceId}');" class="list_icon04">선택된 학술활동 수정페이지로 이동</a></li>
			</c:if>
			<c:if test="${not empty param.mode and (param.mode eq 'search'  or param.mode eq 'scopus')}">
			<li><a href="javascript:resultConferenceInput();" class="list_icon04">학술활동 입력</a></li>
			</c:if>
		</ul>
	</div>
</div>
<table class="write_tbl mgb_10">
	<colgroup>
		<col style="width:130px;" />
		<col style="width:151px;" />
		<col style="width:130px" />
		<col style="width:151px;" />
		<col style="width:130px" />
		<col style="" />
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code='con.cfrc.dvs.cd'/></th>
			<td>
				<c:if test="${conference.scjnlDvsCd eq '1'}"><spring:message code='con.domestic'/></c:if>
				<c:if test="${conference.scjnlDvsCd eq '2'}"><spring:message code='con.international'/></c:if>
				<input type="hidden" id="rslt_scjnlDvsCd" value="${conference.scjnlDvsCd}">
			</td>
			<th><spring:message code='con.cfrc.hctr.cd'/></th>
			<td>
				${rims:codeValue('2000',conference.pblcNtnCd)}
				<input type="hidden" id="rslt_pblcNtnCd" value="${conference.pblcNtnCd}">
			</td>
			<th>ISSN</th>
			<td>${conference.issnNo}</td>
		</tr>
		<tr>
			<th><spring:message code='con.hld.date'/></th>
			<td colspan="3">
				<input type="hidden" id="rslt_hldSttDate" value="${conference.hldSttDate}">
				<input type="hidden" id="rslt_hldSttYear" value="${conference.hldSttYear}">
				<input type="hidden" id="rslt_hldSttMonth" value="${conference.hldSttMonth}">
				<input type="hidden" id="rslt_hldSttDay" value="${conference.hldSttDay}">

				<input type="hidden" id="rslt_hldEndDate" value="${conference.hldEndDate}">
				<input type="hidden" id="rslt_hldEndYear" value="${conference.hldEndYear}">
				<input type="hidden" id="rslt_hldEndMonth" value="${conference.hldEndMonth}">
				<input type="hidden" id="rslt_hldEndDay" value="${conference.hldEndDay}">
				<ui:dateformat value="${conference.hldSttDate}" pattern="yyyy.MM.dd" />
				<c:if test="${not empty conference.hldEndDate }"> ~ <ui:dateformat value="${conference.hldEndDate}" pattern="yyyy.MM.dd" /></c:if>
			</td>
			<th>ISBN</th>
			<td>
				<c:out value="${conference.isbnNo}"/>
				<input type="hidden" id="rslt_isbnNo" value="<c:out value="${conference.isbnNo}"/>">
			</td>
		</tr>
		<tr>
			<th><spring:message code='con.hld.agc.nm'/></th>
			<td colspan="5">
				<c:out value="${conference.pblcPlcNm}"/>
				<input type="hidden" id="rslt_pblcPlcNm" value="<c:out value="${conference.pblcPlcNm}"/>">
			</td>
		</tr>
		<tr>
			<th><spring:message code='con.cfrc.nm'/></th>
			<td colspan="5">
				<c:out value="${conference.cfrcNm}"/>
				<input type="hidden" id="rslt_cfrcNm" value="<c:out value="${conference.cfrcNm}"/>">
			</td>
		</tr>
		<tr>
			<th><%=LanguageUtil.languageMap.get("CON_SCTF_CFRC_ANCM_CLCT_PPR_NM")%></th>
			<td colspan="5">
				<c:out value="${conference.scjnlNm}"/>
				<input type="hidden" id="rslt_scjnlNm" value="<c:out value="${conference.scjnlNm}"/>">
			</td>
		</tr>
		<tr>
			<th><spring:message code='con.ancm.date'/></th>
			<td>
				<ui:dateformat value="${conference.ancmDate}" pattern="yyyy.MM.dd" /></td>
				<input type="hidden" id="rslt_ancmDate" value="${conference.ancmDate}">
				<input type="hidden" id="rslt_ancmYear" value="${conference.ancmYear}">
				<input type="hidden" id="rslt_ancmMonth" value="${conference.ancmMonth}">
				<input type="hidden" id="rslt_ancmDay" value="${conference.ancmDay}">
			<th><spring:message code='con.ancm.plc.nm'/></th>
			<td>
				<c:out value="${conference.ancmPlcNm}"/>
				<input type="hidden" id="rslt_ancmPlcNm" value="<c:out value="${conference.ancmPlcNm}"/>">
			</td>
			<th><spring:message code='con.language'/></th>
			<td>
				${rims:codeValue('2020',conference.pprLangDvsCd)}
				<input type="hidden" id="rslt_pprLangDvsCd" value="${conference.pprLangDvsCd}">
			</td>
		</tr>
		<tr>
			<th><spring:message code='con.volume'/></th>
			<td>
				<c:if test="${not empty conference.volume }">Vol. <c:out value="${conference.volume}"/> </c:if>
				<input type="hidden" id="rslt_volume" value="<c:out value="${conference.volume}"/>">
			</td>
			<th><spring:message code='con.issue'/></th>
			<td>
				<c:if test="${not empty conference.issue }">No. <c:out value="${conference.issue}"/></c:if>
				<input type="hidden" id="rslt_issue" value="<c:out value="${conference.issue}"/>">
			</td>
			<th><spring:message code='con.page'/></th>
			<td>
				<c:out value="${conference.sttPage}"/><c:if test="${not empty conference.endPage }"> - <c:out value="${conference.endPage}"/> </c:if>
				<input type="hidden" id="rslt_sttPage" value="<c:out value="${conference.sttPage}"/>">
				<input type="hidden" id="rslt_endPage" value="<c:out value="${conference.endPage}"/>">
			</td>
		</tr>
		<tr>
			<th><spring:message code='con.title.org'/></th>
			<td colspan="5">
				<c:out value="${conference.orgLangPprNm}"/>
				<input type="hidden" id="rslt_orgLangPprNm" value="<c:out value="${conference.orgLangPprNm}"/>">
			</td>
		</tr>
		<tr>
			<th><spring:message code='con.authors'/></th>
			<td colspan="5">
				<div class="writer_td_inner">
				  <p>
				  	전체저자수 : <c:out value="${conference.totalAthrCnt}"/>
				  	<input type="hidden" id="rslt_totalAthrCnt" value="<c:out value="${conference.totalAthrCnt}"/>">
				  	<input type="hidden" id="rslt_abstCntn" value="<c:out value="${conference.abstCntn}"/>">
				  	<input type="hidden" id="rslt_doi" value="<c:out value="${conference.doi}"/>" >
				  	<input type="hidden" id="rslt_url" value="<c:out value="${conference.url}"/>">
				  </p>
				</div>
			</td>
		</tr>
		<tr>
			<td colspan="6" class="inner_tbl_td">
				<table class="inner_tbl" id="prtcpntTbl" style="height: 50px;">
					<colgroup>
						<col style="width:175px;" />
						<col style="width:190px" />
						<col style="width:150px;" />
						<%--
						<col style="width:170px" />
						 --%>
						<col style="" />
						<col style="width:100px;" />
					</colgroup>
					<thead>
					  <tr>
						<th><spring:message code='con.abbr.nm'/></th>
						<th><spring:message code='con.full.nm'/></th>
						<th><spring:message code='con.tpi.dvs.cd'/></th>
						<%--
						<th><spring:message code='con.user.id'/></th>
						 --%>
						<th><spring:message code='con.blng.agc.nm'/></th>
					  </tr>
					</thead>
					<tbody>
				<c:if test="${not empty conference.partiList}">
					<c:forEach items="${conference.partiList}" var="parti" varStatus="idx">
						<tr id="prtcpnt${idx.count}" class="prtcpnt">
							<td style="text-align: center;">
								<c:out value="${parti.prtcpntNm}"/>
								<input type="hidden" id="rslt_parti_prtcpntId_${idx.count}" value="<c:out value="${parti.prtcpntId}"/>">
								<input type="hidden" id="rslt_parti_prtcpntNm_${idx.count}" value="<c:out value="${parti.prtcpntNm}"/>">
								<input type="hidden" id="rslt_parti_scopusAuthorId_${idx.count}" value="${parti.scopusAuthorId}">
							</td>
							<td style="text-align: center;">
								<c:out value="${parti.prtcpntFullNm}"/>
								<input type="hidden" id="rslt_parti_prtcpntFullNm_${idx.count}" value="<c:out value="${parti.prtcpntFullNm}"/>">
							</td>
							<td style="text-align: center;">
								${rims:codeValue('1180', parti.tpiDvsCd) }
								<input type="hidden" id="rslt_parti_tpiDvsCd_${idx.count}" value="${parti.tpiDvsCd}">
							</td>
							<%--
							<td style="text-align: center;">${fn:escapeXml(parti.prtcpntId)}</td>
							 --%>
							<td style="text-align: left;">
								<c:out value="${parti.blngAgcNm}"/>
								<input type="hidden" id="rslt_parti_blngAgcNm_${idx.count}" value="<c:out value="${parti.blngAgcNm}"/>">
							</td>
						</tr>
					</c:forEach>
				</c:if>
				<c:if test="${not empty conference.authors }">
					<c:set var="authors"  value="${fn:split(conference.authors,'and')}" />
					<c:forEach var="authr"  items="${authors}" varStatus="idx">
						<tr id="prtcpnt${idx.count}" class="prtcpnt">
							<td style="text-align: center;"></td>
							<td style="text-align: center;">${fn:escapeXml(authr)}</td>
							<td style="text-align: center;"></td>
							<%--
							<td style="text-align: center;">${fn:escapeXml(parti.prtcpntId)}</td>
							 --%>
							<td style="text-align: left;"></td>
						</tr>
					</c:forEach>
				</c:if>
				</tbody>
			  </table>
			</td>
		</tr>
	</tbody>
</table>
</div>
</body>
</html>