<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><spring:message code="menu.asrms.dept.journal.page"/></title>
<LINK rel=stylesheet type=text/css	href="${contextPath}/css/jquery/fixedheader.css">
<script type="text/javascript" src="${contextPath}/js/jquery/jquery.fixedheadertable.min.js"></script>
 <style>
.select_row {
	background: #fee79a !important;
}
 </style>
 <script type="text/javascript">
$(document).ready(function(){

	$('#info_tbl').fixedHeaderTable({ footer: false, cloneHeadToFoot: true, fixedColumn: false });
	$('#sbjt_tbl').fixedHeaderTable({ footer: false, cloneHeadToFoot: true, fixedColumn: false });
	
    journalAjax();

    $('.fht-table').css('width','100%');
    bindModalLink();
});

function journalAjax(){
    if(!validateRange()){errorMsg(this); return false;}

    $.ajax({
        url:"<c:url value="/analysis/department/journalAjax.do"/>",
        dataType: "json",
        data: $('#frm').serialize(),
        method: "POST",
        beforeLoad: $('.wrap-loading').css('display', '')

    }).done(function(data){
		if($("#gubun").val() == 'SCI'){
		    $("#indicator_th").html('Impact<br/>Factor');
		}else if($("#gubun").val() == 'SCOPUS'){
		    $("#indicator_th").html('SJR');
		}else if($("#gubun").val() == 'KCI'){
		    $("#indicator_th").html('KCI IF');
		}

        if(FusionCharts('ChartId1')) {
            FusionCharts('ChartId1').dispose();
            $('#chartdiv1').disposeFusionCharts().empty();
        }

        new FusionCharts({
            id:'ChartId1',
            type:'Pie2D',
            renderAt:'chartdiv1',
            width:'100%',
            height:'350',
            dataFormat:'xml',
            dataSource:data.chartXML
        }).render();
        
        var $tbody = "";
        for(var i=0; i<data.journalList.length; i++){
            var jl = data.journalList[i];

            var $tr = '<tr style="height:17px;cursor: pointer;">';
            $tr += '<td style="text-align: center;">'+(i+1)+'</td>';
            $tr += '<td style="text-align: left;"><span class="breakKeepAll">'+jl.title+'</span></td>';
            $tr += '<td style="text-align: center;">'+jl.issnNo+'</td>';
            $tr += '<td style="text-align: center;"><a href="#dialog" class="modalLink" onclick="javacript:clickNoPublications(\''+jl.issnNo+'\');">'+jl.artsCo+'</a></td>';
            $tr += '<td style="text-align: center;">'+jl.userCo+'</td>';
            $tr += "</tr>";
            $tbody += $tr;
        }

        if(data.journalList.length == 0){
            var $tr = '<tr><td colspan="5"><img src="${contextPath}/images/layout/ico_info.png" /> 검색된 논문이 없습니다.</td></tr>';
            $tbody += $tr;
        }

        $("#journalTbl tbody").html($tbody);

        var jtHeight =parseInt($('#journalTbl').height(),10);
        var infoHeight = jtHeight*0.5;

        //if(jtHeight < 415) infoHeight = 270;
        var sbjtHeight = parseInt(jtHeight, 10) - infoHeight -27;

        $('#info_tbl').fixedHeaderTable({ height: infoHeight });
        $('#sbjt_tbl').fixedHeaderTable({ height: sbjtHeight});

        $('#journalTbl tr').bind('click',function(){
            $('#journalTbl tr').removeClass('select_row');
            $(this).addClass('select_row');
            var child = $(this).children();
            var issn = child.eq(2).text();
            selectRow(issn);

        });

        var firstRow = $('#journalTbl tr').eq(1);
        $('#journalTbl tr').removeClass('select_row');
        $(firstRow).addClass('select_row');
        var child = $(firstRow).children();
        var issn = child.eq(2).text();
        selectRow(issn);

        $('input:checkbox').bind('click', function(){ clickCheckbox($(this));});
        $('#fromYear').data('prev', $('#fromYear').val());
        $('#toYear').data('prev', $('#toYear').val());

        $('.wrap-loading').css('display', 'none');
    });
}

function selectRow(issn){
	$.ajax({
		 url : "${contextPath}/analysis/department/findJournalInfoByIssnNoAjax.do",
		 dataType : 'json',
		 data : { "issnNo":issn,
			      "gubun": $('#gubun').val()
			     },
		 success : function(data, textStatus, jqXHR){
			 var indct = data.data;
			 $('#info_body').empty();
			 for(var i=0; i < indct.length; i++){
				 var dataValue = indct[i].dataValue == null ? '-' : indct[i].dataValue;
				 var $tr = $('<tr style="height:17px;"></tr>');
				 $tr.append($('<td style="text-align:center;">'+indct[i].prodYear+'</td>'));
				 $tr.append($('<td style="text-align:center;padding-right:10px;">'+dataValue+'</td>'));
				 $('#info_body').append($tr);
			 }
			 var sbjt = data.cat;
			 $('#sbjt_body').empty();
			 for(var j=0; j < sbjt.length; j++){
				 var $tr = $('<tr style="height:17px;"></tr>');
				 //$tr.append($('<td style="text-align:center;">'+sbjt[j].ctgryCode+'</td>'));
				 $tr.append($('<td style="text-align:left;">'+sbjt[j].ctgryName+'</td>'));
				 $('#sbjt_body').append($tr);
			 }
		 }
	 });
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
	 var chartTitle = $('<tr><td style="text-align:center;"><h1><p>Department(${item.deptKor}) - '+$('.page_title').html()+'</p></h1></td></tr>');
	 //append chart image
	 var chartTr = $('<tr><td><img src="'+fileName+'" height="350" /></td></tr>');
	 var dataTbl = $('<tr><td><h1>Chart Data</h1></td></tr><tr><td>'+$('#journalTbl').clone().wrapAll('<div/>').parent().html().replace(/<a/g, '<span').replace(/\/a>/g,'/span>')+'</td></tr>');
	 table.append(chartTitle)
	      .append(chartTr)
	      .append(dataTbl);
	 //make table with data of checked researcher
	 div.append(table);
	 $('#tableHTML').val(div.html());

	 var excelFileName = "MostFrequentedJournal_"+$('#gubun').val() + "_from_" + $('#fromYear').val() +"_to_" + $('#toYear').val() + ".xls";
	 $('#fileName').val(excelFileName);
	 exportLog($('#frm'), excelFileName + "|" +  fileName);
	 $('#excelFrm').submit();
 }

 function clickNoPublications(issn_no){
	 //alert("chartClick event execute !!" + year);
	 $('#artListTbl').empty();
	 //loading publication list of year by ajax

	 $.ajax({
		 url : "${contextPath}/analysis/department/findArticleListByIssnNoAjax.do",
		 dataType : 'json',
		 data : { "deptKor": $('#deptKor').val(),
			      "fromYear": $('#fromYear').val(),
			      "toYear": $('#toYear').val(),
			      "gubun" : $('#gubun').val(),
			      "hldofYn" : $('#hldofYn').val(),
			      "openAccesAt" : $('#openAccesAt').val(),
			      "topNm" : $('#frm > #topNm').val(),
			      "isFulltime" : 'ALL',
			      "issnNo": issn_no,
			      "trackId":"<c:out value="${parameter.trackId}"/>"
			     },
		 success : function(data, textStatus, jqXHR){


			 var $thead = $('<thead><tr><th><span>NO</span></th><th><span>Article</span></th><th style="width:10%"><span>Citation</span></th><tr></thead>');
			 $('#artListTbl').append($thead);
			 var $tbody = $('<tbody></tbody>');

			 for(var i=0; i < data.length; i++){

				 var seqno = data[i].articleId;
				 var esubject = data[i].orgLangPprNm == null ? '' : data[i].orgLangPprNm;
			     var authors = data[i].authors == null ? '' : data[i].authors;
			     var publisher = data[i].pblcPlcNm == null ? '' : data[i].pblcPlcNm;
				 var magazine = data[i].scjnlNm == null ? '' : data[i].scjnlNm;
			     var vol = data[i].volume == null ? '' : data[i].volume;
			     var no = data[i].issue == null ? '' : data[i].issue
				 var strpage = data[i].sttPage == null ? '' : data[i].sttPage;
			     var endpage = data[i].endPage == null ? '' : data[i].endPage;
			     var issueDate = data[i].pblcYm == null ? '' : dateFormat(data[i].pblcYm);
			     var impctFctr = data[i].impctFctr == null ? '' : data[i].impctFctr;
			     var sciTc = data[i].tc == null ? '' : data[i].tc;
			     var scpTc = data[i].scpTc == null ? '' : data[i].scpTc;
			     var kciTc = data[i].kciTc == null ? '' : data[i].kciTc;

				 var cited = "";
				 if($('#gubun').val() == 'SCI') cited = sciTc;
				 else if($('#gubun').val() == 'SCOPUS') cited = scpTc;
				 else if($('#gubun').val() == 'KCI') cited = kciTc;

			     var $tr = $('<tr style="height:17px;"></tr>');
				 $tr.append($('<td style="font-size: 10pt;" align="center" width="40">'+(i+1)+'</td>'));
				 var $td = $('<td class="link_td" style="font: normal 12px \'Malgun Gothic\';"></td>').append($('<div class="style_12pt"><a href="javascript:popArticle(\''+seqno+'\')"><b>'+esubject+'</b></a></div>'));
				 //var content = '<b>Journal</b>: '+magazine+' [v.'+vol+',&nbsp;no.'+no+',&nbsp; pp.'+strpage+'~'+endpage+',&nbsp;'+issueDate+']';
				 var content = '<span>'+authors + '&nbsp;('+magazine+'&nbsp;v.'+vol+',&nbsp;no.'+no+',&nbsp; pp.'+strpage+'~'+endpage+',&nbsp;'+issueDate+')&nbsp;</span>';
				 $td.append(content);
				 $tr.append($td);
				 var citedTd = $('<td style="text-align: center;">'+cited+'</td>');
				 $tr.append(citedTd);
				 $tbody.append($tr);
			 }
			 $('#artListTbl').append($tbody);
			 var title = magazine + "( "+data.length+" )";
			 $('.popup_header > h3 ').html(title);
			/*
			 $('#dialog').dialog({
				width:730,
				height:450,
				modal:true,
				title:title,
				buttons:[{
					text:'닫기',
					click:function(){
						$(this).dialog("close");
					}
				}]
			 });
			  */
		 }
	 });
 }

 </script>
</head>
<body>
	<h3 class="page_title"><spring:message code="menu.asrms.dept.journal.page"/></h3>
	<div class="help_text mgb_30"><spring:message code="asrms.department.frequented.journal.desc"/></div>

	<form id="frm" name="frm">
	<input type="hidden" id="topNm" name="topNm" value="<c:out value="${topNm}"/>"/>
	<input type="hidden" name="deptKor" id="deptKor" value="<c:out value="${parameter.deptKor}"/>"/>
	<input type="hidden" name="trackId" id="trackId" value="<c:out value="${parameter.trackId}"/>"/>

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
			<span>학술지구분</span>
			<em>
				<select name="gubun" id="gubun">
					<option value="SCI" selected="selected">SCI</option>
					<option value="SCOPUS">SCOPUS</option>
					<option value="KCI">KCI</option>
				</select>
			</em>
			<span>OA구분</span>
			<em>
				<select name="openAccesAt" id="openAccesAt">
					<option value="" selected="selected">전체</option>
					<option value="Y">OA논문</option>
				</select>
			</em>
			<span>실적구분</span>
			<em>
				<select name="insttRsltAt" id="insttRsltAt">
					<option value="" selected="selected">전체</option>
					<option value="Y">${sysConf['inst.abrv']}</option>
					<option value="N">타기관</option>
				</select>
			</em>
			<span>실적기간</span>
			<em>
				<select name="fromYear" id="fromYear">
					<c:forEach var="yl" items="${pubYearList}" varStatus="idx" end="50">
						<option value="${yl.pubYear }" ${idx.index == 5 ? 'selected="selected"' : '' }>${yl.pubYear }</option>
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
			<a href="javascript:journalAjax();" class="to_search_bt"><span>Search</span></a>
		</p>
	</div>

		<h3 class="circle_h3">Chart</h3>

		<div id="chartdiv1" class="chart_box mgb_10"></div>

		<p class="bt_box mgb_10"><a href="#" onclick="exportExcel();" class="black_bt"><em class="export_icon">Export</em></a></p>

		<h3 class="circle_h3">Journal List</h3>

		<div class="sub_content_wrapper">
			<table style="width: 100%">
				<tr>
					<td rowspan="2" style="vertical-align:top; width: 75%; padding-right:  25px;">
						<div style="border-left: 1px solid #bdbdbd;border-right: 1px solid #bdbdbd;">
						<table width="100%" id="journalTbl" class="list_tbl">
							<colgroup>
								<col style="width: 5%"/>
								<col style="width: 41%"/>
								<col style="width: 15%"/>
								<col style="width: 9%"/>
								<col style="width: 10%"/>
							</colgroup>
							<thead>
							<tr style="text-align: center;height:25px">
								<th><span>No</span></th>
								<th><span>저널명</span></th>
								<th><span>ISSN</span></th>
								<th><span>논문수</span></th>
								<th><span>참여<br/>연구자</span></th>
							</tr>
							</thead>
							<tbody></tbody>
						</table>
						</div>
					</td>
					<td style="width: 25%; padding-bottom: 25px;vertical-align: top;">
						<div style="border-left: 1px solid #bdbdbd;border-right: 1px solid #bdbdbd;border-bottom: 1px solid #bdbdbd;">
						<table id="info_tbl" class="list_tbl">
							<colgroup>
								<col style="width: 35%"/>
								<col style="width: 65%"/>
							</colgroup>
							<thead>
							<tr style="text-align: center;height:50px">
								<th><span>Year</span></th>
								<th id="indicator_th" ></th>
							</tr>
							</thead >
							<tbody id="info_body"></tbody>
						</table>
						</div>
					</td>
				</tr>
				<tr style="vertical-align: top;">
					<td>
						<div style="border-left: 1px solid #bdbdbd;border-right: 1px solid #bdbdbd;border-bottom: 1px solid #bdbdbd;">
						<table width="100%" id="sbjt_tbl" class="list_tbl">
							<colgroup>
								<col style="width: 100%"/>
							</colgroup>
							<thead>
							<tr style="text-align: center;height:46px">
								<%--  <th><span>Code</span></th> --%>
								<th><span>Subject</span></th>
							</tr>
							</thead>
							<tbody id="sbjt_body"></tbody>
						</table>
						</div>
					</td>
				</tr>
			</table>
		</div>
	</form>

<form id="excelFrm" method="post" action="${contextPath}/jsp/excelExport.jsp">
      <input type="hidden" id="tableHTML" name="tableHTML" value="" />
      <input type="hidden" id="fileName" name="fileName" value="test.xls" />
</form>

<div id="dialog" class="popup_box modal modal_layer">
	<div class="popup_header">
		<h3></h3>
		<a href="#" class="close_bt closeBtn">닫기</a>
	</div>
	<div class="popup_inner">
		<div class="popup_scroll">
			<table width="100%" id="artListTbl" class="list_tbl mgb_20"></table>
		</div>
	</div>
</div>

</body>
</html>
