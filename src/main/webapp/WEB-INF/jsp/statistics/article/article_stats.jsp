<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../pageInit.jsp" %>
<jsp:useBean id="now" class="java.util.Date" />
<fmt:formatDate value="${now}" var="thisYear" pattern="yyyy" />
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Article Statistics</title>
<style type="text/css">
.dhxwins_vp_dhx_terrace {overflow: auto;}
.dhxwins_vp_dhx_terrace div.dhxwin_active div.dhx_cell_wins div.dhx_cell_toolbar_def, .dhxwins_vp_dhx_terrace div.dhxwin_inactive div.dhx_cell_wins div.dhx_cell_toolbar_def { padding: 10px 0px 0; }
.dhx_toolbar_dhx_terrace { padding: 0 0px; }
div.gridbox_dhx_terrace.gridbox .xhdr {border-bottom: 1px solid #ccc; border-top: 1px solid #ccc; background-color: #f5f5f5;}
div.gridbox_dhx_terrace.gridbox table.hdr td{vertical-align: middle;}
div.gridbox_dhx_terrace.gridbox table.hdr td div.hdrcell{padding-top: 4px; padding-bottom: 4px;line-height: 15px;}
.effectExport {color : red;}
.list_tbl {border-top : none;}
.list_tbl tbody td { border-bottom : none;}
.list_tbl thead th {background : none; border-bottom:2px solid #5e9bf8;}
table ul li ul li {padding-top: 10px;}
table tbody div {padding-top: 10px;}
</style>
<script type="text/javascript" src="<c:url value="/js/jquery/jquery.filedownload.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/mainLayout.js"/>"></script>
<script type="text/javascript">
var dhxLayout, myGrid, t, param;

$(document).ready(function(){
    //반입항목 Modal
    bindModalLink();

    setMainLayoutHeight($('#mainLayout'));
    if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
    else  window.addEventListener("resize",resizeLayout, false);
    //set layout
    dhxLayout = new dhtmlXLayoutObject("mainLayout","1C");
    dhxLayout.cells("a").hideHeader();
    dhxLayout.setSizes(false);
    myGrid = dhxLayout.cells("a").attachGrid();
    myGrid.setImagePath("${dhtmlXImagePath}");
    myGrid.attachEvent("onXLS", doBeforeGridLoad);
    myGrid.attachEvent("onXLE", doOnGridLoaded);
    myGrid.attachEvent("onRowSelect", function(id,ind) {
        var columnId = myGrid.getColumnId(ind);
        if (columnId == "pubyear" || columnId == "prtcpntId" || columnId == "userNm" || columnId == "groupDept" || columnId == "hldofYn" ||
            columnId == "total_if" || columnId == "total_tc" || columnId == "co_has_if" || columnId == "co_has_tc") return;

        param = "";
        if (columnId == "sci") param += "ovrsExclncScjnlPblcYn=1&";
        else if (columnId == "scie") param += "ovrsExclncScjnlPblcYn=2&";
        else if (columnId == "ssci") param += "ovrsExclncScjnlPblcYn=3&";
        else if (columnId == "ahci") param += "ovrsExclncScjnlPblcYn=4&";
        else if (columnId == "intl_j") param += "scjnlDvsCd=1&";
        else if (columnId == "intl_g") param += "scjnlDvsCd=2&";
        else if (columnId == "dmst_j") param += "scjnlDvsCd=3&";
        else if (columnId == "dmst_g") param += "scjnlDvsCd=4&";
        else if (columnId == "other") param += "scjnlDvsCd=5&";
        else if (columnId == "bSci") param += "ovrsExclncScjnlPblcYn=1&enterGubun=B&";
        else if (columnId == "bScie") param += "ovrsExclncScjnlPblcYn=2&enterGubun=B&";
        else if (columnId == "bSsci") param += "ovrsExclncScjnlPblcYn=3&enterGubun=B&";
        else if (columnId == "bAhci") param += "ovrsExclncScjnlPblcYn=4&enterGubun=B&";
        else if (columnId == "aSci") param += "ovrsExclncScjnlPblcYn=1&enterGubun=A&";
        else if (columnId == "aScie") param += "ovrsExclncScjnlPblcYn=2&enterGubun=A&";
        else if (columnId == "aSsci") param += "ovrsExclncScjnlPblcYn=3&enterGubun=A&";
        else if (columnId == "aAhci") param += "ovrsExclncScjnlPblcYn=4&enterGubun=A&";
        else if (columnId == "bScopus") param += "enterGubun=B&";
        else if (columnId == "aScopus") param += "enterGubun=B&";
        else if (columnId == "bIntl_j") param += "scjnlDvsCd=1&enterGubun=B&";
        else if (columnId == "bIntl_g") param += "scjnlDvsCd=2&enterGubun=B&";
        else if (columnId == "bDmst_j") param += "scjnlDvsCd=3&enterGubun=B&";
        else if (columnId == "bDmst_g") param += "scjnlDvsCd=4&enterGubun=B&";
        else if (columnId == "aIntl_j") param += "scjnlDvsCd=1&enterGubun=A&";
        else if (columnId == "aIntl_g") param += "scjnlDvsCd=2&enterGubun=A&";
        else if (columnId == "aDmst_j") param += "scjnlDvsCd=3&enterGubun=A&";
        else if (columnId == "aDmst_g") param += "scjnlDvsCd=4&enterGubun=A&";

        for (var i = 0; i <= 2; i++) {
            if (myGrid.getColumnId(i) == "prtcpntId") param += "prtcpntId=" + myGrid.cellById(id,i).getValue() + "&";
            if (myGrid.getColumnId(i) == "groupDept") param += "groupDept=" + myGrid.cellById(id,i).getValue() + "&";
            if (myGrid.getColumnId(i) == "pubyear") param += "pubyear=" + myGrid.cellById(id,i).getValue() + "&";
        }

        exportSelectBox();
    });
//	myGrid.enableColSpan(true);
    myGrid.init();
    myGrid_load();

    //체크박스 부분체크 및 체크해제시 전체 체크및 체크 효과
    $('.popup_inner tbody input[type="checkbox"]').click(function (){
        if(this.id.indexOf("Sub") != -1){
            var parentId2 = this.id.substr(0,10);
            var i = 0;
            if($("#"+parentId2).prop("checked")) i=1;
            var checkBoxTdSize2 = $('.popup_inner tbody input[id^="'+parentId2+'"]').size()-1;

            if(($('.popup_inner tbody input[id^="'+parentId2+'"]:checked').size()-i) == checkBoxTdSize2){
                $("#"+parentId2).prop('checked', true);
            }else{
                $("#"+parentId2).prop('checked', false);
            }
        }

        var parentId = this.id.substr(0,7);
        var checkBoxTdSize = $('.popup_inner tbody input[id^="'+parentId+'"]').size();

        if($('.popup_inner tbody input[id^="'+parentId+'"]:checked').size() == checkBoxTdSize){
            $("#"+parentId).prop('checked', true);
        }else{
            $("#"+parentId).prop('checked', false);
        }
    });

    $('#selectDialog #closeBtn').click(function (){
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

	$('#selectDialogIn input[type="checkbox"]').click(function(){
		if($(this).prop("checked") == true){
			$(this).val(1);
		}else{
			$(this).val(0);
		}
	});
});
function myGrid_load(){
    myGrid.clearAndLoad('<c:url value="/${preUrl}/statistics/article/statistics.do?"/>' + $('#formArea').serialize());
}

function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){setMainLayoutHeight($('#mainLayout')); dhxLayout.setSizes(false); },80);}
function doOnGridLoaded(){setTimeout(function() {dhxLayout.cells("a").progressOff();}, 100);}
function doBeforeGridLoad(){dhxLayout.cells("a").progressOn();}

function myGrid_onRowSelect(rowID,celInd){
    var wWidth = 990;
    var wHeight = 822;
    var leftPos = (screenWidth - wWidth)/2;
    var topPos = (screenHeight - wHeight)/2;
    if(rowID == '0') return;
    var str = rowID.split('_');
    var mappingPopup = window.open('about:blank', 'articlePopup', 'width='+wWidth+'px,height='+wHeight+'px,top='+topPos+',left='+leftPos+' location=no,scrollbars=yes,resizable=yes');
    var popFrm = $('#popFrm');
    popFrm.empty();
    popFrm.append($('<input type="hidden" name="articleId" value="'+str[1]+'"/>'));
    popFrm.attr('action', '<c:url value="/article/articlePopup.do"/>');
    popFrm.attr('target', 'articlePopup');
    popFrm.attr('method', 'POST');
    popFrm.submit();
    mappingPopup.focus();
}
function changeStatsGubun() {
    if ($('input[name=statsGubun]:checked').val() == "P") {
        $('#jnlGubun0').css('display', '');
        $('#jnlGubun0').attr('disabled', false);
        $('#jnlGubun1').css('display', 'none');
        $('#jnlGubun1').attr('disabled', true);
        $('.researcherGubun').css('display', '');
        $('.researcherGubun input').attr('disabled', false);
        $('.researcherGubun select').attr('disabled', false);
        $('#articleDept').css('display', 'none');
        $('#articleDept select').attr('disabled', true);

        setGrade1();
    } else if ($('input[name=statsGubun]:checked').val() == "A") {
        $('#jnlGubun0').css('display', 'none');
        $('#jnlGubun0').attr('disabled', true);
        $('#jnlGubun1').css('display', '');
        $('#jnlGubun1').attr('disabled', false);
        $('.researcherGubun').css('display', 'none');
        $('.researcherGubun input').attr('disabled', true);
        $('.researcherGubun select').attr('disabled', true);

        if($("#jnlGubun1").val() == "byDept"){
            $('#articleDept').css('display', '');
            $('#articleDept select').attr('disabled', false);
        }else{
            $('#articleDept').css('display', 'none');
            $('#articleDept select').attr('disabled', true);
        }
    }
    resizeLayout();
}
function setGrade1() {
    if ($('input[name=gubun]:checked').val() == "M") {
        $('input[name=grade1]').attr('disabled', false);
    } else {
        $("input[name=grade1]:radio[value='']").prop("checked", true);
        $('input[name=grade1]').attr('disabled', true);
    }
}
function downloadListXlsx() {
    var exportField;
    var statsGubun = $('input[name=statsGubun]').val();

    <c:if test="${not sessMode and sessionScope.auth.adminDvsCd ne 'R' and  sessionScope.auth.adminDvsCd ne 'S' }">statsGubun = $('input[name=statsGubun]:checked').val();</c:if>

    if(statsGubun == "P"){
        exportField = $('#forPForm').serializeArray();
    }else if(statsGubun == "A"){
        exportField = $('#forAForm').serializeArray();
    }

    var formAreaData = $('#formArea').serializeArray();
    var jsonData = formAreaData.concat(exportField);
    var paramJsonArr = param.split("&");
    for(var i=0; i<paramJsonArr.length; i++){
        var paramJsonArr2 = paramJsonArr[i].split("=");
        if(paramJsonArr[i] != "")jsonData.push({name: paramJsonArr2[0], value: paramJsonArr2[1]});
    }

    var url = '${contextPath}/${preUrl}/statistics/article/exportArt.do';
    var expAnchor = $('<a class="exp_anchor" href="'+url+'"></a>');
    $("body").append(expAnchor);
    $('a.exp_anchor').bind('click',function(){
        doBeforeGridLoad();
        $.fileDownload($(this).prop('href'),{
            httpMethod: 'POST',
            dataType:"json",
            contentType:"application/json",
            data: jsonData,
            successCallback: function (url) {
                doOnGridLoaded();
                $('a.exp_anchor').remove();
            },
            failCallback: function (responseHtml, url) {
                doOnGridLoaded();
                $('a.exp_anchor').remove();
            }
        });
    }).trigger('click');
}

function exportSelectBox(){
    if($("#templateSelect ").size() > 0)$("#templateSelect").find("option:eq(0)").prop("selected", true);
    findTemplate();
    var statsGubun = $('input[name=statsGubun]').val();

    <c:if test="${not sessMode and sessionScope.auth.adminDvsCd ne 'R' and  sessionScope.auth.adminDvsCd ne 'S' }">statsGubun = $('input[name=statsGubun]:checked').val();</c:if>

    if(statsGubun == "P"){
        $("#forAForm").css("display","none");
        $("#forPForm").css("display","");
    }else if(statsGubun == "A"){
        $("#forPForm").css("display","none");
        $("#forAForm").css("display","");
    }

    $(".popup_header h3").text("<spring:message code='stats.export.title'/>");

    $("#selectDialogBtn").click();
}

function clickCheckbox(obj){
    var id = $(obj).attr("id");
    if($("#"+id).prop("checked") == true)
    {
        $('input[id^="'+id+'"]').prop('checked', true);
        $('input[id^="'+id+'"]').val(1);
    }
    else
    {
        $('input[id^="'+id+'"]').prop('checked', false);
		$('input[id^="'+id+'"]').val(0);
    }
}

function findTemplate() {
    sideToggleInit();
    if($("#templateSelect").val() == null){
        return;
    }else if($("#templateSelect").val() == "custom"){
        $("#selectDialog input").prop("checked",false);
        $("#selectDialog input").val(0);
    }else{
        $("#selectDialog input").prop("checked",false);
		$("#selectDialog input").val(0);
        $.ajax({
            url: "<c:url value="/auth/statistics/findStatsTemplateAjax.do"/>?sn="+$("#templateSelect").val(),
            type: "POST"
        }).done(function(data){
            //모달 세팅
            var fieldArr = data.field.split(",");
            var statsGubun = $('input[name=statsGubun]').val();

            <c:if test="${not sessMode and sessionScope.auth.adminDvsCd ne 'R' and  sessionScope.auth.adminDvsCd ne 'S' }">statsGubun = $('input[name=statsGubun]:checked').val();</c:if>

            if(statsGubun == "P"){
                for(var i=0; i<fieldArr.length; i++){
                    $("#forPForm input[name="+fieldArr[i]+"]").prop("checked",true);
                    $("#forPForm input[name="+fieldArr[i]+"]").val(1);
                }
            }else{
                for(var i=0; i<fieldArr.length; i++){
                    $("#forAForm input[name="+fieldArr[i]+"]").prop("checked",true);
                    $("#forAForm input[name="+fieldArr[i]+"]").val(1);
                }
            }
        });
    }
}

function sideToggleInit(){
    $(".sideToggle").removeClass('show');
    $(".sideToggle").next().next().next().removeClass('on');
    $(".sideToggle").next().next().next().slideUp(350);
    $(".sideToggle").html('<span><img src="<c:url value="/images/background/ep_plus.png"/>"> </span>');
}
function footerClick(parameter){
    param = parameter;
    exportSelectBox();
}
</script>
</head>
<body>
<div class="title_box">
	<h3><spring:message code='menu.statistics.article'/></h3>
</div>
<div class="contents_box">
	<!-- START 테이블 1 -->
	<form id="formArea" method="post" >
		<c:if test="${not sessMode and sessionScope.auth.adminDvsCd ne 'R' and  sessionScope.auth.adminDvsCd ne 'S' }">
			<table class="view_tbl mgb_10" style="table-layout: fixed;" >
				<colgroup>
					<col style="width: 9%;" />
					<col style="width: 24%;" />
					<col style="width: 9%;" />
					<col style="width: 24%;" />
					<col style="width: 9%;" />
					<col />
					<col style="width: 50px;"/>
				</colgroup>
				<tbody>
				<tr>
					<th>통계 기준</th>
					<td>
						<span style="float: left;"><input type="radio" id="statsGubun0" name="statsGubun" class="radio" value="P" onchange="changeStatsGubun();" checked="checked" />
						<label for="statsGubun0" class="radio_label">연구자 기준</label></span>
						<span style="float: left;"><input type="radio" id="statsGubun1" name="statsGubun" class="radio" value="A" onchange="changeStatsGubun();" />
						<label for="statsGubun1" class="radio_label">논문 기준</label></span>
					</td>
					<th>통계 유형</th>
					<td>
						<select id="jnlGubun0" name="jnlGubun" class="select1">
							<option value="byYear" selected="selected">연도별 통계</option>
							<option value="byPerson">개인별 통계</option>
							<option value="byDept">학과별(구분없음) 통계</option>
							<option value="byDeptYear">학과별(연도별구분) 통계</option>
							<option value="byDeptHldof">학과별(재직여부구분) 통계</option>
						</select>
							<%--<span id="jnlGubun1" style="display: none;">연도별 통계</span>--%>
						<select id="jnlGubun1" name="jnlGubun" class="select1" style="display: none;" disabled="disabled" onchange="if($(this).val() == 'byDept'){$('#articleDept').css('display', '');$('#articleDept select').attr('disabled', false);}else{$('#articleDept').css('display', 'none');$('#articleDept select').attr('disabled', true);}">
							<option value="byYear" selected="selected">연도별 통계</option>
							<option value="byDept">학과별(구분없음) 통계</option>
						</select>
						<span id="articleDept" style="display:none;">
							<c:if test="${sessionScope.auth.adminDvsCd ne 'M'}">
								<c:if test="${sessionScope.auth.adminDvsCd eq 'C'}">
								<select name="dept" class="select1" disabled="disabled">
									<option value="">전체</option>
									<c:forEach var="item" items="${deptList}">
										<option value="${item.groupDept}">${item.groupDept}</option>
									</c:forEach>
								</select>
								</c:if>
							</c:if>
							<c:if test="${sessionScope.auth.adminDvsCd eq 'M'}">
								<select name="dept" class="select1" disabled="disabled">
									<option value="">전체</option>
									<c:forEach var="item" items="${deptList}">
										<option value="${item.groupDept}">${item.groupDept}</option>
									</c:forEach>
								</select>
							</c:if>
						</span>
					</td>
					<th>JCR</th>
					<td>
						<select name="jcrIfRatio"  style="margin-right: 5px;">
							<option value="0">미적용</option>
							<option value="1">1%</option>
							<option value="10">10%</option>
							<option value="12">20%</option>
						</select>
						<span>
							<input type="radio" name="prodyearType" id="prodyearType1" class="radio" value="latest" checked="checked"/>
							<label for="prodyearType1" class="radio_label">최신년 기준</label>
						</span>
						<span>
							<c:set value="${sysConf['article.jcr.prodyearType']}" var="jcrProdYearType"/>
							<input type="radio" name="prodyearType" id="prodyearType2" class="radio" value="${empty jcrProdYearType ? 'pubyear' : jcrProdYearType}"/>
							<label for="prodyearType2" class="radio_label">${jcrProdYearType eq 'pubyear-1' ? '출판년-1' : jcrProdYearType eq 'pubyear-2' ? '출판년-2' : '출판년'} 기준</label>
						</span>
					</td>
					<td rowspan="${sessionScope.auth.adminDvsCd eq 'M' ? '8' : '6' }" class="option_search_td" onclick="javascript:myGrid_load();"><em>search</em></td>
				</tr>
				<tr>
					<th>논문 대상</th>
					<td>
						<input type="radio" id="scjnlGubun1" name="scjnlGubun" class="radio" value="S" checked="checked" />
						<label for="scjnlGubun1" class="radio_label">SCI 논문</label>
						<input type="radio" id="scjnlGubun2" name="scjnlGubun" class="radio" value="SCOPUS"/>
						<label for="scjnlGubun2" class="radio_label">SCOPUS 논문</label>
						<input type="radio" id="scjnlGubun0" name="scjnlGubun" class="radio" value="" />
						<label for="scjnlGubun0" class="radio_label">전체 논문</label>
					</td>
					<th>출판년도</th>
					<td>
						<span style="float: left;"><input type="text" id="stt_date" name="sttDate" class="input2" value="${thisYear-2 }" maxlength="4" style="width: 60px;" />
						~ <input type="text" id="end_date" name="endDate" class="input2" maxlength="4" style="width: 60px;" /></span>
						<span style="float: left;padding: 2px 0 0 5px;"><input type="checkbox" name="isAccept" id="is_accept" value="true" class="radio" checked="checked" />
						<label for="is_accept" class="radio_label" title="Accept 미포함 (Accept 논문 반출 방법: 출판년도 앞에만 입력 후, Accept 미포함 버튼 해제)">Accept 미포함<span style="font-size: 11px;">(Accept 논문 반출 ...</span></label></span>
					</td>
					<th>ISSN번호</th>
					<td>
						<span style="float: left;"><input type="text" name="issnNo" class="input2" /></span>
					</td>
				</tr>
				<tr>
					<th>기관승인여부</th>
					<td>
						<span style="float: left;"><input type="radio" id="apprDvsCd0" name="apprDvsCd" class="radio" value="" checked="checked" /> <label for="apprDvsCd0" class="radio_label">전체</label></span>
						<span style="float: left;"><input type="radio" id="apprDvsCd1" name="apprDvsCd" class="radio" value="3" /> <label for="apprDvsCd1" class="radio_label">승인완료</label></span>
						<span style="float: left;"><input type="radio" id="apprDvsCd2" name="apprDvsCd" class="radio" value="1" /> <label for="apprDvsCd2" class="radio_label">미승인</label></span>
						<span style="float: left;"><input type="radio" id="apprDvsCd3" name="apprDvsCd" class="radio" value="2" /> <label for="apprDvsCd3" class="radio_label">보류</label></span>
						<span style="float: left;"><input type="radio" id="apprDvsCd4" name="apprDvsCd" class="radio" value="4" /> <label for="apprDvsCd4" class="radio_label">반려</label></span>
					</td>
					<th>기관실적구분</th>
					<td>
						<span style="float: left;"><input type="radio" id="insttRsltAt0" name="insttRsltAt" class="radio" value="" checked="checked" /> <label for="insttRsltAt0" class="radio_label">전체</label></span>
						<span style="float: left;"><input type="radio" id="insttRsltAt1" name="insttRsltAt" class="radio" value="Y" /> <label for="insttRsltAt1" class="radio_label">기관</label></span>
						<span style="float: left;"><input type="radio" id="insttRsltAt2" name="insttRsltAt" class="radio" value="N" /> <label for="insttRsltAt2" class="radio_label">타기관</label></span>
					</td>
					<th>KRI 검증여부</th>
					<td>
						<span style="float: left;"><input type="radio" id="vrfcDvsCd0" name="vrfcDvsCd" class="radio" value="" checked="checked" /> <label for="vrfcDvsCd0" class="radio_label">전체</label></span>
						<span style="float: left;"><input type="radio" id="vrfcDvsCd1" name="vrfcDvsCd" class="radio" value="2" /> <label for="vrfcDvsCd1" class="radio_label">검증완료</label></span>
						<span style="float: left;"><input type="radio" id="vrfcDvsCd2" name="vrfcDvsCd" class="radio" value="1" /> <label for="vrfcDvsCd2" class="radio_label">미검증</label></span>
						<span style="float: left;"><input type="radio" id="vrfcDvsCd3" name="vrfcDvsCd" class="radio" value="3" /> <label for="vrfcDvsCd3" class="radio_label">불가</label></span>
					</td>
				</tr>
				<tr>
					<th>OA 구분</th>
					<td>
						<span style="float: left;"><input type="radio" id="openAccesAt0" name="openAccesAt" class="radio" value="" checked="checked" /> <label for="openAccesAt0" class="radio_label">전체</label></span>
						<span style="float: left;"><input type="radio" id="openAccesAt1" name="openAccesAt" class="radio" value="Y" /> <label for="openAccesAt1" class="radio_label">OA 논문</label></span>
					</td>
					<th>신분</th>
					<td>
						<span style="float: left;"><input type="radio" id="gubun0" name="gubun" onchange="setGrade1();" class="radio" value="" /> <label for="gubun0" class="radio_label">전체</label></span>
						<span style="float: left;"><input type="radio" id="gubun1" name="gubun" onchange="setGrade1();" class="radio" value="M" checked="checked" /> <label for="gubun1" class="radio_label">전임</label></span>
						<span style="float: left;"><input type="radio" id="gubun2" name="gubun" onchange="setGrade1();" class="radio" value="U" /> <label for="gubun2" class="radio_label">비전임</label></span>
						<span style="float: left;"><input type="radio" id="gubun3" name="gubun" onchange="setGrade1();" class="radio" value="S" /> <label for="gubun3" class="radio_label">학생</label></span>
						<span style="float: left;"><input type="radio" id="gubun4" name="gubun" onchange="setGrade1();" class="radio" value="E" /> <label for="gubun4" class="radio_label">기타</label></span>
					</td>
					<th class="researcherGubun">상세 신분</th>
					<td class="researcherGubun">
						<span style="float: left;"><input type="radio" id="grade10" name="grade1" class="radio" value="" checked="checked" /> <label for="grade10" class="radio_label">전체</label></span>
						<span style="float: left;"><input type="radio" id="grade11" name="grade1" class="radio" value="교수" /> <label for="grade11" class="radio_label">교수</label></span>
						<span style="float: left;"><input type="radio" id="grade12" name="grade1" class="radio" value="부교수" /> <label for="grade12" class="radio_label">부교수</label></span>
						<span style="float: left;"><input type="radio" id="grade13" name="grade1" class="radio" value="조교수" /> <label for="grade13" class="radio_label">조교수</label></span>
					</td>
				</tr>
				<tr class="researcherGubun">
					<th>참여구분</th>
					<td colspan="3">
						<span style="float: left;"><input type="radio" id="tpiDvsCd0" name="tpiDvsCd" class="radio" value="" checked="checked" /> <label for="tpiDvsCd0" class="radio_label">전체</label></span>
						<span style="float: left;"><input type="radio" id="tpiDvsCd1" name="tpiDvsCd" class="radio" value="1" /> <label for="tpiDvsCd1" class="radio_label">단독</label></span>
						<span style="float: left;"><input type="radio" id="tpiDvsCd3" name="tpiDvsCd" class="radio" value="2" /> <label for="tpiDvsCd3" class="radio_label">제1저자</label></span>
						<span style="float: left;"><input type="radio" id="tpiDvsCd5" name="tpiDvsCd" class="radio" value="5" /> <label for="tpiDvsCd5" class="radio_label">제1 및 교신저자</label></span>
						<span style="float: left;"><input type="radio" id="tpiDvsCd2" name="tpiDvsCd" class="radio" value="3" /> <label for="tpiDvsCd2" class="radio_label">교신저자</label></span>
						<span style="float: left;"><input type="radio" id="tpiDvsCd4" name="tpiDvsCd" class="radio" value="4" /> <label for="tpiDvsCd4" class="radio_label">참여자</label></span>
					</td>
					<th>재직전,후</th>
					<td>
						<span style="float: left;"><input type="radio" id="enterGubun0" name="enterGubun" class="radio" value="" checked="checked" /> <label for="enterGubun0" class="radio_label">전체</label></span>
						<span style="float: left;"><input type="radio" id="enterGubun1" name="enterGubun" class="radio" value="B" /> <label for="enterGubun1" class="radio_label">재직전</label></span>
						<span style="float: left;"><input type="radio" id="enterGubun2" name="enterGubun" class="radio" value="A" /> <label for="enterGubun2" class="radio_label">재직후</label></span>
					</td>
				</tr>
				<tr class="researcherGubun">
					<th>사번</th>
					<td>
						<input type="text" name="userId" class="input2" />
					</td>
					<th>성명</th>
					<td colspan="3">
						<span style="float: left;"><input type="text" name="userNm" class="input2" /></span>
						<span style="float: left;padding: 3px 0 0 5px;font-size: 11px;">동명이인 연구자도 검색될 수 있으니 유의하시기 바랍니다.</span>
					</td>
				</tr>
				<c:if test="${sessionScope.auth.adminDvsCd eq 'M' }">
					<tr class="researcherGubun">
						<th>재직여부</th>
						<td>
							<span style="float: left;"><input type="radio" id="hldofYn0" name="hldofYn" class="radio" value="" checked="checked" /> <label for="hldofYn0" class="radio_label">전체</label></span>
							<span style="float: left;"><input type="radio" id="hldofYn1" name="hldofYn" class="radio" value="1" /> <label for="hldofYn1" class="radio_label">재직</label></span>
							<span style="float: left;"><input type="radio" id="hldofYn2" name="hldofYn" class="radio" value="2" /> <label for="hldofYn2" class="radio_label">퇴직</label></span>
						</td>
						<th>내,외국인</th>
						<td>
							<span style="float: left;"><input type="radio" id="ntntGubun0" name="ntntGubun" class="radio" value="" checked="checked" /> <label for="ntntGubun0" class="radio_label">전체</label></span>
							<span style="float: left;"><input type="radio" id="ntntGubun1" name="ntntGubun" class="radio" value="국내" /> <label for="ntntGubun1" class="radio_label">내국인</label></span>
							<span style="float: left;"><input type="radio" id="ntntGubun2" name="ntntGubun" class="radio" value="국외" /> <label for="ntntGubun2" class="radio_label">외국인</label></span>
						</td>
						<th>성별</th>
						<td>
							<input type="radio" id="sexDvsCd0" name="sexDvsCd" class="radio" value="" checked="checked" />
							<label for="sexDvsCd0" class="radio_label">전체</label>
							<input type="radio" id="sexDvsCd1" name="sexDvsCd" class="radio" value="1" />
							<label for="sexDvsCd1" class="radio_label">남</label>
							<input type="radio" id="sexDvsCd2" name="sexDvsCd" class="radio" value="2" />
							<label for="sexDvsCd2" class="radio_label">여</label>
						</td>
					</tr>
					<tr class="researcherGubun">
						<th>
							<c:if test="${sessionScope.auth.adminDvsCd eq 'M'}">학과 및 트랙</c:if>
							<c:if test="${sessionScope.auth.adminDvsCd eq 'D' or sessionScope.login_user.adminDvsCd eq 'C'}">학과</c:if>
							<c:if test="${sessionScope.login_user.adminDvsCd eq 'T'}">트랙</c:if>
						</th>
						<td>
							<c:if test="${sessionScope.auth.adminDvsCd ne 'M'}">
								<c:if test="${sessionScope.auth.adminDvsCd eq 'D'}">${sessionScope.auth.workTrgetNm}</c:if>
								<c:if test="${sessionScope.auth.adminDvsCd eq 'T'}">${sessionScope.auth.workTrgetNm}</c:if>
								<c:if test="${sessionScope.auth.adminDvsCd eq 'C'}">
									<select name="dept" class="select1">
										<option value="">전체</option>
										<c:forEach var="item" items="${deptList}">
											<option value="DEPT_${item.groupDept}">${item.groupDept}</option>
										</c:forEach>
									</select>
								</c:if>
							</c:if>
							<c:if test="${sessionScope.auth.adminDvsCd eq 'M'}">
								<select name="dept" class="select1">
									<option value="">전체</option>
									<optgroup label="학과(부)">
										<c:forEach var="item" items="${deptList}">
											<option value="DEPT_${item.groupDept}">${item.groupDept}</option>
										</c:forEach>
									</optgroup>
									<optgroup label="트랙">
										<c:forEach var="item" items="${trackList}">
											<option value="TRACK_${item.trackId}">${item.trackName}</option>
										</c:forEach>
									</optgroup>
								</select>
							</c:if>
						</td>
						<th>대상자구분</th>
						<td colspan="3">
							<select name="historyId" class="select1">
								<option value=""></option>
								<c:forEach var="item" items="${exportHistory}">
									<option value="${item.historyId}">${item.groupName}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
				</c:if>
				</tbody>
			</table>
		</c:if>
		<c:if test="${sessMode or (sessionScope.auth.adminDvsCd eq 'R' or  sessionScope.auth.adminDvsCd eq 'S' )}">
			<table class="view_tbl mgb_10" style="table-layout: fixed;" >
				<colgroup>
					<col style="width: 12%;" />
					<col style="width: 28%;" />
					<col style="width: 12%;" />
					<col />
					<col style="width: 50px;"/>
				</colgroup>
				<tbody>
				<tr>
					<th><spring:message code='stats.article.target'/></th>
					<td>
						<input type="hidden" name="statsGubun" value="P" />
						<input type="radio" id="scjnlGubun1" name="scjnlGubun" class="radio" value="S" checked="checked" />
						<label for="scjnlGubun1" class="radio_label"><spring:message code='stats.article.target.sci'/></label>
						<input type="radio" id="scjnlGubun2" name="scjnlGubun" class="radio" value="SCOPUS"/>
						<label for="scjnlGubun2" class="radio_label"><spring:message code='stats.article.target.scopus'/></label>
						<input type="radio" id="scjnlGubun0" name="scjnlGubun" class="radio" value="" />
						<label for="scjnlGubun0" class="radio_label"><spring:message code='stats.article.target.total'/></label>
					</td>
					<th><spring:message code='stats.article.pubyear'/></th>
					<td>
						<span style="float: left;"><input type="text" id="stt_date" name="sttDate" class="input2" maxlength="4" value="" style="width: 60px;" />
						~ <input type="text" id="end_date" name="endDate" class="input2" maxlength="4" style="width: 60px;" /></span>
					</td>
					<td rowspan="2" class="option_search_td" onclick="javascript:myGrid_load();"><em>search</em></td>
				</tr>
				<tr>
					<th><spring:message code='stats.article.type'/></th>
					<td colspan="3">
						<span style="float: left;"><input type="radio" id="jnlGubun0" name="jnlGubun" class="radio" value="byYear" checked="checked" /> <label for="jnlGubun0" class="radio_label"><spring:message code='stats.type.byyear'/></label></span>
						<span style="float: left;"><input type="radio" id="jnlGubun1" name="jnlGubun" class="radio" value="byYearEnter" /> <label for="jnlGubun1" class="radio_label"><spring:message code='stats.type.byyearenter'/></label></span>
					</td>
				</tr>
				</tbody>
			</table>
		</c:if>
	</form>
	<div class="list_bt_area">
		<div class="list_set">
			<ul>
				<li style="text-align: right;padding-top: 7px;">
					<spring:message code='stats.common.message1'/>
				</li>
				<li><a href="#" onclick="javascript:exportSelectBox();param='';" class="list_icon20"><spring:message code='common.download.data'/></a></li>
				<li><a href="#" onclick="myGrid.toExcel('<c:url value="/servlet/xlsGenerate.do?file_name=article_stats.xls"/>');" class="list_icon20"><spring:message code='common.download.table'/></a></li>
			</ul>
		</div>
	</div>
	<!-- layout (grid,paging)  -->
	<div id="mainLayout" style="position: relative; width: 100%;height: 100%;"></div>
</div>
<form name="expFrm" id="expFrm" method="post"></form>
<div id="output"></div>

<a href="#selectDialog" id="selectDialogBtn" class="modalLink" style="display: none;">반출 항목 Modal</a>
<%--<div id="selectDialog" class="popup_box modal modal_layer export_popup" style="<c:if test="${sessMode or (sessionScope.auth.adminDvsCd eq 'R' or  sessionScope.auth.adminDvsCd eq 'S' )}">height: 150px;width: 500px;</c:if><c:if test="${not sessMode and sessionScope.auth.adminDvsCd ne 'R' and  sessionScope.auth.adminDvsCd ne 'S' }">width: 1160px;height:551px;</c:if>display: none;">--%>
<div id="selectDialog" class="popup_box modal modal_layer export_popup" style="width: 1160px;height:551px;display: none;">
	<div class="popup_header" style="height: 50px;background:#ffffff;">
		<h3></h3>
		<a href="#" id="closeBtn" class="close_bt closeBtn">닫기</a>
	</div>
	<%--<div class="popup_inner" id="selectDialogIn" style="<c:if test="${not sessMode and sessionScope.auth.adminDvsCd ne 'R' and  sessionScope.auth.adminDvsCd ne 'S' }">height: 482px;</c:if>overflow: auto;padding-left: 0px;padding-right: 0px;">--%>
	<div class="popup_inner" id="selectDialogIn" style="height: 482px;overflow: auto;padding-left: 0px;padding-right: 0px;">
		<div class="ep_option_box"><!-- 0831 클래스 추가 -->
			<%--<c:if test="${not sessMode and sessionScope.auth.adminDvsCd ne 'R' and  sessionScope.auth.adminDvsCd ne 'S' }">--%>
				<div class="list_set" style="margin-bottom: 10px;">
					<ul>
						<li><a href="javascript:downloadListXlsx();$('#selectDialog #closeBtn').triggerHandler('click');" class="list_icon05"><spring:message code='stats.export.export'/></a></li>
						<li><a href="javascript:$('#selectDialog #closeBtn').triggerHandler('click');" class="list_icon10"><spring:message code='stats.export.cancel'/></a></li>
					</ul>
				</div>
			<%--</c:if>--%>
			<div class="ep_select_wrap"><!-- 0831 클래스 추가 -->
				<span><spring:message code='stats.export.format'/> : </span>
				<select id="templateSelect" class="sel_type" onchange="findTemplate();">
					<c:forEach items="${templateList}" var="temp">
						<option value="${temp.sn}">${temp.title}<c:if test="${not empty temp.titleEng}">(${temp.titleEng})</c:if></option>
					</c:forEach>
					<%--<c:if test="${not sessMode and sessionScope.auth.adminDvsCd ne 'R' and  sessionScope.auth.adminDvsCd ne 'S' }">--%>
						<option value="custom">사용자선택</option>
					<%--</c:if>--%>
				</select>
				<%--<c:if test="${not sessMode and sessionScope.auth.adminDvsCd ne 'R' and  sessionScope.auth.adminDvsCd ne 'S' }">--%>
					<p>※ '저자 상세정보','논문 지수정보'는 반출 속도에 영향을 미칩니다.</p>
				<%--</c:if>--%>
			</div>
		</div>
		<form id="forPForm">
			<%--<table width="100%" class="list_tbl mgb_20" style="<c:if test="${sessMode or (sessionScope.auth.adminDvsCd eq 'R' or  sessionScope.auth.adminDvsCd eq 'S' )}">display:none;</c:if>">--%>
			<table width="100%" class="list_tbl mgb_20">
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
					<c:if test="${not empty rims:codeValue('stats.exp.item.art','rsrchInfF')}"><th style="padding-top: 0px;padding-bottom: 0px;"><label for="forPTb0" class="chk_label"><input type="checkbox" value="1" onclick="clickCheckbox(this);" name="forRTb0" id="forPTb0"> <c:out value="${rims:codeValue('stats.exp.item.art','rsrchInfF')}"/></label></th></c:if>
					<c:if test="${not empty rims:codeValue('stats.exp.item.art','artMajorF')}"><th style="padding-top: 0px;padding-bottom: 0px;"><label for="forPTb1" class="chk_label"><input type="checkbox" value="1" onclick="clickCheckbox(this);" name="forRTb1" id="forPTb1"> <c:out value="${rims:codeValue('stats.exp.item.art','artMajorF')}"/></label></th></c:if>
					<c:if test="${not empty rims:codeValue('stats.exp.item.art','artAddF')}"><th style="padding-top: 0px;padding-bottom: 0px;"><label for="forPTb2" class="chk_label"><input type="checkbox" value="1" onclick="clickCheckbox(this);" name="forRTb2" id="forPTb2"> <c:out value="${rims:codeValue('stats.exp.item.art','artAddF')}"/></label></th></c:if>
					<c:if test="${not empty rims:codeValue('stats.exp.item.art','athrDetailF')}"><th style="padding-top: 0px;padding-bottom: 0px;"><label for="forPTb3" class="chk_label"><input type="checkbox" value="1" onclick="clickCheckbox(this);" name="forRTb3" id="forPTb3"> <c:out value="${rims:codeValue('stats.exp.item.art','athrDetailF')}"/></label></th></c:if>
					<c:if test="${not empty rims:codeValue('stats.exp.item.art','artLatestIndexF')}"><th style="width:170px;padding-top: 0px;padding-bottom: 0px;"><label for="forPTb4" class="chk_label"><input type="checkbox" value="1" onclick="clickCheckbox(this);" name="forRTb4" id="forPTb4"> <c:out value="${rims:codeValue('stats.exp.item.art','artLatestIndexF')}"/></label></th></c:if>
					<c:if test="${not empty rims:codeValue('stats.exp.item.art','artPubIndexF')}"><th style="width:170px;padding-top: 0px;padding-bottom: 0px;"><label for="forPTb5" class="chk_label"><input type="checkbox" value="1" onclick="clickCheckbox(this);" name="forRTb5" id="forPTb5"> <c:out value="${rims:codeValue('stats.exp.item.art','artPubIndexF')}"/></label></th></c:if>
				</tr>
				</thead>
				<tbody>
				<tr>
					<td style="text-align: left;padding-left: 10px; vertical-align:top">
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','prtcpntIdF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forPTb0_1" name="prtcpntIdF"><label for="forPTb0_1"> <c:out value="${rims:codeValue('stats.exp.item.art','prtcpntIdF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','korNmF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forPTb0_2" name="korNmF"><label for="forPTb0_2"> <c:out value="${rims:codeValue('stats.exp.item.art','korNmF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','tpiDvsCdF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forPTb0_3" name="tpiDvsCdF"><label for="forPTb0_3"> <c:out value="${rims:codeValue('stats.exp.item.art','tpiDvsCdF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','gubunF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forPTb0_4" name="gubunF"><label for="forPTb0_4"> <c:out value="${rims:codeValue('stats.exp.item.art','gubunF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','grade1F')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forPTb0_5" name="grade1F"><label for="forPTb0_5"> <c:out value="${rims:codeValue('stats.exp.item.art','grade1F')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','deptKorF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forPTb0_6" name="deptKorF"><label for="forPTb0_6"> <c:out value="${rims:codeValue('stats.exp.item.art','deptKorF')}"/></label></div></c:if>
					</td>
					<td style="text-align: left;padding-left: 10px; vertical-align:top">
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','articleIdF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forPTb1_1" name="articleIdF"><label for="forPTb1_1"> <c:out value="${rims:codeValue('stats.exp.item.art','articleIdF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','scjnlNmF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forPTb1_2" name="scjnlNmF"><label for="forPTb1_2"> <c:out value="${rims:codeValue('stats.exp.item.art','scjnlNmF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','orgLangPprNmF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forPTb1_3" name="orgLangPprNmF"><label for="forPTb1_3"> <c:out value="${rims:codeValue('stats.exp.item.art','orgLangPprNmF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','pblcYearF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forPTb1_4" name="pblcYearF"><label for="forPTb1_4"> <c:out value="${rims:codeValue('stats.exp.item.art','pblcYearF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','pblcMonthF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forPTb1_5" name="pblcMonthF"><label for="forPTb1_5"> <c:out value="${rims:codeValue('stats.exp.item.art','pblcMonthF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','volumeF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forPTb1_6" name="volumeF"><label for="forPTb1_6"> <c:out value="${rims:codeValue('stats.exp.item.art','volumeF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','issueF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forPTb1_7" name="issueF"><label for="forPTb1_7"> <c:out value="${rims:codeValue('stats.exp.item.art','issueF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','sttPageF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forPTb1_8" name="sttPageF"><label for="forPTb1_8"> <c:out value="${rims:codeValue('stats.exp.item.art','sttPageF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','endPageF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forPTb1_9" name="endPageF"><label for="forPTb1_9"> <c:out value="${rims:codeValue('stats.exp.item.art','endPageF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','doiF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forPTb1_10" name="doiF"><label for="forPTb1_10"> <c:out value="${rims:codeValue('stats.exp.item.art','doiF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','doiUrlF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forPTb1_11" name="doiUrlF"><label for="forPTb1_11"> <c:out value="${rims:codeValue('stats.exp.item.art','doiUrlF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','issnNoF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forPTb1_12" name="issnNoF"><label for="forPTb1_12"> <c:out value="${rims:codeValue('stats.exp.item.art','issnNoF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','impctFctrF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forPTb1_13" name="impctFctrF"><label for="forPTb1_13"> <c:out value="${rims:codeValue('stats.exp.item.art','impctFctrF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','corprRsrchDvsCdF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forPTb1_14" name="corprRsrchDvsCdF"><label for="forPTb1_14"> <c:out value="${rims:codeValue('stats.exp.item.art','corprRsrchDvsCdF')}"/></label></div></c:if>
					</td>
					<td style="text-align: left;padding-left: 10px; vertical-align:top">
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','scjnlDvsCdF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forPTb2_1" name="scjnlDvsCdF"><label for="forPTb2_1"> <c:out value="${rims:codeValue('stats.exp.item.art','scjnlDvsCdF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','ovrsExclncScjnlPblcYnF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forPTb2_2" name="ovrsExclncScjnlPblcYnF"><label for="forPTb2_2"> <c:out value="${rims:codeValue('stats.exp.item.art','ovrsExclncScjnlPblcYnF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','wosDocTypeF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forPTb2_3" name="wosDocTypeF"><label for="forPTb2_3"> <c:out value="${rims:codeValue('stats.exp.item.art','wosDocTypeF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','scopusDocTypeF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forPTb2_4" name="scopusDocTypeF"><label for="forPTb2_4"> <c:out value="${rims:codeValue('stats.exp.item.art','scopusDocTypeF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','tcF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forPTb2_5" name="tcF"><label for="forPTb2_5"> <c:out value="${rims:codeValue('stats.exp.item.art','tcF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','scpTcF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forPTb2_6" name="scpTcF"><label for="forPTb2_6"> <c:out value="${rims:codeValue('stats.exp.item.art','scpTcF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','idSciF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forPTb2_7" name="idSciF"><label for="forPTb2_7"> <c:out value="${rims:codeValue('stats.exp.item.art','idSciF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','idScopusF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forPTb2_8" name="idScopusF"><label for="forPTb2_8"> <c:out value="${rims:codeValue('stats.exp.item.art','idScopusF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','idKciF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forPTb2_9" name="idKciF"><label for="forPTb2_9"> <c:out value="${rims:codeValue('stats.exp.item.art','idKciF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','openAccesAtF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forPTb2_10" name="openAccesAtF"><label for="forPTb2_10"> <c:out value="${rims:codeValue('stats.exp.item.art','openAccesAtF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','pblcNtnCdF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forPTb2_11" name="pblcNtnCdF"><label for="forPTb2_11"> <c:out value="${rims:codeValue('stats.exp.item.art','pblcNtnCdF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','isReprsntArticleF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forPTb2_12" name="isReprsntArticleF"><label for="forPTb2_12"> <c:out value="${rims:codeValue('stats.exp.item.art','isReprsntArticleF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','insttRsltAtF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forPTb2_13" name="insttRsltAtF"><label for="forPTb2_13"> <c:out value="${rims:codeValue('stats.exp.item.art','insttRsltAtF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','vrfcDvsCdF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forPTb2_14" name="vrfcDvsCdF"><label for="forPTb2_14"> <c:out value="${rims:codeValue('stats.exp.item.art','vrfcDvsCdF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','abstCntnF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forPTb2_15" name="abstCntnF"><label for="forPTb2_15"> <c:out value="${rims:codeValue('stats.exp.item.art','abstCntnF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','fileAtF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forPTb2_16" name="fileAtF"><label for="forPTb2_16"> <c:out value="${rims:codeValue('stats.exp.item.art','fileAtF')}"/></label></div></c:if>
					</td>
					<td style="text-align: left;padding-left: 10px; vertical-align:top">
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','firstAuthorF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forPTb3_1" name="firstAuthorF"><label for="forPTb3_1"> <c:out value="${rims:codeValue('stats.exp.item.art','firstAuthorF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','corAuthorF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forPTb3_7" name="corAuthorF"><label for="forPTb3_7"> <c:out value="${rims:codeValue('stats.exp.item.art','corAuthorF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','authorsF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forPTb3_2" name="authorsF"><label for="forPTb3_2"> <c:out value="${rims:codeValue('stats.exp.item.art','authorsF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','totalAthrCntF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forPTb3_3" name="totalAthrCntF"><label for="forPTb3_3"> <c:out value="${rims:codeValue('stats.exp.item.art','totalAthrCntF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','athrCntF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forPTb3_4" name="athrCntF"><label for="forPTb3_4"> <c:out value="${rims:codeValue('stats.exp.item.art','athrCntF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','totalAthrDetailCntF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forPTb3_5" name="totalAthrDetailCntF"><label for="forPTb3_5"> <c:out value="${rims:codeValue('stats.exp.item.art','totalAthrDetailCntF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','mainProfessorsF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forPTb3_6" name="mainProfessorsF"><label for="forPTb3_6"> <c:out value="${rims:codeValue('stats.exp.item.art','mainProfessorsF')}"/></label></div></c:if>
					</td>
					<td style="text-align: left;padding-left: 10px; vertical-align:top">
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifLastTopMenuF')}">
							<ul class="ep_toggle_box">
								<li style="padding-bottom:5px;">
									<a href="javascript:void(0);" class="sideToggle"><span><img src="<c:url value="/images/background/ep_plus.png"/>"> </span></a><input type="checkbox" value="1" name="forRTb4_L1" id="forPTb4_L1" onclick="clickCheckbox(this);"><label for="forPTb4_L1"> <c:out value="${rims:codeValue('stats.exp.item.art','ifLastTopMenuF')}"/></label>
									<ul style="padding-left: 35px; display: none;">
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifLastJcrF')}"><li><input type="checkbox" value="1" id="forPTb4_L11Sub" name="ifLastJcrF"><label for="forPTb4_L11Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifLastJcrF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifLastF')}"><li><input type="checkbox" value="1" id="forPTb4_L12Sub" name="ifLastF"><label for="forPTb4_L12Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifLastF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifLastCaCoF')}"><li><input type="checkbox" value="1" id="forPTb4_L13Sub" name="ifLastCaCoF"><label for="forPTb4_L13Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifLastCaCoF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifLastCaNmF')}"><li><input type="checkbox" value="1" id="forPTb4_L14Sub" name="ifLastCaNmF"><label for="forPTb4_L14Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifLastCaNmF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifLastCaRankF')}"><li><input type="checkbox" value="1" id="forPTb4_L15Sub" name="ifLastCaRankF"><label for="forPTb4_L15Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifLastCaRankF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifLastCaRatioF')}"><li><input type="checkbox" value="1" id="forPTb4_L16Sub" name="ifLastCaRatioF"><label for="forPTb4_L16Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifLastCaRatioF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifLastRatingF')}"><li><input type="checkbox" value="1" id="forPTb4_L17Sub" name="ifLastRatingF"><label for="forPTb4_L17Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifLastRatingF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifLastAvg20F')}"><li><input type="checkbox" value="1" id="forPTb4_L18Sub" name="ifLastAvg20F"><label for="forPTb4_L18Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifLastAvg20F')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifLastRevF')}"><li><input type="checkbox" value="1" id="forPTb4_L19Sub" name="ifLastRevF"><label for="forPTb4_L19Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifLastRevF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifLastOrnF')}"><li><input type="checkbox" value="1" id="forPTb4_L111Sub" name="ifLastOrnF"><label for="forPTb4_L111Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifLastOrnF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifLastIndexAvgIfPercentileF')}"><li><input type="checkbox" value="1" id="forPTb4_L116Sub" name="ifLastIndexAvgIfPercentileF"><label for="forPTb4_L116Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifLastIndexAvgIfPercentileF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifLastIndexAvgIfPercentileKorF')}"><li><input type="checkbox" value="1" id="forPTb4_L117Sub" name="ifLastIndexAvgIfPercentileKorF"><label for="forPTb4_L117Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifLastIndexAvgIfPercentileKorF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifLastIndexMrnifF')}"><li><input type="checkbox" value="1" id="forPTb4_L118Sub" name="ifLastIndexMrnifF"><label for="forPTb4_L118Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifLastIndexMrnifF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifLast5YF')}"><li><input type="checkbox" value="1" id="forPTb4_L112Sub" name="ifLast5YF"><label for="forPTb4_L112Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifLast5YF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifLast5YRatioF')}"><li><input type="checkbox" value="1" id="forPTb4_L113Sub" name="ifLast5YRatioF"><label for="forPTb4_L113Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifLast5YRatioF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifLast5YRatingF')}"><li><input type="checkbox" value="1" id="forPTb4_L114Sub" name="ifLast5YRatingF"><label for="forPTb4_L114Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifLast5YRatingF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifLast5YRankF')}"><li><input type="checkbox" value="1" id="forPTb4_L115Sub" name="ifLast5YRankF"><label for="forPTb4_L115Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifLast5YRankF')}"/></label></li></c:if>
									</ul>
								</li>
							</ul>
						</c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','esLastTopMenuF')}">
							<ul class="ep_toggle_box">
								<li style="padding-bottom:5px;">
									<a href="javascript:void(0);" class="sideToggle"><span><img src="<c:url value="/images/background/ep_plus.png"/>"> </span></a><input type="checkbox" value="1" id="forPTb4_L2" name="forRTb4_L2" onclick="clickCheckbox(this);"><label for="forPTb4_L2"> <c:out value="${rims:codeValue('stats.exp.item.art','esLastTopMenuF')}"/></label>
									<ul style="padding-left: 35px; display: none;">
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','esLastVerF')}"><li><input type="checkbox" value="1" id="forPTb4_L21Sub" name="esLastVerF"><label for="forPTb4_L21Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','esLastVerF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','esLastF')}"><li><input type="checkbox" value="1" id="forPTb4_L22Sub" name="esLastF"><label for="forPTb4_L22Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','esLastF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','esLastCaRankF')}"><li><input type="checkbox" value="1" id="forPTb4_L23Sub" name="esLastCaRankF"><label for="forPTb4_L23Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','esLastCaRankF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','esLastRatioF')}"><li><input type="checkbox" value="1" id="forPTb4_L24Sub" name="esLastRatioF"><label for="forPTb4_L24Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','esLastRatioF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','esLastAvg20F')}"><li><input type="checkbox" value="1" id="forPTb4_L25Sub" name="esLastAvg20F"><label for="forPTb4_L25Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','esLastAvg20F')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','esLastRevF')}"><li><input type="checkbox" value="1" id="forPTb4_L26Sub" name="esLastRevF"><label for="forPTb4_L26Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','esLastRevF')}"/></label></li></c:if>
									</ul>
								</li>
							</ul>
						</c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','sjrLastTopMenuF')}">
							<ul class="ep_toggle_box">
								<li style="padding-bottom:5px;">
									<a href="javascript:void(0);" class="sideToggle"><span><img src="<c:url value="/images/background/ep_plus.png"/>"> </span></a><input type="checkbox" value="1" id="forPTb4_L3" name="forRTb4_L3" onclick="clickCheckbox(this);"><label for="forPTb4_L3"> <c:out value="${rims:codeValue('stats.exp.item.art','sjrLastTopMenuF')}"/></label>
									<ul style="padding-left: 35px; display: none;">
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','sjrLastYearF')}"><li><input type="checkbox" value="1" id="forPTb4_L31Sub" name="sjrLastYearF"><label for="forPTb4_L31Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','sjrLastYearF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','sjrLastF')}"><li><input type="checkbox" value="1" id="forPTb4_L32Sub" name="sjrLastF"><label for="forPTb4_L32Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','sjrLastF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','sjrLastCaCoF')}"><li><input type="checkbox" value="1" id="forPTb4_L33Sub" name="sjrLastCaCoF"><label for="forPTb4_L33Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','sjrLastCaCoF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','sjrLastCaF')}"><li><input type="checkbox" value="1" id="forPTb4_L34Sub" name="sjrLastCaF"><label for="forPTb4_L34Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','sjrLastCaF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','sjrLastRankF')}"><li><input type="checkbox" value="1" id="forPTb4_L35Sub" name="sjrLastRankF"><label for="forPTb4_L35Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','sjrLastRankF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','sjrLastRatioF')}"><li><input type="checkbox" value="1" id="forPTb4_L36Sub" name="sjrLastRatioF"><label for="forPTb4_L36Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','sjrLastRatioF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','sjrLastRatingF')}"><li><input type="checkbox" value="1" id="forPTb4_L37Sub" name="sjrLastRatingF"><label for="forPTb4_L37Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','sjrLastRatingF')}"/></label></li></c:if>
									</ul>
								</li>
							</ul>
						</c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','citeScoreLastTopMenuF')}">
							<ul class="ep_toggle_box">
								<li style="padding-bottom:5px;">
									<a href="javascript:void(0);" class="sideToggle"><span><img src="<c:url value="/images/background/ep_plus.png"/>"> </span></a><input type="checkbox" value="1" id="forPTb4_L4" name="forRTb4_L4" onclick="clickCheckbox(this);"><label for="forPTb4_L4"> <c:out value="${rims:codeValue('stats.exp.item.art','citeScoreLastTopMenuF')}"/></label>
									<ul style="padding-left: 35px; display: none;">
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','citeScoreLastYearF')}"><li><input type="checkbox" value="1" id="forPTb4_L41Sub" name="citeScoreLastYearF"><label for="forPTb4_L41Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','citeScoreLastYearF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','citeScoreLastF')}"><li><input type="checkbox" value="1" id="forPTb4_L42Sub" name="citeScoreLastF"><label for="forPTb4_L42Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','citeScoreLastF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','citeScoreLastCaCoF')}"><li><input type="checkbox" value="1" id="forPTb4_L43Sub" name="citeScoreLastCaCoF"><label for="forPTb4_L43Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','citeScoreLastCaCoF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','citeScoreLastCaF')}"><li><input type="checkbox" value="1" id="forPTb4_L44Sub" name="citeScoreLastCaF"><label for="forPTb4_L44Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','citeScoreLastCaF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','citeScoreLastRankF')}"><li><input type="checkbox" value="1" id="forPTb4_L45Sub" name="citeScoreLastRankF"><label for="forPTb4_L45Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','citeScoreLastRankF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','citeScoreLastRatioF')}"><li><input type="checkbox" value="1" id="forPTb4_L46Sub" name="citeScoreLastRatioF"><label for="forPTb4_L46Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','citeScoreLastRatioF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','citeScoreLastRatingF')}"><li><input type="checkbox" value="1" id="forPTb4_L47Sub" name="citeScoreLastRatingF"><label for="forPTb4_L47Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','citeScoreLastRatingF')}"/></label></li></c:if>
									</ul>
								</li>
							</ul>
						</c:if>
					</td>
					<td style="text-align: left;padding-left: 10px; vertical-align:top">
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifPubTopMenuF')}">
							<ul class="ep_toggle_box">
								<li style="padding-bottom:5px;">
									<a href="javascript:void(0);" class="sideToggle"><span><img src="<c:url value="/images/background/ep_plus.png"/>"> </span></a><input type="checkbox" value="1" name="forRTb5_L1" id="forPTb5_L1" onclick="clickCheckbox(this);"><label for="forPTb5_L1"> <c:out value="${rims:codeValue('stats.exp.item.art','ifPubTopMenuF')}"/></label>
									<ul style="padding-left: 35px; display: none;">
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifPubJcrF')}"><li><input type="checkbox" value="1" id="forPTb5_L11Sub" name="ifPubJcrF"><label for="forPTb5_L11Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifPubJcrF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifPubF')}"><li><input type="checkbox" value="1" id="forPTb5_L12Sub" name="ifPubF"><label for="forPTb5_L12Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifPubF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifPubCaCoF')}"><li><input type="checkbox" value="1" id="forPTb5_L13Sub" name="ifPubCaCoF"><label for="forPTb5_L13Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifPubCaCoF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifPubCaNmF')}"><li><input type="checkbox" value="1" id="forPTb5_L14Sub" name="ifPubCaNmF"><label for="forPTb5_L14Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifPubCaNmF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifPubCaRankF')}"><li><input type="checkbox" value="1" id="forPTb5_L15Sub" name="ifPubCaRankF"><label for="forPTb5_L15Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifPubCaRankF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifPubCaRatioF')}"><li><input type="checkbox" value="1" id="forPTb5_L16Sub" name="ifPubCaRatioF"><label for="forPTb5_L16Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifPubCaRatioF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifPubRatingF')}"><li><input type="checkbox" value="1" id="forPTb5_L17Sub" name="ifPubRatingF"><label for="forPTb5_L17Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifPubRatingF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifPubAvg20F')}"><li><input type="checkbox" value="1" id="forPTb5_L18Sub" name="ifPubAvg20F"><label for="forPTb5_L18Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifPubAvg20F')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifPubRevF')}"><li><input type="checkbox" value="1" id="forPTb5_L19Sub" name="ifPubRevF"><label for="forPTb5_L19Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifPubRevF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifPubOrnF')}"><li><input type="checkbox" value="1" id="forPTb5_L111Sub" name="ifPubOrnF"><label for="forPTb5_L111Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifPubOrnF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifPubIndexAvgIfPercentileF')}"><li><input type="checkbox" value="1" id="forPTb5_L116Sub" name="ifPubIndexAvgIfPercentileF"><label for="forPTb5_L116Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifPubIndexAvgIfPercentileF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifPubIndexAvgIfPercentileKorF')}"><li><input type="checkbox" value="1" id="forPTb5_L117Sub" name="ifPubIndexAvgIfPercentileKorF"><label for="forPTb5_L117Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifPubIndexAvgIfPercentileKorF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifPubIndexMrnifF')}"><li><input type="checkbox" value="1" id="forPTb5_L118Sub" name="ifPubIndexMrnifF"><label for="forPTb5_L118Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifPubIndexMrnifF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifPub5YF')}"><li><input type="checkbox" value="1" id="forPTb5_L112Sub" name="ifPub5YF"><label for="forPTb5_L112Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifPub5YF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifPub5YRatioF')}"><li><input type="checkbox" value="1" id="forPTb5_L113Sub" name="ifPub5YRatioF"><label for="forPTb5_L113Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifPub5YRatioF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifPub5YRatingF')}"><li><input type="checkbox" value="1" id="forPTb5_L114Sub" name="ifPub5YRatingF"><label for="forPTb5_L114Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifPub5YRatingF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifPub5YRankF')}"><li><input type="checkbox" value="1" id="forPTb5_L115Sub" name="ifPub5YRankF"><label for="forPTb5_L115Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifPub5YRankF')}"/></label></li></c:if>
									</ul>
								</li>
							</ul>
						</c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','esPubTopMenuF')}">
							<ul class="ep_toggle_box">
								<li style="padding-bottom:5px;">
									<a href="javascript:void(0);" class="sideToggle"><span><img src="<c:url value="/images/background/ep_plus.png"/>"> </span></a><input type="checkbox" value="1" id="forPTb5_L2" name="forRTb5_L2" onclick="clickCheckbox(this);"><label for="forPTb5_L2"> <c:out value="${rims:codeValue('stats.exp.item.art','esPubTopMenuF')}"/></label>
									<ul style="padding-left: 35px; display: none;">
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','esPubVerF')}"><li><input type="checkbox" value="1" id="forPTb5_L21Sub" name="esPubVerF"><label for="forPTb5_L21Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','esPubVerF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','esPubF')}"><li><input type="checkbox" value="1" id="forPTb5_L22Sub" name="esPubF"><label for="forPTb5_L22Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','esPubF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','esPubCaRankF')}"><li><input type="checkbox" value="1" id="forPTb5_L23Sub" name="esPubCaRankF"><label for="forPTb5_L23Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','esPubCaRankF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','esPubRatioF')}"><li><input type="checkbox" value="1" id="forPTb5_L24Sub" name="esPubRatioF"><label for="forPTb5_L24Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','esPubRatioF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','esPubAvg20F')}"><li><input type="checkbox" value="1" id="forPTb5_L25Sub" name="esPubAvg20F"><label for="forPTb5_L25Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','esPubAvg20F')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','esPubRevF')}"><li><input type="checkbox" value="1" id="forPTb5_L26Sub" name="esPubRevF"><label for="forPTb5_L26Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','esPubRevF')}"/></label></li></c:if>
									</ul>
								</li>
							</ul>
						</c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','sjrPubTopMenuF')}">
							<ul class="ep_toggle_box">
								<li style="padding-bottom:5px;">
									<a href="javascript:void(0);" class="sideToggle"><span><img src="<c:url value="/images/background/ep_plus.png"/>"> </span></a><input type="checkbox" value="1" id="forPTb5_L3" name="forRTb5_L3" onclick="clickCheckbox(this);"><label for="forPTb5_L3"> <c:out value="${rims:codeValue('stats.exp.item.art','sjrPubTopMenuF')}"/></label>
									<ul style="padding-left: 35px; display: none;">
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','sjrPubYearF')}"><li><input type="checkbox" value="1" id="forPTb5_L31Sub" name="sjrPubYearF"><label for="forPTb5_L31Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','sjrPubYearF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','sjrPubF')}"><li><input type="checkbox" value="1" id="forPTb5_L32Sub" name="sjrPubF"><label for="forPTb5_L32Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','sjrPubF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','sjrPubCaCoF')}"><li><input type="checkbox" value="1" id="forPTb5_L33Sub" name="sjrPubCaCoF"><label for="forPTb5_L33Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','sjrPubCaCoF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','sjrPubCaF')}"><li><input type="checkbox" value="1" id="forPTb5_L34Sub" name="sjrPubCaF"><label for="forPTb5_L34Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','sjrPubCaF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','sjrPubRankF')}"><li><input type="checkbox" value="1" id="forPTb5_L35Sub" name="sjrPubRankF"><label for="forPTb5_L35Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','sjrPubRankF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','sjrPubRatioF')}"><li><input type="checkbox" value="1" id="forPTb5_L36Sub" name="sjrPubRatioF"><label for="forPTb5_L36Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','sjrPubRatioF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','sjrPubRatingF')}"><li><input type="checkbox" value="1" id="forPTb5_L37Sub" name="sjrPubRatingF"><label for="forPTb5_L37Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','sjrPubRatingF')}"/></label></li></c:if>
									</ul>
								</li>
							</ul>
						</c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','citeScorePubTopMenuF')}">
							<ul class="ep_toggle_box">
								<li style="padding-bottom:5px;">
									<a href="javascript:void(0);" class="sideToggle"><span><img src="<c:url value="/images/background/ep_plus.png"/>"> </span></a><input type="checkbox" value="1" id="forPTb5_L4" name="forRTb5_L4" onclick="clickCheckbox(this);"><label for="forPTb5_L4"> <c:out value="${rims:codeValue('stats.exp.item.art','citeScorePubTopMenuF')}"/></label>
									<ul style="padding-left: 35px; display: none;">
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','citeScorePubYearF')}"><li><input type="checkbox" value="1" id="forPTb5_L41Sub" name="citeScorePubYearF"><label for="forPTb5_L41Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','citeScorePubYearF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','citeScorePubF')}"><li><input type="checkbox" value="1" id="forPTb5_L42Sub" name="citeScorePubF"><label for="forPTb5_L42Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','citeScorePubF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','citeScorePubCaCoF')}"><li><input type="checkbox" value="1" id="forPTb5_L43Sub" name="citeScorePubCaCoF"><label for="forPTb5_L43Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','citeScorePubCaCoF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','citeScorePubCaF')}"><li><input type="checkbox" value="1" id="forPTb5_L44Sub" name="citeScorePubCaF"><label for="forPTb5_L44Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','citeScorePubCaF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','citeScorePubRankF')}"><li><input type="checkbox" value="1" id="forPTb5_L45Sub" name="citeScorePubRankF"><label for="forPTb5_L45Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','citeScorePubRankF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','citeScorePubRatioF')}"><li><input type="checkbox" value="1" id="forPTb5_L46Sub" name="citeScorePubRatioF"><label for="forPTb5_L46Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','citeScorePubRatioF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','citeScorePubRatingF')}"><li><input type="checkbox" value="1" id="forPTb5_L47Sub" name="citeScorePubRatingF"><label for="forPTb5_L47Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','citeScorePubRatingF')}"/></label></li></c:if>
									</ul>
								</li>
							</ul>
						</c:if>
					</td>
				</tr>
				</tbody>
			</table>
		</form>
		<form id="forAForm">
			<%--<table width="100%" class="list_tbl mgb_20" style="<c:if test="${sessMode or (sessionScope.auth.adminDvsCd eq 'R' or  sessionScope.auth.adminDvsCd eq 'S' )}">display:none;</c:if>">--%>
			<table width="100%" class="list_tbl mgb_20">
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
					<c:if test="${not empty rims:codeValue('stats.exp.item.art','artMajorF')}"><th style="padding-top: 0px;padding-bottom: 0px;"><label class="chk_label" for="forATb1"><input type="checkbox" value="1" onclick="clickCheckbox(this);" name="forRTb1" id="forATb1"> <c:out value="${rims:codeValue('stats.exp.item.art','artMajorF')}"/></label></th></c:if>
					<c:if test="${not empty rims:codeValue('stats.exp.item.art','artAddF')}"><th style="padding-top: 0px;padding-bottom: 0px;"><label class="chk_label" for="forATb2"><input type="checkbox" value="1" onclick="clickCheckbox(this);" name="forRTb2" id="forATb2"> <c:out value="${rims:codeValue('stats.exp.item.art','artAddF')}"/></label></th></c:if>
					<c:if test="${not empty rims:codeValue('stats.exp.item.art','athrDetailF')}"><th style="padding-top: 0px;padding-bottom: 0px;"><label class="chk_label" for="forATb3"><input type="checkbox" value="1" onclick="clickCheckbox(this);" name="forRTb3" id="forATb3"> <c:out value="${rims:codeValue('stats.exp.item.art','athrDetailF')}"/></label></th></c:if>
					<c:if test="${not empty rims:codeValue('stats.exp.item.art','artLatestIndexF')}"><th style="width:170px;padding-top: 0px;padding-bottom: 0px;"><label class="chk_label" for="forATb4"><input type="checkbox" value="1" onclick="clickCheckbox(this);" name="forRTb4" id="forATb4"> <c:out value="${rims:codeValue('stats.exp.item.art','artLatestIndexF')}"/></label></th></c:if>
					<c:if test="${not empty rims:codeValue('stats.exp.item.art','artPubIndexF')}"><th style="width:170px;padding-top: 0px;padding-bottom: 0px;"><label class="chk_label" for="forATb5"><input type="checkbox" value="1" onclick="clickCheckbox(this);" name="forRTb5" id="forATb5"> <c:out value="${rims:codeValue('stats.exp.item.art','artPubIndexF')}"/></label></th></c:if>
				</tr>
				</thead>
				<tbody>
				<tr>
					<td style="text-align: left;padding-left: 10px; vertical-align:top">
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','articleIdF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forATb1_1" name="articleIdF"><label for="forATb1_1"> <c:out value="${rims:codeValue('stats.exp.item.art','articleIdF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','scjnlNmF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forATb1_2" name="scjnlNmF"><label for="forATb1_2"> <c:out value="${rims:codeValue('stats.exp.item.art','scjnlNmF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','orgLangPprNmF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forATb1_3" name="orgLangPprNmF"><label for="forATb1_3"> <c:out value="${rims:codeValue('stats.exp.item.art','orgLangPprNmF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','pblcYearF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forATb1_4" name="pblcYearF"><label for="forATb1_4"> <c:out value="${rims:codeValue('stats.exp.item.art','pblcYearF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','pblcMonthF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forATb1_5" name="pblcMonthF"><label for="forATb1_5"> <c:out value="${rims:codeValue('stats.exp.item.art','pblcMonthF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','volumeF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forATb1_6" name="volumeF"><label for="forATb1_6"> <c:out value="${rims:codeValue('stats.exp.item.art','volumeF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','issueF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forATb1_7" name="issueF"><label for="forATb1_7"> <c:out value="${rims:codeValue('stats.exp.item.art','issueF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','sttPageF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forATb1_8" name="sttPageF"><label for="forATb1_8"> <c:out value="${rims:codeValue('stats.exp.item.art','sttPageF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','endPageF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forATb1_9" name="endPageF"><label for="forATb1_9"> <c:out value="${rims:codeValue('stats.exp.item.art','endPageF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','doiF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forATb1_10" name="doiF"><label for="forATb1_10"> <c:out value="${rims:codeValue('stats.exp.item.art','doiF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','doiUrlF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forATb1_11" name="doiUrlF"><label for="forATb1_11"> <c:out value="${rims:codeValue('stats.exp.item.art','doiUrlF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','issnNoF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forATb1_12" name="issnNoF"><label for="forATb1_12"> <c:out value="${rims:codeValue('stats.exp.item.art','issnNoF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','impctFctrF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forATb1_13" name="impctFctrF"><label for="forATb1_13"> <c:out value="${rims:codeValue('stats.exp.item.art','impctFctrF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','corprRsrchDvsCdF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forATb1_14" name="corprRsrchDvsCdF"><label for="forATb1_14"> <c:out value="${rims:codeValue('stats.exp.item.art','corprRsrchDvsCdF')}"/></label></div></c:if>
					</td>
					<td style="text-align: left;padding-left: 10px; vertical-align:top">
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','scjnlDvsCdF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forATb2_1" name="scjnlDvsCdF"><label for="forATb2_1"> <c:out value="${rims:codeValue('stats.exp.item.art','scjnlDvsCdF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','ovrsExclncScjnlPblcYnF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forATb2_2" name="ovrsExclncScjnlPblcYnF"><label for="forATb2_2"> <c:out value="${rims:codeValue('stats.exp.item.art','ovrsExclncScjnlPblcYnF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','wosDocTypeF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forATb2_3" name="wosDocTypeF"><label for="forATb2_3"> <c:out value="${rims:codeValue('stats.exp.item.art','wosDocTypeF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','scopusDocTypeF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forATb2_4" name="scopusDocTypeF"><label for="forATb2_4"> <c:out value="${rims:codeValue('stats.exp.item.art','scopusDocTypeF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','tcF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forATb2_5" name="tcF"><label for="forATb2_5"> <c:out value="${rims:codeValue('stats.exp.item.art','tcF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','scpTcF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forATb2_6" name="scpTcF"><label for="forATb2_6"> <c:out value="${rims:codeValue('stats.exp.item.art','scpTcF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','idSciF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forATb2_7" name="idSciF"><label for="forATb2_7"> <c:out value="${rims:codeValue('stats.exp.item.art','idSciF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','idScopusF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forATb2_8" name="idScopusF"><label for="forATb2_8"> <c:out value="${rims:codeValue('stats.exp.item.art','idScopusF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','idKciF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forATb2_9" name="idKciF"><label for="forATb2_9"> <c:out value="${rims:codeValue('stats.exp.item.art','idKciF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','openAccesAtF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forATb2_10" name="openAccesAtF"><label for="forATb2_10"> <c:out value="${rims:codeValue('stats.exp.item.art','openAccesAtF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','pblcNtnCdF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forATb2_11" name="pblcNtnCdF"><label for="forATb2_11"> <c:out value="${rims:codeValue('stats.exp.item.art','pblcNtnCdF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','insttRsltAtF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forATb2_13" name="insttRsltAtF"><label for="forATb2_13"> <c:out value="${rims:codeValue('stats.exp.item.art','insttRsltAtF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','vrfcDvsCdF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forATb2_14" name="vrfcDvsCdF"><label for="forATb2_14"> <c:out value="${rims:codeValue('stats.exp.item.art','vrfcDvsCdF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','abstCntnF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forATb2_15" name="abstCntnF"><label for="forATb2_15"> <c:out value="${rims:codeValue('stats.exp.item.art','abstCntnF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','fileAtF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forATb2_16" name="fileAtF"><label for="forATb2_16"> <c:out value="${rims:codeValue('stats.exp.item.art','fileAtF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','modDateF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forATb2_17" name="modDateF"><label for="forATb2_17"> <c:out value="${rims:codeValue('stats.exp.item.art','modDateF')}"/></label></div></c:if>
					</td>
					<td style="text-align: left;padding-left: 10px; vertical-align:top">
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','firstAuthorF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forATb3_1" name="firstAuthorF"><label for="forATb3_1"> <c:out value="${rims:codeValue('stats.exp.item.art','firstAuthorF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','corAuthorF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forATb3_7" name="corAuthorF"><label for="forATb3_7"> <c:out value="${rims:codeValue('stats.exp.item.art','corAuthorF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','authorsF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forATb3_2" name="authorsF"><label for="forATb3_2"> <c:out value="${rims:codeValue('stats.exp.item.art','authorsF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','totalAthrCntF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forATb3_3" name="totalAthrCntF"><label for="forATb3_3"> <c:out value="${rims:codeValue('stats.exp.item.art','totalAthrCntF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','totalAthrDetailCntF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forATb3_5" name="totalAthrDetailCntF"><label for="forATb3_5"> <c:out value="${rims:codeValue('stats.exp.item.art','totalAthrDetailCntF')}"/></label></div></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','mainProfessorsF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forATb3_6" name="mainProfessorsF"><label for="forATb3_6"> <c:out value="${rims:codeValue('stats.exp.item.art','mainProfessorsF')}"/></label></div></c:if>
					</td>
					<td style="text-align: left;padding-left: 10px; vertical-align:top">
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifLastTopMenuF')}">
							<ul class="ep_toggle_box">
								<li style="padding-bottom:5px;">
									<a href="javascript:void(0);" class="sideToggle"><span><img src="<c:url value="/images/background/ep_plus.png"/>"> </span></a><input type="checkbox" value="1" name="forRTb4_L1" id="forATb4_L1" onclick="clickCheckbox(this);"><label for="forATb4_L1"> <c:out value="${rims:codeValue('stats.exp.item.art','ifLastTopMenuF')}"/></label>
									<ul style="padding-left: 35px; display: none;">
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifLastJcrF')}"><li><input type="checkbox" value="1" id="forATb4_L11Sub" name="ifLastJcrF"><label for="forATb4_L11Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifLastJcrF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifLastF')}"><li><input type="checkbox" value="1" id="forATb4_L12Sub" name="ifLastF"><label for="forATb4_L12Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifLastF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifLastCaCoF')}"><li><input type="checkbox" value="1" id="forATb4_L13Sub" name="ifLastCaCoF"><label for="forATb4_L13Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifLastCaCoF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifLastCaNmF')}"><li><input type="checkbox" value="1" id="forATb4_L14Sub" name="ifLastCaNmF"><label for="forATb4_L14Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifLastCaNmF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifLastCaRankF')}"><li><input type="checkbox" value="1" id="forATb4_L15Sub" name="ifLastCaRankF"><label for="forATb4_L15Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifLastCaRankF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifLastCaRatioF')}"><li><input type="checkbox" value="1" id="forATb4_L16Sub" name="ifLastCaRatioF"><label for="forATb4_L16Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifLastCaRatioF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifLastRatingF')}"><li><input type="checkbox" value="1" id="forATb4_L17Sub" name="ifLastRatingF"><label for="forATb4_L17Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifLastRatingF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifLastAvg20F')}"><li><input type="checkbox" value="1" id="forATb4_L18Sub" name="ifLastAvg20F"><label for="forATb4_L18Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifLastAvg20F')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifLastRevF')}"><li><input type="checkbox" value="1" id="forATb4_L19Sub" name="ifLastRevF"><label for="forATb4_L19Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifLastRevF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifLastOrnF')}"><li><input type="checkbox" value="1" id="forATb4_L111Sub" name="ifLastOrnF"><label for="forATb4_L111Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifLastOrnF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifLastIndexAvgIfPercentileF')}"><li><input type="checkbox" value="1" id="forATb4_L116Sub" name="ifLastIndexAvgIfPercentileF"><label for="forATb4_L116Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifLastIndexAvgIfPercentileF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifLastIndexAvgIfPercentileKorF')}"><li><input type="checkbox" value="1" id="forATb4_L117Sub" name="ifLastIndexAvgIfPercentileKorF"><label for="forATb4_L117Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifLastIndexAvgIfPercentileKorF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifLastIndexMrnifF')}"><li><input type="checkbox" value="1" id="forATb4_L118Sub" name="ifLastIndexMrnifF"><label for="forATb4_L118Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifLastIndexMrnifF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifLast5YF')}"><li><input type="checkbox" value="1" id="forATb4_L112Sub" name="ifLast5YF"><label for="forATb4_L112Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifLast5YF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifLast5YRatioF')}"><li><input type="checkbox" value="1" id="forATb4_L113Sub" name="ifLast5YRatioF"><label for="forATb4_L113Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifLast5YRatioF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifLast5YRatingF')}"><li><input type="checkbox" value="1" id="forATb4_L114Sub" name="ifLast5YRatingF"><label for="forATb4_L114Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifLast5YRatingF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifLast5YRankF')}"><li><input type="checkbox" value="1" id="forATb4_L115Sub" name="ifLast5YRankF"><label for="forATb4_L115Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifLast5YRankF')}"/></label></li></c:if>
									</ul>
								</li>
							</ul>
						</c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','esLastTopMenuF')}">
							<ul class="ep_toggle_box">
								<li style="padding-bottom:5px;">
									<a href="javascript:void(0);" class="sideToggle"><span><img src="<c:url value="/images/background/ep_plus.png"/>"> </span></a><input type="checkbox" value="1" id="forATb4_L2" name="forRTb4_L2" onclick="clickCheckbox(this);"><label for="forATb4_L2"> <c:out value="${rims:codeValue('stats.exp.item.art','esLastTopMenuF')}"/></label>
									<ul style="padding-left: 35px; display: none;">
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','esLastVerF')}"><li><input type="checkbox" value="1" id="forATb4_L21Sub" name="esLastVerF"><label for="forATb4_L21Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','esLastVerF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','esLastF')}"><li><input type="checkbox" value="1" id="forATb4_L22Sub" name="esLastF"><label for="forATb4_L22Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','esLastF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','esLastCaRankF')}"><li><input type="checkbox" value="1" id="forATb4_L23Sub" name="esLastCaRankF"><label for="forATb4_L23Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','esLastCaRankF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','esLastRatioF')}"><li><input type="checkbox" value="1" id="forATb4_L24Sub" name="esLastRatioF"><label for="forATb4_L24Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','esLastRatioF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','esLastAvg20F')}"><li><input type="checkbox" value="1" id="forATb4_L25Sub" name="esLastAvg20F"><label for="forATb4_L25Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','esLastAvg20F')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','esLastRevF')}"><li><input type="checkbox" value="1" id="forATb4_L26Sub" name="esLastRevF"><label for="forATb4_L26Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','esLastRevF')}"/></label></li></c:if>
									</ul>
								</li>
							</ul>
						</c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','sjrLastTopMenuF')}">
							<ul class="ep_toggle_box">
								<li style="padding-bottom:5px;">
									<a href="javascript:void(0);" class="sideToggle"><span><img src="<c:url value="/images/background/ep_plus.png"/>"> </span></a><input type="checkbox" value="1" id="forATb4_L3" name="forRTb4_L3" onclick="clickCheckbox(this);"><label for="forATb4_L3"> <c:out value="${rims:codeValue('stats.exp.item.art','sjrLastTopMenuF')}"/></label>
									<ul style="padding-left: 35px; display: none;">
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','sjrLastYearF')}"><li><input type="checkbox" value="1" id="forATb4_L31Sub" name="sjrLastYearF"><label for="forATb4_L31Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','sjrLastYearF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','sjrLastF')}"><li><input type="checkbox" value="1" id="forATb4_L32Sub" name="sjrLastF"><label for="forATb4_L32Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','sjrLastF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','sjrLastCaCoF')}"><li><input type="checkbox" value="1" id="forATb4_L33Sub" name="sjrLastCaCoF"><label for="forATb4_L33Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','sjrLastCaCoF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','sjrLastCaF')}"><li><input type="checkbox" value="1" id="forATb4_L34Sub" name="sjrLastCaF"><label for="forATb4_L34Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','sjrLastCaF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','sjrLastRankF')}"><li><input type="checkbox" value="1" id="forATb4_L35Sub" name="sjrLastRankF"><label for="forATb4_L35Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','sjrLastRankF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','sjrLastRatioF')}"><li><input type="checkbox" value="1" id="forATb4_L36Sub" name="sjrLastRatioF"><label for="forATb4_L36Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','sjrLastRatioF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','sjrLastRatingF')}"><li><input type="checkbox" value="1" id="forATb4_L37Sub" name="sjrLastRatingF"><label for="forATb4_L37Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','sjrLastRatingF')}"/></label></li></c:if>
									</ul>
								</li>
							</ul>
						</c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','citeScoreLastTopMenuF')}">
							<ul class="ep_toggle_box">
								<li style="padding-bottom:5px;">
									<a href="javascript:void(0);" class="sideToggle"><span><img src="<c:url value="/images/background/ep_plus.png"/>"> </span></a><input type="checkbox" value="1" id="forATb4_L4" name="forRTb4_L4" onclick="clickCheckbox(this);"><label for="forATb4_L4"> <c:out value="${rims:codeValue('stats.exp.item.art','citeScoreLastTopMenuF')}"/></label>
									<ul style="padding-left: 35px; display: none;">
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','citeScoreLastYearF')}"><li><input type="checkbox" value="1" id="forATb4_L41Sub" name="citeScoreLastYearF"><label for="forATb4_L41Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','citeScoreLastYearF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','citeScoreLastF')}"><li><input type="checkbox" value="1" id="forATb4_L42Sub" name="citeScoreLastF"><label for="forATb4_L42Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','citeScoreLastF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','citeScoreLastCaCoF')}"><li><input type="checkbox" value="1" id="forATb4_L43Sub" name="citeScoreLastCaCoF"><label for="forATb4_L43Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','citeScoreLastCaCoF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','citeScoreLastCaF')}"><li><input type="checkbox" value="1" id="forATb4_L44Sub" name="citeScoreLastCaF"><label for="forATb4_L44Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','citeScoreLastCaF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','citeScoreLastRankF')}"><li><input type="checkbox" value="1" id="forATb4_L45Sub" name="citeScoreLastRankF"><label for="forATb4_L45Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','citeScoreLastRankF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','citeScoreLastRatioF')}"><li><input type="checkbox" value="1" id="forATb4_L46Sub" name="citeScoreLastRatioF"><label for="forATb4_L46Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','citeScoreLastRatioF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','citeScoreLastRatingF')}"><li><input type="checkbox" value="1" id="forATb4_L47Sub" name="citeScoreLastRatingF"><label for="forATb4_L47Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','citeScoreLastRatingF')}"/></label></li></c:if>
									</ul>
								</li>
							</ul>
						</c:if>
					</td>
					<td style="text-align: left;padding-left: 10px; vertical-align:top">
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifPubTopMenuF')}">
							<ul class="ep_toggle_box">
								<li style="padding-bottom:5px;">
									<a href="javascript:void(0);" class="sideToggle"><span><img src="<c:url value="/images/background/ep_plus.png"/>"> </span></a><input type="checkbox" value="1" name="forRTb5_L1" id="forATb5_L1" onclick="clickCheckbox(this);"><label for="forATb5_L1"> <c:out value="${rims:codeValue('stats.exp.item.art','ifPubTopMenuF')}"/></label>
									<ul style="padding-left: 35px; display: none;">
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifPubJcrF')}"><li><input type="checkbox" value="1" id="forATb5_L11Sub" name="ifPubJcrF"><label for="forATb5_L11Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifPubJcrF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifPubF')}"><li><input type="checkbox" value="1" id="forATb5_L12Sub" name="ifPubF"><label for="forATb5_L12Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifPubF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifPubCaCoF')}"><li><input type="checkbox" value="1" id="forATb5_L13Sub" name="ifPubCaCoF"><label for="forATb5_L13Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifPubCaCoF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifPubCaNmF')}"><li><input type="checkbox" value="1" id="forATb5_L14Sub" name="ifPubCaNmF"><label for="forATb5_L14Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifPubCaNmF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifPubCaRankF')}"><li><input type="checkbox" value="1" id="forATb5_L15Sub" name="ifPubCaRankF"><label for="forATb5_L15Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifPubCaRankF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifPubCaRatioF')}"><li><input type="checkbox" value="1" id="forATb5_L16Sub" name="ifPubCaRatioF"><label for="forATb5_L16Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifPubCaRatioF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifPubRatingF')}"><li><input type="checkbox" value="1" id="forATb5_L17Sub" name="ifPubRatingF"><label for="forATb5_L17Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifPubRatingF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifPubAvg20F')}"><li><input type="checkbox" value="1" id="forATb5_L18Sub" name="ifPubAvg20F"><label for="forATb5_L18Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifPubAvg20F')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifPubRevF')}"><li><input type="checkbox" value="1" id="forATb5_L19Sub" name="ifPubRevF"><label for="forATb5_L19Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifPubRevF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifPubOrnF')}"><li><input type="checkbox" value="1" id="forATb5_L111Sub" name="ifPubOrnF"><label for="forATb5_L111Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifPubOrnF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifPubIndexAvgIfPercentileF')}"><li><input type="checkbox" value="1" id="forATb5_L116Sub" name="ifPubIndexAvgIfPercentileF"><label for="forATb5_L116Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifPubIndexAvgIfPercentileF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifPubIndexAvgIfPercentileKorF')}"><li><input type="checkbox" value="1" id="forATb5_L117Sub" name="ifPubIndexAvgIfPercentileKorF"><label for="forATb5_L117Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifPubIndexAvgIfPercentileKorF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifPubIndexMrnifF')}"><li><input type="checkbox" value="1" id="forATb5_L118Sub" name="ifPubIndexMrnifF"><label for="forATb5_L118Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifPubIndexMrnifF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifPub5YF')}"><li><input type="checkbox" value="1" id="forATb5_L112Sub" name="ifPub5YF"><label for="forATb5_L112Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifPub5YF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifPub5YRatioF')}"><li><input type="checkbox" value="1" id="forATb5_L113Sub" name="ifPub5YRatioF"><label for="forATb5_L113Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifPub5YRatioF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifPub5YRatingF')}"><li><input type="checkbox" value="1" id="forATb5_L114Sub" name="ifPub5YRatingF"><label for="forATb5_L114Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifPub5YRatingF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','ifPub5YRankF')}"><li><input type="checkbox" value="1" id="forATb5_L115Sub" name="ifPub5YRankF"><label for="forATb5_L115Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','ifPub5YRankF')}"/></label></li></c:if>
									</ul>
								</li>
							</ul>
						</c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','esPubTopMenuF')}">
							<ul class="ep_toggle_box">
								<li style="padding-bottom:5px;">
									<a href="javascript:void(0);" class="sideToggle"><span><img src="<c:url value="/images/background/ep_plus.png"/>"> </span></a><input type="checkbox" value="1" id="forATb5_L2" name="forRTb5_L2" onclick="clickCheckbox(this);"><label for="forATb5_L2"> <c:out value="${rims:codeValue('stats.exp.item.art','esPubTopMenuF')}"/></label>
									<ul style="padding-left: 35px; display: none;">
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','esPubVerF')}"><li><input type="checkbox" value="1" id="forATb5_L21Sub" name="esPubVerF"><label for="forATb5_L21Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','esPubVerF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','esPubF')}"><li><input type="checkbox" value="1" id="forATb5_L22Sub" name="esPubF"><label for="forATb5_L22Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','esPubF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','esPubCaRankF')}"><li><input type="checkbox" value="1" id="forATb5_L23Sub" name="esPubCaRankF"><label for="forATb5_L23Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','esPubCaRankF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','esPubRatioF')}"><li><input type="checkbox" value="1" id="forATb5_L24Sub" name="esPubRatioF"><label for="forATb5_L24Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','esPubRatioF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','esPubAvg20F')}"><li><input type="checkbox" value="1" id="forATb5_L25Sub" name="esPubAvg20F"><label for="forATb5_L25Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','esPubAvg20F')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','esPubRevF')}"><li><input type="checkbox" value="1" id="forATb5_L26Sub" name="esPubRevF"><label for="forATb5_L26Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','esPubRevF')}"/></label></li></c:if>
									</ul>
								</li>
							</ul>
						</c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','sjrPubTopMenuF')}">
							<ul class="ep_toggle_box">
								<li style="padding-bottom:5px;">
									<a href="javascript:void(0);" class="sideToggle"><span><img src="<c:url value="/images/background/ep_plus.png"/>"> </span></a><input type="checkbox" value="1" id="forATb5_L3" name="forRTb5_L3" onclick="clickCheckbox(this);"><label for="forATb5_L3"> <c:out value="${rims:codeValue('stats.exp.item.art','sjrPubTopMenuF')}"/></label>
									<ul style="padding-left: 35px; display: none;">
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','sjrPubYearF')}"><li><input type="checkbox" value="1" id="forATb5_L31Sub" name="sjrPubYearF"><label for="forATb5_L31Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','sjrPubYearF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','sjrPubF')}"><li><input type="checkbox" value="1" id="forATb5_L32Sub" name="sjrPubF"><label for="forATb5_L32Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','sjrPubF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','sjrPubCaCoF')}"><li><input type="checkbox" value="1" id="forATb5_L33Sub" name="sjrPubCaCoF"><label for="forATb5_L33Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','sjrPubCaCoF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','sjrPubCaF')}"><li><input type="checkbox" value="1" id="forATb5_L34Sub" name="sjrPubCaF"><label for="forATb5_L34Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','sjrPubCaF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','sjrPubRankF')}"><li><input type="checkbox" value="1" id="forATb5_L35Sub" name="sjrPubRankF"><label for="forATb5_L35Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','sjrPubRankF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','sjrPubRatioF')}"><li><input type="checkbox" value="1" id="forATb5_L36Sub" name="sjrPubRatioF"><label for="forATb5_L36Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','sjrPubRatioF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','sjrPubRatingF')}"><li><input type="checkbox" value="1" id="forATb5_L37Sub" name="sjrPubRatingF"><label for="forATb5_L37Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','sjrPubRatingF')}"/></label></li></c:if>
									</ul>
								</li>
							</ul>
						</c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.art','citeScorePubTopMenuF')}">
							<ul class="ep_toggle_box">
								<li style="padding-bottom:5px;">
									<a href="javascript:void(0);" class="sideToggle"><span><img src="<c:url value="/images/background/ep_plus.png"/>"> </span></a><input type="checkbox" value="1" id="forATb5_L4" name="forRTb5_L4" onclick="clickCheckbox(this);"><label for="forATb5_L4"> <c:out value="${rims:codeValue('stats.exp.item.art','citeScorePubTopMenuF')}"/></label>
									<ul style="padding-left: 35px; display: none;">
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','citeScorePubYearF')}"><li><input type="checkbox" value="1" id="forATb5_L41Sub" name="citeScorePubYearF"><label for="forATb5_L41Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','citeScorePubYearF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','citeScorePubF')}"><li><input type="checkbox" value="1" id="forATb5_L42Sub" name="citeScorePubF"><label for="forATb5_L42Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','citeScorePubF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','citeScorePubCaCoF')}"><li><input type="checkbox" value="1" id="forATb5_L43Sub" name="citeScorePubCaCoF"><label for="forATb5_L43Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','citeScorePubCaCoF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','citeScorePubCaF')}"><li><input type="checkbox" value="1" id="forATb5_L44Sub" name="citeScorePubCaF"><label for="forATb5_L44Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','citeScorePubCaF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','citeScorePubRankF')}"><li><input type="checkbox" value="1" id="forATb5_L45Sub" name="citeScorePubRankF"><label for="forATb5_L45Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','citeScorePubRankF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','citeScorePubRatioF')}"><li><input type="checkbox" value="1" id="forATb5_L46Sub" name="citeScorePubRatioF"><label for="forATb5_L46Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','citeScorePubRatioF')}"/></label></li></c:if>
										<c:if test="${not empty rims:codeValue('stats.exp.item.art','citeScorePubRatingF')}"><li><input type="checkbox" value="1" id="forATb5_L47Sub" name="citeScorePubRatingF"><label for="forATb5_L47Sub"> <c:out value="${rims:codeValue('stats.exp.item.art','citeScorePubRatingF')}"/></label></li></c:if>
									</ul>
								</li>
							</ul>
						</c:if>
					</td>
				</tr>
				</tbody>
			</table>
		</form>
		<div class="list_set" style="margin-bottom: 10px;">
			<ul>
				<li><a href="javascript:downloadListXlsx();$('#selectDialog #closeBtn').triggerHandler('click');" class="list_icon05"><spring:message code='stats.export.export'/></a></li>
				<li><a href="javascript:$('#selectDialog #closeBtn').triggerHandler('click');" class="list_icon10"><spring:message code='stats.export.cancel'/></a></li>
			</ul>
		</div>
	</div>
</div>
</body>
</html>