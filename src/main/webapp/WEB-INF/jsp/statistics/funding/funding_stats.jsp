<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../pageInit.jsp" %>
<jsp:useBean id="now" class="java.util.Date" />
<fmt:formatDate value="${now}" var="thisYear" pattern="yyyy" />
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Funding Statistics</title>
<style type="text/css">
.dhxwins_vp_dhx_terrace {overflow: auto;}
.dhxwins_vp_dhx_terrace div.dhxwin_active div.dhx_cell_wins div.dhx_cell_toolbar_def, .dhxwins_vp_dhx_terrace div.dhxwin_inactive div.dhx_cell_wins div.dhx_cell_toolbar_def { padding: 10px 0px 0; }
.dhx_toolbar_dhx_terrace { padding: 0 0px; }
div.gridbox_dhx_terrace.gridbox .xhdr {border-bottom: 1px solid #ccc; border-top: 1px solid #ccc; background-color: #f5f5f5;}
div.gridbox_dhx_terrace.gridbox table.hdr td{vertical-align: middle;}
div.gridbox_dhx_terrace.gridbox table.hdr td div.hdrcell{padding-top: 4px; padding-bottom: 4px;line-height: 15px;}
</style>
<script type="text/javascript" src="${contextPath}/js/jquery/jquery.filedownload.js"></script>
<script type="text/javascript" src="${contextPath}/js/mainLayout.js"></script>
<script type="text/javascript">
var dhxLayout, myGrid, t;
$(document).ready(function(){
	setMainLayoutHeight($('#mainLayout'));
	if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
	else  window.addEventListener("resize",resizeLayout, false);
	//set layout
	dhxLayout = new dhtmlXLayoutObject("mainLayout","1C");
	dhxLayout.cells("a").hideHeader();
	dhxLayout.setSizes(false);
	myGrid = dhxLayout.cells("a").attachGrid();
	myGrid.setImagePath("${dhtmlXImagePath}");
	myGrid.setEditable(false);
//	myGrid.attachEvent("onRowSelect", myGrid_onRowSelect);
//	myGrid.attachEvent("onBeforeSorting", myGrid_onBeforeSorting);
	myGrid.attachEvent("onXLS", doBeforeGridLoad);
	myGrid.attachEvent("onXLE", doOnGridLoaded);
	myGrid.attachEvent("onRowSelect",function(id,ind){
		var param = "";
		var columnId = myGrid.getColumnId(ind);
		if (columnId == "artCnt") {
			param += "type=A&id="+id;
		} else if (columnId == "conCnt") {
			param += "type=C&id="+id;
		} else if (columnId == "patCnt") {
			param += "type=P&id="+id;
		} else if (columnId == "fundCnt") {
			param += "type=F&id="+id;
		} else {
			return;
		}
/*
		for (var i = 0; i <= 2; i++) {
			if (myGrid.getColumnId(i) == "prtcpntId") param += "prtcpntId=" + myGrid.cellById(id,i).getValue() + "&";
			if (myGrid.getColumnId(i) == "groupDept") param += "groupDept=" + myGrid.cellById(id,i).getValue() + "&";
			if (myGrid.getColumnId(i) == "pubyear") param += "pubyear=" + myGrid.cellById(id,i).getValue() + "&";
		}
		*/
		downloadListXlsx(param);
	});
//	myGrid.enableColSpan(true);
	myGrid.init();
});
function myGrid_load() {
	if ($('input[name=statsGubun]:checked').val() == "F") {
		if ($("#groupDept").val() != '' && $("#rschCmcmSttYm").val().trim() != '') {
			myGrid.clearAndLoad("${contextPath}/${preUrl}/statistics/funding/statistics.do?" + $('#formArea').serialize());
		} else {
			alert("필수항목이 누락되었습니다.");
		}
	} else if ($('input[name=statsGubun]:checked').val() == "A") {
		if ($("#groupDept").val() != '' && $("#sttDate").val().trim() != '') {
			myGrid.clearAndLoad("${contextPath}/${preUrl}/statistics/funding/statistics.do?" + $('#formArea').serialize());
		} else {
			alert("필수항목이 누락되었습니다.");
		}
	}
}

function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){setMainLayoutHeight($('#mainLayout')); dhxLayout.setSizes(false); },80);}
function doOnGridLoaded(){setTimeout(function() {dhxLayout.cells("a").progressOff();}, 100);}
function doBeforeGridLoad(){dhxLayout.cells("a").progressOn();}

function myGrid_onRowSelect(rowID,celInd){
	var wWidth = 990;
	var wHeight = 822;
	var leftPos = (screenWidth - wWidth)/2;
	var topPos = (screenHeight - wHeight)/2;
	if(rowID == '0') return;
	var str = rowID.split('_');
	var mappingPopup = window.open('about:blank', 'articlePopup', 'width='+wWidth+'px,height='+wHeight+'px,top='+topPos+',left='+leftPos+' location=no,scrollbars=yes,resizable=yes');
	var popFrm = $('#popFrm');
	popFrm.empty();
	popFrm.append($('<input type="hidden" name="articleId" value="'+str[1]+'"/>'));
	popFrm.attr('action', '${contextPath}/article/articlePopup.do');
	popFrm.attr('target', 'articlePopup');
	popFrm.attr('method', 'POST');
	popFrm.submit();
	mappingPopup.focus();
}
function changeStatsGubun() {
	if ($('input[name=statsGubun]:checked').val() == "F") {
		$('.fundingGubun').css('display', '');
		$('.fundingGubun input').attr('disabled', false);
		$('.articleGubun').css('display', 'none');
		$('.articleGubun input').attr('disabled', true);
	} else if ($('input[name=statsGubun]:checked').val() == "A") {
		$('.fundingGubun').css('display', 'none');
		$('.fundingGubun input').attr('disabled', true);
		$('.articleGubun').css('display', '');
		$('.articleGubun input').attr('disabled', false);
	}
	resizeLayout();
}
function downloadListXlsx(param) {
	var url = '${contextPath}/${preUrl}/statistics/funding/export.do?' + $('#formArea').serialize() + "&" + param;
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
		<h3><spring:message code='menu.funding.report'/></h3>
	</div>
	<div class="contents_box">
		<!-- START 테이블 1 -->
		<form id="formArea" >
			<c:if test="${not sessMode and sessionScope.auth.adminDvsCd ne 'R' and  sessionScope.auth.adminDvsCd ne 'S' }">
			<table class="view_tbl mgb_10" style="table-layout: fixed;" >
				<colgroup>
					<col style="width: 9%;" />
					<col style="width: 24%;" />
					<col style="width: 9%;" />
					<col style="width: 24%;" />
					<col style="width: 9%;" />
					<col />
					<col style="width: 50px;"/>
				</colgroup>
				<tbody>
				<tr>
					<th>통계 기준</th>
					<td colspan="5">
						<span style="float: left;"><input type="radio" id="statsGubun0" name="statsGubun" class="radio" value="F" onchange="changeStatsGubun();" checked="checked" />
						<label for="statsGubun0" class="radio_label">연구과제 기준</label></span>
						<span style="float: left;"><input type="radio" id="statsGubun1" name="statsGubun" class="radio" value="A" onchange="changeStatsGubun();" />
						<label for="statsGubun1" class="radio_label">논문 기준</label></span>
					</td>
					<td rowspan="5" class="option_search_td" onclick="javascript:myGrid_load();"><em>search</em></td>
				</tr>
				<tr>
					<th>
						<c:if test="${sessionScope.auth.adminDvsCd eq 'M'}">학과 및 트랙</c:if>
						<c:if test="${sessionScope.auth.adminDvsCd eq 'D' or sessionScope.login_user.adminDvsCd eq 'C'}">학과</c:if>
						<c:if test="${sessionScope.login_user.adminDvsCd eq 'T'}">트랙</c:if>
					</th>
					<td>
						<c:if test="${sessionScope.auth.adminDvsCd ne 'M'}">
							<c:if test="${sessionScope.auth.adminDvsCd eq 'D'}">${sessionScope.auth.workTrgetNm}</c:if>
							<c:if test="${sessionScope.auth.adminDvsCd eq 'T'}">${sessionScope.auth.workTrgetNm}</c:if>
							<c:if test="${sessionScope.auth.adminDvsCd eq 'C'}">
								<select name="dept" class="select1">
									<option value="">전체</option>
									<c:forEach var="item" items="${deptList}">
										<option value="DEPT_${item.groupDept}">${item.groupDept}</option>
									</c:forEach>
								</select>
							</c:if>
						</c:if>
						<c:if test="${sessionScope.auth.adminDvsCd eq 'M'}">
							<select name="dept" class="select1">
								<option value="">전체</option>
								<optgroup label="학과(부)">
									<c:forEach var="item" items="${deptList}">
										<option value="DEPT_${item.groupDept}">${item.groupDept}</option>
									</c:forEach>
								</optgroup>
								<optgroup label="트랙">
									<c:forEach var="item" items="${trackList}">
										<option value="TRACK_${item.trackId}">${item.trackName}</option>
									</c:forEach>
								</optgroup>
							</select>
						</c:if>
					</td>
					<th>사번</th>
					<td>
						<input type="text" name="userId" class="input2" />
					</td>
					<th>성명</th>
					<td>
						<div style="padding: 3px 0;"><input type="text" name="userNm" class="input2" /></div>
						<span>* 동명이인 연구자도 검색될 수 있으니 유의하시기 바랍니다.</span>
					</td>
				</tr>
				<tr class="fundingGubun">
					<th>연구과제 관리번호</th>
					<td><input type="text" name="fundingId" class="input2" /></td>
					<th>과제번호(KAIST)</th>
					<td colspan="3"><input type="text" name="agcSbjtNo" class="input2" /></td>
				</tr>
				<tr class="fundingGubun">
					<th>연구시작년월</th>
					<td>
						<span style="float: left;"><input type="text" id="rschCmcmSttYm" name="rschCmcmSttYm" class="input2"  maxlength="6" style="width: 80px;" value="${thisYear-1 }01" />
						~ <input type="text" name="rschCmcmEndYm" class="input2" maxlength="6" style="width: 80px;" /></span>
					</td>
					<th>소관정부부처명</th>
					<td><input type="text" name="cptGovOfficNm" class="input2" /></td>
					<th>연구비지원기관</th>
					<td><input type="text" name="rsrcctSpptAgcNm" class="input2" /></td>
				</tr>
				<tr class="fundingGubun">
					<th>과제명</th>
					<td colspan="5"><input type="text" name="rschSbjtNm" class="input2" style="width: 100%;"/></td>
				</tr>
				<tr class="articleGubun" style="display: none;">
					<th>출판년도</th>
					<td colspan="5">
						<span style="float: left;"><input type="text" id="sttDate" name="sttDate" disabled="disabled" class="input2" maxlength="4" value="${thisYear-1 }" style="width: 60px;" />
						~ <input type="text" name="endDate" disabled="disabled" class="input2" maxlength="4" style="width: 60px;" /></span>
					</td>
				</tr>
				</tbody>
			</table>
			</c:if>
			<c:if test="${sessMode or (sessionScope.auth.adminDvsCd eq 'R' or  sessionScope.auth.adminDvsCd eq 'S' )}">
			<table class="view_tbl mgb_10" style="table-layout: fixed;" >
				<colgroup>
					<col style="width: 12%;" />
					<col style="width: 28%;" />
					<col style="width: 12%;" />
					<col />
					<col style="width: 50px;"/>
				</colgroup>
				<tbody>
				<tr>
					<th><spring:message code='stats.funding.target'/></th>
					<td colspan="3">
						<span style="float: left;"><input type="radio" id="statsGubun0" name="statsGubun" class="radio" value="F" onchange="changeStatsGubun();" checked="checked" />
						<label for="statsGubun0" class="radio_label"><spring:message code='stats.funding.target.funding'/></label></span>
						<span style="float: left;"><input type="radio" id="statsGubun1" name="statsGubun" class="radio" value="A" onchange="changeStatsGubun();" />
						<label for="statsGubun1" class="radio_label"><spring:message code='stats.funding.target.article'/></label></span>
					</td>
					<td rowspan="3" class="option_search_td" onclick="javascript:myGrid_load();"><em>search</em></td>
				</tr>
				<tr class="fundingGubun">
					<th><spring:message code='stats.funding.governmentministry'/></th>
					<td><input type="text" name="cptGovOfficNm" class="input2" /></td>
					<th><spring:message code='stats.funding.grantingagency'/></th>
					<td><input type="text" name="rsrcctSpptAgcNm" class="input2" /></td>
				</tr>
				<tr class="fundingGubun">
					<th><spring:message code='stats.funding.projectperiod'/></th>
					<td>
						<span style="float: left;"><input type="text" id="rschCmcmSttYm" name="rschCmcmSttYm" class="input2" maxlength="6" style="width: 80px;" value="${thisYear-1 }01" />
						~ <input type="text" name="rschCmcmEndYm" class="input2" maxlength="6" style="width: 80px;" /></span>
					</td>
					<th><spring:message code='stats.funding.projectname'/></th>
					<td><input type="text" name="rschSbjtNm" class="input2" style="width: 100%;"/></td>
				</tr>
				<tr class="articleGubun" style="display: none;">
					<th><spring:message code='stats.funding.pubyear'/></th>
					<td colspan="3">
						<span style="float: left;"><input type="text" id="sttDate" name="sttDate" disabled="disabled" class="input2" maxlength="4" style="width: 80px;" value="${thisYear-1 }" />
						~ <input type="text" name="endDate" disabled="disabled" class="input2" maxlength="4" style="width: 80px;" /></span>
					</td>
				</tr>
				</tbody>
			</table>
			</c:if>
		</form>
		<div class="list_bt_area">
			<div class="list_set">
				<ul>
					<li style="text-align: right;padding-top: 15px;"><spring:message code='stats.common.message1'/></li>
					<li class="fundingGubun"><a href="#" onclick="downloadListXlsx('type=A');" class="list_icon20"><spring:message code='common.download.data.article'/></a></li>
					<li class="fundingGubun"><a href="#" onclick="downloadListXlsx('type=C');" class="list_icon20"><spring:message code='common.download.data.conference'/></a></li>
					<li class="fundingGubun"><a href="#" onclick="downloadListXlsx('type=P');" class="list_icon20"><spring:message code='common.download.data.patent'/></a></li>
					<li class="articleGubun" style="display: none;"><a href="#" onclick="downloadListXlsx('type=F');" class="list_icon20"><spring:message code='common.download.data.funding'/></a></li>
					<li><a href="#" onclick="myGrid.toExcel('${contextPath}/servlet/xlsGenerate.do?file_name=funding_report.xls');" class="list_icon20"><spring:message code='common.download.table'/></a></li>
				</ul>
			</div>
		</div>
		<!-- layout (grid,paging)  -->
		<div id="mainLayout" style="position: relative; width: 100%;height: 100%;"></div>
	</div>
	<form name="expFrm" id="expFrm" method="post"></form>
	<div id="output"></div>
</body>
</html>