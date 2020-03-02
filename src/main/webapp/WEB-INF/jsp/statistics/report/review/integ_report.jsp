<%@page import="kr.co.argonet.r2rims.util.LanguageUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="../../../pageInit.jsp" %>
<style type="text/css">
.list_bt_area{border: 0px solid;}
div.gridbox_dhx_terrace.gridbox table.hdr td{vertical-align: middle;}
table.table_layout{width: 100%;}
table.table_layout th{border: 1px solid #ccc;height:25px;background-color: #f7f7f7;}
table.table_layout td{border: 1px solid #ccc;height:25px;}
.sumTr td {font-weight:bold;}
</style>
<script type="text/javascript" src="${contextPath}/js/jquery/jquery.filedownload.js"></script>
<script type="text/javascript" src="${contextPath}/js/mainLayout.js"></script>
<script type="text/javascript">
var dhxLayout, myTabbar, t;
$(document).ready(function(){
	setMainLayoutHeight($('#mainLayout'), -170);
	if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
	else  window.addEventListener("resize",resizeLayout, false);
	//set layout
	dhxLayout = new dhtmlXLayoutObject("mainLayout","1C");
	dhxLayout.cells("a").hideHeader();
	dhxLayout.setSizes(false);
	myTabbar = dhxLayout.cells("a").attachTabbar();
	myTabbar.setArrowsMode("auto");
	myTabbar.enableAutoReSize(true);
	myTabbar.addTab('a1',"<spring:message code='stats.report.integ.tab.position'/>");
	myTabbar.addTab('a2',"<spring:message code='stats.report.integ.tab.appointment'/>");
	myTabbar.addTab('a3',"<spring:message code='stats.report.integ.tab.appointment.sci'/>");
	myTabbar.tabs('a1').attachObject('grade1Area');
	myTabbar.tabs('a2').attachObject('appointmentArea');
	myTabbar.tabs('a3').attachObject('appointmentSciArea');
	myTabbar.tabs('a1').setActive();
	$('#grade1Layout').css({'height':($(window).height()-(405+$('.title_box').height()+$('#grade1FormArea').height()+$('.list_bt_area').height()))+"px"});
	$('#appointmentLayout').css({'height':($(window).height()-(271+$('.title_box').height()+$('.list_bt_area').height()))+"px"});
});

function resizeLayout() {
	window.clearTimeout(t);
	t = window.setTimeout(function() {
		setMainLayoutHeight($('#mainLayout'), -170);
		dhxLayout.setSizes(false);
		$('#grade1Layout').css({'height':($(window).height()-(405+$('.title_box').height()+$('#grade1FormArea').height()+$('.list_bt_area').height()))+"px"});
		$('#appointmentLayout').css({'height':($(window).height()-(271+$('.title_box').height()+$('.list_bt_area').height()))+"px"});
		$('#appointmentSciLayout').css({'height':($(window).height()-(271+$('.title_box').height()+$('.list_bt_area').height()))+"px"});
	}, 80);
}
function doOnGridLoaded(){setTimeout(function() {dhxLayout.cells("a").progressOff();}, 100);}
function doBeforeGridLoad(){dhxLayout.cells("a").progressOn();}

function setGridHeight(obj){
	var layoutHeight = $('#mainLayout').height();
	layoutHeight -= 16;
	if($('.title_box') != undefined )
		layoutHeight -= $('.dhxtabbar_tab').height();
	if($('.list_bt_area') != undefined )
		layoutHeight -= $('.list_bt_area').height();
	$(obj).css('height',layoutHeight+"px");
}
function changeOriginSe() {
	if ($('input[name=originSe]:checked').val() == "MNG") {
		$('.rims_date input').attr('disabled', false);
		$('.promote_date input').attr('disabled', true);
	} else if ($('input[name=originSe]:checked').val() == "USR") {
		$('.rims_date input').attr('disabled', true);
		$('.promote_date input').attr('disabled', false);
	}
}
function updateGradeDate(originSe) {
	var className = "";
	if (originSe == "MNG") className = ".rims_date";
	else if (originSe == "USR") className = ".promote_date";
	$.ajax({
		url:'updateUserGradeAjax.do?originSe='+originSe,
		data: $(className).find('input').serialize()
	}).done(function(data){
		alert(data);
	});
}
function loadGradeReport() {
	$.ajax({
		url: 'gradeReportAjax.do',
		data: $("#grade1formArea").serialize()
	}).done(function(data) {
		$('#grade1Layout').html(data);
		//소계 데이터 bold처리
		$('#grade1Layout tbody tr').eq(2).attr('class','sumTr');
		$('#grade1Layout tbody tr').eq(5).attr('class','sumTr');
		$('#grade1Layout tbody tr').eq(8).attr('class','sumTr');
		$('#grade1Layout tbody tr').eq(11).attr('class','sumTr');
		$('#grade1Layout tbody tr').eq(14).attr('class','sumTr');
	});
}
function downloadXlsx(areaName, fileName) {
	$("#excelForm>input").remove();
	$("#excelForm").append("<input type='hidden' id='tableHtml' name='tableHtml' value='' />");
	$("#tableHtml").val($("#"+areaName).clone().wrapAll("<div/>").parent().html());
	$("#excelForm").append("<input type='hidden' name='fileName' value='" + fileName + "' />");
	$("#excelForm").submit();
}
function downloadGradeXlsx(grade) {
	var url = "gradeExport.do?grade1=" + grade + "&" + $("#grade1formArea").serialize();
	var expAnchor = $('<a class="exp_anchor" href="'+url+'"></a>');
	$("body").append(expAnchor);
	$('a.exp_anchor').bind('click',function(){
		doBeforeGridLoad();
		$.fileDownload($(this).prop('href'),{
			successCallback: function (url) {
				doOnGridLoaded();
				$('a.exp_anchor').remove();
			},
			failCallback: function (responseHtml, url) {
				doOnGridLoaded();
				$('a.exp_anchor').remove();
            }
		});
	}).trigger('click');
}
function downloadAppointmentXlsx(appointment) {
	var url = "appointmentExport.do?appointment=" + appointment;
	var expAnchor = $('<a class="exp_anchor" href="'+url+'"></a>');
	$("body").append(expAnchor);
	$('a.exp_anchor').bind('click',function(){
		doBeforeGridLoad();
		$.fileDownload($(this).prop('href'),{
			successCallback: function (url) {
				doOnGridLoaded();
				$('a.exp_anchor').remove();
			},
			failCallback: function (responseHtml, url) {
				doOnGridLoaded();
				$('a.exp_anchor').remove();
            }
		});
	}).trigger('click');
}
function downloadAppointmentSciXlsx(appointment) {
	var url = "appointmentExportBySci.do?appointment=" + appointment;
	var expAnchor = $('<a class="exp_anchor" href="'+url+'"></a>');
	$("body").append(expAnchor);
	$('a.exp_anchor').bind('click',function(){
		doBeforeGridLoad();
		$.fileDownload($(this).prop('href'),{
			successCallback: function (url) {
				doOnGridLoaded();
				$('a.exp_anchor').remove();
			},
			failCallback: function (responseHtml, url) {
				doOnGridLoaded();
				$('a.exp_anchor').remove();
            }
		});
	}).trigger('click');
}
</script>
</head>
<body>
	<div class="title_box">
		<h3><spring:message code='menu.report.integ.title'/></h3>
	</div>
	<div style="height:20px;"><spring:message code='stats.report.integ.comment1'/></div>
	<div class="contents_box">
		<!-- START 테이블 1 -->
		<div id="grade1Area">
			<form id="grade1formArea" >
				<table class="view_tbl mgb_10">
					<colgroup>
						<col />
						<col style="width: 120px;" />
						<col style="width: 50px;" />
						<col style="width: 22%;" />
						<col style="width: 22%;" />
						<col style="width: 22%;" />
						<col style="width: 50px;" />
					</colgroup>
					<tbody>
					<tr>
						<th colspan="3" style="border-right: solid 1px #ccc;text-align: center;"><spring:message code='stats.report.integ.division'/></th>
						<th style="border-right: solid 1px #ccc;text-align: center;"><spring:message code='stats.report.integ.assistant'/></th>
						<th style="border-right: solid 1px #ccc;text-align: center;"><spring:message code='stats.report.integ.associate'/></th>
						<th style="text-align: center;"><spring:message code='stats.report.integ.professor'/></th>
						<td rowspan="4" class="option_search_td" onclick="javascript:loadGradeReport();"><em>search</em></td>
					</tr>
					<c:if test="${sessionScope.auth.adminDvsCd eq 'M'}">
					<tr>
						<th colspan="3" style="border-right: solid 1px #ccc;"><spring:message code='stats.report.integ.erp.basedata'/></th>
						<td style="border-right: solid 1px #ccc;text-align: left;">
							<c:set var="isNullGrade1" value="Y" />
							<c:forEach var="vo" items="${userGradeList}" >
								<c:if test="${vo.originSe == 'ERP' and vo.grade1 == '조교수'}" >
									<input type="text" disabled="disabled" class="input2" value="${vo.sttDate }" style="width: 60px;" />
									<c:set var="isNullGrade1" value="N" />
								</c:if>
							</c:forEach>
							<c:if test="${isNullGrade1 == 'Y'}" >
								<input type="text" disabled="disabled" class="input2" value="" style="width: 60px;" />
							</c:if>
						</td>
						<td style="border-right: solid 1px #ccc;text-align: left;">
							<c:set var="isNullGrade1" value="Y" />
							<c:forEach var="vo" items="${userGradeList}" >
								<c:if test="${vo.originSe == 'ERP' and vo.grade1 == '부교수'}" >
									<input type="text" disabled="disabled" class="input2" value="${vo.sttDate }" style="width: 60px;" />
									<c:set var="isNullGrade1" value="N" />
								</c:if>
							</c:forEach>
							<c:if test="${isNullGrade1 == 'Y'}" >
								<input type="text" disabled="disabled" class="input2" value="" style="width: 60px;" />
							</c:if>
						</td>
						<td style="text-align: left;">
							<c:set var="isNullGrade1" value="Y" />
							<c:forEach var="vo" items="${userGradeList}" >
								<c:if test="${vo.originSe == 'ERP' and vo.grade1 == '교수'}" >
									<input type="text" disabled="disabled" class="input2" value="${vo.sttDate }" style="width: 60px;" />
									<c:set var="isNullGrade1" value="N" />
								</c:if>
							</c:forEach>
							<c:if test="${isNullGrade1 == 'Y'}" >
								<input type="text" disabled="disabled" class="input2" value="" style="width: 60px;" />
							</c:if>
						</td>
					</tr>
					</c:if>
					<tr>
						<th><spring:message code='stats.report.integ.erp'/></th>
						<th style="border-right: solid 1px #ccc;padding: 2px 5px;">
							<div class="list_set" style="float: left;">
								<c:if test="${sessionScope.auth.adminDvsCd eq 'M'}">
								<ul>
									<li>
										<a href="#" onclick="javascript:updateGradeDate('MNG');" class="list_icon02"><spring:message code='common.button.save.date'/></a>
									</li>
								</ul>
								</c:if>
							</div>
						</th>
						<td style="border-right: solid 1px #ccc;text-align: center;"><input type="radio" name="originSe" value="MNG" onchange="changeOriginSe();" checked="checked" /></td>
						<td class="rims_date" style="border-right: solid 1px #ccc;text-align: left;">
							<c:set var="isNullGrade1" value="Y" />
							<c:forEach var="vo" items="${userGradeList}" >
								<c:if test="${vo.originSe == 'MNG' and vo.grade1 == '조교수'}" >
									<input type="text" name="assistantSttDate" class="input2" maxlength="8" value="${vo.sttDate }" style="width: 60px;" /> ~
									<input type="text" name="assistantEndDate" class="input2" maxlength="8" value="${vo.endDate }" style="width: 60px;" />
									<c:set var="isNullGrade1" value="N" />
								</c:if>
							</c:forEach>
							<c:if test="${isNullGrade1 == 'Y'}" >
								<input type="text" name="assistantSttDate" class="input2" maxlength="8" value="" style="width: 60px;" /> ~
								<input type="text" name="assistantEndDate" class="input2" maxlength="8" value="" style="width: 60px;" />
							</c:if>
						</td>
						<td class="rims_date" style="border-right: solid 1px #ccc;text-align: left;">
							<c:set var="isNullGrade1" value="Y" />
							<c:forEach var="vo" items="${userGradeList}" >
								<c:if test="${vo.originSe == 'MNG' and vo.grade1 == '부교수'}" >
									<input type="text" name="associateSttDate" class="input2" maxlength="8" value="${vo.sttDate }" style="width: 60px;" /> ~
									<input type="text" name="associateEndDate" class="input2" maxlength="8" value="${vo.endDate }" style="width: 60px;" />
									<c:set var="isNullGrade1" value="N" />
								</c:if>
							</c:forEach>
							<c:if test="${isNullGrade1 == 'Y'}" >
								<input type="text" name="associateSttDate" class="input2" maxlength="8" value="" style="width: 60px;" /> ~
								<input type="text" name="associateEndDate" class="input2" maxlength="8" value="" style="width: 60px;" />
							</c:if>
						</td>
						<td class="rims_date" style="text-align: left;">
							<c:set var="isNullGrade1" value="Y" />
							<c:forEach var="vo" items="${userGradeList}" >
								<c:if test="${vo.originSe == 'MNG' and vo.grade1 == '교수'}" >
									<input type="text" name="professorSttDate" class="input2" maxlength="8" value="${vo.sttDate }" style="width: 60px;" /> ~
									<input type="text" name="professorEndDate" class="input2" maxlength="8" value="${vo.endDate }" style="width: 60px;" />
									<c:set var="isNullGrade1" value="N" />
								</c:if>
							</c:forEach>
							<c:if test="${isNullGrade1 == 'Y'}" >
								<input type="text" name="professorSttDate" class="input2" maxlength="8" value="" style="width: 60px;" /> ~
								<input type="text" name="professorEndDate" class="input2" maxlength="8" value="" style="width: 60px;" />
							</c:if>
						</td>
					</tr>
					<tr>
						<th><spring:message code='stats.report.integ.promote'/></th>
						<th style="border-right: solid 1px #ccc;padding: 2px 5px;">
							<div class="list_set" style="float: left;">
								<ul>
									<li><a href="#" onclick="javascript:updateGradeDate('USR');" class="list_icon02"><spring:message code='common.button.save.date'/></a></li>
								</ul>
							</div>
						</th>
						<td style="border-right: solid 1px #ccc;text-align: center;"><input type="radio" name="originSe" value="USR" onchange="changeOriginSe();" /></td>
						<td class="promote_date" style="border-right: solid 1px #ccc;text-align: left;">
							<c:set var="isNullGrade1" value="Y" />
							<c:forEach var="vo" items="${userGradeList}" >
								<c:if test="${vo.originSe == 'USR' and vo.grade1 == '조교수'}" >
									<input type="text" name="assistantSttDate" class="input2" maxlength="8" value="${vo.sttDate }" style="width: 60px;" /> ~
									<input type="text" name="assistantEndDate" class="input2" maxlength="8" value="${vo.endDate }" style="width: 60px;" />
									<c:set var="isNullGrade1" value="N" />
								</c:if>
							</c:forEach>
							<c:if test="${isNullGrade1 == 'Y'}" >
								<input type="text" name="assistantSttDate" class="input2" maxlength="8" value="" style="width: 60px;" /> ~
								<input type="text" name="assistantEndDate" class="input2" maxlength="8" value="" style="width: 60px;" />
							</c:if>
						</td>
						<td class="promote_date" style="border-right: solid 1px #ccc;text-align: left;">
							<c:set var="isNullGrade1" value="Y" />
							<c:forEach var="vo" items="${userGradeList}" >
								<c:if test="${vo.originSe == 'USR' and vo.grade1 == '부교수'}" >
									<input type="text" name="associateSttDate" class="input2" maxlength="8" value="${vo.sttDate }" style="width: 60px;" /> ~
									<input type="text" name="associateEndDate" class="input2" maxlength="8" value="${vo.endDate }" style="width: 60px;" />
									<c:set var="isNullGrade1" value="N" />
								</c:if>
							</c:forEach>
							<c:if test="${isNullGrade1 == 'Y'}" >
								<input type="text" name="associateSttDate" class="input2" maxlength="8" value="" style="width: 60px;" /> ~
								<input type="text" name="associateEndDate" class="input2" maxlength="8" value="" style="width: 60px;" />
							</c:if>
						</td>
						<td class="promote_date" style="text-align: left;">
							<c:set var="isNullGrade1" value="Y" />
							<c:forEach var="vo" items="${userGradeList}" >
								<c:if test="${vo.originSe == 'USR' and vo.grade1 == '교수'}" >
									<input type="text" name="professorSttDate" class="input2" maxlength="8" value="${vo.sttDate }" style="width: 60px;" /> ~
									<input type="text" name="professorEndDate" class="input2" maxlength="8" value="${vo.endDate }" style="width: 60px;" />
									<c:set var="isNullGrade1" value="N" />
								</c:if>
							</c:forEach>
							<c:if test="${isNullGrade1 == 'Y'}" >
								<input type="text" name="professorSttDate" class="input2" maxlength="8" value="" style="width: 60px;" /> ~
								<input type="text" name="professorEndDate" class="input2" maxlength="8" value="" style="width: 60px;" />
							</c:if>
						</td>
					</tr>
					</tbody>
				</table>
			</form>
			<div class="list_bt_area">
				<div class="list_set">
					<ul>
						<li><a href="#" onclick="downloadGradeXlsx('조교수');" class="list_icon20"><spring:message code='stats.report.integ.download.assistant'/></a></li>
						<li><a href="#" onclick="downloadGradeXlsx('부교수');" class="list_icon20"><spring:message code='stats.report.integ.download.associate'/></a></li>
						<li><a href="#" onclick="downloadGradeXlsx('교수');" class="list_icon20"><spring:message code='stats.report.integ.download.professor'/></a></li>
						<li><a href="#" onclick="downloadGradeXlsx('');" class="list_icon20"><spring:message code='stats.report.integ.download.total'/></a></li>
						<li><a href="#" onclick="downloadXlsx('grade1Layout','grade_report');" class="list_icon20"><spring:message code='common.download.table'/></a></li>
					</ul>
				</div>
			</div>
			<div id="grade1Layout" style="overflow-x: hidden;overflow-y: auto;">
				<table class="table_layout">
					<colgroup>
						<col/>
						<col/>
						<col/>
						<col style="width: 9%;"/>
						<col style="width: 9%;"/>
						<col style="width: 9%;"/>
						<col style="width: 9%;"/>
						<col style="width: 9%;"/>
						<col style="width: 9%;"/>
						<col style="width: 9%;"/>
						<col style="width: 9%;"/>
					</colgroup>
					<thead>
					<tr>
						<th colspan="3" rowspan="2" style="border-left: 0;"><spring:message code='stats.report.integ.division'/></th>
						<th colspan="2"><spring:message code='stats.report.integ.assistant'/></th>
						<th colspan="2"><spring:message code='stats.report.integ.associate'/></th>
						<th colspan="2"><spring:message code='stats.report.integ.professor'/></th>
						<th colspan="2" style="border-right: 0;"><spring:message code='stats.report.integ.total'/></th>
					</tr>
					<tr>
						<th><spring:message code='stats.report.integ.otherorg'/></th>
						<th>KAIST</th>
						<th><spring:message code='stats.report.integ.otherorg'/></th>
						<th>KAIST</th>
						<th><spring:message code='stats.report.integ.otherorg'/></th>
						<th>KAIST</th>
						<th><spring:message code='stats.report.integ.otherorg'/></th>
						<th style="border-right: 0;">KAIST</th>
					</tr>
					</thead>
					<tbody>
					<tr>
						<th rowspan="6" style="border-left: 0;"><spring:message code='stats.report.integ.intl'/></th>
						<th rowspan="3"><spring:message code='stats.report.integ.intl.sci'/></th>
						<th><spring:message code='stats.report.integ.firstauthor'/></th>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td style="border-right: 0;"></td>
					</tr>
					<tr>
						<th><spring:message code='stats.report.integ.coauthor'/></th>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td style="border-right: 0;"></td>
					</tr>
					<tr>
						<th><spring:message code='stats.report.integ.sum'/></th>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
					</tr>
					<tr>
						<th rowspan="3"><spring:message code='stats.report.integ.intl.other'/></th>
						<th><spring:message code='stats.report.integ.firstauthor'/></th>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td style="border-right: 0;"></td>
					</tr>
					<tr>
						<th><spring:message code='stats.report.integ.coauthor'/></th>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td style="border-right: 0;"></td>
					</tr>
					<tr class="sumTr">
						<th><spring:message code='stats.report.integ.sum'/></th>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td style="border-right: 0;"></td>
					</tr>
					<tr>
						<th colspan="2" rowspan="3" style="border-left: 0;"><spring:message code='stats.report.integ.conference.intl'/></th>
						<th><spring:message code='stats.report.integ.firstauthor'/></th>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td style="border-right: 0;"></td>
					</tr>
					<tr>
						<th><spring:message code='stats.report.integ.coauthor'/></th>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td style="border-right: 0;"></td>
					</tr>
					<tr class="sumTr">
						<th><spring:message code='stats.report.integ.sum'/></th>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td style="border-right: 0;"></td>
					</tr>
					<tr>
						<th rowspan="3" style="border-left: 0;"><spring:message code='stats.report.integ.patent'/></th>
						<th colspan="2"><spring:message code='stats.report.integ.patent.intl'/></th>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td style="border-right: 0;"></td>
					</tr>
					<tr>
						<th colspan="2"><spring:message code='stats.report.integ.patent.dmst'/></th>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td style="border-right: 0;"></td>
					</tr>
					<tr class="sumTr">
						<th colspan="2"><spring:message code='stats.report.integ.sum'/></th>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td style="border-right: 0;"></td>
					</tr>
					<tr>
						<th rowspan="3" style="border-left: 0;"><spring:message code='stats.report.integ.book'/></th>
						<th colspan="2"><spring:message code='stats.report.integ.book.intl'/></th>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td style="border-right: 0;"></td>
					</tr>
					<tr>
						<th colspan="2"><spring:message code='stats.report.integ.book.dmst'/></th>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td style="border-right: 0;"></td>
					</tr>
					<tr class="sumTr">
						<th colspan="2"><spring:message code='stats.report.integ.sum'/></th>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td style="border-right: 0;"></td>
					</tr>
					</tbody>
				</table>
			</div>
		</div>
		<div id="appointmentArea">
			<form id="appointmentFormArea" >
			</form>
			<div class="list_bt_area">
				<div class="list_set">
					<ul>
						<li><a href="#" onclick="downloadAppointmentXlsx('B');" class="list_icon20"><spring:message code='stats.report.integ.download.before'/></a></li>
						<li><a href="#" onclick="downloadAppointmentXlsx('A');" class="list_icon20"><spring:message code='stats.report.integ.download.after'/></a></li>
						<li><a href="#" onclick="downloadAppointmentXlsx('');" class="list_icon20"><spring:message code='stats.report.integ.download.total'/></a></li>
						<li><a href="#" onclick="downloadXlsx('appointmentLayout','appointment_report');" class="list_icon20"><spring:message code='common.download.table'/></a></li>
					</ul>
				</div>
			</div>
			<div id="appointmentLayout" style="overflow-x: hidden;overflow-y: auto;">
				<table class="table_layout">
					<colgroup>
						<col/>
						<col/>
						<col/>
						<col style="width: 12%;"/>
						<col style="width: 12%;"/>
						<col style="width: 12%;"/>
						<col style="width: 12%;"/>
						<col style="width: 12%;"/>
						<col style="width: 12%;"/>
					</colgroup>
					<thead>
					<tr>
						<th colspan="3" rowspan="2" style="border-left: 0;"><spring:message code='stats.report.integ.division'/></th>
						<th colspan="2"><spring:message code='stats.report.integ.before'/></th>
						<th colspan="2"><spring:message code='stats.report.integ.after'/></th>
						<th colspan="2" style="border-right: 0;"><spring:message code='stats.report.integ.total'/></th>
					</tr>
					<tr>
						<th><spring:message code='stats.report.integ.otherorg'/></th>
						<th>KAIST</th>
						<th><spring:message code='stats.report.integ.otherorg'/></th>
						<th>KAIST</th>
						<th><spring:message code='stats.report.integ.otherorg'/></th>
						<th style="border-right: 0;">KAIST</th>
					</tr>
					</thead>
					<tbody>
					<tr>
						<th rowspan="6" style="border-left: 0;"><spring:message code='stats.report.integ.intl'/></th>
						<th rowspan="3"><spring:message code='stats.report.integ.intl.sci'/></th>
						<th><spring:message code='stats.report.integ.firstauthor'/></th>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${articleByAppointment.BAPPOINTMENT2 }" /></td>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${articleByAppointment.BAPPOINTMENT1 }" /></td>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${articleByAppointment.AAPPOINTMENT2 }" /></td>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${articleByAppointment.AAPPOINTMENT1 }" /></td>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${articleByAppointment.BAPPOINTMENT2+articleByAppointment.AAPPOINTMENT2 }" /></td>
						<td style="text-align: right;padding: 0 5px;border-right: 0;"><c:out value="${articleByAppointment.BAPPOINTMENT1+articleByAppointment.AAPPOINTMENT1 }" /></td>
					</tr>
					<tr>
						<th><spring:message code='stats.report.integ.coauthor'/></th>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${articleByAppointment.BAPPOINTMENT4 }" /></td>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${articleByAppointment.BAPPOINTMENT3 }" /></td>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${articleByAppointment.AAPPOINTMENT4 }" /></td>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${articleByAppointment.AAPPOINTMENT3 }" /></td>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${articleByAppointment.BAPPOINTMENT4+articleByAppointment.AAPPOINTMENT4 }" /></td>
						<td style="text-align: right;padding: 0 5px;border-right: 0;"><c:out value="${articleByAppointment.BAPPOINTMENT3+articleByAppointment.AAPPOINTMENT3 }" /></td>
					</tr>
					<tr class="sumTr">
						<th><spring:message code='stats.report.integ.sum'/></th>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${articleByAppointment.BAPPOINTMENT2+articleByAppointment.BAPPOINTMENT4 }" /></td>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${articleByAppointment.BAPPOINTMENT1+articleByAppointment.BAPPOINTMENT3 }" /></td>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${articleByAppointment.AAPPOINTMENT2+articleByAppointment.AAPPOINTMENT4 }" /></td>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${articleByAppointment.AAPPOINTMENT1+articleByAppointment.AAPPOINTMENT3 }" /></td>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${articleByAppointment.BAPPOINTMENT2+articleByAppointment.BAPPOINTMENT4+articleByAppointment.AAPPOINTMENT2+articleByAppointment.AAPPOINTMENT4 }" /></td>
						<td style="text-align: right;padding: 0 5px;border-right: 0;"><c:out value="${articleByAppointment.BAPPOINTMENT1+articleByAppointment.BAPPOINTMENT3+articleByAppointment.AAPPOINTMENT1+articleByAppointment.AAPPOINTMENT3 }" /></td>
					</tr>
					<tr>
						<th rowspan="3"><spring:message code='stats.report.integ.intl.other'/></th>
						<th><spring:message code='stats.report.integ.firstauthor'/></th>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${articleByAppointment.BAPPOINTMENT6 }" /></td>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${articleByAppointment.BAPPOINTMENT5 }" /></td>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${articleByAppointment.AAPPOINTMENT6 }" /></td>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${articleByAppointment.AAPPOINTMENT5 }" /></td>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${articleByAppointment.BAPPOINTMENT6+articleByAppointment.AAPPOINTMENT6 }" /></td>
						<td style="text-align: right;padding: 0 5px;border-right: 0;"><c:out value="${articleByAppointment.BAPPOINTMENT5+articleByAppointment.AAPPOINTMENT5 }" /></td>
					</tr>
					<tr>
						<th><spring:message code='stats.report.integ.coauthor'/></th>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${articleByAppointment.BAPPOINTMENT8 }" /></td>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${articleByAppointment.BAPPOINTMENT7 }" /></td>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${articleByAppointment.AAPPOINTMENT8 }" /></td>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${articleByAppointment.AAPPOINTMENT7 }" /></td>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${articleByAppointment.BAPPOINTMENT8+articleByAppointment.AAPPOINTMENT8 }" /></td>
						<td style="text-align: right;padding: 0 5px;border-right: 0;"><c:out value="${articleByAppointment.BAPPOINTMENT7+articleByAppointment.AAPPOINTMENT7 }" /></td>
					</tr>
					<tr class="sumTr">
						<th><spring:message code='stats.report.integ.sum'/></th>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${articleByAppointment.BAPPOINTMENT6+articleByAppointment.BAPPOINTMENT8 }" /></td>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${articleByAppointment.BAPPOINTMENT5+articleByAppointment.BAPPOINTMENT7 }" /></td>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${articleByAppointment.AAPPOINTMENT6+articleByAppointment.AAPPOINTMENT8 }" /></td>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${articleByAppointment.AAPPOINTMENT5+articleByAppointment.AAPPOINTMENT7 }" /></td>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${articleByAppointment.BAPPOINTMENT6+articleByAppointment.BAPPOINTMENT8+articleByAppointment.AAPPOINTMENT6+articleByAppointment.AAPPOINTMENT8 }" /></td>
						<td style="text-align: right;padding: 0 5px;border-right: 0;"><c:out value="${articleByAppointment.BAPPOINTMENT5+articleByAppointment.BAPPOINTMENT7+articleByAppointment.AAPPOINTMENT5+articleByAppointment.AAPPOINTMENT7 }" /></td>
					</tr>
					<tr>
						<th colspan="2" rowspan="3" style="border-left: 0;"><spring:message code='stats.report.integ.conference.intl'/></th>
						<th><spring:message code='stats.report.integ.firstauthor'/></th>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${conferenceByAppointment.BAPPOINTMENT1 }" /></td>
						<td style="text-align: right;padding: 0 5px;"></td>
						<td style="text-align: right;padding: 0 5px;"></td>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${conferenceByAppointment.AAPPOINTMENT1 }" /></td>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${conferenceByAppointment.BAPPOINTMENT1 }" /></td>
						<td style="text-align: right;padding: 0 5px;border-right: 0;"><c:out value="${conferenceByAppointment.AAPPOINTMENT1 }" /></td>
					</tr>
					<tr>
						<th><spring:message code='stats.report.integ.coauthor'/></th>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${conferenceByAppointment.BAPPOINTMENT2 }" /></td>
						<td style="text-align: right;padding: 0 5px;"></td>
						<td style="text-align: right;padding: 0 5px;"></td>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${conferenceByAppointment.AAPPOINTMENT2 }" /></td>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${conferenceByAppointment.BAPPOINTMENT2 }" /></td>
						<td style="text-align: right;padding: 0 5px;border-right: 0;"><c:out value="${conferenceByAppointment.AAPPOINTMENT2 }" /></td>
					</tr>
					<tr class="sumTr">
						<th><spring:message code='stats.report.integ.sum'/></th>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${conferenceByAppointment.BAPPOINTMENT1+conferenceByAppointment.BAPPOINTMENT2 }" /></td>
						<td style="text-align: right;padding: 0 5px;"></td>
						<td style="text-align: right;padding: 0 5px;"></td>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${conferenceByAppointment.AAPPOINTMENT1+conferenceByAppointment.AAPPOINTMENT2 }" /></td>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${conferenceByAppointment.BAPPOINTMENT1+conferenceByAppointment.BAPPOINTMENT2 }" /></td>
						<td style="text-align: right;padding: 0 5px;border-right: 0;"><c:out value="${conferenceByAppointment.AAPPOINTMENT1+conferenceByAppointment.AAPPOINTMENT2 }" /></td>
					</tr>
					<tr>
						<th rowspan="3" style="border-left: 0;"><spring:message code='stats.report.integ.patent'/></th>
						<th colspan="2"><spring:message code='stats.report.integ.patent.intl'/></th>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${patentByAppointment.BAPPOINTMENT1 }" /></td>
						<td style="text-align: right;padding: 0 5px;"></td>
						<td style="text-align: right;padding: 0 5px;"></td>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${patentByAppointment.AAPPOINTMENT1 }" /></td>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${patentByAppointment.BAPPOINTMENT1 }" /></td>
						<td style="text-align: right;padding: 0 5px;border-right: 0;"><c:out value="${patentByAppointment.AAPPOINTMENT1 }" /></td>
					</tr>
					<tr>
						<th colspan="2"><spring:message code='stats.report.integ.patent.dmst'/></th>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${patentByAppointment.BAPPOINTMENT2 }" /></td>
						<td style="text-align: right;padding: 0 5px;"></td>
						<td style="text-align: right;padding: 0 5px;"></td>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${patentByAppointment.AAPPOINTMENT2 }" /></td>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${patentByAppointment.BAPPOINTMENT2 }" /></td>
						<td style="text-align: right;padding: 0 5px;border-right: 0;"><c:out value="${patentByAppointment.AAPPOINTMENT2 }" /></td>
					</tr>
					<tr class="sumTr">
						<th colspan="2"><spring:message code='stats.report.integ.sum'/></th>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${patentByAppointment.BAPPOINTMENT1+patentByAppointment.BAPPOINTMENT2 }" /></td>
						<td style="text-align: right;padding: 0 5px;"></td>
						<td style="text-align: right;padding: 0 5px;"></td>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${patentByAppointment.AAPPOINTMENT1+patentByAppointment.AAPPOINTMENT2 }" /></td>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${patentByAppointment.BAPPOINTMENT1+patentByAppointment.BAPPOINTMENT2 }" /></td>
						<td style="text-align: right;padding: 0 5px;border-right: 0;"><c:out value="${patentByAppointment.AAPPOINTMENT1+patentByAppointment.AAPPOINTMENT2 }" /></td>
					</tr>
					<tr>
						<th rowspan="3" style="border-left: 0;"><spring:message code='stats.report.integ.book'/></th>
						<th colspan="2"><spring:message code='stats.report.integ.book.intl'/></th>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${bookByAppointment.BAPPOINTMENT1 }" /></td>
						<td style="text-align: right;padding: 0 5px;"></td>
						<td style="text-align: right;padding: 0 5px;"></td>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${bookByAppointment.AAPPOINTMENT1 }" /></td>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${bookByAppointment.BAPPOINTMENT1 }" /></td>
						<td style="text-align: right;padding: 0 5px;border-right: 0;"><c:out value="${bookByAppointment.AAPPOINTMENT1 }" /></td>
					</tr>
					<tr>
						<th colspan="2"><spring:message code='stats.report.integ.book.dmst'/></th>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${bookByAppointment.BAPPOINTMENT2 }" /></td>
						<td style="text-align: right;padding: 0 5px;"></td>
						<td style="text-align: right;padding: 0 5px;"></td>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${bookByAppointment.AAPPOINTMENT2 }" /></td>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${bookByAppointment.BAPPOINTMENT2 }" /></td>
						<td style="text-align: right;padding: 0 5px;border-right: 0;"><c:out value="${bookByAppointment.AAPPOINTMENT2 }" /></td>
					</tr>
					<tr class="sumTr">
						<th colspan="2"><spring:message code='stats.report.integ.sum'/></th>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${bookByAppointment.BAPPOINTMENT1+bookByAppointment.BAPPOINTMENT2 }" /></td>
						<td style="text-align: right;padding: 0 5px;"></td>
						<td style="text-align: right;padding: 0 5px;"></td>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${bookByAppointment.AAPPOINTMENT1+bookByAppointment.AAPPOINTMENT2 }" /></td>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${bookByAppointment.BAPPOINTMENT1+bookByAppointment.BAPPOINTMENT2 }" /></td>
						<td style="text-align: right;padding: 0 5px;border-right: 0;"><c:out value="${bookByAppointment.AAPPOINTMENT1+bookByAppointment.AAPPOINTMENT2 }" /></td>
					</tr>
					</tbody>
				</table>
			</div>
		</div>
		<div id="appointmentSciArea">
			<form id="appointmentSciFormArea" >
			</form>
			<div class="list_bt_area">
				<div class="list_set">
					<ul>
						<li><a href="#" onclick="downloadAppointmentSciXlsx('B');" class="list_icon20"><spring:message code='stats.report.integ.download.before'/></a></li>
						<li><a href="#" onclick="downloadAppointmentSciXlsx('A');" class="list_icon20"><spring:message code='stats.report.integ.download.after'/></a></li>
						<li><a href="#" onclick="downloadAppointmentSciXlsx('');" class="list_icon20"><spring:message code='stats.report.integ.download.total'/></a></li>
						<li><a href="#" onclick="downloadXlsx('appointmentSciLayout','appointment_report');" class="list_icon20"><spring:message code='common.download.table'/></a></li>
					</ul>
				</div>
			</div>
			<div id="appointmentSciLayout" style="overflow-x: hidden;overflow-y: auto;">
				<table class="table_layout">
					<colgroup>
						<col/>
						<col style="width: 13%;"/>
						<col style="width: 13%;"/>
						<col style="width: 13%;"/>
						<col style="width: 13%;"/>
						<col style="width: 13%;"/>
						<col style="width: 13%;"/>
					</colgroup>
					<thead>
					<tr>
						<th rowspan="2" style="border-left: 0;"><spring:message code='stats.report.integ.division'/></th>
						<th colspan="3"><spring:message code='stats.report.integ.before'/></th>
						<th colspan="3" style="border-right: 0;"><spring:message code='stats.report.integ.after'/></th>
					</tr>
					<tr>
						<th><spring:message code='stats.report.integ.article.count'/></th>
						<th><spring:message code='stats.report.integ.article.if.sum'/></th>
						<th><spring:message code='stats.report.integ.article.tc.sum'/></th>
						<th><spring:message code='stats.report.integ.article.count'/></th>
						<th><spring:message code='stats.report.integ.article.if.sum'/></th>
						<th style="border-right: 0;"><spring:message code='stats.report.integ.article.tc.sum'/></th>
					</tr>
					</thead>
					<tbody>
					<tr>
						<th style="border-left: 0;"><spring:message code='stats.report.integ.article.firstauthor'/></th>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${sciArticleByAppointment.BAPPOINTMENT1 }" /></td>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${sciArticleByAppointment.BIF1 }" /></td>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${sciArticleByAppointment.BTC1 }" /></td>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${sciArticleByAppointment.AAPPOINTMENT1 }" /></td>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${sciArticleByAppointment.AIF1 }" /></td>
						<td style="text-align: right;padding: 0 5px;border-right: 0;"><c:out value="${sciArticleByAppointment.ATC1 }" /></td>
					</tr>
					<tr>
						<th style="border-left: 0;"><spring:message code='stats.report.integ.article.coauthor'/></th>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${sciArticleByAppointment.BAPPOINTMENT2 }" /></td>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${sciArticleByAppointment.BIF2 }" /></td>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${sciArticleByAppointment.BTC2 }" /></td>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${sciArticleByAppointment.AAPPOINTMENT2 }" /></td>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${sciArticleByAppointment.AIF2 }" /></td>
						<td style="text-align: right;padding: 0 5px;border-right: 0;"><c:out value="${sciArticleByAppointment.ATC2 }" /></td>
					</tr>
					<tr class="sumTr">
						<th style="border-left: 0;"><spring:message code='stats.report.integ.sum'/></th>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${sciArticleByAppointment.BAPPOINTMENT1+sciArticleByAppointment.BAPPOINTMENT2 }" /></td>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${sciArticleByAppointment.BIF1+sciArticleByAppointment.BIF2 }" /></td>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${sciArticleByAppointment.BTC1+sciArticleByAppointment.BTC2 }" /></td>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${sciArticleByAppointment.AAPPOINTMENT1+sciArticleByAppointment.AAPPOINTMENT2 }" /></td>
						<td style="text-align: right;padding: 0 5px;"><c:out value="${sciArticleByAppointment.AIF1+sciArticleByAppointment.AIF2 }" /></td>
						<td style="text-align: right;padding: 0 5px;border-right: 0;"><c:out value="${sciArticleByAppointment.ATC1+sciArticleByAppointment.ATC2 }" /></td>
					</tr>
					<tr>
						<td colspan="7" style="border: 0;"><a href="<c:url value='/analysis/researcher/h-index.do?topNm=researcher&userId=${sessionScope.sess_user.userId }' />">H-Index (Web of Science 정보 기준으로 작성) : <c:out value="${hindex }" /></a></td>
					</tr>
					</tbody>
				</table>
			</div>
		</div>
		<!-- layout (grid,paging)  -->
		<div id="mainLayout" style="position: relative; width: 100%;height: 100%;"></div>
 	</div>
<form id="excelForm" action="<c:url value='/download/xlsx.do' />" method="post"></form>
</body>
</html>