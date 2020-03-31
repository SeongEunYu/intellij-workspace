<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../pageInit.jsp" %>
<script type="text/javascript">

	var sort = "";
	var order = "";

	$(function(){
		tabClick("journal");
	});

	function tabClick(tabId){

		// 탭 클릭시 파란색 들어오게함.
		$(".output_tab a").removeClass("on");
		$("#"+tabId).attr("class","on");

		sort = "date";
		order = "desc";

		getMyOutput(tabId);
	}

	function getMyOutput(tabId){

		$.ajax({
			url: "${pageContext.request.contextPath}/widget/myResearchOutput.do",
			method: "GET",
			data: {tabId : tabId, id : "${userId}", page:"1", sort:sort, order:order},
            beforeSend: function(){
                $("#outputList_loading").show().fadeIn('fast');
            }
		}).done(function(data){
            $("#outputList_loading").fadeOut();
			if(data.content.length == 0){
				$("#outputList ul li").remove();
				$("#outputList ul").html("<li><p>연구성과 정보가 없습니다.</p></li>");
				$("#outputList ul li").css("text-align","center");
				$("#outputList ul li").css("padding-top","105px");
				return false;
			} else {
				$("#outputList ul li").remove();
				$("#outputList ul").css("margin-top","0px");
				$("#outputList ul").css("text-align","left");
				//성과 종류에 따른 내용물(content)
				for(var i =0; i<data.content.length; i++){
					if(tabId == "journal"){
						var aTag = "<a href='${pageContext.request.contextPath}/share/article/articleDetail.do?id=" + data.content[i].articleId + "'>" + data.content[i].orgLangPprNm + "</a>";
						var sub = "<span class='sr_under_t'>" + data.content[i].content + "</span>";
						$("#outputList ul").append("<li>" + aTag + sub + "</li>");

					}else if(tabId == "funding"){
						var aTag = "<a href='${pageContext.request.contextPath}/share/funding/fundingDetail.do?id=" + data.content[i].fundingId + "'>" + data.content[i].rschSbjtNm + "</a>";
						var sub = "<span class='sr_under_t'>" + data.content[i].content + "</span>";
						$("#outputList ul").append("<li>" + aTag + sub + "</li>");

					}else if(tabId == "patent"){
						var aTag = "<a href='${pageContext.request.contextPath}/share/patent/patentDetail.do?id=" + data.content[i].patentId + "'>" + data.content[i].itlPprRgtNm + "</a>";
						var sub = "<span class='sr_under_t'>" + data.content[i].content + "</span>";
						$("#outputList ul").append("<li>" + aTag + sub + "</li>");

					}else if(tabId == "conference"){
						var aTag = "<a href='${pageContext.request.contextPath}/share/conference/conferenceDetail.do?id=" + data.content[i].conferenceId + "'>" + data.content[i].orgLangPprNm + "</a>";
						var sub = "<span class='sr_under_t'>" + data.content[i].content + "</span>";
						$("#outputList ul").append("<li>" + aTag + sub + "</li>");
					}
				}
				$("#outputList ul li").css("padding","5px 15px 5px 15px");
				$("#outputList ul li").css("margin-bottom","0px");
			}
		});

	}
</script>

<body>
	<div class="col_md_6">
		<div class="dash_box box1">
			<h3>나의 최근 연구성과<a href="${pageContext.request.contextPath}/personal/myRss/myResearchOutput.do" class="main_more_bt">more</a></h3>
			<div class="about_top_wrap">
				<div class="tab_wrap w_25 output_tab">
					<ul>
						<li><a id="journal" href="javascript:tabClick('journal')" class="on" style="font-size: 13px;"><spring:message code="disc.tab.journal"/></a></li>
						<li><a id="funding" href="javascript:tabClick('funding')" style="font-size: 13px;"><spring:message code="disc.tab.research"/></a></li>
						<li><a id="patent" href="javascript:tabClick('patent')" style="font-size: 13px;"><spring:message code="disc.tab.patent"/></a></li>
						<li><a id="conference" href="javascript:tabClick('conference')" style="font-size: 13px;"><spring:message code="disc.tab.conference"/></a></li>
					</ul>
				</div>
			</div>
			<div class="sr_list" id="outputList" >
                <span id="outputList_loading" style="position: absolute; margin-left: 165px; margin-top: 90px;"><img src="<c:url value="/share/img/common_rss/loading.gif"/>" style="height:40px; width:40px;"/></span>
				<ul>

				</ul>
			</div>
		</div>
	</div>

</body>