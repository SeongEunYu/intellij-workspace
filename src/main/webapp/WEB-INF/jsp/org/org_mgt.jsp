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

		var dhxLayout, orgChartGrid, myDp, t;

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
			dhxLayout.cells("b").attachHTMLString('<div id="orgInfo" style="width:100%;height:100%;overflow:auto;"></div>');
			setGridHeight();
			orgChartGrid = dhxLayout.cells("a").attachGrid();
			orgChartGrid.setImagePath("${dhtmlXImagePath}");
			orgChartGrid.setHeader("한글,영어,정렬순서,축약형,대표자,코드형태,사용여부,대표자ID,자식수", null, grid_head_center_bold);
			orgChartGrid.setColumnIds("OrgKorNm,OrgEngNm,DisplayOrder,OrgEngAbbrNm,OrgHeadNm,OrgCd,Status,OrgHeadId,ChildNum");
			orgChartGrid.setInitWidths("*,*,100,1,1,1,1,1,1");
			orgChartGrid.setColAlign("left,center,center,center,center,center,center,center,center");
			orgChartGrid.setColTypes("tree,ro,ed,ro,ro,ro,ro,ro,ro");
			orgChartGrid.setColSorting("str,str,int,str,str,str,str,str,str");
			orgChartGrid.setColumnColor("#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF");
			orgChartGrid.setEditable(true);
			orgChartGrid.enableColSpan(true);
			orgChartGrid.setColumnHidden(orgChartGrid.getColIndexById("OrgEngAbbrNm"),true);
			orgChartGrid.setColumnHidden(orgChartGrid.getColIndexById("OrgHeadNm"),true);
			orgChartGrid.setColumnHidden(orgChartGrid.getColIndexById("OrgCd"),true);
			orgChartGrid.setColumnHidden(orgChartGrid.getColIndexById("Status"),true);
			orgChartGrid.setColumnHidden(orgChartGrid.getColIndexById("OrgHeadId"),true);
			orgChartGrid.setColumnHidden(orgChartGrid.getColIndexById("ChildNum"),true);
			// orgChartGrid.setColumnHidden(orgChartGrid.getColIndexById("DisplayOrder"),true);
			orgChartGrid.attachEvent("onRowSelect", doOnRowSelected);
			orgChartGrid.attachEvent("onXLS", doBeforeGridLoad);
			orgChartGrid.attachEvent("onXLE", orgChartGrid_onSelectPageFirstRow);
			orgChartGrid.attachEvent("onEditCell", function(stage,rId,cInd,nValue,oValue){
				return cInd == 2;
			});
			orgChartGrid.init();
			orgChartGrid_load();

			myDp = new dataProcessor('commonOrgCUD.do');
			myDp.init(orgChartGrid);
			myDp.setTransactionMode("POST", false);
			myDp.setUpdateMode("on");
			myDp.enableDataNames(true);
			myDp.setVerificator(0, myGRID_not_empty);
			myDp.setVerificator(1, myGRID_not_empty);
			myDp.attachEvent("onFullSync", function() {
				orgChartGrid_load();
				dhtmlx.alert({type:"alert",text:"저장되었습니다.",callback:null});
			});
			myDp.attachEvent("onValidationError", function(id, details) {
				console.log(details);
				dhtmlx.alert({type:"alert",text:"한글과 영문명을 모두 입력해주세요.",callback:null});
			});
			myDp.enableDataNames(true);
		});

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
						"<span style='margin-left: 12px;'>"+korNm+"</span><input name='orgHeadId' id='orgHeadId' type='hidden' value='"+userId+"'/>" +
						"<input name='orgHeadNm' id='orgHeadNm' type='hidden' value='"+korNm+"'/>");
				wins.window('w1').close();
			});
			winGrid.init();
		}

		function doOnRowSelected(rowID,celInd) {
			$.post('${contextPath}/code/orgChart/modifyForm.do',{'code' : rowID},null,'text').done(function(data){
				$('#orgInfo').html(data);
			});
		}

		function setGridHeight(){
			var gridHeight = $('#mainLayout').height();
			$('#gridbox').css('height',gridHeight+"px");
		}

		function orgChartGrid_load() {
			doBeforeGridLoad();
			var url = 'findOrgChartList.do?'+$('#formArea').serialize();
			orgChartGrid.clearAndLoad(url, doOnGridLoaded);
		}

		function orgChartGrid_onSelectPageFirstRow(){
			orgChartGrid.selectRow(0,true,true,true);
			orgChartGrid.showRow(orgChartGrid.getRowId(0));
			doOnGridLoaded();
		}

		function save() {
			var org = orgChartGrid;
			var selId = org.getSelectedId();
			if(selId !== null){
				org.cellById(selId,org.getColIndexById("OrgKorNm")).setValue($('#orgKorNm').val());
				org.cellById(selId,org.getColIndexById("OrgEngNm")).setValue($('#orgEngNm').val());
				org.cellById(selId,org.getColIndexById("OrgEngAbbrNm")).setValue($('#orgEngAbbrNm').val());
				org.cellById(selId,org.getColIndexById("OrgHeadNm")).setValue($('#orgHeadNm').val());
				org.cellById(selId,org.getColIndexById("Status")).setValue($('#status').val());
				org.cellById(selId,org.getColIndexById("OrgHeadId")).setValue($('#orgHeadId').val());
				myDp.setUpdated(selId,true,"updated");
			}
			myDp.sendData();
		}

		function addnew(status) {
			if(orgChartGrid.getRowsNum() != 0){
				var org = orgChartGrid;
				var selId = org.getSelectedId();
				if(selId != null) {
					var gr_id, pid, disp = 0 ;
					if (status === 'down') {
						gr_id = (1 + Number(selId.split('_')[0] !== 'TOP' ? selId.split('_')[0] : '0')) + '_new_' + (new Date()).valueOf();
						pid = selId;
					} else if (status === 'same') {
						gr_id = (selId.split('_')[0] !== 'TOP' ? selId.split('_')[0] : '1') + '_new_' + (new Date()).valueOf();
						pid = selId.split('_')[0] !== 'TOP' ? org.getParentId(selId) : selId;
					}
					if (org.hasChildren(pid) !== 0) disp = Number(org.cells(org.getChildItemIdByIndex(pid, org.hasChildren(pid) - 1), 2).getValue()) + 1;
					org.addRow(gr_id, ['', '', disp, '', '', '', 'C', ''], null, pid);
					org.openItem(gr_id);
					org.selectRowById(gr_id);
					doOnRowSelected(gr_id);
				}
			}
		}

		function moveRow(status) {
			var org = orgChartGrid;
			var selectId = org.getSelectedId();
			var sIdx= org.getRowIndex(selectId);
			var tIdx = findSameLevelRowIndex(selectId, sIdx, status);
			if(tIdx !== -1){
				var targetId = org.getRowId(tIdx);
				var targetValue = org.cells(targetId,2).getValue();
				var selectValue = org.cells(selectId,2).getValue();
				org.cells(targetId,2).setValue(selectValue);
				org.cells(selectId,2).setValue(targetValue);
				myDp.setUpdated(targetId,true,"updated");
				myDp.setUpdated(selectId,true,"updated");
			}
			if(status === 'Up'){
				orgChartGrid.moveRowUp(orgChartGrid.getSelectedId())
			}else if(status === 'Down'){
				orgChartGrid.moveRowDown(orgChartGrid.getSelectedId())
			}
		}

		function findSameLevelRowIndex(selectId, sIdx, status){
			var i = 1;
			if(status === 'Up'){
				while(true){
					var targetId=orgChartGrid.getRowId(sIdx-i); //hear
					if(targetId === 'TOP_1') return -1;
					if(targetId.split('_')[0] === selectId.split('_')[0]){
						break;
					}
					i++; //hear
				}
				return sIdx-i; //hear
			}else if(status === 'Down'){
				while(true){
					var targetId=orgChartGrid.getRowId(sIdx+i);
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
			orgChartGrid.deleteSelectedItem();
		}

		function myGRID_not_empty(value, id, ind) {
		    return value.trim() !== "";
		}

		function resizeLayout() { window.clearTimeout(t); t = window.setTimeout(function(){ dhxLayout.setSizes(false); }, 200); }
		function doBeforeGridLoad() { dhxLayout.cells("a").progressOn(); }
		function doOnGridLoaded() { setTimeout(function() { dhxLayout.cells("a").progressOff(); }, 100); }

	</script>
</head>
<body>
	<!-- Page Title -->
	<div class="title_box">
		<h3><spring:message code='menu.org'/></h3>
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
						<select name="gubun" id="gubun" onchange="orgChartGrid_load();">
							<option value="">사용중</option>
							<option value="ALL">미사용 포함</option>
						</select>
					</td>
					<td class="option_search_td" onclick="orgChartGrid_load();"><em>search</em></td>
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
					<li><a href="#" onclick="addnew('same');" class="list_icon12">추가</a></li>
					<li><a href="#" onclick="addnew('down');" class="list_icon12">하위추가</a></li>
					<li><a href="#" onclick="save();" class="list_icon02">저장</a></li>
					<li><a href="#" onclick="cut();" class="list_icon22">삭제</a></li>
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