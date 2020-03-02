<%@ page import="kr.co.argonet.r2rims.core.vo.DeptVo" %>
<%@ page import="kr.co.argonet.r2rims.core.code.CodeConfiguration" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Department Indicator Compare</title>
<script type="text/javascript">
 $(function() {
	$( "#tabs" ).tabs({});
	$("#tabs").css("display", "block");

     fulltimeArticleAjax();
  });

 function fulltimeArticleAjax(){
     if(!validateRange()){errorMsg(this); return false;}

     $.ajax({
         url:"<c:url value="/analysis/institution/fulltimeArticleAjax.do"/>",
         dataType: "json",
         data: $('#frm').serialize(),
         method: "POST",
         beforeLoad: $('.wrap-loading').css('display', '')

     }).done(function(data){

         $('#fromYear').data('prev', $('#fromYear').val());
         $('#toYear').data('prev', $('#toYear').val());

         if(FusionCharts('ChartId2')) {
             FusionCharts('ChartId2').dispose();
             $('#chartdiv1').disposeFusionCharts().empty();
         }

         new FusionCharts({
             id: 'ChartId2',
             type:'MSLine',
             renderAt:'chartdiv1',
             width:'100%',
             height:'350',
             dataFormat:'xml',
             dataSource:data.chartXML+""
         }).render();

         var $tbody = "";
         for(var i=0; i<data.fultimeArticleYearList.length; i++){
             var $tr = "<tr style='height:17px'>";
             var fl = data.fultimeArticleYearList[i];

			 $tr += '<td class="center">'+fl.pubYear+'</td>';
			 $tr += '<td class="center">'+fl.intrlJnalArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+'</td>';
			 $tr += '<td class="center">'+fl.intrlGnalArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+'</td>';
			 $tr += '<td class="center">'+fl.dmstcKciArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+'</td>';
			 $tr += '<td class="center">'+fl.dmstcGnalArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+'</td>';
			 $tr += '<td class="center">'+fl.othersArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+'</td>';
			 $tr += '<td class="center">'+fl.artsTotal.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+'</td>';

             $tr += "</tr>";
             $tbody += $tr;
         }

         if(data.fultimeArticleYearList.length == 0) $tbody+= '<tr><td colspan="99" style="padding-left:5px;"><img src="${contextPath}/images/layout/ico_info.png" /> 검색된 Data가 없습니다.</td></tr>';

         $("#publicationsTbl tbody").html($tbody);

         $('.wrap-loading').css('display', 'none');
     });
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

	 var div = $('<div></div>');
	 var table = $('<table></table>');
	 //append document title
	 var chartTitle = $('<tr><td style="text-align:center;"><h1><p>Institution - '+$('.page_title').html()+'</p></h1></td></tr>');
	 //append chart image
	 var chartTr = $('<tr><td><img src="'+fileName+'" height="350" /></td></tr>');
	 var dataTbl = $('<tr><td><h1>Chart Data</h1></td></tr><tr><td>'+$('#publicationsTbl').clone().wrapAll('<div/>').parent().html()+'</td></tr>');
	 table.append(chartTitle)
	      .append(chartTr)
	      .append(dataTbl);
	 //make table with data of checked researcher
	 div.append(table);
	 $('#tableHTML').val(div.html());
	 var excelFileName = "DepartmentFulltimeArticle_"+ $('#stndYear').val() + "_"  + $('#stndMonthDay').val() + "_from_" + $('#fromYear').val() +"_to_" + $('#toYear').val() + ".xls";
	 $('#fileName').val(excelFileName);
	 exportLog($('#frm'), excelFileName + "|" +  fileName);
	 $('#excelFrm').submit();
 }

 </script>
</head>
<body>
	<h3 class="page_title"><spring:message code="menu.asrms.inst.fulltimeArticle"/></h3>
	<div class="help_text mgb_30"><spring:message code="asrms.institution.fulltime.article.desc"/></div>

	<form id="frm" name="frm" action="${contextPath}/analysis/institution/fulltimeArticle.do" method="post">
	<input type="hidden" id="topNm" name="topNm" value="<c:out value="${topNm}"/>"/>
	<input type="hidden" name="isStndChanged" id="isStndChanged" value="false"/>

	<div class="top_option_box">
		<div class="to_inner">
			<span>실적구분</span>
			<em>
				<select name="insttRsltAt" id="insttRsltAt">
					<option value="ALL">전체</option>
					<option value="Y">${sysConf['inst.abrv']}</option>
					<option value="N">타기관</option>
				</select>
			</em>
			<span>대상학(부)과</span>
			<em>
				<select name="searchDept" id="searchDept">
					<option value="">전체</option>
					<%
						Map<String, List<DeptVo>> AllList = CodeConfiguration.getDeptList();
						Iterator<String> iter0 = AllList.keySet().iterator();
						List<DeptVo> deptList = new ArrayList<DeptVo>();

						while (iter0.hasNext()) {
							String str = iter0.next();
							List<DeptVo> departmentList = AllList.get(str);

							for (DeptVo deptVo : departmentList) {
								deptList.add(deptVo);
							}

						}

						//학과 이름순 정렬
						Collections.sort(deptList,new Comparator() {
							@Override
							public int compare(Object o1,Object o2) {
								String v1 = ((DeptVo)o1).getDeptKorNm();
								String v2 = ((DeptVo)o2).getDeptKorNm();

								return v1.compareTo(v2);
							}
						});

						for(int i=0; i<deptList.size(); i++){
					%>
							<option value="<%=deptList.get(i).getDeptKorNm() %>"><%=deptList.get(i).getDeptKorNm() %></option>
					<%	}	%>
				</select>
			</em>
			<span>기준연도</span>
			<em>
				<select name="stndYear" id="stndYear">
					<c:forEach items="${stndYearList}" var="stndY" varStatus="stats">
						<option value="<c:out value="${stndY.stndYear}"/>" ${stats.index == 1 ? 'selected="selected"' : ''}><c:out value="${stndY.stndYear}"/></option>
					</c:forEach>
				</select>
			</em>
			<span>기준일자</span>
			<em>
				<select name="stndMonthDay" id="stndMonthDay" onchange="javascript: $('#isStndChanged').val('true');">
					<c:forEach items="${stndMonthDayList}" var="stndMD" varStatus="stats">
						<option value="<c:out value="${stndMD.stndMonth}"/>-<c:out value="${stndMD.stndDay}"/>" ${stats.last == true ? 'selected="selected"' : ''}><c:out value="${stndMD.stndMonth}"/>월 <c:out value="${stndMD.stndDay}"/>일</option>
					</c:forEach>
				</select>
			</em>
			<p style="margin-top: 5px;"></p>
			<span>실적기간</span>
			<em>
				<select name="fromYear" id="fromYear">
					<c:forEach items="${stndYearList}" var="stndY" varStatus="stats">
						<option value="<c:out value="${stndY.stndYear}"/>" ${stats.last == true ? 'selected="selected"' : ''}><c:out value="${stndY.stndYear}"/></option>
					</c:forEach>
				</select>
			</em>					~
			<em>
				<select name="toYear" id="toYear">
					<c:forEach items="${stndYearList}" var="stndY" varStatus="stats">
						<option value="<c:out value="${stndY.stndYear}"/>" ${stats.index == 1 ? 'selected="selected"' : ''}><c:out value="${stndY.stndYear}"/></option>
					</c:forEach>
				</select>
			</em>
		</div>
		<p class="ts_bt_box">
			<a href="javascript:fulltimeArticleAjax();" class="to_search_bt"><span>Search</span></a>
		</p>
	</div>

		<h3 class="circle_h3">Chart</h3>
		<div class="chart_box mgb_20" id="chartdiv1"></div>

		<p class="bt_box mgb_20">
			<a href="#" onclick="exportExcel();" class="black_bt"><em class="export_icon">Export</em></a>
		</p>

		<h3 class="circle_h3">Data</h3>

		<div class="sub_content_wrapper">
			<table width="100%" id="publicationsTbl" class="list_tbl mgb_20">
				<colgroup>
					<col style="width: 10%"/>
					<col style="width: 12%"/>
					<col style="width: 10%"/>
					<col style="width: 10%"/>
					<col style="width: 10%"/>
					<col style="width: 10%"/>
					<col style="width: 10%"/>
				</colgroup>
				<thead>
					<tr style="text-align: center;height:25px">
						<th><span>Year</span></th>
						<th><span>SCI급 논문 <br/>(SCI+SCOPUS)</span></th>
						<th><span>국제일반</span></th>
						<th><span>국내KCI급 논문</span></th>
						<th><span>국내일반</span></th>
						<th><span>기타</span></th>
						<th><span>합계</span></th>
					</tr>
				</thead>
				<tbody></tbody>
			</table>
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
