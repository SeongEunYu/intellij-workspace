<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title><spring:message code="menu.asrms.dept.patentByResearchers2"/></title>
<script type="text/javascript" src="${contextPath}/js/jquery/jquery.tablesorter.min.js"></script>

<style type="text/css" rel="stylesheet">
th.header {
    cursor: pointer;
    background-repeat: no-repeat;
    background-position: center right;
    padding-right: 13px;
    margin-right: -1px;
}
</style>
<script>
$.tablesorter.addParser({
	// set a unique id
	id: 'numFmt',
	is: function(s) {
		// return false so this parser is not auto detected
		return false;
	},
	format: function(s) {
		return NumberWithoutComma(s);
	},
	// set type, either numeric or text
	type: 'numeric'
});
 function exportExcel(){

	 var table = $('<table></table>');
	 //append document title
	 var docTitle = $('<tr><td style="text-align:center;"><h1><p>Department - '+$('.page_title').html()+'</p></h1></td></tr>');
	 table.append(docTitle);
	 //make table with data of checked researcher
	 table.append($('<tr><td>'+$('#patentTbl').clone().wrapAll('<div/>').parent().html()+'</td></tr>'));
	 $('#tableHTML').val(table.wrapAll('<div/>').parent().html());
	 var excelFileName = "patentByResearchers_from_" + $('#fromYear').val() +"_to_" + $('#toYear').val() + ".xls";
	 $('#fileName').val(excelFileName);
	 exportLog($('#frm'), excelFileName);
	 $('#excelFrm').submit();
 }

 $(document).ready(function(){
     $("#acqsDvsCd option").eq(0).remove();
     patentByResearchersAjax('0');
 });


 function patentByResearchersAjax(idx){
     if(!validateRange()){errorMsg(this); return false;}

     $.ajax({
         url:"<c:url value="/analysis/department/patentByResearchersAjax.do"/>",
         dataType: "json",
         data: $('#frm').serialize(),
         method: "POST",
         beforeLoad: $('.wrap-loading').css('display', '')

     }).done(function(data){
         $('#fromYear').data('prev', $('#fromYear').val());
         $('#toYear').data('prev', $('#toYear').val());

         var $tbody = "";
         for (var i = 0; i < data.userList.length; i++) {
             var item = data.userList[i];
             var $tr = '<tr style="height:25px;">';
             $tr += '<td style="font-size: 10pt;" align="center">'+(i+1)+'</td>';
             $tr += '<td style="text-align: center;"><span class="breakKeepAll">'+item.korNm+'</span></td>';
             $tr += '<td style="text-align: center;"><span class="breakKeepAll">'+item.posiNm+'</span></td>';
             $tr += '<td style="text-align: center;"><span class="breakKeepAll">'+item.deptKorNm+'</span></td>';
             $tr += '<td style="text-align: center;"><span class="breakKeepAll">'+item.patentCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+'</span></td>';
             $tr += '</tr>';
             $tbody += $tr;
         }

         if(data.userList.length == 0){
             var  $tr = '<tr style="background-color: #ffffff;" height="17px"><td style="font-size: 10pt;" align="center" colspan=5><img src="${contextPath}/images/layout/ico_info.png" />검색된 결과가 없습니다.</td></tr>';
             $tbody += $tr;
         }

         $("#patentTbl tbody").html($tbody);

		 if(data.userList.length > 0){
			 if(idx == '0'){
				 $("#patentTbl").tablesorter({
					 sortList:[[4,1]],
					 headers: {
						 0: { sorter: false },
						 5: { sorter:'numFmt'},
					 }
				 });
			 }else{
				 $("#patentTbl th").removeClass('headerSortUp');
				 $("#patentTbl th").removeClass('headerSortDown');
				 $("#patentTbl th").eq(4).addClass('headerSortUp');
			 }


			 $("#patentTbl").trigger("update");

			 $("#patentTbl").bind("sortStart",function() {
				 var artTr = $('#patentTbl > tbody > tr');
				 for(var i=0; i < artTr.length; i++){
					 artTr.eq(i).children('td:first').text('');
				 }
			 }).bind("sortEnd",function() {
				 var artTr = $('#patentTbl > tbody > tr');
				 for(var i=0; i < artTr.length; i++){
					 artTr.eq(i).children('td:first').text(i+1);
				 }
			 });
		 }

         $('.wrap-loading').css('display', 'none');
     });
 }

 function acqsChange(){
     if($("#acqsDvsCd").val() == "1"){
         $("#status").parent().css("display","none");
     }else{
         $("#status").parent().css("display","");
     }
 }
</script>
</head>
<body>
<h3 class="page_title"><spring:message code="menu.asrms.dept.patentByResearchers2"/></h3>
<div class="help_text mgb_30"><spring:message code="asrms.department.patentByResearchers2.desc"/></div>

<form id="frm" name="frm">
	<input type="hidden" id="topNm" name="topNm" value="${topNm}"/>
	<input type="hidden" name="trackId" id="trackId" value="${parameter.trackId}"/>
	<input type="hidden" name="deptKor" id="deptKor" value="${parameter.deptKor}"/>

	<div class="top_option_box">
		<div class="to_inner">
			<span>취득구분</span>
			<em>
				<select name="acqsDvsCd" id="acqsDvsCd" onchange="javascript:acqsChange();">${rims:makeCodeList('1090',true,parameter.acqsDvsCd)}</select>
			</em>
			<em style="display:none;">
				<select name="status" id="status" mode="checkbox">${rims:makeCodeList('patent.status',true,parameter.status)}</select>
			</em>
			<span>신분구분</span>
			<em>
				<select name="isFulltime" id="isFulltime">
					<option value="ALL">전체</option>
					<option value="M" selected="selected">전임</option>
					<option value="U">비전임</option>
				</select>
			</em>
			<span>실적구분</span>
			<em>
				<select name="insttRsltAt" id="insttRsltAt">
					<option value="ALL">전체</option>
					<option value="Y">${sysConf['inst.abrv']}</option>
					<option value="N">타기관</option>
				</select>
			</em>

			<span>목록수</span>
			<em>
				<select name="rownum">
					<option value="ALL">전체</option>
					<option value="20" selected="selected">20</option>
					<option value="50">50</option>
				</select>
			</em>
			<p style="margin-top: 5px;">
				<span>재직구분</span>
				<em>
					<select name="hldofYn" id="hldofYn">
						<option value="ALL">전체</option>
						<option value="1" selected="selected">재직</option>
						<option value="2">퇴직</option>
					</select>
				</em>
				<span>실적기간</span>
				<em>
					<select name="fromYear" id="fromYear">
						<c:forEach var="yl" items="${patentYearList}" varStatus="idx" end="50">
							<option value="${yl.patYear }" ${idx.index == 5 ? 'selected="selected"' : '' }>${yl.patYear }</option>
						</c:forEach>
					</select>
				</em>
				~
				<em>
					<select name="toYear" id="toYear">
						<c:forEach var="yl" items="${patentYearList}" varStatus="idx" end="50">
							<option value="${yl.patYear }">${yl.patYear }</option>
						</c:forEach>
					</select>
				</em>
			</p>
		</div>

		<p class="ts_bt_box">
			<a href="javascript:patentByResearchersAjax();" class="to_search_bt"><span>Search</span></a>
		</p>
	</div>

	<p class="bt_box mgb_20"><a href="#" onclick="exportExcel();" class="black_bt"><em class="export_icon">Export</em></a></p>

	<table width="100%" id="patentTbl" class="list_tbl mgb_20">
		<thead>
			<tr style="height: 25px;">
				<th><span>NO</span></th>
				<th><span>성명</span></th>
				<th><span>직급</span></th>
				<th><span>학(부)과</span></th>
				<th><span>건수</span></th>
			</tr>
		</thead>
		<tbody></tbody>
	</table>
</form>
<form id="excelFrm" method="post" action="${contextPath}/jsp/excelExport.jsp">
      <input type="hidden" id="tableHTML" name="tableHTML" value="" />
      <input type="hidden" id="fileName" name="fileName" value="publication.xls" />
      <!--
      <input type="button" onclick="gotoExcel('tableData', 'tableHTML');" value="Export these results" />
       -->
</form>
<div id="exportDiv" style="display: none;"></div>
</body>
</html>
