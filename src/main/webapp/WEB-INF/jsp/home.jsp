<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
%>
<%
	String adminId = "";
	adminId = request.getAttribute("adminId").toString();
	if(adminId.equals("Y")){
		response.sendRedirect("https://gotit.bwise.kr/auth/admin/main");
	}

    pageContext.setAttribute("replaceChar", "\n");
%>
<!doctype html>
<html>
	<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta http-equiv="cache-Control" content="co-cache" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=yes"/> 

	<title>Research Support System</title>
	<%@include file="./pageInit.jsp" %>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/share/css/bootstrap.min.css"/>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/share/css/layout_RSS.css"/>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/share/css/custom.css"/>
	<link rel="stylesheet" type="text/css" href="<c:url value="/js/dhtmlx/skins/${sysConf['dhtmlx.skin']}/dhtmlx.css"/>" />
	<link rel="stylesheet" href="<c:url value="/share/css/mquery.css"/>">
	<script type="text/javascript" src="<c:url value="/js/dhtmlx/dhtmlx.js"/>"></script>
	<script src="${pageContext.request.contextPath}/share/js/jquery-1.9.1.min.js"></script> 
	<script src="${pageContext.request.contextPath}/share/js/jquery-ui.js"></script>
    <script src="${pageContext.request.contextPath}/share/js/common.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/share/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/share/js/jquery.scroll.pack.js"></script>
	<script type="text/javascript" src="<c:url value="/js/script.js"/>?t=20200115"></script>
    <script type="text/javascript" src="<c:url value="/js/jquery/jquery.modal.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/js/main_nav.js"/>"></script>

	<script type="text/javascript" src="<c:url value="/js/chart/fusioncharts.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/js/chart/fusioncharts-jquery-plugin.min.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/js/chart/opts/fusioncharts.opts.js"/>"></script>

	<link rel="stylesheet" href="<c:url value="/css/chartJS/Chart.min.css" />">
	<script type="text/javascript" src="<c:url value="/js/chartJS/Chart.bundle.min.js" />"></script>
	<script type="text/javascript" src="<c:url value="/js/chartJS/Chart.min.js" />" />

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
            getTopGotit();
			getTocTop();
			bindModalLink();
			bindSettingModalLink();

			// closeModal('12');
			// fn_changeTab('1');
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

        $(window).resize(function(){
            effectBySize();
        })

		function getTopGotit(){
			$.ajax({
				url: "${pageContext.request.contextPath}/gotitTop.do",
				method: "GET",
			}).done(function(data){
				if(data.length > 0){
					for(var i=0; i<data.length; i++){

						var svcgrp = data[i].SVCGRP;
						var title = data[i].TITLE;
						var url = data[i].URL;
						var author = data[i].AUTHOR;
						var regDate = data[i].REGDATE;


						var appendText = "<li class='add_state'>";

						if(svcgrp == "VART"){
							appendText = appendText + "<span class='u_l_state l_article_t'>journal</span>";
						} else if(svcgrp == "VPAT") {
							appendText = appendText + "<span class='u_l_state l_project_t'>project</span>";
						} else {
							appendText = appendText + "<span class='u_l_state l_patent_t'>patent</span>";
						}

						// appendText = appendText + "<a href='" + url + "'>" + title + "</a><span class='sr_under_t'>" + author + "</span></li>";
						appendText = appendText + "<a href='" + url + "'>" + title + "</a><span class='sr_under_t'>";
						if(regDate && author){
							appendText = appendText + regDate  + " / " + author;
						} else {
							if(regDate){
								appendText = appendText + regDate;
							}
							if(author){
								appendText = appendText + author;
							}
						}
						appendText = appendText + "</span></li>";

						$("#topGotit ul").append(appendText);

					}
					var moreAppend = "<a href='https://gotit.bwise.kr/rsch/rec/list' class='main_more_bt' id='gotit_more'>more</a>";
					$("#topGotitTitle").append(moreAppend);
				} else {
					$("#topGotit ul").append("<li class='add_state'><span class='sr_under_t'>추천 정보가 없습니다.</span></li>");
				}
			});
		}


		function getTocTop(){
			$.ajax({
				url: "${pageContext.request.contextPath}/gotitTocTop.do",
				method: "GET",
			}).done(function(data){
				if(data.length > 0){
					for(var i=0; i<data.length; i++){

						var journalName = data[i].JOURNALNAME;
						var volume = data[i].VOLUME;
						var issue = data[i].ISSUE;
						var sendDate = data[i].SENDDATE;

						var appendText = "<li>";

						appendText = appendText + "<a href='${pageContext.request.contextPath}/personal/toc/article.do?msgId=" + data[i].MSG_ID + "'>" + journalName + "</a>";

						appendText = appendText + "<span class='sr_under_t'>" + sendDate + " / Vol." + volume + " No." + issue + "</span>";

						appendText = appendText + "</li>";

						$("#topMailing ul").append(appendText);

						var moreAppend = "<a href='${pageContext.request.contextPath}/personal/toc.do' class='main_more_bt'>more</a>";
						$("#topMailingTitle").append(moreAppend);
					}
				} else {
					$("#topMailing ul").append("<li><span class='sr_under_t'>수신된 목차정보 메일이 없습니다.</span></li>");
				}
			});
		}

		function goGoogleScholar(){
			var gsUrl = "https://scholar.google.com/scholar?as_q=";
			<c:forEach items="${keywordList}" var="keyword" varStatus="stats">
				<c:set var="textLen1" value="${textLen1 + fn:length(keyword.name)}"/>
				<c:if test="${textLen1 < 130}">
					<c:if test="${stats.index > 0}">gsUrl = gsUrl + " OR ";</c:if>
					var keywordName = "${fn:replace(keyword.name, replaceChar, '')}";
					gsUrl = gsUrl +'"' + keywordName + '"';
				</c:if>
			</c:forEach>
			<c:forEach items="${simKeywordList}" var="simKeyword" varStatus="stats">
				<c:set var="textLen2" value="${textLen2 + fn:length(simKeyword.name)}"/>
				<c:if test="${textLen2 < 130}">
					var simKeywordName = "${fn:replace(simKeyword.name, replaceChar, '')}";
					gsUrl = gsUrl +'"' + simKeywordName + '"';
				</c:if>
			</c:forEach>
			window.open(gsUrl, '_blank');
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

		function searchAll(txt){
			$("#searchAllName").val(txt);
			$("#searchAllForm").submit();
			//검색 작업.
		}

		//파이차트
		function animate(elementId, endPercent) {
			var canvas = document.getElementById(elementId);
			var context = canvas.getContext('2d');
			var x = canvas.width / 2;
			var y = canvas.height / 2;
			var radius = 75;
			var circ = Math.PI * 2;
			var quart = Math.PI / 2;

			context.lineWidth = 50;
			context.clearRect(0, 0, canvas.width, canvas.height);
			context.strokeStyle = '#288CFF';  //파이차트 파란색
			context.shadowOffsetX = 0;
			context.shadowOffsetY = 0;
			context.shadowBlur = 10;
			context.shadowColor = '#656565'; // 그림자 색
			context.beginPath();
			context.arc(x, y, radius, -(quart), ((circ) * (endPercent-1)/100) - quart, false);
			context.stroke();

			context.strokeStyle = '#d5d8e0';//파이차트 회색
			context.shadowOffsetX = 0;
			context.shadowOffsetY = 0;
			context.shadowBlur = 10;
			context.shadowColor = '#656565'; // 그림자 색
			context.beginPath();
			context.arc(x, y, radius, -(quart), ((circ) * (endPercent-1)/100) - quart, true);
			context.stroke();
		}

		var chartOpt = {
			type:'dragnode',
			renderAt:'modalBody',
			width:'774',
			height:'589',
			dataFormat:'json',
			containerBackgroundOpacity:'0',
			dataSource:{
				chart:{
					showPlotBorder: "0",
					//                plotFillAlpha:"0",
					xAxisMinValue:'0',
					canvasBorderAlpha:'0',
					canvasBorderThickness:'0',
					chartTopMargin:'3',
					chartLeftMargin:'3',
					chartRightMargin:'3',
					chartBottomMargin:'3',
					xAxisMaxValue:'100',
					yAxisMinValue:'0',
					yAxisMaxValue:'100',
					toolTipColor: '#ffffff',
					toolTipBorderColor: '#ffffff',
					toolTipBorderThickness: '1',
					toolTipBgColor: '#000000',
					toolTipBgAlpha: '80',
					toolTipBorderRadius: '4',
					toolTipPadding: '10',
					toolTipFontSize : '20',
					is3D:'0',
					viewMode:'0',
					showformbtn:'0',
					enableLink:'1',
					baseFontSize:'12',
					baseFont:'Malgun Gothic',
					divLineAlpha:'30',
					numvdivlines:'5',
					divLineIsDashed:'1',
					bgColor:'F7F7F7, E9E9E9',
					useEllipsesWhenOverflow:'0',
					exportShowMenuItem:'0',
					exportDialogMessage:'Building chart output',
					unescapeLinks:'0',
					exportEnabled:'1',
					exportAtClient:'0',
					exportAction:'save',
					exportHandler:"${pageContext.request.contextPath}/servlet/FlashChartExporter/export.do",
					exportCallBack:'myFN'
				}
			}
		};

	</script>

	<c:set var="notStdn" value="${(sessionScope.auth.adminDvsCd ne 'R' or sessionScope.sess_user.gubun ne 'S') and (not sessMode or sessionScope.sess_user.gubun ne 'S') }"/>
</head>
	<body>

	<div class="system_header_wrap">
		<div class="system_header_inner">
			<h1 class="rss_logo"><a href="${pageContext.request.contextPath}/home/login.do">Research Support System</a></h1>
			<div class="user_search_wrap">
				<form action="${pageContext.request.contextPath}/search/all.do" method="get" id="searchAllForm" onsubmit="return searchCheck()">
					<input class="u_s_int" type="text" placeholder="연구자 이름, 연구분야 또는 키워드를 입력하세요." id="searchAllName" name="searchAllName" value="">
					<span class="focus-border">
						<i></i>
					</span>
					<a href="javascript:searchCheck2()" class="search_bt"></a>
				</form>
			</div>
			<div class="s_h_right_box">
				<a href="#modal_layer12" class="top_icon_btn setting_btn modalSettingLink">설정</a>
				<%--<a href="${pageContext.request.contextPath}/share/myRss/myDocument.do" class="top_icon_btn myfolder_btn">내보관함</a>--%>
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
								${userInfo.korNm}
							</c:when>
							<c:otherwise>
								<c:if test="${not empty userInfo.lastName}">
									${userInfo.lastName}, ${userInfo.firstName}
								</c:if>
								<c:if test="${empty userInfo.lastName}">
									${userInfo.engNm}
								</c:if>
							</c:otherwise>
						</c:choose>
						<a href="<c:url value="/home/logout.do"/>" class="logout_btn">Logout</a>
					</div>
				</div>
			</div>

		</div>
	</div><!-- system_header_wrap : e -->



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
					<%--<a href="#" class="nav_menu_a" id="bigAbout"><img src="../img/background_rss/star.png" style="width: 10%; margin-right: 5px;" />--%>
					<a href="#" class="nav_menu_a" id="myRSS"><spring:message code="disc.menu.rss"/></a>
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





	<div class="user_sub_contents">
		<div class="left_col_box">
			<div class="dash_user_box">
				<%--<span class="dash_user_img" style="min-height: 135px;">--%>
					<%--<c:if test="${userInfo.profPhotoFileId != null}">--%>
						<%--<img src="${pageContext.request.contextPath}/servlet/image/profile.do?fileid=<c:out value="${userInfo.profPhotoFileId}"/>" />--%>
					<%--</c:if>--%>
					<%--<c:if test="${userInfo.profPhotoFileId == null}">--%>
						<%--<img src="<c:url value="/share/img/common/researcher_none_img.jpg"/>"/>--%>
					<%--</c:if>--%>
				<%--</span>--%>
				<span class="dash_user_img" style="min-height: 135px;">
					<img src="<c:url value="/share/img/common/researcher_none_img.jpg"/>" width="100%"/>
				</span>
				<div class="resume_bt_box"><a <c:if test="${notStdn}">href="#resumeDialog"</c:if> class="resume_bt <c:if test="${notStdn}">modalLink</c:if>"><span>Resume</span></a></div>

				<c:if test="${userInfo.rid != null or userInfo.scpid != null or userInfo.orcid != null or userInfo.rgtid != null or userInfo.grdId != null}">
					<div class="ri_type_box">
						<a <c:if test="${userInfo.rid != null}">href="http://www.researcherid.com/rid/${userInfo.rid}"</c:if> class="rid_type${userInfo.rid != null ? '_on' : ''}" target="_blank" >rid</a>
						<a <c:if test="${userInfo.scpid != null}">href="https://www.scopus.com/authid/detail.uri?authorId=${userInfo.scpid}"</c:if> class="si_type${userInfo.scpid != null ? '_on' : ''}" target="_blank">scopus</a>
						<a <c:if test="${userInfo.orcid != null}">href="http://orcid.org/${userInfo.orcid}"</c:if> class="id_type${userInfo.orcid != null ? '_on' : ''}" target="_blank">orcid</a>
						<a <c:if test="${userInfo.rgtid != null}">href="https://www.researchgate.net/profile/${userInfo.rgtid}"</c:if> class="rg_type${userInfo.rgtid != null ? '_on' : ''}" target="_blank">research gate</a>
						<a <c:if test="${userInfo.grdId != null}">href="https://scholar.google.com/citations?user=${userInfo.grdId}"</c:if> class="gi_type${userInfo.grdId != null ? '_on' : ''}" target="_blank">google</a>
					</div>
				</c:if>
			</div>
			<div class="dash_keyword">
				<h3>Keyword</h3>
				<div>
					<c:forEach items="${keywordList}" var="keyword" varStatus="stat">
						<c:set var="textLen" value="${textLen + fn:length(keyword.name)}"/>
						<c:if test="${textLen < 130}">
							<a href="javascript:searchAll('<c:out value="${keyword.name}"/>');" class="keyword_graph keyw">
								<canvas class="chart_b" id="keyGraph${stat.index}" width="250" height="250"></canvas>
								<script>
									animate("keyGraph${stat.index}", (${keyword.num}*100)/${keywordList[0].num});
								</script>
								<span class="keyword_b keyw"><c:out value="${keyword.name}"/></span>
							</a>
						</c:if>
					</c:forEach>
				</div>
			</div>
		</div><!-- left_col_box : e -->
		<div class="u_contents">
			<div class="col_row">
				<%--<c:if test="${not empty myWidget}">--%>
					<%--<c:forEach items="${myWidget}" var="mw" varStatus="stat">--%>
						<%--<c:set var="includeValue" value="widget/${widgetList[mw-1].NAME}.jsp" />--%>
						<%--<jsp:include page='${includeValue}' flush='true'/>--%>
					<%--</c:forEach>--%>
				<%--</c:if>--%>
				<%@ include file="widget/myResearchOutput.jsp" %>
				<div class="col_md_6">
					<div class="dash_box box1">
						<h3 id="topGotitTitle">최근 추천 정보</h3>
						<div class="sr_list" id="topGotit">
							<ul>

							</ul>
						</div>
					</div>
				</div>
				<div class="col_md_6">
					<div class="dash_box box1">
						<h3>공지사항<c:if test="${fn:length(bbsList) > 0}"><a href="${pageContext.request.contextPath}/personal/myRss/nBoard.do" class="main_more_bt">more</a></c:if></h3>
						<div class="sr_list">
							<ul>
								<c:choose>
									<c:when test="${fn:length(bbsList) > 0}">
										<c:forEach items="${bbsList}" var="bbs" varStatus="stat">
											<li>
												<a href="${pageContext.request.contextPath}/personal/myRss/nBoardDetail.do?bbsId=${bbs.bbsId}">${bbs.title}</a>
												<span class="sr_under_t">
													<c:if test="${not empty bbs.noticeSttDate or bbs.noticeSttDate != ''}"><c:out value="${bbs.noticeSttDate}" /></c:if>
													<c:if test="${not empty bbs.noticeEndDate or bbs.noticeEndDate != ''}">~ <c:out value="${bbs.noticeEndDate}" /></c:if>
												</span>
											</li>
										</c:forEach>
									</c:when>
									<c:otherwise>
										<li>
											<p>공지사항이 없습니다.</p>
										</li>
									</c:otherwise>
								</c:choose>
							</ul>
						</div>
					</div>
				</div>
                <%@ include file="widget/myAnalysis.jsp" %>

				<div class="col_md_6">
					<div class="dash_box box1">
						<h3>교내 공동 연구자 추천</h3>
						<div class="google_scholar_box" style="margin-top: 70px;">
							<c:choose>
								<c:when test="${not empty smUser}">
									<p class="gs_r_left">
										<a href="${pageContext.request.contextPath}/share/user/userDetail.do?id=${userInfo.encptUserId}"><img src="<c:url value='/share/img/common/researcher_none_img.jpg'/>" width="100%"/></a>
									</p>
									<div class="gs_r_link">
										<a href="#" onclick="goGoogleScholar()"><span>Google Scholar</span></a>
									</div>
									<p class="gs_r_right">
										<a href="${pageContext.request.contextPath}/share/user/userDetail.do?id=${smUser.encptUserId}"><img src="<c:url value='/share/img/common/researcher_none_img.jpg' />"></a>
										<span style="text-align: center; margin-top: 5px; display: block;">${smUser.korNm}</span>
										<span style="text-align: center; display: block;">${smUser.deptKor}</span>
									</p>
								</c:when>
								<c:otherwise>
									<ul>
										<li>
											<p>교내 공동 연구자에 대한 추천 정보가 없습니다.</p>
										</li>
									</ul>
								</c:otherwise>
							</c:choose>
						</div>
					</div>
				</div>
				<div class="col_md_6">
					<div class="dash_box box1">
						<h3 id="topMailingTitle">목차정보 메일링 목록</h3>
						<div class="sr_list" id="topMailing">
							<ul>

							</ul>
						</div>
					</div>
				</div>
			</div><!--  row : e -->
		</div><!--u_contents : e -->
	</div><!--user_sub_contents :  e  -->

    <div id="modal_area" class="overlay" style="display: none;"></div>
    <div id="resumeDialog" class="popup_box modal modal_layer" style="font-size: 12px;padding:0; margin:0;width: 520px;height:350px; display: none;">
        <form id="resumeFrm">
            <input type="hidden" name="apprDvsCd" value="3" />
            <input type="hidden" name="userId" value="${userInfo.userId}" />
            <input type="hidden" name="type" id="resumeType" value="" />
            <div class="popup_header">
                <h3>Resume</h3>
                <a href="#" id="closeBtn" class="close_bt closeBtn">닫기</a>
            </div>
            <div class="popup_inner">
                <table class="write_tbl mgb_20">
                    <colgroup>
                        <col style="width:26%;" />
                        <col style="width:37%;" />
                        <col style="width:37%;" />
                    </colgroup>
                    <tbody>
                    <tr>
                        <th rowspan="2"><spring:message code="resume.select.output"/></th>
                        <td colspan="2">
                            <input type="checkbox" id="chk_all" name="chk_all" class="chk_rslt radio" onclick="javascript:if($(this).prop('checked')){$('.chk_rslt').prop('checked',true);}else{$('.chk_rslt').prop('checked',false);}"/>
                            <label for="chk_all" class="radio_label"><spring:message code="resume.chk"/></label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <input type="checkbox" id="resume_art" name="gubun" value="article" class="chk_rslt radio" checked="checked"/>
                            <label for="resume_art" class="radio_label"><spring:message code="resume.art"/></label>
                            <br/><br/>

                            <input type="checkbox" id="resume_con" name="gubun" value="conference" class="radio" />
                            <label for="resume_con" class="radio_label"><spring:message code="resume.con"/></label>

                            <br/><br/>
                            <%--
                            <input type="checkbox" id="resume_book" name="gubun" value="book" class="radio" disabled="disabled"/>
                            <label for="resume_book" class="radio_label"><spring:message code="resume.book"/></label>
                            --%>
                        </td>
                    </tr>
                    <tr>
                        <th><spring:message code="resume.limit.year"/></th>
                        <td colspan="2">
                            <input type="text" id="sttDate" name="sttDate" class="input2"  maxlength="4" style="width: 80px;"/>
                            ~ <input type="text" id="endDate" name="endDate" class="input2" maxlength="4" style="width: 80px;"/>
                            <input type="checkbox" name="isAccept" id="isAccept" value="true" class="radio"/>
                            <label for="isAccept" class="radio_label"><spring:message code='search.art9'/></label>
                        </td>
                    </tr>
                    <tr>
                        <th><spring:message code="resume.include.basicinfo"/></th>
                        <td colspan="2">
                            <input type="radio" id="basicInfoInclsAt_Y" name="basicInfoInclsAt" value="Y" checked="checked" class="radio"/>
                            <label for="basicInfoInclsAt_Y" class="radio_label"><spring:message code='common.radio.yes' /></label>&nbsp;&nbsp;
                            <input type="radio" id="basicInfoInclsAt_N" name="basicInfoInclsAt" value="N" class="radio" />
                            <label for="basicInfoInclsAt_N" class="radio_label"><spring:message code='common.radio.no'/></label>
                        </td>
                    </tr>
                    </tbody>
                </table>
                <div class="list_set">
                    <ul>
                        <li><a href="javascript:$('#resumeType').val('word');fn_resume_2();" class="list_icon24">WORD Download</a></li>
                        <li><a href="javascript:$('#resumeType').val('pdf');fn_resume_2();" class="list_icon23">PDF Download</a></li>
                    </ul>
                </div>
            </div>
        </form>
    </div>

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
						<div class="list_top_right_box col_row" style="width:60%;">
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

	<%--<div class="dash_footer">--%>
		<%--<div class="dash_footer_inner">--%>
			<%--<em class="f_line">문의</em>학술정보원 주제정보서비스팀--%>
			<%--<p>Copyright 2019 Chung-Ang University All Rights Reserved.</p>--%>
			<%--<span class="foonter_icon01">${sysConf['system.admin.telno']}</span>--%>
			<%--<span class="foonter_icon02">${sysConf['system.admin.email']}</span>--%>
		<%--</div>--%>
	<%--</div>--%>
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

	<c:if test="${fn:length(popupList) > 0}">
		<c:forEach items="${popupList}" var="popup" varStatus="stats">
			<div class="popup-box" id="div_laypopup${stats.index}" align="center" style="display:none;border-width:0px;Z-INDEX: 201; position: absolute; left:150px; top:170px; background-color: #2d2b4e; width: auto; min-width: 250px; border-radius: 5px; box-shadow: 2px 2px 4px 1px #0c1529;">
				<div class="popup-header" style="padding-top: 5px; padding-bottom: 5px; color: white; font-size: 12px; height: 23px;">
					<span>${popup.title}</span>
				</div>
				<div class="popup-body" style="background-color: white; display: flow-root; border-bottom-left-radius: 5px; border-bottom-right-radius: 5px; margin-left: 2px;">
					<div class="popup_content${stats.index}" style="padding:10px 0; border-bottom: 1px solid black;"><c:out value="${popup.content}" escapeXml="false"/></div>
					<div style="float: left; margin-top: 5px; margin-left: 5px; margin-bottom:5px; display: flex; background-color: white;">
						<input type="checkbox" name="close" value="OK" onclick="closeWinDay('${stats.index}');" style="margin: 2px 5px 0 0;"/> <span style="padding-top: 1px; font-size: 12px;">하루동안 이 창을 열지 않음</span>
					</div>
					<div style="float: right; margin-top: 4px; margin-right: 5px; cursor: pointer; background-color: white;">
						<a onclick="closeWin('${stats.index}');"/> <span style="font-size: 12px;">닫기</span></a>
					</div>
				</div>
			</div>
		</c:forEach>
	</c:if>

	<script>
		$(function(){
			//popup
			var now = new Date();
			var aa = now.getFullYear()+''+getStrNo((now.getMonth()+1))+''+getStrNo(now.getDate());

			var left = 0;
			var top = 0;

			<c:if test="${fn:length(popupList) > 0}">
				<c:forEach items="${popupList}" var="popup" varStatus="stats">
					var startDate = "${popup.noticeSttDate}";
					var endDate = "${popup.noticeEndDate}";
					startDate = startDate.replace(/-/gi, "");
					endDate = endDate.replace(/-/gi, "");
					if ( aa >= startDate && aa <= endDate ) {
						if(getCookie("todayClose") == "Y"){
							$("#div_laypopup${stats.index}").hide();
						} else {
							$("#div_laypopup${stats.index}").show();
							if(${stats.index > 0}){
								var mLeft = $("#div_laypopup${stats.index}").css("left") + "";
								var mTop = $("#div_laypopup${stats.index}").css("top") + "";
								left = mLeft.replace("px","")*1 + 50;
								top = mTop.replace("px","")*1 + 50;
								$("#div_laypopup${stats.index}").css("left", left);
								$("#div_laypopup${stats.index}").css("top", top);
							}
						}
					}
				</c:forEach>
			</c:if>

			$(".popup-box").draggable({'cancel':'.popup-body', containment:'parent', scroll:false});

		});

		function getStrNo(str) {
			if(str < 10) {
				return "0"+str;
			} else {
				return str;
			}
		}
		function closeWinDay(id){
// setCookieMobile( "todayCookie", "done" , 1);
			setCookie('todayClose','Y', 1);
			var popupId = "div_laypopup" + id;
			$("#" + popupId).hide();
		}
		function closeWin(id){
			var popupId = "div_laypopup" + id;
			$("#" + popupId).hide();
		}
		function setCookie(cookieName, value, exdays){
			var exdate = new Date();
			exdate.setDate(exdate.getDate() + exdays);
			var cookieValue = escape(value) + ((exdays==null) ? "" : "; expires=" + exdate.toGMTString());
			document.cookie = cookieName + "=" + cookieValue;
		}
		function getCookie(cookieName) {
			cookieName = cookieName + '=';
			var cookieData = document.cookie;
			var start = cookieData.indexOf(cookieName);
			var cookieValue = '';
			if(start != -1){
				start += cookieName.length;
				var end = cookieData.indexOf(';', start);
				if(end == -1)end = cookieData.length;
				cookieValue = cookieData.substring(start, end);
			}
			return unescape(cookieValue);
		}


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
