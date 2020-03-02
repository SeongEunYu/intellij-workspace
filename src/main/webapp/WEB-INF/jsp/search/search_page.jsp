<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../pageInit.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta http-equiv="cache-Control" content="co-cache" />
<link rel="shortcut icon" href="${pageContext.request.contextPath}/images/${sysConf['shortcut.icon']}">
<title>유사분야 연구자검색</title>
<link type="text/css" href="${contextPath}/css/layout.css" rel="stylesheet" />
<link type="text/css" href="${contextPath}/css/style.css" rel="stylesheet" />
<link type="text/css" href="${contextPath}/js/dhtmlx/skins/${sysConf['dhtmlx.skin']}/dhtmlx.css" rel="stylesheet" />
<script type="text/javascript" src="${contextPath}/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="${contextPath}/js/dhtmlx/dhtmlx.js"></script>
<script type="text/javascript" src="${contextPath}/js/script.js"></script>
<script type="text/javascript" src="${contextPath}/js/mainLayout.js"></script>
<script type="text/javascript" src="${contextPath}/js/chart/fusioncharts.js"></script>
<style type="text/css">
div.dhxcombo_dhx_terrace {height: 19px;}
div.dhxcombo_dhx_terrace input.dhxcombo_input{height: 19px;}
div.dhxcombo_dhx_terrace div.dhxcombo_select_button{height: 13px;}
div.combo_info {color: gray;font-size: 11px;padding-bottom: 5px;padding-left: 2px;font-family: Tahoma;}
.dhxlayout_base_dhx_terrace div.dhx_cell_layout div.dhx_cell_hdr{}
</style>
<script type="text/javascript">
var dhxTabbar, rschLayout, insttLayout, dhxLayout, dhxLayout2, myGrid, insttGrid, t, dhxWins, pageX, pageY, insttCombo, chart_ChartId1;
$(document).ready(function(){

	setMainLayoutHeight($('#mainLayout'), 20);

	if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
	else  window.addEventListener("resize",resizeLayout, false);

	loadTabbarCellsA1();

});

function loadTabbarCellsA1(){

	//dhxTabbar.cells("a1").attachObject("rschPopup");

	//set layout
	dhxLayout = new dhtmlXLayoutObject("mainLayout","1C");
	dhxLayout.cells("a").hideHeader();
	dhxLayout.setSizes(false);

	//attach myGrid
	myGrid = dhxLayout.cells("a").attachGrid();
	myGrid.setImagePath("${dhtmlXImagePath}");
	myGrid.setHeader("No,성명,직급,학과,유사논문/전체논문,유사특허/전체특허,유사과제/전체과제,외부과제,유사도,교내네트워크,교외네트워크", null, grid_head_center_bold);
	myGrid.setColumnIds("No,korNm,posiNm,dpetKor,artsCo,patentCo,fundingCo,exfundingCo,score,inyu,outer");
	myGrid.setInitWidths("40,100,110,*,100,100,110,100,100,100,100");
	myGrid.setColAlign("center,center,center,left,center,center,center,center,center,center,center");
	myGrid.setColTypes("ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro");
	myGrid.setColSorting("na,na,na,na,na,na,na,na,na,na,na");
	myGrid.setEditable(false);
	myGrid.enableTooltips("false,true,true,true,false,false,false,false,false,false,false");
	myGrid.attachEvent("onXLS", doBeforeGridLoad);
	myGrid.attachEvent("onXLE", doOnGridLoaded);
	myGrid.setColumnHidden(myGrid.getColIndexById("exfundingCo"),true);
	myGrid.setColumnHidden(myGrid.getColIndexById("score"),true);
	myGrid.enableColSpan(true);
	myGrid.init();
	//myGrid_load();

}

function myGrid_load(){
	doBeforeGridLoad();
	var url = "${contextPath}/search/findSearchResultList.do?"+$('#formArea').serialize();
	myGrid.clearAndLoad(url, doOnGridLoaded);
}

function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){ setMainLayoutHeight($('#mainLayout'), 20); dhxLayout.setSizes(false); },200);}
function doOnGridLoaded(){setTimeout(function() {dhxLayout.cells("a").progressOff();}, 100);}
function doBeforeGridLoad(){dhxLayout.cells("a").progressOn();}

function initInsttCombo(){
	insttCombo = new dhtmlXCombo('coInstt','combo',628);
	insttCombo.enableFilteringMode(true, "${contextPath}/search/findCoInsttOptionsAjax.do", true);
}

function loadTabbarCellsA2(){

	var miusValue = browserType() == 'I' ? 1275 : 1215;
	dhxTabbar.cells("a2").attachObject("insttPopup");
	$('#insttLayout').css('height',($(document).height()-miusValue)+"px");
	dhxLayout2 = new dhtmlXLayoutObject("insttLayout","1C");
	dhxLayout2.cells("a").hideHeader();
	dhxLayout2.setSizes(false);

	insttGrid = dhxLayout2.cells("a").attachGrid();
	insttGrid.setImagePath("${dhtmlXImagePath}");
	insttGrid.setHeader("No,성명,직급,학과,공저논문/전체논문,참여특허/전체특허,참여과제/전체과제,참여과제/전체과제,유사도,교내네트워크,교외네트워크", null, grid_head_center_bold);
	insttGrid.setColumnIds("No,korNm,posiNm,dpetKor,artsCo,patentCo,fundingCo,exfundingCo,score,inyu,outer");
	insttGrid.setInitWidths("40,100,110,*,120,120,110,100,100,100,100");
	insttGrid.setColAlign("center,center,center,left,center,center,center,center,center,center,center");
	insttGrid.setColTypes("ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro");
	insttGrid.setColSorting("na,na,na,na,na,na,na,na,na,na,na");
	insttGrid.setEditable(false);
	insttGrid.enableTooltips("false,true,true,true,false,false,false,false,false,false,false");
	insttGrid.setColumnHidden(insttGrid.getColIndexById("fundingCo"),true);
	insttGrid.setColumnHidden(insttGrid.getColIndexById("patentCo"),true);
	insttGrid.setColumnHidden(insttGrid.getColIndexById("score"),true);
	insttGrid.enableColSpan(true);
	insttGrid.init();

}

function insttGrid_load(){
	dhxLayout2.cells("a").progressOn();
	var url = "${contextPath}/search/findSearchResultList.do";
	url += "?collection=" +$('#insttCollection').val();
	url += "&keyword=" +insttCombo.getSelectedValue();
	url += "&field=insttname";
	url += "&tabName="+$('#instTabName').val();
	insttGrid.clearAndLoad(url, function(){setTimeout(function() {dhxLayout2.cells("a").progressOff();}, 100);});
}

var myLayout, winGrid;
function totalArticleViewPopup(userId,korNm){


    var wWidth = 800;
    var wHeight = 650;
    pageX = $(window).width() /2 - wWidth /2 + $(window).scrollLeft();
    pageY = $(window).height() /2 - wHeight /2 + $(window).scrollTop();

	if(dhxWins != null && dhxWins.unload != null)
	{
		dhxWins.unload();
		dhxWins = null;
	}

	dhxWins = new dhtmlXWindows({
		viewport : {objec : 'windVP'},
		wins : [ {id : 'w1', left : pageX, top : pageY, width: wWidth, height: wHeight, text: korNm +"-전체논문목록", resize : false} ]
	});
	dhxWins.window('w1').setModal(true);

	myLayout = dhxWins.window('w1').attachLayout('1C')
	myLayout.cells('a').hideHeader();

	winGrid = myLayout.cells("a").attachGrid();
	winGrid.setImagePath('${dhtmlXImagePath}');
	winGrid.enableColSpan(true);
	winGrid.enableMultiline(true);
	winGrid.attachEvent("onXLS", function() {
		dhxWins.window('w1').progressOn();
	});
	winGrid.attachEvent("onXLE", function() {
		dhxWins.window('w1').progressOff();
	});
	winGrid.enableTooltips("false,false");
	winGrid.init();
	$('#selectUserId').val(userId);
	winGrid.loadXML('${contextPath}/search/findTotalArticleListByUserId.do?'+$('#formArea').serialize());
}

function matchArticleViewPopup(userId, korNm, tabName){

    var wWidth = 800;
    var wHeight = 650;
    pageX = $(window).width() /2 - wWidth /2 + $(window).scrollLeft();
    pageY = $(window).height() /2 - wHeight /2 + $(window).scrollTop();

	if(dhxWins != null && dhxWins.unload != null)
	{
		dhxWins.unload();
		dhxWins = null;
	}

	dhxWins = new dhtmlXWindows({
		viewport : {objec : 'windVP'},
		wins : [ {id : 'w1', left : pageX, top : pageY, width: wWidth, height: wHeight, text: korNm +"-유사논문목록", resize : false} ]
	});
	dhxWins.window('w1').setModal(true);

	myLayout = dhxWins.window('w1').attachLayout('1C')
	myLayout.cells('a').hideHeader();

	winGrid = myLayout.cells("a").attachGrid();
	winGrid.setImagePath('${dhtmlXImagePath}');
	winGrid.enableColSpan(true);
	winGrid.enableMultiline(true);
	winGrid.attachEvent("onXLS", function() {
		dhxWins.window('w1').progressOn();
	});
	winGrid.attachEvent("onXLE", function() {
		dhxWins.window('w1').progressOff();
	});
	winGrid.enableTooltips("false,false");
	winGrid.init();
	$('#selectUserId').val(userId);

	var url = '${contextPath}/search/findSearchArticleListByUserId.do?';
	if(tabName == 'rsrchr')
	{
		winGrid.loadXML(url+$('#formArea').serialize());
	}
	else if(tabName =='instt')
	{
		url += 'userId='+userId;
		url += "&keyword=" +  encodeURIComponent(insttCombo.getSelectedValue());
		url += '&collection=article';
		url += "&field=insttname";
		winGrid.loadXML(url);
	}

}

function totalPatentViewPopup(userId, korNm){

    var wWidth = 800;
    var wHeight = 650;
    pageX = $(window).width() /2 - wWidth /2 + $(window).scrollLeft();
    pageY = $(window).height() /2 - wHeight /2 + $(window).scrollTop();

	if(dhxWins != null && dhxWins.unload != null)
	{
		dhxWins.unload();
		dhxWins = null;
	}

	dhxWins = new dhtmlXWindows({
		viewport : {objec : 'windVP'},
		wins : [ {id : 'w1', left : pageX, top : pageY, width: wWidth, height: wHeight, text: korNm + "-전체특허목록", resize : false} ]
	});
	dhxWins.window('w1').setModal(true);

	myLayout = dhxWins.window('w1').attachLayout('1C')
	myLayout.cells('a').hideHeader();

	winGrid = myLayout.cells("a").attachGrid();
	winGrid.setImagePath('${dhtmlXImagePath}');
	winGrid.enableColSpan(true);
	winGrid.enableMultiline(true);
	winGrid.attachEvent("onXLS", function() {
		dhxWins.window('w1').progressOn();
	});
	winGrid.attachEvent("onXLE", function() {
		dhxWins.window('w1').progressOff();
	});
	winGrid.enableTooltips("false,false");
	winGrid.init();
	$('#selectUserId').val(userId);
	winGrid.loadXML('${contextPath}/search/findTotalPatentListByUserId.do?'+$('#formArea').serialize());
}

function matchPatentViewPopup(userId, korNm){

    var wWidth = 800;
    var wHeight = 650;
    pageX = $(window).width() /2 - wWidth /2 + $(window).scrollLeft();
    pageY = $(window).height() /2 - wHeight /2 + $(window).scrollTop();

	if(dhxWins != null && dhxWins.unload != null)
	{
		dhxWins.unload();
		dhxWins = null;
	}

	dhxWins = new dhtmlXWindows({
		viewport : {objec : 'windVP'},
		wins : [ {id : 'w1', left : pageX, top : pageY, width: wWidth, height: wHeight, text: korNm + "-유사특허목록", resize : false} ]
	});
	dhxWins.window('w1').setModal(true);

	myLayout = dhxWins.window('w1').attachLayout('1C')
	myLayout.cells('a').hideHeader();

	winGrid = myLayout.cells("a").attachGrid();
	winGrid.setImagePath('${dhtmlXImagePath}');
	winGrid.enableColSpan(true);
	winGrid.enableMultiline(true);
	winGrid.attachEvent("onXLS", function() {
		dhxWins.window('w1').progressOn();
	});
	winGrid.attachEvent("onXLE", function() {
		dhxWins.window('w1').progressOff();
	});
	winGrid.enableTooltips("false,false");
	winGrid.init();
	$('#selectUserId').val(userId);
	winGrid.loadXML('${contextPath}/search/findSearchPatentListByUserId.do?'+$('#formArea').serialize());
}

function totalFundingViewPopup(userId, korNm){

    var wWidth = 800;
    var wHeight = 650;
    pageX = $(window).width() /2 - wWidth /2 + $(window).scrollLeft();
    pageY = $(window).height() /2 - wHeight /2 + $(window).scrollTop();

	if(dhxWins != null && dhxWins.unload != null)
	{
		dhxWins.unload();
		dhxWins = null;
	}

	dhxWins = new dhtmlXWindows({
		viewport : {objec : 'windVP'},
		wins : [ {id : 'w1', left : pageX, top : pageY, width: wWidth, height: wHeight, text: korNm + "-전체과제목록", resize : false} ]
	});
	dhxWins.window('w1').setModal(true);

	myLayout = dhxWins.window('w1').attachLayout('1C')
	myLayout.cells('a').hideHeader();

	winGrid = myLayout.cells("a").attachGrid();
	winGrid.setImagePath('${dhtmlXImagePath}');
	winGrid.enableColSpan(true);
	winGrid.enableMultiline(true);
	winGrid.attachEvent("onXLS", function() {
		dhxWins.window('w1').progressOn();
	});
	winGrid.attachEvent("onXLE", function() {
		dhxWins.window('w1').progressOff();
	});
	winGrid.enableTooltips("false,false");
	winGrid.init();
	$('#selectUserId').val(userId);
	winGrid.loadXML('${contextPath}/search/findTotalFundingListByUserId.do?'+$('#formArea').serialize());
}

function matchFundingViewPopup(userId, korNm, tabName){

    var wWidth = 800;
    var wHeight = 650;
    pageX = $(window).width() /2 - wWidth /2 + $(window).scrollLeft();
    pageY = $(window).height() /2 - wHeight /2 + $(window).scrollTop();

	if(dhxWins != null && dhxWins.unload != null)
	{
		dhxWins.unload();
		dhxWins = null;
	}

	dhxWins = new dhtmlXWindows({
		viewport : {objec : 'windVP'},
		wins : [ {id : 'w1', left : pageX, top : pageY, width: wWidth, height: wHeight, text: korNm + "-유사과제목록", resize : false} ]
	});
	dhxWins.window('w1').setModal(true);

	myLayout = dhxWins.window('w1').attachLayout('1C')
	myLayout.cells('a').hideHeader();

	winGrid = myLayout.cells("a").attachGrid();
	winGrid.setImagePath('${dhtmlXImagePath}');
	winGrid.enableColSpan(true);
	winGrid.enableMultiline(true);
	winGrid.attachEvent("onXLS", function() {
		dhxWins.window('w1').progressOn();
	});
	winGrid.attachEvent("onXLE", function() {
		dhxWins.window('w1').progressOff();
	});
	winGrid.enableTooltips("false,false");
	winGrid.init();
	$('#selectUserId').val(userId);


	if(tabName == 'rsrchr')
	{
		var url = '${contextPath}/search/findSearchFundingListByUserId.do?';
		winGrid.loadXML(url+$('#formArea').serialize());
	}
	else if(tabName =='instt')
	{
		var url = '${contextPath}/search/findSearchExFundingListByUserId.do?';
		url += 'userId='+userId;
		url += "&keyword=" +encodeURIComponent(insttCombo.getSelectedValue());
		url += '&collection=exfunding';
		url += "&field=insttname";
		winGrid.loadXML(url);
	}
}
function coAuthorNetworkView(tabName){

	$('body').append($('<div id="chartdiv1" align="left"></div>'));

    var wWidth = 800;
    var wHeight = 650;
    pageX = $(window).width() /2 - wWidth /2 + $(window).scrollLeft();
    pageY = $(window).height() /2 - wHeight /2 + $(window).scrollTop();

	if(dhxWins != null && dhxWins.unload != null)
	{
		dhxWins.unload();
		dhxWins = null;
	}

	dhxWins = new dhtmlXWindows({
		viewport : {objec : 'windVP'},
		wins : [ {id : 'w1', left : pageX, top : pageY, width: wWidth, height: wHeight, text: "결과내 공저네트워크", resize : false} ]
	});
	dhxWins.window('w1').setModal(true);

	myLayout = dhxWins.window('w1').attachLayout('1C')
	myLayout.cells('a').hideHeader();
	myLayout.cells('a').attachObject("chartdiv1");

	//dhxWins.window('w1').attachEvent('onClose',function(){$('#chartdiv1').empty();});

	var users = "";
	if(tabName == 'rsrchr')
	{
		for(var i=0; i < myGrid.getRowsNum(); i++) users += myGrid.getRowId(i) + ";";
	}
	else if(tabName =='instt')
	{
		for(var i=0; i < insttGrid.getRowsNum(); i++) users += insttGrid.getRowId(i) + ";";
	}
	users = users.substring(0, users.length-1);
	$.ajax({
		url : "${contextPath}/search/findCoAuthorChartXMLAjax.do",
		dataType : 'json',
		data : {'users' : users},
		success : function(data, textStatus, jqXHR){

			   chart_ChartId1 =  new FusionCharts({
				 	  type:'dragnode',
				 	  renderAt:'chartdiv1',
				 	  width:'774',
				 	  height:'589',
				 	  dataFormat:'xml',
				 	  dataSource:data.chartXML
				   }).render();
		}
	}).done(function(){});
}

function coAuthorNetworkWithinInstView(userId, tabName){

	$('body').append($('<div id="chartdiv1" align="left"></div>'));

    var wWidth = 800;
    var wHeight = 650;
    pageX = $(window).width() /2 - wWidth /2 + $(window).scrollLeft();
    pageY = $(window).height() /2 - wHeight /2 + $(window).scrollTop();

	if(dhxWins != null && dhxWins.unload != null)
	{
		dhxWins.unload();
		dhxWins = null;
	}

	dhxWins = new dhtmlXWindows({
		viewport : {objec : 'windVP'},
		wins : [ {id : 'w1', left : pageX, top : pageY, width: wWidth, height: wHeight, text: "교내공저네트워크", resize : false} ]
	});
	dhxWins.window('w1').setModal(true);

	myLayout = dhxWins.window('w1').attachLayout('1C')
	myLayout.cells('a').hideHeader();
	myLayout.cells('a').attachObject("chartdiv1");

	//dhxWins.window('w1').attachEvent('onClose',function(){$('#chartdiv1').empty();});

	var users = "";
	if(tabName == 'rsrchr')
	{
		for(var i=0; i < myGrid.getRowsNum(); i++) users += myGrid.getRowId(i) + ";";
	}
	else if(tabName =='instt')
	{
		for(var i=0; i < insttGrid.getRowsNum(); i++) users += insttGrid.getRowId(i) + ";";
	}
	users = users.substring(0, users.length-1);
	$.ajax({
		url : "${contextPath}/search/findCoAuthorWithInstChartXMLAjax.do",
		dataType : 'json',
		data : {'userId' : userId},
		success : function(data, textStatus, jqXHR){

			   chart_ChartId1 =  new FusionCharts({
				 	  type:'dragnode',
				 	  renderAt:'chartdiv1',
				 	  width:'774',
				 	  height:'589',
				 	  dataFormat:'xml',
				 	  dataSource:data.chartXML
				   }).render();
		}
	}).done(function(){});
}

function coAuthorNetworkWithinOtherInstView(userId, tabName){

	$('body').append($('<div id="chartdiv1" align="left"></div>'));

    var wWidth = 800;
    var wHeight = 650;
    pageX = $(window).width() /2 - wWidth /2 + $(window).scrollLeft();
    pageY = $(window).height() /2 - wHeight /2 + $(window).scrollTop();

	if(dhxWins != null && dhxWins.unload != null)
	{
		dhxWins.unload();
		dhxWins = null;
	}

	dhxWins = new dhtmlXWindows({
		viewport : {objec : 'windVP'},
		wins : [ {id : 'w1', left : pageX, top : pageY, width: wWidth, height: wHeight, text: "교외공저네트워크", resize : false} ]
	});
	dhxWins.window('w1').setModal(true);

	myLayout = dhxWins.window('w1').attachLayout('1C')
	myLayout.cells('a').hideHeader();
	myLayout.cells('a').attachObject("chartdiv1");

	//dhxWins.window('w1').attachEvent('onClose',function(){$('#chartdiv1').empty();});

	$.ajax({
		url : "${contextPath}/search/findCoAuthorWithOtherInstChartXMLAjax.do",
		dataType : 'json',
		data : {'userId' : userId},
		success : function(data, textStatus, jqXHR){

			   chart_ChartId1 =  new FusionCharts({
				 	  type:'dragnode',
				 	  renderAt:'chartdiv1',
				 	  width:'774',
				 	  height:'589',
				 	  dataFormat:'xml',
				 	  dataSource:data.chartXML
				   }).render();
		}
	}).done(function(){});
}


function totalExFundingViewPopup(userId, korNm){

    var wWidth = 800;
    var wHeight = 700;
    pageX = $(window).width() /2 - wWidth /2 + $(window).scrollLeft();
    pageY = $(window).height() /2 - wHeight /2 + $(window).scrollTop();

	if(dhxWins != null && dhxWins.unload != null)
	{
		dhxWins.unload();
		dhxWins = null;
	}

	dhxWins = new dhtmlXWindows({
		viewport : {objec : 'windVP'},
		wins : [ {id : 'w1', left : pageX, top : pageY, width: wWidth, height: wHeight, text: korNm + "-전체과제목록", resize : false} ]
	});
	dhxWins.window('w1').setModal(true);

	myLayout = dhxWins.window('w1').attachLayout('1C')
	myLayout.cells('a').hideHeader();

	winGrid = myLayout.cells("a").attachGrid();
	winGrid.setImagePath('${dhtmlXImagePath}');
	winGrid.enableColSpan(true);
	winGrid.enableMultiline(true);
	winGrid.attachEvent("onXLS", function() {
		dhxWins.window('w1').progressOn();
	});
	winGrid.attachEvent("onXLE", function() {
		dhxWins.window('w1').progressOff();
	});
	winGrid.enableTooltips("false,false");
	winGrid.init();
	winGrid.loadXML('${contextPath}/search/findTotalExFundingListByUserId.do?srchUserId='+userId);
}
</script>
</head>
<body class="popup_body">

	<div class="popup_header">
		<h2>기술키워드기반 연구자검색</h2>
		<a href="javascript:window.close();" class="popup_close_bt">닫기</a>
	</div>

	<div id="myTabbar" style="width: 918px;"></div>

	<div class="popup_inner">
		<div class="p_top_box">
			<div class="top_search_area">
			<form id="formArea" action="javascript:myGrid_load();">
			  <input type="hidden" name="tabName" id="tabName" value="rsrchr" />
			  <input type="hidden" name="srchUserId" id="selectUserId" />
			  <span class="l_select_span">
			  	<select name="collection" id="collection" class="select_type">
			  		<option value="">전체</option>
			  		<option value="article">논문</option>
			  		<option value="patent">특허</option>
			  		<option value="funding">연구과제</option>
			  	</select>
			  	<select name="field" id="field" class="select_type">
			  		<option value="">전체</option>
					<option value="title">제목</option>
					<option value="keyword">키워드</option>
					<option value="abstract">초록</option>
			  	</select>
			  </span>
		  	  <p>
		  		<input type="text" name="keyword"  id="keyword" class="input_type" onkeydown="if(event.keyCode==13){myGrid_load();}">
		  		<input type="button" value="search" class="p_search_bt" onclick="javascript:myGrid_load();">
		  	  </p>
		  	</form>
			</div>
		</div>
		<div class="list_bt_area">
			<div class="list_set">
				<ul>
					<li class="first_li"><a href="javascript:coAuthorNetworkView('rsrchr');" class="list_icon05">결과내 공저네트워크</a></li>
				</ul>
			</div>
		</div>
		<div id="mainLayout" style="position: relative; width: 100%;height: 100%;"></div>
	</div>


	<%--
	 <div id="insttPopup" class="popup_wrap" style="width:100%;">
	 	<div class="popup_inner">
			<div class="p_top_box" style="padding: 20px 20px 0px 20px;">
				<div class="top_search_area">
				<form id="insttForm" action="javascript:insttGrid_load();">
				  <input type="hidden" name="tabName" id="instTabName" value="instt"/>
				  <input type="hidden" name="srchUserId" id="insttSelectUserId" />
				  <span class="l_select_span">
				  	<select name="collection" id="insttCollection" class="select_type">
				  		<option value="">전체</option>
				  		<option value="article">논문</option>
				  		<option value="exfunding">연구과제</option>
				  	</select>
				  </span>
			  	  <div style="margin: 0 0 0 123px;">
				  	<div id="coInstt" style="width: 628px;"></div>
			  	  	<div class="combo_info">검색할 기관명을 입력하세요.. </div>
				  	<input type="button" value="search" class="p_search_bt" onclick="javascript:insttGrid_load();">
			  	  </div>
			  	</form>
				</div>
			</div>
			<div class="list_bt_area">
				<div class="list_set">
					<ul>
						<li class="first_li"><a href="javascript:coAuthorNetworkView('instt');" class="list_icon05">결과내 공저네트워크</a></li>
						<!--
						<li class="first_li"><a href="javascript:toExcel();" class="list_icon20">Export</a></li>
						 -->
					</ul>
				</div>
			</div>
			<div id="insttLayout" style="position: relative; width: 100%;height: 100%;"></div>
			<script type="text/javascript">$('#insttLayout').css('height',($(document).height()-590)+"px");</script>
	 	</div>
	 </div>
	 --%>
</body>
</html>
