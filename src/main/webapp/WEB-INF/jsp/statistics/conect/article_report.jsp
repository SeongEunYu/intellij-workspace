<%@page import="kr.co.argonet.r2rims.util.LanguageUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="cache-Control" content="co-cache" />
<%@include file="../../pageInit.jsp" %>
<style type="text/css">
.list_bt_area{border: 0px solid;}
div.gridbox_dhx_terrace.gridbox table.hdr td{vertical-align: middle;}
</style>
<script type="text/javascript" src="${contextPath}/js/jquery/jquery.filedownload.js"></script>
<script type="text/javascript" src="${contextPath}/js/mainLayout.js"></script>
<script type="text/javascript">
var dhxLayout, myTabbar,  cnfirmGrid, fundingGrid, myGrid, t;
$(document).ready(function(){
	var callType = '${callType}';
	setMainLayoutHeight($('#mainLayout'), -40);
	if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
	else  window.addEventListener("resize",resizeLayout, false);
	//set layout
	dhxLayout = new dhtmlXLayoutObject("mainLayout","1C");
	dhxLayout.cells("a").hideHeader();
	dhxLayout.setSizes(false);

	myTabbar = dhxLayout.cells("a").attachTabbar();
	myTabbar.setArrowsMode("auto");
	myTabbar.enableAutoReSize(true);

	myTabbar.addTab('a1','논문확인 현황');
	myTabbar.addTab('a2','논문사사정보입력 현황');

	myTabbar.tabs('a1').attachObject('cnfirm');
	myTabbar.tabs('a2').attachObject('funding');

	if(callType == 'articleConfirm') myTabbar.tabs('a1').setActive();
	else if(callType == 'articleFuning') myTabbar.tabs('a2').setActive();

	loadCnfirmGrid();
	loadFundigGrid();

});

function loadCnfirmGrid(){
	setGridHeight($('#cnfirmGridbox'));
	cnfirmGrid = new dhtmlXGridObject("cnfirmGridbox");
	cnfirmGrid.setImagePath("${dhtmlXImagePath}");
	cnfirmGrid.setHeader("사번,연구자,재직여부,신분,학과,논문전체,#cspan,논문(SCI급),#cspan,논문(기타),#cspan,논문확인률",null,grid_head_center_bold);
	cnfirmGrid.attachHeader("#rspan,#rspan,#rspan,#rspan,#rspan,확인,미확인,확인,미확인,확인,미확인,#rspan",grid_head_center_bold);
	cnfirmGrid.setColumnIds("rsrchUserId,rsrchUserNm,rsrchUserHldofYn,rsrchUserSclpst,rsrchUserDept,allCnfirmArtCo,allUncnfrmArtCo,sciCnfirmArtCo,sciUncnfrmArtCo,etcCnfirmArtCo,etcUncnfrmArtCo,artCnfirmRate");
	cnfirmGrid.setInitWidths("*,*,*,*,*,*,*,*,*,*,*,*");
	cnfirmGrid.setColAlign("center,center,center,center,center,right,right,right,right,right,right,right");
	cnfirmGrid.setColTypes("ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro");
	cnfirmGrid.attachEvent("onXLS", function(){myTabbar.tabs('a1').progressOn();});
	cnfirmGrid.attachEvent("onXLE", function(){setTimeout(function() {myTabbar.tabs('a1').progressOff();}, 100);});
	cnfirmGrid.enableColumnAutoSize(true);
	cnfirmGrid.init();
}

function loadFundigGrid(){
	setGridHeight($('#fundigGridbox'));
	fundingGrid = new dhtmlXGridObject("fundigGridbox");
	fundingGrid.setImagePath("${dhtmlXImagePath}");
	fundingGrid.setHeader("사번,연구자,재직여부,신분,학과,논문전체,관련연구과제,#cspan,연구과제확인률",null,grid_head_center_bold);
	fundingGrid.attachHeader("#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,입력,미입력,#rspan",grid_head_center_bold);
	fundingGrid.setColumnIds("rsrchUserId,rsrchUserNm,rsrchUserHldofYn,rsrchUserSclpst,rsrchUserDept,articleTotal,relateFundingInputCo,relateFundingUninputCo,fundingCnfirmRate");
	fundingGrid.setInitWidths("*,*,*,*,*,*,*,*,*");
	fundingGrid.setColAlign("center,center,center,center,center,right,right,right,right");
	fundingGrid.setColTypes("ro,ro,ro,ro,ro,ro,ro,ro,ro");
	fundingGrid.attachEvent("onXLS", function(){myTabbar.tabs('a2').progressOn();});
	fundingGrid.attachEvent("onXLE", function(){setTimeout(function() {myTabbar.tabs('a2').progressOff();}, 100);});
	fundingGrid.enableColumnAutoSize(true);
	fundingGrid.init();
}

function myGrid_load(){

	if($('#adminSrchDeptTrack').length)
	{
		var val = $('#adminSrchDeptTrack').val();
		if(val != null && val != '')
		{
			if(val.indexOf('DEPT_') != -1 ){
				$('#adminSrchDeptKor').val(val.replace('DEPT_',''));
				$('#adminSrchTrack').val('');
			}
			if(val.indexOf('TRACK_') != -1 ){
				$('#adminSrchDeptKor').val('');
				$('#adminSrchTrack').val(val.replace('TRACK_',''));
			}
		}
		else
		{
			$('#adminSrchDeptKor').val('');
			$('#adminSrchTrack').val('');
		}
	}

	cnfirmGrid.clearAndLoad("${contextPath}/statistics/conect/findArticleConfirmList.do?"+$('#formArea').serialize());
	fundingGrid.clearAndLoad("${contextPath}/statistics/conect/findArticleFundigList.do?"+$('#formArea').serialize());
}

function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){
		setMainLayoutHeight($('#mainLayout'), -40);
		setGridHeight($('#cnfirmGridbox'));
		setGridHeight($('#fundigGridbox'));
		cnfirmGrid.setSizes();
		fundingGrid.setSizes();
		dhxLayout.setSizes(false);
	},10);
}
function doOnGridLoaded(){setTimeout(function() {dhxLayout.cells("a").progressOff();}, 100);}
function doBeforeGridLoad(){dhxLayout.cells("a").progressOn();}

function toExcel(tabgubun){
	if(tabgubun == 'cnfirm')
	{
		cnfirmGrid.toExcel('${contextPath}/servlet/xlsGenerate.do?file_name=Article_Confirm_List.xls');
	}
	else if(tabgubun == 'funding')
	{
		fundingGrid.toExcel('${contextPath}/servlet/xlsGenerate.do?file_name=Article_Funding_List.xls');
	}

}

function setGridHeight(obj){
	var layoutHeight = $('#mainLayout').height();
	layoutHeight -= 16;
	if($('.title_box') != undefined )
		layoutHeight -= $('.dhxtabbar_tab').height();
	if($('.list_bt_area') != undefined )
		layoutHeight -= $('.list_bt_area').height();
	$(obj).css('height',layoutHeight+"px");
}

</script>
</head>
<body>
	<div class="title_box">
		<h3>논문확인/사사정보입력현황</h3>
	</div>
	<div class="contents_box">
		<!-- START 테이블 1 -->
		<form id="formArea" >
			<c:if test="${not sessMode and sessionScope.auth.adminDvsCd ne 'R' and  sessionScope.auth.adminDvsCd ne 'S' }">
			<table class="view_tbl mgb_10" >
				<colgroup>
					<col style="width: 15%;"/>
					<col style="width: 37%;"/>
					<col style="width: 15%;"/>
					<col />
					<col style="width: 50px;"/>
				</colgroup>
				<tbody>
				<tr>
					<th>사번</th>
					<td><input type="text" id="srchUserId" name="srchUserId" class="input2" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/></td>
					<th>성명</th>
					<td><input type="text" name="srchUserNm" id="srchUserNm" class="input2" maxlength="10" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/></td>
					<td rowspan="4" class="option_search_td" onclick="javascript:myGrid_load();"><em>search</em></td>
				</tr>
				<tr>
					<th>신분</th>
					<td>
						<input type="radio" id="gubun_A" name="gubun"  value=""  onchange="javascript:myGrid_load();" class="radio"/>
							<label for="전체" class="radio_label">전체</label>
						<input type="radio" id="gubun_M" name="gubun"  value="M" checked="checked"  onchange="javascript:myGrid_load();" class="radio"/>
							<label for="전임" class="radio_label">전임</label>
						<input type="radio" id="gubun_U" name="gubun"  value="U" onchange="javascript:myGrid_load();" class="radio"/>
							<label for="비전임" class="radio_label">비전임</label>
						<input type="radio" id="gubun_S" name="gubun"  value="S" onchange="javascript:myGrid_load();" class="radio"/>
							<label for="학생" class="radio_label">학생</label>
					</td>
					<th>재직여부</th>
					<td>
						<input type="radio" id="hldofYn_a" name="hldofYn"  value=""  checked="checked" onchange="javascript:myGrid_load();" class="radio"/>
							<label for="전체" class="radio_label">전체</label>
						<input type="radio" id="hldofYn_1" name="hldofYn"  value="1" onchange="javascript:myGrid_load();" class="radio"/>
							<label for="재직" class="radio_label">재직</label>
						<input type="radio" id="hldofYn_2" name="hldofYn"  value="2" onchange="javascript:myGrid_load();" class="radio"/>
							<label for="퇴직" class="radio_label">퇴직</label>
					</td>
				</tr>
				<tr>
					<th>입력년월 기준</th>
					<td>
						<input type="text" id="stt_date" name="sttDate" class="input2"  maxlength="6" style="width: 80px;"  onKeyup="javascript:if(event.keyCode=='13')myGrid_load();" />
						~ <input type="text" id="end_date" name="endDate" class="input2" maxlength="6" style="width: 80px;" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/>
						(예:201611)
					</td>
					<th>출판년도 기준</th>
					<td>
						<input type="text" id="srchPblcSttDate" name="srchPblcSttDate" class="input2"  maxlength="6" style="width: 80px;"  onKeyup="javascript:if(event.keyCode=='13')myGrid_load();" />
						~ <input type="text" id="srchPblcEndDate" name="srchPblcEndDate" class="input2" maxlength="6" style="width: 80px;" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/>
						(예:2016)
					</td>
				</tr>
				<tr>
					<th>
							<c:if test="${sessionScope.auth.adminDvsCd eq 'M'}">학과 및 트랙</c:if>
							<c:if test="${sessionScope.auth.adminDvsCd eq 'D' or sessionScope.login_user.adminDvsCd eq 'C'}">학과</c:if>
							<c:if test="${sessionScope.login_user.adminDvsCd eq 'T'}">트랙</c:if>
					</th>
					<td>
						<c:if test="${sessionScope.login_user.adminDvsCd ne 'M'}">
							<c:if test="${sessionScope.auth.adminDvsCd eq 'D'}">
								<input type="hidden" name="srchDeptKor" value="${sessionScope.auth.workTrgetNm}" />
								<input type="hidden" name="srchDept" value="${sessionScope.auth.workTrget}" />
								${sessionScope.auth.workTrgetNm}
							</c:if>
							<c:if test="${sessionScope.auth.adminDvsCd eq 'T'}">
								<input type="hidden" name="srchTrack" value="${sessionScope.auth.workTrget}" />
								${sessionScope.auth.workTrgetNm}
							</c:if>
							<c:if test="${sessionScope.auth.adminDvsCd eq 'C'}">
								<select name="srchDeptKor" onchange="javascript:myGrid_load();" class="select_type">
									<option value="">전체</option>
									<c:forEach items="${deptList}" var="dl" varStatus="idx">
										<c:if test="${not empty dl.deptKor }">
											<option value="${fn:escapeXml(dl.deptKor)}">${fn:escapeXml(dl.deptKor)}</option>
										</c:if>
									</c:forEach>
								</select>
							</c:if>
						</c:if>
						<c:if test="${sessionScope.auth.adminDvsCd eq 'M'}">
							<select  name="adminSrchDeptTrack" id="adminSrchDeptTrack"  onchange="javascript:myGrid_load();" class="select_type" >
								<option value="">전체</option>
								<optgroup label="학과(부)">
									<c:forEach var="item" items="${deptList}">
									<option value="DEPT_${item.deptKor}">${item.deptKor}</option>
									</c:forEach>
								</optgroup>
								<optgroup label="트랙">
									<c:forEach var="item" items="${trackList}">
									<option value="TRACK_${item.trackId}">${item.trackName}</option>
									</c:forEach>
								</optgroup>
							</select>
							<input type="hidden" name="srchDeptKor"  id="adminSrchDeptKor"/>
							<input type="hidden" name="srchTrack"  id="adminSrchTrack"/>
						</c:if>
					</td>
					<th>대상자구분</th>
					<td>
						<select name="historyId" class="select_type">
							<option value=""></option>
							<c:forEach var="item" items="${exportHistory}">
							<option value="${item.historyId}">${item.groupName}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				</tbody>
			</table>
			</c:if>
		</form>
		<!-- layout (grid,paging)  -->
		<div id="mainLayout" style="position: relative; width: 100%;height: 100%;"></div>
		<div id="cnfirm" style="display: none;">
			<div class="list_bt_area">
				<div class="list_set">
					<ul>
						<li><a href="#" onclick="javascript:toExcel('cnfirm');" class="list_icon20">엑셀</a></li>
					</ul>
				</div>
			</div>
			<div id="cnfirmGridbox"></div>
		</div>
		<div id="funding" style="display: none;">
			<div class="list_bt_area">
				<div class="list_set">
					<ul>
						<li><a href="#" onclick="javascript:toExcel('funding');" class="list_icon20">엑셀</a></li>
					</ul>
				</div>
			</div>
			<div id="fundigGridbox"></div>
		</div>
 	</div>
<form id="findItem" action="${contextPath}/article/article.do" method="post" target="item">
  <input type="hidden" id=userId name="srchUserId" value=""/>
  <input type="hidden" id="item_id" name="item_id" value=""/>
</form>
</body>
</html>