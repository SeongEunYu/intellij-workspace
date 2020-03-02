<%@ page import="kr.co.argonet.r2rims.core.vo.DeptVo" %>
<%@ page import="kr.co.argonet.r2rims.core.code.CodeConfiguration" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><spring:message code="menu.asrms.clg.coauthor"/></title>
<style type="text/css" rel="stylesheet">
	.to_inner span {min-width: 70px;}
</style>
 <script type="text/javascript">
 var chart_ChartId1;
 var orginlChartData;

 $(document).ready(function(){

     $( "#tabs" ).tabs({});
     $("#tabs").css("display", "block");

     departCoAuthorAjax();
 });

 function departCoAuthorAjax(){
     if(!validateRange()){errorMsg(this); return false;}

     orginlChartData = null;

     $.ajax({
         url:"<c:url value="/analysis/college/departCoAuthorAjax.do"/>",
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

         if(FusionCharts('networkChart2')) {
             FusionCharts('networkChart2').dispose();
             $('#chartdiv2').disposeFusionCharts().empty();
         }

         var chartWidth =  browserType() == "I" ? "748" : "100%";
         var target = $("#coauthorTarget").val();
         var chartDiv = target == "inst" ? 'chartdiv1' : 'chartdiv2';
         var chartId = target == "inst" ? 'networkChart1' : 'networkChart2';

         chart_ChartId1 =  new FusionCharts({
             id: chartId,
             type:'dragnode',
             renderAt:chartDiv,
             width:chartWidth,
             height:'650',
             dataFormat:'xml',
             dataSource:data.chartXML+"",
             events:{
                 "renderComplete":function(){
                     if(orginlChartData == null){
                         orginlChartData = chart_ChartId1.getJSONData();
                     }
                     $('.fusioncharts-legend').find('path').attr('stroke-width','2.5');
                 },
                 "dataplotDragEnd": function (eventObj, dataObj) {
                     var dsIndex = dataObj['datasetIndex'];
                     orginlChartData.dataset[dsIndex].data[0].x = dataObj["x"];
                     orginlChartData.dataset[dsIndex].data[0].y = dataObj["y"];
                 }
             }
         }).render();

         if($("#coauthorTarget").val() == 'inst'){
             $("#centerDiv").css("display", "block");
             $("#otherDiv").css("display", "none");
             $("#searchDept").css("display", "none");
         }
         else{
             $("#centerDiv").css("display", "none");
             $("#otherDiv").css("display", "block");
             $("#searchDept").css("display", "block");
         }

         if($("#coauthorTarget").val() == "org")$("#dataTbl th").eq(1).html("학(부)과");
         else if($("#coauthorTarget").val() == "other")$("#dataTbl th").eq(1).html("타기관");

         var $tbody2 = "";
         for(var i=0; i<data.departList.length; i++){
             var co = data.departList[i];

             var $tr2 = "<tr style='height:17px;'>";
             $tr2 += '<td style="text-align: center;">'+(i+1)+'</td>';
             $tr2 += '<td style="padding-left: 5px;">'+co.deptKor+'</td>';
             $tr2 += '<td style="text-align: center; padding-right: 5px;">'+co.coArtsCo+'</td>';
             $tr2 += '</tr>';

             $tbody2 += $tr2;
         }
         $("#dataTbl tbody").html($tbody2);

         $('input:checkbox').bind('click', function(){ clickCheckbox($(this));});

         $('input[id^="ds_"]').prop('checked', true);
         $('#checkLable').empty().text('선택해제');
         $("#toggleChkbox").prop("checked",true);

         $('.wrap-loading').css('display', 'none');
     });
 }

 function clickCheckbox(obj){
		var currPosition = $('div.yu_as_rims_wrap').scrollTop();
		toggleCheckbox(obj);
		var chartJson = JSON.parse(JSON.stringify(orginlChartData));
		var dsLength = chartJson.dataset.length;
		for(var i=dsLength-1; i > -1;i--)
		{
			 var dsId = chartJson.dataset[i].id;
			 if($('#'+dsId).prop("checked") == false) chartJson.dataset.splice(i,1);
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
			$('input[id^="ds_"]').prop('checked', true);
			$('#checkLable').empty().text('선택해제');
		}
		else
		{
			$('input[id^="ds_"]').prop('checked', false);
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
			if( $('input[id^="ds_"]:checked').length == $('input[id^="ds_"]').length)
			{
				$('#toggleChkbox').prop('checked', true);
				$('#checkLable').empty().text('선택해제');
			}
		}
	}
 }

 function chartClick(args){

	 var param = args.split(";");
	 var trgetSe = param[0];
	 var targetDeptKor = param[1];
	 var fromDept = "";
	 if(param.length > 2) fromDept = param[2];

	 $('#list_title').css('display','');
	 $('#list_content').css('display','');
	 $('#publicationsTbl > tbody').empty();
	if(trgetSe == "inst")
	{
	   var fromDeptName = findDeptName(targetDeptKor);
	   var toDeptName = findDeptName(fromDept);
	   $('#list_title').text("Publications ("+fromDeptName+" - "+toDeptName+" 공저)");
	}
	else if(trgetSe == "other")
	{
	  $('#list_title').text("Publications (with "+targetDeptKor+")");
	}

	 var deptKor = $('#searchDept').val();
	 var topNm = "";

	 if(deptKor == null || deptKor == '') topNm = 'college';
	 else topNm = 'department';

	 if(fromDept != "") deptKor = fromDept;

	 $.ajax({
		 url : "${contextPath}/analysis/department/findArticleListByCoAuthorDepartmentAjax.do",
		 dataType : 'json',
		 mehtod : 'POST',
		 data : { "clgCd": $('#clgCd').val(),
			 	  "deptKor": deptKor,
			 	  "trackId": "",
			      "fromYear": $('#fromYear').val(),
			      "toYear": $('#toYear').val(),
			      "gubun" : $('#gubun').val(),
			      "position" : $('#position').val(),
			      "isFulltime" : $('#isFulltime').val(),
			      "hldofYn" : $('#hldofYn').val(),
			      "topNm" : topNm,
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

 function findDeptName(deptCode){
	 var compareDeptCode = "ds_" + deptCode;
	 for(var i=0; i < orginlChartData.dataset.length;i++)
	 {
		 var dsId = orginlChartData.dataset[i].id;
		 if(orginlChartData.dataset[i].id == compareDeptCode)
			 return orginlChartData.dataset[i].seriesname;
	 }
	 return '';
 }


//Callback handler method which is invoked after the chart has saved image on server.
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
 		saveExcel(objRtn.fileName,'교외');
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
	 //append document title
	 var pageTitle = $('<tr><td style="text-align:center;"><h1><p>College(${item.codeDisp}) - '+$('.page_title').html()+'('+subtitle+')</p></h1></td></tr>');
	 //append chart image
	 var chartTr = $('<tr><td><img src="'+fileName+'" height= "650"/></td></tr>');
	 table.append(pageTitle)
	      .append(chartTr);
	 div.append(table);
	 $('#tableHTML').val(div.html());
	 var excelFileName = "Co-AuthorNetworkWithDepartment_"+$('#gubun').val() + "_from_" + $('#fromYear').val() +"_to_" + $('#toYear').val() + ".xls";
	 $('#fileName').val(excelFileName);
	 exportLog($('#frm'), excelFileName + "|" +  fileName);
	 $('#excelFrm').submit();
 }
 </script>
</head>
<body>

	<h3 class="page_title"><spring:message code="menu.asrms.clg.coauthor"/></h3>
	<div class="help_text mgb_30"><spring:message code="asrms.college.coauthor.network.desc"/></div>
    <form id="frm" name="frm">
	<input type="hidden" name="clgCd" id="clgCd" value="<c:out value="${parameter.clgCd}"/>"/>
	<input type="hidden" id="topNm" name="topNm" value="<c:out value="${topNm}"/>"/>
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
			<a href="javascript:departCoAuthorAjax();" class="to_search_bt"><span>Search</span></a>
		</p>
	</div>
	<!--END page_function-->
	<h3 class="circle_h3" >Chart</h3>

	<div style="padding-bottom: 23px;">
		<div style="float: right;">
			<div>
				<input type="radio" name="coauthorTargetRadio" id="coauthorTargetIn" value="inst" checked="checked"style="vertical-align: -5px;" onchange="javascript: $('#coauthorTarget').val($(this).val()); $('#searchDept').val('');departCoAuthorAjax();" /><span> 학과간&nbsp;&nbsp;</span>
				<input type="radio" name="coauthorTargetRadio" id="coauthorTargetOut" value="other" style="vertical-align: -5px;" onchange="javascript: $('#coauthorTarget').val($(this).val()); $('#searchDept').val('');departCoAuthorAjax();"/><span> 타기관 &nbsp;&nbsp;</span>
				<div style="float:right;">
				<select id="searchDept" name="searchDept" style="display: none;" onchange="javascript: departCoAuthorAjax();">
					<option value="">${instAbrv}(${item.codeDisp})</option>
					<%
						List<DeptVo> deptList = CodeConfiguration.getDeptList(request.getParameter("clgCd"));

						if(deptList == null) return;
						//학과 이름순 정렬
						Collections.sort(deptList,new Comparator() {
							@Override
							public int compare(Object o1,Object o2) {
								String v1 = ((DeptVo)o1).getDeptKorNm();
								String v2 = ((DeptVo)o2).getDeptKorNm();

								return v1.compareTo(v2);
							}
						});

						for(int i=0; i<deptList.size(); i++){
					%>
					<option value="<%=deptList.get(i).getDeptKorNm() %>" ><%=deptList.get(i).getDeptKorNm() %></option>
					<%	}	%>
				</select>
				</div>
			</div>
		</div>
	</div>
	 <div id="centerDiv" style="display: none;">
			<div id="chartdiv1" class="chart_box" align="left">FusionCharts. </div>

			<p class="bt_box mgb_20"><a href="#" onclick="exportExcel();" class="black_bt"><em class="export_icon">Export</em></a></p>
			<div style="float: left; margin-top: -22px;">
				<input type="checkbox" name="toggleChkbox" id="toggleChkbox" value="0"/>&nbsp;&nbsp;<span id="checkLable">선택해제</span>
			</div>
			<table width="100%" id="userListTbl" class="list_tbl mgb_20">
				<colgroup>
					<col style="width:3%"/>
					<col style="width:17%"/>
					<col style="width:3%"/>
					<col style="width:17%"/>
					<col style="width:3%"/>
					<col style="width:17%"/>
					<col style="width:3%"/>
					<col style="width:17%"/>
					<col style="width:3%"/>
					<col style="width:17%"/>
					<col style="width:3%"/>
					<col style="width:17%"/>
				</colgroup>
				<thead>
					<tr>
						<th colspan="99">학(부)과</th>
					</tr>
				</thead>
				<tbody>
				<input type="hidden" name="departsSize" id="departsSize" value="<%= deptList.size() %>" />
					<%
						for(int i=0; i<deptList.size(); i++){
						    if(i % 4 == 0){
					%>
					<tr>
					<%	} %>
						<td style="text-align: right;">
							<input type="checkbox" checked="checked"  value="<%=deptList.get(i).getDeptCode()%>" id="ds_<%=deptList.get(i).getDeptCode()%>"/>
							<input type="hidden"  value="<%=deptList.get(i).getDeptKorNm()%>" id="name_<%=deptList.get(i).getDeptCode()%>"/>
						</td>
						<td style="text-align: left;"><%=deptList.get(i).getDeptKorNm()%></td>
					<%	 if(i % 4 == 3){	%>
					</tr>
					<%	} %>
					<%}	%>
				</tbody>
			</table>
	</div>
	<div id="otherDiv" style="display: none;">
		<div id="tabs" class="tab_wrap mgb_10" style="display: none;">
		  <ul>
			<li><a href="#tabs-1">Chart</a></li>
			<li><a href="#tabs-2">Data</a></li>
		  </ul>
			<div id="tabs-1">
				<div style="padding-left:0px" class="mgb_10">
				   <div id="chartdiv2" class="chart_box" align="left"></div>
				</div>
		   </div>
			<div id="tabs-2">
				<div>
					<table width="100%" id="dataTbl" class="tab_tbl">
						<colgroup>
							<col style="width: 10%"/>
							<col style="width: 40%"/>
							<col style="width: 25%"/>
						</colgroup>
					<thead>
						<tr style="height:35px;">
							<th>NO</th>
							<th>타기관</th>
							<th>공동연구논문수</th>
						</tr>
					</thead>
					<tbody></tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
	<h3 class="circle_h3" id="list_title" style="display: none;">Publication</h3>
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
