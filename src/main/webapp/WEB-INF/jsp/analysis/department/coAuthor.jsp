<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>학과간 네트워크</title>
<style type="text/css" rel="stylesheet">
	.to_inner span {min-width: 70px;}
</style>
<script type="text/javascript">
 var toggle = true;
 var chart_ChartId1;
 $(document).ready(function(){
	$( "#tabs" ).tabs({});
	$("#tabs").css("display", "block");

     coAuthorAjax();
  });

 function coAuthorAjax(){
     if(!validateRange()){errorMsg(this); return false;}

     $.ajax({
         url:"<c:url value="/analysis/department/coAuthorAjax.do"/>",
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
             width:'790',
             height:'608',
             dataFormat:'xml',
             dataSource: data.chartXML,
             events:{
                 legendItemClicked :function(eventObj, dataObj){
                     //console.log(dataObj.datasetIndex + " : " + dataObj.visible);

                 },
                 renderComplete:function(){
                     //console.log($('.fusioncharts-legend').find('path').eq(0).attr('stroke-width'));
                     $('.fusioncharts-legend').find('path').attr('stroke-width','2.5');
                 }
             }
         }).render();

         var $tbody = "";
         for(var i=0; i<data.coAuthorList.length; i++){
             var co = data.coAuthorList[i];

             var $tr = "<tr style='height:17px;'>";
             $tr += '<td style="text-align: center;">'+(i+1)+'</td>';
             $tr += '<td style="padding-left: 5px;">'+co.deptKor+'</td>';
             $tr += '<td style="text-align: center; padding-right: 5px;">'+co.coArtsCo+'</td>';
             $tr += '</tr>';

             $tbody += $tr;
         }
         $("#dataTbl tbody").html($tbody);

         $('.wrap-loading').css('display', 'none');
     });
 }
 
 function chartClick(args){

	 var param = args.split(";");
	 var trgetSe = param[0];
	 var targetDeptKor = param[1];

	 $('#list_title').css('display','');
	 $('#list_content').css('display','');
	 $('.publicationsDiv').css('display','');
	 $('#publicationsTbl > tbody').empty();
	 $('#list_title').text("Publications (with "+targetDeptKor+")");

	 $.ajax({
		 url : "${contextPath}/analysis/department/findArticleListByCoAuthorDepartmentAjax.do",
		 dataType : 'json',
		 mehtod : 'POST',
		 data : { "deptKor": $('#deptKor').val(),
			      "fromYear": $('#fromYear').val(),
			      "toYear": $('#toYear').val(),
			      "gubun" : $('#gubun').val(),
			      "position" : $('#position').val(),
			      "isFulltime" : $('#isFulltime').val(),
			      "hldofYn" : $('#hldofYn').val(),
			      "topNm" : "department",
			      "trgetSe" : trgetSe,
			      "targetDeptKor" : targetDeptKor,
				 "insttRsltAt" :  $('#insttRsltAt').val()
			     },
		 success : function(data, textStatus, jqXHR){

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

				 var $tr = $('<tr height="17px" ></tr>');
				 $tr.append($('<td style="font-size: 10pt;" align="center" width="40">'+(i+1)+'</td>'));
				 var $td = $('<td class="link_td" style="font-size: 10pt;"></td>').append($('<div class="style_12pt"><a href="javascript:popArticle(\''+seqno+'\')"><b>'+esubject+'</b></a></div>'));
				 var content = '<span>'+authors + '&nbsp;('+publisher+',&nbsp;' + magazine+',&nbsp;v.'+vol+',&nbsp;no.'+no+',&nbsp; pp.'+strpage+'~'+endpage+',&nbsp;'+issueDate+')</span>';
				 $td.append(content);
				 $tr.append($td);
				 $('#publicationsTbl > tbody').append($tr);

			 }
			//alert(data[0].ESUBJECT);
		 }
	 }).done(function(){});


 }
 function myFN(objRtn){
 	if (objRtn.statusCode=="1"){
 		saveExcel(objRtn.fileName, '교내');
 		//alert("The chart was successfully saved on server. The file can be accessed from " + objRtn.fileName);
 	}else{
 		alert("The chart could not be saved on server. There was an error. Description : " + objRtn.statusMessage);
 	}
 }
 function myFN_other(objRtn){
 	if (objRtn.statusCode=="1"){
 		saveExcel(objRtn.fileName, '교외');
 		//alert("The chart was successfully saved on server. The file can be accessed from " + objRtn.fileName);
 	}else{
 		alert("The chart could not be saved on server. There was an error. Description : " + objRtn.statusMessage);
 	}
 }

 function exportExcel(){
	 if( chart_ChartId1.hasRendered() ) chart_ChartId1.exportChart( { exportFormat : 'JPG'} );
 }
 function saveExcel(fileName, subtitle){

	 var div = $('<div></div>');
	 var table = $('<table></table>');
	 var pageTitle = $('<tr><td style="text-align:center;" colspan="5"><h1><p>Department(${item.deptKor}) - '+$('.page_title').html()+'('+subtitle+')</p></h1></td></tr>');
	 var chartTr = $('<tr><td><img src="'+fileName+'" height= "650"/></td></tr>');
	 var dataTitle = $('<tr><td colspan="5"><h1>Chart Data</h1></td></tr>');
	 var dTbl = $('#dataTbl').clone().wrapAll('<div/>').parent().html();
	 dTbl = dTbl.replace(/<a .*>(.*)<\/a>/g, '$1');
	 console.log(dTbl);
	 table.append(pageTitle)
	      .append(chartTr)
	      .append(dataTitle)
	      .append($('<tr><td>'+dTbl+'</td></tr>'));
	 div.append(table);
	 $('#tableHTML').val(div.html());
	 var excelFileName = "DepartmentCo-AuthorNetwork_"+$('#gubun').val() + "_from_" + $('#fromYear').val() +"_to_" + $('#toYear').val() + ".xls";
	 $('#fileName').val(excelFileName);
	 exportLog($('#frm'), excelFileName + "|" +  fileName);
	 $('#excelFrm').submit();
 }

 </script>
</head>
<body>
	<h3 class="page_title">학과간 네트워크</h3>
	<div class="help_text mgb_30"><spring:message code="asrms.department.coauthor.network.dept.desc"/></div>

	<form id="frm" name="frm">
	<input type="hidden" id="topNm" name="topNm" value="<c:out value="${topNm}"/>"/>
	<input type="hidden" name="deptKor" id="deptKor" value="<c:out value="${parameter.deptKor}"/>"/>
	<input type="hidden" name="trackId" id="trackId" value="<c:out value="${parameter.trackId}"/>"/>
	<input type="hidden" name="coauthorTarget" id="coauthorTarget" value="inst"/>

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
			<span>신분구분</span>
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
			<a href="javascript:coAuthorAjax();" class="to_search_bt"><span>Search</span></a>
		</p>
	</div>
	<!--END page_function-->

	<div style="padding-bottom: 22px;">
		<div style="float: right;">
			<input type="radio" name="coauthorTargetRadio" id="coauthorTargetIn" value="inst" checked="checked" style="vertical-align: -5px;" onchange="javascript: $('#coauthorTarget').val($(this).val()); coAuthorAjax();" /><span> 학과&nbsp;&nbsp;</span>
			<input type="radio" name="coauthorTargetRadio" id="coauthorTargetOut" value="other" style="vertical-align: -5px;" onchange="javascript: $('#coauthorTarget').val($(this).val()); coAuthorAjax();"/><span> 타기관 &nbsp;&nbsp;</span>
		</div>
	</div>

	<div id="tabs" class="tab_wrap" style="display: none;">
	  <ul>
	    <li><a href="#tabs-1">Chart</a></li>
	    <li><a href="#tabs-2">Data</a></li>
	  </ul>
  		<div id="tabs-1">
		   <div id="chartdiv1" class="chart_box" align="left">FusionCharts. </div>
	   </div>
		<div id="tabs-2">
			<div id="content_wrap">
				<table width="100%" id="dataTbl" class="tab_tbl mgb_20">
					<colgroup>
						<col style="width: 10%"/>
						<col style="width: 40%"/>
						<col style="width: 25%"/>
					</colgroup>
				<thead>
					<tr style="height:35px;">
						<th><span>NO</span></th>
						<th><span>관련학(부)과명</span></th>
						<th><span>공동연구논문수</span></th>
					</tr>
				</thead>
				<tbody></tbody>
				</table>
			</div>
		</div>
	</div>

	<p class="bt_box mgb_10"><a href="#" onclick="exportExcel();" class="black_bt"><em class="export_icon">Export</em></a></p>
	<!--
	<p class="bt_box mgb_10"><a href="#" onclick="javascript:alert('개발 중')" class="black_bt"><em class="export_icon">Export</em></a></p>
	 -->
	<h3 id="list_title" style="display: none;">Publication</h3>

	<div class="sub_content_wrapper" id="list_content" style="display: none;">
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

<!-- end# wrapper-->
<form id="excelFrm" method="post" action="${contextPath}/jsp/excelExport.jsp">
      <input type="hidden" id="tableHTML" name="tableHTML" value="" />
      <input type="hidden" id="fileName" name="fileName" value="test.xls" />
</form>
</body>
</html>
