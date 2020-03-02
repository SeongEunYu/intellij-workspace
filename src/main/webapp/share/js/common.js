/* 전체메뉴 */

$(function() {
    //gnb 설정
    gnb_init();

});




function gnb_init() {
    if($("#gnb").size() == 0) return;
    $("#gnb").removeClass("gnb_nojs");
    var gnb_menu = $("#gnb .menu");
    var gnb_submenu = $("#gnb .sub_menu");
	var gnb_submenu_ul = $("#gnb .sub_menu ul");
    var gnb_bg = $("#navul_wrap").next(".gnb_bg");
    var gnb_interval = null;
    
    function gnb_show() {
        clearTimeout(gnb_interval);
        gnb_submenu.fadeIn( 200 );
		gnb_submenu_ul.fadeIn( 200 );
        gnb_bg.fadeIn( 200 );
    }
    function gnb_hide() {
        clearTimeout(gnb_interval);
        gnb_interval = setTimeout(function() {
            gnb_submenu.fadeOut( 100 );
			gnb_submenu_ul.fadeOut( 100 );
            gnb_bg.fadeOut( 100 );
        },100);
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
    
    //gnb 마우스 오버 이벤트
    $("#gnb").hover(
        function() { gnb_show(); },
        function() { gnb_hide(); }
    ).children(".menu").hover(
        function() { gnb_over(true,this); },
        function() { gnb_over(false,this); }
    )
    //gnb 포커스 이벤트
    .on("focusin",function() {
        gnb_over(true,this);
    }).on("focusout",function() {
        gnb_over(false,this);
    });
    $("#gnb").on("focusin",function() {
        gnb_show();
    }).on("focusout",function() {
        gnb_hide();
    });
    gnb_bg.hover(
        function() { clearTimeout(gnb_interval); },
        function() { gnb_hide(); }
    );
      
	  
};


$(function () {
  $('[data-toggle="tooltip"]').tooltip()
})




/*메인 메뉴 아코디언 */
  $(function() {

    $( "#accordion_mobile" ).accordion({
      heightStyle: "content",
      active:""
    });

  });














   