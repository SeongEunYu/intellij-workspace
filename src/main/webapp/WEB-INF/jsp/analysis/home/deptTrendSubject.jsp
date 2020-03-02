<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><spring:message code="menu.asrms.about.sbuject"/></title>
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
 var toggle = true;
 var fc = 0;
 var chart_ChartId1;
 $(document).ready(function(){
		$( "#tabs" ).tabs({});
		$("#tabs").css("display", "block");

	    $('input:checkbox').bind('click', function(){ clickCheckbox($(this));});

		 $('#fromYear').data('prev', $('#fromYear').val());
		 $('#toYear').data('prev', $('#toYear').val());

		 renderChart();

  });

 function renderChart(){

	   var chartWidth = "100%";
	   var barWidth = "100%";
	   if(browserType() == "I"){
		   chartWidth = "748";
		   barWidth = "450";
	   }

	   chart_ChartId1 =  new FusionCharts({
	 	  type:'MSLine',
	 	  renderAt:'chartdiv2',
	 	  width:chartWidth,
	 	  height:'350',
	 	  dataFormat:'xml',
	 	  dataSource:"${chartXML}"
	   }).render();

	   var chart_ChartId3 =  new FusionCharts({
	 	  type:'Pie2D',
	 	  renderAt:'chartdiv3',
	 	  width:chartWidth,
	 	  height:'350',
	 	  dataFormat:'xml',
	 	  dataSource:"${chartXML2}"
	   }).render();

	   <c:forEach items="${subjectList }" var="sl" varStatus="st">
		  eval( "var chart_Chart${sl.ctgryCode} =  new FusionCharts({type:'Bar2D',renderAt:'chartdiv_${sl.ctgryCode}',width:'"+barWidth+"',height:'35',dataFormat:'xml',dataSource:\"${sl.chartXML}\"}).render()");
	   </c:forEach>

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

	 	var chartId = 'ChartId1';
		var category = "<categories>";
		var dataset = "";
		var hdataset = "";
		var fy = parseInt($('#fromYear').val(),10);
		var ty = parseInt($('#toYear').val(),10);

		for(var i=fy; i <= ty; i++)
		{
			category += "<category label='"+i+"' />";
		}
		category += "</categories>";

		var chb = $('input[id^="chkbox_"]:checked');
		for(var j=0; j < chb.length; j++)
		{
			var fcIdx = $('input[id^="chkbox_"]').index(chb.eq(j)) % 23;
			var yearJson = getYearMap(chb.eq(j).val());
			var catName = $('#catNm_'+chb.eq(j).val()).val();
			var color = fillColors[fcIdx];
			dataset += "<dataset seriesName='"+catName+"' id='"+chb.eq(j).val()+"' color='"+color+"'>";
			for(var i=fy; i <= ty; i++)
			{
				if(yearJson[i] == undefined) dataset += "<set value='0' toolText='"+catName+" "+i+" : 0' />";
				else dataset += "<set value='"+yearJson[i]+"' toolText='"+catName+" "+i+" : "+yearJson[i]+"' />";
			}
			dataset += "</dataset>";
		}
		var chartData = chart_ChartId1.getChartData('xml');
		chartData = chartData.replace(/(<chart .*>)(<categories.*)(<styles.*)/, '$1'+category+dataset+'$3');
		chart_ChartId1.setDataXML(chartData);

 }

 function getYearMap(chkValue){
	 var retString = "{";
	 for(var i=0; i < cjArr.length; i++)
	 {
		 if(cjArr[i].ctgryCode == chkValue) retString += cjArr[i].prodYear + ":" + cjArr[i].artsCo + ",";
	 }
	 retString = retString.substring(0, retString.length-1) + "}";
	 console.log(retString);
	 return eval('('+retString+')');
 }


//Callback handler method which is invoked after the chart has saved image on server.
 function myFN(objRtn){
 	if (objRtn.statusCode=="1")
 	{
 		saveExcel(objRtn.fileName);
 		//alert("The chart was successfully saved on server. The file can be accessed from " + objRtn.fileName);
 	}
 	else
 	{
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
	 //alert("chartClick event execute !!" + year);
	 $('#artListTbl').empty();
	 //loading publication list of year by ajax

	 $.ajax({
		 url : "${contextPath}/analysis/department/getArticleListBySubjectAjax.do",
		 dataType : 'json',
		 data : { "categ": categ,
			      "fromYear": $('#fromYear').val(),
			      "toYear": $('#toYear').val(),
			      "gubun" : 'SCI',
			      "deptKor" : $('#subject_deptKor').val(),
			      "isFulltime" : 'ALL',
			      "hldofYn" : '1'
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
				 var cited = $('#gubun').val() == 'SCI' ?  sciTc : scpTc;

			     var $tr = $('<tr style="height:17px;"></tr>');
				 $tr.append($('<td style="font-size: 10pt;" align="center" width="40">'+(i+1)+'</td>'));
				 var $td = $('<td class="link_td" style="font: normal 12px \'Malgun Gothic\';"></td>').append($('<div class="style_12pt"><b>'+esubject+'</b></div>'));
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
	<!-- content -->
	<form id="frm" name="frm" action="${contextPath}/analysis/home/deptTrendSubject.do" method="post">
	<input type="hidden" name="sTabIdx" id="sTabIdx" value="<c:out value="${sTabIdx}"/>"/>
	<input type="hidden" id="topNm" name="topNm" value="<c:out value="${topNm}"/>"/>

			<!--START page_title-->
	<h3><spring:message code="menu.asrms.about.sbuject.page"/></h3>
			<!--END page_title-->

	
			<!--START page_function-->
			<div class="sub_top_box">
				<span class="select_text">학술지구분</span>
				<span class="select_span">
					<select name="gubun" id="gubun" onchange="javascript:$('#frm').submit();">
						<option value="SCI" ${parameter.gubun eq 'SCI' ? 'selected="selected"' : '' }>SCI</option>
						<option value="SCOPUS" ${parameter.gubun eq 'SCOPUS' ? 'selected="selected"' : '' }>SCOPUS</option>
						<option value="KCI" ${parameter.gubun eq 'KCI' ? 'selected="selected"' : '' }>KCI</option>
					</select>
				</span>
				<%--
				<span class="select_text">Department</span>
				<span class="select_span">
					<select id="subject_deptKor" name="searchDept" onchange="javascript:$('#frm').submit();">
						<c:forEach items="${deptList}" var="dl">
						<option value="${dl.deptCode }"  <c:if test="${dl.deptCode eq parameter.searchDept}">selected="selected"</c:if> >
								<c:if test="${lang eq 'KOR' }"> ${dl.deptKor }</c:if>
								<c:if test="${lang eq 'ENG' }"> ${dl.deptKor }</c:if>
								<!--
								<c:if test="${lang eq 'ENG' }"> ${dl.deptEngMostAbbr }</c:if>
								 -->
						</option>
						</c:forEach>
					</select>
				</span>
				<span style="margin-top: 5px;">
						<a href="#" onclick="javascript:changeLang($('#frm'));">
							<c:if test="${sessionScope.aslang eq 'KOR'}"><img src="${contextPath}/images/common/btn_ENG.png" style="vertical-align: text-bottom;"/></c:if>
							<c:if test="${sessionScope.aslang eq 'ENG'}"><img src="${contextPath}/images/common/btn_KOR.png" style="vertical-align: text-bottom;"/></c:if>
						</a>
				</span>
				 --%>
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
				<span style="margin-left:10px;">목록</span>
				<span class="select_span">
					<select name="rownum" id="rownum" onchange="javascript:$('#frm').submit();">
						<option value="ALL" ${parameter.rownum eq 'ALL' ? 'selected="selected"' : '' }>전체</option>
						<option value="10" ${parameter.rownum eq '10' ? 'selected="selected"' : '' }>10</option>
						<option value="25" ${parameter.rownum eq '25' ? 'selected="selected"' : '' }>25</option>
						<option value="50" ${parameter.rownum eq '50' ? 'selected="selected"' : '' }>50</option>
					</select>
				</span>

			</div>
			<!--END page_function-->

	<div class="help_text mgb_30"><spring:message code="asrms.aboutsci.subject_trends.desc"/></div>

			<!--START sub_content_wrapper-->
		   <div id="chartdiv2" class="mgb_10"></div>

			<div id="tabs" class="tab_wrap" style="display: none;">
			  <ul>
			    <li><a href="#tabs-1">Data</a></li>
			    <li><a href="#tabs-2">Chart</a></li>
			  </ul>
				<div id="tabs-1">
					<table width="100%" id="publicationsTbl" class="tab_tbl" style="width: 100%;table-layout: fixed;">
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
						<c:forEach items="${subjectList }" var="sl" varStatus="st">
							<tr>
								<td style="text-align: center;">
									<input type="checkbox"  id="chkbox_${sl.ctgryCode}" value="${sl.ctgryCode}" <c:if test="${st.index<=4}">checked="checked"</c:if> />
									<input type="hidden" name="catNm_${sl.ctgryCode}" id="catNm_${sl.ctgryCode}" value="${sl.ctgryName}"/>
								</td>
								<td style="text-align:left;"><font style="font-size: 11px;"> ${sl.ctgryName}</font> </td>
								<td>
									<div id="chartdiv_${sl.ctgryCode}" align="left"></div>
								<input type="hidden" name="fillColorIndex_${sl.ctgryCode}" id="fillColorIndex_${sl.ctgryCode}"/>
								<script type="text/javascript">
									$('#fillColorIndex_${sl.ctgryCode}').val(fc);
									if(fc++ > fillColors.length-1) fc = 0;
								</script>
								</td>
							</tr>
						</c:forEach>
					</table>
				</div>
				<div id="tabs-2">
					<div id="content_wrap" style="padding-left:0px">
						<div id="full_sub_content" style="display: ;">
						   <div id="chartdiv3" align="left">
								<fc:render chartId="ChartId3"  swfFilename="Pie2D" width="100%" height="350" debugMode="false" registerWithJS="false"
									dataFormat="xml" xmlData="${chartXML2}" renderer="javascript" windowMode="transparent" />
						   </div>
						</div>
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
