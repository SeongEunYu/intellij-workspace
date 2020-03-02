<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@include file="../../pageInit.jsp" %>
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
	// myGrid.setHeader(",번호,관리번호,논문명,저널명,출판년도,원문공개여부,연계상태",null,grid_head_center_bold);
	myGrid.setHeader("번호,관리번호,논문명,저널명,출판년도,원문공개여부,연계상태",null,grid_head_center_bold);
	// myGrid.setColumnIds("chkbox,no,articleId,orgLangPprNm,scjnlNm,pblcYm,isOpenFiles,koaFlag");
	myGrid.setColumnIds("articleId,orgLangPprNm,scjnlNm,pblcYm,isOpenFiles,koaFlag");
	// myGrid.setColumnIds("no,articleId,orgLangPprNm,scjnlNm,pblcYm,isOpenFiles,koaFlag");
	myGrid.setInitWidths("50,80,*,240,80,80,80");
	myGrid.setColAlign("center,center,left,left,center,center,center");
	myGrid.setColTypes("ro,ro,ro,ro,ro,ro,ro");
	myGrid.setColSorting("na,na,na,na,na,na");
	myGrid.setImagePath("${dhtmlXImagePath}");
	myGrid.attachEvent("onBeforeSorting",myGrid_onBeforeSorting);
	myGrid.attachEvent("onXLS", doBeforeGridLoad);
	myGrid.attachEvent("onXLE", doOnGridLoaded);
	myGrid.enableMultiselect(true);
    myGrid.enablePaging(true,100,10,"pagingArea",true,"infoArea");
    myGrid.setPagingSkin("${dhtmlXPagingSkin}");
    myGrid.enableColSpan(true);
	myGrid.init();
	myGrid.loadXML("${contextPath}/reposCntc/findReposTargetList.do?perGubun=article");

});


function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){ dhxLayout.setSizes(false); },200);}
function doOnGridLoaded(){ setTimeout(function() {dhxLayout.cells("a").progressOff();}, 100);}
function doBeforeGridLoad(){dhxLayout.cells("a").progressOn();}

function myGrid_onBeforeSorting(ind, gridObj, direct) {
	var indObj = '';
	if 		(ind == 2) indObj = 'org_lang_ppr_nm';
	else if (ind == 3) indObj = 'scjnl_nm';
	else if (ind == 4) indObj = 'pblc_ym';
	else if (ind == 5) indObj = 'is_open_files';
	else if (ind == 6) indObj = 'koa_flag';
	else return false;
	myGrid.clearAndLoad("${contextPath}/openfile/openGetList.do?" + $('#formArea').serialize() + "&orderby=" + indObj + "&direct=" + direct);
	myGrid.setSortImgState(true, ind, direct);
}

function isOpen(updateFlag){
	// because of paging. Get start and end index of rows in this page is first.
	var strIndex  = (myGrid.currentPage-1) * myGrid.rowsBufferOutSize;
	var endIndex  = ((myGrid.currentPage) * myGrid.rowsBufferOutSize)-1;
	var parameter = "";
	endIndex = endIndex<myGrid.getRowsNum() ? endIndex: myGrid.getRowsNum()-1;
	var cIndex_chkbox = myGrid.getColIndexById("chkbox");
	for (var i=strIndex; i<=endIndex; i++){ 		// here i - index of the row in the grid
		var rId = myGrid.getRowId(i); // get row id by its index
		var str = myGrid.cells(rId,cIndex_chkbox).getValue();
		// Grid의 check Box의 값이 체크 되어 있으면 그 값은 1 아니면 0이 된다.
		if (str=="1") parameter += rId+"_";
	}
	if(parameter == "") {
		dhtmlx.alert({type:"alert-warning",text:"체크된 항목이 없습니다.",callback:function(){}});
		return;
	}else {

		$('#parameter').val('').val(parameter);
		$('#updateFlag').val('').val(updateFlag);
		$.post('${contextPath}/reposCntc/updateReposTarget.do', $('#formArea').serializeArray(), null, 'json').done(function(data){
			dhtmlx.alert({text:"원문처리 완료하였습니다.",callback:function(){
				myGrid_load();
			}});
		});
		/*
		$('#formArea').attr('action', "${contextPath}/reposCntc/updateReposTarget.do");
		$('#formArea').attr('method', "POST");
		$('#formArea').append($('<input type="hidden" name="parameter" value="'+parameter+'" />'))
		$('#formArea').append($('<input type="hidden" name="updateFlag" value="'+updateFlag+'" />'))
		$('#formArea').append($('<input type="hidden" name="pMenuId" value="${param.pMenuId}" />'))
		$('#formArea').append($('<input type="hidden" name="navBody" value="${param.navBody}" />'))
		$('#formArea').submit();
		*/
	}
}
function myGrid_load() {
	myGrid.clearAndLoad("${contextPath}/reposCntc/findReposTargetList.do?" + $('#formArea').serialize());
}
</script>
</head>
<body>

	<div class="title_box" >
		<h3>IR 연계</h3>
	</div>

	<!-- Main Content -->
	<div class="contents_box">
	<form id="formArea" onsubmit="return false;">
		<input type="hidden" name="parameter" id="parameter">
		<input type="hidden" name="updateFlag" id="updateFlag">
		<table class="view_tbl mgb_10">
			<colgroup>
				<col style="width: 15% "/>
				<col />
				<col style="width: 50px;">
			</colgroup>
			<tbody>
			<tr>
				<th width="13%">성과 구분</th>
				<td >
					<input type="radio" name="perGubun" id="perGubun1" onclick="myGrid_load();" value="article" class="radio" checked="checked"/>
					<label for="perGubun1" class="radio_label">논문</label>
					<%--<input type="radio" name="perGubun" id="perGubun2" onclick="myGrid_load();" value="conference" class="radio" />
					<label for="perGubun2" class="radio_label">학술대회</label>--%>
				</td>
				<td rowspan="4" class="option_search_td" onclick="javascript: myGrid_load();"><em>search</em></td>
			</tr>
			<tr>
				<th >연계상태</th>
				<td >
					<input type="radio" name="koaFlag" id="gubun1" onclick="myGrid_load();" value="" class="radio" checked="checked"/>
					<label for="gubun1" class="radio_label">전체</label>
					<input type="radio" name="koaFlag" id="gubun2" onclick="myGrid_load();" value="U" class="radio" />
					<label for="gubun2" class="radio_label">대기</label>
					<input type="radio" name="koaFlag" id="gubun3" onclick="myGrid_load();" value="Y" class="radio" />
					<label for="gubun3" class="radio_label">완료</label>
					<input type="radio" name="koaFlag" id="gubun4" onclick="myGrid_load();" value="X" class="radio" />
					<label for="gubun4" class="radio_label">제외</label>
				</td>
			</tr>
			<tr>
				<th>원문공개 구분</th>
				<td>
					<input type="radio" name="pubIrOpen" id="is_open1" onclick="myGrid_load();" value="" class="radio" checked="checked"/>
					<label for="is_open1" class="radio_label">전체</label>
					<input type="radio" name="pubIrOpen" id="is_open2" onclick="myGrid_load();" value="Y" class="radio" />
					<label for="is_open2" class="radio_label">공개</label>
					<input type="radio" name="pubIrOpen" id="is_open3" onclick="myGrid_load();" value="N" class="radio" />
					<label for="is_open3" class="radio_label">비공개</label>
					<input type="radio" name="pubIrOpen" id="is_open4" onclick="myGrid_load();" value="X" class="radio" />
					<label for="is_open4" class="radio_label">없음</label>
				</td>
			</tr>
			<tr>
				<th>
					<select name="type" id="type" class="select1" style="width: 90%;">
						<option value="ppr" ${param.type eq 'ppr' ? 'selected="selected"':'' }>논문명</option>
						<option value="scjnl" ${param.type eq 'scjnl' ? 'selected="selected"':'' }>저널명</option>
						<option value="item_id" ${param.type eq 'item_id' ? 'selected="selected"':'' }>관리번호</option>
					</select>
				</th>
				<td>
					<input type="text" name="keyword" class="input2"  style="width: 100%;" onkeyup="javascript:if(event.keyCode == 13)myGrid_load();" />
				</td>
			</tr>
			</tbody>
		</table>
	</form>
		<%--<div class="list_bt_area">
			<div class="list_set">
				<ul>
					<li><a href="javascript:void(0);" onclick="javascript:isOpen('Y');" class="list_icon14">원문공개처리</a></li>
					<li><a href="javascript:void(0);" onclick="javascript:isOpen('N');" class="list_icon14">원문미공개처리</a></li>
				</ul>
			</div>
		</div>--%>
		<div id="mainLayout" style="position: relative; width: 100%;height: 100%;"></div>
		<script type="text/javascript">setMainLayoutHeight($('#mainLayout'));</script>
		<div id="pagingObj" style="z-index: 1; height: 60px; margin-top: 5px;" >
			<div id="pagingArea" style="z-index: 1;"></div>
		</div>
	</div>
</body>
</html>