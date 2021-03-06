<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@include file="../pageInit.jsp" %>
<head>
    <script type="text/javascript">
        var sort = "${sort}";
        var order = "${order}";

        $(function () {
            //대메뉴 형광색 들어오게하기
            $("#myRSS").addClass("on");

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

            $("#"+sort).addClass(order.slice(0,-1)+"_type");
            $("#"+sort).css("font-weight","bold");

            //페이징 변수 초기화
            var pageClass = [];
            var pageNm = [];

            <c:forEach items="${pageList}" var="pages">
            pageClass.push('${pages.classNm == null ? "null" : pages.classNm}');
            pageNm.push(${pages.page});
            </c:forEach>

            drawPages(pageClass, pageNm);
        });

        function goDocument(page){
            var addr = "page="+page+"&sort="+sort+"&order="+order;

            $(location).attr('href',"${pageContext.request.contextPath}/personal/myRss/myFavorite.do?"+addr);
        }

        function viewDetail(seq){

            var width = $(document).width() * 0.7;
            var height = $(document).height() * 0.8;

            var left = ($(document).width()/2)-(width/2);
            var top = ($(document).height()/2)-(height/2);

            var win = window.open('${s2jUrl}/journal/journalDetailPopup.do?jrnlId='+seq,'jorunalDtl',' height=' + height + 'px, width=' + width + 'px, resizable=yes, location=no, scrollbars=yes');
            win.moveTo(left, top);
            win.focus();
        }

        //페이지 그리기
        function drawPages(pageClass, pageNm){
            var span = 1;
            var currentPage = "${page}";

            //페이징
            for(var i=0; i<pageClass.length; i++){
                //처음, 다음, 이전, 이후 페이지
                if(pageClass[i] != 'null') {
                    $(".paging_nav").append(" <a class='page_select "+pageClass[i]+"' href='javascript:goDocument(\""+pageNm[i]+"\")'></a> ");
                }else{
                    //페이지 숫자표기
                    if(span != 0){
                        $(".paging_nav").append(" <span style='margin-left: 0px;'></span> ");
                        span--;
                    }

                    if(currentPage == pageNm[i]){
                        $(".paging_nav span").append(" <strong>"+pageNm[i]+"</strong>");
                    }else{
                        $(".paging_nav span").append(" <a href='javascript:goDocument(\""+pageNm[i]+"\")'>"+pageNm[i]+"</a>");
                    }
                }
            }
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
                if(inSortNm == "regDate")  order = "desc";
            }

            goDocument("1");
        }
    </script>
</head>
<body>
<div class="sub_container">
    <%--<h3 class="h3_title"><spring:message code="disc.about.ntcm.title"/></h3>--%>
    <h3 class="h3_title">My Favorite</h3>
    <div class="about_top_wrap">
        <%--<div class="language_r_box">
            <a href="${pageContext.request.contextPath}/share/user/kboard.do?language=en" ${lang=='en'?'class="on"':''}><spring:message code="disc.language.eng"/></a>
            <a href="${pageContext.request.contextPath}/share/user/kboard.do?language=ko" ${lang=='ko'?'class="on"':''}><spring:message code="disc.language.kor"/></a>
        </div>--%>
        <div id="tabs">
            <div class="left_list_box" style="width: 1200px; display: contents;">
                <div class="list_top_box">
                    <p class="page_num_box"></p>
                    <div class="list_sort_box">
                        <ul>
                            <li><i><span style="padding-right: 30px;"><spring:message code="disc.sort.sort"/></span></i><a onclick="sortTab('regDate')" id="regDate" style="display: inline; cursor: pointer;"><span><spring:message code="disc.sort.date"/></span><em>정렬</em></a></li>
                            <%--<li><a href="javascript:sortTab('svcgrp')" id="hit" style="display: inline;"><span>구분순</span></a></li>--%>
                        </ul>
                    </div>
                </div>
                <table class="tbl_type" id="journalTbl">
                    <colgroup>
                        <col width="10%">
                        <col width="70%">
                        <col width="10%">
                        <col width="10%">
                    </colgroup>
                    <thead>
                    <tr>
                        <th>구분</th>
                        <th>제목</th>
                        <th>등록 날짜</th>
                        <th>비고</th>
                    </tr>
                    </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${fn:length(favoriteList) > 0}">
                                <c:forEach items="${favoriteList}" var="favorite">
                                    <tr>
                                        <td class='al_center' style="padding-left: 0px; padding-right: 0px">
                                                <c:choose>
                                                    <c:when test="${favorite.svcgrp == 'VUSER'}">
                                                        <span class="favoriteList l_researcher_t" style="font-size: 13px"></span>
                                                    </c:when>
                                                    <c:when test="${favorite.svcgrp == 'VART'}">
                                                        <span class="favoriteList l_article_t" style="font-size: 13px"></span>
                                                    </c:when>
                                                    <c:when test="${favorite.svcgrp == 'VPROJ'}">
                                                        <span class="favoriteList l_project_t" style="font-size: 13px"></span>
                                                    </c:when>
                                                    <c:when test="${favorite.svcgrp == 'VPAT'}">
                                                        <span class="favoriteList l_patent_t" style="font-size: 13px"></span>
                                                    </c:when>
                                                    <c:when test="${favorite.svcgrp == 'VCONF'}">
                                                        <span class="favoriteList l_conference_t" style="font-size: 13px"></span>
                                                    </c:when>
                                                    <c:when test="${favorite.svcgrp == 'VJOUR'}">
                                                        <span class="favoriteList l_journal_t" style="font-size: 13px"></span>
                                                    </c:when>
                                                </c:choose>
                                        </td>
                                        <td class='al_left'>
                                            <c:choose>
                                                <c:when test="${favorite.svcgrp == 'VUSER'}">
                                                    <a href="${favorite.url}">
                                                        <c:out value="${favorite.title != 'null' ? favorite.title : 'Not found Title'}" escapeXml="false"/>
                                                        <c:if test="${favorite.clgNm != '' or favorite.deptNm != ''}">
                                                            (
                                                            <c:if test="${favorite.clgNm != ''}">
                                                                <c:out value="${favorite.clgNm}" />
                                                            </c:if>
                                                            <c:if test="${favorite.deptNm != ''}">
                                                                <c:if test="${favorite.clgNm != ''}">
                                                                    &nbsp;/&nbsp;<c:out value="${favorite.deptNm}" />
                                                                </c:if>
                                                                <c:if test="${!favorite.clgNm == ''}">
                                                                    <c:out value="${favorite.deptNm}" />
                                                                </c:if>
                                                            </c:if>
                                                            )
                                                        </c:if>

                                                    </a>
                                                </c:when>
                                                <c:when test="${favorite.svcgrp == 'VART'}">
                                                    <a href="${favorite.url}">
                                                        <c:out value="${favorite.title != 'null' ? favorite.title : 'Not found Title'}" escapeXml="false"/>
                                                        <c:if test="${favorite.volume != '' or favorite.issue != '' or favorite.page != ''}">
                                                            (
                                                            <c:if test="${favorite.volume != ''}">
                                                                Vol.<c:out value="${favorite.volume}" />
                                                            </c:if>
                                                            <c:if test="${favorite.issue != ''}">
                                                                No.<c:out value="${favorite.issue}" />
                                                            </c:if>
                                                            <c:if test="${favorite.page != ''}">
                                                                page.<c:out value="${favorite.page}" />
                                                            </c:if>
                                                            )
                                                        </c:if>
                                                    </a>
                                                </c:when>
                                                <c:when test="${favorite.svcgrp == 'VPROJ'}">
                                                    <a href="${favorite.url}">
                                                        <c:out value="${favorite.title != 'null' ? favorite.title : 'Not found Title'}" escapeXml="false"/>
                                                        <c:if test="${favorite.author != ''}">
                                                            (<c:out value="${favorite.author}" />)
                                                        </c:if>
                                                    </a>
                                                </c:when>
                                                <c:when test="${favorite.svcgrp == 'VPAT'}">
                                                    <a href="${favorite.url}">
                                                        <c:out value="${favorite.title != 'null' ? favorite.title : 'Not found Title'}" escapeXml="false"/>
                                                        <c:if test="${favorite.author != ''}">
                                                            (<c:out value="${favorite.author}" />)
                                                        </c:if>
                                                    </a>
                                                </c:when>
                                                <c:when test="${favorite.svcgrp == 'VCONF'}">
                                                    <a href="${favorite.url}">
                                                        <c:out value="${favorite.title != 'null' ? favorite.title : 'Not found Title'}" escapeXml="false"/>
                                                        <c:if test="${favorite.author != ''}">
                                                            (<c:out value="${favorite.author}" />)
                                                        </c:if>
                                                    </a>
                                                </c:when>
                                                <c:when test="${favorite.svcgrp == 'VJOUR'}">
                                                    <a href="javascript:viewDetail('${favorite.dataId}')">
                                                        <c:out value="${favorite.title != 'null' ? favorite.title : 'Not found Title'}" escapeXml="false"/>
                                                        <c:if test="${favorite.author != '' or favorite.issn != ''}">
                                                            (
                                                            <c:if test="${favorite.author != ''}">
                                                                <c:out value="${favorite.author}" />
                                                            </c:if>
                                                            <c:if test="${favorite.issn != ''}">
                                                                <c:if test="${favorite.author != ''}">
                                                                    &nbsp;/&nbsp;<c:out value="${favorite.issn}" />
                                                                </c:if>
                                                                <c:if test="${!favorite.author == ''}">
                                                                    <c:out value="${favorite.issn}" />
                                                                </c:if>
                                                            </c:if>
                                                            )
                                                        </c:if>
                                                    </a>
                                                </c:when>
                                            </c:choose>
                                        </td>
                                        <td class='al_center' style="padding-left: 0px; padding-right: 0px"><span style="font-size: 13px"><fmt:formatDate value="${favorite.regDate}" pattern="yyyy-MM-dd"/></span></td>
                                        <td class='al_center' style="padding-left: 0px; padding-right: 0px"><span style="font-size: 13px">${favorite.solution}</span></td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td class='al_center' colspan="4">등록된 데이터가 없습니다.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                </table>
                <!-- 페이지 -->
                <div class="paging_nav" style="padding-top: 20px;"></div>
            </div><!-- left side -->
        </div>
    </div>
    <a id="toTop" style="display: none; cursor: pointer;">상단으로 이동</a>

</div>
</body>
