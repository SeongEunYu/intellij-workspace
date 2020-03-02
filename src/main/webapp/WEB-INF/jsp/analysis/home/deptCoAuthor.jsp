<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><spring:message code="menu.asrms.about.coauthor"/></title>
<link href="${contextPath}/css/easytab/bootstrap.min.css" rel="stylesheet"  type="text/css" />
<script language="JavaScript" src="${contextPath}/Charts/JSClass/FusionCharts.js"></script>
<script type="text/javascript">
 var toggle = true;
 $(document).ready(function(){
	 	$( "#tabs" ).tabs({
			active: '<c:out value="${sTabIdx}"/>',
			activate: function( event, ui ) {
				//clickCheckbox();
				if(ui.newPanel.is('#tabs-1')) $('#sTabIdx').val('0');
				if(ui.newPanel.is('#tabs-2')) $('#sTabIdx').val('1');
			}
		});
		 $("#tabs").css("display", "block");
		$('#fromYear').data('prev', $('#fromYear').val());
		$('#toYear').data('prev', $('#toYear').val());

  });

 function printDataTable(){

 }

 function changePicture(){
	if(toggle){
		 $('#full_sub_content').css('display','none');
		 $('#d3ChartSample').css('display','');
		 toggle = false;
	}else{
		 $('#full_sub_content').css('display','');
		 $('#d3ChartSample').css('display','none');
		 toggle = true;
	}
 }
 function chartClick(targtUserId){

	 $('#artlist_title').css('display','');
	 $('.publicationsDiv').css('display','');
	 $('#publicationsTbl').empty();

	 $.ajax({
		 url : "${contextPath}/analysis/department/findArticleListByCoAuthorDepartmentAjax.do",
		 dataType : 'json',
		 data : { "userid": $('#userid').val(),
			      "fromYear": $('#fromYear').val(),
			      "toYear": $('#toYear').val(),
			      "gubun" : $('#gubun').val(),
			      "coauthorUser" : targtUserId
			     },
		 success : function(data, textStatus, jqXHR){

			 for(var i=0; i < data.length; i++){

				 var seqno = data[i].articleId;
				 var esubject = data[i].orgLangPprNm == null ? '' : data[i].orgLangPprNm;
			     var authors = data[i].authors == null ? '' : data[i].authors;
			     var publisher = data[i].pblcPlcNm == null ? '' : data[i].pblcPlcNm;
				 var magazine = data[i].scjnlNm == null ? '' : data[i].scjnlNm;
			     var vol = data[i].volume == null ? '' : data[i].volume;
			     var no = data[i].issue == null ? '' : data[i].issue
				 var strpage = data[i].sttPage == null ? '' : data[i].sttPage;
			     var endpage = data[i].endPage == null ? '' : data[i].endPage;
			     var issueDate = data[i].pblcYm == null ? '' : dateFormat(data[i].pblcYm);
			     var impctFctr = data[i].impctFctr == null ? '' : data[i].impctFctr;
			     var sciTc = data[i].tc == null ? '' : data[i].tc;
			     var scpTc = data[i].scpTc == null ? '' : data[i].scpTc;

				 var color =  (i+1) % 2 == 1 ? "#ffffff" : "#eaeaff";
				 var $tr = $('<tr style="background-color: '+color+';" height="17px"></tr>');
				 $tr.append($('<td style="font-size: 10pt;" align="center" width="40">'+(i+1)+'</td>'));
				 var $td = $('<td class="link_td" style="font-size: 10pt;"></td>').append($('<a href="javascript:popArticle('+seqno+')"><b>'+esubject+'</b></a>'));
				 var content = '&nbsp;/ '+authors + '&nbsp;('+publisher+',&nbsp;' + magazine+',&nbsp;v.'+vol+',&nbsp;no.'+no+',&nbsp; pp.'+strpage+'~'+endpage+',&nbsp;'+issueDate+')';
				 $td.append(content);
				 $tr.append($td);
				 $('#publicationsTbl').append($tr);

			 }

			//alert(data[0].ESUBJECT);
		 }
	 }).done(function(){});


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

 $(document).ready(function(){
	 var myExportComponent = new FusionChartsExportObject("fcExporter1", "${contextPath}/Charts/flash/FusionCharts/FCExporter.swf");
 });

 function exportExcel(){

	 var chartObject = getChartFromId('ChartId1');

	 if( chartObject.hasRendered() ) chartObject.exportChart( { exportFormat : 'png'} );
 }
 function saveExcel(fileName){

	 var $div = $('<div></div>');
	 $('#tableHTML').val($('<div><table><tr style="height:350px;"><td style="height:350px;">&nbsp;<p style="text-align:center;"><img src="'+fileName+'" style="width: 730px; height: 350px;"/></p><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/></td></tr></tr><td>'+$('#dataTbl').parent().html()+'</td></tr></table></div>').html());


	 $('#excelFrm').submit();
 }


 function saveExcel(fileName){

	 var sDeptKor = $('#searchDeptKor option:selected').text();

	 var div = $('<div></div>');
	 var table = $('<table></table>');
	 var pageTitle = $('<tr><td style="text-align:center;"><h1><p>Department('+sDeptKor+') - '+$('.page_title').html()+'</p></h1></td></tr>');
	 var chartTr = $('<tr style="height:460px;"><td style="height:350px;"><img src="'+fileName+'" style="width: 694px; height: 420px;"/></td></tr>');
	 var dataTitle = $('<tr><td><h1>Chart Data</h1></td></tr>');
	 table.append(pageTitle)
	      .append(chartTr)
	      .append(dataTitle)
	      .append($('<tr><td>'+$('#dataTbl').clone().wrapAll('<div/>').parent().html()+'</td></tr>'));
	 div.append(table);
	 $('#tableHTML').val(div.html());
	 var excelFileName = "Co-AuthorshipNetwork_SCI"+ "_from_" + $('#fromYear').val() +"_to_" + $('#toYear').val() + ".xls";
	 $('#fileName').val(excelFileName);
	 exportLog($('#frm'), excelFileName + "|" +  fileName);
	 $('#excelFrm').submit();
 }
 </script>
</head>
<body>
	<!-- content -->
	<form id="frm" name="frm" action="${contextPath}/analysis/home/deptCoAuthor.do"  method="post">
	<input type="hidden" id="topNm" name="topNm" value="<c:out value="${topNm}"/>"/>
	<input type="hidden" name="isDeptChanged" id="isDeptChanged" value="false"/>

	<h3  class="page_title"><spring:message code="menu.asrms.about.coauthor"/></h3>


			<!--START page_function-->
			<div class="sub_top_box">
				<span style="margin-left:10px;">Department</span>
				<span class="select_span">
					<select id="searchDeptKor" name="searchDept" onchange="javascript:$('#isDeptChanged').val('true'); $('#frm').submit();">
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
				<%--
				<span style="margin-left:10px;">학술지구분</span>
				<span class="select_span">
					<select name="gubun" id="gubun" onchange="javascript:$('#frm').submit();">
						<option value="ALL" ${parameter.gubun eq 'ALL' ? 'selected="selected"' : '' }>전체</option>
						<option value="SCI" ${parameter.gubun eq 'SCI' ? 'selected="selected"' : '' }>SCI</option>
						<option value="SCOPUS" ${parameter.gubun eq 'SCOPUS' ? 'selected="selected"' : '' }>SCOPUS</option>
					</select>
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
			</div>
			<!--END page_function-->

	<div class="help_text mgb_30"><spring:message code="asrms.aboutsci.coauthorship_network.desc"/></div>

	 <div>
		<div id="tabs" class="tab_wrap" style="display: none;">
		  <ul>
		    <li><a href="#tabs-1">Chart</a></li>
		    <li><a href="#tabs-2">Data</a></li>
		  </ul>
	  		<div id="tabs-1">
				<div id="content_wrap" style="padding-left:0px">
					<div id="full_sub_content" style="display: ;">
					   <div id="chartdiv1" align="left">FusionCharts. </div>
				       <script type="text/javascript">
						   var chart1 = new FusionCharts("${contextPath}/Charts/flash/DragNode.swf", "ChartId1", "694", "450", "0", "1");
						   chart1.addParam("WMode", "Transparent");
						   chart1.setDataXML("<c:out value="${chartXML}" escapeXml="false"/>");
						   chart1.render("chartdiv1");
						</script>
					</div>
					<div id="d3ChartSample" style="display: none;">
						<img src="${contextPath}/images/kaist/CoauthorNetwork.png" alt="" />
					</div>
				</div>
		   </div>
			<div id="tabs-2">
				<div id="content_wrap">
					<table width="100%" id="dataTbl" class="list_tbl mgb_20">
						<colgroup>
							<col style="width: 10%"/>
							<col style="width: 40%"/>
							<col style="width: 25%"/>
						</colgroup>
					<thead>
						<tr style="height:35px;">
							<th><span>NO</span></th>
							<th><span>Department</span></th>
							<th><span>No. of Publictaion Co-author</span></th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${coAuthorList}" var="co" varStatus="st">
							<tr style='height:100%;'>
								<td style="text-align: center;">${st.count}</td>
								<td style="padding-left: 5px;">
									<c:if test="${sessionScope.aslang eq 'KOR' }"> ${co.deptKor }</c:if>
									<c:if test="${sessionScope.aslang eq 'ENG' }"> ${co.deptKor }</c:if>
									<!--
									<c:if test="${sessionScope.lang eq 'ENG' }"> ${co.deptEngNm }</c:if>
									 -->
								</td>
								<td style="text-align: center; padding-right: 5px;">${co.coArtsCo}</td>
							</tr>
						</c:forEach>
					</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
  </div>
</form>

<!-- end# wrapper-->
<form id="excelFrm" method="post" action="${contextPath}/jsp/excelExport.jsp">
      <input type="hidden" id="tableHTML" name="tableHTML" value="" />
      <input type="hidden" id="fileName" name="fileName" value="test.xls" />
</form>
</body>
</html>
