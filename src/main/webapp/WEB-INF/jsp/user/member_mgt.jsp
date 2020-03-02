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
div#winVp {position: inherit; height: 100%;}
</style>
<script type="text/javascript" src="${contextPath}/js/mainLayout.js"></script>
<script type="text/javascript">
var dhxLayout, dhxWins, w1, w1Layout, myGrid, myDp, combo, t;
$(document).ready(function(){
	if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
	else  window.addEventListener("resize",resizeLayout, false);
	//set layout
	dhxLayout = new dhtmlXLayoutObject("mainLayout","1C");
	dhxLayout.cells("a").hideHeader();
	dhxLayout.setSizes(false);
	//attach myGrid
	doBeforeGridLoad();
	myGrid = dhxLayout.cells("a").attachGrid();

	myGrid.setHeader("번호,아이디,성명,권한,권한코드,대상,대상ID,대상소속,권한부여일자,이메일,전화번호,비고,등록자ID,수정자ID",null,grid_head_center_bold);
	myGrid.setColumnIds("no,userId,korNm,adminDvsCdNm,adminDvsCd,workTrgetNm,workTrget,workTrgetDept,authorAlwncDate,emailAdres,telno,mngrResnCn,regUserId,modUserId");
	myGrid.setInitWidths("50,80,120,80,1,150,80,130,150,150,130,*,1,1");
	myGrid.setColAlign("center,center,center,left,left,left,center,center,center,center,left,center,center");
	myGrid.setColTypes("ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,co,ro,ro");
	myGrid.setColSorting("int,str,str,str,str,str,str,str,str,str,str,str,str,na");

	<c:if test="${sysConf['mail.use.auth.at'] eq 'Y'}">
		myGrid.setHeader("번호,아이디,성명,권한,권한코드,대상,대상ID,대상소속,권한부여일자,이메일,전화번호,비고,알림,등록자ID,수정자ID",null,grid_head_center_bold);
		myGrid.setColumnIds("no,userId,korNm,adminDvsCdNm,adminDvsCd,workTrgetNm,workTrget,workTrgetDept,authorAlwncDate,emailAdres,telno,mngrResnCn,notice,regUserId,modUserId");
		myGrid.setInitWidths("50,80,120,80,1,150,80,130,150,150,130,*,80,1,1");
		myGrid.setColAlign("center,center,center,left,left,left,center,center,center,center,left,center,center,center");
		myGrid.setColTypes("ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,co,ro,ro,ro");
		myGrid.setColSorting("int,str,str,str,str,str,str,str,str,str,str,str,str,str,na");
	</c:if>

	myGrid.setImagePath("${dhtmlXImagePath}");
	myGrid.enablePaging(true,100,10,"pagingArea",true);
	myGrid.setPagingSkin("${dhtmlXPagingSkin}");
	myGrid.setColumnHidden(myGrid.getColIndexById("adminDvsCd"),true);
	myGrid.setColumnHidden(myGrid.getColIndexById("password"),true);
	myGrid.setColumnHidden(myGrid.getColIndexById("regUserId"),true);
	myGrid.setColumnHidden(myGrid.getColIndexById("modUserId"),true);
	//myGrid.enableMultiselect(true);
	myGrid.attachEvent("onRowDblClicked", myGrid_onRowSelect);
	myGrid.attachEvent("onBeforeSorting", myGrid_onBeforeSorting);
	myGrid.attachEvent("onXLS", doBeforeGridLoad);
	myGrid.attachEvent("onXLE", doOnGridLoaded);
	myGrid.init();

	myDp = new dataProcessor("${contextPath}/member/authCUD.do");
	myDp.init(myGrid);
	myDp.setTransactionMode("POST",false);
	myDp.setUpdateMode("off"); //
	myDp.enableDataNames(true);
	myDp.setVerificator(myGrid.getColIndexById("userId"), authGrid_not_empty);
	myDp.setVerificator(myGrid.getColIndexById("adminDvsCd"), authGrid_not_empty);
	myDp.attachEvent("onValidatationError", function(id, messages) {
		alert(messages.join("\n"));
		return true;
	});

	myGrid_load();

});
// update authority
function myGrid_onRowSelect(rowID,celInd){
	if(rowID == '0') return;

	var wWidth = 970;
	var wHeight = 822;
	var leftPos = (screenWidth - wWidth)/2;
	var topPos = (screenHeight - wHeight)/2;

	var str = rowID.split('_');
	var mappingPopup = window.open('about:blank', 'updateAuthorityPopup', 'width='+wWidth+'px,height='+wHeight+'px,top='+topPos+',left='+leftPos+' location=no,scrollbars=yes,resizable=yes');
	var popFrm = $('#popFrm');
	popFrm.empty();
	popFrm.append($('<input type="hidden" name="trgetUserId" value="'+str[0]+'"/>'));
	popFrm.append($('<input type="hidden" name="trgetAuthorId" value="'+str[1]+'"/>'));
	popFrm.append($('<input type="hidden" name="mode" value="update"/>'));
	popFrm.attr('action', '${contextPath}/member/authorPopup.do');
	popFrm.attr('target', 'updateAuthorityPopup');
	popFrm.attr('method', 'POST');
	popFrm.submit();
	mappingPopup.focus();
}
// add authority
function addMemberPopup(){
	var wWidth = 970;
	var wHeight = 822;
	var leftPos = (screenWidth - wWidth)/2;
	var topPos = (screenHeight - wHeight)/2;
	var mappingPopup = window.open('about:blank', 'addAuthorityPopup', 'width='+wWidth+'px,height='+wHeight+'px,top='+topPos+',left='+leftPos+' location=no,scrollbars=yes,resizable=yes');
	var popFrm = $('#popFrm');
	popFrm.empty();
	popFrm.append($('<input type="hidden" name="trgetUserId" value=""/>'));
	popFrm.append($('<input type="hidden" name="trgetAuthorId" value=""/>'));
	popFrm.append($('<input type="hidden" name="mode" value="add"/>'));
	popFrm.attr('action', '${contextPath}/member/authorPopup.do');
	popFrm.attr('target', 'addAuthorityPopup');
	popFrm.attr('method', 'POST');
	popFrm.submit();
	mappingPopup.focus();
}

function myGrid_load(){
	var url = getGridRequestURL();
	myGrid.clearAndLoad(url, doOnGridLoaded);
}

function myGrid_onBeforeSorting(ind,type,direct){
	var url = getGridRequestURL();
	myGrid.clearAndLoad(url+"&orderby="+(myGrid.getColumnId(ind))+"&direct="+direct);
	myGrid.setSortImgState(true,ind,direct);
	return false;
}

function getGridRequestURL(){
	var url = "${contextPath}/member/findMemberList.do?"+$('#formArea').serialize();
	return url;
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
						}
					}
				});
			}
		}
	});
}

function authGrid_not_empty(value, id, ind) {
    if (value == "") return "Value at (" + id + ", " + ind + ") can't be empty";
    return true;
}

function toExcel(){
	myGrid.toExcel('${contextPath}/servlet/xlsGenerate.do?file_name=Authority_List.xls');
}

var dhxMailWins, mailWin;
function sendMailAuth(authId){

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
    mailWin.attachURL(contextpath+"/mail/mailForm.do?rsltSe=AUTHORITY&itemId="+authId);
}

function unloadDhxMailWins(){
    if(dhxMailWins != null && dhxMailWins.unload != null)
    {
        dhxMailWins.unload();
        dhxMailWins = null;
    }
}
function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){ dhxLayout.setSizes(false); },200);}
function doOnGridLoaded(){setTimeout(function() {dhxLayout.cells("a").progressOff();}, 100);}
function doBeforeGridLoad(){dhxLayout.cells("a").progressOn();}
</script>
</head>
<body>
	<!-- Page Title -->
	<div class="title_box">
		<h3><spring:message code='menu.authority'/></h3>
	</div>
	<!-- Main Content -->
	<div class="contents_box">

		<form id="formArea" >
			<input type="hidden" name="srchStatus" value="Y"/>
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
					<td><input type="text" id="user_id" name="srchUserId" class="input2" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();" /></td>
					<th>성명</th>
					<td>
						<input type="text" id="userNm" name="srchUserNm" class="typeText" style="width: 98%;" class="input2" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/>
					</td>
					<td rowspan="3" class="option_search_td" onclick="javascript:myGrid_load();"><em>search</em></td>
				</tr>
				<tr>
					<th>권한</th>
					<td colspan="3">
						<input type="radio" id="adminDvsCd_A" name="srchAdminDvsCd" class="radio" value=""  checked="checked" onclick="javascript:myGrid_load();" />
							<label for="adminDvsCd_A" class="radio_label">전체</label>
						<input type="radio" id="adminDvsCd_M" name="srchAdminDvsCd" class="radio" value="M" onclick="javascript:myGrid_load();" />
							<label for="adminDvsCd_M" class="radio_label">관리자</label>
						<input type="radio" id="adminDvsCd_P" name="srchAdminDvsCd" class="radio" value="P" onclick="javascript:myGrid_load();" />
							<label for="adminDvsCd_P" class="radio_label">성과관리자</label>
						<input type="radio" id="adminDvsCd_C" name="srchAdminDvsCd" class="radio" value="C" onclick="javascript:myGrid_load();" />
							<label for="adminDvsCd_C" class="radio_label">단과대학관리자</label>
						<input type="radio" id="adminDvsCd_D" name="srchAdminDvsCd" class="radio" value="D" onclick="javascript:myGrid_load();" />
							<label for="adminDvsCd_D" class="radio_label">학(부)과관리자</label>
						<input type="radio" id="adminDvsCd_T" name="srchAdminDvsCd" class="radio" value="T" onclick="javascript:myGrid_load();" />
							<label for="adminDvsCd_T" class="radio_label">트랙관리자</label>
						<input type="radio" id="adminDvsCd_S" name="srchAdminDvsCd" class="radio" value="S" onclick="javascript:myGrid_load();" />
							<label for="adminDvsCd_S" class="radio_label">대리입력자</label>
						<input type="radio" id="adminDvsCd_V" name="srchAdminDvsCd" class="radio" value="V" onclick="javascript:myGrid_load();" />
							<label for="adminDvsCd_V" class="radio_label">열람자</label>
					</td>
				</tr>
				</tbody>
			</table>
		</form>

		<div class="list_bt_area">
			<div class="list_set">
				<ul>
					<li><a href="#" onclick="javascript:addMemberPopup();" class="list_icon12">추가</a></li>
					<%--
					<li><a href="#" onclick="javascript:save();" class="list_icon02"><spring:message code='common.button.save'/></a></li>
					 --%>
					<li><a href="#" onclick="javascript:cut();" class="list_icon22">삭제</a></li>
					<li><a href="#" onclick="javascript:toExcel();" class="list_icon20">엑셀</a></li>
				</ul>
			</div>
		</div>

		<div id="mainLayout" style="position: relative; width: 100%;height: 100%;"></div>
		<script type="text/javascript">setMainLayoutHeight($('#mainLayout'));</script>
		<div id="pagingObj" style="z-index: 1; height: 60px; margin-top: 5px;" >
			<div id="pagingArea" style="z-index: 1;"></div>
		</div>
	</div>
	<div id="winVp"></div>
</body>
</html>
