<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@include file="../pageInit.jsp" %>
<head>
    <script type="text/javascript">
        var sort = "${sort}";
        var order = "${order}";

        $(function () {
            //대메뉴 형광색 들어오게하기
            $("#myRSS").addClass("on");

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

            $(location).attr('href',"${pageContext.request.contextPath}/personal/toc.do?"+addr);
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
    <h3 class="h3_title">My Mailing List</h3>
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
                            <li><i><span style="padding-right: 30px;"><spring:message code="disc.sort.sort"/></span></i><a onclick="sortTab('regDate')" id="regDate" style="display: inline; cursor: pointer;"><span><spring:message code="disc.sort.date"/></span><em>정렬</em></a></li>
                            <%--<li><a href="javascript:sortTab('svcgrp')" id="hit" style="display: inline;"><span>구분순</span></a></li>--%>
                        </ul>
                    </div>
                </div>
                <table class="tbl_type" id="journalTbl">
                    <colgroup>
                        <col width="50%">
                        <col width="15%">
                        <col width="10%">
                        <col width="15%">
                    </colgroup>
                    <thead>
                    <tr>
                        <th>저널명</th>
                        <th>ISSN</th>
                        <th>권/호</th>
                        <th>수신일</th>
                    </tr>
                    </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${fn:length(mailList) > 0}">
                                <c:forEach items="${mailList}" var="mail">
                                    <tr>
                                        <td class='al_left'><a href="${pageContext.request.contextPath}/personal/toc/article.do?msgId=${mail.MSG_ID}&page=${page}&order=${order}&sort=${sort}">${mail.JOURNALNAME}</a></td>
                                        <td class='al_center' style="padding-left: 0px; padding-right: 0px"><span style="font-size: 13px">${mail.ISSN}</span></td>
                                        <td class='al_center' style="padding-left: 0px; padding-right: 0px"><span style="font-size: 13px">VOL.${mail.VOLUME} NO.${mail.ISSUE}</span></td>
                                        <td class='al_center' style="padding-left: 0px; padding-right: 0px"><span style="font-size: 13px"><fmt:formatDate value="${mail.SENDDATE}" pattern="yyyy-MM-dd"/></span></td>
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
