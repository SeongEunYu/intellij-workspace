<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<head>
	<title>${language == 'en'?'Patent' : '특허'}</title>
	<%@include file="../pageInit.jsp" %>
	<script type="text/javascript">

        $(function(){$("#toTop").scrollToTop({speed:1000,ease:"easeOutBack",start:200})});
        <!--start 스크롤 300px 내려오면 top버튼 나타남 0이면 항상 나타남  -->

        $(function () {
            //대메뉴 형광색 들어오게하기
            $("#bigOutput").addClass("on");

            $( "#tabs" ).tabs({
                active: '0',
                activate: function( event, ui ) {
                    $("#tabs li a").removeClass("on");

                    if(ui.newPanel.is('#tabs-1')){
                        $("#tab1").focus();
                        $('#tab1 a').addClass("on");
                    }
                    if(ui.newPanel.is('#tabs-2')){
                        $("#tab2").focus();
                        $('#tab2 a').addClass("on");
                    }
                    if(ui.newPanel.is('#tabs-3')){
                        $("#tab3").focus();
                        $('#tab3 a').addClass("on");
                    }
                    if(ui.newPanel.is('#tabs-4')){
                        $("#tab4").focus();
                        $('#tab4 a').addClass("on");
                    }
                }
            });

            if(${fn:length(resultMap.articleVoList)+fn:length(resultMap.fundingVoList)+fn:length(resultMap.patentVoList)+fn:length(resultMap.conferenceVoList)} > 0){
                $("#tabs a").eq(0).addClass("on");
            }

			checkFavorite("${resultMap.patentVo.patentId}")
        });

		function editFavorite(){
			var ajaxURL = "${pageContext.request.contextPath}/editFavorite.do";
			var svcgrp = "VPAT";
			var type = "";
			if($(".favorite_star").hasClass("star_fill")){
				type = "remove";
			} else {
				type = "add";
			}
			var itemId = "${resultMap.patentVo.patentId}";
			var url = "${requestScope["javax.servlet.forward.request_uri"]}" + "?id=" + itemId;

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

			var svcgrp = "VPAT";

			$.ajax({
				url: "${pageContext.request.contextPath}/checkFavorite.do",
				method: "GET",
				data: {itemId : itemId, svcgrp : svcgrp}
			}).done(function(data){

				var starCode = "";
				if(data){
					starCode = "<span class='favorite_star star_fill' onclick='editFavorite();' style='top:5px;'></span>";
				} else {
					starCode = "<span class='favorite_star star_empty' onclick='editFavorite();' style='top:5px;'></span>";
				}

				$(".view_title").append(starCode);
			});
		}

	</script>
</head>
<body>
<div class="sub_container">
	<a href="javascript:history.go(-1);" class="prev_bt" style="float:right;"><spring:message code="disc.anls.toprf.article.prev"/></a>
	<p class="view_title" style="color:#2d52b1; font-weight: bold;">${resultMap.patentVo.itlPprRgtNm}</p>
	<dl class="abstract_box">
		<dt><spring:message code="disc.detail.patent.abstract"/></dt>
		<c:if test="${resultMap.patentVo.smmrCntn == null }">
			<dd><p style="text-align: justify"><spring:message code="disc.display.nodata"/></p></dd>
		</c:if>
		<c:if test="${resultMap.patentVo.smmrCntn != null }">
			<dd><p style="text-align: justify"><c:out value="${resultMap.patentVo.smmrCntn}"/></p></dd>
		</c:if>
	</dl>
	<div class="view_info_wrap view_add_img">
		<div class="vi_left_box simple_info_type">
			<dl class="view_dl">
				<dt><spring:message code="disc.detail.patent.other.language"/></dt>
				<c:if test="${resultMap.patentVo.diffItlPprRgtNm != null }">
					<dd><c:out value="${resultMap.patentVo.diffItlPprRgtNm}"/></dd>
				</c:if>
			</dl>
			<dl class="view_dl">
				<dt><spring:message code="disc.detail.patent.application.number"/></dt>
				<c:if test="${resultMap.patentVo.applRegNo != null }">
					<dd><c:out value="${resultMap.patentVo.applRegNo}"/></dd>
				</c:if>
			</dl>
			<dl class="view_dl">
				<dt><spring:message code="disc.detail.patent.application.date"/></dt>
				<c:if test="${resultMap.patentVo.applRegDay != null }">
					<dd><c:out value="${resultMap.patentVo.applRegDay}"/></dd>
				</c:if>
			</dl>
			<dl class="view_dl">
				<dt><spring:message code="disc.detail.patent.registration.number"/></dt>
				<c:if test="${resultMap.patentVo.itlPprRgtRegNo != null }">
					<dd><c:out value="${resultMap.patentVo.itlPprRgtRegNo}"/></dd>
				</c:if>
			</dl>
			<dl class="view_dl">
				<dt><spring:message code="disc.detail.patent.registration.date"/></dt>
				<c:if test="${resultMap.patentVo.itlPprRgtRegDay != null }">
					<dd><c:out value="${resultMap.patentVo.itlPprRgtRegDay}"/></dd>
				</c:if>
			</dl>
			<dl class="view_dl">
				<dt><spring:message code="disc.detail.patent.inventor"/></dt>
				<c:if test="${resultMap.patentVo.invtNm != null }">
					<dd><c:out value="${fn:replace(resultMap.patentVo.invtNm,',',', ')}"/></dd>
				</c:if>
			</dl>
			<dl class="view_dl">
				<dt><spring:message code="disc.detail.patent.application.country"/></dt>
				<c:if test="${language == 'en' ? (resultMap.patentVo.applRegNtnEngNm != null) : (resultMap.patentVo.applRegNtnNm != null)}">
					<dd><c:out value="${language == 'en' ? resultMap.patentVo.applRegNtnEngNm  : resultMap.patentVo.applRegNtnNm}"/></dd>
				</c:if>
			</dl>
			<dl class="view_dl">
				<dt><spring:message code="disc.detail.patent.ipc"/></dt>
				<c:if test="${resultMap.patentVo.ipc != null && fn:trim(resultMap.patentVo.ipc) != ','}">
					<c:if test="${language == 'en'}">
						<dd><c:out value="${resultMap.patentVo.ipcEngNm != null ? resultMap.patentVo.ipcEngNm : resultMap.patentVo.ipcKorNm}"/></dd>
					</c:if>
					<c:if test="${language != 'en'}">
						<dd><c:out value="${resultMap.patentVo.ipcKorNm}"/></dd>
					</c:if>
				</c:if>
			</dl>
		</div>

		<div class="view_img_box">
			<c:if test="${resultMap.patentVo.applRegNtnCd == 'KO'}">
				<!--h3><spring:message code="disc.detail.patent.drawing"/></h3-->
				<span><img src="http://kpat.kipris.or.kr/kpat/remoteFile.do?PIsearchFg=PISearch&method=bigFrontDraw&numPerPage=30&openPageId=View01&applno=${fn:replace(resultMap.patentVo.applRegNo,'-','')}" /></span>
				<div class="view_img_bt">
					<ul>
						<li><a href="http://kpat.kipris.or.kr/kpat/biblio/biblioFrontDrawPop.jsp?applno=${fn:replace(resultMap.patentVo.applRegNo,'-','')}" target="_blank"><em><spring:message code="disc.detail.patent.enlarge"/></em></a></li>
					</ul>
				</div>
			</c:if>
			<c:if test="${resultMap.patentVo.applRegNtnCd == 'US'}">

			</c:if>
		</div>
	</div>
	<div class="view_info_wrap mgb_40">
	<!-- 관련 성과 -->
		<c:if test="${fn:length(resultMap.articleVoList)+fn:length(resultMap.fundingVoList)+fn:length(resultMap.patentVoList)+fn:length(resultMap.conferenceVoList) > 0}">
			<div id="tabs" style=" border-top: 1px dashed #ddd; padding-top: 20px; margin-top: 26px; ">
				<div class="tab_wrap w_25">
					<ul>
						<c:if test="${fn:length(resultMap.articleVoList) > 0}">
							<li id="tab1"><a href="#tabs-1"><spring:message code="disc.tab.related.journal"/></a></li>
						</c:if>
						<c:if test="${fn:length(resultMap.fundingVoList) > 0}">
							<li id="tab2"><a href="#tabs-2"><spring:message code="disc.tab.related.research"/></a></li>
						</c:if>
						<c:if test="${fn:length(resultMap.patentVoList) > 0}">
							<li id="tab3"><a href="#tabs-3"><spring:message code="disc.tab.related.patent"/></a></li>
						</c:if>
						<c:if test="${fn:length(resultMap.conferenceVoList) > 0}">
							<li id="tab4"><a href="#tabs-4"><spring:message code="disc.tab.related.conference"/></a></li>
						</c:if>
					</ul>
				</div>
				<c:if test="${fn:length(resultMap.articleVoList) > 0}">
					<div id="tabs-1">
						<c:forEach items="${resultMap.articleVoList}" var="article">
							<div class="article_list_box">
								<div class="alb_text_box">
									<a href="${pageContext.request.contextPath}/share/article/articleDetail.do?id=${article.articleId}" class="al_title">${article.orgLangPprNm}</a>
									<p>${article.content}</p>
									<c:if test="${article.kciTc+article.scpTc+article.tc != 0}">
										<div class='list_r_info'>
											<ul>
												<c:if test="${article.tc != null && article.tc != 0}"><li>SCI<span><c:out value="${article.tc}"></c:out></span></li></c:if>
												<c:if test="${article.scpTc != null && article.scpTc != 0}"><li class="l_scopus">SCOPUS<span><c:out value="${article.scpTc}"></c:out></span></li></c:if>
												<c:if test="${article.kciTc != null && article.kciTc != 0}"><li class="l_kci">KCI<span><c:out value="${article.kciTc}"></c:out></span></li></c:if>
											</ul>
										</div>
									</c:if>
								</div>
								<c:if test="${fn:length(article.keywordList) != 0}">
									<div class="l_keyword_box">
										<span>Keywords</span>
										<c:forEach var="item" items="${article.keywordList}">
											<a href="javascript:searchAll('<c:out value="${fn:trim(item)}"/>');"><c:out value="${fn:trim(item)}"/></a>
										</c:forEach>
									</div>
								</c:if>
							</div>
						</c:forEach>
					</div>
				</c:if>
				<c:if test="${fn:length(resultMap.fundingVoList) > 0}">
					<div id="tabs-2">
						<c:forEach items="${resultMap.fundingVoList}" var="fundingVo">
							<div class="article_list_box">
								<div class="alb_text_box">
									<a href="${pageContext.request.contextPath}/share/funding/fundingDetail.do?id=${fundingVo.fundingId}" class="al_title">${fundingVo.rschSbjtNm}</a>
									<p>${fundingVo.content}</p>
								</div>
								<c:if test="${fn:length(funding.engKeywordList) != 0}">
									<div class="l_keyword_box">
										<span>Keywords</span>
										<c:forEach var="item" items="${funding.engKeywordList}">
											<a href="javascript:searchAll('<c:out value="${fn:trim(item)}"/>');"><c:out value="${fn:trim(item)}"/></a>
										</c:forEach>
									</div>
								</c:if>
							</div>
						</c:forEach>
					</div>
				</c:if>
				<c:if test="${fn:length(resultMap.patentVoList) > 0}">
					<div id="tabs-3">
						<c:forEach items="${resultMap.patentVoList}" var="patentVo">
							<div class="article_list_box">
								<div class="alb_text_box">
									<a href="${pageContext.request.contextPath}/share/patent/patentDetail.do?id=${patentVo.patentId}" class="al_title">${patentVo.itlPprRgtNm}</a>
									<p>${patentVo.content}</p>
								</div>
							</div>
						</c:forEach>
					</div>
				</c:if>
				<c:if test="${fn:length(resultMap.conferenceVoList) > 0}">
					<div id="tabs-4">
						<c:forEach items="${resultMap.conferenceVoList}" var="conferenceVo">
							<div class="article_list_box">
								<div class="alb_text_box">
									<div data-badge-popover="right" data-link-target='_blank' style="float:right;" data-badge-type="donut" data-doi="<c:out value='${conferenceVo.doi}'/>" data-hide-no-mentions="true" class="altmetric-embed"></div>
									<a href="${pageContext.request.contextPath}/share/conference/conferenceDetail.do?id=${conferenceVo.conferenceId}" class="al_title">${conferenceVo.orgLangPprNm}</a>
									<p>${conferenceVo.content}</p>
								</div>
								<c:if test="${fn:length(conference.keywordList) != 0}">
									<div class="l_keyword_box">
										<span>Keywords</span>
										<c:forEach var="item" items="${conference.keywordList}">
											<a href="javascript:searchAll('<c:out value="${fn:trim(item)}"/>');"><c:out value="${fn:trim(item)}"/></a>
										</c:forEach>
									</div>
								</c:if>
							</div>
						</c:forEach>
					</div>
				</c:if>
			</div>
		</c:if>
	</div>
</div>


<a id="toTop" href="#">상단으로 이동</a>
<!-- sub_container : e -->
</body>