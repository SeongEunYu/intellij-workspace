<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><spring:message code="menu.asrms.rsch.profile"/></title>
<link rel=stylesheet type=text/css href="${contextPath}/css/jquery/jqcloud.min.css"/>
<script type="text/javascript" src="${contextPath}/js/jquery/jqcloud.min.js"></script>
<script type="text/javascript">
  $(document).ready(function() {
	  var wordList = $('#wordListText').html();
	  //console.log(wl);
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

	  $("#tagCloud").jQCloud(tag_list,{afterCloudRender:function(){bindModalLink();}});
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

			     var $tr = $('<tr style="height:17px;"></tr>');
				 $tr.append($('<td style="font-size: 10pt;" align="center" width="40">'+(i+1)+'</td>'));
				 var $td = $('<td class="link_td" style="font: normal 12px \'Malgun Gothic\';"></td>').append($('<div class="style_12pt"><a href="javascript:popArticle(\''+seqno+'\')"><b>'+esubject+'</b></a></div>'));
				 //var content = '<b>Journal</b>: '+magazine+' [v.'+vol+',&nbsp;no.'+no+',&nbsp; pp.'+strpage+'~'+endpage+',&nbsp;'+issueDate+']';
				 var content = '<span>'+authors + '&nbsp;('+magazine+'&nbsp;'+vol+',&nbsp;'+no+',&nbsp; pp.'+strpage+'~'+endpage+',&nbsp;'+issueDate+')</span>';
				 var keyword = '<div>&nbsp;'+data[i].keyword.replace(";",",")+'</div>';
				 $td.append(content);
				 $td.append(keyword);
				 $tr.append($td);
				 var citedTd = $('<td style="text-align: center;">'+sciTc+'</td>');
				 $tr.append(citedTd);
				 $tbody.append($tr);
			 }
			 $('#artListTbl').append($tbody);
			 var title = word + "( "+data.length+" )";
			 $('.popup_header h3 ').html(title);

		 }
	 }).done(function(){});

 }

</script>
</head>
<body>
	<!-- content -->
	<form id="frm" name="frm" action="${contextPath}/analysis/researcher/profile.do" method="post">
	<input type="hidden" id="topNm" name="topNm" value="<c:out value="${topNm}"/>"/>
	<input type="hidden" name="userId" id="userId" value="<c:out value="${parameter.userId}"/>"/>
	<input type="hidden" name="mode" id="mode" value="<c:out value="${parameter.mode}"/>"/>
	<input type="hidden" name="srchUserId" id="srchUserId" value="<c:out value="${parameter.srchUserId}"/>"/>
	<input type="hidden" name="srchUserPhotoUrl" id="srchUserPhotoUrl" value="<c:out value="${parameter.srchUserPhotoUrl}"/>"/>

	<h3><spring:message code="menu.asrms.rsch.profile"/></h3>

	<h3 class="circle_h3">Information</h3>
	<table width="100%" id="publicationsTbl" class="view_tbl mgb_40">
		<colgroup>
			<col style="width: 15%"/>
			<col style="width: 19%"/>
			<col style="width: 15%"/>
			<col style="width: 20%"/>
			<col style="width: 15%"/>
			<col style="width: 23%"/>
		</colgroup>
		<tr>
			<th><span>Name<br>(Korean)</span></th>
			<td style="height: 10px;">${item.korNm }</td>
			<th><span>Name<br>(English)</span></th>
			<td  style="height: 10px;">
				${item.lastName }, ${item.firstName }
				<c:if test="${not empty item.abbrFirstName and item.firstName ne item.abbrFirstName }">
				[&nbsp;${item.abbrLastName }. ${item.abbrFirstName}&nbsp;]
				</c:if>
			</td>
			<th><span>Gender</span></th>
			<td class="br_none">${item.sexDvsNm }</td>
		</tr>
		<tr>
			<th><span>ID<br>(Emp No.)</span></th>
			<td>${item.userId }</td>
			<th><span>Department</span></th>
			<td>${item.deptKor }</td>
			<th><span>Status</span></th>
			<td class="br_none">${item.hldofYnNm }</td>
		</tr>
		<tr>
			<td colspan="6" class="tbl_block"></td>
		</tr>
	</table>

	<h3 class="cloud_h3">Keyword Cloud</h3>
	<div class="help_text mgb_30"><spring:message code="asrms.researcher.keyword.cloud.desc"/></div>

	<!--START sub_content_wrapper-->
	<div style="width: 100%">
			<div class="mainItem_boxBgT" style="width: 735px">
				<div class="l"></div>
				<div class="c" style="width: 723px;"></div>
				<div class="r"></div>
			</div>
			<div class="mainItem_boxBgC" style="width: 733px;">
				<div id="tagCloud" style="width:100%; height: 350px;" class="jqcloud"></div>
			</div>
			<div class="mainItem_boxBgB" style="width: 735px">
				<div class="l"></div>
				<div class="c" style="width: 723px;"></div>
				<div class="r"></div>
			</div>
	</div>
	<!--END sub_content_wrapper-->
	</form>
<div id="dialog" class="popup_box modal modal_layer"  style="display: none;">
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
