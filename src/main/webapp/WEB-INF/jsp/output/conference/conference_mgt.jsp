<%@page import="kr.co.argonet.r2rims.util.LanguageUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="../../pageInit.jsp" %>
<script type="text/javascript" src="${contextPath}/js/jquery/jquery.filedownload.js"></script>
<script type="text/javascript" src="${contextPath}/js/mainLayout.js"></script>
<script type="text/javascript">
var dhxLayout, myGrid, t, rowNums, openedPage = 1, pageSize, pageNums, mappingPopup;
$(document).ready(function(){
	bindModalLink();
	setMainLayoutHeight($('#mainLayout'));
	if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
	else  window.addEventListener("resize",resizeLayout, false);
	//set layout
	dhxLayout = new dhtmlXLayoutObject("mainLayout","1C");
	dhxLayout.cells("a").hideHeader();
	dhxLayout.setSizes(false);

	var header = "번호,관리번호,발표일자,논문명,학술대회명,승인여부,최종수정일,삭제여부";
	var colids = "No,conferenceId,ancmDate,orgLangPprNm,cfrcNm,apprDvsCd,modDate,delDvsCd";
	var widths = "50,50,80,*,250,80,90,90";
	var colalign = "center,center,center,left,left,center,center,center";
	var coltypes = "ro,ro,ro,ro,ro,ro,ro,ro";
	var colsorting = "na,int,str,str,str,str,str,str";

	if(sessMode == 'true' || loginAuthor == 'R' || loginAuthor == 'S')
	{
		header = "<spring:message code='grid.no'/>,<spring:message code='grid.id'/>,<spring:message code='grid.con6'/>,<spring:message code='grid.con5'/>,<spring:message code='grid.con2'/>,<spring:message code='grid.con3'/>,<spring:message code='grid.con4'/>,<spring:message code='grid.con.reprsnt'/>,<spring:message code='grid.appr.dvs'/>";
		colids = "No,conferenceId,scjnlDvsCd,pblcNtnCd,cfrcNm,orgLangPprNm,ancmDate,isReprsntConference,apprDvsCd";
		widths = "50,50,50,100,250,*,150,100,100";
		colalign = "center,center,center,center,left,left,center,center,center";
		coltypes = "ro,ro,ro,ro,ro,ro,ro,ro,ro";
		colsorting = "na,na,str,str,str,str,str,str,str";
	}

	//attach myGrid
	myGrid = dhxLayout.cells("a").attachGrid();
	myGrid.setImagePath("${dhtmlXImagePath}");
	myGrid.setHeader(header,null,grid_head_center_bold);
	myGrid.setColumnIds(colids);
	myGrid.setInitWidths(widths);
	myGrid.setColAlign(colalign);
	myGrid.setColTypes(coltypes);
	myGrid.setColSorting(colsorting);
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

	var url = "${contextPath}/${preUrl}/conference/findConferenceList.do";
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
	//alert(rowID);
	var wWidth = 1024;
	var wHeight = 822;
	var leftPos = (screenWidth - wWidth)/2;
	var topPos = (screenHeight - wHeight)/2;
	var str = rowID.split('_');
	openedRowId = rowID;
	openedPage = myGrid.currentPage;
	mappingPopup = window.open('about:blank', 'conferencePopup', 'width='+wWidth+'px,height='+wHeight+'px,top='+topPos+',left='+leftPos+' location=no,scrollbars=yes,resizable=yes');
	var popFrm = $('#popFrm');
	popFrm.empty();
	popFrm.append($('<input type="hidden" name="conferenceId" value="'+str[1]+'"/>'));
	popFrm.attr('action', '${contextPath}/${preUrl}/conference/conferencePopup.do');
	popFrm.attr('target', 'conferencePopup');
	popFrm.attr('method', 'POST');
	popFrm.submit();
	mappingPopup.focus();
}

function fn_new(){
	var wWidth = 1024;
	var wHeight = 822;
	var leftPos = (screenWidth - wWidth)/2;
	var topPos = (screenHeight - wHeight)/2;
	mappingPopup = window.open('about:blank', 'conferenceNewPopup', 'width='+wWidth+'px,height='+wHeight+'px,top='+topPos+',left='+leftPos+' location=no,scrollbars=yes,resizable=yes');
	var popFrm = $('#popFrm');
	popFrm.empty();
	popFrm.attr('action', '${contextPath}/${preUrl}/conference/conferencePopup.do');
	popFrm.attr('target', 'conferenceNewPopup');
	popFrm.attr('method', 'POST');
	popFrm.submit();
	mappingPopup.focus();
}

function fn_export(){
	$('#conferenceExportDialog #closeBtn').triggerHandler('click');
	var url = "${contextPath}/${preUrl}/conference/export.do?"+$('#formArea').serialize()+'&'+$('#conferenceExportFrm').serialize() ;
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
function fn_expFmtClick(rdo){
	var value = $(rdo).val();
	if(value == 'excel')
	{
		$('#conferenceExportDialog input:checkbox').prop('disabled', false);
		$('input:radio[name="expInfo"]').prop('disabled', false);
		$('#expInfo_sumry').prop('checked',true).trigger('click');
	}
	else
	{
		$('#conferenceExportDialog input:checkbox').prop('disabled', true);
		$('input:radio[name="expInfo"]').prop('checked',false).prop('disabled', true);
		$('.chk_item').prop('checked',false);
	}
}
</script>
</head>
<body>
	<div class="title_box">
		<h3><spring:message code='menu.conference'/></h3>
	</div>
	<div class="contents_box">
		<!-- START 테이블 1 -->
		<form id="formArea" >
			<c:if test="${not sessMode and sessionScope.auth.adminDvsCd ne 'R' and  sessionScope.auth.adminDvsCd ne 'S' }">
			<table class="view_tbl mgb_10" >
				<colgroup>
					<col style="width: 15%;"/>
					<col style="width: 35%;"/>
					<col style="width: 15%;"/>
					<col />
					<col style="width: 50px;"/>
				</colgroup>
				<tbody>
				<tr>
					<th>사번</th>
					<td><input type="text" id="srchUserId" name="srchUserId" class="input2" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/></td>
					<th>발표년도</th>
					<td>
						<input type="text" name="sttDate" id="sttDate" class="input2"  maxlength="4" style="width: 80px;"  onKeyup="javascript:if(event.keyCode=='13')myGrid_load();" />
						~ <input type="text" name="endDate" id="end_date" class="input2" maxlength="4" style="width: 80px;" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/>
					</td>
					<td rowspan="6" class="option_search_td" onclick="javascript:myGrid_load();"><em>search</em></td>
				</tr>
				<tr>
					<th>성명</th>
					<td><input type="text" name="userNm" id="nm" class="input2" maxlength="10" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/></td>
					<th>
						<c:if test="${sessionScope.auth.adminDvsCd eq 'M'}">학과 및 트랙</c:if>
						<c:if test="${sessionScope.auth.adminDvsCd eq 'D' or sessionScope.login_user.adminDvsCd eq 'C'}">학과</c:if>
						<c:if test="${sessionScope.login_user.adminDvsCd eq 'T'}">트랙</c:if>
					</th>
					<td>
						<c:if test="${sessionScope.login_user.adminDvsCd ne 'M'}">
							<c:if test="${sessionScope.auth.adminDvsCd eq 'D'}">
								<input type="hidden" name="srchDeptKor" value="${sessionScope.auth.workTrgetNm}" />
								<input type="hidden" name="srchDept" value="${sessionScope.auth.workTrget}" />
								${sessionScope.auth.workTrgetNm}
							</c:if>
							<c:if test="${sessionScope.auth.adminDvsCd eq 'T'}">
								<input type="hidden" name="srchTrack" value="${sessionScope.auth.workTrget}" />
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
					<th>대상구분</th>
					<td colspan="3">
						<input type="radio" id="trgetSe_all" name="trgetSe"  value=""  checked="checked" onchange="javascript:myGrid_load();" class="radio"/>
							<label for="trgetSe_all" class="radio_label">전체</label>
						<input type="radio" id="trgetSe_mgt" name="trgetSe"  value="M" onchange="javascript:myGrid_load();" class="radio"/>
							<label for="trgetSe_mgt" class="radio_label">관리대상자(전임직 교원)</label>
						<input type="radio" id="trgetSe_not_mgt" name="trgetSe"  value="U" onchange="javascript:myGrid_load();" class="radio"/>
							<label for="trgetSe_not_mgt" class="radio_label">미관리대상</label>
						<input type="radio" id="trgetSe_student" name="trgetSe"  value="S" onchange="javascript:myGrid_load();" class="radio"/>
							<label for="trgetSe_student" class="radio_label">학생</label>
						<input type="radio" id="trgetSe_etc" name="trgetSe"  value="E" onchange="javascript:myGrid_load();" class="radio"/>
							<label for="trgetSe_etc" class="radio_label">기타</label>
					</td>
				</tr>
				<tr>
					<th>관리번호</th>
					<td><input type="text" name="conferenceId" id="conferenceId" class="input2" maxlength="15" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/></td>
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
					<th>발표논문명</th>
					<td colspan="3">
						<input type="text" id="org_lang_ppr_nm" name="orgLangPprNm" class="typeText" style="width: 100%;" class="input2" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/>
					</td>
				</tr>
				</tbody>
			</table>
			</c:if>
			<c:if test="${sessMode or (sessionScope.auth.adminDvsCd eq 'R' or  sessionScope.auth.adminDvsCd eq 'S')}">
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
					<th><spring:message code='search.con1'/></th>
					<td>
						<input type="text" id="orgLangPprNm" name="orgLangPprNm" class="typeText" style="width: 100%;" class="input2" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/>
					</td>
					<th><spring:message code='search.con3'/></th>
					<td>
						<input type="text" id="stt_date" name="sttDate" class="input2"  maxlength="4" style="width: 80px;"  onKeyup="javascript:if(event.keyCode=='13')myGrid_load();" />
						~ <input type="text" id="end_date" name="endDate" class="input2" maxlength="4" style="width: 80px;" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/>
					</td>
					<td rowspan="2" class="option_search_td" onclick="javascript:myGrid_load();"><em>search</em></td>
				</tr>
				<tr>
					<th><spring:message code='search.con4'/></th>
					<td colspan="3">
						<input type="radio" id="appr_dvs_cd0" name="scjnlDvsCd" class="radio" style="border: 0;" value="" checked="checked" onchange="javascript:myGrid_load();"/>
							<label for="appr_dvs_cd0" class="radio_label"><spring:message code='search.con6'/></label>
						<input type="radio" id="appr_dvs_cd1" name="scjnlDvsCd" class="radio" style="border: 0;" value="2" onchange="javascript:myGrid_load();"/>
							<label for="appr_dvs_cd1" class="radio_label"><spring:message code='search.con7'/></label>
						<input type="radio" id="appr_dvs_cd2" name="scjnlDvsCd" class="radio" style="border: 0;" value="1" onchange="javascript:myGrid_load();"/>
							<label for="appr_dvs_cd2" class="radio_label"><spring:message code='search.con8'/></label>
					</td>
				</tr>
				</tbody>
			</table>
			</c:if>
		</form>
		<div class="list_bt_area">
			<div class="list_set">
				<ul>
					<c:if test="${sessionScope.auth.CON gt 1 }">
						<li><a href="javascript:fn_new();" class="list_icon12"><spring:message code='common.button.new'/></a></li>
					</c:if>
					<c:if test="${sessMode or (sessionScope.auth.adminDvsCd eq 'R' or  sessionScope.auth.adminDvsCd eq 'S' )}">
						<li><a href="#conferenceExportDialog" class="modalLink list_icon26">Export</a></li>
					</c:if>
					<li><a href="<c:url value='/${preUrl}/statistics/conference/conference.do'/>" class="list_icon14"><spring:message code='common.button.stats'/></a></li>
					<%--
					<li><a href="#" onclick="javascript:toExcel();" class="list_icon20"><spring:message code='common.button.excel'/></a></li>
					 --%>
				</ul>
			</div>
		</div>
		<!-- layout (grid,paging)  -->
		<div id="mainLayout" style="position: relative; width: 100%;height: 100%;"></div>
		<div id="pagingObj" style="z-index: 1; height: 60px; margin-top: 5px;" >
			<div id="pagingArea" style="z-index: 1;"></div>
		</div>
 	</div>
<form id="findItem" action="${contextPath}/article/article.do" method="post" target="item">
  <input type="hidden" id=userId name="srchUserId" value=""/>
  <input type="hidden" id="item_id" name="item_id" value=""/>
</form>
<c:if test="${sessMode or (sessionScope.auth.adminDvsCd eq 'R' or  sessionScope.auth.adminDvsCd eq 'S' )}">
	<div id="conferenceExportDialog" class="popup_box modal modal_layer" style="width: 450px;height:380px; display: none;">
	<form id="conferenceExportFrm">
		<input type="hidden" name="userId" value="${sessionScope.sess_user.userId}" />
		<div class="popup_header">
			<h3>Conference Export</h3>
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
							<input type="radio" id="exportFmt_excel" name="exportFmt" value="excel" checked="checked" onclick="fn_expFmtClick($(this))"/>&nbsp;Excel
							<br/><br/>
							<input type="radio" id="exportFmt_endnote" name="exportFmt" value="endnote" onclick="fn_expFmtClick($(this))"/>&nbsp;EndNote
						</td>
						<td style="vertical-align: top;">
							<input type="radio" id="exportFmt_endnote" name="exportFmt" value="rtf" onclick="fn_expFmtClick($(this))"/>&nbsp;RTF (word)
						</td>
					</tr>
					<tr>
						<th rowspan="2"><spring:message code="exp.info" /></th>
						<td>
							<input type="radio" id="expInfo_sumry" name="expInfo" value="dtl" checked="checked" onclick="javascript:$('.chk_item').prop('checked',false);$('.detail').prop('disabled',true);$('.sumry').prop('checked',true);" />&nbsp;<spring:message code="exp.dtl" />
						</td>
						<td style="vertical-align: top;">
							<input type="radio" id="expInfo_detail" name="expInfo" value="all" onclick="javascript:$('.detail').prop('disabled',false);$('.chk_item').prop('checked',true);"/>&nbsp;<spring:message code="exp.more" />
						</td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" id="resume_art" name="articleTitle" value="Y" class="chk_item sumry" readonly="readonly" checked="checked"/>&nbsp;Title
							<br/><br/>
							<input type="checkbox" id="resume_art" name="confTitle" value="Y" class="chk_item sumry" readonly="readonly" checked="checked"/>&nbsp;Conf.Title
							<br/><br/>
							<input type="checkbox" id="resume_art" name="pubDate" value="Y" class="chk_item sumry" readonly="readonly" checked="checked"/>&nbsp;Year
							<br/><br/>
							<input type="checkbox" id="resume_art" name="organization" value="Y" class="chk_item detail" readonly="readonly" disabled="disabled"/>&nbsp;Oragnization
							<br/><br/>
							<input type="checkbox" id="resume_art" name="abstCntn" value="Y" class="chk_item detail" readonly="readonly" disabled="disabled"/>&nbsp;Abstract
						</td>
						<td style="vertical-align: top;">
							<input type="checkbox" id="resume_art" name="authors" value="Y" class="chk_item sumry" readonly="readonly" checked="checked"/>&nbsp;Author(s)
							<br/><br/>
							<input type="checkbox" id="resume_art" name="country" value="Y" class="chk_item sumry" readonly="readonly" checked="checked"/>&nbsp;Country
							<br/><br/>
							<input type="checkbox" id="resume_art" name="category" value="Y" class="chk_item detail" readonly="readonly" disabled="disabled"/>&nbsp;Category
							<br/><br/>
							<input type="checkbox" id="resume_art" name="role" value="Y" class="chk_item detail" readonly="readonly" disabled="disabled"/>&nbsp;Role
							<br/><br/>
							<input type="checkbox" id="resume_art" name="numofauthors" value="Y" class="chk_item detail" readonly="readonly" disabled="disabled"/>&nbsp;No. of Authors
						</td>
					</tr>
				</tbody>
			</table>
			<div class="list_set">
				<ul>
					<li><a href="javascript:fn_export();" class="list_icon25">Download</a></li>
					<li><a href="javascript:$('#conferenceExportDialog #closeBtn').triggerHandler('click');" class="list_icon10">Cancel</a></li>
				</ul>
			</div>
		</div>
	</form>
	</div>
</c:if>
</body>
</html>