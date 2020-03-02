<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>JCR Ranking </title>
<%@include file="../../pageInit.jsp" %>
<script type="text/javascript" src="${contextPath}/js/mainLayout.js"></script>
<script type="text/javascript">
var dhxLayout, jcrGrid, sbjtGrid, t;
$(document).ready(function(){
	if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
	else  window.addEventListener("resize",resizeLayout, false);
	//set layout
	dhxLayout = new dhtmlXLayoutObject("mainLayout","2U");
	dhxLayout.cells("a").hideHeader();
	dhxLayout.cells("b").setText("Category Ranking");
	dhxLayout.cells("b").setWidth(460);
	dhxLayout.setSizes(false);
	dhxLayout.setAutoSize("a","a;b");
	//attach Grid
	loadJcrCellComponent();
	loadRankingCellComponent();
	jcrGrid_load();
});

function loadJcrCellComponent(){
	jcrGrid = dhxLayout.cells("a").attachGrid();
	jcrGrid.setImagePath("${dhtmlXImagePath}");
	jcrGrid.setHeader("Year,Journal,ISSN,Category Description,I.F", null, grid_head_center_bold);
	jcrGrid.setColumnIds("prodYear,title,issn,cateDesc,impact");
	jcrGrid.setInitWidths("50,*,90,200,60");
	jcrGrid.setColAlign("center,left,center,left,center");
	jcrGrid.setColSorting("str,str,na,na,int");
	jcrGrid.setColTypes("ro,ro,ro,ro,ro");
	jcrGrid.enableColSpan(true);
	jcrGrid.attachEvent("onRowSelect",jcrGrid_onRowSelect);
	jcrGrid.attachEvent("onBeforeSorting",jcrGrid_onBeforeSorting);
	jcrGrid.attachEvent("onPageChanged",doBeforeGridLoad);
	jcrGrid.attachEvent("onPaging",doOnGridLoaded);
	jcrGrid.attachEvent("onXLE", jcrGrid_onSelectPageFirstRow);
	jcrGrid.enablePaging(true,100,10,"pagingArea",true);
	jcrGrid.setPagingSkin("${dhtmlXPagingSkin}");
	jcrGrid.init();
}

function loadRankingCellComponent(){
	sbjtGrid = dhxLayout.cells("b").attachGrid();
	sbjtGrid.setImagePath("${dhtmlXImagePath}");
	sbjtGrid.setHeader("Description,IF순위(%),Rating", null, grid_head_center_bold);
	sbjtGrid.setInitWidths("*,80,80");
	sbjtGrid.setColAlign("left,center,center");
	sbjtGrid.setColSorting("str,str,str");
	sbjtGrid.setColTypes("ro,ro,ro");
	sbjtGrid.init();
}

function jcrGrid_load(){
	var url = '<c:url value="/${preUrl}/jcr/findJcrRankingList.do?maskCateg=" />'+$('#maskCateg').val()+"&maskYear="+$('#maskYear').val();
	sbjtGrid.clearAll();
	jcrGrid.clearAndLoad(url, function(){jcrGrid.selectRow(0, true);});
}


function jcrGrid_onRowSelect(rowID,celInd){
 	var issn = jcrGrid.cells(rowID,jcrGrid.getColIndexById("issn")).getValue();
	var prodYear = jcrGrid.cells(rowID,jcrGrid.getColIndexById("prodYear")).getValue();
	var url = '<c:url value="/${preUrl}/jcr/findJcrCategoryRankingList.do?issn="/>'+issn+"&prodYear="+prodYear;
	sbjtGrid.clearAndLoad(url);
}

function jcrGrid_onBeforeSorting(ind,type,direct){
	jcrGrid.clearAndLoad('<c:url value="/${preUrl}/jcr/findJcrRankingList.do?maskCateg=" />'+$('#maskCateg').val()+"&maskYear="+$('#maskYear').val()+"&orderby="+(jcrGrid.getColumnId(ind))+"&direct="+direct);
	jcrGrid.setSortImgState(true,ind,direct);
	return false;
}

function jcrGrid_onSelectPageFirstRow(){
	var strIndex = (jcrGrid.currentPage-1) * jcrGrid.rowsBufferOutSize;
	jcrGrid.selectRow(strIndex,true,true,true);
	jcrGrid.showRow(jcrGrid.getRowId(strIndex))
	//doOnGridLoaded();
}

function searchHigh(per){
	if($('#maskYear').val() == '') {
		dhtmlx.alert({type:"alert-warning",text:"<spring:message code='win.jcr.alert1'/>",callback:function(){}})
		$('#maskYear').focus();
		return;
	}
	var highJcrCatRanking = window.open('about:blank','HighJcrCatRanking',' height=555px, width=828px, resizable=no, location=no, scrollbars=no');
	var popFrm = $('#popFrm');
	popFrm.empty();
	popFrm.append($('<input type="hidden" name="maskYear" value="'+$('#maskYear').val()+'"/>'));
	popFrm.append($('<input type="hidden" name="maskCateg" value="'+$('#maskCateg').val()+'"/>'));
	popFrm.append($('<input type="hidden" name="maskRatio" value="'+per+'"/>'));
	popFrm.attr('action', '<c:url value="/${preUrl}/jcr/jcrRankingHighPopup.do" />');
	popFrm.attr('target', "HighJcrCatRanking");
	popFrm.attr('method', "post");
	popFrm.submit();
}

function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){ dhxLayout.setSizes(false); },200);}
function doOnGridLoaded(){setTimeout(function() {dhxLayout.cells("a").progressOff();}, 100);}
function doBeforeGridLoad(){dhxLayout.cells("a").progressOn();}
</script>

</head>
<body>
	<!-- Page Title -->
	<div class="title_box">
		<h3><spring:message code='menu.jcr.ranking'/></h3>
	</div>
	<!-- Main Content -->
	<div class="contents_box">
		<!-- START 탑 툴바 -->
		<div class="top_toolbar" >
			<div class="top_toolbar_ttl"></div>
			<div class="top_toolbar_btn">
				<div style="float: right;margin-right: 10px;"><a href="#" onclick="searchHigh('5');">Top 5%</a></div>
				<div style="float: right;margin-right: 10px;"><a href="#" onclick="searchHigh('10');">Top 10%</a></div>
			</div>
		</div>
		<!-- END 탑 툴바 -->
		<form id="frm" name="frm" method="post">
			<div class="formObj">
				<table class="view_tbl mgb_10">
					<colgroup>
						<col style="width: 13%"/>
						<col style="width: 45%;"/>
						<col style="width: 13%"/>
						<col />
						<col style="width: 50px;"/>
					</colgroup>
					<tr>
						<th class="caption">Category</th>
						<td>
							<span style="margin-top:3px;">
								<select id="maskCateg" style="width: 100%;font-size: 9pt;" onchange="javascript:jcrGrid_load();">
									<option value="" selected="selected"></option>
									<c:if test="${not empty categList}">
										<c:forEach items="${categList}" var="tl" varStatus="st">
												<option value="${tl.catcode }">${tl.description  }</option>
										</c:forEach>
									</c:if>
								</select>
							</span>
						</td>
						<th class="caption">Year</th>
						<td style="text-align:left;">
							<span style="margin-top:3px;">
								<select id="maskYear" style="width: 80px;font-family: Arial;font-size: 9pt;" onchange="javascript:jcrGrid_load();">
									<option value="" selected="selected"></option>
									<c:if test="${not empty prodyearList}">
										<c:forEach items="${prodyearList}" var="tl" varStatus="st">
												<option value="${tl.prodyear }">${tl.prodyear  }</option>
										</c:forEach>
									</c:if>
								</select>
							</span>
						</td>
						<td class="option_search_td" onclick="javascript: jcrGrid_load();"><em>search</em></td>
					</tr>
				</table>
			</div>
		</form>
		<div id="mainLayout" style="position: relative; width: 100%;height: 100%;"></div>
		<script type="text/javascript">setMainLayoutHeight($('#mainLayout'));</script>
		<div id="pagingObj" style="z-index: 1; height: 60px; margin-top: 5px;" >
			<div id="pagingArea" style="z-index: 1;"></div>
		</div>
	</div>
</body>
</html>