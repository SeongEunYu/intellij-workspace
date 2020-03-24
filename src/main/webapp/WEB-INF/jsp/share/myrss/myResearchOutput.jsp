<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
%><%@ taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator"
%><%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"
%><!doctype html>
<head>
<%@include file="../pageInit.jsp" %>
<link rel="stylesheet" type="text/css" href="<c:url value="/js/dhtmlx/skins/${sysConf['dhtmlx.skin']}/dhtmlx.css"/>" />
<%--<link rel="stylesheet" type="text/css" href="<c:url value="/share/css/bootstrap.min.css"/>" />--%>
<LINK rel=stylesheet type=text/css	href="<c:url value="/share/css/fixedheader.css"/>">

<script type="text/javascript" src="<c:url value="/share/js/jquery-1.9.1.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/share/js/jquery-ui.js"/>"></script>
<script type="text/javascript" src="<c:url value="/share/js/jquery.scroll.pack.js"/>"></script>
<script type="text/javascript" src="<c:url value="/share/js/bootstrap.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/share/js/chart/opts/fusioncharts.opts.js"/>"></script>
<script type="text/javascript" src="<c:url value="/share/js/chart/fusioncharts.js"/>"></script>
<script type="text/javascript" src="<c:url value="/share/js/jquery.fixedheadertable.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/share/js/chart/fusioncharts-jquery-plugin.min.js"/>"></script>
<title>연구자</title>
<style>
.rl_box ul li .rl_minus { border: 1px solid #dbdbdb; width: 39px;height: 39px;background:#f9f9f9 url(<c:url value="/share/img/minus_icon.png"/>) no-repeat 50% -15px;border-radius: 50%;text-indent: -999999px;   }
.rl_box ul li .rl_minus:hover {background:#474747 url(<c:url value="/share/img/minus_icon.png"/>) no-repeat 50% 12px;  border:1px solid #474747;}
.r_name a { margin-left: 5px; display: inline-block; width:34px; height: 34px; text-indent: -99999px;  }
</style>
<link rel="stylesheet" type="text/css" href="<c:url value="/share/css/mquery.css"/>" />
<script type="text/javascript">
	var sort = "";
	var order = "";
	var temp = 1;

	$(function(){
		//대메뉴 researcher에 형광색 들어오게하기
		$("#myRSS").addClass("on");

		//키워드 길이 체크
		/*while($(".view_keyword_wrap").height() > 70){  //키워드 상자가 다음줄로 넘어가면
			$(".keyword_graph.keyw").eq($(".keyword_graph.keyw").length-1).remove();   //끝에 키워드상자 부터 삭제

			/!*if($(".keyword_b.keyw").text().length <= 119){
				$(".view_fp_box.keyw").append("...");
			}*!/
		}*/

		//Journal Article 선택
		tabClick("journal");

	});


	function tabClick(tabId){

		// 탭 클릭시 파란색 들어오게함.
		$(".tab_wrap a").removeClass("on");
		$("#"+tabId).attr("class","on");

		sort = "date";
		order = "desc";

		makeContents(tabId, "1");
	}

	//tabId : journal, funding, patent, conference 중 1개
	function makeContents(tabId, page){
		$(".sub_container .article_list_box").addClass("willBeDeleted");
		$(".paging_nav").empty();

		$.ajax({
			url: "${pageContext.request.contextPath}/personal/myRss/myResearchOutput/contents.do",
			method: "GET",
			data: {tabId : tabId, id : "${userId}", page:page, sort:sort, order:order}
		}).done(function(data){

			//성과 유무
			if(data.count.end == 0){
				$(".page_num_box").addClass("hidden");
				$(".list_sort_box").addClass("hidden");
				$(".paging_nav").addClass("hidden");
				$(".list_top_box").attr("align","center");
				$(".list_top_box h3").text( '<spring:message code="disc.display.nodata"/>');
				$("#memo").text("");
				$(".willBeDeleted").remove();
				return false;
			}else{
				$(".page_num_box").removeClass("hidden");
				$(".list_sort_box").removeClass("hidden");
				$(".paging_nav").removeClass("hidden");
				<c:if test="${language eq 'en'}">
					$(".page_num_box").text(String(data.count.ps).replace(/\B(?=(\d{3})+(?!\d))/g, ",")+" - "+String(data.count.end).replace(/\B(?=(\d{3})+(?!\d))/g, ",")+" out of "+String(data.count.total).replace(/\B(?=(\d{3})+(?!\d))/g, ",")+" results");
				</c:if>
				<c:if test="${language eq 'ko'}">
					$(".page_num_box").text(String(data.count.ps).replace(/\B(?=(\d{3})+(?!\d))/g, ",")+" - "+String(data.count.end).replace(/\B(?=(\d{3})+(?!\d))/g, ",")+"건 / "+String(data.count.total).replace(/\B(?=(\d{3})+(?!\d))/g, ",")+"건");
				</c:if>
				$(".list_top_box").attr("align","");
				$(".list_top_box h3").text("");
			}

			//sorting
			$(".list_sort_box a").removeClass();

			if(tabId != "journal"){
				$("#tc").addClass("hidden");
			}

			$("#date").css("font-weight","");
			$("#title").css("font-weight","");
			$("#tc").css("font-weight","");
			$("#"+sort).addClass(order.slice(0,-1)+"_type");
			$("#"+sort).css("font-weight","bold");

			for(var i=0; i<data.content.length; i++){

				var content = $(".article_list_box.hidden").clone();
				content.removeClass("hidden");

				//성과 종류에 따른 내용물(content)
				if(tabId == "journal"){
					$("#memo").text("");
					content.find("div").addClass("alb_text_box");

					// 피인용 횟수가 있으면
					if(data.content[i].kciTc+data.content[i].scpTc+data.content[i].tc != 0){
						content.find("div").append("<div class='list_r_info'><ul></ul></div>");
					}

					content.find(".al_title").text(data.content[i].orgLangPprNm);    //논문 명
					content.find(".al_title").attr("href","${pageContext.request.contextPath}/share/article/articleDetail.do?id="+data.content[i].articleId);    //세부정보로 이동

					(data.content[i].tc != null && data.content[i].tc != 0 ? content.find(".list_r_info ul").append('<li>SCI<span>'+data.content[i].tc+'</span></li>') : "");      // WOS 피인용 횟수
					(data.content[i].scpTc != null && data.content[i].scpTc != 0 ? content.find(".list_r_info ul").append('<li class="l_scopus">SCOPUS<span>'+data.content[i].scpTc+'</span></li>') : "");      //SCOPUS 피인용 횟수
					(data.content[i].kciTc != null && data.content[i].kciTc != 0 ? content.find(".list_r_info ul").append('<li class="l_kci">KCI<span>'+data.content[i].kciTc+'</span></li>') : "");      //KCI 피인용 횟수

					content.find("p").html(data.content[i].content);  //간략 내용

					if(data.content[i].keywordList.length != 0){
						var keyArr = data.content[i].keywordList;

						content.append('<div class="l_keyword_box"></div>');
						content.find(".l_keyword_box").append("<span>Keywords</span>");
						//키워드
						for(var j=0; j<keyArr.length; j++){
							content.find(".l_keyword_box").append('<a href="javascript:searchAll(\''+keyArr[j].trim()+'\');">'+ keyArr[j].trim() + '</a>');
						}
					}
					//알트메트릭 로고
					if(data.content[i].doi != null){
						content.find(".al_title").before('<div data-badge-popover="bottom" data-link-target="_blank" style="float:right;" data-badge-type="donut" data-doi="'+data.content[i].doi+'" data-hide-no-mentions="true" class="altmetric-embed"></div>');
					}
				}else if(tabId == "funding"){
					$("#memo").text("<spring:message code='disc.notice.government'/>");
					content.find(".al_title").text(data.content[i].rschSbjtNm);    //연구과제명
					content.find(".al_title").attr("href","${pageContext.request.contextPath}/share/funding/fundingDetail.do?id="+data.content[i].fundingId);    //세부정보로 이동

					content.find("p").html(data.content[i].content);  //간략 내용

					if(data.content[i].engKeywordList.length != 0){
						var keyArr = data.content[i].engKeywordList;

						content.append('<div class="l_keyword_box"></div>');
						content.find(".l_keyword_box").append("<span>Keywords</span>");
						//키워드
						for(var j=0; j<keyArr.length; j++){
							content.find(".l_keyword_box").append('<a href="javascript:searchAll(\''+keyArr[j].trim()+'\');">'+ keyArr[j].trim() + '</a>');
						}
					}
				}else if(tabId == "patent"){
					$("#memo").text("<spring:message code='disc.notice.patent'/>");
					content.find(".al_title").text(data.content[i].itlPprRgtNm);    //지식재산권명
					content.find(".al_title").attr("href","${pageContext.request.contextPath}/share/patent/patentDetail.do?id="+data.content[i].patentId);    //세부정보로 이동
					content.find("p").html(data.content[i].content);  //간략 내용
				}else if(tabId == "conference"){
					$("#memo").text("<spring:message code='disc.notice.conferences'/>");

					content.find(".al_title").text(data.content[i].orgLangPprNm);    //논문명
					content.find(".al_title").attr("href","${pageContext.request.contextPath}/share/conference/conferenceDetail.do?id="+data.content[i].conferenceId);    //세부정보로 이동

					content.find("p").html(data.content[i].content);  //간략 내용

					if(data.content[i].keywordList.length != 0){
						var keyArr = data.content[i].keywordList;

						content.append('<div class="l_keyword_box"></div>');
						content.find(".l_keyword_box").append("<span>Keywords</span>");
						//키워드
						for(var j=0; j<keyArr.length; j++){
							content.find(".l_keyword_box").append('<a href="javascript:searchAll(\''+keyArr[j].trim()+'\');">'+ keyArr[j].trim() + '</a>');
						}
					}

					//알트메트릭 로고
					if(data.content[i].doi != null){
						content.find(".al_title").before('<div data-badge-popover="bottom" data-link-target="_blank" style="float:right;" data-badge-type="donut" data-doi="'+data.content[i].doi+'" data-hide-no-mentions="true" class="altmetric-embed"></div>');
					}
				}

				$(".paging_nav").before(content);
			}

			$(".willBeDeleted").remove();

			var span = 1;

			//페이징
			for(var i=0; i<data.pageList.length; i++){
					//처음, 다음, 이전, 이후 페이지
					if(data.pageList[i].classNm != null) {

						$(".paging_nav").append(" <a class='page_select "+data.pageList[i].classNm+"' href='javascript:makeContents(\""+tabId+"\",\""+data.pageList[i].page+"\")'></a> ");

					}else{
						//페이지 숫자표기
						if(span != 0){
							$(".paging_nav").append(" <span></span> ");
							span--;
						}

						if(page.toString() == data.pageList[i].page){
							$(".paging_nav span").append(" <strong>"+data.pageList[i].page+"</strong>");
						}else{
							$(".paging_nav span").append(" <a href='javascript:makeContents(\""+tabId+"\",\""+data.pageList[i].page+"\")'>"+data.pageList[i].page+"</a>");
						}
					}
			}
			//페이지 이동 or 탭 이동 후 스크롤 위치 (브라우저별)

			if(temp == 0){
				$(window).scrollTop($(".tab_wrap.w_25").offset().top-10);
			}else{
				temp--;
			}

            _altmetric_embed_init(); //알트메트릭 로고 표시
		});
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


		var tabId = $(".tab_wrap .on").attr("id");
		makeContents(tabId,"1");
	}

</script>
</head>
<body>
	<div class="sub_container">
		<%--<h3 class="h3_title"><spring:message code="disc.detail.user.title"/></h3>--%>
		<h3 class="h3_title">My Research Output</h3>
		<div class="about_top_wrap">
			<div class="tab_wrap w_25">
				<ul>
					<li><a id="journal" href="javascript:tabClick('journal')" class="on"><spring:message code="disc.tab.journal"/></a></li>
					<li><a id="funding" href="javascript:tabClick('funding')"><spring:message code="disc.tab.research"/></a></li>
					<li><a id="patent" href="javascript:tabClick('patent')"><spring:message code="disc.tab.patent"/></a></li>
					<li><a id="conference" href="javascript:tabClick('conference')"><spring:message code="disc.tab.conference"/></a></li>
				</ul>
			</div>
			<div class="list_top_box">
				<h3></h3>
				<p class="page_num_box"></p><span id="memo" style='font-weight:bold;color:red;padding-left: 10px;'></span>
				<div class="list_sort_box">
					<ul>
						<li><i><span style="padding-right: 30px;"><spring:message code="disc.sort.sort"/></span></i><a id="date" href="javascript:sortTab('date');" style="display: inline;"><span><spring:message code="disc.sort.date"/></span><em>정렬</em></a></li>
						<li><a id="tc" href="javascript:sortTab('tc');"><span><spring:message code="disc.sort.citation"/></span><em>정렬</em></a></li>
						<li><a id="title" href="javascript:sortTab('title');"><span><spring:message code="disc.sort.title"/></span><em>정렬</em></a></li>
					</ul>
				</div>
			</div>
		</div>
		<div class="paging_nav"></div>
	</div><!-- sub_container : e -->

	<!-- 복사해서 쓸 탭 내용 및 페이징 -->
	<div class="article_list_box hidden">
		<div>
			<a class="al_title" target="_self"></a>
			<p></p>
		</div>
	</div>

    <!-- Modal -->
    <div class="modal fade" id="dialog" tabindex="-1" role="dialog" aria-labelledby="exampleModalLongTitle" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content" style="width: 800px; height: 670px">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h5 class="modal-title"></h5>
                </div>
                <div class="modal-body" id="modalBody">
                </div>
            </div>
        </div>
    </div>
</body>