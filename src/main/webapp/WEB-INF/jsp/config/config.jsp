<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/pageInit.jsp" %>
<html>
<head>
	<script type="text/javascript">
		var dhxLayout, ridForm, armForm, t;

		$(function() {

			if(window.attachEvent) window.attachEvent('onresize',resizeLayout);
			else window.addEventListener('resize',resizeLayout, false);

			dhxLayout = new dhtmlXLayoutObject({
				parent: 'layoutObj',
				pattern: '2U',
				skin: '${dhtmlXSkin}',
				cells: [{ id: 'a', text: 'Researcher ID 설정' }, { id: 'b', text: 'AMR 설정' }]
			});

			ridForm = dhxLayout.cells('a').attachForm([
   				{type: 'settings', position: 'label-left', labelWidth: 200, inputWidth: 300, offsetLeft: 5},
				{type: 'block', inputWidth: 'auto', offsetTop: 12, list: [
					{type: 'hidden', name: 'gubun', value: 'RID'},
					{type: 'label', label: '접속정보', offsetLeft: 0},
					{type: 'input', label: '${ridConfig.idInfo.codeName}', name: 'id', value: '${ridConfig.idInfo.codeDisp}'},
					{type: 'input', label: '${ridConfig.passwordInfo.codeName}', name: 'password', value: '${ridConfig.passwordInfo.codeDisp}'},
					{type: 'label', label: '관리자 설정', offsetLeft: 0},
					{type: 'input', label: '${ridConfig.firstNmInfo.codeName}', name: 'firstNm', value: '${ridConfig.firstNmInfo.codeDisp}'},
					{type: 'input', label: '${ridConfig.lastNmInfo.codeName}', name: 'lastNm', value: '${ridConfig.lastNmInfo.codeDisp}'},
					{type: 'input', label: '${ridConfig.emailInfo.codeName}', name: 'email', value: '${ridConfig.emailInfo.codeDisp}'},
					{type: 'input', label: '${ridConfig.emailCcInfo.codeName}', name: 'emailCc', value: '${ridConfig.emailCcInfo.codeDisp}'},
					{type: "combo", label: "${ridConfig.resmailInfo.codeName}", name: 'resmail', options: [
		   				{value: "true", text: "동의", selected: '${ridConfig.resmailInfo.codeDisp == "true" ? "true" : "false"}'},
		   				{value: "false", text: "동의하지 않음", selected: '${ridConfig.resmailInfo.codeDisp == "false" ? "true" : "false"}'}
		   			]},
					{type: 'button', value: '저장', name: 'save'}
				]}
			]);

			ridForm.attachEvent('onButtonClick', function(id){
				if(id == 'save') {
					doBeforeGridLoad('a');
					ridForm.send("updateConfig.do", function(loader, response){
						$(response).find('result').each(function(i) {
							if($(this).find('code').text() == '001') {
								alert($(this).find('msg').text());
							}
						});
						doOnGridLoaded('a');
					});
				}
			});

			armForm = dhxLayout.cells('b').attachForm([
   				{type: 'settings', position: 'label-left', labelWidth: 200, inputWidth: 300, offsetLeft: 5},
				{type: 'block', inputWidth: 'auto', offsetTop: 12, list: [
					{type: 'hidden', name: 'gubun', value: 'AMR'},
					{type: 'label', label: '관리자 설정', offsetLeft: 0},
					{type: 'input', label: '${amrConfig.firstNmInfo.codeName}', name: 'firstNm', value: '${amrConfig.firstNmInfo.codeDisp}'},
					{type: 'input', label: '${amrConfig.lastNmInfo.codeName}', name: 'lastNm', value: '${amrConfig.lastNmInfo.codeDisp}'},
					{type: 'input', label: '${amrConfig.emailInfo.codeName}', name: 'email', value: '${amrConfig.emailInfo.codeDisp}'},
					{type: 'input', label: '${amrConfig.emailCcInfo.codeName}', name: 'emailCc', value: '${amrConfig.emailCcInfo.codeDisp}'},
					{type: "combo", label: "${amrConfig.resmailInfo.codeName}", name: 'resmail', options: [
		   				{value: "true", text: "동의", selected: '${ridConfig.resmailInfo.codeDisp == "true" ? "true" : "false"}'},
		   				{value: "false", text: "동의하지 않음", selected: '${ridConfig.resmailInfo.codeDisp == "false" ? "true" : "false"}'}
		   			]},
					{type: 'button', value: '저장', name: 'save', align:'right'}
				]}
			]);

			armForm.attachEvent('onButtonClick', function(id){
				if(id == 'save') {
					doBeforeGridLoad('b');
					armForm.send("updateConfig.do", function(loader, response){
						$(response).find('result').each(function(i) {
							if($(this).find('code').text() == '001') {
								alert($(this).find('msg').text());
							}
						});
						doOnGridLoaded('b');
					});
				}
			});

			$('.dhxform_txt_label2, .dhxform_btn').parent().css({ borderBottom: '1px dashed #ccc', marginRight: '10px' });
			$('.dhxform_btn').css({ marginTop: '20px' });
			$('.dhxform_base, .dhxform_block').css({width: '100%'});

		});

		function resizeLayout() { window.clearTimeout(t); t = window.setTimeout(function(){ dhxLayout.setSizes(false); }, 200); }
		function doBeforeGridLoad(cell) { dhxLayout.cells(cell).progressOn(); }
		function doOnGridLoaded(cell) { setTimeout(function() { dhxLayout.cells(cell).progressOff(); }, 100); }

	</script>
</head>
<body>
	<!-- Page Title -->
	<div class="title_box">
		<h3><spring:message code='menu.variables'/></h3>
	</div>
	<!-- Main Content -->
	<div class="contents_box">
		<div id="layoutObj" style="width: 100%; height: 450px;"></div>
	</div>
</body>
</html>