<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../pageInit.jsp" %>
<html>
<head>
	<title>Researcher Management</title>
	<script type="text/javascript" src="${contextPath}/js/mainLayout.js"></script>
	<style type="text/css">
		.dhxwins_vp_dhx_terrace {overflow-y: auto; }
		div#winVp {position: inherit; height: 100%;}
	</style>
	<script type="text/javascript">

		var dhxLayout, userFormLayout, userForm, userModalBox, myGrid, t;

		$(function() {

			if (window.attachEvent) window.attachEvent("onresize",resizeLayout);
			else  window.addEventListener("resize",resizeLayout, false);

			//set layout
			dhxLayout = new dhtmlXLayoutObject("mainLayout","1C");
			dhxLayout.cells("a").hideHeader();
			dhxLayout.setSizes(false);

			//attach mymyGrid
			myGrid = dhxLayout.cells("a").attachGrid();
			myGrid.setImagePath("${dhtmlXImagePath}");

			<c:if test="${r2Conf['usr.rims.info.lab'] eq '3' }">
				myGrid.setHeader("번호,사번,성명(한글),성명(영문),DEPARTMENT,RID,KRI연구자번호,임용일자,E-mail,직급1,직급2,재직,승인상태(랩)",null,grid_head_center_bold);
				myGrid.setColumnIds("no,userId,korNm,engNm,deptKor,ridWos,rschrRegNo,aptmDate,emalAddr,grade1,grade2,hldofYn,apprDvsCd");
				myGrid.setInitWidths("50,80,150,200,*,110,110,110,170,100,100,70,110");
				myGrid.setColumnMinWidth("40,80,150,200,170,110,110,110,170,100,100,70,110");
				myGrid.setColAlign("center,center,center,center,left,center,center,center,left,center,center,center,center");
				myGrid.setColTypes("ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro");
				myGrid.setColSorting("na,str,str,str,str,str,str,str,str,str,str,na,str");
			</c:if>
			<c:if test="${ empty r2Conf['usr.rims.info.lab'] or r2Conf['usr.rims.info.lab'] ne '3' }">
				myGrid.setHeader("번호,사번,성명(한글),성명(영문),DEPARTMENT,RID,KRI연구자번호,임용일자,E-mail,직급1,직급2,재직",null,grid_head_center_bold);
				myGrid.setColumnIds("no,userId,korNm,engNm,deptKor,ridWos,rschrRegNo,aptmDate,emalAddr,grade1,grade2,hldofYn");
				myGrid.setInitWidths("50,80,150,200,*,110,110,110,170,100,100,70");
				myGrid.setColumnMinWidth("40,80,150,200,170,110,110,110,170,100,100,70");
				myGrid.setColAlign("center,center,center,center,left,center,center,center,left,center,center,center");
				myGrid.setColTypes("ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro");
				myGrid.setColSorting("na,str,str,str,str,str,str,str,str,str,str,na");
			</c:if>

			myGrid.enableColSpan(true);
			myGrid.attachEvent("onRowDblClicked",doOnRowDblClicked);
			myGrid.attachEvent("onBeforeSorting", myGrid_onBeforeSorting);
			myGrid.attachEvent("onXLS", doBeforeGridLoad);
			myGrid.attachEvent("onXLE", doOnGridLoaded);
			myGrid.enablePaging(true,100,10,"pagingArea",true);
			myGrid.setPagingSkin("${dhtmlXPagingSkin}");
			myGrid.splitAt(3);
			myGrid.init();
			myGrid_load();

		});

		function doOnRowDblClicked(id) {
			//window.open('${contextPath}/rchfs/main.do?sessUserId='+id,'_blank');
			$('#movePage').prop('action','${contextPath}/rchfs/main.do');
			$('#movePage').find('#sessUserId').val(id);
			$('#movePage').submit();
		}

/*
		function doOnRowDblClicked(id) {
			fn_userPopup('${contextPath}/user/userPopup.do', id);
		}

		function doOnRowDblClicked(id) {

			userModalBox = dhtmlx.modalbox({
				title: '회원정보 수정',
			    text: '<div id="userEditForm" style="width: 450px; height: 430px;"></div>',
			    width: '472px',
			    buttons:["Ok", "Cancel"]
			});

			userFormLayout = new dhtmlXLayoutObject({
				parent: 'userEditForm',
				pattern: '1C',
				skin: '${dhtmlXSkin}',
				cells: [{ id: 'a', header: false }]
			});

			$.ajax({ url: 'update.do?id=' + id, dataType: 'json' }).done(function(data) {

				// 부서 코드목록
				var userDeptOptions = $(data.userDeptList).map(function(i, obj) {
				    return {text: obj.deptKorNm, value: obj.deptCode, selected: (data.user.deptCode == obj.deptCode)};
				}).get();

				// 재직여부 코드목록
				var hldofYnOptions = $(data.hldofYnList).map(function(i, obj) {
				    return {text: obj.codeDisp, value: obj.codeValue, selected: (data.user.hldofYn == obj.codeValue)};
				}).get();

				userForm = userFormLayout.cells('a').attachForm([
 	    			{type: 'settings', position: 'label-left', labelWidth: 100, inputWidth: 300},
	    			{type: 'block', inputWidth: 'auto', offsetTop: 10, list: [
	 					{type: 'input', label: '사번', name: 'userId', value: data.user.userId, validate: "NotEmpty", required: true, readonly: true, style: 'background: #eee;'},
	 					{type: 'input', label: '성명(한글)', name: 'korNm', value: data.user.korNm},
	 					{type: 'label', className: 'engNmLabel', list: [
		 					{type: 'input', label: '성명(영문)', className: 'firstName', name: 'firstName', value: data.user.firstName, inputWidth: 148},
		 					{type: "newcolumn"},
		 					{type: "input", className: 'lastName', name: 'lastName', value: data.user.lastName, inputWidth: 148}
		 				]},
	 					{type: 'select', label: '학과(부)', name: 'deptCode', options: userDeptOptions},
	 					{type: 'input', label: 'RID', name: 'ridWos', value: data.user.ridWos},
	 					{type: 'input', label: 'KRI연구자번호', name: 'rschrRegNo', value: data.user.rschrRegNo},
	 					{type: 'input', label: '임용일자', name: 'aptmDate', value: data.user.aptmDate},
	 					{type: 'input', label: 'E-mail', name: 'emalAddr', value: data.user.emalAddr},
	 					{type: "select", label: '재직여부', name: 'hldofYn', options: hldofYnOptions},
	 					{type: 'input', label: 'Alias 1', name: 'name1', value: data.user.name1},
	 					{type: 'input', label: 'Alias 2', name: 'name2', value: data.user.name2},
	 					{type: 'input', label: 'Alias 3', name: 'name3', value: data.user.name3}
	 		   		]}
		     	]);

				$('.engNmLabel').next().css({paddingLeft: 0}).prev().remove();
				$('.lastName div:first').css({width: '5px'});
			});

			$('.dhtmlx_popup_button').on('click', function(e) {
				if($(this).text() == 'Cancel') return true;
				else {
					if(confirm('수정 하시겠습니까?')) {
						userForm.validate();
						userForm.send("update.do", function(loader, response) {
							dhtmlx.modalbox.hide(userModalBox);
							myGrid_load();
							dhtmlx.alert('수정 되었습니다.');
						});
					}
					return false;
				}
			});
		}
 */
		function myGrid_load(){
			doBeforeGridLoad();
			var url = getGridRequestURL();
			myGrid.clearAndLoad(url, doOnGridLoaded);
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

			var url = "${contextPath}/auth/user/findAdminUserList.do";
			url = comAppendQueryString(url,"text", encodeURIComponent("${text}"));
			url = comAppendQueryString(url,"appr", encodeURIComponent("${appr}"));
			url += "&"+$('#formArea').serialize();
			return url;
		}

		function toExcel(){
			myGrid.toExcel('${contextPath}/servlet/xlsGenerate.do?file_name=User_List.xls');
		}

		function syncUrpData(){
			var syncUrl = "${contextPath}${sysConf['sync.user.uri']}";
			$.ajax({ url: syncUrl, dataType: 'json' }).done(function(data){
				dhtmlx.alert(data.msg);
			});
		}

		var dhxMailWins, mailWin;
		function sendMailLab(userId){
			var wWidth = 950;
			var wHeight = 850;

			var x = $(window).width() /2 - wWidth /2 + $(window).scrollLeft();
			//var y = $(window).height() /2 - wHeight /2 + $(window).scrollTop();
			var y = 0;
			dhxMailWins = new dhtmlXWindows();
			dhxMailWins.attachViewportTo("winVp");

			mailWin = dhxMailWins.createWindow("w1", x, y, wWidth, wHeight);
			mailWin.setText("Send Mail");
			dhxMailWins.window("w1").setModal(true);
			$(".dhxwins_mcover").css("height",$(".popup_wrap").outerHeight());
			dhxMailWins.window("w1").denyMove();
			mailWin.attachURL(contextpath+"/mail/mailForm.do?rsltSe=LAB&itemId="+userId);
		}

		function unloadDhxMailWins(){
			if(dhxMailWins != null && dhxMailWins.unload != null)
			{
				dhxMailWins.unload();
				dhxMailWins = null;
			}
		}

		function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){ dhxLayout.setSizes(false); },200);}
		function doOnGridLoaded(){setTimeout(function() {dhxLayout.cells("a").progressOff();}, 100);}
		function doBeforeGridLoad(){dhxLayout.cells("a").progressOn();}

	</script>
</head>
<body>
	<!-- Page Title -->
	<div class="title_box">
		<h3><spring:message code='menu.researcher.manage'/></h3>

	</div>

	<!-- Main Content -->
	<div class="contents_box">
		<div id="formObj">
			<form id="formArea">
				<table class="view_tbl mgb_10">
					<colgroup>
						<col style="width: 15%" />
						<col style="width: 35%" />
						<col style="width: 15%" />
						<col />
						<col style="width: 50px;" />
					</colgroup>
					<tr>
						<th>사번</th>
						<td><input type="text" name="identity" class="typeText" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/></td>
						<th>성명</th>
						<td><input type="text" name="userNm" class="typeText" onKeyup="javascript:if(event.keyCode=='13')myGrid_load();"/></td>
						<td rowspan="3" class="option_search_td" onclick="javascript: myGrid_load();"><em>search</em></td>
					</tr>
					<tr>
						<th>재직여부</th>
						<td>
							<input type="radio" class="radio" value="" id="hldofYn" name="hldofYn" onchange="javascript:myGrid_load();"/>
								<label for="hldofYn" class="radio_label">전체</label>
							<input type="radio" class="radio" value="1" id="hldofYn1" name="hldofYn" checked="checked"  onchange="javascript:myGrid_load();"/>
								<label for="hldofYn1" class="radio_label">재직</label>
							<input type="radio" class="radio" value="2" id="hldofYn2" name="hldofYn" onchange="javascript:myGrid_load();"/>
								<label for="hldofYn2" class="radio_label">퇴직</label>
						</td>
						<th>전임여부</th>
						<td>
							<input type="radio" class="radio" value="" id="grade" name="gubun"  onchange="javascript:myGrid_load();"/>
								<label for="grade" class="radio_label">전체</label>
							<input type="radio" class="radio" value="M" id="gradem" name="gubun" checked="checked" onchange="javascript:myGrid_load();"/>
								<label for="gradem" class="radio_label">전임</label>
							<input type="radio" class="radio" value="U" id="gradeu" name="gubun" onchange="javascript:myGrid_load();"/>
								<label for="gradeu" class="radio_label">비전임</label>
						</td>
					</tr>
					<tr>
					 <!--
						<th>구분</td>
						<td>
							<input type="radio" value="" id="gubun" name="gubun" checked="checked"/>
								<label for="" class="radio_label">전체</label>
							<input type="radio" value="M" id="gubun" name="gubun" />
								<label for="" class="radio_label">업적관리연구자</label>
						</td>
						 -->
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
											<c:if test="${not empty dl.deptKor}">
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
						<c:if test="${r2Conf['usr.rims.info.lab'] eq '3' }">
						<th>승인상태(랩)</th>
						<td>
							<input type='radio' class="radio" value=''  id="apprDvsCd" name='apprDvsCd' checked='checked' onchange="javascript:myGrid_load();"/>
							<label for="apprDvsCd" class="radio_label">전체</label>
							<input type='radio' class="radio" value='1' id="apprDvsCd1" name='apprDvsCd' onchange="javascript:myGrid_load();"/>
							<label for="apprDvsCd1" class="radio_label">작성중</label>
							<input type='radio' class="radio" value='2' id="apprDvsCd2" name='apprDvsCd' onchange="javascript:myGrid_load();"/>
							<label for="apprDvsCd2" class="radio_label">승인요청</label>
							<input type='radio' class="radio" value='3' id="apprDvsCd3" name='apprDvsCd' onchange="javascript:myGrid_load();"/>
							<label for="apprDvsCd3" class="radio_label">승인완료</label>
						</td>
						</c:if>
						<c:if test="${ empty r2Conf['usr.rims.info.lab'] or r2Conf['usr.rims.info.lab'] ne '3' }">
							<td></td>
							<td></td>
						</c:if>
					</tr>
					<%--
					<tr>
						<td colspan="4" style="border: 0px;">
							<div style="text-align: right; vertical-align:bottom;  margin-top: 2px;">
								<a href="javascript:toExcel();">
									<img src="${contextPath}/images/<%=language%>/button/btn_excel.gif" border="0" />
								</a>
								<a href="javascript:pdfResume();">
									<img src="${contextPath}/images/<%=language%>/button/btn_user_pdf_down.gif" border="0" />
								</a>
						  	</div>
						</td>
					</tr>
					--%>
				</table>
			</form>
		</div>

		<div class="list_bt_area">
			<div class="list_set">
				<ul>
					<c:if test="${sessionScope.auth.adminDvsCd eq 'M' and not empty sysConf['sync.user.uri'] }">
					<li><a href="#" onclick="javascript:syncUrpData();" class="list_icon18">동기화</a></li>
					</c:if>
					<c:if test="${sessionScope.auth.adminDvsCd eq 'M' and sessionScope.login_user.userId eq '1585'}">
					<li><a href="#" onclick="javascript:toExcel();" class="list_icon20">엑셀</a></li>
					</c:if>
				</ul>
			</div>
		</div>

		<div id="mainLayout" style="position: relative; width: 100%;height: 100%;"></div>
		<script type="text/javascript">setMainLayoutHeight($('#mainLayout'));</script>
		<div id="pagingObj" style="z-index: 1; height: 60px; margin-top: 0px;" >
			<div id="pagingArea" style="z-index: 1;"></div>
		</div>
</div>
<form id="findItem" action="${contextPath}/main/main.do" method="post" target="item">
	<input type="hidden" id="userId" name="srchUserId" value=""/>
	<input type="hidden" id="item_id" name="item_id" value=""/>
</form>
<form id="addUser" action="${contextPath}/auth/user/addForm.do" method="post" target="item"></form>
<form id="movePage"  method="post" target="sessUserPage">
	<input type="hidden" id="sessUserId" name="sessUserId" value=""/>
</form>

<div id="winVp"></div>
</body>
</html>