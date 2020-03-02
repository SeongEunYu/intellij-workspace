<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@include file="../../pageInit.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript" src="${contextPath}/js/mainLayout.js"></script>
<script type="text/javascript">
var dhxLayout, myGrid, myDp, t;

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
	myGrid.setHeader("S,WOS_ID,SCOPUS_ID,KCI_ID,직번,이름,이름(영),학과,논문제목,학술지명,등재년,게재년,게재월,게재권,게재호,시작,끝,DOI,ISSN,출판사,출판국,언어,저자명,SE,SC,SS,AH,SP,KC,ET,단,주,교,공,문헌유형,교신주소,Email,&nbsp;", null, grid_head_center_bold );
    myGrid.setColumnIds("status,wosIdntfcNo,scpIdntfcNo,kciIdntfcNo,perno,nameKor,nameEng,dept,articleTtl,plscmpnNm,ry,pblcateYear,pblcateDate,vlm,issue,beginPage,endPage,doi,issn,pblshrNm,pblshrCity,lang,authrNm,isscie,issci,isssci,isahci,isscopus,iskci,isetc,autone,autmain,autcr,autco,docType,RpntAdres,emailAdres,NB");
	myGrid.setInitWidths("30,120,120,120,60,60,80,100,120,100,60,60,60,60,60,60,50,50,50,100,60,50,100,40,40,40,40,40,40,40,40,40,40,40,100,200,150,20");
	myGrid.setColTypes("ed,ro,ro,ro,ed,ed,ed,co,ed,ed,ed,ed,ed,ed,ed,ed,ed,ed,ed,ed,ed,ed,ed,ch,ch,ch,ch,ch,ch,ch,ch,ch,ch,ch,ed,ed,ed,ro");
	myGrid.setColSorting("na,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,na");
	myGrid.setColAlign("center,center,center,center,center,center,left,left,left,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center");
	myGrid.attachEvent("onBeforeSorting",myGrid_onBeforeSorting);
	myGrid.attachEvent("onXLS", doBeforeGridLoad);
	myGrid.attachEvent("onXLE", doOnGridLoaded);
	myGrid.enableMultiselect(true);
    myGrid.enablePaging(true,100,10,"pagingArea",true,"infoArea");
    myGrid.setPagingSkin("${dhtmlXPagingSkin}");
    myGrid.enableColSpan(true);
	myGrid.init();
	myGrid.splitAt(5);
	myDp = new dataProcessor("${contextPath}/revision/intResultCUD.do");
	myDp.init(myGrid);
	myDp.setTransactionMode("POST",false);
	myDp.setUpdateMode("off");
	myDp.enableDataNames(true);
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
	var url = "${contextPath}/revision/findRevisionList.do?"+"maskRevise="+maskRevise+"&orgName="+encodeURIComponent("<%=request.getSession().getAttribute("inst")%>");
	return url;
}

function myGrid_deleteSelectedItem(){
	if(myGrid.getSelectedRowId() != null){
		dhtmlx.confirm({
			ok:"Yes", cancel:"No",
			text:"삭제 하시겠습니까?",
			callback:function(result){
				if(result == true){
					myGrid.deleteSelectedItem();
				}
			}
		});
	}else{
		dhtmlx.alert({type:"alert-warning",text:"먼저 삭제할 정보를 선택하십시요.<p/>Ctrl 혹은 Shift 키를 이용하여 여러 건을 선택할 수 있습니다.",callback:function(){}})
	}
}

function saveChanges(){
	dhtmlx.confirm({
		ok:"Yes", cancel:"No",
		text:"저장 하시겠습니까?",
		callback:function(result){
			if(result == true){
				myDp.sendData();
			}
		}
	});
}

function myGrid_changeStatus(strStatus){
	var msg = "";
	if(strStatus == 'R') msg = '보정완료(R)';
	if(myGrid.getSelectedRowId() != null){
		dhtmlx.confirm({
			title:"보정상태 변경",
			ok:"Yes", cancel:"No",
			text:"Change status to "+msg+"?",
			callback:function(result){
				if(result == true){
					var selectedId = myGrid.getSelectedRowId();
					var str = selectedId.split(','); // regular expression 이 아님에 주의할 것
					for (i=0;i<str.length;i++) {
						var rowIndex = myGrid.getRowIndex(str[i]);
						myGrid.cellByIndex(rowIndex,0).setValue(strStatus); // change cell value
						myDp.setUpdated(myGrid.getRowId(rowIndex),true); // change update status to false
					}
					myDp.sendData();
				}
			}
		});
	}else{
		dhtmlx.alert({type:"alert-warning",text:"먼저 상태를 변경할 정보를 선택하십시요.<p/>Ctrl 혹은 Shift 키를 이용하여 여러 건을 선택할 수 있습니다.",callback:function(){}})
	}
}

function myGrid_toExcel(){
	if(confirm("엑셀파일로 저장 하시겠습니까?")){
		var idList = myGrid.getSelectedId();
		var maskRevise =  $(':radio[name="maskRevise"]:checked').val();
		window.open("${contextPath}/revision/intResultToExcel.do?maskRevise="+maskRevise+"&idList="+idList, "report_excel", "height=600, width=800, scrollbars=yes, resizable=yes, menubar=yes");
	}
}

/*
function myGrid_toExcel(){
	var mask_revise = com_getSelectedRadioValueByName("mask_revise");
	if (mask_revise=="U" || mask_revise=="R") {
			var url = conPath+"/per/intResultToExcel.do?mask_revise="+mask_revise;
			new Ajax.Request(url, {
				onComplete : function(response) {
				}
			});
	} else {
		alert ("보정전(U) 혹은 보정완료(R) 건들에 대해서만 반출할 수 있습니다.");
	}
}
*/
function myGrid_toRIMS(){
	var idList = myGrid.getSelectedId();
	var mask_revise = $(':radio[name="maskRevise"]:checked').val();
	if (mask_revise=="U" || mask_revise=="R") {
		new Ajax.Request("${contextPath}/revision/intResultToRims.do?maskRevise="+maskRevise+"&idList="+idList, {
			onComplete : function(response) {
				var xmlData = response.responseXML.documentElement;
				var code = xmlData.getElementsByTagName("code")[0].firstChild.nodeValue;
				var msg = xmlData.getElementsByTagName("msg")[0].firstChild.nodeValue;
				if (code == "001"){
					myGrid_load();
					alert(msg);
				}
			}
		});
		//window.open( conPath+"/per/intResultToRims.do?mask_revise="+mask_revise+"&idList="+idList, "report_excel", "height=300, width=400, scrollbars=yes, resizable=yes, menubar=yes");
	} else {
		alert ("보정전(U) 혹은 보정완료(R) 건들에 대해서만 반출할 수 있습니다.");
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
		<h3><spring:message code='menu.article.revision'/></h3>
	</div>
	<!-- Main Content -->
	<div class="contents_box">
		<!-- START 테이블 1 -->
		<table class="view_tbl mgb_10">
			<colgroup>
				<col style="width: 15% "/>
				<col />
				<col style="width: 50px;">
			</colgroup>
			<tbody>
			<tr>
				<th>보정상태</th>
				<td >
					<input type="radio"  name="maskRevise" value="" class="radio" onchange="javascript: myGrid_load();"/>
						<label for="전체" class="radio_label">전체</label>
					<input type="radio"  name="maskRevise" value="U" class="radio" checked="checked" onchange="javascript: myGrid_load();"/>
						<label for="보정전(U)" class="radio_label">보정전(U)</label>
					<input type="radio"  name="maskRevise" value="R" class="radio" onchange="javascript: myGrid_load();"/>
						<label for="보정완료(R)" class="radio_label">보정완료(R)</label>
					<input type="radio"  name="maskRevise" value="E" class="radio" onchange="javascript: myGrid_load();"/>
						<label for="반출완료(E)" class="radio_label">반출완료(E)</label>
				</td>
				<td class="option_search_td" onclick="javascript: myGrid_load();"><em>search</em></td>
			</tr>
			</tbody>
		</table>
		<div class="list_bt_area">
			<div class="list_set">
				<ul>
					<li><a href="#" onclick="javascript:myGrid_changeStatus('R');" class="list_icon14">보정완료처리</a></li>
					<li><a href="#" onclick="javascript:saveChanges();" class="list_icon02">저장</a></li>
					<li><a href="#" onclick="javascript:myGrid_deleteSelectedItem();" class="list_icon22">삭제</a></li>
				</ul>
			</div>
		</div>
		<!-- END 테이블 1 -->
		<div id="mainLayout" style="position: relative; width: 100%;height: 100%;"></div>
		<script type="text/javascript">setMainLayoutHeight($('#mainLayout'));</script>
		<div id="pagingObj" style="z-index: 1; height: 60px; margin-top: 5px;" >
			<div id="pagingArea" style="z-index: 1;"></div>
		</div>
	</div>
</body>
</html>