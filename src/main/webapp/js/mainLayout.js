function setMainLayoutHeight(obj, mdat){
	var layoutHeight = $(window).height();
	layoutHeight -= 170;
	if(mdat != undefined )
		layoutHeight -= mdat;
	if($('.title_box') != undefined )
		layoutHeight -= $('.title_box').height();
	if($('.view_tbl') != undefined )
		layoutHeight -= $('.view_tbl').height();
	if($('.list_bt_area') != undefined )
		layoutHeight -= $('.list_bt_area').height();
	if($('.header_wrap') != undefined )
		layoutHeight -= $('.header_wrap').height();
	if($('.nav_wrap') != undefined )
		layoutHeight -= $('.nav_wrap').height();
	$(obj).css('height',layoutHeight+"px");
}