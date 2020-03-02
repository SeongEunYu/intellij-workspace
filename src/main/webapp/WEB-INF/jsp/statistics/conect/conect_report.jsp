<%@page import="kr.co.argonet.r2rims.util.LanguageUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="../../pageInit.jsp" %>
<script type="text/javascript" src="${contextPath}/js/mainLayout.js"></script>
<script type="text/javascript">
var dhxLayout, myTabbar, myGrid, t;
$(document).ready(function(){
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
	myGrid.setHeader("연구자,#cspan,#cspan,#cspan,접속자,#cspan,#cspan,#cspan",null,grid_head_center_bold);
	myGrid.attachHeader("사번,성명,재직여부,신분,사번,성명,로그인횟수,접속권한",grid_head_center_bold);
	myGrid.setColumnIds("rsrchUserId,rsrchUserNm,rsrchUserHldofYn,rsrchUserSclpst,conectrId,conectrNm,loginCo,conectrAuthorCd");
	myGrid.setInitWidths("*,*,*,*,*,*,*,*");
	myGrid.setColAlign("center,center,center,center,center,center,center,center");
	myGrid.setColTypes("ro,ro,ro,ro,ro,ro,ro,ro");
	myGrid.setColSorting("na,na,na,na,na,na,na,na");
	myGrid.attachEvent("onBeforeSorting", myGrid_onBeforeSorting);
	myGrid.attachEvent("onXLS", doBeforeGridLoad);
	myGrid.attachEvent("onXLE", doOnGridLoaded);
	myGrid.enableMultiselect(true);
	myGrid.enableColSpan(true);
	myGrid.enableColumnAutoSize(true);
	myGrid.init();
	//myGrid_load();
});
function myGrid_load(){
	//파라미터 체크 (사번, 성명, 입력년월, 학부 최소 1개 필요)
	if($('#srchUserId').val() != '' || $('#srchUserNm').val() != ''
		 || $('#sttDate').val() != '' || $('#endDate').val() != ''
		 || $('#srchDeptKor').val() != '')
	{
		var url = getGridRequestURL();
		myGrid.clearAndLoad(url);
	}
	else
	{
		dhtmlx.alert({type:"alert-warning",text:"검색조건을 입력 해주세요.",callback:function(){ $('#srchUserId').focus(); }});
		return;
	}
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

	var url = "${contextPath}/statistics/conect/findLoginStatusList.do";
	url += "?"  + $('#formArea').serialize();
	return url;
}

function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){ setMainLayoutHeight($('#mainLayout')); dhxLayout.setSizes(false); },10);}
function doOnGridLoaded(){setTimeout(function() {dhxLayout.cells("a").progressOff();}, 100);}
function doBeforeGridLoad(){dhxLayout.cells("a").progressOn();}

function toExcel(){
	myGrid.toExcel('${contextPath}/servlet/xlsGenerate.do?file_name=LoginStatus_List.xls');
}
</script>
</head>
<body>
	<div class="title_box">
		<h3>로그인현황</h3>
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
					<td rowspan="3" class="option_search_td" onclick="javascript:myGrid_load();"><em>search</em></td>
				</tr>
				<tr>
					<th>신분</th>
					<td>
						<input type="radio" id="gubun_A" name="gubun"  value=""  checked="checked" onchange="javascript:myGrid_load();" class="radio"/>
							<label for="전체" class="radio_label">전체</label>
						<input type="radio" id="gubun_M" name="gubun"  value="M" onchange="javascript:myGrid_load();" class="radio"/>
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
						<input type="text" id="sttDate" name="sttDate" class="input2"  maxlength="8" style="width: 80px;"  onKeyup="javascript:if(event.keyCode=='13')myGrid_load();" />
						~ <input type="text" id="endDate" name="endDate" class="input2" maxlength="8" style="width: 80px;" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/>
						(예:20161122)
					</td>
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
								<select  name="adminSrchDeptTrack" id="adminSrchDeptTrack"  onchange="javascript:myGrid_load();" class="select_type">
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
				</tr>
				</tbody>
			</table>
			</c:if>
		</form>
		<div class="list_bt_area">
			<div class="list_set">
				<ul>
					<li><a href="#" onclick="javascript:toExcel();" class="list_icon20">엑셀</a></li>
				</ul>
			</div>
		</div>
		<!-- layout (grid,paging)  -->
		<div id="mainLayout" style="position: relative; width: 100%;height: 100%;"></div>
 	</div>
</body>
</html>