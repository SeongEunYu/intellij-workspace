<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><spring:message code="menu.asrms.dept.hindex"/></title>
<script type="text/javascript" src="${contextPath}/js/jquery/jquery.tablesorter.min.js"></script>
<style type="text/css" rel="stylesheet">
th.header {
    cursor: pointer;
    background-repeat: no-repeat;
    background-position: center right;
    padding-right: 13px;
    margin-right: -1px;
}
.to_inner span {min-width: 70px;}
</style>

<script type="text/javascript">
 var cjArr;
 var chart_ChartId2;

 $.tablesorter.addParser({
     // set a unique id
     id: 'numFmt',
     is: function(s) {
         // return false so this parser is not auto detected
         return false;
     },
     format: function(s) {
    	 return NumberWithoutComma(s);
     },
     // set type, either numeric or text
     type: 'numeric'
 });

 $(function() {
     hindexAjax('0');
  });


 function hindexAjax(idx){
     if(!validateRange()){errorMsg(this); return false;}

     $.ajax({
         url:"<c:url value="/analysis/department/hindexAjax.do"/>",
         dataType: "json",
         data: $('#frm').serialize(),
         method: "POST",
         beforeLoad: $('.wrap-loading').css('display', '')

     }).done(function(data){
         cjArr = eval('('+ data.dataJson+')');

         if(FusionCharts('ChartId1')) {
             FusionCharts('ChartId1').dispose();
             $('#chartdiv2').disposeFusionCharts().empty();
         }

         chart_ChartId2 =  new FusionCharts({
             id:'ChartId2',
             type:'Column2D',
             renderAt:'chartdiv2',
             width:'100%',
             height:'400',
             dataFormat:'xml',
             dataSource:data.chartXML
         }).render();

         var sum_if = "";
         var sum_tc = "";
         var avg_tc = "";
         var no_arts = "";

         var $tbody = "";
         for(var i=0; i<data.userList.length; i++){
             var ul = data.userList[i];
             var gubun = $("#gubun").val();

             if(gubun == 'SCI'){
                 sum_if = (ul.impctFctrSum.toFixed(2)*1).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
                 sum_tc = ul.wosCitedSum.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
                 avg_tc = (ul.wosCitedAvrg.toFixed(2)*1).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
                 no_arts = ul.sciArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
             }else if(gubun == 'SCOPUS'){
                 sum_if = (ul.sjrSum.toFixed(2)*1).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
                 sum_tc = ul.scpCitedSum.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
                 avg_tc = (ul.scpCitedAvrg.toFixed(2)*1).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
                 no_arts = ul.scpArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
             }else if(gubun == 'KCI'){
                 sum_if = (ul.kciIFSum.toFixed(2)*1).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
                 sum_tc = ul.kciCitedSum.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
                 avg_tc = (ul.kciCitedAvrg.toFixed(2)*1).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
                 no_arts = ul.kciArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
             }

             var $tr = '<tr style="height:17px" id="data_'+ul.userId+'">';

             if(ul.userId != null){
                 $tr += '<td class="center"><input type="checkbox"  id="no_chkbox_'+ul.userId+'" value="'+ul.userId+'"';
                 if(i <= 5) $tr += 'checked="checked"';
                 $tr += '/><input type="hidden" name="no_userNm_'+ul.userId+'" id="no_userNm_'+ul.userId+'" value="'+ul.korNm+'"</td>';
                 $tr += '<td>'+ul.korNm+'</td>';
                 $tr += '<td class="center">'+no_arts+'</td>';
                 $tr += '<td class="center">'+sum_if+'</td>';
                 $tr += '<td class="center">'+sum_tc+'</td>';
                 $tr += '<td class="center">'+avg_tc+'</td>';
                 $tr += '<td class="center">'+ul.hindex+'</td>';
             }
             $tr += "</tr>";
             $tbody += $tr;
         }

         if(data.userList.length == 0){
             var $tr = '<tr><td colspan="7"><img src="${contextPath}/images/layout/ico_info.png" /> 검색된 논문이 없습니다.</td></tr>';

             $tbody += $tr;
         }

         $("#publicationsTbl tbody").html($tbody);

		 if(data.userList.length > 0){
			 if(idx == '0'){
				 $("#publicationsTbl").tablesorter({
					 sortList:[[6,1]],
					 headers: {
						 0: { sorter: false },
						 2: { sorter:'numFmt'},
						 3: { sorter:'numFmt'},
						 4: { sorter:'numFmt'},
						 5: { sorter:'numFmt'},
						 6: { sorter:'numFmt'}
					 }
				 });
			 }else{
				 $("#publicationsTbl th").removeClass('headerSortUp');
				 $("#publicationsTbl th").removeClass('headerSortDown');
				 $("#publicationsTbl th").eq(6).addClass('headerSortUp');
			 }

			 $("#publicationsTbl").trigger("update");

			 $("input:checkbox[id='anonymous']").attr("checked", false);
			 $('input:checkbox').bind('click', function(){ clickCheckbox($(this));});
		 }

         $('#fromYear').data('prev', $('#fromYear').val());
         $('#toYear').data('prev', $('#toYear').val());

         $('.wrap-loading').css('display', 'none');
     });
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
	var prefix = $('#prefix').val();
	if(obj!= undefined){
 		prefix = obj.attr('id').substring(0,3);
		$('#prefix').val(prefix);
 	}
	var isAnonymous = $('#anonymous').is(':checked');
	var starCharCode = 65;

	//no_chkbox_${ul.USERID}
	var chartId = 'ChartId2';
	var category = "<categories>";
	var hdataset = "";
	var $checkbox = $('input[id^="no_chkbox_"]');

	for(var j=0; j < $checkbox.length; j++){
		var userid = $checkbox.eq(j).val();
		var dataArr = getUserJsonData(userid);
		if($checkbox.eq(j).is(':checked')){
			var name = isAnonymous ?  String.fromCharCode(starCharCode) + '교수' : dataArr.korNm;
			var hiToolText = name+" H-index :" + dataArr.hindex;

			category += "<category label='"+name+"' />";
			hdataset += "<set label='"+name+"' value='"+dataArr.hindex+"' toolText='"+hiToolText+"' />";

			if(isAnonymous){
				$('#data_'+ userid + ' td').eq(1).html(name);
				//$('#data_'+ userid + ' td').eq(2).html('-');
			}else{
				$('#data_'+ userid + ' td').eq(1).html(name);
				//$('#data_'+ userid + ' td').eq(2).html(userid);
			}

			starCharCode++;
		}else{
			$('#data_'+ userid + ' td').eq(1).html(dataArr.korNm);
			//$('#data_'+ userid + ' td').eq(2).html(dataArr.userId);
		}
	}

	category += "</categories>";

 	var chartData = chart_ChartId2.getChartData('xml');
     chartData = chartData.replace(/(<chart .* >)(<set .*>)(<styles.*)/, '$1'+hdataset+'$3');
	chart_ChartId2.setDataXML(chartData);
 }

 function getUserJsonData(userid){
	 for(var i=0; i < cjArr.length; i++){
		 if(cjArr[i].userId == userid) return cjArr[i];
	 }
 }

 function setChar2tData(hdataset){
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
	 var chartObject = getChartFromId('ChartId2');
	 if( chartObject.hasRendered() ) chartObject.exportChart( { exportFormat : 'png'} );
 }
 function saveExcel(fileName){
	 var isAnonymous = $('#anonymous').is(':checked');
	 var div = $('<div></div>');
	 var table = $('<table></table>');
	 //append document title
	 var chartTitle = $('<tr><td style="text-align:center;"><h1><p>Department(${item.deptKor}) - '+$('.page_title').html()+'</p></h1></td></tr>');
	 //append chart image
	 var chartTr = $('<tr><td><img src="'+fileName+'" height="350"/></td></tr>');
	 var dataTitle = $('<tr><td><h1>Chart Data</h1></td></tr>');
	 table.append(chartTitle)
	      .append(chartTr)
	      .append(dataTitle);
	 //make table with data of checked researcher
	 var dTbl = $('<table class="list_tbl mgb_20"></table>');
	 var thead = $('#publicationsTbl > thead').clone();
	 thead.find('tr th:first-child').remove();
	 if(isAnonymous) thead.find('tr th').eq(1).remove();
	 dTbl.append(thead.wrapAll('<div/>').parent().html());
	 var dataTbody = $('<tbody></tbody>');
	 var chb = $('input[id^="no_chkbox_"]:checked');
	 for(var i=0; i < chb.length ; i++){
		 var id = chb.eq(i).val();
		 var dataTr = $('#data_'+id).clone();
		 dataTr.find('td:first-child').remove();
		 if(isAnonymous) dataTr.find('td').eq(1).remove();
		 dataTbody.append(dataTr.wrapAll('<div/>').parent().html());
	 }
	 dTbl.append(dataTbody);
	 table.append($('<tr><td>'+dTbl.clone().wrapAll('<div/>').parent().html()+'</td></tr>'));
	 div.append(table);
	 $('#tableHTML').val(div.html());

	 var excelFileName = "H-indexCompare_"+$('#gubun').val() + "_from_" + $('#fromYear').val() +"_to_" + $('#toYear').val() + ".xls";
	 $('#fileName').val(excelFileName);
	 exportLog($('#frm'), excelFileName + "|" +  fileName);
	 $('#excelFrm').submit();
 }
 function dataExportExcel(){

	 var div = $('<div></div>');
	 var table = $('<table></table>');
	 //append document title
	 var chartTitle = $('<tr><td>'+$('#pageTitle').html()+'</td></tr>');
	 //append chart image
	 table.append(chartTitle);
	 //make table with data of checked researcher
	 var dTbl = $('<table class="list_tbl mgb_20"></table>');
	 var thead = $('#publicationsTbl > thead').clone();
	 thead.find('tr th:first-child').remove();
	 dTbl.append(thead.wrapAll('<div/>').parent().html());
	 var dataTbody = $('<tbody></tbody>');
	 var chb = $('input[id^="no_chkbox_"]');
	 for(var i=0; i < chb.length ; i++){
		 var id = chb.eq(i).val();
		 var dataTr = $('#data_'+id).clone();
		 dataTr.find('td:first-child').remove();
		 dataTbody.append(dataTr.wrapAll('<div/>').parent().html());
	 }
	 dTbl.append(dataTbody);
	 table.append($('<tr><td>'+dTbl.clone().wrapAll('<div/>').parent().html()+'</td></tr>'));
	 div.append(table);
	 $('#tableHTML').val(div.html());

	 var excelFileName = "H-indexCompare_Alldata_"+$('#gubun').val() + "_from_" + $('#fromYear').val() +"_to_" + $('#toYear').val() + ".xls";
	 $('#fileName').val(excelFileName);
	 exportLog($('#frm'), excelFileName + "|whole-data-export" );
	 $('#excelFrm').submit();
 }
 </script>
</head>
<body>

	<h3 class="page_title"><spring:message code="menu.asrms.dept.hindex"/></h3>
	<div class="help_text mgb_30"><spring:message code="asrms.department.hindex.comp.desc"/></div>

	<form id="frm" name="frm">
	<input type="hidden" name="isUserChanged" id="isUserChanged" value="false"/>
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
			<a href="javascript:hindexAjax();" class="to_search_bt"><span>Search</span></a>
		</p>
	</div>
	</form>
	   <h3 class="circle_h3">Chart</h3>

	   <div id="chartdiv2" class="chart_box mgb_10"></div>

		<p class="bt_box mgb_10"><a href="#" onclick="exportExcel();" class="black_bt"><em class="export_icon">Export</em></a></p>

		<h3 class="circle_h3" style="float: left;">Data</h3>

		<div style="float: right;padding:8px 5px 0 0;">
			<div><input type="checkbox" id="anonymous" name="anonymous" value="true" style="vertical-align: -5px;" /><span> 익명처리</span></div>
		</div>
		<!--END sub_title-->

		<table width="100%" id="publicationsTbl" class="list_tbl mgb_20">
			<colgroup>
				<col style="width: 4%"/>
				<col style="width: 10%"/>
				<!--
				<col style="width: 9%"/>
				 -->
				<col style="width: 10%"/>
				<col style="width: 15%"/>
				<col style="width: 12%"/>
				<col style="width: 12%"/>
				<col style="width: 11%"/>
			</colgroup>
			<thead>
				<tr style="text-align: center;height:25px">
					<th style="padding-left: 12px;"><span><input type="checkbox" name="toggleChkbox" id="toggleChkbox" value="0"/></span></th>
					<th><span>Name</span></th>
					<!--
					<th><span>ID</span></th>
					 -->
					<th><span>Total <br/> Articles </span></th>
					<th><span>Impact Factor <br/>Sum </span></th>
					<th><span>Citation <br/> Sum</span></th>
					<th><span>Citation <br/> Average </span></th>
					<th><span>H-index</span></th>
				</tr>
			</thead>
			<tbody></tbody>
		</table>
	</div>
<form id="excelFrm" method="post" action="${contextPath}/jsp/excelExport.jsp">
      <input type="hidden" id="tableHTML" name="tableHTML" value="" />
      <input type="hidden" id="fileName" name="fileName" value="test.xls" />
      <!--
      <input type="button" onclick="gotoExcel('tableData', 'tableHTML');" value="Export these results" />
       -->
</form>
</body>
</html>
