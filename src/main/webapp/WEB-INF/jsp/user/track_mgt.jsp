<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../pageInit.jsp" %>
<html>
<head>
	<title>Researcher Management</title>
<style type="text/css">
.dhxtabbar_base_dhx_terrace div.dhx_cell_tabbar div.dhx_cell_cont_tabbar {border-left:0px solid #ccc;border-right:0px solid #ccc;border-bottom:0px solid #ccc;}
</style>
<script type="text/javascript" src="${contextPath}/js/mainLayout.js"></script>
<script type="text/javascript">

	var dhxLayout, userLayout, adminLayout, trackGrid, trackFormLayout, trackForm, trackModalBox;
	var dhxTab;
	var trackUserGrid, trackUserToolbar, trackAdminGrid, trackUserDp, trackAdminToolbar, userGrid, userToolbar, adminGrid, adminToolbar;

	$(function() {
		if (window.attachEvent) window.attachEvent("onresize",resizeLayout);
		else  window.addEventListener("resize",resizeLayout, false);

		//set layout
		dhxLayout = new dhtmlXLayoutObject({
			parent: "mainLayout",
			pattern: "2U",
			cells:[
			       	{id:'a', text:'Track목록', width:400, fix_size:[true,null]},
			       	{id:'b', text:''}
			      ]
		});
		//dhxLayout.cells("a").hideHeader();
		dhxLayout.setSizes(false);


		dhxTab = dhxLayout.cells('b').attachTabbar({
			tabs:[
			      {id:'a1', text:'Track연구자', active:true},
			      {id:'a2', text:'Track관리자'},
			]
		});

		dhxTab.setArrowsMode("auto");
		dhxTab.enableAutoReSize(true)

		userLayout = dhxTab.tabs('a1').attachLayout('2U');
		userLayout.cells("a").setText("Track 연구자");
		userLayout.cells("b").setText("연구자목록");

		adminLayout = dhxTab.tabs('a2').attachLayout('2U');
		adminLayout.cells("a").setText("Track 관리자");
		adminLayout.cells("b").setText("관리자목록");

		attachTrackGrid();
		attachTrackUserGrid();
		attachUserGrid();
		attachTrackAdminGrid();
		attachAdminUserGrid();
	});

	function attachAdminUserGrid(){
		adminToolbar = adminLayout.cells("b").attachToolbar();
		adminToolbar.setIconsPath("${dhtmlXImagePath}/icons_${sysConf['dhtmlx.skin']}/");
		adminToolbar.setIconSize(18);
		adminToolbar.setAlign("right");
		adminToolbar.addButton("add", 1, "추가", "new.gif", "new_dis.gif");

		adminToolbar.attachEvent("onClick",function(id){
			if(id = 'add')
			{
				var rowId = adminGrid.getSelectedRowId();
				if(rowId == null)
				{
					dhtmlx.alert('Track에 추가할 관리자를 선택하세요.');
					return false;
				}
				setAdminValue();
				// 트랙관리자를 등록하고
				$.post('${contextPath}/auth/track/addTrackAdmin.do',$('#adminFormArea').serializeArray(),null,'json').done(function(data){
					// 관리자 Grid에 추가하고
					if(data.authorId != '')
					{
						var rowId = $('#adminFormArea input[name="userId"]').val() + "_" + data.authorId;
						var exist =  trackAdminGrid.doesRowExist(rowId);
						if(exist)
						{
							trackAdminGrid.selectRowById(rowId)
						}
						else
						{
							var data = (trackAdminGrid.getRowsNum()+1) +","+ $('#adminFormArea input[name="userId"]').val() + "," + $('#adminFormArea input[name="korNm"]').val() + "," + $('#adminFormArea input[name="psitnDeptNm"]').val() + ",";
							trackAdminGrid.addRow(rowId,data);
							trackAdminGrid.clearChangedState();
						}
					}
					// 권한상세 팝업 실행함.
				});
				/*
				var sIds = new Array();
				var selectedIds = adminGrid.getSelectedRowId();
				sIds = selectedIds.split(',');
				for(var i=0; i < sIds.length; i++)
				{
					var toRowId = trackAdminGrid.getRowId(trackAdminGrid.getRowsNum - 1);
					adminGrid.moveRowTo(sIds[i],toRowId,"move","sibling",adminGrid, trackAdminGrid);
				}
				*/
			}
		});

		var adminFilterHeader = new Array();
		adminFilterHeader.push('');
		adminFilterHeader.push('<input type="text" class="fheader" name="srchUserId" id="adminUserId" onkeyup="javascript:adminGrid_load();" style="width:85%"/>');
		adminFilterHeader.push('<input type="text" class="fheader" name="korNm" id="adminKorNm" onkeyup="javascript:adminGrid_load();" style="width:85%"/>');
		adminFilterHeader.push('<input type="text" class="fheader" name="engNm" id="adminEngNm" onkeyup="javascript:adminGrid_load();" style="width:85%"/>');
		adminFilterHeader.push('<input type="text" class="fheader" name="deptKor" id="adminDeptKor" onkeyup="javascript:adminGrid_load()" style="width:85%"/>');


		adminGrid = adminLayout.cells("b").attachGrid();
		adminGrid.setImagePath("${dhtmlXImagePath}");

		adminGrid.setHeader("번호,사번,성명(한글),성명(영문),소속,RID,KRI연구자번호,임용일자,E-mail,직급1,직급2,재직,연락처,UID,학번",null,grid_head_center_bold);
		adminGrid.attachHeader(adminFilterHeader,grid_head_center_bold);
		adminGrid.setColumnIds("no,userId,korNm,engNm,deptKor,ridWos,rschrRegNo,aptmDate,emalAddr,grade1,grade2,hldofYn,ofcTelno,userIdntfr,stdntNo");
		adminGrid.setInitWidths("50,80,100,120,*,1,1,1,100,80,1,1,1,1,1");
		adminGrid.setColAlign("center,center,center,center,left,center,center,center,left,center,center,center,left,left,left");
		adminGrid.setColTypes("ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro");
		adminGrid.setColSorting("na,str,str,str,str,str,str,str,str,str,str,na,na,na,na");
		adminGrid.setColumnHidden(adminGrid.getColIndexById("ridWos"),true);
		adminGrid.setColumnHidden(adminGrid.getColIndexById("rschrRegNo"),true);
		adminGrid.setColumnHidden(adminGrid.getColIndexById("aptmDate"),true);
		adminGrid.setColumnHidden(adminGrid.getColIndexById("grade2"),true);
		adminGrid.setColumnHidden(adminGrid.getColIndexById("hldofYn"),true);
		adminGrid.setColumnHidden(adminGrid.getColIndexById("ofcTelno"),true);
		adminGrid.setColumnHidden(adminGrid.getColIndexById("userIdntfr"),true);
		adminGrid.setColumnHidden(adminGrid.getColIndexById("stdntNo"),true);
		adminGrid.attachEvent("onBeforeSorting", adminGrid_onBeforeSorting);
		adminGrid.attachEvent("onRowSelect",adminGrid_onRowSelect);
		adminGrid.enableDragAndDrop(true);
		//adminGrid.enableMultiselect(true);
		adminGrid.setColumnHidden(0,true);
		adminGrid.attachEvent("onHeaderClick", function(ind,obj){
		  var targetType = $(obj.target).attr('type');
		  if(targetType == 'text') return false;
		  else return true;
		});
		adminGrid.init();
		adminGrid.enableSmartRendering(true,50);
		adminGrid.setAwaitedRowHeight(26);

		if(browserType() == 'C'){
			var adminGridUID = "cgrid2_" + (adminGrid.uid() - 1);
		    $('#' + adminGridUID + " .xhdr table tr").last().find('td').eq(0).css('display','none');
		}

	}

	function adminGrid_onBeforeSorting(ind,type,direct){
		var url = getFindAdminListUrl();
		adminGrid.clearAndLoad(url+"&orderby="+(userGrid.getColumnId(ind))+"&direct="+direct);
		adminGrid.setSortImgState(true,ind,direct);
		return false;
	}

	function adminGrid_onRowSelect(rowId, ind){
		$('.fheader').blur();
	}

	function adminGrid_load(){
		adminGrid.clearAndLoad(getFindAdminListUrl(),function(){});
	}

	function getFindAdminListUrl(){
		var selectedTrackRowId = trackGrid.getSelectedRowId();
		var cIndex_trackId = trackGrid.getColIndexById("trackId");
		var selectedTrackId = trackGrid.cells(selectedTrackRowId, cIndex_trackId).getValue();

		var url = "${contextPath}/erpUser/findUserList.do?trackId="+selectedTrackId;
		if($('#adminKorNm').val() != '') url += "&korNm="+encodeURIComponent($('#adminKorNm').val());
		if($('#adminEngNm').val() != '') url += "&engNm="+encodeURIComponent($('#adminEngNm').val());
		if($('#adminDeptKor').val() != '') url += "&deptKor="+encodeURIComponent($('#adminDeptKor').val());
		if($('#adminUserId').val() != '') url += "&userId="+encodeURIComponent($('#adminUserId').val());
		return url;
	}

	function setAdminValue(){

		$('#adminFormArea').empty();

		var rowId = adminGrid.getSelectedRowId();
		var cIndex_userId = adminGrid.getColIndexById("userId");
		var cIndex_korNm = adminGrid.getColIndexById("korNm");
		var cIndex_engNm = adminGrid.getColIndexById("engNm");
		var cIndex_deptKor = adminGrid.getColIndexById("deptKor");
		var cIndex_telNo = adminGrid.getColIndexById("ofcTelno");
		var cIndex_emalAddr = adminGrid.getColIndexById("emalAddr");
		var cIndex_uId = adminGrid.getColIndexById("userIdntfr");

		$('#adminFormArea').append($('<input text="hidden" name="userId" value="'+adminGrid.cells(rowId, cIndex_userId).getValue()+'" />'));
		$('#adminFormArea').append($('<input text="hidden" name="korNm" value="'+adminGrid.cells(rowId, cIndex_korNm).getValue()+'" />'));
		$('#adminFormArea').append($('<input text="hidden" name="engNm" value="'+adminGrid.cells(rowId, cIndex_engNm).getValue()+'" />'));
		$('#adminFormArea').append($('<input text="hidden" name="psitnDeptNm" value="'+adminGrid.cells(rowId, cIndex_deptKor).getValue()+'" />'));
		$('#adminFormArea').append($('<input text="hidden" name="telno" value="'+adminGrid.cells(rowId, cIndex_telNo).getValue()+'" />'));
		$('#adminFormArea').append($('<input text="hidden" name="emailAdres" value="'+adminGrid.cells(rowId, cIndex_emalAddr).getValue()+'" />'));

		var trackRowId = trackGrid.getSelectedRowId();
		var cIndex_trackId = trackGrid.getColIndexById("trackId");
		var cIndex_trackNm = trackGrid.getColIndexById("trackName");

		$('#adminFormArea').append($('<input text="hidden" name="adminDvsCd" value="T" />'));
		$('#adminFormArea').append($('<input text="hidden" name="workTrget" value="'+trackGrid.cells(trackRowId, cIndex_trackId).getValue()+'" />'));
		$('#adminFormArea').append($('<input text="hidden" name="workTrgetNm" value="'+trackGrid.cells(trackRowId, cIndex_trackNm).getValue()+'" />'));
	}

	function attachUserGrid(){

		userToolbar = userLayout.cells("b").attachToolbar();
		userToolbar.setIconsPath("${dhtmlXImagePath}/icons_${sysConf['dhtmlx.skin']}/");
		userToolbar.setIconSize(18);
		userToolbar.setAlign("right");
		userToolbar.addButton("add", 1, "추가", "new.gif", "new_dis.gif");

		userToolbar.attachEvent("onClick",function(id){
			if(id = 'add')
			{
				if(userGrid.getSelectedRowId() == null)
				{
					dhtmlx.alert('Track에 추가할 연구자를 선택하세요.');
					return false;
				}
				var sIds = new Array();
				var selectedIds = userGrid.getSelectedRowId();
				sIds = selectedIds.split(',');
				for(var i=0; i < sIds.length; i++)
				{
					var toRowId = trackUserGrid.getRowId(trackUserGrid.getRowsNum - 1);
					userGrid.moveRowTo(sIds[i],toRowId,"move","sibling",userGrid, trackUserGrid);
				}
			}
		});


		var filterHeader = new Array();
		filterHeader.push('');
		filterHeader.push('<input type="text" class="fheader" name="srchUserId" id="userId" onkeyup="javascript:userGrid_load();" style="width:85%"/>');
		filterHeader.push('<input type="text" class="fheader" name="korNm" id="korNm" onkeyup="javascript:userGrid_load();" style="width:85%"/>');
		filterHeader.push('<input type="text" class="fheader" name="deptKor" id="deptKor" onkeyup="javascript:userGrid_load()" style="width:85%"/>');

		userGrid = userLayout.cells("b").attachGrid();
		userGrid.setImagePath("${dhtmlXImagePath}");
		userGrid.setHeader("No,개인번호,이름,소속", null, grid_head_center_bold);
		userGrid.attachHeader(filterHeader,grid_head_center_bold);
		userGrid.setColumnIds("no,userId,korNm,deptKor");
		userGrid.setInitWidths("40,100,120,*");
		userGrid.setColAlign("center,center,center,left");
		userGrid.setColSorting("na,str,str,str");
		userGrid.setColTypes("ro,ro,ro,ro");
		userGrid.attachEvent("onBeforeSorting", userGrid_onBeforeSorting);
		userGrid.attachEvent("onRowSelect",userGrid_onRowSelect);
		userGrid.enableDragAndDrop(true);
		userGrid.enableMultiselect(true);
		userGrid.setColumnHidden(0,true);
		userGrid.attachEvent("onHeaderClick", function(ind,obj){
		  var targetType = $(obj.target).attr('type');
		  if(targetType == 'text') return false;
		  else return true;
		});
		userGrid.init();
		userGrid.enableSmartRendering(true,50);
		userGrid.setAwaitedRowHeight(26);

		if(browserType() == 'C'){
			var userGridUID = "cgrid2_" + (userGrid.uid() - 1);
		    $('#' + userGridUID + " .xhdr table tr").last().find('td').eq(0).css('display','none');
		}
	}

	function userGrid_onBeforeSorting(ind,type,direct){
		var url = getFindResearcherListUrl();
		userGrid.clearAndLoad(url+"&orderby="+(userGrid.getColumnId(ind))+"&direct="+direct);
		userGrid.setSortImgState(true,ind,direct);
		return false;
	}

	function userGrid_onRowSelect(rowId, ind){
		$('.fheader').blur();
	}

	function userGrid_load(){
		userGrid.clearAndLoad(getFindResearcherListUrl(),function(){});
	}

	function getFindResearcherListUrl(){
		var selectedTrackRowId = trackGrid.getSelectedRowId();
		var cIndex_trackId = trackGrid.getColIndexById("trackId");
		var selectedTrackId = trackGrid.cells(selectedTrackRowId, cIndex_trackId).getValue();
		var url = "${contextPath}/auth/track/findResearcherList.do?gubun=M&trackId="+selectedTrackId;
		if($('#korNm').val() != '') url += "&korNm="+encodeURIComponent($('#korNm').val());
		if($('#deptKor').val() != '') url += "&deptKor="+encodeURIComponent($('#deptKor').val());
		if($('#userId').val() != '') url += "&userId="+encodeURIComponent($('#userId').val());
		return url;
	}

	function attachTrackUserGrid(){
		trackUserToolbar = userLayout.cells("a").attachToolbar();
		trackUserToolbar.setIconsPath("${dhtmlXImagePath}/icons_${sysConf['dhtmlx.skin']}/");
		trackUserToolbar.setIconSize(18);
		trackUserToolbar.setAlign("right");
		trackUserToolbar.addButton("save", 1, "저장", "save.gif", "save.gif");
		trackUserToolbar.addButton("delete", 2, "삭제", "del.png", "del.png");
		trackUserToolbar.attachEvent("onClick",function(id){
			if(id == 'save')
			{
				var changedIds = trackUserGrid.getChangedRows();
				if(changedIds == null || changedIds.length < 1)
				{
					dhtmlx.alert('변경된 사항이 없습니다.');
					return false;
				}
				else
				{
					trackUserDp.sendData();
				}
			}
			else if(id == 'delete')
			{

				if(trackUserGrid.getSelectedRowId() == null)
				{
					dhtmlx.alert('삭제할 Track 연구자를 선택하세요.');
					return false;
				}

				dhtmlx.confirm({
					type:"confirm-warning",
					title:"Track 연구자 삭제",
					text:"선택하신 Track 연구자를 삭제하시겠습니까?",
					ok:"삭제", cancel:"취소",
					callback:function(result){
						if(result == true){
							trackUserGrid.deleteSelectedRows();
							trackUserDp.sendData();
						}
					}
				});
			}
		});

		trackUserGrid = userLayout.cells("a").attachGrid();
		trackUserGrid.setImagePath("${dhtmlXImagePath}");
		trackUserGrid.setHeader("No,개인번호,이름,소속",null,grid_head_center_bold);
		trackUserGrid.setColumnIds("no,userId,userName,dept");
		trackUserGrid.setInitWidths("40,100,130,*");
		trackUserGrid.setColAlign("center,center,center,left");
		trackUserGrid.setColTypes("ro,ro,ro,ro");
		trackUserGrid.setColSorting("na,str,str,str");
		trackUserGrid.enableColSpan(true);
		trackUserGrid.enableMultiselect(true);
		trackUserGrid.enableDragAndDrop(true);
		trackUserGrid.init();

		trackUserDp = new dataProcessor("${contextPath}/auth/track/updateTrackUser.do");
		trackUserDp.init(trackUserGrid);
		trackUserDp.setTransactionMode("POST",false);
		trackUserDp.setUpdateMode("off");
		trackUserDp.enableDataNames(true);
		trackUserDp.attachEvent("onFullSync",function(){
			var rowId = trackGrid.getSelectedRowId();
			trackUserGrid.clearAndLoad("${contextPath}/auth/track/findTrackUserList.do?trackId="+rowId, function(){
				var userCount = trackUserGrid.getRowsNum();
				var cIndex_trackUser = trackGrid.getColIndexById("trackUser");
				trackGrid.cells(rowId, cIndex_trackUser).setValue(userCount);
			});
		});

	}

	function attachTrackAdminGrid(){
		trackAdminToolbar = adminLayout.cells("a").attachToolbar();
		trackAdminToolbar.setIconsPath("${dhtmlXImagePath}/icons_${sysConf['dhtmlx.skin']}/");
		trackAdminToolbar.setIconSize(18);
		trackAdminToolbar.setAlign("right");
		//trackAdminToolbar.addButton("save", 1, "저장", "save.gif", "save.gif");
		trackAdminToolbar.addButton("delete", 2, "삭제", "del.png", "del.png");

		trackAdminToolbar.attachEvent("onClick",function(id){
			if(id == 'save')
			{
				var changedIds = trackAdminGrid.getChangedRows();
				if(changedIds == null || changedIds.length < 1)
				{
					dhtmlx.alert('변경된 사항이 없습니다.');
					return false;
				}
				else
				{
					trackAdminDp.sendData();
				}
			}
			else if(id == 'delete')
			{

				if(trackAdminGrid.getSelectedRowId() == null)
				{
					dhtmlx.alert('삭제할 Track 관리자를 선택하세요.');
					return false;
				}

				dhtmlx.confirm({
					type:"confirm-warning",
					title:"Track 관리자 삭제",
					text:"선택하신 Track 관리자를 삭제하시겠습니까?",
					ok:"삭제", cancel:"취소",
					callback:function(result){
						if(result == true){
							trackAdminGrid.deleteSelectedRows();
							trackAdminDp.sendData();
						}
					}
				});
			}
		});

		trackAdminGrid = adminLayout.cells("a").attachGrid();
		trackAdminGrid.setImagePath("${dhtmlXImagePath}");
		trackAdminGrid.setHeader("No,개인번호,이름,소속,권한",null,grid_head_center_bold);
		trackAdminGrid.setColumnIds("no,userId,userName,psitnDeptNm,grade");
		trackAdminGrid.setInitWidths("40,100,130,*,100");
		trackAdminGrid.setColAlign("center,center,center,left,center");
		trackAdminGrid.setColTypes("ro,ro,ro,ro,co");
		trackAdminGrid.setColSorting("na,str,str,str,str");
		trackAdminGrid.enableColSpan(true);
		trackAdminGrid.enableDragAndDrop(true);
		trackAdminGrid.enableMultiselect(true);
		trackAdminGrid.setColumnHidden(4,true);
		trackAdminGrid.attachEvent("onRowDblClicked",trackAdminGrid_onRowSelect);
		trackAdminGrid.init();

		trackAdminDp = new dataProcessor("${contextPath}/member/authCUD.do");
		trackAdminDp.init(trackAdminGrid);
		trackAdminDp.setTransactionMode("POST",false);
		trackAdminDp.setUpdateMode("off");
		trackAdminDp.enableDataNames(true);
		trackAdminDp.attachEvent("onFullSync",function(){
			var rowId = trackGrid.getSelectedRowId();
			trackAdminGrid.clearAndLoad("${contextPath}/auth/track/findTrackAdminList.do?trackId="+rowId, function(){
				/*
				var userCount = trackUserGrid.getRowsNum();
				var cIndex_trackUser = trackGrid.getColIndexById("trackUser");
				trackGrid.cells(rowId, cIndex_trackUser).setValue(userCount);
				*/
			});
		});

	}

	function trackAdminGrid_onRowSelect(rowID,celInd){
		if(rowID == '0') return;

		var wWidth = 970;
		var wHeight = 822;
		var leftPos = (screenWidth - wWidth)/2;
		var topPos = (screenHeight - wHeight)/2;

		var str = rowID.split('_');
		var mappingPopup = window.open('about:blank', 'updateAuthorityPopup', 'width='+wWidth+'px,height='+wHeight+'px,top='+topPos+',left='+leftPos+' location=no,scrollbars=yes,resizable=yes');
		var popFrm = $('#popFrm');
		popFrm.empty();
		popFrm.append($('<input type="hidden" name="trgetUserId" value="'+str[0]+'"/>'));
		popFrm.append($('<input type="hidden" name="trgetAuthorId" value="'+str[1]+'"/>'));
		popFrm.append($('<input type="hidden" name="mode" value="update"/>'));
		popFrm.attr('action', '${contextPath}/member/authorPopup.do');
		popFrm.attr('target', 'updateAuthorityPopup');
		popFrm.attr('method', 'POST');
		popFrm.submit();
		mappingPopup.focus();
	}

	function attachTrackGrid(){
		trackGrid = dhxLayout.cells("a").attachGrid();
		trackGrid.setImagePath("${dhtmlXImagePath}");
		trackGrid.setHeader("No,TrackId,Track명,등록일자,Track인원",null,grid_head_center_bold);
		trackGrid.setColumnIds("no,trackId,trackName,regDate,trackUser");
		trackGrid.setInitWidths("50,50,*,100,100");
		//trackGrid.setColumnMinWidth("40,80,150,200,170,110,110,110,170,100,100,70");
		trackGrid.setColAlign("center,center,left,center,center");
		trackGrid.setColTypes("ro,ro,ro,ro,ro");
		trackGrid.setColSorting("na,na,str,str,str");
		trackGrid.enableColSpan(true);
		trackGrid.attachEvent("onRowSelect",trackGrid_onRowSelect);
		trackGrid.attachEvent("onRowDblClicked",doOnRowDblClicked);
		trackGrid.attachEvent("onBeforeSorting", trackGrid_onBeforeSorting);
		trackGrid.attachEvent("onPageChanged",doBeforeGridLoad);
		trackGrid.attachEvent("onPaging",doOnGridLoaded);
		trackGrid.enablePaging(true,100,10,"pagingArea",true);
		trackGrid.setPagingSkin("${dhtmlXPagingSkin}");
		trackGrid.setColumnHidden(1,true);
		trackGrid.init();
		trackGrid_load();
	}

	function trackGrid_onRowSelect(rowId,cellInd){
		var cIndex_trackName = trackGrid.getColIndexById("trackName");
		var trackName = trackGrid.cells(rowId, cIndex_trackName).getValue();
		//var trackUserUrl = "${contextPath}/auth/track/findTrackUserList.do?trackId="+rowId;
		trackUserGrid.clearAndLoad("${contextPath}/auth/track/findTrackUserList.do?trackId="+rowId, function(){});
		userLayout.cells("a").setText("Track 연구자 [ " + trackName + " ]");

		//var trackAdminUrl = "${contextPath}/auth/track/findTrackAdminList.do?trackId="+rowId;
		trackAdminGrid.clearAndLoad("${contextPath}/auth/track/findTrackAdminList.do?trackId="+rowId, function(){});
		adminLayout.cells("a").setText("Track 관리자 [ " + trackName + " ]");

		userGrid_load();
		adminGrid_load();
	}

	function trackGrid_load(){
		doBeforeGridLoad();
		var url = getGridRequestURL();
		trackGrid.clearAndLoad(url, doOnGridLoaded);
	}

	function trackGrid_onBeforeSorting(ind,type,direct){
		var url = getGridRequestURL();
		trackGrid.clearAndLoad(url+"&orderby="+(trackGrid.getColumnId(ind))+"&direct="+direct);
		trackGrid.setSortImgState(true,ind,direct);
		return false;
	}

	function getGridRequestURL(){
		var url = "${contextPath}/auth/track/findTrackList.do";
		url += "?"+$('#formArea').serialize();
		return url;
	}

	function doOnRowDblClicked(id){
		trackModalBox = dhtmlx.modalbox({
			title: 'Track 수정',
		    text: '<div id="trackEditForm" style="width: 450px; height: 65px;"></div>',
		    width: '472px',
		    buttons:["저장", "취소"]
		});

		trackFormLayout = new dhtmlXLayoutObject({
			parent: 'trackEditForm',
			pattern: '1C',
			skin: '${dhtmlXSkin}',
			cells: [{ id: 'a', header: false }]
		});

		$.ajax({ url: '${contextPath}/auth/track/update.do?trackId=' + id, dataType: 'json' }).done(function(data) {
			trackForm = trackFormLayout.cells('a').attachForm([
	    			{type: 'settings', position: 'label-left', labelWidth: 100, inputWidth: 300},
    			{type: 'block', inputWidth: 'auto', offsetTop: 10, list: [
 					{type: 'hidden', label: '트랙ID', name: 'trackId', value: data.track.trackId, validate: "NotEmpty", required: true},
 					{type: 'input', label: '트랙명', name: 'trackName', value: data.track.trackName, validate: "NotEmpty", required: true}
 		   		]}
	     	]);
			$('input[name="trackName"]').focus();
		});

		$('.dhtmlx_popup_button').on('click', function(e) {
			if($(this).text() == '취소') return true;
			else {
				if(confirm('수정 하시겠습니까?')) {
					trackForm.validate();
					trackForm.send("${contextPath}/auth/track/update.do", function(loader, response) {
						dhtmlx.modalbox.hide(trackModalBox);
						trackGrid_load();
						dhtmlx.alert('수정 되었습니다.');
					});
				}
				return false;
			}
		});

	}

	function addTrack(){
		trackModalBox = dhtmlx.modalbox({
			title: 'Track 추가',
		    text: '<div id="trackEditForm" style="width: 450px; height: 65px;"></div>',
		    width: '472px',
		    buttons:["저장", "취소"]
		});

		trackFormLayout = new dhtmlXLayoutObject({
			parent: 'trackEditForm',
			pattern: '1C',
			skin: '${dhtmlXSkin}',
			cells: [{ id: 'a', header: false }]
		});

		$.ajax({ url: '${contextPath}/auth/track/add.do?', dataType: 'json' }).done(function(data) {
			trackForm = trackFormLayout.cells('a').attachForm([
	    			{type: 'settings', position: 'label-left', labelWidth: 100, inputWidth: 300},
    			{type: 'block', inputWidth: 'auto', offsetTop: 10, list: [
 					{type: 'input', label: '트랙명', name: 'trackName', value: '', validate: "NotEmpty", required: true}
 		   		]}
	     	]);
			$('input[name="trackName"]').focus();

		});

		$('.dhtmlx_popup_button').on('click', function(e) {
			if($(this).text() == '취소') return true;
			else {
				if(confirm('추가 하시겠습니까?')) {
					trackForm.validate();
					trackForm.send("${contextPath}/auth/track/add.do", function(loader, response) {
						dhtmlx.modalbox.hide(trackModalBox);
						trackGrid_load();
						dhtmlx.alert('추가 되었습니다.');
					});
				}
				return false;
			}
		});

	}

function doBeforeGridLoad(){dhxLayout.cells("a").progressOn();}
function doOnGridLoaded(){
		setTimeout(function() {
								dhxLayout.cells("a").progressOff();
								trackGrid.selectRow(0, true);
		}, 100);

}
function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){ dhxLayout.setSizes(false); },200);}
	</script>
</head>
<body>
	<!-- Page Title -->
	<div class="title_box">
		<h3><spring:message code='menu.track'/></h3>
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
						<th>Track명</th>
						<td><input type="text" name="trackName" class="typeText" style="width:100%;"/></td>
						<th>관리자 이름</th>
						<td><input type="text" name="adminName" class="typeText" style="width:100%;"/></td>
						<td rowspan="2" class="option_search_td" onclick="javascript: myGrid_load();"><em>search</em></td>
					</tr>
					<tr>
						<th>소속연구자성명</th>
						<td><input type="text" name="userName" class="typeText" style="width:100%;"/></td>
						<th>소속학(부)과명</th>
						<td><input type="text" name="deptName" class="typeText" style="width:100%;"/></td>
					</tr>
				</table>
			</form>
		</div>

		<div class="list_bt_area">
			<div class="list_set">
				<ul>
					<li><a href="#" onclick="javascript:addTrack();" class="list_icon20">Track추가</a></li>
					<li><a href="#" onclick="javascript:toExcel();" class="list_icon20">엑셀</a></li>
				</ul>
			</div>
		</div>

		<div id="mainLayout" style="position: relative; width: 100%;height: 100%;"></div>
		<script type="text/javascript">setMainLayoutHeight($('#mainLayout'));</script>
		<div id="pagingObj" style="z-index: 1; height: 60px; margin-top: 5px;" >
			<div id="pagingArea" style="z-index: 1;"></div>
		</div>
</div>
	<form id="findItem" action="${contextPath}/main/main.do" method="post" target="item">
		<input type="hidden" id="userId" name="srchUserId" value=""/>
		<input type="hidden" id="item_id" name="item_id" value=""/>
	</form>
	<form id="addTrack" action="${contextPath}/auth/track/addTrack.do" method="post" target="item"></form>
	<form id="adminFormArea"></form>
</body>
</html>