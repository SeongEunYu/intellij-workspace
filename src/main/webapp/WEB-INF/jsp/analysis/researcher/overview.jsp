<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><spring:message code="menu.asrms.clg.overview"/></title>
<LINK rel=stylesheet type=text/css href="${contextPath}/css/jquery/jqcloud.min.css">
<LINK rel=stylesheet type=text/css href="${contextPath}/css/star_rating.css">
<script type="text/javascript" src="${contextPath}/js/jquery/jqcloud.min.js"></script>
<script type="text/javascript">

  $(document).ready(function() {
	  var wordList = $('#wordListText').html();
	  var wl = eval('('+wordList+')');

	  var tag_list = new Array();
	  for(var i=0 ; i < wl.length; i++)
	  {
		 tag_list.push({
			 text:wl[i].text,
			 weight:wl[i].weight,
			 link:{'href':'#dialog','class':'modalLink'},
			 handlers:{click:function(){ searchArts($(this).text());}}
		 });
	  }
	  $("#tagCloud").jQCloud(tag_list,{autoResize: true ,afterCloudRender:function(){bindModalLink();}});
  });

 function searchArts(word){

	 $('#artListTbl').empty();
	 var userId = $('#frm > input[name="userId"]').val();
	 $.ajax({
		 url : "${contextPath}/analysis/researcher/findArticleListByKeywordAjax.do",
		 dataType : 'json',
		 data : { "userId": userId,
			      "keyword": word,
			      "topNm":"researcher"
			     },
		 success : function(data, textStatus, jqXHR){

			 var $thead = $('<colgroup><col style="width:10%"/><col style="width:80%"/><col style="width:10%"/></colgroup><thead><tr><th><span>NO</span></th><th><span>Article</span></th><th><span>Citation</span></th><tr></thead>');
			 $('#artListTbl').append($thead);
			 var $tbody = $('<tbody></tbody>');
			 for(var i=0; i < data.length; i++){

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
			     var impctFctr = data[i].impctFctr == null ? '' : data[i].impctFctr;
			     var sciTc = data[i].tc == null ? '' : data[i].tc;
			     var scpTc = data[i].scpTc == null ? '' : data[i].scpTc;
			     var kciTc = data[i].kciTc == null ? '' : data[i].kciTc;

				 var cited = "";
				 if($('#gubun').val() == 'SCI') cited = sciTc;
				 else if($('#gubun').val() == 'SCOPUS') cited = scpTc;
				 else if($('#gubun').val() == 'KCI') cited = kciTc;

			     var $tr = $('<tr style="height:17px;"></tr>');
				 $tr.append($('<td style="font-size: 10pt;" align="center" width="40">'+(i+1)+'</td>'));
				 var $td = $('<td class="link_td" style="font: normal 12px \'Malgun Gothic\';"></td>').append($('<div class="style_12pt"><a href="javascript:popArticle(\''+seqno+'\')"><b>'+esubject+'</b></a></div>'));
				 //var content = '<b>Journal</b>: '+magazine+' [v.'+vol+',&nbsp;no.'+no+',&nbsp; pp.'+strpage+'~'+endpage+',&nbsp;'+issueDate+']';
				 var content = '<span>'+authors + '&nbsp;( v.'+vol+',&nbsp;no.'+no+',&nbsp; pp.'+strpage+'~'+endpage+',&nbsp;'+issueDate+')</span>';
				 var keyword = '<div>&nbsp;'+data[i].keyword.replace(";",",")+'</div>';
				 $td.append(content);
				 $td.append(keyword);
				 $tr.append($td);
				 var citedTd = $('<td style="text-align: center;">'+cited+'</td>');
				 $tr.append(citedTd);
				 $tbody.append($tr);
			 }
			 $('#artListTbl').append($tbody);
			 var title = word + "( "+data.length+" )";
			 $('.popup_header > h3 ').html(title);
				/*
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
				*/

/*
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
 */
			//alert(data[0].ESUBJECT);
		 }
	 }).done(function(){});

 }

</script>
</head>
<body>
	<h3><spring:message code="menu.asrms.rsch.overview"/></h3>
	<div class="help_text mgb_30"><spring:message code="asrms.researcher.overview.desc"/></div>

	<!-- content -->
	<form id="frm" name="frm" action="${contextPath}/researcher/overview.do" method="post">
	<input type="hidden" id="topNm" name="topNm" value="<c:out value="${topNm}"/>"/>
	<input type="hidden" name="userId" id="userId" value="<c:out value="${parameter.userId}"/>"/>
	<input type="hidden" name="mode" id="mode" value="<c:out value="${parameter.mode}"/>"/>
	<input type="hidden" name="srchUserId" id="srchUserId" value="<c:out value="${parameter.srchUserId}"/>"/>
	<input type="hidden" name="srchUserPhotoUrl" id="srchUserPhotoUrl" value="<c:out value="${parameter.srchUserPhotoUrl}"/>"/>


	<div class="main_contents_box mgb_30">
		<div class="left_contents">
			<h3 class="circle_h3">Keyword Cloud</h3>
			<a href="#" onclick="javascript:$('#topFrm').attr('action','${contextPath}/analysis/researcher/profile.do').submit();" class="more_plus">더보기</a>
			<div class="graph_box">
				<div id="tagCloud" style="width:100%; height: 288px;" class="jqcloud"></div>
			</div>
		</div>
		<div class="right_contents">
			<h3 class="circle_h3"><spring:message code="menu.asrms.rsch.artco"/></h3>
			<a href="#" onclick="javascript:$('#topFrm').attr('action','${contextPath}/analysis/researcher/publication.do').submit();" class="more_plus">더보기</a>
			<div class="graph_box">
				<fc:render chartId="ChartId1" swfFilename="MSLine" width="100%" height="288" debugMode="false" registerWithJS="false"
					dataFormat="xml" xmlData="${pubChartXML}" renderer="javascript" windowMode="transparent" />
			</div>
		</div>
	</div>
	<div class="main_contents_box  mgb_30">
		<div class="left_contents">
			<h3 class="circle_h3"><spring:message code="menu.asrms.rsch.cited"/></h3>
			<a href="#" onclick="javascript:$('#topFrm').attr('action','${contextPath}/analysis/researcher/trend.do').submit();"  class="more_plus">더보기</a>
			<div class="graph_box">
				<fc:render chartId="ChartId2" swfFilename="StackedColumn2D" width="100%" height="288" debugMode="false" registerWithJS="false"
					dataFormat="xml" xmlData="${trendChartXML}" renderer="javascript" windowMode="transparent" />
			</div>
		</div>
		<div class="right_contents">
			<h3 class="circle_h3"><spring:message code="menu.asrms.rsch.journal"/></h3>
				<a href="#" onclick="javascript:$('#topFrm').attr('action','${contextPath}/analysis/researcher/journals.do').submit();" class="more_plus">more</a>
			<div class="dept_list_box">
				<ul>
					<c:if test="${fn:length(journalList) > 0}">
						<c:forEach items="${journalList}" var="item" varStatus="status" begin="0" end="8">
							<li>
								<div style='width:100%; overflow: hidden; text-overflow:ellipsis; white-space:nowrap;'>
									<a href="#" style="font-size: 9pt; overflow: hidden; text-overflow:ellipsis; white-space:nowrap;">${item.title}</a>
								</div>
								<span><em>${item.artsCo}</em></span>
							</li>
						</c:forEach>
					</c:if>
				</ul>
			</div>
		</div>
	</div>
	</form>
<div id="dialog" class="popup_box modal modal_layer" style="display: none;">
	<div class="popup_header">
		<h3></h3>
		<a href="#" class="close_bt closeBtn">닫기</a>
	</div>
	<div class="popup_inner">
		<div class="popup_scroll">
			<table width="100%" id="artListTbl" class="list_tbl mgb_20"></table>
		</div>
	</div>
</div>
<div style="display: none;"><textarea style="display: none;" id="wordListText">${word_list}</textarea></div>
</body>
</html>
