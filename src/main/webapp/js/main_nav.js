var showDelay = 500, hideDelay = 200, checkTimer;
$(function() {
	gnb_init();
});

function gnb_init() {
	clearTimeout(checkTimer);
    if($("#gnb").size() == 0) return;
    $("#gnb").removeClass("gnb_nojs");
    var gnb_menu = $("#gnb .menu");
    var gnb_submenu = $("#gnb .sub_menu");
	var gnb_submenu_ul = $("#gnb .sub_menu ul");
    /* var gnb_bg = $("#navul_wrap").next(".gnb_bg"); */
    var gnb_bg = $(".gnb_bg");
    var gnb_interval = null;

    function gnb_show() {
        clearTimeout(gnb_interval);
        gnb_submenu.fadeIn( 0 );
		gnb_submenu_ul.fadeIn( 0 );
        gnb_bg.fadeIn( 0 );
    }

    function gnb_hide() {
        clearTimeout(gnb_interval);
        gnb_interval = setTimeout(function() {
            gnb_submenu.fadeOut( 0 );
			gnb_submenu_ul.fadeOut( 0 );
            gnb_bg.fadeOut( 0 );
        },0);
    }

    function gnb_over(type,target) {
        var get_menu = $(target).closest(".menu");
        if(type) {
            get_menu.children(".nav_menu_a").addClass("on");
            get_menu.children(".sub_menu").addClass("on");
        }
        else {
            get_menu.children("a").children("img").attr("src",function() { return this.src.replace("_over",""); });
            get_menu.children(".nav_menu_a").removeClass("on");
            get_menu.children(".sub_menu").removeClass("on");
        }
    }

    $("#gnb").click(function(){
    	gnb_show();
    });

    //gnb 마우스 오버 이벤트
    $("#gnb").hover(
        function() {
        	if(checkTimer != null){ clearTimeout(checkTimer); checkTimer = null; }
        	checkTimer = setTimeout(function() {
        		gnb_show();
        	}, showDelay);
        },
        function() {
        	if(checkTimer != null){ clearTimeout(checkTimer); checkTimer = null; }
        	checkTimer = setTimeout(function() {
        		gnb_hide();
        	}, hideDelay);
        }
    ).children(".menu").hover(
        function() {
        	gnb_over(true,this);
        },
        function() {
        	gnb_over(false,this);
        }
    )
    //gnb 포커스 이벤트
    .on("focusin",function() {
    	gnb_over(true,this);
    }).on("focusout",function() {
        gnb_over(false,this);
    });

    $("#gnb").on("focusin",function() {
    	if(checkTimer != null){ clearTimeout(checkTimer); checkTimer = null; }
    	checkTimer = setTimeout(function() {
    		gnb_show();
    	}, showDelay);
    }).on("focusout",function() {
    	if(checkTimer != null){ clearTimeout(checkTimer); checkTimer = null; }
    	checkTimer = setTimeout(function() {
    		gnb_hide();
    	}, hideDelay);
    });
    /*
    gnb_bg.hover(
        function() { clearTimeout(gnb_interval); },
        function() { gnb_hide();}
    );
     */
};

function fn_selectOption(btn, message){
	var $p = btn.parent();
	$p.find('button').removeClass('on');
	btn.addClass('on');
	if(btn.prop('id') == 'btnOutput')
	{
		$('.search_int').prop('placeholder',message).prop('title','성과검색');
		$('#srchTrget').val("output");
	}
	else if(btn.prop('id') == 'btnRsrchr')
	{
		$('.search_int').prop('placeholder',message).prop('title','연구자검색');
		$('#srchTrget').val("researcher");
	}
}
/*
function fn_search(){
	var objId = $('.search_opion').find('.on').prop('id');
	var srchTrget = "";

	if(objId == 'btnOutput') srchTrget = 'output';
	else if(objId == 'btnRsrchr') srchTrget = 'researcher';

	var menuFrm = $('#menuFrm');
	menuFrm.empty();
	menuFrm.append($('<input type="hidden" name="srchTrget" value="'+srchTrget+'" />'));
	menuFrm.append($('<input type="hidden" name="keyword" value="' + $('#searchKeyword').val() + '" />'));
	menuFrm.prop("action",contextpath+'/'+dPreUrl+'/search/result.do');
	menuFrm.prop("method",'GET');
	menuFrm.submit();
}
*/
function fn_userPopup(url, trgetUser){
	var wWidth = 1024;
	var wHeight = 822;

	if(url.indexOf('infoOthbcForm') != -1) wHeight = 410;

	var leftPos = (screen.width - wWidth)/2;
	var topPos = (screen.height - wHeight)/2;

	var userPopup = window.open('about:blank', 'userPopup', 'width='+wWidth+',height='+wHeight+',top='+topPos+',left='+leftPos+',location=no,scrollbars=yes,resizeable=yes');
	var popFrm = $('#popFrm');
	popFrm.empty();
	if(trgetUser !=  undefined && trgetUser != null && trgetUser != '')
	 popFrm.append($('<input type="hidden" name="srchUserId" value="'+trgetUser+'" />'))
	popFrm.attr('target', 'userPopup');
	popFrm.prop("action",url);
	popFrm.prop("method",'POST');
	popFrm.submit();
	userPopup.focus();
}


function fn_searchResearcherPopup(url){
	var wWidth = 1024;
	var wHeight = 822;

	var leftPos = (screen.width - wWidth)/2;
	var topPos = (screen.height - wHeight)/2;

	var userPopup = window.open('about:blank', 'researcherPopup', 'width='+wWidth+',height='+wHeight+',top='+topPos+',left='+leftPos+',location=no,scrollbars=yes,resizeable=yes');
	var popFrm = $('#popFrm');
	popFrm.empty();
	popFrm.attr('target', 'researcherPopup');
	popFrm.prop("action", contextpath + "/search/similrResearcherPopup.do");
	popFrm.prop("method",'POST');
	popFrm.submit();
	userPopup.focus();
}


function fn_setMainLayoutHeight(obj){
	var layoutHeight = $(window).height();
	if($('.title_box').height() != undefined)
		layoutHeight -= $('.title_box').height();
	if($('.view_tbl').height() != undefined)
		layoutHeight -= $('.view_tbl').height();
	if($('.list_bt_area').height() != undefined)
		layoutHeight -= $('.list_bt_area').height();
	if($('.header_wrap').height() != undefined)
		layoutHeight -= $('.header_wrap').height();
	if($('.nav_wrap').height() != undefined)
		layoutHeight -= $('.nav_wrap').height();
	layoutHeight += 160;
	$(obj).css('height',layoutHeight+"px");
}

function fn_resume(){

	var type = $('#resumeType').val();

	if(type != undefined && type != 'hwp') //Resume
	{
		if($('.chk_rslt:checked').length > 0)
		{
			location.href = contextpath+"/servlet/resume.do?" + $('#resumeFrm').serialize();
			$('.chk_rslt').prop('checked',false);
			$('#closeBtn').trigger('click');
		}
		else
		{
			dhtmlx.alert({type:"alert-warning",text:"Resume로 출력할 성과를 선택하세요.",callback:function(){}});
			return;
		}
	}
	else if(type == 'hwp') //연구계획서용
	{
        location.href = contextpath+"/download/hml.do?" + $('#resumeFrm').serialize();
        $('#closeBtn').trigger('click');
	}
}