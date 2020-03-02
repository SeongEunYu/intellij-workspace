<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/pageInit.jsp" %>
<html>
<head>
	<script type="text/javascript">

		var dhxLayout, codeInfoGrid, codeGrid, myDp, t;

		$(function() {

			$('#mainLayout').css('height', ($(document).height() - 160) + "px");

			if(window.attachEvent) window.attachEvent("onresize",resizeLayout);
			else window.addEventListener("resize",resizeLayout, false);

			dhxLayout = new dhtmlXLayoutObject({
				parent: "mainLayout",
				pattern: "2U",
				skin: "${dhtmlXSkin}",
				cells: [{ id: 'a', text: '영문구분', width: 500 }, { id: 'b', text: '영문목록' }]
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
			codeInfoGrid.init();
			codeInfoGrid_load();

			codeGrid = dhxLayout.cells("b").attachGrid();
			codeGrid.setImagePath("${dhtmlXImagePath}");
			codeGrid.setHeader("한글,영문", null, grid_head_center_bold);
			codeGrid.setColumnIds("codeDisp,codeDispEng");
			codeGrid.setInitWidths("250,*");
			codeGrid.setColAlign("left,left");
			codeGrid.setColTypes("ed,ed");
			codeGrid.setColSorting("str,str");
			codeGrid.init();

			myDp = new dataProcessor('codeEngCUD.do');
			myDp.init(codeGrid);
			myDp.setTransactionMode("POST", false);
			myDp.setUpdateMode("on");
			myDp.enableDataNames(true);
			myDp.setVerificator(1, myGRID_not_empty);
			myDp.attachEvent("onFullSync", function() {
				codeGrid.clearAndLoad('codeEngDetailList.do?gubun=' + codeInfoGrid.getSelectedRowId());
			});
			myDp.attachEvent("onValidatationError", function(id, messages) {
				alert(messages.join("\n"));
				return true;
			});
		});

		function codeInfoGrid_load() {
			doBeforeGridLoad();
			codeInfoGrid.clearAndLoad('codeEngInfoList.do', doOnGridLoaded);
		}

		function doOnRowSelected(id) {
			codeGrid.clearAndLoad('codeEngDetailList.do?gubun=' + id);
		}

		function reLoding() {
			doBeforeGridLoad()
			$.ajax({
				url: '${contextPath}/user/engLoad.do',
				dataType: 'xml'
			}).done(function(data) {
				$(data).find('result').each(function(i) {
					if($(this).find('code').text() == '001') {
						alert($(this).find('msg').text());
					}
				});
				doOnGridLoaded();
			});
		}

		function save() {
			myDp.sendData();
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
		<h3>다국어설정</h3>
	</div>
	<!-- Main Content -->
	<div class="contents_box">
		<!-- START 탑 툴바 -->
		<div class="top_toolbar" style="height: 25px;">
			<div class="top_toolbar_ttl"></div>
			<div class="top_toolbar_btn">
				<div style="float: right;margin-right: 10px;"><a href="javascript:void(0);" onclick="reLoding();">코드갱신</a></div>
				<div style="float: right;margin-right: 10px;"><a href="javascript:void(0);" onclick="save();">저장</a></div>
			</div>
		</div>
		<!-- END 탑 툴바 -->
		<div id="mainLayout" style="width: 100%;height: 100%;"></div>
	</div>
</body>
</html>