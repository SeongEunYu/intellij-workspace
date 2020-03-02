var dhxCnfrncWins, cnfrncLayout, cnfrncGrid, cnfrncToolbar, cnfrncAuthorGrid;
function findConferenceMaster(obj){
    var ancmYear = $("#ancmYear").val().trim();
    if(ancmYear.length == 0){
        dhtmlx.alert({type:"alert-warning",text:"발표일자의 연도를 입력해주세요.",callback:function(){}});
        return;
    }else if(Number(ancmYear) < 2018){
        edition = "2015";
    }else{
        edition = "2018";
    }

  var wWidth = 900;
  var wHeight = 550;
  pageX = $(window).width() /2 - wWidth /2 + $(window).scrollLeft();
  pageY = $(window).height() /2 - wHeight /2 + $(window).scrollTop();

  if(dhxCnfrncWins != null && dhxCnfrncWins.unload != null)
  {
    dhxCnfrncWins.unload();
    dhxCnfrncWins = null;
  }

  dhxCnfrncWins = new dhtmlXWindows({
    viewport : {objec : 'cnfrncWindVP'},
    wins : [ {id : 'w1', left : pageX, top : pageY, width: wWidth, height: wHeight, text: "학술대회(BK)검색", resize : false} ]
  });
  dhxCnfrncWins.window('w1').setModal(true);

  var srchKeyword = $('#schlshpCnfrncNm').val();
  srchKeyword = srchKeyword.substr(0,srchKeyword.indexOf('('));

  cnfrncLayout = dhxCnfrncWins.window('w1').attachLayout('2E')
  cnfrncLayout.cells('a').hideHeader();
  cnfrncLayout.cells('b').hideHeader();
  cnfrncLayout.cells("a").setHeight(40);
  cnfrncLayout.cells("a").attachURL(contextpath+"/"+preUrl+"/i18n/winhelp/help_findConferenceMaster.do");

  cnfrncToolbar = cnfrncLayout.cells("b").attachToolbar();
  cnfrncToolbar.setIconsPath(contextpath + "/images/common/icon/");
  cnfrncToolbar.setIconSize(18);
  cnfrncToolbar.addInput("srchKeyword", 0,  srchKeyword, 815);
  cnfrncToolbar.addButton("search", 1, "", "tbl_search_icon.png", "tbl_search_icon.png");
  cnfrncToolbar.attachEvent("onClick", function(id) { if (id == "search") cnfrncGrid_Load(); });
  cnfrncToolbar.attachEvent("onEnter", function(id,value) {
    if(value == "")
    {
      dhtmlx.alert({type:"alert-warning",text:"검색어를 입력하세요.",callback:function(){}})
    }
    else
    {
      cnfrncGrid_Load();
    }
    });

  cnfrncGrid = cnfrncLayout.cells("b").attachGrid();
  cnfrncGrid.setImagePath(dhtmlximagepath);
  cnfrncGrid.setHeader('학술대회코드,학술대회명,개최기관명,인정IF,Note,학술대회축약명,개최기관축약명',null, grid_head_center_bold);
  cnfrncGrid.setColumnIds("schlshpCnfrncCode,schlshpCnfrncFullNm,opmtInsttFullNm,impact,note,schlshpCnfrncAbbrNm,opmtInsttAbbrNm");
  cnfrncGrid.setInitWidths("80,500,145,60,250,1,1");
  cnfrncGrid.setColAlign('center,left,left,center,left,left,left');
  cnfrncGrid.setColTypes('ro,ro,ro,ro,ro,ro,ro');
  cnfrncGrid.setColSorting('str,str,str,str,str,str,str');
  cnfrncGrid.enableColSpan(true);
  cnfrncGrid.attachEvent("onXLS", function() { dhxCnfrncWins.window('w1').progressOn(); });
  cnfrncGrid.attachEvent("onXLE", function() { dhxCnfrncWins.window('w1').progressOff(); });
  cnfrncGrid.attachEvent('onRowSelect', cnfrncMaster_onRowSelect);
  cnfrncGrid.setColumnHidden(cnfrncGrid.getColIndexById("schlshpCnfrncAbbrNm"),true);
  cnfrncGrid.setColumnHidden(cnfrncGrid.getColIndexById("opmtInsttAbbrNm"),true);
  cnfrncGrid.init();
  cnfrncGrid_Load();

}

function cnfrncGrid_Load(){
  cnfrncGrid.clearAndLoad(contextpath+'/conference/findCnfrncMasterListByKeyword.do?srchKeyword=' + encodeURIComponent(cnfrncToolbar.getValue('srchKeyword')) + '&edition='+edition);
}

function cnfrncMaster_onRowSelect(rowId, index){
  var schlshpCnfrncNm = cnfrncGrid.cells(rowId,cnfrncGrid.getColIndexById("schlshpCnfrncFullNm")).getValue();
  	  schlshpCnfrncNm += '(' + cnfrncGrid.cells(rowId,cnfrncGrid.getColIndexById("schlshpCnfrncAbbrNm")).getValue().replace(/&amp;/g,'&') + ')';
  $('#schlshpCnfrncNm').val(schlshpCnfrncNm);
  $('#schlshpCnfrncNm').prop('readonly', 'readonly');
  $('#schlshpCnfrncCode').val(cnfrncGrid.cells(rowId,cnfrncGrid.getColIndexById("schlshpCnfrncCode")).getValue());
  $('#impctFctr').val(cnfrncGrid.cells(rowId,cnfrncGrid.getColIndexById("impact")).getValue());
  if(cnfrncGrid.cells(rowId,cnfrncGrid.getColIndexById("opmtInsttFullNm")).getValue())$('#pblcPlcNm').val(cnfrncGrid.cells(rowId,cnfrncGrid.getColIndexById("opmtInsttFullNm")).getValue());
  $('#schlshpCnfrncNm').prop('readonly','readonly');
  isChange = true;
  //$('#schlshpCnfrncNmLabel').empty();
  onFocusHelp('schlshpCnfrncNm');
  dhxCnfrncWins.unload();
  dhxCnfrncWins = null;
}

function srchCnfrnc(){
	var target = $('input[name="srchTrget"]:checked').val();
	var keyword = $('#srchKeyword').val();
	var pblcYear = $('#srchAncmYear').val();

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
		 var srchKeyword = $('#schlshpCnfrncNm').val();

	     if(dhxCnfrncWins != null && dhxCnfrncWins.unload != null)
	     {
	    	 dhxCnfrncWins.unload();
	    	 dhxCnfrncWins = null;
	     }

		if(target == 'rims')
		{
            runRIMSSearchPopup();
		}
		else if(target == 'doi' || target == 'crossref')
		{
            runDoiSearchPopup();
		}
		else if(target == 'scopus')
		{
            runScopusSearchPopup();
		}
	}
}

function runRIMSSearchPopup(){

    var w = 930;
    var h = 800
    var x = ($(window).width()/2) - (w/2);
    var y =  ($(window).height()/2) - (h/2);

    dhxCnfrncWins = new dhtmlXWindows({
        viewport : {objec : 'cnfrncWindVP'},
        wins : [ {id : 'w1', left : x, top : 0, width: w, height: h, text: "중복학술활동검색", resize : false} ]
    });

    cnfrncLayout = dhxCnfrncWins.window('w1').attachLayout('3E')
    cnfrncLayout.cells('a').hideHeader();
    cnfrncLayout.cells('b').hideHeader();
    cnfrncLayout.cells("a").setHeight(90);
    cnfrncLayout.cells("b").setHeight(150);
    cnfrncLayout.cells("c").hideHeader();
    cnfrncLayout.cells("c").attachHTMLString("<div id='conferenceViewForm' style='width:100%;height:100%;overflow:auto;'></div>");

    cnfrncGrid = cnfrncLayout.cells("b").attachGrid();
    cnfrncGrid.setImagePath(dhtmlximagepath);
    cnfrncGrid.setHeader('No.,ID,Title,Year,Volume,Issue,Start Page,Mode',null, grid_head_center_bold);
    cnfrncGrid.setColumnIds("no,conferenceId,orgLangPprNm,ancmYear,volume,issue,sttPage,mode");
    cnfrncGrid.setInitWidths("80,100,*,60,100,100,100,1");
    cnfrncGrid.setColAlign('center,left,left,center,center,center,center,center');
    cnfrncGrid.setColTypes('ro,ro,ro,ro,ro,ro,ro,ro');
    cnfrncGrid.setColSorting('str,str,str,str,str,str,str,na');
    cnfrncGrid.enableColSpan(true);
    cnfrncGrid.attachEvent("onXLS", function() { dhxCnfrncWins.window('w1').progressOn(); });
    cnfrncGrid.attachEvent("onXLE", function() { dhxCnfrncWins.window('w1').progressOff(); });
    cnfrncGrid.attachEvent('onRowSelect', cnfrncGid_onRowSelect);
    cnfrncGrid.setColumnHidden(cnfrncGrid.getColIndexById("mode"),true);
    cnfrncGrid.init();
    srchCnfrncGrid_Load();
}

function runDoiSearchPopup(){

    var w = 930;
    var h = 800
    var x = ($(window).width()/2) - (w/2);
    var y =  ($(window).height()/2) - (h/2);

    dhxVrfcWin = new dhtmlXWindows({
        viewport : {objec : 'windVP'},
        wins : [{id:'w1', left : x, top: 0, width: w, height: h, text:"논문검색", resize: true}]
    });
    dhxVrfcWin.window('w1').setModal(true);
    cnfrncLayout = dhxVrfcWin.window('w1').attachLayout('3E')
    cnfrncLayout.cells("a").hideHeader();
    cnfrncLayout.cells("a").setHeight(50);
    cnfrncLayout.cells("a").attachURL(contextpath+"/i18n/winhelp/help_searchByDoi.do");
    cnfrncLayout.cells("b").hideHeader();
    cnfrncLayout.cells("b").setHeight(120);
    cnfrncLayout.cells("c").hideHeader();
    cnfrncLayout.cells("c").attachHTMLString("<div id='conferenceViewForm' style='width:100%;height:100%;overflow:auto;'></div>");

    cnfrncGrid = cnfrncLayout.cells("b").attachGrid();
    cnfrncGrid.setImagePath(dhtmlximagepath);
    cnfrncGrid.setHeader("No.,ID,Title,Year,Volume,Issue,Start Page,End Page,ISSN,Journal,Publisher,authors,mode",null, grid_head_center_bold);
    cnfrncGrid.setColumnIds("no,articleId,orgLangPprNm,pblcYm,volume,issue,sttPage,endPage,issnNo,scjnlNm,pblcPlcNm,authors,mode");
    cnfrncGrid.setInitWidths("30,50,*,60,80,80,80,10,10,*,120,10,1");
    cnfrncGrid.setColAlign("center,center,left,center,center,center,center,center,center,center,center,center,center");
    cnfrncGrid.setColTypes("ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro");
    cnfrncGrid.enableColSpan(true);
    cnfrncGrid.attachEvent("onXLS", function() { cnfrncLayout.cells('b').progressOn(); });
    cnfrncGrid.attachEvent("onXLE", function() { cnfrncLayout.cells('b').progressOff(); });
    cnfrncGrid.setColumnHidden(cnfrncGrid.getColIndexById("volume"),true);
    cnfrncGrid.setColumnHidden(cnfrncGrid.getColIndexById("issue"),true);
    cnfrncGrid.setColumnHidden(cnfrncGrid.getColIndexById("sttPage"),true);
    cnfrncGrid.setColumnHidden(cnfrncGrid.getColIndexById("endPage"),true);
    cnfrncGrid.setColumnHidden(cnfrncGrid.getColIndexById("issnNo"),true);
    //cnfrncGrid.setColumnHidden(cnfrncGrid.getColIndexById("scjnlNm"),true);
    cnfrncGrid.setColumnHidden(cnfrncGrid.getColIndexById("publisher"),true);
    cnfrncGrid.setColumnHidden(cnfrncGrid.getColIndexById("authors"),true);
    cnfrncGrid.setColumnHidden(cnfrncGrid.getColIndexById("mode"),true);
    cnfrncGrid.init();
    cnfrncGrid.attachEvent('onRowSelect', doiConference_onRowSelect);
    srchCnfrncGrid_Load();
}

function runScopusSearchPopup(){

    var w = 930;
    var h = 800
    var x = ($(window).width()/2) - (w/2);
    var y =  ($(window).height()/2) - (h/2);

    dhxVrfcWin = new dhtmlXWindows({
        viewport : {objec : 'windVP'},
        wins : [{id:'w1', left : x, top: 0, width: w, height: h, text:"Scopus 학술활동 검색", resize: true}]
    });
    dhxVrfcWin.window('w1').setModal(true);

    cnfrncLayout = dhxVrfcWin.window('w1').attachLayout('3E')
    cnfrncLayout.cells("a").hideHeader();
    cnfrncLayout.cells("a").setHeight(90);
    //dhxVrfcLayout.cells('a').attachURL(contexPath +'/windowHelp/help13.jsp');
    cnfrncLayout.cells("b").hideHeader();
    cnfrncLayout.cells("b").setHeight(150);
    cnfrncLayout.cells("c").hideHeader();
    cnfrncLayout.cells("c").attachHTMLString("<div id='conferenceViewForm' style='width:100%;height:100%;overflow:auto;'></div>");

    cnfrncGrid = cnfrncLayout.cells("b").attachGrid();
    cnfrncGrid.setImagePath(dhtmlximagepath);
    cnfrncGrid.setHeader("No.,ID,Title,Year,Volume,Issue,Start Page,End Page,ISSN,scjnlNm,publisher,authors,mode",null, grid_head_center_bold);
    cnfrncGrid.setColumnIds("no,articleId,orgLangPprNm,pblcYm,volume,issue,sttPage,endPage,issnNo,scjnlNm,pblcPlcNm,authors,mode");
    cnfrncGrid.setInitWidths("30,40,*,80,10,10,100,10,10,10,300,10,1");
    cnfrncGrid.setColAlign("center,center,left,center,center,center,center,center,center,center,left,center,center");
    cnfrncGrid.setColTypes("ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro");
    cnfrncGrid.enableColSpan(true);
    cnfrncGrid.attachEvent("onXLS", function() { cnfrncLayout.cells('b').progressOn(); });
    cnfrncGrid.attachEvent("onXLE", function() { cnfrncLayout.cells('b').progressOff(); });
    cnfrncGrid.setColumnHidden(cnfrncGrid.getColIndexById("volume"),true);
    cnfrncGrid.setColumnHidden(cnfrncGrid.getColIndexById("issue"),true);
    cnfrncGrid.setColumnHidden(cnfrncGrid.getColIndexById("endPage"),true);
    cnfrncGrid.setColumnHidden(cnfrncGrid.getColIndexById("issnNo"),true);
    cnfrncGrid.setColumnHidden(cnfrncGrid.getColIndexById("scjnlNm"),true);
    //cnfrncGrid.setColumnHidden(cnfrncGrid.getColIndexById("pblcPlcNm"),true);
    cnfrncGrid.setColumnHidden(cnfrncGrid.getColIndexById("authors"),true);
    cnfrncGrid.setColumnHidden(cnfrncGrid.getColIndexById("mode"),true);
    cnfrncGrid.init();
    cnfrncGrid.attachEvent('onRowSelect', scopusConference_onRowSelect);
    srchCnfrncGrid_Load();
}

function resultConferenceInput(){
	$('#scjnlDvsCd').val($('#rslt_scjnlDvsCd').val());
	$('#pblcNtnCd').val($('#rslt_pblcNtnCd').val());
	$('#hldSttYear').val($('#rslt_hldSttYear').val());
	$('#hldSttMonth').val($('#rslt_hldSttMonth').val());
	$('#hldSttDay').val($('#rslt_hldSttDay').val());
	$('#hldEndYear').val($('#rslt_hldEndYear').val());
	$('#hldEndMonth').val($('#rslt_hldEndMonth').val());
	$('#hldEndDay').val($('#rslt_hldEndDay').val());
	$('#ancmYear').val($('#rslt_ancmYear').val());
	$('#ancmMonth').val($('#rslt_ancmMonth').val());
	$('#ancmDay').val($('#rslt_ancmDay').val());
	$('#isbnNo').val($('#rslt_isbnNo').val());
	$('#pblcPlcNm').val($('#rslt_pblcPlcNm').val());
	$('#cfrcNm').val($('#rslt_cfrcNm').val());
	$('#scjnlNm').val($('#rslt_scjnlNm').val());
	$('#ancmDate').val($('#rslt_ancmDate').val());
	$('#pprLangDvsCd').val($('#rslt_pprLangDvsCd').val());
	$('#ancmPlcNm').val($('#rslt_ancmPlcNm').val());
	//$('#volume').val($('#rslt_volume').val());
	//$('#issue').val($('#rslt_issue').val());
	$('#sttPage').val($('#rslt_sttPage').val());
	$('#endPage').val($('#rslt_endPage').val());
	$('#doi').val($('#rslt_doi').val());
	//$('#url').val($('#rslt_url').val());
	$('#orgLangPprNm').val($('#rslt_orgLangPprNm').val());
	$('#abstCntn').val($('#rslt_abstCntn').val());

	$('#totalAthrCnt').val($('#rslt_totalAthrCnt').val());

	var totalAthrCnt = $('#rslt_totalAthrCnt').val()*1;
	for(var i=1; i < totalAthrCnt+1; i++)
	{
		$('#blngAgcCd_'+prtcpntIdx).val('');
		$('.dispDept').empty();

		$('#prtcpntId_'+(prtcpntIdx)).val($('#rslt_parti_prtcpntId_'+i).val());
		$('#prtcpntNm_'+(prtcpntIdx)).val($('#rslt_parti_prtcpntNm_'+i).val());
		$('#prtcpntFullNm_'+(prtcpntIdx)).val($('#rslt_parti_prtcpntFullNm_'+i).val());
		$('#tpiDvsCd_'+(prtcpntIdx)).val($('#rslt_parti_tpiDvsCd_'+i).val());
		$('#blngAgcNm_'+(prtcpntIdx)).val($('#rslt_parti_blngAgcNm_'+i).val());
		if(i < (totalAthrCnt))
			$('#prtcpntTbody').find('.row_add_bt').last().trigger('click');
	}
	dhxVrfcWin.unload();
	dhxVrfcWin = null;

	if(sessMode == 'true' || loginAuthor == 'R' || loginAuthor == 'S')
	{
		choiceSelf();
	}
}

function scopusConference_onRowSelect(id, index){

	var mode = cnfrncGrid.cells(id, cnfrncGrid.getColIndexById("mode")).getValue();
	var srchTrget = $('input[name="srchTrget"]:checked').val();

	$('#conferenceViewForm').empty();
	cnfrncLayout.cells('c').progressOn();
	$.ajax({
		url:contextpath+'/conference/overviewPopup.do',
		data: {"mode":mode,"srchTrget":srchTrget , "eid":id}
	}).done(function(data){
			$('#conferenceViewForm').html(data);
			cnfrncLayout.cells('c').progressOff();
	});
}

function doiConference_onRowSelect(id, index){
	var param = {
			"mngNo" : id,
            "conferenceId" : id,
			"orgLangPprNm" : cnfrncGrid.cells(id, cnfrncGrid.getColIndexById("orgLangPprNm")).getValue(),
			"ancmDate" : cnfrncGrid.cells(id, cnfrncGrid.getColIndexById("pblcYm")).getValue(),
			"volume" : cnfrncGrid.cells(id, cnfrncGrid.getColIndexById("volume")).getValue(),
			"issue" : cnfrncGrid.cells(id, cnfrncGrid.getColIndexById("issue")).getValue(),
			"sttPage" : cnfrncGrid.cells(id, cnfrncGrid.getColIndexById("sttPage")).getValue(),
			"endPage" : cnfrncGrid.cells(id, cnfrncGrid.getColIndexById("endPage")).getValue(),
			"issnNo" : cnfrncGrid.cells(id, cnfrncGrid.getColIndexById("issnNo")).getValue(),
			"scjnlNm" : cnfrncGrid.cells(id, cnfrncGrid.getColIndexById("scjnlNm")).getValue(),
			"pblcPlcNm" : cnfrncGrid.cells(id, cnfrncGrid.getColIndexById("pblcPlcNm")).getValue(),
			"authors" : cnfrncGrid.cells(id, cnfrncGrid.getColIndexById("authors")).getValue(),
			"mode" : cnfrncGrid.cells(id, cnfrncGrid.getColIndexById("mode")).getValue(),
            "srchTrget" : $('input[name="srchTrget"]:checked').val(),
            "srchKeyword" : $('#srchKeyword').val()
	};
	$.ajax({
		url:contextpath+'/conference/overviewPopup.do',
		data: param
	}).done(function(data){ $('#conferenceViewForm').html(data); })

}

function conferenceInput(rowId){
	$('#orgLangPprNm').val(cnfrncGrid.cells(rowId, cnfrncGrid.getColIndexById("orgLangPprNm")).getValue());
	$('#volume').val(cnfrncGrid.cells(rowId, cnfrncGrid.getColIndexById("volume")).getValue());
	$('#issue').val(cnfrncGrid.cells(rowId, cnfrncGrid.getColIndexById("issue")).getValue());
	$('#issnNo').val(cnfrncGrid.cells(rowId, cnfrncGrid.getColIndexById("issnNo")).getValue());
	$('#scjnlNm').val(cnfrncGrid.cells(rowId, cnfrncGrid.getColIndexById("scjnlNm")).getValue());
	$('#pblcPlcNm').val(cnfrncGrid.cells(rowId, cnfrncGrid.getColIndexById("pblcPlcNm")).getValue());
	$('#sttPage').val(cnfrncGrid.cells(rowId, cnfrncGrid.getColIndexById("sttPage")).getValue());
	$('#endPage').val(cnfrncGrid.cells(rowId, cnfrncGrid.getColIndexById("endPage")).getValue());
	var pblcYm = cnfrncGrid.cells(rowId, cnfrncGrid.getColIndexById("pblcYm")).getValue();
	if(pblcYm.length == 4 )
		$('#ancmYear').val(pblcYm);
	else if(pblcYm.length == 6)
		$('#ancmYear').val(pblcYm.substr(0,4));

	var authors = cnfrncGrid.cells(rowId, cnfrncGrid.getColIndexById("authors")).getValue();
	var authorArr = authors.split("and");
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

function srchCnfrncGrid_Load(){
	cnfrncGrid.clearAndLoad(contextpath+'/conference/findByKeywordAndAncmYear.do?' + $('#vrfcFrm').serialize());
}

function cnfrncGid_onRowSelect(id, index){
    if("nodata" != id)
	    $.post(contextpath+'/conference/overviewPopup.do',{'conferenceId' : id, 'mode' : 'dplct'},null,'text').done(function(data){$('#conferenceViewForm').html(data);});
    else
        return;
}

var dhxAuthrWin, dhxAuthrLayout, authrGrid;
function choiceSelf(){
    var wWidth = 250;
    var wHeight = 350;

    pageX = $(window).width() /2 - wWidth /2 + $(window).scrollLeft();
    pageY = $(window).height() /2 - wHeight /2 + $(window).scrollTop();

	if(dhxAuthrWin != null && dhxAuthrWin.unload != null)
	{
		dhxAuthrWin.unload();
		dhxAuthrWin = null;
	}
	dhxAuthrWin = new dhtmlXWindows({
		viewport : {objec : 'windVP'},
		wins : [{id:'w1', left : pageX, top: pageY, width:wWidth, height:wHeight, text:"저자선택", resize: true}]
	});
	dhxAuthrWin.window('w1').setModal(true);

	dhxAuthrLayout = dhxAuthrWin.window('w1').attachLayout('2E')
	dhxAuthrLayout.cells("a").hideHeader();
	dhxAuthrLayout.cells("a").setHeight(70);
	//dhxAuthrLayout.cells("a").attachURL(contextpath+"/i18n/winhelp/help_findDplctArticleFromRIMS.do");
	dhxAuthrLayout.cells("b").hideHeader();
	//dhxAuthrLayout.cells("b").setHeight(150);

	authrGrid = dhxAuthrLayout.cells("b").attachGrid();
	authrGrid.setImagePath(dhtmlximagepath);
	authrGrid.setHeader("No,Name",null, grid_head_center_bold);
	authrGrid.setInitWidths("40,*");
	authrGrid.setColAlign("center,left");
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
	$('#blngAgcCd_'+id).val(instcode);
	$('#blngAgcNm_'+id).val(instname);
	dhxAuthrWin.unload();
	dhxAuthrWin = null;
}


function conferenceMove(conferenceId){
	if(conferenceId != undefined && conferenceId != null && conferenceId != '')
	{
		dhtmlx.confirm({
			ok:"이동", cancel:"취소",
			text:"해당페이지로 이동하시겠습니까?",
			callback:function(result){
				if(result == true)
				{
					$(location).attr('href',contextpath + '/conference/dplct/conferencePopup.do?conferenceId='+conferenceId);
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

function clearBkData(){
	$('#pblcPlcNm').val('');
	$('#schlshpCnfrncNm').val('');
	$('#schlshpCnfrncCode').val('');
	$('#impctFctr').val('');
	onBlurHelp('schlshpCnfrncNm');
	isChange = true;
}

