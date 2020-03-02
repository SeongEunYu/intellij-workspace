<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><spring:message code="menu.asrms.dept.avgif"/></title>
 <script type="text/javascript" src="${contextPath}/js/jquery/jquery.tablesorter.min.js"></script>
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
 var if_fc = 0;
 var djArr;
 var chart_ChartId2;

 $(document).ready(function(){
	$("#tabs").css("display", "block");

	$( "#tabs" ).tabs({});

     trendIFAjax('0');

  });

 function trendIFAjax(idx){
     if(!validateRange()){errorMsg(this); return false;}

     $.ajax({
         url:"<c:url value="/analysis/department/trendIFAjax.do"/>",
         dataType: "json",
         data: $('#frm').serialize(),
         method: "POST",
         beforeLoad: $('.wrap-loading').css('display', '')

     }).done(function(data){

         djArr = eval('('+ data.dataJson+')');

         if(FusionCharts('ChartId1')) {
             FusionCharts('ChartId1').dispose();
             $('#chartdiv2').disposeFusionCharts().empty();
         }

         chart_ChartId2 =  new FusionCharts({
			 id:'ChartId2',
             type:'MSLine',
             renderAt:'chartdiv2',
             width:'100%',
             height:'350',
             dataFormat:'xml',
             dataSource:data.chartXML
         }).render();

         var artNo = "";
         var artNo_IF = "";
         var sumIF = "";
         var avgIF = "";
         var avgIF_Ex = "";

         if_fc = 0;
         var $tbody = "";
         for(var i=0; i<data.userList.length; i++){
             var ul = data.userList[i];
             var gubun = $("#gubun").val();

             if(gubun == 'SCI'){
                 artNo = ul.sciArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
                 artNo_IF = ul.impctFctrExsArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
                 sumIF = (ul.impctFctrSum.toFixed(2)*1).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
                 avgIF = (ul.impctFctrAvrg.toFixed(2)*1).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
                 avgIF_Ex = (ul.impctFctrExsAvrg.toFixed(2)*1).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
			 }else if(gubun == 'SCOPUS'){
                 artNo = ul.scpArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
                 artNo_IF = ul.sjrExsArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
                 sumIF = (ul.sjrSum.toFixed(2)*1).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
                 avgIF = (ul.sjrAvrg.toFixed(2)*1).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
                 avgIF_Ex = (ul.sjrExsAvrg.toFixed(2)*1).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
			 }else if(gubun == 'KCI'){
                 artNo = ul.kciArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
                 artNo_IF = ul.kciIFExsArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
                 sumIF = (ul.kciIFSum.toFixed(2)*1).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
                 avgIF = (ul.kciIFAvrg.toFixed(2)*1).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
                 avgIF_Ex = (ul.kciIFExsAvrg.toFixed(2)*1).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
			 }

             var $tr = '<tr id="legendTr_'+ul.userId+'">';

             if(ul.userId != null){
                 $tr += '<td class="center"><input type="checkbox"  id="if_chkbox_'+ul.userId+'" value="'+ul.userId+'"';
                 if(i < 5) $tr += 'checked="checked"';
                 $tr += '/><input type="hidden" name="if_userNm_'+ul.userId+'" id="if_userNm_'+ul.userId+'" value="'+ul.korNm+'"</td>';
                 $tr += '<td class="center">'+ul.korNm+'</td>';
                 $tr += '<td class="center">'+artNo+'</td>';
                 $tr += '<td class="center">'+artNo_IF+'</td>';
                 $tr += '<td class="center">'+sumIF+'</td>';
                 $tr += '<td class="center">'+avgIF+'</td>';
                 $tr += '<td class="center">'+avgIF_Ex+'</td>';
                 $tr += '<input type="hidden" name="if_fillColorIndex_'+ul.userId+'" id="if_fillColorIndex_'+ul.userId+'" value="'+if_fc+'" />';
                 if(if_fc++ > fillColors.length-1) if_fc = 0;
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
                     sortList:[[5,1]],
                     headers: {
                         0: {
                             sorter: false
                         }
                     }
                 });
             }else{
                 if($("#avgIFType").val()  == 'wh'){
                     $("#publicationsTbl th").removeClass('headerSortUp');
                     $("#publicationsTbl th").removeClass('headerSortDown');
                     $("#publicationsTbl th").eq(5).addClass('headerSortUp');
                 }else{
                     $("#publicationsTbl th").removeClass('headerSortUp');
                     $("#publicationsTbl th").removeClass('headerSortDown');
                     $("#publicationsTbl th").eq(6).addClass('headerSortUp');
                 }
             }

             $("#publicationsTbl").trigger("update");
         }

         printDataTable();

         $("input:checkbox[id='anonymous']").attr("checked", false);
         $('input:checkbox').bind('click', function(){ clickCheckbox($(this));});
         $('#fromYear').data('prev', $('#fromYear').val());
         $('#toYear').data('prev', $('#toYear').val());

         $('.wrap-loading').css('display', 'none');
     });
 }

 function printDataTable(){
     $('#dataTbl').html("");
     
	 if(djArr.length > 0){
		$('#disp_txt').text('');
		var fy = parseInt($('#fromYear').val(),10);
		var ty = parseInt($('#toYear').val(),10);
		var thead = $('<thead></thead>');
		var trTh = $('<tr style="height:20px;"><th><span>성명</span></th></tr>');
		var countCol = 0;
		for(var i=fy; i <= ty; i++){
			trTh.append($('<th style="text-align:center;">'+i+'</th>'));
			countCol++;
		}
		countCol++;

		var width = 400 + countCol*50;
		$('#dataTbl').css('width',width+"px");

		thead.append(trTh)
		$('#dataTbl').append(thead);

		var tbody  = $('<tbody></tbody>');
		for(var j=0; j < djArr.length; j++){
			var name = djArr[j].korNm ;
			var id = djArr[j].userId;
			var trTd = $('<tr style="height:17px;" id="data_'+id+'"><td class="center">'+name+'</td></tr>');
			for(var i=fy; i <= ty; i++){
				var val = djArr[j][i] == undefined ? 0 : parseFloat(djArr[j][i]);
				val = val / 1;
				trTd.append($('<td style="text-align:center;padding-right:5px;">'+val.toFixed(2)+'</td>'));
			}
			tbody.append(trTd);
		}
		$('#dataTbl').append(tbody);
	 }else{
		 $('#disp_txt').text('No data to display');
	 }
}

 function clickCheckbox(obj){

	if($(obj).prop('id') == "toggleChkbox")
	{
		if($(obj).prop("checked") == true)
		{
			$('input[id^="if_chkbox_"]').prop('checked', true);
		}
		else
		{
			$('input[id^="if_chkbox_"]').prop('checked', false);
		}
	}

	var isAnonymous = $('#anonymous').is(':checked');
	var starCharCode = 65;
	var chartId = "ChartId2";
 	var category = "<categories>";
	var dataset = "";
	var hdataset = "";
	var fy = parseInt($('#fromYear').val(),10);
	var ty = parseInt($('#toYear').val(),10);

	for(var i=fy; i <= ty; i++){
		category += "<category label='"+i+"' />";
	}
	category += "</categories>";

	var chb = $('input[id^="if_chkbox_"]');

	for(var j=0; j < chb.length; j++){
		var userid = chb.eq(j).val();
		if(chb.eq(j).is(':checked')){
			var name = isAnonymous ? String.fromCharCode(starCharCode) + '교수' : $('#if_userNm_'+userid).val();
			var userName = isAnonymous ? String.fromCharCode(starCharCode) + '교수' : name;
			var fcIdx = parseInt($('#if_fillColorIndex_'+userid).val(),10);
			var color = fillColors[fcIdx];
			dataset += "<dataset seriesName='"+userName+"' id='"+userid+"' color='"+color+"'>";
			for(var k=0; k < djArr.length; k++){
				if(djArr[k].userId == userid){
					for(var i=fy; i <= ty; i++){
						//<set value='167'  toolText='신소재공학과 2008 : 167' />
						var val = djArr[k][i] == undefined ? 0 : djArr[k][i];
						val = val / 1;
						val = val.toFixed(2);

						dataset += "<set value='"+val+"' toolText='"+userName+" "+i+" : "+val+"' />";
					}
					dataset += "</dataset>";
			     }
		     }
			if(isAnonymous){
				//$('#legendTr_'+ userid + ' td').eq(2).html('-');
				$('#legendTr_'+ userid + ' td').eq(1).html(name);
				$('#data_'+ userid + ' td').eq(0).html(name);
				//$('#data_'+ userid + ' td').eq(1).html('-');

			}else{
				//$('#legendTr_'+ userid + ' td').eq(2).html(userid);
				$('#legendTr_'+ userid + ' td').eq(1).html(name);
				$('#data_'+ userid + ' td').eq(0).html(name);
				//$('#data_'+ userid + ' td').eq(1).html(userid);
			}
			starCharCode++;
		}else{
			//$('#legendTr_'+ userid + ' td').eq(2).html(userid);
			$('#legendTr_'+ userid + ' td').eq(1).html($('#if_userNm_'+userid).val());
			$('#data_'+ userid + ' td').eq(0).html($('#if_userNm_'+userid).val());
			//$('#data_'+ userid + ' td').eq(1).html(userid);
		}
	}

	var chartData = chart_ChartId2.getChartData('xml');
	    chartData = chartData.replace(/(<chart .*>)(<categories.*)(<styles.*)/, '$1'+category+dataset+'$3');
	chart_ChartId2.setDataXML(chartData);

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

	 setTimeout(function() {
		 	if( chart_ChartId2.hasRendered() ) chart_ChartId2.exportChart( { exportFormat : 'png'} );
	 }, 1000);
 }
 function saveExcel(fileName){
	 var isAnonymous = $('#anonymous').is(':checked');
	 var div = $('<div></div>');
	 var table = $('<table></table>');
	 //append document title
	 var chartTitle = $('<tr><td style="text-align:center;"><h1><p>Department(${item.deptKor}) - '+$('.page_title').html()+'</p></h1></td></tr>');
	 //append chart image
	 var chartTr = $('<tr><td><img src="'+fileName+'" height="350" /></td></tr>');
	 var dataTitle = $('<tr><td><h1>Chart Data</h1></td></tr>');
	 table.append(chartTitle)
	      .append(chartTr)
	      .append(dataTitle);
	 //make table with data of checked researcher
	 var dTbl = $('<table class="list_tbl mgb_20"></table>');
	 var thead = $('#dataTbl > thead').clone();
	 if(isAnonymous) thead.find('tr th').eq(1).remove();
	 dTbl.append(thead.wrapAll('<div/>').parent().html());
	 //dTbl.append($('#dataTbl > thead').clone().wrapAll('<div/>').parent().html());
	 var dataTbody = $('<tbody></tbody>');
	 var chb = $('input[id^="if_chkbox_"]:checked');
	 for(var i=0; i < chb.length ; i++){
		 var id = chb.eq(i).val();
		 var dataTr = $('#data_'+id).clone();
		 if(isAnonymous) dataTr.find('td').eq(1).remove();
		 dataTbody.append(dataTr.wrapAll('<div/>').parent().html());
		 //dataTbody.append($('#data_'+id).clone().wrapAll('<div/>').parent().html());
	 }
	 dTbl.append(dataTbody);
	 table.append($('<tr><td>'+dTbl.clone().wrapAll('<div/>').parent().html()+'</td></tr>'));
	 div.append(table);
	 $('#tableHTML').val(div.html());
	 var excelFileName = "AverageOfImapctFactorCompare_"+$('#gubun').val() + "_from_" + $('#fromYear').val() +"_to_" + $('#toYear').val() + ".xls";
	 $('#fileName').val(excelFileName);
	 exportLog($('#frm'), excelFileName + "|" +  fileName);
	 $('#excelFrm').submit();
 }
 </script>
</head>
<body>
	<h3 class="page_title"><spring:message code="menu.asrms.dept.avgif"/></h3>
	<div class="help_text mgb_30"><spring:message code="asrms.department.impactfactor.comp.desc"/></div>

	<form id="frm" name="frm">
	<input type="hidden" id="topNm" name="topNm" value="<c:out value="${topNm}"/>"/>
	<input type="hidden" name="deptKor" id="deptKor" value="<c:out value="${parameter.deptKor}"/>"/>
	<input type="hidden" name="trackId" id="trackId" value="<c:out value="${parameter.trackId}"/>"/>
	<input type="hidden" name="avgIFType" id="avgIFType" value="wh"/>

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
				<a href="javascript:trendIFAjax();" class="to_search_bt"><span>Search</span></a>
			</p>
		</div>
	</form>

	<div class="mgb_10">
		<input type="radio" name="avgIFType" id="avgIFTypeW" value="wh" checked="checked" style="vertical-align: -5px;" onchange="javascript: $('#avgIFType').val($(this).val()); trendIFAjax();" /><span> IF 평균1 (IF합/전체 논문수)&nbsp;&nbsp;</span>
		<input type="radio" name="avgIFType" id="avgIFTypeE" value="ex" style="vertical-align: -5px;" onchange="javascript: $('#avgIFType').val($(this).val()); trendIFAjax();"/><span> IF 평균2 (IF합/IF 제공 논문수)</span>
	</div>

	<div id="chart_data_div">
		<div id="tabs" class="tab_wrap mgb_20" style="display: none;">
		  <ul>
		    <li><a href="#tabs-1">Chart</a></li>
		    <li><a href="#tabs-2">Data</a></li>
		  </ul>
			<div id="tabs-1">

				<div style="width:100%; padding-left:0px">
				    <div id="chartdiv2" class="chart_box" align="left"></div>
				</div>
			</div>
			<div id="tabs-2">
				<div style="width: 100%;overflow: auto;">
					<span id="disp_txt"></span>
					<table id="dataTbl" class="tab_tbl mgb_20" style="width: auto;">
					</table>
				</div>
			</div>
		</div>

		<p class="bt_box mgb_10"><a href="#" onclick="exportExcel();" class="black_bt"><em class="export_icon">Export</em></a></p>

		<div style="float: right;padding:0px 5px 0 0;">
			<div><input type="checkbox" id="anonymous" name="anonymous" value="true" style="vertical-align: -5px;" /><span> 익명처리</span></div>
		</div>

		<table width="100%" id="publicationsTbl" class="list_tbl mgb_20">
			<colgroup>
				<col style="width: 5%"/>
				<col style="width: 11%"/>
				<!--
				<col style="width: 10%"/>
				 -->
				<col style="width: 11%"/>
				<col style="width: 11%"/>
				<col style="width: 13%"/>
				<col style="width: 20%"/>
				<col style="width: 20%"/>
			</colgroup>
			<thead>
				<tr>
					<th style="padding-left: 12px;"><span><input type="checkbox" name="toggleChkbox" id="toggleChkbox" value="0"/></span></th>
					<th><span>성명</span></th>
					<!--
					<th><span>ID</span></th>
					 -->
					<th><span>전체논문수</span></th>
					<th><span>IF제공<br/>논문수</span></th>
					<th><span>IF합계</span></th>
					<th><span>IF평균1<br/>(IF합/전체 논문수)</span></th>
					<th><span>IF평균2<br/>(IF합/IF 제공 논문수)</span></th>
				</tr>
			</thead>
			<tbody></tbody>
		</table>
	</div>

<form id="excelFrm" method="post" action="${contextPath}/jsp/excelExport.jsp">
      <input type="hidden" id="tableHTML" name="tableHTML" value="" />
      <input type="hidden" id="fileName" name="fileName" value="test.xls" />
</form>
</body>
</html>
