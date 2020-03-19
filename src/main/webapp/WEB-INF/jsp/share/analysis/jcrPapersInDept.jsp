<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<head>
<%@include file="../pageInit.jsp" %>

<style>
	.keyword_info ol li { margin-right: 20px;  color: #FA8072;font-size: 13px; padding: 0 0 0 14px;  }
	.list_r_info .ri_less { display: block; width:19px; height: 19px;background: url(../img/background/ti_minus.png) no-repeat 0 0px;  text-indent: -9999px; position: absolute; right:2px; top:2px;   }
</style>
<script type="text/javascript">
	var sort = "${sort}";
	var order = "${order}";
	var filterItem = [];

	$(function () {
		//대메뉴 researcher에 형광색 들어오게하기
		$("#bigAnalysis").addClass("on");

		$("#ratio").val("${ratio}".replace(".0",""));

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
        categorySizing();
	});

    $(window).resize(function(){
        categorySizing();
    })

	function categorySizing(){
        var width_size = window.outerWidth;

        if(width_size <= 1220){
            $("#category").removeAttr("style");
        }else{
            $("#category").css("width","361px");
        }
	}

	function goJCR(page){
		$(location).attr('href','${pageContext.request.contextPath}/share/article/jcrPapersInDept.do?prodyear='+$("#prodyear").val()+'&category='+$("#category").val()+'&categoryNm='+$("#"+$("#category").val()).text()+'&dept='+$("#dept").val()+'&ratio='+$("#ratio").val()+'&page='+page+'&sort='+sort+'&order='+order);

        $(".wrap-loading").css('display','');
	}

	function changeSelect(){
		$(location).attr('href','${pageContext.request.contextPath}/share/article/jcrPapersInDept.do?prodyear='+$("#prodyear").val()+'&category='+$("#category").val()+'&categoryNm='+$("#"+$("#category").val()).text()+'&dept='+$("#dept").val()+'&ratio='+$("#ratio").val());

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
				$(".paging_nav").append(" <a class='page_select "+pageClass[i]+"' href='javascript:goJCR(\""+pageNm[i]+"\")'></a> ");
			}else{
				//페이지 숫자표기
				if(span != 0){
					$(".paging_nav").append(" <span style='margin-left: 0px;'></span> ");
					span--;
				}

				if(currentPage == pageNm[i]){
					$(".paging_nav span").append(" <strong>"+pageNm[i]+"</strong>");
				}else{
					$(".paging_nav span").append(" <a href='javascript:goJCR(\""+pageNm[i]+"\")'>"+pageNm[i]+"</a>");
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

		goJCR("1");
	}

	function filter(type, val){
		var elem = $("."+type+"List");
		// 한번 클릭 되어있는지 확인
		if(elem.hasClass("on")){
			for(var i=0; i<filterItem.length; i++){
				if(filterItem[i] == type+":"+val){
					filterItem.splice(i,1);
					break;
				}
			}

		}else{
			filterItem.push(type+":"+val);
		}

		goJCR("1");
	}

	function catMoreLess(artIdx){
		if($("#catDiv"+artIdx).find("a").hasClass("ri_more")){
			$("#catDiv"+artIdx).find("a").attr("class","ri_less");
			$("#catDiv"+artIdx).find(".hidden").removeClass("hidden");

		}else{
			$("#catDiv"+artIdx).find("a").attr("class","ri_more");

			for(var i=1; i<$("#catDiv"+artIdx).find("ol").length; i++){
				$("#catDiv"+artIdx).find("ol").eq(i).addClass("hidden");
			}

		}
	}
</script>
</head>
<body><!--nav_wrap : e  -->
<div class="top_search_wrap">
	<div class="ts_title">
		<%--<h3><spring:message code="disc.anls.topif.title"/></h3>--%>
		<h3>Top papers by IF</h3>
	</div>
	<div class="ts_text_box">
		<div class="ts_text_inner">
			<p>
				<%--<span  style="font-weight:bold;"><spring:message code="disc.anls.topif.desc"/></span>--%>
				<span  style="font-weight:bold;">저널 영향력 지수(JIF)가 주제별로 상위 1%~20%안에 드는 중앙대학교 논문 정보를 제공합니다. </span>
				<br>
				<span>(출처: Journal Citation Report by CLARIVATE ANALYTICS)</span>
			</p>
		</div>
	</div>
	<div class="search_select_option">
		<ul>
			<li class="sel_col_4">
				<span class="sel_label"><spring:message code="disc.search.filter.department"/></span>
				<span class="sel_type">
					<select class="form-control" id="dept" onchange="changeSelect()">
						<option value="All"><spring:message code="disc.search.filter.option.all"/></option>
						<c:if test="${fn:length(deptVoList) > 0}">
							<c:forEach items="${deptVoList}" var="deptVo">
								<option value="${deptVo.deptCode}" ${deptVo.deptCode == dept ? 'selected=selected' : ''}>${language == 'en'? deptVo.deptEngAbbr : deptVo.deptKorNm}</option>
							</c:forEach>
						</c:if>
					</select>
				</span>
			</li>
			<li class="sel_col_4">
				<span class="sel_label"><spring:message code="disc.search.filter.ratio"/></span>
				<span class="sel_type">
					<select class="form-control" id="ratio" onchange="changeSelect()">
						<option value="1">1%</option>
						<option value="10">10%</option>
						<option value="20">20%</option>
					</select>
				</span>
			</li>
			<li class="sel_col_4">
				<span class="sel_label"><spring:message code="disc.search.filter.pub.year"/></span>
				<span class="sel_type">
					<select class="form-control" id="prodyear" onchange="changeSelect()">
						<c:if test="${fn:length(prodyearList) == 0}">
							<option><spring:message code="disc.search.filter.option.nodata"/></option>
						</c:if>
						<c:if test="${fn:length(prodyearList) > 0}">
							<c:forEach items="${prodyearList}" var="pyear" end="4">
								<option value="${pyear}" ${prodyear == pyear ? 'selected=selected' : ''}>${pyear}</option>
							</c:forEach>
						</c:if>
					</select>
				</span>
			</li>
			<li class="sel_col_4">
				<span class="sel_label"><spring:message code="disc.search.filter.category"/></span>
				<span class="sel_type">
					<select class="form-control" id="category" onchange="changeSelect()" style="width: 361px;">
						<option value="All"><spring:message code="disc.search.filter.option.all"/></option>
						<c:if test="${fn:length(categoryList) > 0}">
							<c:forEach items="${categoryList}" var="cat">
								<option id="${cat.ctgryCd}" value="${cat.ctgryCd}" ${cat.ctgryCd == category ? 'selected=selected' : ''}>${cat.ctgryNm}</option>
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
				<div class="">
					<div class="list_top_box">
						<p class="page_num_box"></p>
						<div class="list_sort_box">
							<ul>
								<li><i><span style="padding-right: 30px;">Sort by</span></i><a href="javascript:sortTab('date')" class="as_type" id="date" style="display: inline;"><span><spring:message code="disc.sort.date"/></span><em>정렬</em></a></li>
								<li><a href="javascript:sortTab('tc')" class="des_type" id="tc"><span><spring:message code="disc.sort.citation"/></span><em>정렬</em></a></li>
								<li><a href="javascript:sortTab('title')" class="des_type" id="title"><span><spring:message code="disc.sort.title"/></span><em>정렬</em></a></li>
							</ul>
						</div>
					</div>

						<c:forEach items="${articleList}" var="article" varStatus="artStat">
							<div class="article_list_box">
								<div class="alb_text_box">
									<a class="al_title" href="${pageContext.request.contextPath}/share/article/articleDetail.do?id=<c:out value='${article.articleId}'/>" target="_self"><c:out value="${article.orgLangPprNm}"/></a>
									<p>${article.content}</p>
									<div>
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
									<div>
									<c:if test="${fn:length(article.catname) > 0}">
										<div class="list_r_info keyword_info" ${fn:length(article.catname) == 1 ? 'style="padding-right: 20px;"':''} id="catDiv${artStat.index}">
											<c:if test="${fn:length(article.catname) > 1}">
												<a href="javascript:catMoreLess('${artStat.index}')" class="ri_more">more</a>
											</c:if>
											<div style="background: url(<c:url value="/share/img/background/t_bullet.png"/>) no-repeat 0 7px; padding: 1px 0 0 14px">IF Category Ratio</div>
											<c:forEach items="${article.catname}" varStatus="stat">
												<ol ${stat.index > 0 ? 'class="hidden"':''}>
													<li><c:out value="${article.catname[stat.index]}"></c:out><span style="font-weight:bold;color:#754F44;"> ${fn:endsWith((article.ratio[stat.index]).toString(),".0") ? fn:replace((article.ratio[stat.index]).toString(),".0","") : article.ratio[stat.index]}%</span></li>
												</ol>
											</c:forEach>
										</div>
									</c:if>
									</div>
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