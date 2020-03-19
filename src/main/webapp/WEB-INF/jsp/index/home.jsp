<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
%><!doctype html>
<html>
	<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta http-equiv="cache-Control" content="co-cache" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=yes"/> 

	<title>Research Support System</title>
	<%@include file="../share/pageInit.jsp" %>
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
	</style>
	<script>
        <%
            String url = request.getRequestURL().toString();
            if(url.contains("rims.rss.ac.kr")){
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

						var appendText = "<li class='add_state'>";

						if(svcgrp == "VART"){
							appendText = appendText + "<span class='u_l_state l_article_t'>journal</span>";
						} else if(svcgrp == "VPAT") {
							appendText = appendText + "<span class='u_l_state l_project_t'>project</span>";
						} else {
							appendText = appendText + "<span class='u_l_state l_patent_t'>patent</span>";
						}

						appendText = appendText + "<a href='" + url + "'>" + title + "</a><span class='sr_under_t'>" + author + "</span></li>";

						$("#topGotit ul").append(appendText);
					}
				} else {
					$("#topGotit ul").append("<li class='add_state'><span class='sr_under_t'>추천 데이터가 없습니다.</span></li>");
				}
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


  
</head>
	<body>

	<div class="system_header_wrap">
		<div class="system_header_inner">
			<h1 class="rss_logo"><a href="${pageContext.request.contextPath}/share/user/main.do">Research Support System</a></h1>
			<div class="user_search_wrap">
				<form action="/rims/share/user/searchAll.do" method="get" id="searchAllForm" onsubmit="return searchCheck()">
					<input class="u_s_int" type="text" placeholder="연구자 이름, 연구분야 또는 키워드를 입력하세요." id="searchAllName" name="searchAllName" value="">
					<span class="focus-border">
						<i></i>
					</span>
					<a href="javascript:searchCheck2()" class="search_bt"></a>
				</form>
			</div>
			<div class="s_h_right_box">
				<a href="#" class="top_icon_btn setting_btn">설정</a>
				<a href="${pageContext.request.contextPath}/share/myRss/myDocument.do" class="top_icon_btn myfolder_btn">내보관함</a>
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
					<%--<a href="#" class="nav_menu_a" id="bigAbout"><img src="../img/background_rss/star.png" style="width: 10%; margin-right: 5px;" />--%>
					<a href="#" class="nav_menu_a" id="myRSS"><spring:message code="disc.menu.rss"/></a>
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





	<div class="user_sub_contents">
		<div class="left_col_box">
			<div class="dash_user_box">
				<span class="dash_user_img">
					<c:if test="${userDetail.profPhotoFileId != null}">
						<img src="${contextPath}/rims/servlet/image/profile.do?fileid=<c:out value="${userDetail.profPhotoFileId}"/>" />
					</c:if>
					<c:if test="${userDetail.profPhotoFileId == null}">
						<img src="<c:url value="/share/img/common/researcher_none_img.jpg"/>"/>
					</c:if>
				</span>
				<%--<span class="dash_user_img"><img src="../img/common_rss/researcher_img.png" /></span>--%>
				<p class="resume_bt_box"><a href="#" class="resume_bt"><span>Resume</span></a></p>

				<c:if test="${userInfo.rid != null or userInfo.scpid != null or userInfo.orcid != null or userInfo.rgtid != null or userInfo.grdid != null}">
					<div class="ri_type_box">
						<c:if test="${userInfo.rid != null}"><a href="http://www.researcherid.com/rid/${userInfo.rid}" class="rid_type" target="_blank" >rid</a></c:if>
						<c:if test="${userInfo.scpid != null}"><a href="https://www.scopus.com/authid/detail.uri?authorId=${userInfo.scpid}" class="si_type" target="_blank">scopus</a></c:if>
						<c:if test="${userInfo.orcid != null}"><a href="http://orcid.org/${userInfo.orcid}" class="id_type" target="_blank">orcid</a></c:if>
						<c:if test="${userInfo.rgtid != null}"><a href="https://www.researchgate.net/profile/${userInfo.rgtid}" class="rg_type" target="_blank">research gate</a></c:if>
						<c:if test="${userInfo.grdId != null}"><a href="https://scholar.google.com/citations?user=${userInfo.grdId}" class="gi_type" target="_blank">google</a></c:if>
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
			<div style="background-color: lightblue; margin-bottom: 10px;">
				<div style="padding: 5px; text-align: center;">투고 저널 추천</div>
			</div>
		</div><!-- left_col_box : e -->
		<div class="u_contents">
			<div class="col_row">
				<div class="col_md_6">
					<div class="dash_box box1">
						<h3>최근 등록 논문</h3>
						<div class="sr_list">
							<ul>
								<c:if test="${not empty recentArticle}">
									<c:forEach items="${recentArticle}" var="content" varStatus="stat">
										<li>
											<a href="${pageContext.request.contextPath}/share/article/articleDetail.do?id=${content.articleId}">${content.orgLangPprNm}</a>
											<span class="sr_under_t">${content.pblcYm} <c:if test="${not empty content.volume or content.volume != ''}">Vol.${content.volume}</c:if> <c:if test="${not empty content.issue or content.issue != ''}">No.${content.issue}</c:if></span>
										</li>
									</c:forEach>
								</c:if>
							</ul>
						</div>
					</div>
				</div>
				<div class="col_md_6">
					<div class="dash_box box1">
						<h3>최근 추천 정보</h3>
						<div class="sr_list" id="topGotit">
							<ul>

							</ul>
						</div>
					</div>
				</div>
				<div class="col_md_6">
					<div class="dash_box box2">
						<h3>공지사항</h3>
						<div class="notice_list">
							<ul>
								<c:choose>
									<c:when test="${fn:length(bbsList) > 0}">
										<c:forEach items="${bbsList}" var="bbs" varStatus="stat">
											<fmt:formatDate var="regDate" pattern="yyyy-MM-dd" value="${bbs.reg_date}" />
											<li>
												<a href="#">${bbs.title}</a><span><c:out value="${regDate}" /></span>
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
					<div class="dash_box box2">
						<h3>연도별 논문수</h3>
						<div class="chart_img">
							<canvas id="chart_canvas" width="377" height="150" style="padding: 0 3px;"></canvas>
						</div>
					</div>
				</div>





			</div><!--  row : e -->


		</div><!--u_contents : e -->


	</div><!--user_sub_contents :  e  -->



	<div class="dash_footer">
		<div class="dash_footer_inner">
			<p>Copyright 2019 Chung-Ang University All Rights Reserved.</p>

		</div>
	</div>




	<script>
		$(function(){
			var topSearchbox = $('.u_s_int');
			topSearchbox.focus(function(){
				$(".user_search_wrap").addClass("u_s_shadow");
			});
			topSearchbox.blur(function(){
				$(".user_search_wrap").removeClass("u_s_shadow");
			});

			var staticsArticle = new Array();
			<%--<c:forEach items="${staticsArticle}" var="item">
				staticsArticle.push("${item}");
			</c:forEach>--%>
			loadArticleChart();


			function loadArticleChart(data){
				var statics = {
					count : [],
					label : []
				};
				/*for(var i=0; i<data.length; i++){
					console.log("count :" + data[i].count);
					console.log("year :" + data[i].year);
					statics.count.push(data[i].count);
					statics.label.push(data[i].year);
				}*/
				<c:forEach items="${staticsArticle}" var="item">
					console.log("count :" + ${item.count});
					console.log("year :" + ${item.year});
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
								borderColor: 'rgb(211, 211, 211)',
								backgroundColor: 'rgb(173, 216, 230)',
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
