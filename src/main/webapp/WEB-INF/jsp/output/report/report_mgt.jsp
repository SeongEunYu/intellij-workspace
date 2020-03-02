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
	bindModalLink();
	setMainLayoutHeight($('#mainLayout'));
	if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
	else  window.addEventListener("resize",resizeLayout, false);

	//set layout
	dhxLayout = new dhtmlXLayoutObject("mainLayout","1C");
	dhxLayout.cells("a").hideHeader();
	dhxLayout.setSizes(false);

	var header = "번호,관리번호,발행년월,보고서명,위탁기관,과제번호,최종수정일,삭제여부";
	var columnIds = "no,reportId,pblicteYm,reportTitle,orderInsttNm,sbjtNo,modDate,delDvsCd";
	var initWidths = "40,110,100,*,120,100,100,100";
	var colAlign = "center,center,center,left,left,center,center,center";
	var colTypes = "ro,ro,ro,ro,ro,ro,ro,ro";
	var colSorting = "na,str,str,str,str,str,str,str";

	if(sessMode == 'true' || loginAuthor == 'R' || loginAuthor == 'S')
	{
		header = "<spring:message code='grid.no'/>,<spring:message code='grid.id'/>,<spring:message code='grid.rrt1'/>,<spring:message code='grid.rrt2'/>,<spring:message code='grid.rrt3'/>";
		columnIds = "no,reportId,pblicteYm,reportTitle,orderInsttNm";
		initWidths = "40,110,110,*,260";
		colAlign = "center,center,center,left,left";
		colTypes = "ro,ro,ro,ro,ro";
		colSorting = "na,na,str,str,str";
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

	var url = "${contextPath}/${preUrl}/report/findAdminReportList.do";
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
		mappingPopup = window.open('about:blank', 'reportPopup', 'width='+wWidth+'px,height='+wHeight+'px,top='+topPos+',left='+leftPos+' location=no,scrollbars=yes,resizable=yes');
		var popFrm = $('#popFrm');
		popFrm.empty();
		popFrm.append($('<input type="hidden" name="reportId" value="'+str[1]+'"/>'));
		popFrm.attr('action', '${contextPath}/${preUrl}/report/reportPopup.do');
		popFrm.attr('target', 'reportPopup');
		popFrm.attr('method', 'POST');
		popFrm.submit();
		mappingPopup.focus();
	}
	else {
		mappingPopup = window.open('about:blank', 'reportPopup', 'width='+wWidth+'px,height='+wHeight+'px,top='+topPos+',left='+leftPos+' location=no,scrollbars=yes,resizable=yes');
		var popFrm = $('#popFrm');
		popFrm.empty();
		popFrm.append($('<input type="hidden" name="srchUserId" value="${sessionScope.login_user.userId}"/>'));
		popFrm.attr('action', '${contextPath}/${preUrl}/report/reportPopup.do');
		popFrm.attr('target', 'reportPopup');
		popFrm.submit();
		mappingPopup.focus();
	}
}
function fn_export(){
    $('#reportExportDialog #closeBtn').triggerHandler('click');
    var url = "${contextPath}/${preUrl}/report/export.do?"+$('#formArea').serialize()+'&'+$('#reportExportFrm').serialize() ;
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
		<h3><spring:message code='menu.report'/></h3>
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
						<th>발행년월</th>
						<td>
							<input type="text" name="sttDate" id="stt_date" class="input2"  maxlength="6" style="width: 80px;"  onKeyup="javascript:if(event.keyCode=='13')myGrid_load();" />
							~ <input type="text" name="endDate" id="end_date" class="input2" maxlength="6" style="width: 80px;" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/>
						</td>
						<td rowspan="4" class="option_search_td" onclick="javascript:myGrid_load();"><em>search</em></td>
					</tr>
					<tr>
						<th>성명</th>
						<td><input type="text" name="srchUserNm" id="nm" class="input2" maxlength="20" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/></td>
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
						<th>관리번호</th>
						<td>
							<input type="text" id="reportId" name="reportId" class="typeText" style="width: 80px;" class="input2" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/>
						</td>
						<th>과제번호</th>
						<td>
							<input type="text" id="sbjtNo" name="sbjtNo" class="typeText" style="width: 80px;" class="input2" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/>
						</td>
					</tr>
					<tr>
						<th>보고서명</th>
						<td colspan="3">
							<input type="text" id="reportTitle" name="reportTitle" class="typeText" style="width: 100%;" class="input2" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/>
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
						<th><spring:message code="search.rrt1" /></th>
						<td><input type="text" id="reportTitle" name="reportTitle" class="input2" style="width: 100%;" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/></td>
						<th><spring:message code="search.rrt2" /></th>
						<td>
							<input type="text" name="sttDate" id="stt_date" class="input2"  maxlength="6" style="width: 80px;"  onKeyup="javascript:if(event.keyCode=='13')myGrid_load();" />
							~ <input type="text" name="endDate" id="end_date" class="input2" maxlength="6" style="width: 80px;" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/>
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
					<c:if test="${sessionScope.auth.RPT gt 1}">
						<li><a href="#" onclick="javascript:myGrid_onRowSelect();" class="list_icon12"><spring:message code='common.button.new'/></a></li>
					</c:if>
					<c:if test="${sessMode or (sessionScope.auth.adminDvsCd eq 'R' or  sessionScope.auth.adminDvsCd eq 'S' ) or sessionScope.auth.adminDvsCd eq 'M'}">
	                    <li><a href="#reportExportDialog" class="modalLink list_icon26">Export</a></li>
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
    <div id="reportExportDialog" class="popup_box modal modal_layer" style="width: 450px;height:170px; display: none;">
    <form id="reportExportFrm">
           <div class="popup_header">
                  <h3>Final Research Reports Export</h3>
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
                               <li><a href="javascript:$('#reportExportDialog #closeBtn').triggerHandler('click');" class="list_icon10">Cancel</a></li>
                        </ul>
                  </div>
           </div>
    </form>
    </div>
</body>
</html>