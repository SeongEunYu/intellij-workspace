<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
%><%@ taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator"
%><!doctype html>
<html>
<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta http-equiv="cache-Control" content="co-cache" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=yes"/>
	<title>Research Support System</title>
	<%@include file="../jsp/share/pageInit.jsp" %>
	<link rel="stylesheet" type="text/css" href="<c:url value="/js/dhtmlx/skins/${sysConf['dhtmlx.skin']}/dhtmlx.css"/>" />
	<link rel="stylesheet" type="text/css" href="<c:url value="/share/css/bootstrap.min.css"/>" />
	<link rel="stylesheet" type="text/css" href="<c:url value="/share/css/layout.css"/>?t=20200115" />
	<link rel="stylesheet" type="text/css" href="<c:url value="/share/css/layout_RSS.css"/>" />
	<link rel="stylesheet" type="text/css" href="<c:url value="/share/css/fixedheader.css"/>" />
	<link rel="stylesheet" type="text/css" href="<c:url value="/share/css/mquery.css"/>" />
	<link rel="stylesheet" type="text/css" href="<c:url value="/share/css/slidebars.css"/>" />

	<script type="text/javascript" src="<c:url value="/share/js/jquery-1.9.1.min.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/share/js/jquery-ui.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/share/js/jquery.sparkline.min.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/js/fontawesome-all.min.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/js/dhtmlx/dhtmlx.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/js/script.js"/>?t=20200115"></script>
	<script type="text/javascript" src="<c:url value="/share/js/common.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/share/js/bootstrap.min.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/share/js/jquery.scroll.pack.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/share/js/chart/opts/fusioncharts.opts.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/share/js/chart/fusioncharts.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/share/js/jquery.fixedheadertable.min.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/share/js/chart/fusioncharts-jquery-plugin.min.js"/>"></script>
	<script type='text/javascript' src='https://d1bxh8uas1mnw7.cloudfront.net/assets/embed.js'></script>
	<!--[if lt IE 9]>
	<script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script>
	<![endif]-->
	<!-- Global site tag (gtag.js) - Google Analytics -->
	<script async src="https://www.googletagmanager.com/gtag/js?id=UA-112251421-1"></script>
	<decorator:head />
	<style>
		.article_list_box .al_title { font-size: 18px; color:#2d52b1; display: block; margin-bottom: 6px;}
		.researcher_info_top dl .dept_dd   { margin-bottom: 5px; color: #333;}
		.wrap-loading{ /*화면 전체를 어둡게 합니다.*/
			position: fixed;
			left:0;
			right:0;
			top:0;
			bottom:0;
			background: rgba(0,0,0,0.2); /*not in ie */
			filter: progid:DXImageTransform.Microsoft.Gradient(startColorstr='#20000000', endColorstr='#20000000');    /* ie */
		}
		.wrap-loading div{ /*로딩 이미지*/
			position: fixed;
			top:50%;
			left:50%;
			margin-left: -21px;
			margin-top: -21px;
		}
		.allmenu_wrap { width: auto; margin-left: 30px; margin-right: 30px;}
		.al_inner h3 { font-size: 16px; }
		/*설명 글*/
		/* .ts_text_inner{
             font-weight:bold;
         }*/
	</style>
	<script>
		<%
			String url = request.getRequestURL().toString();
			if(url.contains("rss.bwise.kr")){
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
				$(".nav_h03 .hexagon_box").css("background","url(../img/background_rss/hexagon_bg_over.png) no-repeat 0 0");
				$(".nav_h03 .hexagon_box span").css("color","#fff");
				$(".nav_h03 .hexagon_box span").css("background","url(../img/background_rss/m_nav_icon03_over.png) no-repeat 50% 51px");

				$(".d1").hover(
						function () {
							$(".nav_h03 .hexagon_box").css("background","url(../img/background_rss/hexagon_bg01.png) no-repeat 0 0");
							$(".nav_h03 .hexagon_box span").css("color","#555");
							$(".nav_h03 .hexagon_box span").css("background","url(../img/background_rss/m_nav_icon03.png) no-repeat 50% 51px");
						}
				);

				$(".nav_h03").hover(
						function(){
							$(".nav_h03 .hexagon_box").css("background","url(../img/background_rss/hexagon_bg_over.png) no-repeat 0 0");
							$(".nav_h03 .hexagon_box span").css("background","url(../img/background_rss/m_nav_icon03_over.png) no-repeat 50% 51px");
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

		function searchAll(txt){
			$("#searchAllName").val(txt);
			$("#searchAllForm").submit();
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
	<div class="system_header_wrap">
		<div class="system_header_inner">
			<h1 class="rss_logo"><a href="${pageContext.request.contextPath}/home.do">Research Support System</a></h1>
			<div class="user_search_wrap">
				<%--<input type="text" title="검색" class="u_s_int"  placeholder="Search" id="searchAllName" name="searchAllName"/>--%>
				<form action="/rss/share/user/searchAll.do" method="get" id="searchAllForm" onsubmit="return searchCheck()">
					<input class="u_s_int" type="text" placeholder="연구자 이름, 연구분야 또는 키워드를 입력하세요." id="searchAllName" name="searchAllName" value="">
					<span class="focus-border">
						<i></i>
					</span>
					<a href="javascript:searchCheck2()" class="search_bt"></a>
				</form>
			</div>
			<div class="s_h_right_box">
				<a href="#" class="top_icon_btn setting_btn">설정</a>
				<div class="service_bt_wrap">
					<a href="#" class="top_icon_btn service_btn">서비스 이동</a>
					<div class="service_link_box">
						<ul>
							<li><a href="#"><em class="system_rss">RSS</em><span>RSS</span></a></li>
							<li><a href="#"><em>Rims</em><span>RIMS</span></a></li>
							<li><a href="#"><em class="system_rd">Discovery</em><span>Discovery</span></a></li>
							<li><a href="#"><em class="system_s2">S2jJournal</em><span>S2jJournal</span></a></li>
							<li><a href="#"><em class="system_g">GotIt</em><span>GotIt</span></a></li>
							<li><a href="#"><em class="system_prism">PRISM</em><span>PRISM</span></a></li>
							<li><a href="#"><em class="system_sw">ScholarWorks</em><span>ScholarWorks</span></a></li>
							<li><a href="#"><em class="system_board">Board</em><span>Board</span></a></li>
						</ul>
					</div>
				</div><!-- 서비스 설정 -->
				<div class="top_user_box">
					<div class="user_box">
						<c:choose>
							<c:when test="${pageContext.response.locale eq 'ko'}">
								${sessionScope.sess_user.korNm}
							</c:when>
							<c:otherwise>
								<c:if test="${not empty sessionScope.sess_user.lastName}">
									${sessionScope.sess_user.lastName}, ${sessionScope.sess_user.firstName}
								</c:if>
								<c:if test="${empty sessionScope.sess_user.lastName}">
									${sessionScope.sess_user.engNm}
								</c:if>
							</c:otherwise>
						</c:choose>
						<a href="<c:url value="/index/logout.do"/>" class="logout_btn">Logout</a>
					</div>
				</div>
			</div>

		</div>
	</div><!-- system_header_wrap : e -->
	<!--div class="nav_wrap nav_type02"-->
	<div class="dashboard_nav">
		<div id="navul_wrap">
			<ul id="gnb" class="gnb">
				<li class="menu">
					<a href="#" class="nav_menu_a" id="bigResearcher"><spring:message code="disc.menu.rsch"/></a>
					<div class="sub_menu" style="display: none;">
						<ul style="display: none;">
							<li><a href="${pageContext.request.contextPath}/share/user/users.do"><spring:message code="disc.menu.rsch.rsch"/></a></li>
							<li><a href="${pageContext.request.contextPath}/share/user/dept.do"><spring:message code="disc.menu.rsch.dept"/></a></li>
							<c:if test="${r2Conf['usr.rims.info.lab'] eq '3' and sessionScope.auth.adminDvsCd eq 'M'}">
							<li><a href="${pageContext.request.contextPath}/share/laboratory/laboratorys.do"><spring:message code="disc.menu.rsch.lab"/></a></li>
							</c:if>
						</ul>
					</div>
				</li>
				<li class="menu">
					<a href="#" class="nav_menu_a" id="bigOutput"><spring:message code="disc.menu.otpt"/></a>
					<div class="sub_menu" style="display:none;">
						<ul style="display: none;">
							<li><a href="${pageContext.request.contextPath}/share/article/articles.do"><spring:message code="disc.menu.otpt.art"/></a></li>
							<li><a href="${pageContext.request.contextPath}/share/funding/fundings.do"><spring:message code="disc.menu.otpt.fnd"/></a></li>
							<li><a href="${pageContext.request.contextPath}/share/patent/patents.do"><spring:message code="disc.menu.otpt.pat"/></a></li>
							<li><a href="${pageContext.request.contextPath}/share/conference/conferences.do"><spring:message code="disc.menu.otpt.cnfr"/></a></li>
						</ul>
					</div>
				</li>
				<li class="menu">
					<a href="#" class="nav_menu_a" id="bigAnalysis"><spring:message code="disc.menu.anls"/></a>
					<div class="sub_menu" style="display:none;">
						<ul style="display: none;">
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
				</li>
				<li class="menu">
					<a href="#" class="nav_menu_a" id="bigNetwork"><spring:message code="disc.menu.ntwk"/></a>
					<div class="sub_menu" style="display: none;">
						<ul style="display: none;">
							<li><a href="${pageContext.request.contextPath}/share/article/deptCoAuthor.do"><spring:message code="disc.menu.ntwk.dept"/></a></li>
							<li><a href="${pageContext.request.contextPath}/share/user/researchGate.do"><spring:message code="disc.menu.ntwk.extn"/></a></li>
							<%--<li><a href="#">${language == 'en' ? 'Subject Network' : '학문분야별 네트워크'}</a></li>--%>
						</ul>
					</div>
				</li>
				<li class="menu">
					<a href="#" class="nav_menu_a" id="bigFunding"><spring:message code="disc.menu.fnd"/></a>
					<div class="sub_menu" style="display: none;">
						<ul style="display: none;">
							<li><a href="${pageContext.request.contextPath}/share/funding/ntis.do"><spring:message code="disc.menu.fnd.ntis"/></a></li>
							<li><a href="${pageContext.request.contextPath}/share/funding/grants.do"><spring:message code="disc.menu.fnd.grnt"/></a></li>
							<li><a href="${pageContext.request.contextPath}/share/funding/horizon.do"><spring:message code="disc.menu.fnd.hrzn"/></a></li>
						</ul>
					</div>
				</li>
				<li class="menu menu_last">
					<a href="#" class="nav_menu_a" id="myRSS"><%--<img src="../img/background_rss/star.png" style="width: 10%; margin-right: 5px;" />--%><spring:message code="disc.menu.rss"/></a>
					<div class="sub_menu" style="display: none;">
						<ul style="display: none;">
							<%--<li><a href="${pageContext.request.contextPath}/share/myRss/myDocument.do"><spring:message code="disc.menu.rss.doc"/></a></li>--%>
							<li><a href="${pageContext.request.contextPath}/share/myRss/myDocument.do">My Favorite</a></li>
						</ul>
					</div>
				</li>
			</ul>
		</div>
		<div class="gnb_bg" style="display:none;"><div class="bg_wrap"></div></div>
		<!-- s : gnb -->
	</div><!--nav_wrap : e  -->


<decorator:body />
<div class="footer_wrap">
	<div class="footer_inner">
		<p class="fl_text">
			<c:if test="${language eq 'en'}">
				<em class="f_line">Contact</em>Academic Information Development Team
			</c:if>
			<c:if test="${language eq 'ko'}">
				<em class="f_line">문의</em>학술정보개발팀
			</c:if>
			<span class="foonter_icon01">${sysConf['system.admin.telno']}</span>
			<span class="foonter_icon02">${sysConf['system.admin.email']}</span>
		</p>
		<p class="fr_text">Copyright (C) 2017, ${sysConf['inst.name.eng.full']}, All Rights Reserved.</p>
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
</div>

<div class="sb-slidebar sb-right">
	<div  class="left_nav_wrap">
		<h2>KAIST Discovery</h2>

		<div id="accordion_mobile" class="left_nav_inner">
			<h3 class="rn_icon01"><em><spring:message code="disc.menu.rsch"/></em></h3>
			<div class="moblie_sub_menu" style="display:none;">
				<ul>
					<li><a href="${pageContext.request.contextPath}/share/user/users.do"><spring:message code="disc.menu.rsch.rsch"/></a></li>
					<li><a href="${pageContext.request.contextPath}/share/user/dept.do"><spring:message code="disc.menu.rsch.dept"/></a></li>
					<c:if test="${r2Conf['usr.rims.info.lab'] eq '3' and sessionScope.auth.adminDvsCd eq 'M'}">
						<li><a href="${pageContext.request.contextPath}/share/laboratory/laboratorys.do"><spring:message code="disc.menu.rsch.lab"/></a></li>
					</c:if>
				</ul>
			</div>
			<h3 class="rn_icon01"><em><spring:message code="disc.menu.otpt"/></em></h3>
			<div class="moblie_sub_menu">
				<ul>
					<li><a href="${pageContext.request.contextPath}/share/article/articles.do"><spring:message code="disc.menu.otpt.art"/></a></li>
					<li><a href="${pageContext.request.contextPath}/share/funding/fundings.do"><spring:message code="disc.menu.otpt.fnd"/></a></li>
					<li><a href="${pageContext.request.contextPath}/share/patent/patents.do"><spring:message code="disc.menu.otpt.pat"/></a></li>
					<li><a href="${pageContext.request.contextPath}/share/conference/conferences.do"><spring:message code="disc.menu.otpt.cnfr"/></a></li>
				</ul>
			</div>
			<h3 class="rn_icon01"><em><spring:message code="disc.menu.anls"/></em></h3>
			<div class="moblie_sub_menu">
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
			<h3 class="rn_icon01"><em><spring:message code="disc.menu.ntwk"/></em></h3>
			<div class="moblie_sub_menu">
				<ul>
					<li><a href="${pageContext.request.contextPath}/share/article/deptCoAuthor.do"><spring:message code="disc.menu.ntwk.dept"/></a></li>
					<li><a href="${pageContext.request.contextPath}/share/user/researchGate.do"><spring:message code="disc.menu.ntwk.extn"/></a></li>
					<%--<li><a href="#">${language == 'en' ? 'Subject Network' : '학문분야별 네트워크'}</a></li>--%>
				</ul>
			</div>
			<h3 class="rn_icon01"><em><spring:message code="disc.menu.fnd"/></em></h3>
			<div class="moblie_sub_menu">
				<ul>
					<li><a href="${pageContext.request.contextPath}/share/funding/ntis.do"><spring:message code="disc.menu.fnd.ntis"/></a></li>
					<li><a href="${pageContext.request.contextPath}/share/funding/grants.do"><spring:message code="disc.menu.fnd.grnt"/></a></li>
					<li><a href="${pageContext.request.contextPath}/share/funding/horizon.do"><spring:message code="disc.menu.fnd.hrzn"/></a></li>
				</ul>
			</div>
			<h3 class="rn_icon01"><em><spring:message code="disc.menu.rss"/></em></h3>
			<div class="moblie_sub_menu">
				<ul>
					<li><a href="${pageContext.request.contextPath}/share/user/introduce.do"><spring:message code="disc.menu.rss.document"/></a></li>
				</ul>
			</div>

		</div>
		<div class="rn_top_box">
			<ul>
				<li><a href="#"><span>Notice</span></a></li>
			</ul>
			<c:if test="${pageContext.response.locale eq 'ko'}">
				<a href="<c:url value='/share/index/setLocale.do?locale=en'/>" class="m_language_bt">ENG</a>
			</c:if>
			<c:if test="${pageContext.response.locale eq 'en'}">
				<a href="<c:url value='/share/index/setLocale.do?locale=ko'/>" class="m_language_bt">KOR</a>
			</c:if>
		</div>
	</div>
</div>

<!-- ajax loading -->
<div class="wrap-loading" style="display: none;">
	<div><img src='<c:url value="/share/img/common/ajax-loader.gif"/>' /></div>
</div>
<script src="<c:url value="/share/js/slidebars.js"/>"></script>
<script>
	(function($) {
		$(document).ready(function() {
			$.slidebars();
		});
	}) (jQuery);
</script>

<script>
	$(".sub_search_bt").click(function(){
		console.log(1);
		$(".mobile_s_inner").toggleClass("search_active");
	});
	$(".m_toggle_bt").click(function(){
		console.log(2);
		$(".m_toggle_box").toggleClass("tm_open_type");
	});

	/*var canvas = document.getElementById('canvasdd');
	if (canvas.getContext) {
		var ctx = canvas.getContext('2d');

		ctx.fillStyle = '#bbbbbb';
		ctx.fillRect(2,10,4,60);

		ctx.fillStyle = '#bbbbbb';
		ctx.fillRect(10,20,4,60);
	}*/
</script>
</body>
</html>