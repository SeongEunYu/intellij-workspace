<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><spring:message code="menu.asrms.about.journal"/></title>
<LINK rel=stylesheet type=text/css	href="${contextPath}/css/jquery/fixedheader.css">
<script type="text/javascript" src="${contextPath}/js/jquery/jquery.fixedheadertable.min.js"></script>
 <style>
.select_row {
	background: #fee79a !important;
}
 </style>
 <script type="text/javascript">
 var toggle = true;
 var fc = 0;
 //var cjArr = eval('('+ '${chartDataJson}'+')');

$(document).ready(function(){

	$('#info_tbl').fixedHeaderTable({ footer: false, cloneHeadToFoot: true, fixedColumn: false });
	$('#sbjt_tbl').fixedHeaderTable({ footer: false, cloneHeadToFoot: true, fixedColumn: false });

    var jtHeight =parseInt($('#journalTbl').height(),10);
    var infoHeight = jtHeight*0.5;

    //if(jtHeight < 415) infoHeight = 270;
    var sbjtHeight = parseInt(jtHeight, 10) - infoHeight -27;


	$('#info_tbl').fixedHeaderTable({ height: infoHeight });
	$('#sbjt_tbl').fixedHeaderTable({ height: sbjtHeight });

    $('input:checkbox').bind('click', function(){ clickCheckbox($(this));});
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

	$('.fht-table').css('width','100%');

	$('#fromYear').data('prev', $('#fromYear').val());
	$('#toYear').data('prev', $('#toYear').val());
	bindModalLink();

});

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
				 var dataValue = indct[i].dataValue == null ? '-' : indct[i].DATA_VALUE;
				 var $tr = $('<tr style="height:17px;"></tr>');
				 $tr.append($('<td style="text-align:center;">'+indct[i].prodYear+'</td>'));
				 $tr.append($('<td style="text-align:center;padding-right:10px;">'+indct[i].dataValue+'</td>'));
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
	 $('#tableHTML').val($('<table><tr style="height:350px;"><td style="height:350px;">&nbsp;<p style="text-align:center;"><img src="'+fileName+'" style="width: 730px; height: 350px;"/></p><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/></td></tr></tr><td>'+$('#publicationsTbl').parent().html()+'</td></tr></table>').html());
	 $('#excelFrm').submit();
 }

 function clickNoPublications(issn_no){
	 //alert("chartClick event execute !!" + year);
	 $('#artListTbl').empty();
	 //loading publication list of year by ajax

	 $.ajax({
		 url : "${contextPath}/analysis/department/findArticleListByIssnNoAjax.do",
		 dataType : 'json',
		 data : { "searchDept": $('#journal_deptKor').val(),
			      "fromYear": $('#fromYear').val(),
			      "toYear": $('#toYear').val(),
			      "gubun" : $('#gubun').val(),
			      "hldofYn" : '1',
			      "isFulltime": 'M',
			      "issnNo" : issn_no
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
			     var cited = 0;
				 if($('#gubun').val() == 'SCI') cited = sciTc;
				 else if($('#gubun').val() == 'SCOPUS') cited = scpTc;
				 else if($('#gubun').val() == 'KCI') cited = kciTc;

			     var $tr = $('<tr style="height:28px;"></tr>');
				 $tr.append($('<td style="font-size: 10pt;" align="center" width="40">'+(i+1)+'</td>'));
				 var $td = $('<td class="link_td" align="left" style="font: normal 12px \'Malgun Gothic\';"></td>').append($('<div class="style_12pt"><b>'+esubject+'</b></div>'));
				 //var content = '<b>Journal</b>: '+magazine+' [v.'+vol+',&nbsp;no.'+no+',&nbsp; pp.'+strpage+'~'+endpage+',&nbsp;'+issueDate+']';
				 var content = '<div>&nbsp;/ '+authors + '&nbsp;( v.'+vol+',&nbsp;no.'+no+',&nbsp; pp.'+strpage+'~'+endpage+',&nbsp;'+issueDate+')&nbsp;</div>';
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
			//alert(data[0].ESUBJECT);
		 }
	 });
 }

 </script>
</head>
<body>
	<form id="frm" name="frm" action="${contextPath}/analysis/home/deptJournal.do" method="post">

	<h3><spring:message code="menu.asrms.about.journal.page"/></h3>
			<!--END page_title-->

	
			<!--START page_function-->
			<div class="sub_top_box">

				<span class="select_text">학술지구분</span>
				<span class="select_span">
					<select name="gubun" id="gubun" onchange="javascript:$('#frm').submit();">
						<option value="SCI" ${parameter.gubun eq 'SCI' ? 'selected="selected"' : '' }>SCI</option>
						<option value="SCOPUS" ${parameter.gubun eq 'SCOPUS' ? 'selected="selected"' : '' }>SCOPUS</option>
						<option value="KCI" ${parameter.gubun eq 'KCI' ? 'selected="selected"' : '' }>KCI</option>
					</select>
				</span>

				<%--
				<span class="select_text">Department</span>
				<span class="select_span">
					<select id="journal_deptKor" name="searchDept" onchange="javascript:$('#frm').submit();">
						<c:forEach items="${deptList}" var="dl">
						<option value="${dl.deptCode }"  <c:if test="${dl.deptCode eq parameter.searchDept}">selected="selected"</c:if> >
								<c:if test="${lang eq 'KOR' }"> ${dl.deptKor }</c:if>
								<c:if test="${lang eq 'ENG' }"> ${dl.deptKor }</c:if>
								<!--
								<c:if test="${lang eq 'ENG' }"> ${dl.deptEngMostAbbr }</c:if>
								 -->
						</option>
						</c:forEach>
					</select>
				</span>
				<span style="margin-top: 5px;">
						<a href="#" onclick="javascript:changeLang($('#frm'));">
							<c:if test="${sessionScope.aslang eq 'KOR'}"><img src="${contextPath}/images/common/btn_ENG.png" style="vertical-align: text-bottom;"/></c:if>
							<c:if test="${sessionScope.aslang eq 'ENG'}"><img src="${contextPath}/images/common/btn_KOR.png" style="vertical-align: text-bottom;"/></c:if>
						</a>
				</span>
				 --%>
				<span class="select_text mgl_40">실적기간</span>
				<span class="select_span">
					<select name="fromYear" id="fromYear" onchange="javascript:if(validateRange()){ $('#frm').submit();}else{ errorMsg(this); $(this).val($(this).data('prev')); return false;}">
						<c:forEach var="yl" items="${pubYearList}" varStatus="idx">
						  <option value="${yl.pubYear }" ${parameter.fromYear eq yl.pubYear ? 'selected="selected"' : '' }>${yl.pubYear }</option>
						</c:forEach>
					</select>
				</span>
				~
				<span class="select_span">
					<select name="toYear" id="toYear" onchange="javascript:if(validateRange()){ $('#frm').submit();}else{ errorMsg(this); $(this).val($(this).data('prev')); return false;}">
						<c:forEach var="yl" items="${pubYearList}" varStatus="idx">
						  <option value="${yl.pubYear }" ${parameter.toYear eq yl.pubYear ? 'selected="selected"' : '' }>${yl.pubYear }</option>
						</c:forEach>
					</select>
				</span>

			</div>
			<!--END page_function-->

	<div class="help_text mgb_30"><spring:message code="asrms.aboutsci.journal_dept.desc"/></div>

			<h3 class="circle_h3">Chart</h3>


			<div id="chartdiv1" class="mgb_10">
				<fc:render chartId="ChartId1" swfFilename="Pie2D" width="100%" height="350" debugMode="false" registerWithJS="false"
					dataFormat="xml" xmlData="${chartXML}" renderer="javascript" windowMode="transparent" />
			</div>

			<h3 class="circle_h3">Journal List</h3>

			<div class="sub_content_wrapper">
				<table>
					<tr>
						<td rowspan="2" style="vertical-align:top; width: 75%; padding-right:  25px;">
							<div style="border-left: 1px solid #bdbdbd;border-right: 1px solid #bdbdbd;">
							<table width="100%" id="journalTbl" class="list_tbl">
								<colgroup>
									<col style="width: 5%"/>
									<col style="width: 36%"/>
									<col style="width: 15%"/>
									<col style="width: 12%"/>
									<col style="width: 12%"/>
								</colgroup>
								<thead>
								<tr style="text-align: center;height:25px">
									<th><span>No</span></th>
									<th><span>Journal</span></th>
									<th><span>ISSN</span></th>
									<th><span>Total<br/> Publications</span></th>
									<th><span>Total<br/> Researchers</span></th>
								</tr>
								</thead>
								<tbody>
								<c:if test="${fn:length(journalList) > 0 }">
								<c:forEach items="${journalList }" var="jl" varStatus="st">
									<tr style='height:17px'>
										<td style="text-align: center;">${st.count}</td>
										<td ><span class="breakKeepAll">${jl.title}</span></td>
										<td style="text-align: center;">${jl.issnNo}</td>
										<td style="text-align: center;"><a href="#dialog" class="modalLink" onclick="javacript:clickNoPublications('${jl.issnNo}');">${jl.artsCo}</a></td>
										<td style="text-align: center;">${jl.userCo}</td>
									</tr>
								</c:forEach>
								</c:if>
								<c:if test="${fn:length(journalList) == 0 }">
									<tr>
										<td colspan="5" style="padding-left:5px;"><img src="${contextPath}/images/layout/ico_info.png" /> 검색된 Journal이 없습니다.</td>
									</tr>
								</c:if>
								</tbody>
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
								<tr style="text-align: center;height:28px">
									<th><span>Year</span></th>
									<th id="indicator_th" >
										Impact<br/>Factor
									</th>
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
		</div>
	</form>

<form id="excelFrm" method="post" action="${contextPath}/jsp/excelExport.jsp">
      <input type="hidden" id="tableHTML" name="tableHTML" value="" />
      <input type="hidden" id="fileName" name="fileName" value="test.xls" />
      <!--
      <input type="button" onclick="gotoExcel('tableData', 'tableHTML');" value="Export these results" />
       -->
</form>

<div id="dialog" class="popup_box modal modal_layer" style="display: none;">
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
