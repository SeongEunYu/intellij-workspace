<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
%><!doctype html>
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
        });

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
				<c:if test="${stats.index > 0}">gsUrl = gsUrl + " OR ";</c:if>
				gsUrl = gsUrl +'"' + "${keyword.name}" + '"';
			</c:forEach>
			<c:forEach items="${simKeywordList}" var="simKeyword" varStatus="stats">
				<c:if test="${stats.index > 0}">gsUrl = gsUrl + " OR ";</c:if>
				gsUrl = gsUrl +'"' + "${simKeyword.name}" + '"';
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
				<a href="#" class="top_icon_btn setting_btn">설정</a>
				<%--<a href="${pageContext.request.contextPath}/share/myRss/myDocument.do" class="top_icon_btn myfolder_btn">내보관함</a>--%>
				<div class="service_bt_wrap">
					<a href="#" class="top_icon_btn service_btn">서비스 이동</a>
					<div class="service_link_box">
						<ul>
							<li><a <c:if test="${RSS.admin eq 'Y' or RSS.user eq 'Y'}">href="https://rss.bwise.kr/home/login.do"</c:if><c:if test="${RSS.admin eq 'N' and RSS.user eq 'N'}"> class="service_gray"</c:if>><em class="system_rss">RSS</em><span>RSS</span></a></li>
							<li><a <c:if test="${RIMS.admin eq 'Y' or RIMS.user eq 'Y'}">href="https://rims.cau.ac.kr/"</c:if><c:if test="${RIMS.admin eq 'N' and RIMS.user eq 'N'}"> class="service_gray"</c:if>><em>Rims</em><span>RIMS</span></a></li>
							<li><a <c:if test="${DISCOVERY.admin eq 'Y' or DISCOVERY.user eq 'Y'}">href="#"</c:if><c:if test="${DISCOVERY.admin eq 'N' and DISCOVERY.user eq 'N'}"> class="service_gray"</c:if>><em class="system_rd">Discovery</em><span>Discovery</span></a></li>
							<li><a <c:if test="${S2JOURNAL.admin eq 'Y' or S2JOURNAL.user eq 'Y'}">href="https://s2journal.bwise.kr/"</c:if><c:if test="${S2JOURNAL.admin eq 'N' and S2JOURNAL.user eq 'N'}"> class="service_gray"</c:if>><em class="system_s2">S2jJournal</em><span>S2jJournal</span></a></li>
							<li><a <c:if test="${GOTIT.admin eq 'Y' or GOTIT.user eq 'Y'}">href="https://gotit.bwise.kr/auth/rsch/main"</c:if><c:if test="${GOTIT.admin eq 'N' and GOTIT.user eq 'N'}"> class="service_gray"</c:if>><em class="system_g">GotIt</em><span>GotIt</span></a></li>
							<li><a <c:if test="${PRISM.admin eq 'Y' or PRISM.user eq 'Y'}">href="#"</c:if><c:if test="${PRISM.admin eq 'N' and PRISM.user eq 'N'}"> class="service_gray"</c:if>><em class="system_prism">PRISM</em><span>PRISM</span></a></li>
							<li><a <c:if test="${SCHOLARWORKS.admin eq 'Y' or SCHOLARWORKS.user eq 'Y'}">href="#"</c:if><c:if test="${SCHOLARWORKS.admin eq 'N' and SCHOLARWORKS.user eq 'N'}"> class="service_gray"</c:if>><em class="system_sw">ScholarWorks</em><span>ScholarWorks</span></a></li>
							<li><a <c:if test="${BOARD.admin eq 'Y' or BOARD.user eq 'Y'}">href=""</c:if><c:if test="${BOARD.admin eq 'N' and BOARD.user eq 'N'}"> class="service_gray"</c:if>><em class="system_board">Board</em><span>Board</span></a></li>
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
								<li><a href="${pageContext.request.contextPath}/personal/toc.do">Journal TOC Mailing</a></li>
								<li><a href="${pageContext.request.contextPath}/personal/myRss/rBoard.do">Research Support Board</a></li>
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
			<div style="background-color: #39484d; margin-bottom: 18px; border-radius: 10px;">
				<div style="padding: 5px; text-align: center;"><a href="${pageContext.request.contextPath}/personal/selection.do" style="color: white;">투고 저널 추천</a></div>
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
				<div class="col_md_6">
					<div class="dash_box box1">
						<h3>나의 최근 등록 논문<c:if test="${fn:length(recentArticle) > 0}"><a href="${pageContext.request.contextPath}/personal/myRss/myResearchOutput.do" class="main_more_bt">more</a></c:if></h3>
						<div class="sr_list">
							<ul>
								<c:choose>
									<c:when test="${fn:length(recentArticle) > 0}">
										<c:forEach items="${recentArticle}" var="content" varStatus="stat">
											<li>
												<a href="${pageContext.request.contextPath}/share/article/articleDetail.do?id=${content.articleId}">${content.orgLangPprNm}</a>
												<span class="sr_under_t">${content.pblcYm} <c:if test="${not empty content.volume or content.volume != ''}">Vol.${content.volume}</c:if> <c:if test="${not empty content.issue or content.issue != ''}">No.${content.issue}</c:if></span>
											</li>
										</c:forEach>
									</c:when>
									<c:otherwise>
										<li>
											<p>등록된 논문이 없습니다.</p>
										</li>
									</c:otherwise>
								</c:choose>
							</ul>
						</div>
					</div>
				</div>
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
						<h3>공지사항<c:if test="${fn:length(bbsList) > 0}"><a href="#" class="main_more_bt">more</a></c:if></h3>
						<div class="sr_list">
							<ul>
								<c:choose>
									<c:when test="${fn:length(bbsList) > 0}">
										<c:forEach items="${bbsList}" var="bbs" varStatus="stat">
											<li>
												<a href="#">${bbs.title}</a>
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
				<div class="col_md_6">
					<div class="dash_box box1">
						<h3>연도별 논문 수</h3>
						<div class="chart_img" style="margin: 40px 0px;">
							<canvas id="chart_canvas" width="377" height="220" style="padding: 0 3px;"></canvas>
						</div>
					</div>
				</div>

				<div class="col_md_6">
					<div class="dash_box box1">
						<h3>교내 공동 연구자 추천</h3>
						<div class="google_scholar_box" style="margin-top: 70px;">
							<c:choose>
								<c:when test="${not empty smUser}">
									<%--<div>${userInfo.korNm}</div>--%>
									<%--<div>${smUser.korNm}</div>--%>
									<p class="gs_r_left">
										<a href="${pageContext.request.contextPath}/share/user/userDetail.do?id=${userInfo.encptUserId}"><img src="<c:url value="/share/img/common/researcher_none_img.jpg"/>" width="100%"/></a>
									</p>
									<div class="gs_r_link">
										<a href="#" onclick="goGoogleScholar()"><span>Google Scholar</span></a>
									</div>
									<p class="gs_r_right">
										<a href="${pageContext.request.contextPath}/share/user/userDetail.do?id=${smUser.encptUserId}"><img src="<c:url value="/share/img/common/researcher_none_img.jpg"/>" width="100%"/></a>
										<p style="text-align: center; margin-top: 5px;">${smUser.korNm}</p><br>
										<c:if test="${smUser.deptKor}">
											<p style="text-align: center;">(${smUser.deptKor})</p>
										</c:if>
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

	<div id="mailingDialog" class="popup_box modal2 modal_layer" style="font-size: 12px;padding:0; margin:0;width: 520px;height:350px; display: none;">
		<div class="popup_header">
			<h3>Resume</h3>
			<a href="#" id="closeBtn2" class="close_bt closeBtn">닫기</a>
		</div>
		<div class="popup_inner2">

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

	<script>
		$(function(){

			// var topSearchbox = $('.u_s_int');
			// topSearchbox.focus(function(){
			// 	$(".user_search_wrap").addClass("u_s_shadow");
			// });
			// topSearchbox.blur(function(){
			// 	$(".user_search_wrap").removeClass("u_s_shadow");
			// });

			loadArticleChart();

			function loadArticleChart(){
				var statics = {
					count : [],
					label : []
				};

				<c:forEach items="${staticsArticle}" var="item">
					statics.count.push(${item.count});
					statics.label.push(${item.year});
				</c:forEach>
				updateStatics("chart_canvas", statics);
			}

			function updateStatics(id, statics) {
				var div = $("#" + id);
				var chart = div.data("chart");
				if(chart) chart.distroy();
				chart = drawStatics(div[0], statics);
				div.data("chart", chart);
			}

			function drawStatics(target, statics) {
				return new Chart(target, {
					type: 'line',
					data: {
						labels: statics.label,
						datasets: [
							{
								data: statics.count,
								backgroundColor: 'rgb(000, 051, 102)',
								borderColor: 'rgb(153, 153, 153)',
								fill: false,
								pointRadius: 4,
								lineTension: 0.00000001
							}
						]
					},
					options: {
						responsive: true,
						title: {
							display: false
						},
						tooltips: {
							mode: 'index',
							intersect: false,
						},
						hover: {
							mode: 'nearest',
							intersect: true
						},
						legend: {
							display: false,
							position: 'right'
						},
						scales: {
							xAxes: [{
								display: true,
								scaleLabel: {
									display: true,
									labelString: 'Year'
								}
							}],
							yAxes: [{
								display: true,
								ticks: {
									beginAtZero: true
								},
								scaleLabel: {
									display: true,
									labelString: 'count'
								}
							}]
						}
					}
				});
			}
		});
	</script>

</body>
</html>
