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
var dhxLayout, myGrid, t, openedPage = 1, rowNums, pageSize, pageNums, mappingPopup;;
$(document).ready(function(){
	setMainLayoutHeight($('#mainLayout'));
	if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
	else  window.addEventListener("resize",resizeLayout, false);

	//set layout
	dhxLayout = new dhtmlXLayoutObject("mainLayout","1C");
	dhxLayout.cells("a").hideHeader();
	dhxLayout.setSizes(false);

	var header = "번호,관리번호,사번,성명(한글),전시발표명,실적구분,발표년월,발표장소명,기획주관처명,승인여부,삭제여부";
	var columnIds = "no,exhibitionId,userId,korNm,orgLangXhbtAncmNm,ancmAcpsDvsCd,ancmYm,ancmPlcNm,planMngCrpNm,apprDvsCd,delDvsCd";
	var initWidths = "40,70,80,100,*,130,120,120,120,100,100";
	var colAlign = "center,center,center,left,left,center,center,left,left,center,center";
	var colTypes = "ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro";
	var colSorting = "na,str,str,str,str,str,str,str,str,str,str";

	if(sessMode == 'true' || loginAuthor == 'R' || loginAuthor == 'S')
	{
		header = "<spring:message code='grid.no'/>,<spring:message code='grid.id'/>,<spring:message code='grid.exi1'/>,<spring:message code='grid.exi2'/>,<spring:message code='grid.exi3'/>,<spring:message code='grid.exi4'/>,<spring:message code='grid.exi5'/>,<spring:message code='grid.appr.dvs'/>";
		columnIds = "no,exhibitionId,orgLangXhbtAncmNm,ancmAcpsDvsCd,ancmYm,ancmPlcNm,planMngCrpNm,apprDvsCd,delDvsCd";
		initWidths = "40,70,*,*,*,*,*,100";
		colAlign = "center,center,left,center,center,left,left,center";
		colTypes = "ro,ro,ro,ro,ro,ro,ro,ro";
		colSorting = "na,na,str,str,str,str,str,str";
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

	var url = "${contextPath}/${preUrl}/exhibition/findAdminExhibitionList.do";
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
	var wWidth = 990;
	var wHeight = 822;
	var leftPos = (screenWidth - wWidth)/2;
	var topPos = (screenHeight - wHeight)/2;
	if(rowID) {
		if(rowID == '0') return;
		var str = rowID.split('_');
		openedRowId = rowID;
		openedPage = myGrid.currentPage;
		mappingPopup = window.open('about:blank', 'exhibitionPopup', 'width='+wWidth+'px,height='+wHeight+'px,top='+topPos+',left='+leftPos+' location=no,scrollbars=yes,resizable=yes');
		var popFrm = $('#popFrm');
		popFrm.empty();
		popFrm.append($('<input type="hidden" name="exhibitionId" value="'+str[1]+'"/>'));
		popFrm.attr('action', '${contextPath}/${preUrl}/exhibition/exhibitionPopup.do');
		popFrm.attr('target', 'exhibitionPopup');
		popFrm.attr('method', 'POST');
		popFrm.submit();
		mappingPopup.focus();
	}
	else {
		mappingPopup = window.open('about:blank', 'exhibitionPopup', 'width='+wWidth+'px,height='+wHeight+'px,top='+topPos+',left='+leftPos+' location=no,scrollbars=yes,resizable=yes');
		var popFrm = $('#popFrm');
		popFrm.empty();
		popFrm.attr('action', '${contextPath}/${preUrl}/exhibition/exhibitionPopup.do');
		popFrm.attr('target', 'exhibitionPopup');
		popFrm.submit();
		mappingPopup.focus();
	}
}
function syncData(){
	var syncUrl = "${contextPath}${sysConf['sync.exhibition.uri']}";
	$.ajax({ url: syncUrl, dataType: 'json' }).done(function(data){
		dhtmlx.alert(data.msg);
	});
}
function fn_export(gubun){

	if(gubun == 'admin')
	{
		$('#exhibitionExportFrm input[name="userId"]').remove();
	}

	var url = "${contextPath}/${preUrl}/exhibition/export.do?"+$('#formArea').serialize()+'&'+$('#exhibitionExportFrm').serialize() ;
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
		<h3><spring:message code='menu.exhibition'/></h3>
	</div>
	<div class="contents_box">
		<!-- START 테이블 1 -->
		<form id="formArea" >
			<c:if test="${not sessMode and sessionScope.auth.adminDvsCd ne 'R' and  sessionScope.auth.adminDvsCd ne 'S' }">
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
						<td><input type="text" id="user_id" name="srchUserId" class="input2" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/></td>
						<th>발표년월</th>
						<td>
							<input type="text" name="sttDate" id="stt_date" class="input2"  maxlength="4" style="width: 80px;"  onKeyup="javascript:if(event.keyCode=='13')myGrid_load();" />
							~ <input type="text" name="endDate" id="end_date" class="input2" maxlength="4" style="width: 80px;" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/>
						</td>
						<td rowspan="5" class="option_search_td" onclick="javascript:myGrid_load();"><em>search</em></td>
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
						<th>전시작품번호</th>
						<td><input type="text" name="exhibitionId" id="exhibitionId" class="input2" maxlength="20" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/></td>
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
						<th>전시작품명</th>
						<td colspan="3">
							<input type="text" name="orgLangXhbtAncmNm" id="orgLangXhbtAncmNm" class="input2" style="width: 100%;" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/>
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
					<th><spring:message code="search.exi1" /></th>
					<td>
						<input type="text" id="orgLangXhbtAncmNm" name="orgLangXhbtAncmNm" class="typeText" style="width: 100%;" class="input2" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/>
					</td>
					<th><spring:message code="search.exi2" /></th>
					<td>
						<input type="text" id="stt_date" name="sttDate" class="input2"  maxlength="4" style="width: 80px;"  onKeyup="javascript:if(event.keyCode=='13')myGrid_load();" />
						~ <input type="text" id="end_date" name="endDate" class="input2" maxlength="4" style="width: 80px;" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/>
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
					<c:if test="${sessionScope.auth.EXHI gt 1 and (sessMode or (sessionScope.auth.adminDvsCd eq 'R' or  sessionScope.auth.adminDvsCd eq 'S' ))}">
					<c:if test="${not empty sysConf['sync.exhibition.uri'] and sessionScope.auth.adminDvsCd eq 'M'}">
						<li><a href="#" onclick="javascript:syncData();" class="list_icon18"><spring:message code='common.button.sync'/></a></li>
					</c:if>
					<li><a href="#" onclick="javascript:myGrid_onRowSelect();" class="list_icon12"><spring:message code='common.button.new'/></a></li>
					</c:if>
					<c:if test="${sessMode or (sessionScope.auth.adminDvsCd eq 'R' or  sessionScope.auth.adminDvsCd eq 'S' )}">
						<li><a href="#" onclick="javascript:fn_export('rsch');" class="list_icon20"><spring:message code='common.button.excel'/></a></li>
					</c:if>
	                <c:if test="${not sessMode and sessionScope.auth.adminDvsCd ne 'R' and  sessionScope.auth.adminDvsCd ne 'S'}">
						<li><a href="#" onclick="javascript:fn_export('admin');" class="list_icon20"><spring:message code='common.button.excel'/></a></li>
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
<form id="exhibitionExportFrm">
<input type="hidden" name="userId" value="${sessionScope.sess_user.userId}" />
<input type="hidden" name="exportFmt" value="excel" />
</form>
</body>
</html>