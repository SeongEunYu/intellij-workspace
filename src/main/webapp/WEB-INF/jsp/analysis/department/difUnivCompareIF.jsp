<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>Department Indicator Compare</title>
	<%@ include file="../../pageInit.jsp" %>
	<script type="text/javascript" src="${contextPath}/js/jquery/jquery.filedownload.js"></script>
	<script type="text/javascript">

        $(function(){
            $('#tabs').tabs({activate: function(event, ui){tab_activate(event, ui);}});
            inputSrchTerm();
            fillDataTable();
            drawJifChart();
        });

        var tab_activate = function(event, ui){
            if(ui.newPanel.is('#tabs-1'))
            {
                var jifChartObj = getChartFromId('jifChart');
                if(jifChartObj == null || !jifChartObj.hasRendered()) drawJifChart();
            }
            else if(ui.newPanel.is('#tabs-2'))
            {
                var artChartObject = getChartFromId('artChart');
                if(artChartObject == null || !artChartObject.hasRendered()) drawArticleChart();
            }
        }

        var drawJifChart = function(){
            var jifChartOpt = $.extend(true, {}, chartOpt);
            jifChartOpt['id'] = 'jifChart';
            jifChartOpt['type'] = 'mscombidy2d';
            jifChartOpt['renderAt'] = 'jif_tab_chart_container';
            jifChartOpt['height'] = '350';
            jifChartOpt.dataSource.chart['exportHandler'] = '${contextPath}/servlet/FCExporter/export.do';
            jifChartOpt.dataSource.chart['exportCallBack'] = 'export_jif_chart';

            $.post("${contextPath}/analysis/department/difUnivComapreIFChartData.do", $('#frm').serializeArray(),null,'json').done(function(data){
                $('#jif_tab_chart_container').off('fusionchartsrendercomplete').on('fusionchartsrendercomplete',function(eventObj, dataObj){});
                jifChartOpt.dataSource['categories'] = data.categories;
                jifChartOpt.dataSource['dataset'] = data.dataset;
                $('#jif_tab_chart_container').insertFusionCharts(jifChartOpt);
            });
        }

        var drawArticleChart = function(){
            var artChartOpt = $.extend(true, {}, chartOpt);
            artChartOpt['id'] = 'artChart';
            artChartOpt['type'] = 'mscombidy2d';
            artChartOpt['renderAt'] = 'article_tab_chart_container';
            artChartOpt['height'] = '350';
            artChartOpt.dataSource.chart['sYAxisName'] = '교원수';
            artChartOpt.dataSource.chart['pYAxisName'] = '논문수';
            artChartOpt.dataSource.chart['exportHandler'] = '${contextPath}/servlet/FCExporter/export.do';
            artChartOpt.dataSource.chart['exportCallBack'] = 'export_art_chart';

            $.post("${contextPath}/analysis/department/difUnivComapreArtChartData.do", $('#frm').serializeArray(),null,'json').done(function(data){
                $('#article_tab_chart_container').off('fusionchartsrendercomplete').on('fusionchartsrendercomplete',function(eventObj, dataObj){});
                artChartOpt.dataSource['categories'] = data.categories;
                artChartOpt.dataSource['dataset'] = data.dataset;
                $('#article_tab_chart_container').insertFusionCharts(artChartOpt);
            });
        }

        var fillDataTable = function(){
            $('#dataTbl tbody').empty();
            $.post("${contextPath}/analysis/department/difUnivComapreData.do", $('#frm').serializeArray(),null,'json').done(function(data){
                for(var i=0; i< data.length; i++)
                {
                    var $tr = $('<tr></tr>');
                    $tr.append($('<td class="center"><input type="checkbox" name="filterItem" onclick="reloadChart();" value="'+data[i].univNm+'" checked="checked" /></td>'));
                    $tr.append($('<td class="center">'+data[i].stndYear+'</td>'));
                    $tr.append($('<td style="text-align: left;">'+data[i].univNm+'</td>'));
                    $tr.append($('<td style="text-align: right;">'+Number(data[i].cntArtcl).toLocaleString('en')+'</td>'));
                    $tr.append($('<td style="text-align: right;">'+Number(data[i].cntRsrch).toLocaleString('en')+'</td>'));
                    $tr.append($('<td style="text-align: right;">'+Number(data[i].totalTc).toLocaleString('en')+'</td>'));
                    $tr.append($('<td style="text-align: right;">'+Number(data[i].avgTcPerArtcl).toLocaleString('en')+'</td>'));
                    $tr.append($('<td style="text-align: right;">'+Number(data[i].totalJif).toLocaleString('en')+'</td>'));
                    $tr.append($('<td style="text-align: right;">'+Number(data[i].avgJifPerRsrch).toLocaleString('en')+'</td>'));
                    $('#dataTbl tbody').append($tr);
                }
            });
        }

        var changeStndYear = function(){
            $('.wrap-loading').css('display', '');
            fillDataTable();
            inputSrchTerm();
            detoryChart();
            drawJifChart();
            drawArticleChart();
            $('.wrap-loading').css('display', 'none');
        }

        var reloadChart = function(){
            detoryChart();
            drawJifChart();
            drawArticleChart();
        }

        var detoryChart = function(){
            if(FusionCharts('jifChart')) FusionCharts('jifChart').dispose();
            if(FusionCharts('artChart')) FusionCharts('artChart').dispose();
            $('#jif_tab_chart_container').disposeFusionCharts().empty();
            $('#article_tab_chart_container').disposeFusionCharts().empty();
        }

        var inputSrchTerm = function(){ $('#srchTerm').empty().text($('#stndYear option:selected').attr('srchTerm')); }

        function exportExcel(){
            $('#tabs').tabs({active:0});
            $('#excelFrm input[name="imagePath"]').remove();
            setTimeout(function() {
                var jifChartObj = getChartFromId('jifChart');
                if( jifChartObj.hasRendered() ) jifChartObj.exportChart( { exportFormat : 'png'} );
            }, 1000);
        }

        function export_jif_chart(objRtn){
            if (objRtn.statusCode=="1")
            {
                $('#excelFrm').append($('<input type="hidden" name="imagePath" value="'+objRtn.fileName+'"/>'));
                $('#tabs').tabs({active:1});
                setTimeout(function() {
                    var artChartObj = getChartFromId('artChart');
                    if( artChartObj.hasRendered() ) artChartObj.exportChart( { exportFormat : 'png'} );
                }, 2000);
            }
            else
            {
                dhtmlx.alert({type:"alert-warning",text:"The JIF chart could not be saved on server. There was an error. Description : " + objRtn.statusMessage,callback:function(){}});
            }
        }

        function export_art_chart(objRtn){
            if (objRtn.statusCode=="1")
            {
                $('#excelFrm').append($('<input type="hidden" name="imagePath" value="'+objRtn.fileName+'"/>'));
                setTimeout(function() { saveExcel();}, 1000);
            }
            else
            {
                dhtmlx.alert({type:"alert-warning",text:"The Article chart could not be saved on server. There was an error. Description : " + objRtn.statusMessage,callback:function(){}});
            }
        }

        function saveExcel(){
            var tbl = $('#dataTbl').clone();
            var chb = tbl.find('input[name="filterItem"]');
            for(var i = (chb.length -1) ; i >= 0; i--)
            {
                if(!chb.eq(i).is(':checked')) chb.eq(i).parent().parent().remove();
            }
            $('#tableHtml').val(tbl.clone().wrapAll('<div/>').parent().html());
            $('#excelFrm').submit();
        }

	</script>
</head>
<body>
<h3 class="page_title">미국대학 vs KAIST Impact Factor 비교</h3>
<div class="help_text mgb_30"><spring:message code="asrms.department.other.univ.comp.if.desc"/></div>

<form id="frm" name="frm" action="${contextPath}/analysis/department/difUnivCompareIF.do" method="post">
	<input type="hidden" name="deptKor" id="deptKor" value="<c:out value="${parameter.deptKor}"/>"/>
	<input type="hidden" name="itemType" id="itemType" value="${parameter.itemType}"/>

	<div class="sub_top_box">
		<span style="margin-left:10px;">기준년도</span>
		<span>
				<select name="stndYear" id="stndYear" onchange="javascript:changeStndYear();">
					<c:forEach var="yl" items="${stndYearList}" varStatus="idx">
						<option value="${yl.stndYear }" srchTerm="${yl.srchTerm}" <c:if test="${idx.count eq 1 }">selected="selected"</c:if>>${yl.stndYear }</option>
					</c:forEach>
				</select>
			</span>
	</div>

	<h3 class="circle_h3">Chart</h3>
	<div class="help_text mgb_30"><spring:message code="asrms.department.other.univ.comp.if.chart.desc"/></div>

	<div class="sub_content_wrapper">
		<div id="tabs" class="tab_wrap">
			<ul>
				<li><a href="#tabs-1">Impact Factor</a></li>
				<li><a href="#tabs-2">논문수</a></li>
			</ul>
			<div id="tabs-1">
				<div id="jif_tab_chart_container" class="chart_box"></div>
			</div>
			<div id="tabs-2">
				<div id="article_tab_chart_container" class="chart_box"></div>
			</div>
		</div>
	</div>

	<p class="bt_box mgb_20"><a href="#" onclick="exportExcel();" class="black_bt"><em class="export_icon">Export</em></a></p>

	<div><div style="float: left;padding:0 5px 10px 0;"><h3>Data</h3></div>
		<div style="float: left;padding:7px 5px 10px 0;">( 대상데이터&nbsp;:&nbsp; <span id="srchTerm"></span> )</div></div>

	<div class="sub_content_wrapper">
		<table width="100%" id="dataTbl" class="list_tbl mgb_20">
			<colgroup>
				<col style="width: 41"/>
				<col style="width: 72"/>
				<col style="width: 229"/>
				<col style="width: 83"/>
				<col style="width: 83"/>
				<col style="width: 104"/>
				<col style="width: 104"/>
				<col style="width: 83"/>
				<col style="width: 105"/>
			</colgroup>
			<thead>
			<tr style="text-align: center;height:25px;">
				<th><span></span></th>
				<th><span>Year</span></th>
				<th><span>대학교</span></th>
				<th><span>논문수</span></th>
				<th><span>교원수</span></th>
				<th><span>피인용횟수</span></th>
				<th><span>평균<br/> 피인용횟수</span></th>
				<th><span>JIF <br/>총합계</span></th>
				<th><span>JIF 총합계 /<br/> 교원수  </span></th>
			</tr>
			</thead>
			<tbody></tbody>
		</table>
	</div>
	<div id="msgDiv">
		<span style="color: red;"><img src="${contextPath}/images/icon/highlycited_icon.gif" alt="icon" />&nbsp;미국대학과의 비교 데이터는 WOS 데이터 기반으로 학술정보운영팀의 조사결과입니다.	<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;RIMS 데이터와는 일치하지 않을 수 있습니다.</span>
	</div>
</form>
<form id="excelFrm" action="${contextPath}/analysis/department/exportExcel.do" method="post">
	<input type="hidden" id="tableHtml" name="tableHtml" value="" />
	<input type="hidden" id="expFileName" name="expFileName" value="difUnivCompareIF.xlsx" />
</form>
</body>
</html>
