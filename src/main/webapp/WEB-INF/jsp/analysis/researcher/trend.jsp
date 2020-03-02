<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><spring:message code="menu.asrms.rsch.cited"/></title>
<style type="text/css" rel="stylesheet">
th.header {
    cursor: pointer;
    background-repeat: no-repeat;
    background-position: center right;
    padding-right: 13px;
    margin-right: -1px;
}
</style>
<script type="text/javascript" src="${contextPath}/js/jquery/jquery.tablesorter.min.js"></script>
<script>

$(document).ready(function(){
    trendAjax('0');
});

function trendAjax(idx){
    if(!validateRange()){errorMsg(this); return false;}

    $.ajax({
        url:"<c:url value="/analysis/researcher/trendAjax.do"/>",
        dataType: "json",
        data: $('#frm').serialize(),
        method: "POST",
        beforeLoad: $('.wrap-loading').css('display', '')

    }).done(function(data){

        if(FusionCharts('ChartId1')) {
            FusionCharts('ChartId1').dispose();
            $('#chartdiv1').disposeFusionCharts().empty();
        }

        new FusionCharts({
            id: 'ChartId1',
            type:'StackedColumn2D',
            renderAt:'chartdiv1',
            width:'100%',
            height:'350',
            dataFormat:'xml',
            dataSource:data.chartXML+""
        }).render();
        $('#publicationsTbl > tbody').empty();
		makeArticleList(data.articleList);

		if(data.articleList.length > 0){
			$("#publicationsTbl th").removeClass('headerSortUp');
			$("#publicationsTbl th").removeClass('headerSortDown');
			$("#publicationsTbl th").eq(2).addClass('headerSortUp');

			$("#publicationsTbl").trigger("update");
		}

        $('#fromYear').data('prev', $('#fromYear').val());
        $('#toYear').data('prev', $('#toYear').val());

        $('.wrap-loading').css('display', 'none');

		if(idx == '0'){
			$("#publicationsTbl").tablesorter();
		}
    });
}

 function clickChart(args){

	 var param = args.split(";");
	 var isCited = param[0];
	 var year = param[1];

	 $('#list_title').text('Publication ( '+year+' - '+isCited+' )');
	 $('#publicationsTbl > tbody').empty();

	 $.ajax({
		 url : "${contextPath}/analysis/researcher/findArticleListByUserIdAjax.do",
		 dataType : 'json',
		 data : { "selectedYear":year,
			      "userId": $('#userId').val(),
			      "fromYear": $('#fromYear').val(),
			      "toYear": $('#toYear').val(),
			      "gubun" : $('#gubun').val(),
			      "isCited" : isCited,
			      "topNm" : '${parameter.topNm}'
			     },
		 success : function(data, textStatus, jqXHR){
             makeArticleList(data);
             $("#publicationsTbl").trigger("update");
		 }
	 }).done(function(){});

 }

function makeArticleList(data){

    var thHtml = $('#excelExportDiv > table > tbody > tr').eq(0).html()
    $('#excelExportDiv').empty();
    $('#excelExportDiv').append($('<table class="list_tbl mgb_20"><tr>'+thHtml+'</tr></table>'));

    for(var i=0; i < data.length; i++){

        var seqno = data[i].articleId;
        var esubject = data[i].orgLangPprNm == null ? '' : data[i].orgLangPprNm;
        var authors = data[i].authors == null ? '' : data[i].authors;
        var publisher = data[i].pblcPlcNm == null ? '' : data[i].pblcPlcNm;
        var magazine = data[i].scjnlNm == null ? '' : data[i].scjnlNm;
        var vol = data[i].volume == null ? '' : 'v.' + data[i].volume;
        var no = data[i].issue == null ? '' : 'no.' + data[i].issue;
        var strpage = data[i].sttPage == null ? '' : data[i].sttPage;
        var endpage = data[i].endPage == null ? '' : data[i].endPage;
        var issueDate = data[i].pblcYm == null ? '' : dateFormat(data[i].pblcYm);
        var impctFctr = data[i].impctFctr == null ? '' : data[i].impctFctr;
        var sciTc = data[i].tc == null ? '0' : data[i].tc;
        var scpTc = data[i].scpTc == null ? '0' : data[i].scpTc;
        var kciTc = data[i].kciTc == null ? '0' : data[i].kciTc;
        var tc = "";
        if($('#gubun').val() == 'SCI') tc = sciTc;
        else if($('#gubun').val() == 'SCOPUS') tc = scpTc;
        else if($('#gubun').val() == 'KCI') tc = kciTc;

        var $tr = $('<tr style="height:17px;"></tr>');
        $tr.append($('<td style="font-size: 10pt;" align="center" width="40">'+(i+1)+'</td>'));
        var $td = $('<td class="link_td" style="font-size: 10pt;"></td>').append($('<div class="style_12pt"><a href="javascript:popArticle('+seqno+')"><b>'+esubject+'</b></a></div>'));
        var content = '<span>'+authors + '&nbsp;('+publisher+',&nbsp;' + magazine+',&nbsp;'+vol+',&nbsp;'+no+',&nbsp; pp.'+strpage+'~'+endpage+',&nbsp;'+issueDate+')&nbsp;</span>';
        $td.append(content);
        $tr.append($td);
        $tr.append($('<td class="center">'+tc+'</td>'));
        $('#publicationsTbl > tbody').append($tr);

        //create table for excel export
        var eTr = $('<tr style="height:100%;"></tr>');
        eTr.append($('<td style="text-align:center;font-size: 10pt;" width="40">'+(i+1)+'</td>'));
        eTr.append($('<td style="text-align:left;font: normal 12px \'Malgun Gothic\';"><b>'+esubject+'</b></td>'));
        eTr.append($('<td style="text-align:left;font: normal 12px \'Malgun Gothic\';">'+authors+'</td>'));
        eTr.append($('<td style="text-align:left;font: normal 12px \'Malgun Gothic\';">'+publisher+'</td>'));
        eTr.append($('<td style="text-align:left;font: normal 12px \'Malgun Gothic\';">'+magazine+'</td>'));
        eTr.append($('<td style="text-align:left;font: normal 12px \'Malgun Gothic\';">'+vol+'</td>'));
        eTr.append($('<td style="text-align:left;font: normal 12px \'Malgun Gothic\';">'+no+'</td>'));
        eTr.append($('<td style="text-align:left;font: normal 12px \'Malgun Gothic\';">'+strpage+'</td>'));
        eTr.append($('<td style="text-align:left;font: normal 12px \'Malgun Gothic\';">'+endpage+'</td>'));
        eTr.append($('<td style="text-align:center;font: normal 12px \'Malgun Gothic\';">'+impctFctr+'</td>'));
        eTr.append($('<td style="text-align:center;font: normal 12px \'Malgun Gothic\';">'+sciTc+'</td>'));
        eTr.append($('<td style="text-align:center;font: normal 12px \'Malgun Gothic\';">'+scpTc+'</td>'));
        eTr.append($('<td style="text-align:center;font: normal 12px \'Malgun Gothic\';">'+kciTc+'</td>'));
        eTr.append($('<td style="text-align:left; font: normal 12px \'Malgun Gothic\';">'+issueDate+'</td>'));
        $('#excelExportDiv > table').append(eTr);

    }
    if(data.length == 0){
        var $tr = "<tr style='background-color: #ffffff;' height='17px'>";
        $tr += '<td colspan=99><img src="${contextPath}/images/layout/ico_info.png" /> There is no Article.</td></tr>';
        $('#publicationsTbl > tbody').append($tr);
    }
    //alert(data[0].ESUBJECT);
}
//Callback handler method which is invoked after the chart has saved image on server.
 function myFN(objRtn){
	if (objRtn.statusCode=="1"){
		saveExcel(objRtn.fileName);
		//alert("The chart was successfully saved on server. The file can be accessed from " + objRtn.fileName);
	}else{
		alert("The chart could not be saved on server. There was an error. Description : " + objRtn.statusMessage);
	}
 }
 function exportExcel(){

	 var chartObject = getChartFromId('ChartId1');

	 if( chartObject.hasRendered() ) chartObject.exportChart( { exportFormat : 'png'} );
 }
 function saveExcel(fileName){
	 var div = $('<div></div>');
	 var table = $('<table></table>');
	 //append document title
	 var pageTitle = $('<tr><td style="text-align:center;" colspan="5"><h1><p>Researcher(${item.korNm}) - '+$('.page_title').html()+'</p></h1></td></tr>');
	 //append chart image
	 var chartTr = $('<tr><td><img src="'+fileName+'" height="350" /></td></tr>');
	 var dataTbl = $('<tr><td><h1>Data</h1></td></tr><tr><td>'+$('#excelExportDiv > table').clone().wrapAll('<div/>').parent().html()+'</td></tr>');
	 table.append(pageTitle)
	 .append(chartTr)
	 .append(dataTbl);
	 div.append(table);
	 $('#tableHTML').val(div.html());
	 var excelFileName = "Cited-vs-Uncited_"+$('#gubun').val() + "_from_" + $('#fromYear').val() +"_to_" + $('#toYear').val() + ".xls";
	 $('#fileName').val(excelFileName);
	 exportLog($('#frm'), excelFileName + "|" +  fileName);
	 $('#excelFrm').submit();
 }
</script>
</head>
<body>
	<!-- content -->
	<form id="frm" name="frm">
	<input type="hidden" id="topNm" name="topNm" value="<c:out value="${topNm}"/>"/>
	<input type="hidden" name="userId" id="userId" value="<c:out value="${parameter.userId}"/>"/>
	<input type="hidden" name="mode" id="mode" value="<c:out value="${parameter.mode}"/>"/>
	<input type="hidden" name="srchUserId" id="srchUserId" value="<c:out value="${parameter.srchUserId}"/>"/>
	<input type="hidden" name="srchUserPhotoUrl" id="srchUserPhotoUrl" value="<c:out value="${parameter.srchUserPhotoUrl}"/>"/>

	<h3 class="page_title"><spring:message code="menu.asrms.rsch.cited"/></h3>
	<div class="help_text mgb_30"><spring:message code="asrms.researcher.cited.uncited.desc"/></div>

	<div class="top_option_box">
		<div class="to_inner">
			<span><spring:message code="asrms.researcher.publications.classification" /></span>
			<em>
				<select name="gubun" id="gubun">
					<option value="SCI">SCI</option>
					<option value="SCOPUS">SCOPUS</option>
					<option value="KCI">KCI</option>
				</select>
			</em>
			<span><spring:message code="asrms.researcher.publications.yearrange" /></span>
			<em>
				<select name="fromYear" id="fromYear">
					<c:forEach var="yl" items="${pubYearList}" varStatus="idx" end="50">
						<c:choose>
							<c:when test="${fn:length(pubYearList) > 5}">
								<option value="${yl.pubYear }" ${idx.index == 5 ? 'selected="selected"' : '' }>${yl.pubYear }</option>
							</c:when>
							<c:otherwise>
								<option value="${yl.pubYear }" ${idx.last == true? 'selected="selected"' : '' }>${yl.pubYear }</option>
							</c:otherwise>
						</c:choose>
					</c:forEach>
				</select>
			</em>
			~
			<em>
				<select name="toYear" id="toYear">
					<c:forEach var="yl" items="${pubYearList}" varStatus="idx" end="50">
						<option value="${yl.pubYear }">${yl.pubYear }</option>
					</c:forEach>
				</select>
			</em>
		</div>

		<p class="ts_bt_box">
			<a href="javascript:trendAjax();" class="to_search_bt"><span>Search</span></a>
		</p>
	</div>

	<h3 class="circle_h3">Chart</h3>

	<div id="chartdiv1" class="chart_box mgb_10"></div>

	<p class="bt_box mgb_10"><a href="#" onclick="exportExcel();" class="black_bt"><em class="export_icon">Export</em></a></p>

	<h3 class="circle_h3" id="list_title">Publication</h3>

	<table width="100%" id="publicationsTbl" class="list_tbl mgb_20">
		<colgroup>
			<col style="width: 10%"/>
			<col style="width: 75%"/>
			<col style="width: 15%"/>
		</colgroup>
		<thead>
		<tr>
			<th><span>NO</span></th>
			<th><span>Article</span></th>
			<th><span>Cited</span></th>
		</tr>
		</thead>
		<tbody></tbody>
	</table>
</form>

<form id="excelFrm" method="post" action="${contextPath}/jsp/excelExport.jsp">
      <input type="hidden" id="tableHTML" name="tableHTML" value="" />
      <input type="hidden" id="fileName" name="fileName" value="trends.xls" />
      <div style="display: none;" id="excelExportDiv" class="tabl_datos">
      	<table class="list_tbl mgb_20">
      		<tr>
      			<th><span>No</span></th>
      			<th><span>Title</span></th>
      			<th><span>Authors</span></th>
      			<th><span>Publisher</span></th>
      			<th><span>Journal</span></th>
      			<th><span>Volume</span></th>
      			<th><span>Issue</span></th>
      			<th><span>startPage</span></th>
      			<th><span>endPage</span></th>
      			<th><span>Imapct Factor</span></th>
      			<th><span>TC(SCI)</span></th>
      			<th><span>TC(SCOPUS)</span></th>
      			<th><span>TC(KCI)</span></th>
      			<th><span>IssueDate</span></th>
      		</tr>
		</table>
      </div>
      <!--
      <input type="button" onclick="gotoExcel('tableData', 'tableHTML');" value="Export these results" />
       -->
</form>
</body>
</html>
