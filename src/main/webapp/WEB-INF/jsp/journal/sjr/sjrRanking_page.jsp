<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../pageInit.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>SJR Category Ranking</title>
<script type="text/javascript" src="${contextPath}/js/mainLayout.js"></script>
<script type="text/javascript">
var dhxLayout, sjrGrid, sbjtGrid, t;
$(document).ready(function(){
	if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
	else  window.addEventListener("resize",resizeLayout, false);
	//set layout
	dhxLayout = new dhtmlXLayoutObject("mainLayout","2U");
	dhxLayout.cells("a").hideHeader();
	dhxLayout.cells("b").setText("Category Ranking");
	dhxLayout.cells("b").setWidth(360);
	dhxLayout.setSizes(false);
	dhxLayout.setAutoSize("a","a;b");
	//attach Grid
	loadSjrCellComponent();
	loadRankingCellComponent();
	sjrGrid_load();
});

function loadSjrCellComponent() {
	sjrGrid = dhxLayout.cells("a").attachGrid();
	sjrGrid.setImagePath("${dhtmlXImagePath}");
	sjrGrid.setHeader("Year,Journal Name,ISSN,Category Description,SJR,<spring:message code='grid.sjr1'/>", null, grid_head_center_bold);
	sjrGrid.setColumnIds("prodyear,title,issn,description,sjr,ratio");
	sjrGrid.setInitWidths("50,*,80,200,60,75");
	sjrGrid.setColAlign("center,left,center,left,center,center");
	sjrGrid.setColSorting("server,server,server,na,server,server");
	sjrGrid.setColTypes("ro,ed,ed,ed,ed,ed");
	sjrGrid.attachEvent("onRowSelect",sjrGrid_onRowSelect);
	sjrGrid.attachEvent("onBeforeSorting",sjrGrid_onBeforeSorting);
	sjrGrid.attachEvent("onPageChanged",doBeforeGridLoad);
	sjrGrid.attachEvent("onPaging",doOnGridLoaded);
	sjrGrid.attachEvent("onXLE", sjrGrid_onSelectPageFirstRow);
	sjrGrid.enablePaging(true,100,10,"pagingArea",true);
	sjrGrid.setPagingSkin("${dhtmlXPagingSkin}");
	sjrGrid.enableColSpan(true);
	sjrGrid.init();
}

function loadRankingCellComponent(){
	sbjtGrid = dhxLayout.cells("b").attachGrid();
	sbjtGrid.setImagePath("${dhtmlXImagePath}");
	sbjtGrid.setHeader("Description,<spring:message code='grid.sjr1'/>,Rating", null, grid_head_center_bold);
	sbjtGrid.setInitWidths("*,80,80");
	sbjtGrid.setColAlign("left,center,center");
	sbjtGrid.setColSorting("str,str,str");
	sbjtGrid.setColTypes("ro,ro,ro");
	sbjtGrid.setColumnColor("#FFFFFF,#FFFFFF,#FFFFFF");
	sbjtGrid.init();
}
function sjrGrid_load(){
	var url = getGridRequestURL();
	sbjtGrid.clearAll();
	sjrGrid.clearAndLoad(url, function(){sjrGrid.selectRow(0, true);});
}

function getGridRequestURL(){
	var url = '<c:url value="/${preUrl}/sjr/findSjrRankingList.do?"/>'+$('#searchForm').serialize();
	sjrGrid.clearAndLoad(url, function(){sjrGrid.selectRow(0, true);});
	sbjtGrid.clearAll();
	return url;
}

function sjrGrid_onRowSelect(rowID,celInd){
	dhxLayout.cells("b").progressOn();
	var year = sjrGrid.cells(rowID,0).getValue();
	var issn = sjrGrid.cells(rowID,2).getValue();
	var url = '<c:url value="/${preUrl}/sjr/findOtherCategRank.do?issn="/>'+issn+"&prodyear="+year;
	sbjtGrid.clearAndLoad(url, function(){setTimeout(function() {dhxLayout.cells("b").progressOff();}, 50);});
}

function sjrGrid_onBeforeSorting(ind,gridObj,direct){
	sjrGrid.clearAll();
	var url = '<c:url value="/${preUrl}/sjr/findSjrRankingList.do?"/>'+$('#searchForm').serialize()+"&orderby="+(sjrGrid.getColumnId(ind))+"&direct="+direct;
	sjrGrid.clearAndLoad(url, function(){sjrGrid.selectRow(0, true);});
	sjrGrid.setSortImgState(true,ind,direct);
}

function sjrGrid_onSelectPageFirstRow(){
	var strIndex = (sjrGrid.currentPage-1) * sjrGrid.rowsBufferOutSize;
	sjrGrid.selectRow(strIndex,true,true,true);
	sjrGrid.showRow(sjrGrid.getRowId(strIndex))
	//doOnGridLoaded();
}

function searchHigh(per){
	if($('#maskYear').val() == '') {
		dhtmlx.alert({type:"alert-warning",text:"년도를 선택하세요.",callback:function(){}})
		$('#maskYear').focus();
		return;
	}
	var highSjrCatRanking = window.open('about:blank','HighSjrCatRanking',' height=555px, width=828px, resizable=no, location=no, scrollbars=no');
	var popFrm = $('#popFrm');
	popFrm.empty();
	popFrm.append($('<input type="hidden" name="maskYear" value="'+$('#maskYear').val()+'"/>'));
	popFrm.append($('<input type="hidden" name="maskCateg" value="'+$('#maskCateg').val()+'"/>'));
	popFrm.append($('<input type="hidden" name="maskRatio" value="'+per+'"/>'));
	popFrm.attr('action', '<c:url value="/${preUrl}/sjr/sjrRankingHighPopup.do"/>');
	popFrm.attr('target', "HighSjrCatRanking");
	popFrm.attr('method', "post");
	popFrm.submit();
}
function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){ dhxLayout.setSizes(false); },200);}
function doOnGridLoaded(){setTimeout(function() {dhxLayout.cells("a").progressOff();}, 100);}
function doBeforeGridLoad(){dhxLayout.cells("a").progressOn();}

function onChangeArea(){
	$.ajax({
		url: '<c:url value="/${preUrl}/sjr/findCategoryListByAreaCodeAjax.do"/>',
		dataType: "json",
		method: "POST",
		data: {"maskArea":$('#maskArea').val()},
		success: function(data,textStatus,jqXHR){}
	}).done(function(data){
		if(data != null && data.length > 0)
		{
			$('#maskCateg > option').remove();
			$('#maskCateg').append($('<option value="">All categories of selected Area</option>'));
			for(var i=0; i < data.length; i++)
			{
				$('#maskCateg').append($('<option value="'+data[i].catcode+'">'+data[i].description+'</option>'))
			}
			sjrGrid_load();
		}
	});
}
function importSjrData(targetYear){
	var importUrl = "${contextPath}/import/importSjr.do?targetYear="+targetYear;
	$.ajax({ url: importUrl, dataType: 'json' }).done(function(data){
		dhtmlx.alert(data.msg);
	});
}
</script>

</head>
<body>
	<!-- Page Title -->
	<div class="title_box">
		<h3><spring:message code='menu.sjr.ranking'/></h3>
	</div>
	<!-- Main Content -->
	<div class="contents_box">
		<!-- START 탑 툴바 -->
		<div class="top_toolbar" >
			<div class="list_bt_area" style="border: 0px;">
				<div class="list_set">
					<ul>
						<li><a href="#" onclick="javascript:searchHigh('5');" class="list_icon17">Top 5%</a></li>
						<li><a href="#" onclick="javascript:searchHigh('10');" class="list_icon17">Top 10%</a></li>
					</ul>
				</div>
			</div>
			<!--
			<div class="top_toolbar_btn">
				<div style="float: right;margin-right: 10px;"><a href="#" onclick="searchHigh('5');">Top 5%</a></div>
				<div style="float: right;margin-right: 10px;"><a href="#" onclick="searchHigh('10');">Top 10%</a></div>
			</div>
			 -->
		</div>
		<!-- END 탑 툴바 -->
		<div class="formObj">
		<form id="searchForm" name="serachForm" method="post">
				<table class="view_tbl mgb_10">
					<colgroup>
						<col style="width: 15%"/>
						<col style="width: 35%"/>
						<col style="width: 15%"/>
						<col />
						<col style="width: 50px;"/>
					</colgroup>
					<tr>
						<th>Subject Area</th>
						<td>
							<span style="margin-top:3px;">
								<select id="maskArea" name="maskArea" style="width: 100%;font-family: Arial;font-size: 9pt;" onchange="javascript:onChangeArea();">
									<option value=""><spring:message code='common.option.select'/></option>
									<c:if test="${not empty areaList}">
										<c:forEach items="${areaList}" var="tl" varStatus="st">
												<option value="${tl.catcode }">${tl.description  }</option>
										</c:forEach>
									</c:if>
								</select>
							</span>
						</td>
						<th>Subject Category</th>
						<td>
							<span style="margin-top:3px;">
								<select id="maskCateg" name="maskCateg" style="width: 100%;font-family: Arial;font-size: 9pt;" onchange="javascript:sjrGrid_load();">
									<option value=""><spring:message code='common.option.select'/></option>
									<c:if test="${not empty categList}">
										<c:forEach items="${categList}" var="cl" varStatus="st">
												<option value="${cl.catcode }">${cl.description  }</option>
										</c:forEach>
									</c:if>
								</select>
							</span>
						</td>
						<td rowspan="2" class="option_search_td" onclick="javascript:sjrGrid_load();"><em>search</em></td>
					</tr>
					<tr>
						<th>Journal Name</th>
						<td>
							<input type="text" size=10 id="maskTitle" name="maskTitle" style="height:14px; width:100%;" onkeyup="javascript:if(event.keyCode=='13')sjrGrid_load();">
						</td>
						<th>Year</th>
						<td style="text-align:left;">
							<span style="margin-top:3px;">
								<select id="maskYear" name="maskYear" style="width: 80px;font-family: Arial;font-size: 9pt;" onchange="javascript:sjrGrid_load();">
									<c:if test="${not empty prodyearList}">
										<c:forEach items="${prodyearList}" var="tl" varStatus="st">
												<option value="${tl.prodyear }">${tl.prodyear}</option>
										</c:forEach>
									</c:if>
								</select>
							</span>
						</td>
					</tr>
					</table>
			</form>
		</div>
		<c:if test="${sessionScope.login_user.adminDvsCd eq 'M' and not empty targetYear}">
		<div class="list_bt_area">
			<div class="list_set">
				<ul>
					<li><a href="#" onclick="javascript:importSjrData('${targetYear}');" class="list_icon14">${targetYear}년데이터반입</a></li>
				</ul>
			</div>
		</div>
		</c:if>
		<div id="mainLayout" style="position: relative; width: 100%;height: 100%;"></div>
		<script type="text/javascript">setMainLayoutHeight($('#mainLayout'));</script>
		<div id="pagingObj" style="z-index: 1; height: 60px; margin-top: 5px;" >
			<div id="pagingArea" style="z-index: 1;"></div>
		</div>
	</div>
</body>
</html>