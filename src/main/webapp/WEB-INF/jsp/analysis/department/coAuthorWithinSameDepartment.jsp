<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>학과내 네트워크</title>
<style type="text/css" rel="stylesheet">
	.to_inner span {min-width: 70px;}
</style>
 <script type="text/javascript">
 var chart_ChartId1;
 var orginlChartData;

 $(document).ready(function(){
     departCoAuthorAjax();
 });

 function departCoAuthorAjax(){
     if(!validateRange()){errorMsg(this); return false;}
     orginlChartData = null;

     $.ajax({
         url:"<c:url value="/analysis/department/coAuthorWithinSameDepartmentAjax.do"/>",
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

         var chartWidth = "100%";
         if(browserType() == "I") chartWidth = "748";

         chart_ChartId1 =  new FusionCharts({
			 id: 'networkChart1',
             type:'dragnode',
             renderAt:'chartdiv1',
             width:chartWidth,
             height:'450',
             dataFormat:'xml',
             dataSource:data.chartXML,
             events:{
                 "renderComplete":function(){
                     if(orginlChartData == null){
                         orginlChartData = chart_ChartId1.getJSONData();
                     }
                 },
                 "dataplotDragEnd": function (eventObj, dataObj) {
                     var index = dataObj['index'];
                     orginlChartData.dataset[0].data[index].x = dataObj["x"];
                     orginlChartData.dataset[0].data[index].y = dataObj["y"];
                 }
             }
         }).render();

         var $tbody = '<input type="hidden" name="usersSize" id="usersSize" value="'+data.coAuthorList.length+'" />';

         for(var i=0; i<data.coAuthorList.length; i++){
             var ul = data.coAuthorList[i];
             var $tr = "";
             if(i%3 == 0) $tr += "<tr>";
             $tr += '<td style="text-align: right;"><input type="checkbox"  value="'+ul.userId+'" id="id_'+ul.userId+'"/><input type="hidden"  value="'+ul.korNm+'" id="name_'+ul.userId+'"/></td>';
             $tr += '<td class="center">'+ul.korNm+'</td>';
             if(i%3 == 2) $tr += "</tr>";

             $tbody += $tr;
         }
         $("#userListTbl tbody").html($tbody);

         $('input:checkbox').bind('click', function(event){ clickCheckbox($(this),event);});
         $('input:checkbox').prop('checked',true);

         $('#checkLable').empty().text('선택해제');

         $('.wrap-loading').css('display', 'none');
     });
 }

 function clickCheckbox(obj,event){

	var currPosition = $('div.yu_as_rims_wrap').scrollTop();

	toggleCheckbox(obj);

	var chartJson = JSON.parse(JSON.stringify(orginlChartData));
	 for(var i=0; i < chartJson.dataset.length;i++)
	 {
		 var dataset = chartJson.dataset[i];
		 var dataLength = chartJson.dataset[i].data.length;
		 for(var j=dataLength-1; j > -1;j--)
		 {
			 var id = chartJson.dataset[i].data[j].id;
			 if($('#'+id).prop("checked") == false) chartJson.dataset[i].data.splice(j,1);
		 }
	 }

	 chart_ChartId1.setJSONData(chartJson);
	 chart_ChartId1.render();

	 $('div.yu_as_rims_wrap').scrollTop(currPosition);

 }

 //Toggle Checkbox
 function toggleCheckbox(obj){
    if($(obj).prop('id') == "toggleChkbox")
	{
		if($(obj).prop("checked") == true)
		{
			$('input[id^="id_"]').prop('checked', true);
			$('#checkLable').empty().text('선택해제');
		}
		else
		{
			$('input[id^="id_"]').prop('checked', false);
			$('#checkLable').empty().text('전체선택');
		}
	}
	else
	{
		if($(obj).prop("checked") == false){
			$('#toggleChkbox').prop('checked', false);
			$('#checkLable').empty().text('전체선택');
		}
		else
		{
			if( $('input[id^="id_"]:checked').length == $('input[id^="id_"]').length)
			{
				$('#toggleChkbox').prop('checked', true);
				$('#checkLable').empty().text('선택해제');
			}
		}
	}
 }

 function chartClick(args){
	 var param = args.split(";");
	 var fromUser = param[0];
	 var toUser = param[1];

	 $('#list_title').css('display','');
	 $('#list_content').css('display','');
	 $('#publicationsTbl > tbody').empty();

	 var fromUserNm = findUserName(fromUser);
	 var toUserNm = findUserName(toUser);

	 var listTitle = "Publications (" +fromUserNm +" - " + toUserNm + " 공저)"
	 $('#list_title').text(listTitle);

	 $.ajax({
		 url : "${contextPath}/analysis/department/findArticleListByCoAuthorAjax.do",
		 dataType : 'json',
		 data : { "userId": fromUser,
			      "fromYear": $('#fromYear').val(),
			      "toYear": $('#toYear').val(),
			      "gubun" : $('#gubun').val(),
			      "coauthorUser" : toUser,
				  "insttRsltAt" :  $('#insttRsltAt').val()
			     },
		 success : function(data, textStatus, jqXHR){
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
			 }
		 }
	 });

 }

 function findUserName(userId){
	 var compareUserId = 'id_' + userId;
	 for(var i=0; i < orginlChartData.dataset.length;i++)
	 {
		 var dataset = orginlChartData.dataset[i];
		 for(var j=0; j < dataset.data.length; j++){
			 if(dataset.data[j].id == compareUserId)
				 return dataset.data[j].name;
		 }
	 }
	 return '';
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
	 	if( chart_ChartId1.hasRendered() ) chart_ChartId1.exportChart( { exportFormat : 'png'} );
 }
 function saveExcel(fileName){
	 var div = $('<div></div>');
	 var table = $('<table></table>');
	 //append document title
	 var pageTitle = $('<tr><td style="text-align:center;"><h1><p>Department(${item.deptKor}) - '+$('.page_title').html()+'</p></h1></td></tr>');
	 //append chart image
	 var chartTr = $('<tr><td><img src="'+fileName+'" height= "650"/></td></tr>');
	 table.append(pageTitle)
	      .append(chartTr);
	 div.append(table);
	 $('#tableHTML').val(div.html());
	 var excelFileName = "Co-AuthorNetworkOnSameDepartment_"+$('#gubun').val() + "_from_" + $('#fromYear').val() +"_to_" + $('#toYear').val() + ".xls";
	 $('#fileName').val(excelFileName);
	 exportLog($('#frm'), excelFileName + "|" +  fileName);
	 $('#excelFrm').submit();
 }
 </script>
</head>
<body>
	<h3 class="page_title"><c:if test="${not empty parameter.isTrack and parameter.isTrack eq 'y' }">Track</c:if><c:if test="${empty parameter.isTrack or parameter.isTrack ne 'y' }">학과</c:if>내 네트워크</h3>
	<div class="help_text mgb_30"><spring:message code="asrms.department.coauthor.network.samedept.desc"/></div>

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
			<p style="margin: 5px;">
				<span>Connection</span>
				<em>
					<select name="numOfConn" id="numOfConn">
						<option value="ALL">전체</option>
						<option value="3">3건이상</option>
						<option value="5">5건이상</option>
					</select>
				</em>
			</p>
		</div>
		<p class="ts_bt_box">
			<a href="javascript:departCoAuthorAjax();" class="to_search_bt"><span>Search</span></a>
		</p>
	</div>
	<!--END page_function-->

	<h3 class="circle_h3" >Chart</h3>

   <div id="chartdiv1" class="chart_box mgb_20" align="left">FusionCharts. </div>

	<p class="bt_box mgb_20"><a href="#" onclick="exportExcel();" class="black_bt"><em class="export_icon">Export</em></a></p>

	<div style="float: left; margin-top: -22px;">
		<input type="checkbox" name="toggleChkbox" id="toggleChkbox" value="0" checked="checked"/>&nbsp;&nbsp;<span id="checkLable">선택해제</span>
	</div>

	<div class="sub_content_wrapper">
		<table width="100%" id="userListTbl" class="list_tbl mgb_20">
			<colgroup>
				<col style="width:7%"/>
				<col style="width:11%"/>
				<!--
				<col style="width:10%"/>
				 -->
				<col style="width:7%"/>
				<col style="width:11%"/>
				<!--
				<col style="width:10%"/>
				 -->
				<col style="width:7%"/>
				<col style="width:11%"/>
				<!--
				<col style="width:10%"/>
				 -->
			</colgroup>
			<thead>
				<tr>
					<th><span></span></th>
					<th><span>성명</span></th>
					<!--
					<th >ID</th>
					 -->
					<th><span></span></th>
					<th><span>성명</span></th>
					<!--
					<th >ID</th>
					 -->
					<th><span></span></th>
					<th><span>성명</span></th>
					<!--
					<th><span>ID</span></th>
					 -->
				</tr>
			</thead>
			<tbody></tbody>
		</table>
	</div>

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
      <input type="hidden" id="fileName" name="fileName" value="test.xls" />
      <!--
      <input type="button" onclick="gotoExcel('tableData', 'tableHTML');" value="Export these results" />
       -->
</form>
</body>
</html>
