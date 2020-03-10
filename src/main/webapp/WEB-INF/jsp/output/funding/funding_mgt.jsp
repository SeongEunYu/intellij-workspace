<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.argonet.r2rims.util.LanguageUtil"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="../../pageInit.jsp" %>
<script type="text/javascript" src="${contextPath}/js/jquery/jquery.filedownload.js"></script>
<script type="text/javascript" src="${contextPath}/js/mainLayout.js"></script>
<script type="text/javascript">
var dhxLayout, myGrid, t, openedPage = 1, rowNums, pageSize, pageNums, mappingPopup;
$(document).ready(function(){
	bindModalLink();
	setMainLayoutHeight($('#mainLayout'));
	if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
	else  window.addEventListener("resize",resizeLayout, false);

	//set layout
	dhxLayout = new dhtmlXLayoutObject("mainLayout","1C");
	dhxLayout.cells("a").hideHeader();
	dhxLayout.setSizes(false);

	var header = "번호,관리번호,연구기간,연구비지원구분,연구과제명,과제번호,과제번호,연구비지원기관,승인여부,최종수정일,삭제여부,Source";
	var columnIds = "no,fundingId,rschCmcmYm,rsrcctSpptDvsCd,rschSbjtNm,sbjtNo,agcSbjtNo,rsrcctSpptAgcNm,apprDvsCd,modDate,delDvsCd,overallFlag";
	var initWidths = "40,70,120,120,*,100,100,110,75,78,60,53";
	var colAlign = "center,center,center,center,left,center,center,left,center,center,center,center";
	var colTypes = "ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro";
	var colSorting = "na,str,str,str,str,str,str,str,str,str,str,str";

	if(sessMode == 'true' || loginAuthor == 'R' || loginAuthor == 'S')
	{
		header = "<spring:message code='grid.no'/>,<spring:message code='grid.id'/>,<spring:message code='grid.fun1'/>,<spring:message code='grid.fun2'/>,<spring:message code='grid.fun3'/>,<spring:message code='grid.fun4'/>,<spring:message code='grid.fun5'/>,Source";
		columnIds = "no,fundingId,rschCmcmYm,rsrcctSpptDvsCd,rschSbjtNm,rsrcctSpptAgcNm,total,overallFlag";
		initWidths = "40,70,120,120,*,125,120,53";
		colAlign = "center,center,center,center,left,left,right,center";
		colTypes = "ro,ro,ro,ro,ro,ro,ro,ro";
		colSorting = "na,na,str,str,str,str,na,str";
	}

	myGrid = dhxLayout.cells("a").attachGrid();
	myGrid.setImagePath("${dhtmlXImagePath}");
	myGrid.setHeader(header,null,grid_head_center_bold);
	myGrid.setColumnIds(columnIds);
	myGrid.setInitWidths(initWidths);
	myGrid.setColAlign(colAlign);
	myGrid.setColTypes(colTypes);
	myGrid.setColSorting(colSorting);
	myGrid.attachEvent("onRowSelect", myGrid_onRowSelect);
	myGrid.attachEvent("onBeforeSorting", myGrid_onBeforeSorting);
	myGrid.attachEvent("onXLS", doBeforeGridLoad);
	myGrid.attachEvent("onXLE", doOnGridLoaded);
	myGrid.enablePaging(true,100,10,"pagingArea",true);
	myGrid.setPagingSkin("${dhtmlXPagingSkin}");
	myGrid.enableMultiselect(true);
	myGrid.enableColSpan(true);
	myGrid.init();
	myGrid_load();

});
function myGrid_load(){
	var url = getGridRequestURL();
	myGrid.clearAndLoad(url, function(){
		rowNums = myGrid.getRowsNum(); pageSize = myGrid.rowsBufferOutSize; pageNums = parseInt(rowNums/pageSize) + 1
		if(openedPage != myGrid.currentPage){
			myGrid.changePage(openedPage);
			myGrid.selectRow(myGrid.getRowIndex(openedRowId),false,false,true);
		}
	});
}

function myGrid_onBeforeSorting(ind,type,direct){
	var url = getGridRequestURL();
	myGrid.clearAndLoad(url+"&orderby="+(myGrid.getColumnId(ind))+"&direct="+direct);
	myGrid.setSortImgState(true,ind,direct);
	return false;
}

function getGridRequestURL(){

	if($('#adminSrchDeptTrack').length)
	{
		var val = $('#adminSrchDeptTrack').val();
		if(val != null && val != '')
		{
			if(val.indexOf('DEPT_') != -1 ){
				$('#adminSrchDeptKor').val(val.replace('DEPT_',''));
				$('#adminSrchTrack').val('');
			}
			if(val.indexOf('TRACK_') != -1 ){
				$('#adminSrchDeptKor').val('');
				$('#adminSrchTrack').val(val.replace('TRACK_',''));
			}
		}
		else
		{
			$('#adminSrchDeptKor').val('');
			$('#adminSrchTrack').val('');
		}
	}

	var url = "${contextPath}/${preUrl}/funding/findAdminFundingList.do";
	url = comAppendQueryString(url,"appr",	'<c:out value="${param.appr}"/>');
	url += "&"  + $('#formArea').serialize();
	return url;
}

function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){ setMainLayoutHeight($('#mainLayout')); dhxLayout.setSizes(false); },10);}
function doOnGridLoaded(){setTimeout(function() {dhxLayout.cells("a").progressOff();}, 100);}
function doBeforeGridLoad(){dhxLayout.cells("a").progressOn();}

function prevRow(){
	var prevId = myGrid.getRowIndex(myGrid.getRowId(myGrid.getRowIndex(openedRowId) - 1));
	if(prevId != -1)
	{
		if(prevId % pageSize == 0){
			if(myGrid.currentPage > 1) myGrid.changePage(myGrid.currentPage - 1);
		}
		myGrid.clearSelection();
		myGrid.selectRow(prevId,true,true,true);
	}
	else
	{
		mappingPopup.alertFirstRow();
	}
}

function nextRow(){
	var nextId = myGrid.getRowIndex(myGrid.getRowId(myGrid.getRowIndex(openedRowId) + 1));
	if(nextId != -1)
	{
		if((nextId+1) % pageSize == 0){
			if(myGrid.currentPage < pageNums) myGrid.changePage(myGrid.currentPage + 1);
		}
		myGrid.clearSelection();
		myGrid.selectRow(nextId,true,true,true);
	}
	else
	{
		mappingPopup.alertLastRow();
	}
}

function myGrid_onRowSelect(rowID,celInd){
	if(rowID == '0') return;
	var wWidth = 990;
	var wHeight = 822;
	var leftPos = (screenWidth - wWidth)/2;
	var topPos = (screenHeight - wHeight)/2;
	var str = rowID.split('_');
	openedRowId = rowID;
	openedPage = myGrid.currentPage;
	mappingPopup = window.open('about:blank', 'fundingPopup', 'width='+wWidth+'px,height='+wHeight+'px,top='+topPos+',left='+leftPos+' location=no,scrollbars=yes,resizable=yes');
	var popFrm = $('#popFrm');
	popFrm.empty();
	popFrm.append($('<input type="hidden" name="fundingId" value="'+str[1]+'"/>'));
	popFrm.append($('<input type="hidden" name="item_id" value="'+str[1]+'"/>'));
	popFrm.attr('action', '${contextPath}/${preUrl}/funding/fundingPopup.do');
	popFrm.attr('target', 'fundingPopup');
	popFrm.attr('method', 'POST');
	popFrm.submit();
	mappingPopup.focus();
}

function fn_new(){
	var wWidth = 990;
	var wHeight = 822;
	var leftPos = (screenWidth - wWidth)/2;
	var topPos = (screenHeight - wHeight)/2;
	mappingPopup = window.open('about:blank', 'fundingNewPopup', 'width='+wWidth+'px,height='+wHeight+'px,top='+topPos+',left='+leftPos+' location=no,scrollbars=yes,resizable=yes');
	var popFrm = $('#popFrm');
	popFrm.empty();
	popFrm.attr('action', '${contextPath}/${preUrl}/funding/fundingPopup.do');
	popFrm.attr('target', 'fundingNewPopup');
	popFrm.attr('method', 'POST');
	popFrm.submit();
	mappingPopup.focus();
}
function fn_export(){
	$('#fundingExportDialog #closeBtn').triggerHandler('click');
    <c:if test="${sessMode or (sessionScope.auth.adminDvsCd eq 'R' or  sessionScope.auth.adminDvsCd eq 'S' )}">
	var url = "${contextPath}/${preUrl}/funding/export.do?"+$('#formArea').serialize()+'&'+$('#fundingExportFrm').serialize() ;
	</c:if>
    <c:if test="${not sessMode and sessionScope.auth.adminDvsCd ne 'R' and  sessionScope.auth.adminDvsCd ne 'S'}">
    var url = "${contextPath}/${preUrl}/funding/export.do?"+$('#formArea').serialize();
	</c:if>
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
		<h3><spring:message code='menu.funding'/></h3>
	</div>
	<div class="contents_box">
		<!-- START 테이블 1 -->
		<form id="formArea" >
			<c:if test="${not sessMode and sessionScope.auth.adminDvsCd ne 'R' and  sessionScope.auth.adminDvsCd ne 'S' }">
				<input type="hidden" name="exportFmt" value="excel"/>
				<table class="view_tbl mgb_10" >
				<colgroup>
					<col style="width: 15%;"/>
					<col style="width: 37%;"/>
					<col style="width: 15%;"/>
					<col />
					<col style="width: 50px;"/>
				</colgroup>
				<tbody>
					<tr>
						<th>사번</th>
						<td><input type="text" id="userId" name="srchUserId" class="input2" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/></td>
						<th>연구시작년월</th>
						<td>
							<input type="text" name="sttDate" id="stt_date" class="input2"  maxlength="6" style="width: 80px;"  onKeyup="javascript:if(event.keyCode=='13')myGrid_load();" />
							~ <input type="text" name="endDate" id="end_date" class="input2" maxlength="6" style="width: 80px;" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/>
						</td>
						<td rowspan="7" class="option_search_td" onclick="javascript:myGrid_load();"><em>search</em></td>
					</tr>
					<tr>
						<th>성명</th>
						<td><input type="text" name="userNm" id="nm" class="input2" maxlength="20" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/></td>
						<th>
							<c:if test="${sessionScope.auth.adminDvsCd eq 'M'}">학과 및 트랙</c:if>
							<c:if test="${sessionScope.auth.adminDvsCd eq 'D' or sessionScope.login_user.adminDvsCd eq 'C'}">학과</c:if>
							<c:if test="${sessionScope.login_user.adminDvsCd eq 'T'}">트랙</c:if>
						</th>
						<td>
							<c:if test="${sessionScope.auth.adminDvsCd ne 'M'}">
								<c:if test="${sessionScope.auth.adminDvsCd eq 'D'}">
									<input type="hidden" name="srchDeptKor" value="${sessionScope.auth.workTrgetNm}" />
									${sessionScope.auth.workTrgetNm}
								</c:if>
								<c:if test="${sessionScope.auth.adminDvsCd eq 'T'}">
									<input type="hidden" name="trackId" value="${sessionScope.auth.workTrget}" />
									${sessionScope.auth.workTrgetNm}
								</c:if>
								<c:if test="${sessionScope.auth.adminDvsCd eq 'C'}">
									<select name="srchDeptKor" onchange="javascript:myGrid_load();" class="select_type">
										<option value="">전체</option>
										<c:forEach items="${deptList}" var="dl" varStatus="idx">
											<c:if test="${not empty dl.deptKor }">
												<option value="${fn:escapeXml(dl.deptKor)}">${fn:escapeXml(dl.deptKor)}</option>
											</c:if>
										</c:forEach>
									</select>
								</c:if>
							</c:if>
							<c:if test="${sessionScope.auth.adminDvsCd eq 'M'}">
								<select  name="adminSrchDeptTrack" id="adminSrchDeptTrack"  onchange="javascript:myGrid_load();" class="select_type" >
									<option value="">전체</option>
									<optgroup label="학과(부)">
										<c:forEach var="item" items="${deptList}">
										<option value="DEPT_${item.deptKor}">${item.deptKor}</option>
										</c:forEach>
									</optgroup>
									<optgroup label="트랙">
										<c:forEach var="item" items="${trackList}">
										<option value="TRACK_${item.trackId}">${item.trackName}</option>
										</c:forEach>
									</optgroup>
								</select>
								<input type="hidden" name="srchDeptKor"  id="adminSrchDeptKor"/>
								<input type="hidden" name="srchTrack"  id="adminSrchTrack"/>
							</c:if>
						</td>
					</tr>
					<tr>
						<th>관리번호</th>
						<td><input type="text" name="fundingId" id="fundingId" class="input2" maxlength="10" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/></td>
						<th>과제번호</th>
						<td><input type="text" name="agcSbjtNo" id="agcSbjtNo" class="input2" maxlength="10" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/></td>
					</tr>
					<tr>
						<th>소스구분</th>
						<td>
							<input type="radio" id="erp_id0" name="erpId" class="radio" value=""  checked="checked" onchange="javascript:myGrid_load();"/>
							<label for="erp_id0" class="radio_label">전체</label>
							<input type="radio" id="erp_id1" name="erpId" class="radio" value="1" onchange="javascript:myGrid_load();"/>
							<label for="erp_id1" class="radio_label">ERP 데이터</label>
							<input type="radio" id="erp_id2" name="erpId" class="radio" value="2" onchange="javascript:myGrid_load();"/>
							<label for="erp_id2" class="radio_label">직접 입력 데이터</label>
						</td>
						<th>삭제구분</th>
						<td>
							<input type="checkbox" name="isDelete" id="isDelete" value="true" onchange="javascript:myGrid_load();" class="radio"/>
								<label for="isDelete" class="radio_label">삭제된 데이터 포함</label>
						</td>
					</tr>
					<tr>
						<th>승인상태</th>
						<td colspan="3">
							<input type="radio" id="appr_dvs_cd0" name="apprDvsCd" class="radio" style="border: 0;" value="" checked="checked" onchange="javascript:myGrid_load();"/>
								<label for="appr_dvs_cd0" class="radio_label">전체</label>
							<input type="radio" id="appr_dvs_cd1" name="apprDvsCd" class="radio" style="border: 0;" value="1" onchange="javascript:myGrid_load();"/>
								<label for="appr_dvs_cd1" class="radio_label">미승인</label>
							<input type="radio" id="appr_dvs_cd2" name="apprDvsCd" class="radio" style="border: 0;" value="2" onchange="javascript:myGrid_load();"/>
								<label for="appr_dvs_cd2" class="radio_label">승인보류</label>
							<input type="radio" id="appr_dvs_cd3" name="apprDvsCd" class="radio" style="border: 0;" value="3" onchange="javascript:myGrid_load();"/>
								<label for="appr_dvs_cd3" class="radio_label">승인완료</label>
							<input type="radio" id="appr_dvs_cd4" name="apprDvsCd" class="radio" style="border: 0;" value="4" onchange="javascript:myGrid_load();"/>
								<label for="appr_dvs_cd4" class="radio_label">승인반려</label>
							<input type="radio" id="appr_dvs_cd5" name="apprDvsCd" class="radio" style="border: 0;" value="5" onchange="javascript:myGrid_load();"/>
								<label for="appr_dvs_cd5" class="radio_label">승인불가</label>
						</td>
					</tr>
					<tr>
						<th>입력구분</th>
						<td>
							<input type="radio" id="overallFlag0" name="overallFlag" class="radio" style="border: 0;" value="" checked="checked" onchange="javascript:myGrid_load();"/>
							<label for="overallFlag0" class="radio_label">전체</label>
							<input type="radio" id="overallFlag1" name="overallFlag" class="radio" style="border: 0;" value="U" onchange="javascript:myGrid_load();"/>
							<label for="overallFlag1" class="radio_label">개인</label>
							<input type="radio" id="overallFlag2" name="overallFlag" class="radio" style="border: 0;" value="T" onchange="javascript:myGrid_load();"/>
							<label for="overallFlag2" class="radio_label">ERP 총괄책임자 기준 (KRI연계)</label>
							<input type="radio" id="overallFlag3" name="overallFlag" class="radio" style="border: 0;" value="S" onchange="javascript:myGrid_load();"/>
							<label for="overallFlag3" class="radio_label">ERP Task책임자 기준 (KRI미연계)</label>
						</td>
						<th>ERP 연계 확정구분</th>
						<td>
							<input type="checkbox" id="isFixed" name="isFixed" style="border: 0;" value="Y" class="radio" onchange="javascript:myGrid_load();"/>
							<label for="isFixed" class="radio_label">ERP 연계 확정구분</label>
						</td>
					</tr>
					<tr>
						<th>연구과제명</th>
						<td colspan="3">
							<input type="text" id="rschSbjtNm" name="rschSbjtNm" class="typeText" style="width: 100%;" class="input2" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/>
						</td>
					</tr>
				</tbody>
			</table>
			</c:if>
			<c:if test="${sessMode or (sessionScope.auth.adminDvsCd eq 'R' or  sessionScope.auth.adminDvsCd eq 'S' )}">
			<table class="view_tbl mgb_10" >
				<colgroup>
					<col style="width: 15%;"/>
					<col style="width: 37%;"/>
					<col style="width: 15%;"/>
					<col />
					<col style="width: 50px;"/>
				</colgroup>
				<tbody>
				<tr>
					<th><spring:message code="search.fund1" /></th>
					<td colspan="3">
						<input type="radio" onclick="overallSearch();" id="overall_flag0" name="overallFlag" value="" onchange="javascript:myGrid_load();" />
						<label for="overall_flag0" class="radio_label"><spring:message code='overall.a'/></label>

						<input type="radio" onclick="overallSearch();" id="overall_flag2" name="overallFlag" value="T" checked="checked" onchange="javascript:myGrid_load();"/>
						<label for="overall_flag2" class="radio_label"><spring:message code='overall.t'/></label>

						<input type="radio" onclick="overallSearch();" id="overall_flag3" name="overallFlag" value="S" onchange="javascript:myGrid_load();" />
						<label for="overall_flag3" class="radio_label"><spring:message code='overall.s'/></label>

						<input type="radio" onclick="overallSearch();" id="overall_flag1" name="overallFlag" value="U" onchange="javascript:myGrid_load();" />
						<label for="overall_flag1" class="radio_label"><spring:message code='overall.u'/></label>
					</td>
					<td class="option_search_td" onclick="javascript:myGrid_load();"><em>search</em></td>
				</tr>
				</tbody>
			</table>
			</c:if>
		</form>
		<div class="list_bt_area">
			<div class="list_set">
				<ul>
					<c:if test="${sessionScope.auth.FUD gt 1 }">
					<li><a href="javascript:fn_new();" class="list_icon12"><spring:message code='common.button.new'/></a></li>
					</c:if>
					<c:if test="${sessMode or (sessionScope.auth.adminDvsCd eq 'R' or  sessionScope.auth.adminDvsCd eq 'S' )}">
						<li><a href="#fundingExportDialog" class="modalLink list_icon26">Export</a></li>
					</c:if>
	                <c:if test="${not sessMode and sessionScope.auth.adminDvsCd ne 'R' and  sessionScope.auth.adminDvsCd ne 'S'}">
						<li><a href="#" onclick="javascript:fn_export();" class="list_icon20"><spring:message code='common.button.excel'/></a></li>
					</c:if>
				</ul>
			</div>
		</div>
		<!-- layout (grid,paging)  -->
		<div id="mainLayout" style="position: relative; width: 100%;height: 100%;"></div>
		<div id="pagingObj" style="z-index: 1; height: 40px; margin-top: 5px;" >
			<div id="pagingArea" style="z-index: 1;"></div>
		</div>
	</div>
	<div id="fundingExportDialog" class="popup_box modal modal_layer" style="width: 450px;height:170px; display: none;">
	<form id="fundingExportFrm">
		<input type="hidden" name="srchUserId" value="${sessionScope.sess_user.userId}" />
		<div class="popup_header">
			<h3>Projects Export</h3>
			<a href="#" id="closeBtn" class="close_bt closeBtn">닫기</a>
		</div>
		<div class="popup_inner">
			<table class="write_tbl mgb_20">
				<colgroup>
					<col style="width:27%;" />
					<col style="width:37%;" />
					<col style="width:37%;" />
				</colgroup>
				<tbody>
					<tr>
						<th><spring:message code="exp.fmt" /></th>
						<td>
							<input type="radio" id="exportFmt_excel" name="exportFmt" value="excel" checked="checked"/>&nbsp;Excel
						</td>
						<td>
							<input type="radio" id="exportFmt_endnote" name="exportFmt" value="rtf"/>&nbsp;RTF (word)
						</td>
					</tr>
				</tbody>
			</table>
			<div class="list_set">
				<ul>
					<li><a href="javascript:fn_export();" class="list_icon25">Download</a></li>
					<li><a href="javascript:$('#fundingExportDialog #closeBtn').triggerHandler('click');" class="list_icon10">Cancel</a></li>
				</ul>
			</div>
		</div>
	</form>
	</div>
</body>
</html>