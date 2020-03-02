<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../pageInit.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Article Statistics</title>
<script type="text/javascript">
var dhxTabbar, dhxLayout, myGrid, myToolbar, myForm, pubLayout, pubGrid, lineChart, t;

$(document).ready(function(){
	$('#my_tabbar').css('height', ($(document).height() - 130) + "px");

	if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
	else  window.addEventListener("resize",resizeLayout, false);

	dhxTabbar = new dhtmlXTabBar("my_tabbar");
	dhxTabbar.addTab("a1","기본통계",null,null,true);
	//dhxTabbar.addTab("a2","상세통계");
	//dhxTabbar.addTab("a3","학과별");
	//dhxTabbar.addTab("a4","개인별");

	loadTabbarCellsA1();
	//loadTabbarCellsA2();
});

function loadTabbarCellsA1(){ // 기본통계
	pubLayout = dhxTabbar.cells("a1").attachLayout({
		pattern:"1C",
		cells:[
		      	{id:"a", text:"By Techtrans Year", header:"hidden"}
		      ]
	});

	myToolbar = pubLayout.cells("a").attachToolbar({
		icons_path :"${dhtmlXImagePath}/icons_${sysConf['dhtmlx.skin']}/"
	});
	myToolbar.addButton("excel",1,"Export","excel.png","excel_dis.png");
	myToolbar.setIconSize(18);
	myToolbar.setAlign("right");


	pubGrid =  pubLayout.cells('a').attachGrid();
	pubGrid.setImagePath("${dhtmlXImagePath}");
	pubGrid.setHeader("이전년도,특허양도,#cspan,전용실시,#cspan,통상실시,#cspan,노하우,#cspan,자문,#cspan,합계,#cspan", null, grid_head_center_bold);
	pubGrid.attachHeader("#rspan,이전금액,건수,이전금액,건수,이전금액,건수,이전금액,건수,이전금액,건수,이전금액,건수",grid_head_center_bold);
	pubGrid.setInitWidths("*,80,80,80,80,80,80,80,80,80,80,80,80");
	pubGrid.setColAlign("center,center,center,center,center,center,center,center,center,center,center,center,center,center");
	pubGrid.setColTypes("ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro");
	pubGrid.setColSorting("na,na,na,na,na,na,na,na,na,na,na,na,na");
	pubGrid.setEditable(false);
	pubGrid.enableColSpan(true);
	pubGrid.init();
	pubGrid.clearAndLoad("${contextPath}/statistics/findTechtransStatsByTransyear.do");

	myToolbar.attachEvent("onClick", function(id){
	    if(id == 'excel')
	    {
	    	pubGrid.toExcel('${contextPath}/servlet/xlsGenerate.do?file_name=TechTransStats.xls');
	    }
	});
}

var conf = {t0:"-",t1:"-",t2:"-",t3:"-"};
var formData =[
              	{type:"setting", position:"label-right", labelWidth: 140, inputWidth:150, offsetLeft:25, offsetTop:20},
              	{type:"fieldset", label:"통계유형", inputWidth:350,  offsetLeft: 20, list:[
						{type:"label", label:"단위선택"},
						{type:"block", width:"auto", list:[
							{type:"radio", name:"statsGubun", value:"person",label:"저자단위", checked:true},
							{type:"newcolumn"},
							{type:"radio", name:"statsGubun", value:"article",label:"논문단위", offsetLeft: 10}
                        ]},
						{type:"label", label:"출판연도"},
						{type:"block", width:"auto", list:[
							{type:"input", name:"sttDate", value:"",label:"", inputWidth:120},
							{type:"newcolumn"},
							{type:"label", label:"~"},
							{type:"newcolumn"},
							{type:"input", name:"endDate", value:"",label:"", inputWidth:120}
                        ]},
                        {type:"label", label:"통계구분"},
                        {type:"block", width:"auto", list:[
	                        {type: "select", name:"jnlGubun", options:[
	                                   					{text: "년도별통계", value: "byYear"},
	                                   					{text: "개인별통계", value: "byPerson"},
	                                   					{text: "학과별(구분없음)통계", value: "byDept"},
	                                   					{text: "학과별(연도별구분)통계", value: "byDeptYear"},
	                                   					{text: "학과별(재직여부구분)통계", value: "byDeptHldof"}
	                        						  ]}
                        ]}
              	  ]},
              	{type:"newcolumn"},
              	{type:"fieldset", label:"통계대상", inputWidth:"auto",  offsetLeft: 20, list:[
					{type:"label", label:"연구자 지정"},
					{type:"block", width:"auto", list:[
						{type:"label", label:"사번/이름", labelWidth:100},
						{type:"newcolumn"},
						{type:"input", name:"prtcpntId", value:"",label:"", inputWidth:200, offsetLeft: 7}
					]},
					{type:"block", width:"auto", list:[
						{type:"label", label:"대상자선택", labelWidth:100},
						{type:"newcolumn"},
						{type:"select", name:"sourceGubun", value:"",label:"",  offsetLeft: 7, options:[
																									{text: "Rims 관리대상", value: "rimsUser"}
	  						                                                                      ]}
					]},
					{type:"label", label:"연구자 상세 구분",offsetTop:35},
					{type:"block", width:"auto", list:[
						{type:"label", label:"신분", labelWidth:100},
						{type:"newcolumn"},
						{type:"radio", name:"gubun", value:"ALL",label:"전체", position:"label-right"},
						{type:"newcolumn"},
						{type:"radio", name:"gubun", value:"M",label:"전임", position:"label-right", offsetLeft: 7, checked: true},
						{type:"newcolumn"},
						{type:"radio", name:"gubun", value:"U",label:"비전임", position:"label-right", offsetLeft: 7},
						{type:"newcolumn"},
						{type:"radio", name:"gubun", value:"S",label:"학생", position:"label-right", offsetLeft: 7},
						{type:"newcolumn"},
						{type:"radio", name:"gubun", value:"E",label:"기타", position:"label-right", offsetLeft: 7}
					]},
					{type:"block", width:"auto", list:[
						{type:"label", label:"상세신분", labelWidth:100},
						{type:"newcolumn"},
						{type:"radio", name:"grade1", value:"ALL",label:"전체", position:"label-right", checked:true},
						{type:"newcolumn"},
						{type:"radio", name:"grade1", value:"교수",label:"교수", position:"label-right", offsetLeft: 7},
						{type:"newcolumn"},
						{type:"radio", name:"grade1", value:"부교수",label:"부교수", position:"label-right", offsetLeft: 7},
						{type:"newcolumn"},
						{type:"radio", name:"grade1", value:"조교수",label:"조교수", position:"label-right", offsetLeft: 7}
					]},
					{type:"block", width:"auto", list:[
						{type:"label", label:"재직여부", labelWidth:100},
						{type:"newcolumn"},
						{type:"radio", name:"hldofYn", value:"ALL",label:"전체", position:"label-right", checked: true},
						{type:"newcolumn"},
						{type:"radio", name:"hldofYn", value:"1",label:"재직", position:"label-right", offsetLeft: 7},
						{type:"newcolumn"},
						{type:"radio", name:"hldofYn", value:"2",label:"퇴직", position:"label-right", offsetLeft: 7}
					]},
					{type:"block", width:"auto", list:[
						{type:"label", label:"내,외국인", labelWidth:100},
						{type:"newcolumn"},
						{type:"radio", name:"ntntCd", value:"ALL",label:"전체", position:"label-right", checked:true},
						{type:"newcolumn"},
						{type:"radio", name:"ntntCd", value:"국내",label:"내국인", position:"label-right", offsetLeft: 7},
						{type:"newcolumn"},
						{type:"radio", name:"ntntCd", value:"국외",label:"외국인", position:"label-right", offsetLeft: 7}
					]},
					{type:"block", width:"auto", list:[
						{type:"label", label:"성별", labelWidth:100},
						{type:"newcolumn"},
						{type:"radio", name:"sexDvsCd", value:"ALL",label:"전체", position:"label-right", checked:true},
						{type:"newcolumn"},
						{type:"radio", name:"sexDvsCd", value:"1",label:"남", position:"label-right", offsetLeft: 7},
						{type:"newcolumn"},
						{type:"radio", name:"sexDvsCd", value:"2",label:"여", position:"label-right", offsetLeft: 7}
					]},
					{type:"block", width:"auto", list:[
						{type:"label", label:"학과", labelWidth:100},
						{type:"newcolumn"},
						{type:"select", name:"deptKor", value:"",label:"",  offsetLeft: 7, options:[
																											{text: "전체", value: ""}
			  						                                                                 ]}
					]},
					{type:"label", label:"논문 상세 구분",offsetTop:35},
					{type:"block", width:"auto", list:[
   						{type:"label", label:"기관승인여부", labelWidth:100},
						{type:"newcolumn"},
						{type:"radio", name:"apprDvsCd", value:"ALL",label:"전체", position:"label-right", checked:true},
						{type:"newcolumn"},
						{type:"radio", name:"apprDvsCd", value:"3",label:"승인완료", position:"label-right", offsetLeft: 7},
						{type:"newcolumn"},
						{type:"radio", name:"apprDvsCd", value:"1",label:"미승인", position:"label-right", offsetLeft: 7},
						{type:"newcolumn"},
						{type:"radio", name:"apprDvsCd", value:"2",label:"보류", position:"label-right", offsetLeft: 7},
						{type:"newcolumn"},
						{type:"radio", name:"apprDvsCd", value:"4",label:"반려", position:"label-right", offsetLeft: 7}
					]},
					{type:"block", width:"auto", list:[
						{type:"label", label:"검증구분", labelWidth:100},
						{type:"newcolumn"},
						{type:"radio", name:"vrfcDvsCd", value:"ALL",label:"전체", position:"label-right", checked:true},
						{type:"newcolumn"},
						{type:"radio", name:"vrfcDvsCd", value:"2",label:"검증완료", position:"label-right", offsetLeft: 7},
						{type:"newcolumn"},
						{type:"radio", name:"vrfcDvsCd", value:"1",label:"미검증", position:"label-right", offsetLeft: 7},
						{type:"newcolumn"},
						{type:"radio", name:"vrfcDvsCd", value:"3",label:"불가", position:"label-right", offsetLeft: 7}
					]},
					{type:"block", width:"auto", list:[
   						{type:"label", label:"연구자참여구분", labelWidth:100},
						{type:"newcolumn"},
						{type:"radio", name:"tpiDvsCd", value:"ALL",label:"전체", position:"label-right", checked:true},
						{type:"newcolumn"},
						{type:"radio", name:"tpiDvsCd", value:"1",label:"단독", position:"label-right", offsetLeft: 7},
						{type:"newcolumn"},
						{type:"radio", name:"tpiDvsCd", value:"3",label:"교신저자", position:"label-right", offsetLeft: 7},
						{type:"newcolumn"},
						{type:"radio", name:"tpiDvsCd", value:"2",label:"주저자(제1저자)", position:"label-right", offsetLeft: 7},
						{type:"newcolumn"},
						{type:"radio", name:"tpiDvsCd", value:"4",label:"참여자", position:"label-right", offsetLeft: 7}
					]},
					{type:"block", width:"auto", list:[
						{type:"label", label:"재직전,후", labelWidth:100},
						{type:"newcolumn"},
						{type:"radio", name:"enterGubun", value:"ALL",label:"전체", position:"label-right", checked:true},
						{type:"newcolumn"},
						{type:"radio", name:"enterGubun", value:"B",label:"재직전", position:"label-right", offsetLeft: 7},
						{type:"newcolumn"},
						{type:"radio", name:"enterGubun", value:"A",label:"재직후", position:"label-right", offsetLeft: 7}
					]}
              	]},
              	{type:"newcolumn"}

              ];

function loadTabbarCellsA2(){ // 상세통계
	dhxLayout = dhxTabbar.cells("a2").attachLayout({
		pattern:"1C",
		cells:[
		      	{id:"a", text:"form"}
		      ]
	});
	dhxLayout.cells("a").hideHeader();
	dhxLayout.setSizes(false);

	myToolbar = dhxLayout.cells("a").attachToolbar({
		icons_path :"${dhtmlXImagePath}/icons_${sysConf['dhtmlx.skin']}/"
	});
	myToolbar.addButton("popup",0,"통계보기","popup.png","popup_dis.png");
	myToolbar.addSeparator("sep1", 1);
	myToolbar.addButton("excel",2,"상세목록","excel.png","excel_dis.png");
	myToolbar.setIconSize(18);
	myToolbar.setAlign("right");

	myForm = dhxLayout.cells("a").attachForm();
	myForm.loadStruct(formData, "json");

}

function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){ dhxTabbar.setSizes(false); },200);}
function doOnGridLoaded(){setTimeout(function() {dhxLayout.cells("a").progressOff();}, 100);}
function doBeforeGridLoad(){dhxLayout.cells("a").progressOn();}
</script>
</head>
<body>
	<div class="title_box">
		<h3><spring:message code='menu.statistics.techtrans'/></h3>
	</div>
	<div class="contents_box">
		<div id="my_tabbar" style="width:100%;"></div>
	</div>
</body>
</html>