<%@include file="../pageInit.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ page import="java.util.Calendar" %>
<script type="text/javascript">
    var chart_hindex;

    $(function(){
        drawHindexChart();
    });

    function drawHindexChart(){
        $.ajax({
            url: '${pageContext.request.contextPath}/widget/hindexAjax.do',
            method: 'get',
        }).done(function(data){
            $("#analysis_hindex_loading").fadeOut();
            var hindex = data.hindex;

            var statics = {
                citation : [],
                article : [],
                hindex : [],
                xCount : [],
            };
            for(var i =0; i<data.hindexList.length; i++){
                statics.citation.push(data.hindexList[i].citation);
                statics.article.push(data.hindexList[i].article);
                statics.xCount.push(i);
                statics.hindex.push(data.hindex);
            }
            updateHindexStatics("chart_hindex_canvas", statics);
        });
    }

    function updateHindexStatics(id, statics) {
        var div = $("#" + id);
        var chart = div.data("chart");
        if(chart) chart.distroy();
        chart = drawHindexStatics(div[0], statics);
        div.data("chart", chart);
    }

    function drawHindexStatics(target, statics) {
        return new Chart(target, {
            type: 'line',
            data: {
                labels: statics.xCount,
                datasets: [
                    {
                        label: "Citation",
                        data: statics.citation,
                        backgroundColor: 'rgba(068, 185, 203, 1)',
                        borderColor: 'rgba(062, 146, 164, 1)',
                        fill: false,
                        pointRadius: 4,
                        lineTension: 0.00000001
                    },
                    {
                        label: "Article Count",
                        data: statics.article,
                        backgroundColor: 'rgba(110, 095, 105, 0.9)',
                        borderColor: 'rgba(101, 085, 091, 1)',
                        fill: false,
                        type: 'bar'
                    },
                    {
                        label: "H-index",
                        data: statics.hindex,
                        backgroundColor: 'rgba(215, 125, 017, 0.9)',
                        borderColor: 'rgba(215, 090, 096, 1)',
                        borderDash: [5,5],
                        fill: false,
                        pointRadius: 0
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
<span id="analysis_hindex_loading" style="position: absolute; margin-left: 165px; margin-top: 90px;"><img src="<c:url value="/share/img/common_rss/loading.gif"/>" style="height:40px; width:40px;"/></span>
<div class="chart_img">
    <canvas id="chart_hindex_canvas" width="377" height="220" style="padding: 0 3px; margin-top: -20px;"></canvas>
</div>
