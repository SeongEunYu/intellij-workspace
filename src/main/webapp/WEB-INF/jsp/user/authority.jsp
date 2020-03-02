<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="cache-Control" content="co-cache" />
<title>${sysConf['system.rims.jsp.title']}</title>
<%@include file="../pageInit.jsp" %>
<script type="text/javascript">
 var mode = '${param.mode}';
 </script>
<link type="text/css" href="<c:url value="/css/layout.css"/>" rel="stylesheet" />
<link type="text/css" href="<c:url value="/js/dhtmlx/skins/${sysConf['dhtmlx.skin']}/dhtmlx.css"/>" rel="stylesheet" />
<link type="text/css" href="<c:url value="/css/jquery/ui.switchbutton.min.css"/>" rel="stylesheet" />
<style type="text/css">
.dhxwins_vp_dhx_terrace {overflow: auto;} .dhx_toolbar_dhx_terrace { padding: 0 0px; }
.dhxwins_vp_dhx_terrace div.dhxwin_active div.dhx_cell_wins div.dhx_cell_toolbar_def, .dhxwins_vp_dhx_terrace div.dhxwin_inactive div.dhx_cell_wins div.dhx_cell_toolbar_def { padding: 10px 0px 0; }
div.dhxform_item_label_left.button_search div.dhxform_btn { height: 25px; margin: 0px 2px; background-color: #ffffff;}
div.dhxform_item_label_left.button_search div.dhxform_btn_txt { top:0;right:0;background: url(${contextPath}/images/background/tbl_search_icon.png) no-repeat 50% 50%; text-indent: -9999px;display: block;width: 23px; height: 25px;margin: 0 0px;}
.alignLeft{text-align: left;} .alignLeft div.dhxform_txt_label2{font-weight: normal;}
.write_tbl tbody td { padding: 3px 10px; border-bottom: 1px solid #ddd; }
.ui-switchbutton-default label{font-size: 11px;font-family: Nanum Gothic, 나눔고딕, Malgun Gothic,맑은 고딕, Verdana,Arial, '돋움', Dotum;}
</style>
<script type="text/javascript" src="<c:url value="/js/jquery/jquery-1.11.3.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jquery/jquery-ui.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jquery/jquery.tmpl.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jquery/jquery.switchbutton.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/dhtmlx/dhtmlx.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/script.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/mainLayout.js"/>"></script>
<script type="text/javascript">
var dhxLayout, dhxWins, w1, w1Layout, memberToolbar, authGrid, authDp, authToolbar, myGrid, myDp, statusCombo, t, detailToolbar, authMoldalBox, authFormLayout, authForm, savedMember;
var rsltProperty = new Array("article","conference","book","funding","patent","techtrans","exhibition","career","degree","award","license","rsrchrealm","lecture","student","report","etc","activity");
$(document).ready(function(){
	if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
	else  window.addEventListener("resize",resizeLayout, false);
	dhxLayout = new dhtmlXLayoutObject("mainLayout","3E");
	dhxLayout.setSizes(false);
	dhxLayout.cells("a").setText("계정정보");
	dhxLayout.cells("a").setHeight("189");
	dhxLayout.cells("b").setText("권한리스트");
	dhxLayout.cells("b").setHeight("203");
	dhxLayout.cells("c").setText("권한상세");
	dhxLayout.cells("c").hideArrow();
	loadMemberComponent();
	loadAuthorityComponent();
	loadAuthDetailComponent();

	if(mode === 'add') savedMember = false;
	else savedMember = true;
});
// 계정정보 로딩
function loadMemberComponent(){
	memberToolbar = dhxLayout.cells("a").attachToolbar();
	memberToolbar.setIconsPath("${dhtmlXImagePath}/icons_${sysConf['dhtmlx.skin']}/");
	memberToolbar.setIconSize(18);
	memberToolbar.setAlign("right");
	memberToolbar.addButton("save", 1, "계정저장", "save.gif", "save_dis.gif");
	memberToolbar.attachEvent('onClick',function(id){
		if(id == 'save')
		{
			saveMember();
		}
	});
	dhxLayout.cells("a").appendObject("memberInfoDiv");
}

function saveMember(){
	dhtmlx.confirm({
		type:"confirm-warning",
		title:"계정 저장",
		text:"계정정보를 저장하시겠습니까?",
		ok:"저장", cancel:"취소",
		callback:function(result){
			if(result == true){
				var url = '<c:url value="/member/modifyMember.do"/>';
				if(mode == 'add') url = '<c:url value="/member/addMember.do"/>';
				url += "?"+ $('#memberFrm').serialize()
				$.get(url, null, null, 'json').done(function(data){
					dhtmlx.alert('저장되었습니다.');
					if(data.status == 'saved') savedMember = true;
				});
			}
		}
	});
}


//권한정보 로딩
function loadAuthorityComponent(){
	authToolbar = dhxLayout.cells("b").attachToolbar();
	authToolbar.setIconsPath("${dhtmlXImagePath}/icons_${sysConf['dhtmlx.skin']}/");
	authToolbar.setIconSize(18);
	authToolbar.setAlign("right");
	authToolbar.addButton("add", 1, "권한추가", "new.gif", "new_dis.gif");
	authToolbar.addButton("save", 2, "권한저장", "save.gif", "save_dis.gif");
	authToolbar.addButton("del", 3, "권한삭제", "del.png", "del.png");
	authToolbar.attachEvent("onClick",function(id){
		if(id == "add") //권한추가
		{
			addAuthority();
		}
		else if(id == "save") //권한삭제
		{
			updateAutority();
		}
		else if(id == "del") //권한삭제
		{
			deleteAutority();
		}
	});
	authGrid = dhxLayout.cells("b").attachGrid();
	authGrid.setImagePath("${dhtmlXImagePath}");
	authGrid.setHeader('No,사번,권한구분,권한코드,대상,권한상태,부여/회수일자,비고,수정자ID,대상식별자',null,grid_head_center_bold);
	authGrid.setColumnIds("no,userId,adminDvsCdNm,adminDvsCd,workTrgetNm,authorStatus,date,mngrResnCn,modUserId,workTrget");
	authGrid.setInitWidths("70,0,150,1,200,100,100,*,0,0");
	authGrid.setColAlign("center,center,left,left,left,center,center,left,center,center");
	authGrid.setColTypes("ro,ro,ro,ro,ro,co,ro,edtxt,ro,ro");
	authGrid.setColSorting("na,str,str,na,str,str,str,str,str,str");
	statusCombo = authGrid.getCombo(authGrid.getColIndexById("authorStatus"));
	statusCombo.put("A","요청");
	statusCombo.put("Y","승인완료");
	statusCombo.put("R","거절");
	statusCombo.put("F","상실");
	statusCombo.save();
	authGrid.setEditable(true);
	authGrid.enableEditEvents(true,true,true);
	authGrid.attachEvent("onRowSelect",authGrid_onRowSelect);
	authGrid.attachEvent("onPageChanged",doBeforeGridLoad);
	authGrid.attachEvent("onPaging",doOnGridLoaded);
	authGrid.setColumnHidden(authGrid.getColIndexById("userId"),true);
	authGrid.setColumnHidden(authGrid.getColIndexById("workTrget"),true);
	authGrid.setColumnHidden(authGrid.getColIndexById("modUserId"),true);
	authGrid.setColumnHidden(authGrid.getColIndexById("adminDvsCd"),true);
	authGrid.init();

	authDp = new dataProcessor("<c:url value="/member/authCUD.do"/>");
	authDp.init(authGrid);
	authDp.setTransactionMode("POST",false);
	authDp.setUpdateMode("off"); //
	authDp.enableDataNames(true);
	authDp.setVerificator(authGrid.getColIndexById("userId"), authGrid_not_empty);
	authDp.setVerificator(authGrid.getColIndexById("adminDvsCd"), authGrid_not_empty);
	authDp.attachEvent("onValidatationError", function(id, messages) {
		alert(messages.join("\n"));
		return true;
	});
	authDp.attachEvent("onAfterUpdate", function(id, action, tid, response) {
		authGrid_load();
		return true;
	});

	authGrid_load();
}
//세부권한정보 로딩
function loadAuthDetailComponent(){
	detailToolbar = dhxLayout.cells("c").attachToolbar();
	detailToolbar.setIconsPath("${dhtmlXImagePath}/icons_${sysConf['dhtmlx.skin']}/");
	detailToolbar.setIconSize(18);
	detailToolbar.setAlign("right");
	detailToolbar.addButton("select", 1, "전체선택", "complete.png", "complete.png");
	detailToolbar.addButton("release", 2, "전체해제", "release.png", "release.png");
	detailToolbar.addSeparator("sep1", 3);
	detailToolbar.addButton("write", 4, "전체입력", "manage.png", "manage.png");
	detailToolbar.addButton("read", 5, "전체열람", "not_manage.png", "not_manage.png");
	for(var i=6; i < 47; i++) detailToolbar.addSeparator("sep"+i, i+1);
	detailToolbar.addButton("save", 50, "상세저장", "save.gif", "save_dis.gif");
	dhxLayout.cells("c").appendObject("authorDetailDiv");

	detailToolbar.attachEvent("onClick",function(id){

		var authAdminDvsCd = authGrid.cells(authGrid.getSelectedRowId(),authGrid.getColIndexById("adminDvsCd")).getValue();

		if(id == "save") //세부권한 저장
		{
			var url = '<c:url value="/member/updateAuthorDetailAjax.do?"/>' + $('#detailFrm').serialize();
			$.get( url, null, null, 'json').done(function(data){
				if(data.result == "001")
				{
					authGrid_onRowSelect(authGrid.getSelectedRowId(), null);
					dhtmlx.alert('성공적으로 저장하였습니다.');
				}
				else
				{
					dhtmlx.alert('저장하는 중에 오류가 발생하였습니다.');
				}
			});
		}
		else if(id == 'select')
		{
			$('.authCheckbox').prop('checked',false).trigger('click');
			if( authAdminDvsCd == 'S')
				$('.writeCheckbox').prop('checked',false).trigger('click');

		}
		else if(id == 'release')
		{
			$('.authCheckbox').prop('checked',true).trigger('click');
		}
		else if(id == 'write')
		{
			$('.writeCheckbox').prop('checked',false).trigger('click');
		}
		else if(id == 'read')
		{
			$('.writeCheckbox').prop('checked',true).trigger('click');
		}
	});
}

function authGrid_not_empty(value, id, ind) {
    if (value == "") return "Value at (" + id + ", " + ind + ") can't be empty";
    return true;
}

function authGrid_load(){
	var url = "<c:url value="/member/findMemberAuthorityList.do?"/>"+$('#formArea').serialize();
	authGrid.clearAndLoad(url, authGrid_selectedRow);
}

var authGridSelectedRow = "${member.userId}_${param.trgetAuthorId}";
function authGrid_selectedRow(){
	var rowIndex = 0;
	if(authGridSelectedRow != null && authGridSelectedRow != '_')
		rowIndex = authGrid.getRowIndex(authGridSelectedRow);
	authGrid.selectRow(rowIndex,true,false,true);
	doOnGridLoaded();
	if(authGrid.getRowsNum() > 0)  savedMember = true;
}

function authGrid_onRowSelect(rowId, celInd){
	var trgetAdminDvsCd = authGrid.cells(rowId,authGrid.getColIndexById("adminDvsCd")).getValue();
	var str = rowId.split('_');
	$('#authorDetailBody').empty();
	$.post( '<c:url value="/member/findMemberAuthorityDetailListAjax.do"/>', {"trgetAutorId" : str[1] }, null, 'json').done(function(data){
	    $('#detailAuthorId').val(str[1]);
		var $tr = $('<tr></tr>');
		var appendCnt = 0;
		for(var i=0; i < data.length; i++)
		{
			if((trgetAdminDvsCd == 'M' || trgetAdminDvsCd == 'P')
				|| ( trgetAdminDvsCd != 'M' && trgetAdminDvsCd != 'P' && rsltProperty.indexOf(data[i].property) != -1 ))
			{
				var authAt_checked = data[i].mgtLvl > '0' ? 'checked="checked"' : '';
				var writeAt_checked = data[i].mgtLvl > '1' ? 'checked="checked"' : '';
				var writeAt_disabled = data[i].mgtLvl > '0' ? '' : 'disabled="disabled"';
				var tdLine = (i+1) % 3 != 0 ? 'border-right: 1px solid #ddd;' : '';
				$tr.append($('<td style="text-align:center;"></td>').append('<input type="hidden" name="seqNo" value="'+data[i].seqNo+'"/>').append('<input type="hidden" name="mgtLvl" id="mgtLvl_'+i+'" value="'+data[i].mgtLvl+'"/>').append('<input type="checkbox" class="authCheckbox" name="authAt" id="authAt_'+i+'" '+authAt_checked+' />'));
				$tr.append('<td><input type="hidden" name="mgtTrget" value="'+data[i].mgtTrget+'"/><input type="hidden" name="mgtTrgetNm" value="'+data[i].mgtTrgetNm+'"/>'+data[i].mgtTrgetNm+'</td>');
				$tr.append('<td style="text-align:center;'+tdLine+'"><input type="checkbox" class="writeCheckbox" name="writeAt" id="writeAt_'+i+'" '+writeAt_checked+' '+writeAt_disabled+' /></td>');

				if(trgetAdminDvsCd != 'M' && trgetAdminDvsCd != 'P')
				{
					if( (appendCnt+1) % 3 == 0 || appendCnt == (rsltProperty.length -1) )
					{
						$('#authorDetailBody').append($tr);
						$tr = $('<tr></tr>');
					}
				}
				else
				{
					if( (i+1) % 3 == 0 || i == (data.length -1) )
					{
						$('#authorDetailBody').append($tr);
						$tr = $('<tr></tr>');
					}
				}
				appendCnt++;
			}
		}
		$('.authCheckbox').click(function(){
			var index = $(this).prop('id').split('_')[1];
			if($(this).prop("checked"))
			{
				$('#mgtLvl_'+index).val('1');
				$('#writeAt_'+index).switchbutton('enable');
			}
			else
			{
				$('#writeAt_'+index).prop('checked',false).change();
				$('#writeAt_'+index).switchbutton('disable');
				$('#mgtLvl_'+index).val('0');
			}
		});

		$('.writeCheckbox')
		.switchbutton({
			classes: 'ui-switchbutton-thin',
			checkedLabel: '입력',
			uncheckedLabel: '열람'
		})
		.change(function(){
			var index = $(this).prop('id').split('_')[1];
			if($(this).prop('checked'))
			{
				$('#mgtLvl_'+index).val('2');
			}
			else
			{
				$('#mgtLvl_'+index).val('1');
			}
		});
	});
}

function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){ dhxLayout.setSizes(false); },200);}
function doOnGridLoaded(){setTimeout(function() {dhxLayout.cells("b").progressOff();}, 100);}
function doBeforeGridLoad(){dhxLayout.cells("b").progressOn();}

//권한삭제
function deleteAutority(){

	if(authGrid.getSelectedRowId() == null)
	{
		dhtmlx.alert('삭제할 권한을 선택하세요.');
		return false;
	}

	authGridSelectedRow = authGrid.getSelectedRowId();
	dhtmlx.confirm({
		type:"confirm-warning",
		title:"권한 삭제",
		text:"선택하신 권한을 삭제하시겠습니까?",
		ok:"삭제", cancel:"취소",
		callback:function(result){
			if(result == true){
				var mngrResnCn = authGrid.cells(authGridSelectedRow,authGrid.getColIndexById("mngrResnCn")).getValue();
				var reasonBox = dhtmlx.modalbox({
					title: '상실 사유 (비고란에 추가)',
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

							authGrid.cells(authGridSelectedRow,authGrid.getColIndexById("mngrResnCn")).setValue(mngrResnCn);
							authGrid.deleteSelectedRows();
							$('#authorDetailBody').empty();
							authDp.sendData();
						}
					}
				});
			}
		}
	});

}

function updateAutority(){
	authGridSelectedRow = authGrid.getSelectedRowId();
	dhtmlx.confirm({
		type:"confirm-warning",
		title:"권한 저장",
		text:"수정된 권한을 저장하시겠습니까?",
		ok:"저장", cancel:"취소",
		callback:function(result){
			if(result == true){
				authDp.sendData();
			}
		}
	});
}

//권한추가
function addAuthority(){
	if(savedMember)
	{
		var btn = new Array();
		btn = ["저장","취소"];
		//create modalbox
		authModalBox = dhtmlx.modalbox({
			title: '권한 추가',
		    text: '<div id="authForm" style="width: 450px; height: 250px;"></div>',
		    width: '472px',
		    buttons:btn
		});
		//attach layout to modalbox
		authFormLayout = new dhtmlXLayoutObject({
			parent: 'authForm',
			pattern: '1C',
			skin: '${dhtmlXSkin}',
			cells: [{ id: 'a', header: false }]
		});
		//load formdata
		loadFormData('');
	}
	else
	{
		dhtmlx.alert({type:'alert-warning',text:'계정정보 추가 후 저장해야 <br/>권한을 추가할 수 있습니다.',callback:function(){}});
		return;
	}
}
var authDetailLayout;
function loadFormData(trgetAuthorId){

	$.ajax({ url: '<c:url value="/member/getMemberAuth.do?trgetAuthorId="/>'+trgetAuthorId, dataType: 'json' }).done(function(data) {
		var status = (data.authorId != null && data.authorId != '') ? 'updated':'inserted';
		var regUserId = (data.regUserId != null && data.regUserId != '') ?  data.regUserId : '${sessionScope.login_user.userId}';
		authForm = authFormLayout.cells('a').attachForm([
	   			{type: 'settings', position: 'label-left', labelWidth: 100, inputWidth: 300},
				{type: 'block', name:'authBlock', inputWidth: 'auto', offsetTop: 10, list: [
					{type: 'select', label: '권한', name: 'adminDvsCd', value:data.adminDvsCd, validate: "NotEmpty", required: true, options:[
					                                                          {text:'선택하세요',value:''},
					                                                          {text:'관리자',value:'M'},
					                                                          {text:'성과관리자',value:'P'},
					                                                          {text:'단과대학관리자',value:'C'},
					                                                          {text:'학(부)과관리자',value:'D'},
					                                                          {text:'트랙관리자',value:'T'},
					                                                          {text:'대리입력자',value:'S'},
					                                                          {text:'열람자',value:'V'}
					                                                          ]}
		   		]},
		   		{type: 'block', name:'trgetBlock', inputWidth: 'auto', offsetTop: 10, list: [
					{type: 'select', label: '대상', name: 'workTrgetSelect', value:data.workTrget, validate: "NotEmpty", required: true, options:[
					                                                          {text:'권한을 먼저 선택하세요',value:''}
					                                                          ]}
		   		]},
		   		{type: 'block', name:'rschrBlock', inputWidth: 'auto', offsetTop: 10, list: [
					{type: 'input', label: '대상', name: 'workTrgetInput', value: '', validate: "NotEmpty", required: false, inputWidth: 270},
					{type: "newcolumn"},
					{type: "button", name:"btn_search", value: "", className: "button_search", inputWidth: 5}
		   		]},
		   		{type: 'block', name:'statusBlock', inputWidth: 'auto', offsetTop: 10, list: [
					{type: 'select', label: '권한상태', name: 'authorStatus', value: data.authorStatus, validate: "NotEmpty", required: true, options:[
                                                    				                                                      {text:'선택하세요',value:''},
                                               					                                                          {text:'요청',value:'A'},
                                               					                                                          {text:'승인완료',value:'Y'},
                                               					                                                          {text:'거절',value:'R'},
                                               					                                                          {text:'상실',value:'F'}
                                                                                                                           ]}
		   		]},
		   		{type: 'block', inputWidth: 'auto', offsetTop: 10, list: [
					{type: 'input', label: '비고', name: 'mngrResnCn', value: data.mngrResnCn, rows:4},
					{type: 'hidden', label: 'ID', name: 'gr_id', value: $('#trgetUserId').val() + "_" + data.authorId },
					{type: 'hidden', label: 'userId', name: 'userId', value: $('#trgetUserId').val()},
					{type: 'hidden', label: '성명', name: 'korNm', value: $('#korNm').val()},
					{type: 'hidden', label: 'STATUS', name: '!nativeeditor_status', value: status},
					{type: 'hidden', label: '대상', name: 'workTrget', value: data.workTrget},
					{type: 'hidden', label: '대상명', name: 'workTrgetNm', value: data.workTrgetNm},
					{type: 'hidden', label: '권한명', name: 'adminDvsCdNm', value: data.workTrgetNm},
					{type: 'hidden', label: '등록자ID', name: 'regUserId', value: regUserId},
					{type: 'hidden', label: '등록자ID', name: 'modUserId', value: '${sessionScope.login_user.userId}'}
		   		]},
		   		{type: 'block', name:'detailBlock', inputWidth: 'auto', offsetTop: 10, list: [
					{type: 'container', label: '권한상세', name: 'authDetail', inputHeight: 200 }
		   		]}
		]);

		authForm.hideItem("rschrBlock");
		authForm.hideItem("detailBlock");

		reloadWorkTrget(data.adminDvsCd, data.workTrget);

		authForm.attachEvent('onChange',function(name,value){
			if(name == 'adminDvsCd')
			{
				reloadWorkTrget(value,'');
			}
		});

		authForm.attachEvent('onButtonClick',function(name){
			if(name == 'btn_search') addWorkTrget();
		});

	}); // end ajax

	$('.dhtmlx_popup_button').on('click', function(e) {
		var clkBtnString = $(this).text();
		if(clkBtnString == '취소') return true;
		else if(clkBtnString == '저장')
		{
			var selectedAdminDvsCd = authForm.getItemValue('adminDvsCd');
			if(selectedAdminDvsCd != '')
			{
				var workTrgetNm = $('select[name="workTrgetSelect"] option:selected').text();
				var adminDvsCdNm = $('select[name="adminDvsCd"] option:selected').text();
				if(authForm.getItemValue('workTrgetSelect') != null && authForm.getItemValue('workTrgetSelect') != '')
				{
					authForm.setItemValue('workTrget', authForm.getItemValue('workTrgetSelect'));
					authForm.setItemValue('workTrgetNm', workTrgetNm);
					authForm.setItemValue('adminDvsCdNm', adminDvsCdNm);
				}
			}
			if(authForm.validate()){
				authForm.setItemValue('authDetailString', $('#modalDetailFrm').serialize());
				authForm.send('<c:url value="/member/authCUD.do"/>', "post", function(loader, response){
					var data = eval('('+response+')');
					authGridSelectedRow = $('#trgetUserId').val() + "_" + data.authorId;
					authGrid_load();
					authGrid.selectRow(authGridSelectedRow,true,false,true);
					//dhtmlx.modalbox.hide(authModalBox);
					dhtmlx.alert('저장 되었습니다.');
				});
			}
			else
			{
				return false;
			}
		}
	});
}
var w1Toolbar, w1Grid;
//연구자검색(대리입력자 - 권한대상) 검색
function addWorkTrget(){
	dhtmlx.modalbox.hide(authModalBox);
	var pageX = Math.max(0, (($(window).width() - 550) / 2) + $(window).scrollLeft());
	var pageY = Math.max(0, (($(window).height() - 350) / 2) + $(window).scrollTop());
	if(dhxWins != null && dhxWins.unload != null){ dhxWins.unload(); dhxWins = null; }

	dhxWins = new dhtmlXWindows({
		viewport : {objec : 'windVP'},
		wins : [ {id : 'w1', left : pageX, top : pageY, width: 600, height: 450, text: "연구자검색", resize : false} ]
	});
	dhxWins.window('w1').setModal(true);
	dhxWins.window('w1').attachEvent('onClose',function(){
		dhtmlx.modalbox(authModalBox);
		return true;
	});
	var keyword = "";
	if(authForm != null) keyword = authForm.getItemValue('workTrgetInput');

	w1Layout = dhxWins.window('w1').attachLayout('2E')
	w1Layout.cells('a').hideHeader();
	w1Layout.cells('b').hideHeader();
	w1Layout.cells("a").setHeight(55);
    w1Layout.cells("a").attachURL('<c:url value="/i18n/winhelp/help_findUser.do"/>');
	w1Toolbar = w1Layout.cells("b").attachToolbar();
	w1Toolbar.setIconsPath("${dhtmlXImagePath}/icons_${sysConf['dhtmlx.skin']}/");
	w1Toolbar.setIconSize(18);
	w1Toolbar.addInput("keyword", 0, keyword, 515);
	w1Toolbar.addButton("search", 1, "", "search.png", "search.png");
	w1Toolbar.attachEvent("onClick", function(id) {
		if (id == "search") w1Grid.clearAndLoad('<c:url value="/user/findAuthorListByKeyword.do?keyword="/>' + encodeURIComponent(w1Toolbar.getValue('keyword')));
	});
	w1Toolbar.attachEvent("onEnter", function(id,value) {
		if(value == "") dhtmlx.alert({type:"alert-warning",text:"검색어를 입력하세요.",callback:function(){}})
		else w1Grid.clearAndLoad('<c:url value="/user/findAuthorListByKeyword.do?keyword="/>' + encodeURIComponent(w1Toolbar.getValue('keyword')));
    });
	w1Grid = w1Layout.cells("b").attachGrid();
	w1Grid.setImagePath("${dhtmlXImagePath}");
	w1Grid.setHeader('');
	w1Grid.setHeader("사번,영문성명(ABBR),영문성명(FULL),한글성명,소속", null, grid_head_center_bold);
	w1Grid.setInitWidths("100,120,120,120,*");
	w1Grid.setColAlign("center,center,left,center,center");
	w1Grid.setColTypes("ro,ro,ro,ro,ro");
	w1Grid.setColSorting("str,str,str,str,str");
	w1Grid.attachEvent("onXLS", function() {
		w1Layout.cells("b").progressOn();
	 });
	w1Grid.attachEvent("onXLE", function() {
		w1Layout.cells("b").progressOff();
	 });
	w1Grid.attachEvent('onRowSelect', doOnRowSelectedResearcher);
	w1Grid.init();
	$('.dhxtoolbar_input').focus();
	if (w1Toolbar.getValue('keyword') != "")
		w1Grid.clearAndLoad('<c:url value="/user/findAuthorListByKeyword.do?keyword="/>' + encodeURIComponent(w1Toolbar.getValue('keyword')));
}

function doOnRowSelectedResearcher(id){
	var userId = w1Grid.cells(w1Grid.getSelectedId(),0).getValue();
	var korNm = w1Grid.cells(w1Grid.getSelectedId(),3).getValue();
	authForm.setItemValue('workTrgetInput', korNm + '['+userId+']');
	authForm.setItemValue('workTrgetNm', korNm);
	authForm.setItemValue('workTrget',userId);
	dhxWins.window('w1').close();
	dhtmlx.modalbox(authModalBox);
}
//권한 선택 시 대상정보 셋팅
function reloadWorkTrget(adminDvsCd, selectedValue){
	var selectWorkTrget = $('select[name="workTrgetSelect"]');

	authForm.setItemValue('workTrgetNm', '');
	authForm.setItemValue('workTrget','');

	if(adminDvsCd != 'S')
	{
		authForm.hideItem("rschrBlock");
		authForm.showItem('trgetBlock');
		authForm.setRequired('workTrgetSelect',true);
		authForm.setRequired('workTrgetInput',false);

		if(adminDvsCd == 'M' || adminDvsCd == 'P' || adminDvsCd == 'V')
		{
			selectWorkTrget.empty().append($('<option value="">해당없음</option>'));
			authForm.setRequired('workTrgetSelect',false);
		}
		else if (adminDvsCd == '')
		{
			selectWorkTrget.empty().append($('<option value="">권한을 먼저 선택하세요</option>'));
			authForm.setRequired('workTrgetSelect',true);
		}
		else
		{
			authForm.setRequired('workTrgetSelect',true);
			$.ajax({
				url: "<c:url value="/member/findWorkTrgetOptionsAjax.do"/>",
				dataType: "json",
				data: {"adminDvsCd": adminDvsCd, "trgetUserId": $('#trgetUserId').val()},
				method: "POST"
			}).done(function(data){
				selectWorkTrget.empty().append($('<option value="">대상을 선택하세요</option>'));
				for(var i=0; i < data.length;i++)
				{
					if(data[i].isUsed == '1' && selectedValue != data[i].codeValue)
					{
						selectWorkTrget.append($('<option value="'+data[i].codeValue+'" disabled="disabled">'+data[i].codeDisp+' - 권한존재</option>'))
					}
					else
					{
						selectWorkTrget.append($('<option value="'+data[i].codeValue+'">'+data[i].codeDisp+'</option>'))
					}
				}
			});
		}

	}
	else
	{
		authForm.hideItem("trgetBlock");
		authForm.showItem('rschrBlock');
		authForm.setRequired('workTrgetSelect',false);
		authForm.setRequired('workTrgetInput',true);
	}
	setTimeout(function() {authForm.setItemValue('workTrget',selectedValue);}, 250);
}
// 계정정보 검색(신규 계정 추가)
function addMember(){

	var pageX = Math.max(0, (($(window).width() - 550) / 2) + $(window).scrollLeft());
	var pageY = Math.max(0, (($(window).height() - 350) / 2) + $(window).scrollTop());

	if(dhxWins != null && dhxWins.unload != null)
	{
		dhxWins.unload();
		dhxWins = null;
	}

	dhxWins = new dhtmlXWindows({
		viewport : {objec : 'windVP'},
		wins : [ {id : 'w1', left : pageX, top : pageY, width: 700, height: 450, text: "계정검색", resize : false} ]
	});
	dhxWins.window('w1').setModal(true);

	var keyword = $('#korNm').val();

	w1Layout = dhxWins.window('w1').attachLayout('2E')
	w1Layout.cells('a').hideHeader();
	w1Layout.cells('b').hideHeader();
	w1Layout.cells("a").setHeight(55);
    w1Layout.cells("a").attachURL('<c:url value="/i18n/winhelp/help_findErpUser.do"/>');
	w1Toolbar = w1Layout.cells("b").attachToolbar();
	w1Toolbar.setIconsPath("${dhtmlXImagePath}/icons_${sysConf['dhtmlx.skin']}/");
	w1Toolbar.setIconSize(18);
	w1Toolbar.addInput("keyword", 0, keyword, 615);
	w1Toolbar.addButton("search", 1, "", "search.png", "search.png");
	w1Toolbar.attachEvent("onClick", function(id) {
		if (id == "search"){
			w1Grid.clearAndLoad('<c:url value="/erpUser/findUserList.do?keyword="/>' + encodeURIComponent(w1Toolbar.getValue('keyword')));
		}
	});
	w1Toolbar.attachEvent("onEnter", function(id,value) {
		if(value == "")
		{
			dhtmlx.alert({type:"alert-warning",text:"검색어를 입력하세요.",callback:function(){}})
		}
		else
		{
			w1Grid.clearAndLoad('<c:url value="/erpUser/findUserList.do?keyword="/>' + encodeURIComponent(w1Toolbar.getValue('keyword')));
		}
    });

	w1Grid = w1Layout.cells("b").attachStatusBar({
		text : '<div id="w1Grid_pagingArea"></div>',
		paging : true
	});

	w1Grid = w1Layout.cells("b").attachGrid();
	w1Grid.setImagePath("${dhtmlXImagePath}");
	w1Grid.setHeader("번호,사번,성명(한글),성명(영문),소속,RID,KRI연구자번호,임용일자,E-mail,직급1,직급2,재직,연락처,UID,학번",null,grid_head_center_bold);
	w1Grid.setColumnIds("no,userId,korNm,engNm,deptKor,ridWos,rschrRegNo,aptmDate,emalAddr,grade1,grade2,hldofYn,ofcTelno,userIdntfr,stdntNo");
	w1Grid.setInitWidths("50,80,100,120,*,1,1,1,100,80,1,1,1,1,1");
	w1Grid.setColAlign("center,center,center,center,left,center,center,center,left,center,center,center,left,left,left");
	w1Grid.setColTypes("ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro");
	w1Grid.setColSorting("na,str,str,str,str,str,str,str,str,str,str,na,na,na,na");
	w1Grid.setColumnHidden(w1Grid.getColIndexById("ridWos"),true);
	w1Grid.setColumnHidden(w1Grid.getColIndexById("rschrRegNo"),true);
	w1Grid.setColumnHidden(w1Grid.getColIndexById("aptmDate"),true);
	w1Grid.setColumnHidden(w1Grid.getColIndexById("grade2"),true);
	w1Grid.setColumnHidden(w1Grid.getColIndexById("hldofYn"),true);
	w1Grid.setColumnHidden(w1Grid.getColIndexById("ofcTelno"),true);
	w1Grid.setColumnHidden(w1Grid.getColIndexById("userIdntfr"),true);
	w1Grid.setColumnHidden(w1Grid.getColIndexById("stdntNo"),true);
	w1Grid.attachEvent("onXLS", function() {
		w1Layout.cells("b").progressOn();
	 });
	w1Grid.attachEvent("onXLE", function() {
		w1Layout.cells("b").progressOff();
	 });
	w1Grid.attachEvent('onRowSelect', doOnRowSelectedAuth);
	w1Grid.enablePaging(true,100,10,"w1Grid_pagingArea");
	w1Grid.setPagingSkin("toolbar");
	w1Grid.init();

	$('.dhxtoolbar_input').focus();
	if (w1Toolbar.getValue('keyword') != "") w1Grid.clearAndLoad('<c:url value="/erpUser/findUserList.do?keyword="/>' + encodeURIComponent(w1Toolbar.getValue('keyword')));

}
//계정선택 시 member정보에 입력
function doOnRowSelectedAuth(id){
	savedMember = false;
	var perno = w1Grid.cells(w1Grid.getSelectedId(),w1Grid.getColIndexById("userId")).getValue();
	var nm = w1Grid.cells(w1Grid.getSelectedId(),w1Grid.getColIndexById("korNm")).getValue();
	var engNm = w1Grid.cells(w1Grid.getSelectedId(),w1Grid.getColIndexById("engNm")).getValue();
	var dept = w1Grid.cells(w1Grid.getSelectedId(),w1Grid.getColIndexById("deptKor")).getValue();
	var email = w1Grid.cells(w1Grid.getSelectedId(),w1Grid.getColIndexById("emalAddr")).getValue();
	var ofcTelno = w1Grid.cells(w1Grid.getSelectedId(),w1Grid.getColIndexById("ofcTelno")).getValue();
	var uId = w1Grid.cells(w1Grid.getSelectedId(),w1Grid.getColIndexById("userIdntfr")).getValue();
	var stdntNo = w1Grid.cells(w1Grid.getSelectedId(),w1Grid.getColIndexById("stdntNo")).getValue();

	//authForm.setItemValue('korNm', nm);
	$('#korNm').val(nm);
	$('#engNm').val(engNm);
	$('#userId').val(perno);
	$('#psitnDeptNm').val(dept);
	$('#emailAdres').val(email);
	$('#telno').val(ofcTelno);
	$('#uId').val(uId);
	$('#stdntNo').val(stdntNo);

	$('#authorDetailBody').empty();
	$('#trgetUserId').val(perno);
	 authGrid_load();
	dhxWins.window('w1').close();
	//checkAdminAuthority();
}
</script>
</head>
<body style="overflow-y: auto;">
	<div class="popup_wrap">
	<div class="title_box">
		<h3><spring:message code='menu.authority'/></h3>
	</div>
	<form id="formArea" action="<c:url value="/member/modifyMember.do"/>" method="post">
	   <input type="hidden" name="trgetUserId" id="trgetUserId" value="${member.userId}"/>
	   <input type="hidden" name="trgetAuthorId" id="trgetAuthorId" value="${param.trgetAuthorId}"/>
	   <div id="mainLayout" style="position: relative; width: 100%;height: 100%;"></div>
	</form>
	</div>
	<script type="text/javascript">$('#mainLayout').css('height',($(window).height()-40)+"px");</script>
	<div id="memberInfoDiv" style="display: none;">
		<form name="memberFrm" id="memberFrm">
		<table class="write_tbl">
			<colgroup>
				<col style="width:140px;" />
				<col style="width:326px;" />
				<col style="width:140px" />
				<col/>
			</colgroup>
			<tbody>
				<tr>
					<th>성명(한글)</th>
					<td>
						<c:if test="${param.mode eq 'add'}">
							<div class="r_add_bt">
								<input type="text" id="korNm" name="korNm" class="input_type" value="" onkeydown="if(event.keyCode==13){addMember(event);}"/>
								<a href="javascript:void(0);" onclick="addMember(event);" class="tbl_search_bt">검색</a>
							</div>
						</c:if>
						<c:if test="${param.mode eq 'update'}">
							<span id="spanKorNm">${member.korNm}</span><input type="hidden"  name="korNm" id="korNm" value="${member.korNm}"/>
						</c:if>
					</td>
					<th>성명(영문)</th>
					<td><input type="text" id="engNm" name="engNm" class="input_type" value="${member.engNm}"/></td>
				</tr>
				<tr>
					<th>사번</th>
					<td>
						<c:if test="${param.mode eq 'add'}">
							<input type="text" id="userId" name="userId" class="input_type" value="<c:out value="${member.engNm}"/>"/>
						</c:if>
						<c:if test="${param.mode eq 'update'}">
							<span id="spanUserId">${member.userId}</span><input type="hidden"  name="userId" id="userId" value="<c:out value="${member.userId}"/>"/>
						</c:if>
					</td>
					<th>소속</th>
					<td><input type="text" id="psitnDeptNm" name="psitnDeptNm" class="input_type" value="<c:out value="${member.psitnDeptNm}"/>"/></td>
				</tr>
				<tr>
					<th>연락처</th>
					<td><input type="text" id="telno" name="telno" class="input_type" value="<c:out value="${member.telno}"/>"/></td>
					<th>E-mail주소</th>
					<td><input type="text" id="emailAdres" name="emailAdres" class="input_type" value="<c:out value="${member.emailAdres}"/>"/> </td>
				</tr>
			</tbody>
		</table>
		<input type="hidden"  name="uId" id="uId" value="${member.userIdntfr}"/>
		<input type="hidden"  name="stdntNo" id="stdntNo" value="${member.stdntNo}"/>
		</form>
	</div>
	<div id="authorDetailDiv" style="display: none;">
		<form name="detailFrm" id="detailFrm" action="<c:url value="/member/updateAuthDetail.do"/>">
		<input type="hidden" name="authorId" id="detailAuthorId" value=""/>
		<table class="write_tbl">
			<colgroup>
				<col style="width:40px;" />
				<col style="width:110px;" />
				<col style="width:120px;" />
				<col style="width:40px;" />
				<col style="width:110px;" />
				<col style="width:120px;" />
				<col style="width:40px;" />
				<col style="width:110px;" />
				<col style="width:120px;" />
			</colgroup>
			<thead>
				<tr>
				<th></th>
				<th>항목</th>
				<th style="border-right: 1px solid #ddd;">입력/열람</th>
				<th></th>
				<th>항목</th>
				<th style="border-right: 1px solid #ddd;">입력/열람</th>
				<th></th>
				<th>항목</th>
				<th>입력/열람</th>
				</tr>
			</thead>
			<tbody id="authorDetailBody"></tbody>
		</table>
		</form>
	</div>
</body>
</html>