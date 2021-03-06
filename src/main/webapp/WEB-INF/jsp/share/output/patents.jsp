<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<head>
	<%@include file="../pageInit.jsp" %>
	<style>
		.search_field_box{margin-left: 223px; border-left:none;}
		.fs_title{width: 80px;}
		.less_arrow {display: block; border-bottom: 1px solid #ddd; height: 26px; background: url(../img/background/up_arrow.png) no-repeat 50% 50%;text-indent: -99999px;margin-top: 5px; }
		.less_arrow:hover  { border-bottom: 1px solid #999;}
	</style>
	<script type="text/javascript">
        var sort = "${sort}";
        var order = "${order}";
        var filterItem = [];

        $(function () {
            <c:forEach var="item" items="${filterItem}">
				<c:if test="${item != ''}">
            		filterItem.push("${item}");
            		$(".${fn:split(item,':')[0]}List.${fn:split(item,':')[1]}").addClass("active");
            	</c:if>
            </c:forEach>

            //대메뉴 patent에 형광색 들어오게하기
            $("#bigOutput").addClass("on");

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

            $("#selectBtn").html( $("#${searchType}").text()+'<span class="sel_arrow"></span>');


            if(${totalPatent} > 0){
				<c:if test="${language eq 'en'}">
					$(".page_num_box").text("${ps}".replace(/\B(?=(\d{3})+(?!\d))/g, ",")+" - "+"${end}".replace(/\B(?=(\d{3})+(?!\d))/g, ",")+" out of "+"${totalPatent}".replace(/\B(?=(\d{3})+(?!\d))/g, ",")+" results");
				</c:if>
				<c:if test="${language eq 'ko'}">
					$(".page_num_box").text("${ps}".replace(/\B(?=(\d{3})+(?!\d))/g, ",")+" - "+"${end}".replace(/\B(?=(\d{3})+(?!\d))/g, ",")+"건 / "+"${totalPatent}".replace(/\B(?=(\d{3})+(?!\d))/g, ",")+"건");
				</c:if>
			}

            drawPages(pageClass, pageNm);
        });

        function selectBox(selectedId){
            $("#selectBtn").html($("#"+selectedId).text()+'<span class="sel_arrow"></span>');
        }


        function goPatents(searchType, searchName, page){
            $(location).attr('href',"${pageContext.request.contextPath}/share/patent/patents.do?searchType="+searchType+"&searchName="+encodeURIComponent(searchName)+"&page="+page+"&sort="+sort+"&order="+order+"&filterItem="+filterItem);
        }


        function goPatentDetail(patentId){
            $(location).attr('href',"${pageContext.request.contextPath}/share/patent/patentDetail.do?patentId="+patentId);
        }

        function patentSearch(){
            var searchValue = $("#patentSearchTxt").val();
            var searchType;

            for(var i = 0; i< $(".form_search_wrap a").length; i++){
                if($(".form_search_wrap a").eq(i).text() == $("#selectBtn").text()){
                    searchType = $(".form_search_wrap a").eq(i).attr("id");
                }
            }

            //아무것도 입력되지 않았을 경우
            if(searchValue.trim().length == 0){
                $(location).attr("href","${pageContext.request.contextPath}/share/patent/patents.do");
            }else{
                //검색 버튼 눌렀을 시 패싯 해제
                filterItem='';
                goPatents(searchType, $("#patentSearchTxt").val(), "1");
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
                    $(".paging_nav").append(" <a class='page_select "+pageClass[i]+"' href='javascript:goPatents(\""+ searchType +"\",\""+ searchName +"\",\""+pageNm[i]+"\")'></a> ");
                }else{
                    //페이지 숫자표기
                    if(span != 0){
                        $(".paging_nav").append(" <span style='margin-left: 0px;'></span> ");
                        span--;
                    }

                    if(currentPage == pageNm[i]){
                        $(".paging_nav span").append(" <strong>"+pageNm[i]+"</strong>");
                    }else{
                        $(".paging_nav span").append(" <a href='javascript:goPatents(\""+ searchType +"\",\""+ searchName +"\",\""+pageNm[i]+"\")'>"+pageNm[i]+"</a>");
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
            }

            goPatents("${searchType}","${fn:replace(searchName,'\"','\\\"')}","1");
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

            goPatents("${searchType}","${fn:replace(searchName,'\"','\\\"')}","1");
		}

        function plusBtn(id){
            if($(".countryList.more").hasClass("hidden")){
                $(".countryList.more").removeClass("hidden");
                $("#"+id).removeClass("more_arrow");
                $("#"+id).addClass("less_arrow");
            }else{
                $(".countryList.more").addClass("hidden");
                $("#"+id).removeClass("less_arrow");
                $("#"+id).addClass("more_arrow");
            }
        }
	</script>
	<link rel="stylesheet" type="text/css" href="<c:url value="/share/css/mquery.css"/>" />
</head>
<body><!--nav_wrap : e  -->
<div class="top_search_wrap">
	<div class="form_search_wrap">
		<span class="fs_title"><spring:message code="disc.otpt.pat.title"/></span>
		<div class="form_dropdown">
			<div class="btn-group">
				<button type="button" class="btn btn-default dropdown-toggle" id="selectBtn" data-toggle="dropdown" aria-expanded="false"></button>
				<ul class="dropdown-menu" role="menu">
					<li><a href="javascript:selectBox('everything')" id="everything"><spring:message code="disc.search.filter.all"/></a></li>
					<li><a href="javascript:selectBox('paTitle')" id="paTitle"><spring:message code="disc.search.filter.patent"/></a></li>
					<li><a href="javascript:selectBox('appl_no')" id="appl_no"><spring:message code="disc.search.filter.application"/></a></li>
					<li><a href="javascript:selectBox('reg_no')" id="reg_no"><spring:message code="disc.search.filter.registration"/></a></li>
				</ul>
			</div>
		</div>
		<div class="search_field_box">
			<input type="text" class="sf_int" placeholder="<spring:message code="disc.placeholder.patent"/>" id="patentSearchTxt" onkeydown="event.keyCode == 13 ? patentSearch():''" maxlength="100" value="<c:out value="${searchName}"/>"/>
			<button type="button" class="fs_bt" onclick="patentSearch()"></button>
		</div>
	</div>
</div>

<div class="sub_container">

	<div class="add_discover">
		<c:choose>
			<c:when test="${totalPatent == 0}">
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
							<c:if test="${fn:length(facetMapList[1]) > 0}">
								<div class="discover_box">
									<h4><span><spring:message code="disc.facet.application"/></span></h4>
									<ul>
										<c:forEach var="country" items="${facetMapList[1]}" varStatus="stat">
											<li class="countryList <c:out value="${fn:split(country.key,'-')[1]}"/> ${stat.index > 9 ? 'more hidden' : ''}">
												<a href="javascript:filter('country','<c:out value="${fn:split(country.key,'-')[1]}"/>');"><c:out value="${fn:split(country.key,'-')[0]}"/></a>
												<span><fmt:formatNumber value="${country.value}" pattern="#,###"/></span>
											</li>
										</c:forEach>
									</ul>
									<c:if test="${fn:length(facetMapList[1]) > 10}">
										<a href="javascript:plusBtn('con');" class="more_arrow" id="con">more</a>
									</c:if>
								</div>
							</c:if>
							<c:if test="${fn:length(facetMapList[0]) > 0}">
								<div class="discover_box">
									<h4><span><spring:message code="disc.facet.registration"/></span></h4>
									<ul>
										<c:forEach var="year" items="${facetMapList[0]}">
											<li class="yearList <c:out value="${year.key}"/>">
												<a href="javascript:filter('year','<c:out value="${year.key}"/>');"><c:out value="${year.key}"/></a>
												<span><fmt:formatNumber value="${year.value}" pattern="#,###"/></span></li>
										</c:forEach>
									</ul>
								</div>
							</c:if>
						</div><!-- right side -->
					</div>
				</div>


				<div class="left_list_box">
					<div class="list_top_box">
						<p class="page_num_box"></p><span style='font-weight:bold;color:red;padding-left: 10px;'><spring:message code="disc.notice.patent"/></span>
								<div class="list_sort_box">
									<ul>
										<li><i><span style="padding-right: 30px;"><spring:message code="disc.sort.sort"/></span></i><a href="javascript:sortTab('date')" class="as_type" id="date" style="display: inline;"><span><spring:message code="disc.sort.date"/></span><em>정렬</em></a></li>
										<li><a href="javascript:sortTab('title')" class="des_type" id="title"><span><spring:message code="disc.sort.title"/></span><em>정렬</em></a></li>
									</ul>
								</div>
					</div>

					<c:forEach items="${patentList}" var="patent">
						<div class="article_list_box">
							<div class="alb_text_box">
								<a href="${pageContext.request.contextPath}/share/patent/patentDetail.do?id=<c:out value='${patent.patentId}'/>" class="al_title" target="_self"><c:out value="${patent.itlPprRgtNm}"/></a>
								<p><c:out value="${patent.content}"/></p>
							</div>
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