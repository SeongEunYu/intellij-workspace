<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../pageInit.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Article Workbench</title>
<script type="text/javascript" src="${contextPath}/js/mainLayout.js"></script>
<script type="text/javascript">
var dhxLayout, myGrid, t;
$(document).ready(function(){
	if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
	else  window.addEventListener("resize",resizeLayout, false);
	//set layout
	dhxLayout = new dhtmlXLayoutObject("mainLayout","1C");
	dhxLayout.cells("a").hideHeader();
	dhxLayout.setSizes(false);
	//attach myGrid
	myGrid = dhxLayout.cells("a").attachGrid();
	myGrid.setImagePath("${dhtmlXImagePath}");
	myGrid.setHeader("No,외부정보원ID,Other No.,Title,DOCTYPE,저자수,상태,상태코드", null, grid_head_center_bold);
	myGrid.setColumnIds("No,sourcIdntfcNo,dplctSourcIdntfcNo,articleTtl,docType,authrCount,migStatus,migCode");
	myGrid.setInitWidths("40,140,140,*,130,70,80,1");
	myGrid.setColAlign("center,center,center,left,center,center,center,center");
	myGrid.setColTypes("ro,ro,ro,ed,ed,ed,ed,ro");
	myGrid.setColSorting("na,na,na,na,na,na,na,na");
	myGrid.setColumnColor("#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF");
	myGrid.setEditable(false);
	myGrid.attachEvent("onRowSelect",myGrid_onRowSelect);
	myGrid.attachEvent("onBeforeSorting",myGrid_onBeforeSorting);
	myGrid.attachEvent("onXLS", doBeforeGridLoad);
	myGrid.attachEvent("onPaging",changeRowColor);
    myGrid.enablePaging(true,100,10,"pagingArea",true);
	myGrid.setPagingSkin("${dhtmlXPagingSkin}");
	myGrid.enableColSpan(true);
    myGrid.setColumnHidden(myGrid.getColIndexById("migCode"),true);
	myGrid.init();
	myGrid_load();
});

function myGrid_onBeforeSorting(ind,type,direct){
	var url = getGridRequestURL();
	myGrid.clearAndLoad(url+"&orderby="+(myGrid.getColumnId(ind))+"&direct="+direct);
	myGrid.setSortImgState(true,ind,direct);
	return false;
}

function myGrid_onRowSelect(rowID,celInd){

	var wWidth = 1050;
	var wHeight = 752;
	var leftPos = (screenWidth - wWidth)/2;
	var topPos = (screenHeight - wHeight)/2;

	var str = rowID.split('|'); // regular expression 이 아님에 주의할 것
	var sourcIdntfcNo = str[0];
	var articleId = str[1];
	var adresSeq = str[2];
	var mappingPopup = window.open('about:blank', 'mappingPopup', 'width='+wWidth+'px,height='+wHeight+'px,top='+topPos+',left='+leftPos+' location=no,scrollbars=yes,resizable=yes');
	var popFrm = $('#popFrm');
	popFrm.empty();
	popFrm.append($('<input type="hidden" name="sourcIdntfcNo" value="'+sourcIdntfcNo+'"/>'));
	popFrm.append($('<input type="hidden" name="articleId" value="'+articleId+'"/>'));
	popFrm.append($('<input type="hidden" name="adresSeq" value="'+adresSeq+'"/>'));
	popFrm.append($('<input type="hidden" name="sourcDvsnCd" value="${sourcDvsnCd}"/>'));
	popFrm.append($('<input type="hidden" name="gubun" value="ARTICLE"/>'));
	popFrm.append($('<input type="hidden" name="q" value="1"/>'));
	popFrm.attr('action', '${contextPath}/workbench/mappingPopup.do');
	popFrm.attr('target', 'mappingPopup');
	popFrm.attr('method', 'POST');
	popFrm.submit();
	mappingPopup.focus();
}

function myGrid_load(){
	doBeforeGridLoad();
	var url = getGridRequestURL();
	myGrid.clearAndLoad(url, changeRowColor);
}

function getGridRequestURL(){
	var maskPos				=  $(':radio[name="maskPos"]:checked').val();
	var maskHistoryId		= $("#maskHistory option:selected").val();
	var maskArticleTtl		= $('#maskArticleTtl').val();
	var maskUt				= $('#maskUt').val();
	var sourcDvsnCd 		= "${sourcDvsnCd}";
	var url = "${contextPath}/workbench/findArticleList.do?q=wos_add_main";
	url += "&maskHistoryId="+maskHistoryId;
	url += "&maskPos="+maskPos;
	url += "&maskUt="+maskUt;
	url += "&maskArticleTtl="+encodeURIComponent(maskArticleTtl);
	url += "&sourcDvsnCd="+sourcDvsnCd;
	return url;
}

function changeRowColor(){
	var strIndex = (myGrid.currentPage-1) * myGrid.rowsBufferOutSize;
	var endIndex = ((myGrid.currentPage) * myGrid.rowsBufferOutSize)-1;
	endIndex = endIndex<myGrid.getRowsNum() ? endIndex: myGrid.getRowsNum()-1;
	for (var i=strIndex; i<=endIndex; i++){ 		// here i - index of the row in the grid
		var rId = myGrid.getRowId(i); // get row id by its index
		if(typeof rId != 'undefined'){
			var str = rId.split('|'); // regular expression 이 아님에 주의할 것
			gubun = str[2];
			if (gubun=="P"){ myGrid.setRowColor(rId, "EECCCC");	}
			if (gubun=="Y"){ myGrid.setRowColor(rId, "CCEECC"); }
			if (gubun=="E"){ myGrid.setRowColor(rId, "CCCCCC");	}
            if (gubun=="D"){ myGrid.setRowColor(rId, "e0e0eb");	}
		}
	}
	doOnGridLoaded();
}
function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){ dhxLayout.setSizes(false); },200);}
function doOnGridLoaded(){setTimeout(function() {dhxLayout.cells("a").progressOff();}, 100);}
function doBeforeGridLoad(){dhxLayout.cells("a").progressOn();}

</script>
</head>
<body>
	<c:if test="${sourcDvsnCd eq 'WOS'}"><c:set var="pageGubun" value="WOS"/></c:if>
	<c:if test="${sourcDvsnCd eq 'SCP'}"><c:set var="pageGubun" value="SCOPUS"/></c:if>
	<c:if test="${sourcDvsnCd eq 'KCI'}"><c:set var="pageGubun" value="KCI"/></c:if>
	<div class="title_box">
		<h3>
			<c:choose>
				<c:when test="${not empty pageGubun and pageGubun eq 'WOS'}"><spring:message code="menu.wos.identify"/></c:when>
				<c:when test="${not empty pageGubun and pageGubun eq 'SCOPUS'}"><spring:message code="menu.scopus.identify"/></c:when>
				<c:when test="${not empty pageGubun and pageGubun eq 'KCI'}"><spring:message code="menu.kci.identify"/></c:when>
			</c:choose>
		</h3>
	</div>
	<div class="contents_box">
		<form id="srchFrm" name="srchFrm" method="POST">
		<table class="view_tbl mgb_10">
			<colgroup>
				<col style="width:14%"/>
				<col style="width:35%"/>
				<col style="width:14%"/>
				<col />
				<col style="width:50px;"/>
			</colgroup>
			<tbody>
				<tr>
					<th>반입 ID</th>
					<td>
						<select class="select1" style="width:100%;" id="maskHistory" name="maskHistory" onchange="myGrid_load();">
							<option selected='selected' value='ALL'>전체</option>
							<c:if test="${not empty rdHistList }">
								<c:forEach items="${rdHistList}" var="rhl" varStatus="st">
									<fmt:formatDate value="${rhl.regdate}" var="regdate" pattern="yyyy-MM-dd"/>
									<option value='${fn:escapeXml(rhl.id)}' >
										${fn:escapeXml(rhl.id)}:${regdate}:${fn:escapeXml(rhl.title)}
									</option>
								</c:forEach>
							</c:if>
						</select>
					</td>
					<th>작업상태</th>
					<td>
						<span>
							<input type="radio" name="maskPos" id="maskPos1" value="ALL" checked="checked" class="radio" onclick="myGrid_load();">
							<label for="maskPos1" class="radio_label">전체</label>
							
							<input type="radio" name="maskPos" id="maskPos2" value="P" class="radio" onclick="myGrid_load();">
							<label for="maskPos2" class="radio_label">보류</label>
							
							<input type="radio" name="maskPos" id="maskPos3" value="N" class="radio" onclick="myGrid_load();">
							<label for="maskPos3" class="radio_label">미작업</label>
							
							<input type="radio" name="maskPos" id="maskPos4" value="Y" class="radio" onclick="myGrid_load();">
							<label for="maskPos4" class="radio_label">작업완료</label>
							
							<input type="radio" name="maskPos" id="maskPos5" value="E" class="radio" onclick="myGrid_load();">
							<label for="maskPos5" class="radio_label">작업제외</label>

							<input type="radio" name="maskPos" id="maskPos6" value="D" class="radio" onclick="myGrid_load();">
							<label for="maskPos6" class="radio_label">중복제외</label>
						</span>
					</td>
					<td rowspan="2" class="option_search_td" onclick="javascript: myGrid_load();"><em>search</em></td>
				</tr>
				<tr>
					<th>논문번호</th>
					<td class="borderRight">
						<input type="text" size=20 id="maskUt" name="maskUt" style="width:100%;" class="input2" onkeyup="javascript:if(event.keyCode=='13')myGrid_load();">
					</td>
					<th>논문명</th>
					<td class="borderRight">
						<input type="text" size=20 id="maskArticleTtl" name="maskArticleTtl" style="width:100%;" class="input2" onkeyup="javascript:if(event.keyCode=='13')myGrid_load();">
					</td>
				</tr>
				<tr>
				</tr>
			</tbody>
		</table>
		</form>
		<div id="mainLayout" style="position: relative; width: 100%;height: 100%;"></div>
		<script type="text/javascript">setMainLayoutHeight($('#mainLayout'));</script>
		<div id="pagingObj" style="z-index: 1; height: 60px; margin-top: 5px;" >
			<div id="pagingArea" style="z-index: 1;"></div>
		</div>
	</div>
</body>
</html>