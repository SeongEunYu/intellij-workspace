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
<script type="text/javascript" src="${contextPath}/js/mainLayout.js"></script>
<script type="text/javascript">
	var swfu, upload_url = "${contextPath}/import/uploadFile.do?gubun=WOS";
	var myLayout, myVault, myForm, formData, impLayout;
    var autoRefreshHistory;
	$(document).ready(function(){

		if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
		else  window.addEventListener("resize",resizeLayout, false);

		if('${running}' == "true"){
			alert("반입이 이미 진행 중에 있습니다. 완료된 후 다시 시도해주세요.");
		}

		impLayout = new dhtmlXLayoutObject("importLayout", "3U");
		impLayout.cells("a").setText("1. File Format");
		impLayout.cells("b").setText("2. File Upload");
		impLayout.cells("c").setText("3. Input Additional Info");
		myVault = impLayout.cells("b").attachVault({
		    container:  "vaultObj",             // html container for vault
		    uploadUrl:  "${contextPath}/import/vaultUploadFile.do?gubun=WIPSON&format=<%=R2Constant.SOURC_FILE_FORMAT_XLS %>", 		// html4/html5 upload url
		    swfPath:    "dhxvault.swf",         // path to flash uploader
		    swfUrl:     "${contextPath}/import/vaultUploadFile.do?gubun=WIPSON&format=<%=R2Constant.SOURC_FILE_FORMAT_XLS %>", 		// flash upload url
		    slXap:      "dhxvault.xap",         // path to silverlight uploader
		    slUrl:      "${contextPath}/import/vaultUploadFile.do?gubun=WIPSON&format=<%=R2Constant.SOURC_FILE_FORMAT_XLS %>" 			// silverlight upload url, FULL path required
		});
		myVault.attachEvent("onUploadFile", onFileUploadComplete);
		myVault.attachEvent("onFileRemove", onFileRemove);

		formData = [
					{type: "settings", position: "label-right",labelWidth: "auto", inputWidth: "auto", offsetLeft: 30, offsetTop: 5},
					{type: "label", label: "Please select file format :"},
					{type: "radio", name: "format", value: "<%=R2Constant.SOURC_FILE_FORMAT_XLS %>", label: "XLS(엑셀 97-2003)", checked:true}
				];
		myForm = impLayout.cells("a").attachForm(formData);

		myForm.attachEvent("onChange", function(name,value,is_checked){
			myVault.setURL("${contextPath}/import/vaultUploadFile.do?gubun=WIPSON&format="+value);
			myVault.setSLURL("${contextPath}/import/vaultUploadFile.do?gubun=WIPSON&format="+value);
			myVault.setSWFURL("${contextPath}/import/vaultUploadFile.do?gubun=WIPSON&format="+value);
		});

		impLayout.cells("c").appendObject("uploadFileInfo");


		if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
		else  window.addEventListener("resize",resizeLayout, false);
		doInitGrid();
		myGrid_load();
		$('#importLayout').css('width','100%');
		impLayout.attachFooter("my_copy");

		var running = '${param.running}';
		if(running == 'false'){
			$('#chkAutoRefresh').prop('checked','checked');
			toggleAutoRefresh();
		}

	});
	// 삭제해도 될듯
	function changeFormat(){
		myVault.setURL("${contextPath}/import/uploadTest.do?gubun=WOS&format="+$(':radio[name="format"]:checked').val());
		myVault.setSLURL("${contextPath}/import/uploadTest.do?gubun=WOS&format="+$(':radio[name="format"]:checked').val());
		myVault.setSWFURL("${contextPath}/import/uploadTest.do?gubun=WOS&format="+$(':radio[name="format"]:checked').val());
	}

	function onFileUploadComplete(file,extra){
		var $tbody = $('#addInfoTbody');
		var tr = $('<tr id="f_tr_'+file.id+'" ></tr>');
		tr.append($('<td>'+file.name+'</td>'))
		tr.append($('<td></td>').append($('<input type="text" name="ftitle" value="'+file.name+'" maxlength="50" style="width:100%" title="파일제목" required="true"/>')));
		tr.append($('<td></td>').append($('<input type="text" name="fquery" maxlength="500" style="width:98%" value="""/>')));
		tr.append($('<td>'+extra.count+'</td>').append($('<input type="hidden" name="fformat" value="'+extra.format+'"/>')).append($('<input type="hidden" name="furl" value="'+extra.url+'"/>')));
		tr.append($('<td><div class="dhx_vault_file_param dhx_vault_file_delete">&nbsp;</div></td>'));
		$tbody.append(tr);
	}

	function onFileRemove(file){
		$('#addInfoTbody > #f_tr_'+file.id).remove();
	}
	function submitForm(form) {
		if (document.getElementsByName("ftitle").length == 0) {
			alert("파일이 한개 이상 필요합니다.");
			return;
		}
		/*
		if (!validation(form)) return;
		*/
		$("#sForm").submit();
	}
	function maintenance() {
		doBeforeGridLoad()
		$.ajax({
			url: "${contextPath}/import/maintenance.do",
			dataType: "json",
			data: {"sourcDvsnCd":"WOS"},
			method: "POST",
			success: function(data){

			}
		}).done(function(data){
			//setTimeout(function() { dhxLayout.cells("b").progressOff(); }, 100);
			doOnGridLoaded()
			dhtmlx.alert({type:"alert",text:data.message,callback:function(){}})
		});
	}

	var dhxLayout, myGrid, t;
	function doInitGrid(){
		dhxLayout = new dhtmlXLayoutObject("mainLayout","1C");
		dhxLayout.cells("a").hideHeader();
		dhxLayout.setSizes(false);
		myGrid = dhxLayout.cells("a").attachGrid();
		myGrid.setImagePath("${dhtmlXImagePath}");
		myGrid.setHeader("작업ID,파일포맷,작업명,검색어,전체,중복,에러,입력,반입일자,상태,에러 레코드", null, grid_head_center_bold);
		myGrid.setColumnIds("id,format,title,query,totCount,dupCount,errCount,insCount,regdate,status,errorLog");
		myGrid.setInitWidths("70,100,*,140,60,60,60,60,150,100,150");
		myGrid.setColAlign("center,center,left,left,center,center,center,center,center,center,left");
		myGrid.setColSorting("int,str,str,str,na,na,na,na,str,str,na");
		myGrid.setColTypes("ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro");
		myGrid.setEditable(false);
		myGrid.enableColSpan(true);
		myGrid.attachEvent("onBeforeSorting",myGrid_onBeforeSorting);
		myGrid.attachEvent("onXLS", doBeforeGridLoad);
		myGrid.attachEvent("onXLE", doOnGridLoaded);
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
		myGrid.clearAndLoad(url, doOnGridLoaded);
	}
	function getGridRequestURL(){ return "${contextPath}/import/findRdHisotryList.do?gubun=WIPSON"; }
	function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){ dhxLayout.setSizes(false); impLayout.setSizes(false); },200);}
	function doOnGridLoaded(){setTimeout(function() {dhxLayout.cells("a").progressOff();}, 100);}
	function doBeforeGridLoad(){dhxLayout.cells("a").progressOn();}
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
<!-- start #content_wrapper -->
<form id="sForm" name="sForm" method="post" action="${contextPath}/import/parseWipson.do?utilType=exr">
	<input type="hidden" name="pMenuId" value="${param.pMenuId}"/>
	<!-- Page Title -->
	<div class="title_box">
		<h3><spring:message code="menu.wipson"/> <spring:message code="menu.wipson.import"/></h3>
	</div>
	<!-- Main Content -->
	<div class="contents_box">
		<div id="importLayout"></div>
		<div id="uploadFileInfo" style="width: 100%; display: none;">
			<table class="sub_basic_tb" style="width: 100%;">
				<colgroup>
					<col style="width: 20%" />
					<col style="width: 30%" />
					<col style="width: 30%" />
					<col style="width: 10%" />
					<col style="width: 5%" />
				</colgroup>
				<thead>
					<tr>
						<th>File</th>
						<th>Title</th>
						<th>Query</th>
						<th>Count</th>
						<th></th>
					</tr>
				</thead>
				<tbody id="addInfoTbody"></tbody>
			</table>

		</div>
		<!-- start 반입이력 테이블 -->
		<div class="txt_basic_12bold" style="height:20px; padding-top: 15px;"></div>
		<div id="mainLayout" style="position: relative; width: 100%;height: 50%;"></div>
		<script type="text/javascript">setMainLayoutHeight($('#mainLayout'));</script>
		<div id="pagingObj" style="z-index: 1; height: 60px; margin-top: 5px;" >
			<div id="pagingArea" style="z-index: 1;"></div>
		</div>
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
						<li><a href="#" onclick="javascript:submitForm(document.sForm);" class="list_icon14">데이터반입</a></li>
						<li><a href="#" onclick="javascript:maintenance();" class="list_icon15">데이터정비</a></li>
					</ul>
				</div>
			</div>
		</div>
	</div>
</form>
</body>