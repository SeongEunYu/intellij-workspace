<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../pageInit.jsp" %>
<html>
<head>
	<title>KRI 연계</title>
<style type="text/css">
.dhxwins_vp_dhx_terrace {overflow: auto;} .dhx_toolbar_dhx_terrace { padding: 0 0px; }
.dhxwins_vp_dhx_terrace div.dhxwin_active div.dhx_cell_wins div.dhx_cell_toolbar_def, .dhxwins_vp_dhx_terrace div.dhxwin_inactive div.dhx_cell_wins div.dhx_cell_toolbar_def { padding: 10px 0px 0; }
div.dhxform_item_label_left.button_search div.dhxform_btn { height: 25px; margin: 0px 2px; background-color: #ffffff;}
div.dhxform_item_label_left.button_search div.dhxform_btn_txt { top:0;right:0;background: url(${contextPath}/images/background/tbl_search_icon.png) no-repeat 50% 50%; text-indent: -9999px;display: block;width: 23px; height: 25px;margin: 0 0px;}
.alignLeft{text-align: left;} .alignLeft div.dhxform_txt_label2{font-weight: normal;}
.write_tbl tbody td { padding: 3px 10px; border-bottom: 1px solid #ddd; }
</style>
<script type="text/javascript" src="${contextPath}/js/mainLayout.js"></script>
<script type="text/javascript">
var dhxLayout, dhxWins, userFormLayout, userForm, userModalBox, myGrid, t;
$(function() {

	if (window.attachEvent) window.attachEvent("onresize",resizeLayout);
	else  window.addEventListener("resize",resizeLayout, false);

	//set layout
	dhxLayout = new dhtmlXLayoutObject("mainLayout","1C");
	dhxLayout.cells("a").hideHeader();
	dhxLayout.setSizes(false);

	//attach mymyGrid
	myGrid = dhxLayout.cells("a").attachGrid();
	myGrid.setImagePath("${dhtmlXImagePath}");
    myGrid.enableColSpan(true);
	myGrid.init();
});

function myGrid_load(){
		doBeforeGridLoad();
	var url = getGridRequestURL();
	myGrid.clearAndLoad(url, doOnGridLoaded);
}

function getGridRequestURL(){
	var url = "${contextPath}/kriCntc/findOutputList.do";
	url += "?"+$('#formArea').serialize();
	return url;
}

function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){ dhxLayout.setSizes(false); },200);}
function doOnGridLoaded(){setTimeout(function() {dhxLayout.cells("a").progressOff();}, 100);}
function doBeforeGridLoad(){dhxLayout.cells("a").progressOn();}

//연구자검색(대리입력자 - 권한대상) 검색
function findTrget(){
	var pageX = Math.max(0, (($(window).width() - 550) / 2) + $(window).scrollLeft());
	var pageY = Math.max(0, (($(window).height() - 350) / 2) + $(window).scrollTop());
	if(dhxWins != null && dhxWins.unload != null){ dhxWins.unload(); dhxWins = null; }

	dhxWins = new dhtmlXWindows({
		viewport : {objec : 'windVP'},
		wins : [ {id : 'w1', left : pageX, top : pageY, width: 600, height: 450, text: "연구자검색", resize : false} ]
	});
	dhxWins.window('w1').setModal(true);
	dhxWins.window('w1').attachEvent('onClose',function(){
		return true;
	});
	var keyword = "";
	if($('#srchUserNm').val() != null) keyword = $('#srchUserNm').val();

	w1Layout = dhxWins.window('w1').attachLayout('2E')
	w1Layout.cells('a').hideHeader();
	w1Layout.cells('b').hideHeader();
	w1Layout.cells("a").setHeight(55);

	w1Toolbar = w1Layout.cells("b").attachToolbar();
	w1Toolbar.setIconsPath("${dhtmlXImagePath}/icons_${sysConf['dhtmlx.skin']}/");
	w1Toolbar.setIconSize(18);
	w1Toolbar.addInput("keyword", 0, keyword, 515);
	w1Toolbar.addButton("search", 1, "", "search.png", "search.png");
	w1Toolbar.attachEvent("onClick", function(id) {
		if (id == "search") w1Grid.clearAndLoad('${contextPath}/user/findAuthorListByKeyword.do?keyword=' + encodeURIComponent(w1Toolbar.getValue('keyword')));
	});
	w1Toolbar.attachEvent("onEnter", function(id,value) {
		if(value == "") dhtmlx.alert({type:"alert-warning",text:"검색어를 입력하세요.",callback:function(){}})
		else w1Grid.clearAndLoad('${contextPath}/user/findAuthorListByKeyword.do?keyword=' + encodeURIComponent(w1Toolbar.getValue('keyword')));
    });
	w1Grid = w1Layout.cells("b").attachGrid();
	w1Grid.setImagePath("${dhtmlXImagePath}");
	w1Grid.setHeader('');
	w1Grid.setHeader("사번,영문성명(ABBR),영문성명(FULL),한글성명,소속", null, grid_head_center_bold);
	w1Grid.setInitWidths("100,120,120,120,*");
	w1Grid.setColAlign("center,center,left,center,center");
	w1Grid.setColTypes("ro,ro,ro,ro,ro");
	w1Grid.setColSorting("str,str,str,str,str");
	w1Grid.attachEvent("onXLS", function() {
		w1Layout.cells("b").progressOn();
	 });
	w1Grid.attachEvent("onXLE", function() {
		w1Layout.cells("b").progressOff();
	 });
	w1Grid.attachEvent('onRowSelect', doOnRowSelectedResearcher);
	w1Grid.init();
	$('.dhxtoolbar_input').focus();
	if (w1Toolbar.getValue('keyword') != "")
		w1Grid.clearAndLoad('${contextPath}/user/findAuthorListByKeyword.do?keyword=' + encodeURIComponent(w1Toolbar.getValue('keyword')));
}

function doOnRowSelectedResearcher(id){
	var userId = w1Grid.cells(w1Grid.getSelectedId(),0).getValue();
	var korNm = w1Grid.cells(w1Grid.getSelectedId(),3).getValue();
	$('#srchUserId').val(userId);
	$('#srchUserNm').val(korNm);
	dhxWins.window('w1').close();
	myGrid.clearAll(true);
	myGrid_load();
}

function sendDataToKRI(){

	var count=myGrid.getRowsNum();

	if(count > 0)
	{
		var trgetItemIds = myGrid.getAllRowIds(';');
		//console.log(trgetItemIds);
		$('#trgetItemIds').val('').val(trgetItemIds);

		dhtmlx.confirm({
			title:"KRI전송",
			ok:"예", cancel:"아니오",
			text:"KRI 전송을 위해 <br/>수정일자를 업데이트를 하시겠습니까?",
			callback:function(result){
				if(result)
				{
					$.post('${contextPath}/kriCntc/updateModDateByIds.do', $('#formArea').serializeArray(), null, 'json').done(function(data){
						dhtmlx.alert("업데이트 완료하였습니다.");
						myGrid_load();
					});
				}
				else
				{
					return;
				}
			}
		});
	}
	else
	{
		dhtmlx.alert({type:"alert-warning",text:"업데이트할 대상이 없습니다.",callback:function(){}})
	}

}

</script>
</head>
<body>
	<!-- Page Title -->
	<div class="title_box">
		<h3><spring:message code='menu.cntc.kri'/></h3>

	</div>

	<!-- Main Content -->
	<div class="contents_box">
		<div id="formObj">
			<form id="formArea" onsubmit="return false;">
				<input type="hidden" name="trgetItemIds" id="trgetItemIds">
				<table class="view_tbl mgb_10">
					<colgroup>
						<col style="width: 15%" />
						<col style="width: 35%" />
						<col style="width: 15%" />
						<col />
						<col style="width: 50px;" />
					</colgroup>
					<tr>
						<th>사번/성명</th>
						<td>
							<div class="r_add_bt">
								<input type="text" name="srchUserNm" id="srchUserNm" class="input_type" onkeyup="javascript:if(event.keyCode=='13')findTrget();"/>
								<a href="javascript:void(0);" onclick="findTrget();" class="tbl_search_bt">검색</a>
								<input type="hidden" name="srchUserId" id="srchUserId"/>
			        		</div>
						</td>
						<td></td>
						<td></td>
						<td rowspan="2" class="option_search_td" onclick="javascript: myGrid_load();"><em>search</em></td>
					</tr>
					<tr>
						<th>대상성과</th>
						<td colspan="3">
							<input type="radio" class="radio" value="article" id="trgetOutput_Art" name="trgetOutput" checked="checked" onchange="javascript:myGrid_load();"/>
								<label for="trgetOutput_Art" class="radio_label">논문게재</label>
							<input type="radio" class="radio" value="conference" id="trgetOutput_Con" name="trgetOutput" onchange="javascript:myGrid_load();"/>
								<label for="trgetOutput_Con" class="radio_label">학술대회</label>
							<input type="radio" class="radio" value="book" id="trgetOutput_Book" name="trgetOutput" onchange="javascript:myGrid_load();"/>
								<label for="trgetOutput_Book" class="radio_label">저역서</label>
							<input type="radio" class="radio" value="funding" id="trgetOutput_Fund" name="trgetOutput" onchange="javascript:myGrid_load();"/>
								<label for="trgetOutput_Fund" class="radio_label">연구비(연구과제)</label>
							<input type="radio" class="radio" value="patent" id="trgetOutput_Pat" name="trgetOutput" onchange="javascript:myGrid_load();"/>
								<label for="trgetOutput_Pat" class="radio_label">지식재산권(특허)</label>
							<input type="radio" class="radio" value="techtrans" id="trgetOutput_Tech" name="trgetOutput" onchange="javascript:myGrid_load();"/>
								<label for="trgetOutput_Tech" class="radio_label">기술이전</label>
							<input type="radio" class="radio" value="career" id="trgetOutput_Career" name="trgetOutput" onchange="javascript:myGrid_load();"/>
								<label for="trgetOutput_Career" class="radio_label">경력사항</label>
							<input type="radio" class="radio" value="degree" id="trgetOutput_Degree" name="trgetOutput" onchange="javascript:myGrid_load();"/>
								<label for="trgetOutput_Degree" class="radio_label">취득학위</label>
							<input type="radio" class="radio" value="award" id="trgetOutput_Award" name="trgetOutput" onchange="javascript:myGrid_load();"/>
								<label for="trgetOutput_Award" class="radio_label">수상사항</label>
							<input type="radio" class="radio" value="license" id="trgetOutput_License" name="trgetOutput" onchange="javascript:myGrid_load();"/>
								<label for="trgetOutput_License" class="radio_label">자격사항</label>
							<input type="radio" class="radio" value="exhibition" id="trgetOutput_Exhibition" name="trgetOutput" onchange="javascript:myGrid_load();"/>
								<label for="trgetOutput_Exhibition" class="radio_label">전시작품</label>
						</td>
					</tr>
				</table>
			</form>
		</div>

		<div class="list_bt_area">
			<div class="list_set">
				<ul>
					<li><a href="#" onclick="javascript:sendDataToKRI();" class="list_icon18">KRI전송</a></li>
				</ul>
			</div>
		</div>

		<div id="mainLayout" style="position: relative; width: 100%;height: 100%;"></div>
		<script type="text/javascript">setMainLayoutHeight($('#mainLayout'));</script>
</div>

</body>
</html>