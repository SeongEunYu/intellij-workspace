<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="../pageInit.jsp" %>
<style type="text/css">
.dhtmlx_modal_box .dhtmlx_popup_text {padding: 5px 10px 10px!important;}
</style>
<script type="text/javascript" src="${contextPath}/js/mainLayout.js"></script>
<script type="text/javascript">
var dhxLayout, myGrid, t, dhxSttDateCal, dhxEndDateCal;
$(document).ready(function(){
	setMainLayoutHeight($('#mainLayout'));
	if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
	else  window.addEventListener("resize",resizeLayout, false);

	//set layout
	dhxLayout = new dhtmlXLayoutObject("mainLayout","1C");
	dhxLayout.cells("a").hideHeader();
	dhxLayout.setSizes(false);

    var header = "번호,제목,URL,언어,표시여부,게시기간";
    var columnIds = "no,title,content,languageFlag,delDvsCd,period";
    var initWidths = "50,*,*,150,150,250";
    var colAlign = "center,left,center,center,center,center";
    var colTypes = "ro,ro,ro,ro,ro,ro";
    var colSorting = "na,str,na,str,str,str";

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

	dhxSttDateCal = new dhtmlXCalendarObject("sttDate");
	dhxSttDateCal.hideTime();
	dhxSttDateCal.loadUserLanguage("ko");
	dhxEndDateCal = new dhtmlXCalendarObject("endDate");
	dhxEndDateCal.hideTime();
	dhxEndDateCal.loadUserLanguage("ko");

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
	var url = "${contextPath}/board/findNoticeList.do";
	url += "?"  + $('#formArea').serialize();
	return url;
}

function myGrid_onRowSelect(rowID,celInd) {
	modify_top_notice(rowID);
}

function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){ setMainLayoutHeight($('#mainLayout')); dhxLayout.setSizes(false); },10);}
function doOnGridLoaded(){setTimeout(function() {dhxLayout.cells("a").progressOff();}, 100);}
function doBeforeGridLoad(){dhxLayout.cells("a").progressOn();}

var noticeModalBox, noticeFormLayout, noticeForm, clkBtnString
function modify_top_notice(rowId, cellInd){
	var btn = new Array();
	if(rowId == undefined || rowId == "0")
	{
		btn = ["저장", "취소"];
	}
	else
	{
		btn = ["저장","삭제","취소"];
	}

	noticeModalBox = dhtmlx.modalbox({
		title: '공지사항 추가/수정',
	    text: '<div style="text-align:left;color:red;height:15px;padding-bottom: 1px;"><span id="msg"></span></div><div id="noticeForm" style="width: 523px; height: 224px;"></div>',
	    width: '545px',
	    buttons:btn
	});

	noticeFormLayout = new dhtmlXLayoutObject({
		parent: 'noticeForm',
		pattern: '1C',
		skin: 'dhx_terrace',
		cells: [{ id: 'a', header: false }]
	});

	noticeFormLayout.cells('a').attachURL("${contextPath}/board/topNoticeModifyForm.do?bbsId="+rowId);

	$('.dhtmlx_popup_button').on('click', function(e) {
		clkBtnString = $(this).text();
		if(clkBtnString == '취소')
		{
			return true;
		}
		else
		{
			if(clkBtnString == '삭제')
			{
				$('#noticeForm iframe').contents().find('input[name="delDvsCd"]').prop('checked', false);
				$('#noticeForm iframe').contents().find('#delDvsCd_Y').eq(0).prop('checked', true);
			}

			if(noticeFrmValidation())
			{
				$('#msg').empty();
				var formdata = $('#noticeForm iframe').contents().find('#noticeFrm').eq(0).serializeArray();

				$.post('${contextPath}/board/modifyTopNotice.do',formdata,null,'json').done(function(data){
					if(data.code == '001')
					{
						//dhtmlx.modalbox.hide(noticeModalBox);
						dhtmlx.alert(clkBtnString + ' 되었습니다.');
						myGrid_load();
					}
				});
				return true;
			}
			else
			{
				$('#msg').empty().text('※필수항목이 누락되었습니다. 입력 후 저장하여 주세요.');
				var reqs = $('#noticeForm iframe').contents().find('.required');
				$(reqs).each(function(idx){ if($(reqs[idx]).val().trim() == ''){ $(reqs[idx]).focus(); return false; }});
				e.preventDefault();
				e.stopPropagation();
			}
		}
	});
}

function noticeFrmValidation(){
	var reqs = $('#noticeForm iframe').contents().find('.required');
	var emptyCo = 0;
	if(reqs.length > 0)
	{
		$(reqs).each(function(idx){
			if($(reqs[idx]).val().trim() == '')
			{
				emptyCo++;
				$(reqs[idx]).css('background-color','#FFCC66');
			}
			else
			{
				$(reqs[idx]).css('background-color','');
			}
		});
		if(emptyCo == 0) return true;
		else return false;
	}
	else
	{
		return true;
	}
}
</script>
</head>
<body>
	<div class="title_box">
		<h3>공지사항관리</h3>
	</div>
	<div class="contents_box">
		<!-- START 테이블 1 -->
		<form id="formArea" >
		<input type="hidden" name="type" id="type" value="top_notice"/>
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
						<th>언어</th>
						<td>
							<input type="radio" id="language_flag_all" name="languageFlag"  value=""  checked="checked" onchange="javascript:myGrid_load();" class="radio"/>
								<label for="language_flag_all" class="radio_label">전체</label>
							<input type="radio" id="language_flag_kor" name="languageFlag"  value="KOR" onchange="javascript:myGrid_load();" class="radio"/>
								<label for="language_flag_kor" class="radio_label">한국어</label>
							<input type="radio" id="language_flag_eng" name="languageFlag"  value="ENG" onchange="javascript:myGrid_load();" class="radio"/>
								<label for="language_flag_eng" class="radio_label">영어</label>
						</td>
						<th>게시기간</th>
						<td>
							<input type="text" name="sttDate" id="sttDate" class="input2"  maxlength="8" style="width: 100px;"  onKeyup="javascript:if(event.keyCode=='13')myGrid_load();" />
							~ <input type="text" name="endDate" id="endDate" class="input2" maxlength="8" style="width: 100px;" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/>
							<input type="checkbox" name="isDelete" id="isDelete" value="true" class="radio" checked="checked" onclick="javascript:myGrid_load();"/>
							   <label for="isDelete" class="radio_label">게시종료 포함</label>
						</td>
						<td rowspan="3" class="option_search_td" onclick="javascript:myGrid_load();"><em>search</em></td>
					</tr>
					<tr>
						<th>제목</th>
						<td><input type="text" name="title" id="title" class="input_type" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/></td>
						<th>URL</th>
						<td><input type="text" name="content" id="content" class="input_type" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/></td>
					</tr>
				</tbody>
			</table>
		</form>

		<div class="list_bt_area">
			<div class="list_set">
				<ul>
					<li><a href="#" onclick="javascript:modify_top_notice('0');" class="list_icon12"><spring:message code='common.button.new'/></a></li>
					<li><a href="#" onclick="javascript:syncData();" class="list_icon10"><spring:message code='common.button.delete'/></a></li>
				</ul>
			</div>
		</div>
		<!-- layout (grid,paging)  -->
		<div id="mainLayout" style="position: relative; width: 100%;height: 100%;"></div>
		<div id="pagingObj" style="z-index: 1; height: 40px; margin-top: 5px;" >
			<div id="pagingArea" style="z-index: 1;"></div>
		</div>
	</div>
</body>
</html>