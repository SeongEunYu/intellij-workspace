<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><spring:message code="menu.asrms.clg.latest"/></title>
<style type="text/css" rel="stylesheet">
	.to_inner span {min-width: 70px;}
</style>
<script>

$(function() {
	latestArticlesAjax();
});

function latestArticlesAjax(){
    $.ajax({
        url:"<c:url value="/analysis/college/latestArticlesAjax.do"/>",
        dataType: "json",
        data: $('#frm').serialize(),
        method: "POST",
        beforeLoad: $('.wrap-loading').css('display', '')

    }).done(function(data){

        var $tbody = "";
        var $tbody2 = "";
        for(var i=0; i<data.lastedArtList.length; i++){
            var $tr = "<tr>";
            var item = data.lastedArtList[i];
            var volume = item.volume != null ? 'v.'+item.volume : '' ;
            var issue = item.issue != null ? 'no.'+item.issue : '' ;

            var pblcYm = item.pblcYm.length == 4 ? item.pblcYm : item.pblcYm.length == 6 ?item.pblcYm.substring(0,4)+'.'+item.pblcYm.substring(4,6) : item.pblcYm.length == 8 ? item.pblcYm.substring(0,4)+'.'+item.pblcYm.substring(4,6)+'.'+item.pblcYm.substring(6,8) : '';

            $tr += '<td width="35" class="center">'+ (i+1) +'</td>';
            $tr += '<td class="link_td">';
            $tr += '<div><a href="javascript:popArticle(\''+item.articleId+'\');"><b>'+item.orgLangPprNm+'</b></a></div>';
            $tr += '<span>'+(item.authors != null ? item.authors : '') +'&nbsp;( ';
            if(item.pblcPlcNm != '') $tr += item.pblcPlcNm +',&nbsp;';
            $tr += item.scjnlNm+',&nbsp;'+volume+',&nbsp;'+issue+',&nbsp;pp.'+item.sttPage+'~'+item.endPage+',&nbsp;'+pblcYm+' )';
            $tr += "</tr>";

            $tbody += $tr;

            var $tr2 = '<tr style="height: 100%">';

            $tr2 += '<td style="text-align:center;font-size: 10pt;">'+ (i+1) +'</td>';
            $tr2 += '<td style="text-align:left;font: normal 12px"><b>'+item.orgLangPprNm+'</b></td>';
            $tr2 += '<td style="text-align:left;font: normal 12px"><b>'+(item.authors != null ? item.authors : '')+'</b></td>';
            $tr2 += '<td style="text-align:left;font: normal 12px"><b>'+item.pblcPlcNm+'</b></td>';
            $tr2 += '<td style="text-align:left;font: normal 12px"><b>'+item.scjnlNm+'</b></td>';
            $tr2 += '<td style="text-align:left;font: normal 12px"><b>'+volume+'</b></td>';
            $tr2 += '<td style="text-align:left;font: normal 12px"><b>'+issue+'</b></td>';
            $tr2 += '<td style="text-align:left;font: normal 12px"><b>'+(item.sttPage != null ? item.sttPage : '')+'</b></td>';
            $tr2 += '<td style="text-align:left;font: normal 12px"><b>'+(item.endPage != null ? item.endPage : '')+'</b></td>';
            $tr2 += '<td style="text-align:center;font: normal 12px"><b>'+(item.impctFctr != null ? item.impctFctr : '')+'</b></td>';
            $tr2 += '<td style="text-align:center;font: normal 12px"><b>'+(item.tc != null ? item.tc : '')+'</b></td>';
            $tr2 += '<td style="text-align:center;font: normal 12px"><b>'+(item.scpTc != null ? item.scpTc : '')+'</b></td>';
            $tr2 += '<td style="text-align:left;font: normal 12px"><b>'+pblcYm+'</b></td>';
            $tr2 += "</tr>";

            $tbody2 += $tr2;
        }

        if(data.lastedArtList.length == 0){
            var $tr = '<tr><td><img src="${contextPath}/images/layout/ico_info.png" /> 검색된 논문이 없습니다.</td></tr>';
            var $tr2 = '<tr style="background-color: #ffffff;" height="17px"><td style="font-size: 10pt;" align="center" colspan="13"> 검색된 논문이 없습니다.</td></tr>';

            $tbody += $tr;
            $tbody2 += $tr2;
        }

        $("#publicationsTbl tbody").html($tbody);
        $("#excelExportDiv tbody").html($tbody2);

        $('.wrap-loading').css('display', 'none');
    });
}

function exportExcel(){

	var table = $('<table></table>');
	//append document title
	var docTitle = $('<tr><td style="text-align:center;"><h1><p>College(${item.codeDisp}) - '+$('.page_title').html()+'</p></h1></td></tr>');
	table.append(docTitle);
	//make table with data of checked researcher
	table.append($('<tr><td>'+$('#excelExportDiv > table').clone().wrapAll('<div/>').parent().html()+'</td></tr>'));
	$('#tableHTML').val(table.wrapAll('<div/>').parent().html());
	var excelFileName = "CollegeLatestArticles_"+$('#gubun').val() + ".xls";
	$('#fileName').val(excelFileName);
	exportLog($('#frm'), excelFileName);
	$('#excelFrm').submit();
}
</script>
</head>
<body>
	<h3 class="page_title"><spring:message code="menu.asrms.clg.latest"/></h3>
	<div class="help_text mgb_30"><spring:message code="asrms.college.latest.article.desc"/></div>

	<form id="frm" name="frm">
	<input type="hidden" name="clgCd" id="clgCd" value="<c:out value="${parameter.clgCd}"/>"/>
	<input type="hidden" id="topNm" name="topNm" value="<c:out value="${topNm}"/>"/>
			<!--START page_title-->

	<!--START page_function-->
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
			<span>신분</span>
			<em>
				<select name="isFulltime" id="isFulltime">
					<option value="ALL">전체</option>
					<option value="M" selected="selected">전임</option>
					<option value="U">비전임</option>
				</select>
			</em>
			<span>학술지구분</span>
			<em>
				<select name="gubun" id="gubun">
					<option value="ALL">전체</option>
					<option value="SCI">SCI</option>
					<option value="SCOPUS">SCOPUS</option>
					<option value="KCI">KCI</option>
				</select>
			</em>
			<span>실적구분</span>
			<em>
				<select name="insttRsltAt" id="insttRsltAt">
					<option value="">전체</option>
					<option value="Y">${sysConf['inst.abrv']}</option>
					<option value="N">타기관</option>
				</select>
			</em>
			<span>목록수</span>
			<em>
				<select name="rownum" id="rownum">
					<option value="10">10</option>
					<option value="50">50</option>
					<option value="100">100</option>
				</select>
			</em>
		</div>

		<p class="ts_bt_box">
			<a href="javascript:latestArticlesAjax();" class="to_search_bt"><span>Search</span></a>
		</p>
	</div>

	<p class="bt_box mgb_10"><a href="#" onclick="exportExcel();" class="black_bt"><em class="export_icon">Export</em></a></p>

	<!--START sub_content_wrapper-->
	<div class="sub_content_wrapper" style="width: 100%;overflow: auto;">
		<table width="100%" id="publicationsTbl" class="list_tbl mgb_20">
			<thead>
				<tr>
					<th><span>No</span></th>
					<th><span>Article</span></th>
				</tr>
			</thead>
			<tbody></tbody>
			</table>
	</div>
	</form>

<form id="excelFrm" method="post" action="${contextPath}/jsp/excelExport.jsp">
      <input type="hidden" id="tableHTML" name="tableHTML" value="" />
      <input type="hidden" id="fileName" name="fileName" value="publication.xls" />
      <div style="display: none;" id="excelExportDiv">
      	<table class="list_tbl mgb_20">
			<thead>
      		<tr>
      			<th><span>No</span></th>
      			<th><span>Title</span></th>
      			<th><span>Authors</span></th>
      			<th><span>Publisher</span></th>
      			<th><span>Journal</span></th>
      			<th><span>Volume</span></th>
      			<th><span>Issue</span></th>
      			<th><span>StartPage</span></th>
      			<th><span>EndPage</span></th>
      			<th><span>Imapct Factor</span></th>
      			<th><span>TC(SCI)</span></th>
      			<th><span>TC(SCOPUS)</span></th>
      			<th><span>IssueDate</span></th>
      		</tr>
			</thead>
			<tbody></tbody>
      	</table>
      </div>
      <!--
      <input type="button" onclick="gotoExcel('tableData', 'tableHTML');" value="Export these results" />
       -->
</form>
<div id="exportDiv" style="display: none;"></div>
</body>
</html>
