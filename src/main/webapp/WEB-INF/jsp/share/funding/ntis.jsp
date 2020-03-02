<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<head>
	<%@include file="../pageInit.jsp" %>
	<style>
		.top_search_wrap {padding: 50px 0 50px 0;}
		.less_arrow {display: block; border-bottom: 1px solid #ddd; height: 26px; background: url(<c:url value="/share/img/background/up_arrow.png"/>) no-repeat 50% 50%;text-indent: -99999px;margin-top: 5px; }
		.less_arrow:hover  { border-bottom: 1px solid #999;}
		.search_field_box {margin-left: 180px;width: 542px;}
		.fs_title {width: 175px; <c:if test="${language eq 'ko'}">font-size: 15px;</c:if>}
	</style>
	<script type="text/javascript">
        var sort = "${sort}";
        var filterItem = "${filterItem}";

        $(function () {
			<c:if test="${language eq 'en'}">
				$(".page_num_box").text("${fn:length(projectList) > 0 ? ps : 0}".replace(/\B(?=(\d{3})+(?!\d))/g, ",")+" - "+"${end}".replace(/\B(?=(\d{3})+(?!\d))/g, ",")+" out of "+"${total}".replace(/\B(?=(\d{3})+(?!\d))/g, ",")+" results");
			</c:if>
			<c:if test="${language eq 'ko'}">
				$(".page_num_box").text("${fn:length(projectList) > 0 ? ps : 0}".replace(/\B(?=(\d{3})+(?!\d))/g, ",")+" - "+"${end}".replace(/\B(?=(\d{3})+(?!\d))/g, ",")+"건 / "+"${total}".replace(/\B(?=(\d{3})+(?!\d))/g, ",")+"건");
			</c:if>

            //대메뉴 형광색 들어오게하기
            $("#bigFunding").addClass("on");

            //sort화살표 표시
            $("#"+sort).addClass("des_type");
            $("#"+sort).css("font-weight","bold");
            ${searchName != '' ? '$("#score").parent().removeClass("hidden");' : ''}

            //페이징 변수 초기화
            var pageClass = [];
            var pageNm = [];

            <c:forEach items="${pageList}" var="pages">
            pageClass.push('${pages.classNm == null ? "null" : pages.classNm}');
            pageNm.push(${pages.page});
            </c:forEach>

            drawPages(pageClass, pageNm);
        });

        function goNtis(searchName, page){
            var addr = "searchName="+encodeURI(searchName)+"&page="+page+"&sort="+sort;
            if(filterItem != "") addr += "&filter="+encodeURI(filterItem);
            $(location).attr('href',"${pageContext.request.contextPath}/share/funding/ntis.do?"+addr);
        }

        function projectSearch(){
            var searchValue = $("#projectSearchTxt").val();

            //아무것도 입력되지 않았을 경우
            if(searchValue.trim().length == 0){
                $(location).attr("href","${pageContext.request.contextPath}/share/funding/ntis.do");
            }else{
                //검색 버튼 눌렀을 시 패싯 해제
                sort = 'score';
                filterItem='';
                goNtis($("#projectSearchTxt").val(), "1");
            }
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
                    $(".paging_nav").append(" <a class='page_select "+pageClass[i]+"' href='javascript:goNtis(\""+ searchName +"\",\""+pageNm[i]+"\")'></a> ");
                }else{
                    //페이지 숫자표기
                    if(span != 0){
                        $(".paging_nav").append(" <span style='margin-left: 0px;'></span> ");
                        span--;
                    }

                    if(currentPage == pageNm[i]){
                        $(".paging_nav span").append(" <strong>"+pageNm[i]+"</strong>");
                    }else{
                        $(".paging_nav span").append(" <a href='javascript:goNtis(\""+ searchName +"\",\""+pageNm[i]+"\")'>"+pageNm[i]+"</a>");
                    }
                }
            }
        }

        //sort a태그 클릭시
        function sortTab(inSortNm){
            sort = inSortNm;
            goNtis("${searchName}","1");
        }

        function filter(val){
            // 한번 클릭 되어있는지 확인
            if($(".categoryList").hasClass("active")){
                filterItem = "";
            }else{
                filterItem = "category:"+val;
            }

            goNtis("${searchName}","1");
        }

        function plusBtn(id){
            if($(".categoryList.more").hasClass("hidden")){
                $(".categoryList.more").removeClass("hidden");
                $("#"+id).removeClass("more_arrow");
                $("#"+id).addClass("less_arrow");
            }else{
                $(".categoryList.more").addClass("hidden");
                $("#"+id).removeClass("less_arrow");
                $("#"+id).addClass("more_arrow");
            }
        }
	</script>
</head>
<body><!--nav_wrap : e  -->
<div class="top_search_wrap">
	<div class="form_search_wrap" style="width: 730px;">
		<span class="fs_title"><a href="http://www.ntis.go.kr" target="_blank"><img src='<c:url value="/share/img/background/ntis.png"/>' style="margin-bottom: 6px;" > <spring:message code="disc.fnd.ntis.title"/></a></span>
		<div class="search_field_box">
			<input type="text" class="sf_int" placeholder="<spring:message code='disc.placeholder.title'/>" id="projectSearchTxt" onkeydown="event.keyCode == 13 ? projectSearch():''" maxlength="100" value="${searchName}" style=" border:0px; height: 30px;">
			<button type="button" class="fs_bt" onclick="projectSearch()"></button>
		</div>
	</div>
	<div class="ts_text_box">
		<div class="ts_text_inner">
			<p style="font-weight:bold;"><spring:message code="disc.fnd.ntis.desc"/></p>
		</div>
	</div>
</div>
<div class="sub_container">
	<div class="add_discover" style="margin-top: 13px;">
		<div class="left_list_box">
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
					<col width="17%">
					<col width="42%">
					<col width="19%">
					<col width="11%">
					<col width="11%">
				</colgroup>
				<thead>
				<tr>
					<th><spring:message code="disc.table.agency"/></th>
					<th><spring:message code="disc.table.opportunity"/></th>
					<th><spring:message code="disc.table.institution.posting"/></th>
					<th><spring:message code="disc.table.date.posted"/></th>
					<th><spring:message code="disc.table.date.closing"/></th>
				</tr>
				</thead>
				<c:if test="${fn:length(projectList) > 0}">
					<tbody>
					<c:forEach items="${projectList}" var="project">
						<tr>
							<td class='al_center'><c:out value="${project.agency != 'null' ? project.agency : ''}"/></td>
							<td class='al_left'><a href="${project.link}" target="_blank"><c:out value="${project.title != 'null' ? project.title : ''}" escapeXml="false"/></a></td>
							<td class='al_center'><c:out value="${project.subject != 'null' ? project.subject : ''}"/></td>
							<td class='al_center' style="padding-left: 0px; padding-right: 0px"><span style="font-size: 13px"><c:out value="${project.postDate != 'null' ? project.postDate : ''}"/></span></td>
							<td class='al_center' style="padding-left: 0px; padding-right: 0px"><span style="font-size: 13px"><c:out value="${project.closeDate != 'null' ? project.closeDate : ''}"/></span></td>
						</tr>
					</c:forEach>
					</tbody>
				</c:if>
			</table>
			<!-- 페이지 -->
			<div class="paging_nav" style="padding-top: 20px;"></div>
		</div><!-- left side -->
		<div class="right_discover_wrap">
			<c:if test="${fn:length(facetList) > 0}">
				<div class="discover_box" style="margin-top: 10px;">
					<h4><span><spring:message code="disc.facet.institution.posting"/></span></h4>
					<ul>
						<c:forEach var="proInst" items="${facetList}" varStatus="stat">
							<li class="categoryList ${stat.index > 9 ? 'more hidden' : ''} ${filterItem != ''? 'active':''}">
								<a href="javascript:filter('${fn:replace(proInst.label,'\\','\\\\')}');">${fn:replace(proInst.label,'\\','')}</a>
								<span><fmt:formatNumber value="${proInst.count}" pattern="#,###"/></span>
							</li>
						</c:forEach>
					</ul>
					<c:if test="${fn:length(facetList) > 10}">
						<a href="javascript:plusBtn('category');" class="more_arrow" id="category">more</a>
					</c:if>
				</div>
			</c:if>
		</div><!-- right side -->
	</div>

	<a id="toTop" href="#">상단으로 이동</a>


</div>
<!-- sub_container : e -->
</body>