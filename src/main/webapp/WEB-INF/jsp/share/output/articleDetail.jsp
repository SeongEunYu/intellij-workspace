<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<head>
<%@include file="../pageInit.jsp" %>
<title>${language == 'en'?'Article' : '논문'}</title>
<style>
	.view_dl  dd {margin: 0 0 0 220px;}
</style>
<link rel="stylesheet" type="text/css" href="<c:url value="/share/css/mquery.css"/>" />
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

		if( "${resultMap.articleVo.impctFctr}" != "" ){
			var chartOpt = {
				id: 'IFChart',
				type:'column2d',
				renderAt:'chartdiv1',
				width:'70%',
				height:'350',
				dataSource:{
					chart: {
						caption: '<spring:message code="disc.detail.article.chart.if.trend"/>',
						subCaption: '(<spring:message code="disc.detail.article.chart.journal"/> : ${resultMap.articleVo.scjnlNm})',
						baseFontSize: '13',
						toolTipColor: '#ffffff',
						toolTipBorderColor: '#ffffff',
						toolTipBorderThickness: '1',
						toolTipBgColor: '#000000',
						toolTipBgAlpha: '80',
						toolTipBorderRadius: '4',
						toolTipPadding: '10',
						toolTipFontSize : '20',
						xAxisName: '<spring:message code="disc.detail.article.chart.year"/>',
						yAxisName: '<spring:message code="disc.detail.article.chart.if"/>',
						paletteColors: '#0075c2',
						showBorder : '0',
						bgColor: '#ffffff',
						borderAlpha: '20',
						canvasBorderAlpha: '0',
						usePlotGradientColor: '0',
						plotBorderAlpha: '10',
						placevaluesInside: '1',
						rotatevalues: '1',
						valueFontColor: '#ffffff',
						showXAxisLine: '1',
						xAxisLineColor: '#999999',
						divlineColor: '#999999',
						divLineIsDashed: '1',
						showAlternateHGridColor: '0',
						subcaptionFontBold: '0',
						subcaptionFontSize: '14'
					}
				}
			};

			chartOpt.dataSource['data'] = ${dataset.data};
			new FusionCharts(chartOpt).render();
		}
    });

	function goUserDetail(idx) {
		$("#id").val($("#id"+idx).val());
		$("#frm").submit();
	}
</script>
</head>
<body>
<div class="sub_container">
	<div style="margin-bottom: 50px;">
		<a href="javascript:history.go(-1);" class="prev_bt" style="float:right;"><spring:message code="disc.anls.toprf.article.prev"/></a>
	</div>
	<div class="view_top_box">
		<div class="view_bt_box">
			<span class="cited_span science_span"><spring:message code="disc.detail.article.cited"/> <em><c:out value="${empty resultMap.articleVo.tc ? 0 : resultMap.articleVo.tc}"/></em> <spring:message code="disc.detail.article.times"/> <img src="<c:url value="/share/img/common/webofscience.png"/>" alt="webofscience">
				<c:if test="${!empty resultMap.articleVo.wosSourceUrl}">
					<a class="view_bt_box_a" href="<c:out value='${resultMap.articleVo.wosSourceUrl}'/>" target="_blank" title="link to WOS">WOS link</a>
				</c:if>
			</span>
			<span class="cited_span"><spring:message code="disc.detail.article.cited"/> <em><c:out value="${empty resultMap.articleVo.scpTc ? 0 : resultMap.articleVo.scpTc}"/></em> <spring:message code="disc.detail.article.times"/> <img src="<c:url value="/share/img/common/scopus.png"/>" alt="scopus">
				<c:if test="${!empty resultMap.articleVo.idScopus}">
					<a class="view_bt_box_a" href="${sysConf['scopus.search.view.url']}&origin=inward&scp=<c:out value="${fn:replace(resultMap.articleVo.idScopus,'2-s2.0-','')}"/>" target="_blank" title="link to SCOPUS">SCOPUS link</a>
				</c:if>
			</span>
			<span class="cited_span"><spring:message code="disc.detail.article.cited"/> <em><c:out value="${empty resultMap.articleVo.kciTc ? 0 : resultMap.articleVo.kciTc}"/></em> <spring:message code="disc.detail.article.times"/> <img src="<c:url value="/share/img/common/kci_text.png"/>" alt="KCI">
				<c:if test="${!empty resultMap.articleVo.idKci}">
					<a class="view_bt_box_a" href="${sysConf['kci.search.view.url']}?sereArticleSearchBean.artiId=<c:out value="${resultMap.articleVo.idKci}"/>" target="_blank" title="link to KCI">KCI link</a>
				</c:if>
			</span>
			<span class="cited_span" style="background:none;">
				<div data-badge-popover="right" data-link-target='_blank' data-badge-type="2" data-doi="<c:out value="${resultMap.articleVo.doi}"/>" data-hide-no-mentions="true" class="altmetric-embed"></div>
			</span>
		</div>
		<c:if test="${resultMap.articleVo.pubFileId != null && sessionScope.ip_check == true}">
			<!-- 카이스트 ip대역에서만  되게해야함-->
			<div class="view_bt_area">
				<div class="view_downbt">
					<ul>
						<li><a href="<c:url value="/servlet/download.do?fileid=${resultMap.articleVo.pubFileId}"/>" class="pdf_download" target="_blank"><em><spring:message code="disc.detail.article.pdf"/></em></a></li>
					</ul>
				</div>
			</div>
		</c:if>
	</div>
	<p class="view_title" style="color:#2d52b1; font-weight: bold;">${resultMap.articleVo.orgLangPprNm} <img src="<c:url value="/share/img/common/open_access.png"/>" alt="open_access" style="padding-bottom: 5px;display: ${resultMap.articleVo.openAccesAt == 'Y' ? '' : 'none' }" ></p>

	<c:if test="${fn:length(resultMap.articlePartiVoList) > 0}">
		<form action="${pageContext.request.contextPath}/share/user/userDetail.do" method="get" id="frm">
		<input type="hidden" id="id" name="id">
		<p class="view_author_t">
			<c:forEach items="${resultMap.articlePartiVoList}" var="articleParti" varStatus="stat">
				<c:if test="${stat.index > 0}">;</c:if>
				<c:choose>
					<c:when test="${articleParti.gubun == 'M' && articleParti.hldofYn == '1'}">
						<input type="hidden" id="id${stat.index}" value="<c:out value="${articleParti.encptUserId}"/>">
						<a href="#" onclick="goUserDetail('${stat.index}');" style="color:blue">
							<c:out value="${articleParti.prtcpntFullNm}"/>
						</a>
					</c:when>
					<c:otherwise>
						<span><c:out value="${articleParti.prtcpntFullNm}"/></span>
					</c:otherwise>
				</c:choose>
			</c:forEach>
		</p>
		</form>
	</c:if>

	<dl class="abstract_box">
		<dt><spring:message code="disc.detail.article.abstract"/></dt>
		<c:if test="${resultMap.articleVo.abstCntn == null }">
			<dd><p style="text-align: justify"><spring:message code="disc.display.nodata"/></p></dd>
		</c:if>
		<c:if test="${resultMap.articleVo.abstCntn != null }">
			<dd><p style="text-align: justify"><c:out value="${resultMap.articleVo.abstCntn}"/></p></dd>
		</c:if>
	</dl>
	<div class="view_info_wrap"><!--이미지 있을때는 view_add_img가 생김  -->
		<div class="vi_left_box">
			<dl class="view_dl">
				<dt><spring:message code="disc.detail.article.citation"/></dt>
				<c:if test="${resultMap.articleVo.content != null }">
					<dd>${resultMap.articleVo.content}</dd>
				</c:if>
			</dl>
			<dl class="view_dl">
				<dt><spring:message code="disc.detail.article.issn"/></dt>
				<c:if test="${resultMap.articleVo.issnNo != null }">
					<dd><c:out value="${resultMap.articleVo.issnNo}"/></dd>
				</c:if>
			</dl>
			<dl class="view_dl">
				<dt><spring:message code="disc.detail.article.wos.categories"/></dt>
				<c:if test="${resultMap.articleVo.sc != null }">
					<dd class="keyword_dd">
						<c:forEach items="${fn:split(resultMap.articleVo.sc,';')}" var="sc">
							<span><a href="javascript:searchAll('${fn:trim(sc)}');"><c:out value="${fn:trim(sc)}"/></a></span>
						</c:forEach>
					</dd>
				</c:if>
			</dl>
			<dl class="view_dl">
				<dt><spring:message code="disc.detail.article.author.keyword"/></dt>
				<c:if test="${fn:length(resultMap.articleVo.keywordList) > 0}">
					<dd class="keyword_dd">
						<c:forEach var="item" items="${resultMap.articleVo.keywordList}">
							<span><a href="javascript:searchAll('<c:out value="${fn:trim(item)}"/>');"><c:out value="${fn:trim(item)}"/></a></span>
						</c:forEach>
					</dd>
				</c:if>
			</dl>
			<dl class="view_dl">
				<dt><spring:message code="disc.detail.article.doi"/></dt>
				<c:if test="${resultMap.articleVo.doi != null }">
					<dd><a style="color:blue" href="http://dx.doi.org/<c:out value="${resultMap.articleVo.doi}"/>" target="_blank"><c:out value="${resultMap.articleVo.doi}"/></a></dd>
				</c:if>
			</dl>
			<dl class="view_dl">
				<dt><spring:message code="disc.detail.article.document.type"/></dt>
				<c:if test="${resultMap.articleVo.docType != null }">
					<dd><c:out value="${fn:trim(resultMap.articleVo.docType)}"/></dd>
				</c:if>
			</dl>
			<dl class="view_dl">
				<dt><spring:message code="disc.detail.article.if"/></dt>
				<c:if test="${resultMap.articleVo.impctFctr != null }">
					<dd><c:out value="${resultMap.articleVo.impctFctr}"/></dd>
				</c:if>
			</dl>
			<div id="chartdiv1" align="center"></div>

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
</div>
<!-- sub_container : e -->
</body>