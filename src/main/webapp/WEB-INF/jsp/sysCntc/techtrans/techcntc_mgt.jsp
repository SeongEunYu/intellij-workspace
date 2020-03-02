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
			myGrid.setHeader("번호,소스관리번호,계약번호,계약기간,계약금액,기술이전명,최종수정일자,상태,기술이전관리번호",null,grid_head_center_bold);
			myGrid.setColumnIds("no,srcId,cntrctManageNo,cntrctPeriod,cntrctAmt,techTransrNm,srcModDate,cntcStatus,techtransId");
			myGrid.setInitWidths("50,80,100,170,120,*,100,60,90");
			myGrid.setColAlign("center,center,left,left,right,left,center,center,center");
			myGrid.setColTypes("ro,ro,ro,ro,ro,ro,ro,ro,ro");
			myGrid.setColSorting("na,na,na,na,na,na,na,na,na");
			//myGrid.attachEvent("onBeforeSorting",myGrid_onBeforeSorting);
			myGrid.attachEvent("onXLS", doBeforeGridLoad);
			myGrid.attachEvent("onXLE", doOnGridLoaded);
			myGrid.attachEvent("onRowSelect", myGrid_onRowSelect);
		    myGrid.enablePaging(true,100,10,"pagingArea",true,"infoArea");
		    myGrid.setPagingSkin("${dhtmlXPagingSkin}");
		    myGrid.enableColSpan(true);
//		    myGrid.setColumnHidden(myGrid.getColIndexById("techtransId"), true);
			myGrid.init();
			myGrid_load();

		});

		function myGrid_load(){
 			doBeforeGridLoad();
			var url = getGridRequestURL();
			myGrid.clearAndLoad(url, doOnGridLoaded);
		}

		function getGridRequestURL(){
			var url = "${contextPath}/techtransCntc/findTechTargetList.do";
			url += "?"+$('#formArea').serialize();
			return url;
		}

		function myGrid_onRowSelect(rowId,celInd){
			var srcId = myGrid.cells(rowId, myGrid.getColIndexById("srcId")).getValue();
			var techtransId = myGrid.cells(rowId, myGrid.getColIndexById("techtransId")).getValue();
			window.open('<c:url value="/techtransCntc/techCntcPopup.do?srcId="/>' + srcId, 'techtranscntc');
//			var cntcPopup = window.open('about:blank', 'techtransCntcPopup', 'height='+(screenHeight-110)+'px,width='+(screenWidth-50)+'px,location=no,scrollbars=yes,resizable=yes');
//			var popFrm = $('#popFrm');
//			popFrm.empty();
//			popFrm.append($('<input type="hidden" name="srcId" value="'+srcId+'"/>'));
//			popFrm.append($('<input type="hidden" name="techtransId" value="'+techtransId+'"/>'));
//			popFrm.attr('action', '${contextPath}/techtransCntc/techCntcPopup.do');
//			popFrm.attr('target', 'techtransCntcPopup');
//			popFrm.attr('method', 'POST');
//			popFrm.submit();
		}

		function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){ dhxLayout.setSizes(false); },200);}
		function doOnGridLoaded(){setTimeout(function() {dhxLayout.cells("a").progressOff();}, 100);}
		function doBeforeGridLoad(){dhxLayout.cells("a").progressOn();}

	</script>
</head>
<body>
	<!-- Page Title -->
	<div class="title_box">
		<h3><spring:message code='menu.cntc.techtrans'/></h3>

	</div>

	<!-- Main Content -->
	<div class="contents_box">
		<div id="formObj">
			<form id="formArea">
				<table class="view_tbl mgb_10">
					<colgroup>
						<col style="width: 15%" />
						<col style="width: 35%" />
						<col style="width: 15%" />
						<col />
						<col style="width: 50px;" />
					</colgroup>
					<tr>
						<th>작업상태</th>
						<td>
							<input type="radio" class="radio" value="I" id="srchStatus_Insert" name="srchStatus" checked="checked" onchange="javascript:myGrid_load();"/> <label for="" class="radio_label">신규</label>
							<input type="radio" class="radio" value="U" id="srchStatus_Update" name="srchStatus" onchange="javascript:myGrid_load();"/> <label for="" class="radio_label">수정</label>
						</td>
						<th>수정일자</th>
						<td>
							<input type="text" id="sttDate" name="sttDate" class="input_type"  maxlength="4" style="width: 80px;"  onKeyup="javascript:if(event.keyCode=='13')myGrid_load();" />
							~ <input type="text" id="endDate" name="endDate" class="input_type" maxlength="4" style="width: 80px;" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/>
						</td>
						<td rowspan="2" class="option_search_td" onclick="javascript: myGrid_load();"><em>search</em></td>
					</tr>
					<tr>
						<th>기술이전명</th>
						<td colspan="3">
							<input type="text" id="techTransrNm" name="techTransrNm" class="input_type" style="width: 100%;" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/>
						</td>
					</tr>
				</table>
			</form>
		</div>

		<div class="list_bt_area">
			<div class="list_set">
				<ul>
				<!--
					<li><a href="#" onclick="javascript:sendDataToKRI();" class="list_icon18">KRI전송</a></li>
				 -->
				</ul>
			</div>
		</div>

		<div id="mainLayout" style="position: relative; width: 100%;height: 100%;"></div>
		<script type="text/javascript">setMainLayoutHeight($('#mainLayout'));</script>
		<div id="pagingObj" style="z-index: 1; height: 40px; margin-top: 5px;" >
			<div id="pagingArea" style="z-index: 1;"></div>
		</div>

</div>

</body>
</html>