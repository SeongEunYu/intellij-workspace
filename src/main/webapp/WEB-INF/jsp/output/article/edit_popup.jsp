<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../pageInit.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link type="text/css" href="${contextPath}/css/layout.css" rel="stylesheet" />
	<link type="text/css" href="${contextPath}/js/dhtmlx/skins/${sysConf['dhtmlx.skin']}/dhtmlx.css" rel="stylesheet" />
	<link type="text/css" href="${contextPath}/js/dhtmlx/skins/${sysConf['dhtmlx.skin']}/dhtmlxvault.css" rel="stylesheet" />
<style type="text/css">
div.dhxform_item_label_left.button_save div.dhxform_btn_txt {
			height:25px;
			background-image: url(${contextPath}/images/common/icon/btn_search.png);
			background-repeat: no-repeat;
			background-position: 0px 5.5px;
			padding-left: 7px;
			padding-right: 10px;
			margin: 0px 2px 0px 2px;
			cursor: pointer;
		}

.list_set ul li a { font-size: 11px; padding: 0 10px 0 26px; line-height: 20px; height: 20px;}
.list_set ul li .list_icon12 { background: url(${contextPath}/images/common/background/list_icon_set.png) no-repeat 7px -488px; background-color: #ebebeb; }
.list_set ul li .list_icon10 { background: url(${contextPath}/images/common/background/list_icon_set.png) no-repeat 7px -399px; background-color: #ebebeb; }
.list_set ul li .list_icon23 { background: url(${contextPath}/images/common/background/list_icon_set.png) no-repeat 7px -1049px; background-color: #ebebeb; }
.list_set ul li .list_icon24 { background: url(${contextPath}/images/common/background/list_icon_set.png) no-repeat 7px -1097px; background-color: #ebebeb; }
.list_bt_area { padding: 6px 0px 2px 0px; }
.dhxwins_vp_dhx_terrace div.dhxwin_active div.dhx_cell_wins div.dhx_cell_toolbar_def, .dhxwins_vp_dhx_terrace div.dhxwin_inactive div.dhx_cell_wins div.dhx_cell_toolbar_def { padding: 10px 0px 0; }
.dhx_toolbar_dhx_terrace { padding: 0 0px; }
</style>
<%--
	<script type="text/javascript" src="http://dhtmlx.com/docs/products/codebase/dhtmlx.js"></script>
 --%>
	<script type="text/javascript" src="${contextPath}/js/dhtmlx/dhtmlx.js"></script>
 	<script type="text/javascript" src="${contextPath}/js/dhtmlx/vault/dhtmlxvault.js"></script>
	<script type="text/javascript" src="${contextPath}/js/jquery/jquery-1.11.3.min.js"></script>
	<script type="text/javascript" src="${contextPath}/js/script.js"></script>
<script type="text/javascript">
var dhxAcc, dhxLayout, myToolbar, authorGrid, authorDp, myForm, myVault, t, myPopup;

$(document).ready(function(){

	if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
	else  window.addEventListener("resize",resizeLayout, false);

	dhxLayout = new dhtmlXLayoutObject("mainLayout","1C");
	dhxLayout.cells("a").hideHeader();
	dhxLayout.setSizes(false);

	myToolbar = dhxLayout.cells("a").attachToolbar({
		icons_path :"${dhtmlXImagePath}/icons_${sysConf['dhtmlx.skin']}/",
		xml: "${contextPath}/dhx_toolbar/article_edit_toolbar.xml"
	});
	myToolbar.setIconSize(18);
	myToolbar.setAlign("right");

	myForm = dhxLayout.cells("a").attachForm();
	myForm.loadStruct("${contextPath}/article/editFormXml.do?articleId=${param.articleId}", loadGrids);
	myForm.enableLiveValidation(true);
	myForm.attachEvent("onButtonClick", function(name){
		if(name == "findJournalMaster") findJournal();
	});

	myPopup = new dhtmlXPopup({mode: "bottom"});
	myPopup.attachEvent("onShow", function(id){
	    $(document).on("click",function(e) {
	    	if($(e.target).parents("div[id^='dhxpopup_node']").size() == 0)
	    	{
	    		if(myPopup != null &&  myPopup.isVisible() == true){
	    			myPopup.hide();
	    		}
	    	}
	    });
	});
	myPopup.attachEvent("onHide", function(){ $(document).off("click"); });

	myForm.attachEvent("onInfo", function(name, e){
		myPopup.attachHTML("<div style='width:250px;'>"+this.getUserData(name,"info")+"</div>");
	    var t = e.target||e.srcElement;
	    var x = window.dhx4.absLeft(t);
	    var y = window.dhx4.absTop(t);
	    var w = t.offsetWidth;
	    var h = t.offsetHeight;
	    myPopup.show(x,y,w,h);
	});

});
function loadGrids(){

	var conatiner = myForm.getContainer("authorGrid");
	var base = $(conatiner).parent().parent();
	var label = base.children('div').eq(0);
	label.css('float','left');

	authorGrid = new dhtmlXGridObject(myForm.getContainer("authorGrid"));
	authorGrid.setImagePath("${dhtmlXImagePath}");
	authorGrid.setEditable(true);
	authorGrid.enableEditEvents(true,true,true);
	authorGrid.init();
	authorGrid_load();
	authorDp = new dataProcessor("${contextPath}/article/updateArticleParti.do");
	authorDp.init(authorGrid);
	authorDp.setTransactionMode("POST",false);
	authorDp.setUpdateMode("off");
	authorDp.enableDataNames(true);

	authorGrid.attachEvent("onCellChanged", function(rId,cInd,nValue){
		var cIndex_blngAgcNm = authorGrid.getColIndexById("blngAgcNm");
		var cIndex_blngAgcCd = authorGrid.getColIndexById("blngAgcCd");
		var blngAgcNm =  authorGrid.cells(rId, cIndex_blngAgcNm).getValue();
		var blngAgcCd =  authorGrid.cells(rId, cIndex_blngAgcCd).getValue();
		if(cInd = cIndex_blngAgcNm && ( blngAgcNm == null || blngAgcNm == '') && blngAgcCd != '')
		{
			authorGrid.cells(rId, cIndex_blngAgcCd).setValue("");
		}
	});

	var authorGridBtn = $('<div class="list_bt_area" style="float:right;"></div>');
	var listSet = $('<div class="list_set"></div>');
	var ul = $('<ul></ul>');
	ul.append($('<li class="group_btn"><a href="#" onclick="javascript:moveUp();" class="list_icon23">위로</a><a href="#" onclick="javascript:moveDown();" class="list_icon24">아래로</a></li>'));
	ul.append($('<li class="group_btn"><a href="#" onclick="javascript:addPrtcpnt();" class="list_icon12">저자추가</a><a href="#" onclick="javascript:delPrtcpnt();" class="list_icon10">저자삭제</a></li>'));
	listSet.append(ul);
	authorGridBtn.append(listSet);
	authorGridBtn.insertAfter(label);

	myVault = new dhtmlXVaultObject({
					container:myForm.getContainer("fileVault"),
				    swfPath:		'dhxvault.swf',
				    slXap:			'dhxvault.xap',
				    uploadUrl:		'${contextPath}/workbench/updateFile.do?gubun=ARTICLE&articleId=${param.articleId}',
				    swfUrl:			'${contextPath}/workbench/updateFile.do?gubun=ARTICLE&articleId=${param.articleId}',
				    slUrl:			'${contextPath}/workbench/updateFile.do?gubun=ARTICLE&articleId=${param.articleId}',
				    downloadUrl:	'${contextPath}/servlet/download.do?fileid={serverName}',
				    buttonClear:	false
	});

	myVault.load('${contextPath}/workbench/findArtclFileList.do?gubun=ARTICLE&articleId=${param.articleId}');

	myVault.attachEvent('onBeforeFileRemove', function(file){
		if(confirm('삭제 하시겠습니까?')) {
			$.ajax({
				dataType: 'json',
				url: '${contextPath}/workbench/deleteFile.do?fileId=' + file.serverName
			}).done(function(data) {
				if(data.result != 1) {
					alert('원문파일 삭제시 오류가 발생하였습니다.');
				}
			});
			return true;
		}
		else return false;
	});
}

function addPrtcpnt(){
	var newId = (new Date()).valueOf();
	authorGrid.addRow(newId,[authorGrid.getRowsNum()+1,"","",'${contextPath}/images/common/icon/btn_search.png^Author search^javascript:findAuthor("'+newId+'");^_self',"","","","",'${contextPath}/images/common/icon/btn_search.png^Inst. search^javascript:findInst("'+newId+'");^_self',"${param.articleId}","999",""],authorGrid.getRowIndex(authorGrid.getSelectedId()));
	reAlignOrder();
	var rowIndex = authorGrid.getRowIndex(newId);
	authorGrid.selectRow(rowIndex,true,true,true);
	//authorGrid.showRow(newId);
}

function delPrtcpnt(){
	authorGrid.deleteSelectedItem();
}

function moveUp(){
	authorGrid.moveRowUp(authorGrid.getSelectedId());
	reAlignOrder();
}

function moveDown(){
	authorGrid.moveRowDown(authorGrid.getSelectedId());
	reAlignOrder();
}

function reAlignOrder(){
	var cIndex_dispOrder = authorGrid.getColIndexById("dispOrder");
	var rowIds = authorGrid.getAllRowIds();
	rowIds = rowIds.split(",");
	for(var i = 0; i < rowIds.length; i++){
		var rowID = rowIds[i];
		var dispOrder = authorGrid.cells(rowID, cIndex_dispOrder).getValue();
		var rowIndex = authorGrid.getRowIndex(rowID)+1;
		//console.log(rowID + ", " + dispOrder + ", " + rowIndex );
		if(dispOrder != rowIndex)
		{
			authorGrid.cells(rowID, cIndex_dispOrder).setValue(rowIndex);
			if(authorDp.getState(rowID) != 'inserted') authorDp.setUpdated(rowID, true);
		}
	}
}

function saveArticle(){
	authorDp.sendData();
	authorGrid.clearAndLoad('${contextPath}/article/findArticlePartiList.do?articleId=${param.articleId}', function(){
		myForm.setItemValue("totalAthrCnt",authorGrid.getRowsNum());
		myForm.send("${contextPath}/article/updateArticle.do","post",function(loader, response){
			var json = eval("("+response+")");
			if(json.result != 1)
			{
				dhtmlx.alert({type:"alert-error",text:"저장 중에 에러가 발생하였습니다. 관리자에게 문의하세요.",callback:function(){}})
			}
			else
			{
				dhtmlx.alert({type:"alert-warning",text:"저장 하였습니다.",callback:function(){}})
			}
		});
	});
}

function deleteArticle(){
	dhtmlx.confirm({
		ok:"삭제", cancel:"취소",
		text:"논문을 삭제하시겠습니까? ",
		callback:function(result){
			if(result == true)
			{
				myForm.send("${contextPath}/article/deleteArticle.do","post",function(loader, response){
					var json = eval("("+response+")");
					if(json.result != 1)
					{
						dhtmlx.alert({type:"alert-error",text:"삭제 중에 에러가 발생하였습니다. 관리자에게 문의하세요.",callback:function(){}})
					}
					else
					{
						dhtmlx.alert({type:"alert-warning",text:"정삭적으로 삭제하였습니다.",callback:function(){}})
					}
				});
			}
			else
			{
				return;
			}
		}
	});
}

function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){ dhxLayout.setSizes(false); },200);}
function authorGrid_load(){
	authorGrid.clearAndLoad('${contextPath}/article/findArticlePartiList.do?articleId=${param.articleId}');
}

var dhxWins, myLayout, pageX, pageY, winToolbar, winGrid;
function  findJournal(e) {

	if (!e) var e = window.event;
	var pos = getMouseClickPosition(e);
	if((parseInt(pos[0])||0) == 0  ){
		pageX = 500;
		pageY = 325;
	}else {
    	pageX = pos[0] - 583;
	    pageY = pos[1] + 20;
	}

	if(dhxWins != null && dhxWins.unload != null)
	{
		dhxWins.unload();
		dhxWins = null;
	}

	dhxWins = new dhtmlXWindows({
		viewport : {objec : 'windVP'},
		wins : [ {id : 'w1', left : pageX, top : pageY, width: 600, height: 450, text: "학술지검색", resize : false} ]
	});
	myLayout = dhxWins.window('w1').attachLayout('2E')
	myLayout.cells('a').hideHeader();
	myLayout.cells('b').hideHeader();
	myLayout.cells("a").setHeight(60);

	winToolbar = myLayout.cells("b").attachToolbar();
	winToolbar.setIconsPath("${contextPath}/images/common/icon/");
	winToolbar.setIconSize(18);
	winToolbar.addInput("keyword", 0, myForm.getItemValue("scjnlNm"), 515);
	winToolbar.addButton("search", 1, "", "btn_search.png", "btn_search.png");
	winToolbar.attachEvent("onClick", function(id) {
		if (id == "search"){
			winGrid.loadXML('${contextPath}/journal/findJournalListByKeyword.do?keyword=' + encodeURIComponent(winToolbar.getValue('keyword')));
		}
	});
	winToolbar.attachEvent("onEnter", function(id,value) {
		if(value == "")
		{
			dhtmlx.alert({type:"alert-warning",text:"검색어를 입력하세요.",callback:function(){}})
		}
		else
		{
			winGrid.loadXML('${contextPath}/journal/findJournalListByKeyword.do?keyword=' + encodeURIComponent(winToolbar.getValue('keyword')));
		}
    });


	winGrid = myLayout.cells("b").attachGrid();
	winGrid.setImagePath('${dhtmlXImagePath}');
	winGrid.setHeader('ISSN,학술지명,발행처명,구분',null, grid_head_center_bold);
	winGrid.setInitWidths("80,*,145,60");
	winGrid.setColAlign('center,left,left,center');
	winGrid.setColTypes('ro,ro,ro,ro');
	winGrid.setColSorting('str,str,str,str');
	winGrid.enableColSpan(true);
	winGrid.attachEvent("onXLS", function() {
		dhxWins.window('w1').progressOn();
	});
	winGrid.attachEvent("onXLE", function() {
		dhxWins.window('w1').progressOff();
	});
	winGrid.attachEvent('onRowSelect', journal_onRowSelect);
	winGrid.init();
	winGrid.loadXML('${contextPath}/journal/findJournalListByKeyword.do?keyword=' + encodeURIComponent(winToolbar.getValue('keyword')));
}
function journal_onRowSelect(id){
	var cell0 = winGrid.cells(winGrid.getSelectedId(),0).getValue();
	var cell1 = winGrid.cells(winGrid.getSelectedId(),1).getValue();
	//var cell2 = winGrid.cells(winGrid.getSelectedId(),2).getValue();
	var cell3 = winGrid.cells(winGrid.getSelectedId(),2).getValue();
	var cell4 = id.split("_")[1];
	var cotCode = id.split("_")[2];
	//var py    = winGrid.cells(winGrid.getSelectedId(),4).getValue();
	if(cell4 != "" )
	{
		myForm.setItemValue("scjnlDvsCd","1");
	}
	if(cell4.indexOf("*") == -1 )
	{
	   myForm.setItemValue("issnNo",cell0);
	}
	myForm.setItemValue("scjnlNm",cell1.replace("&amp;","&"));
	myForm.setItemValue("pblcPlcNm",cell3.replace("&amp;","&"));
	myForm.setItemValue("pblcNtnCd",cotCode);
	/*
	if($('pblcYm').value == ''){
		$('pblcYm').value = py;
	}
	*/
	myForm.setItemValue("ovrsExclncScjnlPblcYn",cell4);

	//scjnlDvs();
	//ifUpdate();
	//onFocusHelp('pblcPlcNm');
	dhxWins.window('w1').close();
}

function findAuthor(rowID, e){

	var pageX = Math.max(0, (($(window).width() - 550) / 2) + $(window).scrollLeft());
	var pageY = Math.max(0, (($(window).height() - 350) / 2) + $(window).scrollTop());

	if(dhxWins != null && dhxWins.unload != null)
	{
		dhxWins.unload();
		dhxWins = null;
	}

	dhxWins = new dhtmlXWindows({
		viewport : {objec : 'windVP'},
		wins : [ {id : 'w1', left : pageX, top : pageY, width: 600, height: 350, text: "저자검색", resize : false} ]
	});

	myLayout = dhxWins.window('w1').attachLayout('2E')
	myLayout.cells('a').hideHeader();
	myLayout.cells('b').hideHeader();
	myLayout.cells("a").setHeight(55);

	winToolbar = myLayout.cells("b").attachToolbar();
	winToolbar.setIconsPath("${contextPath}/images/common/icon/");
	winToolbar.setIconSize(18);
	winToolbar.addInput("keyword", 0, authorGrid.cells(rowID, authorGrid.getColIndexById("prtcpntNm")).getValue(), 515);
	winToolbar.addButton("search", 1, "", "btn_search.png", "btn_search.png");
	winToolbar.attachEvent("onClick", function(id) {
		if (id == "search"){
			winGrid.loadXML('${contextPath}/user/findAuthorListByKeyword.do?keyword=' + encodeURIComponent(winToolbar.getValue('keyword')));
		}
	});
	winToolbar.attachEvent("onEnter", function(id,value) {
		if(value == "")
		{
			dhtmlx.alert({type:"alert-warning",text:"검색어를 입력하세요.",callback:function(){}})
		}
		else
		{
			winGrid.loadXML('${contextPath}/user/findAuthorListByKeyword.do?keyword=' + encodeURIComponent(winToolbar.getValue('keyword')));
		}
    });

	winGrid = myLayout.cells("b").attachGrid();
	winGrid.setImagePath('${dhtmlXImagePath}');
	winGrid.setHeader('사번,영문명(Abbr.),영문명(Full),한글명,소속,직급',null, grid_head_center_bold);
	winGrid.setInitWidths("60,90,90,90,*,100");
	winGrid.setColAlign('center,center,center,center,center,center');
	winGrid.setColTypes('ro,ro,ro,ro,ro,ro');
	winGrid.setColSorting('str,str,str,str,str,str');
	winGrid.enableColSpan(true);
	winGrid.attachEvent("onXLS", function() {
		dhxWins.window('w1').progressOn();
	});
	winGrid.attachEvent("onXLE", function() {
		dhxWins.window('w1').progressOff();
	});
	winGrid.attachEvent('onRowSelect', author_onRowSelect);
	winGrid.init();
	winGrid.loadXML('${contextPath}/user/findAuthorListByKeyword.do?keyword=' + encodeURIComponent(winToolbar.getValue('keyword')));

}
function author_onRowSelect(id, index){
	//<row id='${ul.userId};${ul.korNm};${engNm};${engAbbrNm}' >
	if( index != 1 && index != 2 && index != 3 )
	{
		dhtmlx.alert({type:"alert-warning",text:"영문논문은 영문명, 한글논문은 한글명을 선택 입력하십시오.",callback:function(){}})
		winGrid.clearSelection();
	}
	else
	{
		var userData = id.split(";");
		var userId = userData[0];
		var korNm = userData[1];
		var engNm = userData[2];
		var engAbbr = userData[3];

		var rowId = authorGrid.getSelectedRowId();
		var cIndex_prtcpntNm = authorGrid.getColIndexById("prtcpntNm");
		var cIndex_prtcpntFullNm = authorGrid.getColIndexById("prtcpntFullNm");
		var cIndex_prtcpntId = authorGrid.getColIndexById("prtcpntId");
		var cIndex_blngAgcNm = authorGrid.getColIndexById("blngAgcNm");
		var cIndex_blngAgcCd = authorGrid.getColIndexById("blngAgcCd");

		authorGrid.cells(rowId, cIndex_prtcpntId).setValue(userId);
		if (index == 1 || index == 2)
		{
			if( engAbbr != null && engAbbr != '')
			{
				authorGrid.cells(rowId, cIndex_prtcpntNm).setValue(engAbbr);
			}
			else
			{
				var currPrtcpntNm = authorGrid.cells(rowId,cIndex_prtcpntNm).getValue();
				if(currPrtcpntNm == null || currPrtcpntNm == '')
				{
					authorGrid.cells(rowId, cIndex_prtcpntNm).setValue(engNm);
				}
			}
			authorGrid.cells(rowId, cIndex_prtcpntFullNm).setValue(engNm);

		}
		else if (index == 3) // 한글명을 prtcpntNm에 입력함
		{
			authorGrid.cells(rowId, cIndex_prtcpntNm).setValue(korNm);
			authorGrid.cells(rowId, cIndex_prtcpntFullNm).setValue("");
		}
		authorGrid.cells(rowId, cIndex_blngAgcNm).setValue("${sysConf['inst.blng.agc.name']}");
		authorGrid.cells(rowId, cIndex_blngAgcCd).setValue("${sysConf['inst.blng.agc.code']}");
		dhxWins.window('w1').close();
	}

}


function findInst(rowID){
	var pageX = Math.max(0, (($(window).width() - 550) / 2) + $(window).scrollLeft());
	var pageY = Math.max(0, (($(window).height() - 350) / 2) + $(window).scrollTop());

	if(dhxWins != null && dhxWins.unload != null)
	{
		dhxWins.unload();
		dhxWins = null;
	}

	dhxWins = new dhtmlXWindows({
		viewport : {objec : 'windVP'},
		wins : [ {id : 'w1', left : pageX, top : pageY, width: 600, height: 350, text: "기관검색", resize : false} ]
	});

	myLayout = dhxWins.window('w1').attachLayout('2E')
	myLayout.cells('a').hideHeader();
	myLayout.cells('b').hideHeader();
	myLayout.cells("a").setHeight(55);

	var keywordStr = authorGrid.cells(rowID, authorGrid.getColIndexById("blngAgcNm")).getValue();
	if(keywordStr == null || keywordStr == "") keywordStr = "${sysConf['inst.blng.agc.name']}";

	winToolbar = myLayout.cells("b").attachToolbar();
	winToolbar.setIconsPath("${contextPath}/images/common/icon/");
	winToolbar.setIconSize(18);
	winToolbar.addInput("keyword", 0, keywordStr, 515);
	winToolbar.addButton("search", 1, "", "btn_search.png", "btn_search.png");


	winToolbar.attachEvent("onClick", function(id) {
		if (id == "search"){
			winGrid.loadXML('${contextPath}/code/findOrgCodeList.do?keyword=' + encodeURIComponent(winToolbar.getValue('keyword')));
		}
	});
	winToolbar.attachEvent("onEnter", function(id,value) {
		if(value == "")
		{
			dhtmlx.alert({type:"alert-warning",text:"검색어를 입력하세요.",callback:function(){}})
		}
		else
		{
			winGrid.loadXML('${contextPath}/code/findOrgCodeList.do?keyword=' + encodeURIComponent(winToolbar.getValue('keyword')));
		}
    });

	winGrid = myLayout.cells("b").attachGrid();
	winGrid.setImagePath('${dhtmlXImagePath}');
	winGrid.setHeader('기관/대학명',null, grid_head_center_bold);
	winGrid.setInitWidths("*");
	winGrid.setColAlign('center');
	winGrid.setColTypes('ro');
	winGrid.setColSorting('str');
	winGrid.enableColSpan(true);
	winGrid.attachEvent("onXLS", function() {
		dhxWins.window('w1').progressOn();
	});
	winGrid.attachEvent("onXLE", function() {
		dhxWins.window('w1').progressOff();
	});
	winGrid.attachEvent('onRowSelect', institute_onRowSelect);
	winGrid.init();
	winGrid.loadXML('${contextPath}/code/findOrgCodeList.do?keyword=' + encodeURIComponent(winToolbar.getValue('keyword')));

}
function institute_onRowSelect(id){
	var codeData = id.split("_");
	var code = codeData[0];
	var value = codeData[1];

	var rowId = authorGrid.getSelectedRowId();
	var cIndex_blngAgcNm = authorGrid.getColIndexById("blngAgcNm");
	var cIndex_blngAgcCd = authorGrid.getColIndexById("blngAgcCd");

	authorGrid.cells(rowId, cIndex_blngAgcNm).setValue(value);
	authorGrid.cells(rowId, cIndex_blngAgcCd).setValue(code);

	dhxWins.window('w1').close();
}


</script>
</head>
<body>
	<div id="mainLayout" style="width:100%;"></div>
	<script type="text/javascript">setMainLayoutHeight($('#mainLayout'));</script>
</body>
</html>