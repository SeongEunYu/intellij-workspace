jQuery(function($){
	var article = $('.left_nav>.nav_Body>.article');
	$('.left_nav>.nav_Body>.article>.nav_menu>a').click(function(){
		var myArticle = $(this).parents('.article:first');
		if(myArticle.hasClass('hide')){
			article.addClass('hide').removeClass('show');
			article.find('.nav_sub').slideUp(100);
			myArticle.removeClass('hide').addClass('show');
			myArticle.find('.nav_sub').slideDown(100);
		} else {
			myArticle.removeClass('show').addClass('hide');
			myArticle.find('.nav_sub').slideUp(100);
		}
		return false;
	});
});

function registNoteiceCookie(obj){
	$.cookie('noticeCheck', 'done', {expires : 1, path: '/', secure: true} );
	obj.css('display','none');
}

function menuSumbit(action, anchor){
	var pLi = anchor.parent();
	while(!pLi.hasClass("article")) pLi = pLi.parent();
	$('#menuFrm').append($('<input type="hidden" id="pMenuId" name="pMenuId" value="'+pLi.attr('id')+'"/>'));
	$('#menuFrm').append($('<input type="hidden" id="navBody" name="navBody" value="'+pLi.parent().prop('id')+'"/>'));
	$('#menuFrm').attr('action', action);
	$('#menuFrm').attr('method', "POST");
	$('#menuFrm').submit();
}

function moveSolution(action, system){
	if("ASRIMS" == system)
	{
		//var asRims = window.open('','','height=932px,width=1024px,resizable=yes,location=no,scrollbars=yes');
		var popFrm = $('#popFrm');
		popFrm.empty();
		popFrm.attr('action', action);
		popFrm.attr('target', "_blank");
		popFrm.attr('method', "post");
		popFrm.submit();
	}
	else if("SEARCH" == system)
	{
		var asRims = window.open('','SEARCH','height=783,width=914,innerHeight=919, resizable=no,location=no,scrollbars=yes');
		var popFrm = $('#popFrm');
		popFrm.empty();
		popFrm.attr('action', action);
		popFrm.attr('target', "SEARCH");
		popFrm.attr('method', "post");
		popFrm.submit();
	}
	else if("UGAS" == system)
	{
		var asRims = window.open('','UGAS','height=845px,width=1145px,resizable=no,location=no,scrollbars=yes');
		var popFrm = $('#popFrm');
		popFrm.empty();
		popFrm.attr('action', action);
		popFrm.attr('target', "UGAS");
		popFrm.attr('method', "post");
		popFrm.submit();
	}
	else
	{
		var pMenuId = "";
		var navBody = "";
		if("EXRIMS" == system)
		{
			pMenuId = "left_nav_li1";
			navBody = "exrims_ul";
		}
		if("RIMS" == system)
		{
			pMenuId = "left_nav_li5";
			navBody = "rims_ul";
		}
		$('#menuFrm').append($('<input type="hidden" id="pMenuId" name="pMenuId" value="'+pMenuId+'"/>'));
		$('#menuFrm').append($('<input type="hidden" id="navBody" name="navBody" value="'+navBody+'"/>'));
		$('#menuFrm').attr('action', action);
		$('#menuFrm').attr('method', "POST");
		$('#menuFrm').submit();
	}
}

