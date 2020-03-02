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
			myGrid.setHeader("번호,소스관리번호,지식재산권명,출원번호,출원일자,등록번호,등록일자,상태,패밀리코드,출원상태,수정일자,특허관리번호,삭제여부",null,grid_head_center_bold);
			myGrid.setColumnIds("no,srcId,itlPprRgtNm,applRegNo,applRegDate,itlPprRgtRegNo,itlPprRgtRegDate,status,familyCode,applDvsCd,modDate,patentId,delDvsCd");
			myGrid.setInitWidths("40,70,*,130,80,130,80,140,100,50,80,70,50");
			myGrid.setColAlign("center,center,left,left,center,left,center,center,left,center,center,center,center");
			myGrid.setColTypes("ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro");
			myGrid.setColSorting("na,na,str,str,na,str,na,str,na,na,str,na,na");
			myGrid.attachEvent("onBeforeSorting",myGrid_onBeforeSorting);
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
			var url = "${contextPath}/patentCntc/findPatentTargetList.do";
			url += "?"+$('#formArea').serialize();
			return url;
		}

		function myGrid_onRowSelect(rowId, celInd) {
			var srcId = myGrid.cells(rowId, myGrid.getColIndexById("srcId")).getValue();
			var patentId = myGrid.cells(rowId, myGrid.getColIndexById("patentId")).getValue();
//			var popFrm = $('#popFrm');
			window.open('<c:url value="/patentCntc/patentCntcPopup.do?srcId="/>' + srcId, 'patentcntc');
//			popFrm.empty();
//			popFrm.append($('<input type="hidden" name="srcId" value="'+srcId+'"/>'));
//			popFrm.append($('<input type="hidden" name="patentId" value="'+patentId+'"/>'));
//			popFrm.attr('action', '${contextPath}/patentCntc/patentCntcPopup.do');
//			popFrm.attr('target', '_blank');
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
		<h3><spring:message code='menu.cntc.patent'/></h3>

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
							<input type="radio" class="radio" value="N" id="srchStatus_Insert" name="srchStatus" checked="checked" onchange="javascript:myGrid_load();"/>
								<label for="srchStatus_Insert" class="radio_label">신규입력</label>
							<input type="radio" class="radio" value="U" id="srchStatus_Update" name="srchStatus" onchange="javascript:myGrid_load();"/>
								<label for="srchStatus_Update" class="radio_label">수정</label>
						</td>
						<td></td>
						<td></td>
						<td class="option_search_td" onclick="javascript: myGrid_load();"><em>search</em></td>
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