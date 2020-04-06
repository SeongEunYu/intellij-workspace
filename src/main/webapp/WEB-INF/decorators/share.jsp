<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator"%>
<!doctype html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta http-equiv="cache-Control" content="co-cache" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=yes"/>
	<title>Research Support System</title>
	<%@include file="../jsp/share/pageInit.jsp" %>
	<link rel="stylesheet" type="text/css" href="<c:url value="/js/dhtmlx/skins/${sysConf['dhtmlx.skin']}/dhtmlx.css"/>" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/share/css/bootstrap.min.css"/>
	<link rel="stylesheet" type="text/css" href="<c:url value="/share/css/layout.css"/>?t=20200115" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/share/css/layout_RSS.css"/>
	<link rel="stylesheet" type="text/css" href="<c:url value="/share/css/fixedheader.css"/>" />
	<link rel="stylesheet" type="text/css" href="<c:url value="/share/css/mquery.css"/>" />
	<link rel="stylesheet" type="text/css" href="<c:url value="/share/css/slidebars.css"/>" />

	<script src="${pageContext.request.contextPath}/share/js/jquery-1.9.1.min.js"></script>
	<script src="${pageContext.request.contextPath}/share/js/jquery-ui.js"></script>
	<script src="${pageContext.request.contextPath}/share/js/common.js"></script>
	<script type="text/javascript" src="<c:url value="/share/js/jquery.sparkline.min.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/js/fontawesome-all.min.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/js/dhtmlx/dhtmlx.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/js/script.js"/>?t=20200115"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/share/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/share/js/jquery.scroll.pack.js"></script>
	<script type="text/javascript" src="<c:url value="/share/js/chart/opts/fusioncharts.opts.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/share/js/chart/fusioncharts.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/share/js/jquery.fixedheadertable.min.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/share/js/chart/fusioncharts-jquery-plugin.min.js"/>"></script>
	<script type='text/javascript' src='https://d1bxh8uas1mnw7.cloudfront.net/assets/embed.js'></script>
	<script type="text/javascript" src="<c:url value="/js/jquery/jquery.modal.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/js/main_nav.js"/>"></script>
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

		.write_tbl { width:100%; border-top:2px solid #5e9bf8; font-size: 12px; }
		.write_tbl caption { display: none;   }
		.write_tbl tbody th { background: #f3f3f3; padding: 10px 12px; border-bottom: 1px solid #b1b1b1; text-align: left; }
		.write_tbl tbody td { padding: 10px 10px; border-bottom: 1px solid #b1b1b1;}
		.write_tbl .checkbox, .radio {
			display: inline;
		}
		.write_tbl label {
			display: inline;
			max-width: 100%;
			font-weight: 700;
		}
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
			bindSettingModalLink();
		});

		$(window).resize(function(){
			effectBySize();
		});

		function fn_changeTab(num){
			if(num == '1'){
				$("#receiver_tab").attr("class","on");
				$("#msg_view_tab").attr("class","");
				$("#modal12_user_div").css("display", "block");
				$("#modal12_message_div").css("display", "none");
			}
		}

		function closeModal(num){
			$(".modalClose_btn").click(function(){
				$("#modal_bg" + num).css("display", "none");
				$("#modal_layer" + num).css("display", "none");
			});
			$("#modal_bg" + num).click(function(){
				$("#modal_bg" + num).css("display", "none");
				$("#modal_layer" + num).css("display", "none");
			});
		}

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
			<h1 class="rss_logo"><a href="${pageContext.request.contextPath}/home/login.do">Research Support System</a></h1>
			<div class="user_search_wrap">
				<%--<input type="text" title="검색" class="u_s_int"  placeholder="Search" id="searchAllName" name="searchAllName"/>--%>
				<form action="${pageContext.request.contextPath}/search/all.do" method="get" id="searchAllForm" onsubmit="return searchCheck()">
					<input class="u_s_int" type="text" placeholder="연구자 이름, 연구분야 또는 키워드를 입력하세요." id="searchAllName" name="searchAllName" value="<c:out value="${searchAllName}"/>">
					<span class="focus-border">
						<i></i>
					</span>
					<a href="javascript:searchCheck2()" class="search_bt"></a>
				</form>
			</div>
			<div class="s_h_right_box">
				<a href="#modal_layer12" class="top_icon_btn setting_btn modalSettingLink">설정</a>
				<%--<a href="#" class="top_icon_btn setting_btn">설정</a>--%>
				<div class="service_bt_wrap">
					<a href="#" class="top_icon_btn service_btn">서비스 이동</a>
					<div class="service_link_box">
						<ul>
							<li><a <c:if test="${RSS.admin eq 'Y' or RSS.user eq 'Y'}">href="javascript:location.href='${RSS.url}'"</c:if><c:if test="${RSS.admin eq 'N' and RSS.user eq 'N'}"> class="service_gray"</c:if>><em class="system_rss">RSS</em><span>RSS</span></a></li>
							<li><a <c:if test="${RIMS.admin eq 'Y' or RIMS.user eq 'Y'}">href="javascript:location.href='${RIMS.url}'"</c:if><c:if test="${RIMS.admin eq 'N' and RIMS.user eq 'N'}"> class="service_gray"</c:if>><em>Rims</em><span>RIMS</span></a></li>
							<li><a <c:if test="${DISCOVERY.admin eq 'Y' or DISCOVERY.user eq 'Y'}">href="javascript:location.href='${DISCOVERY.url}'"</c:if><c:if test="${DISCOVERY.admin eq 'N' and DISCOVERY.user eq 'N'}"> class="service_gray"</c:if>><em class="system_rd">Discovery</em><span>Discovery</span></a></li>
							<li><a <c:if test="${S2JOURNAL.admin eq 'Y' or S2JOURNAL.user eq 'Y'}">href="javascript:javascript:document.s2j.submit();"</c:if><c:if test="${S2JOURNAL.admin eq 'N' and S2JOURNAL.user eq 'N'}"> class="service_gray"</c:if>><em class="system_s2">S2jJournal</em><span>S2jJournal</span></a></li>
							<li><a <c:if test="${GOTIT.admin eq 'Y' or GOTIT.user eq 'Y'}">href="javascript:location.href='${GOTIT.url}'"</c:if><c:if test="${GOTIT.admin eq 'N' and GOTIT.user eq 'N'}"> class="service_gray"</c:if>><em class="system_g">GotIt</em><span>GotIt</span></a></li>
							<li><a <c:if test="${PRISM.admin eq 'Y' or PRISM.user eq 'Y'}">href="javascript:location.href='${PRISM.url}'"</c:if><c:if test="${PRISM.admin eq 'N' and PRISM.user eq 'N'}"> class="service_gray"</c:if>><em class="system_prism">PRISM</em><span>PRISM</span></a></li>
							<li><a <c:if test="${SCHOLARWORKS.admin eq 'Y' or SCHOLARWORKS.user eq 'Y'}">href="javascript:location.href='${SCHOLARWORKS.url}'"</c:if><c:if test="${SCHOLARWORKS.admin eq 'N' and SCHOLARWORKS.user eq 'N'}"> class="service_gray"</c:if>><em class="system_sw">ScholarWorks</em><span>ScholarWorks</span></a></li>
							<li><a <c:if test="${BOARD.admin eq 'Y' or BOARD.user eq 'Y'}">href="#"</c:if><c:if test="${BOARD.admin eq 'N' and BOARD.user eq 'N'}"> class="service_gray"</c:if>><em class="system_board">Board</em><span>Board</span></a></li>
						</ul>
					</div>
				</div><!-- 서비스 설정 -->
				<div class="top_user_box">
					<div class="user_box">
						<c:choose>
							<c:when test="${pageContext.response.locale eq 'ko'}">
								${login_user.korNm}
							</c:when>
							<c:otherwise>
								<c:if test="${not empty login_user.lastName}">
									${login_user.lastName}, ${login_user.firstName}
								</c:if>
								<c:if test="${empty login_user.lastName}">
									${login_user.engNm}
								</c:if>
							</c:otherwise>
						</c:choose>
						<a href="<c:url value="/home/logout.do"/>" class="logout_btn">Logout</a>
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
						</ul>
					</div>
				</li>
				<li class="menu">
					<a href="#" class="nav_menu_a" id="bigNetwork"><spring:message code="disc.menu.ntwk"/></a>
					<div class="sub_menu" style="display: none;">
						<ul style="display: none;">
							<li><a href="${pageContext.request.contextPath}/share/article/deptCoAuthor.do"><spring:message code="disc.menu.ntwk.dept"/></a></li>
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
								<li><a href="${pageContext.request.contextPath}/personal/myRss/myResearchOutput.do">My Research Output</a></li>
								<li><a href="${pageContext.request.contextPath}/personal/myRss/myFavorite.do">My Favorite</a></li>
								<li><a href="${pageContext.request.contextPath}/personal/selection.do">Journal Selection Service</a></li>
								<li><a href="${pageContext.request.contextPath}/personal/toc.do">Journal TOC Mailing</a></li>
								<li><a href="${pageContext.request.contextPath}/personal/myRss/rBoard.do">Research Support Board</a></li>
								<li><a href="${pageContext.request.contextPath}/personal/myRss/nBoard.do">Notice Board</a></li>
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
				<em class="f_line">Contact</em>Topic Information Service Team
			</c:if>
			<c:if test="${language eq 'ko'}">
				<em class="f_line">문의</em>학술정보원 주제정보서비스팀
			</c:if>
			<span class="foonter_icon01">${sysConf['system.admin.telno']}</span>
			<span class="foonter_icon02">${sysConf['system.admin.email']}</span>
		</p>
		<p class="fr_text">Copyright (C) 2019, ${sysConf['inst.name.eng.full']}, All Rights Reserved.</p>
	</div>
</div>

	<div id="modal_area" class="overlay" style="display: none;"></div>
	<div class="modal_layer modal_setting" id="modal_layer12" style="width: 800px;">
		<div class="modal_top_title">
			<h2>설정</h2>
			<a href="javascript:void(0);" class="modal_close_btn modalClose_btn">닫기</a>
		</div><!-- modal_top_title : e -->
		<div class="modal_body_wrap">
			<div class="modal_tab">
				<ul>
					<li><a href="javascript:fn_changeTab('1');" class="on" id="receiver_tab">위젯 설정</a></li>
				</ul>
			</div>

			<div id="modal12_user_div">
				<div class="list_top_box">
					<div class="list_top_left_box col_row" style="width:40%; overflow-y: scroll; height: 555px;">
						<c:forEach items="${widgetList}" var="widget" varStatus="stats">
							<c:choose>
								<c:when test="${fn:contains(myWidget, widget.WIDGET_ID)}">
									<div class="col_md_12_rss widgetList list_drag${stats.index + 1}" style="display: none;">
										<p class="arrow_box">${widget.CONTENT}</p>
									</div>
								</c:when>
								<c:otherwise>
									<div class="col_md_12_rss widgetList list_drag${stats.index + 1}">
										<img class="widgetImg" id="drag${stats.index + 1}" src="<c:url value='/share/img/widget/${widget.NAME}.png' />" draggable="true" ondragstart="drag(event)" width="100%" height="100%">
										<p class="arrow_box">${widget.CONTENT}</p>
									</div>
								</c:otherwise>
							</c:choose>
						</c:forEach>
					</div>
					<form id="form-setting1" action="${pageContext.request.contextPath}/widget/submit.do" method="post">
						<div class="list_top_right_box col_row" style="width:60%; margin: 15px 5px 0 0;">
							<c:forEach var="i" begin="0" end="5">
								<div class="col_md_6_rss">
									<div class="drag_div" id="div_drag${i+1}" ondrop="drop(event, 'div_drag${i+1}')" ondragover="allowDrop(event)">
										<c:if test="${not empty myWidget[i]}">
											<c:set var="widgetId" value="${myWidget[i]}"/>
											<img class="widgetImg" id="drag${widgetId}" src="<c:url value='/share/img/widget/${widgetList[widgetId-1].NAME}.png' />" draggable="true" ondragstart="drag(event)" width="95%" height="95%" style="margin-left: 5px; padding-top: 5px;">
											<img class="widget_minus_btn" src="<c:url value='/share/img/background_rss/minus_btn.png'/>" style="cursor:pointer;" onclick="minus_btn(event)" />
											<input type="hidden" name="widget" value="drag${widgetId}" />
										</c:if>
									</div>
								</div>
							</c:forEach>
						</div>
					</form>
				</div>
			</div>

			<div id="modal12_message_div"></div>
		</div><!-- modal_body_wrap : e -->
		<div class="popup_bottom_box"><!-- 팝업 버튼-->
			<a href="javascript:widget_done('1');" class="line_bt"><span class="">적용</span></a>
			<a href="#" class="gray_btn modalClose_btn">닫기</a>
		</div>
	</div>

	<form name="s2j" id="s2j" action="https://s2journal.bwise.kr/rss.do" method=post>
		<!-- 시스템 URL -->
		<input type="hidden" name="rss_resources_url" value="https://rss.bwise.kr/share/" />
		<input type="hidden" name="rss_rss_url" value="${RSS.url}" />
		<input type="hidden" name="rss_rims_url" value="${RIMS.url}" />
		<input type="hidden" name="rss_discovery_url" value="${DISCOVERY.url}" />
		<input type="hidden" name="rss_gotit_url" value="${GOTIT.url}" />
		<input type="hidden" name="rss_prism_url" value="${PRISM.url}" />
		<input type="hidden" name="rss_scholarworks_url" value="${SCHOLARWORKS.url}" />
		<input type="hidden" name="rss_board_url" value="${BOARD.url}" />
		<!-- 사용 권한 -->
		<input type="hidden" name="rss_rss_has" value="${RSS.user}" />
		<input type="hidden" name="rss_rims_has" value="${RIMS.user}" />
		<input type="hidden" name="rss_discovery_has" value="${DISCOVERY.user}" />
		<input type="hidden" name="rss_gotit_has" value="${GOTIT.user}" />
		<input type="hidden" name="rss_prism_has" value="${PRISM.user}" />
		<input type="hidden" name="rss_scholarworks_has" value="${SCHOLARWORKS.user}" />
		<input type="hidden" name="rss_board_has" value="${BOARD.user}" />

		<input type="hidden" name="rss_user_name" value="${userInfo.korNm}" />
		<input type="hidden" name="rss_logout_url" value="https://rss.bwise.kr/home/logout.do" />
	</form>
<!-- ajax loading -->
<%--<div class="wrap-loading" style="display: none;">--%>
	<%--<div><img src='<c:url value="/share/img/common/ajax-loader.gif"/>' /></div>--%>
<%--</div>--%>
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

	function allowDrop(ev) {
		ev.preventDefault();
	}

	function drag(ev) {
		ev.dataTransfer.setData("text", ev.target.id);
		var data = ev.dataTransfer.getData("text");
		var parentId = $("#" + data).parent().attr("id");
		$("#" + parentId).addClass("move");
	}

	function drop(ev, currentId) {
		ev.preventDefault();
		var data = ev.dataTransfer.getData("text");
		var imglog = $("#" + currentId).find(".widgetImg").attr("id");
		if(typeof imglog == 'undefined' || imglog == null){
			// $("#" + currentId + " .widget_minus_btn").remove();
			$("#" + currentId).removeClass("move");
			ev.target.appendChild(document.getElementById(data));

			$("#" + data).css("margin-left", '5px');
			$("#" + data).css("padding-top", '5px');
			$("#" + data).css("height", '95%');
			$("#" + data).css("width", '95%');

			var minusBtn = "<img class='widget_minus_btn' src='" + "<c:url value='/share/img/background_rss/minus_btn.png' />" + "' style='cursor:pointer;' onclick='minus_btn(event)'>";
			var inputTag = "<input type='hidden' name='widget' value='" + data + "' />";
			$("#" + currentId).append(minusBtn);
			$("#" + currentId).append(inputTag);
			$(".list_" + data).hide();

			$('.list_top_right_box').find('.col_md_6_rss').each(function(index, item){
				if(typeof $(this).find('.widgetImg').attr('id') == 'undefined'){
					// $(this).find(".widget_minus_btn").remove();
					// $(this).find("input").remove();
					$(this).find('.drag_div').children().remove();
				}
			});
		} else {
			if($("#" + data).parent().hasClass("drag_div")){
				console.log("dual change");
				// drop의 div 내용
				var imgHTML = $("#" + currentId).find(".widgetImg");
				var inputVal = $("#" + currentId).find("input[name='widget']").val();

				// drag div 내용
				var evImg = $(".move").find(".widgetImg");

				$("#" + currentId).prepend(evImg);
				$(".move").find(".widgetImg").remove();
				$("#" + currentId).find("input[name='widget']").val(data);

				$(".move").prepend(imgHTML);
				$(".move").find("input[name='widget']").val(inputVal);

				$("#" + currentId).removeClass("move");
			}
		}
	}

	function minus_btn(ev){
		var id = $(ev.currentTarget).parent().attr("id");
		var imgId = $('#' + id).find('img').first().attr('id');
		var img = $('#' + id).find('img').first();
		$('.list_' + imgId).prepend(img);
		$('#' + imgId).css("width", "100%");
		$('#' + imgId).css("height", "100%");
		$("#" + imgId).css("margin-left", '0px');
		$("#" + imgId).css("padding-top", '0px');
		$('.list_' + imgId).show();

		$('#' + id).children().remove();
	}

	function widget_done(num){
		// var $form = $("#form-setting" + num);
		// var data = new FormData($form[0]);
		console.log($("#form-setting" + num).serialize());
		$.ajax({
			url: $("#form-setting" + num).attr('action'),
			data: $("#form-setting" + num).serialize(),
			method: "POST",
		}).done(function(){
			location.reload();
		});
		// $("#form-setting" + num).submit();
	}
</script>
</body>
</html>