<%@page import="kr.co.argonet.r2rims.util.LanguageUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="../../pageInit.jsp" %>
<script type="text/javascript" src="${contextPath}/js/jquery/jquery.filedownload.js"></script>
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
	myGrid.attachEvent("onBeforeSorting", myGrid_onBeforeSorting);
	myGrid.attachEvent("onXLS", doBeforeGridLoad);
	myGrid.attachEvent("onXLE", doOnGridLoaded);
	myGrid.enableMultiselect(true);
	myGrid.enableColSpan(true);
	myGrid.enableColumnAutoSize(true);
	myGrid.setNumberFormat("0,000",0);
	myGrid._in_header_stat_sum=function(tag,index,data){
	    var calck=function(){
	        var sum=0;
	        this.forEachRow(function(id){
	        	var value = this.cellById(id,index).getValue();
	            sum+=value.substring(0, value.indexOf('^')).replace(/\D/g, "")*1;
	        })
	    return this._aplNF(sum,0);
	    }
	    this._stat_in_header(tag,calck,index,data);
	}
	myGrid.init();
	//myGrid_load();
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

	var url = "${contextPath}/statistics/output/findRsltList.do";
	url += "?"  + $('#formArea').serialize();
	return url;
}

function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){ setMainLayoutHeight($('#mainLayout')); dhxLayout.setSizes(false); },10);}
function doOnGridLoaded(){setTimeout(function() {dhxLayout.cells("a").progressOff();}, 100);}
function doBeforeGridLoad(){dhxLayout.cells("a").progressOn();}

function toExcel(){
	myGrid.toExcel('${contextPath}/servlet/xlsGenerate.do?file_name=RlstStatus_List.xls');
}
function exportRslt(regDate, cond){
	//dhtmlx.alert({type:"alert-warning",text:"성과를 출력합니다. regDate >>> "+regDate + ", cond >>> " + cond,callback:function(){ $('#srchUserId').focus(); }});
}
</script>
</head>
<body>
	<div class="title_box">
		<h3>성과리포트</h3>
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
					<th>등록기간</th>
					<td>
						<input type="text" id="stt_date" name="sttDate" class="input2"  maxlength="6" style="width: 80px;"  onKeyup="javascript:if(event.keyCode=='13')myGrid_load();" />
						~ <input type="text" id="end_date" name="endDate" class="input2" maxlength="6" style="width: 80px;" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/>
					</td>
					<th>통계유형</th>
					<td>
						<input type="radio" id="gubun_byYear" name="gubun"  value="byYear"  checked="checked" onchange="javascript:myGrid_load();" class="radio"/>
							<label for="전체" class="radio_label">연도별</label>
						<input type="radio" id="gubun_byYearMonth" name="gubun"  value="byYearMonth" onchange="javascript:myGrid_load();" class="radio"/>
							<label for="전임" class="radio_label">연월별</label>
					</td>
					<td rowspan="4" class="option_search_td" onclick="javascript:myGrid_load();"><em>search</em></td>

				</tr>
				<tr>
					<th>사번</th>
					<td><input type="text" id="srchUserId" name="srchUserId" class="input2" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/></td>
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
					<tr>
						<th>대상성과</th>
						<td colspan="3">
							<input type="radio" class="radio" value="article" id="trgetOutput_Art" name="trgetOutput" checked="checked" onchange="javascript:myGrid_load();"/>
								<label for="" class="radio_label">논문게재</label>
							<input type="radio" class="radio" value="conference" id="trgetOutput_Con" name="trgetOutput" onchange="javascript:myGrid_load();"/>
								<label for="" class="radio_label">학술활동</label>
							<input type="radio" class="radio" value="book" id="trgetOutput_Book" name="trgetOutput" onchange="javascript:myGrid_load();"/>
								<label for="" class="radio_label">저역서</label>
							<input type="radio" class="radio" value="funding" id="trgetOutput_Fund" name="trgetOutput" onchange="javascript:myGrid_load();"/>
								<label for="" class="radio_label">연구비(연구과제)</label>
							<input type="radio" class="radio" value="patent" id="trgetOutput_Pat" name="trgetOutput" onchange="javascript:myGrid_load();"/>
								<label for="" class="radio_label">지식재산권(특허)</label>
							<input type="radio" class="radio" value="techtrans" id="trgetOutput_Tech" name="trgetOutput" onchange="javascript:myGrid_load();"/>
								<label for="" class="radio_label">기술이전</label>
							<input type="radio" class="radio" value="exhibition" id="trgetOutput_Exhibition" name="trgetOutput" onchange="javascript:myGrid_load();"/>
								<label for="" class="radio_label">전시작품</label>
							<input type="radio" class="radio" value="career" id="trgetOutput_Career" name="trgetOutput" onchange="javascript:myGrid_load();"/>
								<label for="" class="radio_label">경력사항</label>
							<input type="radio" class="radio" value="degree" id="trgetOutput_Degree" name="trgetOutput" onchange="javascript:myGrid_load();"/>
								<label for="" class="radio_label">취득학위</label>
							<input type="radio" class="radio" value="award" id="trgetOutput_Award" name="trgetOutput" onchange="javascript:myGrid_load();"/>
								<label for="" class="radio_label">수상사항</label>
							<input type="radio" class="radio" value="license" id="trgetOutput_License" name="trgetOutput" onchange="javascript:myGrid_load();"/>
								<label for="" class="radio_label">자격사항</label>
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