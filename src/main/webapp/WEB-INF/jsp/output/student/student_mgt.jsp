<%@page import="kr.co.argonet.r2rims.util.LanguageUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="../../pageInit.jsp" %>
<jsp:useBean id="now" class="java.util.Date" />
<fmt:formatDate value="${now}" var="thisYear" pattern="yyyy" />
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

    var header = "번호,사번,교수명,학생번호,학생이름(한글),학생이름(영문),소속학과명,과정구분,학적상태,졸업일자,구분";
    var columnIds = "no,profsrEmpno,profsrNm,stdntNo,stdntNm,stdntFirstNm,deptKor,crseSe,sknrgsStatus,grdtnDate,coachingSe";
    var initWidths = "50,80,80,*,*,*,*,*,*,*,*";
    var colAlign = "center,center,center,center,center,left,left,center,center,center,center";
    var colTypes = "ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro";
    var colSorting = "int,str,str,str,str,str,str,str,str,str,str";

	if(sessMode == 'true' || loginAuthor == 'R' || loginAuthor == 'S')
	{
	    header = "<spring:message code='grid.no'/>,<spring:message code='grid.std1'/>,<spring:message code='grid.std2'/>,<spring:message code='grid.std3'/>,<spring:message code='grid.std4'/>,<spring:message code='grid.std5'/>,<spring:message code='grid.std6'/>,<spring:message code='grid.std7'/>,<spring:message code='grid.std8'/>";
	    columnIds = "no,stdntNo,stdntNm,stdntFirstNm,deptKor,crseSe,sknrgsStatus,grdtnDate,coachingSe";
	    initWidths = "80,*,*,*,*,*,*,*,*";
	    colAlign = "center,center,center,center,left,center,center,center,center";
	    colTypes = "cntr,ro,ro,ro,ro,ro,ro,ro,ro";
	    colSorting = "na,str,str,str,str,str,str,str,str";
	}

	myGrid = dhxLayout.cells("a").attachGrid();
	myGrid.setImagePath("${dhtmlXImagePath}");
    myGrid.setHeader(header,null,grid_head_center_bold);
    myGrid.setColumnIds(columnIds);
    myGrid.setInitWidths(initWidths);
    myGrid.setColAlign(colAlign);
    myGrid.setColTypes(colTypes);
    myGrid.setColSorting(colSorting);
	myGrid.attachEvent("onBeforeSorting", myGrid_onBeforeSorting);
	myGrid.attachEvent("onXLS", doBeforeGridLoad);
	myGrid.attachEvent("onXLE", doOnGridLoaded);
	myGrid.enablePaging(true,100,10,"pagingArea",true);
	myGrid.setPagingSkin("${dhtmlXPagingSkin}");
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
	var url = "${contextPath}/${preUrl}/student/findAdminStudentList.do";
	url = comAppendQueryString(url,"appr",	'<c:out value="${param.appr}"/>');
	url += "&"  + $('#formArea').serialize();
	return url;
}

function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){ setMainLayoutHeight($('#mainLayout')); dhxLayout.setSizes(false); },10);}
function doOnGridLoaded(){setTimeout(function() {dhxLayout.cells("a").progressOff();}, 100);}
function doBeforeGridLoad(){dhxLayout.cells("a").progressOn();}

function fn_export(){
    $('#studentExportDialog #closeBtn').triggerHandler('click');
    var url = "${contextPath}/${preUrl}/student/export.do?"+$('#formArea').serialize()+'&'+$('#studentExportFrm').serialize() ;
    var expAnchor = $('<a class="exp_anchor" href="'+url+'"></a>');
    $("body").append(expAnchor);
    $('a.exp_anchor').bind('click',function(){
           doBeforeGridLoad();
           $.fileDownload($(this).prop('href'),{
                  successCallback: function (url) {
                        doOnGridLoaded();
                        $('a.exp_anchor').remove();
                        //$('#articleExportDialog #closeBtn').triggerHandler('click');
                  },
                  failCallback: function (responseHtml, url) {
                        doOnGridLoaded();
                        $('a.exp_anchor').remove();
                        //$('#articleExportDialog #closeBtn').triggerHandler('click');
         }
           });
    }).trigger('click');
}

</script>
</head>
<body>
	<div class="title_box">
		<h3><spring:message code='menu.student'/></h3>
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
						<td><input type="text" id="srchUserNm" name="srchUserNm"  class="input2" maxlength="20" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/></td>
						<td rowspan="2" class="option_search_td" onclick="javascript:myGrid_load();"><em>search</em></td>
					</tr>
					<tr>
						<th>과정구분</th>
						<td>
						<input type="radio" id="crseSe_all" name="crseSeCode"  value=""  checked="checked" onchange="javascript:myGrid_load();" class="radio"/>
							<label for="crseSe_all" class="radio_label"><spring:message code='search.std3'/></label>
						<input type="radio" id="crseSeCode_1" name="crseSeCode"  value="1" onchange="javascript:myGrid_load();" class="radio"/>
							<label for="crseSeCode_1" class="radio_label"><spring:message code='search.std4'/></label>
						<input type="radio" id="crseSeCode_2" name="crseSeCode"  value="2" onchange="javascript:myGrid_load();" class="radio"/>
							<label for="crseSeCode_2" class="radio_label"><spring:message code='search.std5'/></label>
						<input type="radio" id="crseSeCode_3" name="crseSeCode"  value="3" onchange="javascript:myGrid_load();" class="radio"/>
							<label for="crseSeCode_3" class="radio_label"><spring:message code='search.std6'/></label>
						<input type="radio" id="crseSeCode_4" name="crseSeCode"  value="4" onchange="javascript:myGrid_load();" class="radio"/>
							<label for="crseSeCode_4" class="radio_label"><spring:message code='search.std7'/></label>
						</td>
						<th>졸업년도</th>
						<td>
							<input type="text" id="stt_date" name="sttDate" class="input2"  value="${thisYear-2 }" maxlength="4" style="width: 80px;" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();" />
							~ <input type="text" id="end_date" name="endDate" class="input2" maxlength="4" style="width: 80px;" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/>
						</td>
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
					<th><spring:message code="search.std1" /></th>
					<td>
					<input type="radio" id="crseSe_all" name="crseSeCode"  value=""  checked="checked" onchange="javascript:myGrid_load();" class="radio"/>
						<label for="crseSe_all" class="radio_label"><spring:message code="search.std3" /></label>
					<input type="radio" id="crseSeCode_1" name="crseSeCode"  value="1" onchange="javascript:myGrid_load();" class="radio"/>
						<label for="crseSeCode_1" class="radio_label"><spring:message code="search.std4" /></label>
					<input type="radio" id="crseSeCode_2" name="crseSeCode"  value="2" onchange="javascript:myGrid_load();" class="radio"/>
						<label for="crseSeCode_2" class="radio_label"><spring:message code="search.std5" /></label>
					<input type="radio" id="crseSeCode_3" name="crseSeCode"  value="3" onchange="javascript:myGrid_load();" class="radio"/>
						<label for="crseSeCode_3" class="radio_label"><spring:message code="search.std6" /></label>
					<input type="radio" id="crseSeCode_4" name="crseSeCode"  value="4" onchange="javascript:myGrid_load();" class="radio"/>
						<label for="crseSeCode_4" class="radio_label"><spring:message code="search.std7" /></label>
					</td>
					<th><spring:message code="search.std2" /></th>
					<td>
						<input type="text" id="stt_date" name="sttDate" class="input2"  value="${thisYear-5 }" maxlength="4" style="width: 80px;"  onKeyup="javascript:if(event.keyCode=='13')myGrid_load();" />
						~ <input type="text" id="end_date" name="endDate" class="input2" maxlength="4" style="width: 80px;" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/>
					</td>
					<td class="option_search_td" onclick="javascript:myGrid_load();"><em>search</em></td>
				</tr>
				</tbody>
			</table>
			</c:if>
		</form>
		<div class="list_bt_area">
			<div class="list_set">
				<ul>
                    <c:if test="${sessMode or (sessionScope.auth.adminDvsCd eq 'R' or  sessionScope.auth.adminDvsCd eq 'S' )}">
                       <li><a href="#studentExportDialog" class="modalLink list_icon26">Export</a></li>
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
       <div id="studentExportDialog" class="popup_box modal modal_layer" style="width: 450px;height:170px; display: none;">
       <form id="studentExportFrm">
              <input type="hidden" name="userId" value="${sessionScope.sess_user.userId}" />
              <div class="popup_header">
                     <h3>Alumni Export</h3>
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
                                  <li><a href="javascript:$('#studentExportDialog #closeBtn').triggerHandler('click');" class="list_icon10">Cancel</a></li>
                           </ul>
                     </div>
              </div>
       </form>
       </div>
</c:if>

</body>
</html>