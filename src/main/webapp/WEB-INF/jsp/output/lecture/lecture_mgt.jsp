<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="../../pageInit.jsp" %>
<jsp:useBean id="now" class="java.util.Date" />
<fmt:formatDate value="${now}" var="thisYear" pattern="yyyy" />
<style type="text/css">
div.gridbox_dhx_terrace.gridbox table.hdr td{vertical-align: middle;}
</style>
<script type="text/javascript" src="${contextPath}/js/jquery/jquery.filedownload.js"></script>
<script type="text/javascript" src="${contextPath}/js/mainLayout.js"></script>
<script type="text/javascript">
var dhxLayout, myGrid, t;
$(document).ready(function(){
	bindModalLink();
	setMainLayoutHeight($('#mainLayout'));
	if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
	else  window.addEventListener("resize",resizeLayout, false);

	//set layout
	dhxLayout = new dhtmlXLayoutObject("mainLayout","1C");
	dhxLayout.cells("a").hideHeader();
	dhxLayout.setSizes(false);

	myGrid = dhxLayout.cells("a").attachGrid();
	myGrid.setImagePath("${dhtmlXImagePath}");
	myGrid.setHeader("<spring:message code='grid.no'/>,<spring:message code='grid.lec1'/>,<spring:message code='grid.lec2'/>,<spring:message code='grid.lec3'/>,<spring:message code='grid.lec4'/>,<spring:message code='grid.lec5'/>,<spring:message code='grid.lec6'/>,<spring:message code='grid.lec7'/>,<spring:message code='grid.lec8'/>,<spring:message code='grid.lec9'/>,<spring:message code='grid.lec10'/>,<spring:message code='grid.lec11'/>,<spring:message code='grid.lec12'/>,<spring:message code='grid.lec14'/>,<spring:message code='grid.lec13'/>,<spring:message code='grid.lec15'/>,<spring:message code='grid.lec16'/>",null,grid_head_center_bold);
	myGrid.setColumnIds("no,profsrEmpno,profsrNm,estblYear,estblSemst,estblDeptKor,sbjectSe,sbjectNmKor,sbjectNmEng,lctre,exper,point,atnlcNmpr,sbjectNo,sbjectCode,lctreClass,engLctreAt");
	myGrid.setInitWidths("40,60,70,50,50,100,100,*,*,50,50,50,80,80,80,50,80");
	myGrid.setColAlign("center,center,center,center,center,left,center,left,left,center,center,center,center,center,center,center,center");
	myGrid.setColTypes("ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro");
	myGrid.setColSorting("int,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str");
	myGrid.attachEvent("onBeforeSorting", myGrid_onBeforeSorting);
	myGrid.attachEvent("onXLS", doBeforeGridLoad);
	myGrid.attachEvent("onXLE", doOnGridLoaded);
	myGrid.enablePaging(true,100,10,"pagingArea",true);
	myGrid.setPagingSkin("${dhtmlXPagingSkin}");
	//myGrid.splitAt(8);
	myGrid.enableMultiselect(true);
	myGrid.enableColSpan(true);
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

	var url = "${contextPath}/${preUrl}/lecture/findAdminLectureList.do";
	url = comAppendQueryString(url,"appr",	'<c:out value="${param.appr}"/>');
	url += "&"  + $('#formArea').serialize();
	return url;
}

function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){ setMainLayoutHeight($('#mainLayout')); dhxLayout.setSizes(false); },10);}
function doOnGridLoaded(){setTimeout(function() {dhxLayout.cells("a").progressOff();}, 100);}
function doBeforeGridLoad(){dhxLayout.cells("a").progressOn();}

function fn_export(){
    $('#lectureExportDialog #closeBtn').triggerHandler('click');
    var url = "${contextPath}/${preUrl}/lecture/export.do?"+$('#formArea').serialize()+'&'+$('#lectureExportFrm').serialize() ;
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
</script>
</head>
<body>
	<div class="title_box">
		<h3><spring:message code='menu.lecture'/></h3>
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
						<td>
						    <input type="text" id="srchUserId" name="srchUserId" class="input2" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/>
						</td>
						<th>성명</th>
						<td><input type="text" name="srchUserNm" class="typeText"/></td>
						<td rowspan="2" class="option_search_td" onclick="javascript: myGrid_load();"><em>search</em></td>
					</tr>
					<tr>
						<th>개설년도</th>
						<td>
							<input type="text" name="sttDate" value="${thisYear-2 }" class="typeText" style="width: 100px;"/> ~ <input type="text" name="endDate" class="typeText" style="width: 100px;"/>
						</td>
						<th>과목명</th>
						<td><input type="text" name="sbjectNm" class="typeText"/></td>
					</tr>
				</tbody>
			</table>
			</c:if>
			<c:if test="${sessMode or (sessionScope.auth.adminDvsCd eq 'R' or  sessionScope.auth.adminDvsCd eq 'S' )}">
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
						<th><spring:message code="search.lec1" /></th>
						<td>
							<input type="text" name="sttDate" value="${thisYear-2 }" class="typeText" style="width: 100px;"/> ~ <input type="text" name="endDate" class="typeText" style="width: 100px;"/>
						</td>
						<th><spring:message code="search.lec2" /></th>
						<td><input type="text" name="sbjectNm" class="typeText"/></td>
						<td rowspan="2" class="option_search_td" onclick="javascript: myGrid_load();"><em>search</em></td>
					</tr>
				</tbody>
			</table>
			</c:if>
		</form>
		<div class="list_bt_area">
			<div class="list_set">
				<ul>
                   <c:if test="${sessMode or (sessionScope.auth.adminDvsCd eq 'R' or  sessionScope.auth.adminDvsCd eq 'S' )}">
                      <li><a href="#lectureExportDialog" class="modalLink list_icon26">Export</a></li>
                   </c:if>
				</ul>
			</div>
		</div>
		<!-- layout (grid,paging)  -->
		<div id="mainLayout" style="position: relative; width: 100%;height: 100%;"></div>
		<div id="pagingObj" style="z-index: 1; height: 40px; margin-top: 5px;" >
			<div id="pagingArea" style="z-index: 1;"></div>
		</div>
	</div>
<c:if test="${sessMode or (sessionScope.auth.adminDvsCd eq 'R' or  sessionScope.auth.adminDvsCd eq 'S' )}">
       <div id="lectureExportDialog" class="popup_box modal modal_layer" style="width: 450px;height:170px; display: none;">
       <form id="lectureExportFrm">
              <input type="hidden" name="userId" value="${sessionScope.sess_user.userId}" />
              <div class="popup_header">
                     <h3>Courses Export</h3>
                     <a href="#" id="closeBtn" class="close_bt closeBtn">닫기</a>
              </div>
              <div class="popup_inner">
                     <table class="write_tbl mgb_20">
                           <colgroup>
                                  <col style="width:27%;" />
                                  <col style="width:37%;" />
                                  <col style="width:37%;" />
                           </colgroup>
                           <tbody>
                                  <tr>
                                         <th><spring:message code="exp.fmt" /></th>
                                         <td>
                                            <input type="radio" id="exportFmt_excel" name="exportFmt" value="excel" checked="checked"/>&nbsp;Excel
                                         </td>
                                         <td>
                                            <input type="radio" id="exportFmt_endnote" name="exportFmt" value="rtf"/>&nbsp;RTF (word)
                                         </td>
                                  </tr>
                           </tbody>
                     </table>
                     <div class="list_set">
                           <ul>
                                  <li><a href="javascript:fn_export();" class="list_icon25">Download</a></li>
                                  <li><a href="javascript:$('#lectureExportDialog #closeBtn').triggerHandler('click');" class="list_icon10">Cancel</a></li>
                           </ul>
                     </div>
              </div>
       </form>
       </div>
</c:if>

</body>
</html>