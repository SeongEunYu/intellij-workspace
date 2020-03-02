<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><spring:message code="menu.asrms.dept.fundingByResearchers"/></title>
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
    $(document).ready(function(){
        fundingByResearchersAjax('0');
    });

    function fundingByResearchersAjax(idx){
        if(!validateRange()){errorMsg(this); return false;}

        $.ajax({
            url:"<c:url value="/analysis/department/fundingByResearchersAjax.do"/>",
            dataType: "json",
            data: $('#frm').serialize(),
            method: "POST",
            beforeLoad: $('.wrap-loading').css('display', '')

        }).done(function(data){

            var $tbody = "";
            if(data.userList.length > 0){

                for(var i=0; i<data.userList.length; i++){
                    var item = data.userList[i];

                    var $tr = '<tr style="height:25px;">';
                    $tr += '<td style="font-size: 10pt;" align="center">'+(i+1)+'</td>';
                    $tr += '<td style="text-align: center;"><span class="breakKeepAll">'+item.korNm+'</span></td>';
                    $tr += '<td style="text-align: center;"><span class="breakKeepAll">'+item.posiNm+'</span></td>';
                    $tr += '<td style="text-align: center;"><span class="breakKeepAll">'+item.deptKorNm+'</span></td>';
                    $tr += '<td style="text-align: center;"><span class="breakKeepAll">'+item.rsrcctSum.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+'</span></td>';
                    $tr += '<td style="text-align: center;"><span class="breakKeepAll">'+item.totRsrcct.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+'</span></td>';
                    $tr += '</tr>';
                    $tbody += $tr;
                }
            }else{
                var $tr = '<tr style="background-color: #ffffff;" height="17px"><td style="font-size: 10pt;" align="center" colspan=6><img src="${contextPath}/images/layout/ico_info.png" /> 검색된 결과가 없습니다.</td></tr>';
                $tbody += $tr;
            }

            $("#publicationsTbl tbody").html($tbody);

            if(data.userList.length > 0){
                if(idx == '0'){
                    $("#publicationsTbl").tablesorter({ sortList:[[4,1]] });
                }else{
                    $("#publicationsTbl th").removeClass('headerSortUp');
                    $("#publicationsTbl th").removeClass('headerSortDown');
                    $("#publicationsTbl th").eq(4).addClass('headerSortUp');
                }

                $("#publicationsTbl").trigger("update");

                $("#publicationsTbl").bind("sortStart",function() {
                    var artTr = $('#publicationsTbl > tbody > tr');
                    for(var i=0; i < artTr.length; i++){
                        artTr.eq(i).children('td:first').text('');
                    }
                }).bind("sortEnd",function() {
                    var artTr = $('#publicationsTbl > tbody > tr');
                    for(var i=0; i < artTr.length; i++){
                        artTr.eq(i).children('td:first').text(i+1);
                    }
                });
            }

            $('#fromYear').data('prev', $('#fromYear').val());
            $('#toYear').data('prev', $('#toYear').val());

            $('.wrap-loading').css('display', 'none');
        });
    }

    function exportExcel(){

	 var table = $('<table></table>');
	 //append document title
	 var docTitle = $('<tr><td style="text-align:center;"><h1><p>Department - '+$('.page_title').html()+'</p></h1></td></tr>');
	 table.append(docTitle);
	 //make table with data of checked researcher
	 table.append($('<tr><td>'+$('#publicationsTbl').clone().wrapAll('<div/>').parent().html()+'</td></tr>'));
	 $('#tableHTML').val(table.wrapAll('<div/>').parent().html());
	 var excelFileName = "fundingByResearchers_from_" + $('#fromYear').val() +"_to_" + $('#toYear').val() + ".xls";
	 $('#fileName').val(excelFileName);
	 exportLog($('#frm'), excelFileName);
	 $('#excelFrm').submit();
 }

   </script>
</head>
<body>
<h3 class="page_title"><spring:message code="menu.asrms.dept.fundingByResearchers"/></h3>
<div class="help_text mgb_30"><spring:message code="asrms.department.fundingByResearchers.desc"/></div>

<form id="frm" name="frm">
	<input type="hidden" id="topNm" name="topNm" value="${topNm}"/>
	<input type="hidden" name="deptKor" id="deptKor" value="${parameter.deptKor}"/>
	<input type="hidden" name="trackId" id="trackId" value="${parameter.trackId}"/>


	<div class="top_option_box">
		<div class="to_inner">
			<span>재직구분</span>
			<em>
				<select name="hldofYn" id="hldofYn">
					<option value="ALL">전체</option>
					<option value="1" selected="selected">재직</option>
					<option value="2">퇴직</option>
				</select>
			</em>
			<span>신분구분</span>
			<em>
				<select name="isFulltime" id="isFulltime">
					<option value="ALL">전체</option>
					<option value="M" selected="selected">전임</option>
					<option value="U">비전임</option>
				</select>
			</em>
			<span>계약기간</span>
			<em>
				<select name="fromYear" id="fromYear">
					<c:forEach var="yl" items="${rsrcctContYrList}" varStatus="idx">
						<option value="${yl.rsrcctContYr }" ${idx.index == 5 ? 'selected="selected"' : '' }>${yl.rsrcctContYr }</option>
					</c:forEach>
				</select>
			</em>
			~
			<em>
				<select name="toYear" id="toYear">
					<c:forEach var="yl" items="${rsrcctContYrList}" varStatus="idx">
						<option value="${yl.rsrcctContYr }">${yl.rsrcctContYr }</option>
					</c:forEach>
				</select>
			</em>
			<p style="margin-top: 5px;">
				<span>목록수</span>
				<em>
					<select name="rownum">
						<option value="ALL">전체</option>
						<option value="20" selected="selected">20</option>
						<option value="50">50</option>
					</select>
				</em>
			</p>
		</div>
		<p class="ts_bt_box">
			<a href="javascript:fundingByResearchersAjax();" class="to_search_bt"><span>Search</span></a>
		</p>
	</div>

	<p class="bt_box mgb_20"><a href="#" onclick="exportExcel();" class="black_bt"><em class="export_icon">Export</em></a></p>

	<table width="100%" id="publicationsTbl" class="list_tbl mgb_20">
		   <colgroup>
			 <col style="width: 7%"/>
			 <col style="width: 15%"/>
			 <col style="width: 15%"/>
			 <col style="width: 15%"/>
			 <col style="width: 15%"/>
			 <col style="width: 40%"/>
		   </colgroup>
			<thead>
				<tr style="height: 25px;">
					<th><span>NO</span></th>
					<th><span>성명</span></th>
					<th><span>직급</span></th>
					<th><span>학(부)과</span></th>
					<th><span>건수</span></th>
					<th><span>총 금액</span></th>
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
