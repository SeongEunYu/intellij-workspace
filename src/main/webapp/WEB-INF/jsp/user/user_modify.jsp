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
<%@include file="../pageInit.jsp" %>
<link type="text/css" href="<c:url value="/css/layout.css"/>" rel="stylesheet" />
<!--
<link type="text/css" href="http://cdn.dhtmlx.com/edge/dhtmlx.css" rel="stylesheet" />
-->
<link type="text/css" href="<c:url value="/js/dhtmlx_461/skins/${sysConf['dhtmlx.skin']}/dhtmlx.css"/>" rel="stylesheet" />
<link type="text/css" href="<c:url value="/js/dhtmlx/skins/${sysConf['dhtmlx.skin']}/dhtmlxvault.css"/>" rel="stylesheet" />
<style type="text/css">
.dhxwins_vp_dhx_terrace {overflow: auto;}
.dhxwins_vp_dhx_terrace div.dhxwin_active div.dhx_cell_wins div.dhx_cell_toolbar_def, .dhxwins_vp_dhx_terrace div.dhxwin_inactive div.dhx_cell_wins div.dhx_cell_toolbar_def { padding: 10px 0px 0; }
.dhx_toolbar_dhx_terrace { padding: 0 0px; }
.labelHelp { position: absolute; color: #afafaf; padding: 2px; line-height: 160%; cursor: text; display: block;}
.fileupload_box ul li {position: relative; height: 23px; padding: 2px 2px 2px 0; border-bottom: 0px;}
.upload_file_text { border-bottom: 0px; padding: 0 0 0 0; margin-bottom: 0px;}
.in_tbl td {padding: 5px 5px !important;}
</style>
<script type="text/javascript" src="<c:url value="/js/jquery/jquery-1.11.3.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jquery/jquery-ui.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/dhtmlx_461/dhtmlx.js"/>"></script>
<script src="<c:url value="/js/dhtmlx/vault/dhtmlxvault.js"/>"></script>
<!--
<script type="text/javascript" src="http://cdn.dhtmlx.com/edge/dhtmlx.js"></script>
-->
<script type="text/javascript" src="<c:url value="/js/script.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/mainLayout.js"/>"></script>
<script type="text/javascript">
var dhxLayout, myTabbar, myForm, formData, t, myVault;
var isChange = false;

$(document).ready(function(){
	var callType = '${callType}';
	setLayoutHeight();
	if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
	else  window.addEventListener("resize",resizeLayout, false);
	//set layout
	dhxLayout = new dhtmlXLayoutObject("mainLayout","1C");
	dhxLayout.cells("a").hideHeader();
	dhxLayout.setSizes(false);

	myTabbar = dhxLayout.cells("a").attachTabbar();
	myTabbar.setArrowsMode("auto");
	myTabbar.enableAutoReSize(true);

	myTabbar.addTab('a1','<spring:message code="user.title.info"/>');
	myTabbar.addTab('a4','<spring:message code="user.title.id"/>');
	myTabbar.addTab('a2','<spring:message code="user.etc"/>');

	if(callType == 'infoProvdPopup') myTabbar.tabs('a2').setActive();
	else if(callType == 'rsrchAreaPopup') myTabbar.tabs('a3').setActive();
	else if(callType == 'researcherIdPopup') myTabbar.tabs('a4').setActive();
	else myTabbar.tabs('a1').setActive();

	myTabbar.tabs('a1').attachObject('basicInfo');
	myTabbar.tabs('a4').attachObject('idntfrInfo');
	myTabbar.tabs('a2').attachObject('submitInfo');

	myTabbar.cells('a1').showInnerScroll();
	myTabbar.cells('a4').showInnerScroll();
	myTabbar.cells('a2').showInnerScroll();

	$(".help_bt_r").click(function(){
		$(".help_text").slideToggle(250);
		$(".help_bt_r").toggleClass("help_open");
	});
	$('input, select').change(function(){ isChange = true; });
	$('input:checkbox, input:radio').click(function(){ isChange = true; });

	loadImageForm();
	resizeLayout();
});

function loadImageForm(){
	formData = [
		{type: "settings", position: "label-top", labelWidth: 0, inputWidth: 140, inputHeight: 186},
		{type: "image",
			name: "user_photo_${user.userId}",
			label: "", value:"${user.profPhotoFileId}",
			imageWidth: '138',
			//imageWidth: 'auto',
			imageHeight: '184',
			//imageHeight: 'auto',
			url: "${contextPath }/dhxform/image/handler.do"
		}
	];

	myForm = new dhtmlXForm('profile', formData);

	myForm.attachEvent("onImageUploadSuccess", function(name, value, extra){
		setTimeout(function() { $('#profPhotoFileId').val(extra);}, 1000);
		isChange = true;
	});

	window.setTimeout(function(){$('.dhxform_image_input').unbind().click(function(){ event.preventDefault(); fn_selectProfilePhoto(); }); }, 100);

	window.dhx4.ajax.get("${contextPath}/user/upload_conf.do?userId=${user.userId}" ,function(r){
		var t = window.dhx4.s2j(r.xmlDoc.responseText);
		if(t != null)
		{
			myVault = new dhtmlXVaultObject(t);
			myVault.attachEvent("onUploadFile", onFileUploadComplete);
			myVault.attachEvent("onBeforeFileAdd", function(file){ $('.dhxform_image_wrap').addClass('dhxform_image_in_progress'); return true;});
		}
	});
}

function onFileUploadComplete(file,extra){
	setTimeout(function() { $('#profPhotoFileId').val(extra);}, 100);
	myForm.setItemValue("user_photo_${user.userId}", extra);
	$('.dhxform_image_wrap').removeClass('dhxform_image_in_progress');
	isChange = true;
}

function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){setLayoutHeight(); dhxLayout.setSizes(false); }, 10);}
function doOnGridLoaded(){setTimeout(function() {dhxLayout.cells("a").progressOff();}, 100);}
function doBeforeGridLoad(){dhxLayout.cells("a").progressOn();}
function setLayoutHeight(){$('#mainLayout').css('height', $(window).height() - (80 +  $('.title_box').height() + $('.list_bt_area').height() + $('.top_help_wrap').height()));}

function fn_selectProfilePhoto(){
	myVault.clear();
	$('.dhx_vault_button').trigger('click');
}
function fn_deleteProfilePhoto(){
	dhtmlx.confirm({
		title:"프로필사진 삭제",
		ok:"Yes", cancel:"No",
		text:"프로필 사진을 삭제 하시겠습니까?<br/>삭제된 사진은 복구할 수 없습니다.",
		callback:function(result){
			if(result){
				fn_runDeleteProfilePhoto('delete');
			}
			else return;
		}
	});
}
function fn_runDeleteProfilePhoto(mode){
	$.post("<c:url value="/dhxform/image/delete.do"/>", {"fileId": $('#profPhotoFileId').val(), "trgetUserId":"${user.userId}", "mode":mode},null,'text').done(function(data){
		myForm.setItemValue("user_photo_${user.userId}", "");
		if(mode == 'delete') $('#profPhotoFileId').val('');
		isChange = true;
	});
}

function fn_save(){
	if(isChange) // 변경사항이 있는지 체크
	{
		dhtmlx.confirm({
			title:"저자 저장",
			ok:"예", cancel:"아니오",
			text:"변경된 내용을 저장 하시겠습니까?",
			callback:function(result){
				if(result)
				{
					$('#formArea').append($('input, select'));
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

function addRow(btn){
	var $tbody = $(btn).parent().parent().parent();
	var $tr = $(btn).parent().parent();
	var newRow = $tr.clone();
	var inputs = newRow.find('input');
	for(var i=0; i < inputs.length; i++)
	{
		var objName = inputs.eq(i).prop('name');
		if(objName == 'seqNo') inputs.eq(i).val('0');
		if(objName == 'idntfr') inputs.eq(i).val('');
	}
	$tr.after(newRow);
	$tbody.find('span[class="disp_order"]').each(function(i, obj){ $(obj).text(i+1); });
	isChange = true;
}
function removeRow(btn){
	var $tbody = $(btn).parent().parent().parent();
	var $trs = $tbody.find('tr');
	if($trs.length == 1){
		addRow(btn);
	}
	var $thisTr = $(btn).parent().parent();
	var seqNo = $thisTr.find('input[name="seqNo"]').val();
	if(seqNo != '0')
		$('#formArea').append($('<input type="hidden" name="delIdntfrSeqNo" value="'+seqNo+'" />)'));
	$thisTr.remove();
	$tbody.find('span[class="disp_order"]').each(function(i, obj){ $(obj).text(i+1); });
	isChange = true;
}
</script>
</head>
<body style="overflow-y: auto;">
<div class="popup_wrap">
	<div class="title_box">
		<h3><spring:message code="user.info"/></h3>
	</div>
	<div class="top_help_wrap">
		<div class="help_text" style="display: none;">
			<spring:message code="comment.user"/>
		</div>
		<p class="help_bt_box">
			<a href="#" class="help_link">Help</a>
			<a href="#" class="help_bt_r help_open">도움말 열기/닫기</a>
		</p>
	</div>

	<div class="list_bt_area">
		<div class="list_set">
			<ul>
				<li class="first_li"><a href="javascript:fn_save();" class="list_icon02"><spring:message code='common.button.save'/></a></li>
			</ul>
		</div>
		<c:if test="${not sessMode and sessionScope.auth.adminDvsCd ne 'R' }">
        <span style="float: right;padding-top: 12px;">
            최종수정일자 [ <fmt:formatDate value="${user.modDate}" pattern="yyyy-MM-dd HH:mm:ss"/> ]
        </span>
		</c:if>
	</div>

	<div id="mainLayout" style="position: relative; width: 100%;height: 100%;"></div>
	<script type="text/javascript"></script>

	<div id="basicInfo" class="mgt_10 mgl_10 mgr_10">
		<h3 class="circle_h3"><spring:message code='user.human'/></h3>
		<table class="write_tbl mgb_30"  >
			<colgroup>
				<col style="width:198px;" />
				<col style="width:140px;" />
				<col style="width:171px" />
				<col style="width:140px;" />
				<col style="" />
			</colgroup>
			<tbody>
			<tr>
				<td rowspan="6">
					<div id="profile" style="width: 180px;"></div>
					<div class="profile_bt_box">
						<a href="javascript:void(0);" class="profile_upload" onclick="fn_selectProfilePhoto();"><spring:message code="common.upload"/></a>
						<a href="javascript:void(0);" class="profile_del" onclick="fn_deleteProfilePhoto();"><spring:message code="common.photo.delete"/></a>
						<input type="hidden" name="profPhotoFileId"  id="profPhotoFileId" value="${user.profPhotoFileId}"/>
					</div>
					<div style="text-align: left;">※ <spring:message code='user.phto.size.cmt'/></div>
					<div style="text-align: left;">  (<spring:message code='user.phto.size.cmt2'/>) </div>
					<div id="vaultObj" style="display: none;"></div>
				</td>
				<th><spring:message code='user.nm.kor'/></th>
				<td colspan="3">${fn:escapeXml(user.korNm)}</td>
			</tr>
			<tr>
				<th><spring:message code='user.nm.eng'/></th>
				<td colspan="3">
					<table class="in_tbl inner_tbl">
						<colgroup>
							<col style="width:33%;"/>
							<col style="width:33%;"/>
							<col style="width:33%;"/>
						</colgroup>
						<thead>
						<tr>
							<th></th>
							<th>Last Name</th>
							<th>First Name</th>
						</tr>
						</thead>
						<tbody>
						<tr>
							<th>Full Name</th>
							<td><input type="text" id="lastName"  name="lastName"  class="input_type" value="${user.lastName}" /></td>
							<td><input type="text" id="firstName"  name="firstName"  class="input_type" value="${user.firstName}" /></td>
						</tr>
						<tr>
							<th>Abbr Name</th>
							<td><input type="text" id="abbrLastName"  name="abbrLastName"  class="input_type" value="${user.abbrLastName}" /></td>
							<td><input type="text" id="abbrFirstName"  name="abbrFirstName"  class="input_type" value="${user.abbrFirstName}" /></td>
						</tr>
						</tbody>
					</table>
				</td>
			</tr>
			<c:if test="${sessionScope.auth.adminDvsCd ne 'R' and sessionScope.auth.adminDvsCd ne 'S' }">
				<tr>
					<th><spring:message code='user.id'/></th>
					<td>${user.userId }</td>
					<th><spring:message code='user.bir'/></th>
					<td>${rims:toDateFormatToken(user.birthDt, '.')}</td>
				</tr>
				<tr>
					<th><spring:message code='user.sex'/></th>
					<td>${rims:codeValue('1370',user.sexDvsCd)}</td>
					<th><spring:message code='user.ntn'/></th>
					<td>${rims:codeValue('2000',user.ntntCd)}</td>
				</tr>
			</c:if>
			<tr>
				<th><spring:message code='user.office'/></th>
				<td>${user.ofcTelno}</td>
				<th><spring:message code='user.hp'/></th>
				<td>${user.hpTelno}</td>
			</tr>
			<tr>
				<th><spring:message code='user.email'/></th>
				<td>${user.emalAddr }</td>
				<th><spring:message code='user.kri.email'/></th>
				<td>
					<input type="radio" id="emalRcvYn" name="emalRcvYn" value="Y" <c:if test="${user.emalRcvYn eq 'Y' }">checked="checked"</c:if>/>&nbsp;<spring:message code='user.yes'/>&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="radio" id="emalRcvYn" name="emalRcvYn" value="N" <c:if test="${user.emalRcvYn eq 'N' }">checked="checked"</c:if>/>&nbsp;<spring:message code='user.no'/>
				</td>
			</tr>
			</tbody>
		</table>
		<%--
        <h3 class="circle_h3"><spring:message code='user.contact'/></h3>
        <table class="write_tbl mgb_30"  >
        <colgroup>
            <col style="width:140px;" />
            <col style="width:171px;" />
            <col style="width:140px" />
            <col style="width:171px;" />
            <col style="width:140px" />
            <col style="" />
        </colgroup>
        <tbody>
            <tr>
                <th><spring:message code='user.office'/></th>
                <td>${user.ofcTelno}</td>
                <th><spring:message code='user.hp'/></th>
                <td>${user.hpTelno}</td>
                <th><spring:message code='user.fax'/></th>
                <td>${user.faxNo}</td>
            </tr>
            <tr>
                <th><spring:message code='user.email'/></th>
                <td colspan="3">${user.emalAddr }</td>
                <th><spring:message code='user.kri.email'/></th>
                <td>
                    <input type="radio" id="emalRcvYn" name="emalRcvYn" value="Y" <c:if test="${user.emalRcvYn eq 'Y' }">checked="checked"</c:if>/><spring:message code='user.yes'/>
                    <input type="radio" id="emalRcvYn" name="emalRcvYn" value="N" <c:if test="${user.emalRcvYn eq 'N' }">checked="checked"</c:if>/><spring:message code='user.no'/>
                </td>
            </tr>
        </tbody>
        </table>
         --%>
		<c:if test="${sessionScope.auth.adminDvsCd ne 'R' and sessionScope.auth.adminDvsCd ne 'S' }">
			<h2 class="circle_h3"><spring:message code='user.agc'/></h2>
			<table class="write_tbl mgb_30"  >
				<colgroup>
					<col style="width:140px;" />
					<col style="width:171px;" />
					<col style="width:140px" />
					<col style="width:171px;" />
					<col style="width:140px" />
					<col style="" />
				</colgroup>
				<tbody>
				<tr>
					<th><spring:message code='user.univ'/></th>
					<td>${rims:codeValue('2030',user.clgCd)}</td>
					<th><spring:message code='user.dept'/></th>
					<td>
							${sysConf['inst.abrv']} : ${user.deptKor }<br/>
						KRI   : ${rims:codeValue('2050',user.sbjtCd)}
					</td>
					<th><spring:message code='user.graduate'/></th>
					<td>
						<select name="grdId" id="grdId" class="select_type">
								${rims:makeCodeList('2110', true, user.grdId)}
						</select>
					</td>
				</tr>
				<tr>
					<th><spring:message code='user.grade1'/></th>
					<td>${user.grade1}</td>
					<th><spring:message code='user.grade2'/></th>
					<td>
						<c:choose>
							<c:when test="${user.grade1 eq '교수' }">전임</c:when>
							<c:when test="${user.grade1 eq '부교수' }">전임</c:when>
							<c:when test="${user.grade1 eq '조교수' }">전임</c:when>
							<c:otherwise>비전임</c:otherwise>
						</c:choose>
					</td>
					<th><spring:message code='user.status'/></th>
					<td>${rims:codeValue('1010',user.hldofYn)}</td>
				</tr>
				<tr>
					<th><spring:message code='user.aptm'/></th>
					<td>
						<input type="text" class="input_type" name="ftfFirstAptmDate" id="ftfFirstAptmDate" value="${rims:toDateFormatToken(user.ftfFirstAptmDate, '.')}" />
					</td>
					<th><spring:message code='user.aptm.kaist'/></th>
					<td>${rims:toDateFormatToken(user.aptmDate, '.')}</td>
					<th><spring:message code='user.retr'/></th>
					<td>${rims:toDateFormatToken(user.retrDate, '.')}</td>
				</tr>
				</tbody>
			</table>
		</c:if>

		<h2 class="circle_h3">Homepage</h2>
		<table class="write_tbl mgb_30"  >
			<colgroup>
				<col style="width:140px;" />
				<col style="" />
			</colgroup>
			<tbody>
			<tr>
				<th>Homepage Address</th>
				<td>
					<input type="text" name="homePageAddr" id="homePageAddr" class="input_type" value="${user.homePageAddr}" />
				</td>
			</tr>
			</tbody>
		</table>

		<h2 class="circle_h3"><spring:message code='user.spnm.tit'/></h2>
		<table class="write_tbl mgb_30"  >
			<colgroup>
				<col style="width:140px;" />
				<col style="width:40%;" />
				<col style="width:40%;" />
			</colgroup>
			<thead>
			<tr>
				<th></th>
				<th><spring:message code='user.rch.kor'/></th>
				<th><spring:message code='user.rch.eng'/></th>
			</tr>
			</thead>
			<tbody>
			<tr>
				<th><spring:message code='user.spnm'/></th>
				<td><input type="text" class="input_type" name="spclNm" id="spclNm" value="${user.spclNm}" <c:if test="${empty user.spclNm}">style="background-color:#FFCC66"</c:if>/></td>
				<td><input type="text" class="input_type" name="spclEngNm" id="spclEngNm" value="${user.spclEngNm}" <c:if test="${empty user.spclEngNm}">style="background-color:#FFCC66"</c:if>/></td>
			</tr>
			<tr>
				<th><spring:message code='user.detail'/></th>
				<td><input type="text" class="input_type" name="dspclNm" id="dspclNm" value="${user.dspclNm}" <c:if test="${empty user.dspclNm}">style="background-color:#FFCC66"</c:if>/></td>
				<td><input type="text" class="input_type" name="dspclEngNm" id="dspclEngNm" value="${user.dspclEngNm}" <c:if test="${empty user.dspclEngNm}">style="background-color:#FFCC66"</c:if>/></td>
			</tr>
			</tbody>
		</table>

		<h2 class="circle_h3"><spring:message code='user.ttl.rch'/></h2>
		<table class="write_tbl mgb_30"  >
			<colgroup>
				<col style="width:140px;" />
				<col style="width:40%;" />
				<col style="width:40%;" />
			</colgroup>
			<thead>
			<tr>
				<th></th>
				<th><spring:message code='user.rch.kor'/></th>
				<th><spring:message code='user.rch.eng'/></th>
			</tr>
			</thead>
			<tbody>
			<tr>
				<th><spring:message code='user.major1'/></th>
				<td><input type="text" class="input_type" name="majorKor1" id="majorKor1" value="${user.majorKor1}" <c:if test="${empty user.majorKor1}">style="background-color:#FFCC66"</c:if>/></td>
				<td><input type="text" class="input_type" name="majorEng1" id="majorEng1" value="${user.majorEng1}" <c:if test="${empty user.majorEng1}">style="background-color:#FFCC66"</c:if>/></td>
			</tr>
			<tr>
				<th><spring:message code='user.major2'/></th>
				<td><input type="text" class="input_type" name="majorKor2" id="majorKor2" value="${user.majorKor2}" <c:if test="${empty user.majorKor2}">style="background-color:#FFCC66"</c:if>/></td>
				<td><input type="text" class="input_type" name="majorEng2" id="majorEng2" value="${user.majorEng2}" <c:if test="${empty user.majorEng2}">style="background-color:#FFCC66"</c:if>/></td>
			</tr>
			<tr>
				<th><spring:message code='user.major3'/></th>
				<td><input type="text" class="input_type" name="majorKor3" id="majorKor3" value="${user.majorKor3}" <c:if test="${empty user.majorKor3}">style="background-color:#FFCC66"</c:if>/></td>
				<td><input type="text" class="input_type" name="majorEng3" id="majorEng3" value="${user.majorEng3}" <c:if test="${empty user.majorEng3}">style="background-color:#FFCC66"</c:if>/></td>
			</tr>
			</tbody>
		</table>

	</div>
	<div id="submitInfo" class="mgt_10 mgl_10 mgr_10">
		<h2 class="circle_h3"><spring:message code='user.etc'/></h2>
		<table class="write_tbl mgb_30"  >
			<colgroup>
				<col style="width:140px;" />
				<col style="width:238px;" />
				<col style="width:120px" />
				<col style="width:171px;" />
				<col style="width:140px" />
				<col style="" />
			</colgroup>
			<tbody>
			<tr>
				<th><spring:message code='user.etc.agc'/></th>
				<td>
					<select name="othAgcInfoOffrYn" id="othAgcInfoOffrYn" class="select_type" onchange="disAgreeInfo();">
						${rims:makeCodeList('1260', true, user.othAgcInfoOffrYn)}
					</select>
				</td>
				<th><spring:message code='user.info1'/></th>
				<td colspan="3">
					<input type="radio" id="infoYes" name="infoOpenYn" class="typeRadio" value="1" ${user.infoOpenYn eq '1' ? 'checked="checked"' : '' } /><label for="infoYes" ><spring:message code='user.info2'/>&nbsp;&nbsp;</label>
					<input type="radio" id="infoNo" name="infoOpenYn" class="typeRadio" value="2"  ${user.infoOpenYn eq '2' ? 'checked="checked"' : '' }/><label for="infoNo"><spring:message code='user.info3'/>&nbsp;&nbsp;</label>
					<input type="radio" id="infoAllNo" name="infoOpenYn" class="typeRadio" value="3" ${user.infoOpenYn eq '3' ? 'checked="checked"' : '' }/><label for="infoAllNo"><spring:message code='user.info4'/>&nbsp;&nbsp;</label>
				</td>
			</tr>
			<tr>
				<th rowspan="2"><spring:message code='user.agr.yn'/></th>
				<td colspan="5"><spring:message code='user.info.comment'/></td>
			</tr>
			<tr>
				<td colspan="5">
					<table class="write_tbl"  >
						<colgroup>
							<col style="width:60%;" />
							<col style="" />
							<col style="width:150px;" />
						</colgroup>
						<thead>
						<tr>
							<th><spring:message code='user.org'/></th>
							<th><spring:message code='user.open.yn'/></th>
							<th><spring:message code='user.agr.date'/></th>
						</tr>
						</thead>
						<tbody>
						<c:forEach items="${user.infoProvdAgreList}" var="agre" varStatus="idx">
							<tr>
								<td>
										${rims:codeValue('2180',agre.infoProvdTrgetInsttCd) }
									<input type="hidden" name="infoProvdTrgetInsttCd" id="infoProvdTrgetInsttCd" value="${agre.infoProvdTrgetInsttCd}" />
									<input type="hidden" name="agreId" id="agreId" value="${not empty agre.agreId ? agre.agreId : '_blank'}" />
								</td>
								<td>
									<select name="infoProvdDvsCd" class="select_type">${rims:makeCodeList('3410', true, agre.infoProvdDvsCd)}</select>
								</td>
								<td><fmt:formatDate value="${agre.modDate}" pattern="yyyy-MM-dd"/></td>
							</tr>
						</c:forEach>
						</tbody>
					</table>
				</td>
			</tr>
			<tr>
				<td colspan="5">
					※ 재단<br/>
					<span style="margin-left: 10px;">-다른기관에 정보를 제공하는 것에 동의 하지 않습니다. 연구재단의 업무 처리를 위한 정보 이용에만 동의 합니다.</span><br/>
					※ 국가(공공)기관<br/>
					<span style="margin-left: 10px;">-국가(공공)기관에서 정보를 공동 활용하는 것에 동의합니다.(하위 목록에 없는 기관에도 정보가 제공됩니다.)</span><br/>
					※ 모든기관<br/>
					<span style="margin-left: 10px;">-국가(공공)기관 및 민간 업체와 정보를 공동 활용하는 것에 동의 합니다.</span><br/>
					※ 상세 설정 방법<br/>
					<span style="margin-left: 10px;">-특정 기관에만 정보를 제공하고 싶지 않은 경우 : 국가기관 선택, 해당기관 제공안함으로 설정</span><br/>
					<span style="margin-left: 10px;">-특정 기관에만 정보를 제공하고 싶은 경우 : 재단 선택, 해당기관 제공으로 설정</span><br/>
				</td>
			</tr>
			</tbody>
		</table>
	</div>

	<div id="idntfrInfo" class="mgt_10 mgl_10 mgr_10">
		<h2 class="circle_h3"><spring:message code="user.title.id"/></h2>
		<table class="write_tbl mgb_30"  >
			<colgroup>
				<col style="width:180px;" />
				<col style="width:300px;" />
				<col style="width:180px;" />
				<col style="" />
			</colgroup>
			<tbody>
			<tr>
				<th><spring:message code="user.prof.photo.IR_open.at"/></th>
				<td>
					<input type="radio" id="profPhotoIrOpenAtYes" name="profPhotoIrOpenAt" class="typeRadio" value="Y" ${user.profPhotoIrOpenAt eq 'Y' ? 'checked="checked"' : '' } />&nbsp;<label for="infoYes" ><spring:message code='common.radio.yes'/>&nbsp;&nbsp;</label>
					<input type="radio" id="profPhotoIrOpenAtNo" name="profPhotoIrOpenAt" class="typeRadio" value="N"  ${user.profPhotoIrOpenAt eq 'N' ? 'checked="checked"' : '' }/>&nbsp;<label for="infoNo"><spring:message code='common.radio.no'/>&nbsp;&nbsp;</label>
				</td>
				<th><spring:message code="user.idntfr.IR_open.at"/></th>
				<td>
					<input type="radio" id="userIdntfrIrOpenAtYes" name="userIdntfrIrOpenAt" class="typeRadio" value="Y" ${user.userIdntfrIrOpenAt eq 'Y' ? 'checked="checked"' : '' } />&nbsp;<label for="infoYes" ><spring:message code='common.radio.yes'/>&nbsp;&nbsp;</label>
					<input type="radio" id="userIdntfrIrOpenAtNo" name="userIdntfrIrOpenAt" class="typeRadio" value="N"  ${user.userIdntfrIrOpenAt eq 'N' ? 'checked="checked"' : '' }/>&nbsp;<label for="infoNo"><spring:message code='common.radio.no'/>&nbsp;&nbsp;</label>
				</td>
			</tr>
			<c:set var="dispCnt"  value="1"/>
			<c:forEach items="${user.idntfrList}" var="il" varStatus="idx">
				<c:if test="${il.idntfrSe ne 'UID' or ( il.idntfrSe eq 'UID' and sessionScope.auth.adminDvsCd ne 'R' and sessionScope.auth.adminDvsCd ne 'S')}">
					<c:if test="${dispCnt mod 2 eq 1 }"><tr></c:if>
					<th>
							${il.idntfrSeNm} <c:if test="${il.idntfrSe eq 'ORC'}">(${il.linkUrl})</c:if>
						<input type="hidden" name="seqNo" value="${il.seqNo}"/>
						<input type="hidden" name="idntfrSe" value="${il.idntfrSe}"/>
					</th>
					<td>
						<div class="r_add_bt">
							<input type="text" id="" name="idntfr" value="${il.idntfr}"  class="input_type"/>
							<span class="r_span_box">
                                <c:if test="${empty il.idntfr or empty il.linkUrl}">
									<a href="javascript:void(0);" class="tbl_icon_a tbl_link_n_icon">링크</a>
								</c:if>
                                <c:if test="${not empty il.idntfr and not empty il.linkUrl}">
									<a href="${il.linkUrl}${il.idntfr}" class="tbl_icon_a tbl_link_icon" target="_blank">링크</a>
								</c:if>
                            </span>
						</div>
					</td>
					<c:if test="${dispCnt mod 2 eq 0 }"></tr></c:if>
					<c:set var="dispCnt"  value="${dispCnt + 1 }"/>
				</c:if>
			</c:forEach>
			<c:if test="${dispCnt mod 2 eq 0 }"><td></td><td></td></tr></c:if>
			</tbody>
		</table>

		<table style="width: 100%">
			<tbody>
			<tr>
				<td style="width: 50%;vertical-align: top;">
					<h2 class="circle_h3"><spring:message code="user.title.alias"/></h2>
					<table class="write_tbl mgb_30"  style="border-right: 1px solid #b1b1b1;">
						<colgroup>
							<col style="width:50px;" />
							<col style="" />
							<col style="width:80px; " />
						</colgroup>
						<thead>
						<tr>
							<th>No</th>
							<th>Alias</th>
							<th></th>
						</tr>
						</thead>
						<tbody>
						<c:forEach items="${user.userAlaisList}" var="al" varStatus="idx">
							<tr>
								<td style="text-align: center;"><span class="disp_order">${idx.count}</span></td>
								<td>
									<input type="hidden" name="seqNo" value="${al.seqNo}"/>
									<input type="hidden" name="idntfrSe" value="${al.idntfrSe}"/>
									<input type="text" id="" name="idntfr" value="${al.idntfr}"  class="input_type"/>
								</td>
								<td>
									<a href="javascript:void(0);" class="tbl_icon_a row_add_bt" onclick="addRow($(this));"><spring:message code='common.add'/></a>
									<a href="javascript:void(0);" class="tbl_icon_a red_del" onclick="removeRow($(this));"><spring:message code='common.row.delete'/></a>
								</td>
							</tr>
						</c:forEach>
						</tbody>
					</table>
				</td>
				<td style="width: 50%;vertical-align: top;">
					<h2 class="circle_h3"><spring:message code="user.title.email"/></h2>
					<table class="write_tbl mgb_30"  style="border-left: 1px solid #b1b1b1;">
						<colgroup>
							<col style="width:50px; text-align: center;" />
							<col style="" />
							<col style="width:80px; " />
						</colgroup>
						<thead>
						<tr>
							<th>No</th>
							<th>E-mail</th>
							<th></th>
						</tr>
						</thead>
						<tbody>
						<c:forEach items="${user.userEmailList}" var="el" varStatus="idx">
							<tr>
								<td style="text-align: center;"><span class="disp_order">${idx.count}</span></td>
								<td>
									<input type="hidden" name="seqNo" value="${el.seqNo}"/>
									<input type="hidden" name="idntfrSe" value="${el.idntfrSe}"/>
									<input type="text" name="idntfr" value="${el.idntfr}"  class="input_type"/>
								</td>
								<td>
									<a href="javascript:void(0);" class="tbl_icon_a row_add_bt" onclick="addRow($(this));"><spring:message code='common.add'/></a>
									<a href="javascript:void(0);" class="tbl_icon_a red_del" onclick="removeRow($(this));"><spring:message code='common.row.delete'/></a>
								</td>
							</tr>
						</c:forEach>
						</tbody>
					</table>
				</td>
			</tr>
			</tbody>
		</table>
	</div>
</div>
<form id="formArea" name="formArea" action="${contextPath }/${preUrl}/user/modifyUser.do" method="post" enctype="multipart/form-data" ></form>
</body>
</html>