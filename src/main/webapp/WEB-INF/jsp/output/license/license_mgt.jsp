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

    var header = "번호,관리번호,사번,성명(한글),자격취득년월,자격증명,자격부여기관,삭제여부,소스원";
    var columnIds = "no,licenseId,userId,korNm,qlfAcqsYm,crQfcNm,qlfGrntAgcNm,delDvsCd,src";
    var initWidths = "40,70,80,120,*,*,*,100,100";
    var colAlign = "center,center,center,center,center,left,center,center,center";
    var colTypes = "ro,ro,ro,ro,ro,ro,ro,ro,ro";
    var colSorting = "na,str,str,str,str,str,str,str,str";

	if(sessMode == 'true' || loginAuthor == 'R' || loginAuthor == 'S')
	{
	    header = "<spring:message code='grid.no'/>,<spring:message code='grid.id'/>,<spring:message code='grid.licn1'/>,<spring:message code='grid.licn2'/>,<spring:message code='grid.licn3'/>,<spring:message code='common.source'/>";
	    columnIds = "no,licenseId,qlfAcqsYm,crQfcNm,qlfGrntAgcNm,src";
	    initWidths = "40,70,90,*,250,100";
	    colAlign = "center,center,center,left,left,center";
	    colTypes = "ro,ro,ro,ro,ro,ro";
	    colSorting = "na,str,str,str,str,str";
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
	myGrid.init();
	myGrid_load();

	$('#formArea').on('submit', function() {
		return false;
	});

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

	var url = "${contextPath}/${preUrl}/license/findAdminLicenseList.do";
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

function myGrid_onRowSelect(rowID,celInd) {

	var wWidth = 990;
	var wHeight = 400;
	var leftPos = (screenWidth - wWidth)/2;
	var topPos = (screenHeight - wHeight)/2;

	if(rowID) {
		if(rowID == '0') return;
		var str = rowID.split('_');
		openedRowId = rowID;
		openedPage = myGrid.currentPage;
		mappingPopup = window.open('about:blank', 'licensePopup', 'width='+wWidth+'px,height='+wHeight+'px,top='+topPos+',left='+leftPos+' location=no,scrollbars=yes,resizable=yes');
		var popFrm = $('#popFrm');
		popFrm.empty();
		popFrm.append($('<input type="hidden" name="licenseId" value="'+str[1]+'"/>'));
		popFrm.attr('action', '${contextPath}/${preUrl}/license/licensePopup.do');
		popFrm.attr('target', 'licensePopup');
		popFrm.attr('method', 'POST');
		popFrm.submit();
		mappingPopup.focus();
	}
	else {
		mappingPopup = window.open('about:blank', 'licensePopup', 'width='+wWidth+'px,height='+wHeight+'px,top='+topPos+',left='+leftPos+' location=no,scrollbars=yes,resizable=yes');
		var popFrm = $('#popFrm');
		popFrm.empty();
		popFrm.attr('action', '${contextPath}/${preUrl}/license/licensePopup.do');
		popFrm.attr('target', 'licensePopup');
		popFrm.submit();
		mappingPopup.focus();
	}
}
function syncData(){
	var syncUrl = "${contextPath}${sysConf['sync.license.uri']}";
	$.ajax({ url: syncUrl, dataType: 'json' }).done(function(data){
		dhtmlx.alert(data.msg);
	});
}
function fn_export(){
    var url = "${contextPath}/${preUrl}/license/export.do?"+$('#formArea').serialize()+'&'+$('#licenseExportFrm').serialize() ;
    var expAnchor = $('<a class="exp_anchor" href="'+url+'"></a>');
    $("body").append(expAnchor);
    $('a.exp_anchor').bind('click',function(){
           doBeforeGridLoad();
           $.fileDownload($(this).prop('href'),{
                  successCallback: function (url) {
                        doOnGridLoaded();
                        $('a.exp_anchor').remove();
                        //$('#articleExportDialog #closeBtn').triggerHandler('click');
                  },
                  failCallback: function (responseHtml, url) {
                        doOnGridLoaded();
                        $('a.exp_anchor').remove();
                        //$('#articleExportDialog #closeBtn').triggerHandler('click');
         }
           });
    }).trigger('click');
}

</script>
</head>
<body>
	<div class="title_box">
		<h3><spring:message code='menu.license'/></h3>
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
						<th>성명</th>
						<td><input type="text" name="userNm" id="nm" class="input2" maxlength="20" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/></td>
						<td rowspan="3" class="option_search_td" onclick="javascript:myGrid_load();"><em>search</em></td>
					</tr>
					<tr>
						<th>
							<c:if test="${sessionScope.auth.adminDvsCd eq 'M'}">학과 및 트랙</c:if>
							<c:if test="${sessionScope.auth.adminDvsCd eq 'D' or sessionScope.login_user.adminDvsCd eq 'C'}">학과</c:if>
							<c:if test="${sessionScope.login_user.adminDvsCd eq 'T'}">트랙</c:if>
						</th>
						<td>
							<c:if test="${sessionScope.login_user.adminDvsCd ne 'M'}">
								<c:if test="${sessionScope.login_user.adminDvsCd eq 'D'}">
									<input type="hidden" name="srchDeptKor" value="${sessionScope.login_user.workDeptKor}" />
									${sessionScope.login_user.workDeptKor}
								</c:if>
								<c:if test="${sessionScope.login_user.adminDvsCd eq 'T'}">
									<input type="hidden" name="trackId" value="${sessionScope.login_user.workUserId}" />
									${sessionScope.login_user.workDeptKor}
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
							<c:if test="${sessionScope.login_user.adminDvsCd eq 'M'}">
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
						<th>삭제구분</th>
						<td>
							<input type="checkbox" name="isDelete" id="isDelete" value="true" onchange="javascript:myGrid_load();" class="radio"/>
							<label for="isDelete" class="radio_label">삭제된 데이터 포함</label>
						</td>
					</tr>
					<tr>
						<th>자격증명</th>
						<td colspan="3">
							<input type="text" name="crQfcNm" id="crQfcNm" class="input2" style="width: 100%;" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/>
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
					<th><spring:message code="search.licn1" /></th>
					<td colspan="3">
						<input type="text" id="crQfcNm" name="crQfcNm" class="typeText" style="width: 100%;" class="input2" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/>
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
					<c:if test="${not empty sysConf['sync.license.uri'] and sessionScope.auth.adminDvsCd eq 'M'}">
						<li><a href="#" onclick="javascript:syncData();" class="list_icon18"><spring:message code='common.button.sync'/></a></li>
					</c:if>
					<c:if test="${sessionScope.auth.LNC gt 1 and (sessMode or (sessionScope.auth.adminDvsCd eq 'R' or  sessionScope.auth.adminDvsCd eq 'S' )) }">
					<li><a href="#" onclick="javascript:myGrid_onRowSelect();" class="list_icon12"><spring:message code='common.button.new'/></a></li>
					</c:if>
					<c:if test="${sessMode or (sessionScope.auth.adminDvsCd eq 'R' or  sessionScope.auth.adminDvsCd eq 'S' )}">
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
<form id="licenseExportFrm">
<input type="hidden" name="userId" value="${sessionScope.sess_user.userId}" />
<input type="hidden" name="exportFmt" value="excel" />
</form>
</body>
</html>