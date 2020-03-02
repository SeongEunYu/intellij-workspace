<%@page import="kr.co.argonet.r2rims.util.LanguageUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="../../pageInit.jsp" %>
<style type="text/css">
.dhxwins_vp_dhx_terrace {overflow-y: auto; }
div#userVp {position: inherit; height: 100%;}
div#winVp {position: inherit; height: 100%;}
</style>
<script type="text/javascript" src="${contextPath}/js/mainLayout.js"></script>
<script type="text/javascript">
var dhxLayout, myGrid, t, openedPage = 1, rowNums, pageSize, pageNums, mappingPopup;
$(document).ready(function(){
	setMainLayoutHeight($('#mainLayout'));
	if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
	else  window.addEventListener("resize",resizeLayout, false);

	//set layout
	dhxLayout = new dhtmlXLayoutObject("mainLayout","1C");
	dhxLayout.cells("a").hideHeader();
	dhxLayout.setSizes(false);

	var header = "번호,관리번호,사번,성명(한글),학위취득년월,학위구분,학위취득기관,학위취득국가,최종학위여부,최종수정일,삭제여부,소스원";
	var columnIds = "no,degreeId,userId,korNm,dgrAcqsYm,acqsDgrDvsCd,dgrAcqsAgcNm,dgrAcqsNtnCd,lastDgrSlctCd,modDate,delDvsCd,src";
	var initWidths = "50,70,80,100,100,130,*,120,100,100,100,80";
	var colAlign = "center,center,center,center,center,center,left,left,center,center,center,center";
	var colTypes = "ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro";
	var colSorting = "na,str,str,str,str,str,str,str,str,str,str,str";

	if(sessMode == 'true' || loginAuthor == 'R' || loginAuthor == 'S')
	{
		header = "<spring:message code='grid.no'/>,<spring:message code='grid.id'/>,<spring:message code='grid.deg1'/>,<spring:message code='grid.deg2'/>,<spring:message code='grid.deg3'/>,<spring:message code='grid.deg4'/>,<spring:message code='grid.deg5'/>,<spring:message code='grid.source'/>,<spring:message code='grid.deg6'/>";
		columnIds = "no,degreeId,dgrAcqsYm,acqsDgrDvsCd,dgrAcqsAgcNm,dgrAcqsNtnCd,orgLangDgrPprNm,src,lastDgrSlctCd";
		initWidths = "50,70,90,70,*,*,*,70,120";
		colAlign = "center,center,center,center,center,center,left,center,center";
		colTypes = "ro,ro,ro,ro,ro,ro,ro,ro,ro";
		colSorting = "na,na,str,str,str,str,str,str,str";
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

	var url = "${contextPath}/${preUrl}/degree/findAdminDegreeList.do";
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
	var wHeight = 730;
	var leftPos = (screenWidth - wWidth)/2;
	var topPos = (screenHeight - wHeight)/2;

	var str = rowID.split('_');
	openedRowId = rowID;
	openedPage = myGrid.currentPage;
	mappingPopup = window.open('about:blank', 'degreePopup', 'width='+wWidth+'px,height='+wHeight+'px,top='+topPos+',left='+leftPos+' location=no,scrollbars=yes,resizable=yes');
	var popFrm = $('#popFrm');
	popFrm.empty();
	popFrm.append($('<input type="hidden" name="degreeId" value="'+str[1]+'"/>'));
	popFrm.attr('action', '${contextPath}/${preUrl}/degree/degreePopup.do');
	popFrm.attr('target', 'degreePopup');
	popFrm.attr('method', 'POST');
	popFrm.submit();
	mappingPopup.focus();
}

function fn_new(){
	var wWidth = 990;
	var wHeight = 730;
	var leftPos = (screenWidth - wWidth)/2;
	var topPos = (screenHeight - wHeight)/2;
	mappingPopup = window.open('about:blank', 'degreePopup', 'width='+wWidth+'px,height='+wHeight+'px,top='+topPos+',left='+leftPos+' location=no,scrollbars=yes,resizable=yes');
	var popFrm = $('#popFrm');
	popFrm.empty();
	popFrm.attr('action', '${contextPath}/${preUrl}/degree/degreePopup.do');
	popFrm.attr('target', 'degreePopup');
	popFrm.attr('method', 'POST');
	popFrm.submit();
	mappingPopup.focus();
}

function syncData(){
	var syncUrl = "${contextPath}${sysConf['sync.degree.uri']}";
	$.ajax({ url: syncUrl, dataType: 'json' }).done(function(data){
		dhtmlx.alert(data.msg);
	});
}


var dhxUserWins, userWin;
function userSearch(){
    var wWidth = 600;
    var wHeight = 700;

    var x = $(window).width() /2 - wWidth /2 + $(window).scrollLeft();
    var y = $(window).height() /2 - wHeight /2 + $(window).scrollTop();
    // var y = 0;
    dhxUserWins = new dhtmlXWindows();
    dhxUserWins.attachViewportTo("userVp");

    userWin = dhxUserWins.createWindow("w1", x, y, wWidth, wHeight);
    userWin.setText("Search User");
    dhxUserWins.window("w1").setModal(true);
    $(".dhxwins_mcover").css("height",$(".popup_wrap").outerHeight());
    dhxUserWins.window("w1").denyMove();
    userWin.attachURL(contextpath+"/degree/userForm.do");
}


var dhxMailWins, mailWin;
function sendMailUserDegree(userId, degreeId, dgrAcqsYm, tutorNm, dgrSpclNm, dgrDtlSpclNm, korNm, acqsDgrDvsNm){
	$("#winVp").find("#degree_id").val(degreeId);
	$("#winVp").find("#dgr_acqs_ym").val(dgrAcqsYm);
	$("#winVp").find("#tutor_nm").val(tutorNm);
	$("#winVp").find("#dgr_spcl_nm").val(dgrSpclNm);
	$("#winVp").find("#dgr_dtl_spcl_nm").val(dgrDtlSpclNm);
	$("#winVp").find("#kor_nm").val(korNm);
	$("#winVp").find("#acqs_dgr_dvs_nm").val(acqsDgrDvsNm);

	var wWidth = 950;
	var wHeight = 850;

	var x = $(window).width() /2 - wWidth /2 + $(window).scrollLeft();
	//var y = $(window).height() /2 - wHeight /2 + $(window).scrollTop();
	var y = 0;
	dhxMailWins = new dhtmlXWindows();
	dhxMailWins.attachViewportTo("winVp");

	mailWin = dhxMailWins.createWindow("w1", x, y, wWidth, wHeight);
	mailWin.setText("Send Mail");
	dhxMailWins.window("w1").setModal(true);
	$(".dhxwins_mcover").css("height",$(".popup_wrap").outerHeight());
	dhxMailWins.window("w1").denyMove();
	mailWin.attachURL(contextpath+"/mail/mailForm.do?rsltSe=DEGREE&itemId="+userId);
}

function unloadDhxMailWins(){
	if(dhxMailWins != null && dhxMailWins.unload != null)
	{
		dhxMailWins.unload();
		dhxMailWins = null;
	}
}
</script>
</head>
<body>
	<div class="title_box">
		<h3><spring:message code='menu.degree'/></h3>
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
						<td rowspan="5" class="option_search_td" onclick="javascript:myGrid_load();"><em>search</em></td>
					</tr>
					<tr>
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
						<th>삭제구분</th>
						<td>
							<input type="checkbox" name="isDelete" id="isDelete" value="true" onchange="javascript:myGrid_load();" class="radio"/>
							<label for="isDelete" class="radio_label">삭제된 데이터 포함</label>
						</td>
					</tr>
					<tr>
						<th>학위구분</th>
						<td>
							<select class="select_type" name="acqsDgrDvsCd" onchange="javascript:myGrid_load();">
								<option value="">전체</option>
								${rims:makeCodeList('1240', false, '')}
							</select>
						</td>
						<th>전임여부</th>
						<td>
							<input type="radio" class="radio" value="" id="isFulltime0" name="isFulltime" checked="checked" onchange="javascript:myGrid_load();"/><label for="isFulltime0" class="radio_label">전체</label>
							<input type="radio" class="radio" value="M" id="isFulltime1" name="isFulltime" onchange="javascript:myGrid_load();"/><label for="isFulltime1" class="radio_label">전임</label>
							<input type="radio" class="radio" value="U" id="isFulltime2" name="isFulltime" onchange="javascript:myGrid_load();"/><label for="isFulltime2" class="radio_label">비전임</label>
							<input type="radio" class="radio" value="S" id="isFulltime3" name="isFulltime" onchange="javascript:myGrid_load();"/><label for="isFulltime3" class="radio_label">학생</label>
						</td>
					</tr>
					<tr>
						<th>학위취득기관</th>
						<td>
							<input type="text" name="dgrAcqsAgcNm" id="dgrAcqsAgcNm" class="input2" style="width: 99%;" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/>
						</td>
						<th>재직여부</th>
						<td>
							<input type="radio" id="hldofYn0" name="hldofYn" class="radio" value="" checked="checked" onchange="javascript:myGrid_load();"/><label for="hldofYn0" class="radio_label">전체</label>
							<input type="radio" id="hldofYn1" name="hldofYn" class="radio" value="1" onchange="javascript:myGrid_load();"/><label for="hldofYn1" class="radio_label">재직</label>
							<input type="radio" id="hldofYn2" name="hldofYn" class="radio" value="2" onchange="javascript:myGrid_load();"/><label for="hldofYn2" class="radio_label">퇴직</label>
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
					<th><spring:message code="search.deg1" /></th>
					<td colspan="3">
						<input type="text" id="dgrAcqsAgcNm" name="dgrAcqsAgcNm" class="typeText" style="width: 100%;" class="input2" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/>
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
                    <c:if test="${sessionScope.auth.adminDvsCd eq 'M'}">
                        <c:if test="${sysConf['mail.use.degree.at'] eq 'Y'}">
                            <li><a href="#" onclick="javascript:userSearch();" class="list_icon19">KRI전송 정보 미입력 연구자 검색</a></li>
                        </c:if>
                        <c:if test="${not empty sysConf['sync.degree.uri']}">
                            <li><a href="#" onclick="javascript:syncData();" class="list_icon18"><spring:message code='common.button.sync'/></a></li>
                        </c:if>
                    </c:if>
					<c:if test="${sessionScope.auth.DGR gt 1 and (sessMode or (sessionScope.auth.adminDvsCd eq 'R' or  sessionScope.auth.adminDvsCd eq 'S' )) }">
					<li><a href="javascript:fn_new();" class="list_icon12"><spring:message code='common.button.new'/></a></li>
					</c:if>
					<%--
					<li><a href="#" onclick="javascript:toExcel();" class="list_icon20"><spring:message code='common.button.excel'/></a></li>
					 --%>
				</ul>
			</div>
		</div>
		<!-- layout (grid,paging)  -->
		<div id="mainLayout" style="position: relative; width: 100%;height: 100%;"></div>
		<div id="pagingObj" style="z-index: 1; height: 40px; margin-top: 5px;" >
			<div id="pagingArea" style="z-index: 1;"></div>
		</div>
	</div>

	<div id="userVp"></div>
	<div id="winVp">
		<input type="hidden" id="kor_nm">
		<input type="hidden" id="degree_id">
		<input type="hidden" id="dgr_acqs_ym">
		<input type="hidden" id="acqs_dgr_dvs_nm">
		<input type="hidden" id="tutor_nm">
		<input type="hidden" id="dgr_spcl_nm">
		<input type="hidden" id="dgr_dtl_spcl_nm">
	</div>
</body>
</html>