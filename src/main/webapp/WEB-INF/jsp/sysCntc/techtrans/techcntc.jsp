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
<script type="text/javascript" src="${contextPath}/js/output/techtrans.js"></script>
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
	dhxLayout.cells("a").setText("PMS No. ${pmsTechtrans.srcId}")
	<c:choose>
		<c:when test="${null eq techtransId}">dhxLayout.cells("b").setText("RIMS");</c:when>
		<c:otherwise>dhxLayout.cells("b").setText("RIMS No. ${techtransId}");</c:otherwise>
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
	pmsToolbar.addButton("techtrans", 1, "기술이전 정보 반입", "complete.png", "complete.png");
	pmsToolbar.addButton("royalty", 2, "전체 연도별입금내역 추가", "complete.png", "complete.png");
	pmsToolbar.addButton("parti", 3, "전체 참여자 추가", "complete.png", "complete.png");
	pmsToolbar.addButton("skip", 4, "작업 제외", "complete.png", "complete.png");
	pmsToolbar.attachEvent("onClick", function(id) {
		if (id=="techtrans") setTechtransData();
		else if (id=="royalty") addRoyaltyData();
		else if (id=="parti") addPartiData();
		else if (id=="skip") skipData();
	});
	dhxLayout.cells("a").attachObject("pmsTechtransInfo");
}

function loadRimsInfo(){
	rimsToolbar = dhxLayout.cells("b").attachToolbar();
	rimsToolbar.setIconsPath("${dhtmlXImagePath}/icons_${sysConf['dhtmlx.skin']}/");
	rimsToolbar.setIconSize(18);
	rimsToolbar.setAlign("right");
	rimsToolbar.addButton("compare", 1, "데이터 비교", "complete.png", "complete.png");
	rimsToolbar.addButton("save", 2, "<spring:message code='common.button.save'/>", "save.gif", "save_dis.gif");
	rimsToolbar.attachEvent("onClick", function(id) {
		if (id=="save") fn_save();
		else if (id=="compare") compareValues();
	});
	dhxLayout.cells("b").attachObject("formObj");

	var techtransId = '${techtransId}';
	if (techtransId) $.post("${contextPath}/${preUrl}/techtrans/modifyForm.do", {"techtransId": techtransId},null,'text').done(function(data){$('#formObj').html(data);});
	else $.post("${contextPath}/${preUrl}/techtrans/addForm.do", null,null,'text').done(function(data){$('#formObj').html(data);});
}

function compareValues(){
	var inputs = $('#pmsTechtransInfo input');
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
	var selects = $('#pmsTechtransInfo select');
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
	var textareas = $('#pmsTechtransInfo textarea');
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

function fn_save(){

	//1. 최소 1명 이상 맵핑?
	var mappingAuthrCount = 0;
	$('input[name="prtcpntId"]').each(function(index){  if($(this).val() != '') mappingAuthrCount++ });
	if(mappingAuthrCount == 0)
	{
		dhtmlx.alert({type:"alert-warning",text:"기술이전에 참여한 연구자 사번을 입력하세요.<br/>(최소1명 이상)",callback:function(){}});
		return;
	}
	// form submit
	userCheckAfterSubmit();

}
function userCheckAfterSubmit(){
	var techtransId = '${techtransId}';
	var techtransUrl = '';
	if (techtransId) techtransUrl = '<c:url value="/techtransCntc/modifyTechtransAjax.do" />';
	else techtransUrl = '<c:url value="/techtransCntc/addTechtransAjax.do" />';
	userCheck();
	$.ajax({
		url : techtransUrl,
		method: "POST",
		data : $('#formArea').serialize() + '&' + $('#pmsPatent :input').serialize(),
		success : function(data) {
			alert(data);
			location.reload();
		}
	});
}

function setTechtransData() {
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
function addRoyaltyData() {
	var pmsRoyalty = $("#pmsRoyalty").children("tbody").children("tr");
	for(var i=1; i <= pmsRoyalty.length; i++) {
		addPmsRoyalty(i);
	}
}
function addPartiData() {
	var pmsPrtcpnt = $("#pmsPrtcpnt").children("tbody").children("tr");
	for(var i=1; i <= pmsPrtcpnt.length; i++) {
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
function setDatas(ids) {
	for (var i=0; i<ids.length; i++) {
		setData(ids[i]);
	}
}
function skipData(id) {
	if (confirm("해당 기술이전은 이제 목록에서 나타나지 않습니다. 계속 진행하시겠습니까?")) {
		$.ajax({
			url : '<c:url value="/techtransCntc/updateStatusAjax.do?srcId=${param.srcId}" />',
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
	// 성명 필드값이 존재하면 추가, 없으면 덮어쓰기
	if ($tr.find("input[name=prtcpntNm]").val().trim() == "") {
		var inputs = $tr.find('input');
		for (var i=0; i < inputs.length; i++) {
			var objName = inputs.eq(i).prop('name');
			if (objName != 'prtcpntIndex' && objName != 'seqAuthor') inputs.eq(i).val($("#pms_"+objName+"_"+num).val());
		}
		var selects = $tr.find('select');
		for (var i=0; i < selects.length; i++) {
			var objName = selects.eq(i).prop('name');
			selects.eq(i).val($("#pms_"+objName+"_"+num).val());
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
		var selects = $tr.find('select');
		for (var i=0; i < selects.length; i++) {
			var objName = selects.eq(i).prop('name');
			selects.eq(i).prop('id', objName+"_"+prtcpntIdx).val($("#pms_"+objName+"_"+num).val());
		}
		$tr.after(newTr);
	}
	$tbody.find('span[class="prtcpnt_order"]').each(function(i, obj){ $(obj).text(i+1); });
	isChange = true;
}
function addPmsRoyalty(num){
	var $tbody = $("#royaltyTbl").children("tbody");
	var $tr = $tbody.children("tr").last();
	// 입금금액 필드값이 존재하면 추가, 없으면 덮어쓰기
	if ($tr.find("input[name=rpmAmt]").val().trim() == "") {
		var inputs = $tr.find('input');
		for (var i=0; i < inputs.length; i++) {
			var objName = inputs.eq(i).prop('name');
			if (objName != 'royaltyIndex' && objName != 'seqRoyalty') inputs.eq(i).val($("#pms_"+objName+"_"+num).val());
		}
	} else {
		royaltyIdx++;
		var newTr = $tr.clone();
		var inputs = newTr.find('input');
		for (var i=0; i < inputs.length; i++) {
			var objName = inputs.eq(i).prop('name');
			if (objName == 'royaltyIndex') inputs.eq(i).prop('id', objName+"_"+royaltyIdx).val(royaltyIdx);
			else if (objName == 'seqRoyalty') inputs.eq(i).prop('id', objName+"_"+royaltyIdx).val('N');
			else inputs.eq(i).prop('id', objName+"_"+royaltyIdx).val($("#pms_"+objName+"_"+num).val());
		}
		$tr.after(newTr);
	}
	$tbody.find('span[class="royalty_order"]').each(function(i, obj){ $(obj).text(i+1); });
	isChange = true;
}
</script>
</head>
<body>
<div id="pmsTechtransInfo" style="height: 100%;overflow-x: hidden;overflow-y:scroll;">
	<table class="write_tbl mgb_10">
		<colgroup>
			<col style="width: 140px;" />
			<col style="width: 325px;" />
			<col style="width: 140px" />
			<col style="" />
		</colgroup>
		<tbody>
			<tr>
				<th class="essential_th"><spring:message code='tech.transr.ym'/></th>
				<td class="pms_data">
					<span class="dk_one_bt_box">
						<input type="text" maxLength="4" style="width: 62px;text-align: right;" id="pms_techTransrYear" class="input_type required"  value="<c:out value="${pmsTechtrans.techTransrYear}"/>"/><spring:message code='common.year'/>
						<input type="text" maxLength="2" style="width: 32px;text-align: right;" id="pms_techTransrMonth" class="input_type required"  value="<c:out value="${pmsTechtrans.techTransrMonth}"/>" /><spring:message code='common.month'/>
						<span class="dk_r_bt">
							<a href="javascript:void(0);" class="tbl_icon_a tbl_cover_icon" onclick="javascript:setDatas(['techTransrYear','techTransrMonth']);">반입</a>
						</span>
					</span>
				</td>
				<th class="add_help">
					<spring:message code='tech.transr.corp.nm'/><a href="javascript:void(0);" onclick="showTooltip($(this))" class="tbl_help_a"></a>
					<p class="th_help_box"><span><spring:message code='tooltip.tech1'/></span></p>
				</th>
				<td class="pms_data">
					<span class="dk_one_bt_box">
						<input type="text" id="pms_techTransrCorpNm" class="input_type" value="<c:out value="${pmsTechtrans.techTransrCorpNm}"/>"/>
						<span class="dk_r_bt">
							<a href="javascript:void(0);" class="tbl_icon_a tbl_cover_icon" onclick="javascript:setData('techTransrCorpNm');">반입</a>
						</span>
					</span>
				</td>
			</tr>
			<tr>
				<th><spring:message code='tech.transr.type'/></th>
				<td class="pms_data">
					<c:choose>
						<c:when test="${pmsTechtrans.techTransrCd=='권리양도' }"><c:set var="pmsTechTransrCd" value="1" /></c:when>
						<c:when test="${pmsTechtrans.techTransrCd=='전용실시권' }"><c:set var="pmsTechTransrCd" value="2" /></c:when>
						<c:when test="${pmsTechtrans.techTransrCd=='통상실시권' }"><c:set var="pmsTechTransrCd" value="3" /></c:when>
					</c:choose>
					<span class="dk_one_bt_box">
						<select id="pms_techTransrCd" class="select_type" style="width: 100px;">${rims:makeCodeList('tech.techTransrCd', true, pmsTechTransrCd)}</select>
						<input type="text" class="input_type" style="width: 100px;" value="<c:out value="${pmsTechtrans.techTransrCd }"/>"/>
						<span class="dk_r_bt">
							<a href="javascript:void(0);" class="tbl_icon_a tbl_cover_icon" onclick="javascript:setData('techTransrCd');">반입</a>
						</span>
					</span>
				</td>
				<th><spring:message code='tech.collection.type'/></th>
				<td class="pms_data">
					<c:choose>
						<c:when test="${pmsTechtrans.collectionCd=='변동기술료' }"><c:set var="pmsCollectionCd" value="CTR" /></c:when>
						<c:when test="${pmsTechtrans.collectionCd=='정액기술료' }"><c:set var="pmsCollectionCd" value="FTR" /></c:when>
						<c:when test="${pmsTechtrans.collectionCd=='정액기술료분납' }"><c:set var="pmsCollectionCd" value="FRI" /></c:when>
					</c:choose>
					<span class="dk_one_bt_box">
						<select id="pms_collectionCd" class="select_type">${rims:makeCodeList('tech.collectionCd', true, pmsCollectionCd)}</select>
						<span class="dk_r_bt">
							<a href="javascript:void(0);" class="tbl_icon_a tbl_cover_icon" onclick="javascript:setData('collectionCd');">반입</a>
						</span>
					</span>
				</td>
			</tr>
			<tr>
				<th class="essential_th"><spring:message code='tech.transr.nm'/></th>
				<td colspan="3" class="pms_data">
					<span class="dk_one_bt_box">
						<input type="text" id="pms_techTransrNm" class="input_type" value="<c:out value="${pmsTechtrans.techTransrNm}"/>"/>
						<span class="dk_r_bt">
							<a href="javascript:void(0);" class="tbl_icon_a tbl_cover_icon" onclick="javascript:setData('techTransrNm');">반입</a>
						</span>
					</span>
				</td>
			</tr>
			<tr>
				<th class="essential_th"><spring:message code='tech.transr.cnt'/></th>
				<td class="pms_data">
					<span class="dk_one_bt_box">
						<input type="text" id="pms_techTransrCnt" maxLength="6" class="input_type required" value="${fn:length(pmsTechtrans.patentMapngList)}" />
						<span class="dk_r_bt">
							<a href="javascript:void(0);" class="tbl_icon_a tbl_cover_icon" onclick="javascript:setData('techTransrCnt');">반입</a>
						</span>
					</span>
				</td>
				<th class="essential_th add_help">
					<spring:message code='tech.asso.tech.poss.cnt'/><a href="javascript:void(0);" onclick="showTooltip($(this))" class="tbl_help_a"></a>
					<p class="th_help_box"><span><spring:message code='tooltip.tech2'/></span></p>
				</th>
				<td class="pms_data">
					<span class="dk_one_bt_box">
						<input type="text" id="pms_assoTechPossCnt" maxLength="6" class="input_type required" value="${fn:length(pmsTechtrans.partiList)}"/>
						<span class="dk_r_bt">
							<a href="javascript:void(0);" class="tbl_icon_a tbl_cover_icon" onclick="javascript:setData('assoTechPossCnt');">반입</a>
						</span>
					</span>
				</td>
			</tr>
			<tr>
				<th><spring:message code='tech.blng.univ'/></th>
				<td class="pms_data">
					<span class="dk_one_bt_box">
						<input type="text" style="color: #aaa;" id="pms_blngUnivCdValue" class="input_type" value="한국과학기술원"/>
						<input type="hidden" id="pms_blngUnivCdKey" value="610400"/>
						<span class="dk_r_bt">
							<a href="javascript:void(0);" class="tbl_icon_a tbl_cover_icon" onclick="javascript:setDatas(['blngUnivCdValue','blngUnivCdKey']);">반입</a>
						</span>
					</span>
				</td>
				<td></td>
				<td></td>
			</tr>
			<tr>
				<th><spring:message code='tech.cntrct.mgt.no'/></th>
				<td class="pms_data">
					<span class="dk_one_bt_box">
						<input type="text" id="pms_cntrctManageNo" class="input_type" value="<c:out value="${pmsTechtrans.cntrctManageNo}"/>" />
						<span class="dk_r_bt">
							<a href="javascript:void(0);" class="tbl_icon_a tbl_cover_icon" onclick="javascript:setData('cntrctManageNo');">반입</a>
						</span>
					</span>
				</td>
				<th><spring:message code='tech.cntrct.period'/></th>
				<td class="pms_data">
					<span class="dk_one_bt_box">
						<input type="text" id="pms_cntrctSttYear" class="input_type" style="width: 40px;" value="<c:out value="${pmsTechtrans.cntrctSttYear }"/>"/><spring:message code='common.year'/>
						<input type="text" id="pms_cntrctSttMonth" class="input_type" style="width: 25px;" value="<c:out value="${pmsTechtrans.cntrctSttMonth}"/>"/><spring:message code='common.month'/>
						&nbsp;~&nbsp;
						<input type="text" id="pms_cntrctEndYear" class="input_type" style="width: 40px;" value="<c:out value="${pmsTechtrans.cntrctEndYear}"/>" /><spring:message code='common.year'/>
						<input type="text" id="pms_cntrctEndMonth" class="input_type" style="width: 25px;" value="<c:out value="${pmsTechtrans.cntrctEndMonth}"/>" /><spring:message code='common.month'/>
						<span class="dk_r_bt">
							<a href="javascript:void(0);" class="tbl_icon_a tbl_cover_icon" onclick="setDatas(['cntrctSttYear','cntrctSttMonth','cntrctEndYear','cntrctEndMonth']);">반입</a>
						</span>
					</span>
				</td>
			</tr>
			<tr>
				<th><spring:message code='tech.cntrct.amt'/></th>
				<td class="pms_data">
					<span class="dk_one_bt_box">
						<input type="text" style="width: 150px;text-align: right;" id="pms_cntrctAmt" maxLength="15" class="input_type" value="<fmt:formatNumber value="${pmsTechtrans.cntrctAmt}"/>"/>
						<select style="width: 65px;" id="pms_rpmAmtUnit" class="select_type">${rims:makeCodeList('tech.rpmAmtUnit', true, pmsTechtrans.rpmAmtUnit)}</select>
						<span class="dk_r_bt">
							<a href="javascript:void(0);" class="tbl_icon_a tbl_cover_icon" onclick="setDatas(['cntrctAmt','rpmAmtUnit']);">반입</a>
						</span>
					</span>
				</td>
				<th><spring:message code='tech.oprtn.cnd'/></th>
				<td class="pms_data">
					<span class="dk_one_bt_box">
						<input type="text" id="pms_oprtnCnd" class="input_type" value="<c:out value="${pmsTechtrans.oprtnCnd}"/>"/>
						<span class="dk_r_bt">
							<a href="javascript:void(0);" class="tbl_icon_a tbl_cover_icon" onclick="setData('oprtnCnd');">반입</a>
						</span>
					</span>
				</td>
			</tr>
			<tr>
				<th><spring:message code='tech.rpm'/></th>
				<td colspan="3"></td>
			</tr>
			<tr>
				<td colspan="4" class="inner_tbl_td">
					<div style="overflow: auto;">
						<table class="inner_tbl" id="pmsRoyalty">
							<colgroup>
								<col style="width:60px;" />
								<col style="width:150px;" />
								<col style="width:100px;" />
								<col style="width:200px;" />
								<col />
							</colgroup>
							<thead>
								<tr>
									<th>No</th>
									<th><spring:message code='tech.rooyalty.type'/></th>
									<th><spring:message code='tech.rpm.tme'/></th>
									<th><spring:message code='tech.rpm.date'/></th>
									<th><spring:message code='tech.rpm.amt'/></th>
								</tr>
							</thead>
							<tbody>
								<c:if test="${not empty pmsTechtrans.royaltyList}">
								<c:forEach items="${pmsTechtrans.royaltyList}" var="rl" varStatus="idx">
								<tr>
									<td style="text-align: center;"><span>${idx.count}</span></td>
									<td><select id="pms_collectionType_${idx.count}" class="select_type">${rims:makeCodeList('tech.collectionType', true, rl.collectionType)}</select></td>
									<td><input type="text" id="pms_rpmTme_${idx.count}" value="<c:out value="${rl.rpmTme}"/>" class="input_type"/></td>
									<td><input type="text" id="pms_rpmDate_${idx.count}" value="<c:out value="${rl.rpmDate}"/>" class="input_type"/></td>
									<td>
										<span class="dk_one_bt_box">
											<input type="text" style="width:250px; text-align: right;" id="pms_rpmAmt_${idx.count}" class="input_type" value="<fmt:formatNumber value="${rl.rpmAmt}"/>" /><spring:message code='fund.won'/>
										    <span class="dk_r_bt">
												<a href="javascript:void(0);" class="tbl_icon_a tbl_cover_icon" onclick="javascript:addPmsRoyalty('${idx.count}');"></a>
										    </span>
										</span>
									</td>
								</tr>
								</c:forEach>
								</c:if>
							</tbody>
						</table>
					</div>
				</td>
			</tr>
			<tr>
			   	<th><spring:message code='tech.parti'/></th>
			   	<td colspan="3"></td>
			</tr>
			<tr>
				<td colspan="4" class="inner_tbl_td">
					<table class="inner_tbl" id="pmsPrtcpnt">
						<colgroup>
							<col style="width:60px;" />
							<col style="width:110px;" />
							<col style="width:120px;" />
							<col style="width:110px;" />
							<col style="width:140px;" />
							<col style="width:190px;" />
							<col />
						</colgroup>
						<thead>
							<tr>
								<th>No</th>
								<th class="essential_th"><spring:message code='tech.parti.name'/></th>
								<th><spring:message code='tech.parti.full.name'/></th>
								<th><spring:message code='tech.parti.role'/></th>
								<th><spring:message code='tech.parti.id'/></th>
								<th><spring:message code='tech.parti.aff'/></th>
								<th><spring:message code='tech.parti.dept'/></th>
							</tr>
						</thead>
						<tbody>
							<c:if test="${not empty pmsTechtrans.partiList}">
							<c:forEach items="${pmsTechtrans.partiList}" var="pl" varStatus="idx">
							<tr>
								<td style="text-align: center;"><span>${idx.count}</span></td>
	 					  		<td><input type="text" id="pms_prtcpntNm_${idx.count}" class="input_type required" value="<c:out value="${pl.prtcpntNm}"/>" /></td>
	 					  		<td><input type="text" id="pms_prtcpntFullNm_${idx.count}" class="input_type" value="<c:out value="${pl.prtcpntFullNm}"/>" /></td>
	 					  		<td><select id="pms_tpiDvsCd_${idx.count}" class="select_type">${rims:makeCodeList('1340', true, pl.tpiDvsCd) }</select></td>
								<td><input type="text" id="pms_prtcpntId_${idx.count}" class="input_type" value="<c:out value="${pl.prtcpntId}"/>" /></td>
								<td>
									<input type="text" id="pms_blngAgcNm_${idx.count}"  class="input_type" style="${pl.blngAgcNm eq '' && pl.blngAgcCd eq '' ? 'background-color: #fef3d7;' : ''}" value="<c:out value="${pl.blngAgcNm}"/>" />
									<input type="hidden" id="pms_blngAgcCd_${idx.count}" value="<c:out value="${pl.blngAgcCd}"/>"/>
								</td>
	 					  		<td class="dispDept">
	 					  			<span class="dk_one_bt_box">
	 					  				<input type="text" class="input_type" value="<c:out value="${pl.deptKor}"/>" />
									    <span class="dk_r_bt">
											<a href="javascript:void(0);" class="tbl_icon_a tbl_cover_icon" onclick="javascript:addPmsPrtcpnt('${idx.count}');"></a>
										</span>
									</span>
									<input type="hidden" id="pms_tpiRate" value="<c:out value="${empty pl.tpiRate ? '_blank' : pl.tpiRate}"/>"/>
	 					  		</td>
							</tr>
							</c:forEach>
							</c:if>
						</tbody>
					</table>
				</td>
			</tr>
			<tr>
			   	<th>관련특허</th>
			   	<td colspan="3"></td>
			</tr>
			<tr>
				<td colspan="4" class="inner_tbl_td">
					<table class="inner_tbl" id="pmsPatent">
						<colgroup>
							<col style="width:60px;" />
							<col style="width:100px;" />
							<col style="width:140px;" />
							<col />
						</colgroup>
						<thead>
							<tr>
								<th>번호</th>
								<th>RIMS관리번호</th>
								<th>출원번호</th>
								<th>지식재산권명</th>
							</tr>
						</thead>
						<tbody>
							<c:if test="${not empty pmsTechtrans.patentMapngList}">
							<c:forEach items="${pmsTechtrans.patentMapngList}" var="pml" varStatus="idx">
							<tr>
								<td style="text-align: center;"><span>${idx.count}</span></td>
	 					  		<td><input type="text" name="patentId" class="input_type" value="<c:out value="${pml.patentId}"/>" /></td>
	 					  		<td><input type="text" class="input_type" value="<c:out value="${pml.applRegNo}"/>" /></td>
	 					  		<td><input type="text" class="input_type" value="<c:out value="${pml.itlPprRgtNm}"/>" /></td>
							</tr>
							</c:forEach>
							</c:if>
						</tbody>
					</table>
				</td>
			</tr>
			<tr>
				<th>소스구분</th>
				<td class="pms_data">
					<span class="dk_one_bt_box">
						<select id="pms_src" class="select_type" style="width: 100px;">
							<option value="">직접입력</option>
							<option value="PMS" selected="selected">PPMS</option>
						</select>
						<span class="dk_r_bt">
							<a href="javascript:void(0);" class="tbl_icon_a tbl_cover_icon" onclick="setData('src');">반입</a>
						</span>
					</span>
				</td>
				<th>특허시스템ID</th>
				<td class="pms_data">
					<span class="dk_one_bt_box">
						<input type="text" id="pms_srcId" class="input_type" value="<c:out value="${pmsTechtrans.srcId}"/>"/>
						<span class="dk_r_bt">
							<a href="javascript:void(0);" class="tbl_icon_a tbl_cover_icon" onclick="setData('srcId');">반입</a>
						</span>
					</span>
				</td>
			</tr>
			<tr>
				<th><spring:message code='common.reg.date'/></th>
				<td><fmt:formatDate var="regDate" value="${pmsTechtrans.regDate}" pattern="yyyy-MM-dd" /><c:out value="${regDate}"/></td>
				<th><spring:message code='common.mod.date'/></th>
				<td><fmt:formatDate var="modDate" value="${pmsTechtrans.modDate}" pattern="yyyy-MM-dd" /><c:out value="${modDate}"/></td>
			</tr>
		</tbody>
	</table>
</div>
<div id="formObj" style="height: 100%; overflow: auto;"></div>

</body>
</html>