<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<head>
    <%@include file="../pageInit.jsp" %>

    <!-- Owl Carousel Assets -->
    <link href="<c:url value="/share/css/owl.carousel.css"/>?ver=2.3.3" rel="stylesheet">
    <link href="<c:url value="/share/css/owl.theme.css"/>?ver=2.3.3" rel="stylesheet">
    <script src="<c:url value="/share/js/owl.carousel.min.js"/>?ver=2.3.3"></script>
    <link href="<c:url value="/share/css/owl.carousel.css"/>" rel="stylesheet">
    <link href="<c:url value="/share/css/owl.theme.css"/>" rel="stylesheet">
    <script src="<c:url value="/share/js/owl.carousel.min.js"/>"></script>
<%--    <script src="https://www.google.com/recaptcha/api.js?onload=onloadCallback&render=explicit" async defer></script>--%>
    <script type='text/javascript'>
        $(function () {
            //대메뉴 researcher에 형광색 들어오게하기
            $("#bigResearcher").addClass("on");
            $("#toTop").scrollToTop({speed: 500, ease: "easeOutBack", start: 200});

            toggleIntrcn();
            if($(".lab_intro_area").height() <= 241)
            {
                $(".view_t_more").hide();
            }
            toggleIntrcn();

            var items = [];
            if ('<c:out value="${labVo.coverFileId}"/>' !== '') {
                var coverFile = '<img src="<c:url value="/servlet/image/lab.do?fileid=${labVo.coverFileId}"/>"/>';
                items.push(coverFile);
            }
            if ('<c:out value="${labVo.repFileId1}"/>' !== '') {
                var repFile1 = '<img src="<c:url value="/servlet/image/lab.do?fileid=${labVo.repFileId1}"/>"/>';
                items.push(repFile1);
            }
            if ('<c:out value="${labVo.repFileId2}"/>' !== '') {
                var repFile2 = '<img src="<c:url value="/servlet/image/lab.do?fileid=${labVo.repFileId2}"/>"/>';
                items.push(repFile2);
            }
            if ('<c:out value="${labVo.videoLink}"/>' !== '') {
                var link = '<c:out value="${labVo.videoLink}"/>';
                if (link.lastIndexOf('v=') !== -1) link = link.substring(link.lastIndexOf('v=') + 2, link.lastIndexOf('v=') + 13);
                else if (link.lastIndexOf('/') !== -1) link = link.substring(link.lastIndexOf('/') + 1, link.length);
                console.log(link);
                var videoLink = '<a href="https://youtu.be/' + link + '" target="_blank"><img style="position:absolute; top:0;bottom:0;left:0;right:0;margin:auto;" src="https://i.ytimg.com/vi/' + link + '/hqdefault.jpg"/>' +
                    '<img style="position:relative; width: 65px; height: auto;" src="<c:url value="/images/icon/youtube_play_btn.png"/>"/></a>';
                items.push(videoLink);
            }

            var $html = '';
            for (var i = 0; i < items.length; i++) {
                $html += '<div class="item">' +
                    '<div class="lab_slide_inner">' +
                    '<div class="lab_slide_bg"><table><tbody><tr>' +
                    '<td>' +
                    items[i] +
                    '</td>' +
                    '</tr></tbody></table></div></div></div>';
            }
            if($html === ''){
                $html += '<div class="item">' +
                    '<div class="lab_slide_inner">' +
                    '<div class="lab_slide_bg"><table><tbody><tr>' +
                    '<td>' +
                    '<img src="<c:url value="/share/img/common/lab_default_rep.jpg"/>"/>' +
                    '</td>' +
                    '</tr></tbody></table></div></div></div>';
            }
            $("#lab_view_slide").append($html);
            $('#lab_view_slide').owlCarousel({
                items:1,
                loop:true,
                nav:false,
                autoHeight:true,
                autoplay: true,
                autoplayTimeout: 4500,
                autoplayHoverPause:true,
                margin:0
            });

            if(items.length == 1) $('#lab_view_slide').css('margin-bottom','42.3px');

            tabClick('main_article');
        });

        function tabClick(tabId) {

            // 탭 클릭시 파란색 들어오게함.
            $(".tab_wrap a").removeClass("on");
            $("#" + tabId).attr("class", "on");

            if (tabId === 'main_article') {
                $(".main_article_list").css("display", "block");
                $(".main_conference_list").css("display", "none");
                $(".latest_patent_list").css("display", "none");
                $(".latest_article_list").css("display", "none");
                $(".faq_list_wrap").css("display", "none");
            } else if (tabId === 'main_conference') {
                $(".main_article_list").css("display", "none");
                $(".main_conference_list").css("display", "block");
                $(".latest_patent_list").css("display", "none");
                $(".latest_article_list").css("display", "none");
                $(".faq_list_wrap").css("display", "none");
            }else if (tabId === 'latest_patent') {
                $(".main_article_list").css("display", "none");
                $(".main_conference_list").css("display", "none");
                $(".latest_patent_list").css("display", "block");
                $(".latest_article_list").css("display", "none");
                $(".faq_list_wrap").css("display", "none");
            }else if (tabId === 'latest_article') {
                $(".main_article_list").css("display", "none");
                $(".main_conference_list").css("display", "none");
                $(".latest_patent_list").css("display", "none");
                $(".latest_article_list").css("display", "block");
                $(".faq_list_wrap").css("display", "none");
            }else if (tabId === 'faq') {
                $(".main_article_list").css("display", "none");
                $(".main_conference_list").css("display", "none");
                $(".latest_patent_list").css("display", "none");
                $(".latest_article_list").css("display", "none");
                $(".faq_list_wrap").css("display", "block");
            }
        }

        function toggleFaq(answerId) {
            if($(answerId)[0].hasAttribute('hidden')){
                $(answerId).removeAttr('hidden');
            }else{
                $(answerId).attr('hidden',true);
            }
        }

        function toggleIntrcn() {
            if($(".lab_intro_t").hasClass('open_intrcn')){
                $(".lab_intro_t").removeClass('open_intrcn')
            }else{
                $(".lab_intro_t").addClass('open_intrcn');
            }
        }

        function toggleHelp() {
            if($(".k_help_view").css("display") == "none"){
                $(".k_help_view").show();
            }else{
                $(".k_help_view").hide();
            }
        }

        /*function onloadCallback() {
            grecaptcha.render('html_element', {
                'sitekey' : '6LddMcAUAAAAAAIyODA0lMnVWis3UrhHViNA85Gx',
                'callback' : function(response) {
                    $.ajax({
                        url: "<c:url value="/share/laboratory/emailReCapcha.do"/>",
                        dataType: "json",
                        data:{userId:${labVo.userId}}
                    }).done(function(data){
                        $("#mailBody form").remove();
                        $("#mailBody").html(data.email);
                    });
                }
            });
        }*/

        function emailModal() {
            $.ajax({
                url: "<c:url value="/share/laboratory/emailReCapcha.do"/>",
                dataType: "json",
                data:{userId:${labVo.userId}}
            }).done(function(data){
                $("#mailBody").html(data.email);
                $('#dialog').modal('show');
            });
        }
    </script>
</head>
<body>
<div class="sub_container">
    <a id="toTop" href="#">상단으로 이동</a>
    <h3 class="result_title" style="margin-bottom: 10px;"><spring:message code="disc.lab.lab.title"/>
        <a href="javascript:history.go(-1);" class="prev_bt" style="float:right;font-size:14px;color: #555;font-weight: normal;"><spring:message code="disc.anls.toprf.article.prev"/></a>
    </h3>
    <div class="lab_view_wrap">
        <div class="lab_left_slide">
            <div id="lab_view_slide" class="owl-carousel owl-theme">

            </div>
            <div class="researcher_bottom_box">
                <div class="r_m_box">
                    <div class="researcher_info_box">
                        <span class="r_img_b"><img src="<c:url value="/servlet/image/profile.do?fileid=${labVo.profPhotoFileId}"/>"/></span>
                        <c:set value='${labVo.posiNm == "교수" ? "Professor" :labVo.posiNm == "조교수" ? "Assistant Professor" :labVo.posiNm == "부교수" ? "Associate Professor" :"" }' var="engPosiNm"/>
                        <c:choose>
                            <c:when test='${language eq "en"}'>
                                <p>${engPosiNm} ${labVo.userEngNm}
                                    <span>(${labVo.userKorNm} ${labVo.posiNm})</span>
                                    <em>${labVo.deptEng} (${labVo.deptKor})</em>
                                </p>
                            </c:when>
                            <c:otherwise>
                                <p>${labVo.userKorNm} ${labVo.posiNm}
                                    <span>(${engPosiNm} ${labVo.userEngNm})</span>
                                    <em>${labVo.deptKor} (${labVo.deptEng})</em>
                                </p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="r_m_link_box">
                    <div class="row">
                        <c:if test='${labVo.homePageAddr eq null or labVo.homePageAddr eq ""}'>
                        <div class="r_m_col r_m_gray">
                            <div class="r_m_link r_m_home"><a href="javascript:void(0)"><span>Homepage</span></a></div>
                        </div>
                        </c:if>
                        <c:if test='${labVo.homePageAddr ne null and labVo.homePageAddr ne ""}'>
                        <div class="r_m_col">
                            <div class="r_m_link r_m_home"><a href="${labVo.homePageAddr}" target="_blank"><span>Homepage</span></a></div>
                        </div>
                        </c:if>
                        <div class="r_m_col">
                            <div class="r_m_link r_m_email"><a href="javascript:void(0)" onclick="javascript:emailModal();"><span>e-Mail</span></a></div>
                        </div>
                        <div class="r_m_col">
                            <div class="r_m_link r_m_profile"><a href="<c:url value="/share/user/userDetail.do?id=${labVo.encptUserId}"/>"><span>Profile</span></a></div>
                        </div>
                        <c:set value="${language eq 'en' ? engLabFaqList : korLabFaqList}" var="labFaqList"/>
                        <c:if test="${not empty labFaqList}">
                        <div class="r_m_col">
                                <div class="r_m_link r_m_faq"><a href="javascript:tabClick('faq')"><span>FAQ</span></a></div>
                        </div>
                        </c:if>
                        <c:if test="${empty labFaqList}">
                        <div class="r_m_col r_m_gray">
                            <div class="r_m_link r_m_faq"><a href="javascript:void(0)"><span>FAQ</span></a></div>
                        </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div><!-- 연구실 이미지 슬라이드 : e -->

        <div class="lab_right_info">
            <div class="lab_info_area">
                <div class="lab_view_title">
                    <c:choose>
                        <c:when test='${language eq "en"}'>
                            <p><em>${labVo.engNm}</em>${labVo.korNm}</p>
                        </c:when>
                        <c:otherwise>
                            <p><em>${labVo.korNm}</em>${labVo.engNm}</p>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="lab_intro_t">
                    <div class="lab_intro_area">
                        <c:set value="${language eq 'en' ? labVo.engIntrcn : labVo.korIntrcn}" var="intrcn"/>
                        ${intrcn}
                    </div>
                    <a href="javascript:toggleIntrcn()" class="view_t_more">더보기</a>
                </div>
            </div>
            <div class="view_keyword">
                <div class="keyword_title_box">
                    <h4>Keyword</h4>
                    <div class="keyword_help_b">
                        <a href="javascript:void(0);" onclick="toggleHelp();" class="k_help_icon">Keyword 도움말</a>
                        <div class="k_help_view" style="display:none;"><p>키워드를 클릭하면 해당 키워드로 검색된 정보를 보실 수 있습니다.</p></div><!-- 도움말 부분 -->
                    </div>
                </div>
                <c:set value="${language eq 'en' ? labVo.engKeyword : labVo.korKeyword}" var="keywords"/>
                <c:if test='${keywords ne null}'>
                    <ul class="keyword_list_box">
                        <c:if test="${language eq 'en'}">
                            <c:forEach items="${fn:split(keywords, ',')}" var="keyword">
                                <li><a href="javascript:searchAll('${keyword}');"><span>${keyword}</span></a></li>
                            </c:forEach>
                        </c:if>
                        <c:if test="${language eq 'ko'}">
                            <c:forEach items="${fn:split(keywords, ',')}" var="keyword">
                                <li><a href="javascript:searchAll('${keyword}');"><span>${keyword}</span></a></li>
                            </c:forEach>
                            <c:forEach items="${fn:split(labVo.engKeyword, ',')}" var="keyword">
                                <li><a href="javascript:searchAll('${keyword}');"><span>${keyword}</span></a></li>
                            </c:forEach>
                        </c:if>
                    </ul>
                </c:if>
                <c:if test="${keywords eq null}">
                    <spring:message code="disc.display.nokeyword"/>
                </c:if>
            </div>
        </div>
    </div>
    <div class="tab_wrap w_20">
        <ul>
            <li><a id="latest_article" href="javascript:tabClick('latest_article')">Latest Article</a></li>
            <li><a id="main_article" href="javascript:tabClick('main_article')">Main Article</a></li>
            <li><a id="main_conference" href="javascript:tabClick('main_conference')">Main Conference</a></li>
            <li><a id="latest_patent" href="javascript:tabClick('latest_patent')">Latest Patent</a></li>
            <li><a id="faq" href="javascript:tabClick('faq')">FAQ</a></li>
        </ul>
    </div>
    <div class="main_article_list">
        <c:choose>
            <c:when test='${not empty mainArticleList}'>
                <c:forEach items="${mainArticleList}" var="article">
                    <div class="article_list_box">
                        <div class="alb_text_box">
                            <div data-badge-popover="left" data-link-target='_blank' style="float:right;"
                                 data-badge-type="donut"
                                 data-doi="${article.doi}" data-hide-no-mentions="true"
                                 class="altmetric-embed"></div>
                            <a class="al_title" target="_self"
                               href="<c:url value="share/article/articleDetail.do?id${article.articleId}"/>">
                                    ${article.orgLangPprNm}
                            </a>
                            <p>
                                    ${article.content}
                            </p>
                        </div>
                        <c:if test="${article.keywords ne 'empty' and article.keywords ne null}">
                            <div class="l_keyword_box">
                                <span>keyword</span>
                                <c:forEach items="${fn:split(article.keywords, ',')}" var="keyword">
                                    <a href="javascript:searchAll('${keyword}');">${keyword}</a>
                                </c:forEach>
                            </div>
                        </c:if>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <h4 style="text-align:center"><spring:message code="disc.display.nodata"/></h4>
            </c:otherwise>
        </c:choose>
    </div>
    <div class="main_conference_list">
        <c:choose>
            <c:when test='${not empty mainConferenceList}'>
                <c:forEach items="${mainConferenceList}" var="conference">
                    <div class="article_list_box">
                        <div class="alb_text_box">
                            <div data-badge-popover="left" data-link-target='_blank' style="float:right;"
                                 data-badge-type="donut"
                                 data-doi="${conference.doi}" data-hide-no-mentions="true"
                                 class="altmetric-embed"></div>
                            <a class="al_title" target="_self"
                               href="<c:url value="/share/conference/conferenceDetail.do?id=${conference.conferenceId}"/>">
                                    ${conference.orgLangPprNm}
                            </a>
                            <p>
                                    ${conference.content}
                            </p>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <h4 style="text-align:center"><spring:message code="disc.display.nodata"/></h4>
            </c:otherwise>
        </c:choose>
    </div>
    <div class="latest_patent_list">
        <c:choose>
            <c:when test='${not empty latestPatentList}'>
                <c:forEach items="${latestPatentList}" var="patent">
                    <div class="article_list_box">
                        <div class="alb_text_box">
                            <a class="al_title" target="_self"
                               href="<c:url value="/share/patent/patentDetail.do?id=${patent.patentId}"/>">
                                    ${patent.itlPprRgtNm}
                            </a>
                            <p>
                                    ${patent.content}
                            </p>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <h4 style="text-align:center"><spring:message code="disc.display.nodata"/></h4>
            </c:otherwise>
        </c:choose>
    </div>
    <div class="latest_article_list">
        <c:choose>
            <c:when test='${not empty latestArticleList}'>
                <c:forEach items="${latestArticleList}" var="latestArticle">
                    <div class="article_list_box">
                        <div class="alb_text_box">
                            <div data-badge-popover="left" data-link-target='_blank' style="float:right;"
                                 data-badge-type="donut"
                                 data-doi="${latestArticle.doi}" data-hide-no-mentions="true"
                                 class="altmetric-embed"></div>
                            <a class="al_title" target="_self"
                               href="<c:url value="/share/article/articleDetail.do?id=${latestArticle.articleId}"/>">
                                    ${latestArticle.orgLangPprNm}
                            </a>
                            <p>
                                    ${latestArticle.content}
                            </p>
                        </div>
                        <c:if test="${not empty latestArticle.keywordList}">
                            <div class="l_keyword_box">
                                <span>keyword</span>
                                <c:forEach items="${latestArticle.keywordList}" var="keyword">
                                    <a href="javascript:searchAll('{keyword}');">${keyword}</a>
                                </c:forEach>
                            </div>
                        </c:if>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <h4 style="text-align:center"><spring:message code="disc.display.nodata"/></h4>
            </c:otherwise>
        </c:choose>
    </div>
    <c:set value="${language eq 'en' ? engLabFaqList : korLabFaqList}" var="labFaqList"/>
    <c:if test="${not empty labFaqList}">
        <div class="faq_list_wrap" name="faq_list_wrap">
            <c:forEach items="${labFaqList}" var="faq" varStatus="status">
                <h3 class="acc_trigger" onclick="javascript:toggleFaq('.answer${status.count}');"><a href="javascript:void(0);"><span>Q</span>${faq.question}</a></h3>
                <div class="acc_container answer${status.count}" hidden>
                    <span>A</span>
                    <div class="fap_block">${faq.answer}</div>
                </div>
            </c:forEach>
        </div>
    </c:if>
    <c:if test="${empty labFaqList}">
        <div class="faq_list_wrap" name="faq_list_wrap" style="border: none;">
            <h4 style="text-align:center"><spring:message code="disc.display.nodata"/></h4>
        </div>
    </c:if>
</div>



<!-- Modal -->
<div class="modal fade" id="dialog" tabindex="-1" role="dialog" aria-labelledby="exampleModalLongTitle" aria-hidden="true">
    <div class="modal-dialog" role="document" style="width:380px;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h5 class="modal-title">Email</h5>
            </div>
            <div class="modal-body" id="mailBody">
                <%--<form action="?" method="POST">
                    <div id="html_element"></div>
                </form>--%>
            </div>
        </div>
    </div>
</div>
</body>