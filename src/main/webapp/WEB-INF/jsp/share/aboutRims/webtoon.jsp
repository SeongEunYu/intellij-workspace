<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@include file="../pageInit.jsp" %>
<head>
    <script type="text/javascript">
        (function($) {
            $(document).ready(function() {
                $.slidebars();
            });
        }) (jQuery);

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
                }
            });
        });
    </script>
</head>
<body>
<div class="sub_container">
    <h3 class="h3_title"><spring:message code="disc.about.wbtn.title"/></h3>
    <div id="tabs">
        <div class="tab_wrap w_33">
            <ul>
                <li id="tab1"><a class="on" href="#tabs-1"><spring:message code="disc.tab.manual.rims"/></a></li>
                <li id="tab2"><a href="#tabs-2"><spring:message code="disc.tab.use"/></a></li>
            </ul>
        </div>
        <div class="sub_img_box" id="tabs-1" style="text-align:center;"><img src='<c:url value="/share/img/common/webtoon_img01.jpg"/>' alt="RIMS와 KRI사용법"></div>
        <div class="sub_img_box" id="tabs-2" style="text-align:center;"><img src='<c:url value="/share/img/common/webtoon_img02.jpg"/>' alt="RIMS 제대로 활용하기"></div>
    </div>

    <a id="toTop" style="display: none; cursor: pointer;">상단으로 이동</a>
</div>
</body>