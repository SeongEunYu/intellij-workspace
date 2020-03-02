<%@page import="kr.co.argonet.r2rims.util.LanguageUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="../../pageInit.jsp" %>
<style type="text/css">
.effectExport {color : red;}
.list_tbl {border-top : none;}
.list_tbl tbody td { border-bottom : none;}
.list_tbl thead th {background : none; border-bottom:2px solid #5e9bf8;}
table ul li ul li {padding-top: 10px;}
table tbody div {padding-top: 10px;}
</style>
<script type="text/javascript" src="${contextPath}/js/mainLayout.js"></script>
<script type="text/javascript">
var dhxLayout, myGrid, t, rowId;
$(document).ready(function(){
	bindModalLink();
	setMainLayoutHeight($('#mainLayout'));
	if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
	else  window.addEventListener("resize",resizeLayout, false);
	//set layout
	dhxLayout = new dhtmlXLayoutObject("mainLayout","1C");
	dhxLayout.cells("a").hideHeader();
	dhxLayout.setSizes(false);
	//attach myGrid
	var header = "No,구분,제목(한글),제목(영문),비고";
	var columnIds = "No,gubun,title,titleEng,remark";
	var initWidths = "50,*,*,*,100";
	var colAlign = "center,center,center,center,center";
	var colTypes = "ro,ro,ro,ro,ro";
	var colSorting = "int,str,str,str,str";
	var serializable = "false,fasle,false,false,false";

	myGrid = dhxLayout.cells("a").attachGrid();
	myGrid.setImagePath("${dhtmlXImagePath}");
	myGrid.setHeader(header,null,grid_head_center_bold);
	myGrid.setColumnIds(columnIds);
	myGrid.setInitWidths(initWidths);
	myGrid.setColAlign(colAlign);
	myGrid.setColTypes(colTypes);
	myGrid.setColSorting(colSorting);
	myGrid.setSerializableColumns(serializable);
	myGrid.attachEvent("onRowSelect", myGrid_onRowSelect);
	myGrid.attachEvent("onXLS", doBeforeGridLoad);
	myGrid.attachEvent("onXLE", doOnGridLoaded);
	myGrid.enableMultiselect(true);
	myGrid.enableColSpan(true);
	myGrid.enableColumnAutoSize(true);
	myGrid.init();
	myGrid_load();
	
	//체크박스 부분체크 및 체크해제시 전체 체크및 체크 효과
    $('#fieldTr tbody input[type="checkbox"]').click(function (){
        if(this.id.indexOf("Sub") != -1){
            var parentId2 = this.id.substr(0,10);
            var i = 0;
            if($("#"+parentId2).prop("checked")) i=1;
            var checkBoxTdSize2 = $('#fieldTr tbody input[id^="'+parentId2+'"]').size()-1;

            if(($('#fieldTr tbody input[id^="'+parentId2+'"]:checked').size()-i) == checkBoxTdSize2){
                $("#"+parentId2).prop('checked', true);
            }else{
                $("#"+parentId2).prop('checked', false);
            }
        }

        var parentId = this.id.substr(0,7);
        var checkBoxTdSize = $('#fieldTr tbody input[id^="'+parentId+'"]').size();

        if($('#fieldTr tbody input[id^="'+parentId+'"]:checked').size() == checkBoxTdSize){
            $("#"+parentId).prop('checked', true);
        }else{
            $("#"+parentId).prop('checked', false);
        }
    });

    $('#templateDialog #closeBtn').click(function (){
        $('.popup_inner').scrollTop(0);
    });

    $('.sideToggle').click(function (e) {
        e.preventDefault();

        $(".sideToggle").removeClass('show');
        var $this = $(this);
        $this.addClass('show');

        if ($this.next().next().next().hasClass('on')) {
            $(".sideToggle").removeClass('show');
            $this.next().next().next().removeClass('on');
            $this.next().next().next().slideUp(350);
            $this.html('<span><img src="<c:url value="/images/background/ep_plus.png"/>"> </span>');
        } else {
            $this.next().next().next().toggleClass('on');
            $this.next().next().next().slideToggle(350);
            $this.html('<span> <img src="<c:url value="/images/background/ep_minus.png"/>"> </span>');
        }
    });
});

function myGrid_load(){
    rowId = undefined;
	myGrid.clearAndLoad("<c:url value="/auth/statistics/findStatsTemplate.do"/>?statsGubun="+$("#statsGubunForSearch").val());
}

function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){ setMainLayoutHeight($('#mainLayout')); dhxLayout.setSizes(false); },10);}
function doOnGridLoaded(){setTimeout(function() {dhxLayout.cells("a").progressOff();}, 100);}
function doBeforeGridLoad(){dhxLayout.cells("a").progressOn();}

function myGrid_onRowSelect(rowID,celInd){
    rowId = rowID;
    findStatsTemplateBySn();
}

function findStatsTemplateBySn(){
    $.ajax({
        url: "<c:url value="/auth/statistics/findStatsTemplateAjax.do"/>?sn="+rowId,
        type: "POST"
    }).done(function(data){
        var statsGubun = data.statsGubun;
		//모달 세팅
		$("#templateType").val("update");
		$("#templateHead").text("템플릿 수정");
		$("#statsGubun").val(statsGubun);
		$("#title").val(data.title);
        $("#titleEng").val(data.titleEng);
        $("#remark").val(data.remark);
        $(".delTemp").css("display","");
        sideToggleInit();
        $('.popup_inner input[type="checkbox"]:checked').prop('checked', false);

		if(data.field != null){
			var fieldArr = data.field.split(",");
			for(var i=0; i<fieldArr.length; i++){
				$("#fieldTr #"+statsGubun+"Tb input[name="+fieldArr[i]+"]").prop("checked",true);
			}
        }
		$("#fieldTr table").css("display","none");
		$("#fieldTr #"+statsGubun+"Tb").css("display","");

		var text = "";
        if(statsGubun == "ART"){
            text = "※ '저자 상세정보','논문 지수정보'는 반출 속도에 영향을 미칩니다.";
        }else if(statsGubun == "CON"){
            text = "※ '제1저자','전체저자(최대 1000명)','저자수'는 반출 속도에 영향을 미칩니다.";
        }else if(statsGubun == "BOOK"){
            text = "※ '전체저자(최대 1000명)','저자수'는 반출 속도에 영향을 미칩니다.";
        }else{
            text = "※ '전체발명자','발명자수'는 반출 속도에 영향을 미칩니다.";
        }
        $("#fieldHelp").html(text);

		$("#openModal").click();
    });
}

function deleteTemplate(){
    dhtmlx.confirm({
        title:"템플릿 삭제", text:"해당 템플릿을 삭제하시겠습니까?",
        callback:function(result){
            if(result){
                $.ajax({
                    url: "<c:url value="/auth/statistics/deleteStatsTemplate.do"/>?sn="+rowId,
                    type: "POST"
                }).done(function(data){
                    if(data.result != 1) {
                        alert('오류가 발생하였습니다.');
                    }else{
                        myGrid_load();
                    }
                });

                $('#templateDialog #closeBtn').triggerHandler('click');
            }
        }
    });
}

function saveTemplate(){
	var statsGubun = $("#statsGubun option:selected").val();
    var fields =  $('#'+statsGubun+'Tb input[type="checkbox"]:checked').map(function() { if(this.name != '')return this.name; }).get().join(",");
	var url = "<c:url value="/auth/statistics/saveStatsTemplate.do"/>?field="+fields+"&"+$('#templateFrm').serialize();

	if($("#templateType").val() == "update")url+="&sn="+rowId;

    $.ajax({
        url: url,
        type: "POST"
    }).done(function(data){
        $('#templateDialog #closeBtn').triggerHandler('click');
        if(data.result != 1) {
            alert('오류가 발생하였습니다.');
        }

        myGrid_load();
    });
}

function clickCheckbox(obj){
    var id = $(obj).attr("id");
    if($("#"+id).prop("checked") == true)
    {
        $('input[id^="'+id+'"]').prop('checked', true);
    }
    else
    {
        $('input[id^="'+id+'"]').prop('checked', false);
    }
}

function openModal(){
    //모달 초기화
	$("#templateType").val("add");
    $("#templateHead").text("템플릿 추가");
    $("#statsGubun").val("ART");
    $("#title").val("");
    $("#titleEng").val("");
    $("#remark").val("");
    $('.popup_inner input[type="checkbox"]:checked').prop('checked', false);
    $("#fieldTr table").css("display","none");
    $("#ARTTb").css("display","");
    $("#fieldHelp").html("※ '저자 상세정보','논문 지수정보'는 반출 속도에 영향을 미칩니다.");
    $(".delTemp").css("display","none");
    sideToggleInit();

    $("#openModal").click();
}

function statsGubunChange(){
    var statsGubun = $("#statsGubun option:selected").val();
    var text = "";
    if(statsGubun == "ART"){
        text = "※ '저자 상세정보','논문 지수정보'는 반출 속도에 영향을 미칩니다.";
    }else if(statsGubun == "CON"){
        text = "※ '제1저자','전체저자(최대 1000명)','저자수'는 반출 속도에 영향을 미칩니다.";
    }else if(statsGubun == "BOOK"){
        text = "※ '전체저자(최대 1000명)','저자수'는 반출 속도에 영향을 미칩니다.";
    }else{
        text = "※ '전체발명자','발명자수'는 반출 속도에 영향을 미칩니다.";
    }
    $("#fieldTr table").css("display","none");
    $("#fieldTr #"+statsGubun+"Tb").css("display","");
    $("#fieldHelp").html(text);
}

function sideToggleInit(){
    $(".sideToggle").removeClass('show');
    $(".sideToggle").next().next().next().removeClass('on');
    $(".sideToggle").next().next().next().slideUp(350);
    $(".sideToggle").html('<span><img src="<c:url value="/images/background/ep_plus.png"/>"> </span>');
}
</script>
</head>
<body>
<div class="title_box">
	<h3>통계반출관리</h3>
</div>
<form id="formArea" >
    <table class="view_tbl mgb_10" >
        <colgroup>
            <col style="width: 15%;"/>
            <col />
            <col style="width: 50px;"/>
        </colgroup>
        <tbody>
        <tr>
            <th>구분</th>
            <td>
                <select id="statsGubunForSearch" onchange="myGrid_load();">
                    <option value="">전체</option>
                    <option value="ART">논문</option>
                    <option value="CON">학술활동</option>
                    <option value="BOOK">저역서</option>
                    <option value="PAT">특허</option>
                </select>
            </td>
            <td class="option_search_td" onclick="javascript:myGrid_load();"><em>search</em></td>
        </tr>
        </tbody>
    </table>
</form>
<div class="contents_box">
	<div class="list_bt_area">
		<div class="list_set">
			<ul>
				<li style="display:none;"><a id="openModal" href="#templateDialog" class="modalLink"></a></li>
				<li><a href="javascript:openModal();" class="list_icon12">추가</a></li>
			</ul>
		</div>
	</div>
	<!-- layout (grid)  -->
	<div id="mainLayout" style="position: relative; width: 100%; height: 100%;"></div>
</div>


<div id="templateDialog" class="popup_box modal modal_layer export_popup" style="width: 1310px;height:540px;display: none;">

        <div class="popup_header" style="height: 50px;background:#ffffff;">
			<h3 id="templateHead">템플릿 추가</h3>
			<a href="#" id="closeBtn" class="close_bt closeBtn">닫기</a>
		</div>
		<div class="popup_inner" style="height: 484px;overflow: auto;padding-top: 10px;">
			<div class="list_set" style="padding-bottom: 10px;">
				<ul>
                    <li><a href="javascript:saveTemplate();$('#templateDialog #closeBtn').triggerHandler('click');" class="list_icon05">저장</a></li>
                    <li class="delTemp"><a href="javascript:deleteTemplate();" class="list_icon10">삭제</a></li>
                    <li><a href="javascript:$('#templateDialog #closeBtn').triggerHandler('click');" class="list_icon10">취소</a></li>
				</ul>
			</div>
			<table class="write_tbl mgb_10">
                <colgroup>
                    <col style="width: 7%;" />
                    <col style="width: 43%;" />
                    <col style="width: 7%;" />
                    <col style="width: 43%;" />
                </colgroup>
                <tbody>
                <form id="templateFrm">
                    <input type="hidden" id="templateType">
                    <tr>
                        <th style="text-align: center">구분</th>
                        <td colspan="3">
                            <select id="statsGubun" name="statsGubun" style="height: 22px;margin-left: 10px;" onchange="statsGubunChange();">
                                <option value="ART">논문</option>
                                <option value="CON">학술활동</option>
                                <option value="BOOK">저역서</option>
                                <option value="PAT">특허</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th style="text-align: center">제목<br/>(한글)</th>
                        <td>
                            <input type="text" name="title" id="title" style="width: 220px;margin-left: 10px;" />
                        </td>
                        <th style="text-align: center">제목<br/>(영문)</th>
                        <td>
                            <input type="text" name="titleEng" id="titleEng" style="width: 220px;margin-left: 10px;" />
                        </td>
                    </tr>
                    <tr>
                        <th style="text-align: center">비고</th>
                        <td colspan="3">
                            <input type="text" name="remark" id="remark" style="width: 220px;margin-left: 10px;" />
                        </td>
                    </tr>
                </form>
				<tr id="fieldTr">
					<th style="text-align: center">필드</th>
					<td colspan="3">
						<div style="font-size:13px;margin-bottom: 10px;" id="fieldHelp"></div>
						<table width="100%" class="list_tbl mgb_20" id="ARTTb">
                            <colgroup>
                                <col style="width: 16%"/>
                                <col style="width: 16%"/>
                                <col style="width: 16%"/>
                                <col style="width: 16%"/>
                                <col style="width: 18%"/>
                                <col style="width: 18%"/>
                            </colgroup>
                            <thead>
                            <tr>
                                <c:if test="${not empty rims:codeValue('stats.exp.item.art','rsrchInfF')}"><th style="padding-top: 0px;padding-bottom: 0px;"><label for="forRTb0" class="chk_label"><input type="checkbox" onclick="clickCheckbox(this);" name="forRTb0" id="forRTb0"> <c:out value="${rims:codeValue('stats.exp.item.art','rsrchInfF')}"/></label></th></c:if>
                                <c:if test="${not empty rims:codeValue('stats.exp.item.art','artMajorF')}"><th style="padding-top: 0px;padding-bottom: 0px;"><label for="forRTb1" class="chk_label"><input type="checkbox" onclick="clickCheckbox(this);" name="forRTb1" id="forRTb1"> <c:out value="${rims:codeValue('stats.exp.item.art','artMajorF')}"/></label></th></c:if>
                                <c:if test="${not empty rims:codeValue('stats.exp.item.art','artAddF')}"><th style="padding-top: 0px;padding-bottom: 0px;"><label for="forRTb2" class="chk_label"><input type="checkbox" onclick="clickCheckbox(this);" name="forRTb2" id="forRTb2"> <c:out value="${rims:codeValue('stats.exp.item.art','artAddF')}"/></label></th></c:if>
                                <c:if test="${not empty rims:codeValue('stats.exp.item.art','athrDetailF')}"><th style="padding-top: 0px;padding-bottom: 0px;"><label for="forRTb3" class="chk_label"><input type="checkbox" onclick="clickCheckbox(this);" name="forRTb3" id="forRTb3"> <c:out value="${rims:codeValue('stats.exp.item.art','athrDetailF')}"/></label></th></c:if>
                                <c:if test="${not empty rims:codeValue('stats.exp.item.art','artLatestIndexF')}"><th style="padding-top: 0px;padding-bottom: 0px;"><label for="forRTb4" class="chk_label"><input type="checkbox" onclick="clickCheckbox(this);" name="forRTb4" id="forRTb4"> <c:out value="${rims:codeValue('stats.exp.item.art','artLatestIndexF')}"/></label></th></c:if>
                                <c:if test="${not empty rims:codeValue('stats.exp.item.art','artPubIndexF')}"><th style="padding-top: 0px;padding-bottom: 0px;"><label for="forRTb5" class="chk_label"><input type="checkbox" onclick="clickCheckbox(this);" name="forRTb5" id="forRTb5"> <c:out value="${rims:codeValue('stats.exp.item.art','artPubIndexF')}"/></label></th></c:if>
                            </tr>
                            </thead>
                            <tbody>
                            <tr>
                                <td style="text-align: left;padding-left: 10px; vertical-align:top">
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','prtcpntIdF')}"><div class="ep_label_box"><input type="checkbox" id="forRTb0_1" name="prtcpntIdF"><label for="forRTb0_1"> <c:out value="${rims:codeValue('stats.exp.item.art','prtcpntIdF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','korNmF')}"><div class="ep_label_box"><input type="checkbox" id="forRTb0_2" name="korNmF"><label for="forRTb0_2"> <c:out value="${rims:codeValue('stats.exp.item.art','korNmF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','tpiDvsCdF')}"><div class="ep_label_box"><input type="checkbox" id="forRTb0_3" name="tpiDvsCdF"><label for="forRTb0_3"> <c:out value="${rims:codeValue('stats.exp.item.art','tpiDvsCdF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','gubunF')}"><div class="ep_label_box"><input type="checkbox" id="forRTb0_4" name="gubunF"><label for="forRTb0_4"> <c:out value="${rims:codeValue('stats.exp.item.art','gubunF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','grade1F')}"><div class="ep_label_box"><input type="checkbox" id="forRTb0_5" name="grade1F"><label for="forRTb0_5"> <c:out value="${rims:codeValue('stats.exp.item.art','grade1F')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','deptKorF')}"><div class="ep_label_box"><input type="checkbox" id="forRTb0_6" name="deptKorF"><label for="forRTb0_6"> <c:out value="${rims:codeValue('stats.exp.item.art','deptKorF')}"/></label></div></c:if>
                                </td>
                                <td style="text-align: left;padding-left: 10px; vertical-align:top">
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','articleIdF')}"><div class="ep_label_box"><input type="checkbox" id="forRTb1_1" name="articleIdF"><label for="forRTb1_1"> <c:out value="${rims:codeValue('stats.exp.item.art','articleIdF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','scjnlNmF')}"><div class="ep_label_box"><input type="checkbox" id="forRTb1_2" name="scjnlNmF"><label for="forRTb1_2"> <c:out value="${rims:codeValue('stats.exp.item.art','scjnlNmF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','orgLangPprNmF')}"><div class="ep_label_box"><input type="checkbox" id="forRTb1_3" name="orgLangPprNmF"><label for="forRTb1_3"> <c:out value="${rims:codeValue('stats.exp.item.art','orgLangPprNmF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','pblcYearF')}"><div class="ep_label_box"><input type="checkbox" id="forRTb1_4" name="pblcYearF"><label for="forRTb1_4"> <c:out value="${rims:codeValue('stats.exp.item.art','pblcYearF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','pblcMonthF')}"><div class="ep_label_box"><input type="checkbox" id="forRTb1_5" name="pblcMonthF"><label for="forRTb1_5"> <c:out value="${rims:codeValue('stats.exp.item.art','pblcMonthF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','volumeF')}"><div class="ep_label_box"><input type="checkbox" id="forRTb1_6" name="volumeF"><label for="forRTb1_6"> <c:out value="${rims:codeValue('stats.exp.item.art','volumeF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','issueF')}"><div class="ep_label_box"><input type="checkbox" id="forRTb1_7" name="issueF"><label for="forRTb1_7"> <c:out value="${rims:codeValue('stats.exp.item.art','issueF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','sttPageF')}"><div class="ep_label_box"><input type="checkbox" id="forRTb1_8" name="sttPageF"><label for="forRTb1_8"> <c:out value="${rims:codeValue('stats.exp.item.art','sttPageF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','endPageF')}"><div class="ep_label_box"><input type="checkbox" id="forRTb1_9" name="endPageF"><label for="forRTb1_9"> <c:out value="${rims:codeValue('stats.exp.item.art','endPageF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','doiF')}"><div class="ep_label_box"><input type="checkbox" id="forRTb1_10" name="doiF"><label for="forRTb1_10"> <c:out value="${rims:codeValue('stats.exp.item.art','doiF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','doiUrlF')}"><div class="ep_label_box"><input type="checkbox" id="forRTb1_11" name="doiUrlF"><label for="forRTb1_11"> <c:out value="${rims:codeValue('stats.exp.item.art','doiUrlF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','issnNoF')}"><div class="ep_label_box"><input type="checkbox" id="forRTb1_12" name="issnNoF"><label for="forRTb1_12"> <c:out value="${rims:codeValue('stats.exp.item.art','issnNoF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','impctFctrF')}"><div class="ep_label_box"><input type="checkbox" id="forRTb1_13" name="impctFctrF"><label for="forRTb1_13"> <c:out value="${rims:codeValue('stats.exp.item.art','impctFctrF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','corprRsrchDvsCdF')}"><div class="ep_label_box"><input type="checkbox" id="forRTb1_14" name="corprRsrchDvsCdF"><label for="forRTb1_14"> <c:out value="${rims:codeValue('stats.exp.item.art','corprRsrchDvsCdF')}"/></label></div></c:if>
                                </td>
                                <td style="text-align: left;padding-left: 10px; vertical-align:top">
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','scjnlDvsCdF')}"><div class="ep_label_box"><input type="checkbox" id="forRTb2_1" name="scjnlDvsCdF"><label for="forRTb2_1"> <c:out value="${rims:codeValue('stats.exp.item.art','scjnlDvsCdF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','ovrsExclncScjnlPblcYnF')}"><div class="ep_label_box"><input type="checkbox" id="forRTb2_2" name="ovrsExclncScjnlPblcYnF"><label for="forRTb2_2"> <c:out value="${rims:codeValue('stats.exp.item.art','ovrsExclncScjnlPblcYnF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','wosDocTypeF')}"><div class="ep_label_box"><input type="checkbox" id="forRTb2_3" name="wosDocTypeF"><label for="forRTb2_3"> <c:out value="${rims:codeValue('stats.exp.item.art','wosDocTypeF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','scopusDocTypeF')}"><div class="ep_label_box"><input type="checkbox" id="forRTb2_4" name="scopusDocTypeF"><label for="forRTb2_4"> <c:out value="${rims:codeValue('stats.exp.item.art','scopusDocTypeF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','tcF')}"><div class="ep_label_box"><input type="checkbox" id="forRTb2_5" name="tcF"><label for="forRTb2_5"> <c:out value="${rims:codeValue('stats.exp.item.art','tcF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','scpTcF')}"><div class="ep_label_box"><input type="checkbox" id="forRTb2_6" name="scpTcF"><label for="forRTb2_6"> <c:out value="${rims:codeValue('stats.exp.item.art','scpTcF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','idSciF')}"><div class="ep_label_box"><input type="checkbox" id="forRTb2_7" name="idSciF"><label for="forRTb2_7"> <c:out value="${rims:codeValue('stats.exp.item.art','idSciF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','idScopusF')}"><div class="ep_label_box"><input type="checkbox" id="forRTb2_8" name="idScopusF"><label for="forRTb2_8"> <c:out value="${rims:codeValue('stats.exp.item.art','idScopusF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','idKciF')}"><div class="ep_label_box"><input type="checkbox" id="forRTb2_9" name="idKciF"><label for="forRTb2_9"> <c:out value="${rims:codeValue('stats.exp.item.art','idKciF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','openAccesAtF')}"><div class="ep_label_box"><input type="checkbox" id="forRTb2_10" name="openAccesAtF"><label for="forRTb2_10"> <c:out value="${rims:codeValue('stats.exp.item.art','openAccesAtF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','pblcNtnCdF')}"><div class="ep_label_box"><input type="checkbox" id="forRTb2_11" name="pblcNtnCdF"><label for="forRTb2_11"> <c:out value="${rims:codeValue('stats.exp.item.art','pblcNtnCdF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','isReprsntArticleF')}"><div class="ep_label_box"><input type="checkbox" id="forRTb2_12" name="isReprsntArticleF"><label for="forRTb2_12"> <c:out value="${rims:codeValue('stats.exp.item.art','isReprsntArticleF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','insttRsltAtF')}"><div class="ep_label_box"><input type="checkbox" id="forRTb2_13" name="insttRsltAtF"><label for="forRTb2_13"> <c:out value="${rims:codeValue('stats.exp.item.art','insttRsltAtF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','vrfcDvsCdF')}"><div class="ep_label_box"><input type="checkbox" id="forRTb2_14" name="vrfcDvsCdF"><label for="forRTb2_14"> <c:out value="${rims:codeValue('stats.exp.item.art','vrfcDvsCdF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','abstCntnF')}"><div class="ep_label_box"><input type="checkbox" id="forRTb2_15" name="abstCntnF"><label for="forRTb2_15"> <c:out value="${rims:codeValue('stats.exp.item.art','abstCntnF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','fileAtF')}"><div class="ep_label_box"><input type="checkbox" id="forRTb2_16" name="fileAtF"><label for="forRTb2_16"> <c:out value="${rims:codeValue('stats.exp.item.art','fileAtF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','modDateF')}"><div class="ep_label_box"><input type="checkbox" id="forRTb2_17" name="modDateF"><label for="forRTb2_17"> <c:out value="${rims:codeValue('stats.exp.item.art','modDateF')}"/></label></div></c:if>
                                </td>
                                <td style="text-align: left;padding-left: 10px; vertical-align:top">
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','firstAuthorF')}"><div class="ep_label_box"><input type="checkbox" id="forRTb3_1" name="firstAuthorF"><label for="forRTb3_1"> <c:out value="${rims:codeValue('stats.exp.item.art','firstAuthorF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','corAuthorF')}"><div class="ep_label_box"><input type="checkbox" id="forRTb3_7" name="corAuthorF"><label for="forRTb3_7"> <c:out value="${rims:codeValue('stats.exp.item.art','corAuthorF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','authorsF')}"><div class="ep_label_box"><input type="checkbox" id="forRTb3_2" name="authorsF"><label for="forRTb3_2"> <c:out value="${rims:codeValue('stats.exp.item.art','authorsF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','totalAthrCntF')}"><div class="ep_label_box"><input type="checkbox" id="forRTb3_3" name="totalAthrCntF"><label for="forRTb3_3"> <c:out value="${rims:codeValue('stats.exp.item.art','totalAthrCntF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','athrCntF')}"><div class="ep_label_box"><input type="checkbox" id="forRTb3_4" name="athrCntF"><label for="forRTb3_4"> <c:out value="${rims:codeValue('stats.exp.item.art','athrCntF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','totalAthrDetailCntF')}"><div class="ep_label_box"><input type="checkbox" id="forRTb3_5" name="totalAthrDetailCntF"><label for="forRTb3_5"> <c:out value="${rims:codeValue('stats.exp.item.art','totalAthrDetailCntF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','mainProfessorsF')}"><div class="ep_label_box"><input type="checkbox" id="forRTb3_6" name="mainProfessorsF"><label for="forRTb3_6"> <c:out value="${rims:codeValue('stats.exp.item.art','mainProfessorsF')}"/></label></div></c:if>
                                </td>
                                <td style="text-align: left;padding-left: 10px; vertical-align:top">
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','ifLastTopMenuF')}">
                                        <ul class="ep_toggle_box">
                                            <li style="padding-bottom:5px;">
                                                <a href="javascript:void(0);" class="sideToggle"><span><img src="<c:url value="/images/background/ep_plus.png"/>"></span></a><input type="checkbox" name="forRTb4_L1" id="forRTb4_L1" onclick="clickCheckbox(this);"><label for="forRTb4_L1"> <c:out value="${rims:codeValue('stats.exp.item.art','ifLastTopMenuF')}"/></label>
                                                <ul style="padding-left: 35px; display: none;">
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','ifLastJcrF')}"><li><input type="checkbox" id="forRTb4_L11Sub" name="ifLastJcrF"><label for="forRTb4_L11Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifLastJcrF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','ifLastF')}"><li><input type="checkbox" id="forRTb4_L12Sub" name="ifLastF"><label for="forRTb4_L12Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifLastF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','ifLastCaCoF')}"><li><input type="checkbox" id="forRTb4_L13Sub" name="ifLastCaCoF"><label for="forRTb4_L13Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifLastCaCoF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','ifLastCaNmF')}"><li><input type="checkbox" id="forRTb4_L14Sub" name="ifLastCaNmF"><label for="forRTb4_L14Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifLastCaNmF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','ifLastCaRankF')}"><li><input type="checkbox" id="forRTb4_L15Sub" name="ifLastCaRankF"><label for="forRTb4_L15Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifLastCaRankF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','ifLastCaRatioF')}"><li><input type="checkbox" id="forRTb4_L16Sub" name="ifLastCaRatioF"><label for="forRTb4_L16Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifLastCaRatioF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','ifLastRatingF')}"><li><input type="checkbox" id="forRTb4_L17Sub" name="ifLastRatingF"><label for="forRTb4_L17Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifLastRatingF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','ifLastAvg20F')}"><li><input type="checkbox" id="forRTb4_L18Sub" name="ifLastAvg20F"><label for="forRTb4_L18Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifLastAvg20F')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','ifLastRevF')}"><li><input type="checkbox" id="forRTb4_L19Sub" name="ifLastRevF"><label for="forRTb4_L19Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifLastRevF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','ifLastOrnF')}"><li><input type="checkbox" id="forRTb4_L111Sub" name="ifLastOrnF"><label for="forRTb4_L111Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifLastOrnF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','ifLastIndexAvgIfPercentileF')}"><li><input type="checkbox" id="forRTb4_L116Sub" name="ifLastIndexAvgIfPercentileF"><label for="forRTb4_L116Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifLastIndexAvgIfPercentileF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','ifLastIndexAvgIfPercentileKorF')}"><li><input type="checkbox" id="forRTb4_L117Sub" name="ifLastIndexAvgIfPercentileKorF"><label for="forRTb4_L117Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifLastIndexAvgIfPercentileKorF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','ifLastIndexMrnifF')}"><li><input type="checkbox" id="forRTb4_L118Sub" name="ifLastIndexMrnifF"><label for="forRTb4_L118Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifLastIndexMrnifF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','ifLast5YF')}"><li><input type="checkbox" id="forRTb4_L112Sub" name="ifLast5YF"><label for="forRTb4_L112Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifLast5YF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','ifLast5YRatioF')}"><li><input type="checkbox" id="forRTb4_L113Sub" name="ifLast5YRatioF"><label for="forRTb4_L113Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifLast5YRatioF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','ifLast5YRatingF')}"><li><input type="checkbox" id="forRTb4_L114Sub" name="ifLast5YRatingF"><label for="forRTb4_L114Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifLast5YRatingF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','ifLast5YRankF')}"><li><input type="checkbox" id="forRTb4_L115Sub" name="ifLast5YRankF"><label for="forRTb4_L115Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifLast5YRankF')}"/></label></li></c:if>
                                                </ul>
                                            </li>
                                        </ul>
                                    </c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','esLastTopMenuF')}">
                                        <ul class="ep_toggle_box">
                                            <li style="padding-bottom:5px;">
                                                <a href="javascript:void(0);" class="sideToggle"><span><img src="<c:url value="/images/background/ep_plus.png"/>"></span></a><input type="checkbox" id="forRTb4_L2" name="forRTb4_L2" onclick="clickCheckbox(this);"><label for="forRTb4_L2"> <c:out value="${rims:codeValue('stats.exp.item.art','esLastTopMenuF')}"/></label>
                                                <ul style="padding-left: 35px; display: none;">
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','esLastVerF')}"><li><input type="checkbox" id="forRTb4_L21Sub" name="esLastVerF"><label for="forRTb4_L21Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','esLastVerF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','esLastF')}"><li><input type="checkbox" id="forRTb4_L22Sub" name="esLastF"><label for="forRTb4_L22Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','esLastF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','esLastCaRankF')}"><li><input type="checkbox" id="forRTb4_L23Sub" name="esLastCaRankF"><label for="forRTb4_L23Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','esLastCaRankF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','esLastRatioF')}"><li><input type="checkbox" id="forRTb4_L24Sub" name="esLastRatioF"><label for="forRTb4_L24Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','esLastRatioF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','esLastAvg20F')}"><li><input type="checkbox" id="forRTb4_L25Sub" name="esLastAvg20F"><label for="forRTb4_L25Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','esLastAvg20F')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','esLastRevF')}"><li><input type="checkbox" id="forRTb4_L26Sub" name="esLastRevF"><label for="forRTb4_L26Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','esLastRevF')}"/></label></li></c:if>
                                                </ul>
                                            </li>
                                        </ul>
                                    </c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','sjrLastTopMenuF')}">
                                        <ul class="ep_toggle_box">
                                            <li style="padding-bottom:5px;">
                                                <a href="javascript:void(0);" class="sideToggle"><span><img src="<c:url value="/images/background/ep_plus.png"/>"></span></a><input type="checkbox" id="forRTb4_L3" name="forRTb4_L3" onclick="clickCheckbox(this);"><label for="forRTb4_L3"> <c:out value="${rims:codeValue('stats.exp.item.art','sjrLastTopMenuF')}"/></label>
                                                <ul style="padding-left: 35px; display: none;">
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','sjrLastYearF')}"><li><input type="checkbox" id="forRTb4_L31Sub" name="sjrLastYearF"><label for="forRTb4_L31Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','sjrLastYearF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','sjrLastF')}"><li><input type="checkbox" id="forRTb4_L32Sub" name="sjrLastF"><label for="forRTb4_L32Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','sjrLastF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','sjrLastCaCoF')}"><li><input type="checkbox" id="forRTb4_L33Sub" name="sjrLastCaCoF"><label for="forRTb4_L33Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','sjrLastCaCoF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','sjrLastCaF')}"><li><input type="checkbox" id="forRTb4_L34Sub" name="sjrLastCaF"><label for="forRTb4_L34Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','sjrLastCaF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','sjrLastRankF')}"><li><input type="checkbox" id="forRTb4_L35Sub" name="sjrLastRankF"><label for="forRTb4_L35Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','sjrLastRankF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','sjrLastRatioF')}"><li><input type="checkbox" id="forRTb4_L36Sub" name="sjrLastRatioF"><label for="forRTb4_L36Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','sjrLastRatioF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','sjrLastRatingF')}"><li><input type="checkbox" id="forRTb4_L37Sub" name="sjrLastRatingF"><label for="forRTb4_L37Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','sjrLastRatingF')}"/></label></li></c:if>
                                                </ul>
                                            </li>
                                        </ul>
                                    </c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','citeScoreLastTopMenuF')}">
                                        <ul class="ep_toggle_box">
                                            <li style="padding-bottom:5px;">
                                                <a href="javascript:void(0);" class="sideToggle"><span><img src="<c:url value="/images/background/ep_plus.png"/>"></span></a><input type="checkbox" id="forRTb4_L4" name="forRTb4_L4" onclick="clickCheckbox(this);"><label for="forRTb4_L4"> <c:out value="${rims:codeValue('stats.exp.item.art','citeScoreLastTopMenuF')}"/></label>
                                                <ul style="padding-left: 35px; display: none;">
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','citeScoreLastYearF')}"><li><input type="checkbox" id="forRTb4_L41Sub" name="citeScoreLastYearF"><label for="forRTb4_L41Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','citeScoreLastYearF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','citeScoreLastF')}"><li><input type="checkbox" id="forRTb4_L42Sub" name="citeScoreLastF"><label for="forRTb4_L42Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','citeScoreLastF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','citeScoreLastCaCoF')}"><li><input type="checkbox" id="forRTb4_L43Sub" name="citeScoreLastCaCoF"><label for="forRTb4_L43Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','citeScoreLastCaCoF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','citeScoreLastCaF')}"><li><input type="checkbox" id="forRTb4_L44Sub" name="citeScoreLastCaF"><label for="forRTb4_L44Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','citeScoreLastCaF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','citeScoreLastRankF')}"><li><input type="checkbox" id="forRTb4_L45Sub" name="citeScoreLastRankF"><label for="forRTb4_L45Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','citeScoreLastRankF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','citeScoreLastRatioF')}"><li><input type="checkbox" id="forRTb4_L46Sub" name="citeScoreLastRatioF"><label for="forRTb4_L46Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','citeScoreLastRatioF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','citeScoreLastRatingF')}"><li><input type="checkbox" id="forRTb4_L47Sub" name="citeScoreLastRatingF"><label for="forRTb4_L47Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','citeScoreLastRatingF')}"/></label></li></c:if>
                                                </ul>
                                            </li>
                                        </ul>
                                    </c:if>
                                </td>
                                <td style="text-align: left;padding-left: 10px; vertical-align:top">
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','ifPubTopMenuF')}">
                                        <ul class="ep_toggle_box">
                                            <li style="padding-bottom:5px;">
                                                <a href="javascript:void(0);" class="sideToggle"><span><img src="<c:url value="/images/background/ep_plus.png"/>"></span></a><input type="checkbox" name="forRTb5_L1" id="forRTb5_L1" onclick="clickCheckbox(this);"><label for="forRTb5_L1"> <c:out value="${rims:codeValue('stats.exp.item.art','ifPubTopMenuF')}"/></label>
                                                <ul style="padding-left: 35px; display: none;">
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','ifPubJcrF')}"><li><input type="checkbox" id="forRTb5_L11Sub" name="ifPubJcrF"><label for="forRTb5_L11Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifPubJcrF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','ifPubF')}"><li><input type="checkbox" id="forRTb5_L12Sub" name="ifPubF"><label for="forRTb5_L12Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifPubF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','ifPubCaCoF')}"><li><input type="checkbox" id="forRTb5_L13Sub" name="ifPubCaCoF"><label for="forRTb5_L13Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifPubCaCoF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','ifPubCaNmF')}"><li><input type="checkbox" id="forRTb5_L14Sub" name="ifPubCaNmF"><label for="forRTb5_L14Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifPubCaNmF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','ifPubCaRankF')}"><li><input type="checkbox" id="forRTb5_L15Sub" name="ifPubCaRankF"><label for="forRTb5_L15Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifPubCaRankF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','ifPubCaRatioF')}"><li><input type="checkbox" id="forRTb5_L16Sub" name="ifPubCaRatioF"><label for="forRTb5_L16Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifPubCaRatioF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','ifPubRatingF')}"><li><input type="checkbox" id="forRTb5_L17Sub" name="ifPubRatingF"><label for="forRTb5_L17Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifPubRatingF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','ifPubAvg20F')}"><li><input type="checkbox" id="forRTb5_L18Sub" name="ifPubAvg20F"><label for="forRTb5_L18Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifPubAvg20F')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','ifPubRevF')}"><li><input type="checkbox" id="forRTb5_L19Sub" name="ifPubRevF"><label for="forRTb5_L19Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifPubRevF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','ifPubOrnF')}"><li><input type="checkbox" id="forRTb5_L111Sub" name="ifPubOrnF"><label for="forRTb5_L111Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifPubOrnF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','ifPubIndexAvgIfPercentileF')}"><li><input type="checkbox" id="forRTb5_L116Sub" name="ifPubIndexAvgIfPercentileF"><label for="forRTb5_L116Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifPubIndexAvgIfPercentileF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','ifPubIndexAvgIfPercentileKorF')}"><li><input type="checkbox" id="forRTb5_L117Sub" name="ifPubIndexAvgIfPercentileKorF"><label for="forRTb5_L117Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifPubIndexAvgIfPercentileKorF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','ifPubIndexMrnifF')}"><li><input type="checkbox" id="forRTb5_L118Sub" name="ifPubIndexMrnifF"><label for="forRTb5_L118Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifPubIndexMrnifF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','ifPub5YF')}"><li><input type="checkbox" id="forRTb5_L112Sub" name="ifPub5YF"><label for="forRTb5_L112Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifPub5YF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','ifPub5YRatioF')}"><li><input type="checkbox" id="forRTb5_L113Sub" name="ifPub5YRatioF"><label for="forRTb5_L113Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifPub5YRatioF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','ifPub5YRatingF')}"><li><input type="checkbox" id="forRTb5_L114Sub" name="ifPub5YRatingF"><label for="forRTb5_L114Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifPub5YRatingF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','ifPub5YRankF')}"><li><input type="checkbox" id="forRTb5_L115Sub" name="ifPub5YRankF"><label for="forRTb5_L115Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifPub5YRankF')}"/></label></li></c:if>
                                                </ul>
                                            </li>
                                        </ul>
                                    </c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','esPubTopMenuF')}">
                                        <ul class="ep_toggle_box">
                                            <li style="padding-bottom:5px;">
                                                <a href="javascript:void(0);" class="sideToggle"><span><img src="<c:url value="/images/background/ep_plus.png"/>"></span></a><input type="checkbox" id="forRTb5_L2" name="forRTb5_L2" onclick="clickCheckbox(this);"><label for="forRTb5_L2"> <c:out value="${rims:codeValue('stats.exp.item.art','esPubTopMenuF')}"/></label>
                                                <ul style="padding-left: 35px; display: none;">
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','esPubVerF')}"><li><input type="checkbox" id="forRTb5_L21Sub" name="esPubVerF"><label for="forRTb5_L21Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','esPubVerF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','esPubF')}"><li><input type="checkbox" id="forRTb5_L22Sub" name="esPubF"><label for="forRTb5_L22Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','esPubF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','esPubCaRankF')}"><li><input type="checkbox" id="forRTb5_L23Sub" name="esPubCaRankF"><label for="forRTb5_L23Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','esPubCaRankF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','esPubRatioF')}"><li><input type="checkbox" id="forRTb5_L24Sub" name="esPubRatioF"><label for="forRTb5_L24Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','esPubRatioF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','esPubAvg20F')}"><li><input type="checkbox" id="forRTb5_L25Sub" name="esPubAvg20F"><label for="forRTb5_L25Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','esPubAvg20F')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','esPubRevF')}"><li><input type="checkbox" id="forRTb5_L26Sub" name="esPubRevF"><label for="forRTb5_L26Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','esPubRevF')}"/></label></li></c:if>
                                                </ul>
                                            </li>
                                        </ul>
                                    </c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','sjrPubTopMenuF')}">
                                        <ul class="ep_toggle_box">
                                            <li style="padding-bottom:5px;">
                                                <a href="javascript:void(0);" class="sideToggle"><span><img src="<c:url value="/images/background/ep_plus.png"/>"></span></a><input type="checkbox" id="forRTb5_L3" name="forRTb5_L3" onclick="clickCheckbox(this);"><label for="forRTb5_L3"> <c:out value="${rims:codeValue('stats.exp.item.art','sjrPubTopMenuF')}"/></label>
                                                <ul style="padding-left: 35px; display: none;">
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','sjrPubYearF')}"><li><input type="checkbox" id="forRTb5_L31Sub" name="sjrPubYearF"><label for="forRTb5_L31Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','sjrPubYearF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','sjrPubF')}"><li><input type="checkbox" id="forRTb5_L32Sub" name="sjrPubF"><label for="forRTb5_L32Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','sjrPubF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','sjrPubCaCoF')}"><li><input type="checkbox" id="forRTb5_L33Sub" name="sjrPubCaCoF"><label for="forRTb5_L33Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','sjrPubCaCoF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','sjrPubCaF')}"><li><input type="checkbox" id="forRTb5_L34Sub" name="sjrPubCaF"><label for="forRTb5_L34Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','sjrPubCaF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','sjrPubRankF')}"><li><input type="checkbox" id="forRTb5_L35Sub" name="sjrPubRankF"><label for="forRTb5_L35Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','sjrPubRankF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','sjrPubRatioF')}"><li><input type="checkbox" id="forRTb5_L36Sub" name="sjrPubRatioF"><label for="forRTb5_L36Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','sjrPubRatioF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','sjrPubRatingF')}"><li><input type="checkbox" id="forRTb5_L37Sub" name="sjrPubRatingF"><label for="forRTb5_L37Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','sjrPubRatingF')}"/></label></li></c:if>
                                                </ul>
                                            </li>
                                        </ul>
                                    </c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','citeScorePubTopMenuF')}">
                                        <ul class="ep_toggle_box">
                                            <li style="padding-bottom:5px;">
                                                <a href="javascript:void(0);" class="sideToggle"><span><img src="<c:url value="/images/background/ep_plus.png"/>"></span></a><input type="checkbox" id="forRTb5_L4" name="forRTb5_L4" onclick="clickCheckbox(this);"><label for="forRTb5_L4"> <c:out value="${rims:codeValue('stats.exp.item.art','citeScorePubTopMenuF')}"/></label>
                                                <ul style="padding-left: 35px; display: none;">
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','citeScorePubYearF')}"><li><input type="checkbox" id="forRTb5_L41Sub" name="citeScorePubYearF"><label for="forRTb5_L41Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','citeScorePubYearF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','citeScorePubF')}"><li><input type="checkbox" id="forRTb5_L42Sub" name="citeScorePubF"><label for="forRTb5_L42Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','citeScorePubF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','citeScorePubCaCoF')}"><li><input type="checkbox" id="forRTb5_L43Sub" name="citeScorePubCaCoF"><label for="forRTb5_L43Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','citeScorePubCaCoF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','citeScorePubCaF')}"><li><input type="checkbox" id="forRTb5_L44Sub" name="citeScorePubCaF"><label for="forRTb5_L44Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','citeScorePubCaF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','citeScorePubRankF')}"><li><input type="checkbox" id="forRTb5_L45Sub" name="citeScorePubRankF"><label for="forRTb5_L45Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','citeScorePubRankF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','citeScorePubRatioF')}"><li><input type="checkbox" id="forRTb5_L46Sub" name="citeScorePubRatioF"><label for="forRTb5_L46Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','citeScorePubRatioF')}"/></label></li></c:if>
                                                    <c:if test="${not empty rims:codeValue('stats.exp.item.art','citeScorePubRatingF')}"><li><input type="checkbox" id="forRTb5_L47Sub" name="citeScorePubRatingF"><label for="forRTb5_L47Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','citeScorePubRatingF')}"/></label></li></c:if>
                                                </ul>
                                            </li>
                                        </ul>
                                    </c:if>
                                </td>
                            </tr>
                            </tbody>
						</table>
                        <table width="100%" class="list_tbl mgb_20" id="CONTb">
                            <colgroup>
                                <col style="width: 20%">
                                <col style="width: 10%">
                                <col style="width: 20%">
                                <col style="width: 25%">
                                <col style="width: 25%">
                            </colgroup>
                            <thead>
                            <tr>
                                <c:if test="${not empty rims:codeValue('stats.exp.item.con','rsrchInfF')}"><th style="padding-top: 0px;padding-bottom: 0px;"><label class="chk_label" for="forCTb0"><input type="checkbox" onclick="clickCheckbox(this);" id="forCTb0" name="forCTb0"> <c:out value="${rims:codeValue('stats.exp.item.con','rsrchInfF')}"/></label></th></c:if>
                                <c:if test="${not empty rims:codeValue('stats.exp.item.con','conMajorF')}"><th style="padding-top: 0px;padding-bottom: 0px;" colspan="2"><label class="chk_label" for="forCTb1"><input type="checkbox" onclick="clickCheckbox(this);" id="forCTb1" name="forCTb1"> <c:out value="${rims:codeValue('stats.exp.item.con','conMajorF')}"/></label></th></c:if>
                                <c:if test="${not empty rims:codeValue('stats.exp.item.con','conAddF')}"><th style="padding-top: 0px;padding-bottom: 0px;"><label class="chk_label" for="forCTb2"><input type="checkbox" onclick="clickCheckbox(this);" id="forCTb2" name="forCTb2"> <c:out value="${rims:codeValue('stats.exp.item.con','conAddF')}"/></label></th></c:if>
                                <c:if test="${not empty rims:codeValue('stats.exp.item.con','conMaster')}"><th style="padding-top: 0px;padding-bottom: 0px;"><label class="chk_label" for="forCTb3"><input type="checkbox" onclick="clickCheckbox(this);" id="forCTb3" name="forCTb3"> <c:out value="${rims:codeValue('stats.exp.item.con','conMaster')}"/></label></th></c:if>
                            </tr>
                            </thead>
                            <tbody>
                            <tr>
                                <td style="text-align: left;padding-left: 10px; vertical-align:top">
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.con','prtcpntIdF')}"><div class="ep_label_box"><input type="checkbox" id="forCTb0_1" name="prtcpntIdF"><label for="forCTb0_1"> <c:out value="${rims:codeValue('stats.exp.item.con','prtcpntIdF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.con','korNmF')}"><div class="ep_label_box"><input type="checkbox" id="forCTb0_2" name="korNmF"><label for="forCTb0_2"> <c:out value="${rims:codeValue('stats.exp.item.con','korNmF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.con','tpiDvsCdF')}"><div class="ep_label_box"><input type="checkbox" id="forCTb0_3" name="tpiDvsCdF"><label for="forCTb0_3"> <c:out value="${rims:codeValue('stats.exp.item.con','tpiDvsCdF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.con','gubunF')}"><div class="ep_label_box"><input type="checkbox" id="forCTb0_4" name="gubunF"><label for="forCTb0_4"> <c:out value="${rims:codeValue('stats.exp.item.con','gubunF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.con','grade1F')}"><div class="ep_label_box"><input type="checkbox" id="forCTb0_5" name="grade1F"><label for="forCTb0_5"> <c:out value="${rims:codeValue('stats.exp.item.con','grade1F')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.con','deptKorF')}"><div class="ep_label_box"><input type="checkbox" id="forCTb0_6" name="deptKorF"><label for="forCTb0_6"> <c:out value="${rims:codeValue('stats.exp.item.con','deptKorF')}"/></label></div></c:if>
                                </td>
                                <td style="text-align: left;padding-left: 10px; vertical-align:top">
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.con','conferenceIdF')}"><div class="ep_label_box"><input type="checkbox" id="forCTb1_1" name="conferenceIdF"><label for="forCTb1_1"> <c:out value="${rims:codeValue('stats.exp.item.con','conferenceIdF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.con','cfrcNmF')}"><div class="ep_label_box"><input type="checkbox" id="forCTb1_2" name="cfrcNmF"><label for="forCTb1_2"> <c:out value="${rims:codeValue('stats.exp.item.con','cfrcNmF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.con','scjnlNmF')}"><div class="ep_label_box"><input type="checkbox" id="forCTb1_3" name="scjnlNmF"><label for="forCTb1_3"> <c:out value="${rims:codeValue('stats.exp.item.con','scjnlNmF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.con','orgLangPprNmF')}"><div class="ep_label_box"><input type="checkbox" id="forCTb1_4" name="orgLangPprNmF"><label for="forCTb1_4"> <c:out value="${rims:codeValue('stats.exp.item.con','orgLangPprNmF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.con','scjnlDvsCdF')}"><div class="ep_label_box"><input type="checkbox" id="forCTb1_5" name="scjnlDvsCdF"><label for="forCTb1_5"> <c:out value="${rims:codeValue('stats.exp.item.con','scjnlDvsCdF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.con','pblcPlcNmF')}"><div class="ep_label_box"><input type="checkbox" id="forCTb1_6" name="pblcPlcNmF"><label for="forCTb1_6"> <c:out value="${rims:codeValue('stats.exp.item.con','pblcPlcNmF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.con','ancmStleCdF')}"><div class="ep_label_box"><input type="checkbox" id="forCTb1_7" name="ancmStleCdF"><label for="forCTb1_7"> <c:out value="${rims:codeValue('stats.exp.item.con','ancmStleCdF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.con','pblcNtnCdF')}"><div class="ep_label_box"><input type="checkbox" id="forCTb1_8" name="pblcNtnCdF"><label for="forCTb1_8"> <c:out value="${rims:codeValue('stats.exp.item.con','pblcNtnCdF')}"/></label></div></c:if>
                                </td>
                                <td style="text-align: left;padding-left: 10px; vertical-align:top">
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.con','sttPageF')}"><div class="ep_label_box"><input type="checkbox" id="forCTb1_9" name="sttPageF"><label for="forCTb1_9"> <c:out value="${rims:codeValue('stats.exp.item.con','sttPageF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.con','endPageF')}"><div class="ep_label_box"><input type="checkbox" id="forCTb1_10" name="endPageF"><label for="forCTb1_10"> <c:out value="${rims:codeValue('stats.exp.item.con','endPageF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.con','ancmDateF')}"><div class="ep_label_box"><input type="checkbox" id="forCTb1_11" name="ancmDateF"><label for="forCTb1_11"> <c:out value="${rims:codeValue('stats.exp.item.con','ancmDateF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.con','idSciF')}"><div class="ep_label_box"><input type="checkbox" id="forCTb1_16" name="idSciF"><label for="forCTb1_16"> <c:out value="${rims:codeValue('stats.exp.item.con','idSciF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.con','idScopusF')}"><div class="ep_label_box"><input type="checkbox" id="forCTb1_12" name="idScopusF"><label for="forCTb1_12"> <c:out value="${rims:codeValue('stats.exp.item.con','idScopusF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.con','doiF')}"><div class="ep_label_box"><input type="checkbox" id="forCTb1_13" name="doiF"><label for="forCTb1_13"> <c:out value="${rims:codeValue('stats.exp.item.con','doiF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.con','issnNoF')}"><div class="ep_label_box"><input type="checkbox" id="forCTb1_14" name="issnNoF"><label for="forCTb1_14"> <c:out value="${rims:codeValue('stats.exp.item.con','issnNoF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.con','isbnNoF')}"><div class="ep_label_box"><input type="checkbox" id="forCTb1_15" name="isbnNoF"><label for="forCTb1_15"> <c:out value="${rims:codeValue('stats.exp.item.con','isbnNoF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.con','tcF')}"><div class="ep_label_box"><input type="checkbox" id="forCTb1_17" name="tcF"><label for="forCTb1_17"> <c:out value="${rims:codeValue('stats.exp.item.con','tcF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.con','scpTcF')}"><div class="ep_label_box"><input type="checkbox" id="forCTb1_18" name="scpTcF"><label for="forCTb1_18"> <c:out value="${rims:codeValue('stats.exp.item.con','scpTcF')}"/></label></div></c:if>
                                </td>
                                <td style="text-align: left;padding-left: 10px; vertical-align:top">
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.con','firstAuthorF')}"><div class="ep_label_box"><input type="checkbox" id="forCTb2_1" name="firstAuthorF"><label for="forCTb2_1"> <c:out value="${rims:codeValue('stats.exp.item.con','firstAuthorF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.con','authorsF')}"><div class="ep_label_box"><input type="checkbox" id="forCTb2_2" name="authorsF"><label for="forCTb2_2"> <c:out value="${rims:codeValue('stats.exp.item.con','authorsF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.con','totalAthrCntF')}"><div class="ep_label_box"><input type="checkbox" id="forCTb2_3" name="totalAthrCntF"><label for="forCTb2_3"> <c:out value="${rims:codeValue('stats.exp.item.con','totalAthrCntF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.con','abstCntnF')}"><div class="ep_label_box"><input type="checkbox" id="forCTb2_4" name="abstCntnF"><label for="forCTb2_4"> <c:out value="${rims:codeValue('stats.exp.item.con','abstCntnF')}"/></label></div></c:if>
                                </td>
                                <td style="text-align: left;padding-left: 10px; vertical-align:top">
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.con','schlshpCnfrncCodeF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forCTb3_1" name="schlshpCnfrncCodeF"><label for="forCTb3_1"> <c:out value="${rims:codeValue('stats.exp.item.con','schlshpCnfrncCodeF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.con','schlshpCnfrncNmF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forCTb3_2" name="schlshpCnfrncNmF"><label for="forCTb3_2"> <c:out value="${rims:codeValue('stats.exp.item.con','schlshpCnfrncNmF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.con','impctFctrF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forCTb3_3" name="impctFctrF"><label for="forCTb3_3"> <c:out value="${rims:codeValue('stats.exp.item.con','impctFctrF')}"/></label></div></c:if>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                        <table width="100%" class="list_tbl mgb_20" id="BOOKTb">
                            <colgroup>
                                <col style="width: 30%">
                                <col style="width: 12%">
                                <col style="width: 28%">
                                <col style="width: 30%">
                            </colgroup>
                            <thead>
                            <tr>
                                <c:if test="${not empty rims:codeValue('stats.exp.item.book','rsrchInfF')}"><th style="padding-top: 0px;padding-bottom: 0px;"><label class="chk_label" for="forBTb0"><input type="checkbox" onclick="clickCheckbox(this);" id="forBTb0" name="forBTb0"> <c:out value="${rims:codeValue('stats.exp.item.book','rsrchInfF')}"/></label></th></c:if>
                                <c:if test="${not empty rims:codeValue('stats.exp.item.book','bookMajorF')}"><th style="padding-top: 0px;padding-bottom: 0px;" colspan="2"><label class="chk_label" for="forBTb1"><input type="checkbox" onclick="clickCheckbox(this);" id="forBTb1" name="forBTb1"> <c:out value="${rims:codeValue('stats.exp.item.book','bookMajorF')}"/></label></th></c:if>
                                <c:if test="${not empty rims:codeValue('stats.exp.item.book','bookAddF')}"><th style="padding-top: 0px;padding-bottom: 0px;"><label class="chk_label" for="forBTb2"><input type="checkbox" onclick="clickCheckbox(this);" id="forBTb2" name="forBTb2"> <c:out value="${rims:codeValue('stats.exp.item.book','bookAddF')}"/></label></th></c:if>
                            </tr>
                            </thead>
                            <tbody>
                            <tr>
                                <td style="text-align: left;padding-left: 10px; vertical-align:top">
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.book','prtcpntIdF')}"><div class="ep_label_box"><input type="checkbox" id="forBTb0_1" name="prtcpntIdF"><label for="forBTb0_1"> <c:out value="${rims:codeValue('stats.exp.item.book','prtcpntIdF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.book','korNmF')}"><div class="ep_label_box"><input type="checkbox" id="forBTb0_2" name="korNmF"><label for="forBTb0_2"> <c:out value="${rims:codeValue('stats.exp.item.book','korNmF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.book','tpiDvsCdF')}"><div class="ep_label_box"><input type="checkbox" id="forBTb0_3" name="tpiDvsCdF"><label for="forBTb0_3"> <c:out value="${rims:codeValue('stats.exp.item.book','tpiDvsCdF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.book','gubunF')}"><div class="ep_label_box"><input type="checkbox" id="forBTb0_4" name="gubunF"><label for="forBTb0_4"> <c:out value="${rims:codeValue('stats.exp.item.book','gubunF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.book','grade1F')}"><div class="ep_label_box"><input type="checkbox" id="forBTb0_5" name="grade1F"><label for="forBTb0_5"> <c:out value="${rims:codeValue('stats.exp.item.book','grade1F')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.book','deptKorF')}"><div class="ep_label_box"><input type="checkbox" id="forBTb0_6" name="deptKorF"><label for="forBTb0_6"> <c:out value="${rims:codeValue('stats.exp.item.book','deptKorF')}"/></label></div></c:if>
                                </td>
                                <td style="text-align: left;padding-left: 10px; vertical-align:top">
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.book','bookIdF')}"><div class="ep_label_box"><input type="checkbox" id="forBTb1_1" name="bookIdF"><label for="forBTb1_1"> <c:out value="${rims:codeValue('stats.exp.item.book','bookIdF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.book','bookDvsCdF')}"><div class="ep_label_box"><input type="checkbox" id="forBTb1_2" name="bookDvsCdF"><label for="forBTb1_2"> <c:out value="${rims:codeValue('stats.exp.item.book','bookDvsCdF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.book','orgLangBookNmF')}"><div class="ep_label_box"><input type="checkbox" id="forBTb1_3" name="orgLangBookNmF"><label for="forBTb1_3"> <c:out value="${rims:codeValue('stats.exp.item.book','orgLangBookNmF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.book','chapterTitleF')}"><div class="ep_label_box"><input type="checkbox" id="forBTb1_4" name="chapterTitleF"><label for="forBTb1_4"> <c:out value="${rims:codeValue('stats.exp.item.book','chapterTitleF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.book','pblcPlcNmF')}"><div class="ep_label_box"><input type="checkbox" id="forBTb1_5" name="pblcPlcNmF"><label for="forBTb1_5"> <c:out value="${rims:codeValue('stats.exp.item.book','pblcPlcNmF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.book','isbnNoF')}"><div class="ep_label_box"><input type="checkbox" id="forBTb1_6" name="isbnNoF"><label for="forBTb1_6"> <c:out value="${rims:codeValue('stats.exp.item.book','isbnNoF')}"/></label></div></c:if>
                                </td>
                                <td style="text-align: left;padding-left: 10px; vertical-align:top">
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.book','bookPblcYmF')}"><div class="ep_label_box"><input type="checkbox" id="forBTb1_7" name="bookPblcYmF"><label for="forBTb1_7"> <c:out value="${rims:codeValue('stats.exp.item.book','bookPblcYmF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.book','jnlDvsCdF')}"><div class="ep_label_box"><input type="checkbox" id="forBTb1_8" name="jnlDvsCdF"><label for="forBTb1_8"> <c:out value="${rims:codeValue('stats.exp.item.book','jnlDvsCdF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.book','totalPageF')}"><div class="ep_label_box"><input type="checkbox" id="forBTb1_9" name="totalPageF"><label for="forBTb1_9"> <c:out value="${rims:codeValue('stats.exp.item.book','totalPageF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.book','wrtSttEndPageF')}"><div class="ep_label_box"><input type="checkbox" id="forBTb1_10" name="wrtSttEndPageF"><label for="forBTb1_10"> <c:out value="${rims:codeValue('stats.exp.item.book','wrtSttEndPageF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.book','mkoutLangCdF')}"><div class="ep_label_box"><input type="checkbox" id="forBTb1_11" name="mkoutLangCdF"><label for="forBTb1_11"> <c:out value="${rims:codeValue('stats.exp.item.book','mkoutLangCdF')}"/></label></div></c:if>
                                </td>
                                <td style="text-align: left;padding-left: 10px; vertical-align:top">
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.book','dlgtAthrNmF')}"><div class="ep_label_box"><input type="checkbox" id="forBTb2_1" name="dlgtAthrNmF"><label for="forBTb2_1"> <c:out value="${rims:codeValue('stats.exp.item.book','dlgtAthrNmF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.book','authorsF')}"><div class="ep_label_box"><input type="checkbox" id="forBTb2_2" name="authorsF"><label for="forBTb2_2"> <c:out value="${rims:codeValue('stats.exp.item.book','authorsF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.book','totalAthrCntF')}"><div class="ep_label_box"><input type="checkbox" id="forBTb2_3" name="totalAthrCntF"><label for="forBTb2_3"> <c:out value="${rims:codeValue('stats.exp.item.book','totalAthrCntF')}"/></label></div></c:if>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                        <table width="100%" class="list_tbl mgb_20" id="PATTb">
                            <colgroup>
                                <col style="width: 30%">
                                <col style="width: 12%">
                                <col style="width: 28%">
                                <col style="width: 30%">
                            </colgroup>
                            <thead>
                            <tr>
                                <c:if test="${not empty rims:codeValue('stats.exp.item.pat','rsrchInfF')}"><th style="padding-top: 0px;padding-bottom: 0px;"><label class="chk_label" for="forPTb0"><input type="checkbox" onclick="clickCheckbox(this);" id="forPTb0" name="forPTb0"> <c:out value="${rims:codeValue('stats.exp.item.pat','rsrchInfF')}"/></label></th></c:if>
                                <c:if test="${not empty rims:codeValue('stats.exp.item.pat','patMajorF')}"><th style="padding-top: 0px;padding-bottom: 0px;" colspan="2"><label class="chk_label" for="forPTb1"><input type="checkbox" onclick="clickCheckbox(this);" id="forPTb1" name="forPTb1"> <c:out value="${rims:codeValue('stats.exp.item.pat','patMajorF')}"/></label></th></c:if>
                                <c:if test="${not empty rims:codeValue('stats.exp.item.pat','patAddF')}"><th style="padding-top: 0px;padding-bottom: 0px;"><label class="chk_label" for="forPTb2"><input type="checkbox" onclick="clickCheckbox(this);" id="forPTb2" name="forPTb2"> <c:out value="${rims:codeValue('stats.exp.item.pat','patAddF')}"/></label></th></c:if>
                            </tr>
                            </thead>
                            <tbody>
                            <tr>
                                <td style="text-align: left;padding-left: 10px; vertical-align:top">
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.pat','prtcpntIdF')}"><div class="ep_label_box"><input type="checkbox" id="forPTb0_1" name="prtcpntIdF"><label for="forPTb0_1"> <c:out value="${rims:codeValue('stats.exp.item.pat','prtcpntIdF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.pat','korNmF')}"><div class="ep_label_box"><input type="checkbox" id="forPTb0_2" name="korNmF"><label for="forPTb0_2"> <c:out value="${rims:codeValue('stats.exp.item.pat','korNmF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.pat','gubunF')}"><div class="ep_label_box"><input type="checkbox" id="forPTb0_3" name="gubunF"><label for="forPTb0_3"> <c:out value="${rims:codeValue('stats.exp.item.pat','gubunF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.pat','deptKorF')}"><div class="ep_label_box"><input type="checkbox" id="forPTb0_4" name="deptKorF"><label for="forPTb0_4"> <c:out value="${rims:codeValue('stats.exp.item.pat','deptKorF')}"/></label></div></c:if>
                                </td>
                                <td style="text-align: left;padding-left: 10px; vertical-align:top">
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.pat','patentIdF')}"><div class="ep_label_box"><input type="checkbox" id="forPTb1_1" name="patentIdF"><label for="forPTb1_1"> <c:out value="${rims:codeValue('stats.exp.item.pat','patentIdF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.pat','itlPprRgtDvsCdF')}"><div class="ep_label_box"><input type="checkbox" id="forPTb1_2" name="itlPprRgtDvsCdF"><label for="forPTb1_2"> <c:out value="${rims:codeValue('stats.exp.item.pat','itlPprRgtDvsCdF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.pat','acqsDvsCdF')}"><div class="ep_label_box"><input type="checkbox" id="forPTb1_3" name="acqsDvsCdF"><label for="forPTb1_3"> <c:out value="${rims:codeValue('stats.exp.item.pat','acqsDvsCdF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.pat','acqsNtnDvsCdF')}"><div class="ep_label_box"><input type="checkbox" id="forPTb1_4" name="acqsNtnDvsCdF"><label for="forPTb1_4"> <c:out value="${rims:codeValue('stats.exp.item.pat','acqsNtnDvsCdF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.pat','statusF')}"><div class="ep_label_box"><input type="checkbox" id="forPTb1_5" name="statusF"><label for="forPTb1_5"> <c:out value="${rims:codeValue('stats.exp.item.pat','statusF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.pat','applRegNtnCdF')}"><div class="ep_label_box"><input type="checkbox" id="forPTb1_6" name="applRegNtnCdF"><label for="forPTb1_6"> <c:out value="${rims:codeValue('stats.exp.item.pat','applRegNtnCdF')}"/></label></div></c:if>

                                </td>
                                <td style="text-align: left;padding-left: 10px; vertical-align:top">
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.pat','itlPprRgtNmF')}"><div class="ep_label_box"><input type="checkbox" id="forPTb1_7" name="itlPprRgtNmF"><label for="forPTb1_7"> <c:out value="${rims:codeValue('stats.exp.item.pat','itlPprRgtNmF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.pat','applRegDateF')}"><div class="ep_label_box"><input type="checkbox" id="forPTb1_8" name="applRegDateF"><label for="forPTb1_8"> <c:out value="${rims:codeValue('stats.exp.item.pat','applRegDateF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.pat','applRegNoF')}"><div class="ep_label_box"><input type="checkbox" id="forPTb1_9" name="applRegNoF"><label for="forPTb1_9"> <c:out value="${rims:codeValue('stats.exp.item.pat','applRegNoF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.pat','itlPprRgtRegDateF')}"><div class="ep_label_box"><input type="checkbox" id="forPTb1_10" name="itlPprRgtRegDateF"><label for="forPTb1_10"> <c:out value="${rims:codeValue('stats.exp.item.pat','itlPprRgtRegDateF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.pat','itlPprRgtRegNoF')}"><div class="ep_label_box"><input type="checkbox" id="forPTb1_11" name="itlPprRgtRegNoF"><label for="forPTb1_11"> <c:out value="${rims:codeValue('stats.exp.item.pat','itlPprRgtRegNoF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.pat','patClsCdF')}"><div class="ep_label_box"><input type="checkbox" id="forPTb1_12" name="patClsCdF"><label for="forPTb1_12"> <c:out value="${rims:codeValue('stats.exp.item.pat','patClsCdF')}"/></label></div></c:if>
                                </td>
                                <td style="text-align: left;padding-left: 10px; vertical-align:top">
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.pat','applRegtNmF')}"><div class="ep_label_box"><input type="checkbox" id="forPTb2_1" name="applRegtNmF"><label for="forPTb2_1"> <c:out value="${rims:codeValue('stats.exp.item.pat','applRegtNmF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.pat','authorsF')}"><div class="ep_label_box"><input type="checkbox" id="forPTb2_2" name="authorsF"><label for="forPTb2_2"> <c:out value="${rims:codeValue('stats.exp.item.pat','authorsF')}"/></label></div></c:if>
                                    <c:if test="${not empty rims:codeValue('stats.exp.item.pat','totalAthrCntF')}"><div class="ep_label_box"><input type="checkbox" id="forPTb2_3" name="totalAthrCntF"><label for="forPTb2_3"> <c:out value="${rims:codeValue('stats.exp.item.pat','totalAthrCntF')}"/></label></div></c:if>
                                </td>
                            </tr>
                            </tbody>
                        </table>
					</td>
				</tr>
				</tbody>
			</table>
			<div class="list_set">
				<ul>
					<li><a href="javascript:saveTemplate();$('#templateDialog #closeBtn').triggerHandler('click');" class="list_icon05">저장</a></li>
                    <li class="delTemp"><a href="javascript:deleteTemplate();" class="list_icon10">삭제</a></li>
					<li><a href="javascript:$('#templateDialog #closeBtn').triggerHandler('click');" class="list_icon10">취소</a></li>
				</ul>
			</div>
		</div>
</div>
</body>
</html>