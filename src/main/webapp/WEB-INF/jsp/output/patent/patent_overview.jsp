<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.argonet.r2rims.util.LanguageUtil"%>
<%@include file="../../pageInit.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Article Detail</title>
<link type="text/css" href="${contextPath}/css/layout.css" rel="stylesheet" />
<link type="text/css" href="${contextPath}/js/dhtmlx/skins/${sysConf['dhtmlx.skin']}/dhtmlx.css" rel="stylesheet" />
<style type="text/css">
.dhxwins_vp_dhx_terrace {overflow: auto;}
.dhxwins_vp_dhx_terrace div.dhxwin_active div.dhx_cell_wins div.dhx_cell_toolbar_def, .dhxwins_vp_dhx_terrace div.dhxwin_inactive div.dhx_cell_wins div.dhx_cell_toolbar_def { padding: 10px 0px 0; }
.dhx_toolbar_dhx_terrace { padding: 0 0px; }
table {font-size: 12px;}
</style>
</head>
<body style="background: none;padding-left: 20px;" style="overflow-y: auto;">
<div class="contents_box" style="width:876px;">
<div class="list_bt_area">
	<div class="list_set">
		<ul>
			<li><a href="javascript:patentMove('${patent.patentId}');" class="list_icon04">선택된 지식재산(특허) 수정페이지로 이동</a></li>
		</ul>
	</div>
</div>
<table class="write_tbl mgb_10" >
	<colgroup>
		<col style="width: 165px;"></col>
		<col style="width: 371px;"></col>
		<col style="width: 165px;"></col>
		<col style=""></col>
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code='patn.itl.ppr.rgt.dvs.cd'/></th>
			<td>${rims:codeValue('1080',patent.itlPprRgtDvsCd)}</td>
			<th><spring:message code='patn.acqs.dvs.cd'/></th>
			<td>${rims:codeValue('1090',patent.acqsDvsCd)}</td>
		</tr>
		<tr>
			<th><spring:message code='patn.acqs.ntn.dvs.cd'/></th>
			<td>${rims:codeValue('1140',patent.acqsNtnDvsCd)}</td>
			<th><spring:message code='patn.appl.reg.ntn.cd'/></th>
			<td>${rims:codeValue('2000',patent.applRegNtnCd)}</td>
		</tr>
		<tr>
			<th><spring:message code='patn.itl.title.org'/></th>
			<td colspan="3">${patent.itlPprRgtNm}</td>
		</tr>
		<tr>
			<th>지식재산권명(타언어)</th>
			<td colspan="3">${patent.diffItlPprRgtNm}</td>
		</tr>
		<tr>
			<th><spring:message code='patn.appl.reg.date'/></th>
			<td><ui:dateformat value="${patent.applRegDate}" pattern="yyyy.MM.dd" /></td>
			<th><spring:message code='patn.appl.reg.no'/></th>
			<td>${patent.applRegNo}</td>
		</tr>
		<tr>
			<th><spring:message code='patn.itl.ppr.rgt.reg.date'/></th>
			<td><ui:dateformat value="${patent.itlPprRgtRegDate}" pattern="yyyy.MM.dd" /></td>
			<th><spring:message code='patn.itl.ppr.rgt.reg.no'/></th>
			<td>${patent.itlPprRgtRegNo}</td>
		</tr>
		<tr>
			<th><spring:message code='patn.appr.regt.nm'/></th>
			<td>${patent.applRegtNm}</td>
			<th><spring:message code='patn.pat.cls.cd'/></th>
			<td>${rims:codeValue('1710',patent.patClsCd)}</td>
		</tr>
		<tr>
			<th><spring:message code='patn.invt.nm'/></th>
			<td colspan="3">${patent.invtNm}</td>
		</tr>
	</tbody>
</table>
</div>
</body>
</html>