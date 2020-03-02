<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="cache-Control" content="co-cache" />
<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=yes" />
<title>${sysConf['system.rims.jsp.title']}</title>
<%@include file="../pageInit.jsp" %>
	<%--	--%>
	<link rel="stylesheet" type="text/css" href="<c:url value="/share/css/layout.css"/>"/>
	<link rel="stylesheet" type="text/css" href="<c:url value="/share/css/bootstrap.min.css"/>"/>
	<%--	--%>
<link type="text/css" href="<c:url value="/css/layout.css"/>" rel="stylesheet" />
<link type="text/css" href="<c:url value="/js/dhtmlx/skins/${sysConf['dhtmlx.skin']}/dhtmlx.css"/>" rel="stylesheet" />
<link type="text/css" href="<c:url value="/js/dhtmlx/skins/${sysConf['dhtmlx.skin']}/dhtmlxvault.css"/>" rel="stylesheet" />
<link type="text/css" href="<c:url value="/css/summernote/summernote-lite.css"/>" rel="stylesheet" />
<style type="text/css">
.dhxwins_vp_dhx_terrace {overflow-y: auto;}
.dhxwins_vp_dhx_terrace div.dhxwin_active div.dhx_cell_wins div.dhx_cell_toolbar_def, .dhxwins_vp_dhx_terrace div.dhxwin_inactive div.dhx_cell_wins div.dhx_cell_toolbar_def { padding: 10px 0px 0; }
.dhx_toolbar_dhx_terrace { padding: 0 0px; }
.in_tbl td {border-bottom: 0px !important; padding: 5px 5px !important;}
/*.write_tbl tbody th {padding: 5px 12px;}*/
.write_tbl tbody td {padding: 5px 10px;}
.popup_wrap{padding: 20px 40px 20px 40px;}
.dhx_toolbar_dhx_terrace div.dhx_toolbar_btn div.dhxtoolbar_text {padding: 0; margin: 4px 5px;}
div#winVp {position: inherit; height: 100%;}

a { color: #555; text-decoration: none; }
.keyword_span  { background:#3c6382; display: inline-block; border:1px solid #d5d5d5; padding: 0 15px; line-height: 24px; border-radius: 12px;  margin-top: 10px; margin-right: 5px;}
.keyword_span a { color:#ffffff; font-size:13px; }
.keyword_close {margin-left: 5px;border:0;background:#3c6382;cursor:pointer;color:#ffffff;}
.view_title {font-size: 20px;color: #222;margin-bottom: 14px;padding-bottom: 14px;border-bottom:1px solid #d8d8d8;}
.abstract_box {  border-bottom: 1px dashed #ddd; padding-bottom: 20px; margin-bottom: 26px; }
.abstract_box dt { font-size: 16px; color: #222; margin-bottom: 10px;  font-weight: bold;padding: 0 0 0 16px; background: url(<c:url value="/share/img/background/view_bullet02.png"/>) no-repeat 0 5px; }
.abstract_box dd {  line-height: 28px;  }
.view_info_wrap {     position: relative; overflow: hidden;  }
.view_info_wrap:after  { content: ''; display: block; clear: both; }
.view_dl  { overflow: hidden; margin-bottom: 28px;}
.view_dl:after  { content: ''; display: block; clear: both; }
.view_dl  dt  { float: left; font-size: 16px; color: #222; font-weight: bold; padding: 0 0 0 16px;  background: url(<c:url value="/share/img/background/view_bullet02.png"/>) no-repeat 0 5px;   }
.view_dl  dd {margin: 0 0 0 220px;}
.view_dl .keyword_dd span  {  display: inline-block; border:1px solid #d5d5d5; padding: 0 15px; line-height: 24px; border-radius: 12px;  margin-bottom: 5px}

.labImg {width : 285px;}

.del_file {background: url(<c:url value="/images/background/red_del_icon02.png" />) no-repeat 50% 0;display: inline-block;font-size: 11px;color: #000;margin: 0 0 0 2px;text-indent: -99999px;width:18px;height: 13px;vertical-align: top;}

.list_icon19 {margin-top: 3px; margin-bottom: 3px;}
.list_icon12 {	display: inline-block;	padding: 0 14px 0 28px;	line-height: 25px;	border: 1px solid #625959;	height: 25px;	color: #fff;	overflow: visible; cursor:pointer;}
.list_set li {margin-top: 3px; margin-bottom: 3px;}
.note-editor .note-editable {
	font-size: 14px;
}
label{
    font-weight: 100;
}
h3{
    font-size: 14px;
}
.youtube_input::placeholder{
	color:#cccccc;
}
.youtube_input:-ms-input-placeholder{
	color:#cccccc !important;
}

#faqItem .input_type::placeholder{
	color:#cccccc;
}
#faqItem .input_type:-ms-input-placeholder{
	color:#cccccc !important;
}
body::-webkit-scrollbar {display: none;}
</style>
<script type="text/javascript" src="<c:url value="/js/jquery/jquery-1.11.3.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jquery/jquery-ui.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jquery/jquery.modal.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jquery/jquery.cookie-1.4.1.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/dhtmlx/dhtmlx.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/dhtmlx/vault/dhtmlxvault.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/script.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/summernote/summernote-lite.js"/>"></script>

<!-- Owl Carousel Assets -->
<link href="<c:url value="/share/css/owl.carousel.css"/>?ver=2.3.3" rel="stylesheet">
<link href="<c:url value="/share/css/owl.theme.css"/>?ver=2.3.3" rel="stylesheet">
<script src="<c:url value="/share/js/owl.carousel.min.js"/>?ver=2.3.3"></script>
	<style type="text/css">
		.preview_box{
			top: 0 !important;
			bottom: 0 !important;
			left: 0 !important;
			right: 0 !important;
			margin: auto !important;
			position: absolute !important;
		}
	</style>
</head>
<body style="overflow-y: auto;">
<div id="modal_area" class="overlay" style="display: none;"></div>
	<div id="labPreviewDialog" class="sub_container popup_box modal modal_layer preview_box" style="padding: 0px 0 46px 0; width: 98%; height:80%; display: none;">
        <div class="popup_header">
            <h3>미리 보기</h3>
            <a href="#" id="closeBtn" class="close_bt closeBtn">닫기</a>
        </div>
		<div style="overflow-y: scroll; padding-left: 2%; padding-right: 2%;padding-top: 20px;height: 100%;">
	<%--	Modal 코드 작성--%>
		<h3 class="result_title" style="margin-bottom: 10px;"><spring:message code="disc.lab.lab.title"/>
			<a href="javascript:history.go(-1);" class="prev_bt" style="float:right;font-size:14px;color: #555;font-weight: normal;"><spring:message code="disc.anls.toprf.article.prev"/></a>
		</h3>
		<div class="lab_view_wrap">
			<div class="lab_left_slide" style="width: 49%;">
				<div id="lab_view_slide" class="owl-carousel owl-theme">
				</div>
				<div class="researcher_bottom_box">
					<div class="r_m_box">
						<div class="researcher_info_box">
							<span class="r_img_b"><img src="<c:url value="/servlet/image/profile.do?fileid=${labVo.profPhotoFileId}"/>"/></span>
							<p>연구자
								<span>(연구자)</span>
								<em>학과</em>
							</p>
						</div>
					</div>
					<div class="r_m_link_box">
						<div class="row">
							<div class="r_m_col">
								<div class="r_m_link r_m_home"><a href="javascript:void(0);"><span>Homepage</span></a></div>
							</div>
							<div class="r_m_col">
								<div class="r_m_link r_m_email"><a href="javascript:void(0);"><span>e-Mail</span></a></div>
							</div>
							<div class="r_m_col">
								<div class="r_m_link r_m_profile"><a href="javascript:void(0);"/>"><span>Profile</span></a></div>
							</div>
							<div class="r_m_col">
								<div class="r_m_link r_m_faq"><a href="javascript:void(0);"><span>FAQ</span></a></div>
							</div>
						</div>
					</div>
				</div>
			</div><!-- 연구실 이미지 슬라이드 : e -->

			<div class="lab_right_info" style="width: 49%; margin: 0;">
				<div class="lab_view_title">
                    <p><em>연구실</em>Name</p>
				</div>
				<div class="modal_lab_intro_t lab_intro_t">
					<div class="lab_intro_area" style="height: 224px;">
					</div>
					<a href="javascript:toggleIntrcn()" class="view_t_more">더보기</a>
				</div>
				<div class="view_keyword modal_keyword" style="margin-top: 10px;">
					<div class="keyword_title_box">
						<h4>Keyword</h4>
						<div class="keyword_help_b">
							<a href="javascript:void(0);" onclick="toggleKeywordHelp();" class="k_help_icon">Keyword 도움말</a>
							<div class="k_help_view" style="display:none;"><p>키워드를 클릭하면 해당 키워드로 검색된 정보를 보실 수 있습니다.</p></div><!-- 도움말 부분 -->
						</div>
					</div>
					<ul class="keyword_list_box">
					</ul>
				</div>
			</div>
		</div>
        <div class="tab_wrap w_20">
            <ul>
                <li><a id="main_article" href="javascript:tabClick('main_article')" style="text-align: center; width: 100%;">Main Article</a></li>
                <li><a id="main_conference" href="javascript:tabClick('main_conference')" style="text-align: center; width: 100%;">Main Conference</a></li>
                <li><a id="latest_patent" href="javascript:tabClick('latest_patent')" style="text-align: center; width: 100%;">Latest Patent</a></li>
                <li><a id="latest_article" href="javascript:tabClick('latest_article')" style="text-align: center; width: 100%;">Latest Article</a></li>
                <li><a id="faq" href="javascript:tabClick('faq')" style="text-align: center; width: 100%;">FAQ</a></li>
            </ul>
        </div>
        <div class="main_article_list" style="margin-bottom: 60px;"></div>
        <div class="main_conference_list" style="margin-bottom: 60px;"></div>
        <div class="latest_patent_list" style="margin-bottom: 60px;"></div>
        <div class="latest_article_list" style="margin-bottom: 60px;"></div>
        <div class="faq_list_wrap" name="faq_list_wrap" style="margin-bottom: 60px;"></div>
	</div>
</div>
<div class="popup_wrap">
	<div class="title_box">
		<h3><spring:message code='main.lab'/></h3>
	</div>
	<div class="top_help_wrap">
		<div class="help_text">
			<spring:message code="comment.lab"/>
		</div>
		<p class="help_bt_box">
			<a href="#" class="help_link">Help</a>
			<a href="#" onclick="javascript:toggleHelp();" class="help_bt_r">도움말 열기/닫기</a>
		</p>
	</div>
	<div class="list_bt_area">
		<span class="et_text"><spring:message code="common.mandatory.field"/></span>
		<div class="list_set">
			<ul>
				<c:if test="${empty labId}">
					<li><a href="javascript:fn_preview();" class="list_icon19" style="margin-top: 0px;margin-bottom: 0px;"><spring:message code='common.button.preview'/></a></li>
					<li><a href="javascript:fn_save();" class="list_icon02"><spring:message code='common.button.save'/></a></li>
				</c:if>
				<c:if test="${not empty labId}">
					<li><a href="javascript:fn_preview();" class="list_icon19" style="margin-top: 0px;margin-bottom: 0px;"><spring:message code='common.button.preview'/></a></li>
					<c:if test="${sessionScope.auth.adminDvsCd eq 'M'}">
						<li><a href="javascript:fn_new();" class="list_icon02"><spring:message code='common.button.new'/></a></li>
					</c:if>
					<li><a href="javascript:fn_save();" class="list_icon02"><spring:message code='common.button.save'/></a></li>
                    <li><a href="javascript:fn_approval();" class="list_icon02"><spring:message code='common.button.approval'/></a></li>
					<li id="delBtn"><a href="javascript:fn_delete();" class="list_icon10"><spring:message code='common.button.delete'/></a></li>
				</c:if>
			</ul>
		</div>

		<c:if test="${not empty labId}">
		<div class="top_mn_box">
			<c:if test="${not empty prevLabId}">
				<a href="#" onclick="javascript:goToLab('<c:out value="${prevLabId}"/>');" class="mn_arrow_bt mn_prev">이전</a>
			</c:if>
			<div class="mn_text">
				<spring:message code='common.mng.no'/><strong>${labId}</strong>
			</div>
			<c:if test="${not empty nextLabId}">
				<a href="#" onclick="javascript:goToLab('<c:out value="${nextLabId}"/>');" class="mn_arrow_bt mn_next">다음</a>
			</c:if>
		</div>
		</c:if>

	</div>
	<div id="formObj"></div>

	<a href="#labPreviewDialog" class="modalLink" style="display:none;" id="labPreModalLink">modalLink</a>
</div>
<script type="text/javascript">
var addEngKeywordCnt = 0, addKorKeywordCnt = 0, dhxRepRsltWin, dhxRepRsltLayout, dhxRepRsltGrid;
var isChange = false;

tabClick('main_article');

function tabClick(tabId) {

    // 탭 클릭시 파란색 들어오게함.
    $(".tab_wrap a").removeClass("on");
    $("#" + tabId).attr("class", "on");

	if (tabId === 'main_article') {
		$(".main_article_list").css("display", "block");
		$(".main_conference_list").css("display", "none");
		$(".latest_patent_list").css("display", "none");
		$(".latest_article_list").css("display", "none");
		$(".faq_list_wrap").css("display", "none");
	} else if (tabId === 'main_conference') {
		$(".main_article_list").css("display", "none");
		$(".main_conference_list").css("display", "block");
		$(".latest_patent_list").css("display", "none");
		$(".latest_article_list").css("display", "none");
		$(".faq_list_wrap").css("display", "none");
	}else if (tabId === 'latest_patent') {
		$(".main_article_list").css("display", "none");
		$(".main_conference_list").css("display", "none");
		$(".latest_patent_list").css("display", "block");
		$(".latest_article_list").css("display", "none");
		$(".faq_list_wrap").css("display", "none");
	}else if (tabId === 'latest_article') {
		$(".main_article_list").css("display", "none");
		$(".main_conference_list").css("display", "none");
		$(".latest_patent_list").css("display", "none");
		$(".latest_article_list").css("display", "block");
		$(".faq_list_wrap").css("display", "none");
	}else if (tabId === 'faq') {
		$(".main_article_list").css("display", "none");
		$(".main_conference_list").css("display", "none");
		$(".latest_patent_list").css("display", "none");
		$(".latest_article_list").css("display", "none");
		$(".faq_list_wrap").css("display", "block");
	}
}

<c:if test="${not empty labId}">
	$.post("<c:url value="/${preUrl}/lab/modifyForm.do"/>", {"labId": "${labId}", "srchUserId" : "${user.userId }"},null,'text').done(function(data){$('#formObj').html(data);});
</c:if>
<c:if test="${empty labId}">
	$.post("<c:url value="/${preUrl}/lab/addForm.do"/>", null,null,'text').done(function(data){$('#formObj').html(data);});
</c:if>

$(document).ready(function(){
	window.focus();
	bindModalLink();
});

function goToLab(labId){
	$(location).attr('href','<c:url value="/${preUrl}/lab/labPopup.do"/>'+'?labId='+labId+'&srchUserId=${user.userId }');
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
	$(location).attr('href','<c:url value="/${preUrl}/lab/labPopup.do?newLabYn=Y"/>');
}

function fn_delete(){
	dhtmlx.confirm({
		title:"Lab 삭제",
		ok:"Yes", cancel:"No",
		text:"삭제 하시겠습니까?",
		callback:function(result){
			if(result){
				$.ajax({
					url:'<c:url value="/${preUrl}/lab/removeLab.do"/>',
					data: {labId : "${labId}"}
				}).done(function(data){
					if(data == 1)
					{
						dhtmlx.alert({type:"alert-warning",text:"삭제되었습니다. <br/> 창을 닫습니다.",callback:function(){
							top.self.close();
						}});
					}
				});
			}
			else return;
		}
	});
}
function fn_approval(){
	dhtmlx.confirm({
		title:"Lab 승인 요청",
		ok:"승인 요청", cancel:"아니오",
		text:"Lab정보를 공개하시겠습니까?",
		callback: function (result) {
			if(result){
				$('#apprDvsCd').val('2');
				$('#sendEmail').val('1');
				$('#formArea').append($('input, select').hide());
				$('#formArea').submit();
			}else{
				return;
			}
		}
	});
}

function fn_save(){

	var reqs = $('.required');
	var emptyCnt = 0;
	var emptyObj = [];
	var validate;
	if(reqs.length > 0)
	{
		$(reqs).each(function(idx){
			var obj_type = $(reqs[idx]);
			var data = $(obj_type).val().trim();
			if(data.length < 1){
				emptyCnt++;
				obj_type.css('background-color','#FFCC66');
				emptyObj.push(obj_type.attr('name'))
			}
			else
			{
				obj_type.css('background-color','');
			}
		});
		if(emptyCnt == 0) validate = true;
		else validate = false;
	}
	else
	{
		validate = true;
	}

	//소개 한글,영문
	var labKorIframe = $("#korIntrcnDiv").summernote('code');
	var labEngIframe = $("#engIntrcnDiv").summernote('code');

	console.log(labKorIframe);
	console.log(labEngIframe);

	var plainTextKr = '<p><span style="font-family: &quot;맑은 고딕&quot;;">﻿</span><br></p>';
	var plainTextEn = '<p><span style="font-family: Arial;">﻿</span><br></p>';

	if(labKorIframe == plainTextKr || labKorIframe == '<p><br></p>'){
		emptyObj.push('korIntrcn');
		validate = false;
	}

	if(labEngIframe == plainTextEn || labEngIframe == '<p><br></p>'){
		emptyObj.push('engIntrcn');
		validate = false;
	}

	if(!validate) {
		var message='';
		var nm = true;
		var intrcn = true;
		$(emptyObj).each(function (idx) {
			if((emptyObj[idx] == 'korNm' || emptyObj[idx] == 'engNm') && nm) { message += 'Lab 명칭'; nm = false;}
			else if((emptyObj[idx] == 'korIntrcn' || emptyObj[idx] == 'engIntrcn') && intrcn) { message += (message == '' ? '소개' : ', 소개'); intrcn = false;}
		});
		dhtmlx.alert({type:"alert-warning",text:"필수항목이 누락되었습니다.<br/>입력 후 저장하여 주세요.<br/>( "+message+" )"});
		return;// 필수입력사항 체크
	}

	if(labKorIframe != $('input[name=korIntrcn]').val()){
		isChange = true;
		$('input[name=korIntrcn]').val(labKorIframe);
	}

	if(labEngIframe != $('input[name=engIntrcn]').val()){
		isChange = true;
		$('input[name=engIntrcn]').val(labEngIframe);
	}

	if(isChange) // 변경사항이 있는지 체크
	{
		dhtmlx.confirm({
			title:"Lab 저장",
			ok:"예", cancel:"아니오",
			text:"저장 하시겠습니까?",
			callback:function(result){
				if(result)
				{
					$('#formArea').append($('input, select').hide());
					$('#formArea').submit();
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
		dhtmlx.alert({type:"alert-warning",text:"변경된 내용이 없습니다.",callback:function(){}})
		return;
	}
}

function modKeyword(idx,type){
	isChange = true;
	if(type == "engStart"){
		$('#engKeyword'+idx+'T').val($('#engKeyword'+idx+'A').text());
		$('#engKeyword'+idx+'A').parent().css('display','none');
		$('#engKeyword'+idx+'T').css('display','');
		$('#engKeyword'+idx+'T').focus();
	}else if(type== "engEnd"){

		if($('#engKeyword'+idx+'T').val().replace( /(\s*)/g, "").length == 0)return;

		var engKeyword = $('#engKeyword'+idx+'A').parent().parent().parent().parent().find("input[name=engKeyword]").val();
		engKeyword = engKeyword.replace($('#engKeyword'+idx+'A').text(),$('#engKeyword'+idx+'T').val());
		$('#engKeyword'+idx+'A').parent().parent().parent().parent().find("input[name=engKeyword]").val(engKeyword);

		$('#engKeyword'+idx+'A').text($('#engKeyword'+idx+'T').val());
		$('#engKeyword'+idx+'A').parent().css('display','');
		$('#engKeyword'+idx+'T').css('display','none');


	}else if(type== "korStart"){
		$('#korKeyword'+idx+'T').val($('#korKeyword'+idx+'A').text());
		$('#korKeyword'+idx+'A').parent().css('display','none');
		$('#korKeyword'+idx+'T').css('display','');
		$('#korKeyword'+idx+'T').focus();
	}else if(type== "korEnd"){
		if($('#korKeyword'+idx+'T').val().replace( /(\s*)/g, "").length == 0)return;
		var korKeyword = $('#korKeyword'+idx+'A').parent().parent().parent().parent().find("input[name=korKeyword]").val();
		korKeyword = korKeyword.replace($('#korKeyword'+idx+'A').text(),$('#korKeyword'+idx+'T').val());
		$('#korKeyword'+idx+'A').parent().parent().parent().parent().find("input[name=korKeyword]").val(korKeyword);

		$('#korKeyword'+idx+'A').text($('#korKeyword'+idx+'T').val());
		$('#korKeyword'+idx+'A').parent().css('display','');
		$('#korKeyword'+idx+'T').css('display','none');

	}
}
function addKeyword(obj,type){
	isChange = true;
	var keyword = $(obj).val();

	if(keyword.replace( /(\s*)/g, "").length == 0)return;

	if(type == "eng"){
		var idx = "add"+addEngKeywordCnt;

		$(".engKeywordArea").append('<span>'+
				'<input type="text" id="engKeyword'+idx+'T" style="display:none;font-size:16px;" onkeyup="javascript:if(event.keyCode==\'13\')modKeyword(\''+idx+'\',\'engEnd\');">'+
				'<span class="keyword_span"><a href="javascript:modKeyword(\''+idx+'\',\'engStart\');" id="engKeyword'+idx+'A">'+keyword+'</a><button onclick="removeKeyword($(this),\'eng\');" class="keyword_close" >x</button>' +
				'</span></span>');

		var engKeyword = $(obj).parent().find("input[name=engKeyword]").val();
		$(obj).parent().find("input[name=engKeyword]").val(engKeyword+";"+keyword);

		addEngKeywordCnt++;
	}else{
		var idx = "add"+addKorKeywordCnt;

		$(".korKeywordArea").append('<span>'+
				'<input type="text" id="korKeyword'+idx+'T" style="display:none;font-size:16px;" onkeyup="javascript:if(event.keyCode==\'13\')modKeyword(\''+idx+'\',\'korEnd\');">'+
				'<span class="keyword_span"><a href="javascript:modKeyword(\''+idx+'\',\'korStart\');" id="korKeyword'+idx+'A">'+keyword+'</a><button onclick="removeKeyword($(this),\'kor\');" class="keyword_close" >x</button>' +
				'</span></span>');

		var korKeyword = $(obj).parent().find("input[name=korKeyword]").val();
		$(obj).parent().find("input[name=korKeyword]").val(korKeyword+";"+keyword);

		addKorKeywordCnt++;
	}
	$(obj).val('');
}

function removeKeyword(obj,type){
	isChange = true;
	var keyword = $(obj).parent().find("a").text();
	//console.log(keyword);
	if(type == "eng"){
		var engKeyword = $(obj).parent().parent().parent().parent().find("input[name=engKeyword]").val();
		//console.log(engKeyword);
		var engKeywordValue  = engKeyword.replace(";"+keyword,"");

		$(obj).parent().parent().parent().parent().find("input[name='engKeyword']").val(engKeywordValue);
	}else{
		var korKeyword = $(obj).parent().parent().parent().parent().find("input[name=korKeyword]").val();
        //console.log(korKeyword);
		var korKeywordValue = korKeyword.replace(";"+keyword,"");
		//console.log(korKeywordValue);
		$(obj).parent().parent().parent().parent().find("input[name='korKeyword']").val(korKeywordValue);
	}

	$(obj).parent().parent().remove();
}

function sendLabMail($emailForm){
	myTabbar.cells('a5').progressOn();

	$.post('<c:url value="/mail/sendMail.do"/>', $($emailForm).serializeArray(), null, 'json').done(function (data) {
		myTabbar.cells('a5').progressOff();
		dhtmlx.alert(data.msg);
	});
}

function findTemplate(){
	$.post( "<c:url value="/mail/findTemplates.do"/>", {'jobGubun':'LAB'},null,'json').done(function(data){
		var template = data[0];
		if(template){
			var userId = "<c:out value="${user.userId }"/>";
			var userNm = "<c:out value="${user.korNm }"/>";
			var userMail = "<c:out value="${user.emalAddr}"/>";
			var userDept = "<c:out value="${user.deptKor}"/>";
			var title = template.title;
			var content = template.contents.toString();

			var $emailForm = $('<form></form>');
			var $emailTitle = $('<input type="hidden" name="emailTitle" value="'+title+'">');
			var $rcvrlist = $('<input type="hidden" name="rcvrlist" value="'+userNm+'|'+userMail+'">');
			var $rcvrgrid = $('<input type="hidden" name="rcvrgrid" value="TO|'+userNm+'|'+userMail+'|'+userDept+'|'+userId+'">');
			var $emailContents = $('<input type="hidden" name="emailContents">');

			$emailContents.val(content);

			$emailForm.append($emailTitle);
			$emailForm.append($rcvrlist);
			$emailForm.append($rcvrgrid);
			$emailForm.append($emailContents);

			sendLabMail($emailForm);
		}else{
			dhtmlx.alert("메일템플릿을 만들어주세요.");
		}
	});
}

function clickLabMail(){
	<c:choose>
	<c:when test="${empty user.emalAddr }">
	dhtmlx.alert("연구자의 이메일주소가 없습니다.");
	</c:when>
	<c:otherwise>
	dhtmlx.confirm({title:"Lab 정보", ok:"예", cancel:"아니오", text:"해당 연구자에게 이메일을 발송하시겠습니까?",
		callback:function(result){
			if(result == true){
				findTemplate();
			}
			else if(result == false)
			{
				return;
			}
		}
	});
	</c:otherwise>
	</c:choose>
}

function searhRepRslt(rsltObj, rsltType) {

	var rsltKorNm;
	var gridLoadUrl;
	var repSpan;

	if(rsltType === "art"){
		rsltKorNm = "논문";
		gridLoadUrl = "findArticleListByUserId";
		repSpan = "repArtSpan";
	}else if(rsltType === "fud"){
		rsltKorNm = "연구과제";
		gridLoadUrl = "findFundingListByUserId";
		repSpan =  "repFudSpan";
	}else if(rsltType === "con"){
		rsltKorNm = "학술활동";
		gridLoadUrl = "findConferenceListByUserId";
		repSpan =  "repConSpan";
	}

	var wWidth = 930;
	var wHeight = 600;

	var pageX = $(window).width() /2 - wWidth /2 + $(window).scrollLeft();
	var pageY = $(window).height() /2 - wHeight /2 + $(window).scrollTop();

	var header;
	var columnIds;
	var initWidths;
	var colAlign;
	var colTypes;
	var colSorting;

	if(dhxRepRsltWin != null && dhxRepRsltWin.unload != null)
	{
		dhxRepRsltWin.unload();
		dhxRepRsltWin = null;
	}
	dhxRepRsltWin = new dhtmlXWindows({
		wins : [{id:'w1', left : pageX, top: pageY, width:wWidth, height:wHeight, text:rsltKorNm+" 검색", resize: true}]
	});
	dhxRepRsltWin.window('w1').setModal(true);

	dhxRepRsltLayout = dhxRepRsltWin.window('w1').attachLayout('1C');
	dhxRepRsltLayout.cells("a").hideHeader();
	dhxRepRsltLayout.cells("a").attachStatusBar({
		text : '<div id="grid_pagingArea"></div>',
		paging : true
	});

	dhxRepRsltGrid = dhxRepRsltLayout.cells("a").attachGrid();
	if(rsltType === "art"){
		header = "<spring:message code='grid.no'/>,<spring:message code='grid.id'/>,<spring:message code='grid.art1'/>,<spring:message code='grid.art2'/>,<spring:message code='grid.art3'/>,<spring:message code='grid.art.reprsnt'/>,<spring:message code='grid.art6'/>,content";
		columnIds = "No,articleId,pblcYm,orgLangPprNm,scjnlNm,isReprsntArticle,userConfirmAt,content";
		initWidths = "7,7,10,31,31,7,7,0";
		colAlign = "center,center,center,left,left,center,center,center";
		colTypes = "ro,ro,ro,ro,ro,ro,ro,ro";
		colSorting = "na,na,str,str,str,str,na,na";
	}else if(rsltType === "fud"){
		header = "<spring:message code='grid.no'/>,<spring:message code='grid.id'/>,<spring:message code='grid.fun1'/>,<spring:message code='grid.fun2'/>,<spring:message code='grid.fun3'/>,<spring:message code='grid.fun4'/>,<spring:message code='grid.fun5'/>,content";
		columnIds = "no,fundingId,rschCmcmYm,rsrcctSpptDvsCd,rschSbjtNm,rsrcctSpptAgcNm,total,content";
		initWidths = "4,7,14,12,*,12.5,12,0";
		colAlign = "center,center,center,center,left,left,right,center";
		colTypes = "ro,ro,ro,ro,ro,ro,ro,ro";
		colSorting = "na,na,str,str,str,str,na,na";
	}else if(rsltType === "con"){
		header = "<spring:message code='grid.no'/>,<spring:message code='grid.id'/>,<spring:message code='grid.con6'/>,<spring:message code='grid.con5'/>,<spring:message code='grid.con2'/>,<spring:message code='grid.con3'/>,<spring:message code='grid.con4'/>,<spring:message code='grid.con.reprsnt'/>,content";
		columnIds = "No,conferenceId,scjnlDvsCd,pblcNtnCd,cfrcNm,orgLangPprNm,ancmDate,isReprsntConference,content";
		initWidths = "5,5,5,10,25,*,15,10,0";
		colAlign = "center,center,center,center,left,left,center,center,center";
		colTypes = "ro,ro,ro,ro,ro,ro,ro,ro,ro";
		colSorting = "na,na,str,str,str,str,str,str,str";
	}
	dhxRepRsltGrid.setHeader(header,null,grid_head_center_bold);
	dhxRepRsltGrid.setColumnIds(columnIds);
	dhxRepRsltGrid.setInitWidthsP(initWidths);
	dhxRepRsltGrid.setColAlign(colAlign);
	dhxRepRsltGrid.setColTypes(colTypes);
	dhxRepRsltGrid.setColSorting(colSorting);
	<%--dhxRepRsltGrid.enablePaging(true,100,10,"grid_pagingArea",true);--%>
	<%--dhxRepRsltGrid.setPagingSkin("${dhtmlXPagingSkin}");--%>
	dhxRepRsltGrid.setColumnHidden(dhxRepRsltGrid.getColIndexById("content"), true);
	dhxRepRsltGrid.enablePaging(true,100,10,"grid_pagingArea");
	dhxRepRsltGrid.setPagingSkin("toolbar");
	dhxRepRsltGrid.setImagePath(dhtmlximagepath);
	dhxRepRsltGrid.enableColSpan(true);
	dhxRepRsltGrid.attachEvent("onXLS", function() { dhxRepRsltLayout.cells('a').progressOn(); });
	dhxRepRsltGrid.attachEvent("onXLE", function() { dhxRepRsltLayout.cells('a').progressOff(); });
	dhxRepRsltGrid.init();
	dhxRepRsltGrid.attachEvent('onRowSelect', function repArticle_onRowSelect(id){
		var contents = dhxRepRsltGrid.cells(id,dhxRepRsltGrid.getColIndexById("content")).getValue();

		dhtmlx.confirm({title:"대표 "+rsltKorNm+" 선택", ok:"적용", cancel:"취소", text:"대표 "+rsltKorNm+"으로 적용하시겠습니까?",
			callback:function(result){
				if(result == true)
				{
                    $(rsltObj).append('<li class="rslt_li" id="'+rsltType+id+'" style="width: 100%;">' +
                        '<input type="hidden" name="rsltType" value="'+rsltType.toUpperCase()+'"/>' +
                        '<input type="hidden" name="rsltId" value="'+id+'"/>' +
                        '<h3 style="width: 20px;height:30px;float:left;">ㆍ</h3>' +
                        '<button onclick="removeRep(\''+rsltType+id+'\');$(this).remove();" style="width:30px;height:30px;float:right;" class="keyword_close">x</button>' +
                        '<span class="'+repSpan+'">'+contents+'</span>' +
                        '</li>');

					isChange = true;
					dhxRepRsltGrid.clearSelection();
					dhxRepRsltWin.window('w1').close();
				}
			}
		});

	});

	dhxRepRsltGrid.load(contextpath+'/lab/'+gridLoadUrl+'.do?srchUserId='+$("#repUserId").val());	//대표연구자의 성과 검색
}

function removeRep(liId){
    $("#"+liId).remove();
	isChange = true;
}

var owl = undefined;
function fn_preview(){
    var korNm = document.getElementsByName("korNm")[0].value;
    var engNm = document.getElementsByName("engNm")[0].value;
    var homePageAddr = document.getElementsByName("homePageAddr")[0].value;
    var repUserNm = $("#repUserNm").text();
    var korIntrcn = $("#korIntrcnDiv").summernote('code');
    var engIntrcn = $("#engIntrcnDiv").summernote('code');
    var korKeyword = document.getElementsByName("korKeyword")[0].value;
    var engKeyword = document.getElementsByName("engKeyword")[0].value;
    var videoLink = document.getElementsByName("videoLink")[0].value;
    var emailAddr = document.getElementsByName('emailAddr')[0].value;
    var coverFile = document.getElementsByName("modal_coverFile")[0];
    var repFile1 = document.getElementsByName("modal_repFile1")[0];
    var repFile2 = document.getElementsByName("modal_repFile2")[0];
    var korFaqQ = document.getElementsByName("korFaqQ");
    var korFaqA = document.getElementsByName("korFaqA");
    var engFaqQ = document.getElementsByName("engFaqQ");
    var engFaqA = document.getElementsByName("engFaqA");
    var state = 0;
    repUserNm = repUserNm.split('(');
    korKeyword = korKeyword.replace(';','').split(';');
    engKeyword = engKeyword.replace(';','').split(';');

	if(owl != undefined){
		owl.trigger('destroy.owl.carousel');
	}
	$(".coverFile").parent().parent().parent().parent().parent().parent().parent().remove();
	$(".repFile1").parent().parent().parent().parent().parent().parent().parent().remove();
	$(".repFile2").parent().parent().parent().parent().parent().parent().parent().remove();
	$(".videoLink").parent().parent().parent().parent().parent().parent().parent().remove();

    var $html = '';
    if(coverFile != undefined){
        if($('.coverFile')[0] == undefined) {
            $html = '<div class="item">' +
                '<div class="lab_slide_inner">' +
                '<div class="lab_slide_bg"><table><tbody><tr>' +
                '<td>' +
                '<img class="coverFile" style="width: 100%;" src="'+coverFile.src+'"/>' +
                '</td>' +
                '</tr></tbody></table></div></div></div>';
            $("#lab_view_slide").append($html);
            state += 1;
        }
    }
    if(repFile1 != undefined){
        if($('.repFile1')[0] == undefined) {
            $html = '<div class="item">' +
                '<div class="lab_slide_inner">' +
                '<div class="lab_slide_bg"><table><tbody><tr>' +
                '<td>' +
                '<img class="repFile1" style="width: 100%;" src="'+repFile1.src+'"/>' +
                '</td>' +
                '</tr></tbody></table></div></div></div>';
            $("#lab_view_slide").append($html);
            state += 1;
        }
    }
    if(repFile2 != undefined){
        if($('.repFile2')[0] == undefined) {
            $html = '<div class="item">' +
                '<div class="lab_slide_inner">' +
                '<div class="lab_slide_bg"><table><tbody><tr>' +
                '<td>' +
                '<img class="repFile2" style="width: 100%;" src="'+repFile2.src+'"/>' +
                '</td>' +
                '</tr></tbody></table></div></div></div>';
            $("#lab_view_slide").append($html);
            state += 1;
        }
    }
	if (videoLink.lastIndexOf('v=') !== -1) videoLink = videoLink.substring(videoLink.lastIndexOf('v=') + 2, videoLink.lastIndexOf('v=') + 13);
	else if (videoLink.lastIndexOf('/') !== -1) videoLink = videoLink.substring(videoLink.lastIndexOf('/') + 1, videoLink.length);
	else videoLink = '';
    if(videoLink != ''){
        if($('.videoImg')[0] == undefined) {
            $html = '<div class="item">' +
                '<div class="lab_slide_inner">' +
                '<div class="lab_slide_bg"><table><tbody><tr>' +
                '<td>' +
                '<a class="videoLink" href="https://youtu.be/' + videoLink + '" target="_blank">' +
                '<img class="videoImg" style="position:absolute; width:95%; top: 10px; left: 10px;" src="https://i.ytimg.com/vi/' + videoLink + '/hqdefault.jpg"/>' +
                '<img style="position:relative; width: 65px; height: auto;" src="<c:url value="/images/icon/youtube_play_btn.png"/>"/></a>' +
                '</td>' +
                '</tr></tbody></table></div></div></div>';
            $("#lab_view_slide").append($html);
        }else{
            $('.videoLink').attr('href','https://youtu.be/' + videoLink + '"');
            $('.videoImg').attr('src','https://i.ytimg.com/vi/' + videoLink + '/hqdefault.jpg');
        }
		state += 1;
    }

    if(state < 1) {
		$html = '<div class="item">' +
				'<div class="lab_slide_inner">' +
				'<div class="lab_slide_bg"><table><tbody><tr>' +
				'<td>' +
				'<img src="<c:url value="/share/img/common/lab_default_rep.jpg"/>"/>' +
				'</td>' +
				'</tr></tbody></table></div></div></div>';
		$("#lab_view_slide").append($html);
    }
	$('#lab_view_slide').attr('class', 'owl-carousel owl-theme');
	owl = $('#lab_view_slide').owlCarousel({
		items:1,
		loop:true,
		nav:false,
		autoHeight:true,
		autoplay: true,
		autoplayTimeout: 4500,
		autoplayHoverPause:true,
		margin:0
	});

    var Intrcn = (language == 'en' ? engIntrcn : korIntrcn);
    $(".modal_lab_intro_t .lab_intro_area").text('');
    $(".modal_lab_intro_t .lab_intro_area").append(Intrcn);


    /*$html = '<ul>' +
            '<li><a href="#" target="_blank" class="model_homepage_addr">'+homePageAddr+'</a></li>' +
            '<li class="r_mail">'+emailAddr+'</li>' +
            '</ul>';

    $(".lab_view_link").children().remove();
    $(".lab_view_link").append($html);*/

    $html = (language == 'en' ? '<p><em>'+engNm+'</em>'+korNm+'</p>' : '<p><em>'+korNm+'</em>'+engNm+'</p>');
    $(".lab_view_title").children("p").remove();
    $(".lab_view_title").append($html);

    $html = '';
    var firstKeywords = (language == 'en' ? engKeyword : korKeyword);
    if(firstKeywords.length > 0){
        for(var i = 0; i < (firstKeywords.length < 3 ? firstKeywords.length : 3); i++){
            $html += '<li><a href="javascript:void(0);"><span>'+firstKeywords[i]+'</span></a></li>';
        }
    }
	var secondKeywords = (language != 'en' ? engKeyword : korKeyword);
	if(secondKeywords.length > 0){
		for(var i = 0; i < (secondKeywords.length < 3 ? secondKeywords.length : 3); i++){
			$html += '<li><a href="javascript:void(0);"><span>'+secondKeywords[i]+'</span></a></li>';
		}
	}
	if($html != ''){
		$(".modal_keyword .keyword_list_box").children().remove();
		$(".modal_keyword .keyword_list_box").append($html);
	}

    var userId = document.getElementsByName('repUserId')[0].value;
    var rsltIds = [];
    var rsltTypes = [];
	$('input[name=rsltId]').each(function () {
		rsltIds.push($(this).val());
	});
	$('input[name=rsltType]').each(function () {
		rsltTypes.push($(this).val());
	});
    $.ajax({
        url:'<c:url value="/share/laboratory/laboratoryPreview.do"/>',
        data: {userId : userId, rsltType:rsltTypes, rsltId:rsltIds},
        type: 'GET'
    }).done(function(data){
        var mainArticleList = data.mainArticleList;
        var mainConferenceList = data.mainConferenceList;
        var latestPatentList = data.latestPatentList;
        var latestArticleList = data.latestArticleList;
        var user = data.user;
        var profFile = user.profPhotoFileId;

        if(profFile != null){
        	$('.lab_researcher_img img').attr('src', '${contextPath}/servlet/image/profile.do?fileid=' + profFile);
        }

        var engPosiNm = user.posiNm == "교수" ? "Professor" :user.posiNm == "조교수" ? "Assistant Professor" :user.posiNm == "부교수" ? "Associate Professor" :"";
        var dept = (language == 'en' ? user.deptEng + "(" + user.deptKor + ")" : user.deptKor + "(" + user.deptEng + ")");
        if(language == 'en'){
            $html = '<span class="r_img_b"><img src="${contextPath}/servlet/image/profile.do?fileid='+profFile+'"/></span>'+
					'<p>' + engPosiNm +' '+ repUserNm[0]+
					'<span>('+repUserNm[1].replace(')','')+' '+user.posiNm+')</span>'+
					'<em>'+dept+'</em>'+
					'</p>';
        }else{
			$html = '<span class="r_img_b"><img src="${contextPath}/servlet/image/profile.do?fileid='+profFile+'"/></span>'+
					'<p>' + repUserNm[0] +' ' + user.posiNm +
					'<span>(' + engPosiNm+' '+repUserNm[1]+'</span>' +
					'<em>'+dept+'</em>'+
					'</p>';
        }
        $(".researcher_info_box").children().remove();
        $(".researcher_info_box").append($html);


		$(".main_article_list").children().remove();
        if(mainArticleList != null && mainArticleList.length > 0 && mainArticleList != undefined) {
            for (var i = 0; i < mainArticleList.length; i++) {
                var $html = '';
                $html += '<div class="article_list_box">' +
                    '<div class="alb_text_box">' +
                    '<div data-badge-popover="left" data-link-target=\'_blank\' style="float:right;"' +
                    'data-badge-type="donut"' +
                    'data-doi="' + mainArticleList[i].doi + '" data-hide-no-mentions="true"' +
                    'class="altmetric-embed"></div>' +
                    '<a class="al_title"' +
                    'href="">' +
                    mainArticleList[i].orgLangPprNm +
                    '</a>' +
                    '<p>' +
                    mainArticleList[i].content +
                    '</p>' +
                    '</div>';
                if (mainArticleList[i].keywords != 'empty') {
                    $html += '<div class="l_keyword_box">' +
                        '<span>keyword</span>';
                    mainArticleList[i].keywords.split(',').forEach(function (keyword) {
                        $html += '<a href="">' + keyword + '</a>';
                    });
                    $html += '</div>';
                }
                $html += '<div>';
                $(".main_article_list").append($html);
            }
        }else{
        	$html = '<h4 style="text-align:center">'+(language == 'en' ? 'There is no result.' : '대표 논문이 없습니다.')+'</h4>';
			$(".main_article_list").append($html);
		}
		$(".main_conference_list").children().remove();
        if(mainConferenceList != null && mainConferenceList.length > 0 && mainConferenceList != undefined) {

            for (var i = 0; i < mainConferenceList.length; i++) {
                var $html = '';
                $html += '<div class="article_list_box">' +
                    '<div class="alb_text_box">' +
                    '<a class="al_title" href="">'+
                    mainConferenceList[i].orgLangPprNm +
                    '</a>' +
                    '<p>' +
                    mainConferenceList[i].content +
                    '</p>' +
                    '</div>' +
                    '</div>';
                $(".main_conference_list").append($html);
            }
        }else{
			$html = '<h4 style="text-align:center">'+(language == 'en' ? 'There is no result.' : '대표 활동이 없습니다.')+'</h4>';
			$(".main_conference_list").append($html);
		}
		$(".latest_patent_list").children().remove();
        if(latestPatentList != null && latestPatentList.length > 0 && latestPatentList != undefined) {

            for (var i = 0; i < latestPatentList.length; i++) {
                var $html = '';
                $html += '<div class="article_list_box">' +
                    '<div class="alb_text_box">' +
                    '<a class="al_title" href="">'+
                    latestPatentList[i].itlPprRgtNm +
                    '</a>' +
                    '<p>' +
                    latestPatentList[i].content +
                    '</p>' +
                    '</div>' +
                    '</div>';
                $(".latest_patent_list").append($html);
            }
        }else{
			$html = '<h4 style="text-align:center">'+(language == 'en' ? 'There is no result.' : '최신 특허가 없습니다.')+'</h4>';
			$(".latest_patent_list").append($html);
		}
		$(".latest_article_list").children().remove();
		if(latestArticleList != null && latestArticleList.length > 0 && latestArticleList != undefined) {
			for (var i = 0; i < latestArticleList.length; i++) {
				var $html = '';
				$html += '<div class="article_list_box">' +
						'<div class="alb_text_box">' +
						'<div data-badge-popover="left" data-link-target=\'_blank\' style="float:right;"' +
						'data-badge-type="donut"' +
						'data-doi="' + latestArticleList[i].doi + '" data-hide-no-mentions="true"' +
						'class="altmetric-embed"></div>' +
						'<a class="al_title"' +
						'href="">' +
						latestArticleList[i].orgLangPprNm +
						'</a>' +
						'<p>' +
						latestArticleList[i].content +
						'</p>' +
						'</div>';
				if (latestArticleList[i].keywordList.length > 0) {
					$html += '<div class="l_keyword_box">' +
							'<span>keyword</span>';
					for(var j = 0; j < latestArticleList[i].keywordList.length; j++){
						$html += '<a href="">' + latestArticleList[i].keywordList[j] + '</a>';
					}
					$html += '</div>';
				}
				$html += '<div>';
				$(".latest_article_list").append($html);
			}
		}else{
			$html = '<h4 style="text-align:center">'+(language == 'en' ? 'There is no result.' : '최신 논문이 없습니다.')+'</h4>';
			$(".latest_article_list").append($html);
		}
		$(".faq_list_wrap").children().remove();
		var faqQList = language == 'en' ? engFaqQ : korFaqQ;
		var faqAList = language == 'en' ? engFaqA : korFaqA;
		var $html = '';
		for (var i = 0; i < faqQList.length; i++) {
			if(faqQList[i].value != '' && faqAList[i].value != '') {
				$html +='<h3 class="acc_trigger" onclick="$(\'.acc_container\')[0].toggleAttribute(\'hidden\');">' +
						'<a href="#faq_list_wrap" style="color:#337ab7; text-decoration: none;"><span>Q</span>'+ faqQList[i].value +'</a>' +
						'</h3>' +
						'<div class="acc_container" hidden>' +
						'<span>A</span>' +
						'<div class="faq_block">'+ faqAList[i].value +'</div>' +
						'</div>';
			}
		}
		if($html == ''){
			$html = '<h4 style="text-align:center">'+(language == 'en' ? 'There is no result.' : '질의응답이 없습니다.')+'</h4>';
		}
		$(".faq_list_wrap").append($html);
    });


	$("#labPreModalLink").click();
}

function addFaq(btn){
	var $tbody = $(btn).parent().parent().parent();
	var newTbody = $tbody.clone();
	var inputs = newTbody.find('textarea');
	inputs.val("");
	inputs = newTbody.find('input');
	inputs.val("");
	$tbody.after(newTbody);
	isChange = true;
}

function removeFaq(btn){
	var $table = $(btn).parent().parent().parent().parent();
	var $tbody = $table.find('tbody');
	if($tbody.length == 1){
		addFaq(btn);
	}
	var  $thisTbody = $(btn).parent().parent().parent();
	var seqNo = $thisTbody.find('input[name="faqId"]').val();
	if(seqNo != '0')$('#formArea').append($('<input type="hidden" name="delFaqSeqNos" value="'+seqNo+'" />)'));
	$thisTbody.remove();
	isChange = true;
}

function loadThumbnail(youtubeAddr){
	var pureAddr;
	if (youtubeAddr.lastIndexOf('v=') !== -1) pureAddr = youtubeAddr.substring(youtubeAddr.lastIndexOf('v=') + 2, youtubeAddr.lastIndexOf('v=') + 13);
	else if (youtubeAddr.lastIndexOf('/') !== -1) pureAddr = youtubeAddr.substring(youtubeAddr.lastIndexOf('/') + 1, youtubeAddr.length);

	if(pureAddr != ''){
		$('#youtubeImg').attr('src','https://img.youtube.com/vi/'+ pureAddr +'/0.jpg');
		$("#youtubeImg").show();
	}else{
		$("#youtubeImg").hide();
	}
}

function removeLabFile(fileObj, fileNm){
	if(fileNm == 'coverFile'){
        $(fileObj).parent().find("li").html(
            '<label>' +
            '<span class="list_icon12"><spring:message code="lab.upload"/></span>' +
			'<span style="font-size:15px;"><spring:message code="lab.cover.img.size"/></span>' +
            '<input type="file" name="'+fileNm+'" style="display:none;" onchange="labFileUpload(this,\''+fileNm+'\');"/>' +
            '</label>');
    }else{
		$(fileObj).parent().find("li").html(
			'<label>' +
			'<span class="list_icon12"><spring:message code="lab.upload"/></span>' +
			'<span style="font-size:15px;"><spring:message code="lab.rep.img.size"/></span>' +
			'<input type="file" name="'+fileNm+'" style="display:none;" onchange="labFileUpload(this,\''+fileNm+'\');"/>' +
			'</label>');
	}


	$(fileObj).remove();
	isChange = true;
}

function labFileUpload(fileObj, fileNm){
	$(fileObj).parent().hide();
	$(fileObj).parent().parent().append('<img class="labImg" name="modal_'+fileNm+'" src=""/>');
	$(fileObj).parent().parent().parent().append('<a href="javascript:void(0);" style="padding:0px;" onclick="removeLabFile($(this), \''+fileNm+'\');" class="del_file">삭제</a>');
	previewImg(fileObj);
}

function previewImg(imgObj){
	console.log(imgObj);
	if(imgObj.files && imgObj.files[0]){
		var reader = new FileReader();

		reader.onload = function (e){
			$(imgObj).parent().parent().find("img").attr('src',e.target.result);
		};
		reader.readAsDataURL(imgObj.files[0]);
	}
}

var wins,  winGrid, dhxLayout, winToolbar;

// 사용자 검색
function addUser(obj){

	var wWidth = 600;
	var wHeight = 350;
	var pageX = $(window).width() /2 - wWidth /2 + $(window).scrollLeft();
	var pageY = $(window).height() /2 - wHeight /2 + $(window).scrollTop();

	if(wins != null && wins.unload != null)
	{
		wins.unload();
		wins = null;
	}

	wins = new dhtmlXWindows({
		viewport : {objec : 'windVP'},
		wins : [ {id : 'w1', left : pageX, top : pageY, width: wWidth, height: wHeight, text: getText("tit_res_sear"), resize : false} ]
	});
	wins.window('w1').setModal(true);


	dhxLayout = wins.window('w1').attachLayout('1C')
	dhxLayout.cells("a").hideHeader();

	winToolbar = dhxLayout.cells("a").attachToolbar();
	winToolbar.setIconsPath(contextpath+"/images/common/icon/");
	winToolbar.addInput("keyword", 0, '', 515);
	winToolbar.addButton("search", 1, "", "tbl_search_icon.png", "tbl_search_icon.png");
	winToolbar.attachEvent("onClick", function(id) {
		if (id == "search"){
			winGrid.clearAndLoad(contextpath+'/user/findAuthorListByKeyword.do?keyword=' + encodeURIComponent(winToolbar.getValue('keyword')));
		}
	});
	winToolbar.attachEvent("onEnter", function(id,value) {
		if (value == "")
		{
			dhtmlx.alert({type:"alert-warning",text:"검색어를 입력하세요.",callback:function(){}});
		}
		else
		{
			winGrid.clearAndLoad(contextpath+ '/user/findAuthorListByKeyword.do?keyword=' + encodeURIComponent(winToolbar.getValue('keyword')));
		}
	});

	winGrid = dhxLayout.cells("a").attachGrid();
	winGrid.setImagePath(contextpath+'/js/codebase/imgs/');
	winGrid.setHeader(getText("tit_res_grid"),null,grid_head_center_bold);
	winGrid.setInitWidths("60,90,90,90,*,100");
	winGrid.setColAlign("center,left,left,center,left,left");
	winGrid.setColTypes("ro,ro,ro,ro,ro,ro");
	winGrid.setColSorting("str,str,str,str,str,str");
	winGrid.enableColSpan(true);
	winGrid.attachEvent("onXLS", function() {
		wins.window('w1').progressOn();
	});
	winGrid.attachEvent("onXLE", function() {
		wins.window('w1').progressOff();
	});
	winGrid.attachEvent('onRowSelect', function(id){
		var userData = id.split(';');
		var userId = userData[0];
		var userKorNm = userData[1];
		var userEngNm = userData[2];

		if(language == 'en'){
            $(obj).parent().parent().after('<div style="padding-top: 5px;padding-bottom: 5px;">' +
                '<input type="hidden" name="userId" value="'+userId+'"/>' +
                '<span style="vertical-align: sub;margin-right: 10px;">'+userEngNm+'('+userKorNm+')</span>' +
                ' <span>' +
                '<a href="javascript:void(0);" class="tbl_icon_a row_add_bt" onclick="addUser($(this));"><spring:message code='common.add'/></a> ' +
                '<a href="javascript:void(0);" class="tbl_icon_a red_del" onclick="removeUser($(this));"><spring:message code='common.row.delete'/></a>' +
                '</span>' +
                '</div>');
        }else if(language == 'ko'){
            $(obj).parent().parent().after('<div style="padding-top: 5px;padding-bottom: 5px;">' +
                '<input type="hidden" name="userId" value="'+userId+'"/>' +
                '<span style="vertical-align: sub;margin-right: 10px;">'+userKorNm+'('+userEngNm+')</span>' +
                ' <span>' +
                '<a href="javascript:void(0);" class="tbl_icon_a row_add_bt" onclick="addUser($(this));"><spring:message code='common.add'/></a> ' +
                '<a href="javascript:void(0);" class="tbl_icon_a red_del" onclick="removeUser($(this));"><spring:message code='common.row.delete'/></a>' +
                '</span>' +
                '</div>');
        }
		isChange = true;

		if($(obj).hasClass('just_button')){
			$(obj).parent().parent().remove();
		}

		wins.window('w1').close();
	});

	winGrid.init();
	$('.dhxtoolbar_input').focus();
	if (winToolbar.getValue('keyword') != "") winGrid.loadXML(contextpath+'/user/findAuthorListByKeyword.do?keyword=' + encodeURIComponent(winToolbar.getValue('keyword')));
}

function removeUser(obj){
	if($("input[name=userId]").length == 1){
		$(obj).parent().parent().after('<div style="padding-top: 5px;padding-bottom: 5px;">' +
			'<span style="vertical-align: sub;"></span>' +
			'<span>' +
			'<a href="javascript:void(0);" class="tbl_icon_a row_add_bt just_button" onclick="addUser($(this));"><spring:message code='common.add'/></a>' +
			'</span>' +
			'</div>');
	}

	$(obj).parent().parent().remove();
	isChange = true;
}

function searchRepUser(obj){
	var wWidth = 600;
	var wHeight = 350;
	var pageX = $(window).width() /2 - wWidth /2 + $(window).scrollLeft();
	var pageY = $(window).height() /2 - wHeight /2 + $(window).scrollTop();
	var repUserId = $('#repUserId').val();

	if(wins != null && wins.unload != null)
	{
		wins.unload();
		wins = null;
	}

	wins = new dhtmlXWindows({
		viewport : {objec : 'windVP'},
		wins : [ {id : 'w1', left : pageX, top : pageY, width: wWidth, height: wHeight, text: getText("tit_res_sear"), resize : false} ]
	});
	wins.window('w1').setModal(true);


	dhxLayout = wins.window('w1').attachLayout('1C')
	dhxLayout.cells("a").hideHeader();

	winToolbar = dhxLayout.cells("a").attachToolbar();
	winToolbar.setIconsPath(contextpath+"/images/common/icon/");
	winToolbar.addInput("keyword", 0, '', 515);
	winToolbar.addButton("search", 1, "", "tbl_search_icon.png", "tbl_search_icon.png");
	winToolbar.attachEvent("onClick", function(id) {
		if (id == "search"){
			winGrid.clearAndLoad(contextpath+'/user/findAuthorListByKeyword.do?keyword=' + encodeURIComponent(winToolbar.getValue('keyword')));
		}
	});
	winToolbar.attachEvent("onEnter", function(id,value) {
		if (value == "")
		{
			dhtmlx.alert({type:"alert-warning",text:"검색어를 입력하세요.",callback:function(){}});
		}
		else
		{
			winGrid.clearAndLoad(contextpath+ '/user/findAuthorListByKeyword.do?keyword=' + encodeURIComponent(winToolbar.getValue('keyword')));
		}
	});

	winGrid = dhxLayout.cells("a").attachGrid();
	winGrid.setImagePath(contextpath+'/js/codebase/imgs/');
	winGrid.setHeader(getText("tit_res_grid"),null,grid_head_center_bold);
	winGrid.setInitWidths("60,90,90,90,*,100");
	winGrid.setColAlign("center,left,left,center,left,left");
	winGrid.setColTypes("ro,ro,ro,ro,ro,ro");
	winGrid.setColSorting("str,str,str,str,str,str");
	winGrid.enableColSpan(true);
	winGrid.attachEvent("onXLS", function() {
		wins.window('w1').progressOn();
	});
	winGrid.attachEvent("onXLE", function() {
		wins.window('w1').progressOff();
	});
	winGrid.attachEvent('onRowSelect', function(id){
		var userData = id.split(';');
		var userId = userData[0];
		var userKorNm = userData[1];
		var userEngNm = userData[2];

        var userNm = language == 'en' ? userEngNm + "(" + userKorNm + ")" : userKorNm + "(" + userEngNm + ")"
        $(obj).parent().parent().find("#repUserId").val(userId);
		$(obj).parent().parent().find("#repUserNm").html(userNm);

		//대표연구자가 달라지면 대표성과를 다시 입력받도록 삭제
		if(repUserId != userId){
			$(".rslt_li").remove();
		}

		isChange = true;
		wins.window('w1').close();
	});

	winGrid.init();
	$('.dhxtoolbar_input').focus();
	if (winToolbar.getValue('keyword') != "") winGrid.loadXML(contextpath+'/user/findAuthorListByKeyword.do?keyword=' + encodeURIComponent(winToolbar.getValue('keyword')));
}

function toggleHelp() {
	$(".help_text").slideToggle(250);
	if($(".help_bt_r").hasClass('help_open')){
		$(".help_bt_r").removeClass('help_open')
	}else{
		$(".help_bt_r").addClass('help_open')
	}
}


function toggleIntrcn() {
	if($(".lab_intro_t").hasClass('open_intrcn')){
		$(".lab_intro_t").removeClass('open_intrcn')
	}else{
		$(".lab_intro_t").addClass('open_intrcn');
	}
}

function toggleKeywordHelp() {
	if($(".k_help_view").css("display") == "none"){
		$(".k_help_view").show();
	}else{
		$(".k_help_view").hide();
	}
}

</script>
</body>
</html>