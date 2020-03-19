<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<head>
<%@include file="../pageInit.jsp" %>
<style>
.jqstooltip {width:35px; height: 40px;} /* 차트 mouseover 창 넓이 높이 */
.kor_dept_card { height: 152px; }
.input-group .form-control {width : auto;}
.researcher_info_top dl .ra_dd {font-weight: bold;}
.researcher_card {border:1.5px solid #d9d9d9;}
</style>
<script type="text/javascript">

	$(function () {
        //대메뉴 researcher에 형광색 들어오게하기
        $("#bigResearcher").addClass("on");

        var pageClass = [];
        var pageNm = [];

        <c:forEach items="${pageList}" var="pages">
			pageClass.push('${pages.classNm == null ? "null" : pages.classNm}');
			pageNm.push(${pages.page});
        </c:forEach>

		if('${searchType}' != 'browse'){
            $("#selectBtn").html( $("#${searchType}").text()+'<span class="sel_arrow"></span>');
        }else{
			$("#${fn:replace(searchName,'\"','\\\"')}").addClass("on");
        }

        if(${totalUser} > 0){
        	<c:if test="${language eq 'en'}">
				$(".page_num_box").text("${ps} - ${end} out of "+"${totalUser}".replace(/\B(?=(\d{3})+(?!\d))/g, ",")+" results");
			</c:if>
			<c:if test="${language eq 'ko'}">
				$(".page_num_box").text("${ps} - ${end}건 / "+"${totalUser}".replace(/\B(?=(\d{3})+(?!\d))/g, ",")+"건");
			</c:if>
        }

        $('.mouseoverdemo').bind('sparklineRegionChange', function(ev) {
            var sparkline = ev.sparklines[0],
                region = sparkline.getCurrentRegionFields(),
                value = region[0].value;
        });

        $('.mouseoverdemo').sparkline('html', { enableTagOptions: true , tooltipFormat: '{{value}}', barWidth: 2 });


        drawPages(pageClass, pageNm);

		$('img.lazy').each(function() {
			var $img = $(this);
			$img.attr('src', $img.data('src'));
		});
    });

	function selectBox(selectedId){
	    $("#selectBtn").html($("#"+selectedId).text()+'<span class="sel_arrow"></span>');
	}


    function goUsers(searchType, searchName, page){
        $(location).attr('href',"${pageContext.request.contextPath}/share/user/users.do?searchType="+searchType+"&searchName="+encodeURIComponent(searchName)+"&page="+page);
    }

	function userSearch(){
        var searchValue = $("#userSearchTxt").val();
        var searchType;

        for(var i = 0; i< $(".form_search_wrap a").length; i++){
            if($(".form_search_wrap a").eq(i).text() == $("#selectBtn").text()){
                searchType = $(".form_search_wrap a").eq(i).attr("id");
            }
        }

		//아무것도 입력되지 않았을 경우
		if(searchValue.trim().length == 0){
            $(location).attr("href","${pageContext.request.contextPath}/share/user/users.do");
		}else{
            goUsers(searchType, $("#userSearchTxt").val(), "1");
        }
	}

    //페이지 그리기
    function drawPages(pageClass, pageNm){
        var span = 1;
        var searchName = "${fn:replace(searchName,'\"','\\\"')}";
        var searchType = "${searchType}";
        var currentPage = "${page}";

        //페이징
        for(var i=0; i<pageClass.length; i++){
            //처음, 다음, 이전, 이후 페이지
            if(pageClass[i] != 'null') {
                $(".paging_nav").append(" <a class='page_select "+pageClass[i]+"' href='javascript:goUsers(\""+ searchType +"\",\""+ searchName +"\",\""+pageNm[i]+"\")'></a> ");
            }else{
                //페이지 숫자표기
                if(span != 0){
                    $(".paging_nav").append(" <span style='margin-left: 0px;'></span> ");
                    span--;
                }

                if(currentPage == pageNm[i]){
                    $(".paging_nav span").append(" <strong>"+pageNm[i]+"</strong>");
                }else{
                    $(".paging_nav span").append(" <a href='javascript:goUsers(\""+ searchType +"\",\""+ searchName +"\",\""+pageNm[i]+"\")'>"+pageNm[i]+"</a>");
                }
            }
        }
    }


</script>
</head>
<body><!--nav_wrap : e  -->
<div class="top_search_wrap">
	<div class="form_search_wrap">
		<span class="fs_title al_left" <c:if test="${language ne 'en'}">style="padding-left:55px;"</c:if> ><spring:message code="disc.rsch.rsch.title"/></span>
		<div class="form_dropdown">
			<div class="btn-group">
				<button type="button" class="btn btn-default dropdown-toggle" id="selectBtn" data-toggle="dropdown" aria-expanded="false" <%--style="width:186px"--%>><spring:message code="disc.search.filter.all"/><span class="sel_arrow"></span></button>
				<ul class="dropdown-menu" role="menu">
					<li><a href="javascript:selectBox('everything')" id="everything"><spring:message code="disc.search.filter.all"/></a></li>
					<li><a href="javascript:selectBox('name')" id="name"><spring:message code="disc.search.filter.name"/></a></li>
					<li><a href="javascript:selectBox('area')" id="area"><spring:message code="disc.search.filter.research"/></a></li>
					<li><a href="javascript:selectBox('wosSub')" id="wosSub"><spring:message code="disc.search.filter.wos.subject"/></a></li>
					<li><a href="javascript:selectBox('keyword')" id="keyword"><spring:message code="disc.search.filter.keyword"/></a></li>
				</ul>
			</div>
		</div>
		<div class="search_field_box"<%-- style="margin:0 0 0 325px"--%>>
			<input type="text" class="sf_int" placeholder="<spring:message code='disc.placeholder.researcher'/>" id="userSearchTxt" onkeydown="event.keyCode == 13 ? userSearch():''" maxlength="100" value="<c:out value="${searchType != 'browse' ? searchName : ''}"/>"/>
			<button type="button" class="fs_bt" onclick="userSearch()"></button>
		</div>
	</div>
	<div class="browse_alphabet">
		<c:choose>
			<c:when test="${language == 'en'}">
				<c:set var="alphabet">A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z</c:set>
			</c:when>
			<c:otherwise>
				<c:set var="alphabet">가,나,다,라,마,바,사,아,자,차,카,타,파,하</c:set>
			</c:otherwise>
		</c:choose>
		<a id="all" href="javascript:goUsers('','','');" style="width: ${language eq 'en' ? '32px' : '38px'}"><spring:message code="disc.search.filter.all"/></a><c:forTokens items="${alphabet}" delims="," var="letter"><a href="javascript:goUsers('browse','${letter}','1');" id="${letter}">${letter}</a></c:forTokens>
	</div>
</div>

<div class="sub_container">
	<div class="list_top_box mgb_0">
		<p class="${totalUser > 0 ? 'page_num_box':''}"></p>
		<h3 style="text-align:center">
			<c:if test="${totalUser == 0}">
				<spring:message code="disc.display.nodata"/>
			</c:if>
		</h3>
	</div>

	<div class="row">
	<c:forEach items="${userList}" var="user" varStatus="st">
		<div class="col-lg-3 col-md-4 col-sm-6">
			<div class="researcher_card kor_dept_card">
				<div class="researcher_info_top">
					<span class="researcher_img ${user.profPhotoFileId == null ? 'none_img' : ''}">
						<c:if test="${user.profPhotoFileId != null}">
							<img class="lazy" src="${contextPath}/share/img/background/researcher_list_icon.png"
								 data-src="${contextPath}/rims/servlet/image/profile.do?fileid=<c:out value="${user.profPhotoFileId}"/>"/>
						</c:if>
					</span>
					<dl>
						<form action="userDetail.do" method="get">
							<input type="hidden" name="id" value="<c:out value="${user.encptUserId}"/>">
							<dt><a href="#" onclick="$(this).closest('form').submit()"><c:out value='${language=="en"? user.engNm : user.korNm}' escapeXml="false"/></a></dt>
						</form>
						<dd class="dept_dd" id="dept"><c:out value='${language=="en"? user.abbrName : user.deptKor}' escapeXml="false"/></dd>
						<dd class="ra_dd"><c:out value='${language=="en"? (user.majorEng1 != null ? user.majorEng1 : "&nbsp;") : (user.majorKor1 != null ? user.majorKor1 : "&nbsp;")}' escapeXml="false"/></dd>
					</dl>
				</div>
				<div class="article_year_wrap">
					<div class="article_year_box"><!-- 샘플 차트 영역-->
						<span class="g_year_t" style="padding-top: 6px;"><c:out value="${fn:substring(user.fromYm,0,4)}"/></span>
						<span class= '${user.fromYm eq null ? "": "mouseoverdemo"}' sparkType="bar" sparkBarColor="#888"><c:out value="${user.numOfArticle}"/></span>
						<span class="g_year_t"><c:out value="${fn:substring(user.toYm,0,4)}"/></span>
					</div>
				</div>
			</div>
		</div>
	</c:forEach>
	</div>

	<a id="toTop" href="#">상단으로 이동</a>

	<div class="paging_nav" style="padding-top: 20px;"></div>
</div>
<!-- sub_container : e -->
</body>