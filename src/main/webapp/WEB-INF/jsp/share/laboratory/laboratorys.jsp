<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<head>
    <%@include file="../pageInit.jsp" %>

    <script type='text/javascript'>
        $(function () {
            //대메뉴 researcher에 형광색 들어오게하기
            $("#bigResearcher").addClass("on");

            $("#toTop").scrollToTop({speed: 1000, ease: "easeOutBack", start: 200});

            drawProfPhoto();
            drawCoverImg('${cover}');
            $('#cover').val('${cover}');

            $('#keyword').val('${keyword}');

            //페이징 변수 초기화
            var pageClass = [];
            var pageNm = [];

            <c:forEach items="${pageList}" var="pages">
            pageClass.push('${pages.classNm == null ? "null" : pages.classNm}');
            pageNm.push(${pages.page});
            </c:forEach>

            drawPages(pageClass, pageNm);
        });

        function drawProfPhoto() {
            <c:set value="${language == 'en' ? engLabList : korLabList}" var="labList"/>
            <c:forEach items="${labList}" var="lab">
                <c:if test="${lab.profPhotoFileId != 'empty'}">
                    $(".${lab.labId}").css("background-image","url(<c:url value="/servlet/image/profile.do?fileid=${lab.profPhotoFileId}"/>)");
                    $(".${lab.labId}").css("background-repeat","no-repeat");
                    $(".${lab.labId}").css("background-position","0 0");
                    $(".${lab.labId}").css("background-size","26px 26px");
                </c:if>
            </c:forEach>
        }

        function drawPages(pageClass, pageNm){
            var span = 1;
            var currentPage = "${page}";

            //페이징
            for(var i=0; i<pageClass.length; i++){
                //처음, 다음, 이전, 이후 페이지
                if(pageClass[i] != 'null') {
                    $(".paging_nav").append(" <a class='page_select "+pageClass[i]+"' href='javascript:goPage(\""+pageNm[i]+"\")'></a> ");
                }else{
                    //페이지 숫자표기
                    if(span != 0){
                        $(".paging_nav").append(" <span style='margin-left: 0px;'></span> ");
                        span--;
                    }

                    if(currentPage == pageNm[i]){
                        $(".paging_nav span").append(" <strong>"+pageNm[i]+"</strong>");
                    }else{
                        $(".paging_nav span").append(" <a href='javascript:goPage(\""+pageNm[i]+"\")'>"+pageNm[i]+"</a>");
                    }
                }
            }
        }

        function goLabDetail(labId){
            var param = "&dept="+$('#dept').val()+"&keyword="+  $('#keyword').val();
            $(location).attr('href',"<c:url value="/share/laboratory/laboratoryDetail.do"/>?labId=" + labId + param);
        }

        function coverOnOff() {
            var status = $('#cover').val();
            $('#cover').val(status == 'on' ? 'off' : 'on');
            searchLab();
        }

        function drawCoverImg(status) {
            if(status == 'on'){
                var html = '';
                    <c:forEach items="${labList}" var="lab">
                        html += '<div class=\'col-lg-3 col-md-4 col-sm-6\'>'+
                                    '<div class=\'lablist_inner\'>'+
                                        '<div class=\'lablist_box\' onclick="javascript:goLabDetail(\'${lab.labId}\');">'+
                                            '<span>'+
                                                <c:if test="${lab.coverFileId ne null}">
                                                    '<img style=\'height: 126.78px;\' src=\'<c:url value="/servlet/image/lab.do?fileid=${lab.coverFileId}"/>\'/>'+
                                                </c:if>
                                                <c:if test="${lab.coverFileId eq null}">
                                                '<img style=\'height: 126.78px;\' src=\'<c:url value="/share/img/common/lab_default_cover.png"/>\'/>'+
                                                </c:if>
                                            '</span>'+
                                            '<a style=\'background: #545454;\' href=\'javascript:goLabDetail("${lab.labId}");\'><em style=\'color: #ffffff;\'>${language == "en" ? lab.engNm : lab.korNm}</em></a>'+
                                            '<p>${language == "en" ? lab.engKeyword : lab.korKeyword}</p>'+
                                            '<em class=\'lab_r ${lab.labId}\'>${language == "en" ? lab.userEngNm : lab.userKorNm}</em>'+
                                        '</div>'+
                                    '</div>'+
                                '</div>';
                    </c:forEach>
                $('.row').html(html);
                $(".cover_btn").prop("checked",true);
                $(".row").removeClass('dept_list');
            }else if(status == 'off'){
                var html = '';
                    <c:forEach items="${labList}" var="lab">
                        html += '<div class="col-lg-3">'+
                                    '<a href="javascript:goLabDetail(\'${lab.labId}\');">'+
                                        '<span>${language == "en" ? lab.engNm : lab.korNm}</span>'+
                                    '</a>'+
                                '</div>';
                    </c:forEach>
                $('.row').html(html);
                $(".cover_btn").removeAttr("checked");
                $(".row").addClass('dept_list');
            }
        }
        function searchLab() {
            $('.frm').submit();
        }

        function goPage(page){
            $('#page').val(page);
            searchLab();
        }

    </script>
    <style type="text/css">
        a {
            color: #000000;
        }
        .result_title, .st_left label{
            position: relative;
            top: 3px;
        }
    </style>
</head>
<body>
<div class="sub_container">
    <form class="frm" action="<c:url value="/share/laboratory/laboratorys.do"/>" method="get">
        <div class="sub_title_add">
                <h3 class="result_title" style="margin-right: 15px;"><spring:message code="disc.lab.lab.title"/></h3>
                <input type="checkbox" class="cover_btn" id="cover_btn" onclick="javascript:coverOnOff();" style="margin-top: -2px; -webkit-transform: scale(1.5); "/>
                <label for="cover_btn" style="margin-top: 3px;"><spring:message code="disc.lab.cover.btn"/></label>
            <div class="st_right">
                <input type="hidden" id="page" name="page" value="1">
                <input type="hidden" id="cover" name="cover" value="off">
                <span class="sel_type">
                    <select id="dept" name="dept" class="form-control" onchange="searchLab()">
                        <option value="all">${language == 'en' ? 'All' : '전체'}</option>
                        <c:set value="${language == 'en' ? engDeptList : korDeptList}" var="deptList"/>
                        <c:forEach items="${deptList}" var="dept" varStatus="status">
                            <option value="${dept.deptCode}" <c:if test="${deptCode eq dept.deptCode}">selected</c:if>>
                            ${language == 'en' ? dept.deptEngAbbr : dept.deptKorNm}
                            </option>
                        </c:forEach>
                    </select>
                </span>
                <span class="top_int_type">
                        <input type="text" id="keyword" name="keyword" class="form-control" onkeydown="if (event.keyCode == 13) searchLab();"/>
                </span>
                <a onclick="searchLab();" class="lab_search_bt">search</a>
            </div>
        </div>
    </form>
    <div class="row" style="margin-top: 0px;">
        <!-- 연구실 정보 -->

    </div>

    <!-- 페이지 -->
    <div class="paging_nav" style="padding-top: 20px;"></div>
    <a id="toTop" href="#">상단으로 이동</a>
</div><!-- sub_container : e -->
</body>