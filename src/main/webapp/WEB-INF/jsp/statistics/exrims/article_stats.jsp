<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../pageInit.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Article Statistics</title>
<script type="text/javascript">
var dhxTabbar, dhxLayout, myGrid, pubLayout, pubGrid, lineChart, t;

$(document).ready(function(){
	$('#my_tabbar').css('height', ($(document).height() - 130) + "px");

	if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
	else  window.addEventListener("resize",resizeLayout, false);

	dhxTabbar = new dhtmlXTabBar("my_tabbar");
	dhxTabbar.addTab("a1","반입통계",null,null,true);
	dhxTabbar.addTab("a2","출판년도별");
	//dhxTabbar.addTab("a3","학과별");
	//dhxTabbar.addTab("a4","개인별");

	loadTabbarCellsA1();
	loadTabbarCellsA2();
});

function loadTabbarCellsA2(){
	pubLayout = dhxTabbar.cells("a2").attachLayout({
		pattern:"1C",
		cells:[
		      	{id:"a", text:"By Publication Year", header:"hidden"}
		      ]
	});

	pubGrid =  pubLayout.cells('a').attachGrid();
	pubGrid.setImagePath("${dhtmlXImagePath}");
	pubGrid.setHeader("출판년도,WOS,SCOPUS,KCI,OTHERS,계,IF합계,TC합계,IF있는논문건수,TC있는논문건수", null, grid_head_center_bold);
	pubGrid.setInitWidths("*,105,105,105,105,105,105,105,105,105");
	pubGrid.setColAlign("center,center,center,center,center,center,center,center,center,center");
	pubGrid.setColTypes("ro,ro,ro,ro,ro,ro,ro,ro,ro,ro");
	pubGrid.setColSorting("na,na,na,na,na,na,na,na,na,na");
	pubGrid.setEditable(false);
	pubGrid.enableColSpan(true);
	pubGrid.init();
	pubGrid.clearAndLoad("${contextPath}/statistics/findArticeStatsByPubyear.do?searchYear=2015&gubun=ALL");
}
function loadTabbarCellsA1(){
	dhxLayout = dhxTabbar.cells("a1").attachLayout({
		pattern:"2U",
		cells:[
		      	{id:"a", text:"Data", width:600},
		      	{id:"b", text:"Chart"}
		      ]
	});
	lineChart = dhxLayout.cells('b').attachChart({
			view:"line",
			value:"#data0#",
			label:"#data0#",
			tooltip:{
				template:"#data0#"
			},
			width:50,
			origin:0,
			yAxis:{
				start:0,
				step: 50,
				end: 300
			},
			group:{ by:"#data0#", map:{ data0:["#data7#","sum"] } },
			xAxis:{ template:"#id#" },
			border:false
	});

	myGrid = dhxLayout.cells('a').attachGrid();
	myGrid.setImagePath("${dhtmlXImagePath}");
	myGrid.setHeader("년월,횟수,전체건수,중복,반입,미작업,보류,작업완료,작업제외", null, grid_head_center_bold);
	myGrid.setInitWidths("*,60,68,68,68,68,68,68,68");
	myGrid.setColAlign("center,center,center,center,center,center,center,center,center");
	myGrid.setColTypes("ro,ro,ro,ro,ro,ro,ro,ro,ro");
	myGrid.setColSorting("na,na,na,na,na,na,na,na,na");
	myGrid.setEditable(false);
	myGrid.enableColSpan(true);
	myGrid.init();
	myGrid.clearAndLoad("${contextPath}/statistics/findImpStat.do?searchYear=2015&gubun=ALL",refresh_chart);
}
function refresh_chart(){
	lineChart.clearAll();
	lineChart.parse(myGrid,"dhtmlxgrid");
};

function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){ dhxTabbar.setSizes(false); },200);}
function doOnGridLoaded(){setTimeout(function() {dhxLayout.cells("a").progressOff();}, 100);}
function doBeforeGridLoad(){dhxLayout.cells("a").progressOn();}
</script>
</head>
<body>
	<div class="title_box">
		<h3><spring:message code='menu.statistics.article'/></h3>
	</div>
	<div class="contents_box">
		<div id="my_tabbar" style="width:100%;"></div>
	</div>
</body>
</html>