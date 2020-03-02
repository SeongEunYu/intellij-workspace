<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/pageInit.jsp" %>
<html>
<head>
	<script type="text/javascript" src="${contextPath}/js/mainLayout.js"></script>
	<script type="text/javascript">

		var dhxLayout, codeInfoGrid, codeGrid, myDp, t;

		$(function() {

			$('#mainLayout').css('height', ($(document).height() - (120 +  $('.title_box').height() + $('.header_wrap').height() + $('.nav_wrap').height() + $('.list_bt_area').height()     )) + "px");

			if(window.attachEvent) window.attachEvent("onresize",resizeLayout);
			else window.addEventListener("resize",resizeLayout, false);

			dhxLayout = new dhtmlXLayoutObject({
				parent: "mainLayout",
				pattern: "2U",
				skin: "${dhtmlXSkin}",
				cells: [{ id: 'a', text: '코드구분', width: 500 }, { id: 'b', text: '코드목록' }]
			});

			codeInfoGrid = dhxLayout.cells("a").attachGrid();
			codeInfoGrid.setImagePath("${dhtmlXImagePath}");
			codeInfoGrid.setHeader("코드구분,코드설명", null, grid_head_center_bold);
			codeInfoGrid.setInitWidths("150,*");
			codeInfoGrid.setColAlign("center,left");
			codeInfoGrid.setColTypes("ro,ro");
			codeInfoGrid.setColSorting("str,str");
			codeInfoGrid.setColumnColor("#FFFFFF,#FFFFFF");
			codeInfoGrid.setEditable(false);
			codeInfoGrid.enableColSpan(true);
			codeInfoGrid.attachEvent("onRowSelect", doOnRowSelected);
			codeInfoGrid.attachEvent("onXLE", codeInfoGrid_onSelectPageFirstRow);
			codeInfoGrid.init();
			codeInfoGrid_load();

			codeGrid = dhxLayout.cells("b").attachGrid();
			codeGrid.setImagePath("${dhtmlXImagePath}");
			codeGrid.setHeader("번호,한글,영문,코드형태,사용여부,정렬순서", null, grid_head_center_bold);
			codeGrid.setColumnIds("no,codeDisp,CodeDispEng,CodeValue,IsUsed,DispOrder");
			codeGrid.setInitWidths("60,*,*,80,80,80");
			codeGrid.setColAlign("center,left,left,center,center,center");
			codeGrid.setColTypes("ro,ed,ed,ed,co,ed");
			codeGrid.setColSorting("int,str,str,str,str,str");
			codeGrid.init();
			var comboUseYn = codeGrid.getCombo(4);
			comboUseYn.put("Y","사용함");
			comboUseYn.put("N","사용안함");

			myDp = new dataProcessor('commonCodeCUD.do');
			myDp.init(codeGrid);
			myDp.setTransactionMode("POST", false);
			myDp.setUpdateMode("on");
			myDp.enableDataNames(true);
			myDp.setVerificator(1, myGRID_not_empty);
			myDp.setVerificator(3, myGRID_not_empty);
			myDp.setVerificator(5, myGRID_not_empty);
			myDp.attachEvent("onFullSync", function() {
				codeGrid.clearAndLoad('codeDetailList.do?gubun=' + codeInfoGrid.getSelectedRowId());
			});
			myDp.attachEvent("onValidatationError", function(id, messages) {
				alert(messages.join("\n"));
				return true;
			});
		});

		function codeInfoGrid_load() {
			doBeforeGridLoad();
			codeInfoGrid.clearAndLoad('codeInfoList.do', doOnGridLoaded);
		}

		function doOnRowSelected(id) {
			codeGrid.clearAndLoad('codeDetailList.do?gubun=' + id);
		}

		function codeInfoGrid_onSelectPageFirstRow(){
			codeInfoGrid.selectRow(0,true,true,true);
			codeInfoGrid.showRow(codeInfoGrid.getRowId(0))
			doOnGridLoaded();
		}

		function reLoding() {
			dhxLayout.progressOn();
			$.ajax({
				url: 'codeReload.do',
				dataType: 'xml'
			}).done(function(data) {
				$(data).find('result').each(function(i) {
					if($(this).find('code').text() == '001') {
						alert($(this).find('msg').text());
					}
				});
				dhxLayout.progressOff();
			});
		}

		function save() {
			myDp.sendData();
		}

		function addnew() {
			if(codeGrid.getRowsNum() != 0){
				var gr_id = codeGrid.getRowId(0).split("_")[0];
				codeGrid.selectRow(0); //to Add row at the TOP of grid
				codeGrid.addRow(gr_id,[codeGrid.getRowsNum() + 1,'','','','Y'],codeGrid.getRowIndex(codeGrid.getSelectedId()));
				codeGrid.selectRow(0); //to Select added row
			}
		}

		function cut() {
			codeGrid.deleteSelectedItem();
		}

		function myGRID_not_empty(value, id, ind) {
		    if (value == "") {
				return "Value at (" + id + ", " + ind + ") can't be empty";
			}
		    return true;
		}

		function resizeLayout() { window.clearTimeout(t); t = window.setTimeout(function(){ dhxLayout.setSizes(false); }, 200); }
		function doBeforeGridLoad() { dhxLayout.cells("a").progressOn(); }
		function doOnGridLoaded() { setTimeout(function() { dhxLayout.cells("a").progressOff(); }, 100); }

	</script>
</head>
<body>
	<!-- Page Title -->
	<div class="title_box">
		<h3><spring:message code='menu.code'/></h3>
	</div>
	<!-- Main Content -->
	<div class="contents_box">
		<div class="list_bt_area">
			<div class="list_set">
				<ul>
					<li><a href="#" onclick="javascript:addnew();" class="list_icon12">추가</a></li>
					<li><a href="#" onclick="javascript:save();" class="list_icon02">저장</a></li>
					<li><a href="#" onclick="javascript:cut();" class="list_icon22">삭제</a></li>
					<li><a href="#" onclick="javascript:reLoding();" class="list_icon21">코드갱신</a></li>
				</ul>
			</div>
		</div>

		<div id="mainLayout" style="width: 100%;height: 100%;"></div>
	</div>
</body>
</html>