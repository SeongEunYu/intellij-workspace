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
	bindModalLink();
	setMainLayoutHeight($('#mainLayout'));
	if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
	else  window.addEventListener("resize",resizeLayout, false);
	//set layout
	dhxLayout = new dhtmlXLayoutObject("mainLayout","1C");
	dhxLayout.cells("a").hideHeader();
	dhxLayout.setSizes(false);

    var header = "번호,관리번호,기술이전년월,이전기술명,이전기업명,승인여부,최종수정일,소스원,삭제여부";
    var columnIds = "No,techtransId,techTransrYm,techTransrNm,techTransrCorpNm,modDate,apprDvsCd,src,delDvsCd";
    var initWidths = "50,100,80,*,*,80,80,80,80";
    var colAlign = "center,center,center,left,left,center,center,center,center";
    var colTypes = "ro,ro,ro,ro,ro,ro,ro,ro,ro";
    var colSorting = "na,str,str,str,str,str,str,str,str";

    if(sessMode == 'true' || loginAuthor == 'R' || loginAuthor == 'S')
    {
        header = "<spring:message code='grid.no'/>,<spring:message code='grid.id'/>,<spring:message code='grid.tech1'/>,<spring:message code='grid.tech2'/>,<spring:message code='grid.tech3'/>,<spring:message code='grid.appr.dvs'/>";
        columnIds = "No,techtransId,techTransrYm,techTransrNm,techTransrCorpNm,apprDvsCd";
        initWidths = "50,100,*,*,*,100";
        colAlign = "center,center,center,left,left,center";
        colTypes = "ro,ro,ro,ro,ro,ro";
        colSorting = "na,na,str,str,str,str";
	}

	//attach myGrid
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

function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){ setMainLayoutHeight($('#mainLayout')); dhxLayout.setSizes(false); },10);}
function doOnGridLoaded(){setTimeout(function() {dhxLayout.cells("a").progressOff();}, 100);}
function doBeforeGridLoad(){dhxLayout.cells("a").progressOn();}
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

	return "${contextPath}/${preUrl}/techtrans/findAdminTechtransList.do?" + $('#formArea').serialize();
}

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

function myGrid_onBeforeSorting(ind, gridObj, direct) {
	var url = getGridRequestURL();
	myGrid.clearAndLoad(url+"&orderby="+(myGrid.getColumnId(ind))+"&direct="+direct);
	myGrid.setSortImgState(true,ind,direct);
	return false;
}

function doOnRowDblClicked(id) {
	var key = id.split('_');
	$('userId').value = key[0];
	$('item_id').value = key[1];
	$('findItem').submit();
}
function selectAppr(){
	str = grid.getSelectedId();
	var strList = str.split(',');
	new Ajax.Request("${contextPath}/auth/techtrans/techtransAppr.do?idList=" + str , {
		onComplete : function(response) {
			var xmlData = response.responseXML.documentElement;
			var code = xmlData.getElementsByTagName("code")[0].firstChild.nodeValue;
			var msg = xmlData.getElementsByTagName("msg")[0].firstChild.nodeValue;
			if (code == "001"){
				grid.clearAndLoad("${contextPath}/${preUrl}/techtrans/findAdminTechtransList.do?"+ $('#formArea').serialize());
				alert(msg);
			}
			else alert(msg);
		}
	});
}

function myGrid_onRowSelect(rowID,celInd){
	openedRowId = rowID;
	openedPage = myGrid.currentPage;
	var wWidth = 990;
	var wHeight = 822;
	var leftPos = (screenWidth - wWidth)/2;
	var topPos = (screenHeight - wHeight)/2;

	var str = rowID.split('_');
	mappingPopup = window.open('about:blank', 'techtransPopup', 'width='+wWidth+'px,height='+wHeight+'px,top='+topPos+',left='+leftPos+' location=no,scrollbars=yes,resizable=yes');
	var popFrm = $('#popFrm');
	popFrm.empty();
	popFrm.append($('<input type="hidden" name="techtransId" value="'+str[1]+'"/>'));
	popFrm.attr('action', '${contextPath}/${preUrl}/techtrans/techtransPopup.do');
	popFrm.attr('target', 'techtransPopup');
	popFrm.attr('method', 'POST');
	popFrm.submit();
	mappingPopup.focus();
}

function fn_new(){
	var wWidth = 990;
	var wHeight = 822;
	var leftPos = (screenWidth - wWidth)/2;
	var topPos = (screenHeight - wHeight)/2;
	mappingPopup = window.open('about:blank', 'techtransPopup', 'width='+wWidth+'px,height='+wHeight+'px,top='+topPos+',left='+leftPos+' location=no,scrollbars=yes,resizable=yes');
	var popFrm = $('#popFrm');
	popFrm.empty();
	popFrm.attr('action', '${contextPath}/${preUrl}/techtrans/techtransPopup.do');
	popFrm.attr('target', 'techtransPopup');
	popFrm.attr('method', 'POST');
	popFrm.submit();
	mappingPopup.focus();
}

function syncUrpData(){
	var syncUrl = "${contextPath}${sysConf['sync.techtrans.uri']}";
	$.ajax({ url: syncUrl, dataType: 'json' }).done(function(data){
		dhtmlx.alert(data.msg);
	});
}
function fn_export(){
	$('#techtransExportDialog #closeBtn').triggerHandler('click');
	var url = "${contextPath}/${preUrl}/techtrans/export.do?"+$('#formArea').serialize()+'&'+$('#techtransExportFrm').serialize() ;
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
		<h3><spring:message code='menu.techtrans'/></h3>
	</div>

	<div id="contents_box">

		<!-- START 테이블 1 -->
		<form id="formArea" >
		<c:if test="${not sessMode and sessionScope.auth.adminDvsCd ne 'R' and  sessionScope.auth.adminDvsCd ne 'S' }">
		<table class="view_tbl mgb_10">
			<colgroup>
				<col style="width: 13%"/>
				<col style="width: 35%"/>
				<col style="width: 13%"/>
				<col />
				<col style="width: 50px;"/>
			</colgroup>
			<tbody>
			<tr>
				<th>사번</th>
				<td>
					<input type="text" id="user_id" name="srchUserId" class="input2" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/>
				</td>
				<th>기술이전년월</th>
				<td>
					<input type="text" name="sttDate" class="input2" maxlength="6" style="width: 80px;"/> ~ <input type="text" name="endDate" class="input2" maxlength="6" style="width: 80px;"/>
				</td>
				<td rowspan="5" class="option_search_td" onclick="javascript:myGrid_load();"><em>search</em></td>
			</tr>
			<tr>
				<th >성명</th>
				<td>
					<input type="text" id="nm" name="userNm" class="input2" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/>
				</td>
				<th>
					<c:if test="${sessionScope.auth.adminDvsCd eq 'M'}">학과 및 트랙</c:if>
					<c:if test="${sessionScope.auth.adminDvsCd eq 'D' or sessionScope.login_user.adminDvsCd eq 'C'}">학과</c:if>
					<c:if test="${sessionScope.login_user.adminDvsCd eq 'T'}">트랙</c:if>
				</th>
				<td >
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
				<th>관리번호</th>
				<td>
					<input type="text" name="techtransId" id="techtransId" class="input2" maxlength="15" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/>
				</td>
				<th>계약번호</th>
				<td><input type="text" name="cntrctManageNo" class="input2" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/></td>
			</tr>
			<tr>
				<th>승인상태</th>
				<td>
					<input type="radio" id="appr_dvs_cd0" name="apprDvsCd" class="radio" value="" checked="checked"  onchange="javascript:myGrid_load();"/>
						<label for="appr_dvs_cd0" class="radio_label">전체</label>
					<input type="radio" id="appr_dvs_cd1" name="apprDvsCd" class="radio" value="1" onchange="javascript:myGrid_load();"/>
						<label for="appr_dvs_cd1" class="radio_label">미승인</label>
					<input type="radio" id="appr_dvs_cd2" name="apprDvsCd" class="radio" value="2" onchange="javascript:myGrid_load();"/>
						<label for="appr_dvs_cd2" class="radio_label">승인보류</label>
					<input type="radio" id="appr_dvs_cd3" name="apprDvsCd" class="radio" value="3" onchange="javascript:myGrid_load();"/>
						<label for="appr_dvs_cd3" class="radio_label">승인완료</label>
					<input type="radio" id="appr_dvs_cd4" name="apprDvsCd" class="radio" value="4" onchange="javascript:myGrid_load();"/>
						<label for="appr_dvs_cd4" class="radio_label">승인반려</label>
					<input type="radio" id="appr_dvs_cd5" name="apprDvsCd" class="radio" value="5" onchange="javascript:myGrid_load();"/>
						<label for="appr_dvs_cd5" class="radio_label">승인불가</label>
				</td>
				<th>삭제구분</th>
				<td>
					<input type="checkbox" name="isDelete" id="isDelete" value="true" class="radio" onchange="javascript:myGrid_load();"/>
						<label for="isDelete" class="radio_label">삭제된 데이터 포함</label>
				</td>
			</tr>
			<tr>
				<th>기술이전명</th>
				<td  colspan="3">
					<input type="text" id="techTransrNm" name="techTransrNm" class="input2" style="width: 100%" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/>
				</td>
			</tr>
			</tbody>
		</table>
		</c:if>
		<c:if test="${sessMode or (sessionScope.auth.adminDvsCd eq 'R' or  sessionScope.auth.adminDvsCd eq 'S' )}">
		<table class="view_tbl mgb_10">
			<colgroup>
				<col style="width: 13%"/>
				<col style="width: 35%"/>
				<col style="width: 13%"/>
				<col />
				<col style="width: 50px;"/>
			</colgroup>
			<tbody>
				<tr>
					<th><spring:message code='search.tech1'/></th>
					<td>
						<input type="text" id="techTransrNm" name="techTransrNm" class="input_type" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/>
					</td>
					<th><spring:message code='search.tech2'/></th>
					<td>
						<input type="text" name="sttDate" class="input_type" maxlength="6" style="width: 80px;" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/> ~ <input type="text" name="endDate" class="input_type" maxlength="6" style="width: 80px;" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/>
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
					<c:if test="${sessionScope.auth.TECH gt 1 and (sessMode or (sessionScope.auth.adminDvsCd eq 'R' or  sessionScope.auth.adminDvsCd eq 'S' ))}">
					<c:if test="${not empty sysConf['sync.techtrans.uri'] and sessionScope.auth.adminDvsCd eq 'M'}">
					<li><a href="#" onclick="javascript:syncUrpData();" class="list_icon18"><spring:message code='common.button.sync'/></a></li>
					</c:if>
					<li><a href="javascript:fn_new();" class="list_icon12"><spring:message code='common.button.new'/></a></li>
					</c:if>
					<c:if test="${sessMode or (sessionScope.auth.adminDvsCd eq 'R' or  sessionScope.auth.adminDvsCd eq 'S' )}">
						<li><a href="#techtransExportDialog" class="modalLink list_icon26">Export</a></li>
					</c:if>
	                <c:if test="${not sessMode and sessionScope.auth.adminDvsCd ne 'R' and  sessionScope.auth.adminDvsCd ne 'S'}">
						<li><a href="#" onclick="javascript:fn_export();" class="list_icon20"><spring:message code='common.button.excel'/></a></li>
					</c:if>
				</ul>
			</div>
		</div>

		<!-- layout (grid,paging)  -->
		<div id="mainLayout" style="position: relative; width: 100%;height: 100%;"></div>
		<div id="pagingObj" style="z-index: 1; height: 60px; margin-top: 5px;" >
			<div id="pagingArea" style="z-index: 1;"></div>
		</div>
	</div>
	<div id="techtransExportDialog" class="popup_box modal modal_layer" style="width: 450px;height:170px; display: none;">
	<form id="techtransExportFrm">
		<input type="hidden" name="userId" value="${sessionScope.sess_user.userId}" />
		<div class="popup_header">
			<h3>Technology Transfer Export</h3>
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
					<li><a href="javascript:$('#techtransExportDialog #closeBtn').triggerHandler('click');" class="list_icon10">Cancel</a></li>
				</ul>
			</div>
		</div>
	</form>
	</div>
</body>
</html>