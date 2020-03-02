<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><spring:message code="menu.asrms.dept.sbuject.page"/></title>
<script type="text/javascript" src="${contextPath}/js/jquery/jquery.tablesorter.min.js"></script>

<style type="text/css" rel="stylesheet">
th.header {
    cursor: pointer;
    background-repeat: no-repeat;
    background-position: center right;
    padding-right: 13px;
    margin-right: -1px;
}
</style>
<script type="text/javascript">
 var fc = 0;
 var chart_ChartId2;;
 var cjArr;
 $(function() {
	$( "#tabs" ).tabs({});
	$("#tabs").css("display", "block");

     subjectAjax();
  });

 function subjectAjax(){
     if(!validateRange()){errorMsg(this); return false;}

     $.ajax({
         url:"<c:url value="/analysis/department/subjectAjax.do"/>",
         dataType: "json",
         data: $('#frm').serialize(),
         method: "POST",
         beforeLoad: $('.wrap-loading').css('display', '')

     }).done(function(data){
         cjArr = eval('('+ data.dataJson+')');

         if(FusionCharts('ChartId2')) {
             FusionCharts('ChartId2').dispose();
             $('#chartdiv2').disposeFusionCharts().empty();
         }
         if(FusionCharts('ChartId3')) {
             FusionCharts('ChartId3').dispose();
             $('#chartdiv3').disposeFusionCharts().empty();
         }

         var chartWidth = "100%";
         var barWidth = "100%";
         if(browserType() == "I"){
             chartWidth = "748";
             barWidth = "450";
         }

         chart_ChartId2 =  new FusionCharts({
			 id:'ChartId2',
             type:'MSLine',
             renderAt:'chartdiv2',
             width:chartWidth,
             height:'350',
             dataFormat:'xml',
             dataSource:data.chartXML
         }).render();

         var chart_ChartId3 =  new FusionCharts({
             id:'ChartId3',
             type:'Pie2D',
             renderAt:'chartdiv3',
             width:chartWidth,
             height:'350',
             dataFormat:'xml',
             dataSource:data.chartXML2
         }).render();

         var $tbody = "";
         for(var i=0; i<data.subjectList.length; i++){
             var sl = data.subjectList[i];

             var $tr = '<tr>';

                 $tr += '<td style="text-align: center;"><input type="checkbox"  id="chkbox_'+sl.ctgryCode+'" value="'+sl.ctgryCode+'"';
                 if(i < 5) $tr += 'checked="checked"';
                 $tr += '/><input type="hidden" name="catNm_'+sl.ctgryCode+'" id="catNm_'+sl.ctgryCode+'" value="'+sl.ctgryName+'"</td>';
                 $tr += '<td style="font-size: 11px;">'+sl.ctgryName+'</td>';
                 $tr += '<td><div id="chartdiv_'+sl.ctgryCode+'" align="left"></div>';
                 $tr += '<input type="hidden" name="fillColorIndex_'+sl.ctgryCode+'" id="fillColorIndex_'+sl.ctgryCode+'" value="'+fc+'" /></td>';
                 if(fc++ > fillColors.length-1) fc = 0;
             $tr += "</tr>";
             $tbody += $tr;
         }

         if(data.subjectList.length == 0){
             var $tr = '<tr><td colspan="99"><img src="${contextPath}/images/layout/ico_info.png" /> 검색된 Data가 없습니다.</td></tr>';

             $tbody += $tr;
         }

         $("#publicationsTbl tbody").html($tbody);

         for(var i=0; i<data.subjectList.length; i++){
             var sl = data.subjectList[i];
             eval( "var chart_Chart"+sl.ctgryCode+" =  new FusionCharts({type:'Bar2D',renderAt:'chartdiv_"+sl.ctgryCode+"',width:'"+barWidth+"',height:'35',dataFormat:'xml',dataSource:\""+sl.chartXML+"\"}).render()");
         }

         $('input:checkbox').bind('click', function(){ clickCheckbox($(this));});
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
				$('input[id^="chkbox_"]').prop('checked', true);
				$('#checkLable').empty().text('선택해제');
			}
			else
			{
				$('input[id^="chkbox_"]').prop('checked', false);
				$('#checkLable').empty().text('전체선택');
			}
		}

		var chartId = 'ChartId2';
		var category = "<categories>";
		var dataset = "";
		var hdataset = "";
		var fy = parseInt($('#fromYear').val(),10);
		var ty = parseInt($('#toYear').val(),10);

		for(var i=fy; i <= ty; i++){
			category += "<category label='"+i+"' />";
		}
		category += "</categories>";

		//var chb = $('input:checkbox:checked');
		var chb = $('input[id^="chkbox_"]:checked');
		for(var j=0; j < chb.length; j++){
			var fcIdx = $('input[id^="chkbox_"]').index(chb.eq(j)) % 23;
			var yearJson = getYearMap(chb.eq(j).val());
			var catName = $('#catNm_'+chb.eq(j).val()).val();
			var color = fillColors[fcIdx];
			dataset += "<dataset seriesName='"+catName+"' id='"+chb.eq(j).val()+"' color='"+color+"'>";
			for(var i=fy; i <= ty; i++){
				if(yearJson[i] == undefined) dataset += "<set value='0' toolText='"+catName+" "+i+" : 0' />";
				else dataset += "<set value='"+yearJson[i]+"' toolText='"+catName+" "+i+" : "+yearJson[i]+"' />";
			}
			dataset += "</dataset>";
		}

		var chartData = chart_ChartId2.getChartData('xml');
		chartData = chartData.replace(/(<chart .*>)(<categories.*)(<styles.*)/, '$1'+category+dataset+'$3');
		chart_ChartId2.setDataXML(chartData);
		//chartObject.setDataXML(preVars.replace(/(.*dataXML=)(<chart .*>)(<categories.*)(<styles.*)/, '$2$3$4'));
 }

 function getYearMap(chkValue){
	 var retString = "{";
	 for(var i=0; i < cjArr.length; i++){
		 if(cjArr[i].ctgryCode == chkValue) retString += cjArr[i].prodYear + ":" + cjArr[i].artsCo + ",";
	 }
	 retString = retString.substring(0, retString.length-1) + "}";
	 return eval('('+retString+')');
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
	 var chartObject = getChartFromId('ChartId1');
	 if( chartObject.hasRendered() ) chartObject.exportChart( { exportFormat : 'png'} );
 }
 function saveExcel(fileName){
	 $('#tableHTML').val($('<table><tr style="height:350px;"><td style="height:350px;">&nbsp;<p style="text-align:center;"><img src="'+fileName+'" style="width: 730px; height: 350px;"/></p><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/></td></tr></tr><td>'+$('#publicationsTbl').parent().html()+'</td></tr></table>').html());
	 //$('#exportDiv').append($('<img src="'+fileName+'" />'));
	 //$('#exportDiv').append($('#publicationsTbl').parent().html());
	 //$('#tableHTML').val($('#exportDiv').html());
	 $('#excelFrm').submit();
 }
 function viewArticleList(categ){
	 $('#artListTbl').empty();
	 //loading publication list of year by ajax

	 $.ajax({
		 url : "${contextPath}/analysis/department/getArticleListBySubjectAjax.do",
		 dataType : 'json',
		 data : { "categ": categ,
			      "fromYear": $('#fromYear').val(),
			      "toYear": $('#toYear').val(),
			      "gubun" : 'SCI',
			 	  "openAccesAt" : $('#openAccesAt').val(),
			      "deptKor" : $('#deptKor').val(),
			      "isFulltime" : 'ALL',
			      "hldofYn" : '1',
			      "trackId":"<c:out value="${parameter.trackId}"/>"
			     },
		 success : function(data, textStatus, jqXHR){

			 var $thead = $('<colgroup><col style="width:10%"/><col style="width:80%"/><col style="width:10%"/></colgroup><thead><tr><th><span>NO</span></th><th><span>Article</span></th><th><span>Citation</span></th><tr></thead>');
			 $('#artListTbl').append($thead);
			 var $tbody = $('<tbody></tbody>');
			 for(var i=0; i < data.length; i++){

				 var seqno = data[i].SEQNO;
				 var esubject = data[i].ESUBJECT == null ? '' : data[i].ESUBJECT;
			     var authors = data[i].AUTHORS == null ? '' : data[i].AUTHORS;
			     var publisher = data[i].PUBLISHER == null ? '' : data[i].PUBLISHER;
				 var magazine = data[i].MAGAZINE == null ? '' : data[i].MAGAZINE;
			     var vol = data[i].VOL == null ? '' : data[i].VOL;
			     var no = data[i].NO == null ? '' : data[i].NO
			     var strpage = data[i].STRPAGE == null ? '' : data[i].STRPAGE;
			     var endpage = data[i].ENDPAGE == null ? '' : data[i].ENDPAGE;
			     var issueDate = data[i].ISSUEDATE == null ? '' : dateFormat(data[i].ISSUEDATE);
			     var sciTc = data[i].SCI_TC == null ? '' : data[i].SCI_TC;
			     var scpTc = data[i].SCP_TC == null ? '' : data[i].SCP_TC;
			     var kciTc = data[i].kciTc == null ? '' : data[i].kciTc;

				 var cited = "";
				 if($('#gubun').val() == 'SCI') cited = sciTc;
				 else if($('#gubun').val() == 'SCOPUS') cited = scpTc;
				 else if($('#gubun').val() == 'KCI') cited = kciTc;

			     var $tr = $('<tr style="height:17px;"></tr>');
				 $tr.append($('<td style="font-size: 10pt;" align="center" width="40">'+(i+1)+'</td>'));
				 var $td = $('<td class="link_td" style="font: normal 12px \'Malgun Gothic\';"></td>').append($('<div class="style_12pt"><a href="javascript:popArticle('+seqno+')"><b>'+esubject+'</b></a></div>'));
				 //var content = '<b>Journal</b>: '+magazine+' [v.'+vol+',&nbsp;no.'+no+',&nbsp; pp.'+strpage+'~'+endpage+',&nbsp;'+issueDate+']';
				 var content = '<div>&nbsp;/ '+authors + '&nbsp;( v.'+vol+',&nbsp;no.'+no+',&nbsp; pp.'+strpage+'~'+endpage+',&nbsp;'+issueDate+')</div>';
				 $td.append(content);
				 $tr.append($td);
				 var citedTd = $('<td style="text-align: center;">'+cited+'</td>');
				 $tr.append(citedTd);
				 $tbody.append($tr);
			 }
			 $('#artListTbl').append($tbody);

				$("#artListTbl").tablesorter({
					sortList:[[1,0]]
				});

				$("#artListTbl").bind("sortStart",function() {
					var artTr = $('#artListTbl > tbody > tr');
			        for(var i=0; i < artTr.length; i++){
			        	artTr.eq(i).children('td:first').text('');
			        }
			    }).bind("sortEnd",function() {
			        var artTr = $('#artListTbl > tbody > tr');
			        for(var i=0; i < artTr.length; i++){
			        	artTr.eq(i).children('td:first').text(i+1);
			        }
			    });


			 var title = $('#catNm_'+categ).val() + "( "+data.length+" )";
			 $('#dialog').dialog({
				width:730,
				height:450,
				modal:true,
				title:title,
				buttons:[{
					text:'닫기',
					click:function(){
						$(this).dialog("close");
					}
				}]
			 });

			//alert(data[0].ESUBJECT);
		 }
	 }).done(function(){});
 }

 </script>
</head>
<body>

	<h3><spring:message code="menu.asrms.dept.sbuject.page"/></h3>
	<div class="help_text mgb_30"><spring:message code="asrms.department.subject.trends.desc"/></div>

	<form id="frm" name="frm">
	<input type="hidden" id="topNm" name="topNm" value="<c:out value="${topNm}"/>"/>
	<input type="hidden" name="deptKor" id="deptKor" value="<c:out value="${parameter.deptKor}"/>"/>
	<input type="hidden" name="trackId" id="trackId" value="<c:out value="${parameter.trackId}"/>"/>

	<div class="top_option_box">
		<div class="to_inner">
			<span>학술지구분</span>
			<em>
				<select name="gubun" id="gubun">
					<option value="SCI" selected="selected">SCI</option>
					<option value="SCOPUS">SCOPUS</option>
					<option value="KCI">KCI</option>
				</select>
			</em>
			<span>OA구분</span>
			<em>
				<select name="openAccesAt" id="openAccesAt">
					<option value="" selected="selected">전체</option>
					<option value="Y">OA논문</option>
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
			<span>목록수</span>
			<em>
				<select name="rownum" id="rownum">
					<option value="ALL">전체</option>
					<option value="10" selected="selected">10</option>
					<option value="25">25</option>
					<option value="50">50</option>
				</select>
			</em>
		</div>
		<p class="ts_bt_box">
			<a href="javascript:subjectAjax();" class="to_search_bt"><span>Search</span></a>
		</p>
	</div>

	   <h3 class="circle_h3">Chart</h3>

	   <div id="chartdiv2" class="chart_box mgb_20"></div>

		<div id="tabs" class="tab_wrap" style="display: none;">
		  <ul>
		    <li><a href="#tabs-1">Data</a></li>
		    <li><a href="#tabs-2">Pie Chart</a></li>
		  </ul>
			<div id="tabs-1">
				<table width="100%" id="publicationsTbl" style="border-color: FFFFFF;border-width: 0px;border-spacing: 0px;">
					<colgroup>
						<col style="width: 5%"/>
						<col style="width: 35%"/>
						<col style="width: 60%"/>
					</colgroup>
					<thead>
						<tr>
							<th>
								<input type="checkbox" name="toggleChkbox" id="toggleChkbox" value="0"/>
							</th>
							<th style="text-align: left;"><span id="checkLable">전체선택</span></th>
							<th></th>
						</tr>
					</thead>
					<tbody></tbody>
				</table>
			</div>
			<div id="tabs-2">
				<div id="content_wrap" style="padding-left:0px">
					<div id="full_sub_content" style="display: ;">
					   <div id="chartdiv3" align="left"></div>
					</div>
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
<div id="dialog" style="display: none;">
	<table width="100%" id="artListTbl" class="list_tbl mgb_20">
	</table>
</div>
</body>
</html>
