<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../pageInit.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>RID Management</title>
<script type="text/javascript" src="${contextPath}/js/mainLayout.js"></script>
<script type="text/javascript">
var dhxLayout, myGrid, myDp, myTree, t;
$(document).ready(function(){
	setMainLayoutHeight($('#mainLayout'));
	if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
	else  window.addEventListener("resize",resizeLayout, false);
	//set layout
	dhxLayout = new dhtmlXLayoutObject("mainLayout","2U");
	dhxLayout.cells("a").hideHeader();
	dhxLayout.cells("a").setWidth("250");
	dhxLayout.cells("b").hideHeader();
	dhxLayout.setSizes(false);

	//attach treeView
	myTree = dhxLayout.cells("a").attachTree();
	myTree.setImagePath("${dhtmlXImagePath}dhxtree_terrace/");
	myTree.enableTreeLines(true);
	myTree.enableHighlighting(true);
	myTree.setOnClickHandler(treeClick);
	myTree.deleteChildItems(0);
	myTree.insertNewChild(0,1,"연구자 [${ridStats.rsrchCo}]");
	myTree.insertNewChild(1,'hffc',"재직 (${ridStats.hffcCo})");
	myTree.insertNewChild('hffc','hffc_issu',"발급 (${ridStats.hffcIssuCo})");
	myTree.insertNewChild('hffc','hffc_notissu',"미발급 (${ridStats.hffcNotIssuCo})");
	myTree.insertNewChild(1,'retire',"퇴직 (${ridStats.retireCo})");
	myTree.insertNewChild('retire','retire_issu',"발급 (${ridStats.retireIssuCo})");
	myTree.insertNewChild('retire','retire_notissu',"미발급 (${ridStats.retireNotIssuCo})");

	//attach myGrid
	myGrid = dhxLayout.cells("b").attachGrid();
	myGrid.setImagePath("${dhtmlXImagePath}");
	myGrid.setHeader('No,사번,RID,이름,영문명,학(부)과명,이메일,재직여부,상태,Link,seqNo,idntfrSe', null, grid_head_center_bold);
	myGrid.setColumnIds("no,userId,idntfr,korNm,engNm,deptKor,emalAddr,hldofYn,status,link,seqNo,idntfrSe");
	myGrid.setInitWidths("80,80,100,*,*,250,*,*,*,*,1,1");
	myGrid.setColAlign('center,center,center,center,left,left,left,center,center,center,left,center');
	myGrid.setColTypes('ro,ro,ed,ro,ro,ro,ro,ro,co,link,ro,ro');
	myGrid.setColSorting("na,str,str,str,str,str,str,str,str,str,na,na");
	myGrid.attachEvent("onRowSelect",ridMakeParam);
	myGrid.attachEvent("onBeforeSorting",myGrid_onBeforeSorting);
	myGrid.attachEvent("onXLS", doBeforeGridLoad);
	myGrid.attachEvent("onXLE", doOnGridLoaded);
	myGrid.enablePaging(true,30,10,"pagingArea",true);
	myGrid.setPagingSkin("${dhtmlXPagingSkin}");
	myGrid.enableMultiselect(true);
	myGrid.setColumnHidden(myGrid.getColIndexById("seqNo"),true);
	myGrid.setColumnHidden(myGrid.getColIndexById("idntfrSe"),true);
	myGrid.init();
	var comboStat = myGrid.getCombo(myGrid.getColIndexById("status"));
	comboStat.put("001","초기 상태");
	comboStat.put("002","RID미대상자");
	comboStat.put("003","개인등록완료");
	comboStat.put("004","기관등록동의");
	comboStat.put("005","기관등록미동의");
	comboStat.put("006","기관등록완료");

	myDp = new dataProcessor("${contextPath}/auth/user/updateStat.do");
	myDp.init(myGrid);
	myDp.setTransactionMode("POST",false);
	myDp.setUpdateMode("off");
	myDp.enableDataNames(true);
	myDp.attachEvent("onFullSync",function(){
		dhtmlx.alert('수정되었습니다');
	    return true;
	});

	myGrid_load();
});

function treeClick(id){

	var hldofYn = "All";
	var issuAt = "All";

	if(id != "1")
	{
		if(id.indexOf("_") == -1)
		{
			if(id == 'hffc') hldofYn = "1";
			else if(id == 'retire')	hldofYn = "2";
		}
		else
		{
			if(id.split('_')[0] == 'hffc') hldofYn = "1";
			else if(id.split('_')[0] == 'retire')	hldofYn = "2";
			if(id.split('_')[1] == 'issu') issuAt = "Y";
			else if(id.split('_')[1] == 'notissu') issuAt = "N";
		}
	}
	$('input:radio[name="hldofYn"]').prop('checked', '');
	$('#hldofYn' + hldofYn).prop('checked','checked');
	$('input:radio[name="issuAt"]').prop('checked', '');
	$('#issuAt' + issuAt).prop('checked','checked');
	myGrid_load();
}

function myGrid_load(){
	doBeforeGridLoad();
	var url = getGridRequestURL();
	myGrid.clearAndLoad(url, doOnGridLoaded);
}

function getGridRequestURL(){

	if($('#adminSrchDeptTrack').length)
	{
		var val = $('#adminSrchDeptTrack').val();
		if(val != null && val != '')
		{
			if(val.indexOf('DEPT_') != -1 ){
				$('#adminSrchDeptKor').val(val.replace('DEPT_',''));
				$('#adminSrchTrack').val('');
			}
			if(val.indexOf('TRACK_') != -1 ){
				$('#adminSrchDeptKor').val('');
				$('#adminSrchTrack').val(val.replace('TRACK_',''));
			}
		}
		else
		{
			$('#adminSrchDeptKor').val('');
			$('#adminSrchTrack').val('');
		}
	}
	var url = "${contextPath}/auth/user/findRIDList.do";
	url += "?"  + $('#ridSearchFrm').serialize();
	return url;
}

function myGrid_onBeforeSorting(ind,type,direct){
	var url = getGridRequestURL();
	myGrid.clearAndLoad(url+"&orderby="+(myGrid.getColumnId(ind))+"&direct="+direct);
	myGrid.setSortImgState(true,ind,direct);
	return false;
}

function fn_batchupload(){
	// 1) 조회된 그리드 전체선택
	myGrid.selectAll();
	// 2) 전체 ID List 가져오기
	var idList = myGrid.getSelectedId();
	// 3) 기관등록 동의 이외 데이터 체크
	if(!checkArgeeAt(idList))
	{
		dhtmlx.alert({type:"alert-warning",text:"기관등록동의 이외의 데이터가 <br/>포함되어있습니다.",callback:function(){}})
		return;
	}
	else
	{
		// 4) Confirm 메시지 (발급요청페이지)
		dhtmlx.confirm({
			type:"confirm-warning",
			title:"발급요청페이지 이동",
			text:"총 "+idList.split(",").length+"명의 연구자 <br/>ResearcherID 발급 요청 페이지로 <br/>이동 하시겠습니까?",
			ok:"예", cancel:"아니오",
			callback:function(result){
				if(result == true){
					// 5) Popup 실행
					fn_openRidPopup();
				}
				else
				{
					return;
				}
			}
		});
	}
}

function checkArgeeAt(ids){
	var list = ids.split(",");
	for(var i = 0; i < list.length; i++)
	{
		if(list[i].split("_")[1] != '004')
			return false;
	}
	return true;
}

function fn_openRidPopup(){

	var wWidth = 1100;
	var wHeight = 500;
	var leftPos = (screenWidth - wWidth)/2;
	var topPos = (screenHeight - wHeight)/2;

	var ridPopup = window.open('about:blank', 'ridPopup', 'width='+wWidth+'px,height='+wHeight+'px,top='+topPos+',left='+leftPos+' location=no,scrollbars=yes,resizable=yes');
	var popFrm = $('#popFrm');
	popFrm.empty();
	var idList = myGrid.getSelectedId();
	var list = idList.split(",");
	for(var i = 0; i < list.length; i++)
	{
		popFrm.append($('<input type="hidden" name="userId" value="'+list[i].split("_")[0]+'"/>'));
	}
	popFrm.attr('action', '${contextPath}/auth/user/ridPopup.do');
	popFrm.attr('target', 'ridPopup');
	popFrm.attr('method', 'POST');
	popFrm.submit();
	ridPopup.focus();
}


var ridList = new Array();
function ridMakeParam(rowID,celInd){
	ridList.push(rowID);
}

function fn_save(){
	dhtmlx.confirm({
		type:"confirm-warning",
		title:"RID 저장",
		text:"수정된 RID 정보를 저장하시겠습니까?",
		ok:"저장", cancel:"취소",
		callback:function(result){
			if(result == true){
				myDp.sendData();
				myGrid_load();
			}
		}
	});

}

function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){ setMainLayoutHeight($('#mainLayout')); dhxLayout.setSizes(false); },200);}
function doOnGridLoaded(){setTimeout(function() {dhxLayout.cells("b").progressOff();}, 100);}
function doBeforeGridLoad(){dhxLayout.cells("b").progressOn();}
</script>

</head>
<body>
<form id='ridSearchFrm'>
	<input type="hidden" name="gubun" id="gubun" value="M"/>

	<!-- Page Title -->
	<div class="title_box">
		<h3><spring:message code='menu.researcher.rid'/></h3>
	</div>
	<!-- Main Content -->
	<div class="contents_box">
		<!-- START 탑 툴바 -->
		<!--
		<div class="top_toolbar" style="width: 100%">
			<div class="top_toolbar_ttl"></div>
			<div class="top_toolbar_btn">
				<div  style="float: right;margin-right: 10px;"><a href="#" onclick="javascript:myDp.sendData();">저장</a></div>
				<div  style="float: right;margin-right: 10px;"><a href="#" onclick="excDown();">Download</a></div>
				<div  style="float: right;margin-right: 10px;"><a href="#" onclick="ridBatchUP(0);">Profile batch upload</a></div>
			</div>
		</div>
		 -->
		<!-- END 탑 툴바 -->
		<!-- START 테이블 1 -->
		<table class="view_tbl mgb_10">
			<colgroup>
				<col style="width:13% " />
				<col style="width:45% " />
				<col style="width:13% " />
				<col />
				<col style="width:50px;" />
			</colgroup>
			<tbody>
			<tr>
				<th>사번</th>
				<td><input type="text" name="identity" class="typeText" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/></td>
				<th>성명</th>
				<td><input type="text" name="userNm" class="typeText" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/></td>
				<td rowspan="3" class="option_search_td" onclick="javascript: myGrid_load();"><em>search</em></td>
			</tr>
			<tr>
				<th>재직여부</th>
				<td>
					<input type='radio' name='hldofYn' id='hldofYnAll' value='ALL' class="radio" checked='checked' onchange="javascript:myGrid_load();"/>
						<label for="hldofYnAll" class="radio_label">전체</label>
					<input type='radio' name='hldofYn' id='hldofYn1' value='1' class="radio" onchange="javascript:myGrid_load();"/>
						<label for="hldofYn1" class="radio_label">재직</label>
					<input type='radio' name='hldofYn' id='hldofYn2' value='2' class="radio" onchange="javascript:myGrid_load();"/>
						<label for="hldofYn2" class="radio_label">퇴직</label>
				</td>
				<th>학과 및 트랙</th>
				<td>
					<select  name="adminSrchDeptTrack" id="adminSrchDeptTrack"  class="select_type" style="width: 50%" onchange="javascript:myGrid_load();" >
						<option value="">전체</option>
						<optgroup label="학과(부)">
							<c:forEach var="item" items="${deptList}">
							<option value="DEPT_${item.deptKor}">${item.deptKor}</option>
							</c:forEach>
						</optgroup>
						<optgroup label="트랙">
							<c:forEach var="item" items="${trackList}">
							<option value="TRACK_${item.trackId}">${item.trackName}</option>
							</c:forEach>
						</optgroup>
					</select>
					<input type="hidden" name="srchDeptKor"  id="adminSrchDeptKor"/>
					<input type="hidden" name="srchTrack"  id="adminSrchTrack"/>
				</td>
			</tr>
			<tr>
				<th >RID 상태</th>
				<td >
					<input type="hidden" name="state" value="ALL">
					<input type='radio' name='ridStatus' id='stateAll' value='ALL' class="radio" checked='checked' onchange="javascript:myGrid_load();"/>
						<label for="stateAll" class="radio_label">전체</label>
					<input type='radio' name='ridStatus' id='state001' value='001' class="radio" onchange="javascript:myGrid_load();"/>
						<label for="state001" class="radio_label">초기상태</label>
					<input type='radio' name='ridStatus' id='state002' value='002' class="radio" onchange="javascript:myGrid_load();"/>
						<label for="state002" class="radio_label">RID미대상자</label>
					<input type='radio' name='ridStatus' id='state003' value='003' class="radio" onchange="javascript:myGrid_load();"/>
						<label for="state003" class="radio_label">개인등록완료</label>
					<input type='radio' name='ridStatus' id='state004' value='004' class="radio" onchange="javascript:myGrid_load();"/>
						<label for="state004" class="radio_label">기관등록동의</label>
					<input type='radio' name='ridStatus' id='state005' value='005' class="radio" onchange="javascript:myGrid_load();"/>
						<label for="state005" class="radio_label">기관등록미동의</label>
					<input type='radio' name='ridStatus' id='state006' value='006' class="radio" onchange="javascript:myGrid_load();"/>
						<label for="state006" class="radio_label">기관등록완료</label>
				</td>
				<th >RID 발급여부</th>
				<td>
					<input type='radio' name='issuAt' id='issuAtAll' value='ALL' class="radio" checked='checked' onchange="javascript:myGrid_load();"/>
						<label for="issuAtAll" class="radio_label">전체</label>
					<input type='radio' name='issuAt' id='issuAtY' value='Y' class="radio" onchange="javascript:myGrid_load();"/>
						<label for="issuAtY" class="radio_label">발급</label>
					<input type='radio' name='issuAt' id='issuAtN' value='N' class="radio" onchange="javascript:myGrid_load();"/>
						<label for="issuAtN" class="radio_label">미발급</label>
				</td>
			</tr>
			</tbody>
		</table>

		<div class="list_bt_area">
			<div class="list_set">
				<ul>
					<li><a href="#" onclick="javascript:fn_batchupload();" class="list_icon16">Profile Batch Upload</a></li>
					<li><a href="#" onclick="javascript:fn_save();" class="list_icon02">저장</a></li>
					<c:if test="${sessionScope.auth.userId eq '1585' }">
					<li><a href="#" onclick="javascript:fn_export();" class="list_icon20"><spring:message code='common.button.excel'/></a></li>
					</c:if>
				</ul>
			</div>
		</div>

		<div id="mainLayout" style="position: relative; width: 100%;height: 100%;"></div>
		<div id="pagingObj" style="z-index: 1; height: 60px; margin-top: 5px; padding-left: 260px;" >
			<div id="pagingArea" style="z-index: 1;"></div>
		</div>
	</div>
</form>
</body>
</html>