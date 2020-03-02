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
<link type="text/css" href="${contextPath}/css/layout.css" rel="stylesheet" />
<link type="text/css" href="${contextPath}/js/dhtmlx/skins/${sysConf['dhtmlx.skin']}/dhtmlx.css" rel="stylesheet" />
<link type="text/css" href="${contextPath}/css/jquery/ui.switchbutton.min.css" rel="stylesheet" />
<style type="text/css">
.dhxwins_vp_dhx_terrace {overflow: auto;} .dhx_toolbar_dhx_terrace { padding: 0 0px; }
.dhxwins_vp_dhx_terrace div.dhxwin_active div.dhx_cell_wins div.dhx_cell_toolbar_def, .dhxwins_vp_dhx_terrace div.dhxwin_inactive div.dhx_cell_wins div.dhx_cell_toolbar_def { padding: 10px 0px 0; }
div.dhxform_item_label_left.button_search div.dhxform_btn { height: 25px; margin: 0px 2px; background-color: #ffffff;}
div.dhxform_item_label_left.button_search div.dhxform_btn_txt { top:0;right:0;background: url(${contextPath}/images/background/tbl_search_icon.png) no-repeat 50% 50%; text-indent: -9999px;display: block;width: 23px; height: 25px;margin: 0 0px;}
.alignLeft{text-align: left;} .alignLeft div.dhxform_txt_label2{font-weight: normal;}
.detail_tbl tbody td {padding: 10px 1px; border-bottom: 1px solid #ddd; }
.detail_tbl tbody th {padding: 10px 20px; border-bottom: 1px solid #ddd; }
.ui-switchbutton-default label{font-size: 11px;font-family: Nanum Gothic, 나눔고딕, Malgun Gothic,맑은 고딕, Verdana,Arial, '돋움', Dotum;}
</style>
<script type="text/javascript" src="${contextPath}/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="${contextPath}/js/jquery/jquery-ui.min.js"></script>
<script type="text/javascript" src="${contextPath}/js/jquery/jquery.tmpl.min.js"></script>
<script type="text/javascript" src="${contextPath}/js/jquery/jquery.switchbutton.min.js"></script>
<script type="text/javascript" src="${contextPath}/js/dhtmlx/dhtmlx.js"></script>
<script type="text/javascript" src="${contextPath}/js/script.js"></script>
<script type="text/javascript">
var dhxLayout, dhxWins, w1, w1Layout, memberToolbar, authGrid, authDp, authToolbar, myGrid, myDp, statusCombo, t, detailToolbar, authMoldalBox, authFormLayout, authForm, savedMember;
var rsltProperty = new Array("article","conference","book","funding","patent","techtrans","exhibition","career","degree","award","license","rsrchrealm","lecture","student","report","etc","activity");
var authGridSelectedRow = "${member.userId}_${param.trgetAuthorId}";
$(document).ready(function(){
	if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
	else  window.addEventListener("resize",resizeLayout, false);
	dhxLayout = new dhtmlXLayoutObject("mainLayout","2E");
	dhxLayout.setSizes(false);
	dhxLayout.cells("a").setText("<spring:message code='sitter.header.info'/>");
	if(mode === 'add')
	{
		dhxLayout.cells("a").setHeight("157");
	}
	else
	{
		dhxLayout.cells("a").setHeight("178");
	}
	dhxLayout.cells("b").setText("<spring:message code='sitter.header.detail'/>");
	dhxLayout.cells("b").hideArrow();
	dhxLayout.cells("a").appendObject("memberInfoDiv");
	loadAuthDetailComponent();

	if(mode === 'add') savedMember = false;
	else savedMember = true;
});

//세부권한정보 로딩
function loadAuthDetailComponent(){
	detailToolbar = dhxLayout.cells("b").attachToolbar();
	detailToolbar.setIconsPath("${dhtmlXImagePath}/icons_${sysConf['dhtmlx.skin']}/");
	detailToolbar.setIconSize(18);
	detailToolbar.setAlign("right");
	detailToolbar.addButton("select", 1, "<spring:message code='sitter.all.select'/>", "complete.png", "complete.png");
	detailToolbar.addButton("release", 2, "<spring:message code='sitter.all.unselect'/>", "release.png", "release.png");
	detailToolbar.addSeparator("sep1", 3);
	if(mode != 'add')
	{
		for(var i=6; i < 57; i++) detailToolbar.addSeparator("sep"+i, i+1);
		detailToolbar.addButton("save", 58, "<spring:message code='common.button.save'/>", "save.gif", "save_dis.gif");
		detailToolbar.addButton("del", 59, "<spring:message code='sitter.authority.del.button'/>", "del.png", "del.png");
	}
	else
	{
		for(var i=6; i < 65; i++) detailToolbar.addSeparator("sep"+i, i+1);
		detailToolbar.addButton("save", 66, "<spring:message code='common.button.save'/>", "save.gif", "save_dis.gif");
	}

	dhxLayout.cells("b").appendObject("authorDetailDiv");
	detailToolbar.attachEvent("onClick",function(id){
		if(id == "save") //세부권한 저장
		{
			var url = '${contextPath}/member/addAgncy.do?' + $('#formArea').serialize();
			$.get( url, null, null, 'json').done(function(data){
				if(data.result == "001")
				{
					dhtmlx.alert({type:"alert-warning",text:"<spring:message code='sitter.save.success.message'/>",callback:function(){opener.myGrid_load(); top.window.close();}})
				}
				else
				{
					dhtmlx.alert('<spring:message code="sitter.create.error.message"/>');
				}
			});
		}
		else if(id == "del") //권한삭제
		{
			deleteAutority();
		}
		else if(id == 'select')
		{
			$('.authCheckbox').prop('checked',false).trigger('click');
		}
		else if(id == 'release')
		{
			$('.authCheckbox').prop('checked',true).trigger('click');
		}
	});

	if(mode == 'update') authGrid_onRowSelect();
}

function authGrid_onRowSelect(){
	var str = authGridSelectedRow.split('_');
	$('#authorDetailBody').empty();
	$.post( '${contextPath}/member/findMemberAuthorityDetailListAjax.do', {"trgetAutorId" : str[1] }, null, 'json').done(function(data){
	    $('#detailAuthorId').val(str[1]);
		var $tr = $('<tr></tr>');
		var appendCnt = 0;
		for(var i=0; i < data.length; i++)
		{
			if(rsltProperty.indexOf(data[i].property) != -1)
			{
				var lang = "${pageContext.response.locale}";
				var authAt_checked = data[i].mgtLvl > '0' ? 'checked="checked"' : '';
				var writeAt_checked = data[i].mgtLvl > '1' ? 'checked="checked"' : '';
				var writeAt_disabled = data[i].mgtLvl > '0' ? '' : 'disabled="disabled"';
				var tdLine = (appendCnt+1) % 6 != 0 ? 'border-right: 1px solid #ddd;' : '';
				var mgtTrgetNm = data[i].mgtTrgetNm;
				if(lang == 'en') mgtTrgetNm = data[i].mgtTrgetEngNm;
				$tr.append($('<td style="height:30px; text-align:center;"></td>').append('<input type="hidden" name="seqNo" value="'+data[i].seqNo+'"/>').append('<input type="hidden" name="mgtLvl" id="mgtLvl_'+i+'" value="'+data[i].mgtLvl+'"/>').append('<input type="checkbox" class="authCheckbox" name="authAt" id="authAt_'+i+'" '+authAt_checked+' />'));
				$tr.append('<td><input type="hidden" name="mgtTrget" value="'+data[i].mgtTrget+'"/><input type="hidden" name="mgtTrgetNm" value="'+mgtTrgetNm+'"/>'+mgtTrgetNm+'</td>');
				if( (appendCnt+1) % 6 == 0 || appendCnt == (rsltProperty.length -1) )
				{
					$('#authorDetailBody').append($tr);
					$tr = $('<tr></tr>');
				}
				appendCnt++;
			}
		}
		$('.authCheckbox').click(function(){
			var index = $(this).prop('id').split('_')[1];
			if($(this).prop("checked"))
			{
				$('#mgtLvl_'+index).val('2');
			}
			else
			{
				$('#mgtLvl_'+index).val('0');
			}
		});
	});
}

function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){ dhxLayout.setSizes(false); },200);}
function doOnGridLoaded(){setTimeout(function() {dhxLayout.cells("b").progressOff();}, 100);}
function doBeforeGridLoad(){dhxLayout.cells("b").progressOn();}

//권한삭제
function deleteAutority(){
	dhtmlx.confirm({
		type:"confirm-warning",
		title:"<spring:message code='itter.del.widnow.title'/>",
		text:"<spring:message code='sitter.del.alter.message'/>",
		ok:"<spring:message code='common.button.delete'/>", cancel:"<spring:message code='common.button.cancel'/>",
		callback:function(result){
			if(result == true){
				var mngrResnCn = $("#mngrResnCn").val();
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

							$("#mngrResnCn").val(mngrResnCn);

							$('#formArea').append($('<input type="hidden" name="!nativeeditor_status" value="deleted"/>'));
							$('#formArea').append($('<input type="hidden" name="gr_id" value="'+authGridSelectedRow+'"/>'));
							var url = '${contextPath}/member/authCUD.do';
							$.post( url,  $('#formArea').serializeArray(), null, 'json').done(function(data){
								dhtmlx.alert({type:"alert-warning",text:"<spring:message code='sitter.del.success.message'/>",callback:function(){opener.myGrid_load(); top.window.close();}})
							});
						}
					}
				});
			}
		}
	});
}

var w1Toolbar, w1Grid;
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
		wins : [ {id : 'w1', left : pageX, top : pageY, width: 700, height: 400, text: "<spring:message code='sitter.search.account'/>", resize : false} ]
	});
	dhxWins.window('w1').setModal(true);

	var keyword = $('#korNm').val();

	w1Layout = dhxWins.window('w1').attachLayout('2E')
	w1Layout.cells('a').hideHeader();
	w1Layout.cells('b').hideHeader();
	w1Layout.cells("a").setHeight(55);

	w1Toolbar = w1Layout.cells("b").attachToolbar();
	w1Toolbar.setIconsPath("${dhtmlXImagePath}/icons_${sysConf['dhtmlx.skin']}/");
	w1Toolbar.setIconSize(18);
	w1Toolbar.addInput("keyword", 0, keyword, 615);
	w1Toolbar.addButton("search", 1, "", "search.png", "search.png");
	w1Toolbar.attachEvent("onClick", function(id) {
		if (id == "search"){
			w1Grid.clearAndLoad('${contextPath}/erpUser/findUserList.do?keyword=' + encodeURIComponent(w1Toolbar.getValue('keyword')));
		}
	});
	w1Toolbar.attachEvent("onEnter", function(id,value) {
		if(value == "")
		{
			dhtmlx.alert({type:"alert-warning",text:"<spring:message code='sitter.keyword.alter.message'/>",callback:function(){}})
		}
		else
		{
			w1Grid.clearAndLoad('${contextPath}/erpUser/findUserList.do?keyword=' + encodeURIComponent(w1Toolbar.getValue('keyword')));
		}
    });

	w1Grid = w1Layout.cells("b").attachStatusBar({
		text : '<div id="w1Grid_pagingArea"></div>',
		paging : true
	});

	w1Grid = w1Layout.cells("b").attachGrid();
	w1Grid.setImagePath("${dhtmlXImagePath}");
	w1Grid.setHeader("No,ID,Name(kor),Name(eng),Affiliation,RID,KRI연구자번호,임용일자,E-mail,직급1,직급2,재직,연락처,UID,학번",null,grid_head_center_bold);
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
	if (w1Toolbar.getValue('keyword') != "") w1Grid.clearAndLoad('${contextPath}/erpUser/findUserList.do?keyword=' + encodeURIComponent(w1Toolbar.getValue('keyword')));

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
	$('#spanEngNm').empty().text(engNm);
	$('#userId').val(perno);
	$('#spanUserId').empty().text(perno);
	$('#psitnDeptNm').val(dept);
	$('#spanPsitnDeptNm').empty().text(dept);
	$('#emailAdres').val(email);
	$('#spanEmailAdres').empty().text(email);
	$('#telno').val(ofcTelno);
	$('#spanTelno').empty().text(ofcTelno);
	$('#uId').val(uId);
	$('#stdntNo').val(stdntNo);

	$('#authorDetailBody').empty();
	$('#trgetUserId').val(perno);

	authGrid_onRowSelect();
	dhxWins.window('w1').close();
}
</script>
</head>
<body style="overflow-y: auto;">
	<div class="popup_wrap">
	<div class="title_box">
		<h3><spring:message code="menu.assistant.mgt" /> </h3>
	</div>
	<form id="formArea" action="${contextPath}/member/addAgncy.do" method="post">
	   <input type="hidden" name="trgetUserId" id="trgetUserId" value="${member.userId}"/>
	   <input type="hidden" name="trgetAuthorId" id="trgetAuthorId" value="${param.trgetAuthorId}"/>
	   <input type="hidden" name="authorId" id="detailAuthorId" value="${agncy.authorId}"/>
		<%--권한정보 --%>
	   	<input type="hidden" name="adminDvsCdNm" id="adminDvsCdNm" value="${rims:codeValue('auth.type',agncy.adminDvsCd)}"/>
	   	<input type="hidden" name="adminDvsCd" id="adminDvsCd" value="${agncy.adminDvsCd}"/>
	   	<input type="hidden" name="workTrgetNm" id="workTrgetNm" value="${agncy.workTrgetNm}"/>
	   	<input type="hidden" name="workTrget" id="workTrget" value="${agncy.workTrget}"/>
	   	<input type="hidden" name="authorStatus" id="authorStatus" value="${agncy.authorStatus}"/>
	   	<input type="hidden" name="mngrResnCn" id="mngrResnCn" value="${agncy.mngrResnCn}"/>

	   <div id="mainLayout" style="position: relative; width: 100%;height: 100%;"></div>

	</div>
	<script type="text/javascript">$('#mainLayout').css('height',($(window).height()-90)+"px");</script>
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
				<c:if test="${param.mode eq 'update'}">
				<tr>
					<th><spring:message code="sitter.authority.status"/></th>
					<spring:message code="sitter.authority.status.allow" var="allow"/>
					<spring:message code="sitter.authority.retrieval" var="retrieval"/>
					<td>${not empty agncy.authorStatus and agncy.authorStatus eq 'Y' ? allow : retrieval}</td>
					<th><spring:message code="sitter.allow.date"/></th>
					<td><fmt:formatDate value="${agncy.authorAlwncDate}" pattern="yyyy-MM-dd" /></td>
				</tr>
				</c:if>
				<tr>
					<th><spring:message code="sitter.name.kor"/></th>
					<td>
						<c:if test="${param.mode eq 'add'}">
							<div class="r_add_bt">
								<label for="korNm" id="korNmLabel" class="labelHelp"><spring:message code="sitter.search.label"/></label>
								<input type="text" id="korNm" name="korNm" class="input_type" value="" onkeydown="if(event.keyCode==13){addMember(event);}" onfocus="onFocusHelp('korNm');" onblur="onBlurHelp('korNm');"/>
								<a href="javascript:void(0);" onclick="addMember(event);" class="tbl_search_bt">검색</a>
							</div>
						</c:if>
						<c:if test="${param.mode eq 'update'}">
							<span id="spanKorNm">${member.korNm}</span><input type="hidden"  name="korNm" id="korNm" value="${member.korNm}"/>
						</c:if>
					</td>
					<th><spring:message code="sitter.name.eng"/></th>
					<td>
						<span id="spanEngNm">${member.engNm}</span><input type="hidden" id="engNm" name="engNm" value="${member.engNm}"/>
					</td>
				</tr>
				<tr>
					<th><spring:message code="sitter.userid"/></th>
					<td>
						<span id="spanUserId">${member.userId}</span><input type="hidden"  name="userId" id="userId" value="${member.userId}"/>
					</td>
					<th><spring:message code="sitter.affiation"/></th>
					<td>
						<span id="spanPsitnDeptNm">${member.psitnDeptNm}</span><input type="hidden" id="psitnDeptNm" name="psitnDeptNm" value="${member.psitnDeptNm}"/>
					</td>
				</tr>
				<tr>
					<th><spring:message code="sitter.telno"/></th>
					<td>
						<span id="spanTelno">${member.telno}</span><input type="hidden" id="telno" name="telno" value="${member.telno}"/>
					</td>
					<th><spring:message code="sitter.email"/></th>
					<td>
						<span id="spanEmailAdres">${member.emailAdres}</span><input type="hidden" id="emailAdres" name="emailAdres" value="${member.emailAdres}"/>
					</td>
				</tr>
			</tbody>
		</table>
		<input type="hidden"  name="uId" id="uId" value="${member.userIdntfr}"/>
		<input type="hidden"  name="stdntNo" id="stdntNo" value="${member.stdntNo}"/>
		</form>
	</div>
	<div id="authorDetailDiv" style="display: none;">
		<table class="write_tbl detail_tbl">
			<colgroup>
				<col style="width:30px;" />
				<col style="width:110px;" />
				<col style="width:30px;" />
				<col style="width:110px;" />
				<col style="width:30px;" />
				<col style="width:110px;" />
				<col style="width:30px;" />
				<col style="width:110px;" />
				<col style="width:30px;" />
				<col style="width:110px;" />
				<col style="width:30px;" />
				<col style="width:110px;" />
			</colgroup>
			<tbody id="authorDetailBody"></tbody>
		</table>
	</div>
	<div style="display: none;">
		<div id="authGridDiv"></div>
	</div>
	</form>
</body>
</html>