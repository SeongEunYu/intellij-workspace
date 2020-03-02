<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../pageInit.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta http-equiv="cache-Control" content="co-cache" />
	<title>${sysConf['system.rims.jsp.title']}</title>
	<link rel="shortcut icon" href="<c:url value="/images/${sysConf['shortcut.icon']}"/>">
	<link type="text/css" href="${contextPath}/js/dhtmlx/skins/${sysConf['dhtmlx.skin']}/dhtmlx.css" rel="stylesheet" />
	<script type="text/javascript" src="${contextPath}/js/jquery/jquery-1.11.3.min.js"></script>
	<script type="text/javascript" src="${contextPath}/js/dhtmlx/dhtmlx.js"></script>
	<script type="text/javascript" src="${contextPath}/js/script.js"></script>
	<link type="text/css" href="${contextPath}/js/dhtmlx/skins/${sysConf['dhtmlx.skin']}/dhtmlxvault.css" rel="stylesheet" />
	<script type="text/javascript" src="${contextPath}/js/dhtmlx/vault/dhtmlxvault.js"></script>
<style type="text/css">
div#layoutObj {position: relative;margin-top: 20px;width: 100%;}
.sub_basic tr{ height: 21px; }
.sub_basic td { font-size: 12px; padding: 0 5px 0 5px;}
.sub_basic th { background-color: #e8e9ed; font-size: 12px; text-align: center; }
.dhxlayout_base_dhx_terrace div.dhx_cell_layout div.dhx_cell_toolbar_def{ padding: 2px; }
.dhxwins_vp_dhx_terrace {overflow: auto;}
.dhxwins_vp_dhx_terrace div.dhxwin_active div.dhx_cell_wins div.dhx_cell_toolbar_def, .dhxwins_vp_dhx_terrace div.dhxwin_inactive div.dhx_cell_wins div.dhx_cell_toolbar_def { padding: 10px 0px 0; }
.dhx_toolbar_dhx_terrace { padding: 0 0px; }
div.dhxform_item_label_left.button_search div.dhxform_btn {height: 25px; margin: 0px 2px; background-color: #ffffff;}
div.dhxform_item_label_left.button_search div.dhxform_btn_txt {
	top:0;right:0;background: url(${contextPath}/images/background/tbl_search_icon.png) no-repeat 50% 50%;
	text-indent: -9999px;display: block;width: 23px; height: 25px;margin: 0 0px;
}
.alignLeft{text-align: left;}
.alignLeft div.dhxform_txt_label2{font-weight: normal;}
</style>
<script type="text/javascript">

	var colorArr = ['FEA47F', '25CCF7', '55E6C1', 'D6A2E8', '9AECDB' ];
	var dhxLayout, authorGrid, authorToolbar, authorDp, rschGrid, rschToolbar, adresGrid, fileUploadLayout, fileUploadVault, t, authorGridUID;
	var authorNum, roleCombo;
$(document).ready(function(){

		if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
		else  window.addEventListener("resize",resizeLayout, false);

		dhxLayout = new dhtmlXLayoutObject("layoutObj","4J");
		//dhxLayout.cells("a").hideHeader();
		dhxLayout.setSizes(false);
		dhxLayout.cells("a").setText("Article Information");
		dhxLayout.cells("a").setHeight("145");
		dhxLayout.cells("a").appendObject("articleInfoDiv");
		dhxLayout.cells("b").setText("Address");
		dhxLayout.cells("b").setHeight("200");
		dhxLayout.cells("c").setText("Author");
		dhxLayout.cells("c").hideArrow();
		dhxLayout.cells("d").setText("Researcher");
		dhxLayout.cells("d").hideArrow();
		dhxLayout.setAutoSize("a;b;c","c;d");

		loadAddressCellComponent();
		loadAuthorCellComponent();
		loadResearcherCellComponent();

		$('#fileUpload').on('click', function(e) {

			e.preventDefault();

			dhtmlx.modalbox({
				title: '원문파일 업로드',
			    text: '<div id="fileUploadForm" style="width: 450px; height: 380px;"></div>',
			    width: '472px',
			    buttons:['Close']
			});

			fileUploadLayout = new dhtmlXLayoutObject({
				parent: 'fileUploadForm',
				pattern: '1C',
				skin: '${dhtmlXSkin}',
				cells: [{ id: 'a', header: false }]
			});

			fileUploadVault = fileUploadLayout.cells('a').attachVault({
			    container:		'fileUploadForm',
			    swfPath:		'dhxvault.swf',
			    slXap:			'dhxvault.xap',
			    uploadUrl:		'updateFile.do?gubun=ARTICLE&articleId=${articleInfo.articleId}',
			    swfUrl:			'updateFile.do?gubun=ARTICLE&articleId=${articleInfo.articleId}',
			    slUrl:			'updateFile.do?gubun=ARTICLE&articleId=${articleInfo.articleId}',
			    downloadUrl:	'/rims/servlet/download.do?fileid={serverName}', // 다운로드 URL 확인 필요
			    buttonClear:	false
			});

			fileUploadVault.load('findArtclFileList.do?gubun=ARTICLE&articleId=${articleInfo.articleId}');

			fileUploadVault.attachEvent('onBeforeFileRemove', function(file){
				if(confirm('삭제 하시겠습니까?')) {
					$.ajax({
						dataType: 'json',
						url: 'deleteFile.do?fileId=' + file.serverName
					}).done(function(data) {
						if(data.result != 1) {
							alert('원문파일 삭제시 오류가 발생하였습니다.');
						}
					});
					return true;
				}
				else return false;
			});
		});

	});

	function loadAddressCellComponent(){
		dhxLayout.cells("b").progressOn();
		adresGrid = dhxLayout.cells("b").attachGrid();
		adresGrid.setImagePath("${dhtmlXImagePath}");
		adresGrid.setColumnIds("add1,reInst,reDept,add2,add3");
		//adresGrid.attachEvent("onRowSelect",rschGrid_onRowSelect);
		//adresGrid.attachEvent("onXLE", rschGrid_onXLE);
		adresGrid.init();
		adresGrid.load(getAdresGridUrl(),function(){dhxLayout.cells("b").progressOff()});

		adresGrid.attachEvent("onEditCell", function(stage,rId,cInd,nValue,oValue) {
			if(nValue != oValue) {
				$.ajax({
					dataType: 'json',
					method:'POST',
					url: 'updateAddressReInst.do',
					data: {articleId: rId.split('|')[0], adresSeq: rId.split('|')[1], reInst: nValue}
				}).done(function(data) {
					if(data.result != 1) {
						alert('주소정보 변경시 오류가 발생하였습니다.');
					}
					else
					{
						adresGrid.clearAndLoad(getAdresGridUrl(),function(){
							adresGrid.selectRowById(rId);
						});
					}

				});
			}
			return true;
		});
	}

	function getAdresGridUrl(){
		return "${contextPath}/workbench/findAddressList.do?articleId=${param.articleId}&sourcIdntfcNo=${param.sourcIdntfcNo}";
	}

	function loadResearcherCellComponent(){
		//dhxLayout.cells("d").progressOn();
		var filterHeader = new Array();
		filterHeader.push('<input type="text" name="korNm" id="korNm" onkeyup="javascript:runSearch($(this));" style="width:90%"/>');
		filterHeader.push('<input type="text" name="engNm" id="engNm" onkeyup="javascript:runSearch($(this));" style="width:90%"/>');
		filterHeader.push('<input type="text" name="deptKor" id="deptKor" onkeyup="javascript:runSearch($(this));" style="width:90%"/>');
		filterHeader.push('<input type="text" name="aptmDate" id="aptmDate" onkeyup="javascript:runSearch($(this));" style="width:90%"/>');
		filterHeader.push('<input type="text" name="srchUserId" id="userId" onkeyup="javascript:runSearch($(this));" style="width:90%"/>');
		rschToolbar =  dhxLayout.cells("d").attachToolbar({
			icons_path :"${dhtmlXImagePath}/icons_${sysConf['dhtmlx.skin']}/",
			xml: "${contextPath}/dhx_toolbar/researcher_toolbar.xml"
		});
		rschToolbar.setIconSize(18);
		rschToolbar.setAlign("right");
		rschGrid = dhxLayout.cells("d").attachGrid();
		rschGrid.setImagePath("${dhtmlXImagePath}");
		rschGrid.setHeader("Name,Name(Eng),Dept,입사일,ID No.", null, grid_head_center_bold);
		rschGrid.attachHeader(filterHeader,grid_head_center_bold);
		rschGrid.setColumnIds("korNm,engNm,deptKor,aptmDate,userId");
		rschGrid.setInitWidths("*,120,130,80,80");
		rschGrid.setColAlign("left,left,left,center,center");
		rschGrid.setColSorting("na,na,na,na,na");
		rschGrid.setColTypes("ro,ro,ro,ro,ro");
		rschGrid.attachEvent("onRowSelect",rschGrid_onRowSelect);
		rschGrid.attachEvent("onBeforeSorting", rschGrid_onBeforeSorting);
		rschGrid.attachEvent("onXLE", rschGrid_onXLE);
		//rschGrid.enablePaging(true,50,10,"pagingArea",true);
		//rschGrid.objBox.style.overflowY = 'scroll';
		rschGrid.init();
		rschGrid.enableSmartRendering(true,50);
		//rschGrid.enableDistributedParsing(true,100,300);
		rschGrid.setAwaitedRowHeight(26);
		//rschGrid.load("${contextPath}/workbench/findResearcherList.do?gubun=U&flag=");
		rschGrid_load('M','M');
		//rschGrid.load("${contextPath}/workbench/findResearcherList.do?gubun=M&flag=M&articleId=${param.articleId}");
	}

	function rschGrid_onBeforeSorting(ind,type,direct){
		var url = getRschGridRequestURL($('#rsch_gubun').val(), $('#rsch_flag').val());
		rschGrid.clearAndLoad(url+"&orderby="+(rschGrid.getColumnId(ind))+"&direct="+direct);
		rschGrid.setSortImgState(true,ind,direct);
		return false;
	}

	function getRschGridRequestURL(gubun, flag){
		var flagValue = flag == undefined ? '' : flag;
		$('#rsch_gubun').val(gubun);
		$('#rsch_flag').val(flagValue);
		var url = "${contextPath}/workbench/findResearcherList.do?gubun="+gubun;
		url += "&flag="+flagValue+"&articleId=${param.articleId}";
		if($('#korNm').val() != '') url += "&korNm="+encodeURIComponent($('#korNm').val());
		if($('#engNm').val() != '') url += "&engNm="+encodeURIComponent($('#engNm').val());
		if($('#deptKor').val() != '') url += "&deptKor="+encodeURIComponent($('#deptKor').val());
		if($('#aptmDate').val() != '') url += "&aptmDate="+encodeURIComponent($('#aptmDate').val());
		if($('#userId').val() != '') url += "&srchUserId="+encodeURIComponent($('#userId').val());
		return url;
	}

	function rschGrid_load(gubun, flag){
		var gubunValue = gubun == undefined ? 'M' : gubun;
		var flagValue = flag == undefined ? '' : flag;
		var url = getRschGridRequestURL(gubunValue, flagValue);
		rschGrid.clearAndLoad(url);
	}

	function runSearch(input){
		var url = getRschGridRequestURL($('#rsch_gubun').val(),$('#rsch_flag').val());
		//var name = input.prop('name');
		//url += "&"+name+"="+input.val();
		rschGrid.clearAndLoad(url);
	}

	function rschGrid_onRowSelect(rowID,celInd){
		// alert("Selected row ID is "+rowID+"\nUser clicked cell with index "+celInd);
		var rowInd		= rschGrid.getRowIndex(rowID);
		var cellPERName = rschGrid.cellByIndex(rowInd, 0);
		var cellPERno	= rschGrid.cellByIndex(rowInd, 4);
		if (authorGrid.getSelectedId()!=null) {
			var rePernameIndex = authorGrid.getColIndexById("rePername");
			var rePernoIndex = authorGrid.getColIndexById("rePerno");
			var rowInd_AUT		= authorGrid.getRowIndex(authorGrid.getSelectedId());
			var cellAUTName		= authorGrid.cellByIndex(rowInd_AUT,rePernameIndex);
			var cellAUTPerno	= authorGrid.cellByIndex(rowInd_AUT,rePernoIndex);
			cellAUTName.setValue(cellPERName.getValue());
			cellAUTPerno.setValue(cellPERno.getValue());
			authorDp.setUpdated(authorGrid.getSelectedId(),true);
		}else{
			dhtmlx.alert({type:"alert-warning",text:"맵핑할 저자를 선택하세요.",callback:function(){}})
		}
	}

	function rschGrid_onXLE(){
		var strIndex = (rschGrid.currentPage-1) * rschGrid.rowsBufferOutSize;
		var endIndex = ((rschGrid.currentPage) * rschGrid.rowsBufferOutSize)-1;
		endIndex = endIndex < rschGrid.getRowsNum() ? endIndex: rschGrid.getRowsNum()-1;
		for (var i=0; i<=endIndex; i++){ 		// here i - index of the row in the grid
			var rId = rschGrid.getRowId(i); // get row id by its index
			if(rId != undefined){
				var str = rId.toString().split('|'); // regular expression 이 아님에 주의할 것
				aut = str[1];
				rschGrid.setRowColor(rId, colorArr[aut%5]);
			}
		}
		dhxLayout.cells("d").progressOff();
	}

	function onLoadResearcher(id){
		if(id == "s") rschGrid_load('M','M');
		if(id == "m") rschGrid_load('M');
		if(id == "u") rschGrid_load('X');
	}

	var idx = 0;
	function loadAuthorCellComponent(){
		//dhxLayout.cells("c").progressOn();

		authorToolbar = dhxLayout.cells("c").attachToolbar({
			icons_path :"${dhtmlXImagePath}/icons_${sysConf['dhtmlx.skin']}/",
			xml: "${contextPath}/dhx_toolbar/author_toolbar.xml"
		});
		authorToolbar.setIconSize(18);
		authorToolbar.setAlign("right");
		authorGrid = dhxLayout.cells("c").attachGrid();
		authorGrid.setImagePath("${dhtmlXImagePath}");
		authorGrid.setHeader('C,,#,Author(Abbr),Author(Full),Name(R),No.(R),Role',null,grid_head_center_bold);
		authorGrid.setColumnIds("isChk,auuthorsAdres,adresSeq,authrAbrv,authrNm,rePername,rePerno,tpiDvsCd");
		authorGrid.setInitWidths("20,25,20,90,*,80,80");
		authorGrid.setColAlign("center,center,center,center,center,center,center,center");
		authorGrid.setColTypes("ro,sub_row,ed,ed,ed,ed,ed,co");
		authorGrid.setColSorting("na,na,str,str,str,str,str,str");
		roleCombo = authorGrid.getCombo(authorGrid.getColIndexById("tpiDvsCd"));
		roleCombo.put("1","단독");
		roleCombo.put("2","공동(제1)");
		roleCombo.put("3","공동(교신)");
		roleCombo.put("4","공동(참여)");
		authorGrid.attachEvent("onRowSelect",authorGrid_onRowSelect);
		authorGrid.attachEvent("onDistributedEnd", authorGrid_onDistributedEnd);
		authorGrid.enableDragAndDrop(true);
		//authorGrid.setColVAlign("top,middle,bottom,top,top,sub");
		//authorGrid.enableEditEvents(true,false,true);
		authorGrid.init();
        authorGrid.enableDistributedParsing(true,10,300);
        authorGrid.attachEvent("onXLE", function(grid_obj,count){
        	for (var i=idx; i < authorGrid.getRowsNum()+1; i++){
                   var rId = authorGrid.getRowId(i);
                   idx++;
                   var str = rId.split(';'); // regular expression 이 아님에 주의할 것
                   if(i <= 50 || (i > 50 && str[3] == '1') )
                   {
	                   aut = str[1];
	                   authorGrid.setRowColor(rId, colorArr[aut%5]);
	                   var cell = authorGrid.cellById(rId, 1);
	                   cell.open();
                   }
           	}
        });

		authorGrid.setAwaitedRowHeight(26);
		authorGrid.load("${contextPath}/workbench/findAuthorList.do?articleId=${param.articleId}&adresSeq=${param.adresSeq}&flag=W", function(){
			authorNum = authGrid.getRowsNum();
		});
		authorDp = new dataProcessor("${contextPath}/workbench/updateAuthor.do");
		authorDp.init(authorGrid);
		authorDp.setTransactionMode("POST",false);
		authorDp.setUpdateMode("off");
		authorDp.enableDataNames(true);
		authorGridUID = "cgrid2_" + (authorGrid.uid() - 1);
	}
	function openCell(){
		for (var i=0; i<authorGrid.getRowsNum(); i++){ 		// here i - index of the row in the grid
			var rId = authorGrid.getRowId(i); // get row id by its index
			var str = rId.split(';'); // regular expression 이 아님에 주의할 것
			aut = str[1];
			authorGrid.setRowColor(rId, colorArr[aut%5]);
			var cell = authorGrid.cellById(rId, 1);
			cell.open();
		}
	}

	function authorGrid_onDistributedEnd(){
		dhxLayout.cells("c").progressOff();
		$('#'+authorGridUID+" .obj tbody tr td").attr('valign','top');
	}

	function authorGrid_onRowSelect(rowID,celInd){
		var rowInd = authorGrid.getRowIndex(rowID);
		var cellObj = authorGrid.cellByIndex(rowInd, 0);
		// if selected address exists then change institute info.
		if (authorGrid.getSelectedId()!=null) {
			var rowInd_ADD = authorGrid.getRowIndex(authorGrid.getSelectedId());
			var cellObj_ADD = authorGrid.cellByIndex(rowInd_ADD,2);
	//		cellObj_ADD.setValue(cellObj.getValue());
		}
	}

	function mappingClear(){
		var data;
		var cIndex_rePername = authorGrid.getColIndexById("rePername");
		var cIndex_rePerno = authorGrid.getColIndexById("rePerno");
		if(authorGrid.getSelectedId() == null || authorGrid.getSelectedId() == ""){
			dhtmlx.alert({type:"alert-warning",text:"선택된 셀이 없습니다..",callback:function(){}})
			return false;
		}else{
			data = authorGrid.cells(authorGrid.getSelectedId(),cIndex_rePerno).getValue();
		}
		if(data == null || data == ""){
			dhtmlx.alert({type:"alert-warning",text:"삭제할 데이터가 없습니다.",callback:function(){}})
			return false;
		}else {
			authorGrid.cells(authorGrid.getSelectedId(),cIndex_rePername).setValue("");
			authorGrid.cells(authorGrid.getSelectedId(),cIndex_rePerno).setValue("");
			authorDp.setUpdated(authorGrid.getSelectedId(),true);
		}
		authorDp.sendData(authorGrid.getSelectedId());
	}

	function authorSave(){
		authorDp.sendData();
	}

	function migstatusUpdate(id){
		authorDp.sendData();
		$.ajax({
			url : "${contextPath}/workbench/updateMigCompleted.do",
			dataType : 'json',
			method : 'POST',
			data : {
					  "sourcIdntfcNo" : '${param.sourcIdntfcNo}',
					  "migCompleted"  : id,
					  "articleId"	  : '${param.articleId}'
				   },
			success:function(data){
				if(data.code == "001"){
					//alert(data.msg);
					dhtmlx.alert({type:"alert-warning",text:data.msg,callback:function(){}})
					//wins.window('w1').close();
				}

			}
		});

	}

	function rawDataLink(url, flag){
		var tempUrl = "";
		if(flag == 1) tempUrl = "http://dx.doi.org/";
		if(flag == 2) tempUrl = "http://scholar.google.co.kr/scholar?q=";
		if(flag == 3)
		{
			window.open(url,"rawDataWin","height=720px, width=1000px,fullscreen=yes,location=no, resizable =yes,scrollbars=yes");
		}
		else
		{
			window.open(tempUrl+encodeURIComponent(url),"rawDataWin","height=720px, width=1000px,fullscreen=yes,location=no, resizable =yes,scrollbars=yes");
		}
	}

	function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){ dhxLayout.setSizes(false); },200);}


	var orgAliasModalBox, orgAliasFormLayout, orgAliasForm, clkBtnString;

	function addReference(rowId){
		console.log(rowId);
		var cIndex_reInst = adresGrid.getColIndexById("reInst");
		var cIndex_add1 = adresGrid.getColIndexById("add1");
		var reInst = adresGrid.cells(rowId,cIndex_reInst).getValue();
		var add1 = adresGrid.cells(rowId,cIndex_add1).getValue();
		fn_mgtOrgAlias(reInst, add1);
	}

	function fn_mgtOrgAlias(reInst, add1){
		var btn = ["저장", "취소"];
		orgAliasModalBox = dhtmlx.modalbox({
			title: '기관명전거 추가',
		    text: '<div id="orgAliasForm" style="width: 500px; height: 235px;"></div>',
		    width: '522px',
		    buttons:btn
		});

		orgAliasFormLayout = new dhtmlXLayoutObject({
			parent: 'orgAliasForm',
			pattern: '1C',
			skin: '${dhtmlXSkin}',
			cells: [{ id: 'a', header: false }]
		});

		$.ajax({ url: '${contextPath}/orgAlias/getComOrgAlias.do?id=', dataType: 'json' }).done(function(data) {

			var status = (data.orgAlias.id != null && data.orgAlias.id != '') ? 'updated':'inserted';
			var regUserId = (data.orgAlias.regUserId != null && data.orgAlias.regUserId != '') ?  data.orgAlias.regUserId : '${sessionScope.login_user.userId}';

			var selectedOrgName = reInst;

			var orgNameOptions = new Array();
			orgNameOptions.push({text:"기관명을 선택하세요.",value:""});
			var isExist = false;
			for(var i=0; i < data.instList.length; i++)
			{
				if(data.instList[i].orgName == selectedOrgName)
				{
					isExist = true;
					orgNameOptions.push({text:data.instList[i].orgName,value:data.instList[i].orgName,selected:true});
				}
				else
				{
					orgNameOptions.push({text:data.instList[i].orgName,value:data.instList[i].orgName});
				}
			}
			if(!isExist) orgNameOptions.push({text:selectedOrgName,value:selectedOrgName,selected:true});

			orgAliasForm = orgAliasFormLayout.cells('a').attachForm([
		   			{type: 'settings', position: 'label-left', labelWidth: 100, inputWidth: 350},
					{type: 'block', inputWidth: 'auto', offsetTop: 10, list: [
						{type: 'combo', label: '기관명', name: 'orgName', options:orgNameOptions , filterCache: true, filtering: true, readonly:true, validate: "NotEmpty", required: true, inputWidth: 322},
						{type: "newcolumn"},
						{type: "button", name:"btn_search", value: "", className: "button_search", inputWidth: 5},
						{type: "newcolumn"},
						{type: 'input', label: '전거', name: 'orgAlias', value: add1, validate: "NotEmpty", required: true}
			   		]},
			   		{type: 'block', inputWidth: 'auto', offsetTop: 10, list: [
						{type: 'select', label: '구분', name: 'gubun', value:data.orgAlias.gubun, options:[
						                                                          {text:'대학',value:'대학'},
						                                                          {text:'기관',value:'기관'}
						                                                          ]},
						{type: 'select', label: '국가', name: 'country', value:data.orgAlias.country, options:[
						                                                          {text:'South Korea',value:'South Korea'},
						                                                          {text:'USA',value:'USA'}
						                                                          ]},
						{type: 'input', label: '적요', name: 'remark', value: data.orgAlias.remark, rows:3},
						{type: 'hidden', label: 'ID', name: 'gr_id', value: data.orgAlias.id},
						{type: 'hidden', label: 'STATUS', name: '!nativeeditor_status', value: status},
						{type: 'hidden', label: '등록자ID', name: 'regUserId', value: regUserId},
						{type: 'hidden', label: '수정자ID', name: 'modUserId', value: '${sessionScope.login_user.userId}'}
			   		]}
		    ]);

			orgAliasForm.attachEvent('onButtonClick',function(name){
				if(name == 'btn_search')searchInst();
			});

			orgAliasForm.getCombo("orgName").attachEvent("onOpen",function(){
				$(".dhxcombolist_dhx_terrace").eq(0).css("z-index","20001");
			});

		});
		$('select[name="orgName"]').focus();

		$('.dhtmlx_popup_button').on('click', function(e) {
			clkBtnString = $(this).text();
			if(clkBtnString == '취소')
			{
				orgAliasForm.getCombo("orgName").clearAll();
				return true;
			}
			else if(clkBtnString == '삭제')
			{
				orgAliasForm.getCombo("orgName").clearAll();
				cut();
			}
			else
			{
				orgAliasForm.validate();
				orgAliasForm.send("${contextPath}/orgAlias/comOrgAliasCUD.do", "post", function() {
					dhtmlx.modalbox.hide(orgAliasModalBox);
					adresGrid.clearAndLoad(getAdresGridUrl());
					dhtmlx.alert('저장 되었습니다.');
					orgAliasForm.getCombo("orgName").clearAll();
				});
				return false;
			}
		});
	}

	var w1Toolbar, w1Grid;
	function searchInst(){

		dhtmlx.modalbox.hide(orgAliasModalBox);

		var pageX = Math.max(0, (($(window).width() - 550) / 2) + $(window).scrollLeft());
		var pageY = Math.max(0, (($(window).height() - 350) / 2) + $(window).scrollTop());

		if(dhxWins != null && dhxWins.unload != null)
		{
			dhxWins.unload();
			dhxWins = null;
		}

		dhxWins = new dhtmlXWindows({
			viewport : {objec : 'windVP'},
			wins : [ {id : 'w1', left : pageX, top : pageY, width: 600, height: 450, text: "대학/기관검색", resize : false} ]
		});
		dhxWins.window('w1').setModal(true);
		dhxWins.window('w1').attachEvent('onClose',function(){
			dhtmlx.modalbox(orgAliasModalBox);
			return true;
		});

		var keyWord = "";
		if(orgAliasForm != null) keyWord = orgAliasForm.getItemValue('orgName');

		w1Layout = dhxWins.window('w1').attachLayout('2E')
		w1Layout.cells('a').hideHeader();
		w1Layout.cells('b').hideHeader();
		w1Layout.cells("a").setHeight(55);

		w1Toolbar = w1Layout.cells("b").attachToolbar();
		w1Toolbar.setIconsPath("${dhtmlXImagePath}/icons_${sysConf['dhtmlx.skin']}/");
		w1Toolbar.setIconSize(18);
		w1Toolbar.addInput("keyword", 0, keyWord, 515);
		w1Toolbar.addButton("search", 1, "", "search.png", "search.png");
		w1Toolbar.attachEvent("onClick", function(id) {
			if (id == "search"){
				w1Grid.clearAndLoad('${contextPath}/code/findOrgCodeList.do?keyword=' + encodeURIComponent(w1Toolbar.getValue('keyword')));
			}
		});
		w1Toolbar.attachEvent("onEnter", function(id,value) {
			if(value == "")
			{
				dhtmlx.alert({type:"alert-warning",text:"검색어를 입력하세요.",callback:function(){}})
			}
			else
			{
				w1Grid.clearAndLoad('${contextPath}/code/findOrgCodeList.do?keyword=' + encodeURIComponent(w1Toolbar.getValue('keyword')));
			}
	    });

		w1Grid = w1Layout.cells("b").attachGrid();
		w1Grid.setImagePath("${dhtmlXImagePath}");
		w1Grid.setHeader('');
		w1Grid.setHeader("대학/기관명", null, grid_head_center_bold);
		w1Grid.setInitWidths("*");
		w1Grid.setColAlign("left");
		w1Grid.setColTypes("ro");
		w1Grid.setColSorting("na");
		w1Grid.attachEvent("onXLS", function() {
			w1Layout.cells("a").progressOn();
		 });
		w1Grid.attachEvent("onXLE", function() {
			w1Layout.cells("a").progressOff();
		 });
		w1Grid.attachEvent('onRowSelect', doOnRowSelectedInst);
		w1Grid.init();
		$('.dhxtoolbar_input').focus();
		if (w1Toolbar.getValue('keyword') != "") w1Grid.clearAndLoad('${contextPath}/code/findOrgCodeList.do?keyword=' + encodeURIComponent(w1Toolbar.getValue('keyword')));

	}

	function doOnRowSelectedInst(id){
		var orgName = id.split('_')[1];
		dhxWins.window('w1').close();
		orgAliasForm.getCombo("orgName").addOption(orgName,orgName,null,"",true);
		dhtmlx.modalbox(orgAliasModalBox);
	}



</script>
</head>
<body>
	<input type="hidden" name="rsch_gubun" id="rsch_gubun" value="M"/>
	<input type="hidden" name="rsch_flag" id="rsch_flag" value="M"/>
	<form name="popFrm" id="popFrm" method="post"></form>
	<div id="layoutObj"></div>
	<script type="text/javascript">$('#layoutObj').css('height',($(document).height()-40)+"px");</script>
	<div id="articleInfoDiv" style="display: none;">
		<table class="sub_basic" style="width: 100%;table-layout: fixed;">
			<colgroup>
				<col style="width: 12%;"/>
				<col style="width: 12%;"/>
				<col style="width: 12%;"/>
				<col style="width: 12%;"/>
				<col style="width: 12%;"/>
				<col style="width: 12%;"/>
				<col style="width: 12%;"/>
				<col style="width: 12%;"/>
			</colgroup>
			<tbody>
				<tr>
					<th>Article Title</th>
					<td colspan="7">
						<c:if test="${empty articleInfo.doi }">
							${articleInfo.articleTtl}
						</c:if>
						<c:if test="${not empty articleInfo.doi }">
							<a href="javascript:rawDataLink('${articleInfo.doi}',1);">${articleInfo.articleTtl}</a> &nbsp;
						</c:if>
						<c:if test="${sysConf['exrims.google.use'] eq 'Y' }">
							<a href="javascript:rawDataLink('${articleInfo.articleTtl}',2);" title="Link for Google Scholar"><img src="${contextPath}/images/common/icon/scholar_icon.png" style="vertical-align: middle;" border="0" width="16" height="16" /></a>&nbsp;
						</c:if>
						<c:if test="${not empty articleInfo.idntfrList}">
							<c:forEach items="${articleInfo.idntfrList}" var="idntfr" varStatus="st">
								<c:if test="${not empty idntfr and not empty idntfr.sourceUrl}">
									<c:if test="${idntfr.idntfrSe eq 'WOS' }">
										<a href="javascript:rawDataLink('${idntfr.sourceUrl}',3);" title="Link for Web of Science"><img src="${contextPath}/images/common/icon/wos_icon.png" style="vertical-align: middle;" border="0" width="16" height="16"/></a>&nbsp;
									</c:if>
									<c:if test="${idntfr.idntfrSe eq 'SCP' }">
										<a href="javascript:rawDataLink('${idntfr.sourceUrl}',3);" title="Link for Scopus"><img src="${contextPath}/images/common/icon/scopus_icon.gif" style="vertical-align: middle;" border="0" width="16" height="16"/></a>&nbsp;
									</c:if>
									<c:if test="${idntfr.idntfrSe eq 'KCI' }">
										<a href="javascript:rawDataLink('${idntfr.sourceUrl}',3);" title="Link for KCI"><img src="${contextPath}/images/common/icon/kci_icon.gif" style="vertical-align: middle;" border="0" width="16" height="16"/></a>&nbsp;
									</c:if>
									<c:if test="${idntfr.idntfrSe eq 'KCI' and not empty idntfr.pdfUrl }">
										<a href="${idntfr.pdfUrl}" title="Link for kci PDF"><img src="${contextPath}/images/common/icon/kci_pdf_icon.gif" style="vertical-align: middle;" border="0" width="40" height="16"/></a>&nbsp;
									</c:if>
								</c:if>
							</c:forEach>
						</c:if>
					</td>
				</tr>
				<tr>
					<th>Journal</th>
					<td colspan="3">${articleInfo.plscmpnNm}</td>
					<th>Pub. Year</th>
					<td colspan="3"><b>${articleInfo.pblcateYear}</b></td>
					<%--<th>원문파일</th>
					<td><a href="test" id="fileUpload">원문파일 업로드</a></td>--%>
				</tr>
				<tr>
					<th>Identifier</th>
					<td colspan="3">${articleInfo.sourcIdntfcNo}</td>
					<th>Other Identifier</th>
					<td colspan="3">

						<c:if test="${not empty articleInfo.idntfrList}">
							<c:forEach items="${articleInfo.idntfrList}" var="idntfr" varStatus="st">
								<c:if test="${not empty idntfr}">
									<c:if test="${idntfr.idntfrSe ne 'DOI' and idntfr.idntfrSe eq 'WOS' and  idntfr.idntfrSe ne articleInfo.sourcDvsnCd }">
										${idntfr.idntfr}
									</c:if>
									<c:if test="${idntfr.idntfrSe ne 'DOI' and idntfr.idntfrSe eq 'SCP' and  idntfr.idntfrSe ne articleInfo.sourcDvsnCd }">
										${idntfr.idntfr}
									</c:if>
									<c:if test="${idntfr.idntfrSe ne 'DOI' and idntfr.idntfrSe eq 'KCI' and  idntfr.idntfrSe ne articleInfo.sourcDvsnCd }">
										6${idntfr.idntfr}
									</c:if>
								</c:if>
							</c:forEach>
						</c:if>

						${articleInfo.dplctSourcIdntfcNos}
					</td>
				</tr>
				<tr>
					<th>Volumn</th>
					<td>${articleInfo.vlm}</td>
					<th>Issue</th>
					<td>${articleInfo.issue}</td>
					<th>Page</th>
					<td>${articleInfo.beginPage} ~ ${articleInfo.endPage}</td>
					<th>ISSN</th>
					<td>${articleInfo.issn}</td>
				</tr>
			</tbody>
		</table>
	</div>

</body>
</html>