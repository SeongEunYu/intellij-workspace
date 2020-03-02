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
<script type="text/javascript" src="${contextPath}/js/output/funding.js"></script>
<style type="text/css">
.dhxwins_vp_dhx_terrace {overflow-y: auto; }
.dhxwins_vp_dhx_terrace div.dhxwin_active div.dhx_cell_wins div.dhx_cell_toolbar_def, .dhxwins_vp_dhx_terrace div.dhxwin_inactive div.dhx_cell_wins div.dhx_cell_toolbar_def { padding: 10px 0px 0; }
.dhx_toolbar_dhx_terrace { padding: 0; }
.popup_wrap{padding: 20px 40px 20px 40px;}
.diff{background-color:#FFCCCC;}
.dk_one_bt_box { position: relative; display: block; padding: 0 28px 0 0; }
.dk_one_bt_box .dk_r_bt { position: absolute; display: block; top:0; right:0;  width: 23px;}
.tbl_cover_icon {background: url('<c:url value="/images/background/list_icon_set02.png"/>') no-repeat 2px -165px;}
</style>
<c:choose>
	<c:when test="${funding.apprDvsCd == 'APPROVED'}"><c:set var="apprDvsNm" value="(상태: 승인)" /></c:when>
	<c:when test="${funding.apprDvsCd == 'UNAPPROVED'}"><c:set var="apprDvsNm" value="(상태: 미승인)" /></c:when>
	<c:when test="${funding.apprDvsCd == 'REJECTED'}"><c:set var="apprDvsNm" value="(상태: 거절)" /></c:when>
	<c:when test="${funding.apprDvsCd == 'CLOSED'}"><c:set var="apprDvsNm" value="(상태: 종료)" /></c:when>
</c:choose>
<c:choose>
	<c:when test="${param.overallFlag == 'T'}"><c:set var="taskType" value="총괄과제" /></c:when>
	<c:when test="${param.overallFlag == 'S'}"><c:set var="taskType" value="서브과제(${funding.taskNum})" /></c:when>
</c:choose>
<script type="text/javascript">
var dhxLayout, erpToolbar, rimsToolbar;
$(function(){
	dhxLayout = new dhtmlXLayoutObject({
		parent: document.body,  // parent container
		pattern: "2U"           // layout's pattern
	});
	dhxLayout.cells("a").setText('ERP <c:out value="${taskType}" /> No. ${funding.erpId} <c:out value="${apprDvsNm}" />');
	<c:choose>
		<c:when test="${null eq fundingId}">dhxLayout.cells("b").setText("RIMS");</c:when>
		<c:otherwise>dhxLayout.cells("b").setText("RIMS No. ${fundingId}");</c:otherwise>
	</c:choose>
	loadErpFundingInfo();
	loadRimsFundingInfo();
	setTimeout(function() {compareValues();}, 1100);
});

function loadErpFundingInfo() {
	erpToolbar = dhxLayout.cells("a").attachToolbar();
	erpToolbar.setIconsPath("${dhtmlXImagePath}/icons_${sysConf['dhtmlx.skin']}/");
	erpToolbar.setIconSize(18);
	erpToolbar.setAlign("right");
	erpToolbar.addButton("funding", 1, "연구과제 정보 반입", "complete.png", "complete.png");
	erpToolbar.addButton("parti", 2, "전체 참여자 추가", "complete.png", "complete.png");
	erpToolbar.addButton("manager", 3, "연구책임자 추가", "complete.png", "complete.png");
	erpToolbar.addButton("skip", 4, "작업 제외", "complete.png", "complete.png");
	erpToolbar.attachEvent("onClick", function(id) {
		if (id=="funding") setFundingData();
		else if (id=="parti") addPartiData();
		else if (id=="manager") addPrincipalManager();
		else if (id=="skip") skipData();
	});
	dhxLayout.cells("a").attachObject("erpFundingInfo");
}
function loadRimsFundingInfo() {
	rimsToolbar = dhxLayout.cells("b").attachToolbar();
	rimsToolbar.setIconsPath("${dhtmlXImagePath}/icons_${sysConf['dhtmlx.skin']}/");
	rimsToolbar.setIconSize(18);
	rimsToolbar.setAlign("right");
	rimsToolbar.addButton("prtcpntcnt", 1, "연구자수 수정", "complete.png", "complete.png");
	rimsToolbar.addButton("compare", 2, "데이터 비교", "complete.png", "complete.png");
	rimsToolbar.addButton("save", 3, "<spring:message code='common.button.save'/>", "save.gif", "save_dis.gif");
	rimsToolbar.attachEvent("onClick", function(id) {
		if (id=="save") fn_save();
		else if (id=="compare") compareValues();
		else if (id=="prtcpntcnt") updatePrtcpntCnt();
	});
	dhxLayout.cells("b").attachObject("formObj");

	var fundingId = '${fundingId}';
	if (fundingId) $.post("${contextPath}/${preUrl}/funding/modifyForm.do", {"fundingId": fundingId}, null, 'text').done(function(data) {
	    $('#formObj').html(data);
	    //참여자행의 배경색
        for(var i=0; i<$("#prtcpntTbl tbody tr").length; i++){
            var prtcpntTd = $("#prtcpntTbl tbody tr").eq(i).find("td");
            if(prtcpntTd.eq(3).find("select").val() == 1 || prtcpntTd.eq(3).find("select").val() == 4){
                //연구책임자 일때
                $("#prtcpntTbl tbody tr").eq(i).css("background-color","yellowgreen");
            }else if(!isNaN(prtcpntTd.eq(4).find("input[name='prtcpntId']").val()) && prtcpntTd.eq(4).find("input[name='prtcpntId']").val() <=5000){
                //사번이 5000이하 일때
                $("#prtcpntTbl tbody tr").eq(i).css("background-color"," yellow");
            }
        }
	});
	else $.post("${contextPath}/${preUrl}/funding/addForm.do", null, null, 'text').done(function(data) {$('#formObj').html(data);});
}
function compareValues() {
	var inputs = $('#erpFundingInfo input');
	for (var i=0; i < inputs.length; i++) {
		var rimsId = inputs.eq(i).prop('id').replace("erp_", "");
		if (rimsId == "") continue;
		if (inputs.eq(i).val() != $('#'+rimsId).val()) {
			inputs.eq(i).addClass('diff');
			$('#'+rimsId).addClass('diff');
		} else {
			inputs.eq(i).removeClass('diff');
			$('#'+rimsId).removeClass('diff');
		}
	}
	var selects = $('#erpFundingInfo select');
	for (var i=0; i < selects.length; i++) {
		var rimsId = selects.eq(i).prop('id').replace("erp_", "");
		if (selects.eq(i).val() != $('#'+rimsId).val()) {
			selects.eq(i).addClass('diff');
			$('#'+rimsId).addClass('diff');
		} else {
			selects.eq(i).removeClass('diff');
			$('#'+rimsId).removeClass('diff');
		}
	}
}

function fn_save() {
    updatePrtcpntCnt(); //연구자수 수정

	var sbjtNoValue = $('#sbjtNo').val().trim();
	if (sbjtNoValue == null || sbjtNoValue == "") {
		dhtmlx.confirm({
			title : "과제번호(지원기관) 임의 생성 여부",
			ok : "Yes",
			cancel : "No",
			text : "과제번호(지원기관)를 임의로 생성해 저장합니다. 계속하시겠습니까?",
			callback : function(data) {
				if (result) {
					userCheckAfterSubmit();
				} else {
					$('#sbjtNo').css('background-color','#FFCC66');
					$('#sbjtNo').focus();
					return;
				}
				if (data == "true") {
					opener.overallGrid_load();
					alert("저장되었습니다. 현재 열려 있는 창을 종료합니다.");
					window.close();
				}
			}
		});
	} else {
		var rschCmcmYear = $('#rschCmcmYear').val();
		var rschEndYear = $('#rschEndYear').val();
		if(rschCmcmYear > rschEndYear) {
			dhtmlx.alert({
				type : "alert-warning",
				text : "연구기간을 확인하세요. <br/>시작년도가 종료년도보다 클 수 없습니다.",
				callback : function() {
					$('#rschCmcmYear').val('');
					$('#rschEndYear').val('');
					$('#rschCmcmYear').focus();
				}
			})
			return;
		}
		else
		{
			userCheckAfterSubmit();
		}
	}
}
function userCheckAfterSubmit() {
	var fundingId = '${fundingId}';
	var fundingUrl = '';
	if (fundingId) fundingUrl = '<c:url value="/fundingCntc/modifyFundingAjax.do?erpId=${param.erpId}" />';
	else fundingUrl = '<c:url value="/fundingCntc/addFundingAjax.do?overallFlag=${param.overallFlag}&erpId=${param.erpId}" />';
	userCheck();
	$.ajax({
		url : fundingUrl, 
		method: "POST", 
		data : $('#formArea').serialize(), 
		success : function(data) {
			alert(data);
			location.reload();
		}
	});
}


function setFundingData() {
	var inputs = $(".erp_data").find("input");
	for(var i=0; i < inputs.length; i++) {
		setData(inputs.eq(i).prop('id').replace("erp_", ""));
	}
	var selects = $(".erp_data").find("select");
	for(var i=0; i < selects.length; i++) {
		setData(selects.eq(i).prop('id').replace("erp_", ""));
	}
}
function addPartiData() {
	var erpPrtcpnt = $("#erpPrtcpnt").children("tbody").children("tr");
	for(var i=1; i <= erpPrtcpnt.length; i++) {
		addErpPrtcpnt(i);
	}
}
function setData(id) {
	$("#"+id).val($("#erp_" + id).val());
}
function setDate(id1, id2) {
	setData(id1 + "Year");
	setData(id1 + "Month");
	setData(id2 + "Year");
	setData(id2 + "Month");
}
function setKeyAndValue(id) {
	setData(id + "Key");
	setData(id + "Value");
}
function addPrincipalManager() {
	var $tbody = $("#prtcpntTbl").children("tbody");
    var $trs = $tbody.children("tr");
    var $tr = $tbody.children("tr").last();

    for (var i=0; i < $trs.length; i++) {
        if (($trs.eq(i).find('select[name=tpiDvsCd]').val() == '1' || $trs.eq(i).find('select[name=tpiDvsCd]').val() == '4')  && $trs.eq(i).find('input[name=prtcpntId]').val() == "${funding.userId}"){
            dhtmlx.alert("이미 해당 연구책임자가 추가되어있습니다.");
            return;
        }
    }

	if ($tr.find("input[name=prtcpntNm]").val().trim() == "") {
		$tr.find('input[name=prtcpntNm]').val("${funding.korNm}");
		$tr.find('select[name=tpiDvsCd]').val("${overallFlag eq 'T' ? '1' : '4'}");
		$tr.find('input[name=prtcpntId]').val("${funding.userId}");
		$tr.find('input[name=blngAgcNm]').val("한국과학기술원");
		$tr.find('input[name=tpiSttYear]').val("${funding.rschCmcmYear}");
		$tr.find('input[name=tpiSttMonth]').val("${funding.rschCmcmMonth}");
		$tr.find('input[name=tpiEndYear]').val("${funding.rschEndYear}");
		$tr.find('input[name=tpiEndMonth]').val("${funding.rschEndMonth}");
        $tr.css("background-color","yellowgreen");
	} else {
		prtcpntIdx++;
		var newTr = $tr.clone();
		var inputs = newTr.find('input');
		for (var i=0; i < inputs.length; i++) {
			var objName = inputs.eq(i).prop('name');
			if (objName == 'prtcpntIndex') inputs.eq(i).prop('id', objName+"_"+prtcpntIdx).val(prtcpntIdx);
			else if(objName == 'seqAuthor') inputs.eq(i).prop('id', objName+"_"+prtcpntIdx).val('N');
			else if(objName == 'prtcpntNm') inputs.eq(i).prop('id', objName+"_"+prtcpntIdx).val('${funding.korNm}');
			else if(objName == 'prtcpntId') inputs.eq(i).prop('id', objName+"_"+prtcpntIdx).val('${funding.userId}');
			else if(objName == 'blngAgcNm') inputs.eq(i).prop('id', objName+"_"+prtcpntIdx).val('한국과학기술원');
			else if(objName == 'tpiSttYear') inputs.eq(i).prop('id', objName+"_"+prtcpntIdx).val('${funding.rschCmcmYear}');
			else if(objName == 'tpiSttMonth') inputs.eq(i).prop('id', objName+"_"+prtcpntIdx).val('${funding.rschCmcmMonth}');
			else if(objName == 'tpiEndYear') inputs.eq(i).prop('id', objName+"_"+prtcpntIdx).val('${funding.rschEndYear}');
			else if(objName == 'tpiEndMonth') inputs.eq(i).prop('id', objName+"_"+prtcpntIdx).val('${funding.rschEndMonth}');
		}

		newTr.find('select[name="tpiDvsCd"]').prop('id', "tpiDvsCd_"+prtcpntIdx).val('${overallFlag eq 'T' ? '1' : '4'}');
        newTr.css("background-color","yellowgreen");
		$tr.after(newTr);
	}
	$tbody.find('span[id^="prtcpntOrder_"]').each(function(i, obj){ $(obj).text(i+1); });
	isChange = true;
}
function skipData(id) {
	if (confirm("해당 연구비(연구과제)는 이제 목록에서 나타나지 않습니다. 계속 진행하시겠습니까?")) {
		$.ajax({
			url : '<c:url value="/fundingCntc/updateStatusAjax.do?overallFlag=${param.overallFlag}&erpId=${param.erpId}" />', 
			data : $('#formArea').serialize(), 
			success : function(data) {
				if (data == "true") opener.overallGrid_load();
				window.close();
			}
		});
	}
}
function updatePrtcpntCnt() {
	var $trs = $("#prtcpntTbl").children("tbody").children("tr");
	var asso = 0;
	var asst = 0;
	for (var i=0; i < $trs.length; i++) {
		if ($trs.eq(i).find('select[name=tpiDvsCd]').val() == 2) asso++;
		else if ($trs.eq(i).find('select[name=tpiDvsCd]').val() == 3) asst++;
	}
	var $tbody = $("#detailTbl").children("tbody").children("tr").first();
	$tbody.find("input[name=assoRschrCnt]").val(asso);
	$tbody.find("input[name=asstRschrCnt]").val(asst);
}
function addErpPrtcpnt(num){
	var $tbody = $("#prtcpntTbl").children("tbody");
	var $tr = $tbody.children("tr").last();
    var prtcpntTr = $("#prtcpntTbl").children("tbody").children("tr");
    var erpPrtcpntTr = $("#erpPrtcpnt").children("tbody").children("tr");

	if ($tr.find("input[name=prtcpntNm]").val().trim() == "") {
        $tr.css("background-color", erpPrtcpntTr.eq(num-1).css("background-color"));
	    //RIMS에 참여자가 없는경우
		var inputs = $tr.find('input');
		for (var i=0; i < inputs.length; i++) {
			var objName = inputs.eq(i).prop('name');
			if (objName != 'prtcpntIndex' && objName != 'seqAuthor') inputs.eq(i).val($("#erp_"+objName+"_"+num).val());
		}
		$tr.find('select[name="tpiDvsCd"]').val($("#erp_tpiDvsCd_"+num).val());
	} else {
        //RIMS에 참여자와 중복되는 경우
		var dupYn = "N";

	    for(var i=0; i<prtcpntTr.length; i++){
	        var prtcpntId = prtcpntTr.eq(i).find("td").eq(4).find("input").val();
	        var erpPrtcpntId = erpPrtcpntTr.eq(num-1).find("td").eq(3).find("input").val();
            var inputs = prtcpntTr.eq(i).find('input');

			if(prtcpntId && prtcpntId == erpPrtcpntId){
//                prtcpntTr.eq(i).find('select').val(erpPrtcpntTr.eq(num-1).find('select').val()); (참여자구분)
                prtcpntTr.eq(i).css("background-color", erpPrtcpntTr.eq(num-1).css("background-color"));

                for (var j=0; j < inputs.length; j++) {
                    var objName = inputs.eq(j).prop('name');
                    if (objName != 'prtcpntIndex' && objName != 'seqAuthor' && objName != 'tpiSttYear'&& objName != 'tpiSttMonth') inputs.eq(j).val($("#erp_"+objName+"_"+num).val());
                }

			    dupYn = "Y";
			    break;
			}
		}

		if(dupYn == "N"){
            //RIMS에 참여자와 중복되지 않은경우
            prtcpntIdx++;
            var newTr = $tr.clone();
            var inputs = newTr.find('input');
            for (var i=0; i < inputs.length; i++) {
                var objName = inputs.eq(i).prop('name');
                if (objName == 'prtcpntIndex') inputs.eq(i).prop('id', objName+"_"+prtcpntIdx).val(prtcpntIdx);
                else if (objName == 'seqAuthor') inputs.eq(i).prop('id', objName+"_"+prtcpntIdx).val('N');
                else inputs.eq(i).prop('id', objName+"_"+prtcpntIdx).val($("#erp_"+objName+"_"+num).val());
            }
            newTr.find('select[name="tpiDvsCd"]').prop('id', "tpiDvsCd_"+prtcpntIdx).val($("#erp_tpiDvsCd_"+num).val());
            newTr.css("background-color", erpPrtcpntTr.eq(num-1).css("background-color"));
            $tr.after(newTr);
		}
	}
	$tbody.find('span[id^="prtcpntOrder_"]').each(function(i, obj){ $(obj).text(i+1); });
	isChange = true;
}
function setErpDetail(num) {
	var $tbody = $("#detailTbl").children("tbody");
	var $tr = $tbody.children("tr").eq(num-1);
	var inputs = $tr.find('input');
	for (var i=0; i < inputs.length; i++) {
		var objName = inputs.eq(i).prop('name');
		if (objName != 'detailIndex' && objName != 'seqFunding') inputs.eq(i).val($("#erp_"+objName+"_"+num).val());
	}
	if($tr.find('select[name="detailApprDvsCd"]').val() == '')$tr.find('select[name="detailApprDvsCd"]').val('1');

	isChange = true;
}
</script>
</head>
<body>
<div id="erpFundingInfo" style="height: 100%;overflow-x: hidden;overflow-y:scroll;">
  <table class="write_tbl mgb_10" >
	<colgroup>
		<col style="width:140px;" />
		<col style="width:325px;" />
		<col style="width:140px" />
		<col style="" />
	</colgroup>
	<tbody>
		<tr>
			<th class="essential_th"><spring:message code='fund.rsrcct.sppt.dvs.cd'/></th>
			<td class="erp_data">
			<span class="dk_one_bt_box">
				<select name="rsrcctSpptDvsCd" id="erp_rsrcctSpptDvsCd" class="select_type required">${rims:makeCodeList('1280', true, funding.rsrcctSpptDvsCd)}</select>
				 <span class="dk_r_bt">
					<a href="javascript:void(0);" class="tbl_icon_a tbl_cover_icon" onclick="setData('rsrcctSpptDvsCd');">반입</a>
				 </span>
				</span>
			</td>
			<th><spring:message code='fund.cpt.gov.offic.nm'/></th>
			<td class="erp_data">
				<span class="dk_one_bt_box">
				<input type="text" name="cptGovOfficNm" id="erp_cptGovOfficNm"  class="input_type" value="<c:out value="${funding.cptGovOfficNm}"/>"/>
				 <span class="dk_r_bt">
					<a href="javascript:void(0);" class="tbl_icon_a tbl_cover_icon" onclick="setData('cptGovOfficNm');">반입</a>
				 </span>
				</span>
			</td>
		</tr>
	    <tr>
	    	<th class="essential_th"><spring:message code='fund.rsrcct.sppt.agc.nm'/></th>
	    	<td class="erp_data">
				<span class="dk_one_bt_box">
	    		<input type="text" name="rsrcctSpptAgcNm" id="erp_rsrcctSpptAgcNm"  class="input_type required" value="<c:out value="${funding.rsrcctSpptAgcNm}"/>"/>
				 <span class="dk_r_bt">
					<a href="javascript:void(0);" class="tbl_icon_a tbl_cover_icon" onclick="setData('rsrcctSpptAgcNm');">반입</a>
				 </span>
				</span>
	    	</td>
	    	<th class="essential_th"><spring:message code='fund.biz.nm'/></th>
	    	<td class="erp_data">
				<span class="dk_one_bt_box">
	    		<input type="text" name="bizNm" id="erp_bizNm"  class="input_type required" value="<c:out value="${funding.bizNm}"/>"/>
				 <span class="dk_r_bt">
					<a href="javascript:void(0);" class="tbl_icon_a tbl_cover_icon" onclick="setData('bizNm');">반입</a>
				 </span>
				</span>
	    	</td>
	    </tr>
	    <tr>
			<th class="essential_th add_help">
				<spring:message code='fund.sbjt.no'/><a href="javascript:void(0);" onclick="showTooltip($(this))" class="tbl_help_a"></a>
				<p class="th_help_box"><span><spring:message code='tooltip.fund1'/></span></p>
			</th>
	    	<td class="erp_data">
	    		<span class="dk_one_bt_box">
	    		<input type="text" name="sbjtNo" id="erp_sbjtNo"  class="input_type" value="<c:out value="${funding.sbjtNo}"/>"/>
				 <span class="dk_r_bt">
					<a href="javascript:void(0);" class="tbl_icon_a tbl_cover_icon" onclick="setData('sbjtNo');">반입</a>
				 </span>
				</span>
	    	</td>
	    	<th><spring:message code='fund.sbjt.no.kaist'/></th>
	    	<td class="erp_data">
	    		<span class="dk_one_bt_box">
	    		<input type="text" name="agcSbjtNo" id="erp_agcSbjtNo"  class="input_type" value="<c:out value="${funding.agcSbjtNo}"/>"/>
				 <span class="dk_r_bt">
					<a href="javascript:void(0);" class="tbl_icon_a tbl_cover_icon" onclick="setData('agcSbjtNo');">반입</a>
				 </span>
				</span>
	    	</td>
	    </tr>
	    <tr>
			<th class="essential_th"><spring:message code='fund.rsch.sbjt.nm'/></th>
			<td class="erp_data" colspan="3">
	    		<span class="dk_one_bt_box">
				<input type="text" name="rschSbjtNm" id="erp_rschSbjtNm"  class="input_type required" value="<c:out value="${funding.rschSbjtNm}"/>"/>
				 <span class="dk_r_bt">
					<a href="javascript:void(0);" class="tbl_icon_a tbl_cover_icon" onclick="setData('rschSbjtNm');">반입</a>
				 </span>
				</span>
			</td>
	    </tr>
	    <tr>
			<th class="essential_th"><spring:message code='fund.rsch.date'/></th>
			<td class="erp_data">
	    		<span class="dk_one_bt_box">
			  <input type="text" name="rschCmcmYear" id="erp_rschCmcmYear" class="input_type required" style="width: 50px;" value="<c:out value="${funding.rschCmcmYear}"/>" />&nbsp;<spring:message code='common.year'/>&nbsp;&nbsp;
              <input type="text" name="rschCmcmMonth" id="erp_rschCmcmMonth" class="input_type" style="width: 30px;" value="<c:out value="${funding.rschCmcmMonth}"/>" />&nbsp;<spring:message code='common.month'/>&nbsp;&nbsp;
              ~&nbsp;
              <input type="text"  name="rschEndYear" id="erp_rschEndYear" class="input_type required" style="width: 50px;" value="<c:out value="${funding.rschEndYear}"/>" />&nbsp;<spring:message code='common.year'/>&nbsp;&nbsp;
              <input type="text"  name="rschEndMonth" id="erp_rschEndMonth" class="input_type" style="width: 30px;" value="<c:out value="${funding.rschEndMonth}"/>" />&nbsp;<spring:message code='common.month'/>&nbsp;&nbsp;
				 <span class="dk_r_bt">
					<a href="javascript:void(0);" class="tbl_icon_a tbl_cover_icon" onclick="setDate('rschCmcm', 'rschEnd');">반입</a>
				 </span>
				</span>
			</td>
	    	<th class="essential_th"><spring:message code='fund.mny.yr.sbjt.nm'/></th>
	    	<td class="erp_data">
	    		<span class="dk_one_bt_box">
	    		<select name="mnyYrSbjtYn" id="erp_mnyYrSbjtYn" class="select_type required">${rims:makeCodeList('1450',true,funding.mnyYrSbjtYn)}</select>
				 <span class="dk_r_bt">
					<a href="javascript:void(0);" class="tbl_icon_a tbl_cover_icon" onclick="setData('mnyYrSbjtYn');">반입</a>
				 </span>
				</span>
	    	</td>
	    </tr>
	    <tr>
	    	<th class="essential_th"><spring:message code='fund.rsch.sbjt.stdy.sphe.cd'/></th>
	    	<td class="erp_data">
	    		<span class="dk_one_bt_box">
	    		<select name="rschSbjtStdySpheCd" id="erp_rschSbjtStdySpheCd" class="select_type required">${rims:makeCodeList('1350',true,funding.rschSbjtStdySpheCd)}</select>
				 <span class="dk_r_bt">
					<a href="javascript:void(0);" class="tbl_icon_a tbl_cover_icon" onclick="setData('rschSbjtStdySpheCd');">반입</a>
				 </span>
				</span>
	    	</td>
	    	<th><spring:message code='fund.blng.univ'/></th>
	    	<td class="erp_data">
	    		<span class="dk_one_bt_box">
				<input type="text" id="erp_blngUnivCdValue" name="blngUnivNm" class="input_type" value="한국과학기술원"/>
				<input type="hidden" id="erp_blngUnivCdKey" name="blngUnivCd" value="610400"/>
				 <span class="dk_r_bt">
					<a href="javascript:void(0);" class="tbl_icon_a tbl_cover_icon" onclick="setKeyAndValue('blngUnivCd');">반입</a>
				 </span>
				</span>
	    	</td>
	    </tr>
	    <tr>
			<th class="add_help"><spring:message code='fund.detail'/><a href="javascript:void(0);" onclick="showTooltip($(this))" class="tbl_help_a"></a>
				<p class="th_help_box"><span><spring:message code='tooltip.fund2'/></span></p>
			</th>
	    	<td colspan="3">
		    	<c:if test="${not empty funding.detailList}">
		    		<c:forEach items="${funding.detailList}" var="dl" varStatus="idx">
		    			<c:if test="${idx.count==1 && dl.totRsrcct ne null}" >
		    			계약금액: 총금액 <fmt:formatNumber value="${dl.totRsrcct}"/>원(차액 <fmt:formatNumber value="${dl.totRsrcct-dl.budgetAmount}"/>원), 
		    			순수연구비 <fmt:formatNumber value="${dl.prtyRsrcct}"/>원
		    			</c:if>
	    			</c:forEach>
	    		</c:if>
	    	</td>
	    </tr>
	    <tr>
			<td colspan="4" class="inner_tbl_td">
				<div>
				<table class="inner_tbl" id="erpDetail">
					<colgroup>
						<col style="width:55px;" />
						<col style="width:80px;" />
						<col style="width:120px;" />
						<col style="width:120px;" />
						<col style="width:120px;" />
						<col style="width:120px;" />
						<col style="width:120px;" />
						<col style="width:50px;" />
						<col style="width:50px;" />
						<col />
					</colgroup>
					<thead>
						<tr>
							<th rowspan="2"><spring:message code='fund.order'/></th>
							<th rowspan="2"><spring:message code='fund.rsrcct.cont.yr'/></th>
							<th rowspan="2"><spring:message code='fund.tot.rsrcct'/></th>
							<th rowspan="2"><spring:message code='fund.prty.rsrcct'/></th>
							<th rowspan="2"><spring:message code='fund.indrfee'/></th>
							<th rowspan="2"><spring:message code='fund.sclgrnd.corr.fund'/></th>
							<th rowspan="2"><spring:message code='fund.schout.corr.fund'/></th>
							<th colspan="2"><spring:message code='fund.rschr.cnt'/></th>
							<th rowspan="2"></th>
						</tr>
						<tr>
							<th><spring:message code='fund.asso.rschr.cnt'/></th>
							<th><spring:message code='fund.asst.rschr.cnt'/></th>
						</tr>
					</thead>
					<tbody>
					  <c:if test="${not empty funding.detailList}">
					  	<c:forEach items="${funding.detailList}" var="dl" varStatus="idx">
							<tr>
							  <td style="text-align: center;">
					  			<input type="hidden" name="detailIndex" id="erp_detailIndex_${idx.count}" value="${idx.count}"/>
					  			<span>${idx.count}</span>
					  		  </td>
					  		  <td>
					  		  	<input type="text" style="width: 40px; text-align: right;" name="rsrcctContYr" id="erp_rsrcctContYr_${idx.count}" value="<c:out value="${dl.rsrcctContYr}"/>" maxlength="4" class="input_type required"/><spring:message code='common.year'/>
					  		  </td>
					  		  <td style="text-align: left;">
					  		  	<input type="text" style="width: 90px; text-align: right;" name="totRsrcct" id="erp_totRsrcct_${idx.count}" maxLength="15" class="input_type required" value="<fmt:formatNumber value="${dl.budgetAmount}"/>" onkeyup="getNumber($(this));" onkeydown="getNumber($(this));"/><spring:message code='fund.won'/>
					  		  </td>
					  		  <td style="text-align: left;">
					  		  	<input type="text" style="width: 90px; text-align: right;" name="prtyRsrcct"  id="erp_prtyRsrcct_${idx.count}" maxLength="15" class="input_type required" value="<fmt:formatNumber value="${dl.budgetAmount-dl.indrfee}"/>" onkeyup="getNumber($(this));" onkeydown="getNumber($(this));"/><spring:message code='fund.won'/>
					  		  </td>
					  		  <td style="text-align: center;">
					  		  	<input type="text" style="width: 90px; text-align: right;" name="indrfee" id="erp_indrfee_${idx.count}" maxLength="15" class="input_type required" value="<fmt:formatNumber value="${dl.indrfee}"/>" onkeyup="getNumber($(this));" onkeydown="getNumber($(this));"/><spring:message code='fund.won'/>
					  		  </td>
					  		  <td style="text-align: center;">
					  		  	<input type="text" style="width: 90px; text-align: right;" name="sclgrndCorrFund" id="erp_sclgrndCorrFund_${idx.count}" maxLength="15" class="input_type required" value="<fmt:formatNumber value="${dl.sclgrndCorrFund}"/>" onkeyup="getNumber($(this));" onkeydown="getNumber($(this));"/><spring:message code='fund.won'/>
					  		  </td>
					  		  <td style="text-align: center;">
					  		  	<input type="text" style="width: 90px; text-align: right;" name="schoutCorrFund" id="erp_schoutCorrFund_${idx.count}" maxLength="15" class="input_type required" value="<fmt:formatNumber value="${dl.schoutCorrFund}"/>" onkeyup="getNumber($(this));" onkeydown="getNumber($(this));"/><spring:message code='fund.won'/>
					  		  </td>
					  		  <td style="text-align: center;">
					  		  	<input type="text" style="width: 30px; text-align: right;" name="assoRschrCnt" id="erp_assoRschrCnt_${idx.count}" maxLength="3" class="input_type required" value="0" />
					  		  </td>
					  		  <td style="text-align: center;">
					  		  	<input type="text" style="width: 30px; text-align: right;" name="asstRschrCnt" id="erp_asstRschrCnt_${idx.count}" maxLength="3" class="input_type required" value="<c:out value="${dl.asstRschrCnt}" default="0" />" />
					  		  </td>
					  		  <td style="text-align: right;"><span class="dk_r_bt"><a href="javascript:void(0);" class="tbl_icon_a tbl_cover_icon" onclick="setErpDetail('${idx.count}');"></a></span></td>
							</tr>
					  	</c:forEach>
					  </c:if>
					</tbody>
				</table>
				</div>
			</td>
	    </tr>
	    <tr>
	    	<th><spring:message code='fund.authors'/></th>
	    	<td colspan="3">${overallFlag eq 'T' ? '연구책임자' : '서브책임자'}: ${funding.korNm} (${funding.userId})</td>
	    </tr>
	    <tr>
			<td colspan="4" class="inner_tbl_td">
				<table class="in_tbl inner_tbl" id="erpPrtcpnt">
					<thead>
						<tr>
							<th><spring:message code='fund.order'/></th>
							<th class="essential_th"><spring:message code='fund.name'/></th>
							<th class="essential_th"><spring:message code='fund.tpi.dvs.cd'/></th>
							<th><spring:message code='fund.user.id'/></th>
							<th><spring:message code='fund.agc.nm'/></th>
							<th><spring:message code='fund.tpi.date'/></th>
						</tr>
					</thead>
					<tbody>
						<c:if test="${not empty funding.partiList}">
						  <c:forEach items="${funding.partiList}" var="pl" varStatus="idx">
						  	<tr style="<c:choose><c:when test="${pl.tpiDvsCd == '1' or pl.tpiDvsCd == '4'}">background-color:yellowgreen;</c:when><c:when test="${(pl.prtcpntId).matches('[0-9]+') and pl.prtcpntId <= 5000}">background-color:yellow;</c:when></c:choose>">
						  		<td style="width: 50px; text-align: center;">
						  			<input type="hidden" name="prtcpntIndex" id="erp_prtcpntIndex_${idx.count}" value="${idx.count}"/>
						  			<span>${idx.count}</span>
						  		</td>
						  		<td style="width:80px;">
						  			<input type="text"  name="prtcpntNm" maxLength="30" id="erp_prtcpntNm_${idx.count}" class="input_type required" value="<c:out value="${pl.prtcpntNm}"/>" onkeydown="if(event.keyCode==13){findUser($(this),event);}"/>
						  			<input type="hidden" name="pcnRschrRegNo" id="pcnRschrRegNo_${idx.count}" value="<c:out value="${pl.pcnRschrRegNo}"/>"/>
				                	<input type="hidden" name="seqAuthor" id="seqAuthor_${idx.count}" value="${empty pl.seqParti ? 'N' : pl.seqParti}"/>
						  		</td>
						  		<td style="width:100px;">
						  			<select name="tpiDvsCd" id="erp_tpiDvsCd_${idx.count}" class="select_type required">${rims:makeCodeList('1360', true, (overallFlag eq 'S' and pl.tpiDvsCd eq '1' ? '4' : pl.tpiDvsCd)) }</select>
						  		</td>
						  		<td	style="width:140px;"><input type="text" name="prtcpntId" id="erp_prtcpntId_${idx.count}" value="<c:out value="${pl.prtcpntId}"/>"  class="input_type"/></td>
						  		<td style="width:160px;">
									<input type="text"  name="blngAgcNm" id="erp_blngAgcNm_${idx.count}"  class="input_type" value="<c:out value="${pl.blngAgcNm}"/>"/>
						  		</td>
						  		<td style="width:240px;">
						    		<span class="dk_one_bt_box">
									  <input type="hidden" name="tpiRate" maxLength="3" class="input_type" value="<c:out value="${pl.tpiRate}"/>"/>
									  <input type="text" name="tpiSttYear" id="erp_tpiSttYear_${idx.count}" class="input_type required" style="width: 40px;" value="<c:out value="${pl.tpiSttYear }"/>" /><spring:message code='common.year'/>
						              <input type="text" name="tpiSttMonth" id="erp_tpiSttMonth_${idx.count}" class="input_type" style="width: 25px;" value="<c:out value="${pl.tpiSttMonth}"/>" /><spring:message code='common.month'/>
						              &nbsp;~&nbsp;
						              <input type="text" name="tpiEndYear" id="erp_tpiEndYear_${idx.count}" class="input_type required" style="width: 40px;" value="<c:out value="${pl.tpiEndYear}"/>" /><spring:message code='common.year'/>
						              <input type="text" name="tpiEndMonth" id="erp_tpiEndMonth_${idx.count}" class="input_type" style="width: 25px;" value="<c:out value="${pl.tpiEndMonth}"/>" /><spring:message code='common.month'/>
									 <span class="dk_r_bt"><a href="javascript:void(0);" class="tbl_icon_a tbl_cover_icon" onclick="addErpPrtcpnt('${idx.count}');"></a></span>
									</span>
						  		</td>
						  	</tr>
						  </c:forEach>
						</c:if>
					</tbody>
				</table>
			</td>
	    </tr>
	</tbody>
  </table>
</div>

<div id="formObj" style="width:100%;height: 100%;overflow-x: hidden;overflow-y:scroll;"></div>

<div id="objId">
	<form id="connection" action="${contextPath}/auth/connection/patent/addPatent.do" method="post" target="_blank">
		<input type="hidden" id="item_id" name="item_id" value="${pmsPatent.srcId}"/>
		<input type="hidden" id="inventors" name="inventors" value=""/>
	</form>
	<form id="done" action="${contextPath}/auth/connection/patent/done.do" method="post">
		<input type="hidden" id="item_id" name="item_id" value="${pmsPatent.srcId}"/>
	</form>
</div>

</body>
</html>