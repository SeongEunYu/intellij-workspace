<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../pageInit.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Check Duplicate Article</title>
<script type="text/javascript" src="${contextPath}/js/mainLayout.js"></script>
<script type="text/javascript">
var dhxLayout, myGrid, myDP, t;

$(document).ready(function(){
	if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
	else  window.addEventListener("resize",resizeLayout, false);
	//set layout
	dhxLayout = new dhtmlXLayoutObject("mainLayout","1C");
	dhxLayout.cells("a").hideHeader();
	dhxLayout.setSizes(false);
	//attach myGrid
	myGrid = dhxLayout.cells("a").attachGrid();
	myGrid.setImagePath("${dhtmlXImagePath}");
	myGrid.setHeader("C,Identifier,Title,Source,ISSN,Volumn,Begin Page,Dup. Identifier", null,grid_head_center_bold );
	myGrid.setColumnIds("C,sourcIdntfcNo,articleTtl,plscmpnNm,issn,vlm,beginPage,dplctSourcIdntfcNo");
	myGrid.setInitWidths("40,110,*,170,100,70,100,130");
	myGrid.setColAlign("center,center,left,left,center,center,center,center")
	myGrid.setColSorting("na,str,server,server,str,na,na,na");
	myGrid.setColTypes("ch,ed,ro,ro,ro,ro,ro,ro");
	myGrid.setColumnColor("#FFFFFF,#FFFFFF,#EEFFEE,#EEFFEE,#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF");
	myGrid.attachEvent("onBeforeSorting",myGrid_onBeforeSorting);
	myGrid.attachEvent("onXLS", doBeforeGridLoad);
	myGrid.attachEvent("onPaging",changeRowColor);
	myGrid.attachEvent("onXLE", checkGridEmpty);
    myGrid.enablePaging(true,100,10,"pagingArea",true);
    myGrid.setPagingSkin("${dhtmlXPagingSkin}");
    myGrid.enableColSpan(true);
    myGrid.init();
	myDP = new dataProcessor("${contextPath}/dplct/dplctArticleUpdate.do");
	myDP.init(myGrid);
	myDP.setTransactionMode("POST",false);
	myDP.setUpdateMode("off");
	myDP.enableDataNames(true);
	myGrid_load();

});

function myGrid_load(){
	doBeforeGridLoad();
	var url = getGridRequestURL();
	myGrid.clearAndLoad(url, changeRowColor);
}

function checkGridEmpty(){
	if (myGrid.getRowsNum()==0)  dhtmlx.alert({type:"alert-warning",text:"중복체크 대상 자료가 없습니다.",callback:function(){}});
}

function changeRowColor(){
	var strIndex = (myGrid.currentPage-1) * myGrid.rowsBufferOutSize;
	var endIndex = ((myGrid.currentPage) * myGrid.rowsBufferOutSize)-1;
	endIndex = endIndex<myGrid.getRowsNum() ? endIndex: myGrid.getRowsNum()-1;
	for (var i=strIndex; i<=endIndex; i++){ // here i - index of the row in the grid
		var rId = myGrid.getRowId(i); // get row id by its index
		if(typeof rId != 'undefined'){
			var str = rId.split('|');  // regular expression 이 아님에 주의할 것
			ut = str[0];
			gubun = str[1];
			if (gubun=="W"){ myGrid.setRowColor(rId, "E0FFE0");	}
			else if (gubun=="S"){ myGrid.setRowColor(rId, "DDDDFF");	}
			else if (gubun=="K"){ myGrid.setRowColor(rId, "FFFFC8");	}
		}
	}
	doOnGridLoaded();
}

function myGrid_onBeforeSorting(ind,type,direct){
	var url = getGridRequestURL();
	myGrid.clearAndLoad(url+"&orderby="+(myGrid.getColumnId(ind))+"&direct="+direct);
	myGrid.setSortImgState(true,ind,direct);
	return false;
}

function getGridRequestURL(){
	var maskMatch			= $(':radio[name="maskMatch"]:checked').val();
	var maskPubyear		= encodeURIComponent( document.getElementById("maskPubyear").value );
	var maskTitle			= encodeURIComponent( document.getElementById("maskTitle").value );
	var url = "${contextPath}/dplct/findDplctArticleList.do?"+"maskMatch="+maskMatch+"&maskPubyear="+maskPubyear+"&maskTitle="+maskTitle+"&orgName="+encodeURIComponent("<%=request.getSession().getAttribute("inst")%>");
	return url;
}

function saveDuplicate(){
	// because of paging. Get start and end index of rows in this page is first.
	var strIndex = (myGrid.currentPage-1) * myGrid.rowsBufferOutSize;
	var endIndex = ((myGrid.currentPage) * myGrid.rowsBufferOutSize)-1;
	endIndex = endIndex<myGrid.getRowsNum() ? endIndex: myGrid.getRowsNum()-1;

	// check 2 items checked and one is WOS and the other is SCOPUS
	var chkstr = "";
	for (var i=strIndex; i<=endIndex; i++){ 		// here i - index of the row in the grid
		if (myGrid.cellByIndex(i,0).getValue()=="1" ){ //체크된 아이템만을 대상으로 함
			var rId	= myGrid.getRowId(i); // get row id by its index
			var str = rId.split('|'); // regular expression 이 아님에 주의할 것
			ut		= str[0];
			gubun	= str[1];
			chkstr += gubun;
			if (gubun=="W") {
				var rowIndexWOS = i;
				var utWOS		= ut;
			}
			if (gubun=="S") {
				var rowIndexSCP = i;
				var utSCP		= ut;
			}
			myGrid.cellByIndex(i,0).setValue("0"); // uncheck items
			myDP.setUpdated(myGrid.getRowId(i),false); // change update status to false
		}
	}

	if (chkstr=="WS" || chkstr=="SW") {
		myGrid.cellByIndex(rowIndexWOS, 7).setValue(utSCP);
		myGrid.cellByIndex(rowIndexSCP, 7).setValue(utWOS);
		myDP.setUpdated(myGrid.getRowId(rowIndexWOS),true); // change update status to true
		myDP.setUpdated(myGrid.getRowId(rowIndexSCP),true); // change update status to true
		myDP.sendData();
	} else {
		dhtmlx.alert({type:"alert-warning",text:"중복된 두건(WOS 1건, SCOPUS 1건)을 체크한 후 저장버튼을 클릭하십시요.",callback:function(){}});
	}
}

function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){ dhxLayout.setSizes(false); },200);}
function doOnGridLoaded(){setTimeout(function() {dhxLayout.cells("a").progressOff();}, 100);}
function doBeforeGridLoad(){dhxLayout.cells("a").progressOn();}

</script>


</head>
<body>
	<!-- Page Title -->
	<div class="title_box">
		<h3><spring:message code='menu.article.dplct'/></h3>
	</div>
	<!-- Main Content -->
	<div class="contents_box">
		<!-- START 테이블 1 -->
		<table class="view_tbl mgb_10">
			<colgroup>
				<col style="width:13%"/>
				<col style="width:35%"/>
				<col style="width:13%"/>
				<col />
				<col style="width:50px;"/>
			</colgroup>
			<tbody>
			<tr>
				<th>구분</th>
				<td class="borderRight">
					<input type="radio" name="maskMatch" value="ALL" class="radio" onchange="javascript:myGrid_load();">
						<label for="All" class="radio_label">All</label>
					<input type="radio" name="maskMatch" value="NOTYET" checked="checked" class="radio" onchange="javascript:myGrid_load();">
						<label for="Not Matched Only" class="radio_label">Not Matched Only</label>
				</td>
				<th>연도</th>
				<td>
					<input type="text" style="width:70px;" class="input2" id="maskPubyear" onkeydown="javascript:if (event.keyCode == 13) myGrid_load();">
				</td>
				<td rowspan="2" class="option_search_td" onclick="javascript: myGrid_load();"><em>search</em></td>
			</tr>
			<tr>
				<th>제목</th>
				<td colspan="3" >
					<input type="text" style="width:100%;" class="input2" id="maskTitle" onkeydown="javascript:if (event.keyCode == 13) myGrid_load();">
				</td>
			</tr>
			</tbody>
		</table>

		<div class="list_bt_area">
			<div class="list_set">
				<ul>
					<li><a href="#" onclick="javascript:saveDuplicate();" class="list_icon02">저장</a></li>
				</ul>
			</div>
		</div>

		<!-- end 테이블 1 -->
		<div id="mainLayout" style="position: relative; width: 100%;height: 100%;"></div>
		<script type="text/javascript">setMainLayoutHeight($('#mainLayout'));</script>
		<div id="pagingObj" style="z-index: 1; height: 40px; margin-top: 5px;" >
			<div id="pagingArea" style="z-index: 1;"></div>
		</div>
	</div>
</body>
</html>