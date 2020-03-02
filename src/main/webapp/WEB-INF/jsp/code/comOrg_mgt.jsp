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
var dhxLayout, dhxWins, w1, w1Layout, myGrid, myDp, t, orgCombo;
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
	myGrid.setHeader("번호,구분,기관명,전거명,Country,매칭건수,적요,수정일자",null,grid_head_center_bold);
	myGrid.setColumnIds("no,gubun,orgName,orgAlias,country,matchCnt,remark,date");
	myGrid.setImagePath("${dhtmlXImagePath}");
	myGrid.setInitWidths("50,80,150,*,80,80,150,80");
	myGrid.setColAlign("center,center,left,left,center,right,left,center");
	myGrid.setColTypes("ro,ro,ro,ro,ro,ro,ro,ro");
	myGrid.setColSorting("na,na,str,str,str,na,str,str");
	myGrid.enableMultiselect(true);
	myGrid.enablePaging(true,100,10,"pagingArea",true);
	myGrid.setPagingSkin("${dhtmlXPagingSkin}");
	myGrid.attachEvent("onBeforeSorting", myGrid_onBeforeSorting);
	myGrid.attachEvent("onXLS", doBeforeGridLoad);
	myGrid.attachEvent("onXLE", doOnGridLoaded);
	myGrid.attachEvent("onRowDblClicked",doOnRowDblClicked);
	myGrid.init();
	myGrid.enableRowspan(true);
	myDp = new dataProcessor("${contextPath}/orgAlias/comOrgAliasCUD.do");
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
	orgCombo = new dhtmlXCombo('orgList','combo',704);
	orgCombo.enableFilteringMode(true, "${contextPath}/orgAlias/findComOrgAliasOptionsAjax.do", true);
	orgCombo.enableAutocomplete();
	orgCombo.attachEvent("onKeyPressed",function(keyCode){if(keyCode==13)myGrid_load();});
	orgCombo.load({options:[{value:instname,text:instname}]});
	orgCombo.setComboValue(instname);
    orgCombo.setFocus();
    myGrid_load();
});

function doOnRowDblClicked(id){
	fn_mgtOrgAlias(id);
}

function myGrid_load(){
	var url = getGridRequestURL();
	myGrid.clearAndLoad(url, doOnGridLoaded);
}

function getGridRequestURL(){
	var url = "${contextPath}/orgAlias/comOrgAliasList.do"
	    url += "?"+$('#formArea').serialize();
	    url += "&orgName="+orgCombo.getSelectedValue();
	return url;
}

function myGrid_onBeforeSorting(ind,type,direct){
	var url = getGridRequestURL();
	myGrid.clearAndLoad(url+"&orderby="+(myGrid.getColumnId(ind))+"&direct="+direct);
	myGrid.setSortImgState(true,ind,direct);
	return false;
}

function myGrid_not_empty(value, id, ind) {
    if (value == "") return "Value at (" + id + ", " + ind + ") can't be empty";
    return true;
}

var orgAliasModalBox, orgAliasFormLayout, orgAliasForm, clkBtnString;

function fn_mgtOrgAlias(id){
	var btn = new Array();
	if(id == "")
	{
		btn = ["저장", "취소"];
	}
	else
	{
		btn = ["저장","삭제","취소"];
	}

	orgAliasModalBox = dhtmlx.modalbox({
		title: '기관명전거 추가',
	    text: '<div id="orgAliasForm" style="width: 500px; height: 235px;"></div>',
	    width: '522px',
	    buttons:btn
	});

	orgAliasFormLayout = new dhtmlXLayoutObject({
		parent: 'orgAliasForm',
		pattern: '1C',
		skin: '${dhtmlXSkin}',
		cells: [{ id: 'a', header: false }]
	});
	$.ajax({ url: '${contextPath}/orgAlias/getComOrgAlias.do?id=' + id, dataType: 'json' }).done(function(data) {

		var status = (data.orgAlias.id != null && data.orgAlias.id != '') ? 'updated':'inserted';
		var regUserId = (data.orgAlias.regUserId != null && data.orgAlias.regUserId != '') ?  data.orgAlias.regUserId : '${sessionScope.login_user.userId}';

		var selectedOrgName = "";
		if(data.orgAlias.orgName != null && data.orgAlias.orgName != '') selectedOrgName = data.orgAlias.orgName;
		else if(orgCombo.getSelectedValue() != null && orgCombo.getSelectedValue() != null ) selectedOrgName = orgCombo.getSelectedValue();
		else selectedOrgName = instname;

		var orgNameOptions = new Array();
		orgNameOptions.push({text:"기관명을 선택하세요.",value:""});
		for(var i=0; i < data.instList.length; i++)
		{
			if(data.instList[i].orgName == selectedOrgName)
			{
				orgNameOptions.push({text:data.instList[i].orgName,value:data.instList[i].orgName,selected:true});
			}
			else
			{
				orgNameOptions.push({text:data.instList[i].orgName,value:data.instList[i].orgName});
			}
		}

		orgAliasForm = orgAliasFormLayout.cells('a').attachForm([
	   			{type: 'settings', position: 'label-left', labelWidth: 100, inputWidth: 350},
				{type: 'block', inputWidth: 'auto', offsetTop: 10, list: [
					{type: 'combo', label: '기관명', name: 'orgName', value:data.orgAlias.orgName, options:orgNameOptions , filterCache: true, filtering: true, readonly:true, validate: "NotEmpty", required: true, inputWidth: 322},
					{type: "newcolumn"},
					{type: "button", name:"btn_search", value: "", className: "button_search", inputWidth: 5},
					{type: "newcolumn"},
					{type: 'input', label: '전거', name: 'orgAlias', value: data.orgAlias.orgAlias, validate: "NotEmpty", required: true}
		   		]},
		   		{type: 'block', inputWidth: 'auto', offsetTop: 10, list: [
					{type: 'select', label: '구분', name: 'gubun', value:data.orgAlias.gubun, options:[
					                                                          {text:'대학',value:'대학'},
					                                                          {text:'기관',value:'기관'}
					                                                          ]},
					{type: 'select', label: '국가', name: 'country', value:data.orgAlias.country, options:[
					                                                          {text:'South Korea',value:'South Korea'},
					                                                          {text:'USA',value:'USA'}
					                                                          ]},
					{type: 'input', label: '적요', name: 'remark', value: data.orgAlias.remark, rows:3},
					{type: 'hidden', label: 'ID', name: 'gr_id', value: data.orgAlias.id},
					{type: 'hidden', label: 'STATUS', name: '!nativeeditor_status', value: status},
					{type: 'hidden', label: '등록자ID', name: 'regUserId', value: regUserId},
					{type: 'hidden', label: '수정자ID', name: 'modUserId', value: '${sessionScope.login_user.userId}'}
		   		]}
	    ]);

		orgAliasForm.attachEvent('onButtonClick',function(name){
			if(name == 'btn_search')searchInst();
		});

		orgAliasForm.getCombo("orgName").attachEvent("onOpen",function(){
			$(".dhxcombolist_dhx_terrace").eq(0).css("z-index","20001");
		});

	});
	$('select[name="orgName"]').focus();

	$('.dhtmlx_popup_button').on('click', function(e) {
		clkBtnString = $(this).text();
		if(clkBtnString == '취소')
		{
			orgAliasForm.getCombo("orgName").clearAll();
			return true;
		}
		else if(clkBtnString == '삭제')
		{
			orgAliasForm.getCombo("orgName").clearAll();
			cut();
		}
		else
		{
			orgAliasForm.validate();
			orgAliasForm.send("${contextPath}/orgAlias/comOrgAliasCUD.do", "post", function() {
				dhtmlx.modalbox.hide(orgAliasModalBox);
				myGrid_load();
				dhtmlx.alert('저장 되었습니다.');
				orgAliasForm.getCombo("orgName").clearAll();
			});
			return false;
		}
	});
}

var w1Toolbar, w1Grid;
function searchInst(){

	dhtmlx.modalbox.hide(orgAliasModalBox);

	var pageX = Math.max(0, (($(window).width() - 550) / 2) + $(window).scrollLeft());
	var pageY = Math.max(0, (($(window).height() - 350) / 2) + $(window).scrollTop());

	if(dhxWins != null && dhxWins.unload != null)
	{
		dhxWins.unload();
		dhxWins = null;
	}

	dhxWins = new dhtmlXWindows({
		viewport : {objec : 'windVP'},
		wins : [ {id : 'w1', left : pageX, top : pageY, width: 600, height: 450, text: "대학/기관검색", resize : false} ]
	});
	dhxWins.window('w1').setModal(true);
	dhxWins.window('w1').attachEvent('onClose',function(){
		dhtmlx.modalbox(orgAliasModalBox);
		return true;
	});

	var keyWord = "";
	if(orgAliasForm != null) keyWord = orgAliasForm.getItemValue('orgName');

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
			w1Grid.clearAndLoad('${contextPath}/code/findOrgCodeList.do?keyword=' + encodeURIComponent(w1Toolbar.getValue('keyword')));
		}
	});
	w1Toolbar.attachEvent("onEnter", function(id,value) {
		if(value == "")
		{
			dhtmlx.alert({type:"alert-warning",text:"검색어를 입력하세요.",callback:function(){}})
		}
		else
		{
			w1Grid.clearAndLoad('${contextPath}/code/findOrgCodeList.do?keyword=' + encodeURIComponent(w1Toolbar.getValue('keyword')));
		}
    });

	w1Grid = w1Layout.cells("b").attachGrid();
	w1Grid.setImagePath("${dhtmlXImagePath}");
	w1Grid.setHeader('');
	w1Grid.setHeader("대학/기관명", null, grid_head_center_bold);
	w1Grid.setInitWidths("*");
	w1Grid.setColAlign("left");
	w1Grid.setColTypes("ro");
	w1Grid.setColSorting("na");
	w1Grid.attachEvent("onXLS", function() {
		w1Layout.cells("a").progressOn();
	 });
	w1Grid.attachEvent("onXLE", function() {
		w1Layout.cells("a").progressOff();
	 });
	w1Grid.attachEvent('onRowSelect', doOnRowSelectedInst);
	w1Grid.init();
	$('.dhxtoolbar_input').focus();
	if (w1Toolbar.getValue('keyword') != "") w1Grid.clearAndLoad('${contextPath}/code/findOrgCodeList.do?keyword=' + encodeURIComponent(w1Toolbar.getValue('keyword')));

}

function doOnRowSelectedInst(id){
	var orgName = id.split('_')[1];
	dhxWins.window('w1').close();
	orgAliasForm.getCombo("orgName").addOption(orgName,orgName,null,"",true);
	dhtmlx.modalbox(orgAliasModalBox);
}

function save(){
	myDp.sendData();
}
function cut(){
	if(myGrid.getSelectedRowId() == null)
	{
		dhtmlx.alert('삭제할 전거를 선택하세요.');
		return false;
	}
	dhtmlx.confirm({
		type:"confirm-warning",
		title:"전거 삭제",
		text:"선택하신 전거를 삭제하시겠습니까?",
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

function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){ dhxLayout.setSizes(false); },200);}
function doOnGridLoaded(){setTimeout(function() {dhxLayout.cells("a").progressOff();}, 100);}
function doBeforeGridLoad(){dhxLayout.cells("a").progressOn();}
</script>
</head>
<body>
	<!-- Page Title -->
	<div class="title_box">
		<h3><spring:message code='menu.orgalias'/></h3>
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
					<th>기관</th>
					<td colspan="3">
						<div id="orgList"></div>
					</td>
					<td rowspan="2" class="option_search_td" onclick="javascript:myGrid_load();"><em>search</em></td>
				</tr>
				<tr>
					<th>별칭</th>
					<td>
						<input type="text" id="orgAlias" name="orgAlias" class="input_type" class="input2" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/>
					</td>
					<th>구분</th>
					<td>
						<input type="radio" id="gubunA" name="gubun" class="radio" value=""  onclick="myGrid_load();"/>
							<label for="gubunA" class="radio_label">전체</label>
						<input type="radio" id="gubunC" name="gubun" class="radio" value="대학" checked="checked" onclick="myGrid_load();" />
							<label for="gubunC" class="radio_label">대학</label>
						<input type="radio" id="gubun" name="gubun" class="radio" value="기관" onclick="myGrid_load();" />
							<label for="gubun" class="radio_label">기관</label>
					</td>
				</tr>
				</tbody>
			</table>
		</form>

		<div class="list_bt_area">
			<div class="list_set">
				<ul>
					<li><a href="#" onclick="javascript:fn_mgtOrgAlias('');" class="list_icon12">추가</a></li>
					<%--
					<li><a href="#" onclick="javascript:save();" class="list_icon02">저장</a></li>
					 --%>
					<li><a href="#" onclick="javascript:cut();" class="list_icon22">삭제</a></li>
					<%--
					<li><a href="#" onclick="javascript:toExcel();" class="list_icon20">엑셀</a></li>
					 --%>
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
