var dhxRptWins, dhxRptLayout, dhxRptToolbar, dhxRptGrid;
function findReportFunding(btn,e){

	var wWidth = 900;
	var wHeight = 350;
	var leftPos = Math.max(0, (($(document).width() - wWidth) / 2) + $(document).scrollLeft());
	var topPos = Math.max(0, (($(document).height() - wHeight) / 2) + $(document).scrollTop());

	if(dhxRptWins != null && dhxRptWins.unload != null)
	{
		dhxRptWins.unload();
		dhxRptWins = null;
	}

	var srchKeyword = $('#rschSbjtNm').val();

	dhxRptWins = new dhtmlXWindows({
		viewport : {objec : 'windVP'},
		wins : [ {id : 'w1', left : leftPos, top : topPos, width: wWidth, height: wHeight, text: "연구과제검색", resize : false} ]
	});
	dhxRptLayout = dhxRptWins.window('w1').attachLayout('2E')
	dhxRptLayout.cells('a').hideHeader();
	dhxRptLayout.cells('b').hideHeader();
	dhxRptLayout.cells("a").setHeight(60);
	dhxRptLayout.cells("a").attachURL(contextpath+"/"+preUrl+"/i18n/winhelp/help_findFunding.do");

	var initYearMonth = (new Date().getFullYear() - 7) + "01" ;
	var endYearMonth = '999912';

	var toolbarText = '<div class="r_add_bt" style="margin-top:-2px;">';
		toolbarText += '<form id="srchFundingFrm">';

		if(sessMode == 'true' || loginAuthor == 'R' || loginAuthor == 'S')
			toolbarText += '<input type="radio" name="srchGroup" id="srchGroup_User" value="USER" style="vertical-align:middle;width:12px;height:12px;" checked="checked" />';
		else
			toolbarText += '<input type="radio" name="srchGroup" id="srchGroup_User" value="USER" style="vertical-align:middle;width:12px;height:12px;" />';
		toolbarText += '<label for="group_p">'+getText('tit_fund_gubun_person')+'</label>&nbsp;&nbsp;';
		if(sessMode == 'true' || loginAuthor == 'R' || loginAuthor == 'S')
			toolbarText += '<input type="radio" name="srchGroup" id="srchGroup_All" value="ALL" style="vertical-align:middle;width:12px;height:12px;" />';
		else
			toolbarText += '<input type="radio" name="srchGroup" id="srchGroup_All" value="ALL" style="vertical-align:middle;width:12px;height:12px;" checked="checked"/>';
		toolbarText += '<label for="group_a">'+getText('tit_fund_gubun_all')+'</label>&nbsp;&nbsp;';
		toolbarText += '<span style="margin-right:20px;"></span>';
		toolbarText += getText('tit_fund_period');
		if(sessMode == 'true' || loginAuthor == 'R' || loginAuthor == 'S')
		{
			toolbarText += '<input type="text" id="sttDate" name="sttDate" class="input_type" value="" maxlength="6" style="text-align:center;width:100px;" /> ~ ';
			toolbarText += '<input type="text" id="endDate" name="endDate" class="input_type" value="" maxlength="6" style="text-align:center;width:100px;" />';
		}
		else
		{
			toolbarText += '<input type="text" id="sttDate" name="sttDate" class="input_type" value="'+initYearMonth+'" maxlength="6" style="text-align:center;width:100px;" /> ~ ';
			toolbarText += '<input type="text" id="endDate" name="endDate" class="input_type" value="'+endYearMonth+'" maxlength="6" style="text-align:center;width:100px;" />';
		}
		toolbarText += '<span style="margin-right:20px;"></span>';
		toolbarText += getText('tit_fund_sub');
		toolbarText += '<input type="text" id="srchKeyword" name="srchKeyword" class="input_type" value="'+srchKeyword+'" style="width:400px;" onkeydown="if(event.keyCode==13){$(\'#srchBtn\').trigger(\'click\');}"/>';
		toolbarText += '<a href="javascript:void(0);" id="srchBtn" class="tbl_search_bt" >검색</a>';
		toolbarText += '</form>';
	dhxRptToolbar = dhxRptLayout.cells("b").attachToolbar();
	dhxRptToolbar.setIconsPath(contextpath + "/images/common/icon/");
	dhxRptToolbar.setIconSize(18);
	dhxRptToolbar.addText("funding", 0, toolbarText);
	setTimeout(function() {
		var dhxCellToolbarDef =  $('#srchFundingFrm').parent().parent().parent().parent().parent();
		dhxCellToolbarDef.css({'border-width':'1px', 'border-bottom':'0px'});
		$('#srchBtn').click(function(){
			var srchGubun = $('input:radio[name="srchGroup"]:checked').val();
			if(srchGubun == 'ALL' && ($('#sttDate').val() == ''|| $('#endDate').val() == '') )
			{
				dhtmlx.alert({type:"alert-warning",text:"전체 연구과제 검색의 경우 연구기간을 입력해야합니다.",callback:function(){
					if($('#sttDate').val() == '') $('#sttDate').focus();
					else $('#endDate').focus();
				}})
				return;
			}
			else
			{
				var sttDateValue = $('#sttDate').val();
				var endDateVaoue = $('#endDate').val();
				if( sttDateValue != '' && endDateVaoue != '' &&  sttDateValue > endDateVaoue)
				{
					dhtmlx.alert({type:"alert-warning",text:"시작년월은 종료년월보다 작아야 합니다. 다시 입력하세요",callback:function(){
						$('#sttDate').val('').focus();
					}})
					return;
				}

				dhxRptGrid.clearAndLoad(contextpath+'/article/getFunding.do?' + $('#srchFundingFrm').serialize());
			}
		});

	}, 100);

	 dhxRptGrid = dhxRptLayout.cells("b").attachGrid();
	 dhxRptGrid.setImagePath(dhtmlximagepath);
	 dhxRptGrid.setHeader('관리번호,연구기간,과제명,기관과제번호,과제번호,시작일자,종료일자,지원기관,수행기관,소관부처',null, grid_head_center_bold);
	 dhxRptGrid.setColumnIds("fundingId,rschYm,rschSbjtNm,agcSbjtNo,sbjtNo,rschCmcmYm,rschEndYm,rsrcctSpptAgcNm,blngUnivNm,cptGovOfficNm");
	 dhxRptGrid.setInitWidths("80,145,*,120,120,1,1,1,1,1");
	 dhxRptGrid.setColAlign('center,center,left,center,center,center,center,center,center,center');
	 dhxRptGrid.setColTypes('ro,ro,ro,ro,ro,ro,ro,ro,ro,ro');
	 dhxRptGrid.setColSorting('str,str,str,str,str,str,str,str,str,str');
	 dhxRptGrid.enableColSpan(true);
	 dhxRptGrid.attachEvent("onXLS", function() { dhxRptLayout.cells("b").progressOn(); });
	 dhxRptGrid.attachEvent("onXLE", function() { dhxRptLayout.cells("b").progressOff();});
	 dhxRptGrid.attachEvent('onRowSelect', rptFunding_onRowSelect);
	 dhxRptGrid.setColumnHidden(dhxRptGrid.getColIndexById("rschCmcmYm"),true);
	 dhxRptGrid.setColumnHidden(dhxRptGrid.getColIndexById("rschEndYm"),true);
	 dhxRptGrid.setColumnHidden(dhxRptGrid.getColIndexById("rsrcctSpptAgcNm"),true);
	 dhxRptGrid.setColumnHidden(dhxRptGrid.getColIndexById("blngUnivNm"),true);
	 dhxRptGrid.setColumnHidden(dhxRptGrid.getColIndexById("cptGovOfficNm"),true);
	 dhxRptGrid.init();
	 if(sessMode == 'true' || loginAuthor == 'R' || loginAuthor == 'S')
	 {
		 dhxRptGrid.loadXML(contextpath+'/article/getFunding.do?' + $('#srchFundingFrm').serialize());
	 }
	 else
	 {
		 if(srchGubun == 'ALL' && ($('#sttDate').val() != ''|| $('#endDate').val() != '' || $('#srchKeyword').val() != '' ))
			 dhxRptGrid.loadXML(contextpath+'/article/getFunding.do?' + $('#srchFundingFrm').serialize());
	 }
}

function rptFunding_onRowSelect(rowId,celInd){
	if(dhxRptGrid != null)
	{
		$('#sbjtNo').val(dhxRptGrid.cells(rowId, dhxRptGrid.getColIndexById("sbjtNo")).getValue());
		$('#detailSbjtNo').val(dhxRptGrid.cells(rowId, dhxRptGrid.getColIndexById("agcSbjtNo")).getValue());
		$('#fundingId').val(dhxRptGrid.cells(rowId, dhxRptGrid.getColIndexById("fundingId")).getValue());
		$('#rschSbjtNm').val(dhxRptGrid.cells(rowId, dhxRptGrid.getColIndexById("rschSbjtNm")).getValue());

		$('#orderInsttNm').val(dhxRptGrid.cells(rowId, dhxRptGrid.getColIndexById("rsrcctSpptAgcNm")).getValue());
		$('#sbjtExcInsttNm').val(dhxRptGrid.cells(rowId, dhxRptGrid.getColIndexById("blngUnivNm")).getValue());
		$('#sbjtManageInsttNm').val(dhxRptGrid.cells(rowId, dhxRptGrid.getColIndexById("cptGovOfficNm")).getValue());

		var sttYm = dhxRptGrid.cells(rowId, dhxRptGrid.getColIndexById("rschCmcmYm")).getValue();
		var endYm = dhxRptGrid.cells(rowId, dhxRptGrid.getColIndexById("rschEndYm")).getValue();
		if(sttYm != null)
		{
			$('#thsyrRsrchSttYear').val(sttYm.substr(0,4));
			$('#thsyrRsrchSttMonth').val(sttYm.substr(4,2));
		}
		if(endYm != null)
		{
			$('#thsyrRsrchEndYear').val(endYm.substr(0,4));
			$('#thsyrRsrchEndMonth').val(endYm.substr(4,2));
		}
	}
	isChange = true;
	dhxRptWins.window('w1').close();
}