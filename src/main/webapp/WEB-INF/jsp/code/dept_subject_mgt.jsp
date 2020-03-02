<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../pageInit.jsp" %>
<html>
<head>
<style type="text/css">
.dhxtabbar_base_dhx_terrace div.dhx_cell_tabbar div.dhx_cell_cont_tabbar {border-left:0px solid #ccc;border-right:0px solid #ccc;border-bottom:0px solid #ccc;}
</style>
<script type="text/javascript" src="${contextPath}/js/mainLayout.js"></script>
<script type="text/javascript">

	var dhxLayout, jcrLayout, sjrLayout, deptGrid;
	var dhxTab;
	var jcrSubjectGrid, jcrSubjectToolbar, sjrSubjectGrid, sjrSubjectToolbar,  jcrTrgetGrid, jcrTrgetToolbar, sjrTrgetGrid, sjrTrgetToolbar, jcrSubjectDp, sjrSubjectDp;

	$(function() {

		setMainLayoutHeight($('#mainLayout'), -15);

		if (window.attachEvent) window.attachEvent("onresize",resizeLayout);
		else  window.addEventListener("resize",resizeLayout, false);

		//set layout
		dhxLayout = new dhtmlXLayoutObject({
			parent: "mainLayout",
			pattern: "2U",
			cells:[
			       	{id:'a', text:'학과목록', width:300, fix_size:[true,null]},
			       	{id:'b', text:''}
			      ]
		});
		dhxLayout.setSizes(false);

		dhxTab = dhxLayout.cells('b').attachTabbar({
			tabs:[
			      {id:'a1', text:'JCR', active:true},
			      {id:'a2', text:'SJR'},
			]
		});
		dhxTab.setArrowsMode("auto");
		dhxTab.enableAutoReSize(true);

		jcrLayout = dhxTab.tabs('a1').attachLayout('2U');
		jcrLayout.cells("a").setText("학과 JCR주제분야");
		jcrLayout.cells("b").setText("JCR주제분야목록");

		sjrLayout = dhxTab.tabs('a2').attachLayout('2U');
		sjrLayout.cells("a").setText("학과 SJR주제분야");
		sjrLayout.cells("b").setText("SJR주제분야목록");

		attachDeptJcrGrid();
		attachDeptSjrGrid();
		attachTrgetJcrGrid();
		attachTrgetSjrGrid();
		attachDeptGrid();
	});

function attachDeptJcrGrid(){

	jcrSubjectToolbar = jcrLayout.cells("a").attachToolbar();
	jcrSubjectToolbar.setIconsPath("${dhtmlXImagePath}/icons_${sysConf['dhtmlx.skin']}/");
	jcrSubjectToolbar.setIconSize(18);
	jcrSubjectToolbar.setAlign("right");
	jcrSubjectToolbar.addButton("save", 1, "저장", "save.gif", "save.gif");
	jcrSubjectToolbar.addButton("delete", 2, "삭제", "del.png", "del.png");
	jcrSubjectToolbar.attachEvent("onClick",function(id){
		if(id == 'save')
		{
			var changedIds = jcrSubjectGrid.getChangedRows();
			if(changedIds == null || changedIds.length < 1)
			{
				dhtmlx.alert('변경된 사항이 없습니다.');
				return false;
			}
			else
			{
				jcrSubjectDp.sendData();
			}
		}
		else if(id == 'delete')
		{
			if(jcrSubjectGrid.getSelectedRowId() == null)
			{
				dhtmlx.alert('삭제할 주제분야를 선택하세요.');
				return false;
			}

			dhtmlx.confirm({
				type:"confirm-warning",
				title:"학과 주제분야 삭제",
				text:"선택하신 주제분야를 삭제하시겠습니까?",
				ok:"삭제", cancel:"취소",
				callback:function(result){
					if(result == true){
						jcrSubjectGrid.deleteSelectedRows();
						jcrSubjectDp.sendData();
					}
				}
			});
		}
	});

	jcrSubjectGrid = jcrLayout.cells("a").attachGrid();
	jcrSubjectGrid.setImagePath("${dhtmlXImagePath}");
	jcrSubjectGrid.setHeader("코드,주제명,분야구분,학과코드,학과명,SEQNO",null,grid_head_center_bold);
	jcrSubjectGrid.setColumnIds("catcode,description,prodcode,deptCode,deptKor,seqNo");
	jcrSubjectGrid.setInitWidths("100,*,*,1,1,1,1");
	jcrSubjectGrid.setColAlign("center,left,left,center,center,center,center");
	jcrSubjectGrid.setColTypes("ro,ro,ro,ro,ro,ro,ro");
	jcrSubjectGrid.setColSorting("str,str,str,na,na,na,na");
	jcrSubjectGrid.setColumnHidden(jcrSubjectGrid.getColIndexById("prodcode"),true);
	jcrSubjectGrid.setColumnHidden(jcrSubjectGrid.getColIndexById("deptCode"),true);
	jcrSubjectGrid.setColumnHidden(jcrSubjectGrid.getColIndexById("deptKor"),true);
	jcrSubjectGrid.setColumnHidden(jcrSubjectGrid.getColIndexById("seqNo"),true);
	jcrSubjectGrid.attachEvent("onXLS", function(){jcrLayout.cells("a").progressOn();});
	jcrSubjectGrid.attachEvent("onXLE", function(){jcrLayout.cells("a").progressOff();});
	jcrSubjectGrid.enableDragAndDrop(true);
	jcrSubjectGrid.enableMultiselect(true);
	jcrSubjectGrid.init();

	jcrSubjectDp = new dataProcessor("${contextPath}/subject/deptSubjectCUD.do");
	jcrSubjectDp.init(jcrSubjectGrid);
	jcrSubjectDp.setTransactionMode("POST",false);
	jcrSubjectDp.setUpdateMode("off");
	jcrSubjectDp.enableDataNames(true);

}

function attachTrgetJcrGrid(){

	jcrTrgetToolbar = jcrLayout.cells("b").attachToolbar();
	jcrTrgetToolbar.setIconsPath("${dhtmlXImagePath}/icons_${sysConf['dhtmlx.skin']}/");
	jcrTrgetToolbar.setIconSize(18);
	jcrTrgetToolbar.setAlign("right");
	jcrTrgetToolbar.addButton("add", 1, "추가", "new.gif", "new_dis.gif");
	jcrTrgetToolbar.attachEvent("onClick",function(id){
		if(id == 'add')
		{
			if(jcrTrgetGrid.getSelectedRowId() == null)
			{
				dhtmlx.alert('추가할 연구분야를 선택하세요.');
				return false;
			}
			var sIds = new Array();
			var selectedIds = jcrTrgetGrid.getSelectedRowId();
			sIds = selectedIds.split(',');
			for(var i=0; i < sIds.length; i++)
			{
				var toRowId = jcrSubjectGrid.getRowId(jcrSubjectGrid.getRowsNum - 1);
				jcrTrgetGrid.moveRowTo(sIds[i],toRowId,"move","sibling",jcrTrgetGrid, jcrSubjectGrid);
			}
		}
	});

	jcrTrgetGrid = jcrLayout.cells("b").attachGrid();
	jcrTrgetGrid.setImagePath("${dhtmlXImagePath}");
	jcrTrgetGrid.setHeader("코드,대상주제명,분야구분,학과코드,학과명,id",null,grid_head_center_bold);
	jcrTrgetGrid.setColumnIds("catcode,description,prodcode,deptCode,deptKor,id");
	jcrTrgetGrid.setInitWidths("100,*,1,1,1,1");
	jcrTrgetGrid.setColAlign("center,left,center,center,center,center");
	jcrTrgetGrid.setColTypes("ro,ro,ro,ro,ro,ro");
	jcrTrgetGrid.setColSorting("str,str,na,na,na,na");
	jcrTrgetGrid.setColumnHidden(jcrTrgetGrid.getColIndexById("prodcode"),true);
	jcrTrgetGrid.setColumnHidden(jcrTrgetGrid.getColIndexById("deptCode"),true);
	jcrTrgetGrid.setColumnHidden(jcrTrgetGrid.getColIndexById("deptKor"),true);
	jcrTrgetGrid.setColumnHidden(jcrTrgetGrid.getColIndexById("id"),true);
	jcrTrgetGrid.attachEvent("onXLS", function(){jcrLayout.cells("b").progressOn();});
	jcrTrgetGrid.attachEvent("onXLE", function(){jcrLayout.cells("b").progressOff();});
	jcrTrgetGrid.enableDragAndDrop(true);
	jcrTrgetGrid.enableMultiselect(true);
	jcrTrgetGrid.init();

}

function attachDeptSjrGrid(){

	sjrSubjectToolbar = sjrLayout.cells("a").attachToolbar();
	sjrSubjectToolbar.setIconsPath("${dhtmlXImagePath}/icons_${sysConf['dhtmlx.skin']}/");
	sjrSubjectToolbar.setIconSize(18);
	sjrSubjectToolbar.setAlign("right");
	sjrSubjectToolbar.addButton("save", 1, "저장", "save.gif", "save.gif");
	sjrSubjectToolbar.addButton("delete", 2, "삭제", "del.png", "del.png");
	sjrSubjectToolbar.attachEvent("onClick",function(id){
		if(id == 'save')
		{
			var changedIds = sjrSubjectGrid.getChangedRows();
			if(changedIds == null || changedIds.length < 1)
			{
				dhtmlx.alert('변경된 사항이 없습니다.');
				return false;
			}
			else
			{
				sjrSubjectDp.sendData();
			}
		}
		else if(id == 'delete')
		{
			if(sjrSubjectGrid.getSelectedRowId() == null)
			{
				dhtmlx.alert('삭제할 주제분야를 선택하세요.');
				return false;
			}

			dhtmlx.confirm({
				type:"confirm-warning",
				title:"학과 주제분야 삭제",
				text:"선택하신 주제분야를 삭제하시겠습니까?",
				ok:"삭제", cancel:"취소",
				callback:function(result){
					if(result == true){
						sjrSubjectGrid.deleteSelectedRows();
						sjrSubjectDp.sendData();
					}
				}
			});
		}
	});

	sjrSubjectGrid = sjrLayout.cells("a").attachGrid();
	sjrSubjectGrid.setImagePath("${dhtmlXImagePath}");
	sjrSubjectGrid.setHeader("코드,주제명,분야구분,학과코드,학과명,SEQNO",null,grid_head_center_bold);
	sjrSubjectGrid.setColumnIds("catcode,description,prodcode,deptCode,deptKor,seqNo");
	sjrSubjectGrid.setInitWidths("100,*,1,1,1,1");
	sjrSubjectGrid.setColAlign("center,left,left,center,center,center");
	sjrSubjectGrid.setColTypes("ro,ro,ro,ro,ro,ro");
	sjrSubjectGrid.setColSorting("str,str,str,str,str,str");
	sjrSubjectGrid.setColumnHidden(sjrSubjectGrid.getColIndexById("prodcode"),true);
	sjrSubjectGrid.setColumnHidden(sjrSubjectGrid.getColIndexById("deptCode"),true);
	sjrSubjectGrid.setColumnHidden(sjrSubjectGrid.getColIndexById("deptKor"),true);
	sjrSubjectGrid.setColumnHidden(sjrSubjectGrid.getColIndexById("seqNo"),true);
	sjrSubjectGrid.attachEvent("onXLS", function(){sjrLayout.cells("a").progressOn();});
	sjrSubjectGrid.attachEvent("onXLE", function(){sjrLayout.cells("a").progressOff();});
	sjrSubjectGrid.enableDragAndDrop(true);
	sjrSubjectGrid.enableMultiselect(true);
	sjrSubjectGrid.init();

	sjrSubjectDp = new dataProcessor("${contextPath}/subject/deptSubjectCUD.do");
	sjrSubjectDp.init(sjrSubjectGrid);
	sjrSubjectDp.setTransactionMode("POST",false);
	sjrSubjectDp.setUpdateMode("off");
	sjrSubjectDp.enableDataNames(true);

}

function attachTrgetSjrGrid(){

	sjrTrgetToolbar = sjrLayout.cells("b").attachToolbar();
	sjrTrgetToolbar.setIconsPath("${dhtmlXImagePath}/icons_${sysConf['dhtmlx.skin']}/");
	sjrTrgetToolbar.setIconSize(18);
	sjrTrgetToolbar.setAlign("right");
	sjrTrgetToolbar.addButton("add", 1, "추가", "new.gif", "new_dis.gif");
	sjrTrgetToolbar.attachEvent("onClick",function(id){
		if(id == 'add')
		{
			if(sjrTrgetGrid.getSelectedRowId() == null)
			{
				dhtmlx.alert('추가할 연구분야를 선택하세요.');
				return false;
			}
			var sIds = new Array();
			var selectedIds = sjrTrgetGrid.getSelectedRowId();
			sIds = selectedIds.split(',');
			for(var i=0; i < sIds.length; i++)
			{
				var toRowId = sjrSubjectGrid.getRowId(sjrSubjectGrid.getRowsNum - 1);
				sjrTrgetGrid.moveRowTo(sIds[i],toRowId,"move","sibling",sjrTrgetGrid, sjrSubjectGrid);
			}
		}
	});

	sjrTrgetGrid = sjrLayout.cells("b").attachGrid();
	sjrTrgetGrid.setImagePath("${dhtmlXImagePath}");
	sjrTrgetGrid.setHeader("코드,대상주제명,분야구분,학과코드,학과명,id",null,grid_head_center_bold);
	sjrTrgetGrid.setColumnIds("catcode,description,prodcode,deptCode,deptKor,id");
	sjrTrgetGrid.setInitWidths("100,*,1,1,1,1");
	sjrTrgetGrid.setColAlign("center,left,left,center,center,center");
	sjrTrgetGrid.setColTypes("ro,ro,ro,ro,ro,ro");
	sjrTrgetGrid.setColSorting("str,str,str,str,str,str");
	sjrTrgetGrid.setColumnHidden(sjrTrgetGrid.getColIndexById("prodcode"),true);
	sjrTrgetGrid.setColumnHidden(sjrTrgetGrid.getColIndexById("deptCode"),true);
	sjrTrgetGrid.setColumnHidden(sjrTrgetGrid.getColIndexById("deptKor"),true);
	sjrTrgetGrid.setColumnHidden(sjrTrgetGrid.getColIndexById("id"),true);
	sjrTrgetGrid.attachEvent("onXLS", function(){sjrLayout.cells("b").progressOn();});
	sjrTrgetGrid.attachEvent("onXLE", function(){sjrLayout.cells("b").progressOff();});
	sjrTrgetGrid.enableDragAndDrop(true);
	sjrTrgetGrid.enableMultiselect(true);
	sjrTrgetGrid.init();
}

function attachDeptGrid(){
	deptGrid = dhxLayout.cells("a").attachGrid();
	deptGrid.setImagePath("${dhtmlXImagePath}");
	deptGrid.setHeader("No,학과명,학과코드,주제분야수",null,grid_head_center_bold);
	deptGrid.setColumnIds("no,deptKor,deptCode,catCo");
	deptGrid.setInitWidths("50,*,*,100");
	deptGrid.setColAlign("center,left,center,center");
	deptGrid.setColTypes("ro,ro,ro,ro");
	deptGrid.setColSorting("na,str,str,str");
	deptGrid.enableColSpan(true);
	deptGrid.attachEvent("onRowSelect",deptGrid_onRowSelect);
	deptGrid.setColumnHidden(deptGrid.getColIndexById("deptCode"),true);
	deptGrid.setColumnHidden(deptGrid.getColIndexById("catCo"),true);
	deptGrid.init();
	deptGrid_load();
}
function deptGrid_load(){
	doBeforeGridLoad();
	var url = getGridRequestURL();
	deptGrid.clearAndLoad(url, doOnGridLoaded);
}
function getGridRequestURL(){
	var url = "${contextPath}/subject/findDeptList.do";
	url += "?"+$('#formArea').serialize();
	return url;
}

function doBeforeGridLoad(){dhxLayout.cells("a").progressOn();}
function doOnGridLoaded(){ setTimeout(function() { dhxLayout.cells("a").progressOff(); deptGrid.selectRow(0, true); }, 100);}
function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){ setMainLayoutHeight($('#mainLayout'), -15); dhxLayout.setSizes(false); },200);}

function deptGrid_onRowSelect(rowId, ind){
	var cIndex_deptCode = deptGrid.getColIndexById("deptCode");
	var cIndex_deptKor = deptGrid.getColIndexById("deptKor");

	var jcrSubjectUrl = "${contextPath}/subject/findDeptSubjectList.do"
		jcrSubjectUrl += "?prodcode=JCR";
		jcrSubjectUrl += "&srchDeptCode=" + deptGrid.cells(rowId, cIndex_deptCode).getValue();
		jcrSubjectUrl += "&srchDeptKor=" + encodeURIComponent(deptGrid.cells(rowId, cIndex_deptKor).getValue());

	jcrSubjectGrid.clearAndLoad(jcrSubjectUrl, null);

	var sjrSubjectUrl = "${contextPath}/subject/findDeptSubjectList.do"
		sjrSubjectUrl += "?prodcode=SJR";
		sjrSubjectUrl += "&srchDeptCode=" + deptGrid.cells(rowId, cIndex_deptCode).getValue();
		sjrSubjectUrl += "&srchDeptKor=" + encodeURIComponent(deptGrid.cells(rowId, cIndex_deptKor).getValue());

	sjrSubjectGrid.clearAndLoad(sjrSubjectUrl, null);

	var jcrTrgetUrl = "${contextPath}/subject/findTrgetSubjectList.do"
		jcrTrgetUrl += "?prodcode=JCR";
		jcrTrgetUrl += "&srchDeptCode=" + deptGrid.cells(rowId, cIndex_deptCode).getValue();
		jcrTrgetUrl += "&srchDeptKor=" + encodeURIComponent(deptGrid.cells(rowId, cIndex_deptKor).getValue());

	jcrTrgetGrid.clearAndLoad(jcrTrgetUrl, null);

	var sjrTrgetUrl = "${contextPath}/subject/findTrgetSubjectList.do"
		sjrTrgetUrl += "?prodcode=SJR";
		sjrTrgetUrl += "&srchDeptCode=" + deptGrid.cells(rowId, cIndex_deptCode).getValue();
		sjrTrgetUrl += "&srchDeptKor=" + encodeURIComponent(deptGrid.cells(rowId, cIndex_deptKor).getValue());

	sjrTrgetGrid.clearAndLoad(sjrTrgetUrl, null);

}
function toExcel(){
	var cIndex_deptKor = deptGrid.getColIndexById("deptKor");
	var deptRowId	   = deptGrid.getSelectedRowId();
	var deptKor = encodeURIComponent(deptGrid.cells(deptRowId, cIndex_deptKor).getValue());
	var id = dhxTab.getActiveTab();
	if(id == 'a1')
	{
		jcrSubjectGrid.toExcel('${contextPath}/servlet/xlsGenerate.do?file_name='+deptKor+'_JCR_SUBJECT.xls');
	}
	else if(id == 'a2')
	{
		sjrSubjectGrid.toExcel('${contextPath}/servlet/xlsGenerate.do?file_name='+deptKor+'_SJR_SUBJECT.xls');
	}
}
</script>
</head>
<body>
	<!-- Page Title -->
	<div class="title_box">
		<h3>학과별 주제분야 관리</h3>
	</div>

	<!-- Main Content -->
	<div class="contents_box">
		<div class="list_bt_area">
			<div class="list_set">
				<ul>
					<li><a href="#" onclick="javascript:toExcel();" class="list_icon20">엑셀</a></li>
				</ul>
			</div>
		</div>
		<div id="mainLayout" style="position: relative; width: 100%;height: 100%;"></div>
</div>
	<form id="findItem" action="${contextPath}/main/main.do" method="post" target="item">
		<input type="hidden" id="userId" name="srchUserId" value=""/>
		<input type="hidden" id="item_id" name="item_id" value=""/>
	</form>
	<form id="addTrack" action="${contextPath}/auth/track/addTrack.do" method="post" target="item"></form>
</body>
</html>