function searchTutorRschr(){
	var wWidth = 550;
	var wHeight = 440;
	var leftPos = (screenWidth - wWidth)/2;
	var topPos = (screenHeight - wHeight)/2;
	var url = 'https://www.kri.go.kr/kri/ra/cm/sso/wisesso_pop_utf8.jsp';
	var tutorRschrPopup = window.open('about:blank', 'tutorRschrPopup', 'width='+wWidth+'px,height='+wHeight+'px,top='+topPos+',left='+leftPos+' location=no,scrollbars=yes,resizeable=no');
	var popFrm = $('#frmKri');
	popFrm.empty();
	popFrm.append($('<input type="hidden" name="Kri_Param1" value="'+instcode+'"/>'));
	popFrm.append($('<input type="hidden" name="Kri_Param9" value="'+rimsUrl+contextpath+'/jsp/kriRslt.jsp"/>'));
	popFrm.append($('<input type="hidden" name="iKri_charset" value=""/>'));
	popFrm.append($('<input type="hidden" name="Kri_Service" value="13"/>'));
	popFrm.attr('action',url);
	popFrm.attr('target', 'tutorRschrPopup');
	popFrm.attr('method', 'POST');
	popFrm.submit();
}

var dhxDgrUserWins, dhxDgrUserLayout, dhxDgrUserToolbar, dhxDgrUserGrid
function findDegreeUser(){

	var wWidth = 600;
	var wHeight = 350;
	var leftPos = Math.max(0, (($(document).width() - wWidth) / 2) + $(document).scrollLeft());
	var topPos = Math.max(0, (($(document).height() - wHeight) / 2) + $(document).scrollTop());

	if(dhxDgrUserWins != null && dhxDgrUserWins.unload != null)
	{
		dhxDgrUserWins.unload();
		dhxDgrUserWins = null;
	}

	dhxDgrUserWins = new dhtmlXWindows({
		viewport : {objec : 'windVP'},
		wins : [ {id : 'w1', left : leftPos, top : topPos, width: wWidth, height: wHeight, text: '연구자검색', resize : false} ]
	});

	dhxDgrUserLayout = dhxDgrUserWins.window('w1').attachLayout('2E');
	dhxDgrUserLayout.cells("a").hideHeader();
	dhxDgrUserLayout.cells("b").hideHeader();
	//dhxDgrUserLayout.cells("a").attachURL(rimsPath+"/windowHelp/help10.jsp");
	dhxDgrUserLayout.cells("a").setHeight(55);

	dhxDgrUserToolbar = dhxDgrUserLayout.cells("b").attachToolbar();
	dhxDgrUserToolbar.setIconsPath(contextpath+"/images/common/icon/");
	dhxDgrUserToolbar.addInput("keyword", 0, $('#korNm').val(), 515);
	dhxDgrUserToolbar.addButton("search", 1, "", "tbl_search_icon.png", "tbl_search_icon.png");
	dhxDgrUserToolbar.attachEvent("onClick", function(id) {
		if (id == "search"){
			dhxDgrUserGrid.clearAndLoad(contextpath+'/user/findAuthorListByKeyword.do?keyword=' + encodeURIComponent(dhxDgrUserToolbar.getValue('keyword')));
		}
	});
	dhxDgrUserToolbar.attachEvent("onEnter", function(id,value) {
		if (value == "")
		{
			dhtmlx.alert({type:"alert-warning",text:"검색어를 입력하세요.",callback:function(){}});
		}
		else
		{
			dhxDgrUserGrid.clearAndLoad(contextpath+ '/user/findAuthorListByKeyword.do?keyword=' + encodeURIComponent(dhxDgrUserToolbar.getValue('keyword')));
		}
	});

	dhxDgrUserGrid = dhxDgrUserLayout.cells("b").attachGrid();
	dhxDgrUserGrid.setImagePath(contextpath+'/js/codebase/imgs/');
	dhxDgrUserGrid.setHeader(getText("tit_res_grid"),null,grid_head_center_bold);
	dhxDgrUserGrid.setInitWidths("60,90,90,90,*,100");
	dhxDgrUserGrid.setColAlign("center,left,left,center,left,left");
	dhxDgrUserGrid.setColTypes("ro,ro,ro,ro,ro,ro");
	dhxDgrUserGrid.setColSorting("str,str,str,str,str,str");
	dhxDgrUserGrid.enableColSpan(true);
	dhxDgrUserGrid.attachEvent("onXLS", function() {
		dhxDgrUserWins.window('w1').progressOn();
	});
	dhxDgrUserGrid.attachEvent("onXLE", function() {
		dhxDgrUserWins.window('w1').progressOff();
	});
	dhxDgrUserGrid.attachEvent('onRowSelect', function(rowId){
		var userData = rowId.split(';');
		$('#userId').val(userData[0]);
		$('#korNm').val(userData[1]);
		isChange = true;
		dhxDgrUserWins.window('w1').close();
	});
	dhxDgrUserGrid.init();
	$('.dhxtoolbar_input').focus();
	if (dhxDgrUserToolbar.getValue('keyword') != "") dhxDgrUserGrid.loadXML(contextpath+'/user/findAuthorListByKeyword.do?keyword=' + encodeURIComponent(dhxDgrUserToolbar.getValue('keyword')));
}