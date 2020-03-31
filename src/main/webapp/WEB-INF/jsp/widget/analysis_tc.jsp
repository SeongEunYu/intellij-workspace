<%@include file="../pageInit.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<script type="text/javascript">

    $(function(){
        drawTcChart();
    });

    function drawTcChart(){

        $.ajax({
            url: '${pageContext.request.contextPath}/widget/getCitedAjax.do',
            method: 'get',
            beforeSend:function(){
                $('#analysis_tc_loading').css('display','');
            }
        }).done(function(data){
            $("#analysis_tc_loading").fadeOut();
            var statics = {
                label : [],
                wos : [],
                scp : [],
                kci : []
            };
            for(var i =0; i<data.statics.length; i++){
                statics.label.push(data.statics[i].year);
                statics.wos.push(data.statics[i].wos);
                statics.scp.push(data.statics[i].scp);
                statics.kci.push(data.statics[i].kci);
            }
            updateTcStatics("chart_tc_canvas", statics);
        });
    }

    function updateTcStatics(id, statics) {
        var div = $("#" + id);
        var chart = div.data("chart");
        if(chart) chart.distroy();
        chart = drawTcStatics(div[0], statics);
        div.data("chart", chart);
    }

    function drawTcStatics(target, statics) {
        return new Chart(target, {
            type: 'line',
            data: {
                labels: statics.label,
                datasets: [
                    {
                        label: "Web of Science",
                        data: statics.wos,
                        backgroundColor: 'rgba(068, 185, 203, 1)',
                        borderColor: 'rgba(062, 146, 164, 1)',
                        fill: false,
                        pointRadius: 4,
                        lineTension: 0.00000001
                    },
                    {
                        label: "Scopus",
                        data: statics.scp,
                        backgroundColor: 'rgba(014, 045, 103, 1)',
                        borderColor: 'rgba(016, 042, 088, 1)',
                        fill: false,
                        pointRadius: 4,
                        lineTension: 0.00000001
                    },
                    {
                        label: "KCI",
                        data: statics.kci,
                        backgroundColor: 'rgba(062, 062, 064, 1)',
                        borderColor: 'rgba(025, 030, 028, 1)',
                        fill: false,
                        pointRadius: 4,
                        lineTension: 0.00000001
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
<span id="analysis_tc_loading" style="position: absolute; margin-left: 165px; margin-top: 90px;"><img src="<c:url value="/share/img/common_rss/loading.gif"/>" style="height:40px; width:40px;"/></span>
<div class="chart_img">
    <canvas id="chart_tc_canvas" width="377" height="220" style="padding: 0 3px; margin-top: -20px;"></canvas>
</div>
