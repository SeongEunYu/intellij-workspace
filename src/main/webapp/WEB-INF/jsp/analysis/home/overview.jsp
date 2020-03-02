<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@page import="kr.co.argonet.r2rims.core.comment.CommentConfiguration"%>
<%@ include file="../../pageInit.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<title>main_page</title>
<script type="text/javascript">
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
 function changeLatestDept(){
	 $('#lastedUl').empty();

	 $.ajax({
		 url : "${contextPath}/analysis/home/findLatestArticleListAjax.do",
		 type: 'POST',
		 dataType : 'json',
		 data : { "searchDept":$('#latestDept').val(), 'gubun':'SCI' },
		 success : function(data, textStatus, jqXHR){

			 for(var i=0; i < data.length; i++){
				 if(i >= 4)break;
				 var seqno = data[i].articleId;
				 var esubject = data[i].orgLangPprNm == null ? '' : data[i].orgLangPprNm;
			     var authors = data[i].authors == null ? '' : data[i].authors;
			     var publisher = data[i].pblcPlcNm == null ? '' : data[i].pblcPlcNm;
				 var magazine = data[i].scjnlNm == null ? '' : data[i].scjnlNm;
			     var vol = data[i].volume == null ? '' : 'v.' + data[i].volume;
			     var no = data[i].issue == null ? '' : 'no.' + data[i].issue;
			     var strpage = data[i].sttPage == null ? '' : data[i].sttPage;
			     var endpage = data[i].endPage == null ? '' : data[i].endPage;
			     var issueDate = data[i].pblcYm == null ? '' : dateFormat(data[i].pblcYm);
			     var esubjectLink = data[i].doi == null ? '<a href="javascript:popArticle(\''+seqno+'\');" style="font-size: 8.5pt;text-overflow:ellipsis;overflow: hidden;white-space:nowrap;"><b>' + esubject + '</b></a>' : '<a href="http://dx.doi.org/'+data[i].doi+'" target="_blank" style="font-size: 8.5pt;text-overflow:ellipsis;overflow: hidden;white-space:nowrap;"><b>'+esubject+'</b></a>';

				 var $li = $('<li></li>');
				 var $a = $(esubjectLink);
				 //var content = '<b>Journal</b>: '+magazine+' [v.'+vol+',&nbsp;no.'+no+',&nbsp; pp.'+strpage+'~'+endpage+',&nbsp;'+issueDate+']';
				 var content = '<span>'+authors + '&nbsp;('+publisher+',&nbsp;' + magazine+',&nbsp;'+vol+',&nbsp;'+no+',&nbsp; pp.'+strpage+'~'+endpage+',&nbsp;'+issueDate+')</span>';
				 $li.append($a);
				 $li.append(content);
				 $('#lastedUl').append($li);

			 }
		 }
	 });
 }

function searchJcr(){
	 $('#jcrJournalTbl > tbody').empty();

	 $.ajax({
		 url : "${contextPath}/home/getJcrHighAjax.do",
		 type: 'POST',
		 dataType : 'json',
		 data : { "mask_categ":$('#mask_categ').val(),
			 	  "mask_year":$('#mask_year').val()
			    },
		 success : function(data, textStatus, jqXHR){
			 var j = 1;
			 for(var i=0; i < data.length; i++){
				 if(j > 10) break;
				 var title = data[i].TITLE;
				 var issn = data[i].ISSN == null ? '' : data[i].ISSN;
			     var impact = data[i].IMPACT == 'False' ? '-' : data[i].IMPACT;

				 var $tr = $('<tr style="height:25px;"></tr>');
				 $tr.append($('<td align="center">'+j+'</td>'));
				 var $td = $('<td class="link_td" style="font-size: 8pt;width:65%; overflow: hidden; text-overflow:ellipsis; white-space:nowrap;" title="'+title+'">'+title+'</td>');
				 $tr.append($td);
				 $tr.append($('<td style="text-align: center;font-size: 8pt;">'+issn+'</td>'));
				 $tr.append($('<td style="text-align: center;font-size: 8pt;">'+impact+'</td>'));

				 $('#jcrJournalTbl > tbody').append($tr);
				 j++;
			 }
			 //$('#list_title').text('Publication ('+year+')');
			//alert(data[0].ESUBJECT);
		 }
	 });
 }
 function changeCoreDept(){
	 $('#jouranlUl').empty();

	 $.ajax({
		 url : "${contextPath}/analysis/home/findJournalListAjax.do",
		 type: 'POST',
		 dataType : 'json',
		 data : { "searchDept":$('#coreDept').val(), 'gubun':'SCI', 'rownum':'20' },
		 success : function(data, textStatus, jqXHR){
			 var j = 0;
			 for(var i=0; i < data.length; i++){
				 if(j > 7) break;
				 var title = data[i].title;
				 var noArts = data[i].artsCo == null ? '' : data[i].artsCo;

				 var $li = $('<li></li>');
				 var $div = $("<div style='width:100%; overflow: hidden; text-overflow:ellipsis; white-space:nowrap;'></div>")
				 $div.append($('<a href="#" style="font-size: 8pt; overflow: hidden; text-overflow:ellipsis; white-space:nowrap;">'+title+'</a>'));
				 $li.append($div);
				 $li.append($('<span><em>'+noArts+'</em></span>'));
				 $('#jouranlUl').append($li);
				 j++;

			 }
			 //$('#list_title').text('Publication ('+year+')');
			//alert(data[0].ESUBJECT);
		 }
	 });
 }

 function changeSubjectDept(){
	 $.ajax({
		 url : "${contextPath}/analysis/home/findDeptSubjectAjax.do",
		 type: 'POST',
		 dataType : 'json',
		 data : { "searchDept":$('#subjectDept').val(), 'gubun':'SCI', 'rownum':'20' },
		 success : function(data, textStatus, jqXHR){
			 //console.log(data.chartXml);
			 chart_ChartId3.setDataXML(data.chartXml);
		 }
	 });
 }

 function searchDeptJcr(){
	 $('#deptSubjectJcrTbl > tbody').empty();

	 $.ajax({
		 url : "${contextPath}/home/getDeptJcrHighAjax.do",
		 type: 'POST',
		 dataType : 'json',
		 data : { "dept_categ":$('#dept_categ').val(),
			 	  "mask_year": '${mask_year}'
			    },
		 success : function(data, textStatus, jqXHR){
			 var j = 1;
			 for(var i=0; i < data.length; i++){
				 if(j > 10) break;
				 var title = data[i].TITLE;
				 var issn = data[i].ISSN == null ? '' : data[i].ISSN;
			     var impact = data[i].IMPACT == 'False' ? '-' : data[i].IMPACT;

				 var $tr = $('<tr style="height:25px;"></tr>');
				 $tr.append($('<td align="center">'+j+'</td>'));
				 var $td = $('<td class="link_td" style="font-size: 8pt;width:65%; overflow: hidden; text-overflow:ellipsis; white-space:nowrap;" title="'+title+'">'+title+'</td>');
				 $tr.append($td);
				 $tr.append($('<td style="text-align: center;font-size: 8pt;">'+issn+'</td>'));
				 $tr.append($('<td style="text-align: center;font-size: 8pt;">'+impact+'</td>'));

				 $('#deptSubjectJcrTbl > tbody').append($tr);
				 j++;

			 }
			 //$('#list_title').text('Publication ('+year+')');
			//alert(data[0].ESUBJECT);
		 }
	 });
 }

 function changeCoauthorDepr(){
	 $.ajax({
		 type:"POST",
		 url : "${contextPath}/home/getCoauthorChartAjax.do",
		 dataType : 'text',
		 data : { "deptKor":$('#coauthorDept').val(), 'gubun':'SCI' },
		 success : function(data, textStatus, jqXHR){
			 var chartId = "ChartId3";
			 updateChartXML(chartId, data);
			 var preVars = $('#'+chartId).attr('flashvars').replace(/(.*dataXML=).*/, '$1');
			 $('#'+chartId).attr('flashvars', preVars+data);

		 }
	 });
 }

</script>
</head>
<body>
	<h3><spring:message code="menu.asrms.about.overview"/></h3>
	<div class="help_text mgb_30"><spring:message code="asrms.aboutsci.overview.desc"/></div>

	<div class="main_contents_box mgb_30">
		<div class="left_contents">
			<h3 class="circle_h3"><spring:message code="menu.asrms.about.overview.scilatest"/></h3>
			<a href="#" onclick="javascript:$('#topFrm').attr('action','${contextPath}/analysis/home/latestArticles.do?gubun=SCI').submit();" class="more_plus">more</a>
			<div class="main_list_box">
				<ul id="lastedUl">
				<c:if test="${fn:length(sciLastedArtList) > 0}">
					<c:forEach items="${sciLastedArtList}" var="item" varStatus="status" begin="0" end="4">
					<li>
						<c:set var="sciLink" value=""/>
						<c:if test="${not empty item.doi}"><c:set var="sciLink" value="http://dx.doi.org/${item.doi}"/></c:if>
						<c:if test="${empty item.doi and not empty item.url}"><c:set var="sciLink" value="${item.url}"/></c:if>
						<c:if test="${empty item.doi and empty item.url and not empty item.idSci}"><c:set var="sciLink" value="${item.wosSourceUrl}"/></c:if>
						<c:if test="${empty item.doi and empty item.url and empty item.idSci}"><c:set var="sciLink" value=""/></c:if>
						<c:if test="${not empty sciLink}">
						<a href="${sciLink}" target="_blank" style="font-size: 8.5pt;text-overflow:ellipsis;overflow: hidden;white-space:nowrap;">${item.orgLangPprNm}</a>
						</c:if>
						<c:if test="${empty sciLink}">
						<a href="javascript:dhtmlx.alert('링크가 존재하지않습니다.');" style="font-size: 8.5pt;text-overflow:ellipsis;overflow: hidden;white-space:nowrap;">${item.orgLangPprNm}</a>
						</c:if>
						<span>${item.authors } &nbsp; ( ${item.pblcPlcNm},&nbsp;v.${item.volume},&nbsp;no.${item.issue},&nbsp;pp.${item.sttPage}~${item.endPage},&nbsp;<ui:dateformat value="${item.pblcYm}" pattern="yyyy.MM.dd" /> )</span>
					</li>
					</c:forEach>
				</c:if>
				</ul>
			</div>
		</div>
		<div class="right_contents">
			<h3 class="circle_h3"><spring:message code="menu.asrms.about.overview.kcilatest"/></h3>
			<a href="#" onclick="javascript:$('#topFrm').attr('action','${contextPath}/analysis/home/latestArticles.do?gubun=KCI').submit();" class="more_plus">more</a>
			<div class="main_list_box">
				<ul id="lastedUl">
				<c:if test="${fn:length(kciLastedArtList) > 0}">
					<c:forEach items="${kciLastedArtList}" var="item" varStatus="status" begin="0" end="4">
					<li>
						<c:set var="kciLink" value=""/>
						<c:if test="${not empty item.idKci}"><c:set var="kciLink" value="${sysConf['kci.search.view.url']}?sereArticleSearchBean.artiId=${item.idKci}"/></c:if>
						<c:if test="${empty item.idKci and not empty item.doi}"><c:set var="kciLink" value="http://dx.doi.org/${item.doi}"/></c:if>
						<c:if test="${empty item.idKci and empty item.doi}"><c:set var="kciLink" value="${item.url}"/></c:if>
						<c:if test="${empty item.idKci and empty item.doi and empty item.url}"><c:set var="kciLink" value="javascript:void(0);"/></c:if>
						<c:if test="${not empty kciLink}">
						<a href="${kciLink}" target="_blank" style="font-size: 8.5pt;text-overflow:ellipsis;overflow: hidden;white-space:nowrap;">${item.orgLangPprNm}</a>
						</c:if>
						<c:if test="${empty kciLink}">
						<a href="javascript:dhtmlx.alert('링크가 존재하지않습니다.');" style="font-size: 8.5pt;text-overflow:ellipsis;overflow: hidden;white-space:nowrap;">${item.orgLangPprNm}</a>
						</c:if>


						<span>${item.authors } &nbsp; ( ${item.pblcPlcNm},&nbsp;v.${item.volume},&nbsp;no.${item.issue},&nbsp;pp.${item.sttPage}~${item.endPage},&nbsp;<ui:dateformat value="${item.pblcYm}" pattern="yyyy.MM.dd" /> )</span>
					</li>
					</c:forEach>
				</c:if>
				</ul>
			</div>
		</div>
	</div>
	<div class="main_contents_box">
		<div class="left_contents">
			<h3 class="circle_h3"><spring:message code="menu.asrms.about.overview.scitrend"/></h3>
			<a href="#" onclick="javascript:$('#topFrm').attr('action','${contextPath}/analysis/home/publicationSCI.do?gubun=SCI').submit();" class="more_plus">more</a>
			<div class="graph_box">
				<fc:render chartId="ChartId1" swfFilename="MSLine" width="100%" height="288" debugMode="false" registerWithJS="false"
					dataFormat="xml" xmlData="${chartXML}" renderer="javascript" windowMode="transparent" />
			</div>
		</div>
		<div class="right_contents">
			<h3 class="circle_h3"><spring:message code="menu.asrms.about.overview.kcitrend"/></h3>
			<a href="#" onclick="javascript:$('#topFrm').attr('action','${contextPath}/analysis/home/publicationSCI.do?gubun=KCI').submit();" class="more_plus">more</a>
			<div class="graph_box">
				<fc:render chartId="ChartId2" swfFilename="MSLine" width="100%" height="288" debugMode="false" registerWithJS="false"
					dataFormat="xml" xmlData="${chartXML2}" renderer="javascript" windowMode="transparent" />
			</div>
		</div>
	</div>
	</div>
<!--  file download target frame -->
	<iframe id="filefrm" name="filefrm" style="display: none;"></iframe>
</body>
</html>
