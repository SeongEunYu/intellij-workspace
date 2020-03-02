var dhxWins, myLayout, pageX, pageY, winToolbar, winGrid;

function  findJournal(e) {

	var wWidth = 700;
    var wHeight = 550;

    pageX = $(window).width() /2 - wWidth /2 + $(window).scrollLeft();
    pageY = $(window).height() /2 - wHeight /2 + $(window).scrollTop() + 13;

    if(dhxWins != null && dhxWins.unload != null)
	{
		dhxWins.unload();
		dhxWins = null;
	}

	dhxWins = new dhtmlXWindows({
		viewport : {objec : 'windVP'},
		wins : [ {id : 'w1', left : pageX, top : pageY, width: wWidth, height: wHeight, text: "학술지검색", resize : false} ]
	});
	dhxWins.window('w1').setModal(true);
	myLayout = dhxWins.window('w1').attachLayout('2E')
	myLayout.cells('a').hideHeader();
	myLayout.cells('b').hideHeader();
	myLayout.cells("a").setHeight(60);
	myLayout.cells("a").attachURL(contextpath+"/"+preUrl+"/i18n/winhelp/help_findJournal.do");

	winToolbar = myLayout.cells("b").attachToolbar();
	winToolbar.setIconsPath(contextpath + "/images/common/icon/");
	winToolbar.setIconSize(18);
	winToolbar.addInput("keyword", 0,  $('#scjnlNm').val(), 610);
	winToolbar.addButton("search", 1, "", "tbl_search_icon.png", "tbl_search_icon.png");
	winToolbar.attachEvent("onClick", function(id) {
		if (id == "search"){
			winGrid.clearAndLoad(contextpath+'/journal/findJournalListByKeywordWithPaging.do?keyword=' + encodeURIComponent(winToolbar.getValue('keyword')));
		}
	});
	winToolbar.attachEvent("onEnter", function(id,value) {
		if(value == "")
		{
			dhtmlx.alert({type:"alert-warning",text:"검색어를 입력하세요.",callback:function(){}})
		}
		else
		{
			winGrid.clearAndLoad(contextpath+'/journal/findJournalListByKeywordWithPaging.do?keyword=' + encodeURIComponent(winToolbar.getValue('keyword')));
		}
    });

	winGrid =  myLayout.cells("b").attachStatusBar({
		text : '<div id="w1Grid_pagingArea"></div>',
		paging : true
	});

	winGrid = myLayout.cells("b").attachGrid();
	winGrid.setImagePath(dhtmlximagepath);
	winGrid.setHeader('ISSN,학술지명,발행처명,구분',null, grid_head_center_bold);
	winGrid.setColumnIds("issn,title,pblcPlcNm,scjnlDvsCd");
	winGrid.setInitWidths("80,*,145,60");
	winGrid.setColAlign('center,left,left,center');
	winGrid.setColTypes('ro,ro,ro,ro');
	winGrid.setColSorting('str,str,str,str');
	winGrid.enableColSpan(true);
	winGrid.attachEvent("onXLS", function() {
		dhxWins.window('w1').progressOn();
	});
	winGrid.attachEvent("onXLE", function() {
		dhxWins.window('w1').progressOff();
	});
	winGrid.attachEvent('onRowSelect', journal_onRowSelect);
	winGrid.enablePaging(true,100,10,"w1Grid_pagingArea");
	winGrid.setPagingSkin("toolbar");
	winGrid.init();
	winGrid.clearAndLoad(contextpath+'/journal/findJournalListByKeywordWithPaging.do?keyword=' + encodeURIComponent(winToolbar.getValue('keyword')));
}

function journal_onRowSelect(id){
	var issnNo = winGrid.cells(id,winGrid.getColIndexById("issn")).getValue();
	var scjnlNm = winGrid.cells(id,winGrid.getColIndexById("title")).getValue();
	var pblcPlcNm = winGrid.cells(id,winGrid.getColIndexById("pblcPlcNm")).getValue();
	var dvsCd = id.split("_")[1];
	var pblcNtnCd = id.split("_")[2];

	if(dvsCd != "" )
	{
		$('#scjnlDvsCd').val('1');
	}

	if(dvsCd.indexOf("*") == -1 )
	{
		$('#issnNo').val(issnNo);
	}

	$('#scjnlNm').val(scjnlNm.replace("&amp;","&"));
	$('#pblcPlcNm').val(pblcPlcNm.replace("&amp;","&"));
	$('#pblcNtnCd').val(pblcNtnCd);

	if(dvsCd != '6')
	{
		$('#scjnlDvsCd').val('1');
		$('#ovrsExclncScjnlPblcYn').val(dvsCd);
	}
	else
	{
		$('#scjnlDvsCd').val('3');
		$('#krfRegPblcYn').val('1');
	}
	changeScjnlDvs($('#scjnlDvsCd'));
	//ifUpdate();
	//onFocusHelp('pblcPlcNm');
	isChange = true;
	dhxWins.window('w1').close();
}

function findAuthor(rowID, e, idx){

	//alert("article.js > findAuthor >>> " + rowID + " : " + idx );

    var wWidth = 600;
    var wHeight = 350;
    pageX = $(window).width() /2 - wWidth /2 + $(window).scrollLeft();
    pageY = $(window).height() /2 - wHeight /2 + $(window).scrollTop();

	if(dhxWins != null && dhxWins.unload != null)
	{
		dhxWins.unload();
		dhxWins = null;
	}

	dhxWins = new dhtmlXWindows({
		viewport : {objec : 'windVP'},
		wins : [ {id : 'w1', left : pageX, top : pageY, width: wWidth, height: wHeight, text: "저자검색", resize : false} ]
	});
	dhxWins.window('w1').setModal(true);

	myLayout = dhxWins.window('w1').attachLayout('2E')
	myLayout.cells('a').hideHeader();
	myLayout.cells('b').hideHeader();
	myLayout.cells("a").setHeight(55);

	winToolbar = myLayout.cells("b").attachToolbar();
	winToolbar.setIconsPath(contextpath+"/images/common/icon/");
	winToolbar.setIconSize(18);
	winToolbar.addInput("keyword", 0, authorGrid.cells(rowID, authorGrid.getColIndexById("prtcpntNm")).getValue(), 515);
	winToolbar.addButton("search", 1, "", "tbl_search_icon.png", "tbl_search_icon.png");
	winToolbar.attachEvent("onClick", function(id) {
		if (id == "search"){
			winGrid.loadXML(contextpath+'/user/findAuthorListByKeyword.do?keyword=' + encodeURIComponent(winToolbar.getValue('keyword')));
		}
	});
	winToolbar.attachEvent("onEnter", function(id,value) {
		if(value == "")
		{
			dhtmlx.alert({type:"alert-warning",text:"검색어를 입력하세요.",callback:function(){}})
		}
		else
		{
			winGrid.loadXML(contextpath+'/user/findAuthorListByKeyword.do?keyword=' + encodeURIComponent(winToolbar.getValue('keyword')));
		}
    });

	winGrid = myLayout.cells("b").attachGrid();
	winGrid.setSkin("${dhtmlXSkin}");
	winGrid.setImagePath('${dhtmlXImagePath}');
	winGrid.setHeader('사번,영문명(Abbr.),영문명(Full),한글명,소속,직급',null, grid_head_center_bold);
	winGrid.setInitWidths("60,90,90,90,*,100");
	winGrid.setColAlign('center,center,center,center,center,center');
	winGrid.setColTypes('ro,ro,ro,ro,ro,ro');
	winGrid.setColSorting('str,str,str,str,str,str');
	winGrid.enableColSpan(true);
	winGrid.attachEvent("onXLS", function() {
		dhxWins.window('w1').progressOn();
	});
	winGrid.attachEvent("onXLE", function() {
		dhxWins.window('w1').progressOff();
	});
	winGrid.attachEvent('onRowSelect', author_onRowSelect);
	winGrid.init();
	winGrid.loadXML(contextpath+'/user/findAuthorListByKeyword.do?keyword=' + encodeURIComponent(winToolbar.getValue('keyword')));

}
function author_onRowSelect(id, index){
	//<row id='${ul.userId};${ul.korNm};${engNm};${engAbbrNm}' >
	if( index != 1 && index != 2 && index != 3 )
	{
		dhtmlx.alert({type:"alert-warning",text:"영문논문은 영문명, 한글논문은 한글명을 선택 입력하십시오.",callback:function(){}})
		winGrid.clearSelection();
	}
	else
	{
		var userData = id.split(";");
		var userId = userData[0];
		var korNm = userData[1];
		var engNm = userData[2];
		var engAbbr = userData[3];

		var rowId = authorGrid.getSelectedRowId();
		var cIndex_prtcpntNm = authorGrid.getColIndexById("prtcpntNm");
		var cIndex_prtcpntFullNm = authorGrid.getColIndexById("prtcpntFullNm");
		var cIndex_prtcpntId = authorGrid.getColIndexById("prtcpntId");
		var cIndex_blngAgcNm = authorGrid.getColIndexById("blngAgcNm");
		var cIndex_blngAgcCd = authorGrid.getColIndexById("blngAgcCd");

		authorGrid.cells(rowId, cIndex_prtcpntId).setValue(userId);
		if (index == 1 || index == 2)
		{
			if( engAbbr != null && engAbbr != '')
			{
				authorGrid.cells(rowId, cIndex_prtcpntNm).setValue(engAbbr);
			}
			else
			{
				var currPrtcpntNm = authorGrid.cells(rowId,cIndex_prtcpntNm).getValue();
				if(currPrtcpntNm == null || currPrtcpntNm == '')
				{
					authorGrid.cells(rowId, cIndex_prtcpntNm).setValue(engNm);
				}
			}
			authorGrid.cells(rowId, cIndex_prtcpntFullNm).setValue(engNm);

		}
		else if (index == 3) // 한글명을 prtcpntNm에 입력함
		{
			authorGrid.cells(rowId, cIndex_prtcpntNm).setValue(korNm);
			authorGrid.cells(rowId, cIndex_prtcpntFullNm).setValue("");
		}
		authorGrid.cells(rowId, cIndex_blngAgcNm).setValue("${sysConf['inst.blng.agc.name']}");
		authorGrid.cells(rowId, cIndex_blngAgcCd).setValue("${sysConf['inst.blng.agc.code']}");
		dhxWins.window('w1').close();
	}

}

function changePblcYear(){
	var yearValue = $('#pblcYear').val();
	if(yearValue == '' ||  yearValue == 'ACCEPT')
	{
		$('#pblcMonth').val('').prop('disabled','disabled').css('background-color','#f0f0f0').removeClass('required');
		$('#pblcDay').val('').prop('disabled','disabled').css('background-color','#f0f0f0').removeClass('required');
		$('#pblcMonth').removeClass('');

	}
	else
	{
		$('#pblcMonth').removeProp('disabled').css('background-color','#ffffff').addClass('required');
		$('#pblcDay').removeProp('disabled').css('background-color','#ffffff').addClass('required');
		if($('#pblcMonth').val() != '')
			changePblcMonth();
	}

	setPblcYm();
}

function changePblcMonth(){
	var to_year = $('#pblcYear').val();
	var to_month = $('#pblcMonth').val();
	var pblcYm = new Date(to_year, to_month, "");
	var lastDay = pblcYm.getDate();
	var dayValue = $('#pblcDay').val();
	$('#pblcDay').empty().append($('<option value=""></option>'));
	for(var i = 1; i < lastDay + 1 ; i ++)
	{
		var selected = "";
		var value = i < 10 ? '0'+i : ''+i ;
		if(value == dayValue) selected = 'selected="selected"';
		$('#pblcDay').append($('<option value="'+value+'" '+selected+'>'+value+'</option>'))
	}
	setPblcYm();
}

function changePblcDay(){
	setPblcYm();
}

function setPblcYm(){
	var pblcYmValue = "";
	var yearValue = $('#pblcYear').val();
	var monthValue = $('#pblcMonth').val();
	var dayValue = $('#pblcDay').val();
	pblcYmValue = yearValue +  monthValue + dayValue;
	$('#pblcYm').val(pblcYmValue.trim());
	isChange = true;
}

function clearPblc(){
	$('#pblcMonth').removeProp('disabled').css('background-color','#ffffff').addClass('required');
	$('#pblcDay').removeProp('disabled').css('background-color','#ffffff').addClass('required');
	$('#pblcYear').val('');
	$('#pblcMonth').val('');
	$('#pblcDay').val('');
	setPblcYm();
}

function pblcAccept(){
	$('#pblcYear').val('ACCEPT');
	changePblcYear();
}

function changeScjnlDvs(){

    var scjnlValue = $('#scjnlDvsCd').val();
    var ovrsValue = $('#ovrsExclncScjnlPblcYn').val();
    var krfValue =  $('#krfRegPblcYn').val();

    if(scjnlValue == '1') //국제
    {
		$('#scjnlDvsSpan').text('국제전문학술지(SCI급)');

		if($('select[name="ovrsExclncScjnlPblcYn"]').length)
		{
			$('#ovrsExclncScjnlPblcYn').css('display','');
			if($('select[name="krfRegPblcYn"]').length) $('#krfRegPblcYn').css('display','none');
			$('#scjnlDetailSpan').css('display','none');
		}
		else
		{
			if(ovrsValue != '')
			{
				$('#scjnlDetailSpan').css('display','');
				if(ovrsValue == '1') $('#scjnlDetailSpan').text('SCI');
				else if(ovrsValue == '2') $('#scjnlDetailSpan').text('SCIE');
				else if(ovrsValue == '3') $('#scjnlDetailSpan').text('SSCI');
				else if(ovrsValue == '4') $('#scjnlDetailSpan').text('A&HCI');
				else if(ovrsValue == '5') $('#scjnlDetailSpan').text('SCOPUS');
			}
		}
    }
    else if(scjnlValue == '3') //국내
    {

		$('#scjnlDvsSpan').text('국내전문학술지(KCI급)');
		if($('select[name="krfRegPblcYn"]').length)
		{
			$('#krfRegPblcYn').css('display','');
			$('#scjnlDetailSpan').css('display','none');
			if($('select[name="ovrsExclncScjnlPblcYn"]').length) $('#ovrsExclncScjnlPblcYn').css('display','none');
		}
		else
		{
			if(krfValue != '')
			{
				$('#scjnlDetailSpan').css('display','');
				if(krfValue == '1') $('#scjnlDetailSpan').text('학진등재');
				else if(krfValue == '2') $('#scjnlDetailSpan').text('학진등재후보');
			}
		}
    }
    else
    {
        $('#ovrsExclncScjnlPblcYn').css('display','none');
        $('#krfRegPblcYn').css('display','none');
        if(scjnlValue == '2') $('#scjnlDvsSpan').text('국제일반학술지');
        else if(scjnlValue == '4') $('#scjnlDvsSpan').text('국내일반학술지');
        else if(scjnlValue == '5') $('#scjnlDvsSpan').text('기타');
        else $('#scjnlDvsSpan').text('등재정보 최소 1개 선택');
        $('#scjnlDetailSpan').css('display','');
        $('#scjnlDetailSpan').text('-');
    }

}

var dhxVrfcWin, dhxVrfcLayout, dhxVrfcGrid;
function addVrfcPopup(){
	var target = $('input[name="srchTrget"]:checked').val();
    var keyword = $('#srchKeyword').val();
    var pblcYear = $('#srchPblcYear').val();

	if(keyword == '')
	{
		dhtmlx.alert({type:"alert-warning",text:"논문제목(원어)는 필수입니다.",callback:function(){$('#srchKeyword').focus();}})
		return;
	}
	else if(pblcYear == '' && target != 'doi' && target != 'crossref')
	{
		dhtmlx.alert({type:"alert-warning",text:"게재년은 필수입니다.",callback:function(){$('#srchPblcYear').focus();}})
		return;
	}
	else
	{
		if(target == 'kri') // kri 검증창실행
		{
            runKRIVrfcPopup();
		}
		else if(target == 'rims')
		{
            runRIMSSearchPopup();
		}
		else if(target == 'doi' ||target == 'crossref')
		{
            runDoiSearchPopup();
		}
	}
} // end function addVrfcPopup()

function runKRIVrfcPopup(){

    var keyword = $('#srchKeyword').val();
    var pblcYear = $('#srchPblcYear').val();

    var wWidth = 935;
    var wHeight = 700;

    var leftPos = (screenWidth - wWidth)/2;
    var topPos = (screenHeight - wHeight)/2;

    var kriParam2 = $('input[name="sessUserRschrRegNo"]').val();
    var kriParam6 = "0";
    var kriParam7 = "0";
    var scjnlDvs = $('input[name="srchScjnlDvsCd"]:checked').val();
    if(scjnlDvs == 'SCI') kriParam7 = '1';
    else if(scjnlDvs == 'SCP') kriParam7 = '5';
    else if(scjnlDvs == 'KCI') kriParam6 = '1';
    var kriPopup = window.open('about:blank', 'kriSearchPopup', 'width='+wWidth+'px,height='+wHeight+'px,top='+topPos+',left='+leftPos+' location=no,scrollbars=yes,resizable=yes');
    var vrfcFrm = $('#vrfcFrm');
    vrfcFrm.find('input[name^="Kri_"]').remove();
    vrfcFrm.append($('<input type="hidden" name="Kri_Param2" value="'+kriParam2+'"/>'));
    vrfcFrm.append($('<input type="hidden" name="Kri_Param4" value="'+keyword+'"/>'));
    vrfcFrm.append($('<input type="hidden" name="Kri_Param5" value=""/>'));
    vrfcFrm.append($('<input type="hidden" name="Kri_Param6" value="'+kriParam6+'"/>'));
    vrfcFrm.append($('<input type="hidden" name="Kri_Param7" value="'+kriParam7+'"/>'));
    vrfcFrm.append($('<input type="hidden" name="Kri_Param8" value="'+pblcYear+'"/>'));
    vrfcFrm.append($('<input type="hidden" name="returnUrl" value="'+rimsUrl+contextpath+'/jsp/kriRslt.jsp"/>'));
    vrfcFrm.append($('<input type="hidden" name="kriAction" value="'+kriAction+'"/>'));
    vrfcFrm.append($('<input type="hidden" name="Kri_Service" value="4"/>'));
    vrfcFrm.attr('action',contextpath+'/jsp/kriVrfc.jsp');
    vrfcFrm.attr('target','kriSearchPopup');
    vrfcFrm.submit();
    vrfcFrm.focus();
}

function runRIMSSearchPopup(){

    var wWidth = 930;
    var wHeight = 800;

    pageX = $(window).width() /2 - wWidth /2 + $(window).scrollLeft();
    pageY = $(window).height() /2 - wHeight /2 + $(window).scrollTop();

    if(dhxVrfcWin != null && dhxVrfcWin.unload != null)
    {
        dhxVrfcWin.unload();
        dhxVrfcWin = null;
    }
    dhxVrfcWin = new dhtmlXWindows({
        viewport : {objec : 'windVP'},
        wins : [{id:'w1', left : pageX, top: 0, width:wWidth, height:wHeight, text:"중복논문검색", resize: true}]
    });
    dhxVrfcWin.window('w1').setModal(true);

    dhxVrfcLayout = dhxVrfcWin.window('w1').attachLayout('3E')
    dhxVrfcLayout.cells("a").hideHeader();
    dhxVrfcLayout.cells("a").setHeight(120);
    dhxVrfcLayout.cells("a").attachURL(contextpath+"/"+preUrl+"/i18n/winhelp/help_findDplctArticleFromRIMS.do");
    dhxVrfcLayout.cells("b").hideHeader();
    dhxVrfcLayout.cells("b").setHeight(150);
    dhxVrfcLayout.cells("c").hideHeader();
    dhxVrfcLayout.cells("c").attachHTMLString("<div id='articleViewForm' style='width:100%;height:100%;overflow:auto;'></div>");

    dhxVrfcGrid = dhxVrfcLayout.cells("b").attachGrid();
    dhxVrfcGrid.setImagePath(dhtmlximagepath);
    dhxVrfcGrid.setHeader("No.,ID,Source,Title,Year,Volume,Issue,Start Page,Mode",null, grid_head_center_bold);
    dhxVrfcGrid.setColumnIds("no,articleId,source,orgLangPprNm,pblcYm,volume,issue,sttPage,mode");
    dhxVrfcGrid.setInitWidths("30,50,1,*,60,80,80,80,1");
    dhxVrfcGrid.setColAlign("center,center,center,left,center,center,center,center,center");
    dhxVrfcGrid.setColTypes("ro,ro,ro,ro,ro,ro,ro,ro,ro");
    dhxVrfcGrid.enableColSpan(true);
    dhxVrfcGrid.attachEvent("onXLS", function() { dhxVrfcLayout.cells('b').progressOn(); });
    dhxVrfcGrid.attachEvent("onXLE", function() { dhxVrfcLayout.cells('b').progressOff(); });
    dhxVrfcGrid.setColumnHidden(dhxVrfcGrid.getColIndexById("source"),true);
    dhxVrfcGrid.setColumnHidden(dhxVrfcGrid.getColIndexById("mode"),true);
    dhxVrfcGrid.init();
    dhxVrfcGrid.attachEvent('onRowSelect', dplctArticle_onRowSelect);
    dhxVrfcGrid.loadXML(contextpath+'/article/findByKeywordAndPblcYear.do?' + $('#vrfcFrm').serialize());
}

function runDoiSearchPopup(){

    var wWidth = 930;
    var wHeight = 700;

    pageX = $(window).width() /2 - wWidth /2 + $(window).scrollLeft();
    pageY = $(window).height() /2 - wHeight /2 + $(window).scrollTop();

    if(dhxVrfcWin != null && dhxVrfcWin.unload != null)
    {
        dhxVrfcWin.unload();
        dhxVrfcWin = null;
    }
    //if(dhxVrfcWin != null && dhxVrfcWin.window('w1') != null) dhxVrfcWin.window('w1').close();
    dhxVrfcWin = new dhtmlXWindows({
        viewport : {objec : 'windVP'},
        wins : [{id:'w1', left : pageX, top: pageY, width:wWidth, height:wHeight, text:"DOI논문검색", resize: true}]
    });
    dhxVrfcWin.window('w1').setModal(true);

    dhxVrfcLayout = dhxVrfcWin.window('w1').attachLayout('3E')
    //dhxVrfcLayout.cells('a').setText('도움말(Help)')
    dhxVrfcLayout.cells("a").hideHeader();
    dhxVrfcLayout.cells("a").setHeight(50);
    dhxVrfcLayout.cells("a").attachURL(contextpath+"/i18n/winhelp/help_searchByDoi.do");
    dhxVrfcLayout.cells("b").hideHeader();
    dhxVrfcLayout.cells("b").setHeight(120);
    dhxVrfcLayout.cells("c").hideHeader();
    dhxVrfcLayout.cells("c").attachHTMLString("<div id='articleViewForm' style='width:100%;height:100%;overflow:auto;'></div>");

    dhxVrfcGrid = dhxVrfcLayout.cells("b").attachGrid();
    dhxVrfcGrid.setImagePath(dhtmlximagepath);
    dhxVrfcGrid.setHeader("No.,ID,Source,Title,Year,Volume,Issue,Start Page,End Page,ISSN,scjnlNm,publisher,authors,mode",null, grid_head_center_bold);
    dhxVrfcGrid.setColumnIds("no,articleId,source,orgLangPprNm,pblcYm,volume,issue,sttPage,endPage,issnNo,scjnlNm,pblcPlcNm,authors,mode");
    dhxVrfcGrid.setInitWidths("30,50,100,*,60,60,60,80,1,1,1,1,1,1");
    dhxVrfcGrid.setColAlign("center,center,center,left,center,center,center,center,center,center,center,center,center,center");
    dhxVrfcGrid.setColTypes("ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro");
    dhxVrfcGrid.enableColSpan(true);
    dhxVrfcGrid.attachEvent("onXLS", function() { dhxVrfcLayout.cells('b').progressOn(); });
    dhxVrfcGrid.attachEvent("onXLE", function() { dhxVrfcLayout.cells('b').progressOff(); });
    dhxVrfcGrid.setColumnHidden(dhxVrfcGrid.getColIndexById("articleId"),true);
    dhxVrfcGrid.setColumnHidden(dhxVrfcGrid.getColIndexById("endPage"),true);
    dhxVrfcGrid.setColumnHidden(dhxVrfcGrid.getColIndexById("issnNo"),true);
    dhxVrfcGrid.setColumnHidden(dhxVrfcGrid.getColIndexById("scjnlNm"),true);
    dhxVrfcGrid.setColumnHidden(dhxVrfcGrid.getColIndexById("publisher"),true);
    dhxVrfcGrid.setColumnHidden(dhxVrfcGrid.getColIndexById("authors"),true);
    dhxVrfcGrid.setColumnHidden(dhxVrfcGrid.getColIndexById("mode"),true);
    dhxVrfcGrid.init();
    dhxVrfcGrid.attachEvent('onRowSelect', doiArticle_onRowSelect);
    dhxVrfcGrid.loadXML(contextpath+'/article/findByKeywordAndPblcYear.do?' + $('#vrfcFrm').serialize());
}

function dplctArticle_onRowSelect(id, index){
	if("nodata" != id)
	{
		$.post(contextpath+'/article/overviewPopup.do',{'articleId' : id, 'mode' : 'dplct'},null,'text').done(function(data){$('#articleViewForm').html(data);});
	}
	else
	{
		return;
	}
}

function doiArticle_onRowSelect(id, index){
	if("nodata" != id)
	{
		var param = {
				"mngNo" : id,
				"articleId" : id,
				"orgLangPprNm" : dhxVrfcGrid.cells(id, dhxVrfcGrid.getColIndexById("orgLangPprNm")).getValue(),
				"pblcYm" : dhxVrfcGrid.cells(id, dhxVrfcGrid.getColIndexById("pblcYm")).getValue(),
				"volume" : dhxVrfcGrid.cells(id, dhxVrfcGrid.getColIndexById("volume")).getValue(),
				"issue" : dhxVrfcGrid.cells(id, dhxVrfcGrid.getColIndexById("issue")).getValue(),
				"sttPage" : dhxVrfcGrid.cells(id, dhxVrfcGrid.getColIndexById("sttPage")).getValue(),
				"endPage" : dhxVrfcGrid.cells(id, dhxVrfcGrid.getColIndexById("endPage")).getValue(),
				"issnNo" : dhxVrfcGrid.cells(id, dhxVrfcGrid.getColIndexById("issnNo")).getValue(),
				"scjnlNm" : dhxVrfcGrid.cells(id, dhxVrfcGrid.getColIndexById("scjnlNm")).getValue(),
				"pblcPlcNm" : dhxVrfcGrid.cells(id, dhxVrfcGrid.getColIndexById("pblcPlcNm")).getValue(),
				"authors" : dhxVrfcGrid.cells(id, dhxVrfcGrid.getColIndexById("authors")).getValue(),
				"mode" : dhxVrfcGrid.cells(id, dhxVrfcGrid.getColIndexById("mode")).getValue(),
                "srchTrget" : $('input[name="srchTrget"]:checked').val(),
                "srchKeyword" : $('#srchKeyword').val()
		};
		$.ajax({
			url:contextpath+'/article/overviewPopup.do',
			data: param
		}).done(function(data){ $('#articleViewForm').html(data); })
	}
	else
	{
		return;
	}


}

function articleInput(rowId){
	$('#orgLangPprNm').val(dhxVrfcGrid.cells(rowId, dhxVrfcGrid.getColIndexById("orgLangPprNm")).getValue());
	$('#pblcYm').val(dhxVrfcGrid.cells(rowId, dhxVrfcGrid.getColIndexById("pblcYm")).getValue());
	$('#volume').val(dhxVrfcGrid.cells(rowId, dhxVrfcGrid.getColIndexById("volume")).getValue());
	$('#issue').val(dhxVrfcGrid.cells(rowId, dhxVrfcGrid.getColIndexById("issue")).getValue());
	$('#issnNo').val(dhxVrfcGrid.cells(rowId, dhxVrfcGrid.getColIndexById("issnNo")).getValue());
	$('#scjnlNm').val(dhxVrfcGrid.cells(rowId, dhxVrfcGrid.getColIndexById("scjnlNm")).getValue());
	$('#pblcPlcNm').val(dhxVrfcGrid.cells(rowId, dhxVrfcGrid.getColIndexById("pblcPlcNm")).getValue());
	$('#sttPage').val(dhxVrfcGrid.cells(rowId, dhxVrfcGrid.getColIndexById("sttPage")).getValue());
	$('#endPage').val(dhxVrfcGrid.cells(rowId, dhxVrfcGrid.getColIndexById("endPage")).getValue());
	var pblcYm = dhxVrfcGrid.cells(rowId, dhxVrfcGrid.getColIndexById("pblcYm")).getValue();
	if(pblcYm.length == 4 )
		$('#pblcYear').val(pblcYm);
	else if(pblcYm.length == 6)
	{
        $('#pblcYear').val(pblcYm.substr(0,4));
        $('#pblcMonth').val(pblcYm.substr(5,2));
	}

	resetPrtcpnt();
	var authors = dhxVrfcGrid.cells(rowId, dhxVrfcGrid.getColIndexById("authors")).getValue();
	var authorArr = authors.split(" and ");
	$('#totalAthrCnt').val(authorArr.length);
	for(var i = 0; i < authorArr.length; i++)
	{
		$('#prtcpntId_'+prtcpntIdx).val('');
		$('#blngAgcCd_'+prtcpntIdx).val('');
		$('#blngAgcNm_'+prtcpntIdx).val('');
		$('.dispDept').empty();

		$('#prtcpntNm_'+(prtcpntIdx)).val(authorArr[i]);
		$('#prtcpntFullNm_'+(prtcpntIdx)).val(authorArr[i]);
		if(i < (authorArr.length - 1))
			$('#prtcpntTbody').find('.row_add_bt').last().trigger('click');
	}
	dhxVrfcWin.unload();
	dhxVrfcWin = null;

	if(sessMode == 'true' || loginAuthor == 'R' || loginAuthor == 'S')
	{
		choiceSelf();
	}
}

/**
 * DOI 검색 결과 팝업 > 논문반입 클릭 시 실행하는 Function
 *  -> 논문정보 화면의 Input(hidden)의 값을 가져와서 값을 입력하도록 처리
 * created by hojkim
 * */
function resultArticleInput(){
	// 논문항목 셋팅
	$('#scjnlNm').val($('#result_scjnlNm').val());
	$('#issnNo').val($('#result_issnNo').val());
	$('#pblcPlcNm').val($('#result_pblcPlcNm').val());
	$('#pblcNtnCd').val($('#result_pblcNtnCd').val());
	$('#pblcYm').val($('#result_pblcYm').val());
	$('#pblcVolume').val($('#result_volume').val());
	$('#pblcIssue').val($('#result_issue').val());
	$('#sttPage').val($('#result_sttPage').val());
	$('#endPage').val($('#result_endPage').val());
	$('#orgLangPprNm').val($('#result_orgLangPprNm').val());
	$('#diffLangPprNm').val($('#result_diffLangPprNm').val());
	$('#totalAthrCnt').val($('#result_totalAthrCnt').val());
	$('#doi').val($('#result_doi').val());
	$('#abstCntn').val($('#result_abstCntn').val());

    var pblcYm = $('#result_pblcYm').val();
    if(pblcYm.length == 4 )
        $('#pblcYear').val(pblcYm);
    else if(pblcYm.length == 6)
	{
        $('#pblcYear').val(pblcYm.substr(0,4));
        $('#pblcMonth').val(pblcYm.substr(5,2));
	}

    resetPrtcpnt();
    var authors = $('.prtcpnt');
	for(var i=0;i < authors.length; i++)
	{
		var $author = $(authors.get(i));
        $('#prtcpntId_'+prtcpntIdx).val($author.find('input[id^="parti_prtcpntId"]').eq(0).val());
        $('#blngAgcCd_'+prtcpntIdx).val('');
        $('#blngAgcNm_'+prtcpntIdx).val($author.find('input[id^="parti_blngAgcNm"]').eq(0).val());
        $('.dispDept').empty();
        $('#prtcpntNm_'+(prtcpntIdx)).val($author.find('input[id^="parti_prtcpntNm"]').eq(0).val());
        $('#prtcpntFullNm_'+(prtcpntIdx)).val($author.find('input[id^="parti_prtcpntFullNm"]').eq(0).val());
        $('#tpiDvsCd_'+(prtcpntIdx)).val($author.find('input[id^="parti_tpiDvsCd"]').eq(0).val());
        if(i < (authors.length - 1))
            $('#prtcpntTbody').find('.row_add_bt').last().trigger('click');
	}
    dhxVrfcWin.unload();
    dhxVrfcWin = null;

    if(sessMode == 'true' || loginAuthor == 'R' || loginAuthor == 'S')
    {
        choiceSelf();
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
	var authorArr = prtcpnts.split("/");
	var scjnlDvsCd  = $('#scjnlDvsCd').val();
	$('#totalAthrCnt').val(authorArr.length);
	for(var i = 0; i < authorArr.length; i++)
	{
		var name = "";
		var blngAgcNm = "";
		var prtcpntNm = "";
		var prtcpntFullNm = "";

		if(authorArr[i].indexOf("[") != -1)
		{
			name = authorArr[i].substring(0, authorArr[i].indexOf("["));
			blngAgcNm = authorArr[i].substring(authorArr[i].indexOf("[")+1, authorArr[i].indexOf("]"));
		}
		else
		{
			name = authorArr[i];
		}

		if(name.indexOf("(") != -1)
		{
			prtcpntNm = name.substring(0, name.indexOf("("));
			prtcpntFullNm = name.substring(name.indexOf("(")+1, name.indexOf(")"));
		}
		else
		{
			prtcpntNm = name;
			prtcpntFullNm = name;
		}

		$('#prtcpntId_'+prtcpntIdx).val('');
		$('#blngAgcCd_'+prtcpntIdx).val('');
		$('#blngAgcNm_'+prtcpntIdx).val(blngAgcNm);
		$('.dispDept').empty();

		$('#prtcpntNm_'+(prtcpntIdx)).val(prtcpntNm);
		if(scjnlDvsCd != '3')
		{
			$('#prtcpntFullNm_'+(prtcpntIdx)).val(prtcpntFullNm);
		}
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
		wins : [{id:'w1', left : pageX, top: pageY, width:wWidth, height:wHeight, text:"저자선택(Select author)", resize: true}]
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
	authrGrid.setHeader("No,Name,Affiliation",null, grid_head_center_bold);
	authrGrid.setInitWidths("40,150,*");
	authrGrid.setColAlign("center,center,left");
	authrGrid.setColTypes("ro,ro,ro");
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
		var blngAgcNm = $(this).find('input[name="blngAgcNm"]').eq(0).val();
		data.push(index+1);
		data.push(name);
		data.push(blngAgcNm);
		row = {'id':rowId, 'data':data};
		rows.push(row);
	});
	authrGrid.clearAll();
	authrGrid.parse({'rows':rows},"json")
}

function authr_onRowSelect(id,ind){
	$('#prtcpntId_'+id).val(sessUserId);
	$('#blngAgcCd_'+id).val(instcode);
	$('#blngAgcNm_'+id).val(instname);
	dhxAuthrWin.unload();
	dhxAuthrWin = null;
}

function articleMove(articleId){
	if(articleId != undefined && articleId != null && articleId != '')
	{
		dhtmlx.confirm({
			ok:"이동", cancel:"취소",
			text:"해당페이지로 이동하시겠습니까?",
			callback:function(result){
				if(result == true)
				{
					$(location).attr('href',contextpath + '/article/dplct/articlePopup.do?articleId='+articleId);
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
		dhtmlx.alert({type:"alert-warning",text:"논문을 선택하세요.",callback:function(){}})
		return;
	}
}

function removeArticleOrgFile(btn, gubun){
	var $tr = $(btn).parent().parent().parent().parent();
	var $uploadbx = $tr.find('.fileupload_box');

	$(btn).parent().remove();

	$tr.find('input[name$=IrOpen]').each(function(index){ if($(this).val() == 'Y') $(this).prop('checked',false); else $(this).prop('checked',true);});
	$tr.find('input[name$=IrOpenDate]').val('');

	var ul = $('<ul></ul>');
	var li = $('<li></li>');
	var span = $('<span class="upload_int"></span>');
	span.append($('<input type="text" class="up_input" id="fileInput'+gubun+'" onclick="$(\'#file'+gubun+'\').trigger(\'click\');" readonly="readonly"/>'));
	span.append($('<a href="javascript:void(0);" class="upload_int_bt" onclick="$(\'#file'+gubun+'\').trigger(\'click\');">파일 선택</a>'));
	span.append($('<input type="file"  class="typeFile" style="display: none;" name="file'+gubun+'"  id="file'+gubun+'" onchange="$(\'#fileInput'+gubun+'\').val($(this).val().split(\'\\\\\').pop());"/>'));
	$uploadbx.append(ul.append(li.append(span)));
	isChange = true;
}

var dhxIFWins, dhxIFLayout, dhxIFGrid;
function findIFByIssn(){

	var issnValue = $('#issnNo').val();

	if(issnValue == null || issnValue == '')
	{
		dhtmlx.alert({type:"alert-warning",text:"ISSN번호를 입력하세요.(ex: 0000-0000)",callback:function(){$('#issnNo').focus();}})
		return;
	}
	else
	{

        var wWidth = 355;
        var wHeight = 350;
        pageX = $(window).width() /2 - wWidth /2 + $(window).scrollLeft();
        pageY = $(window).height() /2 - wHeight /2 + $(window).scrollTop();

	    if(dhxIFWins != null && dhxIFWins.unload != null)
		{
			dhxIFWins.unload();
			dhxIFWins = null;
		}
		dhxIFWins = new dhtmlXWindows({
			viewport : {objec : 'windVP'},
			wins : [ {id : 'w1', left : pageX, top : pageY, width: wWidth, height: wHeight, text: "IF 검색", resize : false} ]
		});
		dhxIFWins.window('w1').setModal(true);

		dhxIFLayout = dhxIFWins.window('w1').attachLayout('2E')
		dhxIFLayout.cells('a').hideHeader();
		dhxIFLayout.cells('b').hideHeader();
		dhxIFLayout.cells("a").setHeight(68);
		dhxIFLayout.cells("a").attachURL(contextpath+"/"+preUrl+"/i18n/winhelp/help_findImpactFactor.do");

	    dhxIFGrid = dhxIFLayout.cells("b").attachGrid();
	    dhxIFGrid.setImagePath(contextpath+'/js/codebase/imgs/');
	    dhxIFGrid.setHeader('Year, Impact Factor, Ornif',null,grid_head_center_bold);
	    dhxIFGrid.setColumnIds('prodYear,impact,ornif');
	    dhxIFGrid.setInitWidths("80,*,80");
	    dhxIFGrid.setColAlign('center,center,center');
	    dhxIFGrid.setColTypes('ro,ro,ro');
	    dhxIFGrid.attachEvent("onXLS", function() { dhxIFLayout.cells("b").progressOn(); });
	    dhxIFGrid.attachEvent("onXLE", function() { dhxIFLayout.cells("b").progressOff(); });
	    dhxIFGrid.attachEvent('onRowSelect', function(rowId){
	    	var prodyear = dhxIFGrid.cells(rowId,dhxIFGrid.getColIndexById("prodYear")).getValue();
	    	var impact = dhxIFGrid.cells(rowId,dhxIFGrid.getColIndexById("impact")).getValue();
	    	var ornif = dhxIFGrid.cells(rowId,dhxIFGrid.getColIndexById("ornif")).getValue();
	    	$('#impctFctr').val(impact);
	    	$('#ornif').val(ornif);
	    	isChange = true;
	    	dhxIFWins.window('w1').close();
		});
	    dhxIFGrid.init();
		$('.dhxtoolbar_input').focus();
		dhxIFGrid.loadXML(contextpath + '/' + preUrl + '/jcr/findImpactFactorByISSN.do?issn='+encodeURIComponent(issnValue));
	}
}

function confirmPrtcpnt(articleId, prtcpntId, index){
	$.post(contextpath+"/article/confirmPrtcpnt.do", {'articleId':articleId, 'prtcpntId':prtcpntId},null,'json').done(function(data){
		$('#prtcpntConfirm_' + index).addClass('ck_round_gray').prop('href','javascript:void(0);').empty().text(artUserNoconfirm);
		$('#recordStatus_' + index).val('1');
		opener.myGrid_load();
	});
}

function confirmPrtcpntFromAlter(articleId, prtcpntId){
	var index;
	$('input[name="prtcpntId"]').each(function(i){
		var value = $(this).val();
		if(prtcpntId == value)
		{
			var id = $(this).prop("id");
			index = id.replace("prtcpntId_","");
		}
	});
	confirmPrtcpnt(articleId, prtcpntId, index);
	$('.top_alert_wrap').css('display','none');
	topAlertClose();
}

function vriferByKri(){

	var wWidth = 935;
	var wHeight = 700;
	var leftPos = (screenWidth - wWidth)/2;
	var topPos = (screenHeight - wHeight)/2;

	var pcnRschrRegNo = "";
	var pcnRschrRegNos = $('input[name="pcnRschrRegNo"]');
	for(var i = 0; i<pcnRschrRegNos.length; i++)
	{
		if(pcnRschrRegNos.eq(i).val() != ''){
			pcnRschrRegNo = pcnRschrRegNos.eq(i).val();
			break;
		}
	}

	var kriParam6 = "0";
	var kriParam7 = "0";
	var scjnlDvs = $('#scjnlDvsCd').val();
	var ovrsExclncScjnlPblcYn = $('#ovrsExclncScjnlPblcYn').val();

	if(scjnlDvs == '1')
	{
		if(ovrsExclncScjnlPblcYn == '5' )
		{
			kriParam7 = '5';
		}
		else
		{
			kriParam7 = '1';
		}
	}
	else if(scjnlDvs == '3') kriParam6 = '1';

	var kriPopup = window.open('about:blank', 'kriSearchPopup', 'width='+wWidth+'px,height='+wHeight+'px,top='+topPos+',left='+leftPos+' location=no,scrollbars=yes,resizable=yes');
	var vrfcFrm = $('#vrfcFrm');
	vrfcFrm.empty();
	vrfcFrm.append($('<input type="hidden" name="Kri_Param2" value="'+pcnRschrRegNo+'"/>'));
	vrfcFrm.append($('<input type="hidden" name="Kri_Param4" value="'+$('#orgLangPprNm').val()+'"/>'));
	vrfcFrm.append($('<input type="hidden" name="Kri_Param5" value=""/>'));
	vrfcFrm.append($('<input type="hidden" name="Kri_Param6" value="'+kriParam6+'"/>'));
	vrfcFrm.append($('<input type="hidden" name="Kri_Param7" value="'+kriParam7+'"/>'));
	vrfcFrm.append($('<input type="hidden" name="Kri_Param8" value="'+$('#pblcYear').val()+'"/>'));
	vrfcFrm.append($('<input type="hidden" name="returnUrl" value="'+rimsUrl+contextpath+'/jsp/vrifyByKri.jsp"/>'));
	vrfcFrm.append($('<input type="hidden" name="kriAction" value="'+kriAction+'"/>'));
	vrfcFrm.append($('<input type="hidden" name="Kri_Service" value="4"/>'));
	vrfcFrm.attr('action',contextpath+'/jsp/kriVrfc.jsp');
	vrfcFrm.attr('target','kriSearchPopup');
	vrfcFrm.submit();
	vrfcFrm.focus();

}

var dhxIndexWins, dhxIndexLayout, dhxIndexGrid;
function findImpactIndexByIssnAndIndexType(indexType){

    var issnValue = $('#issnNo').val();

    if(issnValue == null || issnValue == '')
    {
        dhtmlx.alert({type:"alert-warning",text:"",callback:function(){$('#issnNo').focus();}})
        return;
    }
    else
    {
    	var valueHeader = "";
    	if(indexType == 'if') valueHeader = "Impact Factor";
        else if(indexType == 'sjr') valueHeader = "SJR";
        else if(indexType == 'ornif') valueHeader = "ORNIF";

        var wWidth = 355;
        var wHeight = 350;
        pageX = $(window).width() /2 - wWidth /2 + $(window).scrollLeft();
        pageY = $(window).height() /2 - wHeight /2 + $(window).scrollTop();

        if(dhxIndexWins != null && dhxIndexWins.unload != null)
        {
            dhxIndexWins.unload();
            dhxIndexWins = null;
        }
        dhxIndexWins = new dhtmlXWindows({
            viewport : {objec : 'windVP'},
            wins : [ {id : 'w1', left : pageX, top : pageY, width: wWidth, height: wHeight, text: "영향력지수 검색", resize : false} ]
        });
        dhxIndexWins.window('w1').setModal(true);

        dhxIndexLayout = dhxIndexWins.window('w1').attachLayout('2E')
        dhxIndexLayout.cells('a').hideHeader();
        dhxIndexLayout.cells('b').hideHeader();
        dhxIndexLayout.cells("a").setHeight(68);
        dhxIndexLayout.cells("a").attachURL(contextpath+"/"+preUrl+"/i18n/winhelp/help_findImpactFactor.do");

        dhxIndexGrid = dhxIndexLayout.cells("b").attachGrid();
        dhxIndexGrid.setImagePath(contextpath+'/js/codebase/imgs/');
        dhxIndexGrid.setHeader('Year,'+valueHeader,null,grid_head_center_bold);
        dhxIndexGrid.setColumnIds('prodyear,indexValue');
        dhxIndexGrid.setInitWidths("80,*,80");
        dhxIndexGrid.setColAlign('center,center,center');
        dhxIndexGrid.setColTypes('ro,ro,ro');
        dhxIndexGrid.attachEvent("onXLS", function() { dhxIndexLayout.cells("b").progressOn(); });
        dhxIndexGrid.attachEvent("onXLE", function() { dhxIndexLayout.cells("b").progressOff(); });
        dhxIndexGrid.attachEvent('onRowSelect', function(rowId){
            var prodyear = dhxIndexGrid.cells(rowId,dhxIndexGrid.getColIndexById("prodyear")).getValue();
            var indexValue = dhxIndexGrid.cells(rowId,dhxIndexGrid.getColIndexById("indexValue")).getValue();

            if(indexType == 'if')
            	$('#impctFctr').val(indexValue);
            else if(indexType == 'sjr')
                $('#sjr').val(indexValue);
            else if(indexType == 'ornif')
                $('#ornif').val(indexValue);

            isChange = true;
            dhxIndexWins.window('w1').close();
        });
        dhxIndexGrid.init();
        $('.dhxtoolbar_input').focus();
        dhxIndexGrid.loadXML(contextpath + '/journal/findImpactIndexByIssn.do?issn='+encodeURIComponent(issnValue) + '&indexType='+indexType);
    }
}

function  findJournalFromExtrlSource(obj) {

	var pblcYearVal = $('#pblcYear').val();

    if(pblcYearVal == '')
    {
        dhtmlx.alert({type:"alert-warning",text:"출판년도를 입력하고 검색해 주세요.",callback:function(){$('#pblcYear').focus();}})
        return;
    }else if(pblcYearVal == 'ACCEPT'){
        pblcYearVal = getCurrentYear();
	}

    var wWidth = 700;
    var wHeight = 550;

    pageX = $(window).width() /2 - wWidth /2 + $(window).scrollLeft();
    pageY = $(window).height() /2 - wHeight /2 + $(window).scrollTop() + 15;

    if(dhxWins != null && dhxWins.unload != null)
    {
        dhxWins.unload();
        dhxWins = null;
    }

    dhxWins = new dhtmlXWindows({
        viewport : {objec : 'windVP'},
        wins : [ {id : 'w1', left : pageX, top : pageY, width: wWidth, height: wHeight, text: "학술지검색", resize : false} ]
    });
    dhxWins.window('w1').setModal(true);
    myLayout = dhxWins.window('w1').attachLayout('2E')
    myLayout.cells('a').hideHeader();
    myLayout.cells('b').hideHeader();
    myLayout.cells("a").setHeight(60);
    myLayout.cells("a").attachURL(contextpath+"/"+preUrl+"/i18n/winhelp/help_findJournal.do");

    winToolbar = myLayout.cells("b").attachToolbar();
    winToolbar.setIconsPath(contextpath + "/images/common/icon/");
    winToolbar.setIconSize(18);
    winToolbar.addInput("keyword", 0,  $(obj).val(), 610);
    winToolbar.addButton("search", 1, "", "tbl_search_icon.png", "tbl_search_icon.png");
    winToolbar.attachEvent("onClick", function(id) {
        if (id == "search"){
            winGrid.clearAndLoad(contextpath+'/journal/findJournalListFromExtrlSourceByKeywordWithPaging.do?pubyear='+pblcYearVal+'&keyword=' + encodeURIComponent(winToolbar.getValue('keyword')));
        }
    });
    winToolbar.attachEvent("onEnter", function(id,value) {
        if(value == "")
        {
            dhtmlx.alert({type:"alert-warning",text:"검색어를 입력하세요.",callback:function(){}})
        }
        else
        {
            winGrid.clearAndLoad(contextpath+'/journal/findJournalListFromExtrlSourceByKeywordWithPaging.do?pubyear='+pblcYearVal+'&keyword=' + encodeURIComponent(winToolbar.getValue('keyword')));
        }
    });

    winGrid =  myLayout.cells("b").attachStatusBar({
        text : '<div id="w1Grid_pagingArea"></div>',
        paging : true
    });

    winGrid = myLayout.cells("b").attachGrid();
    winGrid.setImagePath(dhtmlximagepath);
    winGrid.setHeader('ISSN,학술지명,발행처명,구분',null, grid_head_center_bold);
    winGrid.setColumnIds("issn,title,pblcPlcNm,scjnlDvsCd");
    winGrid.setInitWidths("80,*,145,120");
    winGrid.setColAlign('center,left,left,center');
    winGrid.setColTypes('ro,ro,ro,ro');
    winGrid.setColSorting('str,str,str,str');
    winGrid.enableColSpan(true);
    winGrid.attachEvent("onXLS", function() {
        dhxWins.window('w1').progressOn();
    });
    winGrid.attachEvent("onXLE", function() {
        dhxWins.window('w1').progressOff();
    });
    winGrid.attachEvent('onRowSelect', journal_onRowSelect2);
    winGrid.enablePaging(true,100,10,"w1Grid_pagingArea");
    winGrid.setPagingSkin("toolbar");
    winGrid.init();
    winGrid.clearAndLoad(contextpath+'/journal/findJournalListFromExtrlSourceByKeywordWithPaging.do?pubyear='+pblcYearVal+'&keyword=' + encodeURIComponent(winToolbar.getValue('keyword')));
}

var journalData;
function journal_onRowSelect2(id){
    var pblcYearVal = $('#pblcYear').val();

    if(pblcYearVal == 'ACCEPT'){
        pblcYearVal = getCurrentYear();
    }

    dhxWins.window('w1').progressOn();

    $.post(contextpath + '/journal/findJournalByJid.do',{'jid' : id, 'pubyear': pblcYearVal },null,'json').done(function(data){

        journalData = data;
        dhxWins.window('w1').progressOff();

        if(loginAuthor == 'M' || loginAuthor == 'P')
        {
            dhxWins.window('w1').detachObject(true);
            dhxWins.window('w1').attachHTMLString('<div id="applyDiv" class="popup_inner"><table id="applyValue" class="write_tbl mgb_20"><colgroup><col style="width:16%;" /><col style="width:37%;" /><col style="width:37%;" /><tbody></tbody></table></div>')

            var registString = "";
            var journalTitle = "";
            if(data.isSci == 'Y') registString += "SCI, ";
            if(data.isScie == 'Y') registString += "SCIE, ";
            if(data.isSsci == 'Y') registString += "SSCI, ";
            if(data.isAhci == 'Y') registString += "AHCI, ";
            if(data.isEsci == 'Y') registString += "ESCI, ";
            if(data.isScopus == 'Y') registString += "SCOPUS, ";
            if(data.krfRegPblcYn == '1')  registString += "KCI(등재), ";
            else if(data.krfRegPblcYn == '2')  registString += "KCI(후보), ";

            registString = registString.trim().substring(0, registString.lastIndexOf(","));

            if(  journalData.isSci == 'Y' || journalData.isScie == 'Y' || journalData.isSsci == 'Y' || journalData.isAhci == 'Y' || journalData.isScopus == 'Y')
            {
                journalTitle = data.engTitle;
            }
            else
			{
                journalTitle = data.title;
			}

            $('#applyValue tbody').empty();

            var chkAllTr = $('<tr style="height: 35px;"></tr>');
            chkAllTr.append($('<th></th>'));
            chkAllTr.append($('<td colspan="2"><input type="checkbox" id="checkall" value="all" class="radio" checked="checked" onclick="javascript:if($(this).prop(\'checked\')){$(\'.apply_field\').prop(\'checked\',true);}else{$(\'.apply_field\').prop(\'checked\',false);}"/>&nbsp;<label for="checkall" class="radio_label">전체선택/해제</label></td>'));
            $('#applyValue tbody').append(chkAllTr);

            var rgistTr = $('<tr style="height: 35px;"></tr>');
            rgistTr.append($('<th rowspan="2">저널등재정보</th>'));
            rgistTr.append($('<td colspan="2"><input type="checkbox" id="jnl_regist" value="reg" class="apply_field radio" checked="checked"/>&nbsp;<label for="jnl_regist" class="radio_label">저널등재정보 적용</label></td>'));
            $('#applyValue tbody').append(rgistTr);
            $('#applyValue tbody').append($('<tr style="height: 40px;"><td colspan="2">'+registString+'</td></tr>'));

            var scjnlTr = $('<tr style="height: 35px;"></tr>');
            scjnlTr.append($('<th rowspan="2">학술지명</th>'));
            scjnlTr.append($('<td colspan="2"><input type="checkbox" id="scjnl_nm" value="scjnl" class="apply_field radio" checked="checked"/>&nbsp;<label for="scjnl_nm" class="radio_label">학술지명 변경</label></td>'));
            $('#applyValue tbody').append(scjnlTr);
            $('#applyValue tbody').append($('<tr style="height: 40px;"><td colspan="2">'+$('#scjnlNm').val()+' =>  ' + journalTitle + '</td></tr>'));

            var publisherTr = $('<tr style="height: 35px;"></tr>');
            publisherTr.append($('<th rowspan="2">발행처(출판사)</th>'));
            publisherTr.append($('<td colspan="2"><input type="checkbox" id="pblc_nm" value="pblc" class="apply_field radio" checked="checked"/>&nbsp;<label for="pblc_nm" class="radio_label">발행처(출판사) 변경</label></td>'));
            $('#applyValue tbody').append(publisherTr);
            $('#applyValue tbody').append($('<tr style="height: 40px;"><td colspan="2">'+ $('#pblcPlcNm').val()+' => ' + data.publisher + '</td></tr>'));

            var issnTr = $('<tr style="height: 35px;"></tr>');
            issnTr.append($('<th rowspan="2">ISSN</th>'));
            issnTr.append($('<td colspan="2"><input type="checkbox" id="issn" value="issn" class="apply_field radio" checked="checked"/>&nbsp;<label for="issn" class="radio_label">ISSN 변경</label></td>'));
            $('#applyValue tbody').append(issnTr);
            $('#applyValue tbody').append($('<tr style="height: 40px;"><td colspan="2">'+$('#issnNo').val()+' => ' + data.issn + '</td></tr>'));

            var ntnTr = $('<tr style="height: 35px;"></tr>');
            ntnTr.append($('<th rowspan="2">발행국</th>'));
            ntnTr.append($('<td colspan="2"><input type="checkbox" id="ntn" value="ntn" class="apply_field radio" checked="checked"/>&nbsp;<label for="ntn" class="radio_label">발행국 변경</label></td>'));
            $('#applyValue tbody').append(ntnTr);
            $('#applyValue tbody').append($('<tr style="height: 40px;"><td colspan="2">'+$('#pblcNtnCd').val()+' => ' + data.countryCd +'</td></tr>'));

            $('#applyDiv').append($('<div class="list_set"><ul><li><a href="javascript:changeJournalField();" class="list_icon02">적용</a></li><li><a href="javascript:dhxWins.window(\'w1\').close();" class="list_icon10">취소</a></li></ul></div>'));
        }
        else
        {
            changeJournalDataWithoutCheckbox();
        }
    });
}

function changeJournalField(){

	if($('#jnl_regist').prop('checked'))
	{
        if(journalData.isSci == 'Y') $('#isSci').prop('checked', true);
        if(journalData.isScie == 'Y') $('#isScie').prop('checked', true);
        if(journalData.isSsci == 'Y') $('#isSsci').prop('checked', true);
        if(journalData.isAhci == 'Y') $('#isAhci').prop('checked', true);
        if(journalData.isEsci == 'Y') $('#isEsci').prop('checked', true);
        if(journalData.isScopus == 'Y') $('#isScopus').prop('checked', true);
        //if(data.isKci == 'Y') $('#isKci').prop('checked', true);
        if(journalData.krfRegPblcYn == '1')  $('#isKci').prop('checked', true);
        else if(journalData.krfRegPblcYn == '2')  $('#isKciCandi').prop('checked', true);
	}

    if($('#scjnl_nm').prop('checked'))
	{
        if(  journalData.isSci == 'Y' || journalData.isScie == 'Y' || journalData.isSsci == 'Y' || journalData.isAhci == 'Y' || journalData.isScopus == 'Y')
        {
            $('#scjnlNm').val(journalData.engTitle.replace("&amp;","&"));
        }
        else
		{
        	$('#scjnlNm').val(journalData.title.replace("&amp;","&"));
		}
	}

    if($('#pblc_nm').prop('checked'))
        $('#pblcPlcNm').val(journalData.publisher);

    if($('#issn').prop('checked'))
        $('#issnNo').val( journalData.issn);

    if($('#ntn').prop('checked'))
	{
        if(journalData.countryCd != '')
        {
            $('#pblcNtnCd option').removeAttr('selected');
            $('#pblcNtnCd').val(journalData.countryCd);
        }
	}

    isChange = true;
    dhxWins.window('w1').close();
    updateScjnlDvsValueByRadio();
}


function changeJournalDataWithoutCheckbox(){

    if(journalData.isSci == 'Y') $('#isSci').prop('checked', true);
    if(journalData.isScie == 'Y') $('#isScie').prop('checked', true);
    if(journalData.isSsci == 'Y') $('#isSsci').prop('checked', true);
    if(journalData.isAhci == 'Y') $('#isAhci').prop('checked', true);
    if(journalData.isEsci == 'Y') $('#isEsci').prop('checked', true);
    if(journalData.isScopus == 'Y') $('#isScopus').prop('checked', true);
    //if(data.isKci == 'Y') $('#isKci').prop('checked', true);
    if(journalData.krfRegPblcYn == '1')  $('#isKci').prop('checked', true);
    else if(journalData.krfRegPblcYn == '2')  $('#isKciCandi').prop('checked', true);

    if(  journalData.isSci == 'Y' || journalData.isScie == 'Y' || journalData.isSsci == 'Y' || journalData.isAhci == 'Y' || journalData.isScopus == 'Y')
	{
        $('#scjnlNm').val(journalData.engTitle.replace("&amp;","&"));
	}
	else
	{
    	$('#scjnlNm').val(journalData.title.replace("&amp;","&"));
	}

    $('#pblcPlcNm').val(journalData.publisher);
    $('#issnNo').val( journalData.issn);
    if(journalData.countryCd != '')
    {
        $('#pblcNtnCd option').removeAttr('selected');
        $('#pblcNtnCd').val(journalData.countryCd);
    }
    isChange = true;
    dhxWins.window('w1').close();
    updateScjnlDvsValueByRadio();
}

var dhxMailWins, mailWin;
function sendMailArticle(artilceId){

    var wWidth = 950;
    var wHeight = 850;

    var x = $(window).width() /2 - wWidth /2 + $(window).scrollLeft();
    var y = $(window).height() /2 - wHeight /2 + $(window).scrollTop();

    dhxMailWins = new dhtmlXWindows();
    dhxMailWins.attachViewportTo("winVp");

    mailWin = dhxMailWins.createWindow("w1", x, y, wWidth, wHeight);
    mailWin.setText("Send Mail");
    dhxMailWins.window("w1").setModal(true);
    $(".dhxwins_mcover").css("height",$(".popup_wrap").outerHeight());
    dhxMailWins.window("w1").denyMove();
    mailWin.attachURL(contextpath+"/mail/mailForm.do?rsltSe=ARTICLE&itemId="+artilceId);
}

function unloadDhxMailWins(){
	if(dhxMailWins != null && dhxMailWins.unload != null)
	{
        dhxMailWins.unload();
        dhxMailWins = null;
	}
}
