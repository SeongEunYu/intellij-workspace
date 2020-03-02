<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/pageInit.jsp" %>
<html>
<head>
	<style>
		.dhxwins_vp_dhx_terrace div.dhxwin_active div.dhx_cell_wins div.dhx_cell_toolbar_def, .dhxwins_vp_dhx_terrace div.dhxwin_inactive div.dhx_cell_wins div.dhx_cell_toolbar_def { padding: 10px 0px 0; }
		.dhx_toolbar_dhx_terrace { padding: 0 0px; }
		.dhx_toolbar_dhx_terrace div.dhx_toolbar_btn div.dhxtoolbar_text {padding: 0; margin: 4px 5px;}
	</style>
	<script type="text/javascript" src="${contextPath}/js/mainLayout.js"></script>
	<script type="text/javascript">

		var dhxLayout, winDhxLayout, deptInfoGrid, deptGrid, myDp, t, wins, test;

		var drag_stat = false;

		$(function() {

			$('#mainLayout').css('height', ($(document).height() - (130 +  $('.title_box').height() + $('.header_wrap').height() + $('.nav_wrap').height() + $('.list_bt_area').height()     )) + "px");

			if(window.attachEvent) window.attachEvent("onresize",resizeLayout);
			else window.addEventListener("resize",resizeLayout, false);

			dhxLayout = new dhtmlXLayoutObject("mainLayout","2U");
			dhxLayout.cells("a").hideHeader();
			dhxLayout.cells("b").hideHeader();
			dhxLayout.cells("a").setWidth(650);
			dhxLayout.setSizes(false);
			dhxLayout.setAutoSize("a","a;b");
			dhxLayout.cells("a").attachObject('listbox');
			dhxLayout.cells("b").attachHTMLString('<div id="deptInfo" style="width:100%;height:100%;overflow:auto;"></div>');
			setGridHeight();
			deptInfoGrid = new dhtmlXGridObject('gridbox');
			deptInfoGrid.setImagePath("${dhtmlXImagePath}");
			deptInfoGrid.setHeader("한글,영어,정렬순서,축약형,최대축약형,대표자,코드형태,사용여부,대표자ID", null, grid_head_center_bold);
			deptInfoGrid.setColumnIds("DeptKorNm,DeptEngNm,DispOrder,DeptEngAbbr,DeptEngMostAbbr,DrhfEmpNm,DeptCode,IsUsed,DrhfEmpId");
			deptInfoGrid.setInitWidths("*,*,100,1,1,1,1,1,1");
			deptInfoGrid.setColAlign("left,left,center,center,center,center,center,center,center");
			deptInfoGrid.setColTypes("tree,ro,ed,ro,ro,ro,ro,ro,ro,ro");
			deptInfoGrid.setColSorting("str,str,int,str,str,str,str,str,str");
			deptInfoGrid.setColumnColor("#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF");
			deptInfoGrid.setEditable(true);
			deptInfoGrid.enableColSpan(true);
			deptInfoGrid.setColumnHidden(deptInfoGrid.getColIndexById("DeptEngAbbr"),true);
			deptInfoGrid.setColumnHidden(deptInfoGrid.getColIndexById("DeptEngMostAbbr"),true);
			deptInfoGrid.setColumnHidden(deptInfoGrid.getColIndexById("DrhfEmpNm"),true);
			deptInfoGrid.setColumnHidden(deptInfoGrid.getColIndexById("DeptCode"),true);
			deptInfoGrid.setColumnHidden(deptInfoGrid.getColIndexById("IsUsed"),true);
			deptInfoGrid.setColumnHidden(deptInfoGrid.getColIndexById("DrhfEmpId"),true);
			deptInfoGrid.setColumnHidden(deptInfoGrid.getColIndexById("DispOrder"),true);
			// deptInfoGrid.enableDragAndDrop(true);
			// deptInfoGrid.setDragBehavior("sibling-next");
			deptInfoGrid.attachEvent("onRowSelect", doOnRowSelected);
			deptInfoGrid.attachEvent("onXLS", doBeforeGridLoad);
			deptInfoGrid.attachEvent("onXLE", deptInfoGrid_onSelectPageFirstRow);
			deptInfoGrid.attachEvent("onEditCell", function(stage,rId,cInd,nValue,oValue){
				return cInd == 2;
			});
			deptInfoGrid.attachEvent('onBeforeSelect', function(id){return id !== 'root_1';});
			//deptInfoGrid.enablePaging(true,100,10,"pagingArea",true);
			//deptInfoGrid.setPagingSkin("${dhtmlXPagingSkin}");
			deptInfoGrid.init();
			deptInfoGrid_load();

			myDp = new dataProcessor('commonDeptCUD.do');
			myDp.init(deptInfoGrid);
			myDp.setTransactionMode("POST", false);
			myDp.setUpdateMode("on");
			myDp.setVerificator(0, myGRID_not_empty);
			myDp.setVerificator(1, myGRID_not_empty);
			myDp.attachEvent("onValidationError", function(id, details) {
				console.log(details);
				dhtmlx.alert({type:"alert",text:"한글과 영문명을 모두 입력해주세요.",callback:null});
			});
			myDp.attachEvent("onFullSync", function() {
				deptInfoGrid_load();
				dhtmlx.alert({type:"alert",text:"저장되었습니다.",callback:null});
			});
			myDp.enableDataNames(true);
		});

		function setGridHeight(){
			var gridHeight = $('#mainLayout').height();
			$('#gridbox').css('height',gridHeight+"px");
		}

		function searchResearcher(obj) {
			var wWidth = 600;
			var wHeight = 350;
			var pageX = $(window).width() /2 - wWidth /2 + $(window).scrollLeft();
			var pageY = $(window).height() /2 - wHeight /2 + $(window).scrollTop();

			if(wins != null && wins.unload != null)
			{
				wins.unload();
				wins = null;
			}

			wins = new dhtmlXWindows({
				viewport : {objec : 'windVP'},
				wins : [ {id : 'w1', left : pageX, top : pageY, width: wWidth, height: wHeight, text: getText("tit_res_sear"), resize : false} ]
			});
			wins.window('w1').setModal(true);

			winDhxLayout = wins.window('w1').attachLayout('2E');
			winDhxLayout.cells("a").hideHeader();
			winDhxLayout.cells("b").hideHeader();
			winDhxLayout.cells("a").attachURL(contextpath+"/"+preUrl+"/i18n/winhelp/help_findUser.do");
			winDhxLayout.cells("a").setHeight(55);

			winToolbar = winDhxLayout.cells("b").attachToolbar();
			winToolbar.setIconsPath(contextpath+"/images/common/icon/");
			winToolbar.addInput("keyword", 0, "", 515);
			winToolbar.addButton("search", 1, "", "tbl_search_icon.png", "tbl_search_icon.png");
			winToolbar.attachEvent("onClick", function(id) {
				if (id == "search"){
					winGrid.clearAndLoad(contextpath+'/user/findAuthorListByKeyword.do?keyword=' + encodeURIComponent(winToolbar.getValue('keyword')));
				}
			});
			winToolbar.attachEvent("onEnter", function(id,value) {
				if (value == "")
				{
					dhtmlx.alert({type:"alert-warning",text:"검색어를 입력하세요.",callback:function(){}});
				}
				else
				{
					winGrid.clearAndLoad(contextpath+ '/user/findAuthorListByKeyword.do?keyword=' + encodeURIComponent(winToolbar.getValue('keyword')));
				}
			});

			winGrid = winDhxLayout.cells("b").attachGrid();
			winGrid.setImagePath(contextpath+'/js/codebase/imgs/');
			winGrid.setHeader(getText("tit_res_grid"),null,grid_head_center_bold);
			//사번,영문명(Abbr),영문명(Full),한글명,소속,직급,PosiCd
			winGrid.setColumnIds("userId,engAbbr,engFull,korNm,deptKor,posiNm,posiCd");
			winGrid.setInitWidths("60,90,90,90,*,100,1");
			winGrid.setColAlign("center,left,left,center,left,left,center");
			winGrid.setColTypes("ro,ro,ro,ro,ro,ro,ro");
			winGrid.setColSorting("str,str,str,str,str,str,str");
			winGrid.enableColSpan(true);
			winGrid.setColumnHidden(winGrid.getColIndexById("posiCd"),true);
			winGrid.attachEvent("onXLS", function() {
				wins.window('w1').progressOn();
			});
			winGrid.attachEvent("onXLE", function() {
				wins.window('w1').progressOff();
			});
			winGrid.attachEvent('onRowSelect', function(id, index){
				var userId = winGrid.cells(id, winGrid.getColIndexById("userId")).getValue();
				var korNm = winGrid.cells(id, winGrid.getColIndexById("korNm")).getValue();
				var parent = $(obj).parent();
				parent.children().remove();
				parent.prepend("<a href=\"javascript:void(0);\" class=\"tbl_icon_a tbl_search_icon\" onclick=\"searchResearcher($(this));\">검색</a>" +
						"<span style='margin-left: 12px;'>"+korNm+"</span><input name='drhfEmpId' id='drhfEmpId' type='hidden' value='"+userId+"'/>");
				wins.window('w1').close();
			});
			winGrid.init();
		}

		function deptInfoGrid_load() {
			doBeforeGridLoad();
			var url = 'findDeptList.do?'+$('#formArea').serialize();
			deptInfoGrid.clearAndLoad(url, doOnGridLoaded);
		}

		function doOnRowSelected(rowID,celInd) {
			var str = rowID.split('_');

			$.post('${contextPath}/code/dept/modifyForm.do',{'code' : str[1],'gubun':str[0]},null,'text').done(function(data){
				$('#deptInfo').html(data);
			});
		}

		function deptInfoGrid_onSelectPageFirstRow(){
			deptInfoGrid.selectRow(1,true,true,true);
			deptInfoGrid.showRow(deptInfoGrid.getRowId(1));
			doOnGridLoaded();
		}

		function save() {
			var dept = deptInfoGrid;
			var selId = dept.getSelectedId();
			if(selId !== null) {
				dept.cellById(selId, dept.getColIndexById("DeptCode")).setValue($('#deptCode').val());
				dept.cellById(selId, dept.getColIndexById("DeptKorNm")).setValue($('#deptKorNm').val());
				dept.cellById(selId, dept.getColIndexById("DeptEngNm")).setValue($('#deptEngNm').val());
				dept.cellById(selId, dept.getColIndexById("DeptEngAbbr")).setValue($('#deptEngAbbr').val());
				dept.cellById(selId, dept.getColIndexById("DeptEngMostAbbr")).setValue($('#deptEngMostAbbr').val());
				dept.cellById(selId, dept.getColIndexById("DrhfEmpNm")).setValue($('#drhfEmpNm').val());
				dept.cellById(selId, dept.getColIndexById("IsUsed")).setValue($('#isUsed').val());
				dept.cellById(selId, dept.getColIndexById("DrhfEmpId")).setValue($('#drhfEmpId').val());
				myDp.setUpdated(selId, true, "updated");
			}
			myDp.sendData();
		}

		var id_idx = 0;
		function addnew(status) {
			var dept = deptInfoGrid;
			var selId = dept.getSelectedId();
			if(selId != null) {
				var gr_id, pid, disp;
				var depth = selId.split('_')[0];
				if (status === 'same') {
					gr_id = (depth === 'dept' ? 'dept_D' : 'clg_C') + new Date().valueOf();
					pid = dept.getParentId(selId) === 0 ? 'root_1' : dept.getParentId(selId);
				} else if (status === 'down') {
					gr_id = (depth === 'root' ? 'clg_C' : 'dept_D') + new Date().valueOf();
					pid = depth === 'dept' ? dept.getParentId(selId) : selId;
				}
				if (dept.hasChildren(pid) !== 0) disp = Number(dept.cells(dept.getChildItemIdByIndex(pid, dept.hasChildren(pid) - 1), 2).getValue()) + 1;
				dept.addRow(gr_id, ['', '', disp, '', '', '', '', 'Y', '', ''], null, pid);
				dept.openItem(gr_id);
				dept.selectRowById(gr_id);
				doOnRowSelected(gr_id);
			}
		}

		function moveRow(status) {
			var dept = deptInfoGrid;
			var selectId = dept.getSelectedId();
			var sIdx= dept.getRowIndex(selectId);
			var tIdx = findSameLevelRowIndex(selectId, sIdx, status);
			if(tIdx !== -1){
				var targetId = dept.getRowId(tIdx);
				var targetValue = dept.cells(targetId,2).getValue();
				var selectValue = dept.cells(selectId,2).getValue();
				dept.cells(targetId,2).setValue(selectValue);
				dept.cells(selectId,2).setValue(targetValue);
				myDp.setUpdated(targetId,true,"updated");
				myDp.setUpdated(selectId,true,"updated");
			}
			if(status === 'Up'){
				dept.moveRowUp(dept.getSelectedId())
			}else if(status === 'Down'){
				dept.moveRowDown(dept.getSelectedId())
			}
		}

		function findSameLevelRowIndex(selectId, sIdx, status){
			var i = 1;
			if(status === 'Up'){
				while(true){
					var targetId=deptInfoGrid.getRowId(sIdx-i); //hear
					if(targetId === 'root_1') return -1;
					if(targetId.split('_')[0] === selectId.split('_')[0]){
						break;
					}
					i++;
				}
				return sIdx-i;
			}else if(status === 'Down'){
				while(true){
					var targetId=deptInfoGrid.getRowId(sIdx+i);
					if(targetId === undefined) return -1;
					if(targetId.split('_')[0] === selectId.split('_')[0]){
						break;
					}
					i++;
				}
				return sIdx+i;
			}
		}

		function cut() {
			deptInfoGrid.deleteSelectedItem();
		}

		function myGRID_not_empty(value, id, ind) {
		    return value.trim() != "";
		}

		function resizeLayout() { window.clearTimeout(t); t = window.setTimeout(function(){ dhxLayout.setSizes(false); }, 200); }
		function doBeforeGridLoad() { dhxLayout.cells("a").progressOn(); }
		function doOnGridLoaded() { setTimeout(function() { dhxLayout.cells("a").progressOff(); }, 100); }

	</script>
</head>
<body>
	<!-- Page Title -->
	<div class="title_box">
		<h3><spring:message code='menu.dept'/></h3>
	</div>
	<!-- Main Content -->
	<div class="contents_box">
		<form id="formArea" onsubmit="return false;">
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
					<th>사용여부</th>
					<td colspan="3">
						<select name="gubun" id="gubun" onchange="deptInfoGrid_load();">
							<option value="">사용중</option>
							<option value="ALL">미사용 포함</option>
						</select>
					</td>
					<td class="option_search_td" onclick="javascript:deptInfoGrid_load();"><em>search</em></td>
				</tr>
				</tbody>
			</table>
		</form>
		<div class="list_bt_area">
			<div class="list_set" style="float:left;">
				<ul>
					<li><a href="#" onclick="moveRow('Up');" class="row_up_bt">Up</a></li>
					<li><a href="#" onclick="moveRow('Down');" class="row_down_bt">Down</a></li>
				</ul>
			</div>
			<div class="list_set">
				<ul>
					<li><a href="#" onclick="javascript:addnew('same');" class="list_icon12">추가</a></li>
					<li><a href="#" onclick="javascript:addnew('down');" class="list_icon12">하위추가</a></li>
					<li><a href="#" onclick="javascript:save();" class="list_icon02">저장</a></li>
					<li><a href="#" onclick="javascript:cut();" class="list_icon22">삭제</a></li>
				</ul>
			</div>
		</div>
		<div id="listbox">
			<div id="gridbox" style="position: relative; width: 100%;height: 100%;"></div>
		</div>
		<div id="mainLayout" style="width: 100%;height: 100%;"></div>
	</div>
</body>
</html>