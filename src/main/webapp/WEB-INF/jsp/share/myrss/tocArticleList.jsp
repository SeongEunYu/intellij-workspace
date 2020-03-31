<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@include file="../pageInit.jsp" %>
<head>
    <script type="text/javascript">
        $(function () {
            //대메뉴 형광색 들어오게하기
            $("#myRSS").addClass("on");

        });
    </script>
</head>
<body>
<div class="sub_container">
    <%--<h3 class="h3_title"><spring:message code="disc.about.ntcm.title"/></h3>--%>
    <a href="${pageContext.request.contextPath}/personal/toc.do?page=${page}&order=${order}&sort=${sort}" class="prev_bt" style="float:right;">목록</a>
    <h3 class="h3_title">My Mailing List <em>(Article List)</em></h3>
    <div class="about_top_wrap">
        <%--<div class="language_r_box">
            <a href="${pageContext.request.contextPath}/share/user/kboard.do?language=en" ${lang=='en'?'class="on"':''}><spring:message code="disc.language.eng"/></a>
            <a href="${pageContext.request.contextPath}/share/user/kboard.do?language=ko" ${lang=='ko'?'class="on"':''}><spring:message code="disc.language.kor"/></a>
        </div>--%>
        <table class="tbl_type" id="journalTbl">
            <colgroup>
                <col width="10%">
                <col width="10%">
                <col width="55%">
                <col width="25%">

            </colgroup>
            <thead>
            <tr>
                <th>권/호</th>
                <th>페이지</th>
                <th>제목</th>
                <th>저자</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${fn:length(articleList) > 0}">
                    <c:forEach items="${articleList}" var="article">
                        <tr>
                            <td class='al_center' style="padding-left: 0px; padding-right: 0px">
                                <span style="font-size: 13px"><c:if test="${not empty article.VOLUME}">Vol.${article.VOLUME} </c:if><c:if test="${not empty article.ISSUE}">No.${article.ISSUE}</c:if></span>
                            </td>
                            <td class='al_center' style="padding-left: 0px; padding-right: 0px">
                                <span style="font-size: 13px">${article.STR_PAGE}-${article.END_PAGE}</span>
                            </td>
                            <td class='al_left'><a href="https://dx.doi.org/${article.DOI}" target="_blank">${article.TITLE}</a></td>
                                <%--<td class='al_center' style="padding-left: 0px; padding-right: 0px"><span style="font-size: 13px"><c:out value="${favorite.regDate != 'null' ? favorite.regDate : ''}"/></span></td>--%>
                            <td class='al_center' style="padding-left: 0px; padding-right: 0px"><span style="font-size: 13px"><c:out value="${fn:replace(article.AUTHOR, ';', ' &')}"/></span></td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td class='al_center' colspan="4">데이터가 없습니다.</td>
                    </tr>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
    </div>
    <a id="toTop" style="display: none; cursor: pointer;">상단으로 이동</a>

</div>
</body>
