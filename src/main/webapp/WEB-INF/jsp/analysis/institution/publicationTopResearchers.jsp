<%@ page import="kr.co.argonet.r2rims.core.vo.DeptVo" %>
<%@ page import="kr.co.argonet.r2rims.core.code.CodeConfiguration" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Top Researchers By Publications</title>
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
<script>
 function popArticle(seqno) {
		var url = "${contextPath}/jsp/viewDetail.jsp?seqno="+seqno;
		var PopUP = window.open(url, "detail", "width=670,height=700,directories=no,status=no,toolbar=no,menubar=no,scrollbars=yes,resizable=yes");
 }

 function exportExcel(){

	 var table = $('<table></table>');
	 //append document title
	 var docTitle = $('<tr><td style="text-align:center;"><h1><p>Institution - '+$('.page_title').html()+'</p></h1></td></tr>');
	 table.append(docTitle);
	 //make table with data of checked researcher
	 table.append($('<tr><td>'+$('#publicationsTbl').clone().wrapAll('<div/>').parent().html()+'</td></tr>'));
	 $('#tableHTML').val(table.wrapAll('<div/>').parent().html());
	 var excelFileName = "ResearcherByPulbication_"+$('#gubun').val() + "_from_" + $('#fromYear').val() +"_to_" + $('#toYear').val() + ".xls";
	 $('#fileName').val(excelFileName);
	 exportLog($('#frm'), excelFileName);
	 $('#excelFrm').submit();
 }

 $(document).ready(function(){
     byPublicationsAjax('0');
 });
 
 function byPublicationsAjax(idx){
     if(!validateRange()){errorMsg(this); return false;}

     $.ajax({
         url:"<c:url value="/analysis/institution/byPublicationsAjax.do"/>",
         dataType: "json",
         data: $('#frm').serialize(),
         method: "POST",
         beforeLoad: $('.wrap-loading').css('display', '')

     }).done(function(data){
         var $tbody = "";

         if(data.topList.length > 0){
             for(var j=0; j < data.topList.length; j++){
                 var item = data.topList[j];
				 var artsCo;
				 if(data.parameter.gubun == 'ALL'){
					 artsCo = item.artsTotal;
                 }else if(data.parameter.gubun == 'SCI'){
                     artsCo = item.sciArtsCo;
                 }else if(data.parameter.gubun == 'SCOPUS'){
                     artsCo = item.scpArtsCo;
                 }else if(data.parameter.gubun == 'KCI'){
                     artsCo = item.kciArtsCo;
                 }

                 var $tr = '<tr style="height:25px;">';
                 $tr += '<td style="font-size: 10pt;" align="center">'+(j+1)+'</td>';
                 $tr += '<td align="center" style="font: normal 12px"><span class="breakKeepAll">'+item.korNm+'</span></td>';
                 $tr += '<td align="center" style="font: normal 12px"><span class="breakKeepAll">'+item.userId+'</span></td>';
                 $tr += '<td style="text-align: center;"><span class="breakKeepAll">'+item.posiNm+'</span></td>';
                 $tr += '<td style="text-align: left; padding-left: 5px;"><span class="breakKeepAll">'+item.deptKor+'</span></td>';
                 $tr += '<td style="text-align: center;padding-right: 5px;">'+artsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+'</td>';
                 $tr += '</tr>';

                 $tbody += $tr;
             }
         }else{
             var $tr = "<tr style='background-color: #ffffff;' height='17px'>";
             $tr += "<td style='font-size: 10pt;' align='center' colspan=99><img src='${contextPath}/images/layout/ico_info.png' /> 검색된 논문이 없습니다.</td>";
             $tbody += $tr;
         }

         $("#publicationsTbl tbody").html($tbody);

         if(idx == "0") {
             $("#publicationsTbl").tablesorter({sortList: [[5, 1]]});
         }else{
             $("#publicationsTbl th").removeClass('headerSortUp');
             $("#publicationsTbl th").removeClass('headerSortDown');
             $("#publicationsTbl th").eq(5).addClass('headerSortUp');
         }
         $("#publicationsTbl").trigger("update");

         $("#publicationsTbl").bind("sortStart",function() {
             var artTr = $('#publicationsTbl > tbody > tr');
             for(var i=0; i < artTr.length; i++){
                 artTr.eq(i).children('td:first').text('');
             }
         }).bind("sortEnd",function() {
             var artTr = $('#publicationsTbl > tbody > tr');
             for(var i=0; i < artTr.length; i++){
                 artTr.eq(i).children('td:first').text(i+1);
             }
         });

         $('#fromYear').data('prev', $('#fromYear').val());
         $('#toYear').data('prev', $('#toYear').val());

         $('.wrap-loading').css('display', 'none');
     });
 }
</script>
</head>
<body>
	<h3 class="page_title"><spring:message code="menu.asrms.inst.pub"/></h3>
	<div class="help_text mgb_30"><spring:message code="asrms.institution.publication.desc"/></div>

	<form id="frm" name="frm">
	<input type="hidden" id="topNm" name="topNm" value="<c:out value="${topNm}"/>"/>
	<input type="hidden" name="tpiDvsCd" id="tpiDvsCd" value="all"/>

		<div class="top_option_box">
			<div class="to_inner">
				<span>학술지구분</span>
				<em>
					<select name="gubun" id="gubun">
						<option value="ALL">전체</option>
						<option value="SCI" selected="selected">SCI</option>
						<option value="SCOPUS">SCOPUS</option>
						<option value="KCI">KCI</option>
					</select>
				</em>
				<span>재직구분</span>
				<em>
					<select name="hldofYn" id="hldofYn">
						<option value="ALL">전체</option>
						<option value="1" selected="selected">재직</option>
						<option value="2">퇴직</option>
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
				<span>실적구분</span>
				<em>
					<select name="insttRsltAt" id="insttRsltAt">
						<option value="" selected="selected">전체</option>
						<option value="Y">${sysConf['inst.abrv']}</option>
						<option value="N">타기관</option>
					</select>
				</em>
				<p style="margin-top: 5px;">
					<span>목록수</span>
					<em>
						<select name="rownum">
							<option value="ALL">전체</option>
							<option value="20" selected="selected">20</option>
							<option value="50">50</option>
						</select>
					</em>
					<span>대상학(부)과</span>
					<em>
						<select name="searchDept" id="searchDept" style="width: 142px;">
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
					<span>신분구분</span>
					<em>
						<select name="isFulltime" id="isFulltime">
							<option value="ALL">전체</option>
							<option value="M" selected="selected">전임</option>
							<option value="U">비전임</option>
						</select>
					</em>
				</p>
			</div>
			<p class="ts_bt_box">
				<a href="javascript:byPublicationsAjax();" class="to_search_bt"><span>Search</span></a>
			</p>
		</div>

	<p class="bt_box"><a href="#" onclick="exportExcel();" class="black_bt"><em class="export_icon">Export</em></a></p>
	<div style="float: left;margin: -10px 0px 5px 5px">
		<input type="radio" name="tpiDvsRadio" id="tpiDvsAll" value="all" checked="checked" style="vertical-align: -2px;" onchange="javascript: $('#tpiDvsCd').val($(this).val());byPublicationsAjax();" /><span>&nbsp;전체&nbsp;&nbsp;</span>
		<input type="radio" name="tpiDvsRadio" id="tpiDvsMain" value="main" style="vertical-align: -2px;" onchange="javascript: $('#tpiDvsCd').val($(this).val());byPublicationsAjax();"/><span>&nbsp;주저자(단독,제1,교신)</span>
	</div>
	<table width="100%" id="publicationsTbl" class="list_tbl mgb_20">
		   <colgroup>
			 <col style="width: 7%"/>
			 <col style="width: 15%"/>
			 <col style="width: 15%"/>
			 <col style="width: 15%"/>
			 <col style="width: 30%"/>
			 <col style="width: 25%"/>
		   </colgroup>
			<thead>
				<tr style="height: 25px;">
					<th><span>NO</span></th>
					<th><span>성명</span></th>
					<th><span>ID</span></th>
					<th><span>직급</span></th>
					<th><span>학(부)과</span></th>
					<th><span>논문수</span></th>
				</tr>
			</thead>
			<tbody></tbody>
		</table>
</form>
<form id="excelFrm" method="post" action="${contextPath}/jsp/excelExport.jsp">
      <input type="hidden" id="tableHTML" name="tableHTML" value="" />
      <input type="hidden" id="fileName" name="fileName" value="publication.xls" />
</form>
<div id="exportDiv" style="display: none;"></div>
</body>
</html>
