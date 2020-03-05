<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@include file="../pageInit.jsp" %>
<head>
    <script type="text/javascript">
        $(function () {
            //대메뉴 형광색 들어오게하기
            $("#bigAbout").addClass("on");

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
            var addr = "&page="+page+"&sort="+sort;

            $(location).attr('href',"${pageContext.request.contextPath}/share/myRss/myFavorite.do?"+addr);
        }

        //페이지 그리기
        function drawPages(pageClass, pageNm){
            var span = 1;
            var searchName = "${searchName}";
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
            <div class="left_list_box" style="width: 1200px;">
                <div class="list_top_box">
                    <p class="page_num_box"></p>
                    <div class="list_sort_box">
                        <ul>
                            <li><i><span style="padding-right: 30px;"><spring:message code="disc.sort.sort"/></span></i><a href="javascript:sortTab('date')" id="date" style="display: inline;"><span><spring:message code="disc.sort.date"/></span></a></li>
                            <li><a href="javascript:sortTab('hit')" id="hit" style="display: inline;"><span><spring:message code="disc.sort.views"/></span></a></li>
                            <li class="hidden"><a href="javascript:sortTab('score')" id="score"><span><spring:message code="disc.sort.relevance"/></span></a></li>
                        </ul>
                    </div>
                </div>
                <table class="tbl_type" id="journalTbl">
                    <colgroup>
                        <col width="10%">
                        <col width="42%">
                        <col width="12%">
                    </colgroup>
                    <thead>
                    <tr>
                        <th>구분</th>
                        <th>제목</th>
                        <th>보관 날짜</th>
                    </tr>
                    </thead>
                        <tbody>
                        <c:choose>
                            <c: test="${fn:length(favoriteList) > 0}">
                                <c:forEach items="${favoriteList}" var="favorite">
                                    <tr>
                                        <td class='al_center' style="padding-left: 0px; padding-right: 0px">
                                            <span style="font-size: 13px">
                                                <c:choose>
                                                    <c:when test="${favorite.svcgrp == 'VUSER'}">
                                                        연구자
                                                    </c:when>
                                                    <c:otherwise>

                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                        </td>
                                        <td class='al_left'><a href="${favorite.url}"><c:out value="${favorite.title != 'null' ? favorite.title : 'Not found Title'}" escapeXml="false"/></a></td>
                                        <%--<td class='al_center' style="padding-left: 0px; padding-right: 0px"><span style="font-size: 13px"><c:out value="${favorite.regDate != 'null' ? favorite.regDate : ''}"/></span></td>--%>
                                        <td class='al_center' style="padding-left: 0px; padding-right: 0px"><span style="font-size: 13px"><fmt:formatDate value="${favorite.regDate}" pattern="yyyy-MM-dd"/></span></td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td class='al_center' colspan="3">등록된 데이터가 없습니다.</td>
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
