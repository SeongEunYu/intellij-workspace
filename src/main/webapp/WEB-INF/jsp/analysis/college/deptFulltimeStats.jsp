<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Department Full Time SCI Average Citation </title>
<script type="text/javascript">
 var article_djArr;
 var citation_djArr;
 var impact_djArr;

 $(function() {
	$( "#tabs" ).tabs({});
	$("#tabs").css("display", "block");

     fulltimeStatsAjax();
  });

 function fulltimeStatsAjax(){
     if(!validateRange()){errorMsg(this); return false;}

     $.ajax({
         url:"<c:url value="/analysis/college/fulltimeStatsAjax.do"/>",
         dataType: "json",
         data: $('#frm').serialize(),
         method: "POST",
         beforeLoad: $('.wrap-loading').css('display', '')

     }).done(function(data){
         article_djArr = eval('('+ data.article_dataJson+')');
         citation_djArr = eval('('+ data.citation_dataJson+')');
         impact_djArr = eval('('+ data.impact_dataJson+')');

         $('#fromYear').data('prev', $('#fromYear').val());
         $('#toYear').data('prev', $('#toYear').val());

         if(FusionCharts('ChartId1')) {
             FusionCharts('ChartId1').dispose();
             $('#chartdiv1').disposeFusionCharts().empty();
         }
         if(FusionCharts('ChartId2')) {
             FusionCharts('ChartId2').dispose();
             $('#chartdiv2').disposeFusionCharts().empty();
         }
         if(FusionCharts('ChartId3')) {
             FusionCharts('ChartId3').dispose();
             $('#chartdiv3').disposeFusionCharts().empty();
         }

         new FusionCharts({
             id: 'ChartId1',
             type:'MSLine',
             renderAt:'chartdiv1',
             width:'100%',
             height:'350',
             dataFormat:'xml',
             dataSource:data.chartXML+""
         }).render();

         new FusionCharts({
             id: 'ChartId2',
             type:'MSLine',
             renderAt:'chartdiv2',
             width:'100%',
             height:'350',
             dataFormat:'xml',
             dataSource:data.chartXML1+""
         }).render();

         new FusionCharts({
             id: 'ChartId3',
             type:'MSLine',
             renderAt:'chartdiv3',
             width:'100%',
             height:'350',
             dataFormat:'xml',
             dataSource:data.chartXML2+""
         }).render();

         article_printDataTable();
         citation_printDataTable();
         impact_printDataTable();

         $('input:checkbox').bind('click', function(){ clickCheckbox($(this));});
         $('.wrap-loading').css('display', 'none');
     });
 }

 function article_printDataTable(){
     $("#article_dataTbl").html("");
	 if(article_djArr.length > 0){
		$('#article_disp_txt').text('');
		var fy = parseInt($('#fromYear').val(),10);
		var ty = parseInt($('#toYear').val(),10);
		var thead = $('<thead></thead>');
		var trTh = $('<tr style="height:20px;"><th style="width:15px;"></th><th><span>학(부)과</span></th></tr>');
		var countCol = 0;
		for(var i=fy; i <= ty; i++){
			trTh.append($('<th><span>'+i+'</span></th>'));
			countCol++;
		}
		/*var width = 250 + countCol*50;
		width = width > 821 ? width : 821;
		$('#article_dataTbl').css('width',width+"px");*/

		thead.append(trTh)
		$('#article_dataTbl').append(thead);

		var tbody  = $('<tbody></tbody>');
		for(var j=0; j < article_djArr.length; j++){
			var name = article_djArr[j].deptKor;
			var checked = j > 4 ? '' : 'checked="checked"';
			var trTd = $('<tr style="height:17px;" id="art_data_'+article_djArr[j].deptCode+'"><td class="center"><input type="checkbox"  id="article_chkbox_'+article_djArr[j].deptCode+'" value="'+article_djArr[j].deptCode+'" '+checked+'/></td><td>'+name+'</td></tr>');
			for(var i=fy; i <= ty; i++){
				var val = article_djArr[j][i] == undefined ? 0 : article_djArr[j][i];
				trTd.append($('<td class="center">'+(val.toFixed(2)*1).toString()+'</td>'));
			}
			tbody.append(trTd);
		}
		$('#article_dataTbl').append(tbody);
	 }else{
		$('#article_disp_txt').text('No data to display');
	 }
}

 function citation_printDataTable(){
     $("#citation_dataTbl").html("");
	 if(citation_djArr.length > 0){
		$('#citation_disp_txt').text('');
		var fy = parseInt($('#fromYear').val(),10);
		var ty = parseInt($('#toYear').val(),10);
		var thead = $('<thead></thead>');
		var trTh = $('<tr style="height:20px;"><th style="width:15px;"></th><th><span>학(부)과</span></th></tr>');
		var countCol = 0;
		for(var i=fy; i <= ty; i++){
			trTh.append($('<th><span>'+i+'</span></th>'));
			countCol++;
		}
		/*var width = 250 + countCol*50;
		width = width > 821 ? width : 821;
		$('#citation_dataTbl').css('width',width+"px");*/

		thead.append(trTh)
		$('#citation_dataTbl').append(thead);

		var tbody  = $('<tbody></tbody>');
		for(var j=0; j < citation_djArr.length; j++){
			var name = citation_djArr[j].deptKor;
			var id = citation_djArr[j].deptCode;
			var checked = j > 4 ? '' : 'checked="checked"';
			var trTd = $('<tr style="height:17px;" id="tc_data_'+id+'"><td class="center"><input type="checkbox"  id="citation_chkbox_'+id+'" value="'+id+'" '+checked+'/></td><td>'+name+'</td></tr>');
			for(var i=fy; i <= ty; i++){
				var val = citation_djArr[j][i] == undefined ? 0 : citation_djArr[j][i];
				trTd.append($('<td class="center">'+(val.toFixed(2)*1).toString()+'</td>'));
			}
			tbody.append(trTd);
		}
		$('#citation_dataTbl').append(tbody);
	 }else{
		$('#citation_disp_txt').text('No data to display');
	 }
 }

 function impact_printDataTable(){
     $("#impact_dataTbl").html("");
	 if(impact_djArr.length > 0){
		$('#impact_disp_txt').text('');
		var fy = parseInt($('#fromYear').val(),10);
		var ty = parseInt($('#toYear').val(),10);
		var thead = $('<thead></thead>');
		var trTh = $('<tr style="height:20px;"><th style="width:15px;"></th><th><span>학(부)과</span></th></tr>');
		var countCol = 0;
		for(var i=fy; i <= ty; i++){
			trTh.append($('<th><span>'+i+'</span></th>'));
			countCol++;
		}
		/*var width = 250 + countCol*50;
		width = width > 821 ? width : 821;
		$('#impact_dataTbl').css('width',width+"px");*/

		thead.append(trTh)
		$('#impact_dataTbl').append(thead);

		var tbody  = $('<tbody></tbody>');
		for(var j=0; j < impact_djArr.length; j++){
			var name = impact_djArr[j].deptKor;
			var checked = j > 4 ? '' : 'checked="checked"';
			var trTd = $('<tr style="height:17px;" id="if_data_'+impact_djArr[j].deptCode+'"><td class="center"><input type="checkbox"  id="impact_chkbox_'+impact_djArr[j].deptCode+'" value="'+impact_djArr[j].deptCode+'" '+checked+'/></td><td>'+name+'</td></tr>');
			for(var i=fy; i <= ty; i++){
				var val = impact_djArr[j][i] == undefined ? 0 : impact_djArr[j][i];
				trTd.append($('<td class="center">'+(val.toFixed(2)*1).toString()+'</td>'));
			}
			tbody.append(trTd);
		}
		$('#impact_dataTbl').append(tbody);
	 }else{
		$('#impact_disp_txt').text('No data to display');
	 }
}

 function clickCheckbox(obj){
		//(.*dataXML=)(<chart .*>)(<categories.*)(<styles.*)
		var djArr;
		var chkId = obj.attr('id');
		var chartId;
		var prefix;
		var articleReg = /article_/i;
		var citationReg = /citation_/i;
		var impactReg = /impact_/i;

		if(articleReg.test(chkId)){
			djArr = article_djArr;
			chartId = "ChartId1";
			prefix = "article_";
		}
		if(citationReg.test(chkId)){
			djArr = citation_djArr;
			chartId = "ChartId2";
			prefix = "citation_";
		}
		if(impactReg.test(chkId)){
			djArr = impact_djArr;
			chartId = "ChartId3";
			prefix = "impact_";
		}

		var category = "<categories>";
		var fy = parseInt($('#fromYear').val(),10);
		var ty = parseInt($('#toYear').val(),10);

		for(var i=fy; i <= ty; i++){
			category += "<category label='"+i+"' />";
		}
		category += "</categories>";

		var dataset = "";
		for(var i=0; i < djArr.length; i++){
			if($('#'+prefix +'chkbox_'+djArr[i].deptCode).is(':checked')){
				var fcIdx = i % 23;
				var color = fillColors[fcIdx];
				dataset += "<dataset seriesName='"+djArr[i].deptKor+"' color='"+color+"' id='"+djArr[i].deptKor+"' >";
				for(var j=fy; j <= ty; j++){
					var val = djArr[i][j] != undefined ? djArr[i][j] : '0';
					var toolText = djArr[i].deptKor+" "+j+" : " + val;
					dataset += "<set value='"+val+"' toolText='"+toolText+"' />";
				}
				dataset += "</dataset>";
			}
		}

		 var chartData = getChartFromId(chartId).getChartData('xml');
		 chartData = chartData.replace(/(<chart .*>)(<categories.*)(<styles.*)/, '$1'+category+dataset+'$3');
    	 getChartFromId(chartId).setDataXML(chartData);
}
 var chartFileArr = new Array();
//Callback handler method which is invoked after the chart has saved image on server.
 function myFN_IF(objRtn){
 	if (objRtn.statusCode=="1"){
 		chartFileArr.push(objRtn.fileName);
 		if(chartFileArr.length == 3) saveExcel();
 		//alert("The chart was successfully saved on server. The file can be accessed from " + objRtn.fileName);
 	}else{
 		alert("The chart could not be saved on server. There was an error. Description : " + objRtn.statusMessage);
 	}
 }
 function myFN_TC(objRtn){
 	if (objRtn.statusCode=="1"){
 		chartFileArr.push(objRtn.fileName);
 		//if(chartFileArr.length == 2) saveExcel();
 		$("#tabs").tabs({active:2});

 		setTimeout(function() {
		 	var chartObject = getChartFromId('ChartId3');
		 	if( chartObject.hasRendered() ) chartObject.exportChart( { exportFormat : 'png'} );
 		}, 1000);

 		//alert("The chart was successfully saved on server. The file can be accessed from " + objRtn.fileName);
 	}else{
 		alert("The chart could not be saved on server. There was an error. Description : " + objRtn.statusMessage);
 	}
 }
 function myFN_ART(objRtn){
	 if (objRtn.statusCode=="1"){
 		chartFileArr.push(objRtn.fileName);
 		//if(chartFileArr.length == 2) saveExcel();
 		$("#tabs").tabs({active:1});

 		setTimeout(function() {
		 	var chartObject = getChartFromId('ChartId2');
		 	if( chartObject.hasRendered() ) chartObject.exportChart( { exportFormat : 'png'} );
 		}, 1000);

 		//alert("The chart was successfully saved on server. The file can be accessed from " + objRtn.fileName);
 	}else{
 		alert("The chart could not be saved on server. There was an error. Description : " + objRtn.statusMessage);
 	}
 }
 function exportExcel(){
	 $("#tabs").tabs({active:0});
	  setTimeout(function() {
		var chartObject2 = getChartFromId('ChartId1');
		if( chartObject2.hasRendered() ) chartObject2.exportChart( { exportFormat : 'png'} );
	  }, 1000);
 }
 function saveExcel(){

	 var div = $('<div></div>');
	 var table = $('<table></table>');
	 //append document title
	 var chartTitle = $('<tr><td style="text-align:center;"><h1><p>College(${item.codeDisp}) - '+$('.page_title').html()+'</p></h1></td></tr>');
	 table.append(chartTitle);
	 //append chart image & data
	 	//Article
	 var chart1Title = $('<tr><td></td></tr><tr><td><h3>전임교원 1인당 평균 논문수 Chart</h3></td></tr>');
	 var chart1Tr = $('<tr><td><img src="'+chartFileArr[0]+'" height="350"/></td></tr>');
	 var artDataTitle = $('<tr><td><h3>전임교원 1인당 평균 논문수 Data</h3></td></tr>');
	 table.append(chart1Title)
	      .append(chart1Tr)
	      .append(artDataTitle);


	 //make table with data of checked department
	 var artDataTbl = $('<table class="list_tbl mgb_20"></table>');
	 var artThead = $('#article_dataTbl > thead').clone();
	 artThead.find('tr th:first-child').remove();
	 artDataTbl.append(artThead.wrapAll('<div/>').parent().html());
	 var artTbody = $('<tbody></tbody>');
	 var chb = $('input[id^="article_chkbox_"]:checked');
	 for(var i=0; i < chb.length ; i++){
		 var id = chb.eq(i).val();
		 var artTr = $('#art_data_'+id).clone();
		 artTr.find('td:first-child').remove();
		 artTbody.append(artTr.wrapAll('<div/>').parent().html());
	 }
	 artDataTbl.append(artTbody);
	 table.append($('<tr><td>'+artDataTbl.wrapAll('<div/>').parent().html()+'</td></tr>'));

	 	//Citation
	 var chart2Title = $('<tr><td></td></tr><tr><td><h3>전임교원 1인당 평균 피인용횟수 Chart</h3></td></tr>');
	 var chart2Tr = $('<tr><td><img src="'+chartFileArr[1]+'" height="350"/></td></tr>');
	 var tcDataTitle = $('<tr><td><h3>전임교원 1인당 평균 피인용횟수 Data</h3></td></tr>');
	 table.append(chart2Title)
	      .append(chart2Tr)
	      .append(tcDataTitle);


	 //make table with data of checked department
	 var tcDataTbl = $('<table class="list_tbl mgb_20"></table>');
	 var tcThead = $('#citation_dataTbl > thead').clone();
	 tcThead.find('tr th:first-child').remove();
	 tcDataTbl.append(tcThead.wrapAll('<div/>').parent().html());
	 var tcTbody = $('<tbody></tbody>');
	     chb = $('input[id^="citation_chkbox_"]:checked');
	 for(var i=0; i < chb.length ; i++){
		 var id = chb.eq(i).val();
		 var tcTr = $('#tc_data_'+id).clone();
		 tcTr.find('td:first-child').remove();
		 tcTbody.append(tcTr.wrapAll('<div/>').parent().html());
	 }
	 tcDataTbl.append(tcTbody);
	 table.append($('<tr><td>'+tcDataTbl.wrapAll('<div/>').parent().html()+'</td></tr>'));

	 	//Impact Factor
	 var chart3Title = $('<tr><td></td></tr><tr><td><h3>전임교원 1인당 평균 Impact Factor Chart</h3></td></tr>');
	 var chart3Tr = $('<tr><td><img src="'+chartFileArr[2]+'" height="350"/></td></tr>');
	 var ifDataTitle = $('<tr><td><h3>전임교원 1인당 평균 Impact Factor Data</h3></td></tr>');
	 table.append(chart3Title)
	      .append(chart3Tr)
          .append(ifDataTitle);

	 //make table with data of checked department
	 var ifDataTbl = $('<table class="list_tbl mgb_20"></table>');
	 var ifThead = $('#impact_dataTbl > thead').clone();
	 ifThead.find('tr th:first-child').remove();
	 ifDataTbl.append(ifThead.wrapAll('<div/>').parent().html());
	 var ifTbody = $('<tbody></tbody>');
	     chb = $('input[id^="citation_chkbox_"]:checked');
	 for(var i=0; i < chb.length ; i++){
		 var id = chb.eq(i).val();
		 var ifTr = $('#if_data_'+id).clone();
		 ifTr.find('td:first-child').remove();
		 ifTbody.append(ifTr.wrapAll('<div/>').parent().html());
	 }
	 ifDataTbl.append(ifTbody);
	 table.append($('<tr><td>'+ifDataTbl.wrapAll('<div/>').parent().html()+'</td></tr>'));

	 div.append(table);
	 $('#tableHTML').val(div.html());

	 var excelFileName = "DepartmentFulltimeStats_"+$('#stndMonthDay').val() + "_from_" + $('#fromYear').val() +"_to_" + $('#toYear').val() + ".xls";
	 $('#fileName').val(excelFileName);
	 exportLog($('#frm'), excelFileName + "|" +  chartFileArr);
	 chartFileArr = new Array();
	 $('#excelFrm').submit();
 }
 </script>
</head>
<body>
	<h3 class="page_title"><spring:message code="menu.asrms.clg.fulltimeStats"/></h3>
	<div class="help_text mgb_30"><spring:message code="asrms.college.fulltime.year.article.desc"/></div>

	<form id="frm" name="frm">
	<input type="hidden" name="clgCd" id="clgCd" value="<c:out value="${parameter.clgCd}"/>"/>
	<input type="hidden" id="topNm" name="topNm" value="<c:out value="${topNm}"/>"/>
	<input type="hidden" name="isStndChanged" id="isStndChanged" value="false"/>
	<div class="top_option_box">
		<div class="to_inner">
			<span>기준일자</span>
			<em>
				<select name="stndMonthDay" id="stndMonthDay" onchange="javascript: $('#isStndChanged').val('true');">
					<c:forEach items="${stndMonthDayList}" var="stndMD" varStatus="stats">
						<option value="<c:out value="${stndMD.stndMonth}"/>-<c:out value="${stndMD.stndDay}"/>" ${stats.last == true ? 'selected="selected"' : ''}><c:out value="${stndMD.stndMonth}"/>월 <c:out value="${stndMD.stndDay}"/>일</option>
					</c:forEach>
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
					<c:forEach items="${stndYearList}" var="stndY" varStatus="stats">
						<option value="<c:out value="${stndY.stndYear}"/>" ${stats.index == 5 ? 'selected="selected"' : ''}><c:out value="${stndY.stndYear}"/></option>
					</c:forEach>
				</select>
	
			</em>					~<em>
				<select name="toYear" id="toYear">
					<c:forEach items="${stndYearList}" var="stndY" varStatus="stats">
						<option value="<c:out value="${stndY.stndYear}"/>" ${stats.index == 1 ? 'selected="selected"' : ''}><c:out value="${stndY.stndYear}"/></option>
					</c:forEach>
				</select>
			</em>
		</div>
		<p class="ts_bt_box">
			<a href="javascript:fulltimeStatsAjax();" class="to_search_bt"><span>Search</span></a>
		</p>
	</div>

	<h3 class="circle_h3">Chart</h3>
	<div id="tabs" class="tab_wrap" style="display: none;">
	  <ul>
	    <li><a href="#tabs-1">Article</a></li>
	    <li><a href="#tabs-2">Citation</a></li>
	    <li><a href="#tabs-3">Impact Factor</a></li>
	  </ul>
		<div id="tabs-1">
			<div id="chartdiv1" class="chart_box mgb_10" ></div>
			<p class="bt_box mgb_20"><a href="#" onclick="exportExcel();" class="black_bt"><em class="export_icon">Export</em></a></p>
			<h3 class="circle_h3">Data</h3>
			<div class="sub_content_wrapper" style="width: 100%;overflow: auto;">
				<table id="article_dataTbl" class="list_tbl mgb_20">
				</table>
			</div>
		</div>

		<div id="tabs-2">
			<div id="chartdiv2" class="chart_box mgb_10"></div>
			<p class="bt_box mgb_20"><a href="#" onclick="exportExcel();" class="black_bt"><em class="export_icon">Export</em></a></p>
			<h3 class="circle_h3">Data</h3>
			<div class="sub_content_wrapper" style="width: 100%;overflow: auto;">
				<table id="citation_dataTbl" class="list_tbl mgb_20">
				</table>
			</div>
		</div>

		<div id="tabs-3">
			<div id="chartdiv3" class="chart_box mgb_10" ></div>
			<p class="bt_box mgb_20"><a href="#" onclick="exportExcel();" class="black_bt"><em class="export_icon">Export</em></a></p>
			<h3 class="circle_h3">Data</h3>
			<div class="sub_content_wrapper" style="width: 100%;overflow: auto;">
				<table id="impact_dataTbl" class="list_tbl mgb_20">
				</table>
			</div>
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
