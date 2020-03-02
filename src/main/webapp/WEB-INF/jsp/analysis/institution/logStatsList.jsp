<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Department Full Time SCI Average Citation </title>
<script type="text/javascript">
 var toggle = true;
 var fillColors = new Array( "AFD8F8","F6BD0F","8BBA00","FF8E46","008E8E",
			"D64646","8E468E","588526","B3AA00","008ED6",
			"9D080D","A186BE","CC6600","FDC689","ABA000",
			"F26D7D","FFF200","0054A6","F7941C","CC3300",
			"006600","663300","6DCFF6");
 var fc = 0;
 var if_fc = 0;
 //var article_djArr = eval('('+ '${article_dataJson}'+')');
 //var citation_djArr = eval('('+ '${citation_dataJson}'+')');
 //var impact_djArr = eval('('+ '${impact_dataJson}'+')');
 $(function() {
		$( "#tabs" ).tabs({
			active: '<c:out value="${sTabIdx}"/>',
		});
		$("#tabs").css("display", "block");
		//article_printDataTable();
		//citation_printDataTable();
		//impact_printDataTable();
	    //$('input:checkbox').bind('click', function(){ clickCheckbox($(this));});
  });


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
	 var chart1Tr = $('<tr style="height:360px;"><td style="width:694px;height:360px;"><img src="'+chartFileArr[0]+'" style="width: 694px; height: 350px;"/></td></tr>');
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
	 var chart2Tr = $('<tr style="height:360px;"><td style="width:694px;height:360px;"><img src="'+chartFileArr[1]+'" style="width: 694px; height: 350px;"/></td></tr>');
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
	 var chart3Tr = $('<tr style="height:360px;"><td style="width:694px;height:360px;"><img src="'+chartFileArr[2]+'" style="width: 694px; height: 350px;"/></td></tr>');
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

	 var excelFileName = "DepartmentFulltimeStats_"+$('#stnd').val() + "_from_" + $('#fromYear').val() +"_to_" + $('#toYear').val() + ".xls";
	 $('#fileName').val(excelFileName);
	 exportLog($('#frm'), excelFileName + "|" +  chartFileArr);
	 chartFileArr = new Array();
	 $('#excelFrm').submit();
 }
 </script>
</head>
<body>
	<h3 class="page_title">시스템 접속자</h3>
	<%--<div class="help_text mgb_30"><spring:message code="asrms.institution.logStatsByMenu.desc"/></div>--%>

	<form id="frm" name="frm" action="${contextPath}/analysis/institution/logStatsList.do" method="post">
	<input type="hidden" id="topNm" name="topNm" value="<c:out value="${topNm}"/>"/>
	<input type="hidden" name="sTabIdx" id="sTabIdx" value="${empty sTabIdx ? '0' : sTabIdx }"/>
	<input type="hidden" name="isStndChanged" id="isStndChanged" value="false"/>

		<div class="sub_top_box">
			<span class="select_text">User Name or ID</span>
			<span>
				<input type="text" name="searchName" id="searchName" style="width: 100px;" value="${parameter.searchName}"/>
			</span>
			<span class="select_text">Access User</span>
			<span class="select_span">
				<select name="userId" id="userId" onchange="javascript:$('#frm').submit();">
					<option value="" ${empty parameter.userId ? 'selected="selected"' : '' }>전체</option>
					<c:forEach var="ul" items="${userList}" varStatus="idx">
					  <option value="${ul.userId }" ${parameter.userId eq ul.userId ? 'selected="selected"' : '' }>${ul.korNm }</option>
					</c:forEach>
				</select>
			</span>
			<span class="select_text mgl_20">Year-Month range</span>
			<span class="select_span">
				<select name="fromYm" id="fromYm" onchange="javascript:if(validateRange()){ $('#frm').submit();}else{ errorMsg(this); $(this).val($(this).data('prev')); return false;}">
					<c:forEach var="yl" items="${regymList}" varStatus="idx">
					  <option value="${yl.regym }" ${parameter.fromYm eq yl.regym ? 'selected="selected"' : '' }>${yl.regym }</option>
					</c:forEach>
				</select>
			</span>
			~
			<span class="select_span">
				<select name="toYm" id="toYm" onchange="javascript:if(validateRange()){ $('#frm').submit();}else{ errorMsg(this); $(this).val($(this).data('prev')); return false;}">
					<c:forEach var="yl" items="${regymList}" varStatus="idx">
					  <option value="${yl.regym }" ${parameter.toYm eq yl.regym ? 'selected="selected"' : '' }>${yl.regym }</option>
					</c:forEach>
				</select>
			</span>
			<p style="margin-top: 5px;">
			<span class="select_text">Top Menu</span>
			<span class="select_span">
				<select name="searchTopMenu" id="searchTopMenu" onchange="javascript:$('#frm').submit();">
					<option value="" ${empty parameter.searchTopMenu ? 'selected="selected"' : '' }>전체</option>
					<c:forEach var="tl" items="${topMenuList}" varStatus="idx">
					  <option value="${tl.codeValue }" ${parameter.searchTopMenu eq tl.codeValue ? 'selected="selected"' : '' }>${tl.codeDisp }</option>
					</c:forEach>
				</select>
			</span>
			<span style="margin-left:10px;">목록수</span>
			<span class="select_span">
				<select name="rownum" onchange="javascript:$('#frm').submit();">
					<option value="ALL" ${parameter.rownum eq 'ALL' ? 'selected="selected"' : '' }>전체</option>
					<option value="50" ${parameter.rownum eq  '50' ? 'selected="selected"' : '' }>50</option>
					<option value="100" ${parameter.rownum eq '100' ? 'selected="selected"' : '' }>100</option>
					<option value="500" ${parameter.rownum eq '500' ? 'selected="selected"' : '' }>500</option>
				</select>
			</span>
		</div>

		<div class="sub_content_wrapper" style="width: 100%;overflow: auto;">
			<table width="100%" id="institutionMenu_dataTbl" class="list_tbl mgb_20" style="table-layout: fixed;">
				<thead>
					<tr style="height: 0px;">
						<td style="width: 40px;border: 0px;height: 0px;"></td>
						<td style="width: 100px;border: 0px;height: 0px;"></td>
						<td style="width: 80px;border: 0px;height: 0px;"></td>
						<td style="width: 40px;border: 0px;height: 0px;"></td>
						<td style="width: 105px;border: 0px;height: 0px;"></td>
						<td style="width: 120px;border: 0px;height: 0px;"></td>
						<td style="width: 120px;border: 0px;height: 0px;"></td>
					</tr>
					<tr>
						<th rowspan="2">No</th>
						<th rowspan="2">접속일자</th>
						<th colspan="2">접속자</th>
						<th rowspan="2">조회대상</th>
						<th rowspan="2">Top Menu</th>
						<th rowspan="2">Sub Menu</th>
					</tr>
					<tr>
						<th style="border-top: 1px solid #bdbdbd">성명</th>
						<th style="border-top: 1px solid #bdbdbd">ID</th>
					</tr>
				</thead>
				<tbody>
					<c:if test="${not empty  statsList}">
					<c:forEach items="${statsList }" var="sl" varStatus="idx">
					<tr>
						<td style="text-align: center;">${idx.count}</td>
						<td><fmt:formatDate value="${sl.regDate}"  var="logRegDate" pattern="yyyy-MM-dd HH:mm:ss"/>${logRegDate}</td>
						<td style="text-align: center;">${sl.korNm }</td>
						<td style="text-align: center;">${sl.userId }</td>
						<c:choose>
							<c:when test="${sl.topMenu eq 'researcher' }">
								<td style="text-align: center;">${sl.targetUserNm }</td>
							</c:when>
							<c:when test="${sl.topMenu eq 'department' }">
								<td style="text-align: center;">${sl.targetDept }</td>
							</c:when>
							<c:when test="${sl.topMenu eq 'college' }">
								<td style="text-align: center;">${sl.targetCollegeNm }</td>
							</c:when>
							<c:otherwise>
								<td style="text-align: center;"></td>
							</c:otherwise>
						</c:choose>
						<td style="text-align: center;">${sl.topMenuNm }</td>
						<td >${sl.menuNm }</td>
						<%--
						<td style="text-align: center;">${is.CODE_DISP }</td>
						<td style="text-align: center;"><fmt:formatNumber value="${fn:trim(is.CLICK_COUNT)}" type="number" /></td>
						 --%>
					</tr>
					</c:forEach>
					</c:if>
					<c:if test="${empty  statsList}">
						<tr>
							<td colspan="7">No data to display</td>
						</tr>
					</c:if>
				</tbody>
			</table>
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
