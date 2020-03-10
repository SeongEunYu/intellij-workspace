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
        });
    </script>
</head>
<body>
<div class="sub_container">
    <h3 class="h3_title"><spring:message code="disc.about.ntcm.title"/></h3>
    <div class="about_top_wrap">
        <%--<div class="language_r_box">
            <a href="${pageContext.request.contextPath}/share/user/kboard.do?language=en" ${lang=='en'?'class="on"':''}><spring:message code="disc.language.eng"/></a>
            <a href="${pageContext.request.contextPath}/share/user/kboard.do?language=ko" ${lang=='ko'?'class="on"':''}><spring:message code="disc.language.kor"/></a>
        </div>--%>
        <div id="tabs">
            <div class="tab_wrap w_33">
                <ul>
                    <li id="tab1"><a class="on" href="#tabs-1"><spring:message code="disc.tab.notice"/></a></li>
                    <li id="tab2"><a href="#tabs-2"><spring:message code="disc.tab.manual"/></a></li>
                    <li id="tab3"><a href="#tabs-3"><spring:message code="disc.tab.sci.if.list"/></a></li>
                </ul>
            </div>
            <div class="sub_img_box" id="tabs-1"><script type="text/javascript" src="https://board.kaist.ac.kr/javascript/apiboard.jsp?boardId=ri_notice&bltnCateId1=1&langKnd=${lang}&isMobile=0"></script></div>
            <div class="sub_img_box" id="tabs-2"><script type="text/javascript" src="https://board.kaist.ac.kr/javascript/apiboard.jsp?boardId=ri_notice&bltnCateId1=2&langKnd=${lang}&isMobile=0"></script></div>
            <div class="sub_img_box" id="tabs-3"><script type="text/javascript" src="https://board.kaist.ac.kr/javascript/apiboard.jsp?boardId=ri_notice&bltnCateId1=3&langKnd=${lang}&isMobile=0"></script></div>
        </div>
    </div>
    <a id="toTop" style="display: none; cursor: pointer;">상단으로 이동</a>

</div>
</body>
