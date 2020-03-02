<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><spring:message code="menu.asrms.clg.cited"/></title>
<style type="text/css" rel="stylesheet">
th.header {
    cursor: pointer;
    background-repeat: no-repeat;
    background-position: center right;
    padding-right: 15px;
    margin-right: -1px;
}
.to_inner span {min-width: 70px;}
</style>
 <script type="text/javascript">
 var fc = 0;
 var chart_ChartId1;
 var djArr;

 $(document).ready(function(){
	 $( "#tabs" ).tabs({	});
	 $("#tabs").css("display", "block");
	 departTimeCitedAjax('0');
 });

 function departTimeCitedAjax(idx){
     if(!validateRange()){errorMsg(this); return false;}

     $.ajax({
		 url:"<c:url value="/analysis/college/departTimeCitedAjax.do"/>",
		 dataType: "json",
		 data: $('#frm').serialize(),
		 method: "POST",
		 beforeLoad: $('.wrap-loading').css('display', '')

	 }).done(function(data){
		 djArr = eval('('+ data.dataJson+')');

		 $('#fromYear').data('prev', $('#fromYear').val());
		 $('#toYear').data('prev', $('#toYear').val());

		 if(FusionCharts('artChart')) {
			 FusionCharts('artChart').dispose();
			 $('#chartdiv1').disposeFusionCharts().empty();
		 }

		 var chartWidth = "100%";
		 var barWidth = "100%";
		 if(browserType() == "I"){
			 chartWidth = "748";
			 barWidth = "600";
		 }

		 chart_ChartId1 =  new FusionCharts({
			 id:'artChart',
			 type:'MSLine',
			 renderAt:'chartdiv1',
			 width:chartWidth,
			 height:'350',
			 dataFormat:'xml',
			 dataSource: data.chartXML
		 }).render();

         fc = 0;
		 var $tbody = "";
		 for(var i=0; i<data.departList.length; i++){

			 var dl = data.departList[i];
			 var $tr = "<tr>";
			 $tr += '<td style="text-align: center;"><input type="checkbox"  id="no_chkbox_'+dl.deptCode+'" value="'+dl.deptCode+'"';
			 if(i < 5) $tr += 'checked="checked"';
			 $tr += '/><input type="hidden" name="no_fillColorIndex_'+dl.deptCode+'" id="no_fillColorIndex_'+dl.deptCode+'" value="'+fc+'" /></td>';
			 $tr += '<td style="text-align: left;">'+dl.deptKor+'</td>';
			 $tr += '<td><div id="chartdiv_'+dl.deptCode+'" align="left"></div></td>';
			 if(fc++ > fillColors.length-1) fc = 0;
			 $tr += "</tr>";
			 $tbody += $tr;
		 }

		 $("#publicationsTbl tbody").html($tbody);

         for(var i=0; i<data.departList.length; i++){
             var dl = data.departList[i];
             eval( "var chart_Chart"+dl.deptCode+" =  new FusionCharts({type:'Bar2D',renderAt:'chartdiv_"+dl.deptCode+"',width:'"+barWidth+"',height:'35',dataFormat:'xml',dataSource:\""+dl.chartXML+"\"}).render()");
         }

		 $('input:checkbox').bind('click', function(){ clickCheckbox($(this));});

		 printDataTable();

		 $('.wrap-loading').css('display', 'none');
	 });
 }

 function printDataTable(){
	 $('#dataTbl').html("");
	 var fy = parseInt($('#fromYear').val(),10);
	 var ty = parseInt($('#toYear').val(),10);
	 var thead = $('<thead></thead>');
	 var trTh = $('<tr style="height:20px;"><th><span>학(부)과명</span></th></tr>');
	 var countCol = 0;
	 for(var i=fy; i <= ty; i++){
		 trTh.append($('<th><span>'+i+'</span></th>'));
		 countCol++;
	 }
	 var width = 500 + countCol*50;
	 $('#dataTbl').css('width',width+"px");

	 thead.append(trTh)
	 $('#dataTbl').append(thead);

	 var tbody  = $('<tbody></tbody>');
	 for(var j=0; j < djArr.length; j++){
		 var name = djArr[j].deptKor ;
		 var trTd = $('<tr style="height:17px;" id="data_'+djArr[j].deptCode+'"><td>'+name+'</td></tr>');
		 for(var i=fy; i <= ty; i++){
			 var val = djArr[j][i] == undefined ? 0 : parseFloat(djArr[j][i]);
			 val = val / 1;
             val = (val.toFixed(2)*1).toString();
			 trTd.append($('<td style="text-align:center;padding-right:5px;">'+val+'</td>'));
		 }
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

		 if($('#no_chkbox_'+djArr[i].deptCode).is(':checked')){
			 var color = fillColors[$('#no_fillColorIndex_'+djArr[i].deptCode).val()];
			 dataset += "<dataset seriesName='"+djArr[i].deptKor+"' color='"+color+"' id='"+djArr[i].deptCode+"' >";
			 for(var j=fy; j <= ty; j++){
				 var val = djArr[i][j] == undefined ? 0 : parseFloat(djArr[i][j]);
				 val = val / 1;
                 val = (val.toFixed(2)*1).toString();
				 var toolText = djArr[i].deptKor+" "+j+" :" + val;
				 dataset += "<set value='"+val+"' toolText='"+toolText+"' />";

			 }
			 dataset += "</dataset>";
		 }
	 }

	 var chartData = chart_ChartId1.getChartData('xml');
	 chartData = chartData.replace(/(<chart .*>)(<categories.*)(<styles.*)/, '$1'+category+dataset+'$3');
	 //console.log(chartData);
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
	 var chartTitle = $('<tr><td style="text-align:center;"><h1><p>College(${item.codeDisp}) - '+$('.page_title').html()+'</p></h1></td></tr>');
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
	 var excelFileName = "DepartmentCitationCompare_"+$('#gubun').val() + "_from_" + $('#fromYear').val() +"_to_" + $('#toYear').val() + ".xls";
	 $('#fileName').val(excelFileName);
	 exportLog($('#frm'), excelFileName + "|" +  fileName);
	 $('#excelFrm').submit();
 }
 </script>
</head>
<body>

	<h3 class="page_title"><spring:message code="menu.asrms.clg.cited.page"/></h3>
	<div class="help_text mgb_30"><spring:message code="asrms.college.citation.comp.desc"/></div>

	<form id="frm" name="frm">
	<input type="hidden" id="topNm" name="topNm" value="<c:out value="${topNm}"/>"/>
	<input type="hidden" name="clgCd" id="clgCd" value="<c:out value="${parameter.clgCd}"/>"/>

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
					<option value="SCI" selected="selected">SCI</option>
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
			<a href="javascript:departTimeCitedAjax();" class="to_search_bt"><span>Search</span></a>
		</p>
	</div>

	<div id="tabs" class="tab_wrap mgb_10" style="display: none;">
	  <ul>
	    <li><a href="#tabs-1">Chart</a></li>
	    <li><a href="#tabs-2">Data</a></li>
	  </ul>
  		<div id="tabs-1">
		   <div id="chartdiv1" align="left" class="chart_box"></div>
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
				<th><span>학(부)과명</span></th>
				<th><span>평균 피인용횟수</span></th>
			</tr>
		</thead>
		<tbody></tbody>
	</table>
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
