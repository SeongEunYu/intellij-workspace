<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@include file="../pageInit.jsp" %>
<head>
    <script type="text/javascript" src="<c:url value="/js/pdfobject.js"/>"></script>
    <script type="text/javascript">

        $(function () {
            //대메뉴 형광색 들어오게하기
            $("#myRSS").addClass("on");

            <%--var options = {--%>
                <%--pdfOpenParams : {--%>
                    <%--navpanes: 0,--%>
                    <%--toolbar: 0,--%>
                    <%--statusbar: 0,--%>
                    <%--view: "FitV",--%>
                    <%--page: 1--%>
                <%--},--%>
                <%--forcePDFJS: true,--%>
                <%--PDFJS_URL: "${pageContext.request.contextPath}/pdfjs/web/viewer.html"--%>
            <%--};--%>
            <%--PDFObject.embed("<c:url value='/pdf/${bbs.bbsId}/${bbs.fileList[0].fileNm}.do'/>", "#pdfView2", options);--%>
        });
    </script>
</head>
<body>
<div class="sub_container" style="display: table;">
    <div style="margin-bottom: 50px;">
        <a href="${pageContext.request.contextPath}/personal/myRss/nBoard.do?page=${page}&order=${order}&sort=${sort}" class="prev_bt" style="float:right;">목록</a>
    </div>
    <div class="view_top_box">
        <div class="view_bt_box">
			<span class="">작성자 : ${bbs.regUserId}</span>
            <span class="cited_span">조회수 : ${bbs.viewCnt}</span>
            <span class="cited_span">등록일 : <fmt:formatDate value="${bbs.regDate}" pattern="yyyy-MM-dd"/></span>
        </div>
    </div>
    <p class="view_title" style="color:#2d52b1; font-weight: bold;">${bbs.title}</p>

    <dl class="abstract_box" style="float: left; width: 100%; border-bottom: none;">
        <dt>내용</dt>
        <dd style="text-align: justify; width: 100%; word-break: break-all; margin-top: 15px;">
            <c:out value="${bbs.content}" escapeXml="false"/>
        </dd>
    </dl>
    <a id="toTop" href="#">상단으로 이동</a>
</div>
</body>
