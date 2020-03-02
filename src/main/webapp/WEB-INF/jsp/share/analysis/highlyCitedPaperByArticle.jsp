<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<head>
<%@include file="../pageInit.jsp" %>
</head>
<script type="text/javascript">
    var sort = "${sort}";
    var order = "${order}";
    var filterItem = [];

    $(function () {
        //대메뉴 researcher에 형광색 들어오게하기
        $("#bigAnalysis").addClass("on");
        $("#extractionDate").val('${extractionDate}');
        $("#dept").val('${dept}');

        var field = "${field}".replace(/amp/g, '&');
        $("#field").val(field);

        <c:forEach var="item" items="${filterItem}">
			<c:if test="${item != ''}">
				filterItem.push("${item}");
				$(".${fn:split(item,':')[0]}List.${fn:split(item,':')[1]}").addClass("active");
			</c:if>
        </c:forEach>

        //sort화살표 표시
        $(".list_sort_box a").removeClass();
        $("#"+sort).addClass(order.slice(0,-1)+"_type");
        $("#"+sort).css("font-weight","bold");

        //페이징 변수 초기화
        var pageClass = [];
        var pageNm = [];

        <c:forEach items="${pageList}" var="pages">
			pageClass.push('${pages.classNm == null ? "null" : pages.classNm}');
			pageNm.push(${pages.page});
        </c:forEach>

        if(${totalArticle} > 0){
			<c:if test="${language eq 'en'}">
				$(".page_num_box").text("${ps}".replace(/\B(?=(\d{3})+(?!\d))/g, ",")+" - "+"${end}".replace(/\B(?=(\d{3})+(?!\d))/g, ",")+" out of "+"${totalArticle}".replace(/\B(?=(\d{3})+(?!\d))/g, ",")+" results");
			</c:if>
			<c:if test="${language eq 'ko'}">
				$(".page_num_box").text("${ps}".replace(/\B(?=(\d{3})+(?!\d))/g, ",")+" - "+"${end}".replace(/\B(?=(\d{3})+(?!\d))/g, ",")+"건 / "+"${totalArticle}".replace(/\B(?=(\d{3})+(?!\d))/g, ",")+"건");
			</c:if>
        }

        drawPages(pageClass, pageNm);
        extDateSizing();
    });

    $(window).resize(function(){
        extDateSizing();
	})

	function extDateSizing(){
        var width_size = window.outerWidth;

        if(width_size <= 1220){
            $("#extDate").removeAttr("style");
        }else{
            $("#extDate").css("width","395px");
        }
	}

    function goByArticle(page){
        $(location).attr('href',"${pageContext.request.contextPath}/share/article/highlyCitedPaperByArticle.do?extractionDate="+$("#extractionDate").val()+"&field=${field}"+"&dept="+$("#dept").val()+"&page="+page+"&sort="+sort+"&order="+order+"&filterItem="+filterItem);
    }

    function changeSelect(type){
        var dept = 'All';// & 변환
        var field = $("#field").val().replace(/&/g, 'amp');

        if(type == 'dept'){
            dept = $("#dept").val();
		}

        $(location).attr('href',"${pageContext.request.contextPath}/share/article/highlyCitedPaperByArticle.do?extractionDate="+$("#extractionDate").val()+"&field="+field+"&dept="+dept);

        $(".wrap-loading").css('display','');
    }

    //페이지 그리기
    function drawPages(pageClass, pageNm){
        var span = 1;
        var currentPage = "${page}";

        //페이징
        for(var i=0; i<pageClass.length; i++){
            //처음, 다음, 이전, 이후 페이지
            if(pageClass[i] != 'null') {
                $(".paging_nav").append(" <a class='page_select "+pageClass[i]+"' href='javascript:goByArticle(\""+pageNm[i]+"\")'></a> ");
            }else{
                //페이지 숫자표기
                if(span != 0){
                    $(".paging_nav").append(" <span style='margin-left: 0px;'></span> ");
                    span--;
                }

                if(currentPage == pageNm[i]){
                    $(".paging_nav span").append(" <strong>"+pageNm[i]+"</strong>");
                }else{
                    $(".paging_nav span").append(" <a href='javascript:goByArticle(\""+pageNm[i]+"\")'>"+pageNm[i]+"</a>");
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

            if(inSortNm == "date")  order = "desc";
            if(inSortNm == "tc")  order = "desc";
            if(inSortNm == "title")  order = "asc";
        }

        goByArticle("1");
    }

    function filter(type, val){
        var elem = $("."+type+"List");
        // 한번 클릭 되어있는지 확인
        if(elem.hasClass("active")){
            for(var i=0; i<filterItem.length; i++){
                if(filterItem[i] == type+":"+val){
                    filterItem.splice(i,1);
                    break;
                }
            }

        }else{
            filterItem.push(type+":"+val);
        }

        goByArticle("1");
    }

</script>
<body><!--nav_wrap : e  -->
	<div class="top_search_wrap">
		<div class="ts_title ts_add_line">
			<h3><spring:message code="disc.anls.toprf.title"/><span>${fn:replace(fn:trim(field),'amp','&')}</span></h3>
			<a href="javascript:history.go(-1);" class="prev_bt"><spring:message code="disc.anls.toprf.article.prev"/></a>
		</div>

		<div class="search_select_option">
			<ul>
				<li>
					<span class="sel_label"><spring:message code="disc.search.filter.extraction.date"/></span>
					<span class="sel_type" style="width: 395px;" id="extDate">
						<select id="extractionDate" class="form-control" onchange="changeSelect('date');">
							<c:if test="${fn:length(dateList) == 0}">
								<option><spring:message code="disc.search.filter.option.nodata"/></option>
							</c:if>
							<c:if test="${fn:length(dateList) > 0}">
								<c:forEach items="${dateList}" var="date">
									<option value="${date.extractionDate}:${date.periodFrom}:${date.periodTo}"><spring:message code="disc.search.filter.option.extraction.date"/>: ${date.extractionDate} (<spring:message code="disc.search.filter.option.target.date"/>: ${date.periodFrom} ~ ${date.periodTo})</option>
								</c:forEach>
							</c:if>
						</select>
			</span>
				</li>
				<li>
					<span class="sel_label"><spring:message code="disc.search.filter.areas"/></span>
					<span class="sel_type ">
						<select class="form-control" id="field" onchange="changeSelect('field');">
							<c:if test="${fn:length(fieldVoList) == 0}">
								<option><spring:message code="disc.search.filter.option.nodata"/></option>
							</c:if>
							<c:if test="${fn:length(fieldVoList) > 0}">
								<c:forEach items="${fieldVoList}" var="field">
									<option value="${field.rschField}">${field.rschField}</option>
								</c:forEach>
							</c:if>
						</select>
			</span>
				</li>
				<li>
					<span class="sel_label"><spring:message code="disc.search.filter.department"/></span>
					<span class="sel_type">
						<select class="form-control" id="dept" onchange="changeSelect('dept');">
							<option value="All"><spring:message code="disc.search.filter.option.all"/></option>
							<c:if test="${fn:length(deptVoList) > 0}">
								<c:forEach items="${deptVoList}" var="dept">
									<option value="${dept.deptCode}">${language == 'en'? dept.deptEngAbbr : dept.deptKorNm}</option>
								</c:forEach>
							</c:if>
						</select>
					</span>
				</li>
			</ul>

		</div>
	</div>
	<div class="sub_container">
		<div class="add_discover">
			<c:choose>
				<c:when test="${totalArticle == 0}">
					<h3 style="text-align:center">
						<spring:message code="disc.display.nodata"/>
					</h3>
				</c:when>
				<c:otherwise>
					<div class="d_f_sel_wrap">
						<a href="javascript:void(0);" onclick="$('.discovery_facet_s').addClass('d_f_open');" class="d_f_sel_bt">선택</a>
						<div class="discovery_facet_s">
							<div class="right_discover_wrap">
								<div class="d_f_close_box">
									<a onclick="$('.discovery_facet_s').removeClass('d_f_open');" class="d_f_close_bt">닫기</a>
								</div>
								<div class="discover_box">
									<h4><span><spring:message code="disc.facet.pub.date"/></span></h4>
									<ul>
										<c:forEach var="pub" items="${facetMapList[1]}">
											<li class="pubList ${pub.key}"><a href="javascript:filter('pub','${pub.key}');">${pub.key}</a><span><fmt:formatNumber value="${pub.value}" pattern="#,###"/></span></li>
										</c:forEach>
									</ul>
								</div>
							</div><!-- right side -->
						</div>
					</div>

					<div class="left_list_box">
						<div class="list_top_box">
							<p class="page_num_box"></p>
							<div class="list_sort_box">
								<ul>
									<li><i><span style="padding-right: 30px;"><spring:message code="disc.sort.sort"/></span></i><a href="javascript:sortTab('date')" class="as_type" id="date" style="display: inline;"><span><spring:message code="disc.sort.date"/></span><em>정렬</em></a></li>
									<li><a href="javascript:sortTab('tc')" class="des_type" id="tc"><span><spring:message code="disc.sort.citation"/></span><em>정렬</em></a></li>
									<li><a href="javascript:sortTab('title')" class="des_type" id="title"><span><spring:message code="disc.sort.title"/></span><em>정렬</em></a></li>
								</ul>
							</div>
						</div>

						<c:forEach items="${articleList}" var="article">
							<div class="article_list_box">
								<div class="alb_text_box">
									<a class="al_title" href="${pageContext.request.contextPath}/share/article/articleDetail.do?id=<c:out value='${article.articleId}'/>" target="_self"><c:out value="${article.orgLangPprNm}"/></a>
									<p>${article.content}</p>
									<c:if test="${article.tc + article.scpTc + article.kciTc > 0}">
										<div class="list_r_info">
											<ul>
												<c:if test="${article.tc != null}"><li>SCI<span><c:out value="${article.tc}"></c:out></span></li></c:if>
												<c:if test="${article.scpTc != null}"><li class="l_scopus">SCOPUS<span><c:out value="${article.scpTc}"></c:out></span></li></c:if>
												<c:if test="${article.kciTc != null}"><li class="l_kci">KCI<span><c:out value="${article.kciTc}"></c:out></span></li></c:if>
											</ul>
										</div>
									</c:if>
								</div>
								<c:if test="${fn:length(article.keywordList) != 0}">
									<div class="l_keyword_box">
										<span>Keywords</span>
										<c:forEach var="item" items="${article.keywordList}">
											<a href="javascript:searchAll('<c:out value="${fn:trim(item)}"/>');"><c:out value="${fn:trim(item)}"/></a>
										</c:forEach>
									</div>
								</c:if>
							</div>
						</c:forEach>
						<!-- 페이지 -->
						<div class="paging_nav" style="padding-top: 20px;"></div>
					</div><!-- left side -->
				</c:otherwise>
			</c:choose>
		</div>

		<a id="toTop" href="#">상단으로 이동</a>
	</div>
<!-- sub_container : e -->
</body>