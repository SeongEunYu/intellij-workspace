<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
%><%@ taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator"
%><%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"
%><!doctype html>
<head>
<%@include file="../pageInit.jsp" %>
<link rel="stylesheet" type="text/css" href="<c:url value="/js/dhtmlx/skins/${sysConf['dhtmlx.skin']}/dhtmlx.css"/>" />
<link rel="stylesheet" type="text/css" href="<c:url value="/share/css/bootstrap.min.css"/>" />
<LINK rel=stylesheet type=text/css	href="<c:url value="/share/css/fixedheader.css"/>">

<script type="text/javascript" src="<c:url value="/share/js/jquery-1.9.1.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/share/js/jquery-ui.js"/>"></script>
<script type="text/javascript" src="<c:url value="/share/js/jquery.scroll.pack.js"/>"></script>
<script type="text/javascript" src="<c:url value="/share/js/bootstrap.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/share/js/chart/opts/fusioncharts.opts.js"/>"></script>
<script type="text/javascript" src="<c:url value="/share/js/chart/fusioncharts.js"/>"></script>
<script type="text/javascript" src="<c:url value="/share/js/jquery.fixedheadertable.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/share/js/chart/fusioncharts-jquery-plugin.min.js"/>"></script>
<title>연구자</title>
<style>
.keyword_graph {padding: 5px 7px;    }
.keyword_b  {font-size: 13px;}
.keyword_graph .chart_b{ width: 20px; height: 20px;}
.rl_box ul li .rl_minus { border: 1px solid #dbdbdb; width: 39px;height: 39px;background:#f9f9f9 url(<c:url value="/share/img/minus_icon.png"/>) no-repeat 50% -15px;border-radius: 50%;text-indent: -999999px;   }
.rl_box ul li .rl_minus:hover {background:#474747 url(<c:url value="/share/img/minus_icon.png"/>) no-repeat 50% 12px;  border:1px solid #474747;}
.r_name a { margin-left: 5px; display: inline-block; width:34px; height: 34px; text-indent: -99999px;  }
.rl_box { padding-right: 40px;}
</style>
<link rel="stylesheet" type="text/css" href="<c:url value="/share/css/mquery.css"/>" />
<script type="text/javascript">
	var sort = "";
	var order = "";
	var temp = 1;

	$(function(){
		//대메뉴 researcher에 형광색 들어오게하기
		$("#bigResearcher").addClass("on");

		//키워드 길이 체크
		/*while($(".view_keyword_wrap").height() > 70){  //키워드 상자가 다음줄로 넘어가면
			$(".keyword_graph.keyw").eq($(".keyword_graph.keyw").length-1).remove();   //끝에 키워드상자 부터 삭제

			/!*if($(".keyword_b.keyw").text().length <= 119){
				$(".view_fp_box.keyw").append("...");
			}*!/
		}*/

		//Journal Article 선택
		tabClick("journal");

		// favorite check
		checkFavorite("${userDetail.encptUserId}")
	});

	function editFavorite(){
		var ajaxURL = "${pageContext.request.contextPath}/editFavorite.do";
		var svcgrp = "VUSER";
		var type = "";
		if($(".favorite_star").hasClass("star_fill")){
			type = "remove";
		} else {
			type = "add";
		}
		var itemId = "${userDetail.encptUserId}";
		var url = "${pageContext.request.requestURL}";

		//ajax
		$.ajax({
			url: ajaxURL,
			data: {itemId:itemId, svcgrp:svcgrp, type:type, url:url}
		}).done(function(){
			$(".favorite_star").remove();
			checkFavorite(itemId);
		});
	}

	function checkFavorite(itemId){

		var svcgrp = "VUSER";

		$.ajax({
			url: "${pageContext.request.contextPath}/checkFavorite.do",
			method: "GET",
			data: {itemId : itemId, svcgrp : svcgrp}
		}).done(function(data){

			var starCode = "";
			if(data){
				starCode = "<span class='favorite_star star_fill' onclick='editFavorite();'></span>";
			} else {
				starCode = "<span class='favorite_star star_empty' onclick='editFavorite();'></span>";
			}

			$(".r_name").append(starCode);
		});
	}

	function tabClick(tabId){

		// 탭 클릭시 파란색 들어오게함.
		$(".tab_wrap a").removeClass("on");
		$("#"+tabId).attr("class","on");

		sort = "date";
		order = "desc";

		makeContents(tabId, "1");
	}

	//tabId : journal, funding, patent, conference 중 1개
	function makeContents(tabId, page){
		$(".sub_container .article_list_box").addClass("willBeDeleted");
		$(".paging_nav").empty();

		$.ajax({
			url: "${pageContext.request.contextPath}/share/user/content.do",
			method: "GET",
			data: {tabId : tabId, id : "${userDetail.encptUserId}", page:page, sort:sort, order:order}
		}).done(function(data){

			//성과 유무
			if(data.count.end == 0){
				$(".page_num_box").addClass("hidden");
				$(".list_sort_box").addClass("hidden");
				$(".paging_nav").addClass("hidden");
				$(".list_top_box").attr("align","center");
				$(".list_top_box h3").text( '<spring:message code="disc.display.nodata"/>');
				$("#memo").text("");
				$(".willBeDeleted").remove();
				return false;
			}else{
				$(".page_num_box").removeClass("hidden");
				$(".list_sort_box").removeClass("hidden");
				$(".paging_nav").removeClass("hidden");
				<c:if test="${language eq 'en'}">
					$(".page_num_box").text(String(data.count.ps).replace(/\B(?=(\d{3})+(?!\d))/g, ",")+" - "+String(data.count.end).replace(/\B(?=(\d{3})+(?!\d))/g, ",")+" out of "+String(data.count.total).replace(/\B(?=(\d{3})+(?!\d))/g, ",")+" results");
				</c:if>
				<c:if test="${language eq 'ko'}">
					$(".page_num_box").text(String(data.count.ps).replace(/\B(?=(\d{3})+(?!\d))/g, ",")+" - "+String(data.count.end).replace(/\B(?=(\d{3})+(?!\d))/g, ",")+"건 / "+String(data.count.total).replace(/\B(?=(\d{3})+(?!\d))/g, ",")+"건");
				</c:if>
				$(".list_top_box").attr("align","");
				$(".list_top_box h3").text("");
			}

			//sorting
			$(".list_sort_box a").removeClass();

			if(tabId != "journal"){
				$("#tc").addClass("hidden");
			}

			$("#date").css("font-weight","");
			$("#title").css("font-weight","");
			$("#tc").css("font-weight","");
			$("#"+sort).addClass(order.slice(0,-1)+"_type");
			$("#"+sort).css("font-weight","bold");

			for(var i=0; i<data.content.length; i++){

				var content = $(".article_list_box.hidden").clone();
				content.removeClass("hidden");

				//성과 종류에 따른 내용물(content)
				if(tabId == "journal"){
					$("#memo").text("");
					content.find("div").addClass("alb_text_box");

					// 피인용 횟수가 있으면
					if(data.content[i].kciTc+data.content[i].scpTc+data.content[i].tc != 0){
						content.find("div").append("<div class='list_r_info'><ul></ul></div>");
					}

					content.find(".al_title").text(data.content[i].orgLangPprNm);    //논문 명
					content.find(".al_title").attr("href","${pageContext.request.contextPath}/share/article/articleDetail.do?id="+data.content[i].articleId);    //세부정보로 이동

					(data.content[i].tc != null && data.content[i].tc != 0 ? content.find(".list_r_info ul").append('<li>SCI<span>'+data.content[i].tc+'</span></li>') : "");      // WOS 피인용 횟수
					(data.content[i].scpTc != null && data.content[i].scpTc != 0 ? content.find(".list_r_info ul").append('<li class="l_scopus">SCOPUS<span>'+data.content[i].scpTc+'</span></li>') : "");      //SCOPUS 피인용 횟수
					(data.content[i].kciTc != null && data.content[i].kciTc != 0 ? content.find(".list_r_info ul").append('<li class="l_kci">KCI<span>'+data.content[i].kciTc+'</span></li>') : "");      //KCI 피인용 횟수

					content.find("p").html(data.content[i].content);  //간략 내용

					if(data.content[i].keywordList.length != 0){
						var keyArr = data.content[i].keywordList;

						content.append('<div class="l_keyword_box"></div>');
						content.find(".l_keyword_box").append("<span>Keywords</span>");
						//키워드
						for(var j=0; j<keyArr.length; j++){
							content.find(".l_keyword_box").append('<a href="javascript:searchAll(\''+keyArr[j].trim()+'\');">'+ keyArr[j].trim() + '</a>');
						}
					}
					//알트메트릭 로고
					if(data.content[i].doi != null){
						content.find(".al_title").before('<div data-badge-popover="bottom" data-link-target="_blank" style="float:right;" data-badge-type="donut" data-doi="'+data.content[i].doi+'" data-hide-no-mentions="true" class="altmetric-embed"></div>');
					}
				}else if(tabId == "funding"){
					$("#memo").text("<spring:message code='disc.notice.government'/>");
					content.find(".al_title").text(data.content[i].rschSbjtNm);    //연구과제명
					content.find(".al_title").attr("href","${pageContext.request.contextPath}/share/funding/fundingDetail.do?id="+data.content[i].fundingId);    //세부정보로 이동

					content.find("p").html(data.content[i].content);  //간략 내용

					if(data.content[i].engKeywordList.length != 0){
						var keyArr = data.content[i].engKeywordList;

						content.append('<div class="l_keyword_box"></div>');
						content.find(".l_keyword_box").append("<span>Keywords</span>");
						//키워드
						for(var j=0; j<keyArr.length; j++){
							content.find(".l_keyword_box").append('<a href="javascript:searchAll(\''+keyArr[j].trim()+'\');">'+ keyArr[j].trim() + '</a>');
						}
					}
				}else if(tabId == "patent"){
					$("#memo").text("<spring:message code='disc.notice.patent'/>");
					content.find(".al_title").text(data.content[i].itlPprRgtNm);    //지식재산권명
					content.find(".al_title").attr("href","${pageContext.request.contextPath}/share/patent/patentDetail.do?id="+data.content[i].patentId);    //세부정보로 이동
					content.find("p").html(data.content[i].content);  //간략 내용
				}else if(tabId == "conference"){
					$("#memo").text("<spring:message code='disc.notice.conferences'/>");

					content.find(".al_title").text(data.content[i].orgLangPprNm);    //논문명
					content.find(".al_title").attr("href","${pageContext.request.contextPath}/share/conference/conferenceDetail.do?id="+data.content[i].conferenceId);    //세부정보로 이동

					content.find("p").html(data.content[i].content);  //간략 내용

					if(data.content[i].keywordList.length != 0){
						var keyArr = data.content[i].keywordList;

						content.append('<div class="l_keyword_box"></div>');
						content.find(".l_keyword_box").append("<span>Keywords</span>");
						//키워드
						for(var j=0; j<keyArr.length; j++){
							content.find(".l_keyword_box").append('<a href="javascript:searchAll(\''+keyArr[j].trim()+'\');">'+ keyArr[j].trim() + '</a>');
						}
					}

					//알트메트릭 로고
					if(data.content[i].doi != null){
						content.find(".al_title").before('<div data-badge-popover="bottom" data-link-target="_blank" style="float:right;" data-badge-type="donut" data-doi="'+data.content[i].doi+'" data-hide-no-mentions="true" class="altmetric-embed"></div>');
					}
				}

				$(".paging_nav").before(content);
			}

			$(".willBeDeleted").remove();

			var span = 1;

			//페이징
			for(var i=0; i<data.pageList.length; i++){
					//처음, 다음, 이전, 이후 페이지
					if(data.pageList[i].classNm != null) {

						$(".paging_nav").append(" <a class='page_select "+data.pageList[i].classNm+"' href='javascript:makeContents(\""+tabId+"\",\""+data.pageList[i].page+"\")'></a> ");

					}else{
						//페이지 숫자표기
						if(span != 0){
							$(".paging_nav").append(" <span></span> ");
							span--;
						}

						if(page.toString() == data.pageList[i].page){
							$(".paging_nav span").append(" <strong>"+data.pageList[i].page+"</strong>");
						}else{
							$(".paging_nav span").append(" <a href='javascript:makeContents(\""+tabId+"\",\""+data.pageList[i].page+"\")'>"+data.pageList[i].page+"</a>");
						}
					}
			}
			//페이지 이동 or 탭 이동 후 스크롤 위치 (브라우저별)

			if(temp == 0){
				$(window).scrollTop($(".tab_wrap.w_25").offset().top-10);
			}else{
				temp--;
			}

            _altmetric_embed_init(); //알트메트릭 로고 표시
		});
	}

	//sort a태그 클릭시
	function sortTab(inSortNm){
		if(sort == inSortNm){
			if(order == "desc"){
				order = "asc";
			}else{
				order = "desc";
			}
		}else{
			sort = inSortNm;

			if(inSortNm == "date")  order = "desc";
			if(inSortNm == "title")  order = "asc";
			if(inSortNm == "tc")  order = "desc";
		}


		var tabId = $(".tab_wrap .on").attr("id");
		makeContents(tabId,"1");
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

function PlusBtn(targetClass){
		if($("."+targetClass).hasClass("hidden")){
			//부호 + -> -
			if(targetClass == "coResearch"){
				$(".network_lbox .rl_more").attr("class","rl_minus");
			}else{
				$(".network_rbox .rl_more").attr("class","rl_minus");
			}
			$("."+targetClass).removeClass("hidden");
		}else{
			//부호 - -> +
			if(targetClass == "coResearch"){
				$(".network_lbox .rl_minus").attr("class","rl_more");
			}else{
				$(".network_rbox .rl_minus").attr("class","rl_more");
			}
			$("."+targetClass).addClass("hidden");
		}
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

function coAuthorNetworkWithInstView(encptUserId, type){
	$('.modal-body').empty();
	$('.modal-title').text('<spring:message code="disc.detail.user.network"/>');

	var instChartOpt = $.extend(true, {}, chartOpt);
	$("#dialog").modal('show');

	$.ajax({
		url : 'findCoAuthorWithInstChartAjax.do',
		dataType : 'json',
		data : {'encptUserId' : encptUserId}
	}).done(function(data){
		instChartOpt.dataSource['dataset'] = data.dataset;
		instChartOpt.dataSource['connectors'] = data.connectors;
		instChartOpt.dataSource['styles'] = data.styles;

		new FusionCharts(instChartOpt).render();
	});
}

</script>
</head>
<body>
	<div class="sub_container">
		<a href="javascript:history.go(-1);" class="prev_bt" style="float:right;"><spring:message code="disc.anls.toprf.article.prev"/></a>
		<h3 class="h3_title"><spring:message code="disc.detail.user.title"/></h3>
		<div class="researcher_view_wrap">
			<div class="pic_box">
				<span>
					<c:if test="${userDetail.profPhotoFileId != null}">
						<img src="${contextPath}/rss/servlet/image/profile.do?fileid=<c:out value="${userDetail.profPhotoFileId}"/>" height="164" width="130"/>
					</c:if>
					<c:if test="${userDetail.profPhotoFileId == null}">
						<img src="<c:url value="/share/img/common/researcher_none_img.jpg"/>"/>
					</c:if>
				</span>
			</div>
			<div class="researcher_info">
				<div class="ri_box">
					<div class="r_name">
						<c:out value='${userDetail.engNm}' /><em>(<c:out value='${userDetail.korNm}' />)</em>
					</div>
					<c:set value='${userDetail.posiNm == "교수" ? "Professor" :userDetail.posiNm == "조교수" ? "Assistant Professor" :userDetail.posiNm == "부교수" ? "Associate Professor" :"" }' var="engPosiNm"/>
					<span class="r_t02"><c:out value='${language eq "en" ? engPosiNm : userDetail.posiNm}'/>, <c:out value='${language eq "en" ? userDetail.deptEng : userDetail.deptKor}'/></span>
					<div class="ri_type_box" style="background:white;">
						<a <c:if test="${userDetail.rid != null}">href="http://www.researcherid.com/rid/${userDetail.rid}"</c:if> class="rid_type${userDetail.rid != null ? '_on' : ''}" target="_blank" >rid</a>
						<a <c:if test="${userDetail.scpid != null}">href="https://www.scopus.com/authid/detail.uri?authorId=${userDetail.scpid}"</c:if> class="si_type${userDetail.scpid != null ? '_on' : ''}" target="_blank">scopus</a>
						<a <c:if test="${userDetail.orcid != null}">href="http://orcid.org/${userDetail.orcid}"</c:if> class="id_type${userDetail.orcid != null ? '_on' : ''}" target="_blank">orcid</a>
						<a <c:if test="${userDetail.rgtid != null}">href="https://www.researchgate.net/profile/${userDetail.rgtid}"</c:if> class="rg_type${userDetail.rgtid != null ? '_on' : ''}" target="_blank">research gate</a>
						<a <c:if test="${userDetail.grdId != null}">href="https://scholar.google.com/citations?user=${userDetail.grdId}"</c:if> class="gi_type${userDetail.grdId != null ? '_on' : ''}" target="_blank">google</a>
					</div>
				</div>
				<div class="ri_bottom_box">
					<div class="row">
						<div class="col-md-4 col-sm-12">
							<dl class="ri_dl">
								<dt><spring:message code="disc.detail.user.telephone"/></dt>
								<c:if test="${userDetail.ofcTelno != null}">
									<dd class="r_phone_icon"><c:out value='${userDetail.ofcTelno}' /></dd>
								</c:if>
							</dl>
						</div>
						<c:if test="${userDetail.emalAddr != null}">
							<div class="col-md-4 col-sm-12">
								<dl class="ri_dl r_mail_icon">
									<dt><spring:message code="disc.detail.user.email"/></dt>
									<dd><c:out value='${userDetail.emalAddr}' /></dd>
								</dl>
							</div>
						</c:if>
						<c:if test="${userDetail.homePageAddr != null}">
							<div class="col-md-4 col-sm-12">
								<p class="r_web_icon"><a href="<c:out value='${userDetail.homePageAddr}' />" target="_blank"><spring:message code="disc.detail.user.website"/></a></p>
							</div>
						</c:if>

						<div class="col-sm-12">
							<div class="r_info_t">
								<dl class="ri_dl r_area_dl">
									<dt class="r_area_icon"><spring:message code="disc.detail.user.research.area"/></dt>
									<c:if test="${not empty userDetail.majorKorList}">
										<dd>
											<c:forEach items="${userDetail.majorKorList}" var="major" varStatus="stat">
												<a href="javascript:searchAll('<c:out value="${major}"/>');" >
													<c:if test="${major == ''}">

													</c:if>

													<c:if test="${major != ''}">
														<c:choose>
															<c:when test="${stat.last}">
																<c:out value='${major}'/>
															</c:when>
															<c:otherwise>
																<c:out value='${major} ;'/>
															</c:otherwise>
														</c:choose>
													</c:if>
												</a>
											</c:forEach>
										</dd>
									</c:if>
									<c:if test="${not empty userDetail.majorEngList}">
										<dd>
											<c:forEach items="${userDetail.majorEngList}" var="major" varStatus="stat">
												<a href="javascript:searchAll('<c:out value="${major}"/>');" >
													<c:if test="${major == ''}">

													</c:if>

													<c:if test="${major != ''}">
														<c:choose>
															<c:when test="${stat.last}">
																<c:out value='${major}'/>
															</c:when>
															<c:otherwise>
																<c:out value='${major} ;'/>
															</c:otherwise>
														</c:choose>
													</c:if>
												</a>
											</c:forEach>
										</dd>
									</c:if>
								</dl>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div><!-- researcher_view_wrap:  e-->
	
		<div class="network_info_wrap">
			<div class="nb_type network_lbox">
				<h5><spring:message code="disc.detail.user.researchers.co"/><a ${fn:length(coAuthorList) > 0 ? 'href=\"javascript:coAuthorNetworkWithInstView(\'':''}${fn:length(coAuthorList) > 0 ? userDetail.encptUserId:''}${fn:length(coAuthorList) > 0 ? '\',\'in\');\"':''} class="coa_bt"><c:out value='${fn:length(coAuthorList)}'/></a></h5>
				<div class="rl_box">
					<ul>
						<c:forEach items="${coAuthorList}" var="coAuthor" varStatus="stat">
							<li class="${stat.index <= 4 ? "" : "coResearch hidden"}">
								<form action="userDetail.do" method="get">
									<input type="hidden" name="id" value="<c:out value="${coAuthor.encptUserId}"/>">
										<a href="#" onclick="$(this).closest('form').submit()" title="<c:out value='${language eq "en"? coAuthor.engNm : coAuthor.korNm}'/> (<c:out value='${language eq "en"? coAuthor.deptEng : coAuthor.deptKor}'/>)">
											<span class="researcher_img ${coAuthor.profPhotoFileId == null ? 'none_img' : ''}">
												<c:if test="${coAuthor.profPhotoFileId != null}">
													<img src="${contextPath}/rss/servlet/image/profile.do?fileid=<c:out value="${coAuthor.profPhotoFileId}"/>"/>
												</c:if>
											</span>
										</a>
								</form>
							</li>
						</c:forEach>
						<c:if test='${fn:length(coAuthorList) > 5}'>
							<li><a href="javascript:PlusBtn('coResearch');" class="rl_more">more</a></li>
						</c:if>
					</ul>
				</div>
				<a class="nt_link"><c:out value='${fn:length(coAuthorList)}'/></a>
			</div>
			<div class="nb_type network_rbox">
				<h5><spring:message code="disc.detail.user.researchers.similar"/></h5>
				<div class="rl_box">
					<ul>
						<c:forEach items="${similarList}" var="similar" varStatus="stat">
							<li class="${stat.index <= 4 ? "" : "simResearch hidden"}">
								<form action="userDetail.do" method="get">
									<input type="hidden" name="id" value="<c:out value="${similar.encptUserId}"/>">
									<a href="#" onclick="$(this).closest('form').submit()" title="<c:out value='${language eq "en"? similar.engNm : similar.korNm}'/> (<c:out value='${language eq "en"? similar.deptEng : similar.deptKor}'/>)">
										<span class="researcher_img ${similar.profPhotoFileId == null ? 'none_img' : ''}">
											<c:if test="${similar.profPhotoFileId != null}">
												<img src="${contextPath}/rss/servlet/image/profile.do?fileid=<c:out value="${similar.profPhotoFileId}"/>"/>
											</c:if>
										</span>
									</a>
								</form>
							</li>
						</c:forEach>
						<c:if test='${fn:length(similarList) > 5}'>
							<li><a href="javascript:PlusBtn('simResearch');" class="rl_more">more</a></li>
						</c:if>
					</ul>
				</div>
				<a class="nt_link"><c:out value='${fn:length(similarList)}'/></a>
			</div>
		</div>
		<div class="view_keyword_wrap" style="margin-bottom: 50px;">
			<c:if test="${fn:length(keywordList) > 0}">
				<h4 class="keyword_bullet"><spring:message code="disc.detail.user.author.keyword"/></h4>
				<div>
					<c:set var="textLen" value="0"/>
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
							${keywod.name}
						</c:if>
					</c:forEach>
				</div>
			</c:if>
		</div>
		<div class="tab_wrap w_25">
			<ul>
				<li><a id="journal" href="javascript:tabClick('journal')" class="on"><spring:message code="disc.tab.journal"/></a></li>
				<li><a id="funding" href="javascript:tabClick('funding')"><spring:message code="disc.tab.research"/></a></li>
				<li><a id="patent" href="javascript:tabClick('patent')"><spring:message code="disc.tab.patent"/></a></li>
				<li><a id="conference" href="javascript:tabClick('conference')"><spring:message code="disc.tab.conference"/></a></li>
			</ul>
		</div>
		<div class="list_top_box">
			<h3></h3>
			<p class="page_num_box"></p><span id="memo" style='font-weight:bold;color:red;padding-left: 10px;'></span>
			<div class="list_sort_box">
				<ul>
					<li><i><span style="padding-right: 30px;"><spring:message code="disc.sort.sort"/></span></i><a id="date" href="javascript:sortTab('date');" style="display: inline;"><span><spring:message code="disc.sort.date"/></span><em>정렬</em></a></li>
					<li><a id="tc" href="javascript:sortTab('tc');"><span><spring:message code="disc.sort.citation"/></span><em>정렬</em></a></li>
					<li><a id="title" href="javascript:sortTab('title');"><span><spring:message code="disc.sort.title"/></span><em>정렬</em></a></li>
				</ul>
			</div>
		</div>
		<div class="paging_nav"></div>
	</div><!-- sub_container : e -->

	<!-- 복사해서 쓸 탭 내용 및 페이징 -->
	<div class="article_list_box hidden">
		<div>
			<a class="al_title" target="_self"></a>
			<p></p>
		</div>
	</div>

    <!-- Modal -->
    <div class="modal fade" id="dialog" tabindex="-1" role="dialog" aria-labelledby="exampleModalLongTitle" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content" style="width: 800px; height: 670px">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h5 class="modal-title"></h5>
                </div>
                <div class="modal-body" id="modalBody">
                </div>
            </div>
        </div>
    </div>
</body>