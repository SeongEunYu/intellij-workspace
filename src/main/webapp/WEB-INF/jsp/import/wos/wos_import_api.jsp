<%@page import="kr.co.argonet.r2rims.constant.R2Constant"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../pageInit.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link type="text/css" href="${contextPath}/js/dhtmlx/skins/${sysConf['dhtmlx.skin']}/dhtmlxvault.css" rel="stylesheet" />
<style>div#importLayout {position: relative;margin-top: 10px;width: 101.5%;height: 300px;}</style>
<script src="${contextPath}/js/dhtmlx/vault/dhtmlxvault.js"></script>
<script src="${contextPath}/js/dhtmlx/vault/swfobject.js"></script>
<script type="text/javascript">

var myLayout, myVault, myForm, myGrid, impLayout, impGrid, t, createdRowNum, dhxCanlendar;

$(document).ready(function(){

	$('#dateFrom').val(getToday().substring(0,6));

	if('${running}' == "true"){
		//alert("반입이 이미 진행 중에 있습니다. 완료된 후 다시 시도해주세요.");
		dhtmlx.alert({type:"alert-warning",text:"반입 중인 작업이 있습니다<br/>(진행 중인 반입작업 완료 후 추가 반입 가능)",callback:function(){}})
	}

	if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
	else  window.addEventListener("resize",resizeLayout, false);

	impLayout = new dhtmlXLayoutObject("importLayout", "2E");
	impLayout.cells("a").setText("1. Input Query & Search");
	impLayout.cells("a").setHeight("143");
	impLayout.cells("b").setText("2. Search Result");
	impLayout.setAutoSize("a", "b");

	/*
	impLayout.cells("b").attachStatusBar({
		text: "<div id='importPagingArea'></div>",
		paging: true
	});
	*/

	impGrid = impLayout.cells("b").attachGrid();
	impGrid.setImagePath("${dhtmlXImagePath}");
	impGrid.setHeader("선택,중복,논문ID,논문정보,DocType,DOI,Link",null,grid_head_center_bold);
	impGrid.setColumnIds("chkbox,dpltYn,articleId,articleInfo,doctype,doi,chkLink");
	impGrid.setInitWidths("40,50,125,*,150,250,60");
	impGrid.setColAlign("center,center,center,left,center,left,center");
	impGrid.setColTypes("ch,ro,ro,ro,ro,link,link");
	impGrid.setColSorting("na,na,na,na,na,na,na");
	impGrid.enableColSpan(true);
	impGrid.enableMultiline(true);
	//impGrid.enableMultiselect(true);
	impGrid.attachEvent("onBeforeSorting",myGrid_onBeforeSorting);
	//impGrid.attachEvent("onPageChanged",doBeforeImpGridLoad);
	//impGrid.attachEvent("onPaging",doOnImpGridLoaded);
	impGrid.attachEvent("onDistributedEnd", function(){
	   //console.log(createdRowNum + " : " + impGrid.getRowsNum());
	   if(createdRowNum == impGrid.getRowsNum()) doOnImpGridLoaded();
	});
	impGrid.attachEvent("onRowCreated", function(rId,rObj,rXml){
		var cIndex_dpltYn = impGrid.getColIndexById("dpltYn");
		var cIndex_chkbox = impGrid.getColIndexById("chkbox");
		var dpltYn = impGrid.cells(rId, cIndex_dpltYn).getValue().trim();
		if(dpltYn == 'Y'){
			impGrid.cellById(rId,cIndex_chkbox).setValue('0');
			impGrid.cellById(rId,cIndex_chkbox).setDisabled(true);
		}
		createdRowNum++;
	});
    impGrid.enableDistributedParsing(true,100,250);
    impGrid.enableTooltips("false,false,false,false,false,true,true");
    impGrid.setXMLAutoLoading("${contextPath}/import/findWosArticleListByAPI.do?"+$('#formArea').serialize(), 100);
	impGrid.init();
	if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
	else  window.addEventListener("resize",resizeLayout, false);
	doInitGrid();
	myGrid_load();
	$('#importLayout').css('width','100%');
	impLayout.cells("a").attachObject("my_search");
	impLayout.attachFooter("my_copy");
	//impGrid_load();

	var running = '${param.running}';
	if(running == 'false'){
		$('#chkAutoRefresh').prop('checked','checked');
		toggleAutoRefresh();
	}

    dhxCanlendar = new dhtmlXCalendarObject(["sttDate","endDate"]);
    dhxCanlendar.hideTime();
    dhxCanlendar.loadUserLanguage("ko");
    dhxCanlendar.setPosition("bottom");

});

function impGrid_load(){

    // validate
    var query = $('#userQuery').val();
    if(query == '')
	{
        dhtmlx.alert('Query는 필수 입니다.');
        $('#userQuery').focus();
        return;
	}

    doBeforeImpGridLoad();
	impLayout.cells("b").setText("2. Search Result");
	createdRowNum = 0;
	//alert($('#formArea').serialize());
	var url = "${contextPath}/import/findWosArticleListByApi.do?"+$('#formArea').serialize();
	impGrid.xmlFileUrl = url;
	impGrid.clearAndLoad(url);
}

function doOnImpGridLoaded(){
	impLayout.cells("b").setText("2. Search Result ("+impGrid.getRowsNum()+"건)");
	setTimeout(function() {impLayout.cells("b").progressOff();}, 100);
}
function doBeforeImpGridLoad(){impLayout.cells("b").progressOn();}

function submitForm(form) {

	if(checkSelectedRow())
	{
		dhtmlx.confirm({
			title:"WOS 데이터 반입",
			ok:"Yes", cancel:"No",
			text:"선택하신 논문을 반입하시겠습니까?",
			callback:function(result){
				if(result == true){
					var cIndex_chkbox = impGrid.getColIndexById("chkbox");
					for (var i=0; i<impGrid.getRowsNum(); i++){
						var rId = impGrid.getRowId(i);
						if(typeof rId != 'undefined' && impGrid.cells(rId, cIndex_chkbox).getValue()  == '1')
						{
							$('#sForm').append($('<input type="hidden" name="articleId" value="'+rId+'"/>'));
						}
					}
					$('#sForm').append($('<input type="hidden" name="historyTitle" value="'+$('#historyTitle').val()+'"/>'));
					$('#sForm').append($('<input type="hidden" name="userQuery" value="'+$('#userQuery').val()+'"/>'));
					$('#sForm').append($('<input type="hidden" name="sttDate" value="'+$('#sttDate').val()+'"/>'));
					$('#sForm').append($('<input type="hidden" name="endDate" value="'+$('#endDate').val()+'"/>'));
					$('#sForm').append($('<input type="hidden" name="symbolicTimeSpan" value="'+$('#symbolicTimeSpan').val()+'"/>'));
					if($('#edition_sci').is('checked') )
						$('#sForm').append($('<input type="hidden" name="edition" value="'+$('#edition_sci').val()+'"/>'));
					if($('#edition_ssci').is('checked') )
						$('#sForm').append($('<input type="hidden" name="edition" value="'+$('#edition_ssci').val()+'"/>'));
					if($('#edition_ahci').is('checked') )
						$('#sForm').append($('<input type="hidden" name="edition" value="'+$('#edition_ahci').val()+'"/>'));
					$('#sForm').append($('<input type="hidden" name="edition" value="'+$('#edition').val()+'"/>'));
					$('#sForm').append($('<input type="hidden" name="sortField" value="'+$('#sortField').val()+'"/>'));
					$('#sForm').append($('<input type="hidden" name="sortDirect" value="'+$('#sortDirect').val()+'"/>'));
					$('#sForm').append($('<input type="hidden" name="sid" value="'+$('#sid').val()+'"/>'));
					$('#sForm').append($('<input type="hidden" name="databaseId" value="'+$('#databaseId').val()+'"/>'));
					$('#sForm').append($('<input type="hidden" name="collection" value="'+$('#collection').val()+'"/>'));
					$('#sForm').append($('<input type="hidden" name="queryLanguage" value="'+$('#queryLanguage').val()+'"/>'));
					$("#sForm").submit();
				}
			}
		});
	}
	else
	{
        dhtmlx.alert({type:"alert-warning",text:"반입할 논문이 없습니다.",callback:function(){}})
	}
}

function checkSelectedRow(){
    var cIndex_chkbox = impGrid.getColIndexById("chkbox");
    for (var i=0; i<impGrid.getRowsNum(); i++){
        var rId = impGrid.getRowId(i);
        if(typeof rId != 'undefined' && impGrid.cells(rId, cIndex_chkbox).getValue()  == '1')
        {
            return true;
        }
    }
    return false;
}

function doInitGrid(){
	dhxLayout = new dhtmlXLayoutObject("mainLayout","1C");
	dhxLayout.cells("a").hideHeader();
	dhxLayout.setSizes(false);
	myGrid = dhxLayout.cells("a").attachGrid();
	myGrid.setImagePath("${dhtmlXImagePath}");
	myGrid.setHeader("작업ID,파일포맷,작업명,검색어,전체,중복,에러,입력,반입일자,상태,에러 레코드", null, grid_head_center_bold);
	myGrid.setColumnIds("id,format,title,query,totCount,dupCount,errCount,insCount,regdate,status,errorLog");
	myGrid.setInitWidths("50,90,200,200,50,50,50,50,80,50,*");
	myGrid.setColAlign("center,center,left,left,center,center,center,center,center,center,left");
	myGrid.setColSorting("int,str,str,str,na,na,na,na,str,str,na");
	myGrid.setColTypes("ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro");
	myGrid.setEditable(false);
	myGrid.enableColSpan(true);
	myGrid.attachEvent("onBeforeSorting",myGrid_onBeforeSorting);
	myGrid.attachEvent("onXLS", doBeforeGridLoad);
	myGrid.attachEvent("onXLE", doOnGridLoaded);
    myGrid.attachEvent("onRowSelect", function(id,ind) {
        var columnId = myGrid.getColumnId(ind);
        if (columnId == "id" ||columnId == "historyId" || columnId == "format" || columnId == "title" || columnId == "query" || columnId == "regdate" || columnId == "status" ||
            columnId == "errorLog" || columnId == "0" || myGrid.cellById(id,ind).getValue() == "0") return;

        var status = "";
        if (columnId == "totCount") status="";
        else if (columnId == "dupCount") status="D";
        else if (columnId == "errCount") status="E";
        else if (columnId == "insCount") status="I";

        fn_impHistoryListPopup(myGrid.cellById(id,0).getValue(), status);
    });
    myGrid.enablePaging(true,100,30,"pagingArea",true);
    myGrid.setPagingSkin("${dhtmlXPagingSkin}");
	myGrid.init();
}

function myGrid_onBeforeSorting(ind,type,direct){
	var url = getGridRequestURL();
	myGrid.clearAndLoad(url+"&orderby="+(myGrid.getColumnId(ind))+"&direct="+direct);
	myGrid.setSortImgState(true,ind,direct);
	return false;
}

function myGrid_load(){
	doBeforeGridLoad();
	var url = getGridRequestURL();
	myGrid.clearAndLoad(url,doOnGridLoaded);
}

function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){ dhxLayout.setSizes(false); impLayout.setSizes(false); },200);}
function doOnGridLoaded(){setTimeout(function() {dhxLayout.cells("a").progressOff();}, 100);}
function doBeforeGridLoad(){dhxLayout.cells("a").progressOn();}
function getGridRequestURL(){return "${contextPath}/import/findRdHisotryList.do?gubun=WOS";}
function toggleAutoRefresh(){
	if($('#chkAutoRefresh').prop("checked") == true)
	{
		autoRefreshHistory = setInterval(function(){myGrid_load();}, 5000);
	}
	else
	{
		clearTimeout(autoRefreshHistory);
	}
}
function toggleTimeSpan(value){
    if("T" == value)
	{
        $('#sttDate').val('').prop('disabled', false);
        $('#endDate').val('').prop('disabled', false);
        $('#symbolicTimeSpan').val('').prop('disabled', true);
	}
	else if("S" == value)
	{
        $('#sttDate').val('').prop('disabled', true);
        $('#endDate').val('').prop('disabled', true);
        $('#symbolicTimeSpan').val('1week').prop('disabled', false);
	}
}
</script>
</head>
<body>
<form id="sForm" name="sForm" method="post" action="${contextPath}/import/parseWosByApi.do?utilType=exr">
	<input type="hidden" name="pMenuId" value="${param.pMenuId}"/>
</form>
	<!-- Page Title -->
	<div class="title_box">
		<h3>WOS 데이터 반입(웹서비스)</h3>
	</div>
	<!-- Main Content -->
	<div class="contents_box">
		<div id="importLayout" style="position: relative; width: 100%;height: 100%;"></div>
		<script type="text/javascript">$('#importLayout').css('height',($(document).height()-320)+"px");</script>
		<!-- end 반입관리 테이블 -->
		<div class="txt_basic_12bold" style="height:20px; padding-top: 15px;"></div>
		<div id="mainLayout" style="position: relative; width: 100%;height: 140px;"></div>
		<div id="pagingObj" style="z-index: 1; height: 60px; margin-top: 5px;" >
			<div id="pagingArea" style="z-index: 1;"></div>
		</div>
		<div id="my_search" class="my_ftr" style="visibility: visible;">
			<form id="formArea">
			<input type="hidden" name="sid" id="sid" value="<c:out value="${sid}"/>"/>
			<input type="hidden" name="databaseId" id="databaseId" value="WOS"/>
			<input type="hidden" name="collection" id="collection" value="WOS"/>
			<input type="hidden" name="queryLanguage" id="queryLanguage" value="en"/>
			<table class="view_tbl" >
				<colgroup>
					<col style="width: 11%;"/>
					<col style="width: 39%;"/>
					<col style="width: 11%;"/>
					<col />
					<col style="width: 50px;"/>
				</colgroup>
				<tbody>
				<tr>
					<th>Query</th>
					<td colspan="3">
						<textarea rows="3"  style="width: 100%" name="userQuery" id="userQuery">AD=CAU</textarea>
					</td>
					<td rowspan="4" class="option_search_td" onclick="javascript:impGrid_load();"><em>search</em></td>
				</tr>
				<tr>
					<th>
						TimeSpan <input type="radio" name="timeSpanRdo" id="timeSpanRdo_T" value="T" style="vertical-align: middle;" onclick="javascript:toggleTimeSpan($(this).val());"/>
					</th>
					<td>
						<input type="text" title="발행년월 시작" value="" name="sttDate" id="sttDate" maxlength="10" onkeypress="javascript:if(event.keyCode < 48 || event.keyCode > 57) event.returnValue = false;" style="ime-mode:disabled;width: 80px;" disabled="disabled">
						(YYYY-MM-DD)
						~
						<input type="text" title="발행년월 끝" name="endDate" id="endDate" maxlength="10" onkeypress="javascript:if(event.keyCode < 48 || event.keyCode > 57) event.returnValue = false;" style="ime-mode:disabled;width: 80px;"  disabled="disabled">
						(YYYY-MM-DD)
					</td>
					<th>
						Symbolic <input type="radio" name="timeSpanRdo" id="timeSpanRdo_S" checked="checked" value="S" style="vertical-align: middle;" onclick="javascript:toggleTimeSpan($(this).val());"/>
					</th>
					<td>
						<select name="symbolicTimeSpan" id="symbolicTimeSpan" >
							<option value="" ></option>
							<option value="1week" selected="selected">1week</option>
							<option value="2week">2week</option>
							<option value="4week">4week</option>
						</select>
					</td>
				</tr>
				<tr>
					<th>Edition</th>
					<td>
						<input type="checkbox" name="edition" id="edition_sci" value="SCI" checked="checked"/>
						<label for="edition_sci">SCI(E)</label>
						<input type="checkbox" name="edition" id="edition_ssci" value="SSCI"/>
						<label for="edition_ssci">SSCI</label>
						<input type="checkbox" name="edition" id="edition_ahci" value="AHCI"/>
						<label for="edition_ahci">AHCI</label>
					</td>
					<th>Sort</th>
					<td>
						<select name="sortField" id="sortField">
							<option value="LD" selected="selected">Load Date</option>
							<option value="PY">Publication Year</option>
							<option value="VL">Volume</option>
							<option value="SO">Source</option>
							<option value="TC">Times Cited</option>
						</select>
						<select name="sortDirect" id="sortDirect" >
							<option value="A" selected="selected">Ascending</option>
							<option value="D">Descending</option>
						</select>
					</td>
				</tr>
				</tbody>
			</table>
			</form>
		</div>
		<div id="my_copy" class="my_ftr" style="visibility: visible;">
			<div style="float: left;vertical-align: bottom;" >
				<div class="list_bt_area" style="padding-top: 18px;">
					<input type="checkbox" id="chkAutoRefresh" value="R" class="radio" onclick="javascript:toggleAutoRefresh();"/>
					<label for="" class="radio_label" style="margin: 0 7px 0 2px;">Auto Refresh(5초간격)</label>
				</div>
			</div>
			<div style="float: right; vertical-align: bottom">
				<div class="list_bt_area" style="padding-top: 4px;">
					<div class="list_set">
						<ul>
							<li>작업명 : <input type="text" name="historyTitle" id="historyTitle" value="" style="height: 23px;width: 450px;"/></li>
							<li><a href="#" onclick="javascript:submitForm(document.sForm);" class="list_icon14">데이터반입</a></li>
						</ul>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
</body>