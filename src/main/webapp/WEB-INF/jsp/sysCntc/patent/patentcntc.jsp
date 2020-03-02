<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${sysConf['system.rims.jsp.title']}</title>
<%@include file="../../pageInit.jsp" %>
<link type="text/css" href="${contextPath}/css/layout.css" rel="stylesheet" />
<link type="text/css" href="${contextPath}/js/dhtmlx/skins/${sysConf['dhtmlx.skin']}/dhtmlx.css" rel="stylesheet" />
<script type="text/javascript" src="${contextPath}/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="${contextPath}/js/jquery/jquery-ui.min.js"></script>
<script type="text/javascript" src="${contextPath}/js/jquery/jquery.modal.js"></script>
<script type="text/javascript" src="${contextPath}/js/jquery/jquery.cookie-1.4.1.min.js"></script>
<script type="text/javascript" src="${contextPath}/js/dhtmlx/dhtmlx.js"></script>
<script type="text/javascript" src="${contextPath}/js/script.js"></script>
<script type="text/javascript" src="${contextPath}/js/output/patent.js"></script>
<style type="text/css">
.dhxwins_vp_dhx_terrace {overflow-y: auto; }
.dhxwins_vp_dhx_terrace div.dhxwin_active div.dhx_cell_wins div.dhx_cell_toolbar_def, .dhxwins_vp_dhx_terrace div.dhxwin_inactive div.dhx_cell_wins div.dhx_cell_toolbar_def { padding: 10px 0px 0; }
.dhx_toolbar_dhx_terrace { padding: 0; }
.popup_wrap{padding: 20px 40px 20px 40px;}
.diff{background-color:#FFCCCC;}
.dk_one_bt_box { position: relative; display: block; padding: 0 28px 0 0; }
.dk_one_bt_box .dk_r_bt { position: absolute; display: block; top:0; right:0;  width: 23px;}
.dk_one_bt_box.data_radio_type .dk_r_bt{ top:-5px;}

.tbl_cover_icon {background: url('<c:url value="/images/background/list_icon_set02.png"/>') no-repeat 2px -165px;}
</style>
<script type="text/javascript">
var dhxLayout, invtGrid, userGrid, pmsToolbar, rimsToolbar
$(function(){
	dhxLayout = new dhtmlXLayoutObject({
        parent: document.body,  // parent container
        pattern: "2U"           // layout's pattern
    });
	dhxLayout.cells("a").setText("PMS No. ${pmsPatent.srcId}${empty pmsPatent.delDvsCd ? '' : ' (<span style=\'color:red;\'>삭제</span>)'}")
	<c:choose>
		<c:when test="${null eq patentId}">dhxLayout.cells("b").setText("RIMS");</c:when>
		<c:otherwise>dhxLayout.cells("b").setText("RIMS No. ${patentId}");</c:otherwise>
	</c:choose>
	loadPmsInfo();
	loadRimsInfo();
	setTimeout(function() {compareValues();}, 1100);
});

function loadPmsInfo(){
	pmsToolbar = dhxLayout.cells("a").attachToolbar();
	pmsToolbar.setIconsPath("${dhtmlXImagePath}/icons_${sysConf['dhtmlx.skin']}/");
	pmsToolbar.setIconSize(18);
	pmsToolbar.setAlign("right");
	pmsToolbar.addButton("patent", 1, "지식재산 정보 반입", "complete.png", "complete.png");
	pmsToolbar.addButton("parti", 2, "전체 발명자 추가", "complete.png", "complete.png");
	pmsToolbar.addButton("skip", 3, "작업 제외", "complete.png", "complete.png");
	pmsToolbar.attachEvent("onClick", function(id) {
		if (id=="patent") setPatentData();
		else if (id=="parti") addPartiData();
		else if (id=="skip") skipData();
	});
	dhxLayout.cells("a").attachObject("pmsPatentInfo");
}

function loadRimsInfo(){
	rimsToolbar = dhxLayout.cells("b").attachToolbar();
	rimsToolbar.setIconsPath("${dhtmlXImagePath}/icons_${sysConf['dhtmlx.skin']}/");
	rimsToolbar.setIconSize(18);
	rimsToolbar.setAlign("right");
	<c:if test="${not empty pmsPatent.itlPprRgtRegNo}">
	rimsToolbar.addButton("search", 3, "KRI검색", "search.png", "search_dis.png");
	</c:if>
	rimsToolbar.addButton("compare", 1, "데이터 비교", "complete.png", "complete.png");
	rimsToolbar.addButton("save", 2, "<spring:message code='common.button.save'/>", "save.gif", "save_dis.gif");
	rimsToolbar.attachEvent("onClick", function(id) {
		if (id=="save") fn_save();
		else if (id=="compare") compareValues();
		else if (id=="search") vriferByKri('${patentId}');
	});
	dhxLayout.cells("b").attachObject("formObj");

	var patentId = '${patentId}';
	if(patentId) $.post("${contextPath}/${preUrl}/patent/modifyForm.do", {"patentId": patentId},null,'text').done(function(data){$('#formObj').html(data);});
	else $.post("${contextPath}/${preUrl}/patent/addForm.do", null,null,'text').done(function(data){$('#formObj').html(data);});
}

function compareValues(){
	var inputs = $('#pmsPatentInfo input');
	for (var i=0; i < inputs.length; i++) {
		var rimsId = inputs.eq(i).prop('id').replace("pms_", "");
		if (rimsId == "") continue;
		if (inputs.eq(i).val() != $('#'+rimsId).val()) {
			inputs.eq(i).addClass('diff');
			$('#'+rimsId).addClass('diff');
		} else {
			inputs.eq(i).removeClass('diff');
			$('#'+rimsId).removeClass('diff');
		}
	}
	var selects = $('#pmsPatentInfo select');
	for (var i=0; i < selects.length; i++) {
		var rimsId = selects.eq(i).prop('id').replace("pms_", "");
		if (selects.eq(i).val() != $('#'+rimsId).val()) {
			selects.eq(i).addClass('diff');
			$('#'+rimsId).addClass('diff');
		} else {
			selects.eq(i).removeClass('diff');
			$('#'+rimsId).removeClass('diff');
		}
	}
	var textareas = $('#pmsPatentInfo textarea');
	for (var i=0; i < textareas.length; i++) {
		var rimsId = textareas.eq(i).prop('id').replace("pms_", "");
		if (textareas.eq(i).val() != $('#'+rimsId).val()) {
			textareas.eq(i).addClass('diff');
			$('#'+rimsId).addClass('diff');
		} else {
			textareas.eq(i).removeClass('diff');
			$('#'+rimsId).removeClass('diff');
		}
	}
}
function fn_save() {
	var mappingAuthrCount = 0;
	$('input[name="prtcpntId"]').each(function(index){  if($(this).val() != '') mappingAuthrCount++ });
	if(mappingAuthrCount == 0)
	{
		dhtmlx.alert({type:"alert-warning",text:"발명자 사번을 입력하세요.<br/>(최소1명 이상)",callback:function(){}});
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

function dplctCheckAfterSubmit(){
	var frmAction = $('#formArea').prop('action');
	frmAction = frmAction.substr(frmAction.lastIndexOf('/'));
	if("addPatent.do" == frmAction) //신규입력인 경우에만 체크
	{
		var checkUrl = '${contextPath}/patent/dplctPatentCheck.do?'+$('#formArea').serialize() ;
		$.get(checkUrl, null, null, 'text').done(function(data){
			if(data.dplctAt == 'true')
			{
				dhtmlx.confirm({title:"중복특허유무", ok:"예", cancel:"아니오", text:"<spring:message code='win.per.dup01'/>",
					callback:function(result){
						if(result == true) authrCheckAfterSubmit();
						else if(result == false)
						{
							dhtmlx.alert({type:"alert-warning",text:"<spring:message code='win.per.dup02'/>",callback:function(){
								dplctPatentCheck();
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
function authrCheckAfterSubmit(){
	var authrRowCount = 0;
	$('input[name="prtcpntNm"]').each(function(index){  if($(this).val() != '') authrRowCount++ });
	var invtCnt = $('#invtCnt').val();
	if(invtCnt == '')
	{
		$('#invtCnt').val(authrRowCount);
		userCheckAfterSubmit();
	}
	else if(invtCnt != authrRowCount)
	{
		dhtmlx.confirm({
			title:"저자확인",
			ok:"예", cancel:"아니오",
			text:"<spring:message code='win.per.alert02'/>",
			callback:function(result){
				if(result)
				{
					$('#invtCnt').val(authrRowCount);
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
	var patentId = '${patentId}';
	var patentUrl = '';
	if (patentId) patentUrl = '<c:url value="/patentCntc/modifyPatentAjax.do" />';
	else patentUrl = '<c:url value="/patentCntc/addPatentAjax.do?srcId=${param.srcId}" />';
	userCheck();
	$.ajax({
		url : patentUrl,
		method: "POST",
		data : $('#formArea').serialize(),
		success : function(data) {
			alert(data);
			location.reload();
		}
	});
}

function setPatentData() {
	var inputs = $(".pms_data").find("input");
	for (var i=0; i < inputs.length; i++) {
		setData(inputs.eq(i).prop('id').replace("pms_", ""));
	}
	var radios = $(".pms_data").find("input:radio");
	for (var i=0; i < radios.length; i++) {
		setRadioData(radios.eq(i).prop('name').replace("pms_", ""));
	}
	var selects = $(".pms_data").find("select");
	for (var i=0; i < selects.length; i++) {
		setData(selects.eq(i).prop('id').replace("pms_", ""));
	}
	var textareas = $(".pms_data").find("textarea");
	for (var i=0; i < textareas.length; i++) {
		setData(textareas.eq(i).prop('id').replace("pms_", ""));
	}
}
function addPartiData() {
	var erpPrtcpnt = $("#pmsPrtcpnt").children("tbody").children("tr");
	for(var i=1; i <= erpPrtcpnt.length; i++) {
		addPmsPrtcpnt(i);
	}
}
function setData(id) {
	$("#"+id).val($("#pms_" + id).val());
}
function setRadioData(id) {
	var value = $('input:radio[name="pms_'+id+'"]:checked').val();
	$('input:radio[name="'+id+'"][value="'+value+'"]').prop('checked', true);
}
function setDate(id) {
	setData(id + "Year");
	setData(id + "Month");
	setData(id + "Day");
}
function setDatas(ids) {
	for (var i=0; i<ids.length; i++) {
		setData(ids[i]);
	}
}
function skipData(id) {
	if (confirm("해당 지식재산(특허)은 이제 목록에서 나타나지 않습니다. 계속 진행하시겠습니까?")) {
		$.ajax({
			url : '<c:url value="/patentCntc/updateStatusAjax.do?srcId=${param.srcId}" />',
			data : $('#formArea').serialize(),
			success : function(data) {
				if (data == "true") opener.myGrid_load();
				window.close();
			}
		});
	}
}
function addPmsPrtcpnt(num){
	var $tbody = $("#prtcpntTbl").children("tbody");
	var $tr = $tbody.children("tr").last();
	if ($tr.find("input[name=prtcpntNm]").val().trim() == "") {
		var inputs = $tr.find('input');
		for (var i=0; i < inputs.length; i++) {
			var objName = inputs.eq(i).prop('name');
			if (objName != 'prtcpntIndex' && objName != 'seqAuthor') inputs.eq(i).val($("#pms_"+objName+"_"+num).val());
		}
	} else {
		prtcpntIdx++;
		var newTr = $tr.clone();
		var inputs = newTr.find('input');
		for (var i=0; i < inputs.length; i++) {
			var objName = inputs.eq(i).prop('name');
			if (objName == 'prtcpntIndex') inputs.eq(i).prop('id', objName+"_"+prtcpntIdx).val(prtcpntIdx);
			else if (objName == 'seqAuthor') inputs.eq(i).prop('id', objName+"_"+prtcpntIdx).val('N');
			else inputs.eq(i).prop('id', objName+"_"+prtcpntIdx).val($("#pms_"+objName+"_"+num).val());
		}
		$tr.after(newTr);
	}
	$tbody.find('span[class="prtcpnt_order"]').each(function(i, obj){ $(obj).text(i+1); });
	isChange = true;
}
</script>
</head>
<body>
<div id="pmsPatentInfo" style="height: 100%;overflow-x: hidden;overflow-y:scroll;">
	<table class="write_tbl mgb_10" >
		<colgroup>
			<col style="width: 165px;"></col>
			<col style="width: 300px;"></col>
			<col style="width: 165px;"></col>
			<col style=""></col>
		</colgroup>
		<tbody>
			<tr>
				<th><spring:message code='patn.itl.ppr.rgt.dvs.cd'/></th>
				<td class="pms_data">
					<span class="dk_one_bt_box">
						<select id="pms_itlPprRgtDvsCd" class="select_type"  disabled="disabled" >${rims:makeCodeList('1080',true,pmsPatent.itlPprRgtDvsCd)}</select>
						<span class="dk_r_bt">
							<a href="javascript:void(0);" class="tbl_icon_a tbl_cover_icon" onclick="javascript:setData('itlPprRgtDvsCd');">반입</a>
						</span>
					</span>
				</td>
				<th><spring:message code='patn.acqs.dvs.cd'/></th>
				<td class="pms_data">
					<c:set var="acqsDvsCd"/>
					<c:choose>
						<c:when test="${not empty  pmsPatent.itlPprRgtRegNo}"><c:set var="acqsDvsCd" value="1"/></c:when>
						<c:when test="${empty  pmsPatent.itlPprRgtRegNo and not empty  pmsPatent.applRegNo}"><c:set var="acqsDvsCd" value="2"/></c:when>
					</c:choose>
					<span class="dk_one_bt_box">
						<select id="pms_acqsDvsCd" class="select_type" style="width: 49%;" disabled="disabled">${rims:makeCodeList('1090',true,acqsDvsCd)}</select>
						${pmsPatent.status}
						<span class="dk_r_bt">
							<a href="javascript:void(0);" class="tbl_icon_a tbl_cover_icon" onclick="javascript:setData('acqsDvsCd');">반입</a>
						</span>
					</span>
				</td>
			</tr>
			<tr>
				<th><spring:message code='patn.acqs.ntn.dvs.cd'/></th>
				<td class="pms_data">
					<span class="dk_one_bt_box">
						<select id="psm_acqsNtnDvsCd" class="select_type" disabled="disabled">${rims:makeCodeList('1140',true,pmsPatent.acqsNtnDvsCd)}</select>
						<span class="dk_r_bt">
							<a href="javascript:void(0);" class="tbl_icon_a tbl_cover_icon" onclick="javascript:setData('acqsNtnDvsCd');">반입</a>
						</span>
					</span>
				</td>
				<th><spring:message code='patn.appl.reg.ntn.cd'/></th>
				<td class="pms_data">
					<span class="dk_one_bt_box">
						<select id="pms_applRegNtnCd" class="select_type" disabled="disabled">${rims:makeCodeList('2000', true, pmsPatent.applRegNtnCd) }</select>
						<span class="dk_r_bt">
							<a href="javascript:void(0);" class="tbl_icon_a tbl_cover_icon" onclick="javascript:setData('applRegNtnCd');">반입</a>
						</span>
					</span>
				</td>
			</tr>
			<tr>
				<th><spring:message code='patn.itl.title.org'/>-PMS출원후</th>
				<td colspan="3" class="pms_data">
					<span class="dk_one_bt_box">
						<div class="tbl_textarea">
							<textarea maxLength="500" rows="3" id="pms_itlPprRgtNm" readonly="readonly">${pmsPatent.itlPprRgtNm}</textarea>
						</div>
						<span class="dk_r_bt">
							<a href="javascript:void(0);" class="tbl_icon_a tbl_cover_icon" onclick="javascript:setData('itlPprRgtNm');">반입</a>
						</span>
					</span>
				</td>
			</tr>
			<tr>
				<th><spring:message code='patn.itl.title.org'/>-PMS출원전</th>
				<td colspan="3" class="pms_data">
					<span class="dk_one_bt_box">
						<div class="tbl_textarea">
							<textarea maxLength="500" rows="3" id="pms_beforeItlPprRgtNm" readonly="readonly">${pmsPatent.beforeItlPprRgtNm}</textarea>
						</div>
						<span class="dk_r_bt">
							<%--
							<a href="javascript:void(0);" class="tbl_icon_a tbl_cover_icon" onclick="javascript:setData('itlPprRgtNm');">반입</a>
							--%>
						</span>
					</span>
				</td>
			</tr>

			<tr>
				<th>지식재산권명(타언어)</th>
				<td colspan="3" class="pms_data">
					<span class="dk_one_bt_box">
						<div class="tbl_textarea">
							<textarea maxLength="500" rows="2" id="pms_diffItlPprRgtNm" readonly="readonly">${pmsPatent.diffItlPprRgtNm}</textarea>
						</div>
						<span class="dk_r_bt">
							<a href="javascript:void(0);" class="tbl_icon_a tbl_cover_icon" onclick="javascript:setData('diffItlPprRgtNm');">반입</a>
						</span>
					</span>
				</td>
			</tr>
			<tr>
				<th><spring:message code='patn.appl.reg.date'/></th>
				<td class="pms_data">
					<span class="dk_one_bt_box">
						<input type="text" id="pms_applRegYear" class="input_type" style="width: 80px;" value="${pmsPatent.applRegYear=='0000'?'':pmsPatent.applRegYear }" readonly="readonly"/>&nbsp;<spring:message code='common.year'/>&nbsp;&nbsp;
						<input type="text" id="pms_applRegMonth" class="input_type" style="width: 45px;" value="${pmsPatent.applRegMonth=='00'?'':pmsPatent.applRegMonth }" readonly="readonly">&nbsp;<spring:message code='common.month'/>&nbsp;&nbsp;
						<input type="text" id="pms_applRegDay" class="input_type" style="width: 45px;" value="${pmsPatent.applRegDay=='00'?'':pmsPatent.applRegDay }" readonly="readonly">&nbsp;<spring:message code='common.day'/>&nbsp;&nbsp;
						<span class="dk_r_bt">
							<a href="javascript:void(0);" class="tbl_icon_a tbl_cover_icon" onclick="javascript:setDate('applReg');">반입</a>
						</span>
					</span>
				</td>
				<th><spring:message code='patn.appl.reg.no'/></th>
				<td class="pms_data">
					<span class="dk_one_bt_box">
						<input type="text" id="pms_applRegNo" maxLength="32" class="input_type" value="${pmsPatent.applRegNo}" readonly="readonly"/>
					    <span class="dk_r_bt">
							<a href="javascript:void(0);" class="tbl_icon_a tbl_cover_icon" onclick="javascript:setData('applRegNo');">반입</a>
					    </span>
					</span>
				</td>
			</tr>
			<tr>
				<th><spring:message code='patn.itl.ppr.rgt.reg.date'/></th>
				<td class="pms_data">
					<span class="dk_one_bt_box">
						<input type="text" id="pms_itlPprRgtRegYear" class="input_type" style="width: 80px;" value="${pmsPatent.itlPprRgtRegYear=='0000'?'':pmsPatent.itlPprRgtRegYear }" readonly="readonly"/>&nbsp;<spring:message code='common.year'/>&nbsp;&nbsp;
						<input type="text" id="pms_itlPprRgtRegMonth" class="input_type" style="width: 45px;" value="${pmsPatent.itlPprRgtRegMonth=='00'?'':pmsPatent.itlPprRgtRegMonth }" readonly="readonly"/>&nbsp;<spring:message code='common.month'/>&nbsp;&nbsp;
						<input type="text" id="pms_itlPprRgtRegDay" class="input_type" style="width: 45px;" value="${pmsPatent.itlPprRgtRegDay=='00'?'':pmsPatent.itlPprRgtRegDay }"  readonly="readonly"/>&nbsp;<spring:message code='common.day'/>&nbsp;&nbsp;
						<span class="dk_r_bt">
							<a href="javascript:void(0);" class="tbl_icon_a tbl_cover_icon" onclick="javascript:setDate('itlPprRgtReg');">반입</a>
						</span>
					</span>
				</td>
				<th><spring:message code='patn.itl.ppr.rgt.reg.no'/></th>
				<td class="pms_data">
					<span class="dk_one_bt_box">
						<input type="text" maxLength="50" id="pms_itlPprRgtRegNo" class="input_type" value="${pmsPatent.itlPprRgtRegNo}" readonly="readonly" />
					    <span class="dk_r_bt">
							<a href="javascript:void(0);" class="tbl_icon_a tbl_cover_icon" onclick="javascript:setData('itlPprRgtRegNo');">반입</a>
					    </span>
					</span>
				</td>
			</tr>
			<tr>
				<th><spring:message code='patn.appr.regt.nm'/></th>
				<td class="pms_data">
					<span class="dk_one_bt_box">
						<input type="text" maxLength="150" id="pms_applRegtNm" class="input_type " value="${pmsPatent.applRegtNm}"  readonly="readonly"/>
					    <span class="dk_r_bt">
							<a href="javascript:void(0);" class="tbl_icon_a tbl_cover_icon" onclick="javascript:setData('applRegtNm');">반입</a>
					    </span>
				    </span>
				</td>
				<th><spring:message code='patn.pat.cls.cd'/></th>
				<td class="pms_data">${pmsPatent.patClsCd }</td>
			</tr>
			<tr>
				<th><spring:message code='patn.invt.nm'/></th>
				<td colspan="3" class="pms_data">
					<div class="writer_td_inner">
						<em class="td_left_ex">${patent.invtNm}</em>
						<input type="hidden" id="pms_invtNm" value="${pmsPatent.invtNm}" />
						<p>
							<spring:message code='patn.invt.cnt'/>
							<input type="text" id="pms_invtCnt" class="input_type" style="width:30px;text-align: center;" value="${patent.invtCnt}" maxlength="3"  readonly="readonly"/>
							<em>ex) 5</em>
						</p>
					</div>
				</td>
			</tr>
			<tr>
				<td colspan="4" class="inner_tbl_td">
					<table class="in_tbl inner_tbl" id="pmsPrtcpnt">
						<thead>
							<tr>
								<th><spring:message code='patn.order'/></th>
								<th><spring:message code='patn.abbr.nm'/></th>
								<th><spring:message code='patn.user.id'/></th>
								<th>이메일</th>
								<th>유선</th>
								<th>무선</th>
								<th><spring:message code='patn.blng.agc.nm'/></th>
								<th><spring:message code='patn.author.dept'/></th>
							</tr>
						</thead>
						<tbody>
						<c:if test="${not empty pmsPatent.partiList}">
							<c:forEach items="${pmsPatent.partiList}" var="pl" varStatus="st">
								<tr>
									<td style="text-align: center;width: 50px;">
										<span class="prtcpnt_order">${st.count}</span>
										<input type="hidden" id="pms_prtcpntIndex_${st.count}" value="${st.count}"/>
									</td>
									<td style="width: 80px;">
										<input type="text" maxLength="30" id="pms_prtcpntNm_${st.count}" class="input_type" value="${pl.prtcpntNm}" readonly="readonly"/>
										<input type="hidden" id="pms_pcnRschrRegNo_${st.count}" value="${pl.pcnRschrRegNo}"/>
										<input type="hidden" id="pms_seqAuthor_${st.count}" value="${pl.seqAuthor}"/>
										<input type="hidden" id="pms_prtcpntFullNm_${st.count}"/>
									</td>
									<td style="width: 80px;">
										<input type="text" id="pms_prtcpntId_${st.count}" value="${pl.prtcpntId}"  class="input_type" readonly="readonly"/>
									</td>
									<td style="width: 80px;"><input type="text" class="input_type" value="${pl.email}" /></td>
									<td style="width: 80px;"><input type="text" class="input_type" value="${pl.telno}" /></td>
									<td style="width: 80px;"><input type="text" class="input_type" value="${pl.hpTelno}" /></td>
									<td style="width: 80px;">
										<input type="hidden" id="pms_blngAgcCd_${st.count}" value="${pl.blngAgcCd}"/>
										<input type="text"  id="pms_blngAgcNm_${st.count}" class="input_type" value="${pl.blngAgcNm}" readonly="readonly"/>
									</td>
									<td style="width: 150px;">
										<span class="dk_one_bt_box">
											<input type="text" class="input_type" value="${pl.deptKor}"/>
										    <span class="dk_r_bt">
												<a href="javascript:void(0);" class="tbl_icon_a tbl_cover_icon" onclick="javascript:addPmsPrtcpnt('${st.count}');"></a>
										    </span>
										</span>
									</td>
								</tr>
							</c:forEach>
						</c:if>
						</tbody>
					</table>
				</td>
			</tr>
			<tr>
				<th><spring:message code='patn.acqs.dtl.dvs.cd'/></th>
				<td class="pms_data">
					<span class="dk_one_bt_box data_radio_type">
						<input name="pms_acqsDtlDvsCd" type="radio" value="1" ${pmsPatent.acqsDtlDvsCd eq '1' ? "checked='checked'" : ''}  readonly="readonly" />&nbsp;<spring:message code='patn.dtl'/>&nbsp;&nbsp;
						<input name="pms_acqsDtlDvsCd" type="radio" value="2" ${pmsPatent.acqsDtlDvsCd eq '2' ? "checked='checked'" : ''}  readonly="readonly"  />&nbsp;<spring:message code='patn.pct'/>&nbsp;&nbsp;
						<input name="pms_acqsDtlDvsCd" type="radio" value="3" ${pmsPatent.acqsDtlDvsCd eq '3' ? "checked='checked'" : ''}  readonly="readonly"  />&nbsp;<spring:message code='patn.epo'/>&nbsp;&nbsp;
					    <span class="dk_r_bt">
							<a href="javascript:void(0);" class="tbl_icon_a tbl_cover_icon" onclick="javascript:setRadioData('acqsDtlDvsCd');">반입</a>
					    </span>
					</span>
				</td>
				<th><spring:message code='patn.pct.epo'/></th>
				<td class="pms_data">
					<span class="dk_one_bt_box">
						<input type="text" id="pms_pctEpoApplNtnCnt" class="input_type" value="${pmsPatent.pctEpoApplNtnCnt}" maxlength="3" readonly="readonly" />
					    <span class="dk_r_bt">
							<a href="javascript:void(0);" class="tbl_icon_a tbl_cover_icon" onclick="javascript:setData('pctEpoApplNtnCnt');">반입</a>
					    </span>
					</span>
				</td>
			</tr>
			<tr>
				<th><spring:message code='patn.smmr.cntn'/></th>
				<td colspan="3" class="pms_data">
					<span class="dk_one_bt_box">
						<div class="tbl_textarea">
							<textarea id="pms_smmrCntn" rows="7" readonly="readonly">${pmsPatent.smmrCntn}</textarea>
						</div>
					    <span class="dk_r_bt">
							<a href="javascript:void(0);" class="tbl_icon_a tbl_cover_icon" onclick="javascript:setData('smmrCntn');">반입</a>
					    </span>
					</span>
				</td>
			</tr>
			<tr>
				<th><spring:message code='patn.sbjt.no'/></th>
				<td class="pms_data">
					<table class="in_tbl inner_tbl">
						<colgroup>
							<col style="width:105px;" />
							<col style="width:162px;" />
							<col style="width: 63px;" />
						</colgroup>
						<tbody>
							<c:forEach items="${fundingMapngList}" var="fml" varStatus="idx">
							<tr>
								<td style="border-bottom: 0;"><input type="text" class="input_type" value="${fml.project_no}" /></td>
								<td style="border-bottom: 0;"><input type="text" class="input_type" value="${fml.project_name}" /></td>
							</tr>
							</c:forEach>
						</tbody>
					</table>
				</td>
				<th><spring:message code='patn.blng.univ'/></th>
				<td class="pms_data">
					<span class="dk_one_bt_box">
						<input type="text" id="pms_blngUnivCdValue" class="input_type" value="한국과학기술원"/>
						<input type="hidden" id="pms_blngUnivCdKey" value="610400"/>
						<span class="dk_r_bt">
							<a href="javascript:void(0);" class="tbl_icon_a tbl_cover_icon" onclick="javascript:setDatas(['blngUnivCdValue','blngUnivCdKey']);">반입</a>
						</span>
					</span>
				</td>
			</tr>
			<tr>
				<th>IPC</th>
				<td colspan="3" class="pms_data">
					<span class="dk_one_bt_box">
						<input type="text" name="pms_ipc" id="pms_ipc" class="input_type" value="${pmsPatent.ipc}" />
						<span class="dk_r_bt">
							<a href="javascript:void(0);" class="tbl_icon_a tbl_cover_icon" onclick="javascript:setData('ipc');">반입</a>
						</span>
				    </span>
				</td>
			</tr>
			<tr>
				<th>특허시스템 ID</th>
				<td class="pms_data">${pmsPatent.srcId }</td>
				<th>패밀리특허 코드</th>
				<td class="pms_data">
					<span class="dk_one_bt_box">
						<input type="text" id="pms_familyCode" class="input_type" value="${pmsPatent.familyCode}" readonly="readonly" style="width: 100px;" />
						<select id="pms_applDvsCd" class="select_type" style="width: 60px;">
							<option value=""></option>
							<option value="1" ${pmsPatent.applDvsCd=='1'?'selected=\'selected\'':''}>국내</option>
							<option value="2" ${pmsPatent.applDvsCd=='2'?'selected=\'selected\'':''}>해외</option>
							<option value="3" ${pmsPatent.applDvsCd=='3'?'selected=\'selected\'':''}>PCT</option>
							<option value="4" ${pmsPatent.applDvsCd=='4'?'selected=\'selected\'':''}>변경</option>
							<option value="5" ${pmsPatent.applDvsCd=='5'?'selected=\'selected\'':''}>분할</option>
							<option value="6" ${pmsPatent.applDvsCd=='6'?'selected=\'selected\'':''}>우선권</option>
						</select>
					    <span class="dk_r_bt">
							<a href="javascript:void(0);" class="tbl_icon_a tbl_cover_icon" onclick="javascript:setDatas(['familyCode','applDvsCd']);">반입</a>
					    </span>
					</span>
				</td>
			</tr>
			<tr>
			 	<th>신고서ID</th>
			 	<td class="pms_data">
			 		<span class="dk_one_bt_box">
				 		<input type="text" id="pms_pmsId" name="pms_pmsId" class="input_type" value="${pmsPatent.pmsId}" />
					    <span class="dk_r_bt">
							<a href="javascript:void(0);" class="tbl_icon_a tbl_cover_icon" onclick="javascript:setData('pmsId');">반입</a>
					    </span>
				 	</span>
				</td>
			 	<th>기관실적여부</th>
			 	<td class="pms_data">
			 		<span class="dk_one_bt_box data_radio_type">
			            KAIST <input type="radio" name="pms_insttRsltAt" value="Y" checked="checked" />
			            Other <input type="radio" name="pms_insttRsltAt" value="N" />
					    <span class="dk_r_bt">
							<a href="javascript:void(0);" class="tbl_icon_a tbl_cover_icon" onclick="javascript:setRadioData('insttRsltAt');">반입</a>
					    </span>
					</span>
			 	</td>
			</tr>
			<tr>
				<th><spring:message code='common.reg.date'/></th>
				<td><fmt:formatDate var="pms_regDate" value="${pmsPatent.regDate}" pattern="yyyy-MM-dd" /> ${pms_regDate}</td>
				<th><spring:message code='common.mod.date'/></th>
				<td><fmt:formatDate var="pms_modDate" value="${pmsPatent.modDate}" pattern="yyyy-MM-dd" /> ${pms_modDate}</td>
			</tr>
		</tbody>
	</table>
</div>
<div id="formObj" style="height: 100%; overflow: auto;"></div>

</body>
</html>