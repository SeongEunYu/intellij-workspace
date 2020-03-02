<%@page import="kr.co.argonet.r2rims.util.LanguageUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="../../pageInit.jsp" %>
<c:if test="${sessMode or (sessionScope.auth.adminDvsCd eq 'R' or  sessionScope.auth.adminDvsCd eq 'S' )}">
<style type="text/css">.appr { color: #f26522; font-weight: bold; }</style>
</c:if>
<script type="text/javascript" src="${contextPath}/js/jquery/jquery.filedownload.js"></script>
<script type="text/javascript" src="${contextPath}/js/mainLayout.js"></script>
<script type="text/javascript">
var dhxLayout, myGrid, t;
$(document).ready(function(){
	bindModalLink();
	setMainLayoutHeight($('#mainLayout'), -30);
	if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
	else  window.addEventListener("resize",resizeLayout, false);
	//set layout
	dhxLayout = new dhtmlXLayoutObject("mainLayout","1C");
	dhxLayout.cells("a").hideHeader();
	dhxLayout.setSizes(false);
	//attach myGrid
	var header = "번호,논문정보,발행년월";
	var columnIds = "No,articleInfo,pblcYm";
	var initWidths = "80,*,150";
	var colAlign = "center,left,center";
	var colTypes = "ro,ro,ro";
	var colSorting = "na,na,na";

	myGrid = dhxLayout.cells("a").attachGrid();
	myGrid.setImagePath("${dhtmlXImagePath}");
	myGrid.setHeader(header,null,grid_head_center_bold);
	myGrid.setColumnIds(columnIds);
	myGrid.setInitWidths(initWidths);
	myGrid.setColAlign(colAlign);
	myGrid.setColTypes(colTypes);
	myGrid.setColSorting(colSorting);
	myGrid.attachEvent("onXLS", doBeforeGridLoad);
	myGrid.attachEvent("onXLE", doOnGridLoaded);
	myGrid.enableColSpan(true);
	myGrid.enableColumnAutoSize(true);
	myGrid.enableTooltips("false,false,false");
	myGrid.init();
	myGrid_load();
});
function myGrid_load(){
	var url = getGridRequestURL();
	myGrid.clearAndLoad(url);
}
function myGrid_onBeforeSorting(ind,type,direct){
	var url = getGridRequestURL();
	myGrid.clearAndLoad(url+"&orderby="+(myGrid.getColumnId(ind))+"&direct="+direct);
	myGrid.setSortImgState(true,ind,direct);
	return false;
}
function getGridRequestURL(){

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

	var url = "${contextPath}/${preUrl}/article/findLatestArticleList.do";
	url += "?"  + $('#formArea').serialize();
	return url;
}

function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){ setMainLayoutHeight($('#mainLayout'), -30); dhxLayout.setSizes(false); },10);}
function doOnGridLoaded(){setTimeout(function() {dhxLayout.cells("a").progressOff();}, 100);}
function doBeforeGridLoad(){dhxLayout.cells("a").progressOn();}

</script>
</head>
<body>
	<div class="title_box">
		<h3>최신논문</h3>
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
					<th>
						<c:if test="${sessionScope.auth.adminDvsCd eq 'M'}">학과 및 트랙</c:if>
						<c:if test="${sessionScope.auth.adminDvsCd eq 'D' or sessionScope.login_user.adminDvsCd eq 'C'}">학과</c:if>
						<c:if test="${sessionScope.login_user.adminDvsCd eq 'T'}">트랙</c:if>
					</th>
					<td>
						<c:if test="${sessionScope.auth.adminDvsCd ne 'M'}">
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
							<select  name="adminSrchDeptTrack" id="adminSrchDeptTrack"  onchange="javascript:myGrid_load();" >
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
					<th>Row수</th>
					<td>
						<select name="rownum">
							<option value="100" <c:if test="${rownum  eq '100'}">selected="selected"</c:if>>100</option>
							<option value="500" <c:if test="${rownum  eq '500'}">selected="selected"</c:if>>500</option>
							<option value="1000" <c:if test="${rownum  eq '100'}">selected="selected"</c:if>>1000</option>
						</select>
					</td>
					<td rowspan="9" class="option_search_td" onclick="javascript:myGrid_load();"><em>search</em></td>
				</tr>
				<tr>
					<th>대상구분</th>
					<td colspan="3">
						<input type="radio" id="trgetSe_all" name="trgetSe"  value=""  checked="checked" onchange="javascript:myGrid_load();" class="radio"/>
							<label for="trgetSe_all" class="radio_label">전체</label>
						<input type="radio" id="trgetSe_mgt" name="trgetSe"  value="M" onchange="javascript:myGrid_load();" class="radio"/>
							<label for="trgetSe_mgt" class="radio_label">관리대상자(전임직 교원)</label>
						<input type="radio" id="trgetSe_not_mgt" name="trgetSe"  value="U" onchange="javascript:myGrid_load();" class="radio"/>
							<label for="trgetSe_not_mgt" class="radio_label">미관리대상</label>
						<input type="radio" id="trgetSe_student" name="trgetSe"  value="S" onchange="javascript:myGrid_load();" class="radio"/>
							<label for="trgetSe_student" class="radio_label">학생</label>
						<input type="radio" id="trgetSe_etc" name="trgetSe"  value="E" onchange="javascript:myGrid_load();" class="radio"/>
							<label for="trgetSe_etc" class="radio_label">기타</label>
					</td>
				</tr>
				<tr>
					<th>학술지 구분</th>
					<td colspan="3">
						<input type="radio" id="scjnl_dvs_cd0" name="scjnlDvsCd" class="radio" style="border: 0;" checked="checked" value="" onchange="javascript:myGrid_load();"/>
							<label for="scjnl_dvs_cd0" class="radio_label">전체</label>
						<input type="radio" id="scjnl_dvs_cd1" name="scjnlDvsCd" class="radio" style="border: 0;" value="1" onchange="javascript:myGrid_load();"/>
							<label for="scjnl_dvs_cd1" class="radio_label">국제전문학술지(SCI급)</label>
						<input type="radio" id="scjnl_dvs_cd2" name="scjnlDvsCd" class="radio" style="border: 0;" value="2" onchange="javascript:myGrid_load();"/>
							<label for="scjnl_dvs_cd2" class="radio_label">국제일반학술지</label>
						<input type="radio" id="scjnl_dvs_cd3" name="scjnlDvsCd" class="radio" style="border: 0;" value="3" onchange="javascript:myGrid_load();"/>
							<label for="scjnl_dvs_cd3" class="radio_label">국내전문학술지(KCI급)</label>
						<input type="radio" id="scjnl_dvs_cd4" name="scjnlDvsCd" class="radio" style="border: 0;" value="4" onchange="javascript:myGrid_load();"/>
							<label for="scjnl_dvs_cd4" class="radio_label">국내일반학술지</label>
						<input type="radio" id="scjnl_dvs_cd5" name="scjnlDvsCd" class="radio" style="border: 0;" value="5" onchange="javascript:myGrid_load();"/>
							<label for="scjnl_dvs_cd5" class="radio_label">기타</label>
					</td>
				</tr>
				</tbody>
			</table>
			</c:if>
		</form>
		<!-- layout (grid,paging)  -->
		<div id="mainLayout" style="position: relative; width: 100%;height: 100%;"></div>
 	</div>
</body>
</html>