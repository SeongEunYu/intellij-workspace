var dhxPatWin, dhxPatLayout, dhxPatToolbar, dhxPatGrid;
//KRI검색
function patVrfcPopup(){
	// 1)입력값 체크
	/*
	if($('#itlPprRgtNm').val() == '')
	{
		dhtmlx.alert({type:"alert-warning",text:"지식재산권명은 필수입니다.",callback:function(){$('#itlPprRgtNm').focus();}})
		return;
	}
	else
	*/
	if($('#itlPprRgtDvsCd').val() == '')
	{
		dhtmlx.alert({type:"alert-warning",text:"지식재산권 구분은 필수입니다.",callback:function(){$('#itlPprRgtDvsCd').focus();}})
		return;
	}
	else if($('#acqsDvsCd').val() == '')
	{
		dhtmlx.alert({type:"alert-warning",text:"취득구분은 필수입니다.",callback:function(){$('#acqsDvsCd').focus();}})
		return;
	}
	/*
	else if($('#applRegtNm').val() == '')
	{
		dhtmlx.alert({type:"alert-warning",text:"출원및 등록인명은 필수입니다.",callback:function(){$('#applRegtNm').focus();}})
		return;
	}
	*/
	else if($('#acqsNtnDvsCd').val() == '')
	{
		dhtmlx.alert({type:"alert-warning",text:"취득국가구분은 필수입니다.",callback:function(){$('#acqsNtnDvsCd').focus();}})
		return;
	}
	else
	{
		var param8 = "";
		var param5 = $('#acqsDvsCd').val();
		if(param5 == '1')
		{
			if($('#itlPprRgtRegNo').val() == ''){
				dhtmlx.alert({type:"alert-warning",text:"등록번호를 입력하세요.",callback:function(){$('#itlPprRgtRegNo').focus();}})
				return;
			}
			else
			{
				param8 = $('#itlPprRgtRegNo').val();
			}
		}
		else if(param5 == '2')
		{
			if($('#applRegNo').val() == ''){
				dhtmlx.alert({type:"alert-warning",text:"출원번호를 입력하세요.",callback:function(){$('#applRegNo').focus();}})
				return;
			}
			else
			{
				 param8 = $('#applRegNo').val();
			}

		}

		var kriPopup = window.open('about:blank', 'kriPatentSearchPopup', 'width=935px,height=500px,location=no,scrollbars=yes,resizeable=no');
		var vrfcFrm = $('#vrfcFrm');
		vrfcFrm.empty();
		vrfcFrm.append($('<input type="hidden" name="Kri_Param3" value="'+$('#itlPprRgtNm').val()+'"/>'));
		vrfcFrm.append($('<input type="hidden" name="Kri_Param4" value="'+$('#itlPprRgtDvsCd').val()+'"/>'));
		vrfcFrm.append($('<input type="hidden" name="Kri_Param5" value="'+param5+'"/>'));
		vrfcFrm.append($('<input type="hidden" name="Kri_param6" value="'+$('#applRegtNm').val()+'"/>'));
		vrfcFrm.append($('<input type="hidden" name="Kri_Param8" value="'+param8+'"/>'));
		vrfcFrm.append($('<input type="hidden" name="Kri_Param10" value="'+$('#acqsNtnDvsCd').val()+'"/>'));
		vrfcFrm.append($('<input type="hidden" name="Kri_Service" value="5"/>'));
		vrfcFrm.attr('action',contextpath+'/jsp/kriVrfc.jsp');
		vrfcFrm.attr('target','kriPatentSearchPopup');
		vrfcFrm.submit();
	}
}

//대표지식재산 검색
function getFamilyWin(id, keyword) {
	var pageX = Math.max(0, (($(window).width() - 550) / 2) + $(window).scrollLeft());
	var pageY = Math.max(0, (($(window).height() - 350) / 2) + $(window).scrollTop());

	if(dhxPatWin != null && dhxPatWin.unload != null)
	{
		dhxPatWin.unload();
		dhxPatWin = null;
	}

	dhxPatWin = new dhtmlXWindows({
		viewport : {objec : 'windVP'},
		wins : [ {id : 'w1', left : pageX, top : pageY, width: 600, height: 350, text: getText("tit_family_sear"), resize : false} ]
	});

	keyword = keyword.split(" ")[0];

	dhxPatLayout = dhxPatWin.window('w1').attachLayout('2E');
	dhxPatLayout.cells("a").hideHeader();
	dhxPatLayout.cells("b").hideHeader();
	//dhxLayout.cells("a").attachURL(rimsPath+"/windowHelp/help12.jsp");
	dhxPatLayout.cells("a").setHeight(55);

	dhxPatToolbar = dhxPatLayout.cells("b").attachToolbar();
	dhxPatToolbar.setIconsPath(contextpath+"/images/common/icon/");
	dhxPatToolbar.addInput("keyword", 0, keyword, 515);
	dhxPatToolbar.addButton("search", 1, "", "btn_search.png", "btn_search.png");
	dhxPatToolbar.attachEvent("onClick", function(id) {
    	if (id == "search") dhxPatGrid.clearAndLoad(contextpath+'/patent/findFamilyList.do?keyword=' + encodeURIComponent(dhxPatToolbar.getValue('keyword')));
    });
	dhxPatToolbar.attachEvent("onEnter", function(id, value) {
    	if (id == "search") dhxPatGrid.clearAndLoad(contextpath+'/patent/findFamilyList.do?keyword=' + encodeURIComponent(dhxPatToolbar.getValue('keyword')));
    });

    dhxPatGrid = dhxPatLayout.cells("b").attachGrid();
    dhxPatGrid.setImagePath(contextpath+'/js/codebase/imgs/');
    dhxPatGrid.setHeader(getText('tit_patn_family'),null,grid_head_center_bold);
    dhxPatGrid.setInitWidths("55,*,60");
    dhxPatGrid.setColAlign('center,left,center');
    dhxPatGrid.setColTypes('ro,ro,ro');
    dhxPatGrid.attachEvent("onXLS", function() {
    	dhxPatWin.window('w1').progressOn();
	});
    dhxPatGrid.attachEvent("onXLE", function() {
    	dhxPatWin.window('w1').progressOff();
	});
    dhxPatGrid.attachEvent('onRowSelect', function(id){
		var code = id.split("_")[1];
		$("#familyCode").val(code);
		isChange = true;
		dhxPatWin.window('w1').close();
	});
    dhxPatGrid.init();
	$('.dhxtoolbar_input').focus();
	dhxPatGrid.loadXML(contextpath+'/patent/findFamilyList.do?keyword=' + encodeURIComponent(keyword));
}

function dplctPatentCheck(){
	// 1)입력값 체크
	if($('#applRegNo').val() == '' && $('#itlPprRgtRegNo').val() == '')
	{
		dhtmlx.alert({type:"alert-warning",text:"등록번호, 출원번호 중 최소 1개 입력해야합니다.",callback:function(){
			if($('#applRegNo').val() == '') $('#applRegNo').focus();
			else if($('#itlPprRgtRegNo').val() == '') $('#itlPprRgtRegNo').focus();
		}});
		return;
	}

	var pageX = Math.max(0, (($(window).width() - 902) / 2) + $(window).scrollLeft());
	var pageY = Math.max(0, (($(window).height() - 600) / 2) + $(window).scrollTop());

	if(dhxPatWin != null && dhxPatWin.unload != null)
	{
		dhxPatWin.unload();
		dhxPatWin = null;
	}

	dhxPatWin = new dhtmlXWindows({
		viewport : {objec : 'windVP'},
		wins : [ {id : 'w1', left : pageX, top : pageY, width: 902, height: 600, text: getText("tit_dup_patent"), resize : false} ]
	});

	dhxPatLayout = dhxPatWin.window('w1').attachLayout('3E');
	dhxPatLayout.cells("a").hideHeader();
	//dhxLayout.cells("a").attachURL(rimsPath+"/windowHelp/help15.jsp");
	dhxPatLayout.cells("a").setHeight(90);

	dhxPatLayout.cells("b").hideHeader();
	dhxPatLayout.cells("b").setHeight(150);
    dhxPatGrid = dhxPatLayout.cells("b").attachGrid();
    dhxPatGrid.setImagePath(contextpath+'/js/codebase/imgs/');
    dhxPatGrid.setHeader("No.,ID,Title,Appl. Date,Appl. No.,Reg. Date,Reg. No",null,grid_head_center_bold);
    dhxPatGrid.setInitWidths("30,50,*,120,120,120,120");
    dhxPatGrid.setColAlign('center,center,left,center,center,center,center');
    dhxPatGrid.setColTypes('ro,ro,ro,ro,ro,ro,ro');
    dhxPatGrid.attachEvent("onXLS", function() {
    	dhxPatWin.window('w1').progressOn();
	});
    dhxPatGrid.attachEvent("onXLE", function() {
    	dhxPatWin.window('w1').progressOff();
	});
    dhxPatGrid.attachEvent('onRowSelect', dplctPatent_onRowSelect);
    dhxPatGrid.loadXML(contextpath+'/patent/findByApplRegNoOrItlPprRgtRegNo.do?'+ $('#formArea').serialize());
    dhxPatGrid.init();
    dhxPatLayout.cells("c").hideHeader();
    dhxPatLayout.cells("c").attachHTMLString("<div id='patentOverviewForm' style='width:100%;height:100%;overflow:auto;'></div>");

}

function dplctPatent_onRowSelect(id, index){
	$.post(contextpath+'/patent/overviewPopup.do',{'patentId' : id},null,'text').done(function(data){$('#patentOverviewForm').html(data);});
}

function patentMove(patentId){
	if(patentId != undefined && patentId != null && patentId != '')
	{
		dhtmlx.confirm({
			ok:"이동", cancel:"취소",
			text:"해당페이지로 이동하시겠습니까?",
			callback:function(result){
				if(result == true)
				{
					$(location).attr('href',contextpath + '/patent/patentPopup.do?patentId='+patentId);
					dhxVrfcWin.unload();
					dhxVrfcWin = null;
				}
				else
				{
					return;
				}
			}
		});
	}
	else
	{
		dhtmlx.alert({type:"alert-warning",text:"지식재산(특허)을 선택하세요.",callback:function(){}})
		return;
	}
}

function vriferByKri(patentId){

	if($('#itlPprRgtDvsCd').val() == '')
	{
		dhtmlx.alert({type:"alert-warning",text:"지식재산권 구분은 필수입니다.",callback:function(){$('#itlPprRgtDvsCd').focus();}})
		return;
	}
	else if($('#acqsDvsCd').val() == '')
	{
		dhtmlx.alert({type:"alert-warning",text:"취득구분은 필수입니다.",callback:function(){$('#acqsDvsCd').focus();}})
		return;
	}
	/*
	else if($('#applRegtNm').val() == '')
	{
		dhtmlx.alert({type:"alert-warning",text:"출원및 등록인명은 필수입니다.",callback:function(){$('#applRegtNm').focus();}})
		return;
	}
	*/
	else if($('#acqsNtnDvsCd').val() == '')
	{
		dhtmlx.alert({type:"alert-warning",text:"취득국가구분은 필수입니다.",callback:function(){$('#acqsNtnDvsCd').focus();}})
		return;
	}
	else
	{

		var wWidth = 935;
		var wHeight = 700;
		var leftPos = (screenWidth - wWidth)/2;
		var topPos = (screenHeight - wHeight)/2;

		var param8 = "";
		var param5 = $('#acqsDvsCd').val();
		if(param5 == '1')
		{
			if($('#itlPprRgtRegNo').val() == ''){
				dhtmlx.alert({type:"alert-warning",text:"등록번호를 입력하세요.",callback:function(){$('#itlPprRgtRegNo').focus();}})
				return;
			}
			else
			{
				param8 = $('#itlPprRgtRegNo').val();
			}
		}
		else if(param5 == '2')
		{
			if($('#applRegNo').val() == ''){
				dhtmlx.alert({type:"alert-warning",text:"출원번호를 입력하세요.",callback:function(){$('#applRegNo').focus();}})
				return;
			}
			else
			{
				 param8 = $('#applRegNo').val();
			}

		}

		var pcnRschrRegNo = "";
		var pcnRschrRegNos = $('input[name="pcnRschrRegNo"]');
		for(var i = 0; i < pcnRschrRegNos.length; i++)
		{
			if(pcnRschrRegNos.eq(i).val() != ''){
				pcnRschrRegNo = pcnRschrRegNos.eq(i).val();
				break;
			}
		}

		var kriPopup = window.open('about:blank', 'kriSearchPopup', 'width='+wWidth+'px,height='+wHeight+'px,top='+topPos+',left='+leftPos+' location=no,scrollbars=yes,resizable=yes');
		var vrfcFrm = $('#vrfcFrm');
		vrfcFrm.empty();
		vrfcFrm.append($('<input type="hidden" name="Kri_Param2" value="'+pcnRschrRegNo+'"/>'));
		vrfcFrm.append($('<input type="hidden" name="Kri_Param3" value="'+$('#itlPprRgtNm').val()+'"/>'));
		vrfcFrm.append($('<input type="hidden" name="Kri_Param4" value="'+$('#itlPprRgtDvsCd').val()+'"/>'));
		vrfcFrm.append($('<input type="hidden" name="Kri_Param5" value="'+param5+'"/>'));
		vrfcFrm.append($('<input type="hidden" name="Kri_Param6" value="'+$('#applRegtNm').val()+'"/>'));
		vrfcFrm.append($('<input type="hidden" name="Kri_Param8" value="'+param8+'"/>'));
		vrfcFrm.append($('<input type="hidden" name="Kri_Param10" value="'+$('#acqsNtnDvsCd').val()+'"/>'));

		if(patentId != undefined && patentId != "")
			vrfcFrm.append($('<input type="hidden" name="returnUrl" value="'+rimsUrl+contextpath+'/jsp/vrifyByKri.jsp"/>'));
		else
			vrfcFrm.append($('<input type="hidden" name="returnUrl" value="'+rimsUrl+contextpath+'/jsp/kriRslt.jsp"/>'));

		vrfcFrm.append($('<input type="hidden" name="kriAction" value="'+kriAction+'"/>'));
		vrfcFrm.append($('<input type="hidden" name="Kri_Service" value="5"/>'));
		vrfcFrm.attr('action',contextpath+'/jsp/kriVrfc.jsp');
		vrfcFrm.attr('target','kriSearchPopup');
		vrfcFrm.submit();
		vrfcFrm.focus();
	}

}

function insertPrtcpnt(prtcpnts, isReset){

	if(isReset == undefined || isReset == 'Y')
	{
		resetPrtcpnt();
	}
	else
	{
		$('#prtcpntTbody').find('.row_add_bt').last().trigger('click');
	}

	var authorArr = prtcpnts.split(",");
	$('#totalAthrCnt').val(authorArr.length);
	for(var i = 0; i < authorArr.length; i++)
	{
		$('#prtcpntId_'+prtcpntIdx).val('');
		$('#blngAgcCd_'+prtcpntIdx).val('');
		$('.dispDept').empty();
		$('#prtcpntNm_'+prtcpntIdx).val(authorArr[i]);

		if(i < (authorArr.length - 1))
			$('#prtcpntTbody').find('.row_add_bt').last().trigger('click');
	}
	$('span[class="prtcpnt_order"]').each(function(i, obj){ $(obj).text(i+1); });
	if(sessMode == 'true' || loginAuthor == 'R' || loginAuthor == 'S')
	{
		choiceSelf();
	}
}

function resetPrtcpnt(){
	var delBtns =  $('#prtcpntTbody').find('.red_del');
	for(var i = (delBtns.length - 1); i > -1 ; i--)
	{
		delBtns.eq(i).trigger('click');
	}
}

function updatePrtcpnt(gubun, prtcpnts){
	if(gubun == '2')
	{
		insertPrtcpnt(prtcpnts, 'N');
	}
	else if(gubun == '3')
	{
		insertPrtcpnt(prtcpnts, 'Y');
	}
}

var dhxAuthrWin, dhxAuthrLayout, authrGrid;
function choiceSelf(){
    var wWidth = 406;
    var wHeight = 450;

    pageX = $(window).width() /2 - wWidth /2 + $(window).scrollLeft();
    pageY = $(window).height() /2 - wHeight /2 + $(window).scrollTop();

	if(dhxAuthrWin != null && dhxAuthrWin.unload != null)
	{
		dhxAuthrWin.unload();
		dhxAuthrWin = null;
	}
	dhxAuthrWin = new dhtmlXWindows({
		viewport : {objec : 'windVP'},
		wins : [{id:'w1', left : pageX, top: pageY, width:wWidth, height:wHeight, text:"발명자선택(Select author)", resize: true}]
	});
	dhxAuthrWin.window('w1').setModal(true);

	dhxAuthrLayout = dhxAuthrWin.window('w1').attachLayout('2E')
	dhxAuthrLayout.cells("a").hideHeader();
	dhxAuthrLayout.cells("a").setHeight(70);
	dhxAuthrLayout.cells("a").attachURL(contextpath+"/"+preUrl+"/i18n/winhelp/help_choiceSelf.do");
	dhxAuthrLayout.cells("b").hideHeader();
	//dhxAuthrLayout.cells("b").setHeight(150);

	authrGrid = dhxAuthrLayout.cells("b").attachGrid();
	authrGrid.setImagePath(dhtmlximagepath);
	authrGrid.setHeader("No,Name",null, grid_head_center_bold);
	authrGrid.setInitWidths("40,*");
	authrGrid.setColAlign("center,center");
	authrGrid.setColTypes("ro,ro");
	//authrGrid.attachEvent("onXLS", function() { dhxVrfcLayout.cells('b').progressOn(); });
	//authrGrid.attachEvent("onXLE", function() { dhxVrfcLayout.cells('b').progressOff(); });
	authrGrid.attachEvent('onRowSelect', authr_onRowSelect);
	authrGrid.init();
	//authrGrid.loadXML(contextpath+'/article/findByKeywordAndPblcYear.do?' + $('#vrfcFrm').serialize());
	var rows = new Array();
	$('#prtcpntTbody tr').each(function(index){
		var row = new Object();
		var data = new Array();
		var rowId = $(this).find('input[name="prtcpntIndex"]').eq(0).val();
		var name = $(this).find('input[name="prtcpntNm"]').eq(0).val();
		data.push(index+1);
		data.push(name);
		row = {'id':rowId, 'data':data};
		rows.push(row);
	});
	authrGrid.clearAll();
	authrGrid.parse({'rows':rows},"json")
}

function authr_onRowSelect(id,ind){
	$('#prtcpntId_'+id).val(sessUserId);
	dhxAuthrWin.unload();
	dhxAuthrWin = null;
}
