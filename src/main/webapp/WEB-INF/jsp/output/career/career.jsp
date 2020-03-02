<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="kr.co.argonet.r2rims.core.comment.CommentConfiguration"%>
<%@page import="org.apache.commons.lang3.ObjectUtils"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="cache-Control" content="co-cache" />
<title>${sysConf['system.rss.jsp.title']}</title>
<%@include file="../../pageInit.jsp" %>
<link type="text/css" href="${contextPath}/css/layout.css" rel="stylesheet" />
<link type="text/css" href="${contextPath}/js/dhtmlx/skins/${sysConf['dhtmlx.skin']}/dhtmlx.css" rel="stylesheet" />
<style type="text/css">
.dhxwins_vp_dhx_terrace {overflow: auto;}
.dhxwins_vp_dhx_terrace div.dhxwin_active div.dhx_cell_wins div.dhx_cell_toolbar_def, .dhxwins_vp_dhx_terrace div.dhxwin_inactive div.dhx_cell_wins div.dhx_cell_toolbar_def { padding: 10px 0px 0; }
.dhx_toolbar_dhx_terrace { padding: 0 0px; }
</style>
<script type="text/javascript" src="${contextPath}/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="${contextPath}/js/jquery/jquery-ui.min.js"></script>
<script type="text/javascript" src="${contextPath}/js/dhtmlx/dhtmlx.js"></script>
<script type="text/javascript" src="${contextPath}/js/script.js"></script>
</head>
<body style="overflow-y: auto;">
	<form name="popFrm" id="popFrm" method="post">
		<input type="hidden" name="careerId" id="popCareerId"/>
	</form>
	<div class="popup_wrap">
		<div class="title_box">
			<h3><spring:message code='menu.career'/></h3>
		</div>
		<div class="top_help_wrap">
			<div class="help_text" style="display: none;">
				<spring:message code="comment.carr"/>
			</div>
			<p class="help_bt_box">
				<a href="#" class="help_link">Help</a>
				<a href="#" class="help_bt_r help_open">도움말 열기/닫기</a>
			</p>
		</div>
		<div class="list_bt_area">
			<span class="et_text"><spring:message code="common.mandatory.field"/></span>
			<div class="list_set">
				<ul>
					<c:if test="${sessionScope.auth.CAR gt 1 }">
						<li id="fnSave" class="first_li"><a href="javascript:fn_save();" class="list_icon02"><spring:message code='common.button.save'/></a></li>
					<c:if test="${not empty careerId}">
						<c:if test="${sessMode or (sessionScope.auth.adminDvsCd eq 'R' or  sessionScope.auth.adminDvsCd eq 'S' )}">
						<li id="newBtn"><a href="javascript:fn_new();" class="list_icon12"><spring:message code='common.button.new'/></a></li>
						</c:if>
						<li id="delBtn"><a href="javascript:fn_delete();" class="list_icon10"><spring:message code='common.button.delete'/></a></li>
					</c:if>
					</c:if>
				</ul>
			</div>
		<c:if test="${not empty careerId}">
		<div class="top_mn_box">
			<a href="#" onclick="javascript:loadPrevRow();" class="mn_arrow_bt mn_prev">이전</a>
			<div class="mn_text">
				<spring:message code='common.mng.no'/><strong>${careerId}</strong>
			</div>
			<a href="#" onclick="javascript:loadNextRow()" class="mn_arrow_bt mn_next">다음</a>
		</div>
		</c:if>
		</div>
		<div id="formObj"></div>
	</div>
</body>

<script type="text/javascript">

	$(function(){
		window.focus();
	    $(".help_bt_r").click(function(){ $(".help_text").slideToggle(500); $(".help_bt_r").toggleClass("help_open"); });
	    if("<c:out value="${param.reload}"/>" == 'true') window.opener.myGrid_load();
	});

	var careerId = '${careerId}';

	if(careerId) {
		$.ajax({
			url: '${contextPath}/${preUrl}/career/modifyForm.do',
			data: {'careerId' : careerId}
		}).done(function(data) {
			$('#formObj').html(data);
			var src = $('#formObj').find('input[name="src"]').val();
			if(src && src == 'ERP') {
				$('#fnSave').hide();
				$('#fnDelete').hide();
			}
		});
	}
	else {
		$.ajax({
			url: '${contextPath}/${preUrl}/career/addForm.do'
		}).done(function(data) {
			$('#formObj').html(data);
			$('#fnDelete').hide();
			$('.top_mn_box').remove();
			$('#fnSave').show();
		});
	}

	function loadPrevRow(){
		window.opener.prevRow();
	}

	function loadNextRow(){
		window.opener.nextRow();
	}

	function alertLastRow(){
		dhtmlx.alert({type:"alert-warning",text:"마지막 입니다.",callback:function(){}});
	}

	function alertFirstRow(){
		dhtmlx.alert({type:"alert-warning",text:"맨 처음입니다.",callback:function(){}});
	}

	function fn_new() {
		$.ajax({
			url: "${contextPath}/${preUrl}/career/addForm.do",
		}).done(function(data){
			$('#formObj').html(data);
			$('#fnDelete').hide();
			$('#fnSave').show();
		});
	}

	function fn_delete() {
		dhtmlx.confirm({
			title: '경력사항 삭제', text: '삭제 하시겠습니까?', ok: 'Yes', cancel: 'No',
			callback:function(result){
				if(result == true) {
					$.ajax({
						url: '${contextPath}/career/removeCareer.do',
						data: $('#removeFormArea').serialize()
					}).done(function(data) {
						if(data == 1) {
							opener.myGrid_load();
							self.close();
						}
					});
				}
			}
		});
	}

	function fn_save() {
		if(true) {
			if(validation()) {
				$('#formArea').submit();
			}
			else {
				dhtmlx.alert({type: 'alert-warning', text: '필수항목이 누락되었습니다.<br/>입력 후 저장하여 주세요.', callback:function(){focusRequired();}})
				return;
			}
		}
		else {
			dhtmlx.alert({type: 'alert-warning', text: '변경된 내용이 없습니다.', callback:function(){}})
			return;
		}
	}

</script>