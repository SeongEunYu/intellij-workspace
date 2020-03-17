<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<head>
<%@include file="../pageInit.jsp" %>
<style>
	.search_field_box{margin-left: 304px; border-left:none;}
	.fs_title{width: 162px;}
	.less_arrow {display: block; border-bottom: 1px solid #ddd; height: 26px; background: url(../img/background/up_arrow.png) no-repeat 50% 50%;text-indent: -99999px;margin-top: 5px; }
	.less_arrow:hover  { border-bottom: 1px solid #999;}
</style>
<script type="text/javascript">
	var sort = "${sort}";
	var order = "${order}";
	var filterItem = [];

	$(function () {
        if (!Array.prototype.includes) {
            Object.defineProperty(Array.prototype, "includes", {
                enumerable: false,
                value: function(obj) {
                    var newArr = this.filter(function(el) {
                        return el == obj;
                    });
                    return newArr.length > 0;
                }
            });
        }

		<c:forEach var="item" items="${filterItem}">
			filterItem.push("${item}");
			<c:if test="${fn:split(item,':')[0] == 'class'}">
     			$(".classList").addClass("active");
			</c:if>
			<c:if test="${fn:split(item,':')[0] == 'pub'}">
				$(".pubList").addClass("active");
			</c:if>
			<c:if test="${fn:split(item,':')[0] == 'wosSub'}">
				for(var i=0; i<$(".wosSubList").length; i++){
					if($(".wosSubList a").eq(i).text() == '${fn:replace(item,"wosSub:","")}') $(".wosSubList").eq(i).addClass("active");
				}
			</c:if>
		</c:forEach>

		//대메뉴 형광색 들어오게하기
		$("#bigOutput").addClass("on");

		//sort화살표 표시
		$("#"+sort).addClass(order.slice(0,-1)+"_type");
		$("#"+sort).css("font-weight","bold");

		//페이징 변수 초기화
		var pageClass = [];
		var pageNm = [];

		<c:forEach items="${pageList}" var="pages">
		pageClass.push('${pages.classNm == null ? "null" : pages.classNm}');
		pageNm.push(${pages.page});
		</c:forEach>

		$("#selectBtn").html( $("#${searchType}").text()+'<span class="sel_arrow"></span>');


		if(${totalArticle} > 0){
			<c:if test="${language eq 'en'}">
				$(".page_num_box").text("${ps}".replace(/\B(?=(\d{3})+(?!\d))/g, ",")+" - "+"${end}".replace(/\B(?=(\d{3})+(?!\d))/g, ",")+" out of "+"${totalArticle}".replace(/\B(?=(\d{3})+(?!\d))/g, ",")+" results");
			</c:if>
			<c:if test="${language eq 'ko'}">
				$(".page_num_box").text("${ps}".replace(/\B(?=(\d{3})+(?!\d))/g, ",")+" - "+"${end}".replace(/\B(?=(\d{3})+(?!\d))/g, ",")+"건 / "+"${totalArticle}".replace(/\B(?=(\d{3})+(?!\d))/g, ",")+"건");
			</c:if>
		}

		drawPages(pageClass, pageNm);
	});

	function selectBox(selectedId){
		$("#selectBtn").html($("#"+selectedId).text()+'<span class="sel_arrow"></span>');
	}


	function goArticles(searchType, searchName, page){
		var addr = "searchType="+searchType+"&searchName="+encodeURIComponent(searchName)+"&page="+page+"&sort="+sort+"&order="+order;
		for(var i=0; i<filterItem.length; i++){
            if(filterItem[i] != '') addr += "&filterItem="+encodeURIComponent(filterItem[i]);
		}

		$(location).attr('href',"${pageContext.request.contextPath}/share/article/articles.do?"+addr);
	}

	function articleSearch(){
		var searchValue = $("#articleSearchTxt").val();
		var searchType;

		for(var i = 0; i< $(".form_search_wrap a").length; i++){
			if($(".form_search_wrap a").eq(i).text() == $("#selectBtn").text()){
				searchType = $(".form_search_wrap a").eq(i).attr("id");
			}
		}

		//아무것도 입력되지 않았을 경우
		if(searchValue.trim().length == 0){
			$(location).attr("href","${pageContext.request.contextPath}/share/article/articles.do");
		}else{
			//검색 버튼 눌렀을 시 패싯 해제
			filterItem=[];
			goArticles(searchType, $("#articleSearchTxt").val(), "1");
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
				$(".paging_nav").append(" <a class='page_select "+pageClass[i]+"' href='javascript:goArticles(\""+ searchType +"\",\""+ searchName +"\",\""+pageNm[i]+"\")'></a> ");
			}else{
				//페이지 숫자표기
				if(span != 0){
					$(".paging_nav").append(" <span style='margin-left: 0px;'></span> ");
					span--;
				}

				if(currentPage == pageNm[i]){
					$(".paging_nav span").append(" <strong>"+pageNm[i]+"</strong>");
				}else{
					$(".paging_nav span").append(" <a href='javascript:goArticles(\""+ searchType +"\",\""+ searchName +"\",\""+pageNm[i]+"\")'>"+pageNm[i]+"</a>");
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
			if(inSortNm == "title")  order = "asc";
			if(inSortNm == "tc")  order = "desc";
		}

		goArticles("${searchType}","${fn:replace(searchName,'\"','\\\"')}","1");
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

		goArticles("${searchType}","${fn:replace(searchName,'\"','\\\"')}","1");
	}

	function filterWos(val){
		// 한번 클릭 되어있는지 확인
        if(filterItem.includes("wosSub:"+val)){
            filterItem.splice(filterItem.indexOf("wosSub:"+val),1);
        }else{
            filterItem.push("wosSub:"+val);
        }

		goArticles("${searchType}","${fn:replace(searchName,'\"','\\\"')}","1");
	}

	function plusBtn(id){
		if($(".wosSubList.more").hasClass("hidden")){
			$(".wosSubList.more").removeClass("hidden");
			$("#"+id).removeClass("more_arrow");
			$("#"+id).addClass("less_arrow");
		}else{
			$(".wosSubList.more").addClass("hidden");
			$("#"+id).removeClass("less_arrow");
			$("#"+id).addClass("more_arrow");
		}
	}

</script>
<link rel="stylesheet" type="text/css" href="<c:url value="/share/css/mquery.css"/>" />
</head>
<body><!--nav_wrap : e  -->
<div class="top_search_wrap">
	<div class="form_search_wrap"<%-- style="width: 780px;"--%>>
		<span class="fs_title"><spring:message code="disc.otpt.art.title"/></span>
		<div class="form_dropdown">
			<div class="btn-group">
				<button type="button" class="btn btn-default dropdown-toggle" id="selectBtn" data-toggle="dropdown" aria-expanded="false"></button>
				<ul class="dropdown-menu" role="menu">
					<li><a href="javascript:selectBox('everything')" id="everything"><spring:message code="disc.search.filter.all"/></a></li>
					<li><a href="javascript:selectBox('artTitle')" id="artTitle"><spring:message code="disc.search.filter.article"/></a></li>
					<li><a href="javascript:selectBox('journal')" id="journal"><spring:message code="disc.search.filter.journal"/></a></li>
					<li><a href="javascript:selectBox('issn')" id="issn"><spring:message code="disc.search.filter.issn"/></a></li>
					<li><a href="javascript:selectBox('keywordAth')" id="keywordAth"><spring:message code="disc.search.filter.keyword"/></a></li>
				</ul>
			</div>
		</div>
		<div class="search_field_box">
			<input type="text" class="sf_int" placeholder="<spring:message code='disc.placeholder.article'/>" id="articleSearchTxt" onkeydown="event.keyCode == 13 ? articleSearch():''" maxlength="100" value="<c:out value="${searchType == 'class' ? '' : (searchType == 'pblc_y'? '' : searchName)}"/>"/>
			<button type="button" class="fs_bt" onclick="articleSearch()"></button>
		</div>
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
							<c:if test="${fn:length(facetMapList[0]) > 0}">
								<div class="discover_box">
									<h4><span><spring:message code="disc.facet.journal"/></span></h4>
									<ul>
										<c:if test="${!empty facetMapList[0]['10']}">
											<li class="classList 10">
												<a href="javascript:filter('class','10');">SCI(WOS)</a>
												<span><fmt:formatNumber value="${facetMapList[0]['10']}" pattern="#,###"/></span>
											</li>
										</c:if>
										<c:if test="${!empty facetMapList[0]['15']}">
											<li class="classList 15">
												<a href="javascript:filter('class','15');">SCOPUS</a>
												<span><fmt:formatNumber value="${facetMapList[0]['15']}" pattern="#,###"/></span>
											</li>
										</c:if>
										<c:if test="${!empty facetMapList[0]['20']}">
											<li class="classList 20">
												<a href="javascript:filter('class','20');">국제일반학술지</a>
												<span><fmt:formatNumber value="${facetMapList[0]['20']}" pattern="#,###"/></span>
											</li>
										</c:if>
										<c:if test="${!empty facetMapList[0]['30']}">
											<li class="classList 30">
												<a href="javascript:filter('class','30');">국내전문학술지</a>
												<span><fmt:formatNumber value="${facetMapList[0]['30']}" pattern="#,###"/></span>
											</li>
										</c:if>
										<c:if test="${!empty facetMapList[0]['40']}">
											<li class="classList 40">
												<a href="javascript:filter('class','40');">국내일반학술지</a>
												<span><fmt:formatNumber value="${facetMapList[0]['40']}" pattern="#,###"/></span>
											</li>
										</c:if>
									</ul>
								</div>
							</c:if>
							<c:if test="${fn:length(facetMapList[1]) > 0}">
								<div class="discover_box">
									<h4><span><spring:message code="disc.facet.pub.year"/></span></h4>
									<ul>
										<c:forEach var="pub" items="${facetMapList[1]}" varStatus="stat">
											<c:if test="${stat.index < 10}">
												<li class="pubList ${pub.key}"><a href="javascript:filter('pub','${pub.key}');">${pub.key}</a><span><fmt:formatNumber value="${pub.value}" pattern="#,###"/></span></li>
											</c:if>
										</c:forEach>
									</ul>
								</div>
							</c:if>
							<c:if test="${fn:length(facetMapList[2]) > 0}">
								<div class="discover_box">
									<h4><span><spring:message code="disc.facet.wos.keyword"/></span></h4>
									<ul>
										<c:forEach var="wosSub" items="${facetMapList[2]}" varStatus="stat">
											<c:if test="${fn:replace(fn:replace(fn:replace(wosSub.key,',','442C'),'&','3826'),' ','') ne ''}">
												<li class="wosSubList ${fn:replace(fn:replace(fn:replace(wosSub.key,',','442C'),'&','3826'),' ','')}  ${stat.index > 9 ? 'more hidden' : ''}">
													<a href="javascript:filterWos('${wosSub.key}');">${wosSub.key}</a>
													<span><fmt:formatNumber value="${wosSub.value}" pattern="#,###"/></span>
												</li>
											</c:if>
										</c:forEach>
									</ul>
									<c:if test="${fn:length(facetMapList[2]) > 10}">
										<a href="javascript:plusBtn('wos');" class="more_arrow" id="wos">more</a>
									</c:if>
								</div>
							</c:if>
						</div><!-- right side -->
					</div>
				</div>

				<div class="left_list_box">
					<div class="list_top_box">
						<p class="page_num_box"></p>
						<div class="list_sort_box">
							<ul>
								<li><i><span style="padding-right: 30px;"><spring:message code="disc.sort.sort"/></span></i><a href="javascript:sortTab('date')" id="date" style="display: inline;"><span><spring:message code="disc.sort.date"/></span><em>정렬</em></a></li>
								<li><a href="javascript:sortTab('tc')" id="tc"><span><spring:message code="disc.sort.citation"/></span><em>정렬</em></a></li>
								<li><a href="javascript:sortTab('title')" id="title"><span><spring:message code="disc.sort.title"/></span><em>정렬</em></a></li>
							</ul>
						</div>
					</div>

					<c:forEach items="${articleList}" var="article">
						<div class="article_list_box">
							<div class="alb_text_box">
								<div data-badge-popover="right" data-link-target='_blank' style="float:right;" data-badge-type="donut" data-doi="<c:out value='${article.doi}'/>" data-hide-no-mentions="true" class="altmetric-embed"></div>
								<a class="al_title" href="${pageContext.request.contextPath}/share/article/articleDetail.do?id=<c:out value='${article.articleId}'/>" target="_self"> <c:out value="${article.orgLangPprNm}"/><img src="<c:url value="/share/img/icon/oa_icon.png"/>" alt="open_access" style="padding-left: 5px; display: ${article.openAccesAt == 'Y' ? '' : 'none' }"></a>
								<p>${article.content}</p>
								<c:if test="${article.tc + article.scpTc + article.kciTc > 0}">
									<div class="list_r_info">
										<ul>
											<c:if test="${article.tc != null && article.tc != 0}"><li>SCI<span><c:out value="${article.tc}"></c:out></span></li></c:if>
											<c:if test="${article.scpTc != null && article.scpTc != 0}"><li class="l_scopus">SCOPUS<span><c:out value="${article.scpTc}"></c:out></span></li></c:if>
											<c:if test="${article.kciTc != null && article.kciTc != 0}"><li class="l_kci">KCI<span><c:out value="${article.kciTc}"></c:out></span></li></c:if>
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