<%@ page import="kr.co.argonet.r2rims.core.vo.DeptVo" %>
<%@ page import="kr.co.argonet.r2rims.core.code.CodeConfiguration" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><spring:message code="menu.asrms.inst.artCited"/></title>
<script>

 function exportExcel(){

	 var table = $('<table></table>');
	 //append document title
	 var docTitle = $('<tr><td style="text-align:center;"><h1><p>Institution - '+$('.page_title').html()+'</p></h1></td></tr>');
	 table.append(docTitle);
	 //make table with data of checked researcher
	 table.append($('<tr><td>'+$('#excelExportDiv > table').clone().wrapAll('<div/>').parent().html()+'</td></tr>'));
	 $('#tableHTML').val(table.wrapAll('<div/>').parent().html());
	 var excelFileName = "ArticleByCitation_"+$('#gubun').val() + "_from_" + $('#fromYear').val() +"_to_" + $('#toYear').val() + ".xls";
	 $('#fileName').val(excelFileName);
	 exportLog($('#frm'), excelFileName);
	 $('#excelFrm').submit();
 }

 $(document).ready(function(){
     topArticlesAjax();
});
 
 function topArticlesAjax(){
     if(!validateRange()){errorMsg(this); return false;}

     $.ajax({
         url:"<c:url value="/analysis/institution/topArticlesAjax.do"/>",
         dataType: "json",
         data: $('#frm').serialize(),
         method: "POST",
         beforeLoad: $('.wrap-loading').css('display', '')

     }).done(function(data){
         var $tbody = "";
         var $tbody2 = "";

         if(data.topArticleList.length > 0){
             for(var j=0; j < data.topArticleList.length; j++){
                 var item = data.topArticleList[j];
                 var tc;
                 if(data.parameter.gubun == 'SCI'){
                     tc = item.tc + "";
                 }else if(data.parameter.gubun == 'SCOPUS'){
                     tc = item.scpTc + "";
                 }else if(data.parameter.gubun == 'KCI'){
                     tc = item.kciTc + "";
                 }

                 tc = tc == 'null' ? '-' : tc;

                 var author = item.authorsInfo ? item.authorsInfo.split(';') : '';

                 var $tr = '<tr style="height:17px;">';
                 $tr += '<td style="font-size: 10pt;" align="center" width="40">'+(j+1)+'</td>';
                 $tr += '<td class="link_td" style="font: normal 12px"><div class="style_12pt"><a href="javascript:popArticle(\''+item.articleId+'\')"><b>'+item.orgLangPprNm+'</b></a></div></td>';
				 $tr += '<td style="text-align: center;padding-right: 5px;"><div>'+tc.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+'</div></td>';
				 $tr += '<td style="padding-left: 15px; text-align: left;"><div><ul>';

				 for(var i=0; i<author.length; i++){
                     var info = author[i].split(',');

                     var name = info[0];
                     var userid = info[1];
                     var grade = info[2];
                     var depart = info[3];

                     if(name != ""){
						$tr += '<li>'+name+'('+userid+')&nbsp;';

						if(depart != ""){
						    $tr += '/&nbsp; '+depart;
						}
					 	$tr +='</li>';
                     }

                 }

                 $tr += '</ul></div></td>';
                 $tr += '</tr>';

                 $tbody += $tr;

                 //엑셀 반출 테이블
                 var bgColor;
                 var volume = item.volume == null ? "" : 'v.'+item.volume;
                 var issue = item.issue == null ? "" : 'no.'+item.issue;
                 var pblcYm = item.pblcYm;

                 if(pblcYm != null){
                     if(pblcYm.length == 6) pblcYm = pblcYm.substring(0,4) + "." + pblcYm.substring(4);
                     if(pblcYm.length == 8) pblcYm = pblcYm.substring(0,4) + "." + pblcYm.substring(4,6)+"."+ pblcYm.substring(6);
                 }

                 if(j % 2 == 0) bgColor= "#ffffff";
				 else bgColor= "#eaeaff";

                 var $tr2 = '<tr height="17px">';
                 $tr2 += '<td>'+(j+1)+'</td>';
                 $tr2 += '<td><b>'+item.orgLangPprNm+'</b></td>';
                 $tr2 += '<td>'+item.authors+'</td>';
                 $tr2 += '<td>'+item.pblcPlcNm+'</td>';
                 $tr2 += '<td>'+item.scjnlNm+'</td>';
                 $tr2 += '<td>'+volume+'</td>';
                 $tr2 += '<td>'+issue+'</td>';
                 $tr2 += '<td>'+item.sttPage+'</td>';
                 $tr2 += '<td>'+item.endPage+'</td>';
                 $tr2 += '<td>'+(item.tc == null ? "" : item.tc) +'</td>';
                 $tr2 += '<td>'+(item.scpTc == null ? "" : item.scpTc)+'</td>';
                 $tr2 += '<td>'+(item.kciTc == null ? "" : item.kciTc)+'</td>';
                 $tr2 += '<td>'+pblcYm+'</td>';

                 $tbody2 += $tr2;
             }

         }else{
             var $tr = "<tr style='background-color: #ffffff;' height='17px'>";
             $tr += "<td style='font-size: 10pt;' align='center' colspan=99><img src='${contextPath}/images/layout/ico_info.png' /> 검색된 논문이 없습니다.</td>";
             $tbody += $tr;
             $tbody2 += $tr;
         }

         $("#publicationsTbl tbody").html($tbody);
         $("#excelExportDiv tbody").html($tbody2);

         $('#fromYear').data('prev', $('#fromYear').val());
         $('#toYear').data('prev', $('#toYear').val());

         $('.wrap-loading').css('display', 'none');
     });
 }
 
</script>
</head>
<body>
	<h3 class="page_title"><spring:message code="menu.asrms.inst.artCited"/></h3>
	<div class="help_text mgb_30"><spring:message code="asrms.institution.article.desc"/></div>

	<form id="frm" name="frm" action="${contextPath}/analysis/institution/topArticles.do" method="post">
	<input type="hidden" name="isUserChanged" id="isUserChanged" value="false"/>
	<input type="hidden" id="topNm" name="topNm" value="<c:out value="${topNm}"/>"/>

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
							<option value="100">100</option>
							<option value="500">500</option>
							<option value="1000">1000</option>
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
				<a href="javascript:topArticlesAjax();" class="to_search_bt"><span>Search</span></a>
			</p>
		</div>
		<p class="bt_box mgb_20"><a href="#" onclick="exportExcel();" class="black_bt"><em class="export_icon">Export</em></a></p>
		<table width="100%;" id="publicationsTbl" class="list_tbl mgb_20">
			<colgroup>
				<col style="width: 5%"/>
				<col style="width: 50%"/>
				<col style="width: 7%"/>
				<col style="width: 40%"/>
			</colgroup>
			<thead>
				<tr>
					<th><span>No</span></th>
					<th><span>논문명</span></th>
					<th><span>TC</span></th>
					<th><span>저자정보</span></th>
				</tr>
			</thead>
			<tbody></tbody>
			</table>
	</form>

<form id="excelFrm" method="post" action="${contextPath}/jsp/excelExport.jsp">
      <input type="hidden" id="fileName" name="fileName" value="publication.xls" />
      <input type="hidden" id="tableHTML" name="tableHTML" value="" />
      <div style="display: none;" id="excelExportDiv">
      	<table>
			<thead>
				<tr>
					<th><span>No</span></th>
					<th><span>Title</span></th>
					<th><span>Authors</span></th>
					<th><span>Publisher</span></th>
					<th><span>Journal</span></th>
					<th><span>Volume</span></th>
					<th><span>Issue</span></th>
					<th><span>startPage</span></th>
					<th><span>endPage</span></th>
					<th><span>TC(SCI)</span></th>
					<th><span>TC(SCOPUS)</span></th>
					<th><span>TC(KCI)</span></th>
					<th><span>IssueDate</span></th>
				</tr>
			</thead>
			<tbody></tbody>
      	</table>
      </div>
</form>
<div id="exportDiv" style="display: none;"></div>
</body>
</html>
