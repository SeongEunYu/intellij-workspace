<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><spring:message code="menu.asrms.inst.artco"/></title>
<style type="text/css" rel="stylesheet">
th.header {
    cursor: pointer;
    background-repeat: no-repeat;
    background-position: center right;
    padding-right: 15px;
    margin-right: -1px;
}
</style>
<script type="text/javascript" src="${contextPath}/js/jquery/jquery.tablesorter.min.js"></script>
 <script type="text/javascript">
 var fc = 0;
 var chart_ChartId1;
 var djArr;

$(function() {
    $("#tabs").tabs({});
    $("#tabs").css("display", "block");

	$("#acqsDvsCd option").eq(0).remove();
	patentByNationAjax('0');
});

 function patentByNationAjax(idx){
     if(!validateRange()){errorMsg(this); return false;}

     $.ajax({
         url:"<c:url value="/analysis/researcher/patentByNationAjax.do"/>",
         dataType: "json",
         data: $('#frm').serialize(),
         method: "POST",
         beforeLoad: $('.wrap-loading').css('display', '')

     }).done(function(data){
         djArr = eval('('+ data.dataJson+')');

         $('#fromYear').data('prev', $('#fromYear').val());
         $('#toYear').data('prev', $('#toYear').val());

         if(FusionCharts('ChartId1')) {
             FusionCharts('ChartId1').dispose();
             $('#chartdiv1').disposeFusionCharts().empty();
         }

         var chartWidth = "100%";
         var barWidth = "100%";
         if(browserType() == "I"){
             chartWidth = "748";
             barWidth = "480";
         }

         chart_ChartId1 =  new FusionCharts({
			 id:'ChartId1',
             type:'MSLine',
             renderAt:'chartdiv1',
             width:chartWidth,
             height:'350',
             dataFormat:'xml',
             dataSource:data.chartXML
         }).render();

        fc = 0;
		var $tbody = "";
		if(data.applRegNtnCdList.length > 0){	
			for(var i=0; i<data.applRegNtnCdList.length; i++){
				var nl = data.applRegNtnCdList[i];

				var $tr = '<tr>';
				$tr += '<td style="text-align: center;">';
				$tr += '<input type="checkbox"  id="no_chkbox_'+nl.applRegNtnCd+'" value="'+nl.applRegNtnCd+'"';
				if(i < 5) $tr += 'checked="checked"';
				$tr += '/></td>';
				$tr += '<td style="text-align: left;">'+nl.applRegNtnNm+'</td>';
				$tr += '<td><div id="chartdiv_'+nl.applRegNtnCd+'" align="left"></div><input type="hidden" name="no_fillColorIndex_'+nl.applRegNtnCd+'" id="no_fillColorIndex_'+nl.applRegNtnCd+'" value="'+fc+'" /></td>';
				if(fc++ > fillColors.length-1) fc = 0;
				$tr += "</tr>";
				$tbody += $tr;
			}
		}else{
			var $tr = '<tr><td colspan="99" style="padding-left:5px;"><img src="${contextPath}/images/layout/ico_info.png" /> 검색된 Data가 없습니다.</td></tr>';
			$tbody += $tr;
		}
         $("#publicationsTbl tbody").html($tbody);
         printDataTable();

         for(var i=0; i<data.nationList.length; i++){
             var nl = data.nationList[i];
             eval( "var chart_Chart"+nl.applRegNtnCd+" =  new FusionCharts({type:'Bar2D',renderAt:'chartdiv_"+nl.applRegNtnCd+"',width:'"+barWidth+"',height:'35',dataFormat:'xml',dataSource:\""+nl.chartXML+"\"}).render()");
         }

         if(data.applRegNtnCdList.length > 0){
             $("#publicationsTbl").trigger("update");

             $('input:checkbox').bind('click', function(){ clickCheckbox($(this));});
         }

         $('.wrap-loading').css('display', 'none');

		 if(idx == '0'){
			 $.tablesorter.addParser({
				 // set a unique id
				 id: 'patentCo',
				 is: function(s) {
					 // return false so this parser is not auto detected
					 return false;
				 },
				 format: function(s) {
					 return s.match(/Chart([0-9]*)/i)[1];
				 },
				 // set type, either numeric or text
				 type: 'numeric'
			 });

			 $("#publicationsTbl").tablesorter({
				 sortList:[[2,1]],
				 headers: {
					 0: {
						 sorter: false
					 },
					 2: {
						 sorter:'patentCo'
					 }
				 }
			 });
		 }
     });
 }

 function printDataTable(){
	$('#dataTbl').html("");
	var fy = parseInt($('#fromYear').val(),10);
	var ty = parseInt($('#toYear').val(),10);
	var thead = $('<thead></thead>');
	var trTh = $('<tr style="height:20px;"><th><span>구분</span></th></tr>');
	var countCol = 0;
	for(var i=fy; i <= ty; i++){
		trTh.append($('<th class="center">'+i+'</th>'));
		countCol++;
	}
	trTh.append($('<th><span>계</span></th>'));
	countCol++;

	var width = 400 + countCol*55;
	$('#dataTbl').css('width',width+"px");
	thead.append(trTh);
	$('#dataTbl').append(thead);

	var tbody  = $('<tbody></tbody>');
	for(var j=0; j < djArr.length; j++){
		var name = djArr[j].applRegNtnNm ;
		var code = djArr[j].applRegNtnCd ;
		var trTd = $('<tr style="height:17px;" id="data_'+code+'"><td>'+name+'</td></tr>');
		var sum = 0;
		for(var i=fy; i <= ty; i++){
			var val = djArr[j][i] == undefined ? 0 : djArr[j][i];
			trTd.append($('<td style="text-align:center;padding-right:5px;">'+commaNum(val)+'</td>'));
			sum += Number(val);
		}
		trTd.append($('<td style="text-align:center;">'+commaNum(sum)+'</td>'));
		tbody.append(trTd);
	}
	$('#dataTbl').append(tbody);
 }

 function clickCheckbox(obj){

		if($(obj).prop('id') == "toggleChkbox")
		{
			if($(obj).prop("checked") == true)
			{
				$('input[id^="no_chkbox_"]').prop('checked', true);
			}
			else
			{
				$('input[id^="no_chkbox_"]').prop('checked', false);
			}
		}

		//(.*dataXML=)(<chart .*>)(<categories.*)(<styles.*)
		var chartId = "ChartId1";
		var category = "<categories>";
		var fy = parseInt($('#fromYear').val(),10);
		var ty = parseInt($('#toYear').val(),10);

		for(var i=fy; i <= ty; i++){
			category += "<category label='"+i+"' />";
		}
		category += "</categories>";

		var dataset = "";
		for(var i=0; i < djArr.length; i++){
			if($('#no_chkbox_'+djArr[i].applRegNtnCd).is(':checked')){
				var color = fillColors[$('#no_fillColorIndex_'+djArr[i].applRegNtnCd).val()];
				dataset += "<dataset seriesName='"+djArr[i].applRegNtnNm+"' color='"+color+"' anchorBorderColor='"+color+"' id='"+djArr[i].applRegNtnCd+"' >";
				for(var j=fy; j <= ty; j++){
					var val = djArr[i][j] == undefined ? 0 : djArr[i][j];
					var toolText = djArr[i].applRegNtnNm+" "+j+" :" + val;
					dataset += "<set value='"+val+"' toolText='"+toolText+"' />";
				}
				dataset += "</dataset>";
			}
		}
		var chartData = chart_ChartId1.getChartData('xml');
 	    chartData = chartData.replace(/(<chart .*>)(<categories.*)(<styles.*)/, '$1'+category+dataset+'$3');
 		console.log(chartData);
 	    chart_ChartId1.setDataXML(chartData);
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
	 $("#tabs").tabs({active:0});
	 if( chart_ChartId1.hasRendered() ) chart_ChartId1.exportChart( { exportFormat : 'png'} );
 }
 function saveExcel(fileName){

	 var div = $('<div></div>');
	 var table = $('<table></table>');
	 var chartTitle = $('<tr><td style="text-align:center;" colspan="5"><h1><p>Researcher(${item.korNm}) - '+$('.page_title').html()+'</p></h1></td></tr>');
	 var chartTr = $('<tr><td><img src="'+fileName+'" height="350" /></td></tr>');
	 var dataTitle = $('<tr><td><h1>Chart Data</h1></td></tr>');
	 table.append(chartTitle)
			 .append(chartTr)
			 .append(dataTitle);

	 var dTbl = $('<table class="list_tbl mgb_20"></table>');
	 dTbl.append($('#dataTbl > thead').clone().wrapAll('<div/>').parent().html());
	 var dataTbody = $('<tbody></tbody>');
	 var chb = $('input[id^="no_chkbox_"]:checked');
	 for(var i=0; i < chb.length ; i++){
		 var id = chb.eq(i).val();
		 dataTbody.append($('#data_'+id).clone().wrapAll('<div/>').parent().html());
	 }
	 dTbl.append(dataTbody);
	 table.append($('<tr><td>'+dTbl.clone().wrapAll('<div/>').parent().html()+'</td></tr>'));
	 div.append(table);

	 $('#tableHTML').val(div.html());
	 var excelFileName = "patentByNation_from_" + $('#fromYear').val() +"_to_" + $('#toYear').val() + ".xls";
	 $('#fileName').val(excelFileName);
	 exportLog($('#frm'), excelFileName + "|" +  fileName);
	 $('#excelFrm').submit();
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

	<h3 class="page_title"><spring:message code="menu.asrms.rsch.patentNation"/></h3>
	<div class="help_text mgb_30"><spring:message code="asrms.researcher.patent.nation.desc"/></div>

	<form id="frm" name="frm">
	<input type="hidden" id="topNm" name="topNm" value="<c:out value="${topNm}"/>"/>
	<input type="hidden" name="userId" id="userId" value="<c:out value="${parameter.userId}"/>"/>
	<input type="hidden" name="mode" id="mode" value="<c:out value="${parameter.mode}"/>"/>
	<input type="hidden" name="srchUserId" id="srchUserId" value="<c:out value="${parameter.srchUserId}"/>"/>
	<input type="hidden" name="srchUserPhotoUrl" id="srchUserPhotoUrl" value="<c:out value="${parameter.srchUserPhotoUrl}"/>"/>
		
	<!--START page_function-->

		<div class="top_option_box">
			<div class="to_inner">
				<span>Class</span>
				<em>
					<select name="acqsDvsCd" id="acqsDvsCd" onchange="javascript:acqsChange();">${rims:makeCodeList('1090',true,parameter.acqsDvsCd)}</select>
				</em>
				<em style="display:none;">
					<select name="status" id="status" mode="checkbox" >${rims:makeCodeList('patent.status',true,parameter.status)}</select>
				</em>
				<span>Year Range</span>
				<em>
					<select name="fromYear" id="fromYear">
						<c:forEach var="yl" items="${patYearList}" varStatus="idx" end="50">
							<c:choose>
								<c:when test="${fn:length(patYearList) > 5}">
									<option value="${yl.patYear }" ${idx.index == 5 ? 'selected="selected"' : '' }>${yl.patYear }</option>
								</c:when>
								<c:otherwise>
									<option value="${yl.patYear }" ${idx.last == true? 'selected="selected"' : '' }>${yl.patYear }</option>
								</c:otherwise>
							</c:choose>
						</c:forEach>
					</select>
				</em>
				~
				<em>
					<select name="toYear" id="toYear">
						<c:forEach var="yl" items="${patYearList}" varStatus="idx" end="50">
							<option value="${yl.patYear }">${yl.patYear }</option>
						</c:forEach>
					</select>
				</em>
			</div>

			<p class="ts_bt_box">
				<a href="javascript:patentByNationAjax();" class="to_search_bt"><span>Search</span></a>
			</p>
		</div>

	<div id="tabs" class="tab_wrap mgb_10" style="display: none;">
	  <ul>
		<li><a href="#tabs-1">Chart</a></li>
		<li><a href="#tabs-2">Data</a></li>
	  </ul>
		<div id="tabs-1">
			<!--START sub_content_wrapper-->
			<div class="chart_box">
			   <div id="chartdiv1" align="left"></div>
			</div>
			<!--END sub_content_wrapper-->
		</div>
		<div id="tabs-2">
			<div id="content_wrap" style="width: 100%;overflow: auto;">
				<table height="370px" id="dataTbl" class="tab_tbl mgb_20">
				</table>
			</div>
		</div>
	</div>

	<p class="bt_box mgb_20"><a href="#" onclick="exportExcel();" class="black_bt"><em class="export_icon">Export</em></a></p>

	<table width="100%" id="publicationsTbl" class="list_tbl mgb_20">
		<colgroup>
			<col style="width: 5%"/>
			<col style="width: 30%"/>
			<col style="width: 60%"/>
		</colgroup>
		<thead>
			<tr>
				<th style="padding-left: 12px;"><span><input type="checkbox" name="toggleChkbox" id="toggleChkbox" value="0"/></span></th>
				<th><span>국가</span></th>
				<th><span>특허수</span></th>
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
