<%@page import="kr.co.argonet.r2rims.util.LanguageUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="../../pageInit.jsp" %>
<style type="text/css">
.dhxwins_vp_dhx_terrace {overflow: auto;}
.dhxlayout_base_dhx_terrace div.dhx_cell_layout div.dhx_cell_cont_layout {border: 0 solid #fff;}
.dhxlayout_base_dhx_terrace div.dhx_cell_layout div.dhx_cell_hdr{border: 0 solid #fff;}
div#winVp {position: inherit; height: 100%;}
</style>
<script type="text/javascript" src="${contextPath}/js/jquery/jquery.filedownload.js"></script>
<script type="text/javascript" src="${contextPath}/js/mainLayout.js"></script>
<script type="text/javascript">
var dhxLayout, myGrid, t;
var rsltSe = "ERR_HANDLE";
$(document).ready(function(){
	setLayoutHeight();
	if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
	else  window.addEventListener("resize",resizeLayout, false);

	var header = "번호,요청일자,성과구분,관리번호,요청구분,요청자,상태,처리일자";
	var columnIds = "No,requestDate,trgetRsltType,trgetRsltId,requestSeCd,requestUserId,requestStatus,tretDate";
	var initWidths = "50,*,*,*,*,*,*,*";
	var colAlign = "center,center,center,center,center,center,center,center";
	var colTypes = "ro,ro,ro,ro,ro,ro,ro,ro";
	var colSorting = "na,str,str,str,str,str,str,str";

	if(sessMode == 'true' || loginAuthor == 'R' || loginAuthor == 'S')
	{
		//set layout
		dhxLayout = new dhtmlXLayoutObject("mainLayout","1C");
		dhxLayout.cells("a").hideHeader();
		dhxLayout.setSizes(false);
		//attach myGrid
		dhxLayout.cells("a").attachObject('listbox');
		setGridHeight();
		myGrid = new dhtmlXGridObject('gridbox');

		header = "<spring:message code='grid.req1'/>,<spring:message code='grid.req10'/>,<spring:message code='grid.req2'/>,<spring:message code='grid.req6'/>,<spring:message code='grid.req3'/>,<spring:message code='grid.req8'/>,<spring:message code='grid.req5'/>,<spring:message code='grid.req4'/>,<spring:message code='grid.req9'/>";
		columnIds = "No,requestDate,trgetRsltType,trgetRsltId,requestSeCd,requestCn,requestStatus,tretResultCn,tretDate";
		initWidths = "50,100,80,100,80,*,100,*,100)";
		colAlign = "center,center,center,center,center,left,center,left,center";
		colTypes = "ro,ro,ro,ro,ro,ro,ro,ro,ro";
		colSorting = "na,str,str,str,str,str,str,str,str";
	}
	else
	{
		dhxLayout = new dhtmlXLayoutObject("mainLayout","2U");
		dhxLayout.cells("a").hideHeader();
		dhxLayout.cells("b").hideHeader();
		dhxLayout.setSizes(false);

		dhxLayout.attachEvent("onPanelResizeFinish", function(ids){
			setGridHeight();
		});

		//attach myGrid
		dhxLayout.cells("a").attachObject('listbox');
		dhxLayout.cells("b").attachHTMLString('<div id="requestInfo" style="width:100%;height:100%;overflow:auto;"></div>');
		setGridHeight();
		myGrid = new dhtmlXGridObject('gridbox');
		myGrid.attachEvent("onRowSelect", load_modifyForm);
	}

	myGrid.setImagePath("${dhtmlXImagePath}");
	myGrid.setHeader(header,null,grid_head_center_bold);
	myGrid.setColumnIds(columnIds);
	myGrid.setInitWidths(initWidths);
	myGrid.setColAlign(colAlign);
	myGrid.setColTypes(colTypes);
	myGrid.setColSorting(colSorting);
	myGrid.attachEvent("onBeforeSorting", myGrid_onBeforeSorting);
	myGrid.attachEvent("onXLS", doBeforeGridLoad);
	myGrid.attachEvent("onXLE", doOnGridLoaded);
	myGrid.enablePaging(true,100,10,"pagingArea",true);
	myGrid.setPagingSkin("${dhtmlXPagingSkin}");
	myGrid.enableColSpan(true);
	myGrid.enableColumnAutoSize(true);
	myGrid.init();
	myGrid_load();
});
function myGrid_load(){
	var url = getGridRequestURL();
	myGrid.clearAndLoad(url);
}
function myGrid_onBeforeSorting(ind,type,direct){
	var url = getGridRequestURL();
	myGrid.clearAndLoad(url+"&orderby="+(myGrid.getColumnId(ind))+"&direct="+direct);
	myGrid.setSortImgState(true,ind,direct);
	return false;
}
function getGridRequestURL(){
	var url = "${contextPath}/${preUrl}/request/findRequestList.do";
	url += "?"  + $('#formArea').serialize();
	return url;
}

function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){ setLayoutHeight(); dhxLayout.setSizes(false); },10);}
function doOnGridLoaded(){
	var strIndex = (myGrid.currentPage-1) * myGrid.rowsBufferOutSize;
	myGrid.selectRow(strIndex,true,true,true);
	setTimeout(function() {dhxLayout.cells("a").progressOff();}, 100);
}
function doBeforeGridLoad(){dhxLayout.cells("a").progressOn();}

function fn_complete(){
	dhtmlx.confirm({title:"완료처리", ok:"예", cancel:"아니오", text:"요청사항에 대한 완료처리 하시겠습니까?",
		callback:function(result){
			if(result == true){
				$('#requestStatus').val('3');
				$.post('${contextPath}/request/updateTretRslt.do', $('#requestForm').serializeArray(),null,'text').done(function(data){
					load_modifyForm(myGrid.getSelectedRowId());
				});
			}
			else if(result == false)
			{
				return;
			}
		}
	});
}

function fn_pause(){
	dhtmlx.confirm({title:"보류처리", ok:"예", cancel:"아니오", text:"요청사항에 대한 보류처리 하시겠습니까?",
		callback:function(result){
			if(result == true){
				$('#requestStatus').val('4');
				$.post('${contextPath}/request/updateTretRslt.do', $('#requestForm').serializeArray(),null,'text').done(function(data){
					load_modifyForm(myGrid.getSelectedRowId());
				});
			}
			else if(result == false)
			{
				return;
			}
		}
	});
}

function load_modifyForm(rowID,celInd){
	$.post('${contextPath}/request/requestModifyForm.do',{'seqNo' : rowID},null,'text').done(function(data){
		$('#requestInfo').html(data);
		var cnTrHeight = $('#mainLayout').height();
		cnTrHeight = cnTrHeight - ($(".circle_h3").eq(0).height()*2);
		cnTrHeight = cnTrHeight - (30*2);
		cnTrHeight = cnTrHeight - 41;
		cnTrHeight = cnTrHeight - (35*($('#requestTbl tbody tr').length - 1 ));
		cnTrHeight = cnTrHeight - (35*($('#trgetTbl tbody tr').length - 1 ));
		cnTrHeight = cnTrHeight - 55;
		cnTrHeight = cnTrHeight/2;
		$('.cnTr').css('height', cnTrHeight);
		$('#tretResultCn').css('height', (cnTrHeight-40));
	});
}
function toExcel(){
	var url = "${contextPath}/article/excelExport.do?"+$('#formArea').serialize();
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

function setLayoutHeight(){
	var layoutHeight = $(window).height();
	layoutHeight -= 120;
	if($('.title_box') != undefined )
		layoutHeight -= $('.title_box').height();
	if($('.header_wrap') != undefined )
		layoutHeight -= $('.header_wrap').height();
	if($('.nav_wrap') != undefined )
		layoutHeight -= $('.nav_wrap').height();
	$('#mainLayout').css('height',layoutHeight+"px");
}

function setGridHeight(){
	var gridHeight = $('#mainLayout').height();
	gridHeight -= 60;
	if($('.view_tbl') != undefined )
		gridHeight -= $('.nav_wrap').height();
	$('#gridbox').css('height',gridHeight+"px");
}

function fn_edit()
{
	var rsltType = $('#trgetRsltType').val()
	var rsltId = $('#trgetRsltId').val()
	var wWidth = 990;
	var wHeight = 822;
	var leftPos = (screenWidth - wWidth)/2;
	var topPos = (screenHeight - wHeight)/2;
	var mappingPopup = window.open('about:blank', 'rsltPopup', 'width='+wWidth+'px,height='+wHeight+'px,top='+topPos+',left='+leftPos+' location=no,scrollbars=yes,resizable=yes');
	var popFrm = $('#popFrm');
	popFrm.empty();
	popFrm.append($('<input type="hidden" name="'+rsltType+'Id" value="'+rsltId+'"/>'));
	popFrm.attr('action', '${contextPath}/auth/'+rsltType+'/'+rsltType+'Popup.do');
	popFrm.attr('target', 'rsltPopup');
	popFrm.attr('method', 'POST');
	popFrm.submit();
	mappingPopup.focus();
}

function fn_completeAndMail(){
	dhtmlx.confirm({title:"완료처리", ok:"예", cancel:"아니오", text:"요청사항에 대한 완료처리 하시겠습니까?",
		callback:function(result){
			if(result == true){
				$('#requestStatus').val('3');
				$.post('${contextPath}/request/updateTretRslt.do', $('#requestForm').serializeArray(),null,'text').done(function(data){
					load_modifyForm(myGrid.getSelectedRowId());
					sendMailErrHandle(myGrid.getSelectedRowId());
				});
			}
			else if(result == false)
			{
				return;
			}
		}
	});
}

var dhxMailWins, mailWin;
function sendMailErrHandle(reqId){

	var wWidth = 950;
	var wHeight = 850;

	var x = $(window).width() /2 - wWidth /2 + $(window).scrollLeft();
	var y = $(window).height() /2 - wHeight /2 + $(window).scrollTop();
	// var y = 0;
	dhxMailWins = new dhtmlXWindows();
	dhxMailWins.attachViewportTo("winVp");

	mailWin = dhxMailWins.createWindow("w1", x, y, wWidth, wHeight);
	mailWin.setText("Send Mail");
	dhxMailWins.window("w1").setModal(true);
	$(".dhxwins_mcover").css("height",$(".popup_wrap").outerHeight());
	dhxMailWins.window("w1").denyMove();
	mailWin.attachURL(contextpath+"/mail/mailForm.do?rsltSe="+rsltSe+"&itemId="+reqId);
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
	<form id="mailForm">
		<input type="hidden" name="emailTitle" id="emailTitle"/>
		<input type="hidden" name="emailContents" id="emailContents"/>
		<input type="hidden" name="rcvrlist" id="rcvrlist"/>
		<input type="hidden" name="rcvrgrid" id="rcvrgrid"/>
	</form>
	<form name="popFrm" id="popFrm" method="post"></form>
	<div class="title_box">
		<h3><spring:message code="menu.request.result"/></h3>
	</div>
	<div class="contents_box">
		<!-- START 테이블 1 -->
			<form id="formArea">
			<c:if test="${not sessMode and sessionScope.auth.adminDvsCd ne 'R' and  sessionScope.auth.adminDvsCd ne 'S' }">
			<table class="view_tbl mgb_10" >
				<colgroup>
					<col style="width: 15%;"/>
					<col style="width: 27%;"/>
					<col style="width: 15%;"/>
					<col />
					<col style="width: 50px;"/>
				</colgroup>
				<tbody>
				<tr>
					<th>성과구분</th>
					<td>
						<select name="trgetRsltType" class="select_type">
							<option value="" selected="selected">전체</option>
							<option value="article">논문게재</option>
							<option value="conference">학술활동</option>
							<option value="book">저역서</option>
							<option value="funding">연구과제</option>
							<option value="patent">지식재산</option>
							<option value="techtarans">기술이전</option>
							<option value="exhibitionId">전시작품</option>
						</select>
					</td>
					<th>진행상태</th>
					<td>
						<input type="radio" id="record_status_all" name="requestStatus"  value=""  checked="checked" onchange="javascript:myGrid_load();" class="radio"/>
						<label for="record_status_all" class="radio_label">전체</label>

						<input type="radio" id="record_status_chk" name="requestStatus"  value="2" onchange="javascript:myGrid_load();" class="radio"/>
						<label for="record_status_chk" class="radio_label">미반영</label>

						<input type="radio" id="record_status_cmp" name="requestStatus"  value="3" onchange="javascript:myGrid_load();" class="radio"/>
						<label for="record_status_cmp" class="radio_label">완료</label>

						<input type="radio" id="record_status_not" name="requestStatus"  value="4" onchange="javascript:myGrid_load();" class="radio"/>
						<label for="record_status_not" class="radio_label">보류</label>
					</td>
					<td rowspan="2" class="option_search_td" onclick="javascript:myGrid_load();"><em>search</em></td>
				</tr>
				<tr>
					<th>사번</th>
					<td><input type="text" id="user_id" name="srchUserId" class="input2" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/></td>
					<th>요청일자</th>
					<td>
						<input type="text" id="stt_date" name="sttDate" class="input2" style="width: 80px;"  onKeyup="javascript:if(event.keyCode=='13')myGrid_load();" />
						~ <input type="text" id="end_date" name="endDate" class="input2" style="width: 80px;" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/>
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
					<th><spring:message code="search.req1"/></th>
					<td>
						<select name="trgetRsltType" class="select_type">
							<option value=""><spring:message code="common.option.all"/></option>
							<option value="article"><spring:message code="main.art"/></option>
							<option value="conference"><spring:message code="main.con"/></option>
							<option value="book"><spring:message code="main.book"/></option>
							<option value="funding"><spring:message code="main.fund"/></option>
							<option value="patent"><spring:message code="main.pat"/></option>
							<option value="techtarans"><spring:message code="main.tech"/></option>
							<option value="exhibitio"><spring:message code="main.exi"/></option>
						</select>
					</td>
					<th><spring:message code="search.req2"/></th>
					<td>
						<input type="text" id="stt_date" name="sttDate" class="input2" style="width: 80px;"  onKeyup="javascript:if(event.keyCode=='13')myGrid_load();" />
						~ <input type="text" id="end_date" name="endDate" class="input2" style="width: 80px;" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/>
					</td>
					<td class="option_search_td" onclick="javascript:myGrid_load();"><em>search</em></td>
				</tr>
				</tbody>
			</table>
			</form>
			</c:if>
			<div id="listbox">
				<div id="gridbox" style="position: relative; width: 100%;height: 100%;"></div>
				<div id="pagingObj" style="z-index: 1; height: 40px; margin-top: 5px;" >
					<div id="pagingArea" style="z-index: 1;"></div>
				</div>
			</div>
		<!-- layout (grid,paging)  -->
		<div id="mainLayout" style="position: relative; width: 100%;height: 100%;"></div>
 	</div>
    <div id="winVp"></div>
</body>
</html>