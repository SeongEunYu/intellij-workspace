<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
%><!doctype html>
<html>
	<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta http-equiv="cache-Control" content="co-cache" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=yes"/> 

	<title>RIMS Discovery</title>
	<%@include file="../pageInit.jsp" %>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/share/css/bootstrap.min.css"/>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/share/css/layout.css"/>
	<link rel="stylesheet" type="text/css" href="<c:url value="/js/dhtmlx/skins/${sysConf['dhtmlx.skin']}/dhtmlx.css"/>" />
	<link rel="stylesheet" href="<c:url value="/share/css/mquery.css"/>">
	<script type="text/javascript" src="<c:url value="/js/dhtmlx/dhtmlx.js"/>"></script>
	<script src="${pageContext.request.contextPath}/share/js/jquery-1.9.1.min.js"></script> 
	<script src="${pageContext.request.contextPath}/share/js/jquery-ui.js"></script>
    <script src="${pageContext.request.contextPath}/share/js/common.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/share/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/share/js/jquery.scroll.pack.js"></script>
	<!-- Global site tag (gtag.js) - Google Analytics -->
	<script async src="https://www.googletagmanager.com/gtag/js?id=UA-112251421-1"></script>
	<!-- Slidebars CSS -->
	<link rel="stylesheet" href="${pageContext.request.contextPath}/share/css/slidebars.css">
	<!-- Owl Carousel Assets -->
	<link href="${pageContext.request.contextPath}/share/css/owl.carousel.css" rel="stylesheet">
	<link href="${pageContext.request.contextPath}/share/css/owl.theme.css" rel="stylesheet">
	<script src="${pageContext.request.contextPath}/share/js/owl.carousel.min.js"></script>
	<!--[if lt IE 9]>
	<script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script>
	<![endif]-->
	<style type="text/css">
		.allmenu_wrap { width: auto; margin-left: 30px; margin-right: 30px;}
		.al_inner h3 { font-size: 16px; }
	</style>
	<script>
        <%
            String url = request.getRequestURL().toString();
            if(url.contains("rims.kaist.ac.kr")){
        %>
        // Global site tag (gtag.js) - Google Analytics
        window.dataLayer = window.dataLayer || [];
        function gtag(){dataLayer.push(arguments);}
        gtag('js', new Date());
        gtag('config', 'UA-112251421-1');
        <%}%>
        $(document).ready(function() {
            effectBySize();
        });

        $(window).resize(function(){
            effectBySize();
        })

        function effectBySize(){
            var width_size = window.outerWidth;

            if(width_size > 1213){
                $(".nav_h03 .hexagon_box").css("background","url(../img/background/hexagon_bg_over.png) no-repeat 0 0");
                $(".nav_h03 .hexagon_box span").css("color","#fff");
                $(".nav_h03 .hexagon_box span").css("background","url(../img/background/m_nav_icon03_over.png) no-repeat 50% 51px");

                $(".d1").hover(
                    function () {
                        $(".nav_h03 .hexagon_box").css("background","url(../img/background/hexagon_bg01.png) no-repeat 0 0");
                        $(".nav_h03 .hexagon_box span").css("color","#555");
                        $(".nav_h03 .hexagon_box span").css("background","url(../img/background/m_nav_icon03.png) no-repeat 50% 51px");
                    }
                );

                $(".nav_h03").hover(
                    function(){
                        $(".nav_h03 .hexagon_box").css("background","url(../img/background/hexagon_bg_over.png) no-repeat 0 0");
                        $(".nav_h03 .hexagon_box span").css("background","url(../img/background/m_nav_icon03_over.png) no-repeat 50% 51px");
                        $(".nav_h03 .hexagon_box span").css("color","#fff");
                    }
                );
            }else{
                $(".d1").hover(
                    function () {
                        $(".nav_h03 .hexagon_box").removeAttr("style");
                        $(".nav_h03 .hexagon_box span").removeAttr("style");
                    }
                );

                $(".nav_h03").hover(
                    function(){
                        $(".nav_h03 .hexagon_box").removeAttr("style");
                        $(".nav_h03 .hexagon_box span").removeAttr("style");
                    }
                );
                $(".nav_h03 .hexagon_box").removeAttr("style");
                $(".nav_h03 .hexagon_box span").removeAttr("style");
			}
        }

        function searchCheck(){
            if($("#searchAllName").val().trim().length == 0){
                dhtmlx.alert('<spring:message code="disc.alert.keyword"/>');
                return false;
            }
		}

		function searchCheck2(){
            if($("#searchAllName").val().trim().length == 0){
                dhtmlx.alert('<spring:message code="disc.alert.keyword"/>');
                return;
            }

            $("#searchAllForm").submit();
		}

	</script>

  
</head>
<body>
<div id="sb-site">
	<div class="main_top_wrap">
		<div class="mt_inner h_fix">
			<h1><a href="#">KAIST</a></h1>
			<div class="mtr_box">
				<ul>
				<li class="language_li"><a href="${pageContext.request.contextPath}/share/user/main.do"><spring:message code="disc.top.menu.home"/></a></li>
				<li class="language_li"><a href="${pageContext.request.contextPath}/share/user/kboard.do"><spring:message code="disc.top.menu.notice"/></a></li>
				<li class="language_li"><a href="<c:url value="/index/goRimsFromDiscovery.do"/>"><spring:message code="disc.top.menu.rims"/></a></li>
				<c:if test="${pageContext.response.locale eq 'ko'}">
					<li class="language_li"><a href="<c:url value='/share/index/setLocale.do?locale=en'/>">ENG</a></li>
				</c:if>
				<c:if test="${pageContext.response.locale eq 'en'}">
					<li class="language_li"><a href="<c:url value='/share/index/setLocale.do?locale=ko'/>">KOR</a></li>
				</c:if>
				<li><button type="button" class="menu_bt" data-toggle="modal" data-target="#myModal">전체메뉴</button></li>
				</ul>
			</div>
			<div class="tablet_nav sb-toggle-right">
				<a href="#" class="tablet_nav_bt" id="mnav_bt">
					<span class="line"></span>
					<span class="line"></span>
					<span class="line"></span></span>
				</a>
			</div>
			<div class="search_bt_box"><!-- 모바일용 검색 -->
				<a href="#" class="sub_search_bt">search</a>
				<div class="mobile_s_inner">
					<p class="mmobile_s_int">
						<input onKeypress="javascript:if(event.keyCode==13) {$('#searchAllName').val($('#mobile_search').val()); searchCheck2();}" id="mobile_search" type="text" title="검색" placeholder="<spring:message code='disc.placeholder.keyword'/>">
					</p>
					<input type="button" class="sub_search_bt" value="close">
				</div>
			</div>
		</div>
	</div> 
	
	<div class="main_wrap">
		<div class="main_contents">
			<div class="m_search_wrap">
				<h2 style="width: 670px; margin-left: 85px; letter-spacing:-3px;">Welcome to <strong>RIMS <span style="color: rgb(207, 147, 41)">D</span>iscovery</strong></h2>
				<p style="padding-top: 10px;margin-bottom: 10px;<c:if test="${language eq 'ko'}">font-size: 18px;</c:if>"><spring:message code="disc.main.comment"/></p>
				<div class="m_search_box">
					<div class="header_search_box" style="width: 610px;">
						<form action="${pageContext.request.contextPath}/share/user/searchAll.do" method="get" id="searchAllForm" onsubmit="return searchCheck()">
							<input class="effect-9" type="text" placeholder="<spring:message code='disc.placeholder.keyword'/>" id="searchAllName" name="searchAllName" value="<c:out value="${searchAllName}"/>" style="width: 610px;">
							<span class="focus-border">
								<i></i>
							</span>
							<a href="javascript: searchCheck2()" class="search_bt" style="left: 560px;">검색</a>
						</form>
					</div>
				</div>
			</div><!-- m_search_wrap : e-->

			<div class="m_nav_wrap">
				<div class="nav_hexagon nav_h01 over_effect d1">
					<a href="${pageContext.request.contextPath}/share/user/dept.do">
						<div class="hexagon_wrap">
							<div class="hexagon_box">
								<span><spring:message code="disc.menu.rsch"/></span>
							</div>
						</div>
					</a>
				</div><!-- researhcer -->
				<div class="nav_hexagon nav_h02 over_effect d1">
					<a href="${pageContext.request.contextPath}/share/article/articles.do">
						<div class="hexagon_wrap">
							<div class="hexagon_box">
								<span><spring:message code="disc.menu.otpt"/></span>
							</div>

						</div>
					</a>
				</div><!-- Research Output -->
				<div class="nav_hexagon nav_h03 over_effect">
					<a href="${pageContext.request.contextPath}/share/article/highlyCitedPaperByField.do">
						<div class="hexagon_wrap">
							<div class="hexagon_box">
								<span><spring:message code="disc.menu.anls"/></span>
							</div>
						</div>
					</a>
				</div><!-- Research Analysis -->
				<div class="nav_hexagon nav_h04 over_effect d1">
					<a href="${pageContext.request.contextPath}/share/article/deptCoAuthor.do">
						<div class="hexagon_wrap">
							<div class="hexagon_box">
								<span><spring:message code="disc.menu.ntwk"/></span>
							</div>
						</div>
					</a>
				</div><!-- Research Network -->
				<div class="nav_hexagon nav_h05 over_effect d1">
					<a href="${pageContext.request.contextPath}/share/funding/ntis.do">
						<div class="hexagon_wrap">
							<div class="hexagon_box">
								<span><spring:message code="disc.menu.fnd"/></span>
							</div>
						</div>
					</a>
				</div><!-- Research Funding -->
				<div class="nav_hexagon nav_h06 over_effect d1">
					<a href="${pageContext.request.contextPath}/share/user/introduce.do">
						<div class="hexagon_wrap">
							<div class="hexagon_box">
								<span><spring:message code="disc.menu.about"/></span>
							</div>
						</div>
					</a>
				</div><!-- Research Trend -->
			</div><!-- m_nav_wrap : e -->
		</div>
	</div><!-- main_wrap : e -->
 


<div class="footer_banner_wrap">
	<div class="footer_banner">
		<div id="footer_slide" class="owl-carousel owl-theme">
			<div class="item"><a href="http://koasas.kaist.ac.kr/" target="_blank"><img src="${pageContext.request.contextPath}/share/img/common/banner_img01.png" alt="KOASAS" /></a></div>
			<div class="item"><a href="https://www.scopus.com/" target="_blank"><img src="${pageContext.request.contextPath}/share/img/common/banner_img03.png" alt="SCOPUS"></a></div>
			<div class="item"><a href="http://webofknowledge.com" target="_blank"><img src="${pageContext.request.contextPath}/share/img/common/banner_img04.png" alt="WEB OF SCIENCE"></a></div>
			<div class="item"><a href="https://www.kri.go.kr/kri2" target="_blank"><img src="${pageContext.request.contextPath}/share/img/common/banner_img05.png" alt="KRI"></a></div>
			<div class="item"><a href="http://www.researcherid.com/rid/" target="_blank"><img src="${pageContext.request.contextPath}/share/img/common/banner_img06.png" alt="RESEARCHERID"></a></div>
			<div class="item"><a href="/selca/" target="_blank"><img src="${pageContext.request.contextPath}/share/img/common/selca_link.png" alt="SELCA"></a></div>
		</div>
	</div>
</div>

	<div class="footer_wrap">
  		<div class="footer_inner">
  		
  			<p class="fl_text">
				<c:if test="${language eq 'en'}">
					<em class="f_line">Contact</em>Academic Information Development Team
				</c:if>
				<c:if test="${language eq 'ko'}">
					<em class="f_line">문의</em>학술정보원 주제정보서비스팀
				</c:if>
  				<span class="foonter_icon01">${sysConf['system.admin.telno']}</span>
  				<span class="foonter_icon02">${sysConf['system.admin.email']}</span>
  			</p>
  			<p class="fr_text">Copyright (C) 2017, ${sysConf['inst.name.eng.full']}, All Rights Reserved.</p>
  	
	  	</div>
  	</div>
</div>




	<!-- 오른쪽 메뉴 new -->
	<div class="sb-slidebar sb-right">
		<div  class="left_nav_wrap">
			<h2>KAIST Discovery</h2>
			<div id="accordion_mobile" class="left_nav_inner">
				<h3 class="rn_icon01"><em>Researcher</em></h3>
				<div class="moblie_sub_menu" style="display:none;">
					<ul>
						<li><a href="${pageContext.request.contextPath}/share/user/users.do">연구자(전임재직교원)</a></li>
						<li><a href="${pageContext.request.contextPath}/share/user/dept.do">학과</a></li>
						<c:if test="${r2Conf['usr.rims.info.lab'] eq '3' and sessionScope.auth.adminDvsCd eq 'M'}">
							<li><a href="${pageContext.request.contextPath}/share/laboratory/laboratorys.do"><spring:message code="disc.menu.rsch.lab"/></a></li>
						</c:if>
					</ul>
				</div>
				<h3 class="rn_icon01"><em>Research Output</em></h3>
				<div class="moblie_sub_menu">
					<ul>
						<li><a href="${pageContext.request.contextPath}/share/article/articles.do">Journal Article</a></li>
						<li><a href="${pageContext.request.contextPath}/share/funding/fundings.do">Research Project</a></li>
						<li><a href="${pageContext.request.contextPath}/share/patent/patents.do">Patent</a></li>
						<li><a href="${pageContext.request.contextPath}/share/conference/conferences.do">Conference Paper</a></li>
					</ul>
				</div>
				<h3 class="rn_icon01"><em>Research Analysis</em></h3>
				<div class="moblie_sub_menu">
					<ul>
						<li><a href="${pageContext.request.contextPath}/share/article/highlyCitedPaperByField.do">최상위 논문 by 주제분야</a></li>
						<li><a href="${pageContext.request.contextPath}/share/article/jcrPapersInDept.do">최상위 논문 by IF</a></li>
						<li><a href="${pageContext.request.contextPath}/share/article/subject.do">주제분석</a></li>
						<li><a href="${pageContext.request.contextPath}/share/article/journalByDept.do">저널분석</a></li>
						<li><a href="${pageContext.request.contextPath}/share/user/keywordAnalysis.do">키워드 트렌드 분석</a></li>
						<li><a href="${pageContext.request.contextPath}/share/user/keywordNetwork.do">키워드 동시발생빈도</a></li>

					</ul>
				</div>
				<h3 class="rn_icon01"><em>Research Network</em></h3>
				<div class="moblie_sub_menu">
					<ul>
						<li><a href="${pageContext.request.contextPath}/share/article/deptCoAuthor.do">Department Network</a></li>
						<li><a href="${pageContext.request.contextPath}/share/user/researchGate.do">External ResearchGate</a></li>
					</ul>
				</div>
				<h3 class="rn_icon01"><em>Research Funding</em></h3>
				<div class="moblie_sub_menu">
					<ul>
						<li><a href="${pageContext.request.contextPath}/share/funding/ntis.do">NTIS R&amp;D</a></li>
						<li><a href="${pageContext.request.contextPath}/share/funding/grants.do">GRANTS.GOV</a></li>
						<li><a href="${pageContext.request.contextPath}/share/funding/horizon.do">HORIZON 2020</a></li>
					</ul>
				</div>
				<h3 class="rn_icon01"><em>About RIMS</em></h3>
				<div class="moblie_sub_menu">
					<ul>
						<li><a href="${pageContext.request.contextPath}/share/user/rimsOverview.do?language=en">RIMS &amp; RIMS Discovery</a></li>
						<li><a href="${pageContext.request.contextPath}/share/user/kboard.do?language=en">Notice &amp; Manual</a></li>
						<li><a href="${pageContext.request.contextPath}/share/user/webtoon.do">RIMS &amp; KRI 웹툰</a></li>
						<li><a href="${pageContext.request.contextPath}/share/user/selca.do">SelCA</a></li>
					</ul>
				</div>

			</div>
			<div class="rn_top_box">
				<ul>
					<li><a href="#"><span>Notice</span></a></li>
				</ul>
				<a href="#" class="m_language_bt">ENG</a>
			</div>



		</div>
	</div>






<!-- Modal -->
<div class="modal fade allmenu_m_bg" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog allmenu_wrap">

	  <div class="allmenu_row">
		  <div class="allmenu_lbox">
			  <div class="al_inner">
				  <h3><spring:message code="disc.menu.rsch"/></h3>
				  <ul>
					  <li><a href="${pageContext.request.contextPath}/share/user/users.do"><spring:message code="disc.menu.rsch.rsch"/></a></li>
					  <li><a href="${pageContext.request.contextPath}/share/user/dept.do"><spring:message code="disc.menu.rsch.dept"/></a></li>
 					  <c:if test="${r2Conf['usr.rims.info.lab'] eq '3' and sessionScope.auth.adminDvsCd eq 'M'}">
					  <li><a href="${pageContext.request.contextPath}/share/laboratory/laboratorys.do"><spring:message code="disc.menu.rsch.lab"/></a></li>
					  </c:if>
				  </ul>
			  </div>
		  </div>
		  <div class="allmenu_lbox">
			  <div class="al_inner">
				  <h3><spring:message code="disc.menu.otpt"/></h3>
				  <ul>
					  <li><a href="${pageContext.request.contextPath}/share/article/articles.do"><spring:message code="disc.menu.otpt.art"/></a></li>
					  <li><a href="${pageContext.request.contextPath}/share/funding/fundings.do"><spring:message code="disc.menu.otpt.fnd"/></a></li>
					  <li><a href="${pageContext.request.contextPath}/share/patent/patents.do"><spring:message code="disc.menu.otpt.pat"/></a></li>
					  <li><a href="${pageContext.request.contextPath}/share/conference/conferences.do"><spring:message code="disc.menu.otpt.cnfr"/></a></li>
				  </ul>
			  </div>
		  </div>
		  <div class="allmenu_lbox">
			  <div class="al_inner">
				  <h3><spring:message code="disc.menu.anls"/></h3>
				  <ul>
					  <li><a href="${pageContext.request.contextPath}/share/article/highlyCitedPaperByField.do"><spring:message code="disc.menu.anls.toprf"/></a></li>
					  <li><a href="${pageContext.request.contextPath}/share/article/jcrPapersInDept.do"><spring:message code="disc.menu.anls.topif"/></a></li>
					  <li><a href="${pageContext.request.contextPath}/share/article/subject.do"><spring:message code="disc.menu.anls.sbj"/></a></li>
					  <li><a href="${pageContext.request.contextPath}/share/article/journalByDept.do"><spring:message code="disc.menu.anls.jnl"/></a></li>
					  <li><a href="${pageContext.request.contextPath}/share/user/keywordAnalysis.do"><spring:message code="disc.menu.anls.key"/></a></li>
					  <li><a href="${pageContext.request.contextPath}/share/user/keywordNetwork.do"><spring:message code="disc.menu.anls.keyNet"/></a></li>
					  <%--<li><a href="${pageContext.request.contextPath}/share/article/SCIByYear.do">SCI Artices by Year</a></li>
					  <li><a href="#">Journal Impact Factor</a></li>--%>
				  </ul>
			  </div>
		  </div>
		  <div class="allmenu_lbox">
			  <div class="al_inner">
				  <h3><spring:message code="disc.menu.ntwk"/></h3>
				  <ul>
					  <li><a href="${pageContext.request.contextPath}/share/article/deptCoAuthor.do"><spring:message code="disc.menu.ntwk.dept"/></a></li>
					  <li><a href="${pageContext.request.contextPath}/share/user/researchGate.do"><spring:message code="disc.menu.ntwk.extn"/></a></li>
					  <%--<li><a href="#">${language == 'en' ? 'Subject Network' : '학문분야별 네트워크'}</a></li>--%>
				  </ul>
			  </div>
		  </div>
		  <div class="allmenu_lbox">
			  <div class="al_inner">
				  <h3><spring:message code="disc.menu.fnd"/></h3>
				  <ul>
					  <li><a href="${pageContext.request.contextPath}/share/funding/ntis.do"><spring:message code="disc.menu.fnd.ntis"/></a></li>
					  <li><a href="${pageContext.request.contextPath}/share/funding/grants.do"><spring:message code="disc.menu.fnd.grnt"/></a></li>
					  <li><a href="${pageContext.request.contextPath}/share/funding/horizon.do"><spring:message code="disc.menu.fnd.hrzn"/></a></li>
				  </ul>
			  </div>
		  </div>
		  <div class="allmenu_lbox">
			  <div class="al_inner">
				  <h3><spring:message code="disc.menu.about"/></h3>
				  <ul>
					  <li><a href="${pageContext.request.contextPath}/share/user/introduce.do"><spring:message code="disc.menu.about.rims"/></a></li>
					  <li><a href="${pageContext.request.contextPath}/share/user/kboard.do"><spring:message code="disc.menu.about.ntcm"/></a></li>
					  <li><a href="${pageContext.request.contextPath}/share/user/webtoon.do"><spring:message code="disc.menu.about.wbtn"/></a></li>
					  <li><a href="${pageContext.request.contextPath}/share/user/selca.do"><spring:message code="disc.menu.about.selca"/></a></li>
				  </ul>
			  </div>
		  </div>
	  </div>
	 <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">close</span></button>
	</div>
</div>

<script src="${pageContext.request.contextPath}/share/js/slidebars.js"></script>
<script>
	(function($) {
		$(document).ready(function() {
			$.slidebars();
		});
	}) (jQuery);
</script>

	<!--모바일 검색 -->
<script>
	$('#footer_slide').owlCarousel({
		loop:true,
		margin:10,
		nav:true,
		responsive:{
			0:{items:2},
			600:{items:2},
			1000:{items:3},
			1024:{items:6}
		}
	});

	$(".sub_search_bt").click(function(){
		$(".mobile_s_inner").toggleClass("search_active");
	});
	$(".m_toggle_bt").click(function(){
		$(".m_toggle_box").toggleClass("tm_open_type");
	});
</script>

</body>
</html>
