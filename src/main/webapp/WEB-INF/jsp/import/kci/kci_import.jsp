<%@page import="kr.co.argonet.r2rims.constant.R2Constant"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../pageInit.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<style>div#importLayout {position: relative;margin-top: 10px;width: 101.5%;height: 300px;}</style>
<script type="text/javascript">
var myLayout, myVault, myForm, myGrid, impLayout, impGrid, t, createdRowNum;
$(document).ready(function(){

	$('#dateFrom').val(getToday().substring(0,6));

	if('${running}' == "true"){
		alert("반입이 이미 진행 중에 있습니다. 완료된 후 다시 시도해주세요.");
	}

	if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
	else  window.addEventListener("resize",resizeLayout, false);

	impLayout = new dhtmlXLayoutObject("importLayout", "2E");
	impLayout.cells("a").setText("1. Input Keyword & Search");
	impLayout.cells("a").setHeight("123");
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
	impGrid.setHeader("선택,중복,논문ID,구분,논문정보,저자수,DOI,KCI",null,grid_head_center_bold);
	impGrid.setColumnIds("chkbox,dpltYn,articleId,foreignRegistration,articleInfo,authorCount,doi,chkLink");
	impGrid.setInitWidths("40,50,100,80,*,50,100,60");
	impGrid.setColAlign("center,center,center,center,left,center,center,center");
	impGrid.setColTypes("ch,ro,ro,ro,ro,ro,link,link");
	impGrid.setColSorting("na,na,na,na,na,na,na,na");
	impGrid.enableColSpan(true);
	impGrid.enableMultiline(true);
	impGrid.enableMultiselect(true);
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
		var cIndex_foreignReg = impGrid.getColIndexById("foreignRegistration");
		var dpltYn = impGrid.cells(rId, cIndex_dpltYn).getValue().trim();
		var foreignReg = impGrid.cells(rId, cIndex_foreignReg).getValue().trim();
		if(dpltYn == 'Y' || foreignReg != ''){
			impGrid.cellById(rId,cIndex_chkbox).setValue('0');
			impGrid.cellById(rId,cIndex_chkbox).setDisabled(true);
		}
		createdRowNum++;
	});
    //impGrid.enableDistributedParsing(true,10,300);
    impGrid.enableTooltips("false,false,false,false,false,true,true");
	impGrid.init();
    impGrid.enableDistributedParsing(true,50,250);

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

});

function impGrid_load(){
	doBeforeImpGridLoad();
	impLayout.cells("b").setText("2. Search Result");
	createdRowNum = 0;
	var url = "${contextPath}/import/findKciArticleListByOpenAPI.do?"+$('#formArea').serialize();
	impGrid.xmlFileUrl = url;
	impGrid.clearAndLoad(url);
}

function doOnImpGridLoaded(){
	impLayout.cells("b").setText("2. Search Result ("+impGrid.getRowsNum()+"건)");
	setTimeout(function() {impLayout.cells("b").progressOff();}, 100);
}
function doBeforeImpGridLoad(){impLayout.cells("b").progressOn();}

function submitForm(form) {
	dhtmlx.confirm({
		title:"KCI 데이터 반입",
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
				$('#sForm').append($('<input type="hidden" name="title" value="'+$('#title').val()+'"/>'));
				$('#sForm').append($('<input type="hidden" name="affiliation" value="'+$('#affiliation').val()+'"/>'));
				$('#sForm').append($('<input type="hidden" name="author" value="'+$('#author').val()+'"/>'));
				$('#sForm').append($('<input type="hidden" name="journal" value="'+$('#journal').val()+'"/>'));
				$('#sForm').append($('<input type="hidden" name="dateFrom" value="'+$('#dateFrom').val()+'"/>'));
				$('#sForm').append($('<input type="hidden" name="dateTo" value="'+$('#dateTo').val()+'"/>'));
				$('#sForm').append($('<input type="hidden" name="historyTitle" value="'+$('#historyTitle').val()+'"/>'));
				$("#sForm").submit();
			}
		}
	});
}

function maintenance() {
	doBeforeGridLoad()
	$.ajax({
		url: "${contextPath}/import/maintenance.do",
		dataType: "json",
		data: {"sourcDvsnCd":"<%=R2Constant.ARTICLE_GUBUN_KCI%>"},
		method: "POST",
		success: function(data){

		}
	}).done(function(data){
		//setTimeout(function() { dhxLayout.cells("b").progressOff(); }, 100);
		doOnGridLoaded();
		dhtmlx.alert({type:"alert",text:data.message,callback:function(){}})
	});
}

function doInitGrid(){
	dhxLayout = new dhtmlXLayoutObject("mainLayout","1C");
	dhxLayout.cells("a").hideHeader();
	dhxLayout.setSizes(false);
	myGrid = dhxLayout.cells("a").attachGrid();
	myGrid.setImagePath("${dhtmlXImagePath}");
	myGrid.setHeader("작업ID,파일포맷,작업명,검색어,전체,중복,에러,입력,반입일자,상태,에러 레코드", null, grid_head_center_bold);
	myGrid.setColumnIds("id,format,title,query,totCount,dupCount,errCount,insCount,regdate,status,errorLog");
	myGrid.setInitWidths("70,100,*,170,60,60,60,60,130,80,130");
	myGrid.setColAlign("center,center,left,left,center,center,center,center,center,center,left");
	myGrid.setColSorting("na,na,na,na,na,na,na,na,na,na,na");
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
function getGridRequestURL(){return "${contextPath}/import/findRdHisotryList.do?gubun=<%=R2Constant.ARTICLE_GUBUN_KCI%>";}
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
</script>
</head>
<body>
<form id="sForm" name="sForm" method="post" action="${contextPath}/import/parseKci.do?utilType=exr">
	<input type="hidden" name="pMenuId" value="${param.pMenuId}"/>
</form>
	<!-- Page Title -->
	<div class="title_box">
		<h3><spring:message code="menu.kci.import"/></h3>
	</div>
	<!-- Main Content -->
	<div class="contents_box">
		<div id="importLayout" style="position: relative; width: 100%;height: 100%;"></div>
		<script type="text/javascript">$('#importLayout').css('height',($(document).height()-(360+$('.header_wrap').height() + $('.nav_wrap').height()))+"px");</script>
		<!-- end 반입관리 테이블 -->
		<div class="txt_basic_12bold" style="height:20px; padding-top: 15px;"></div>
		<div id="mainLayout" style="position: relative; width: 100%;height: 140px;"></div>
		<div id="pagingObj" style="z-index: 1; height: 60px; margin-top: 5px;" >
			<div id="pagingArea" style="z-index: 1;"></div>
		</div>
		<div id="my_search" class="my_ftr" style="visibility: visible;">
			<form id="formArea">
			<table class="view_tbl" >
				<colgroup>
					<col style="width: 10%;"/>
					<col style="width: 40%;"/>
					<col style="width: 10%;"/>
					<col />
					<col style="width: 50px;"/>
				</colgroup>
				<tbody>
				<tr>
					<th>저자소속기관</th>
					<td>
						<input type="text" style="width: 99%" title="저자소속기관" name="affiliation" id="affiliation" value="${sysConf['inst.name']}">
					</td>
					<th>논문명</th>
					<td>
						<input type="text" style="width: 99%" title="제목" name="title" id="title" value="">
					</td>
					<td rowspan="3" class="option_search_td" onclick="javascript:impGrid_load();"><em>search</em></td>
				</tr>
				<tr>
					<th>저자명</th>
					<td>
						<input type="text" style="width: 99%" title="저자명" name="author" id="author">
					</td>
					<th>저널명</th>
					<td>
						<input type="text" style="width: 99%" title="저널" name="journal" id="journal">
					</td>
				</tr>
				<tr>
					<th>발행년월</th>
					<td>
						<input type="text" title="발행년월 시작" value="" name="dateFrom" id="dateFrom" maxlength="6" onkeypress="javascript:if(event.keyCode < 48 || event.keyCode > 57) event.returnValue = false;" style="ime-mode:disabled;width: 50px;">
						(YYYYMM)
						~
						<input type="text" title="발행년월 끝" name="dateTo" id="dateTo" maxlength="6" onkeypress="javascript:if(event.keyCode < 48 || event.keyCode > 57) event.returnValue = false;" style="ime-mode:disabled;width: 50px;">
						(YYYYMM)
					</td>
					<th>출력건수</th>
					<td>
 						 전체
                         <input type="hidden" name="displayCount" id="displayCount" value="50">
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
							<li>작업명 : <input type="text" name="historyTitle" id="historyTitle" value="" style="height: 23px;width: 350px;"/></li>
							<li><a href="#" onclick="javascript:submitForm(document.sForm);" class="list_icon14">데이터반입</a></li>
							<li><a href="#" onclick="javascript:maintenance();" class="list_icon15">데이터정비</a></li>
						</ul>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
</body>