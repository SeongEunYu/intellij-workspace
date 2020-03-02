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
var dhxLayout, dhxWins, w1, w1Layout, myGrid, myDp, combo, mgtCombo, t;
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
	myGrid.setHeader("번호,아이디,EMPLID,성명,권한,업무상세,이메일,전화번호,관리여부,비고,패스워드,등록자ID,수정자ID",null,grid_head_center_bold);
	myGrid.setColumnIds("no,userId,cn,korNm,adminDvsCd,workDeptKor,emalAddr,telno,mgtAt,etc,password,regUserId,modUserId");
	myGrid.setImagePath("${dhtmlXImagePath}");
	myGrid.setInitWidths("50,80,80,150,100,*,100,80,70,180,1,1,1");
	myGrid.setColAlign("center,center,center,center,left,left,center,center,center,center,center,center,center");
	myGrid.setColTypes("ro,ro,ro,ro,co,ro,ro,ro,co,ro,ro,ro,ro");
	myGrid.setColSorting("int,str,str,str,str,str,str,str,str,str,na,na,na");
	mgtCombo = myGrid.getCombo(myGrid.getColIndexById("mgtAt"));
	mgtCombo.put("0","No");
	mgtCombo.put("1","Yes");
	mgtCombo.save();
	combo = myGrid.getCombo(myGrid.getColIndexById("adminDvsCd"));
	combo.put("M","관리자");
	combo.put("C","단과대학관라자");
	combo.put("D","학(부)과관리자");
	combo.put("T","트랙관라자");
	combo.put("S","대리입력자");
	combo.put("V","View");
	//combo.put("A","분석서비스");
	combo.save();
	myGrid.setColumnHidden(myGrid.getColIndexById("cn"),true);
	myGrid.setColumnHidden(myGrid.getColIndexById("password"),true);
	myGrid.setColumnHidden(myGrid.getColIndexById("regUserId"),true);
	myGrid.setColumnHidden(myGrid.getColIndexById("modUserId"),true);
	myGrid.enableMultiselect(true);
	myGrid.attachEvent("onRowDblClicked",doOnRowDblClicked);
	myGrid.init();
	myDp = new dataProcessor("${contextPath}/auth/user/authUserCUD.do");
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

function doOnRowDblClicked(id){
	fn_mgtAuth(id);
}

function myGrid_load(){
	var url = "${contextPath}/auth/user/authUserList.do?"+$('#formArea').serialize();;
	myGrid.clearAndLoad(url, doOnGridLoaded);
}

function myGrid_not_empty(value, id, ind) {
    if (value == "") return "Value at (" + id + ", " + ind + ") can't be empty";
    return true;
}

var authModalBox, authFormLayout, authForm, clkBtnString;
function fn_mgtAuth(id){
	var btn = new Array();
	if(id == "")
	{
		btn = ["저장 후 닫기", "저장 후 추가", "취소"];
	}
	else
	{
		btn = ["저장","삭제","취소"];
	}

	authModalBox = dhtmlx.modalbox({
		title: '권한 추가',
	    text: '<div id="authForm" style="width: 450px; height: 345px;"></div>',
	    width: '472px',
	    buttons:btn
	});

	authFormLayout = new dhtmlXLayoutObject({
		parent: 'authForm',
		pattern: '1C',
		skin: '${dhtmlXSkin}',
		cells: [{ id: 'a', header: false }]
	});
	$.ajax({ url: '${contextPath}/auth/user/getAuthUser.do?id=' + id, dataType: 'json' }).done(function(data) {
		var status = (data.auth.id != null && data.auth.id != '') ? 'updated':'inserted';
		var regUserId = (data.auth.regUserId != null && data.auth.regUserId != '') ?  data.auth.regUserId : '${sessionScope.login_user.userId}';
		authForm = authFormLayout.cells('a').attachForm([
	   			{type: 'settings', position: 'label-left', labelWidth: 100, inputWidth: 300},
				{type: 'block', inputWidth: 'auto', offsetTop: 10, list: [
					{type: 'input', label: '성명', name: 'korNm', value: data.auth.korNm, validate: "NotEmpty", required: true, inputWidth: 274},
					{type: "newcolumn"},
					{type: "button", name:"btn_search", value: "", className: "button_search", inputWidth: 5},
					{type: "newcolumn"},
					{type: 'input', label: '아이디', name: 'userId', value: data.auth.userId, validate: "NotEmpty", required: true, className: 'alignLeft', readonly:true},
					{type: 'input', label: 'e-mail', name: 'emalAddr', value: data.auth.emalAddr,className: 'alignLeft', readonly:true},
					{type: 'input', label: '전화번호', name: 'telno', value: data.auth.telno,className: 'alignLeft', readonly:true},
					{type: 'select', label: '권한', name: 'adminDvsCd', value:data.auth.adminDvsCd, validate: "NotEmpty", required: true, options:[
					                                                          {text:'선택하세요',value:''},
					                                                          {text:'관리자',value:'M'},
					                                                          {text:'학(부)과관리자',value:'D'},
					                                                          {text:'단과대학관리자',value:'C'},
					                                                          {text:'대리입력자',value:'S'},
					                                                          {text:'View',value:'V'},
					                                                          {text:'트랙관리자',value:'T'}
					                                                          ]},
					{type: 'select', label: '업무상세', name: 'workUserId', value:data.auth.workUserId, validate: "NotEmpty", required: true, options:[
					                                                          {text:'권한을 먼저 선택하세요',value:''}
					                                                          ]}
		   		]},
		   		{type: 'block', inputWidth: 'auto', offsetTop: 0, offsetLeft: 0, list: [
					{type: 'label', label: '관리여부', name: 'mgt_lable', value: '', inputWidth: 0, className: 'alignLeft'},
					{type: "newcolumn"},
					{type: "radio", label: "Yes", name:'mgtAt', value:'1', position: 'label-right', labelWidth: 50, inputWidth: 50, checked:true},
					{type: "newcolumn"},
					{type: "radio", label: "No", name:'mgtAt', value:'0', position: 'label-right', labelWidth: 50, inputWidth: 50},
					{type: "newcolumn"}
		   		]},
		   		{type: 'block', inputWidth: 'auto', offsetTop: 10, list: [
					{type: 'input', label: '비고', name: 'etc', value: data.auth.etc, rows:3},
					{type: 'hidden', label: 'ID', name: 'gr_id', value: data.auth.id},
					{type: 'hidden', label: 'STATUS', name: '!nativeeditor_status', value: status},
					{type: 'hidden', label: '패스워드', name: 'password', value: data.auth.password},
					{type: 'hidden', label: '업무상세명', name: 'workDeptKor', value: data.auth.workDeptKor},
					{type: 'hidden', label: '등록자ID', name: 'regUserId', value: regUserId},
					{type: 'hidden', label: '등록자ID', name: 'modUserId', value: '${sessionScope.login_user.userId}'}
		   		]}
	    ]);

		if(data.auth.mgtAt != null && data.auth.mgtAt != ''){
			var mgtAt = JSON.stringify(data.auth.mgtAt).substr(1,1);
			authForm.checkItem('mgtAt',mgtAt);
			authForm.setItemValue('mgtAt',mgtAt);
		}
		reloadWorkUserIdSelect(data.auth.adminDvsCd,data.auth.workUserId);

		authForm.attachEvent('onBeforeChange',function(name, old_value, new_value){
			if(name == 'adminDvsCd')
			{
				if(authForm.getItemValue('userId') != null && authForm.getItemValue('userId') != "" )
				{
					return true;
				}
				else
				{
					dhtmlx.alert('권한 부여할 대상을 조회 후 권한 선택 가능합니다.');
					return false;
				}
			}
			else
			{
				return true;
			}
		});

		authForm.attachEvent('onChange',function(name,value){
			if(name == 'adminDvsCd')
			{
				reloadWorkUserIdSelect(value,'');
			}
		});

		authForm.attachEvent('onKeyUp',function(inp, ev, name, value){
			if(ev.keyCode=='13' && name == 'korNm') add();
		});

		authForm.attachEvent('onButtonClick',function(name){
			if(name == 'btn_search')add();
		});

		checkAdminAuthority();

	});

	$('input[name="korNm"]').focus();

	$('.dhtmlx_popup_button').on('click', function(e) {
		clkBtnString = $(this).text();
		if(clkBtnString == '취소') return true;
		else if(clkBtnString == '삭제') cut();
		else {
			var workDeptKor = $('select[name="workUserId"] option:selected').text();
			if(authForm.getItemValue('workUserId') != null && authForm.getItemValue('workUserId') != '')
				authForm.setItemValue('workDeptKor',workDeptKor);
			authForm.validate();
			authForm.send("${contextPath}/auth/user/authUserCUD.do", "post", function() {
				dhtmlx.modalbox.hide(authModalBox);
				myGrid_load();
				if(clkBtnString == '저장 후 추가') fn_mgtAuth('');
				else dhtmlx.alert('저장 되었습니다.');
			});

			return false;
		}
	});
}

function checkAdminAuthority(){
	var id  = authForm.getItemValue('gr_id');
	var userId = authForm.getItemValue('userId');
	$.ajax({
		url: "${contextPath}/auth/findIsHasAdminByUserIdAndIdAjax.do",
		dataType: "json",
		data: {"id": id, "userId": userId},
		method: "POST",
		success: function(data){}
	}).done(function(data){
		if(data.isAdmin != null && data.isAdmin == '1')
		{
			$('select[name="adminDvsCd"] option[value="M"]').prop('disabled','disabled').text('관리자 - 권한존재');
		}
		else
		{
			$('select[name="adminDvsCd"] option[value="M"]').removeProp('disabled').text('관리자');
		}
	});
}


function reloadWorkUserIdSelect(adminDvsCd, selectedValue){
	var seletWorkUserId = $('select[name="workUserId"]');
	if(adminDvsCd == 'M')
	{
		seletWorkUserId.empty().append($('<option value="">업무상세 필요없음</option>'));
		authForm.setRequired('workUserId',false);
	}
	else if (adminDvsCd == '')
	{
		seletWorkUserId.empty().append($('<option value="">권한을 먼저 선택하세요</option>'));
		authForm.setRequired('workUserId',true);
	}
	else
	{
		authForm.setRequired('workUserId',true);
		$.ajax({
			url: "${contextPath}/auth/findWorkDeptOpetionsAjax.do",
			dataType: "json",
			data: {"adminDvsCd": adminDvsCd, "userId": authForm.getItemValue('userId')},
			method: "POST",
			success: function(data){}
		}).done(function(data){
			seletWorkUserId.empty().append($('<option value="">업무상세를 선택하세요</option>'));
			for(var i=0; i < data.length;i++)
			{
				if(data[i].isUsed == '1' && selectedValue != data[i].codeValue)
				{
					seletWorkUserId.append($('<option value="'+data[i].codeValue+'" disabled="disabled">'+data[i].codeDisp+' - 권한존재</option>'))
				}
				else
				{
					seletWorkUserId.append($('<option value="'+data[i].codeValue+'">'+data[i].codeDisp+'</option>'))
				}
			}
		});
	}
	setTimeout(function() {authForm.setItemValue('workUserId',selectedValue);}, 250);
}

var w1Toolbar, w1Grid;
function add(){

	dhtmlx.modalbox.hide(authModalBox);

	var pageX = Math.max(0, (($(window).width() - 550) / 2) + $(window).scrollLeft());
	var pageY = Math.max(0, (($(window).height() - 350) / 2) + $(window).scrollTop());

	if(dhxWins != null && dhxWins.unload != null)
	{
		dhxWins.unload();
		dhxWins = null;
	}

	dhxWins = new dhtmlXWindows({
		viewport : {objec : 'windVP'},
		wins : [ {id : 'w1', left : pageX, top : pageY, width: 600, height: 450, text: "관리자검색", resize : false} ]
	});
	dhxWins.window('w1').setModal(true);
	dhxWins.window('w1').attachEvent('onClose',function(){
		dhtmlx.modalbox(authModalBox);
		return true;
	});

	var keyWord = "";
	if(authForm != null) keyWord = authForm.getItemValue('korNm');

	w1Layout = dhxWins.window('w1').attachLayout('2E')
	w1Layout.cells('a').hideHeader();
	w1Layout.cells('b').hideHeader();
	w1Layout.cells("a").setHeight(55);

	w1Toolbar = w1Layout.cells("b").attachToolbar();
	w1Toolbar.setIconsPath("${dhtmlXImagePath}/icons_${sysConf['dhtmlx.skin']}/");
	w1Toolbar.setIconSize(18);
	w1Toolbar.addInput("keyword", 0, keyWord, 515);
	w1Toolbar.addButton("search", 1, "", "search.png", "search.png");
	w1Toolbar.attachEvent("onClick", function(id) {
		if (id == "search"){
			w1Grid.clearAndLoad('${contextPath}/urpUser/findUrpUserList.do?keyword=' + encodeURIComponent(w1Toolbar.getValue('keyword')));
		}
	});
	w1Toolbar.attachEvent("onEnter", function(id,value) {
		if(value == "")
		{
			dhtmlx.alert({type:"alert-warning",text:"검색어를 입력하세요.",callback:function(){}})
		}
		else
		{
			w1Grid.clearAndLoad('${contextPath}/urpUser/findUrpUserList.do?keyword=' + encodeURIComponent(w1Toolbar.getValue('keyword')));
		}
    });

	w1Grid = w1Layout.cells("b").attachGrid();
	w1Grid.setImagePath("${dhtmlXImagePath}");
	w1Grid.setHeader('');
	w1Grid.setHeader("사번,이름,부서명,직급,이메일", null, grid_head_center_bold);
	w1Grid.setInitWidths("70,100,*,110,130");
	w1Grid.setColAlign("center,center,left,center,center");
	w1Grid.setColTypes("ro,ro,ro,ro,ro");
	w1Grid.setColSorting("str,str,str,str,str");
	w1Grid.attachEvent("onXLS", function() {
		w1Layout.cells("a").progressOn();
	 });
	w1Grid.attachEvent("onXLE", function() {
		w1Layout.cells("a").progressOff();
	 });
	w1Grid.attachEvent('onRowSelect', doOnRowSelectedAuth);
	w1Grid.init();
	$('.dhxtoolbar_input').focus();
	if (w1Toolbar.getValue('keyword') != "") w1Grid.clearAndLoad('${contextPath}/urpUser/findUrpUserList.do?keyword=' + encodeURIComponent(w1Toolbar.getValue('keyword')));

}

function doOnRowSelectedAuth(id){
	var perno = w1Grid.cells(w1Grid.getSelectedId(),0).getValue();
	var nm = w1Grid.cells(w1Grid.getSelectedId(),1).getValue();
	var dept = w1Grid.cells(w1Grid.getSelectedId(),2).getValue();
	var email = w1Grid.cells(w1Grid.getSelectedId(),4).getValue();

	authForm.setItemValue('korNm', nm);
	authForm.setItemValue('userId',perno);
	authForm.setItemValue('emalAddr',email);

	dhxWins.window('w1').close();
	checkAdminAuthority();
	dhtmlx.modalbox(authModalBox);
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
				myGrid.deleteSelectedRows();
				myDp.sendData();
			}
		}
	});
}

function toExcel(){
	myGrid.toExcel('${contextPath}/servlet/xlsGenerate.do?file_name=Authority_List.xls');
}

function loadWorkDpetKorFilter(adminDvsCd){
	if(adminDvsCd == '')
	{
		$('select[id="workDeptKorFilter"] option').css('display','').eq(0).prop('selected','selected');
	}
	else if(adminDvsCd == 'M')
	{
		$('select[id="workDeptKorFilter"] option').css('display','none').eq(0).css('display','').prop('selected','selected');
	}
	else
	{
		$.ajax({
			url: "${contextPath}/auth/findWorkDeptOpetionsAjax.do",
			dataType: "json",
			data: {"adminDvsCd": adminDvsCd, "userId": ''},
			method: "POST",
			success: function(data){}
		}).done(function(data){
			$('select[id="workDeptKorFilter"] option').css('display','none').eq(0).css('display','').prop('selected','selected');
			for(var i=0; i < data.length;i++)
			{
				$('select[id="workDeptKorFilter"] option[value="'+data[i].codeDisp+'"]').css('display','');
			}
		});
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
						<input type="text" id="userNm" name="userNm" class="typeText" style="width: 98%;" class="input2" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/>
					</td>
					<td rowspan="3" class="option_search_td" onclick="javascript:myGrid_load();"><em>search</em></td>
				</tr>
				<tr>
					<th>업무상세</th>
					<td>
						<select name="workDeptKor" id="workDeptKorFilter" onchange="myGrid_load();">
							<option value="">전체</option>
							<c:forEach items="${workDeptList}" var="wl" varStatus="idx">
								<option value="${wl.workDeptKor}">${wl.workDeptKor}</option>
							</c:forEach>
						</select>
					</td>
					<th>등록방법</th>
					<td>
						<input type="radio" id="registerSeA" name="registerSe" class="radio" value=""  onclick="myGrid_load();"/>
							<label for="" class="radio_label">전체</label>
						<input type="radio" id="registerSeD" name="registerSe" class="radio" value="DIRECT" checked="checked" onclick="myGrid_load();" />
							<label for="" class="radio_label">직접입력</label>
						<input type="radio" id="registerSeS" name="registerSe" class="radio" value="CNTC" onclick="myGrid_load();" />
							<label for="" class="radio_label">연계입력</label>
					</td>
				</tr>
				<tr>
					<th>권한</th>
					<td colspan="3">
						<input type="radio" id="adminDvsCd_A" name="adminDvsCd" class="radio" value=""  checked="checked" onclick="javascript:loadWorkDpetKorFilter('');myGrid_load();" />
							<label for="" class="radio_label">전체</label>
						<input type="radio" id="adminDvsCd_M" name="adminDvsCd" class="radio" value="M" onclick="javascript:loadWorkDpetKorFilter('M');myGrid_load();" />
							<label for="" class="radio_label">관리자</label>
						<input type="radio" id="adminDvsCd_C" name="adminDvsCd" class="radio" value="C" onclick="javascript:loadWorkDpetKorFilter('C');myGrid_load();" />
							<label for="" class="radio_label">단과대학관리자</label>
						<input type="radio" id="adminDvsCd_D" name="adminDvsCd" class="radio" value="D" onclick="javascript:loadWorkDpetKorFilter('D');myGrid_load();" />
							<label for="" class="radio_label">학(부)과관리자</label>
						<input type="radio" id="adminDvsCd_T" name="adminDvsCd" class="radio" value="T" onclick="javascript:loadWorkDpetKorFilter('T');myGrid_load();" />
							<label for="" class="radio_label">트랙관리자</label>
					</td>
				</tr>
				</tbody>
			</table>
		</form>

		<div class="list_bt_area">
			<div class="list_set">
				<ul>
					<li><a href="#" onclick="javascript:fn_mgtAuth('');" class="list_icon12">추가</a></li>
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
</body>
</html>
