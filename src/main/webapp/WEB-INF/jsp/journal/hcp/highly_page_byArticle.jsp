<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="../../pageInit.jsp" %>
<style type="text/css">
div.gridbox table.obj td {line-height: 150%;}
</style>
<script type="text/javascript" src="${contextPath}/js/jquery/jquery.filedownload.js"></script>
<script type="text/javascript" src="${contextPath}/js/mainLayout.js"></script>
<script type="text/javascript">
var dhxLayout, myGrid, t;
$(document).ready(function(){

    $("#extractionDate").val("${extractionDate}");

	setMainLayoutHeight($('#mainLayout'));
	if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
	else  window.addEventListener("resize",resizeLayout, false);
	//set layout
	dhxLayout = new dhtmlXLayoutObject("mainLayout","1C");
	dhxLayout.cells("a").hideHeader();
	dhxLayout.setSizes(false);
	//attach myGrid
	myGrid = dhxLayout.cells("a").attachGrid();
	myGrid.setImagePath("${dhtmlXImagePath}");
	myGrid.setHeader("NO,ArticleId,Accession Number,Article Name,TC,Publication Date",null,grid_head_center_bold);
	myGrid.setColumnIds("no,id,idSci,orgLangPprNm,tc,pubDate");
	myGrid.setInitWidths("50,120,120,*,50,150");
	myGrid.setColAlign("center,center,center,center,center,center");
	myGrid.setColTypes("ro,ro,ro,ro,ro,ro");
	myGrid.setColSorting("int,int,na,str,int,int");
	myGrid.enableMultiline(true);
	myGrid.enableColSpan(true);
	myGrid.attachEvent("onXLS", doBeforeGridLoad);
	myGrid.attachEvent("onXLE", doOnGridLoaded);
	myGrid.attachEvent("onRowSelect", myGrid_onRowSelect);
	myGrid.init();
	myGrid_load();

});
function myGrid_load(){
	var url = getGridRequestURL();
	myGrid.clearAndLoad(url, function(){});
}
function getGridRequestURL(){
	var url = "${contextPath}/${preUrl}/hcp/findHcpArticleGrid.do";
	url = comAppendQueryString(url,"extractionDate", $("#extractionDate").val());
	url = comAppendQueryString(url,"exceptAt",	$("#exceptAt").prop("checked"));
	url = comAppendQueryString(url,"field",	"${field}");
	//url += "&"  + $('#formArea').serialize();
	return url;
}

function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){ setMainLayoutHeight($('#mainLayout')); dhxLayout.setSizes(false); },200);}
function doOnGridLoaded(){setTimeout(function() {dhxLayout.cells("a").progressOff();}, 100);}
function doBeforeGridLoad(){dhxLayout.cells("a").progressOn();}

function myGrid_onRowSelect(rowID,celInd){
	var wWidth = 1024;
	var wHeight = 822;
	var leftPos = (screenWidth - wWidth)/2;
	var topPos = (screenHeight - wHeight)/2;
	if(rowID == '0') return;
	var str = rowID.split('_');
	var mappingPopup = window.open('about:blank', 'articlePopup', 'width='+wWidth+'px,height='+wHeight+'px,top='+topPos+',left='+leftPos+' location=no,scrollbars=yes,resizable=yes');
	var popFrm = $('#popFrm');
	popFrm.empty();
	popFrm.append($('<input type="hidden" name="articleId" value="'+str[1]+'"/>'));
	popFrm.attr('action', '${contextPath}/article/articlePopup.do');
	popFrm.attr('target', 'articlePopup');
	popFrm.attr('method', 'POST');
	popFrm.submit();
	mappingPopup.focus();
}

function toExcel(){
	var url = "${contextPath}/${preUrl}/article/excelExport.do?"+$('#formArea').serialize();
	var expAnchor = $('<a class="exp_anchor" href="'+url+'"></a>');
	$("body").append(expAnchor);
	$('a.exp_anchor').bind('click',function(){
		doBeforeGridLoad();
		$.fileDownload($(this).prop('href'),{
			successCallback: function (url) {
				doOnGridLoaded();
				$('a.exp_anchor').remove();
			},
			failCallback: function (responseHtml, url) {
				doOnGridLoaded();
				$('a.exp_anchor').remove();
            }
		});
	}).trigger('click');
}

function goField(){
    $(location).attr("href","${contextPath}/${preUrl}/hcp/hcpFieldPage.do?extractionDate="+$("#extractionDate").val());
}
</script>
</head>
<body>
	<div class="title_box">
		<h3><a href="javascript:goField();" style="color: blue;"><spring:message code='menu.hcp'/></a><span style="font-size: 15pt">(${fn:replace(fn:trim(field),'amp',' & ')})</span></h3>
	</div>
	<div class="contents_box">
		<!-- START 테이블 1 -->
		<form id="formArea" >
			<table class="view_tbl mgb_10" >
				<colgroup>
					<col style="width: 15%;">
					<col>
					<col style="width: 50px;">
				</colgroup>
				<tbody>
				<tr>
					<th>Extraction date</th>
					<td>
						<select id="extractionDate" onchange="myGrid_load();">
							<c:forEach items="${dateList}" var="date">
								<option value="${date.extractionDate}:${date.periodFrom}:${date.periodTo}">추출날짜:${date.extractionDate} (대상날짜:${date.periodFrom} ~ ${date.periodTo})</option>
							</c:forEach>
						</select>

						<td rowspan="2" class="option_search_td" onclick="javascript:myGrid_load();"><em>search</em></td>
					</td>
				</tr>
				<c:if test="${sessionScope.auth.adminDvsCd eq 'M'}">
					<tr>
						<th>Display 제외</th>
						<td>
							<input type="checkbox" value = "N" id="exceptAt" onclick="javascript:myGrid_load();"/>
						</td>
					</tr>
				</c:if>
				</tbody>
			</table>
		</form>
		<!-- layout (grid,paging)  -->
		<div id="mainLayout" style="position: relative; width: 100%;height: 100%;"></div>
 	</div>
</body>
</html>