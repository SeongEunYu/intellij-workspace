<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.argonet.r2rims.util.LanguageUtil"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="cache-Control" content="co-cache" />
<title>Article Detail</title>
<%@include file="../../pageInit.jsp" %>
<link type="text/css" href="${contextPath}/css/layout.css" rel="stylesheet" />
<link type="text/css" href="${contextPath}/js/dhtmlx/skins/${sysConf['dhtmlx.skin']}/dhtmlx.css" rel="stylesheet" />
<LINK rel=stylesheet type=text/css href="${contextPath}/css/jquery/jqcloud.min.css">
<script type="text/javascript" src="${contextPath}/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="${contextPath}/js/jquery/jqcloud.min.js"></script>
<script type="text/javascript" src="${contextPath}/js/jquery/jquery.modal.js"></script>
<script type="text/javascript" src="${contextPath}/js/dhtmlx/dhtmlx.js"></script>
<script type="text/javascript" src="${contextPath}/js/script.js"></script>

<style type="text/css">
.dhxwins_vp_dhx_terrace {overflow: auto;}
.dhxwins_vp_dhx_terrace div.dhxwin_active div.dhx_cell_wins div.dhx_cell_toolbar_def, .dhxwins_vp_dhx_terrace div.dhxwin_inactive div.dhx_cell_wins div.dhx_cell_toolbar_def { padding: 10px 0px 0; }
.dhx_toolbar_dhx_terrace { padding: 0 0px; }
.jqcloud_span_hover_in { font-size: 20px;}
.jqcloud_span_hover_out { font-size: 10px;}
table {font-size: 12px;}
</style>
<script type="text/javascript">
var dhxLayout;
$(document).ready(function() {

	  if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
	  else  window.addEventListener("resize",resizeLayout, false);
	  //set layout
	  dhxLayout = new dhtmlXLayoutObject("mainLayout","1C");
	  dhxLayout.cells("a").hideHeader();
	  dhxLayout.setSizes(false);
	  dhxLayout.cells("a").attachObject('tagCloud');

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

	  if(tag_list.length > 0){doBeforeGridLoad();}

	  //$("#tagCloud").jQCloud(tag_list,{height:290, afterCloudRender:function(){ alert('finish cloud render~'); bindModalLink();}});
	  $("#tagCloud").jQCloud(tag_list,{height:290, afterCloudRender:function(){
		  		$('.jqcloud').find('span').hover(function(){
		  			if( $(this).hasClass('w1')){
		  				$(this).css('font-size','20px');
		  			}
		  		}
		  		,function(){
		  			if( $(this).hasClass('w1')){
		  				$(this).css('font-size','10px');
		  			}
		  		});

		  		bindModalLink();
		  		doOnGridLoaded();
		  	}
	  });
	  $('#wordListText').remove();
});

function searchArts(word){

	 $('#artListTbl').empty();
	 var userId = $('#frm > input[name="userId"]').val();
	 $.ajax({
		 url : "${contextPath}/search/findArticleListByUserIdAndKeywordAjax.do",
		 dataType : 'json',
		 data : { "userId": userId,
			      "keyword": word,
			      "topNm":"researcher"
			     },
		 success : function(data, textStatus, jqXHR){

			 var $thead = $('<colgroup><col style="width:10%"/><col style="width:80%"/></colgroup><thead><tr><th><span>NO</span></th><th><span>Article</span></th><tr></thead>');
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
				 var $td = $('<td class="link_td" style="text-align: left; font: normal 12px \'Malgun Gothic\';"></td>').append($('<div class="style_12pt"><a href="javascript:popArticle(\''+seqno+'\')"><b>'+esubject+'</b></a></div>'));
				 //var content = '<b>Journal</b>: '+magazine+' [v.'+vol+',&nbsp;no.'+no+',&nbsp; pp.'+strpage+'~'+endpage+',&nbsp;'+issueDate+']';
				 var content = '<span>'+authors + '&nbsp;('+magazine+'&nbsp;'+vol+',&nbsp;'+no+',&nbsp; pp.'+strpage+'~'+endpage+',&nbsp;'+issueDate+')</span>';
				 var keyword = '<div>&nbsp;'+data[i].keyword.replace(";",",")+'</div>';
				 $td.append(content);
				 $td.append(keyword);
				 $tr.append($td);
				 //var citedTd = $('<td style="text-align: center;">'+cited+'</td>');
				 //$tr.append(citedTd);
				 $tbody.append($tr);
			 }
			 console.log($tbody);
			 $('#artListTbl').append($tbody);
			 var title = word + "( "+data.length+" )";
			 $('.popup_header h3 ').html(title);
		 }
	 }).done(function(){});

}
function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){dhxLayout.setSizes(false); },10);}
function doOnGridLoaded(){setTimeout(function() {dhxLayout.cells("a").progressOff();}, 100);}
function doBeforeGridLoad(){dhxLayout.cells("a").progressOn();}
</script>
</head>
<body style="background: none;padding-left: 20px;width: 929px;" class="dhxwins_vp_dhx_terrace">
<div id="modal_area" class="overlay" style="display: none;"></div>
<form id="frm" name="frm">
	<input type="hidden" name="userId" id="userId" value="${rsrchr.userId}"/>
</form>
<div class="title_box mgb_30">
	<h3>연구자정보</h3>
</div>
<div class="contents_box" style="width:887px;">
<h2 class="circle_h3">인적사항</h2>
<table class="write_tbl mgb_30">
	<colgroup>
		<col style="width:20%;" />
		<col style="width:55%;" />
		<col style="width:25%" />
	</colgroup>
	<tbody>
		<tr>
			<th>Name</th>
			<td>${fn:escapeXml(rsrchr.korNm)}
				<c:if test="${not empty rsrchr.lastName}">
					( ${rsrchr.lastName }, ${rsrchr.firstName } )
				</c:if>
			</td>
			<td rowspan="8" style="text-align: center;">
				<c:if test="${not empty rsrchr.profPhotoFileId }">
					<img id="thumb" width="180px" height="210px" src="${contextPath}/servlet/image/profile.do?fileid=${rsrchr.profPhotoFileId}" alt="${rsrchr.korNm}"/>
				</c:if>
				<c:if test="${empty rsrchr.profPhotoFileId}">
					<img id="thumb" width="180px" height="210px" src="${contextPath }/images/analysis/common/anonymous_profile.png" alt="anonymous"/><span></span>
				</c:if>
			</td>
		</tr>
		<tr>
			<th>Department</th>
			<td>${fn:escapeXml(rsrchr.deptKor)}</td>
		</tr>
		<tr>
			<th>E-mail</th>
			<td>${rsrchr.emalAddr}</td>
		</tr>
		<tr>
			<th>Office Phone</th>
			<td>${rsrchr.ofcTelno}</td>
		</tr>
		<tr>
			<th>Major</th>
			<td>${rsrchr.spclNm}</td>
		</tr>
		<tr>
			<th>Specific Subject</th>
			<td>${rsrchr.dspclNm}</td>
		</tr>
		<tr>
			<th>Homepage</th>
			<td>
				<c:if test="${not empty rsrchr.homePageAddr}">
				<a href="${rsrchr.homePageAddr}" target="_blank">${rsrchr.homePageAddr}</a>
				</c:if>
			</td>
		</tr>
		<tr>
			<th>ResearcherID Link</th>
			<td>
				<c:if test="${not empty rsrchr.ridWos}">
					<a href="http://www.researcherid.com/rid/${rsrchr.ridWos}" target="_blank">http://www.researcherid.com/rid/${rsrchr.ridWos}</a>
				</c:if>
			</td>
		</tr>
	</tbody>
</table>
<h2 class="circle_h3">Research Area</h2>
<table class="write_tbl mgb_30">
	<colgroup>
		<col style="width:20%;" />
		<col style="width:55%;" />
		<col style="width:25%" />
	</colgroup>
	<tbody>
		<tr>
			<th>Korean</th>
			<td colspan="2">${rsrchr.majorKor1}
				<c:if test="${not empty rsrchr.majorKor2}">, ${rsrchr.majorKor2}</c:if>
				<c:if test="${not empty rsrchr.majorKor3}">, ${rsrchr.majorKor3}</c:if>
			</td>
		</tr>
		<tr>
			<th>English</th>
			<td colspan="2">${rsrchr.majorEng1}
				<c:if test="${not empty rsrchr.majorEng2}">, ${rsrchr.majorEng2}</c:if>
				<c:if test="${not empty rsrchr.majorEng3}">, ${rsrchr.majorEng3}</c:if>
			</td>
		</tr>
	</tbody>
</table>

<h2 class="circle_h3">Article Keyword Cloud</h2>
<div class="keywords_box">
	<div id="mainLayout" style="position: relative; width: 100%; height: 290px;"></div>
	<div id="tagCloud" style="width:100%;" ></div>
</div>
</div>

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