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
        $('.mouseoverdemo').bind('sparklineRegionChange', function(ev) {
            var sparkline = ev.sparklines[0],
                region = sparkline.getCurrentRegionFields(),
                value = region[0].value;
        });

        $('.mouseoverdemo').sparkline('html', { enableTagOptions: true , tooltipFormat: '{{value}}', barWidth: 2 });

    });

	<%--function relationKeyword(keyword){--%>
		<%--$.ajax({--%>
			<%--url: "${pageContext.request.contextPath}/relationKeyword.do",--%>
			<%--data: {keyword:keyword},--%>
			<%--method: "GET",--%>
		<%--}).done(function(data){--%>
			<%--if(data != null){--%>
				<%--if(data.length > 0){--%>
					<%--var keywordText=  "";--%>
					<%--for(var i=0; i<data.length; i++){--%>
						<%--var keyword = data[i].name;--%>
						<%--var textLen = textLen + keyword.length;--%>
						<%--if(textLen < 130){--%>
							<%--keywordText = keywordText + "<a href='javascript:searchAll('" + keyword + "');' class='keyword_graph keyw'>";--%>
							<%--keywordText = keywordText + "<canvas class='chart_b' id='keyGraph" + i + "' width='250' height='250'></canvas>";--%>
							<%--// keywordText = keywordText + "animate('keyGraph" + i +"'," + num + ");";--%>
							<%--keywordText = keywordText + "<span class='keyword_b keyw'>" + keyword + "</span></a>";--%>
						<%--}--%>
						<%--$(".dash_keyword div").append(keywordText);--%>
					<%--}--%>

					<%--for(var j=0; i<data.length; j++){--%>
						<%--var keyword = data[j].name;--%>
						<%--var textLen = textLen + keyword.length;--%>
						<%--var num = (data[j].num * 100)/data[0].num;--%>
						<%--if(textLen < 130){--%>
							<%--animate('keyGraph' + j, num);--%>
						<%--}--%>
					<%--}--%>
				<%--}--%>
			<%--}--%>
		<%--});--%>
	<%--}--%>

	function animate(elementId, endPercent) {
		console.log("elementId : " + elementId);
		//파이차트
		var canvas = document.getElementById(elementId);
		console.log("canvas : " + canvas);
		var context = canvas.getContext('2d');
		console.log("context : " + context);
		var x = canvas.width / 2;
		var y = canvas.height / 2;
		var radius = 75;
		var circ = Math.PI * 2;
		var quart = Math.PI / 2;

		context.lineWidth = 50;
		context.clearRect(0, 0, canvas.width, canvas.height);
		context.strokeStyle = '#288CFF';  //파이차트 파란색
		context.shadowOffsetX = 0;
		context.shadowOffsetY = 0;
		context.shadowBlur = 10;
		context.shadowColor = '#656565'; // 그림자 색
		context.beginPath();
		context.arc(x, y, radius, -(quart), ((circ) * (endPercent-1)/100) - quart, false);
		context.stroke();

		context.strokeStyle = '#d5d8e0';//파이차트 회색
		context.shadowOffsetX = 0;
		context.shadowOffsetY = 0;
		context.shadowBlur = 10;
		context.shadowColor = '#656565'; // 그림자 색
		context.beginPath();
		context.arc(x, y, radius, -(quart), ((circ) * (endPercent-1)/100) - quart, true);
		context.stroke();
		// $("#" + elementId).append(context);
	}

	var chartOpt = {
		type:'dragnode',
		renderAt:'modalBody',
		width:'774',
		height:'589',
		dataFormat:'json',
		containerBackgroundOpacity:'0',
		dataSource:{
			chart:{
				showPlotBorder: "0",
				//                plotFillAlpha:"0",
				xAxisMinValue:'0',
				canvasBorderAlpha:'0',
				canvasBorderThickness:'0',
				chartTopMargin:'3',
				chartLeftMargin:'3',
				chartRightMargin:'3',
				chartBottomMargin:'3',
				xAxisMaxValue:'100',
				yAxisMinValue:'0',
				yAxisMaxValue:'100',
				toolTipColor: '#ffffff',
				toolTipBorderColor: '#ffffff',
				toolTipBorderThickness: '1',
				toolTipBgColor: '#000000',
				toolTipBgAlpha: '80',
				toolTipBorderRadius: '4',
				toolTipPadding: '10',
				toolTipFontSize : '20',
				is3D:'0',
				viewMode:'0',
				showformbtn:'0',
				enableLink:'1',
				baseFontSize:'12',
				baseFont:'Malgun Gothic',
				divLineAlpha:'30',
				numvdivlines:'5',
				divLineIsDashed:'1',
				bgColor:'F7F7F7, E9E9E9',
				useEllipsesWhenOverflow:'0',
				exportShowMenuItem:'0',
				exportDialogMessage:'Building chart output',
				unescapeLinks:'0',
				exportEnabled:'1',
				exportAtClient:'0',
				exportAction:'save',
				exportHandler:"${pageContext.request.contextPath}/servlet/FlashChartExporter/export.do",
				exportCallBack:'myFN'
			}
		}
	};
</script>
</head>
<body><!--nav_wrap : e  -->
<div class="sub_container">

	<%--<div>Relation keyword</div>--%>
	<h5>Relation keyword</h5>
	<div class="dash_keyword" style="margin-bottom: 20px;">
		<div>

		</div>
	</div>

	<div class="sub_title add_r_box h_fix">
		<h4 style="font-size:22px; font-weight: bold;"><spring:message code="disc.menu.rsch.rsch"/></h4>
	</div>
		<p class="${totalUser > 0 ? 'page_num_box':''}"> <c:if test="${totalUser > 0}">1 - <fmt:formatNumber value="${fn:length(userList)}" type="number"/> out of <fmt:formatNumber value="${totalUser}" type="number"/> results</c:if> </p>
	<div class="row">
		<c:if test="${totalUser == 0}">
			<h4 style="text-align:center">
				<spring:message code="disc.display.nodata"/>
			</h4>
		</c:if>
		<c:forEach items="${userList}" var="user" varStatus="st">
			<div class="col-lg-3 col-md-4 col-sm-6">
				<div class="researcher_card kor_dept_card">
					<div class="researcher_info_top">
						<span class="researcher_img ${user.profPhotoFileId == null ? 'none_img' : ''}">
							<c:if test="${user.profPhotoFileId != null}">
								<img src="${contextPath}/rims/servlet/image/profile.do?fileid=<c:out value="${user.profPhotoFileId}"/>"/>
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
	<c:if test="${totalUser > 8}">
		<div class="al_right mgb_30">
			<c:if test="${totalUser > 8}">
				<a href="${pageContext.request.contextPath}/share/user/users.do?searchName=<c:out value="${searchAllName}"/>&searchType=everything&page=1" class="result_more" style="margin-right: 15px;"><spring:message code="disc.searchAll.more"/></a>
			</c:if>
		</div>
	</c:if>
	<c:if test="${totalUser <= 8}">
		<div class="al_right mgb_30"></div>
	</c:if>

	<div class="sub_title add_r_box h_fix">
		<h4 style="font-size:22px; font-weight: bold;"><spring:message code="disc.menu.otpt.art"/></h4>
	</div>
	<c:if test="${totalArticle == 0}">
		<h4 style="text-align:center">
			<spring:message code="disc.display.nodata"/>
		</h4>
	</c:if>
	<c:if test="${totalArticle > 0}">
		<div class="list_top_box">
			<p class="page_num_box"><c:if test="${totalArticle > 0}">1 - <fmt:formatNumber value="${fn:length(articleList)}" type="number"/> out of <fmt:formatNumber value="${totalArticle}" type="number"/> results</c:if></p>
		</div>
	</c:if>
	<c:forEach items="${articleList}" var="article">
		<div class="article_list_box">
			<div class="alb_text_box">
				<div data-badge-popover="right" data-link-target='_blank' style="float:right;" data-badge-type="donut" data-doi="<c:out value='${article.doi}'/>" data-hide-no-mentions="true" class="altmetric-embed"></div>
				<a class="al_title" href="${pageContext.request.contextPath}/share/article/articleDetail.do?language=${language}&id=<c:out value='${article.articleId}'/>" target="_self"><c:out value="${article.orgLangPprNm}"/></a>
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
	<div class="al_right mgb_30">
		<c:if test="${totalArticle > 4}">
			<a href="${pageContext.request.contextPath}/share/article/articles.do?searchType=everything&searchName=<c:out value="${searchAllName}"/>" class="result_more"><spring:message code="disc.searchAll.more"/></a>
		</c:if>
	</div>
	<div class="sub_title add_r_box h_fix">
		<h4 style="font-size:22px; font-weight: bold;"><spring:message code="disc.menu.otpt.fnd"/></h4>
	</div>
	<c:if test="${totalFunding == 0}">
		<h4 style="text-align:center">
			<spring:message code="disc.display.nodata"/>
		</h4>
	</c:if>
	<c:if test="${totalFunding > 0}">
		<div class="list_top_box">
			<p class="page_num_box"><c:if test="${totalFunding > 0}">1 - <fmt:formatNumber value="${fn:length(fundingList)}" type="number"/> out of <fmt:formatNumber value="${totalFunding}" type="number"/> results</c:if></p>
		</div>
	</c:if>
	<c:forEach items="${fundingList}" var="funding">
		<div class="article_list_box">
			<div class="alb_text_box">
				<a href="${pageContext.request.contextPath}/share/funding/fundingDetail.do?language=${language}&id=<c:out value='${funding.fundingId}'/>" target="_self" class="al_title"><c:out value="${funding.rschSbjtNm}"/></a>
				<p><c:out value="${funding.content}"/></p>
			</div>
			<c:if test="${fn:length(funding.engKeywordList) != 0}">
				<div class="l_keyword_box">
					<span>Keywords</span>
					<c:forEach var="item" items="${funding.engKeywordList}">
						<a href="javascript:searchAll('<c:out value="${fn:trim(item)}"/>');"><c:out value="${fn:trim(item)}"/></a>
					</c:forEach>
				</div>
			</c:if>
		</div>
	</c:forEach>
	<div class="al_right mgb_30">
		<c:if test="${totalFunding > 4}">
			<a href="${pageContext.request.contextPath}/share/funding/fundings.do?searchType=everything&searchName=<c:out value="${searchAllName}"/>" class="result_more"><spring:message code="disc.searchAll.more"/></a>
		</c:if>
	</div>
	<div class="sub_title add_r_box h_fix">
		<h4 style="font-size:22px; font-weight: bold;"><spring:message code="disc.menu.otpt.pat"/></h4>
	</div>
	<c:if test="${totalPatent == 0}">
		<h4 style="text-align:center">
			<spring:message code="disc.display.nodata"/>
		</h4>
	</c:if>
	<c:if test="${totalPatent > 0}">
		<div class="list_top_box">
			<p class="page_num_box"><c:if test="${totalPatent > 0}">1 - <fmt:formatNumber value="${fn:length(patentList)}" type="number"/> out of <fmt:formatNumber value="${totalPatent}" type="number"/> results</c:if></p>
		</div>
	</c:if>
	<c:forEach items="${patentList}" var="patent">
		<div class="article_list_box">
			<div class="alb_text_box">
				<a href="${pageContext.request.contextPath}/share/patent/patentDetail.do?language=${language}&id=<c:out value='${patent.patentId}'/>" class="al_title" target="_self"><c:out value="${patent.itlPprRgtNm}"/></a>
				<p><c:out value="${patent.content}"/></p>
			</div>
		</div>
	</c:forEach>
	<div class="al_right mgb_30">
		<c:if test="${totalPatent > 4}">
			<a href="${pageContext.request.contextPath}/share/patent/patents.do?searchType=everything&searchName=<c:out value="${searchAllName}"/>" class="result_more"><spring:message code="disc.searchAll.more"/></a>
		</c:if>
	</div>
	<div class="sub_title add_r_box h_fix">
		<h4 style="font-size:22px; font-weight: bold;"><spring:message code="disc.menu.otpt.cnfr"/></h4>
	</div>
	<c:if test="${totalConference == 0}">
		<h4 style="text-align:center">
			<spring:message code="disc.display.nodata"/>
		</h4>
	</c:if>
	<c:if test="${totalConference > 0}">
		<div class="list_top_box">
			<p class="page_num_box"><c:if test="${totalConference > 0}">1 - <fmt:formatNumber value="${fn:length(conferenceList)}" type="number"/> out of <fmt:formatNumber value="${totalConference}" type="number"/> results</c:if></p>
		</div>
	</c:if>
	<c:forEach items="${conferenceList}" var="conference">
		<div class="article_list_box">
			<div class="alb_text_box">
				<div data-badge-popover="right" data-link-target='_blank' style="float:right;" data-badge-type="donut" data-doi="<c:out value='${conference.doi}'/>" data-hide-no-mentions="true" class="altmetric-embed"></div>
				<a href="${pageContext.request.contextPath}/share/conference/conferenceDetail.do?language=${language}&id=<c:out value='${conference.conferenceId}'/>" class="al_title" target="_self"><c:out value="${conference.orgLangPprNm}"/></a>
				<p><c:out value="${conference.content}"/></p>
			</div>
			<c:if test="${fn:length(conference.keywordList) != 0}">
				<div class="l_keyword_box">
					<span>Keywords</span>
					<c:forEach var="item" items="${conference.keywordList}">
						<a href="javascript:searchAll('<c:out value="${fn:trim(item)}"/>');"><c:out value="${fn:trim(item)}"/></a>
					</c:forEach>
				</div>
			</c:if>
		</div>
	</c:forEach>
	<div class="al_right mgb_30">
		<c:if test="${totalConference > 4}">
			<a href="${pageContext.request.contextPath}/share/conference/conferences.do?searchType=everything&searchName=<c:out value="${searchAllName}"/>" class="result_more"><spring:message code="disc.searchAll.more"/></a>
		</c:if>
	</div>
	<div class="sub_title add_r_box h_fix">
	</div>
	<a id="toTop" href="#">상단으로 이동</a>
</div>
<!-- sub_container : e -->
</body>