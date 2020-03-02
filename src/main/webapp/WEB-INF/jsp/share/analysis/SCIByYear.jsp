<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="../pageInit.jsp" %>
<head>
<title>SCI Articles by Year</title>
<script type="text/javascript" src="${pageContext.request.contextPath}/share/js/chart/opts/fusioncharts.opts.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/share/js/chart/fusioncharts.js"></script>
<script type="text/javascript">
	var prevFromYear = "";
	var prevToYear = "";

	$(document).ready(function(){
		//대메뉴 researcher에 형광색 들어오게하기
		$("#bigAnalysis").addClass("on");
		$("#language").val(language);

		//학과 코드로 들어올 경우.
		if('${deptCode}' != ''){
			$('#dept').val('${deptCode}');
		}else{
            $('#dept').val('All');
        }

		$( "#tabs" ).tabs({
			active: '0',
			activate: function( event, ui ) {
				$('.tab_wrap a').removeClass("on");

				if(ui.newPanel.is('#tabs-1')){
					$("#tab1").focus();
					$('.tab_wrap a').eq(0).addClass("on");
				}
				if(ui.newPanel.is('#tabs-2')){
					$("#tab2").focus();
					$('.tab_wrap a').eq(1).addClass("on");

					if($("#artDiv").children().length == 0){
                        $('.wrap-loading').css('display','');
					}
				}
			}
		});
		prevFromYear = $("#fromYear").val();
		prevToYear = $("#toYear").val();

		drawChart();
        latesetArticle();
	});

	function drawChart(){
		if(!validateRange()){
			dhtmlx.alert("${language == 'en' ? 'The start year can not exceed the finish year':'실적기간 범위를 올바로 선택해주세요.'}");
			$("#fromYear").val(prevFromYear);
			$("#toYear").val(prevToYear);

			return;
		}else{
			prevFromYear = $("#fromYear").val();
			prevToYear = $("#toYear").val();
		}

		//차트가 있을경우 지우고 다시 그리기
		if(FusionCharts('SCIChart')) {
			FusionCharts('SCIChart').dispose();
			$('#chartdiv1').disposeFusionCharts().empty();
			//    $('#chartdiv1').css('height','350');
		}

        var chart_obj = {
            id: 'SCIChart',
            type:'mscolumn2d',
            renderAt:'chartdiv1',
            width:'100%',
            height:'350',
            dataSource:{
                chart: {
                    baseFontSize: '13',
                    toolTipColor: '#ffffff',
                    toolTipBorderColor: '#ffffff',
                    toolTipBorderThickness: '1',
                    toolTipBgColor: '#000000',
                    toolTipBgAlpha: '80',
                    toolTipBorderRadius: '4',
                    toolTipPadding: '10',
                    toolTipFontSize : '20',
                    paletteColors: '#AFD8F8,#F6BD0F',
					showValues: '0',
                    showBorder : '0',
                    bgColor: '#ffffff',
                    borderAlpha: '20',
                    canvasBorderAlpha: '0',
                    usePlotGradientColor: '0',
                    plotBorderAlpha: '10',
                    showXAxisLine: '1',
                    xAxisLineColor: '#999999',
                    divlineColor: '#999999',
                    divLineIsDashed: '1',
                    showAlternateHGridColor: '0'
                }
            }
        };


		$("#NoArtTbody").empty();

		$.ajax({
			url:"SCIByYearData.do",
			data:$('#frm').serializeArray(),
			method:'post',
			beforeSend:function(){
				$('.wrap-loading').css('display','');
			}

		}).done(function(data){
			chart_obj.dataSource['categories'] = data.categories;
			chart_obj.dataSource['dataset'] = data.dataset;
			chart_obj.dataSource['styles'] = data.styles;

			new FusionCharts(chart_obj).render();

			//SCI,SCOPUS 목록
			if(data.artList.length > 0){
				var sciTotal = 0;
				var scopusTotal = 0;

				for(var i=0; i<data.artList.length; i++){
					var art = data.artList[i];
					$("#NoArtTbody").append("<tr>" +
						"<td class='al_center'>"+art.pblcYm+"</span></td>" +
						"<td class='al_center'>"+art.coIdSci.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+"</td>" +
						"<td class='al_center'>"+art.coIdScopus.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+"</td>"+
						"</tr>");

					sciTotal += art.coIdSci;
					scopusTotal += art.coIdScopus;
				}
				//합계
				$("#NoArtTbody").append("<tr>" +
					"<td class='al_center'><span style='font-weight: bold'>합계</span></td>" +
					"<td class='al_center'><span style='font-weight: bold'>"+sciTotal.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+"</span></td>" +
					"<td class='al_center'><span style='font-weight: bold'>"+scopusTotal.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+"</span></td>" +
					"</tr>");


			}else{
				$("#NoArtTbody").append("<tr>" +
					"<td colspan='5' style='padding-left:5px;'>There is no result.</td>"+
					"</tr>");
			}

			$(".wrap-loading").css('display','none');
		});
	}

	function latesetArticle() {
		$.ajax({
			url: 'latestArticleByDept.do',
			data: { deptCode : $("#dept").val(), rownum: $("#rownum").val() },
			method: 'post',
			beforeSend:function(){
				$('.wrap-loading').css('display','');
			}
		}).done(function(data){
            $("#artDiv").empty();

            for(var i=0; i<data.latestArtList.length; i++){
				var latestArt = data.latestArtList[i];
                var content = $(".article_list_box.hidden").clone();
                content.removeClass("hidden");
				content.find("div").addClass("alb_text_box");

				// 피인용 횟수가 있으면
				if(latestArt.kciTc+latestArt.scpTc+latestArt.tc != 0){
					content.find("div").append("<div class='list_r_info'><ul></ul></div>");
				}

				content.find(".al_title").text(latestArt.orgLangPprNm);    //논문 명
				content.find(".al_title").attr("href","${pageContext.request.contextPath}/share/article/articleDetail.do?id="+latestArt.articleId);    //세부정보로 이동

				(latestArt.tc != null && latestArt.tc != 0 ? content.find(".list_r_info ul").append('<li>SCI<span>'+latestArt.tc+'</span></li>') : "");      // WOS 피인용 횟수
				(latestArt.scpTc != null && latestArt.scpTc != 0 ? content.find(".list_r_info ul").append('<li class="l_scopus">SCOPUS<span>'+latestArt.scpTc+'</span></li>') : "");      //SCOPUS 피인용 횟수
				(latestArt.kciTc != null && latestArt.kciTc != 0 ? content.find(".list_r_info ul").append('<li class="l_kci">KCI<span>'+latestArt.kciTc+'</span></li>') : "");      //KCI 피인용 횟수

                content.find("p").text(latestArt.content);  //간략 내용

                if(latestArt.keyword != "" && latestArt.keyword != null ){
                    var keyArr = latestArt.keyword.split(";");

                    content.append('<div class="l_keyword_box"></div>');
                    content.find(".l_keyword_box").append("<span>Keywords</span>");
                    //키워드
                    for(var j=0; j<keyArr.length; j++){
                        content.find(".l_keyword_box").append('<a href="javascript:searchAll(\''+keyArr[j].trim()+'\');">'+ keyArr[j].trim() + '</a>');

                    }
                }
                $("#artDiv").append(content);
            }

            $(".wrap-loading").css('display','none');
		});

	}
</script>
</head>
<body>
<div class="top_search_wrap">
	<div class="ts_title">
		<h3>SCI Artices by Year</h3>
	</div>
	<div class="ts_text_box">
		<div class="ts_text_inner"><p style="font-weight:bold;">${language == 'en'?'The number of the SCI articles by year' : '연도별 SCI 논문 건수'}</p></div>
	</div>
</div>
<div class="sub_container">
	<div id="tabs">
		<div class="tab_wrap w_33">
			<ul>
				<li id="tab1"><a class="on" href="#tabs-1">SCI&SCOPUS Data</a></li>
				<li id="tab2"><a href="#tabs-2">Lateset Articles</a></li>
			</ul>
		</div>
		<div id="tabs-1"><!-- 처음 탭 영역-->
			<form class="form-inline" id="frm" name="frm">
				<div class="search_select_option">
					<span class="sel_label">${language == 'en' ? 'Period' : '실적기간'}</span>
					<span class="sel_type">
						<select class="form-control" name="fromYear" id="fromYear" onchange="drawChart();">
						<c:forEach var="yl" items="${pubYearList}">
							<c:if test="${yl >= 2010}">
								<option value="${yl }" ${yl == fromYear ? 'selected="selected"': ''}>${yl }</option>
							</c:if>
						</c:forEach>
						</select>
					</span>
					~
					<span class="sel_type mgr_20">
						<select class="form-control" name="toYear" id="toYear" onchange="drawChart();">
							<c:forEach var="yl" items="${pubYearList}">
								<c:if test="${yl >= 2010}">
									<option value="${yl }" ${yl == toYear ? 'selected="selected"': ''}>${yl }</option>
								</c:if>
							</c:forEach>
						</select>
					</span>
				</div>
			</form>
			<br/><br/><br/>
			<div id="chartdiv1" class="chart_box"></div>
			<table class="tbl_type">
				<thead>
				<tr>
					<th>Year</th>
					<th>SCI</th>
					<th>SCOPUS</th>
				</tr>
				</thead>
				<tbody id="NoArtTbody"></tbody>
			</table>
		</div>
		<div id="tabs-2">
			<div class="search_select_option">
				<span class="sel_label">${language == 'en' ? 'Department' : '학과' }</span>
				<span class="sel_type mgr_20 ">
					<select class="form-control" id="dept" name="dept" onchange="latesetArticle();">
						<c:forEach items="${deptList}" var="dl" varStatus="idx">
							<c:if test="${idx.count == 1}">
								<option value="All">${language == 'en' ? 'All' : '전체' }</option>
							</c:if>
							<option value="${dl.deptCode }">${language == 'en' ? dl.deptEngMostAbbr : dl.deptKorNm }</option>
						</c:forEach>
					</select>
				</span>
				<span class="sel_label">${language == 'en' ? 'List' : '목록' }</span>
				<span class="sel_type mgr_20 ">
					<select class="form-control" id="rownum" name="rownum" onchange="latesetArticle();">
						<option value="20">20</option>
						<option value="40" selected="selected">40</option>
					</select>
				</span>
			</div>
			<br/><br/><br/><br/>
			<div id="artDiv"></div>
		</div>
	</div>
</div>
<!-- 복사해서 쓸 탭 내용 및 페이징 -->
<div class="article_list_box hidden">
	<div>
		<a class="al_title" target="_self"></a>
		<p></p>
	</div>
</div>
</body>
