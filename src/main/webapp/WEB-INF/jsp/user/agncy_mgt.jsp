<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../pageInit.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Authority Management</title>
<style type="text/css">
.dhxwins_vp_dhx_terrace {overflow: auto;}
.dhxwins_vp_dhx_terrace div.dhxwin_active div.dhx_cell_wins div.dhx_cell_toolbar_def, .dhxwins_vp_dhx_terrace div.dhxwin_inactive div.dhx_cell_wins div.dhx_cell_toolbar_def { padding: 10px 0px 0; }
.dhx_toolbar_dhx_terrace { padding: 0 0px; }
div.dhxform_item_label_left.button_search div.dhxform_btn {
	height: 25px; margin: 0px 2px; background-color: #ffffff;
}
div.dhxform_item_label_left.button_search div.dhxform_btn_txt {
	top:0;right:0;background: url(${contextPath}/images/background/tbl_search_icon.png) no-repeat 50% 50%;
	text-indent: -9999px;display: block;width: 23px; height: 25px;margin: 0 0px;
}
.alignLeft{text-align: left;}
.alignLeft div.dhxform_txt_label2{font-weight: normal;}
</style>
<script type="text/javascript" src="${contextPath}/js/mainLayout.js"></script>
<script type="text/javascript">
var dhxLayout, dhxWins, w1, w1Layout, myGrid, myDp, combo, t;
$(document).ready(function(){
	setMainLayoutHeight($('#mainLayout'));
	if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
	else  window.addEventListener("resize",resizeLayout, false);
	//set layout
	dhxLayout = new dhtmlXLayoutObject("mainLayout","1C");
	dhxLayout.cells("a").hideHeader();
	dhxLayout.setSizes(false);
	//attach myGrid
	doBeforeGridLoad();
	myGrid = dhxLayout.cells("a").attachGrid();
	myGrid.setImagePath("${dhtmlXImagePath}");
	myGrid.setHeader("<spring:message code='grid.no'/>,<spring:message code='grid.sitter.userid'/>,<spring:message code='grid.sitter.username'/>,<spring:message code='grid.sitter.authority'/>,<spring:message code='grid.sitter.authority.status'/>,<spring:message code='grid.sitter.authority.date'/>,<spring:message code='grid.sitter.email'/>,<spring:message code='grid.sitter.tel'/>,<spring:message code='grid.sitter.remark'/>,등록자ID,수정자ID,권한코드,대상자식별자,대상자명,관리자비고",null,grid_head_center_bold);
	myGrid.setColumnIds("no,userId,korNm,adminDvsCdNm,authorStatus,date,emailAdres,telno,remarkCn,regUserId,modUserId,adminDvsCd,workTrget,workTrgetNm,mngrResnCn");
	myGrid.setInitWidths("80,*,*,*,*,*,*,*,*,1,1,1,1,1,1");
	myGrid.setColAlign("center,center,center,center,center,center,center,center,center,center,center,center,center,center,center");
	myGrid.setColTypes("ro,ro,ro,ro,ro,ro,ro,co,ro,ro,ro,ro,ro,ro,ro");
	myGrid.setColSorting("int,str,str,str,str,str,str,str,str,str,na,na,na,na,na");
	myGrid.setColumnHidden(myGrid.getColIndexById("password"),true);
	myGrid.setColumnHidden(myGrid.getColIndexById("regUserId"),true);
	myGrid.setColumnHidden(myGrid.getColIndexById("modUserId"),true);
	myGrid.setColumnHidden(myGrid.getColIndexById("adminDvsCd"),true);
	myGrid.setColumnHidden(myGrid.getColIndexById("workTrget"),true);
	myGrid.setColumnHidden(myGrid.getColIndexById("workTrgetNm"),true);
	myGrid.setColumnHidden(myGrid.getColIndexById("mngrResnCn"),true);
	//myGrid.enableMultiselect(true);
	myGrid.attachEvent("onRowDblClicked", myGrid_onRowSelect);
	myGrid.attachEvent("onXLS", doBeforeGridLoad);
	myGrid.attachEvent("onXLE", doOnGridLoaded);
	myGrid.init();

	myDp = new dataProcessor("${contextPath}/member/authCUD.do");
	myDp.init(myGrid);
	myDp.setTransactionMode("POST",false);
	myDp.setUpdateMode("off"); //
	myDp.enableDataNames(true);
	myDp.setVerificator(myGrid.getColIndexById("userId"), myGrid_not_empty);
	myDp.setVerificator(myGrid.getColIndexById("adminDvsCd"), myGrid_not_empty);
	myDp.attachEvent("onValidatationError", function(id, messages) {
		alert(messages.join("\n"));
		return true;
	});

	myGrid_load();
	//myGrid.loadXML("${contextPath}/auth/user/authUserList.do",doOnGridLoaded);
});

function myGrid_not_empty(value, id, ind) {
    if (value == "") return "Value at (" + id + ", " + ind + ") can't be empty";
    return true;
}

// update authority
function myGrid_onRowSelect(rowID,celInd){
	if(rowID == '0') return;

	var wWidth = 970;
	var wHeight = 515;
	var leftPos = (screenWidth - wWidth)/2;
	var topPos = (screenHeight - wHeight)/2;

	var str = rowID.split('_');
	var mappingPopup = window.open('about:blank', 'updateAgncyPopup', 'width='+wWidth+'px,height='+wHeight+'px,top='+topPos+',left='+leftPos+' location=no,scrollbars=yes,resizable=yes');
	var popFrm = $('#popFrm');
	popFrm.empty();
	popFrm.append($('<input type="hidden" name="trgetUserId" value="'+str[0]+'"/>'));
	popFrm.append($('<input type="hidden" name="trgetAuthorId" value="'+str[1]+'"/>'));
	popFrm.append($('<input type="hidden" name="mode" value="update"/>'));
	popFrm.attr('action', '${contextPath}/member/agncyPopup.do');
	popFrm.attr('target', 'updateAgncyPopup');
	popFrm.attr('method', 'POST');
	popFrm.submit();
	mappingPopup.focus();
}
// add authority
function addMemberPopup(){

	//최대 5명만 허용
	var sitterCount = myGrid.getRowsNum();
	if(sitterCount >= 5 )
	{
		dhtmlx.alert({type:"alert-warning",text:"최대 5명까지 가능합니다. <br/> 삭제 후 추가하세요.",callback:function(){}});
		return;
	}
	else
	{
		var wWidth = 970;
		var wHeight = 515;
		var leftPos = (screenWidth - wWidth)/2;
		var topPos = (screenHeight - wHeight)/2;
		var mappingPopup = window.open('about:blank', 'addAgncyPopup', 'width='+wWidth+'px,height='+wHeight+'px,top='+topPos+',left='+leftPos+' location=no,scrollbars=yes,resizable=yes');
		var popFrm = $('#popFrm');
		popFrm.empty();
		popFrm.append($('<input type="hidden" name="trgetUserId" value=""/>'));
		popFrm.append($('<input type="hidden" name="trgetAuthorId" value=""/>'));
		popFrm.append($('<input type="hidden" name="mode" value="add"/>'));
		popFrm.attr('action', '${contextPath}/member/agncyPopup.do');
		popFrm.attr('target', 'addAgncyPopup');
		popFrm.attr('method', 'POST');
		popFrm.submit();
		mappingPopup.focus();
	}
}

function myGrid_load(){
	var url = "${contextPath}/${preUrl}/member/findAgncyList.do?"+$('#formArea').serialize();;
	myGrid.clearAndLoad(url, doOnGridLoaded);
}

function myGrid_not_empty(value, id, ind) {
    if (value == "") return "Value at (" + id + ", " + ind + ") can't be empty";
    return true;
}
function save(){
	myDp.sendData();
}
function cut(){
	if(myGrid.getSelectedRowId() == null)
	{
		dhtmlx.alert('삭제할 권한을 선택하세요.');
		return false;
	}
	dhtmlx.confirm({
		type:"confirm-warning",
		title:"권한 삭제",
		text:"선택하신 권한을 삭제하시겠습니까?",
		ok:"삭제", cancel:"취소",
		callback:function(result){
			if(result == true){
				var mngrResnCn = myGrid.cells(myGrid.getSelectedRowId(),myGrid.getColIndexById("mngrResnCn")).getValue();
				var reasonBox = dhtmlx.modalbox({
					title: '상실 사유',
					text: '<h3>상실 사유를 입력해주세요.</h3><input type="text" id="aa" style="width: 450px;margin-top: 20px;height: 20px;">',
					width: '472px',
					buttons:["저장"],
					callback: function(result){
						if(result == "0"){
							var reason = $(reasonBox).find("input").val();
							if(mngrResnCn != ""){
								mngrResnCn += ";"+reason;
							}else{
								mngrResnCn = reason;
							}

							myGrid.cells(myGrid.getSelectedRowId(),myGrid.getColIndexById("mngrResnCn")).setValue(mngrResnCn);
							myGrid.deleteSelectedRows();
							myDp.sendData();

							setTimeout(function() {myGrid_load();}, 100);
						}
					}
				});
			}
		}
	});
}

function toExcel(){
	myGrid.toExcel('${contextPath}/servlet/xlsGenerate.do?file_name=Sitter_List.xls');
}

function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){ setMainLayoutHeight($('#mainLayout')); dhxLayout.setSizes(false); },10);}
function doOnGridLoaded(){setTimeout(function() {dhxLayout.cells("a").progressOff();}, 100);}
function doBeforeGridLoad(){dhxLayout.cells("a").progressOn();}
</script>
</head>
<body>
	<!-- Page Title -->
	<div class="title_box">
		<h3><spring:message code="menu.assistant.mgt"/></h3>
	</div>
	<!-- Main Content -->
	<div class="contents_box">
		<form id="formArea" >
			<table class="view_tbl mgb_10" >
				<colgroup>
					<col style="width: 15%;"/>
					<col style="width: 30%;"/>
					<col style="width: 15%;"/>
					<col />
					<col style="width: 50px;"/>
				</colgroup>
				<tbody>
				<tr>
					<th>ID</th>
					<td><input type="text" id="srchUserId" name="srchUserId" class="input2" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();" /></td>
					<th><spring:message code="search.sitter.name" /></th>
					<td>
						<input type="text" id="srchUserNm" name="srchUserNm" class="typeText" style="width: 98%;" class="input2" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/>
					</td>
					<td class="option_search_td" onclick="javascript:myGrid_load();"><em>search</em></td>
				</tr>
				</tbody>
			</table>
		</form>

		<div class="list_bt_area">
			<div class="list_set">
				<ul>
					<li style="padding-top: 15px;">
						<label><spring:message code='sitter.comment1'/></label>
					</li>
					<li><a href="#" onclick="javascript:addMemberPopup();" class="list_icon12"><spring:message code='common.button.new'/></a></li>
					<li><a href="#" onclick="javascript:cut();" class="list_icon22"><spring:message code='common.button.delete'/></a></li>
					<li><a href="#" onclick="javascript:toExcel();" class="list_icon20"><spring:message code='common.button.excel'/></a></li>
				</ul>
			</div>
		</div>

		<div id="mainLayout" style="position: relative; width: 100%;height: 100%;"></div>
		<div id="pagingObj" style="z-index: 1; height: 60px; margin-top: 5px;" >
			<div id="pagingArea" style="z-index: 1;"></div>
		</div>
	</div>
</body>
</html>
