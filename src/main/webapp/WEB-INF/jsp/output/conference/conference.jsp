<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.argonet.r2rims.util.LanguageUtil"%>
<%@ page import="org.apache.commons.lang3.ObjectUtils"%>
<%@ page import="kr.co.argonet.r2rims.core.comment.CommentConfiguration"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="cache-Control" content="co-cache" />
<title>${sysConf['system.rims.jsp.title']}</title>
<%@include file="../../pageInit.jsp" %>
<link type="text/css" href="<c:url value="/css/layout.css"/>" rel="stylesheet" />
<link type="text/css" href="<c:url value="/js/dhtmlx/skins/${sysConf['dhtmlx.skin']}/dhtmlx.css"/>" rel="stylesheet" />
<style type="text/css">
.dhxwins_vp_dhx_terrace {overflow: auto;}
.dhxwins_vp_dhx_terrace div.dhxwin_active div.dhx_cell_wins div.dhx_cell_toolbar_def, .dhxwins_vp_dhx_terrace div.dhxwin_inactive div.dhx_cell_wins div.dhx_cell_toolbar_def { padding: 10px 0px 0; }
.dhx_toolbar_dhx_terrace { padding: 0 0px; }
.labelHelp { position: absolute; color: #afafaf; padding: 2px; line-height: 160%; cursor: text; display: block;}
.upload_file_text { border-bottom: 0px; padding: 0 0 0 0; margin-bottom: 0px;}
.in_tbl td {border-bottom: 0px !important; padding: 5px 5px !important;}
</style>
<script type="text/javascript" src="<c:url value="/js/jquery/jquery-1.11.3.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jquery/jquery-ui.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jquery/jquery.modal.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/dhtmlx/dhtmlx.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/script.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/output/conference.js"/>?t=20200123"></script>
</head>
<body style="overflow-y: auto;">
<form name="popFrm" id="popFrm" method="post">
	<input type="hidden" name="conferenceId" id="popConferenceId"/>
</form>
<div id="modal_area" class="overlay" style="display: none;"></div>
<div class="popup_wrap">
<div class="title_box">
	<h3><spring:message code='main.con'/></h3>
</div>
<div class="top_help_wrap">
	<div class="help_text" style="display: none;">
		<spring:message code="comment.con"/>
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
			<c:if test="${sessionScope.auth.CON gt 1 }">
				<li class="first_li"><a href="javascript:fn_save();" class="list_icon02"><spring:message code='common.button.save'/></a></li>
				<c:if test="${not empty conferenceId}">
				<li id="newBtn"><a href="javascript:fn_new();" class="list_icon12"><spring:message code='common.button.new'/></a></li>
				<li id="delBtn"><a href="javascript:fn_delete();" class="list_icon10"><spring:message code='common.button.delete'/></a></li>
				</c:if>
			</c:if>
			<c:if test="${not empty conferenceId and (sessMode or (sessionScope.auth.adminDvsCd eq 'R' or  sessionScope.auth.adminDvsCd eq 'S' ))}">
			<li id="reqBtn">
				<a href="#requestDialog" class="modalLink list_icon09" onclick="$('#requestCn').val('');$('.requestSe').prop('checked',false);$('#requestSeCd_3').prop('checked',true);" ><spring:message code="common.report.error"/></a>
			</li>
			</c:if>
		</ul>
	</div>

	<c:if test="${not empty conferenceId}">
	<div class="top_mn_box">
		<a href="#" onclick="javascript:loadPrevRow();" class="mn_arrow_bt mn_prev">이전</a>
		<div class="mn_text">
			<spring:message code='common.mng.no'/><strong>${conferenceId}</strong>
		</div>
		<a href="#" onclick="javascript:loadNextRow()" class="mn_arrow_bt mn_next">다음</a>
	</div>
	</c:if>

</div>
<div id="formObj"></div>
</div>
<script type="text/javascript">
var conferenceId = '${conferenceId}';
if(conferenceId)
  $.post("<c:url value="/${preUrl}/conference/modifyForm.do"/>", {"conferenceId": conferenceId},null,'text').done(function(data){$('#formObj').html(data);});
else
  $.post("<c:url value="/${preUrl}/conference/addForm.do"/>", null,null,'text').done(function(data){$('#formObj').html(data);});

$(document).ready(function(){
	bindModalLink();
	$('.list_bt_area .list_set ul li').eq(0).addClass('first_li')
	$(".help_bt_r").off('click').click(function(){ $(".help_text").slideToggle(250); $(".help_bt_r").toggleClass("help_open"); });
	if("<c:out value="${param.reload}"/>" == 'true') window.opener.myGrid_load();
});

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

function fn_new(){
	if(isChange) // 변경사항이 있는지 체크
	{
		dhtmlx.confirm({title:"수정된데이터처리", ok:"예", cancel:"아니오", text:"수정된 항목이 있습니다.<br/> 저장하시겠습니까?",
			callback:function(result){
				if(result == true) fn_save();
				else if(result == false) loadAddFormData();
			}
		});
	}
	else
	{
		loadAddFormData();
	}
}

function loadAddFormData(){
	$.post("<c:url value="/${preUrl}/conference/addForm.do"/>", null,null,'text').done(function(data){
		$('#newBtn').remove();
		$('#delBtn').remove();
		$('#reqBtn').remove();
		$('.top_mn_box').remove();
		$('#formObj').html(data);
	});
}

function fn_delete(){
	dhtmlx.confirm({
		title:"학술활동 삭제",
		ok:"Yes", cancel:"No",
		text:"삭제 하시겠습니까?",
		callback:function(result){
			if(result){
				$.ajax({
					url:'<c:url value="/conference/removeConference.do"/>',
					data: $('#removeFormArea').serialize()
				}).done(function(data){
					if(data == 1)
					{
						dhtmlx.alert({type:"alert-warning",text:"삭제되었습니다. <br/> 창을 닫습니다.",callback:function(){
							opener.myGrid_load();
							top.window.close();
						}});
					}
				});
			}
			else return;
		}
	});
}

function fn_save(){
	if(isChange) // 변경사항이 있는지 체크
	{
		if(validation()){ // 필수입력사항 체크

			//1. 최소 1명 이상 맵핑?
			var mappingAuthrCount = 0;
			$('input[name="prtcpntId"]').each(function(index){  if($(this).val() != '') mappingAuthrCount++ });
			if(mappingAuthrCount == 0)
			{
				dhtmlx.alert({type:"alert-warning",text:"학술대회에 참여한 연구자 사번을 입력하세요.<br/>(최소1명 이상)",callback:function(){}});
				return;
			}

			//2. 관련연구과제 필수입력 체크
			if(loginAuthor == 'R' || loginAuthor == 'S') // 연구자,대리입력자 에게만 필수
			{
				var relateFundingAt = $('#relateFundingAt').prop('checked');

				var fundCount = 0;
				$('input[name="sbjtNo"]').each(function(index){  if($(this).val() != '') fundCount++ });
				if(!relateFundingAt && fundCount == 0)
				{
					dhtmlx.alert({type:"alert-warning",text:"<spring:message code='win.per.alert04'/>",callback:function(){
						$('input[name="sbjtNo"]').each(function(index){  if($(this).val() == '') $(this).css('background-color','#FFCC66') });
					}});
					return;
				}
				else
				{
					dplctCheckAfterSubmit();
				}
			}
			else
			{
				dplctCheckAfterSubmit();
			}
		}
		else
		{
			dhtmlx.alert({type:"alert-warning",text:"필수항목이 누락되었습니다.<br/>입력 후 저장하여 주세요.",callback:function(){focusRequired();}})
			return;
		}
	}
	else
	{
		dhtmlx.alert({type:"alert-warning",text:"변경된 내용이 없습니다.",callback:function(){}})
		return;
	}
}

//3.중복학술대회체크(신규입력일때)
function dplctCheckAfterSubmit(){
	var frmAction = $('#formArea').prop('action');
	frmAction = frmAction.substr(frmAction.lastIndexOf('/')+1);
	if("addConference.do" == frmAction) //신규입력인 경우에만 체크
	{
		var checkUrl = '<c:url value="/conference/dplctConferenceCheck.do?"/>'+$('#formArea').serialize() ;
		$.get(checkUrl, null, null, 'json').done(function(data){
			if(data.dplctAt == 'true')
			{
				dhtmlx.confirm({title:"중복논문유무", ok:"예", cancel:"아니오", text:"<spring:message code='win.per.dup01'/>",
					callback:function(result){
						if(result == true) authrCheckAfterSubmit();
						else if(result == false)
						{
							dhtmlx.alert({type:"alert-warning",text:"<spring:message code='win.per.dup02'/>",callback:function(){
								$('input:checkbox[name="srchTrget"]').prop('checked',false);
								$('#srchTrget_RIMS').prop('checked',true);
								$('#srchAncmYear').val($('#ancmYear').val());
								onFocusHelp('srchKeyword');;
								$('#srchKeyword').val($('#orgLangPprNm').val());
								srchCnfrnc();
								return;
							}});
						}
					}
				});
			}
			else
			{
				authrCheckAfterSubmit();
			}
		});
	}
	else
	{
		authrCheckAfterSubmit();
	}
}

//4.전체저자수와 참여자Row수 비교
function authrCheckAfterSubmit(){
	var authrRowCount = 0;
	$('input[name="prtcpntNm"]').each(function(index){  if($(this).val() != '') authrRowCount++ });
	var totalAuthrCount = $('#totalAthrCnt').val();
	if(totalAuthrCount == '')
	{
		$('#totalAthrCnt').val(authrRowCount);
		userCheckAfterSubmit();
	}
	else if(totalAuthrCount != authrRowCount)
	{
		dhtmlx.confirm({
			title:"저자확인",
			ok:"예", cancel:"아니오",
			text:"<spring:message code='win.per.alert02'/>",
			callback:function(result){
				if(result)
				{
					$('#totalAthrCnt').val(authrRowCount);
					userCheckAfterSubmit();
				}
				else
				{
					userCheckAfterSubmit();
				}
			}
		});
	}
	else
	{
		userCheckAfterSubmit();
	}
}

function userCheckAfterSubmit(){
	userCheck();
	$('#formArea').submit();
}

function fn_request(){
	var requestSeCdValue = $('input:radio[name="requestSeCd"]:checked').val();
	if(requestSeCdValue == '3' && $('#requestCn').val() == '')
	{
		dhtmlx.alert({type:"alert-warning",text:"요청내용을 입력하세요.",callback:function(){ $('#requestCn').focus();}});
		return;
	}
	// 기타 정정사항 입력시 요청내용 필수
	$.post('<c:url value="/request/addRequest.do"/>', $('#requestForm').serializeArray(),null,'text').done(function(data){
		if(data == '1'){
			dhtmlx.alert({type:"alert-warning",text:"정상적으로 요청되었습니다.",callback:function(){$('#closeBtn').triggerHandler('click');}});
			<c:if test="${sysConf['mail.use.req.at'] eq 'Y'}">
			fn_sendReqeustMail();
			</c:if>
		}else {
			dhtmlx.alert({
				type: "alert-warning", text: "요청이 실패하였습니다. <br/>관리자에게 문의하세요.", callback: function () {
					$('#closeBtn').triggerHandler('click');
				}
			});
		}
	});
}

function fn_sendReqeustMail(){
	$.post( "<c:url value="/mail/findTemplates.do"/>", {'jobGubun':'ERR_REPORT'},null,'json').done(function(data){
		var template = data[0];

		if(template){
			var userNm = "<c:out value="${sessionScope.login_user.korNm}"/>";
			var groupDept = "<c:out value="${sessionScope.login_user.groupDept}"/>";
			var gubun = "<c:out value="${sessionScope.login_user.gubun}"/>";
			gubun = (gubun == "M" ? "전임" : gubun == "U" ? "비전임" : gubun == "S" ? "학생" : "");
			var dvsCd = "<c:out value="${sessionScope.login_user.adminDvsCd}"/>";
			dvsCd = (dvsCd == "S" ? "대리입력자" : dvsCd == "R" ? "연구자" : dvsCd == "M" ? "관리자" : dvsCd == "D" ? "학과(부)관리자"
					: dvsCd == "C" ? "단과대관리자" : dvsCd == "U" ? "유저" : dvsCd == "T" ? "트랙관리자" : dvsCd == "V" ? "열람자" : dvsCd == "P" ? "성과관리자" : "");

			var trgetNm = "<c:out value="${sessionScope.sess_user.korNm}"/>";
			var trgetId = "<c:out value="${sessionScope.sess_user.userId}"/>";

			var reqeustSeCd = $('input[name="requestSeCd"]:checked').val();

			var title = template.title;
			var content = template.contents.toString();

			content = content.replace("{current_date}", getCurrentDate());
			content = content.replace("{request_user_nm}", userNm);
			content = content.replace("{request_user_dept}", groupDept);
			content = content.replace("{request_user_type}", gubun);
			content = content.replace("{request_date}", getCurrentDate());
			content = content.replace("{request_user_dvsCd}", dvsCd);
			content = content.replace("{request_trget_nm}", trgetNm);
			content = content.replace("{request_trget_id}", trgetId);
			content = content.replace("{trget_rslt_nm}", $("#cfrcNm").val());
			content = content.replace("{trget_rslt_type}", $("#trgetRsltType").val());
			content = content.replace("{trget_rslt_id}", $("#trgetRsltId").val());
			content = content.replace("{request_se_cd}", (reqeustSeCd == "1" ? "중복" : reqeustSeCd == "2" ? "본인성과아님" : "기타"));
			content = content.replace("{request_cn}", $("#requestCn").val());

			var $emailForm = $('<form></form>');
			var $emailTitle = $('<input type="hidden" name="emailTitle" value="'+title+'">');
			var $emailContents = $('<input type="hidden" name="emailContents">');
			$emailContents.val(content);

			$emailForm.append($emailTitle);
			$emailForm.append($emailContents);

			fn_postSendAdminMail($emailForm);
		}
	});
}

function fn_postSendAdminMail($emailForm) {
	$.post('<c:url value="/mail/sendAdminMail.do"/>', $($emailForm).serializeArray(), null, 'json').done(function (data) {});
}
</script>
<div id="requestDialog" class="popup_box modal modal_layer" style="width: 450px;height:360px; display: none;">
<form id="requestForm">
	<input type="hidden" name="trgetRsltType" id="trgetRsltType" value="conference"/>
	<input type="hidden" name="trgetRsltId" id="trgetRsltId" value="${conferenceId}"/>
	<div class="popup_header">
		<h3><spring:message code='con.com.pop8'/></h3>
		<a href="#" id="closeBtn" class="close_bt closeBtn">닫기</a>
	</div>
	<div class="popup_inner">
		<table class="write_tbl mgb_20">
			<colgroup>
				<col style="width:80px;">
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th><spring:message code='con.com.pop9'/></th>
					<td>
						<input type="radio" id="requestSeCd_1" name="requestSeCd" class="requestSe" value="1" />&nbsp;<spring:message code='con.com.pop4'/>
						<br/><br/>
						<input type="radio" id="requestSeCd_2" name="requestSeCd" class="requestSe" value="2" />&nbsp;<spring:message code='con.com.pop6'/>
						<br/><br/>
						<input type="radio" id="requestSeCd_3" name="requestSeCd" class="requestSe" value="3" checked="checked"/>&nbsp;<spring:message code='con.com.pop5'/>
					</td>
				</tr>
				<tr>
					<th><spring:message code='con.com.pop3'/></th>
					<td>
						<div class="tbl_textarea">
							<textarea name="requestCn" id="requestCn" maxLength="4000" rows="4">${request.tretResultCn}</textarea>
						</div>
					</td>
				</tr>
				<tr>
					<td colspan="2" style="border-bottom: 0px solid #b1b1b1;"><spring:message code='con.com.pop7'/></td>
				</tr>
			</tbody>
		</table>
		<div class="list_set">
			<ul>
				<li><a href="javascript:fn_request();" class="list_icon16"><spring:message code="common.button.request"/></a></li>
				<li><a href="javascript:void(0);" onclick="$('#requestDialog .close_bt').triggerHandler('click');" class="list_icon10"><spring:message code="common.button.cancel"/></a></li>
			</ul>
		</div>
	</div>
</form>
</div>
</body>
