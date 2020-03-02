<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/pageInit.jsp" %>
<html>
<head>
<style type="text/css">
.dhxlayout_base_dhx_terrace div.dhx_cell_layout div.dhx_cell_cont_layout {border: 0 solid #fff;}
.dhxlayout_base_dhx_terrace div.dhx_cell_layout div.dhx_cell_hdr{border: 0 solid #fff;}
</style>
<script type="text/javascript" src="${contextPath}/js/mainLayout.js"></script>
<script type="text/javascript">
var dhxLayout, i18nGrid, i18nForm, msgGrid, msgDp, t, selectedRowId;

$(function() {

	setMainLayoutHeight($('#mainLayout'), -30);

	if(window.attachEvent) window.attachEvent("onresize",resizeLayout);
	else window.addEventListener("resize",resizeLayout, false);

	dhxLayout = new dhtmlXLayoutObject("mainLayout","2U");
	dhxLayout.cells("a").hideHeader();
	dhxLayout.cells("b").hideHeader();
	dhxLayout.cells("a").setWidth(650);
	dhxLayout.setSizes(false);
	dhxLayout.setAutoSize("a","a;b");
	dhxLayout.cells("a").attachObject('listbox');
	dhxLayout.cells("b").attachHTMLString('<div id="i18nInfo" style="width:100%;height:100%;overflow:auto;"></div>');
	setGridHeight();
	i18nGrid = new dhtmlXGridObject('gridbox');
	i18nGrid.setImagePath("${dhtmlXImagePath}");
	i18nGrid.setHeader("language,languageName,Code,Description", null, grid_head_center_bold);
	i18nGrid.setColumnIds("language,languageName,code,description");
	i18nGrid.setInitWidths("10,10,200,*");
	i18nGrid.setColAlign("center,center,left,left");
	i18nGrid.setColTypes("ro,ro,ro,ro");
	i18nGrid.setColSorting("str,str,str,str");
	i18nGrid.setEditable(false);
	i18nGrid.enableColSpan(true);
	i18nGrid.attachEvent("onRowSelect", doOnRowSelected);
	i18nGrid.attachEvent("onBeforeSorting", i18nGrid_onBeforeSorting);
	i18nGrid.attachEvent("onXLS", doBeforeGridLoad);
	i18nGrid.attachEvent("onXLE", i18nGrid_onSelectPageFirstRow);
	i18nGrid.enablePaging(true,100,10,"pagingArea",true);
	i18nGrid.setPagingSkin("${dhtmlXPagingSkin}");
	i18nGrid.setColumnHidden(i18nGrid.getColIndexById("language"),true);
	i18nGrid.setColumnHidden(i18nGrid.getColIndexById("languageName"),true);
	i18nGrid.init();
	i18nGrid_load();
});

function setGridHeight(){
	var gridHeight = $('#mainLayout').height();
	if($('.view_tbl') != undefined )
		gridHeight -= $('.nav_wrap').height();
	$('#gridbox').css('height',gridHeight+"px");
}

function i18nGrid_onBeforeSorting(ind,type,direct){
	var url = '${contextPath}/i18n/i18nDetailList.do?language=ko&'+ $('#formArea').serialize();
	i18nGrid.clearAndLoad(url+"&orderby="+(i18nGrid.getColumnId(ind))+"&direct="+direct);
	i18nGrid.setSortImgState(true,ind,direct);
	return false;
}

function i18nGrid_load() {
	doBeforeGridLoad();
	var url = '${contextPath}/i18n/i18nDetailList.do?language=ko&'+ $('#formArea').serialize();
	i18nGrid.clearAndLoad(url, doOnGridLoaded);
}

function doOnRowSelected(rowID,celInd) {
	var str = rowID.split('|');
	$.post('${contextPath}/i18n/modifyForm.do',{'code' : str[0]},null,'text').done(function(data){
		$('#i18nInfo').html(data);
		var cnTrHeight = $('#mainLayout').height();
		cnTrHeight = cnTrHeight - (30*2);
		cnTrHeight = cnTrHeight - (99);
		cnTrHeight = cnTrHeight/2;
		$('textarea[name="message"]').css('height',(cnTrHeight - 24));

	});
}

function i18nGrid_onSelectPageFirstRow(){
	var rowCount = i18nGrid.getRowsNum();
	if(rowCount > 0)
	{
		if(selectedRowId == undefined || selectedRowId == '' )
		{
			var strIndex = (i18nGrid.currentPage-1) * i18nGrid.rowsBufferOutSize;
			i18nGrid.selectRow(strIndex,true,true,true);
			i18nGrid.showRow(i18nGrid.getRowId(strIndex))
		}
		else
		{

		}
	}
	else
	{
		$('#i18nInfo').empty();
	}
	doOnGridLoaded();
}

function saveMessage(){
	dhxLayout.cells("b").progressOn();
	msgDp.sendData();
	i18nForm.send('${contextPath}/i18n/i18nUpdate.do',function(loader,response){
		var code = i18nForm.getItemValue("code");
		$.ajax({
			url: "${contextPath}/i18n/findI18nDetail.do",
			async : false,
			dataType:"json",
			data:{"code":code, "language":$('#selectLanguage').val()},
			method:"POST",
			success:function(data){
				var selectdId = i18nGrid.getSelectedRowId();
				var rowInd = i18nGrid.getRowIndex(selectdId);
				var cIndex_description = i18nGrid.getColIndexById("");
				//var cIndex_message = i18nGrid.getColIndexById("");
				i18nGrid.cellByIndex(rowInd,3).setValue(data.description);
				i18nGrid.cellByIndex(rowInd,4).setValue(data.message);
			}
		}).done(function(data){});
		setTimeout(function() { dhxLayout.cells("b").progressOff(); }, 100);
		dhtmlx.alert({type:"alert",text:"저장하였습니다.",callback:function(){}})
	});
}

function fn_save(){
	$.post('${contextPath}/i18n/modifyI18n.do', $('#i18nForm').serializeArray(),null,'text').done(function(data){
		if(data == '1')
		{
			dhtmlx.alert({type:"alert",text:"저장하였습니다.",callback:function(){

				var selectedRowId = i18nGrid.getSelectedRowId();



			}})
		}
	});
}

function myGRID_not_empty(value, id, ind) {
    if (value == "") {
		return "Value at (" + id + ", " + ind + ") can't be empty";
	}
    return true;
}

function reLoding() {
	doBeforeGridLoad()
	$.ajax({
		url: '${contextPath}/i18n/reoladMessage.do',
		dataType: 'json'
	}).done(function(data) {
		if(data.code == "001"){
			dhtmlx.alert({type:"alert",text:data.msg,callback:function(){}})
		}
		doOnGridLoaded();
	});
}

function resizeLayout() { window.clearTimeout(t); t = window.setTimeout(function(){ setMainLayoutHeight($('#mainLayout'), -30); dhxLayout.setSizes(false); }, 200); }
function doBeforeGridLoad() { dhxLayout.cells("a").progressOn(); }
function doOnGridLoaded() { setTimeout(function() { dhxLayout.cells("a").progressOff(); }, 100); }

</script>
</head>
<body>
	<!-- Page Title -->
	<div class="title_box">
		<h3><spring:message code='menu.language'/></h3>
	</div>
	<!-- Main Content -->
	<div class="contents_box">
		<!-- START 테이블 1 -->
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
					<th>업무구분</th>
					<td>
						<select name="gubun" id="gubun" onchange="i18nGrid_load();">
							<option value="">전체</option>
							<c:forEach items="${infoList}" var="il" varStatus="idx">
								<option value="${il.gubun }">${il.gubunDesc}</option>
							</c:forEach>
						</select>
					</td>
					<th>Message/Code</th>
					<td>
						<input type="text" id="message" name="message" class="input_type" onKeyup="javascript:if(event.keyCode=='13')i18nGrid_load();"/>
					</td>
					<td class="option_search_td" onclick="javascript:i18nGrid_load();"><em>search</em></td>
				</tr>
				</tbody>
			</table>
		</form>
		<div class="list_bt_area">
			<div class="list_set">
				<ul>
					<li><a href="#" onclick="javascript:reLoding();" class="list_icon21">언어갱신</a></li>
					<li><a href="javascript:fn_save();" class="list_icon02">저장</a></li>
				</ul>
			</div>
		</div>
		<div id="listbox">
			<div id="gridbox" style="position: relative; width: 100%;height: 100%;"></div>
			<div id="pagingObj" style="z-index: 1; height: 40px; margin-top: 5px;" >
				<div id="pagingArea" style="z-index: 1;"></div>
			</div>
		</div>
		<div id="mainLayout" style="width: 100%;height: 100%;"></div>
	</div>
</body>
</html>