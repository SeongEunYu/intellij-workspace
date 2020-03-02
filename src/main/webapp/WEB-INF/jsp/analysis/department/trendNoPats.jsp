<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><spring:message code="menu.asrms.dept.patentByResearchers"/></title>
<script type="text/javascript" src="${contextPath}/js/jquery/jquery.tablesorter.min.js"></script>
<style type="text/css" rel="stylesheet">
.list_tbl thead th.header {
    cursor: pointer;
    background-repeat: no-repeat;
    background-position: center right;
    padding-right: 15px;
    margin-right: -1px;
}
</style>
<script type="text/javascript">
var fc = 0;
var chart_ChartId1;
var djArr;

$(document).ready(function(){
    $("#tabs").tabs({});
    $("#tabs").css("display", "block");

    $("#acqsDvsCd option").eq(0).remove();
    departNoPatsAjax('0');
});

function departNoPatsAjax(idx){
    if(!validateRange()){errorMsg(this); return false;}

    $.ajax({
        url:"<c:url value="/analysis/department/trendNoPatsAjax.do"/>",
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
            barWidth = "600";
        }

        chart_ChartId1 =  new FusionCharts({
            id: 'ChartId1',
            type:'MSLine',
            renderAt:'chartdiv1',
            width:chartWidth,
            height:'350',
            dataFormat:'xml',
            dataSource: data.chartXML
        }).render();

        fc = 0;
        var $tbody = "";
        for(var i=0; i<data.userPatsList.length; i++){
            var pl = data.userPatsList[i];

            var $tr = '<tr style="background-color:#ffffff;" id="legendTr_'+pl.userId+'">';
            $tr += '<td style="text-align: center;">';
            $tr += '<input type="checkbox"  id="no_chkbox_'+pl.userId+'" value="'+pl.userId+'"';
            if(i < 5) $tr += 'checked="checked"';
            $tr += '/><input type="hidden" name="no_userNm_'+pl.userId+'" id="no_userNm_'+pl.userId+'" value="'+pl.korNm+'"/></td>';

            $tr += '<td class="center"><span class="breakKeepAll">'+pl.korNm+'</span></td>';
            $tr += '<td><div id="chartdiv_'+pl.userId+'" align="left"></div>';
            $tr += '<input type="hidden" name="no_fillColorIndex_'+pl.userId+'" id="no_fillColorIndex_'+pl.userId+'" value="'+fc+'" /></td>';
            if(fc++ > fillColors.length-1) fc = 0;
            $tr += "</tr>";
            $tbody += $tr;
        }

        if(data.userPatsList.length == 0){
            var $tr = '<tr><td colspan="99" style="padding-left:5px;"><img src="${contextPath}/images/layout/ico_info.png" /> 검색된 Data가 없습니다.</td></tr>';
            $tbody += $tr;
        }

        $("#publicationsTbl tbody").html($tbody);

        if(data.userPatsList.length > 0){
            if(idx == '0'){
                $("#publicationsTbl").tablesorter({
                    sortList:[[2,1]],
                    headers: {
                        0: {  sorter: false},
                        2: {sorter:'noArts'}
                    }
                });

                $.tablesorter.addParser({
                    id: 'noArts',
                    is: function (s) {
                        return false;
                    },
                    format: function (s) {
                        return s.match(/Chart([0-9]*)/i)[1];
                    },
                    type: 'numeric'
                });
            }else{
                $("#publicationsTbl th").removeClass('headerSortUp');
                $("#publicationsTbl th").removeClass('headerSortDown');
                $("#publicationsTbl th").eq(2).addClass('headerSortUp');
            }

            setTimeout(function() {
                $("#publicationsTbl").trigger("update");
            },500);
        }

        printDataTable();

        for(var i=0; i<data.userPatsList.length; i++ ){
            var pl = data.userPatsList[i];

            eval( "var chart_Chart"+pl.userId+" =  new FusionCharts({type:'Bar2D', renderAt:'chartdiv_"+pl.userId+"',width:'"+barWidth+"',height:'35',dataFormat:'xml',dataSource:\""+pl.chartXML+"\"}).render()");
        }

        $('input:checkbox').bind('click', function(){ clickCheckbox($(this));});
        $('.wrap-loading').css('display', 'none');
    });
}

 function printDataTable(){
     $('#dataTbl').html('');
	 if(djArr.length > 0){
		$('#disp_txt').text('');
		var fy = parseInt($('#fromYear').val(),10);
		var ty = parseInt($('#toYear').val(),10);
		var thead = $('<thead></thead>');
		var trTh = $('<tr style="height:20px;"><th><span>성명</span></th></tr>');
		var countCol = 0;
		for(var i=fy; i <= ty; i++){
			trTh.append($('<th><span>'+i+'</span></th>'));
			countCol++;
		}
		trTh.append($('<th><span>합계</span></th>'));
		countCol++;

		var width = 400 + countCol*50;
		$('#dataTbl').css('width',width+"px");

		thead.append(trTh);
		$('#dataTbl').append(thead);

		var tbody  = $('<tbody></tbody>');
		for(var j=0; j < djArr.length; j++){
			var name = djArr[j].korNm ;
			var id = djArr[j].userId;
			var sum = 0;
			var trTd = $('<tr style="height:17px;" id="data_'+id+'"><td class="center"><span class="breakKeepAll">'+name+'</span></td></tr>');
			for(var i=fy; i <= ty; i++){
				var val = djArr[j][i] == undefined ? 0 : djArr[j][i];
				trTd.append($('<td style="text-align:center;">'+val+'</td>'));
				sum += Number(val);
			}
			trTd.append($('<td style="text-align:center;">'+sum+'</td>'));
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
			$('input[id^="no_chkbox_"]').prop('checked', true);
		}
		else
		{
			$('input[id^="no_chkbox_"]').prop('checked', false);
		}
	}

	var isAnonymous = $('#anonymous').is(':checked');
	var starCharCode = 65;
	var chartId = "ChartId1";
 	var category = "<categories>";
	var dataset = "";
	var hdataset = "";
	var fy = parseInt($('#fromYear').val(),10);
	var ty = parseInt($('#toYear').val(),10);

	for(var i=fy; i <= ty; i++){
		category += "<category label='"+i+"' />";
	}
	category += "</categories>";

	var chb = $('input[id^="no_chkbox_"]');

	for(var j=0; j < chb.length; j++){
		var userid = chb.eq(j).val();
		if(chb.eq(j).is(':checked')){
			var name = isAnonymous ? String.fromCharCode(starCharCode) + '교수' : $('#no_userNm_'+userid).val();
			var userName = isAnonymous ? String.fromCharCode(starCharCode) + '교수' : name;//+"("+userid+")";
			var fcIdx = parseInt($('#no_fillColorIndex_'+userid).val(),10);
			var color = fillColors[fcIdx];
			dataset += "<dataset seriesName='"+userName+"' id='"+userid+"' color='"+color+"'>";
			for(var k=0; k < djArr.length; k++){
				if(djArr[k].userId == userid){
					for(var i=fy; i <= ty; i++){
						//<set value='167'  toolText='신소재공학과 2008 : 167' />
						if(djArr[k][i] == undefined) dataset += "<set value='0' toolText='"+userName+" "+i+" : 0' />";
						else dataset += "<set value='"+djArr[k][i]+"' toolText='"+userName+" "+i+" : "+djArr[k][i]+"' />";
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
			$('#legendTr_'+ userid + ' td').eq(1).html($('#no_userNm_'+userid).val());
			$('#data_'+ userid + ' td').eq(0).html($('#no_userNm_'+userid).val());
			//$('#data_'+ userid + ' td').eq(1).html(userid);
		}
	}
	var chartData = chart_ChartId1.getChartData('xml');
 	    chartData = chartData.replace(/(<chart .*>)(<categories.*)(<styles.*)/, '$1'+category+dataset+'$3');
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
	 //$("#tabs").tabs({active:0});
	 setTimeout(function() {
	 	var chartObject = getChartFromId('ChartId1');
	 	if( chartObject.hasRendered() ) chartObject.exportChart( { exportFormat : 'png', showExportDialog: '1'} );
	  }, 1000);
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
	 var thead = $('#dataTbl > thead').clone();
	 if(isAnonymous) thead.find('tr th').eq(1).remove();
	 dTbl.append(thead.wrapAll('<div/>').parent().html());
	 //dTbl.append($('#dataTbl > thead').clone().wrapAll('<div/>').parent().html());
	 var dataTbody = $('<tbody></tbody>');
	 var chb = $('input[id^="no_chkbox_"]:checked');
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
	 var excelFileName = "NumberOfPublicationCompare_"+$('#gubun').val() + "_from_" + $('#fromYear').val() +"_to_" + $('#toYear').val() + ".xls";
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

function regNtnChange(){
    if($("#acqsNtnDvsCd").val() == "1"){
        $("#applRegNtnCd").parent().css("display","none");
    }else{
        $("#applRegNtnCd").parent().css("display","");
    }
}
 </script>
</head>
<body>

	<h3 class="page_title"><spring:message code="menu.asrms.dept.patentByResearchers"/></h3>
	<div class="help_text mgb_30"><spring:message code="asrms.department.patentByResearchers.desc"/></div>

	<form id="frm" name="frm">
	<input type="hidden" id="topNm" name="topNm" value="<c:out value="${topNm}"/>"/>
	<input type="hidden" name="deptKor" id="deptKor" value="<c:out value="${parameter.deptKor}"/>"/>
	<input type="hidden" name="trackId" id="trackId" value="<c:out value="${parameter.trackId}"/>"/>

	<div class="top_option_box">
		<div class="to_inner">
			<span>취득구분</span>
			<em>
				<select name="acqsDvsCd" id="acqsDvsCd" onchange="javascript:acqsChange();">${rims:makeCodeList('1090',true,parameter.acqsDvsCd)}</select>
			</em>
			<em style="display:none;">
				<select name="status" id="status" mode="checkbox" >${rims:makeCodeList('patent.status',true,parameter.status)}</select>
			</em>
			<span>출원국</span>
			<em>
				<select name="acqsNtnDvsCd" id="acqsNtnDvsCd" onchange="javascript: $('#applRegNtnCd').val('');regNtnChange();">
					<option value="1">국내</option>
					<option value="2">해외</option>
				</select>
			</em>
			<em style="display:none;">
				<select name="applRegNtnCd" id="applRegNtnCd">
					<option value="">전체</option>
					<c:forEach var="nc" items="${applRegNtnCdList}" varStatus="idx">
						<option value="${nc.applRegNtnCd }">${nc.applRegNtnNm}</option>
					</c:forEach>
				</select>
			</em>
			<span>실적구분</span>
			<em>
				<select name="insttRsltAt" id="insttRsltAt">
					<option value="ALL">전체</option>
					<option value="Y">${sysConf['inst.abrv']}</option>
					<option value="N">타기관</option>
				</select>
			</em>
			<p style="margin-top: 5px;">
				<span>실적기간</span>
				<em>
					<select name="fromYear" id="fromYear">
						<c:forEach var="yl" items="${patentYearList}" varStatus="idx" end="50">
							<option value="${yl.patYear }" ${idx.index == 5 ? 'selected="selected"' : '' }>${yl.patYear }</option>
						</c:forEach>
					</select>
				</em>
				~
				<em>
					<select name="toYear" id="toYear">
						<c:forEach var="yl" items="${patentYearList}" varStatus="idx" end="50">
							<option value="${yl.patYear }">${yl.patYear }</option>
						</c:forEach>
					</select>
				</em>
			</p>
		</div>

		<p class="ts_bt_box">
			<a href="javascript:departNoPatsAjax();" class="to_search_bt"><span>Search</span></a>
		</p>
	</div>

	</form>

	<div id="chart_data_div">
		<div id="tabs" class="tab_wrap mgb_20" style="display: none;">
		  <ul>
		    <li><a href="#tabs-1">Chart</a></li>
		    <li><a href="#tabs-2">Data</a></li>
		  </ul>
	  		<div id="tabs-1">
				<div style="padding-left:0px">
					  <div id="chartdiv1" class="chart_box" align="left"></div>
				</div>
			</div>
			<div id="tabs-2">
				<div style="width: 100%;overflow: auto;">
					<span id="disp_txt"></span>
					<table id="dataTbl" class="list_tbl mgb_20">
					</table>
				</div>
			</div>
		</div>
		<!--END sub_content_wrapper-->

		<!--START button-->
		<p class="bt_box mgb_20"><a href="#" onclick="exportExcel();" class="black_bt"><em class="export_icon">Export</em></a></p>
		<!--END button-->

		<div style="float: right;padding:0px 5px 0 0;">
			<div><input type="checkbox" id="anonymous" name="anonymous" value="true" style="vertical-align: -5px;" /><span> 익명처리</span></div>
		</div>

		<table width="100%" id="publicationsTbl" class="list_tbl mgb_20">
			<colgroup>
				<col style="width: 5%"/>
				<col style="width: 15%;"/>
				<col style="width: 10%;"/>
				<col style="width: 60%"/>
			</colgroup>
			<thead>
				<tr>
					<th style="padding-left: 12px;"><span><input type="checkbox" name="toggleChkbox" id="toggleChkbox" value="0"/></span></th>
					<th><span>성&nbsp;&nbsp;명</span></th>
					<!--
					<th><span>ID</span></th>
					 -->
					<th><span>특허건수 합계</span></th>
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
