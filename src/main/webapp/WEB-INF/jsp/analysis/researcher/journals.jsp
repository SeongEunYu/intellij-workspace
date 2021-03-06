<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title><spring:message code="menu.asrms.rsch.journal"/></title>
	<script>
		function myFN(objRtn){
			if (objRtn.statusCode=="1"){
				saveExcel(objRtn.fileName);
				//alert("The chart was successfully saved on server. The file can be accessed from " + objRtn.fileName);
			}else{
				alert("The chart could not be saved on server. There was an error. Description : " + objRtn.statusMessage);
			}
		}


		$(document).ready(function(){
			journalsAjax();
			setTimeout(function(){
				bindModalLink();
			}, 1000);
		});

		function journalsAjax(){
			if(!validateRange()){errorMsg(this); return false;}

			$.ajax({
				url:"<c:url value="/analysis/researcher/journalsAjax.do"/>",
				dataType: "json",
				data: $('#frm').serialize(),
				method: "POST",
				beforeLoad: $('.wrap-loading').css('display', '')

			}).done(function(data){

				if(FusionCharts('ChartId1')) {
					FusionCharts('ChartId1').dispose();
					$('#chartdiv1').disposeFusionCharts().empty();
				}

				new FusionCharts({
					id:'ChartId1',
					type:'StackedBar2D',
					renderAt:'chartdiv1',
					width:'100%',
					height:'600',
					dataFormat:'xml',
					dataSource:data.chartXML.replace(/&/g,'&amp;')
				}).render();

				var $tbody = "";
				for(var i=0; i<data.journalList.length; i++){
					var item = data.journalList[i];

					var $tr = (i%2 == 0 ? '<tr style="height:17px;">' : i%2 == 1 ? '<tr style="height:17px;" class="par">' :'');
					$tr += '<td style="font-size: 10pt;" align="center" width="40">'+(i+1)+'</td>';
					$tr += '<td class="link_td" style="font-size: 10pt;">'+item.title+'</td>';
					$tr += '<td style="text-align: center;">'+item.issnNo+'</td>';
					$tr += '<td style="text-align: center;color:blue;"><a style="cursor:pointer;" onclick="chartClick(\'all;'+item.issnNo+'\');">'+item.artsCo+'</a></td>';
					$tr += '<td style="text-align: center;">'+(item.scie == '1' ? '○' : '-')+'</td>';
					$tr += '<td style="text-align: center;">'+(item.sci == '1' ? '○' : '-')+'</td>';
					$tr += '<td style="text-align: center;">'+(item.ssci == '1' ? '○' : '-')+'</td>';
					$tr += '<td style="text-align: center;">'+(item.ahci == '1' ? '○' : '-')+'</td>';
					$tr += '<td style="text-align: center;">'+(item.scopus == '1' ? '○' : '-')+'</td>';
					$tr += '<td style="text-align: center;">'+(item.kci == '1' ? '○' : '-')+'</td>';
					$tr += "</tr>";
					$tbody += $tr;
				}

				if(data.journalList.length == 0){
					var $tr = '<tr style="background-color: #ffffff;" height="17px"><td style="font-size: 10pt;" align="center" colspan="99"><img src="${contextPath}/images/layout/ico_info.png" />There are no journals.</td></tr>';
					$tbody += $tr;
				}

				$("#publicationsTbl tbody").html($tbody);

				$('#fromYear').data('prev', $('#fromYear').val());
				$('#toYear').data('prev', $('#toYear').val());

				$('.wrap-loading').css('display', 'none');
			});
		}

		function exportExcel(){

			var chartObject = getChartFromId('ChartId1');
			if( chartObject.hasRendered() ) chartObject.exportChart( { exportFormat : 'png'} );
		}
		function saveExcel(fileName){

			var div = $('<div></div>');
			var table = $('<table></table>');
			//append document title
			var pageTitle = $('<tr><td style="text-align:center;" colspan="5"><h1><p>Researcher(${item.korNm}) - '+$('.page_title').html()+'</p></h1></td></tr>');
			//append chart image
			var chartTr = $('<tr><td><img src="'+fileName+'" height="350" /></td></tr>');
			var dataTbl = $('<tr><td><h1>Journal List</h1></td></tr><tr><td>'+$('#publicationsTbl').clone().wrapAll('<div/>').parent().html().replace(/<(\/a|a)([^>]*)>/gi,"")+'</td></tr>');
			table.append(pageTitle)
					.append(chartTr)
					.append(dataTbl);
			div.append(table);
			$('#tableHTML').val(div.html());
			var excelFileName = "Popular_Published_Journals_"+$('#gubun').val() + "_from_" + $('#fromYear').val() +"_to_" + $('#toYear').val() + ".xls";
			$('#fileName').val(excelFileName);
			exportLog($('#frm'), excelFileName + "|" +  fileName);
			$('#excelFrm').submit();

		}

		function chartClick(args){

			var param = args.split(";");
			var isCited = param[0];
			var issnNo = param[1];

			$('#artListTbl').empty();
			//loading publication list of year by ajax
			var userId = $('#frm > input[name="userId"]').val();
			$.ajax({
				url : "${contextPath}/analysis/researcher/findArticleListByUserIdAjax.do",
				dataType : 'json',
				data : { "userId": userId,
					"fromYear": $('#fromYear').val(),
					"toYear": $('#toYear').val(),
					"gubun" : $('#gubun').val(),
					"issnNo": issnNo,
					"isCited" : isCited,
					"topNm" : '${parameter.topNm}'
				},
				success : function(data, textStatus, jqXHR){

					var $thead = $('<thead><tr><th><span>NO</span></th><th><span>Article</span></th><th><span>Citation</span></th><tr></thead>');
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
						var content = '<div>&nbsp;/ '+authors + '&nbsp;('+magazine+'&nbsp;'+vol+',&nbsp;'+no+',&nbsp; pp.'+strpage+'~'+endpage+',&nbsp;'+issueDate+')</div>';
						$td.append(content);
						$tr.append($td);
						var citedTd = $('<td style="text-align: center;">'+cited+'</td>');
						$tr.append(citedTd);
						$tbody.append($tr);
					}
					$('#artListTbl').append($tbody);
					var title = magazine + " ( "+data.length+" )";
					$('.popup_header > h3 ').html(title);

					$("#dialogBtn").click();
				}
			}).done(function(){});


		}

	</script>
</head>
<body>
<h3 class="page_title"><spring:message code="menu.asrms.rsch.journal.page"/></h3>
<div class="help_text mgb_30"><spring:message code="asrms.researcher.frequented.journals.desc"/></div>

<form id="frm" name="frm">
	<input type="hidden" id="topNm" name="topNm" value="<c:out value="${topNm}"/>"/>
	<input type="hidden" name="userId" id="userId" value="<c:out value="${parameter.userId}"/>"/>
	<input type="hidden" name="mode" id="mode" value="<c:out value="${parameter.mode}"/>"/>
	<input type="hidden" name="srchUserId" id="srchUserId" value="<c:out value="${parameter.srchUserId}"/>"/>
	<input type="hidden" name="srchUserPhotoUrl" id="srchUserPhotoUrl" value="<c:out value="${parameter.srchUserPhotoUrl}"/>"/>

	<div class="top_option_box">
		<div class="to_inner">
			<span><spring:message code="asrms.researcher.publications.classification" /></span>
			<em>
				<select name="gubun" id="gubun">
					<option value="SCI">SCI</option>
					<option value="SCOPUS">SCOPUS</option>
					<option value="KCI">KCI</option>
				</select>
			</em>
			<span><spring:message code="asrms.researcher.publications.yearrange" /></span>
			<em>
				<select name="fromYear" id="fromYear">
					<c:forEach var="yl" items="${pubYearList}" varStatus="idx" end="50">
						<c:choose>
							<c:when test="${fn:length(pubYearList) > 5}">
								<option value="${yl.pubYear }" ${idx.index == 5 ? 'selected="selected"' : '' }>${yl.pubYear }</option>
							</c:when>
							<c:otherwise>
								<option value="${yl.pubYear }" ${idx.last == true? 'selected="selected"' : '' }>${yl.pubYear }</option>
							</c:otherwise>
						</c:choose>
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
		</div>

		<p class="ts_bt_box">
			<a href="javascript:journalsAjax();" class="to_search_bt"><span>Search</span></a>
		</p>
	</div>

	<h3 class="circle_h3">Chart</h3>
	<div id="chartdiv1" class="chart_box mgb_10"></div>

	<p class="bt_box mgb_10"><a href="#" onclick="exportExcel();" class="black_bt"><em class="export_icon">Export</em></a></p>

	<h3 class="circle_h3">Journal List</h3>
	<table width="100%" id="publicationsTbl" class="list_tbl mgb_20">
		<colgroup>
			<col style="width: 5%;"/>
			<col style="width: 38%;"/>
			<col style="width: 13%"/>
			<col style="width: 10%"/>
			<col style="width: 7%"/>
			<col style="width: 9%"/>
			<col style="width: 5%"/>
			<col style="width: 7%"/>
			<col style="width: 5%"/>
		</colgroup>
		<thead>
		<tr style="text-align: center;">
			<th><span>NO</span></th>
			<th><span>TITLE</span></th>
			<th><span>ISSN</span></th>
			<th><span>NO. of<br/>articles </span></th>
			<th><span>SCIE</span></th>
			<th><span>SCI</span></th>
			<th style="padding: 0;">SSCI</th>
			<th><span>AHCI</span></th>
			<th><span>SCOPUS</span></th>
			<th><span>KCI</span></th>
		</tr>
		</thead>
		<tbody></tbody>
	</table>
	</div>
</form>

<form id="excelFrm" method="post" action="${contextPath}/jsp/excelExport.jsp">
	<input type="hidden" id="tableHTML" name="tableHTML" value="" />
	<input type="hidden" id="fileName" name="fileName" value="journals.xls" />
	<!--
    <input type="button" onclick="gotoExcel('tableData', 'tableHTML');" value="Export these results" />
     -->
</form>

<a id="dialogBtn" href="#dialog" class="modalLink"></a>
<div id="dialog" class="popup_box modal modal_layer" style="display: none;">
	<div class="popup_header">
		<h3></h3>
		<a href="javascript:void(0);" class="close_bt closeBtn">닫기</a>
	</div>
	<div class="popup_inner">
		<div class="popup_scroll">
			<table width="100%" id="artListTbl" class="list_tbl mgb_20"></table>
		</div>
	</div>
</div>
</body>
</html>
