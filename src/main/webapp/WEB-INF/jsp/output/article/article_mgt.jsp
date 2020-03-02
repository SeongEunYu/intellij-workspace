<%@page import="kr.co.argonet.r2rims.util.LanguageUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="../../pageInit.jsp" %>
<c:if test="${sessMode or (sessionScope.auth.adminDvsCd eq 'R' or  sessionScope.auth.adminDvsCd eq 'S' )}">
<style type="text/css">.appr { color: #f26522; font-weight: bold; }</style>
</c:if>
<script type="text/javascript" src="<c:url value="/js/jquery/jquery.filedownload.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/mainLayout.js"/>"></script>
<script type="text/javascript">
var dhxLayout, myGrid, t, openedPage = 1, openedRowId, rowNums, pageSize, pageNums, mappingPopup;
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
	var header = "번호,관리번호,학술지구분,게재년월,논문명,학술지명,WOS,SCOPUS,KCI,DOI,저자수,KRI검증여부,출판여부,최종수정일,삭제여부,post,pub";
	var columnIds = "No,articleId,scjnlDvsNm,pblcYm,orgLangPprNm,scjnlNm,idSci,idScopus,idKci,doi,authorCo,vrfcDvsCd,apprDvsCd,modDate,delDvsCd,postVer,pubVer";
	//var initWidths = "50,80,120,70,*,*,50,50,50,50,70,70,80,50,50,50";
	var initWidths = "3,5,7,5,18,18,4,4,4,4,4,5,4,5,4,3,3";
	var colAlign = "center,center,left,center,left,left,center,center,center,left,center,center,center,center,center,center,center";
	var colTypes = "ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro";
	var colSorting = "na,int,str,str,str,str,str,str,str,str,int,str,str,str,na,na,na";
	var serializable = "false,fasle,false,false,true,false,false,false,false,false,false,false,false,false,false,false,false";

	if(sessMode == 'true' || loginAuthor == 'R' || loginAuthor == 'S')
	{
		header = "<spring:message code='grid.no'/>,<spring:message code='grid.id'/>,<spring:message code='grid.art1'/>,<spring:message code='grid.art2'/>,<spring:message code='grid.art3'/>,<spring:message code='grid.art.reprsnt'/>,<spring:message code='grid.art6'/>,<spring:message code='grid.art5'/>,<spring:message code='grid.appr.dvs'/>,<spring:message code='art.org.file'/>";
		columnIds = "No,articleId,pblcYm,orgLangPprNm,scjnlNm,isReprsntArticle,userConfirmAt,fundingConfirmAt,apprDvsCd,attachFile";
		//initWidths = "50,80,70,*,*,100,100,100,90,100";
		initWidths = "3,5.5,5,29,28,6,6,6,5.5,6";
		colAlign = "center,center,center,left,left,center,center,center,center,center";
		colTypes = "ro,ro,ro,ro,ro,ro,ro,ro,ro,ro";
		colSorting = "na,na,str,str,str,str,na,str,na,na";
		serializable = "fasle,false,false,true,false,false,false,false,false,false";
	}

	myGrid = dhxLayout.cells("a").attachGrid();
	myGrid.setImagePath("${dhtmlXImagePath}");
	myGrid.setHeader(header,null,grid_head_center_bold);
	myGrid.setColumnIds(columnIds);
	//myGrid.setInitWidths(initWidths);
	myGrid.setInitWidthsP(initWidths);
	myGrid.setColAlign(colAlign);
	myGrid.setColTypes(colTypes);
	myGrid.setColSorting(colSorting);
	myGrid.setSerializableColumns(serializable);
	myGrid.attachEvent("onRowSelect", myGrid_onRowSelect);
	myGrid.attachEvent("onBeforeSorting", myGrid_onBeforeSorting);
	myGrid.attachEvent("onXLS", doBeforeGridLoad);
	myGrid.attachEvent("onXLE", doOnGridLoaded);
	myGrid.enablePaging(true,100,10,"pagingArea",true);
	myGrid.setPagingSkin("${dhtmlXPagingSkin}");
	myGrid.enableMultiselect(true);
	myGrid.enableColSpan(true);
	myGrid.enableColumnAutoSize(true);
	myGrid.init();
	myGrid.setSizes();
	myGrid_load();

    $(".menu_option_bt").click(function(){
        $(".search_option_box").slideToggle(500, function(){
            setMainLayoutHeight($('#mainLayout')); dhxLayout.setSizes(false);
		});
        $(".menu_option_bt").toggleClass("mo_open_bt");
    });

});
function myGrid_load(){
	var url = getGridRequestURL();
	myGrid.clearAndLoad(url, function(){
		rowNums = myGrid.getRowsNum(); pageSize = myGrid.rowsBufferOutSize; pageNums = parseInt(rowNums/pageSize) + 1
		if(openedPage != myGrid.currentPage){
			myGrid.changePage(openedPage);
			myGrid.selectRow(myGrid.getRowIndex(openedRowId),false,false,true);
		}
	});
}
function myGrid_onBeforeSorting(ind,type,direct){
	var url = getGridRequestURL();
	myGrid.clearAndLoad(url+"&orderby="+(myGrid.getColumnId(ind))+"&direct="+direct);
	myGrid.setSortImgState(true,ind,direct);
	return false;
}
function getGridRequestURL(){

	if($('#adminSrchDeptTrack').length)
	{
		var val = $('#adminSrchDeptTrack').val();
		if(val != null && val != '')
		{
			if(val.indexOf('DEPT_') != -1 ){
				$('#adminSrchDeptKor').val(val.replace('DEPT_',''));
				$('#adminSrchTrack').val('');
			}
			if(val.indexOf('TRACK_') != -1 ){
				$('#adminSrchDeptKor').val('');
				$('#adminSrchTrack').val(val.replace('TRACK_',''));
			}
		}
		else
		{
			$('#adminSrchDeptKor').val('');
			$('#adminSrchTrack').val('');
		}
	}

	var url = "<c:url value="/${preUrl}/article/findArticleList.do"/>";
	url = comAppendQueryString(url,"appr",	'<c:out value="${param.appr}"/>');
	url += "&"  + $('#formArea').serialize();
	return url;
}

function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){ setMainLayoutHeight($('#mainLayout')); dhxLayout.setSizes(false); },10);}
function doOnGridLoaded(){setTimeout(function() {dhxLayout.cells("a").progressOff();}, 100);}
function doBeforeGridLoad(){dhxLayout.cells("a").progressOn();}

function myGrid_onRowSelect(rowID,celInd){
	openedRowId = rowID;
	openedPage = myGrid.currentPage;
	var wWidth = 1108;
	var wHeight = (screenHeight - 100);
	var leftPos = (screenWidth - wWidth)/2;
	var topPos = 0;
	if(rowID == '0') return;
	var str = rowID.split('_');
	mappingPopup = window.open('about:blank', 'articlePopup', 'width='+wWidth+',height='+wHeight+',top='+topPos+',left='+leftPos+' location=no,scrollbars=yes,resizable=yes');
	var popFrm = $('#popFrm');
	popFrm.empty();
	popFrm.append($('<input type="hidden" name="articleId" value="'+str[1]+'"/>'));
	popFrm.attr('action', '<c:url value="/${preUrl}/article/articlePopup.do"/>');
	popFrm.attr('target', 'articlePopup');
	popFrm.attr('method', 'POST');
	popFrm.submit();
	mappingPopup.focus();
}

function prevRow(){
	var prevId = myGrid.getRowIndex(myGrid.getRowId(myGrid.getRowIndex(openedRowId) - 1));
	if(prevId != -1)
	{
		if(prevId % pageSize == 0){
			if(myGrid.currentPage > 1) myGrid.changePage(myGrid.currentPage - 1);
		}
		myGrid.clearSelection();
		myGrid.selectRow(prevId,true,true,true);
	}
	else
	{
		mappingPopup.alertFirstRow();
	}
}

function nextRow(){
	var nextId = myGrid.getRowIndex(myGrid.getRowId(myGrid.getRowIndex(openedRowId) + 1));
	if(nextId != -1)
	{
		if((nextId+1) % pageSize == 0){
			if(myGrid.currentPage < pageNums) myGrid.changePage(myGrid.currentPage + 1);
		}
		myGrid.clearSelection();
		myGrid.selectRow(nextId,true,true,true);
	}
	else
	{
		mappingPopup.alertLastRow();
	}
}

function fn_new(){
	var wWidth = 1100;
	var wHeight = (screenHeight - 100);
	var leftPos = (screenWidth - wWidth)/2;
	//var topPos = (screenHeight - wHeight)/2;
	var topPos = 0;
	mappingPopup = window.open('about:blank', 'articleNewPopup', 'width='+wWidth+',height='+wHeight+',top='+topPos+',left='+leftPos+' location=no,scrollbars=yes,resizable=yes');
	var popFrm = $('#popFrm');
	popFrm.empty();
	popFrm.attr('action', '<c:url value="/${preUrl}/article/articlePopup.do"/>');
	popFrm.attr('target', 'articleNewPopup');
	popFrm.attr('method', 'POST');
	popFrm.submit();
	mappingPopup.focus();
}

function toExcel(){
	var url = "<c:url value="/article/excelExport.do?"/>"+$('#formArea').serialize();
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

function fn_export(){
	$('#articleExportDialog #closeBtn').triggerHandler('click');
	var exportFmt = $('input[name="exportFmt"]:checked').val();
	var expInfo = $('input[name="expInfo"]:checked').val();
	var url = "";
	if(exportFmt == 'excel' && expInfo == 'all')
	{
		url = "<c:url value="/${preUrl}/statistics/article/export.do?"/>"+$('#formArea').serialize()+'&'+$('#articleExportFrm').serialize()+'&statsGubun=P' ;
	}
	else
	{
		url = "<c:url value="/${preUrl}/article/export.do?"/>"+$('#formArea').serialize()+'&'+$('#articleExportFrm').serialize() ;
	}
	var expAnchor = $('<a class="exp_anchor" href="'+url+'"></a>');
	$("body").append(expAnchor);
	$('a.exp_anchor').bind('click',function(){
		doBeforeGridLoad();
		$.fileDownload($(this).prop('href'),{
			successCallback: function (url) {
				doOnGridLoaded();
				$('a.exp_anchor').remove();
				//$('#articleExportDialog #closeBtn').triggerHandler('click');
			},
			failCallback: function (responseHtml, url) {
				doOnGridLoaded();
				$('a.exp_anchor').remove();
				//$('#articleExportDialog #closeBtn').triggerHandler('click');
            }
		});
	}).triggerHandler('click');
}
// 저널영향력지수 재반입
function reimportJournalImpactIndex(){
	dhtmlx.confirm({title:"Impact Factor Update", ok:"예", cancel:"아니오", text:"Journal Impact Index 다시 반입 하시겠습니까?<br/>(기존데이터 삭제 후 재반입)",
		callback:function(result){
			if(result == true)
			{
				$.post("<c:url value="/migration/article/journal.do?target=index"/>", null,null,'text').done(function(data){});
				dhtmlx.alert({type:"alert-warning",text:"업데이트는 백그라운드로 진행됩니다. <br/>(최장 하루 정도 소요됩니다.)"});
			}
		}
	});
}

// Impact Factor 업데이트
function updateArticleIF(){
	dhtmlx.confirm({title:"Impact Factor Update", ok:"예", cancel:"아니오", text:"논문테이블의 IF, SJR 값을 전체 업데이트 하시겠습니까?",
		callback:function(result){
			if(result == true)
			{
				doBeforeGridLoad();
				$.post("<c:url value="/article/updateIF.do"/>", null,null,'text').done(function(data){
					dhtmlx.alert({type:"alert-warning",text:"업데이트 완료하였습니다.",callback:function(){ doOnGridLoaded();}});
				});
			}
		}
	});
}

// Upload Article To WOS_RID
function fn_uploadArticleToWOS(){

	if($('input:radio[name="trget_range"]:checked').val() == 'rsch')
	{
		if($('#trgetUserId').val() == '')
		{
			dhtmlx.alert({type:"alert-warning",text:"대상이 연구자(선택)인 경우<br/> 연구자 사번은 필수입니다.",callback:function(){$('#trgetUserId').focus();}});
			return;
		}
	}

	dhtmlx.confirm({title:"WOS RID Data Upload", ok:"예", cancel:"아니오", text:"WOS RID Data를 업로드 하시겠습니까?",
		callback:function(result){
			if(result == true)
			{
				doBeforeGridLoad();
				$.post("<c:url value="/article/updatePub.do"/>", $('#ridDataUploadFrm').serializeArray(),null,'text').done(function(data){
					dhtmlx.alert({type:"alert-warning",text:"업로드 완료하였습니다.",callback:function(){
						doOnGridLoaded();
						$('#ridDataUploadDialog #closeBtn').triggerHandler('click');
					}});
				});
			}
		}
	});

}

function fn_expFmtClick(rdo){
	var value = $(rdo).val();
	if(value == 'excel')
	{
		$('#articleExportDialog input:checkbox').prop('disabled', false);
		$('input:radio[name="expInfo"]').prop('disabled', false);
		$('#expInfo_sumry').prop('checked',true).trigger('click');
	}
	else
	{
		$('#articleExportDialog input:checkbox').prop('disabled', true);
		$('input:radio[name="expInfo"]').prop('checked',false).prop('disabled', true);
		$('.chk_item').prop('checked',false);
	}
}

</script>
</head>
<body>
	<div class="title_box">
		<h3><spring:message code='menu.article'/></h3>
		<div class="add_option"><span>검색 옵션</span><a href="#" class="menu_option_bt">열기/닫기</a></div>
	</div>
	<div class="contents_box">
		<!-- START 테이블 1 -->
		<form id="formArea" >
			<c:if test="${not sessMode and sessionScope.auth.adminDvsCd ne 'R' and  sessionScope.auth.adminDvsCd ne 'S' }">
			<div class="search_option_box">
			<table class="view_tbl mgb_10" >
				<colgroup>
					<col style="width: 15%;"/>
					<col style="width: 37%;"/>
					<col style="width: 15%;"/>
					<col />
					<col style="width: 50px;"/>
				</colgroup>
				<tbody>
				<tr>
					<th>사번</th>
					<td><input type="text" id="user_id" name="srchUserId" class="input2" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/></td>
					<th>게재년</th>
					<td>
						<input type="text" id="stt_date" name="sttDate" class="input2"  maxlength="4" style="width: 80px;"  value="" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();" />
						~ <input type="text" id="end_date" name="endDate" class="input2" maxlength="4" style="width: 80px;" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/>
						<input type="checkbox" name="isAccept" id="isAccept" value="true" class="radio"/>
							<label for="isAccept" class="radio_label">Accept 미포함</label>
					</td>
					<td rowspan="9" class="option_search_td" onclick="javascript:myGrid_load();"><em>search</em></td>
				</tr>
				<tr>
					<th>성명</th>
					<td><input type="text" name="userNm" id="nm" class="input2" maxlength="10" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/></td>
					<th>
						<c:if test="${sessionScope.auth.adminDvsCd eq 'M'}">학과 및 트랙</c:if>
						<c:if test="${sessionScope.auth.adminDvsCd eq 'D' or sessionScope.login_user.adminDvsCd eq 'C'}">학과</c:if>
						<c:if test="${sessionScope.login_user.adminDvsCd eq 'T'}">트랙</c:if>
					</th>
					<td>
						<c:if test="${sessionScope.auth.adminDvsCd ne 'M'}">
							<c:if test="${sessionScope.auth.adminDvsCd eq 'D'}">
								<input type="hidden" name="srchDeptKor" value="${sessionScope.auth.workTrgetNm}" />
								<input type="hidden" name="srchDept" value="${sessionScope.auth.workTrget}" />
								${sessionScope.auth.workTrgetNm}
							</c:if>
							<c:if test="${sessionScope.auth.adminDvsCd eq 'T'}">
								<input type="hidden" name="srchTrack" value="${sessionScope.auth.workTrget}" />
								${sessionScope.auth.workTrgetNm}
							</c:if>
							<c:if test="${sessionScope.auth.adminDvsCd eq 'C'}">
								<select name="srchDeptKor" onchange="javascript:myGrid_load();">
									<option value="">전체</option>
									<c:forEach items="${deptList}" var="dl" varStatus="idx">
										<option value="${fn:escapeXml(dl.deptKor)}">${fn:escapeXml(dl.deptKor)}</option>
									</c:forEach>
								</select>
							</c:if>
						</c:if>
						<c:if test="${sessionScope.auth.adminDvsCd eq 'M'}">
							<select  name="adminSrchDeptTrack" id="adminSrchDeptTrack"  onchange="javascript:myGrid_load();" >
								<option value="">전체</option>
								<optgroup label="학과(부)">
									<c:forEach var="item" items="${deptList}">
									<option value="DEPT_${item.deptKor}">${item.deptKor}</option>
									</c:forEach>
								</optgroup>
								<optgroup label="트랙">
									<c:forEach var="item" items="${trackList}">
									<option value="TRACK_${item.trackId}">${item.trackName}</option>
									</c:forEach>
								</optgroup>
							</select>
							<input type="hidden" name="srchDeptKor"  id="adminSrchDeptKor"/>
							<input type="hidden" name="srchTrack"  id="adminSrchTrack"/>
						</c:if>
					</td>
				</tr>
				<tr>
					<th>논문명</th>
					<td colspan="3">
						<input type="text" id="org_lang_ppr_nm" name="orgLangPprNm" class="typeText" style="width: 100%;" class="input2" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/>
					</td>
				</tr>
				<tr>
					<th>논문번호</th>
					<td><input type="text" name="articleId" id="article_id" class="input2" maxlength="10" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/></td>
					<th>연구자확인 상태</th>
					<td>
						<input type="radio" id="record_status_all" name="recordStatus"  value=""  checked="checked" onchange="javascript:myGrid_load();" class="radio"/>
							<label for="record_status_all" class="radio_label">전체</label>
						<input type="radio" id="record_status_chk" name="recordStatus"  value="1" onchange="javascript:myGrid_load();" class="radio"/>
							<label for="record_status_chk" class="radio_label">확인</label>
						<input type="radio" id="record_status_not" name="recordStatus"  value="0" onchange="javascript:myGrid_load();" class="radio"/>
							<label for="record_status_not" class="radio_label">미확인</label>
					</td>
				</tr>
				<tr>
					<th>대상구분</th>
					<td colspan="3">
						<input type="radio" id="trgetSe_all" name="trgetSe"  value=""  checked="checked" onchange="javascript:myGrid_load();" class="radio"/>
							<label for="trgetSe_all" class="radio_label">전체</label>
						<input type="radio" id="trgetSe_mgt" name="trgetSe"  value="M" onchange="javascript:myGrid_load();" class="radio"/>
							<label for="trgetSe_mgt" class="radio_label">관리대상자(전임직 교원)</label>
						<input type="radio" id="trgetSe_not_mgt" name="trgetSe"  value="U" onchange="javascript:myGrid_load();" class="radio"/>
							<label for="trgetSe_not_mgt" class="radio_label">미관리대상</label>
						<input type="radio" id="trgetSe_student" name="trgetSe"  value="S" onchange="javascript:myGrid_load();" class="radio"/>
							<label for="trgetSe_student" class="radio_label">학생</label>
						<input type="radio" id="trgetSe_etc" name="trgetSe"  value="E" onchange="javascript:myGrid_load();" class="radio"/>
							<label for="trgetSe_etc" class="radio_label">기타</label>
					</td>
				</tr>
				<tr>
					<th>학술지 구분</th>
					<td colspan="3">
						<input type="radio" id="scjnl_dvs_cd0" name="scjnlDvsCd" class="radio" style="border: 0;" checked="checked" value="" onchange="javascript:myGrid_load();"/>
							<label for="scjnl_dvs_cd0" class="radio_label">전체</label>
						<input type="radio" id="scjnl_dvs_cd1" name="scjnlDvsCd" class="radio" style="border: 0;" value="1" onchange="javascript:myGrid_load();"/>
							<label for="scjnl_dvs_cd1" class="radio_label">국제전문학술지(SCI급)</label>
						<input type="radio" id="scjnl_dvs_cd2" name="scjnlDvsCd" class="radio" style="border: 0;" value="2" onchange="javascript:myGrid_load();"/>
							<label for="scjnl_dvs_cd2" class="radio_label">국제일반학술지</label>
						<input type="radio" id="scjnl_dvs_cd3" name="scjnlDvsCd" class="radio" style="border: 0;" value="3" onchange="javascript:myGrid_load();"/>
							<label for="scjnl_dvs_cd3" class="radio_label">국내전문학술지(KCI급)</label>
						<input type="radio" id="scjnl_dvs_cd4" name="scjnlDvsCd" class="radio" style="border: 0;" value="4" onchange="javascript:myGrid_load();"/>
							<label for="scjnl_dvs_cd4" class="radio_label">국내일반학술지</label>
						<input type="radio" id="scjnl_dvs_cd5" name="scjnlDvsCd" class="radio" style="border: 0;" value="5" onchange="javascript:myGrid_load();"/>
							<label for="scjnl_dvs_cd5" class="radio_label">기타</label>
					</td>
				</tr>
				<tr>
					<th>실적 구분</th>
					<td >
						<input type="radio" id="insttRsltAt_all" name="insttRsltAt" class="radio" style="border: 0;" value="" checked="checked" onchange="javascript:myGrid_load();"/>
							<label for="insttRsltAt_all" class="radio_label">전체</label>
						<input type="radio" id="insttRsltAt_y" name="insttRsltAt" class="radio" style="border: 0;" value="Y" onchange="javascript:myGrid_load();"/>
							<label for="insttRsltAt_y" class="radio_label">${sysConf['inst.abrv']}</label>
						<input type="radio" id="insttRsltAt_n" name="insttRsltAt" class="radio" style="border: 0;" value="N" onchange="javascript:myGrid_load();"/>
							<label for="insttRsltAt_n" class="radio_label">Other</label>
					</td>
					<th>ISSN번호</th>
					<td>
						<input type="text" name="issnNo" id="issnNo" class="input2" maxlength="10" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/>
					</td>
				</tr>
				<tr>
					<th>KRI 검증상태</th>
					<td>
						<input type="radio" id="vrfcDvsCd_cd0" name="vrfcDvsCd" class="radio" style="border: 0;" value="" checked="checked" onchange="javascript:myGrid_load();"/>
							<label for="vrfcDvsCd_cd0" class="radio_label">전체</label>
						<input type="radio" id="vrfcDvsCd_cd1" name="vrfcDvsCd" class="radio" style="border: 0;" value="1" onchange="javascript:myGrid_load();"/>
							<label for="vrfcDvsCd_cd1" class="radio_label">미검증</label>
						<input type="radio" id="vrfcDvsCd_cd2" name="vrfcDvsCd" class="radio" style="border: 0;" value="2" onchange="javascript:myGrid_load();"/>
							<label for="vrfcDvsCd_cd2" class="radio_label">검증완료</label>
						<input type="radio" id="vrfcDvsCd_cd3" name="vrfcDvsCd" class="radio" style="border: 0;" value="3" onchange="javascript:myGrid_load();"/>
							<label for="vrfcDvsCd_cd3" class="radio_label">검증불가</label>
					</td>
					<th>삭제구분</th>
					<td>
						<input type="checkbox" name="isDelete" id="isDelete" value="true" onchange="javascript:myGrid_load();" class="radio"/>
						<label for="isDelete" class="radio_label">삭제된 데이터 포함</label>
					</td>
				</tr>
				<tr>
					<th>승인상태</th>
					<td>
						<input type="radio" id="appr_dvs_cd0" name="apprDvsCd" class="radio" style="border: 0;" value="" checked="checked" onchange="javascript:myGrid_load();"/>
							<label for="appr_dvs_cd0" class="radio_label">전체</label>
						<input type="radio" id="appr_dvs_cd1" name="apprDvsCd" class="radio" style="border: 0;" value="1" onchange="javascript:myGrid_load();"/>
							<label for="appr_dvs_cd1" class="radio_label">미승인</label>
						<input type="radio" id="appr_dvs_cd2" name="apprDvsCd" class="radio" style="border: 0;" value="2" onchange="javascript:myGrid_load();"/>
							<label for="appr_dvs_cd2" class="radio_label">승인보류</label>
						<input type="radio" id="appr_dvs_cd3" name="apprDvsCd" class="radio" style="border: 0;" value="3" onchange="javascript:myGrid_load();"/>
							<label for="appr_dvs_cd3" class="radio_label">승인완료</label>
						<input type="radio" id="appr_dvs_cd4" name="apprDvsCd" class="radio" style="border: 0;" value="4" onchange="javascript:myGrid_load();"/>
							<label for="appr_dvs_cd4" class="radio_label">승인반려</label>
						<input type="radio" id="appr_dvs_cd5" name="apprDvsCd" class="radio" style="border: 0;" value="5" onchange="javascript:myGrid_load();"/>
							<label for="appr_dvs_cd5" class="radio_label">승인불가</label>
					</td>
					<th>식별자중복</th>
					<td>
						<input type="radio" id="dplctIdntfr_na" name="dplctIdntfr" class="radio" style="border: 0;" value="" checked="checked" onchange="javascript:myGrid_load();"/>
							<label for="dplctIdntfr_na" class="radio_label">해당없음</label>
						<input type="radio" id="dplctIdntfr_wos" name="dplctIdntfr" class="radio" style="border: 0;" value="WOS" onchange="javascript:myGrid_load();"/>
							<label for="dplctIdntfr_wos" class="radio_label">WOS</label>
						<input type="radio" id="dplctIdntfr_scopus" name="dplctIdntfr" class="radio" style="border: 0;" value="SCOPUS" onchange="javascript:myGrid_load();"/>
							<label for="dplctIdntfr_scopus" class="radio_label">SCOPUS</label>
						<input type="radio" id="dplctIdntfr_kci" name="dplctIdntfr" class="radio" style="border: 0;" value="KCI" onchange="javascript:myGrid_load();"/>
							<label for="dplctIdntfr_kci" class="radio_label">KCI</label>
						<input type="radio" id="dplctIdntfr_doi" name="dplctIdntfr" class="radio" style="border: 0;" value="DOI" onchange="javascript:myGrid_load();"/>
							<label for="dplctIdntfr_doi" class="radio_label">DOI</label>
					</td>
				</tr>
				</tbody>
			</table>
			</div>
			</c:if>
			<c:if test="${sessMode or (sessionScope.auth.adminDvsCd eq 'R' or  sessionScope.auth.adminDvsCd eq 'S' )}">
			<table class="view_tbl mgb_10" >
				<colgroup>
					<col style="width: 15%;"/>
					<col style="width: 37%;"/>
					<col style="width: 15%;"/>
					<col />
					<col style="width: 50px;"/>
				</colgroup>
				<tbody>
				<tr>
					<th><spring:message code='search.art1'/></th>
					<td>
						<input type="text" id="org_lang_ppr_nm" name="orgLangPprNm" class="typeText" style="width: 100%;" class="input2" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/>
					</td>
					<th><spring:message code='search.art3'/></th>
					<td>
						<input type="text" id="stt_date" name="sttDate" class="input2"  maxlength="4" style="width: 80px;"  value="" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();" />
						~ <input type="text" id="end_date" name="endDate" class="input2" maxlength="4" style="width: 80px;" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/>
						<input type="checkbox" name="isAccept" id="is_accept" value="true" class="radio" onchange="javascript:myGrid_load();" />
							<label for="is_accept" class="radio_label"><spring:message code='search.art9'/></label>
					</td>
					<td rowspan="2" class="option_search_td" onclick="javascript:myGrid_load();"><em>search</em></td>
				</tr>
				<tr>
					<th><spring:message code='search.art4'/></th>
					<td colspan="3">
						<input type="radio" id="articleGubun_all" name="articleGubun" class="radio" style="border: 0;" checked="checked" value="" onchange="javascript:myGrid_load();"/>
							<label for="articleGubun_all" title="<spring:message code='search.art5'/>" class="radio_label" ><spring:message code='search.art5'/></label>
						<input type="radio" id="articleGubun_sci" name="articleGubun" class="radio" style="border: 0;" value="sdc_1_2" onchange="javascript:myGrid_load();"/>
							<label for="articleGubun_sci" title="<spring:message code='search.art6'/>" class="radio_label"><spring:message code='search.art6'/></label>
						<input type="radio" id="articleGubun_dm" name="articleGubun" class="radio" style="border: 0;" value="sdc_3_4" onchange="javascript:myGrid_load();"/>
							<label for="articleGubun_dm" title="<spring:message code='search.art7'/>" class="radio_label"><spring:message code='search.art7'/></label>
						<input type="radio" id="articleGubun_ut" name="articleGubun" class="radio" style="border: 0;" value="ut" onchange="javascript:myGrid_load();"/>
							<label for="articleGubun_ut" title="<spring:message code='search.art8'/>" class="radio_label"><spring:message code='search.art8'/></label>
					</td>
				</tr>
				</tbody>
			</table>
			</c:if>
		</form>
		<div class="list_bt_area">
			<div class="list_set">
				<ul>
					<c:if test="${sessionScope.auth.adminDvsCd eq 'M' and (sessionScope.auth.userId eq '1585' or sessionScope.auth.userId eq '28222')}">
						<li><a href="#ridDataUploadDialog" class="modalLink list_icon16">Pub Upload</a></li>
						<li><a href="javascript:void(0);" class="list_icon18" onclick="updateArticleIF()">IF Update</a></li>
						<li><a href="javascript:void(0);" class="list_icon18" onclick="reimportJournalImpactIndex()">저널영향력지수 재반입</a></li>
					</c:if>
					<c:if test="${sessionScope.auth.ART gt 1 }">
						<li><a href="javascript:fn_new();" class="list_icon12"><spring:message code='common.button.new'/></a></li>
					</c:if>
					<c:if test="${sessMode or (sessionScope.auth.adminDvsCd eq 'R' or  sessionScope.auth.adminDvsCd eq 'S' or  sessionScope.auth.adminDvsCd eq 'D' )}">
						<li><a href="#articleExportDialog" class="modalLink list_icon26">Export</a></li>
					</c:if>
					<li><a href="<c:url value='/${preUrl}/statistics/article/article.do'/>" class="list_icon14"><spring:message code='common.button.stats'/></a></li>
				</ul>
			</div>
		</div>
		<!-- layout (grid,paging)  -->
		<div id="mainLayout" style="position: relative; width: 100%;height: 100%;"></div>
		<div id="pagingObj" style="z-index: 1; height: 40px; margin-top: 5px;" >
			<div id="pagingArea" style="z-index: 1;"></div>
		</div>
 	</div>
<form id="findItem" action="<c:url value="/article/article.do"/>" method="post" target="item">
  <input type="hidden" id=userId name="srchUserId" value=""/>
  <input type="hidden" id="item_id" name="item_id" value=""/>
</form>
<c:if test="${sessMode or (sessionScope.auth.adminDvsCd eq 'R' or  sessionScope.auth.adminDvsCd eq 'S' or  sessionScope.auth.adminDvsCd eq 'D' )}">
	<div id="articleExportDialog" class="popup_box modal modal_layer" style="width: 450px;height:500px; display: none;">
	<form id="articleExportFrm">
		<div class="popup_header">
			<h3>Article Export</h3>
			<a href="javascript:voi(0);" id="closeBtn" class="close_bt closeBtn">닫기</a>
		</div>
		<div class="popup_inner">
			<table class="write_tbl mgb_20">
				<colgroup>
					<col style="width:27%;" />
					<col style="width:37%;" />
					<col style="width:37%;" />
				</colgroup>
				<tbody>
					<tr>
						<th><spring:message code="exp.fmt" /></th>
						<td>
							<input type="radio" id="exportFmt_excel" name="exportFmt" value="excel" checked="checked" onclick="fn_expFmtClick($(this))"/>&nbsp;Excel
							<br/><br/>
							<input type="radio" id="exportFmt_endnote" name="exportFmt" value="endnote" onclick="fn_expFmtClick($(this))"/>&nbsp;EndNote
						</td>
						<td style="vertical-align: top;">
							<%--
							<input type="radio" id="exportFmt_excel" name="exportFmt" value="html"/>&nbsp;Html
							<br/><br/>
							 --%>
							<input type="radio" id="exportFmt_endnote" name="exportFmt" value="rtf" onclick="fn_expFmtClick($(this))"/>&nbsp;RTF (word)
						</td>
					</tr>
					<tr>
						<th rowspan="2"><spring:message code="exp.info" /></th>
						<td>
							<input type="radio" id="expInfo_sumry" name="expInfo" value="dtl" checked="checked" onclick="javascript:$('.chk_item').prop('checked',false);$('.detail').prop('disabled',true);$('.sumry').prop('checked',true);" />&nbsp;<spring:message code="exp.dtl" />
						</td>
						<td style="vertical-align: top;">
							<!--
							<input type="radio" id="exportFmt_excel" name="expInfo" value="more" onclick="javascript:$('.chk_item').prop('checked',false);$('.detail').prop('checked',true);"/>&nbsp;<spring:message code="exp.more" />
							 -->
							<input type="radio" id="expInfo_detail" name="expInfo" value="all" onclick="javascript:$('.detail').prop('disabled',false);$('.chk_item').prop('checked',true);"/>&nbsp;<spring:message code="exp.more" />
						</td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" id="resume_art" name="articleTitle" value="Y" class="chk_item sumry" readonly="readonly" checked="checked"/>&nbsp;Title
							<br/><br/>
							<input type="checkbox" id="resume_art" name="pubDate" value="Y" class="chk_item sumry" readonly="readonly" checked="checked"/>&nbsp;Year
							<br/><br/>
							<input type="checkbox" id="resume_art" name="vol" value="Y" class="chk_item sumry" readonly="readonly" checked="checked"/>&nbsp;Volume
							<br/><br/>
							<input type="checkbox" id="resume_art" name="pages" value="Y" class="chk_item sumry" readonly="readonly" checked="checked"/>&nbsp;Pages
							<br/><br/>
							<input type="checkbox" id="resume_art" name="jif" value="Y" class="chk_item sumry" readonly="readonly" checked="checked"/>&nbsp;JIF
							<br/><br/>
							<input type="checkbox" id="resume_art" name="doi" value="Y" class="chk_item detail" readonly="readonly" disabled="disabled"/>&nbsp;DOI
							<br/><br/>
							<input type="checkbox" id="resume_art" name="abstCntn" value="Y" class="chk_item detail" readonly="readonly" disabled="disabled"/>&nbsp;Abstract
						</td>
						<td style="vertical-align: top;">
							<input type="checkbox" id="resume_art" name="authors" value="Y" class="chk_item sumry" readonly="readonly" checked="checked"/>&nbsp;Author(s)
							<br/><br/>
							<input type="checkbox" id="resume_art" name="journalTitle" value="Y" class="chk_item sumry" readonly="readonly" checked="checked"/>&nbsp;Source Title
							<br/><br/>
							<input type="checkbox" id="resume_art" name="issue" value="Y" class="chk_item sumry" readonly="readonly" checked="checked"/>&nbsp;Issue
							<br/><br/>
							<input type="checkbox" id="resume_art" name="issn" value="Y" class="chk_item sumry" readonly="readonly" checked="checked"/>&nbsp;ISSN
							<br/><br/>
							<input type="checkbox" id="resume_art" name="tc" value="Y" class="chk_item sumry" readonly="readonly" checked="checked" />&nbsp;Times Cited
							<br/><br/>
							<input type="checkbox" id="resume_art" name="role" value="Y" class="chk_item detail" readonly="readonly" disabled="disabled"/>&nbsp;Role
							<br/><br/>
							<input type="checkbox" id="resume_art" name="numofauthors" value="Y" class="chk_item detail" readonly="readonly" disabled="disabled"/>&nbsp;No. of Authors
						</td>
					</tr>
					<tr>
						<td colspan="3" style="border-bottom: 0px solid #b1b1b1;">※ <spring:message code="art.exp.cmt"/></td>
					</tr>
				</tbody>
			</table>
			<div class="list_set">
				<ul>
					<li><a href="javascript:fn_export();" class="list_icon25">Download</a></li>
					<li><a href="javascript:$('#articleExportDialog #closeBtn').triggerHandler('click');" class="list_icon10">Cancel</a></li>
				</ul>
			</div>
		</div>
	</form>
	</div>
</c:if>

<c:if test="${sessionScope.auth.adminDvsCd eq 'M' and (sessionScope.auth.userId eq '1585' or sessionScope.auth.userId eq '28222') }">
	<div id="ridDataUploadDialog" class="popup_box modal modal_layer" style="width: 450px;height:250px; display: none;">
		<form id="ridDataUploadFrm">
			<div class="popup_header">
				<h3>Pub Upload</h3>
				<a href="#" id="closeBtn" class="close_bt closeBtn">닫기</a>
			</div>
			<div class="popup_inner">
				<table class="write_tbl mgb_20">
					<colgroup>
						<col style="width:27%;" />
						<col style="width:37%;" />
					</colgroup>
					<tbody>
						<tr>
							<th>대상</th>
							<td>
								<input type="radio" id="trget_range_rsch" name="trget_range" value="rsch" checked="checked" onclick="javascript:$('#trgetUserId').prop('disabled', '').focus();"/>&nbsp;연구자(선택)
								<input type="radio" id="trget_range_all" name="trget_range" value="all" onclick="javascript:$('#trgetUserId').val('').prop('disabled', 'disabled');"/>&nbsp;연구자(전체)
							</td>
						</tr>
						<tr>
							<th>연구자(사번)</th>
							<td>
								<input type="text" name="trgetUserId" id="trgetUserId" class="input_type">
							</td>
						</tr>
						<tr>
							<th>게재년월</th>
							<td>
								<input type="text" id="riddata_stt_date" name="sttDate" class="input2"  maxlength="4" style="width: 80px;"/>
								~ <input type="text" id="riddata_end_date" name="endDate" class="input2" maxlength="4" style="width: 80px;" />
							</td>
						</tr>
					</tbody>
				</table>
				<div class="list_set">
					<ul>
						<li><a href="javascript:fn_uploadArticleToWOS();" class="list_icon25">Upload</a></li>
						<li><a href="javascript:$('#ridDataUploadDialog #closeBtn').triggerHandler('click');" class="list_icon10">Cancel</a></li>
					</ul>
				</div>
			</div>
		</form>
	</div>
</c:if>
</body>
</html>