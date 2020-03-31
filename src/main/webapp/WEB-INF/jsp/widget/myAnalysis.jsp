<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../pageInit.jsp" %>

<script type="text/javascript">

	$(function(){
		tabClick2("article");
		drawArtChart();
	});

	function tabClick2(tabId){
		// 탭 클릭시 파란색 들어오게함.
		$(".analysis_tab a").removeClass("on");
		$("#"+tabId).attr("class","on");

		$("#div_article").css("display","none");
		$("#div_impact").css("display","none");
		$("#div_tc").css("display","none");
		$("#div_hindex").css("display","none");

		$("#div_"+tabId).css("display","");
	}

	function drawArtChart(){
		$.ajax({
			url: '${pageContext.request.contextPath}/widget/getArticleAjax.do',
			method: 'get',
			beforeSend:function(){
				$("#analysis_article_loading").show().fadeIn('fast');
			}
		}).done(function(data){
			$("#analysis_article_loading").fadeOut();
			var statics = {
				count : [],
				label : []
			};
			for(var i =0; i<data.statics.length; i++){
				statics.count.push(data.statics[i].count);
				statics.label.push(data.statics[i].year);
			}
			updateStatics("chart_article_canvas", statics);
		});
	}

	function updateStatics(id, statics) {
		var div = $("#" + id);
		var chart = div.data("chart");
		if(chart) chart.distroy();
		chart = drawStatics(div[0], statics);
		div.data("chart", chart);
	}

	function drawStatics(target, statics) {
		return new Chart(target, {
			type: 'bar',
			data: {
				labels: statics.label,
				datasets: [
					{
						label: "논문수",
						data: statics.count,
						backgroundColor: 'rgba(018, 026, 068, 0.9)',
						borderColor: 'rgba(153, 153, 153, 1)',
						fill: false
					}
				]
			},
			options: {
				responsive: true,
				title: {
					display: false
				},
				tooltips: {
					mode: 'index',
					intersect: false,
				},
				hover: {
					mode: 'nearest',
					intersect: true
				},
				legend: {
					display: true,
					position: 'top'
				}
			}
		});
	}
</script>

<body>
	<div class="col_md_6">
		<div class="dash_box box1">
			<h3>나의 연구성과 분석</h3>
			<div class="about_top_wrap">
				<div class="tab_wrap w_25 analysis_tab" style="margin-bottom: 40px; margin-left: -1px;">
					<ul>
						<li><a id="article" href="javascript:tabClick2('article')" class="on" style="font-size: 13px;">논문수</a></li>
						<li><a id="tc" href="javascript:tabClick2('tc')" style="font-size: 13px;">피인용횟수</a></li>
						<li><a id="hindex" href="javascript:tabClick2('hindex')" style="font-size: 13px;">H-index</a></li>
						<li><a id="impact" style="font-size: 13px;"></a></li>
					</ul>
				</div>
			</div>
			<div class="sr_list" id="div_article" >
                <span id="analysis_article_loading" style="position: absolute; margin-left: 165px; margin-top: 90px;"><img src="<c:url value="/share/img/common_rss/loading.gif"/>" style="height:40px; width:40px;"/></span>
				<%--<div style="width:100%; height:auto;" id="chart_art"></div>--%>
				<div class="chart_img">
					<canvas id="chart_article_canvas" width="377" height="220" style="padding: 0 3px; margin-top: -20px;"></canvas>
				</div>
			</div>

			<div class="sr_list" id="div_tc" style="display: none;">
				<jsp:include page="widget/analysis_tc.jsp"/>
			</div>
			<%--<div class="sr_list" id="div_impact" style="display: none;">--%>
				<%--<jsp:include page="widget/analysis_impact.jsp"/>--%>
			<%--</div>--%>
			<div class="sr_list" id="div_hindex" style="display: none;">
				<jsp:include page="widget/analysis_hindex.jsp"/>
			</div>
		</div>
	</div>

</body>