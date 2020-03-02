<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<head>
	<title>${language == 'en'?'Research project' : '연구비'}</title>
	<%@include file="../pageInit.jsp" %>
    <%--<style>
        .simple_info_type .view_dl  dd {margin: 0 0 0 310px;}
    </style>--%>
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
                }
            });

            if(${fn:length(resultMap.articleVoList)+fn:length(resultMap.fundingVoList)+fn:length(resultMap.patentVoList)+fn:length(resultMap.conferenceVoList)} > 0){
                $("#tabs a").eq(0).addClass("on");
            }

        });
	</script>
</head>
<body>
<div class="sub_container">
	<a href="javascript:history.go(-1);" class="prev_bt" style="float:right;"><spring:message code="disc.anls.toprf.article.prev"/></a>
	<p class="view_title" style="color:#2d52b1; font-weight: bold;"><c:out value="${resultMap.fundingVo.rschSbjtNm}"/></p>

	<div class="view_info_wrap mgb_40"><!--이미지 있을때는 view_add_img가 생김  -->
		<div class="vi_left_box simple_info_type">
			<dl class="view_dl">
				<dt><spring:message code="disc.detail.funding.government"/></dt>
				<c:if test="${resultMap.fundingVo.cptGovOfficNm != null }">
					<dd><c:out value="${resultMap.fundingVo.cptGovOfficNm}"/></dd>
				</c:if>
			</dl>
			<dl class="view_dl">
				<dt><spring:message code="disc.detail.funding.funding"/></dt>
				<c:if test="${resultMap.fundingVo.rsrcctSpptAgcNm != null }">
					<dd><c:out value="${resultMap.fundingVo.rsrcctSpptAgcNm}"/></dd>
				</c:if>
			</dl>
			<dl class="view_dl">
				<dt><spring:message code="disc.detail.funding.supporting"/></dt>
				<c:if test="${resultMap.fundingVo.bizNm != null }">
					<dd><c:out value="${resultMap.fundingVo.bizNm}"/></dd>
				</c:if>
			</dl>
			<dl class="view_dl">
				<dt><spring:message code="disc.detail.funding.research"/></dt>
				<c:if test="${resultMap.fundingVo.korNm != null}">
					<dd><c:out value="${resultMap.fundingVo.korNm}"/></dd>
				</c:if>
			</dl>
			<dl class="view_dl">
				<dt><spring:message code="disc.detail.funding.period"/></dt>
				<c:if test="${resultMap.fundingVo.rschYm != null }">
					<dd><c:out value="${resultMap.fundingVo.rschYm}"/></dd>
				</c:if>
			</dl>
			<c:if test="${resultMap.fundingVo.agcSbjtNo != null }">
				<dl class="view_dl">
					<dt><spring:message code="disc.detail.funding.projec.kaist"/></dt>
					<dd> <c:out value="${resultMap.fundingVo.agcSbjtNo}"/></dd>
				</dl>
			</c:if>
			<dl class="view_dl">
				<dt><spring:message code="disc.detail.funding.projec.agency"/></dt>
				<c:if test="${resultMap.fundingVo.sbjtNo != null }">
					<dd> <c:out value="${resultMap.fundingVo.sbjtNo}"/></dd>
				</c:if>
			</dl>
			<dl class="view_dl">
				<dt><spring:message code="disc.detail.funding.keywords.eng"/></dt>
				<c:if test="${fn:length(resultMap.fundingVo.engKeywordList) > 0}">
					<dd class="keyword_dd">
						<c:forEach var="item" items="${resultMap.fundingVo.engKeywordList}">
							<span><a href="javascript:searchAll('<c:out value="${fn:trim(item)}"/>');"><c:out value="${fn:trim(item)}"/></a></span>
						</c:forEach>
					</dd>
				</c:if>
			</dl>
			<dl class="view_dl">
				<dt><spring:message code="disc.detail.funding.keywords.kor"/></dt>
				<c:if test="${fn:length(resultMap.fundingVo.korKeywordList) > 0}">
					<dd class="keyword_dd">
						<c:forEach var="item" items="${resultMap.fundingVo.korKeywordList}">
							<span><a href="javascript:searchAll('<c:out value="${fn:trim(item)}"/>');"><c:out value="${fn:trim(item)}"/></a></span>
						</c:forEach>
					</dd>
				</c:if>
			</dl>
			<!-- 관련 성과 -->
			<c:if test="${fn:length(resultMap.articleVoList)+fn:length(resultMap.patentVoList)+fn:length(resultMap.conferenceVoList) > 0}">
				<div id="tabs" style=" border-top: 1px dashed #ddd; padding-top: 20px; margin-top: 26px; ">
					<div class="tab_wrap w_25">
						<ul>
							<c:if test="${fn:length(resultMap.articleVoList) > 0}">
								<li id="tab1"><a href="#tabs-1"><spring:message code="disc.tab.related.journal"/></a></li>
							</c:if>
							<c:if test="${fn:length(resultMap.patentVoList) > 0}">
								<li id="tab2"><a href="#tabs-2"><spring:message code="disc.tab.related.patent"/></a></li>
							</c:if>
							<c:if test="${fn:length(resultMap.conferenceVoList) > 0}">
								<li id="tab3"><a href="#tabs-3"><spring:message code="disc.tab.related.conference"/></a></li>
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
					<c:if test="${fn:length(resultMap.patentVoList) > 0}">
						<div id="tabs-2">
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
						<div id="tabs-3">
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
</div>
<!-- sub_container : e -->
</body>