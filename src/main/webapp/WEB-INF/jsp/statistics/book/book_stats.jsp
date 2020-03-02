<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../pageInit.jsp" %>
<jsp:useBean id="now" class="java.util.Date" />
<fmt:formatDate value="${now}" var="thisYear" pattern="yyyy" />
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Book Statistics</title>
<style type="text/css">
.dhxwins_vp_dhx_terrace {overflow: auto;}
.dhxwins_vp_dhx_terrace div.dhxwin_active div.dhx_cell_wins div.dhx_cell_toolbar_def, .dhxwins_vp_dhx_terrace div.dhxwin_inactive div.dhx_cell_wins div.dhx_cell_toolbar_def { padding: 10px 0px 0; }
.dhx_toolbar_dhx_terrace { padding: 0 0px; }
div.gridbox_dhx_terrace.gridbox .xhdr {border-bottom: 1px solid #ccc; border-top: 1px solid #ccc; background-color: #f5f5f5;}
div.gridbox_dhx_terrace.gridbox table.hdr td{vertical-align: middle;}
div.gridbox_dhx_terrace.gridbox table.hdr td div.hdrcell{padding-top: 4px; padding-bottom: 4px;line-height: 15px;}
div.gridbox_dhx_terrace.gridbox .ftr table td {padding-left: 5px;}
.effectExport {color : red;}
.list_tbl {border-top : none;}
.list_tbl tbody td { border-bottom : none;}
.list_tbl thead th {background : none; border-bottom:2px solid #5e9bf8;}
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
	myGrid.attachEvent("onRowSelect",function(id,ind){
		var columnId = myGrid.getColumnId(ind);
		if (columnId == "pubyear" || columnId == "prtcpntId" || columnId == "userNm" || columnId == "groupDept") return;

        param = "";
		if (columnId == "intl") param += "jnlDvsCd=2&";
		else if (columnId == "dmst") param += "jnlDvsCd=1&";
		else if (columnId == "other") param += "jnlDvsCd=0&";

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
        var parentId = this.id.substr(0,7);
        var checkBoxTdSize = $('.popup_inner tbody input[id^="'+parentId+'"]').size();

        if($('.popup_inner tbody input[id^="'+parentId+'"]:checked').size() == checkBoxTdSize){
            $("#"+parentId).prop('checked', true);
        }else{
            $("#"+parentId).prop('checked', false);
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
	myGrid.clearAndLoad("<c:url value="/${preUrl}/statistics/book/statistics.do?"/>" + $('#formArea').serialize());
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
function setGrade1() {
	if ($('input[name=gubun]:checked').val() == "M") {
		$('input[name=grade1]').attr('disabled', false);
	} else {
		$("input[name=grade1]:radio[value='']").prop("checked", true);
		$('input[name=grade1]').attr('disabled', true);
	}
}

function downloadListXlsx() {
	var url = '${contextPath}/${preUrl}/statistics/book/exportBook.do?' + $('#formArea').serialize() + "&" + param +  "&" + $('#forBForm').serialize();
	var expAnchor = $('<a class="exp_anchor" href="'+url+'"></a>');
	$("body").append(expAnchor);
	$('a.exp_anchor').bind('click',function(){
		doBeforeGridLoad();
		$.fileDownload($(this).prop('href'),{
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

    $(".popup_header h3").text("<spring:message code='stats.export.title'/>");

    $("#selectDialogBtn").click();
}

function findTemplate(){

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

			for(var i=0; i<fieldArr.length; i++){
				$("#forBForm input[name="+fieldArr[i]+"]").prop("checked",true);
				$("#forBForm input[name="+fieldArr[i]+"]").val(1);
			}

        });
    }
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

function footerClick(parameter){
    param = parameter;
    exportSelectBox();
}
</script>
</head>
<body>
	<div class="title_box">
		<h3><spring:message code='menu.statistics.book'/></h3>
	</div>
	<div class="contents_box">
		<!-- START 테이블 1 -->
		<form id="formArea" >
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
					<th>통계 유형</th>
					<td>
						<select name="jnlGubun" class="select1">
							<option value="byYear" selected="selected">연도별 통계</option>
							<option value="byPerson">개인별 통계</option>
							<option value="byDept">학과별(구분없음) 통계</option>
							<option value="byDeptYear">학과별(연도별구분) 통계</option>
						</select>
					</td>
					<th>발행년도</th>
					<td colspan="3">
						<span style="float: left;"><input type="text" id="stt_date" name="sttDate" class="input2"  maxlength="4" value="${thisYear-2 }" style="width: 60px;" />
						~ <input type="text" id="end_date" name="endDate" class="input2" maxlength="4" style="width: 60px;" /></span>
					</td>
					<td rowspan="8" class="option_search_td" onclick="javascript:myGrid_load();"><em>search</em></td>
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
					<th>작성언어</th>
					<td>
						<span style="float: left;"><input type="radio" id="mkoutLangCd0" name="mkoutLangCd" class="radio" value="" checked="checked" /> <label for="mkoutLangCd0" class="radio_label">전체</label></span>
						<span style="float: left;"><input type="radio" id="mkoutLangCd1" name="mkoutLangCd" class="radio" value="1" /> <label for="mkoutLangCd1" class="radio_label">한국어</label></span>
						<span style="float: left;"><input type="radio" id="mkoutLangCd2" name="mkoutLangCd" class="radio" value="2" /> <label for="mkoutLangCd2" class="radio_label">외국어</label></span>
					</td>
					<th>개정구분</th>
					<td>
						<span style="float: left;"><input type="radio" id="rvsnYn0" name="rvsnYn" class="radio" value="" checked="checked" /> <label for="rvsnYn0" class="radio_label">전체</label></span>
						<span style="float: left;"><input type="radio" id="rvsnYn1" name="rvsnYn" class="radio" value="1" /> <label for="rvsnYn1" class="radio_label">개정</label></span>
						<span style="float: left;"><input type="radio" id="rvsnYn2" name="rvsnYn" class="radio" value="2" /> <label for="rvsnYn2" class="radio_label">증보</label></span>
					</td>
				</tr>
				<tr>
					<th>저역서구분</th>
					<td>
						<span style="float: left;"><input type="radio" id="bookDvsCd0" name="bookDvsCd" class="radio" value="" checked="checked" /> <label for="bookDvsCd0" class="radio_label">전체</label></span>
						<span style="float: left;"><input type="radio" id="bookDvsCd1" name="bookDvsCd" class="radio" value="1" /> <label for="bookDvsCd1" class="radio_label">저서</label></span>
						<span style="float: left;"><input type="radio" id="bookDvsCd2" name="bookDvsCd" class="radio" value="2" /> <label for="bookDvsCd2" class="radio_label">역서</label></span>
						<span style="float: left;"><input type="radio" id="bookDvsCd3" name="bookDvsCd" class="radio" value="3" /> <label for="bookDvsCd3" class="radio_label">편서</label></span>
						<span style="float: left;"><input type="radio" id="bookDvsCd4" name="bookDvsCd" class="radio" value="4" /> <label for="bookDvsCd4" class="radio_label">기타</label></span>
					</td>
					<th>도서성격구분</th>
					<td colspan="3">
						<span style="float: left;"><input type="radio" id="bookCharCd0" name="bookCharCd" class="radio" value="" checked="checked" /> <label for="bookCharCd0" class="radio_label">전체</label></span>
						<span style="float: left;"><input type="radio" id="bookCharCd1" name="bookCharCd" class="radio" value="1" /> <label for="bookCharCd1" class="radio_label">전문도서</label></span>
						<span style="float: left;"><input type="radio" id="bookCharCd2" name="bookCharCd" class="radio" value="2" /> <label for="bookCharCd2" class="radio_label">교양도서(극내)</label></span>
						<span style="float: left;"><input type="radio" id="bookCharCd3" name="bookCharCd" class="radio" value="3" /> <label for="bookCharCd3" class="radio_label">교과서 및 지도서</label></span>
						<span style="float: left;"><input type="radio" id="bookCharCd4" name="bookCharCd" class="radio" value="4" /> <label for="bookCharCd4" class="radio_label">기타</label></span>
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
					<th>신분</th>
					<td>
						<span style="float: left;"><input type="radio" id="gubun0" name="gubun" onchange="setGrade1();" class="radio" value="" /> <label for="gubun0" class="radio_label">전체</label></span>
						<span style="float: left;"><input type="radio" id="gubun1" name="gubun" onchange="setGrade1();" class="radio" value="M" checked="checked" /> <label for="gubun1" class="radio_label">전임</label></span>
						<span style="float: left;"><input type="radio" id="gubun2" name="gubun" onchange="setGrade1();" class="radio" value="U" /> <label for="gubun2" class="radio_label">비전임</label></span>
						<span style="float: left;"><input type="radio" id="gubun3" name="gubun" onchange="setGrade1();" class="radio" value="S" /> <label for="gubun3" class="radio_label">학생</label></span>
						<span style="float: left;"><input type="radio" id="gubun4" name="gubun" onchange="setGrade1();" class="radio" value="E" /> <label for="gubun4" class="radio_label">기타</label></span>
					</td>
					<th>상세 신분</th>
					<td>
						<span style="float: left;"><input type="radio" id="grade10" name="grade1" class="radio" value="" checked="checked" /> <label for="grade10" class="radio_label">전체</label></span>
						<span style="float: left;"><input type="radio" id="grade11" name="grade1" class="radio" value="교수" /> <label for="grade11" class="radio_label">교수</label></span>
						<span style="float: left;"><input type="radio" id="grade12" name="grade1" class="radio" value="부교수" /> <label for="grade12" class="radio_label">부교수</label></span>
						<span style="float: left;"><input type="radio" id="grade13" name="grade1" class="radio" value="조교수" /> <label for="grade13" class="radio_label">조교수</label></span>
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
					<th>대상자구분</th>
					<td colspan="5">
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
					<col />
					<col style="width: 50px;"/>
				</colgroup>
				<tbody>
				<tr>
					<th><spring:message code='stats.book.pubyear'/></th>
					<td>
						<input type="hidden" name="statsGubun" value="P" />
						<input type="hidden" name="jnlGubun" value="byYear" />
						<span style="float: left;"><input type="text" id="stt_date" name="sttDate" class="input2" maxlength="4" value="" style="width: 60px;" />
						~ <input type="text" id="end_date" name="endDate" class="input2" maxlength="4" style="width: 60px;" /></span>
					</td>
					<td class="option_search_td" onclick="javascript:myGrid_load();"><em>search</em></td>
				</tr>
				</tbody>
			</table>
			</c:if>
		</form>
		<div class="list_bt_area">
			<div class="list_set">
				<ul>
					<li style="text-align: right;padding-top: 15px;"><spring:message code='stats.common.message1'/></li>
					<li><a href="#" onclick="javascript:exportSelectBox();param='';" class="list_icon20"><spring:message code='common.download.data'/></a></li>
					<li><a href="#" onclick="javascript:myGrid.toExcel('${contextPath}/servlet/xlsGenerate.do?file_name=book_stats.xls');" class="list_icon20"><spring:message code='common.download.table'/></a></li>
				</ul>
			</div>
		</div>
		<!-- layout (grid,paging)  -->
		<div id="mainLayout" style="position: relative; width: 100%;height: 100%;"></div>
	</div>
	<form name="expFrm" id="expFrm" method="post"></form>
	<div id="output"></div>
	<a href="#selectDialog" id="selectDialogBtn" class="modalLink" style="display: none;">반출 항목 Modal</a>
	<%--<div id="selectDialog" class="popup_box modal modal_layer export_popup" style="<c:if test="${sessMode or (sessionScope.auth.adminDvsCd eq 'R' or  sessionScope.auth.adminDvsCd eq 'S' )}">height: 150px;width: 500px;</c:if><c:if test="${not sessMode and sessionScope.auth.adminDvsCd ne 'R' and  sessionScope.auth.adminDvsCd ne 'S' }">width: 730px;height: 340px;</c:if>display: none;">--%>
	<div id="selectDialog" class="popup_box modal modal_layer export_popup" style="width: 730px;height: 340px;display: none;">
		<div class="popup_header" style="height: 50px;background:#ffffff;">
			<h3></h3>
			<a href="#" id="closeBtn" class="close_bt closeBtn">닫기</a>
		</div>
		<div class="popup_inner" id="selectDialogIn" style="overflow: auto;padding-left: 0px;padding-right: 0px;">
			<div class="ep_option_box"><!-- 0831 클래스 추가 -->
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
						<p>※ '전체저자(최대 1000명)','저자수'는 반출 속도에 영향을 미칩니다.</p>
					<%--</c:if>--%>
				</div>
			</div>
			<form id="forBForm">
				<%--<table width="100%" class="list_tbl mgb_20" style="<c:if test="${sessMode or (sessionScope.auth.adminDvsCd eq 'R' or  sessionScope.auth.adminDvsCd eq 'S' )}">display:none;</c:if>">--%>
				<table width="100%" class="list_tbl mgb_20">
					<colgroup>
						<col style="width: 30%">
						<col style="width: 15%">
						<col style="width: 28%">
						<col style="width: 30%">
					</colgroup>
					<thead>
					<tr>
						<c:if test="${not empty rims:codeValue('stats.exp.item.book','rsrchInfF')}"><th style="padding-top: 0px;padding-bottom: 0px;"><label for="forBTb0" class="chk_label"><input type="checkbox" value="1" onclick="clickCheckbox(this);" id="forBTb0" name="forBTb0"> <c:out value="${rims:codeValue('stats.exp.item.book','rsrchInfF')}"/></label></th></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.book','bookMajorF')}"><th style="padding-top: 0px;padding-bottom: 0px;" colspan="2"><label for="forBTb1" class="chk_label"><input type="checkbox" value="1" onclick="clickCheckbox(this);" id="forBTb1" name="forBTb1"> <c:out value="${rims:codeValue('stats.exp.item.book','bookMajorF')}"/></label></th></c:if>
						<c:if test="${not empty rims:codeValue('stats.exp.item.book','bookAddF')}"><th style="padding-top: 0px;padding-bottom: 0px;"><label for="forBTb2" class="chk_label"><input type="checkbox" value="1" onclick="clickCheckbox(this);" id="forBTb2" name="forBTb2"> <c:out value="${rims:codeValue('stats.exp.item.book','bookAddF')}"/></label></th></c:if>
					</tr>
					</thead>
					<tbody>
					<tr>
						<td style="text-align: left;padding-left: 10px; vertical-align:top">
							<c:if test="${not empty rims:codeValue('stats.exp.item.book','prtcpntIdF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forBTb0_1" name="prtcpntIdF"><label for="forBTb0_1"> <c:out value="${rims:codeValue('stats.exp.item.book','prtcpntIdF')}"/></label></div></c:if>
							<c:if test="${not empty rims:codeValue('stats.exp.item.book','korNmF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forBTb0_2" name="korNmF"><label for="forBTb0_2"> <c:out value="${rims:codeValue('stats.exp.item.book','korNmF')}"/></label></div></c:if>
							<c:if test="${not empty rims:codeValue('stats.exp.item.book','tpiDvsCdF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forBTb0_3" name="tpiDvsCdF"><label for="forBTb0_3"> <c:out value="${rims:codeValue('stats.exp.item.book','tpiDvsCdF')}"/></label></div></c:if>
							<c:if test="${not empty rims:codeValue('stats.exp.item.book','gubunF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forBTb0_4" name="gubunF"><label for="forBTb0_4"> <c:out value="${rims:codeValue('stats.exp.item.book','gubunF')}"/></label></div></c:if>
							<c:if test="${not empty rims:codeValue('stats.exp.item.book','grade1F')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forBTb0_5" name="grade1F"><label for="forBTb0_5"> <c:out value="${rims:codeValue('stats.exp.item.book','grade1F')}"/></label></div></c:if>
							<c:if test="${not empty rims:codeValue('stats.exp.item.book','deptKorF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forBTb0_6" name="deptKorF"><label for="forBTb0_6"> <c:out value="${rims:codeValue('stats.exp.item.book','deptKorF')}"/></label></div></c:if>
						</td>
						<td style="text-align: left;padding-left: 10px; vertical-align:top">
							<c:if test="${not empty rims:codeValue('stats.exp.item.book','bookIdF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forBTb1_1" name="bookIdF"><label for="forBTb1_1"> <c:out value="${rims:codeValue('stats.exp.item.book','bookIdF')}"/></label></div></c:if>
							<c:if test="${not empty rims:codeValue('stats.exp.item.book','bookDvsCdF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forBTb1_2" name="bookDvsCdF"><label for="forBTb1_2"> <c:out value="${rims:codeValue('stats.exp.item.book','bookDvsCdF')}"/></label></div></c:if>
							<c:if test="${not empty rims:codeValue('stats.exp.item.book','orgLangBookNmF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forBTb1_3" name="orgLangBookNmF"><label for="forBTb1_3"> <c:out value="${rims:codeValue('stats.exp.item.book','orgLangBookNmF')}"/></label></div></c:if>
							<c:if test="${not empty rims:codeValue('stats.exp.item.book','chapterTitleF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forBTb1_4" name="chapterTitleF"><label for="forBTb1_4"> <c:out value="${rims:codeValue('stats.exp.item.book','chapterTitleF')}"/></label></div></c:if>
							<c:if test="${not empty rims:codeValue('stats.exp.item.book','pblcPlcNmF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forBTb1_5" name="pblcPlcNmF"><label for="forBTb1_5"> <c:out value="${rims:codeValue('stats.exp.item.book','pblcPlcNmF')}"/></label></div></c:if>
							<c:if test="${not empty rims:codeValue('stats.exp.item.book','isbnNoF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forBTb1_6" name="isbnNoF"><label for="forBTb1_6"> <c:out value="${rims:codeValue('stats.exp.item.book','isbnNoF')}"/></label></div></c:if>
						</td>
						<td style="text-align: left;padding-left: 10px; vertical-align:top">
							<c:if test="${not empty rims:codeValue('stats.exp.item.book','bookPblcYmF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forBTb1_7" name="bookPblcYmF"><label for="forBTb1_7"> <c:out value="${rims:codeValue('stats.exp.item.book','bookPblcYmF')}"/></label></div></c:if>
							<c:if test="${not empty rims:codeValue('stats.exp.item.book','jnlDvsCdF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forBTb1_8" name="jnlDvsCdF"><label for="forBTb1_8"> <c:out value="${rims:codeValue('stats.exp.item.book','jnlDvsCdF')}"/></label></div></c:if>
							<c:if test="${not empty rims:codeValue('stats.exp.item.book','totalPageF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forBTb1_9" name="totalPageF"><label for="forBTb1_9"> <c:out value="${rims:codeValue('stats.exp.item.book','totalPageF')}"/></label></div></c:if>
							<c:if test="${not empty rims:codeValue('stats.exp.item.book','wrtSttEndPageF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forBTb1_10" name="wrtSttEndPageF"><label for="forBTb1_10"> <c:out value="${rims:codeValue('stats.exp.item.book','wrtSttEndPageF')}"/></label></div></c:if>
							<c:if test="${not empty rims:codeValue('stats.exp.item.book','mkoutLangCdF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forBTb1_11" name="mkoutLangCdF"><label for="forBTb1_11"> <c:out value="${rims:codeValue('stats.exp.item.book','mkoutLangCdF')}"/></label></div></c:if>
						</td>
						<td style="text-align: left;padding-left: 10px; vertical-align:top">
							<c:if test="${not empty rims:codeValue('stats.exp.item.book','dlgtAthrNmF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forBTb2_1" name="dlgtAthrNmF"><label for="forBTb2_1"> <c:out value="${rims:codeValue('stats.exp.item.book','dlgtAthrNmF')}"/></label></div></c:if>
							<c:if test="${not empty rims:codeValue('stats.exp.item.book','authorsF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forBTb2_2" name="authorsF"><label for="forBTb2_2"> <c:out value="${rims:codeValue('stats.exp.item.book','authorsF')}"/></label></div></c:if>
							<c:if test="${not empty rims:codeValue('stats.exp.item.book','totalAthrCntF')}"><div class="ep_label_box"><input type="checkbox" value="1" id="forBTb2_3" name="totalAthrCntF"><label for="forBTb2_3"> <c:out value="${rims:codeValue('stats.exp.item.book','totalAthrCntF')}"/></label></div></c:if>
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