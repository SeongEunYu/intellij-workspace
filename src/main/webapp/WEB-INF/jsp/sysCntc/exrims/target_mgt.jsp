<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@include file="../../pageInit.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<style type="text/css">
div.gridbox_dhx_terrace.gridbox table.hdr td { vertical-align: middle;}
</style>
<script type="text/javascript" src="<c:url value="/js/mainLayout.js"/>"></script>
<script type="text/javascript">
var dhxLayout, myGrid, myDp, t;

$(document).ready(function(){
    setMainLayoutHeight($('#mainLayout'));
	if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
	else  window.addEventListener("resize",resizeLayout, false);
	//set layout
	dhxLayout = new dhtmlXLayoutObject("mainLayout","1C");
	dhxLayout.cells("a").hideHeader();
	dhxLayout.setSizes(false);
	//attach myGrid
    myGrid = dhxLayout.cells("a").attachGrid();
    myGrid.setImagePath("${dhtmlXImagePath}");
	myGrid.setHeader("<img src='${dhtmlXImagePath}dhxgrid_${sysConf['dhtmlx.skin']}/item_chk0.gif' onClick='javascript:onToggleCheckbox($(this));' status='uncheck' style='vertical-align: middle;'>,반입대상정보,Doc Type,유사데이터(논문),유사데이터(학술활동)",null,grid_head_center_bold);
	myGrid.setColumnIds("chkbox,infomation,docType,dupArticle,dupConference");
	myGrid.setInitWidths("80,*,170,100,100");
	myGrid.setColAlign("center,left,center,center,center");
	myGrid.setColTypes("ch,ro,ro,link,link");
	myGrid.setColSorting("na,na,na,na,na");
	myGrid.attachEvent("onBeforeSorting",myGrid_onBeforeSorting);
	myGrid.attachEvent("onXLS", doBeforeGridLoad);
	myGrid.attachEvent("onXLE",doOnGridLoaded);
	myGrid.attachEvent("onPaging",onChangeCheckBox);
	myGrid.enableMultiselect(true);
	myGrid.enableMultiline(true);
    myGrid.enablePaging(true,25,10,"pagingArea",true);
    myGrid.setPagingSkin("${dhtmlXPagingSkin}");
    myGrid.enableColSpan(true);
	myGrid.init();
	myGrid_load();
});

function myGrid_onBeforeSorting(ind,type,direct){
	var url = getGridRequestURL();
	myGrid.clearAndLoad(url+"&orderby="+(myGrid.getColumnId(ind))+"&direct="+direct);
	myGrid.setSortImgState(true,ind,direct);
	return false;
}

function myGrid_load(){
	doBeforeGridLoad();
	var url = getGridRequestURL();
	myGrid.clearAndLoad(url, doOnGridLoaded);
}

function getGridRequestURL(){
	var maskRevise = $(':radio[name="maskRevise"]:checked').val();
	var url = "<c:url value="/erCntc/findExrimsTargetList.do?"/>"+$('#formArea').serialize();
	return url;
}


function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){ setMainLayoutHeight($('#mainLayout')); dhxLayout.setSizes(false); },200);}
function doOnGridLoaded(){ setTimeout(function() {dhxLayout.cells("a").progressOff();}, 100);}
function doBeforeGridLoad(){dhxLayout.cells("a").progressOn();}

function onChangeCheckBox(){
	var strIndex = (myGrid.currentPage-1) * myGrid.rowsBufferOutSize;
	var endIndex = ((myGrid.currentPage) * myGrid.rowsBufferOutSize)-1;
	endIndex = endIndex<myGrid.getRowsNum() ? endIndex: myGrid.getRowsNum()-1;
	for (var i=strIndex; i<=endIndex; i++)
	{
		var rId = myGrid.getRowId(i);
		var cIndex_dupArticle = myGrid.getColIndexById("dupArticle");
		var cIndex_dupConference = myGrid.getColIndexById("dupConference");
		var cIndex_chkbox = myGrid.getColIndexById("chkbox");
		if(typeof rId != 'undefined')
		{
			var dupArticleValue = myGrid.cells(rId, cIndex_dupArticle).getValue();
			var dupConferenceValue = myGrid.cells(rId, cIndex_dupConference).getValue();
			if((dupArticleValue != null && dupArticleValue != '') || (dupConferenceValue != null && dupConferenceValue != ''))
			{
				myGrid.cellById(rId,cIndex_chkbox).setDisabled(true);
			}
		}
	}
}

function onToggleCheckbox(checkbox){
	var status = checkbox.attr('status');
	if(status == 'uncheck')
	{
		checkbox.attr('status', 'check');
		checkbox.attr('src', "${dhtmlXImagePath}dhxgrid_${sysConf['dhtmlx.skin']}/item_chk1.gif");
	}
	else
	{
		checkbox.attr('status', 'uncheck');
		checkbox.attr('src', "${dhtmlXImagePath}dhxgrid_${sysConf['dhtmlx.skin']}/item_chk0.gif");
	}
	var strIndex = (myGrid.currentPage-1) * myGrid.rowsBufferOutSize;
	var endIndex = ((myGrid.currentPage) * myGrid.rowsBufferOutSize)-1;
	endIndex = endIndex<myGrid.getRowsNum() ? endIndex: myGrid.getRowsNum()-1;
	for (var i=strIndex; i<=endIndex; i++)
	{
		var rId = myGrid.getRowId(i);
		var cIndex_dupArticle = myGrid.getColIndexById("dupArticle");
		var cIndex_dupConference = myGrid.getColIndexById("dupConference");

		var cIndex_chkbox = myGrid.getColIndexById("chkbox");
		if(typeof rId != 'undefined')
		{
			var dupArticleValue = myGrid.cells(rId, cIndex_dupArticle).getValue();
			var dupConferenceValue = myGrid.cells(rId, cIndex_dupConference).getValue();

			if((dupArticleValue == null || dupArticleValue == '') && (dupConferenceValue == null || dupConferenceValue == ''))
			{
				if(status == 'uncheck') myGrid.cellById(rId,cIndex_chkbox).setValue('1');
				else myGrid.cellById(rId,cIndex_chkbox).setValue('0');
			}
		}
	}
}
function dupWorkbench(eId, rId){
	rId = rId.substring(0, rId.length-1);
	var mappingPopup = window.open('about:blank', 'dupArticlePopup', 'height=822px,width=990px,location=no,scrollbars=yes,resizable=yes');
	var popFrm = $('#popFrm');
	popFrm.empty();
	popFrm.append($('<input type="hidden" name="eId" value="'+eId+'"/>'));
	popFrm.append($('<input type="hidden" name="rId" value="'+rId+'"/>'));
	popFrm.attr('action', '<c:url value="/erCntc/dupArticlePopup.do"/>');
	popFrm.attr('target', 'dupArticlePopup');
	popFrm.attr('method', 'POST');
	popFrm.submit();
	mappingPopup.focus();
}

function dupConWorkbench(eId, rId){
	rId = rId.substring(0, rId.length-1);
	var mappingPopup = window.open('about:blank', 'dupConferencePopup', 'height=822px,width=990px,location=no,scrollbars=yes,resizable=yes');
	var popFrm = $('#popFrm');
	popFrm.empty();
	popFrm.append($('<input type="hidden" name="eId" value="'+eId+'"/>'));
	popFrm.append($('<input type="hidden" name="rId" value="'+rId+'"/>'));
	popFrm.attr('action', '<c:url value="/erCntc/dupConferencePopup.do"/>');
	popFrm.attr('target', 'dupConferencePopup');
	popFrm.attr('method', 'POST');
	popFrm.submit();
	mappingPopup.focus();
}

function saveToArticle(){
	var idList = getCheckResultIds();
	var idArr = idList.substring(0,idList.length-1).split(";");

	if(idList == '')
	{
		dhtmlx.alert({type:"alert-warning",text:"반입 할 대상 논문을 체크 후 실행하십시오!",callback:function(){}})
	}
	else
	{
		dhtmlx.confirm({
			title:"논문으로 반입",
			ok:"Yes", cancel:"No",
			text:"논문으로 반입하시겠습니까 ?<br/>(반입 중에는 <span style='color:red;'>절대</span> 창을 닫지 말아주세요.)",
			callback:function(result){
				if(result == true){
					doBeforeGridLoad();
                    var cnt = 1;
					for(var i=0; i<idArr.length; i++){
						var resultId = idArr[i];
						$.ajax({
							url: "<c:url value="/erCntc/toArtCon.do"/>",
							data: {"rsltType": "art", "resultId": resultId},
							method: "POST"
						}).done(function(data){
						    if(idArr.length == cnt++){
                                myGrid_load();
                                dhtmlx.alert("반입을 완료했습니다.");
                            }
                        });
					}
				}
			}
		});
	}
}

function saveToConference(){
    var idList = getCheckResultIds();
    var idArr = idList.substring(0,idList.length-1).split(";");

    if(idList == '')
    {
        dhtmlx.alert({type:"alert-warning",text:"반입 할 대상 논문을 체크 후 실행하십시오!",callback:function(){}})
    }
    else
    {
        dhtmlx.confirm({
            title:"학술활동으로 반입",
            ok:"Yes", cancel:"No",
            text:"학술활동으로 반입하시겠습니까 ?<br/>(반입 중에는 <span style='color:red;'>절대</span> 창을 닫지 말아주세요.)",
            callback:function(result){
                if(result == true){
                    doBeforeGridLoad();
                    var cnt = 1;
                    for(var i=0; i<idArr.length; i++){
                        var resultId = idArr[i];
                        $.ajax({
                            url: "<c:url value="/erCntc/toArtCon.do"/>",
                            data: {"rsltType": "con", "resultId": resultId},
                            method: "POST"
                        }).done(function(data){
                            if(idArr.length == cnt++){
                                myGrid_load();
                                dhtmlx.alert("반입을 완료했습니다.");
                            }
                        });
                    }
                }
            }
        });
    }
}

function getCheckResultIds(){
	var checkedResultIds = "";
	var strIndex = (myGrid.currentPage-1) * myGrid.rowsBufferOutSize;
	var endIndex = ((myGrid.currentPage) * myGrid.rowsBufferOutSize)-1;
	endIndex = endIndex<myGrid.getRowsNum() ? endIndex: myGrid.getRowsNum()-1;
	for (var i=strIndex; i<=endIndex; i++)
	{
		var rId = myGrid.getRowId(i);
		var cIndex_chkbox = myGrid.getColIndexById("chkbox");
		if(typeof rId != 'undefined')
		{
			if(myGrid.cells(rId, cIndex_chkbox).getValue() == '1') checkedResultIds += rId + ";";
		}
	}
	return checkedResultIds;
}
</script>
</head>
<body>
	<!-- Page Title -->
	<div class="title_box">
		<h3>논문정보연계<!-- 외부정보연계 --> </h3>
	</div>
	<!-- Main Content -->
	<div class="contents_box">
		<form id="formArea" >
		<input type="hidden" id="idList" name="idList">
	    <input type="hidden" id="pMenuId" name="pMenuId" value="${param.pMenuId}"/>
	    <input type="hidden" id="navBody" name="navBody" value="${param.navBody}"/>
		<!-- START 테이블 1 -->
		<table class="view_tbl mgb_10">
			<colgroup>
				<col style="width: 20% "/>
				<col />
				<col style="width: 50px;">
			</colgroup>
			<tbody>
			<tr>
				<th>Article Doc Type</th>
				<td >
					<input type="checkbox" name="doc_type_nm" id="docType1" value="Article" class="radio" ${not empty DC01 ?'checked=\"checked\"':''}>
					<label for="docType1" class="radio_label">Article</label>

					<input type="checkbox" name="doc_type_nm" id="docType2" style="margin-left: 15px;" value="Editorial Material" class="radio" ${not empty DC02 ?'checked=\"checked\"':''}>
					<label for="docType2" class="radio_label">Editorial Material</label>

					<input type="checkbox" name="doc_type_nm" id="docType3" style="margin-left: 15px;" value="Erratum" class="radio" ${not empty DC03 ?'checked=\"checked\"':''}>
					<label for="docType3" class="radio_label">Erratum</label>

					<input type="checkbox" name="doc_type_nm" id="docType4" style="margin-left: 15px;" value="Letter" class="radio" ${not empty DC04 ?'checked=\"checked\"':''}>
					<label for="docType4" class="radio_label">Letter</label>

					<input type="checkbox" name="doc_type_nm" id="docType5" style="margin-left: 15px;" value="Note" class="radio" ${not empty DC05 ?'checked=\"checked\"':''}>
					<label for="docType5" class="radio_label">Note</label>

					<input type="checkbox" name="doc_type_nm" id="docType6" style="margin-left: 15px;" value="Review" class="radio" ${not empty DC06 ?'checked=\"checked\"':''}>
					<label for="docType6" class="radio_label">Review</label>
				</td>
				<td rowspan="2" class="option_search_td" onclick="javascript: myGrid_load();"><em>search</em></td>
			</tr>
			<tr>
				<th>Proceeding Doc Type</th>
				<td >
					<input type="checkbox" name="doc_type_nm" id="docType7" value="Article in Press" class="radio" ${not empty DC07 ? 'checked=\"checked\"':''}>
					<label for="docType7" class="radio_label">Article in Press</label>

					<input type="checkbox" name="doc_type_nm" id="docType8" style="margin-left: 15px;" value="Proceedings Paper" class="radio" ${not empty DC08 ? 'checked=\"checked\"':''}>
					<label for="docType8" class="radio_label">Proceedings Paper</label>

					<input type="checkbox" name="doc_type_nm" id="docType9" style="margin-left: 15px;" value="Conference Review" class="radio" ${not empty DC09 ? 'checked=\"checked\"':''}>
					<label for="docType9" class="radio_label">Conference Review</label>

					<input type="checkbox" name="doc_type_nm" id="docType10" style="margin-left: 15px;" value="Short" class="radio" ${not empty DC10 ? 'checked=\"checked\"':''}>
					<label for="docType10" class="radio_label">Short</label>
				</td>
			</tr>
			</tbody>
		</table>
		<div class="list_bt_area">
			<div class="list_set">
				<ul>
					<li><a href="#" onclick="javascript:saveToArticle();" class="list_icon14">논문으로 반입</a></li>
					<li><a href="#" onclick="javascript:saveToConference();" class="list_icon14">학술할동으로 반입</a></li>
				</ul>
			</div>
		</div>
		<!-- END 테이블 1 -->
		<div id="mainLayout" style="position: relative; width: 100%;height: 100%;"></div>
		<div id="pagingObj" style="z-index: 1; height: 60px; margin-top: 5px;" >
			<div id="pagingArea" style="z-index: 1;"></div>
		</div>
	</form>
	</div>
</body>
</html>