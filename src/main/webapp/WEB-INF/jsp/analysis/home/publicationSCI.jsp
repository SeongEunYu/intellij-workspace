<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Publications</title>
<script type="text/javascript" src="${contextPath}/js/jquery/jquery.number.min.js"></script>
<script type="text/javascript" src="${contextPath}/js/jquery/jquery.form.js"></script>
<script>
var djArr = eval('('+ '${dataJson}'+')');

 $(document).ready(function(){

	 $('#fromYear').data('prev', $('#fromYear').val());
	 $('#toYear').data('prev', $('#toYear').val());

	 $("#tabs").tabs({
			active: '<c:out value="${sTabIdx}"/>',
			activate: function( event, ui ) {
				//clickCheckbox();
				if(ui.newPanel.is('#tabs-1')) $('#sTabIdx').val('0');
				if(ui.newPanel.is('#tabs-2')) $('#sTabIdx').val('1');
			},
			beforeActivate:function( event, ui ) {
				if(ui.newPanel.is('#tabs-1')) $('#prefix').val('no_');
				if(ui.newPanel.is('#tabs-2')) $('#prefix').val('if_');
			}
	});
	$("#tabs").css("display", "block");

	printDataTable();
	renderChart();
 });

function renderChart(){
   var chart_ChartId1 =  new FusionCharts({
 	  type:'MSLine',
 	  renderAt:'chartdiv1',
 	  width:'748',
 	  height:'350',
 	  dataFormat:'xml',
 	  dataSource:"${chartXML}"
   }).render();
}

 function printDataTable(){

	 if(djArr.length > 0){
		$('#disp_txt').text('');
		var fy = parseInt($('#fromYear').val(),10);
		var ty = parseInt($('#toYear').val(),10);
		var thead = $('<thead></thead>');
		var trTh = $('<tr style="height:20px;"><th><span>Year</span></th><th><span>The Number of Publication</span></th></tr>');
		$('#dataTbl').css('width',"100%");
		thead.append(trTh)
		$('#dataTbl').append(thead);
		var yearJson = getYearMap();
		var tbody  = $('<tbody></tbody>');
		var total = Number(0);
		for(var i=fy; i <= ty; i++){
			var noArts = $.number(yearJson[i]);
			var trTd = $('<tr style="height:17px;"><td class="center">'+i+'</td><td class="center">'+noArts+'</td></tr>');
			tbody.append(trTd);
			if(yearJson[i] != undefined) total += Number(yearJson[i]);
			else total += 0;
		}
		$('#numofPub').text($.number(total));

		var now = new Date();
	    var year= now.getFullYear();
	    var mon = (now.getMonth()+1)>9 ? ''+(now.getMonth()+1) : '0'+(now.getMonth()+1);
	    var day = now.getDate()>9 ? ''+now.getDate() : '0'+now.getDate();

	    //var chan_val = year + '-' + mon + '-' + day;
	    //$('#stndDate').text(" ( " + chan_val + " 기준)");


		var totalTr = $('<tr style="height:17px;"><td class="center" style="font-weight:bold;" >Total</td><td class="center" style="font-weight:bold;">'+$.number(total)+'</td></tr>');
		tbody.append(totalTr);
		$('#dataTbl').append(tbody);

	 }else{
		 $('#disp_txt').text('No data to display');
	 }
 }

 function getYearMap(){
	 var retString = "{";
	 for(var i=0; i < djArr.length; i++){
		 retString += djArr[i].pubYear + ":" + djArr[i].artsCo + ",";
	 }
	 retString = retString.substring(0, retString.length-1) + "}";
	 return eval('('+retString+')');
 }

</script>
</head>
<body>
	<!-- content -->
	<form id="frm" name="frm" action="${contextPath}/analysis/home/publicationSCI.do" method="post">
	<input type="hidden" name="mode" id="mode" value="${mode}"/>
	<input type="hidden" id="topNm" name="topNm" value="<c:out value="${topNm}"/>"/>

	<h3><spring:message code="menu.asrms.about.trend"/></h3>

	

			<!--START page_function-->
			<div class="sub_top_box">
				<span class="select_text">학술지구분</span>
				<span class="select_span">
					<select name="gubun" id="gubun" onchange="javascript:$('#frm').submit();">
						<option value="ALL" ${parameter.gubun eq 'ALL' ? 'selected="selected"' : '' }>전체</option>
						<option value="SCI" ${parameter.gubun eq 'SCI' ? 'selected="selected"' : '' }>SCI</option>
						<option value="SCOPUS" ${parameter.gubun eq 'SCOPUS' ? 'selected="selected"' : '' }>SCOPUS</option>
						<option value="KCI" ${parameter.gubun eq 'KCI' ? 'selected="selected"' : '' }>KCI</option>
					</select>
				</span>
				<span class="select_text mgl_20">실적기간</span>
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

	<div class="help_text mgb_30"><spring:message code="asrms.aboutsci.publications.desc"/></div>

			<div style="text-align:right; padding-right: 10px;">No. of Publication : <span id="numofPub"></span><span id="stndDate"></span></div>

			<div id="tabs" class="tab_wrap mgb_10" style="display: none;">
			  <ul>
			    <li><a href="#tabs-1">Chart</a></li>
			    <li><a href="#tabs-2">Data</a></li>
			  </ul>
		  		<div id="tabs-1">
				   <div id="chartdiv1" class="mgb_10">
					<%--
					<fc:render chartId="ChartId1" swfFilename="MSLine" width="748" height="350" debugMode="false" registerWithJS="false"
						dataFormat="xml" xmlData="${chartXML}" renderer="javascript" windowMode="transparent" />
				    --%>
				   </div>
				</div>
				<div id="tabs-2">
					<div id="content_wrap" style="width: 100%;overflow: auto;">
						<span id="disp_txt"></span>
						<table id="dataTbl" class="tab_tbl mgb_10">
						</table>
					</div>
				</div>
			</div>
		</div>
</form>
</body>
</html>
