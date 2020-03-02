<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><spring:message code="menu.asrms.rsch.coauthor"/></title>
<%--
<script language="JavaScript" src="${contextPath}/Charts/JSClass/FusionCharts.js"></script>
 --%>
 <script type="text/javascript" charset="utf-8">
 var chart_ChartId1;

 $(document).ready(function(){
	 coauthorAjax();
 });

 function coauthorAjax(){
     if(!validateRange()){errorMsg(this); return false;}

     $.ajax({
         url:"<c:url value="/analysis/researcher/coauthorAjax.do"/>",
         dataType: "json",
         data: $('#frm').serialize(),
         method: "POST",
         beforeLoad: $('.wrap-loading').css('display', '')

     }).done(function(data){
         $("#list_title").css("display","none");
         $("#list_content").css("display","none");

         $('#fromYear').data('prev', $('#fromYear').val());
         $('#toYear').data('prev', $('#toYear').val());

         if(FusionCharts('networkChart1')) {
             FusionCharts('networkChart1').dispose();
             $('#chartdiv1').disposeFusionCharts().empty();
         }

         chart_ChartId1 =  new FusionCharts({
             id:'networkChart1',
             type:'dragnode',
             renderAt:'chartdiv1',
             width:'748',
             height:'548',
             dataFormat:'xml',
             dataSource: data.chartXML,
             events: {
                 "rendered": function () {
                 }
             }
         }).render();

         // makeArticleList(data.articleList);

         $('.wrap-loading').css('display', 'none');
     });
 }
 
 function chartClick(args){

	 var param = args.split(";");
	 var trgetSe = param[0];
	 var targtUserId = param[1];
	 var kor_nm = param[2];

	 $('#list_title').css('display','');
	 $('#list_content').css('display','');
	 $('#publicationsTbl > tbody').empty();
	 $('#list_title').text("Publications (with "+kor_nm+")");
	 var userId = $('#frm > input[name="userId"]').val();
	 $.ajax({
         url : "<c:url value="/analysis/researcher/findArticleListByCoAuthorAjax.do"/>",
		 dataType : 'json',
		 data : { "topNm": "researcher",
			      "userId": userId,
			      "fromYear": $('#fromYear').val(),
			      "toYear": $('#toYear').val(),
			      "gubun" : $('#gubun').val(),
			      "coauthorUser" : targtUserId,
			      "trgetSe" : trgetSe,
			      "trgetPsitn" : targtUserId,
			      "trgetNm":kor_nm
			     },
		 success : function(data, textStatus, jqXHR){
             makeArticleList(data);
		 }
	 }).done(function(){});

 }

 function makeArticleList(data){
     $('#excelExportDiv').empty();

     if( $('#coauthorTarget').val() != 'exfund')
     {
		 $('#excelExportDiv').append($('<table class="list_tbl mgb_20"><tr><th><span>No</span></th><th><span>Title</span></th><th><span>Authors</span></th><th><span>Publisher</span></th><th><span>Journal</span></th><th><span>Volume</span></th><th><span>Issue</span></th><th><span>startPage</span></th><th><span>endPage</span></th><th><span>Imapct Factor</span></th><th><span>TC(SCI)</span></th><th><span>TC(SCOPUS)</span></th><th><span>TC(KCI)</span></th><th><span>IssueDate</span></th></tr></table>'));
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
             var sciTc = data[i].tc == null ? '' : data[i].tc;
             var scpTc = data[i].scpTc == null ? '' : data[i].scpTc;
             var kciTc = data[i].kciTc == null ? '' : data[i].kciTc;

             var $tr = $('<tr height="17px"></tr>');
             $tr.append($('<td style="font-size: 10pt;" align="center" width="40">'+(i+1)+'</td>'));
             var $td = $('<td class="link_td" style="font-size: 10pt;"></td>').append($('<div class="style_12pt"><a href="javascript:popArticle('+seqno+')"><b>'+esubject+'</b></a><div>'));
             var content = '<span>'+authors + '&nbsp;('+publisher+',&nbsp;' + magazine+',&nbsp;'+vol+',&nbsp;'+no+',&nbsp; pp.'+strpage+'~'+endpage+',&nbsp;'+issueDate+')</span>';
             $td.append(content);
             $tr.append($td);
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

     }
     else
     {
         $('#excelExportDiv').append($('<table class="list_tbl mgb_20"><tr><th><span>No</span></th><th><span>Funding</span></th></tr></table>'));

         for(var i=0; i < data.length; i++){

             var $tr = $('<tr height="17px"></tr>');
             $tr.append($('<td style="font-size: 10pt;" align="center" width="40">'+(i+1)+'</td>'));
             var $td = $('<td class="link_td" style="font-size: 10pt;"></td>').append($('<div class="style_12pt"><a href="javascript:void(0);"><b>'+data[i].prjtNm+'</b></a><div>'));
             var content = '<span>('+data[i].prjtTypeNm+')</span>';
             $td.append(content);
             $tr.append($td);
             $('#publicationsTbl > tbody').append($tr);
         }
     }

     if(data.length == 0){
         var $tr = "<tr style='background-color: #ffffff;' height='17px'>";
         $tr += '<td colspan=99><img src="${contextPath}/images/layout/ico_info.png" /> There is no Data.</td></tr>';
         $('#publicationsTbl > tbody').append($tr);
     }

     //alert(data[0].ESUBJECT);
     $('.breakKeepAll').wordBreakKeepAll();
 }
//Callback handler method which is invoked after the chart has saved image on server.
 function myFN(objRtn){
 	if (objRtn.statusCode=="1"){
 		saveExcel(objRtn.fileName);
 		//alert("The chart was successfully saved on server. The file can be accessed from " + objRtn.fileName);
 	}else{
 		// alert("The chart could not be saved on server. There was an error. Description : " + objRtn.statusMessage);
 	}
 }

 function exportExcel(){
	 if( chart_ChartId1.hasRendered() ) chart_ChartId1.exportChart( { exportFormat : 'png'} );
 }
 function saveExcel(fileName){

	 var div = $('<div></div>');
	 var table = $('<table></table>');
	 //append document title
	 var pageTitle = $('<tr><td style="text-align:center;width:1200px;"><h1><p>Researcher(${item.korNm}) - '+$('.page_title').html()+'</p></h1></td></tr><tr><td>'+comment+'</td></tr>');
	 //append chart image
	 var chartTr = $('<tr><td><img src="'+fileName+'" height= "450"/></td></tr>');
	 var dataTbl = "";
	 if($("#list_content").css("display") !== "none"){
		 dataTbl = $('<tr><td colspan="5"><h1>'+$('#list_title').html()+'</h1></td></tr><tr><td>'+$('#excelExportDiv > table').clone().wrapAll('<div/>').parent().html()+'</td></tr>');
	 }
	 table.append(pageTitle).append(chartTr).append(dataTbl);
	 div.append(table);
	 $('#tableHTML').val(div.html());
	 var excelFileName = "Co-author_Network_"+$('#gubun').val() + "_from_" + $('#fromYear').val() +"_to_" + $('#toYear').val() + ".xls";
	 $('#fileName').val(excelFileName);
	 exportLog($('#frm'), excelFileName + "|" +  fileName);
	 $('#excelFrm').submit();
	 chartRefresh();

 }
 function chartRefresh(){
	var chartId = "ChartId1";
  	var flashvars = "";

 	if(jQuery.browser.msie == true && parseInt(jQuery.browser.version) <= 10){
 		$('#'+chartId).children().each(function(){ if($(this).attr('name') == 'flashvars')  flashvars = $(this).attr('value'); });
 	}else{
     	flashvars = $('#'+chartId).attr('flashvars');
 	}

 	var chartObject = getChartFromId(chartId);
 	//updateChartXML(chartId, $('#'+chartId).attr('flashvars').replace(/(.*dataXML=)(<chart .*>)/, '$2'));
 	chartObject.setDataXML(flashvars.replace(/(.*dataXML=)(<chart .*>)/, '$2'));
 }
 </script>
</head>
<body>
	<h3 class="page_title"><spring:message code="menu.asrms.rsch.coauthor"/></h3>
	<div class="help_text mgb_30"><spring:message code="asrms.researcher.coauthor.network.desc"/></div>

	<form id="frm" name="frm">
	<input type="hidden" id="topNm" name="topNm" value="<c:out value="${topNm}"/>"/>
	<input type="hidden" name="userId" id="userId" value="<c:out value="${parameter.userId}"/>"/>
	<input type="hidden" name="mode" id="mode" value="<c:out value="${parameter.mode}"/>"/>
	<input type="hidden" name="srchUserId" id="srchUserId" value="<c:out value="${parameter.srchUserId}"/>"/>
	<input type="hidden" name="srchUserPhotoUrl" id="srchUserPhotoUrl" value="<c:out value="${parameter.srchUserPhotoUrl}"/>"/>
	<input type="hidden" name="aslang" id="coauthor_lang" value="${sessionScope.aslang}"/>
	<input type="hidden" name="coauthorTarget" id="coauthorTarget" value="inst"/>

	<!--START page_function-->
	<div class="top_option_box">
		<div class="to_inner">
			<span><spring:message code="asrms.researcher.publications.classification" /></span>
			<em>
				<select name="gubun" id="gubun">
					<option value="ALL">전체</option>
					<option value="SCI">SCI</option>
					<option value="SCOPUS">SCOPUS</option>
					<option value="KCI">KCI</option>
				</select>
			</em>
			<span><spring:message code="asrms.researcher.publications.yearrange" /></span>
			<em>
				<select name="fromYear" id="fromYear">
					<c:forEach var="yl" items="${pubYearList}" varStatus="idx" end="50">
						<option value="${yl.pubYear }" ${idx.last == true? 'selected="selected"' : '' }>${yl.pubYear }</option>
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
			<a href="javascript:coauthorAjax();" class="to_search_bt"><span>Search</span></a>
		</p>
	</div>

	<h3 class="circle_h3">Chart</h3>
	<div style="float: right;padding:15px 5px 0px 0px;">
			<input type="radio" name="coauthorTargetRadio" id="coauthorTargetIn" value="inst" checked="checked" style="vertical-align: -2px;" onchange="javascript: $('#coauthorTarget').val($(this).val()); $('searchDept').val('');coauthorAjax();" /><span>In KAIST&nbsp;&nbsp;</span>
			<input type="radio" name="coauthorTargetRadio" id="coauthorTargetOut" value="other" style="vertical-align: -2px;" onchange="javascript: $('#coauthorTarget').val($(this).val()); $('searchDept').val('');coauthorAjax();"/><span>Off KAIST &nbsp;&nbsp;</span>
			<c:if test="${not empty exfund and exfund > 0 }">
				<input type="radio" name="coauthorTargetRadio" id="coauthorTargetExfund" value="exfund" style="vertical-align: -2px;" onchange="javascript: $('#coauthorTarget').val($(this).val()); $('searchDept').val('');coauthorAjax();"/><span>연구과제 &nbsp;&nbsp;</span>
			</c:if>
	 <%--
		<a href="#" onclick="javascript:changeLang($('#frm'));">
			<c:if test="${sessionScope.aslang eq 'KOR'}"><img src="${contextPath}/images/common/btn_ENG.png" style="vertical-align: text-bottom;"/></c:if>
			<c:if test="${sessionScope.aslang eq 'ENG'}"><img src="${contextPath}/images/common/btn_KOR.png" style="vertical-align: text-bottom;"/></c:if>
		</a>
	 --%>
	</div>

	<div class="sub_content_wrapper mgb_10">
		   <div id="chartdiv1" class="chart_box" align="center"></div>
	</div>

	<p class="bt_box mgb_10"><a href="#" onclick="exportExcel();" class="black_bt"><em class="export_icon">Export</em></a></p>

	<h3 id="list_title" class="circle_h3" style="display: none;">Publication</h3>
	<div class="sub_content_wrapper" id="list_content" style="display: none;">
		<table width="100%" id="publicationsTbl" class="list_tbl mgb_20">
			<colgroup>
				<col style="width: 10%"/>
				<col style="width: 90%"/>
			</colgroup>
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
      <div style="display: none;" id="excelExportDiv"></div>
      <!--
      <input type="button" onclick="gotoExcel('tableData', 'tableHTML');" value="Export these results" />
       -->
</form>

</body>
</html>
