<%@ page import="kr.co.argonet.r2rims.core.vo.DeptVo" %>
<%@ page import="kr.co.argonet.r2rims.core.code.CodeConfiguration" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../../pageInit.jsp" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>One Page Report</title>
    <style type="text/css">
        .list_tbl {
            margin-bottom: 20px;
        }

        .black_bt .pdf_icon {
            background: url("<c:url value="/images/analysis/background/pdf_icon.png"/>") no-repeat 0 6px;
        }

        .black_bt .print_icon {
            background: url("<c:url value="/images/analysis/background/print_icon.png"/>") no-repeat 0 6px;
        }

        .black_bt .question_icon {
            background: url("<c:url value="/images/analysis/background/question_icon.png"/>") no-repeat 0 6px;
        }

        .black_bt .data_update {
            background: url("<c:url value="/images/background/list_icon_set.png"/>") no-repeat -2px -949px;
        }

        @media print {
            * {
                -webkit-print-color-adjust: exact;
            }
        }

        @page {
            margin: 5mm 5mm 5mm 5mm;
        }

        .year_rbox {
            margin-top: 50px;
        }

        table, td {
            border: 1px solid gray;
        }

        .second_chart_box {
            height: 350px;
            width: 730px;
            margin-left:auto;
            margin-right:auto;
        }

        .to_bt_box a {
            background: #e56d28;
            color: #fff;
            padding: 0 16px;
            display: inline-block;
            line-height: 20px;
            font-size: 12px;
        }

        .to_bt_box a:hover {
            background: #ca5d1e;
        }

        .enTag {
            font-family: Arial Narrow
        }

        .koTag {
            font-family: 맑은 고딕
        }

        .select_text {
            margin-left: 5px
        }

        @media all and (min-width: 1440px) {
            .header_box {
                width: 1140px;
                margin: 0 auto;
            }

            .contenst_wrap {
                width: 1140px;
                margin: 0 auto;
            }
        }
    </style>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/script.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/chart/opts/fusioncharts.opts.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/chart/fusioncharts.js"></script>
    <script type="text/javascript" src="<c:url value="/share/js/d3.v3.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/share/js/cloud.min.js"/>"></script>
    <script type="text/javascript" src="${contextPath}/js/jquery/jquery.filedownload.js"></script>
    <%--<script type="text/javascript" src="${contextPath}/js/html2pdf.bundle.min.js"></script>--%>
    <script type="text/javascript">
        var prevFromYear = "";
        var prevToYear = "";
        var resFlag1, resFlag2, resFlag3, resFlag4, resFlag5, resFlag6, resFlag7, resFlag8, resFlagKey = false;
        var colors = '#5e83d0,#FFDC00';
        var colors2 = '#358ada,#FF4136';
        var initNum = 1;

        $(function () {
            <c:if test="${empty pnttmDate}">
            dhtmlx.alert("데이터가 없거나, 업데이트 중입니다. <br/>잠시 뒤에 다시 이용해주세요.");
            $("#tabs").hide();
            return false;
            </c:if>

            bindModalLink();
            search();
            subTab("tab1", "chart");
            $("#tabs").tabs({
                activate: function (event, ui) {
                    if (ui.newPanel.is('#tabs-4')) {
                        $("#selectForm").css("display", "none");
                        $("#selectForm2").css("display", "");
                    } else {
                        $("#selectForm").css("display", "");
                        $("#selectForm2").css("display", "none");
                    }

                    if (ui.newPanel.is('#tabs-1')) {
                        tabOnOff("tab1");
                        subTab("tab1", "chart");
                        $("#langArea").css('display', '');

                        if (!resFlag1) {
                            $('.wrap-loading').css('display', '');
                        } else {
                            $('.wrap-loading').css('display', 'none');
                        }
                    }

                    if (ui.newPanel.is('#tabs-2')) {
                        tabOnOff("tab2");
                        subTab("tab2", "chart");
                        $("#langArea").css('display', '');

                        if (!resFlag3) {
                            $('.wrap-loading').css('display', '');
                        } else {
                            $('.wrap-loading').css('display', 'none');
                        }
                    }
                    if (ui.newPanel.is('#tabs-3')) {
                        tabOnOff("tab3");
                        subTab("tab3", "art");
                        $("#langArea").css('display', 'none');

                        if (!resFlag5) {
                            $('.wrap-loading').css('display', '');
                        } else {
                            $('.wrap-loading').css('display', 'none');
                        }
                    }
                    if (ui.newPanel.is('#tabs-4')) {
                        tabOnOff("tab4");
                        subTab("tab4", "art");
                        $("#stndYearArea").css('display', 'none');
                        $("#stndMonthDayArea").css('display', 'none');

                        if (!resFlag7) {
                            $('.wrap-loading').css('display', '');
                        } else {
                            $('.wrap-loading').css('display', 'none');
                        }
                    }
                }
            });

            prevFromYear = $("#fromYear").val();
            prevToYear = $("#toYear").val();

            var date = new Date();
            var mm = date.getMonth() + 1;
            var dd = date.getDate();
            if (mm < 10) {
                mm = '0' + mm;
            }
            if (dd < 10) {
                dd = '0' + dd;
            }
            var today = date.getFullYear() + "." + mm + "." + dd;
           $(".onepage_footer span").append(today);
        });

        function tabOnOff(tabId) {
            $('#' + tabId).blur();
            $('.tab_menu').removeClass("on");
            $('#' + tabId).addClass("on");
        }

        function search() {

            if (initNum != 1 && (!resFlag1 || !resFlag2 || !resFlag3 || !resFlag4 || !resFlag5 || !resFlag6 || !resFlag7 || !resFlag8 || !resFlagKey)) {
                dhtmlx.alert("모든 탭의 결과가 표시된 후 다시 눌러주세요.");
                return;
            }
            initNum = 0;

            if (!validateRange()) {
                dhtmlx.alert("실적기간 범위를 올바로 선택해주세요.");
                $("#fromYear").val(prevFromYear);
                $("#toYear").val(prevToYear);

                return;
            } else {
                prevFromYear = $("#fromYear").val();
                prevToYear = $("#toYear").val();
            }
            resFlag1, resFlag2, resFlag3, resFlag4, resFlag5, resFlag6, resFlag7, resFlag8, resFlagKey = false;

            if ($("#lang").val() == 'ko') {
                $(".enTag").css("display", "none");
                $(".koTag").css("display", "");
            } else {
                $(".koTag").css("display", "none");
                $(".enTag").css("display", "");
            }

            var deptKorTitle = "&nbsp";
            var deptEngTitle = "&nbsp";

            if ($("select[name=deptKor] option:selected").val() != "") deptKorTitle = $("select[name=deptKor] option:selected").text();
            if ($("select[name=deptKor] option:selected").val() != "") deptEngTitle = $("select[name=deptKor] option:selected").attr("name");

            $(".op_title_dept.koTag").html(deptKorTitle);
            $(".op_title_dept.enTag").html(deptEngTitle);
            $(".year_rbox .yearRange").html($("#fromYear").val() + " ~ " + $("#toYear").val());
            $(".stndYearSpan").html($("#stndYear").val() + "." + $("#stndMonthDay").val().replace("-", "."));
            if ($("#exportUserStatsYn2").val() == "") {
                $(".stndYearDiv").html("<span style='color: #777;font-weight:normal;'>Standard Date</span> <span>" + $("#srchPblcYear").val() + "</span>");
            } else {
                $(".stndYearDiv").html("<span style='color: #777;font-weight:normal;'>Standard Date</span> <span>" + $("#stndYear2").val() + "." + $("#stndMonthDay2").val().replace("-", ".") + "</span>");
            }


            $('.wrap-loading').css('display', '');

            overviewGraph();
            overviewData();
            keyword();
            sciGraph();
            sciData();
            journalReportByArt();
            journalReportByRsch();
            abstReportByArt();
            abstReportByRsch();
        }

        function overviewGraph() {
            var artChart_obj = $.extend(true, {}, chartOpt);
            artChart_obj['id'] = 'artChart';
            artChart_obj['type'] = 'mscolumn2d';
            artChart_obj['renderAt'] = 'artChartDiv';
            artChart_obj['height'] = '240';
            artChart_obj.dataSource.chart['showValues'] = '1';
            artChart_obj.dataSource.chart['yAxisValuesStep'] = '5';
            artChart_obj.dataSource.chart['showplotborder'] = '0';
            artChart_obj.dataSource.chart['usePlotGradientColor'] = '0';
            artChart_obj.dataSource.chart['divLineAlpha'] = '0';
            artChart_obj.dataSource.chart['plotSpacePercent'] = '50';
            artChart_obj.dataSource.chart['paletteColors'] = colors;
            artChart_obj.dataSource.chart['labelDisplay'] = "Auto";

            var conChart_obj = $.extend(true, {}, chartOpt);
            conChart_obj['id'] = 'conChart';
            conChart_obj['type'] = 'mscolumn2d';
            conChart_obj['renderAt'] = 'conChartDiv';
            conChart_obj['height'] = '240';
            conChart_obj.dataSource.chart['plotSpacePercent'] = '50';
            conChart_obj.dataSource.chart['showValues'] = '1';
            conChart_obj.dataSource.chart['yAxisValuesStep'] = '5';
            conChart_obj.dataSource.chart['showplotborder'] = '0';
            conChart_obj.dataSource.chart['usePlotGradientColor'] = '0';
            conChart_obj.dataSource.chart['divLineAlpha'] = '0';
            conChart_obj.dataSource.chart['paletteColors'] = colors;
            conChart_obj.dataSource.chart['labelDisplay'] = "Auto";

            var fudChart_obj = $.extend(true, {}, chartOpt);
            fudChart_obj['id'] = 'fudChart';
            fudChart_obj['type'] = 'msstackedcolumn2dlinedy';
            fudChart_obj['renderAt'] = 'fudChartDiv';
            fudChart_obj['width'] = '99%';
            fudChart_obj['height'] = '240';
            fudChart_obj.dataSource.chart['showValues'] = '1';
            fudChart_obj.dataSource.chart['yAxisValuesStep'] = '5';
            fudChart_obj.dataSource.chart['showplotborder'] = '0';
            fudChart_obj.dataSource.chart['usePlotGradientColor'] = '0';
            fudChart_obj.dataSource.chart['plotSpacePercent'] = '50';
            fudChart_obj.dataSource.chart['paletteColors'] = colors;
            fudChart_obj.dataSource.chart['labelDisplay'] = "Auto";
            fudChart_obj.dataSource.chart['interactiveLegend'] = '0';
            fudChart_obj.dataSource.chart['divLineAlpha'] = '0';

            if ($("#lang").val() == 'ko') {
                fudChart_obj.dataSource.chart['sYAxisName'] = '총연구비(백만원)';
                fudChart_obj.dataSource.chart['pYAxisName'] = '과제건수';
            } else {
                fudChart_obj.dataSource.chart['sYAxisName'] = 'Total Research Fundings(1 million unit)';
                fudChart_obj.dataSource.chart['pYAxisName'] = 'No. of Research Project';
            }

            var patChart_obj = $.extend(true, {}, chartOpt);
            patChart_obj['id'] = 'patChart';
            patChart_obj['type'] = 'MSLine';
            patChart_obj['renderAt'] = 'patChartDiv';
            patChart_obj['height'] = '240';
            patChart_obj.dataSource.chart['showValues'] = '1';
            patChart_obj.dataSource.chart['yAxisValuesStep'] = '5';
            patChart_obj.dataSource.chart['showplotborder'] = '0';
            patChart_obj.dataSource.chart['usePlotGradientColor'] = '0';
            patChart_obj.dataSource.chart['divLineAlpha'] = '0';
            patChart_obj.dataSource.chart['paletteColors'] = colors;
            patChart_obj.dataSource.chart['labelDisplay'] = "Auto";


            $.ajax({
                url: "reportGraphAjax.do",
                data: $("#selectForm").serialize(),
                method: "post"
            }).done(function (data) {
                //차트가 있을경우 지우고 다시 그리기
                if (FusionCharts('artChart')) {
                    FusionCharts('artChart').dispose();
                    $('#artChartDiv').disposeFusionCharts().empty();
                }
                if (FusionCharts('conChart')) {
                    FusionCharts('conChart').dispose();
                    $('#conChartDiv').disposeFusionCharts().empty();
                }
                if (FusionCharts('fudChart')) {
                    FusionCharts('fudChart').dispose();
                    $('#fudChartDiv').disposeFusionCharts().empty();
                }
                if (FusionCharts('patChart')) {
                    FusionCharts('patChart').dispose();
                    $('#patChartDiv').disposeFusionCharts().empty();
                }

                //performance 총 수
                $(".performArt").text(data.total.artsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'));
                $(".performFud").text(data.total.fundCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'));
                $(".performPat").text(data.total.patentCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'));
                $(".performCon").text(data.total.confereneceCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'));

                //Faculty
                var faculty;
                $("#facultyDiv1 span").text("0");
                $("#facultyDiv2 span").text("0");

                for (var i = 0; i < data.facultyList.length; i++) {
                    faculty = data.facultyList[i].cnt.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');

                    if (data.facultyList[i].grade1 == '조교수') {
                        $("#facultyDiv1 span").eq(2).text(faculty);
                        $("#facultyDiv2 span").eq(2).text(faculty);
                    } else if (data.facultyList[i].grade1 == '부교수') {
                        $("#facultyDiv1 span").eq(3).text(faculty);
                        $("#facultyDiv2 span").eq(3).text(faculty);
                    } else if (data.facultyList[i].grade1 == '교수') {
                        $("#facultyDiv1 span").eq(4).text(faculty);
                        $("#facultyDiv2 span").eq(4).text(faculty);
                    } else {
                        //총합
                        $("#facultyDiv1 span").eq(0).text(faculty);
                        $("#facultyDiv2 span").eq(0).text(faculty);
                        $("#facultyDiv1 span").eq(1).text(faculty);
                        $("#facultyDiv2 span").eq(1).text(faculty);
                    }

                }

                artChart_obj.dataSource['categories'] = data.articleCategories;
                artChart_obj.dataSource['dataset'] = data.articleDataset;
                artChart_obj.dataSource['styles'] = data.articleStyles;

                conChart_obj.dataSource['categories'] = data.conferenceCategories;
                conChart_obj.dataSource['dataset'] = data.conferenceDataset;
                conChart_obj.dataSource['styles'] = data.conferenceStyles;

                fudChart_obj.dataSource['categories'] = data.fundingCategories;
                fudChart_obj.dataSource['dataset'] = data.fundingDataset;
                fudChart_obj.dataSource['lineset'] = data.fundingLineset;
                //fudChart_obj.dataSource['styles'] = data.conferenceStyles;

                patChart_obj.dataSource['categories'] = data.patentCategories;
                patChart_obj.dataSource['dataset'] = data.patentDataset;
                patChart_obj.dataSource['styles'] = data.patentStyles;

                new FusionCharts(artChart_obj).render();
                new FusionCharts(conChart_obj).render();
                new FusionCharts(fudChart_obj).render();
                new FusionCharts(patChart_obj).render();

                resFlag1 = true;
                if ($("#tab1Chart").hasClass("active")) {
                    setTimeout(function () {
                        $(".wrap-loading").css('display', 'none')
                    }, 500);
                }
            });
        }

        function overviewData() {
            $.ajax({
                url: "reportAjax.do",
                data: $("#selectForm").serialize(),
                method: "post"
            }).done(function (data) {
                $("#artOverTb tbody").empty();
                $("#fundTb tbody").empty();
                $("#patTb tbody").empty();
                $("#conTb tbody").empty();

                var exportUserStatsYn = $("#exportUserStatsYn1").val();

                //저널논문
                for (var i = 0; i < data.articlePubyearList1.length; i++) {
                    var article = data.articlePubyearList1[i];
                    var rsrchCo = article.rsrchCo == null ? 0 : article.rsrchCo;

                    var $tr = "<tr>" +
                        "<td>" + article.pubYear + "</td>" +
                        "<td>" + article.artsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + article.sciArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + (exportUserStatsYn == "N" ? (rsrchCo != 0 ? article.sciArtsCo / rsrchCo : 0).toFixed(2).replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') : '-') + "</td>" +
                        "<td>" + (exportUserStatsYn == "N" ? rsrchCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') : '-') + "</td>" +
                        "</tr>";

                    $("#artOverTb tbody").append($tr);
                }

                //연구비(연구과제)
                for (var i = 0; i < data.fundingRschyearList.length; i++) {
                    var funding = data.fundingRschyearList[i];
                    var avgFundCoPerRsrch = funding.avgFundCoPerRsrch == null ? 0 : funding.avgFundCoPerRsrch;
                    var avgRsrcctPerRsrch = funding.avgRsrcctPerRsrch == null ? 0 : funding.avgRsrcctPerRsrch;

                    var $tr = "<tr>" +
                        "<td>" + funding.rschYear + "</td>" +
                        "<td>" + funding.fundCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + (parseInt(funding.totRsrcct / 1000000)).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + (exportUserStatsYn == "N" ? avgFundCoPerRsrch.toFixed(2).replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') : '-') + "</td>" +
                        "<td>" + (exportUserStatsYn == "N" ? (avgRsrcctPerRsrch / 1000000).toFixed(2).replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') : '-') + "</td>" +
                        "</tr>";

                    $("#fundTb tbody").append($tr);
                }

                //지식재산(특허)
                for (var i = 0; i < data.patentPatyearList.length; i++) {
                    var patent = data.patentPatyearList[i];
                    var $tr = "<tr>" +
                        "<td>" + patent.patYear + "</td>" +
                        "<td>" + patent.applPatentCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + patent.itlPatentCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "</tr>";

                    $("#patTb tbody").append($tr);
                }

                //학술활동(학술대회)
                for (var i = 0; i < data.conferencePubyearList.length; i++) {
                    var conference = data.conferencePubyearList[i];
                    var $tr = "<tr>" +
                        "<td>" + conference.pubYear + "</td>" +
                        "<td>" + conference.intrlCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + conference.dmstcCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "</tr>";

                    $("#conTb tbody").append($tr);
                }

                resFlag2 = true;
                if ($("#tab1Data").hasClass("active")) {
                    setTimeout(function () {
                        $(".wrap-loading").css('display', 'none')
                    }, 500);
                }
            });
        }


        function sciGraph() {

            var journalChart_obj = $.extend(true, {}, pieChartOpt);
            journalChart_obj['id'] = 'journalChart';
            journalChart_obj['type'] = 'pie2d';
            journalChart_obj['renderAt'] = 'journalChartDiv';
            journalChart_obj['height'] = '300';
            journalChart_obj.dataSource.chart['baseFontSize'] = '10';
            journalChart_obj.dataSource.chart['pieRadius'] = '100';

            var deptChart_obj = $.extend(true, {}, shareChartOpt);
            deptChart_obj['id'] = 'deptChart';
            deptChart_obj['type'] = 'dragnode';
            deptChart_obj['renderAt'] = 'deptChartDiv';
            deptChart_obj['height'] = '400';

            var sciArtChart_obj = $.extend(true, {}, chartOpt);
            sciArtChart_obj['id'] = 'sciArtChart';
            sciArtChart_obj['renderAt'] = 'sciArtChartDiv';
            sciArtChart_obj['height'] = '240';
            sciArtChart_obj.dataSource.chart['showValues'] = '1';
            sciArtChart_obj.dataSource.chart['yAxisValuesStep'] = '5';
            sciArtChart_obj.dataSource.chart['showplotborder'] = '0';
            sciArtChart_obj.dataSource.chart['usePlotGradientColor'] = '0';
            sciArtChart_obj.dataSource.chart['plotSpacePercent'] = '50';
            sciArtChart_obj.dataSource.chart['paletteColors'] = colors2;
            sciArtChart_obj.dataSource.chart['labelDisplay'] = "Auto";

            if ($("#exportUserStatsYn1").val() == 'N') {
                sciArtChart_obj['type'] = 'msstackedcolumn2dlinedy';
                sciArtChart_obj.dataSource.chart['interactiveLegend'] = '0';
                sciArtChart_obj.dataSource.chart['divLineAlpha'] = '0';

                if ($("#lang").val() == 'ko') {
                    sciArtChart_obj.dataSource.chart['sYAxisName'] = '1인당 평균논문';
                    sciArtChart_obj.dataSource.chart['pYAxisName'] = 'SCI논문';
                } else {
                    sciArtChart_obj.dataSource.chart['sYAxisName'] = 'Avg. No. of Papers per Professor';
                    sciArtChart_obj.dataSource.chart['pYAxisName'] = 'SCI Papers';
                }
            } else {
                sciArtChart_obj['type'] = 'mscolumn2d';
                sciArtChart_obj.dataSource.chart['divLineAlpha'] = '0';
            }

            var sciIfChart_obj = $.extend(true, {}, chartOpt);
            sciIfChart_obj['id'] = 'sciIfChart';
            sciIfChart_obj['type'] = 'mscolumn2d';
            sciIfChart_obj['renderAt'] = 'sciIfChartDiv';
            sciIfChart_obj['height'] = '240';
            sciIfChart_obj.dataSource.chart['showValues'] = '1';
            sciIfChart_obj.dataSource.chart['yAxisValuesStep'] = '5';
            sciIfChart_obj.dataSource.chart['showplotborder'] = '0';
            sciIfChart_obj.dataSource.chart['usePlotGradientColor'] = '0';
            sciIfChart_obj.dataSource.chart['plotSpacePercent'] = '50';
            sciIfChart_obj.dataSource.chart['divLineAlpha'] = '0';
            sciIfChart_obj.dataSource.chart['paletteColors'] = colors2;
            sciIfChart_obj.dataSource.chart['labelDisplay'] = "Auto";

            $.ajax({
                url: "sciGraphAjax.do",
                data: $("#selectForm").serialize() + "&srchGroup=researcher",
                method: "post"
            }).done(function (data) {
                var totArt = 0;
                var totTc = 0;
                var totTcAvg = 0;
                var totIf = 0;
                var totIfAvg = 0;

                //논문수 피인용수 등등..
                for (var i = 0; i < data.articlePubyearList1.length; i++) {
                    var article = data.articlePubyearList1[i];

                    totArt += parseInt(article.sciArtsCo);
                    totTc += parseInt(article.tcSum);
                    totIf += parseFloat(article.ifSum);
                }

                totTcAvg = totTc / totArt;
                totIfAvg = totIf / totArt;

                totTcAvg = (totArt == 0 ? 0 : totTc / totArt);
                totIfAvg = (totArt == 0 ? 0 : totIf / totArt);

                //performance 총 수
                $(".performSciArt").text(totArt.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'));
                $(".performSciTc").text(totTc.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'));
                $(".performSciTcAvg").text(totTcAvg.toFixed(2).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'));
                $(".performSciIf").text(totIfAvg.toFixed(2).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'));

                //차트가 있을경우 지우고 다시 그리기
                if (FusionCharts('journalChart')) {
                    FusionCharts('journalChart').dispose();
                    $('#journalChartDiv').disposeFusionCharts().empty();
                }
                if (FusionCharts('deptChart')) {
                    FusionCharts('deptChart').dispose();
                    $('#deptChartDiv').disposeFusionCharts().empty();
                }
                if (FusionCharts('sciArtChart')) {
                    FusionCharts('sciArtChart').dispose();
                    $('#sciArtChartDiv').disposeFusionCharts().empty();
                }
                if (FusionCharts('sciIfChart')) {
                    FusionCharts('sciIfChart').dispose();
                    $('#sciIfChartDiv').disposeFusionCharts().empty();
                }

                journalChart_obj.dataSource['categories'] = data.journalCategories;
                journalChart_obj.dataSource['dataset'] = data.journalDataset;

                deptChart_obj.dataSource['dataset'] = data.deptDataset;
                deptChart_obj.dataSource['connectors'] = data.deptConnectors;
                deptChart_obj.dataSource['styles'] = data.deptStyles;

                sciArtChart_obj.dataSource['categories'] = data.sciArtCategories;
                sciArtChart_obj.dataSource['dataset'] = data.sciArtDataset;
                if ($("#exportUserStatsYn1").val() == 'N') {
                    sciArtChart_obj.dataSource['lineset'] = data.sciArtLineset;
                } else {
                    sciArtChart_obj.dataSource['styles'] = data.sciArtStyles;
                }

                sciIfChart_obj.dataSource['categories'] = data.sciIfCategories;
                sciIfChart_obj.dataSource['dataset'] = data.sciIfDataset;
                sciIfChart_obj.dataSource['styles'] = data.sciIfStyles;

                new FusionCharts(deptChart_obj).render();
                new FusionCharts(journalChart_obj).render();
                new FusionCharts(sciArtChart_obj).render();
                new FusionCharts(sciIfChart_obj).render();

                resFlag3 = true;
                if ($("#tab2Chart").hasClass("active")) {
                    setTimeout(function () {
                        $(".wrap-loading").css('display', 'none')
                    }, 500);
                }
            });
        }

        function keyword() {
            $("#keywordChartDiv").html("<div style='padding-left:301px;padding-top:150px'><img src='${pageContext.request.contextPath}/images/analysis/common/ajax-loader.gif' /></div>");
            $("#keywordTb tbody").html("<td colspan='4'><img src='${pageContext.request.contextPath}/images/analysis/common/ajax-loader.gif' /></td>");

            $.ajax({
                url: "keywordAjax.do",
                data: $("#selectForm").serialize(),
                method: "post"
            }).done(function (data) {

                var text = "";
                for (var i = 0; i < data.keywordList.length; i++) {
                    //키워드 수
                    if (i >= 50) break;
                    var keyword = data.keywordList[i];

                    if (i != 0) text += ";split;";
                    text += keyword.name + ":" + keyword.num + ".0 ";
                }

                //Cloud Data
                $("#text").html(text);

                if (text == "") {
                    $("#keywordChartDiv").html('<div style="padding-top: 160px;padding-left: 330px;font-size: 10px;">No data to display.</div>');
                } else {
                    $("#keywordChartDiv").html("");
                }

                drawCloud(730, 350, "keywordChartDiv");

                //키워드 목록
                $("#keywordTb tbody").empty();
                if (data.keywordList.length > 0) {
                    for (var i = 0; i < data.keywordList.length; i++) {
                        var countTr;

                        // 키워드 70개
                        if (i == 70) break;
                        countTr = parseInt(i / 2);
                        if (i % 2 == 0) $("#keywordTb tbody").append("<tr></tr>");

                        var keyword = data.keywordList[i];

                        $("#keywordTb tbody tr").eq(countTr).append(
                            "<td class='al_left'>" + keyword.name + "</td>" +
                            "<td class='al_center'>" + keyword.num.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>"
                        );

                    }
                } else {
                    $("#keywordTb tbody").append("<tr><td colspan='5'>키워드가 없습니다.</td></tr>");
                }

                resFlagKey = true;
            });
        }

        function sciData() {

            $.ajax({
                url: "sciReportAjax.do",
                data: $("#selectForm").serialize() + "&srchGroup=researcher",
                method: "post"
            }).done(function (data) {
                $("#sciAnalyTb1 tbody").empty();

                var exportUserStatsYn = $("#exportUserStatsYn1").val();

                //SCI 저널논문분석1
                for (var i = 0; i < data.articlePubyearList1.length; i++) {
                    var article = data.articlePubyearList1[i];
                    var rsrchCo = article.rsrchCo == null ? 0 : article.rsrchCo;
                    var avgTcPerArtcl = article.avgTcPerArtcl == null ? 0 : article.avgTcPerArtcl;
                    var avgArtsPerRsrch = article.avgArtsPerRsrch == null ? 0 : article.avgArtsPerRsrch;
                    var avgJifPerRsrch = article.avgJifPerRsrch == null ? 0 : article.avgJifPerRsrch;
                    var avgJifPerRsrchPerArtcl = avgArtsPerRsrch != 0 ? avgJifPerRsrch / avgArtsPerRsrch : 0;

                    var $tr = "<tr>" +
                        "<td>" + article.pubYear + "</td>" +
                        "<td><a style='color:blue' href='javascript:exportArticle(\"sciAllByRsch\",\"" + article.pubYear + "\",\"" + article.sciArtsCo + "\")'>" + article.sciArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</a><a></a></td>" +
                        "<td>" + article.tcSum.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + article.ifSum.toFixed(2).replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + avgTcPerArtcl.toFixed(2).replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + (exportUserStatsYn == "N" ? avgArtsPerRsrch.toFixed(2).replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') : '-') + "</td>" +
                        "<td>" + (exportUserStatsYn == "N" ? avgJifPerRsrch.toFixed(2).replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') : '-') + "</td>" +
                        "<td>" + (exportUserStatsYn == "N" ? avgJifPerRsrchPerArtcl.toFixed(2).replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') : '-') + "</td>" +
                        "<td>" + (exportUserStatsYn == "N" ? rsrchCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') : '-') + "</td>" +
                        "</tr>";

                    $("#sciAnalyTb1 tbody").append($tr);
                }
            });

            $.ajax({
                url: "sciReportAjax.do",
                data: $("#selectForm").serialize(),
                method: "post"
            }).done(function (data) {
                $("#sciAnalyTb tbody").empty();
                $("#sciAnalyTb2 tbody").empty();
                $("#sciAnalyTb3 tbody").empty();
                $("#sciTcAnalyTb tbody").empty();
                $("#journalTb tbody").empty();
                $("#networkTb tbody").empty();

                var exportUserStatsYn = $("#exportUserStatsYn1").val();

                //SCI 저널논문분석1
                for (var i = 0; i < data.articlePubyearList1.length; i++) {
                    var article = data.articlePubyearList1[i];
                    var rsrchCo = article.rsrchCo == null ? 0 : article.rsrchCo;
                    var avgTcPerArtcl = article.avgTcPerArtcl == null ? 0 : article.avgTcPerArtcl;
                    var avgArtsPerRsrch = article.avgArtsPerRsrch == null ? 0 : article.avgArtsPerRsrch;
                    var avgJifPerRsrch = article.avgJifPerRsrch == null ? 0 : article.avgJifPerRsrch;
                    var avgJifPerRsrchPerArtcl = avgArtsPerRsrch != 0 ? avgJifPerRsrch / avgArtsPerRsrch : 0;

                    var $tr = "<tr>" +
                        "<td>" + article.pubYear + "</td>" +
                        "<td><a style='color:blue' href='javascript:exportArticle(\"sciAll\",\"" + article.pubYear + "\",\"" + article.sciArtsCo + "\")'>" + article.sciArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</a><a></a></td>" +
                        "<td>" + article.tcSum.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + article.ifSum.toFixed(2).replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + avgTcPerArtcl.toFixed(2).replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + (exportUserStatsYn == "N" ? avgArtsPerRsrch.toFixed(2).replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') : '-') + "</td>" +
                        "<td>" + (exportUserStatsYn == "N" ? avgJifPerRsrch.toFixed(2).replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') : '-') + "</td>" +
                        "<td>" + (exportUserStatsYn == "N" ? avgJifPerRsrchPerArtcl.toFixed(2).replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') : '-') + "</td>" +
                        "<td>" + (exportUserStatsYn == "N" ? rsrchCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') : '-') + "</td>" +
                        "</tr>";

                    $("#sciAnalyTb tbody").append($tr);
                }

                //SCI 저널논문분석(상위10%)
                for (var i = 0; i < data.articlePubyearList1.length; i++) {
                    var article1 = data.articlePubyearList1[i];
                    var ifArtsCo = data.if10ArticlePubyearList[i].dataValue;
                    var categCo = data.if10CategProdyearList[i].dataValue;
                    var percentIfArticle = article1.sciArtsCo != 0 ? (Number(ifArtsCo) / article1.sciArtsCo) * 100 : 0;

                    var $tr = "<tr>" +
                        "<td>" + article1.pubYear + "</td>" +
                        "<td><a style='color:blue' href='javascript:exportArticle(\"sciAll\",\"" + article1.pubYear + "\",\"" + article1.sciArtsCo + "\")'>" + article1.sciArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</a></td>" +
                        "<td><a style='color:blue' href='javascript:exportArticle(\"sciIf10\",\"" + article1.pubYear + "\",\"" + ifArtsCo + "\")'>" + ifArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</a></td>" +
                        "<td>" + parseInt(percentIfArticle) + "%</td>" +
                        "<td>" + categCo.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "</tr>";

                    $("#sciAnalyTb2 tbody").append($tr);
                }

                //SCI 저널논문분석(상위20%)
                for (var i = 0; i < data.articlePubyearList1.length; i++) {
                    var article1 = data.articlePubyearList1[i];
                    var ifArtsCo = data.if20ArticlePubyearList[i].dataValue;
                    var categCo = data.if20CategProdyearList[i].dataValue;
                    var percentIfArticle = article1.sciArtsCo != 0 ? (Number(ifArtsCo) / article1.sciArtsCo) * 100 : 0;

                    var $tr = "<tr>" +
                        "<td>" + article1.pubYear + "</td>" +
                        "<td><a style='color:blue' href='javascript:exportArticle(\"sciAll\",\"" + article1.pubYear + "\",\"" + article1.sciArtsCo + "\")'>" + article1.sciArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</a></td>" +
                        "<td><a style='color:blue' href='javascript:exportArticle(\"sciIf20\",\"" + article1.pubYear + "\",\"" + ifArtsCo + "\")'>" + ifArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</a></td>" +
                        "<td>" + parseInt(percentIfArticle) + "%</td>" +
                        "<td>" + categCo.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "</tr>";

                    $("#sciAnalyTb3 tbody").append($tr);
                }

                //SCI 논문 피인용수 분석
                for (var i = 0; i < data.articlePubyearList1.length; i++) {
                    var article1 = data.articlePubyearList1[i];
                    var hcpArtsCo = data.hcpArticlePubyearList[i].dataValue;
                    var percentTcArticle = article1.sciArtsCo != 0 ? (article1.sciTcArtsCo / article1.sciArtsCo) * 100 : 0;

                    var $tr = "<tr>" +
                        "<td>" + article1.pubYear + "</td>" +
                        "<td><a style='color:blue' href='javascript:exportArticle(\"sciAll\",\"" + article1.pubYear + "\",\"" + article1.sciArtsCo + "\")'>" + article1.sciArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</a></td>" +
                        "<td><a style='color:blue' href='javascript:exportArticle(\"sciHcp\",\"" + article1.pubYear + "\",\"" + hcpArtsCo + "\")'>" + hcpArtsCo.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</a></td>" +
                        "<td><a style='color:blue' href='javascript:exportArticle(\"sciTc\",\"" + article1.pubYear + "\",\"" + article1.sciTcArtsCo + "\")'>" + article1.sciTcArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</a></td>" +
                        "<td>" + parseInt(percentTcArticle) + "%</td>" +
                        "<td><a style='color:blue' href='javascript:exportArticle(\"sciNotTc\",\"" + article1.pubYear + "\",\"" + (article1.sciArtsCo - article1.sciTcArtsCo) + "\")'>" + (article1.sciArtsCo - article1.sciTcArtsCo).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</a></td>" +
                        "</tr>";

                    $("#sciTcAnalyTb tbody").append($tr);
                }

                //저널목록
                if (data.journalList.length > 0) {
                    for (var i = 0; i < data.journalList.length; i++) {
                        var count = i + 1;
                        var title = data.journalList[i].title;
                        if (title == null) {
                            title = "";
                        }

                        if (title.length > 59) {
                            title = data.journalList[i].title.substr(0, 59) + "...";
                        }

                        $("#journalTb tbody").append("<tr>" +
                            "<td>" + count + "</td>" +
                            "<td class='al_left'><span title='" + data.journalList[i].title + "'>" + title + "</span></td>" +
                            "<td>" + data.journalList[i].issnNo + "</td>" +
                            "<td>" + data.journalList[i].artsCo + "</td>" +
                            "<td>" + data.journalList[i].userCo + "</td>" +
                            "</tr>");
                    }
                } else {
                    $("#journalTb tbody").append("<tr>" +
                        "<td colspan='5'>Journal이 없습니다.</td>" +
                        "</tr>");
                }

                //Department Collaboration Network
                for (var i = 0; i < data.coAuthorList.length; i++) {
                    var count = i + 1;
                    var dept = data.coAuthorList[i].deptKor;

                    $("#networkTb tbody").append("<tr>" +
                        "<td>" + count + "</td>" +
                        "<td class='al_left'>" + dept + "</td>" +
                        "<td>" + ((data.coAuthorList[i].coArtsCo / data.totalCoArts) * 100).toFixed(2) + "%</td>" +
                        "<td>" + data.coAuthorList[i].coArtsCo + "</td>" +
                        "</tr>");
                }

                if (data.coAuthorList.length == 0) {
                    $("#networkTb tbody").append("<tr><td colspan='5'>공동연구논문이 없습니다.</td></tr>");
                }

                resFlag4 = true;

                if ($("#tab2Data").hasClass("active")) {
                    setTimeout(function () {
                        $(".wrap-loading").css('display', 'none')
                    }, 500);
                }
            });
        }

        function journalReportByArt() {

            $.ajax({
                url: "journalReportAjax.do",
                data: $("#selectForm").serialize(),
                method: "post"
            }).done(function (data) {
                $("#abstArtTb tbody").empty();
                $("#abstSciConTb tbody").empty();
                $("#abstConTb tbody").empty();
                $("#abstSciTb tbody").empty();
                $("#abstSciEtcTb tbody").empty();

                var exportUserStatsYn = $("#exportUserStatsYn1").val();

                //국내/국제 논문 기준 요약 통계
                for (var i = 0; i < data.articlePubyearList1.length; i++) {
                    var article = data.articlePubyearList1[i];
                    var rsrchCo = article.rsrchCo == null ? 0 : article.rsrchCo;

                    var $tr1 = "<tr>" +
                        "<td>" + article.pubYear + "</td>" +
                        "<td>" + article.intrlJnalArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + article.intrlGnalArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + article.intrlArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + article.dmstcKciArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + article.dmstcGnalArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + article.dmstcArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + article.artsTotal.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + article.sciDmstcCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + article.sciIntrlCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + article.tcSum.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + article.ifSum.toFixed(2).replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + (exportUserStatsYn == "N" ? rsrchCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') : '-') + "</td>" +
                        "</tr>";

                    var $tr2 = "<tr>" +
                        "<td>" + article.pubYear + "</td>" +
                        "<td>" + article.sciDmstcCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + article.sciIntrlCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + (article.sciDmstcCo + article.sciIntrlCo).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + article.tcSum.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + article.ifSum.toFixed(2).replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + (exportUserStatsYn == "N" ? rsrchCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') : '-') + "</td>" +
                        "</tr>";

                    var totalArts = article.intrlArtsTotal + article.dmstArtsTotal;

                    var $tr3 = "<tr>" +
                        "<td>" + article.pubYear + "</td>" +
                        "<td>" + totalArts.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + article.sciIntrlCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + (article.intrlArtsTotal - article.sciIntrlCo).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + article.sciDmstcCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + (article.dmstArtsTotal - article.sciDmstcCo).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + (exportUserStatsYn == "N" ? rsrchCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') : '-') + "</td>" +
                        "</tr>";

                    var $tr4 = "<tr>" +
                        "<td>" + article.pubYear + "</td>" +
                        "<td>" + article.sciArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + article.ifSum.toFixed(2).replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + article.tcSum.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + (exportUserStatsYn == "N" ? (rsrchCo == 0 ? 0 : article.sciArtsCo / rsrchCo).toFixed(2).replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') : '-') + "</td>" +
                        "<td>" + (article.sciArtsCo == 0 ? 0 : article.tcSum / article.sciArtsCo).toFixed(2).replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + (exportUserStatsYn == "N" ? rsrchCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') : '-') + "</td>" +
                        "</tr>";

                    var $tr5 = "<tr>" +
                        "<td>" + article.pubYear + "</td>" +
                        "<td>" + article.sciArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + (article.artsCo - article.sciArtsCo).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + article.artsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + (exportUserStatsYn == "N" ? rsrchCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') : '-') + "</td>" +
                        "</tr>";


                    $("#abstArtTb tbody").append($tr1);
                    $("#abstSciConTb tbody").append($tr2);
                    $("#abstConTb tbody").append($tr3);
                    $("#abstSciTb tbody").append($tr4);
                    $("#abstSciEtcTb tbody").append($tr5);
                }

                resFlag5 = true;
                if ($("#tab3ByArt").hasClass("active")) {
                    setTimeout(function () {
                        $(".wrap-loading").css('display', 'none')
                    }, 500);
                }
            });
        }

        function journalReportByRsch() {
            $.ajax({
                url: "journalReportAjax.do",
                data: $("#selectForm").serialize() + "&srchGroup=researcher",
                method: "post"
            }).done(function (data) {
                $("#abstArtTb2 tbody").empty();
                $("#abstSciConTb2 tbody").empty();
                $("#abstConTb2 tbody").empty();
                $("#abstSciTb2 tbody").empty();
                $("#abstSciEtcTb2 tbody").empty();

                var exportUserStatsYn = $("#exportUserStatsYn1").val();
                //국내/국제 논문 기준 요약 통계
                for (var i = 0; i < data.articlePubyearList1.length; i++) {
                    var article = data.articlePubyearList1[i];
                    var rsrchCo = article.rsrchCo == null ? 0 : article.rsrchCo;

                    var $tr1 = "<tr>" +
                        "<td>" + article.pubYear + "</td>" +
                        "<td>" + article.intrlJnalArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + article.intrlGnalArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + article.intrlArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + article.dmstcKciArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + article.dmstcGnalArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + article.dmstcArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + article.artsTotal.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + article.sciDmstcCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + article.sciIntrlCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + article.tcSum.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + article.ifSum.toFixed(2).replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + (exportUserStatsYn == "N" ? rsrchCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') : '-') + "</td>" +
                        "</tr>";

                    var $tr2 = "<tr>" +
                        "<td>" + article.pubYear + "</td>" +
                        "<td>" + article.sciDmstcCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + article.sciIntrlCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + (article.sciDmstcCo + article.sciIntrlCo).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + article.tcSum.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + article.ifSum.toFixed(2).replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + (exportUserStatsYn == "N" ? rsrchCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') : '-') + "</td>" +
                        "</tr>";

                    var totalArts = article.intrlArtsTotal + article.dmstArtsTotal;

                    var $tr3 = "<tr>" +
                        "<td>" + article.pubYear + "</td>" +
                        "<td>" + totalArts.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + article.sciIntrlCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + (article.intrlArtsTotal - article.sciIntrlCo).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + article.sciDmstcCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + (article.dmstArtsTotal - article.sciDmstcCo).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + (exportUserStatsYn == "N" ? rsrchCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') : '-') + "</td>" +
                        "</tr>";

                    var $tr4 = "<tr>" +
                        "<td>" + article.pubYear + "</td>" +
                        "<td>" + article.sciArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + article.ifSum.toFixed(2).replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + article.tcSum.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + (exportUserStatsYn == "N" ? (rsrchCo == 0 ? 0 : article.sciArtsCo / rsrchCo).toFixed(2).replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') : '-') + "</td>" +
                        "<td>" + (article.sciArtsCo == 0 ? 0 : article.tcSum / article.sciArtsCo).toFixed(2).replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + (exportUserStatsYn == "N" ? rsrchCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') : '-') + "</td>" +
                        "</tr>";

                    var $tr5 = "<tr>" +
                        "<td>" + article.pubYear + "</td>" +
                        "<td>" + article.sciArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + (article.artsCo - article.sciArtsCo).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + article.artsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td>" + (exportUserStatsYn == "N" ? rsrchCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') : '-') + "</td>" +
                        "</tr>";


                    $("#abstArtTb2 tbody").append($tr1);
                    $("#abstSciConTb2 tbody").append($tr2);
                    $("#abstConTb2 tbody").append($tr3);
                    $("#abstSciTb2 tbody").append($tr4);
                    $("#abstSciEtcTb2 tbody").append($tr5);
                }

                resFlag6 = true;
                if ($("#tab3ByRsch").hasClass("active")) {
                    setTimeout(function () {
                        $(".wrap-loading").css('display', 'none')
                    }, 500);
                }
            });
        }

        function abstReportByArt() {
            var data = $("#selectForm2").serialize();

            $.ajax({
                url: "abstReportAjax.do",
                data: data,
                method: "post"
            }).done(function (data) {
                $("#abstArtByArtTb tbody").empty();

                //전임 교원 학술논문 현황
                var toTintrlJnalArtsCo = 0;
                var toTintrlGnalArtsCo = 0;
                var toTintrlArtsCo = 0;
                var toTdmstcKciArtsCo = 0;
                var toTdmstcGnalArtsCo = 0;
                var toTdmstcArtsCo = 0;
                var toTartsTotal = 0;
                var toTsciDmstcCo = 0;
                var toTsciIntrlCo = 0;
                var toTtcSum = 0;
                var toTifSum = 0;
                var toTrsrchCo = 0;
                var $tr;

                var exportUserStatsYn = $("#exportUserStatsYn2").val();
                for (var i = 0; i < data.articleDeptList.length; i++) {
                    var article = data.articleDeptList[i];

                    toTintrlJnalArtsCo += article.intrlJnalArtsCo;
                    toTintrlGnalArtsCo += article.intrlGnalArtsCo;
                    toTintrlArtsCo += article.intrlArtsCo;
                    toTdmstcKciArtsCo += article.dmstcKciArtsCo;
                    toTdmstcGnalArtsCo += article.dmstcGnalArtsCo;
                    toTdmstcArtsCo += article.dmstcArtsCo;
                    toTartsTotal += article.artsTotal;
                    toTsciDmstcCo += article.sciDmstcCo;
                    toTsciIntrlCo += article.sciIntrlCo;
                    toTtcSum += article.tcSum;
                    toTifSum += article.ifSum;
                    toTrsrchCo += article.rsrchCo;

                    $tr = "<tr>" +
                        "<td>" + article.deptKor + "</td>" +
                        "<td style='text-align:right'>" + article.intrlJnalArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td style='text-align:right'>" + article.intrlGnalArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td style='text-align:right'>" + article.intrlArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td style='text-align:right'>" + article.dmstcKciArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td style='text-align:right'>" + article.dmstcGnalArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td style='text-align:right'>" + article.dmstcArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td style='text-align:right'>" + article.artsTotal.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td style='text-align:right'>" + article.sciDmstcCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td style='text-align:right'>" + article.sciIntrlCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td style='text-align:right'>" + article.tcSum.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td style='text-align:right'>" + article.ifSum.toFixed(2).replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td style='text-align:right'>" + (exportUserStatsYn == "N" ? article.rsrchCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') : '-') + "</td>" +
                        "</tr>";

                    $("#abstArtByArtTb tbody").append($tr);
                }

                $tr = "<tr>" +
                    "<td>총 계</td>" +
                    "<td style='text-align:right'>" + toTintrlJnalArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                    "<td style='text-align:right'>" + toTintrlGnalArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                    "<td style='text-align:right'>" + toTintrlArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                    "<td style='text-align:right'>" + toTdmstcKciArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                    "<td style='text-align:right'>" + toTdmstcGnalArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                    "<td style='text-align:right'>" + toTdmstcArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                    "<td style='text-align:right'>" + toTartsTotal.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                    "<td style='text-align:right'>" + toTsciDmstcCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                    "<td style='text-align:right'>" + toTsciIntrlCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                    "<td style='text-align:right'>" + toTtcSum.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                    "<td style='text-align:right'>" + toTifSum.toFixed(2).replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                    "<td style='text-align:right'>" + (exportUserStatsYn == "N" ? toTrsrchCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') : '-') + "</td>" +
                    "</tr>";

                $("#abstArtByArtTb tbody").append($tr);

                $tr = "<tr>" +
                    "<td>1인당<br/>실적</td>" +
                    "<td colspan='7'></td>" +
                    "<td style='text-align:right'>" + (exportUserStatsYn == "N" ? (toTrsrchCo != 0 ? toTsciDmstcCo / toTrsrchCo : 0).toFixed(1) : '-') + "</td>" +
                    "<td style='text-align:right'>" + (exportUserStatsYn == "N" ? (toTrsrchCo != 0 ? toTsciIntrlCo / toTrsrchCo : 0).toFixed(1) : '-') + "</td>" +
                    "<td style='text-align:right'>" + (exportUserStatsYn == "N" ? (toTrsrchCo != 0 ? toTtcSum / toTrsrchCo : 0).toFixed(1) : '-') + "</td>" +
                    "<td style='text-align:right'>" + (exportUserStatsYn == "N" ? (toTrsrchCo != 0 ? toTifSum / toTrsrchCo : 0).toFixed(2) : '-') + "</td>" +
                    "<td></td>" +
                    "</tr>";

                $("#abstArtByArtTb tbody").append($tr);

                resFlag7 = true;
                if ($("#tab4ByArt").hasClass("active")) {
                    setTimeout(function () {
                        $(".wrap-loading").css('display', 'none')
                    }, 500);
                }
            });
        }


        function abstReportByRsch() {
            var data = $("#selectForm2").serialize() + "&srchGroup=researcher";

            $.ajax({
                url: "abstReportAjax.do",
                data: data,
                method: "post"
            }).done(function (data) {
                $("#abstArtByRschTb tbody").empty();

                //전임 교원 학술논문 현황
                var toTintrlJnalArtsCo = 0;
                var toTintrlGnalArtsCo = 0;
                var toTintrlArtsCo = 0;
                var toTdmstcKciArtsCo = 0;
                var toTdmstcGnalArtsCo = 0;
                var toTdmstcArtsCo = 0;
                var toTartsTotal = 0;
                var toTsciDmstcCo = 0;
                var toTsciIntrlCo = 0;
                var toTtcSum = 0;
                var toTifSum = 0;
                var toTrsrchCo = 0;
                var $tr;

                var exportUserStatsYn = $("#exportUserStatsYn2").val();
                for (var i = 0; i < data.articleDeptList.length; i++) {
                    var article = data.articleDeptList[i];

                    toTintrlJnalArtsCo += article.intrlJnalArtsCo;
                    toTintrlGnalArtsCo += article.intrlGnalArtsCo;
                    toTintrlArtsCo += article.intrlArtsCo;
                    toTdmstcKciArtsCo += article.dmstcKciArtsCo;
                    toTdmstcGnalArtsCo += article.dmstcGnalArtsCo;
                    toTdmstcArtsCo += article.dmstcArtsCo;
                    toTartsTotal += article.artsTotal;
                    toTsciDmstcCo += article.sciDmstcCo;
                    toTsciIntrlCo += article.sciIntrlCo;
                    toTtcSum += article.tcSum;
                    toTifSum += article.ifSum;
                    toTrsrchCo += article.rsrchCo;

                    $tr = "<tr>" +
                        "<td>" + article.deptKor + "</td>" +
                        "<td style='text-align:right'>" + article.intrlJnalArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td style='text-align:right'>" + article.intrlGnalArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td style='text-align:right'>" + article.intrlArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td style='text-align:right'>" + article.dmstcKciArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td style='text-align:right'>" + article.dmstcGnalArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td style='text-align:right'>" + article.dmstcArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td style='text-align:right'>" + article.artsTotal.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td style='text-align:right'>" + article.sciDmstcCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td style='text-align:right'>" + article.sciIntrlCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td style='text-align:right'>" + article.tcSum.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td style='text-align:right'>" + article.ifSum.toFixed(2).replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                        "<td style='text-align:right'>" + (exportUserStatsYn == "N" ? article.rsrchCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') : '-') + "</td>" +
                        "</tr>";

                    $("#abstArtByRschTb tbody").append($tr);
                }

                $tr = "<tr>" +
                    "<td>총 계</td>" +
                    "<td style='text-align:right'>" + toTintrlJnalArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                    "<td style='text-align:right'>" + toTintrlGnalArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                    "<td style='text-align:right'>" + toTintrlArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                    "<td style='text-align:right'>" + toTdmstcKciArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                    "<td style='text-align:right'>" + toTdmstcGnalArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                    "<td style='text-align:right'>" + toTdmstcArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                    "<td style='text-align:right'>" + toTartsTotal.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                    "<td style='text-align:right'>" + toTsciDmstcCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                    "<td style='text-align:right'>" + toTsciIntrlCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                    "<td style='text-align:right'>" + toTtcSum.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                    "<td style='text-align:right'>" + toTifSum.toFixed(2).replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                    "<td style='text-align:right'>" + (exportUserStatsYn == "N" ? toTrsrchCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') : '-') + "</td>" +
                    "</tr>";

                $("#abstArtByRschTb tbody").append($tr);

                $tr = "<tr>" +
                    "<td>1인당<br/>실적</td>" +
                    "<td colspan='7'></td>" +
                    "<td style='text-align:right'>" + (exportUserStatsYn == "N" ? (toTrsrchCo != 0 ? toTsciDmstcCo / toTrsrchCo : 0).toFixed(1) : '-') + "</td>" +
                    "<td style='text-align:right'>" + (exportUserStatsYn == "N" ? (toTrsrchCo != 0 ? toTsciIntrlCo / toTrsrchCo : 0).toFixed(1) : '-') + "</td>" +
                    "<td style='text-align:right'>" + (exportUserStatsYn == "N" ? (toTrsrchCo != 0 ? toTtcSum / toTrsrchCo : 0).toFixed(1) : '-') + "</td>" +
                    "<td style='text-align:right'>" + (exportUserStatsYn == "N" ? (toTrsrchCo != 0 ? toTifSum / toTrsrchCo : 0).toFixed(2) : '-') + "</td>" +
                    "<td></td>" +
                    "</tr>";

                $("#abstArtByRschTb tbody").append($tr);

                resFlag8 = true;
                if ($("#tab4ByRsch").hasClass("active")) {
                    setTimeout(function () {
                        $(".wrap-loading").css('display', 'none')
                    }, 500);
                }
            });
        }

        function pdfWork() {
            var browser = navigator.userAgent.toLowerCase();

            var currentTab = $(".tab_menu.on").attr("href").replace("#", "");

            $(".header_wrap").css("display", "none");
            $(".shadow_box").css("display", "none");
            $(".sub_top_box").css("display", "none");
            $(".onepage_footer").css("display", "none");

            var $pdfDiv = $("<div id='pdfDiv' style='max-width: 100%;overflow:hidden;background:#ffffff;'></div>");
            $pdfDiv.append($(".asrims_contents").html());
//    $pdfDiv.find(".professor_box span").css("font-size","17px");
//    $pdfDiv.find(".faculty_box span").css("font-size","19px");
//    $pdfDiv.find(".sb_num dl dd").css("font-size","17px");
            /*if(browser.indexOf("chrome") == -1){
                $pdfDiv.find("text").css("font-weight","bold");
            }*/
            $pdfDiv.find("#keywordDiv").css('margin-top', '50px');
            $pdfDiv.find("#div_sciData a").css('color', '');

            var footer = $(".onepage_footer").clone().css("width","100%").css("position","absolute").css("bottom","0px").css("display","");

            $("body").prepend($pdfDiv);
            $("#pdfDiv").append(footer);
            $("#pdfDiv").css('position', 'relative').css('width','793px');
            /*var page = Math.ceil($("#pdfDiv").height() / 1020);
            console.log('page : ' + page + ' / height : ' + $("#pdfDiv").height());
            if (($("#pdfDiv").height() / 1020) < 1.02) page = 1;
            $("#pdfDiv").height(1004 * parseInt(page) + ((parseInt(page) - 1) * 82) + 55);
            console.log('page : ' + page + ' / height : ' + $("#pdfDiv").height());*/

            var page = Math.ceil($("#pdfDiv").height() / 1080);
            $("#pdfDiv").height(1080 * parseInt(page));

            /* var svgNum = $pdfDiv.find("#"+currentTab).find("svg").length;
            if($(".sub_menuC.active").attr("id").indexOf("Chart") == -1 || browser.indexOf("chrome") != -1){
                makePdf();
            }else{
                $("#svgToImgForm>input").remove();
                for(var i=0; i<svgNum; i++){
                    var svgParentId = $pdfDiv.find("#"+currentTab).find("svg").eq(i).parent().attr("id");
                    var svgTag = $pdfDiv.find("#"+svgParentId).html();
                    svgTag = svgTag.replace(/font-style="undefined"/gi,"").replace(/font-weight="undefined"/gi,"").replace(/1e-006/gi,"0.000001").replace(/1e-06/gi,"0.000001").replace('xmlns:xml="http://www.w3.org/XML/1998/namespace" xml:space="preserve" xmlns:NS1="" NS1:xmlns:xml="http://www.w3.org/XML/1998/namespace"','')
                        .replace(/cursor: pointer;/gi,"").replace(/cursor: col-resize;/gi,"").replace(/cursor: default;/gi,"");

                    $("#svgToImgForm").append($("<input type='hidden' name='svgHtml' />").val(svgTag));
                }

                $.ajax({
                    url: "<c:url value="/analysis/svgToImg.do"/>",
                    data: $("#svgToImgForm").serialize(),
                    method: "post"
                }).done(function (data) {
                    for(var i=0; i<svgNum; i++){
                        $pdfDiv.find("#"+currentTab).find("svg").eq(0).parent().html("<img src="+data[i]+">");
                    }
                    makePdf();
                });
            }*/

            makePdf();
        }

        function makePdf() {
            var browser = navigator.userAgent.toLowerCase();
            if (-1 != browser.indexOf('chrome')) {
                window.print();
            } else if (-1 != browser.indexOf('trident')) {
                try {
                    //웹 브라우저 컨트롤 생성
                    var webBrowser = '<OBJECT ID="previewWeb" WIDTH=0 HEIGHT=0 CLASSID="CLSID:8856F961-340A-11D0-A96B-00C04FD705A2"></OBJECT>';

                    //웹 페이지에 객체 삽입
                    document.body.insertAdjacentHTML('beforeEnd', webBrowser);

                    //ExexWB 메쏘드 실행 (7 : 미리보기 , 8 : 페이지 설정 , 6 : 인쇄하기(대화상자))
                    previewWeb.ExecWB(7, 1);

                    //객체 해제
                    previewWeb.outerHTML = "";
                } catch (e) {
                    alert("- 도구 > 인터넷 옵션 > 보안 탭 > 신뢰할 수 있는 사이트 선택\n   1. 사이트 버튼 클릭 > 사이트 추가\n   2. 사용자 지정 수준 클릭 > 스크립팅하기 안전하지 않은 것으로 표시된 ActiveX 컨트롤 (사용)으로 체크\n\n※ 위 설정은 프린트 기능을 사용하기 위함임");
                }

            }

            /*var element = $("#pdfDiv")[0];
            html2pdf(element, {
                filename: "onePageReport.pdf",
                margin : [0,1,0,1],
                dpi: "300"
            });*/
            console.log('height : ' + $("#pdfDiv").height());

            setTimeout(function() {
                $("#pdfDiv").remove();
                //$(".onepage_footer").eq(0).remove();
                $(".header_wrap").css("display","");
                $(".shadow_box").css("display","");
                $(".sub_top_box").css("display","");
                $(".onepage_footer").css("display","");
            }, 100);
        }

        function deptChartClick() {
        }

        function subTab(tabId, subTab) {

            $('.sub_menuC').parent().parent().css("display", "none");
            $(".sub_menuC").removeClass("active");

            if (tabId == "tab1") {
                $("#div_overviewChart").css("display", "none");
                $("#div_overviewData").css("display", "none");

                if (subTab == "chart") {
                    if (!resFlag1) {
                        $('.wrap-loading').css('display', '');
                    } else {
                        $('.wrap-loading').css('display', 'none');
                    }

                    $("#div_overviewChart").css("display", "");
                    //sub tab 효과
                    $("#tab1Chart").addClass("active");
                    $('#tab1Chart').parent().parent().css("display", "");
                }

                if (subTab == "data") {
                    if (!resFlag2) {
                        $('.wrap-loading').css('display', '');
                    } else {
                        $('.wrap-loading').css('display', 'none');
                    }

                    $("#div_overviewData").css("display", "");
                    //sub tab 효과
                    $("#tab1Data").addClass("active");
                    $('#tab1Data').parent().parent().css("display", "");
                }
            } else if (tabId == "tab2") {
                $("#div_sciChart").css("display", "none");
                $("#div_sciData").css("display", "none");

                if (subTab == "chart") {
                    if (!resFlag3) {
                        $('.wrap-loading').css('display', '');
                    } else {
                        $('.wrap-loading').css('display', 'none');
                    }

                    $("#div_sciChart").css("display", "");
                    //sub tab 효과
                    $("#tab2Chart").addClass("active");
                    $('#tab2Chart').parent().parent().css("display", "");
                }

                if (subTab == "data") {
                    if (!resFlag4) {
                        $('.wrap-loading').css('display', '');
                    } else {
                        $('.wrap-loading').css('display', 'none');
                    }

                    $("#div_sciData").css("display", "");
                    //sub tab 효과
                    $("#tab2Data").addClass("active");
                    $('#tab2Data').parent().parent().css("display", "");
                }
            } else if (tabId == "tab3") {
                $("#div_jnlArt").css("display", "none");
                $("#div_jnlRsch").css("display", "none");

                if (subTab == "art") {
                    if (!resFlag5) {
                        $('.wrap-loading').css('display', '');
                    } else {
                        $('.wrap-loading').css('display', 'none');
                    }

                    $("#div_jnlArt").css("display", "");
                    //sub tab 효과
                    $("#tab3ByArt").addClass("active");
                    $('#tab3ByArt').parent().parent().css("display", "");
                }

                if (subTab == "rsch") {
                    if (!resFlag6) {
                        $('.wrap-loading').css('display', '');
                    } else {
                        $('.wrap-loading').css('display', 'none');
                    }

                    $("#div_jnlRsch").css("display", "");
                    //sub tab 효과
                    $("#tab3ByRsch").addClass("active");
                    $('#tab3ByRsch').parent().parent().css("display", "");
                }
            } else if (tabId == "tab4") {
                $("#div_abstArt").css("display", "none");
                $("#div_abstRsch").css("display", "none");

                if (subTab == "art") {
                    if (!resFlag7) {
                        $('.wrap-loading').css('display', '');
                    } else {
                        $('.wrap-loading').css('display', 'none');
                    }

                    $("#div_abstArt").css("display", "");
                    //sub tab 효과
                    $("#tab4ByArt").addClass("active");
                    $('#tab4ByArt').parent().parent().css("display", "");
                }

                if (subTab == "rsch") {
                    if (!resFlag8) {
                        $('.wrap-loading').css('display', '');
                    } else {
                        $('.wrap-loading').css('display', 'none');
                    }

                    $("#div_abstRsch").css("display", "");
                    //sub tab 효과
                    $("#tab4ByRsch").addClass("active");
                    $('#tab4ByRsch').parent().parent().css("display", "");
                }
            }
        }

        function exportArticle(type, pubyear, num) {
            if (Number(num) > 0) {
                $(".wrap-loading").css('display', '');

                var itemType = "";
                var dataUrl = "";
                if (type == 'sciAll') {
                    itemType = "&itemType=sciArticle";
                }
                if (type == 'sciAllByRsch') {
                    itemType = "&itemType=sciArticleByRsch";
                }
                if (type == 'sciTc') {
                    itemType = "&itemType=sciArticle";
                    dataUrl += "&isCited=Y"
                }
                if (type == 'sciNotTc') {
                    itemType = "&itemType=sciArticle";
                    dataUrl += "&isCited=N"
                }
                if (type == 'sciHcp') {
                    itemType = "&itemType=sciHcpArticle";
                }
                if (type == 'sciIf10') {
                    itemType = "&itemType=sciIf10Article";
                }
                if (type == 'sciIf20') {
                    itemType = "&itemType=sciIf20Article";
                }

                $.fileDownload("exportArticle.do?" + $("#selectForm").serialize() + itemType + dataUrl + "&gubun=SCI&pubyear=" + pubyear, {
                    successCallback: function (url) {
                        $(".wrap-loading").css('display', 'none');
                    },
                    failCallback: function (responseHtml, url) {
                        $(".wrap-loading").css('display', 'none');
                        dhtmlx.alert("File download failed");
                    }
                });
            }
        }

        function dataUpdate() {
            dhtmlx.alert("데이터 업데이트를 수동으로 시작했습니다. <br/>(백그라운드로 진행)");

            $.ajax({
                url: "<c:url value="/rawdataUpdate.do"/>"
            });
        }

        function exportUser2OnChange() {
            if ($("#exportUserStatsYn2").val() == "") {
                $("#stndYear2Span").css("display", "none");
                $("#stndMonthDay2Span").css("display", "none");
            } else {
                $("#stndYear2Span").css("display", "");
                $("#stndMonthDay2Span").css("display", "");
            }
        }

    </script>
</head>
<body>
<link media="print" href="${pageContext.request.contextPath}/css/analysis_${instAbrv}/layout.css" rel="stylesheet"
      type="text/css"/>
<h3 class="page_title"><spring:message code="menu.asrms.inst.onePageReport"/></h3>
<div class="help_text mgb_15"><spring:message code="asrms.institution.onePageReport.desc"/><br/>데이터 추출일: <c:out
        value="${fn:substring(pnttmDate,0,4)}.${fn:substring(pnttmDate,4,6)}.${fn:substring(pnttmDate,6,8)}"/></div>
<p class="bt_box mgb_10">
    <c:if test="${sessionScope.auth.adminDvsCd eq 'M'}">
        <a href="javascript:dataUpdate();" class="black_bt"><em class="data_update">Data Update</em></a>
    </c:if>
    <a href="javascript:pdfWork();" class="black_bt"><em class="print_icon">Print (Chrome recommended)</em></a>
    <c:if test="${fn:contains(header['User-Agent'],'MSIE') || fn:contains(header['User-Agent'],'Trident')}">
        <a href="javascript:alert('인쇄 미리보기 화면에서 \'페이지 설정(Alt+U) -> 배경색 및 이미지 인쇄 클릭, 머리글/바닥글 모두 비어있음 설정\' 을 하시면 머리글/바닥글이 내용을 가리지 않습니다.');" class="black_bt"><em class="question_icon">Help</em></a>
    </c:if>
</p>
<div id="tabs" style="margin-bottom: 0px;">
    <div class="con_tab" style="margin-bottom: 0px;">
        <ul>
            <li>
                <a href="#tabs-1" class="tab_menu on" id="tab1">Overview Report</a>
                <ul>
                    <li><a href='javascript:subTab("tab1","chart")' class="sub_menuC" id="tab1Chart">Chart</a></li>
                    <li><a href='javascript:subTab("tab1","data")' class="sub_menuC" id="tab1Data">Table</a></li>
                </ul>
            </li>
            <li>
                <a href="#tabs-2" class="tab_menu" id="tab2">SCI Report</a>
                <ul>
                    <li><a href='javascript:subTab("tab2","chart")' class="sub_menuC" id="tab2Chart">Chart</a></li>
                    <li><a href='javascript:subTab("tab2","data")' class="sub_menuC" id="tab2Data">Table</a></li>
                </ul>
            </li>
            <li>
                <a href="#tabs-3" class="tab_menu" id="tab3">Journal Report</a>
                <ul>
                    <li><a href='javascript:subTab("tab3","art")' class="sub_menuC" id="tab3ByArt">By Article</a></li>
                    <li><a href='javascript:subTab("tab3","rsch")' class="sub_menuC" id="tab3ByRsch">By Professor</a>
                    </li>
                </ul>
            </li>
            <li>
                <a href="#tabs-4" class="tab_menu" id="tab4">Department Report</a>
                <ul>
                    <li><a href='javascript:subTab("tab4","art")' class="sub_menuC" id="tab4ByArt">By Article</a></li>
                    <li><a href='javascript:subTab("tab4","rsch")' class="sub_menuC" id="tab4ByRsch">By Professor</a>
                    </li>
                </ul>
            </li>
        </ul>
    </div>
    <div class="top_option_box">
        <form id="selectForm">
            <div class="to_inner">
                <span>학과</span>
                <em>
                    <select name="deptKor" id="deptKor" style="width:150px">
                        <option value="" selected="selected">전체</option>
                        <%
                            Map<String, List<DeptVo>> AllList = CodeConfiguration.getDeptList();

                            Iterator<String> iter0 = AllList.keySet().iterator();
                            while (iter0.hasNext()) {
                                String str = iter0.next();
                                List<DeptVo> departmentList = AllList.get(str);
                                for (DeptVo deptVo : departmentList) {
                        %>
                        <option name="<%=deptVo.getDeptEngNm() %>"
                                value="<%=deptVo.getDeptKorNm() %>"><%=deptVo.getDeptKorNm() %>
                        </option>
                        <%
                                }
                            }
                        %>
                    </select>
                </em>
                <c:set var="now" value="<%=new java.util.Date()%>"/>
                <c:set var="sysYear"><fmt:formatDate value="${now}" pattern="yyyy"/></c:set>
                <span>실적기간</span>
                <em>
                    <select name="fromYear" id="fromYear">
                        <c:forEach var="year" begin="${sysYear - 9}" end="${sysYear}">
                            <option value="${sysYear - year + sysYear - 9}" ${(sysYear-3) == (sysYear - year + sysYear - 9) ? 'selected="selected"' : ''}>
                                <c:out value="${sysYear - year + sysYear - 9}"/></option>
                        </c:forEach>
                    </select>
                </em>
                ~
                <em>
                    <select name="toYear" id="toYear">
                        <c:forEach var="year" begin="${sysYear - 9}" end="${sysYear}">
                            <option value="${sysYear - year + sysYear - 9}" ${(sysYear-1) == (sysYear - year + sysYear - 9) ? 'selected="selected"' : ''}>
                                <c:out value="${sysYear - year + sysYear - 9}"/></option>
                        </c:forEach>
                    </select>
                </em>
                <span>성과기준</span>
                <em>
                    <select name="exportUserStatsYn" id="exportUserStatsYn1">
                        <option value="">전체</option>
                        <option value="N" selected="selected">전임(연도말재직교원)</option>
                        <option value="Y">전임(퇴직교수포함)</option>
                    </select>
                </em>
                <div style="margin-top: 5px;" id="langArea">
                    <span style="margin-right: 72px;">
                        <span>언어</span>
                        <em>
                            <select name="lang" id="lang">
                                <option value="ko">한글</option>
                                <option value="en">영문</option>
                            </select>
                        </em>
                    </span>
                    <span style="margin-right: 63px;">
                        <span>기준연도(교수)</span>
                        <em>
                            <select name="stndYear" id="stndYear">
                                <c:forEach var="year" begin="${sysYear - 9}" end="${sysYear}">
                                    <option value="${sysYear - year + sysYear - 9}" ${(sysYear-1) == (sysYear - year + sysYear - 9) ? 'selected="selected"' : ''}><c:out
                                            value="${sysYear - year + sysYear - 9}"/></option>
                                </c:forEach>
                            </select>
                        </em>
                    </span>
                    <span style="padding-right:0px;">
                        <span>기준일자(교수)</span>
                        <em>
                            <select name="stndMonthDay" id="stndMonthDay">
                                <option value="04-01">04월01일</option>
                                <option value="12-31" selected="selected">12월31일</option>
                            </select>
                        </em>
                    </span>
                </div>
            </div>
        </form>
        <form id="selectForm2" style="display: none;">
            <div class="to_inner" style="min-width: 80px;">
                <span style="min-width: 60px;">기준연도(논문)</span>
                <em>
                    <select name="srchPblcYear" id="srchPblcYear">
                        <c:forEach var="year" begin="${sysYear - 9}" end="${sysYear}">
                            <option value="${sysYear - year + sysYear - 9}" ${(sysYear-1) == (sysYear - year + sysYear - 9) ? 'selected="selected"' : ''}>
                                <c:out value="${sysYear - year + sysYear - 9}"/></option>
                        </c:forEach>
                    </select>
                </em>
                <span style="min-width: 60px;">실적구분</span>
                <em>
                    <select name="insttRsltAt" id="insttRsltAt">
                        <option value="ALL">전체</option>
                        <option value="Y" selected="selected">${sysConf['inst.abrv']}</option>
                        <option value="N">타기관</option>
                    </select>
                </em>
                <span style="min-width: 60px;">성과기준</span>
                <em>
                    <select name="exportUserStatsYn" id="exportUserStatsYn2" onchange="exportUser2OnChange();">
                        <option value="">전체</option>
                        <option value="N" selected="selected">전임</option>
                    </select>
                </em>
                <span id="stndYear2Span" style="margin-left: 5px;">
                    <span style="min-width: 60px;">기준연도(교수)</span>
                    <em>
                        <select name="stndYear" id="stndYear2">
                            <c:forEach var="year" begin="${sysYear - 9}" end="${sysYear}">
                                <option value="${sysYear - year + sysYear - 9}" ${(sysYear-1) == (sysYear - year + sysYear - 9) ? 'selected="selected"' : ''}><c:out
                                        value="${sysYear - year + sysYear - 9}"/></option>
                            </c:forEach>
                        </select>
                    </em>
                </span>
                <span id="stndMonthDay2Span">
                    <span style="min-width: 60px;">기준일자(교수)</span>
                    <em>
                        <select name="stndMonthDay" id="stndMonthDay2">
                            <option value="04-01">04월01일</option>
                            <option value="12-31" selected="selected">12월31일</option>
                        </select>
                    </em>
                </span>
            </div>
        </form>
        <p class="ts_bt_box">
            <a href="javascript:search();" class="to_search_bt"><span>Search</span></a>
        </p>
    </div>
    <div class="asrims_contents" style="margin-bottom: 0px;">
        <div id="tabs-1">
            <div id="div_overviewChart" class="onepage_wrap">
                <div class="overview_box">
                    <em class="enTag"><span class="overview_text">Overview Chart</span></em>
                    <em class="koTag"><span class="overview_text">요약차트</span></em>
                </div>
                <div class="onepage_inner" style="margin-bottom: 10px; margin-bottom: 10px;">
                    <div class="op_title_box">
                        <div class="op_title">
                            <img src="<c:url value="/images/analysis/background/onepage_title01.png"/>" width="436px"
                                 height="auto"/>
                        </div>
                        <div class="year_rbox"><span class='enTag'
                                                     style="color: #777;font-weight:normal;">Year Range</span><span
                                class='koTag' style="color: #777;font-weight:normal;">성과기간</span> <span
                                class="yearRange"></span></div>
                    </div>
                    <div class="top_summary_wrap">
                        <div class="top_summary_row">
                            <div class="summary_box">
                                <div class="sb_inner">
                                    <span><img src="<c:url value="/images/background/onepage_icon01.png"/>" width="44px"
                                               height="auto" alt="Journal Articles"/></span>
                                    <div class="sb_num">
                                        <dl>
                                            <dt class="enTag">Journal Articles</dt>
                                            <dt class="koTag">저널논문</dt>
                                            <dd class="performArt"></dd>
                                        </dl>
                                    </div>
                                </div>
                            </div>
                            <div class="summary_box">
                                <div class="sb_inner">
                                    <span><img src="<c:url value="/images/background/onepage_icon02.png"/>" width="44px"
                                               height="auto" alt="Research Fundings"/></span>
                                    <div class="sb_num">
                                        <dl>
                                            <dt class="enTag">Research Fundings</dt>
                                            <dt class="koTag">연구비(연구과제)</dt>
                                            <dd class="performFud"></dd>
                                        </dl>
                                    </div>
                                </div>
                            </div>
                            <div class="summary_box">
                                <div class="sb_inner">
                                    <span><img src="<c:url value="/images/background/onepage_icon03.png"/>" width="44px"
                                               height="auto" alt="Patents"/></span>
                                    <div class="sb_num">
                                        <dl>
                                            <dt class="enTag">Registered Patents</dt>
                                            <dt class="koTag">지식재산(특허)</dt>
                                            <dd class="performPat"></dd>
                                        </dl>
                                    </div>
                                </div>
                            </div>
                            <div class="summary_box">
                                <div class="sb_inner">
                                    <span><img src="<c:url value="/images/background/onepage_icon04.png"/>" width="44px"
                                               height="auto" alt="Conference"/></span>
                                    <div class="sb_num">
                                        <dl>
                                            <dt class="enTag">Conference Papers</dt>
                                            <dt class="koTag">학술활동(학술대회)</dt>
                                            <dd class="performCon"></dd>
                                        </dl>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="faculty_wrap" style="padding-top: 45px;margin-bottom: 15px;">
                        <div class="faculty_inner" id="facultyDiv1">
                            <div class="faculty_box">
                                <div class="faculty_t">
                                    <p class="enTag">Faculty <span></span></p>
                                    <p class="koTag">교원수 <span></span></p>
                                </div>
                                <em class="stndYearSpan"></em>
                            </div>
                            <div class="professor_wrap">
                                <div class="professor_row">
                                    <div class="professor_box">
                                        <div class="professor_inner">
                                            <p class="enTag">Assistant Professor</p>
                                            <p class="koTag">조교수</p>
                                            <span></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="professor_row">
                                    <div class="professor_box ap_type">
                                        <div class="professor_inner">
                                            <p class="enTag">Associate Professor</p>
                                            <p class="koTag">부교수</p>
                                            <span></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="professor_row">
                                    <div class="professor_box p_type">
                                        <div class="professor_inner">
                                            <p class="enTag">Professor</p>
                                            <p class="koTag">교수</p>
                                            <span></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div><!-- faculty_wrap : e -->
                    <div class="one_con_wrap">
                        <div class="one_col_lb" style="padding-bottom: 10px;">
                            <h4 class="onepage_title enTag"><span><img
                                    src="<c:url value="/images/analysis/background/chart_icon01.png"/>"
                                    width="16"/></span>Journal Article</h4>
                            <h4 class="onepage_title koTag"><span><img
                                    src="<c:url value="/images/analysis/background/chart_icon01.png"/>"
                                    width="16"/></span>저널논문</h4>
                            <div class="one_chart_box" id="artChartDiv"></div>
                        </div>
                        <div class="one_col_rb" style="padding-bottom: 10px;">
                            <h4 class="onepage_title enTag"><span><img
                                    src="<c:url value="/images/analysis/background/chart_icon02.png"/>"
                                    width="16"/></span>Research Project</h4>
                            <h4 class="onepage_title koTag"><span><img
                                    src="<c:url value="/images/analysis/background/chart_icon02.png"/>"
                                    width="16"/></span>연구비(연구과제)</h4>
                            <div class="one_chart_box" id="fudChartDiv"></div>
                        </div>
                        <div class="one_col_lb">
                            <h4 class="onepage_title enTag"><span><img
                                    src="<c:url value="/images/analysis/background/chart_icon03.png"/>"
                                    width="16"/></span>Patent</h4>
                            <h4 class="onepage_title koTag"><span><img
                                    src="<c:url value="/images/analysis/background/chart_icon03.png"/>"
                                    width="16"/></span>지식재산(특허)</h4>
                            <div class="one_chart_box" id="patChartDiv"></div>
                        </div>
                        <div class="one_col_rb">
                            <h4 class="onepage_title enTag"><span><img
                                    src="<c:url value="/images/analysis/background/chart_icon04.png"/>"
                                    width="16"/></span>Conference Proceeding</h4>
                            <h4 class="onepage_title koTag"><span><img
                                    src="<c:url value="/images/analysis/background/chart_icon04.png"/>"
                                    width="16"/></span>학술활동(학술대회)</h4>
                            <div class="one_chart_box" id="conChartDiv"></div>
                        </div>
                    </div>
                </div>
            </div>
            <div id="div_overviewData" class="onepage_wrap">
                <div class="overview_box">
                    <em class="enTag"><span class="overview_text">Overview Table</span></em>
                    <em class="koTag"><span class="overview_text">요약표</span></em>
                </div>
                <div class="onepage_inner" style="margin-bottom: 10px; margin-bottom: 10px;">
                    <div class="op_title_box">
                        <div class="op_title">
                            <img src="<c:url value="/images/analysis/background/onepage_title01.png"/>" width="436px"
                                 height="auto"/>
                        </div>
                        <div class="year_rbox"><span class='enTag'
                                                     style="color: #777;font-weight:normal;">Year Range</span><span
                                class='koTag' style="color: #777;font-weight:normal;">성과기간</span> <span
                                class="yearRange"></span></div>
                    </div>
                    <div class="top_summary_wrap">
                        <div class="top_summary_row">
                            <div class="summary_box">
                                <div class="sb_inner">
                                    <span><img src="<c:url value="/images/background/onepage_icon01.png"/>" width="44px"
                                               height="auto" alt="Journal Articles"/></span>
                                    <div class="sb_num">
                                        <dl>
                                            <dt class="enTag">Journal Articles</dt>
                                            <dt class="koTag">저널논문</dt>
                                            <dd class="performArt"></dd>
                                        </dl>
                                    </div>
                                </div>
                            </div>
                            <div class="summary_box">
                                <div class="sb_inner">
                                    <span><img src="<c:url value="/images/background/onepage_icon02.png"/>" width="44px"
                                               height="auto" alt="Research Fundings"/></span>
                                    <div class="sb_num">
                                        <dl>
                                            <dt class="enTag">Research Fundings</dt>
                                            <dt class="koTag">연구비(연구과제)</dt>
                                            <dd class="performFud"></dd>
                                        </dl>
                                    </div>
                                </div>
                            </div>
                            <div class="summary_box">
                                <div class="sb_inner">
                                    <span><img src="<c:url value="/images/background/onepage_icon03.png"/>" width="44px"
                                               height="auto" alt="Patents"/></span>
                                    <div class="sb_num">
                                        <dl>
                                            <dt class="enTag">Registered Patents</dt>
                                            <dt class="koTag">지식재산(특허)</dt>
                                            <dd class="performPat"></dd>
                                        </dl>
                                    </div>
                                </div>
                            </div>
                            <div class="summary_box">
                                <div class="sb_inner">
                                    <span><img src="<c:url value="/images/background/onepage_icon04.png"/>" width="44px"
                                               height="auto" alt="Conference"/></span>
                                    <div class="sb_num">
                                        <dl>
                                            <dt class="enTag">Conference Papers</dt>
                                            <dt class="koTag">학술활동(학술대회)</dt>
                                            <dd class="performCon"></dd>
                                        </dl>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="one_con_wrap" style="margin-top: 40px;">
                        <div class="row_box">
                            <h4 class="onepage_title mgb_0 koTag"><span><img
                                    src="<c:url value="/images/analysis/background/chart_icon01.png"/>"
                                    width="16"/></span>저널논문</h4>
                            <h4 class="onepage_title mgb_0 enTag"><span><img
                                    src="<c:url value="/images/analysis/background/chart_icon01.png"/>"
                                    width="16"/></span>Journal Article</h4>
                            <table class="one_tbl" id="artOverTb">
                                <thead>
                                <tr>
                                    <th style="width: 70px;border-right: 1px solid white;" class="koTag">연도</th>
                                    <th style="width: 70px;border-right: 1px solid white;" class="enTag">Year</th>
                                    <th class="koTag" style="border-right: 1px solid white;">전체 논문수</th>
                                    <th class="enTag" style="border-right: 1px solid white;">Total No. of Papers</th>
                                    <th class="koTag" style="border-right: 1px solid white;">SCI 논문수</th>
                                    <th class="enTag" style="border-right: 1px solid white;">SCI Papers</th>
                                    <th class="koTag" style="border-right: 1px solid white;">교원1인당<br/>평균 SCI 논문수</th>
                                    <th style="border-right: 1px solid white;" class="enTag">Avg. No. of Papers<br/>per
                                        Prof.
                                    </th>
                                    <th class="koTag">전임재직교원수</th>
                                    <th class="enTag">Total No. of Professors</th>
                                </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                        <div class="row_box">
                            <h4 class="onepage_title mgb_0 koTag"><span><img
                                    src="<c:url value="/images/analysis/background/chart_icon02.png"/>"
                                    width="16"/></span>연구비(연구과제)</h4>
                            <h4 class="onepage_title mgb_0 enTag"><span><img
                                    src="<c:url value="/images/analysis/background/chart_icon02.png"/>"
                                    width="16"/></span>Research Project</h4>
                            <table class="one_tbl one_tbl" id="fundTb">
                                <thead>
                                <tr>
                                    <th style="width: 70px;border-right: 1px solid white;" class="koTag">연도</th>
                                    <th style="width: 70px;border-right: 1px solid white;" class="enTag">Year</th>
                                    <th class="koTag" style="border-right: 1px solid white;">과제건수</th>
                                    <th class="enTag" style="border-right: 1px solid white;">No. of<br/>Research Project
                                    </th>
                                    <th class="koTag" style="border-right: 1px solid white;">총연구비(백만원)</th>
                                    <th class="enTag" style="border-right: 1px solid white;">Total Research
                                        Fundings<br/>(1 million unit)
                                    </th>
                                    <th class="koTag" style="border-right: 1px solid white;">교원1인당<br/>과제건수</th>
                                    <th class="enTag" style="border-right: 1px solid white;">No. of Research
                                        Project<br/>per Prof.
                                    </th>
                                    <th class="koTag">교원1인당<br/>연구비(백만원)</th>
                                    <th class="enTag">Total Research Fundings<br/>per Prof.(1 million unit)</th>
                                </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                        <div class="one_col_lb" style="margin-bottom: 40px">
                            <h4 class="onepage_title mgb_0 koTag"><span><img
                                    src="<c:url value="/images/analysis/background/chart_icon03.png"/>"
                                    width="16"/></span>지식재산(특허)</h4>
                            <h4 class="onepage_title mgb_0 enTag"><span><img
                                    src="<c:url value="/images/analysis/background/chart_icon03.png"/>"
                                    width="16"/></span>Patent</h4>
                            <table class="one_tbl" id="patTb">
                                <thead>
                                <tr>
                                    <th style="width: 70px;border-right: 1px solid white;" class="koTag">연도</th>
                                    <th style="width: 70px;border-right: 1px solid white;" class="enTag">Year</th>
                                    <th class="koTag" style="border-right: 1px solid white;">출원건수</th>
                                    <th class="enTag" style="border-right: 1px solid white;">Total No. of Application
                                        Patents
                                    </th>
                                    <th class="koTag">등록건수</th>
                                    <th class="enTag">Total No. of Registration Patents</th>
                                </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                        <div class="one_col_rb" style="margin-bottom: 40px">
                            <h4 class="onepage_title mgb_0 koTag"><span><img
                                    src="<c:url value="/images/analysis/background/chart_icon04.png"/>"
                                    width="16"/></span>학술활동(학술대회)</h4>
                            <h4 class="onepage_title mgb_0 enTag"><span><img
                                    src="<c:url value="/images/analysis/background/chart_icon04.png"/>"
                                    width="16"/></span>Conference Proceeding</h4>
                            <table class="one_tbl" id="conTb">
                                <thead>
                                <tr>
                                    <th style="width: 70px;border-right: 1px solid white;" class="koTag">연도</th>
                                    <th style="width: 70px;border-right: 1px solid white;" class="enTag">Year</th>
                                    <th class="koTag" style="border-right: 1px solid white;">국제</th>
                                    <th class="enTag" style="border-right: 1px solid white;">International</th>
                                    <th class="koTag">국내</th>
                                    <th class="enTag">Domestic</th>
                                </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div id="tabs-2">
            <div id="div_sciChart" class="onepage_wrap">
                <div class="overview_box">
                    <em class="enTag"><span class="overview_text">SCI Overview Chart</span></em>
                    <em class="koTag"><span class="overview_text">SCI 요약차트</span></em>
                </div>
                <div class="onepage_inner" style="margin-bottom: 10px; margin-bottom: 10px;">
                    <div class="op_title_box">
                        <div class="op_title">
                            <img src="<c:url value="/images/analysis/background/onepage_title01.png"/>" width="436px"
                                 height="auto"/>
                        </div>
                        <div class="year_rbox"><span class='enTag'
                                                     style="color: #777;font-weight:normal;">Year Range</span><span
                                class='koTag' style="color: #777;font-weight:normal;">성과기간</span> <span
                                class="yearRange"></span></div>
                    </div>
                    <div class="top_summary_wrap">
                        <div class="top_summary_row">
                            <div class="summary_box">
                                <div class="sb_inner">
                                    <span><img src="<c:url value="/images/background/onepage_icon01.png"/>" width="44px"
                                               height="auto" alt="Journal Articles"/></span>
                                    <div class="sb_num">
                                        <dl>
                                            <dt class="enTag">Articles</dt>
                                            <dt class="koTag">논문수</dt>
                                            <dd class="performSciArt"></dd>
                                        </dl>
                                    </div>
                                </div>
                            </div>
                            <div class="summary_box">
                                <div class="sb_inner">
                                    <span><img src="<c:url value="/images/background/onepage_icon05.png"/>" width="44px"
                                               height="auto" alt="Research Fundings"/></span>
                                    <div class="sb_num">
                                        <dl>
                                            <dt class="enTag">Citation Count</dt>
                                            <dt class="koTag">피인용수</dt>
                                            <dd class="performSciTc"></dd>
                                        </dl>
                                    </div>
                                </div>
                            </div>
                            <div class="summary_box">
                                <div class="sb_inner">
                                    <span><img src="<c:url value="/images/background/onepage_icon06.png"/>" width="44px"
                                               height="auto" alt="Patents"/></span>
                                    <div class="sb_num">
                                        <dl>
                                            <dt class="enTag">Citations per Article</dt>
                                            <dt class="koTag">논문당 피인용수</dt>
                                            <dd class="performSciTcAvg"></dd>
                                        </dl>
                                    </div>
                                </div>
                            </div>
                            <div class="summary_box">
                                <div class="sb_inner">
                                    <span><img src="<c:url value="/images/background/onepage_icon07.png"/>" width="44px"
                                               height="auto" alt="Conference"/></span>
                                    <div class="sb_num">
                                        <dl>
                                            <dt class="enTag">IF Count per Article</dt>
                                            <dt class="koTag">논문당 IF</dt>
                                            <dd class="performSciIf"></dd>
                                        </dl>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="faculty_wrap" style="padding-top: 45px;margin-bottom: 15px;">
                        <div class="faculty_inner" id="facultyDiv2">
                            <div class="faculty_box">
                                <div class="faculty_t">
                                    <p class="enTag">Faculty <span></span></p>
                                    <p class="koTag">교원수 <span></span></p>
                                </div>
                                <em class="stndYearSpan"></em>
                            </div>
                            <div class="professor_wrap">
                                <div class="professor_row">
                                    <div class="professor_box">
                                        <div class="professor_inner">
                                            <p class="enTag">Assistant Professor</p>
                                            <p class="koTag">조교수</p>
                                            <span></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="professor_row">
                                    <div class="professor_box ap_type">
                                        <div class="professor_inner">
                                            <p class="enTag">Associate Professor</p>
                                            <p class="koTag">부교수</p>
                                            <span></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="professor_row">
                                    <div class="professor_box p_type">
                                        <div class="professor_inner">
                                            <p class="enTag">Professor</p>
                                            <p class="koTag">교수</p>
                                            <span></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div><!-- faculty_wrap : e -->
                    <div class="one_con_wrap" style="padding-top: 20px;">
                        <div class="one_col_lb">
                            <h4 class="onepage_title enTag">SCI Papers</h4>
                            <h4 class="onepage_title koTag">SCI 논문수</h4>
                            <div class="one_chart_box" id="sciArtChartDiv"></div>
                        </div>
                        <div class="one_col_rb">
                            <h4 class="onepage_title enTag">Impact Factor(IF)</h4>
                            <h4 class="onepage_title koTag">Impact Factor(IF)</h4>
                            <div class="one_chart_box" id="sciIfChartDiv"></div>
                        </div>
                    </div>
                    <div class="one_con_wrap">
                        <div style="padding-top: 20px;">
                            <h4 class="onepage_title enTag" style="margin-bottom: 0px;">Published Journal Analysis</h4>
                            <h4 class="onepage_title koTag" style="margin-bottom: 0px;">저널논문분석</h4>
                            <div class="second_chart_box" id="journalChartDiv"></div>
                        </div>
                        <div id="keywordDiv">
                            <h4 class="onepage_title enTag">Keyword Trend Network</h4>
                            <h4 class="onepage_title koTag">키워드 네트워크</h4>
                            <div class="second_chart_box" id="keywordChartDiv"></div>
                        </div>
                        <div id="networkDiv" style="padding-top: 20px;height: 450px;">
                            <h4 class="onepage_title enTag">Collaboration Network</h4>
                            <h4 class="onepage_title koTag">협력연구 네트워크</h4>
                            <div class="second_chart_box" id="deptChartDiv"></div>
                        </div>
                    </div>
                </div>
            </div>
            <div id="div_sciData" class="onepage_wrap">
                <div class="overview_box">
                    <em class="enTag"><span class="overview_text">SCI Overview Table</span></em>
                    <em class="koTag"><span class="overview_text">SCI 요약표</span></em>
                </div>
                <div class="onepage_inner" style="margin-bottom: 10px; margin-bottom: 10px;">
                    <div class="op_title_box">
                        <div class="op_title">
                            <img src="<c:url value="/images/analysis/background/onepage_title01.png"/>" width="436px"
                                 height="auto"/>
                        </div>
                        <div class="year_rbox"><span class='enTag'
                                                     style="color: #777;font-weight:normal;">Year Range</span><span
                                class='koTag' style="color: #777;font-weight:normal;">성과기간</span> <span
                                class="yearRange"></span></div>
                    </div>
                    <div class="top_summary_wrap">
                        <div class="top_summary_row">
                            <div class="summary_box">
                                <div class="sb_inner">
                                    <span><img src="<c:url value="/images/background/onepage_icon01.png"/>" width="44px"
                                               height="auto" alt="Journal Articles"/></span>
                                    <div class="sb_num">
                                        <dl>
                                            <dt class="enTag">Articles</dt>
                                            <dt class="koTag">논문수</dt>
                                            <dd class="performSciArt"></dd>
                                        </dl>
                                    </div>
                                </div>
                            </div>
                            <div class="summary_box">
                                <div class="sb_inner">
                                    <span><img src="<c:url value="/images/background/onepage_icon05.png"/>" width="44px"
                                               height="auto" alt="Research Fundings"/></span>
                                    <div class="sb_num">
                                        <dl>
                                            <dt class="enTag">Citation Count</dt>
                                            <dt class="koTag">피인용수</dt>
                                            <dd class="performSciTc"></dd>
                                        </dl>
                                    </div>
                                </div>
                            </div>
                            <div class="summary_box">
                                <div class="sb_inner">
                                    <span><img src="<c:url value="/images/background/onepage_icon06.png"/>" width="44px"
                                               height="auto" alt="Patents"/></span>
                                    <div class="sb_num">
                                        <dl>
                                            <dt class="enTag">Citations per Article</dt>
                                            <dt class="koTag">논문당 피인용수</dt>
                                            <dd class="performSciTcAvg"></dd>
                                        </dl>
                                    </div>
                                </div>
                            </div>
                            <div class="summary_box">
                                <div class="sb_inner">
                                    <span><img src="<c:url value="/images/background/onepage_icon07.png"/>" width="44px"
                                               height="auto" alt="Conference"/></span>
                                    <div class="sb_num">
                                        <dl>
                                            <dt class="enTag">IF Count per Article</dt>
                                            <dt class="koTag">논문당 IF</dt>
                                            <dd class="performSciIf"></dd>
                                        </dl>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="one_con_wrap" style="margin-top: 40px;">
                        <div class="row_box">
                            <h4 class="onepage_title mgb_0 koTag">SCI 논문 요약 상세 (논문별기준)</h4>
                            <h4 class="onepage_title mgb_0 enTag">Detailed Summary of SCI Papers by Article</h4>
                            <table class="one_tbl" id="sciAnalyTb">
                                <thead>
                                <tr>
                                    <th style="border-right: 1px solid white;" class="koTag">연도</th>
                                    <th style="width: 70px;border-right: 1px solid white;" class="enTag">Year</th>
                                    <th style="border-right: 1px solid white;" class="koTag">SCI 전체 논문수</th>
                                    <th style="border-right: 1px solid white;" class="enTag">Total of SCI Papers</th>
                                    <th style="border-right: 1px solid white;" class="koTag">피인용수<br/>합계</th>
                                    <th style="border-right: 1px solid white;" class="enTag">Total of Citations</th>
                                    <th style="border-right: 1px solid white;" class="koTag">IF<br/>합계</th>
                                    <th style="border-right: 1px solid white;" class="enTag">Total of IF</th>
                                    <th style="border-right: 1px solid white;" class="koTag">논문당 평균<br/>피인용 횟수</th>
                                    <th style="border-right: 1px solid white;" class="enTag">Avg. No. of Citations<br/>per
                                        Paper
                                    </th>
                                    <th style="border-right: 1px solid white;" class="koTag">교원1인당<br/>평균 논문수</th>
                                    <th style="border-right: 1px solid white;" class="enTag">Avg. No. of Papers<br/>per
                                        Prof.
                                    </th>
                                    <th style="border-right: 1px solid white;" class="koTag">교원1인당<br/>평균 IF합계</th>
                                    <th style="border-right: 1px solid white;" class="enTag">Total of Avg. No. of
                                        IF<br/>per Prof.
                                    </th>
                                    <th style="border-right: 1px solid white;" class="koTag">교원1인의<br/>논문 1편당 평균 IF</th>
                                    <th style="border-right: 1px solid white;" class="enTag">Avg. No. of IF per
                                        Paper<br/>of a prof.
                                    </th>
                                    <th class="koTag">전임재직<br/>교원수</th>
                                    <th class="enTag">No. of Professors</th>
                                </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                        <div class="row_box">
                            <h4 class="onepage_title mgb_0 koTag">SCI 논문 요약 상세 (교원개인별기준)</h4>
                            <h4 class="onepage_title mgb_0 enTag">Detailed Summary of SCI Papers by Professor</h4>
                            <table class="one_tbl" id="sciAnalyTb1">
                                <thead>
                                <tr>
                                    <th style="border-right: 1px solid white;" class="koTag">연도</th>
                                    <th style="width: 70px;border-right: 1px solid white;" class="enTag">Year</th>
                                    <th style="border-right: 1px solid white;" class="koTag">SCI 전체 논문수</th>
                                    <th style="border-right: 1px solid white;" class="enTag">Total of SCI Papers</th>
                                    <th style="border-right: 1px solid white;" class="koTag">피인용수<br/>합계</th>
                                    <th style="border-right: 1px solid white;" class="enTag">Total of Citations</th>
                                    <th style="border-right: 1px solid white;" class="koTag">IF<br/>합계</th>
                                    <th style="border-right: 1px solid white;" class="enTag">Total of IF</th>
                                    <th style="border-right: 1px solid white;" class="koTag">논문당 평균<br/>피인용 횟수</th>
                                    <th style="border-right: 1px solid white;" class="enTag">Avg. No. of Citations<br/>per
                                        Paper
                                    </th>
                                    <th style="border-right: 1px solid white;" class="koTag">교원1인당<br/>평균 논문수</th>
                                    <th style="border-right: 1px solid white;" class="enTag">Avg. No. of Papers<br/>per
                                        Prof.
                                    </th>
                                    <th style="border-right: 1px solid white;" class="koTag">교원1인당<br/>평균 IF합계</th>
                                    <th style="border-right: 1px solid white;" class="enTag">Total of Avg. No. of
                                        IF<br/>per Prof.
                                    </th>
                                    <th style="border-right: 1px solid white;" class="koTag">교원1인의<br/>논문 1편당 평균 IF</th>
                                    <th style="border-right: 1px solid white;" class="enTag">Avg. No. of IF per
                                        Paper<br/>of a prof.
                                    </th>
                                    <th class="koTag">전임재직<br/>교원수</th>
                                    <th class="enTag">No. of Professors</th>
                                </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                        <div class="row_box">
                            <h4 class="onepage_title mgb_0 koTag">SCI 논문 IF 주제별 분석(상위10%이내)</h4>
                            <h4 class="onepage_title mgb_0 enTag">Analysis of SCI Papers by IF Category(within the top
                                10%)</h4>
                            <table class="one_tbl" id="sciAnalyTb2">
                                <thead>
                                <tr>
                                    <th style="width: 70px;border-right: 1px solid white;" class="koTag">연도</th>
                                    <th style="width: 70px;border-right: 1px solid white;" class="enTag">Year</th>
                                    <th style="border-right: 1px solid white;" class="koTag">SCI 전체 논문수</th>
                                    <th style="border-right: 1px solid white;" class="enTag">Total of SCI Papers</th>
                                    <th style="border-right: 1px solid white;" class="koTag">IF 10% 논문수<br/>by 주제별</th>
                                    <th style="border-right: 1px solid white;" class="enTag">No. of the top 10% papers
                                    </th>
                                    <th style="border-right: 1px solid white;" class="koTag">IF 10% 논문비율<br/>by 주제별</th>
                                    <th style="border-right: 1px solid white;" class="enTag">Ratio of the top 10%
                                        papers
                                    </th>
                                    <th class="koTag">IF 10% 이내<br/>주제분야수</th>
                                    <th class="enTag">No. of subject category<br/>within the top 10%</th>
                                </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                        <div class="row_box">
                            <h4 class="onepage_title mgb_0 koTag">SCI 논문 IF 주제별 분석(상위20%이내)</h4>
                            <h4 class="onepage_title mgb_0 enTag">Analysis of SCI Papers by IF Category(within the top
                                20%)</h4>
                            <table class="one_tbl" id="sciAnalyTb3">
                                <thead>
                                <tr>
                                    <th style="width: 70px;border-right: 1px solid white;" class="koTag">연도</th>
                                    <th style="width: 70px;border-right: 1px solid white;" class="enTag">Year</th>
                                    <th style="border-right: 1px solid white;" class="koTag">SCI 전체 논문수</th>
                                    <th style="border-right: 1px solid white;" class="enTag">Total of SCI Papers</th>
                                    <th style="border-right: 1px solid white;" class="koTag">IF 20% 논문수<br/>by 주제별</th>
                                    <th style="border-right: 1px solid white;" class="enTag">No. of the top 20% papers
                                    </th>
                                    <th style="border-right: 1px solid white;" class="koTag">IF 20% 논문비율<br/>by 주제별</th>
                                    <th style="border-right: 1px solid white;" class="enTag">Ratio of the top 20%
                                        papers
                                    </th>
                                    <th class="koTag">IF 20% 이내<br/>주제분야수</th>
                                    <th class="enTag">No. of subject category<br/>within the top 20%</th>
                                </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                        <div class="row_box">
                            <h4 class="onepage_title mgb_0 koTag">SCI 논문 피인용수 분석</h4>
                            <h4 class="onepage_title mgb_0 enTag">Analysis of Citation Information on SCI Papers</h4>
                            <table class="one_tbl" id="sciTcAnalyTb">
                                <thead>
                                <tr>
                                    <th style="width: 70px;border-right: 1px solid white;" class="koTag">연도</th>
                                    <th style="width: 70px;border-right: 1px solid white;" class="enTag">Year</th>
                                    <th style="border-right: 1px solid white;" class="koTag">SCI 전체 논문수</th>
                                    <th style="border-right: 1px solid white;" class="enTag">Total of SCI Papers</th>
                                    <th style="border-right: 1px solid white;" class="koTag">세계상위1%<br/>피인용논문수</th>
                                    <th style="border-right: 1px solid white;" class="enTag">No. of Citation Papers<br/>within
                                        the top 1%
                                    </th>
                                    <th style="border-right: 1px solid white;" class="koTag">피인용된<br/>논문수</th>
                                    <th style="border-right: 1px solid white;" class="enTag">No. of Citation Papers</th>
                                    <th style="border-right: 1px solid white;" class="koTag">피인용된<br/>논문비율</th>
                                    <th style="border-right: 1px solid white;" class="enTag">Ratio of Citation Papers
                                    </th>
                                    <th class="koTag">인용되지 않은<br/>논문수</th>
                                    <th class="enTag">No. of Non-Citation Papers</th>
                                </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                        <div class="row_box">
                            <h4 class="onepage_title mgb_0 enTag">Published Journal Analysis</h4>
                            <h4 class="onepage_title mgb_0 koTag">저널논문분석</h4>
                            <table class="one_tbl" id="journalTb">
                                <thead>
                                <tr>
                                    <th style="width: 70px;border-right: 1px solid white;" class="koTag">순서</th>
                                    <th style="width: 70px;border-right: 1px solid white;" class="enTag">No</th>
                                    <th style="border-right: 1px solid white;" class="koTag">저널명</th>
                                    <th style="border-right: 1px solid white;" class="enTag">Journal</th>
                                    <th style="border-right: 1px solid white;">ISSN</th>
                                    <th style="width: 70px;border-right: 1px solid white;" class="koTag">총 논문수</th>
                                    <th style="width: 70px;border-right: 1px solid white;" class="enTag">Total No. of
                                        Papers
                                    </th>
                                    <th style="width: 95px;" class="koTag">총 저자수</th>
                                    <th style="width: 95px;" class="enTag">Total No. of Authors</th>
                                </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                        <div class="row_box">
                            <h4 class="onepage_title mgb_0 enTag">Keyword Trend Network</h4>
                            <h4 class="onepage_title mgb_0 koTag">키워드 네트워크</h4>
                            <table class="one_tbl" id="keywordTb">
                                <colgroup>
                                    <col width="30%">
                                    <col width="20%">
                                    <col width="30%">
                                    <col width="20%">
                                </colgroup>
                                <thead>
                                <tr>
                                    <th style="border-right: 1px solid white;" class="koTag">키워드</th>
                                    <th style="border-right: 1px solid white;" class="enTag">Keyword</th>
                                    <th style="border-right: 1px solid white;" class="koTag">빈도수</th>
                                    <th style="border-right: 1px solid white;" class="enTag">Frequency</th>
                                    <th style="border-right: 1px solid white;" class="koTag">키워드</th>
                                    <th style="border-right: 1px solid white;" class="enTag">Keyword</th>
                                    <th class="koTag">빈도수</th>
                                    <th class="enTag">Frequency</th>
                                </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                        <div class="row_box">
                            <h4 class="onepage_title mgb_0 enTag">Collaboration Network</h4>
                            <h4 class="onepage_title mgb_0 koTag">협력연구 네트워크</h4>
                            <table class="one_tbl" id="networkTb">
                                <thead>
                                <tr>
                                    <th style="width: 70px;border-right: 1px solid white;" class="koTag">순서</th>
                                    <th style="width: 70px;border-right: 1px solid white;" class="enTag">No</th>
                                    <th style="border-right: 1px solid white;" class="koTag">기관명</th>
                                    <th style="border-right: 1px solid white;" class="enTag">Institution</th>
                                    <th style="border-right: 1px solid white;" class="koTag">비율</th>
                                    <th style="border-right: 1px solid white;" class="enTag">Percentage</th>
                                    <th class="koTag">논문수</th>
                                    <th class="enTag">Total No. of Papers</th>
                                </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div id="tabs-3" style="font-family:맑은 고딕;">
            <div id="div_jnlArt" class="onepage_wrap">
                <div class="overview_box">
                    <span class="overview_text">Journal by Article</span>
                </div>
                <div class="onepage_inner" style="margin-bottom: 10px; margin-bottom: 10px;">
                    <div class="op_title_box">
                        <div class="op_title">
                            <img src="<c:url value="/images/analysis/background/onepage_title01.png"/>" width="436px"
                                 height="auto"/>
                        </div>
                        <div class="year_rbox"><span style="color: #777;font-weight:normal;">Year Range</span> <span
                                class="yearRange"></span></div>
                    </div>
                    <div class="one_con_wrap">
                        <div class="row_box" style="margin-top: 5px;">
                            <h4 class="onepage_title mgb_0">한국연구재단기준 통계(논문별기준)</h4>
                            <table class="one_tbl" id="abstArtTb">
                                <thead>
                                <tr>
                                    <th rowspan="2" style="width: 45px;border-right: 1px solid white;">연도</th>
                                    <th colspan="3"
                                        style="width: 50px;border-right: 1px solid white;border-bottom: 1px solid white;">
                                        국제논문
                                    </th>
                                    <th colspan="3"
                                        style="border-right: 1px solid white;border-bottom: 1px solid white;">국내논문
                                    </th>
                                    <th rowspan="2" style="border-right: 1px solid white;">총계</th>
                                    <th colspan="4"
                                        style="border-right: 1px solid white;border-bottom: 1px solid white;">SCI/SSCI
                                    </th>
                                    <th rowspan="2">전임재직교원수</th>
                                </tr>
                                <tr>
                                    <th style="width: 56px;border-right: 1px solid white;">국제전문<br/>학술지</th>
                                    <th style="width: 56px;border-right: 1px solid white;">국제일반<br/>학술지</th>
                                    <th style="border-right: 1px solid white;">소계</th>
                                    <th style="width: 56px;border-right: 1px solid white;">국내전문<br/>학술지</th>
                                    <th style="width: 56px;border-right: 1px solid white;">국내일반<br/>학술지</th>
                                    <th style="border-right: 1px solid white;">소계</th>
                                    <th style="border-right: 1px solid white;">국내<br/>논문</th>
                                    <th style="border-right: 1px solid white;">국제<br/>논문</th>
                                    <th style="border-right: 1px solid white;">피인용수<br/>합계</th>
                                    <th style="border-right: 1px solid white;">IF<br/>합계</th>
                                </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                        <div class="row_box">
                            <h4 class="onepage_title mgb_0">SCI논문 출판국가 구분 통계(논문별기준)</h4>
                            <table class="one_tbl" id="abstSciConTb">
                                <thead>
                                <tr>
                                    <th rowspan="2" style="width: 70px; border-right: 1px solid white;">연도</th>
                                    <th colspan="2"
                                        style="border-right: 1px solid white;border-bottom: 1px solid white;">SCI급
                                    </th>
                                    <th rowspan="2" style="border-right: 1px solid white;">소계</th>
                                    <th rowspan="2" style="border-right: 1px solid white;">피인용수<br/>합계</th>
                                    <th rowspan="2" style="border-right: 1px solid white;">IF<br/>합계</th>
                                    <th rowspan="2">전임재직교원수</th>
                                </tr>
                                <tr>
                                    <th style="border-right: 1px solid white;">국내</th>
                                    <th style="border-right: 1px solid white;">국제</th>
                                </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                        <div class="row_box">
                            <h4 class="onepage_title mgb_0">국제/국내 구분 통계(논문별기준)</h4>
                            <table class="one_tbl" id="abstConTb">
                                <thead>
                                <tr>
                                    <th rowspan="2" style="width: 70px;border-right: 1px solid white;">연도</th>
                                    <th rowspan="2" style="border-right: 1px solid white;">총계</th>
                                    <th colspan="2"
                                        style="border-right: 1px solid white;border-bottom: 1px solid white;">국제논문
                                    </th>
                                    <th colspan="2"
                                        style="border-right: 1px solid white;border-bottom: 1px solid white;">국내논문
                                    </th>
                                    <th rowspan="2">전임재직교원수</th>
                                </tr>
                                <tr>
                                    <th style="border-right: 1px solid white;">SCI급</th>
                                    <th style="border-right: 1px solid white;">비SCI급</th>
                                    <th style="border-right: 1px solid white;">SCI급</th>
                                    <th style="border-right: 1px solid white;">비SCI급</th>
                                </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                        <div class="row_box">
                            <h4 class="onepage_title mgb_0">SCI 논문 상세 통계(논문별기준)</h4>
                            <table class="one_tbl" id="abstSciTb">
                                <thead>
                                <tr>
                                    <th style="width: 70px;border-right: 1px solid white;">연도</th>
                                    <th style="border-right: 1px solid white;">SCI 논문수</th>
                                    <th style="border-right: 1px solid white;">IF<br/>합계</th>
                                    <th style="border-right: 1px solid white;">피인용수 합계</th>
                                    <th style="border-right: 1px solid white;">교원1인당<br/>평균논문수</th>
                                    <th style="border-right: 1px solid white;">논문당<br/>평균피인용수</th>
                                    <th>전임재직교원수</th>
                                </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                        <div class="row_box">
                            <h4 class="onepage_title mgb_0">SCI/비SCI논문수 통계(논문별기준)</h4>
                            <table class="one_tbl" id="abstSciEtcTb">
                                <thead>
                                <tr>
                                    <th style="width: 70px;border-right: 1px solid white;">연도</th>
                                    <th style="border-right: 1px solid white;">SCI 논문수</th>
                                    <th style="border-right: 1px solid white;">비SCI논문수</th>
                                    <th style="border-right: 1px solid white;">전체</th>
                                    <th>전임재직교원수</th>
                                </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <div id="div_jnlRsch" class="onepage_wrap">
                <div class="overview_box">
                    <span class="overview_text">Journal by Professor</span>
                </div>
                <div class="onepage_inner" style="margin-bottom: 10px; margin-bottom: 10px;">
                    <div class="op_title_box">
                        <div class="op_title">
                            <img src="<c:url value="/images/analysis/background/onepage_title01.png"/>" width="436px"
                                 height="auto"/>
                        </div>
                        <div class="year_rbox"><span style="color: #777;font-weight:normal;">Year Range</span> <span
                                class="yearRange"></span></div>
                    </div>
                    <div class="one_con_wrap">
                        <div class="row_box" style="margin-top: 5px;">
                            <h4 class="onepage_title mgb_0">한국연구재단기준 통계(교원개인별기준)</h4>
                            <table class="one_tbl" id="abstArtTb2">
                                <thead>
                                <tr>
                                    <th rowspan="2" style="width: 45px;border-right: 1px solid white;">연도</th>
                                    <th colspan="3"
                                        style="width: 50px;border-right: 1px solid white;border-bottom: 1px solid white;">
                                        국제논문
                                    </th>
                                    <th colspan="3"
                                        style="border-right: 1px solid white;border-bottom: 1px solid white;">국내논문
                                    </th>
                                    <th rowspan="2" style="border-right: 1px solid white;">총계</th>
                                    <th colspan="4"
                                        style="border-right: 1px solid white;border-bottom: 1px solid white;">SCI/SSCI
                                    </th>
                                    <th rowspan="2">전임재직교원수</th>
                                </tr>
                                <tr>
                                    <th style="width: 56px;border-right: 1px solid white;">국제전문<br/>학술지</th>
                                    <th style="width: 56px;border-right: 1px solid white;">국제일반<br/>학술지</th>
                                    <th style="border-right: 1px solid white;">소계</th>
                                    <th style="width: 56px;border-right: 1px solid white;">국내전문<br/>학술지</th>
                                    <th style="width: 56px;border-right: 1px solid white;">국내일반<br/>학술지</th>
                                    <th style="border-right: 1px solid white;">소계</th>
                                    <th style="border-right: 1px solid white;">국내<br/>논문</th>
                                    <th style="border-right: 1px solid white;">국제<br/>논문</th>
                                    <th style="border-right: 1px solid white;">피인용수<br/>합계</th>
                                    <th style="border-right: 1px solid white;">IF<br/>합계</th>
                                </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                        <div class="row_box">
                            <h4 class="onepage_title mgb_0">SCI논문 출판국가 구분 통계(교원개인별기준)</h4>
                            <table class="one_tbl" id="abstSciConTb2">
                                <thead>
                                <tr>
                                    <th rowspan="2" style="width: 70px;border-right: 1px solid white;">연도</th>
                                    <th colspan="2"
                                        style="border-right: 1px solid white;border-bottom: 1px solid white;">SCI급
                                    </th>
                                    <th rowspan="2" style="border-right: 1px solid white;">소계</th>
                                    <th rowspan="2" style="border-right: 1px solid white;">피인용수<br/>합계</th>
                                    <th rowspan="2" style="border-right: 1px solid white;">IF<br/>합계</th>
                                    <th rowspan="2">전임재직교원수</th>
                                </tr>
                                <tr>
                                    <th style="border-right: 1px solid white;">국내</th>
                                    <th style="border-right: 1px solid white;">국제</th>
                                </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                        <div class="row_box">
                            <h4 class="onepage_title mgb_0">국제/국내 구분 통계(교원개인별기준)</h4>
                            <table class="one_tbl" id="abstConTb2">
                                <thead>
                                <tr>
                                    <th rowspan="2" style="width: 70px;border-right: 1px solid white;">연도</th>
                                    <th rowspan="2" style="border-right: 1px solid white;">총계</th>
                                    <th colspan="2"
                                        style="border-right: 1px solid white;border-bottom: 1px solid white;">국제논문
                                    </th>
                                    <th colspan="2"
                                        style="border-right: 1px solid white;border-bottom: 1px solid white;">국내논문
                                    </th>
                                    <th rowspan="2">전임재직교원수</th>
                                </tr>
                                <tr>
                                    <th style="border-right: 1px solid white;">SCI급</th>
                                    <th style="border-right: 1px solid white;">비SCI급</th>
                                    <th style="border-right: 1px solid white;">SCI급</th>
                                    <th style="border-right: 1px solid white;">비SCI급</th>
                                </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                        <div class="row_box">
                            <h4 class="onepage_title mgb_0">SCI 논문 상세 통계(교원개인별기준)</h4>
                            <table class="one_tbl" id="abstSciTb2">
                                <thead>
                                <tr>
                                    <th style="width: 70px;border-right: 1px solid white;">연도</th>
                                    <th style="border-right: 1px solid white;">SCI 논문수</th>
                                    <th style="border-right: 1px solid white;">IF<br/>합계</th>
                                    <th style="border-right: 1px solid white;">피인용수 합계</th>
                                    <th style="border-right: 1px solid white;">교원1인당<br/>평균논문수</th>
                                    <th style="border-right: 1px solid white;">논문당<br/>평균피인용수</th>
                                    <th>전임재직교원수</th>
                                </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                        <div class="row_box">
                            <h4 class="onepage_title mgb_0">SCI/비SCI논문수 통계(교원개인별기준)</h4>
                            <table class="one_tbl" id="abstSciEtcTb2">
                                <thead>
                                <tr>
                                    <th style="width: 70px;border-right: 1px solid white;">연도</th>
                                    <th style="border-right: 1px solid white;">SCI 논문수</th>
                                    <th style="border-right: 1px solid white;">비SCI논문수</th>
                                    <th style="border-right: 1px solid white;">전체</th>
                                    <th>전임재직교원수</th>
                                </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div id="tabs-4" style="font-family:맑은 고딕;">
            <div id="div_abstArt" class="onepage_wrap">
                <div class="overview_box">
                    <span class="overview_text">Journal by Article</span>
                </div>
                <div class="onepage_inner" style="margin-bottom: 10px; margin-bottom: 10px;">
                    <div class="op_title_box">
                        <div class="op_title">
                            <img src="<c:url value="/images/analysis/background/onepage_title01.png"/>" width="436px"
                                 height="auto"/>
                        </div>
                        <div class="year_rbox stndYearDiv"></div>
                    </div>
                    <div class="one_con_wrap">
                        <div class="row_box">
                            <h4 class="onepage_title mgb_0">국내/국제 논문 기준 요약 통계</h4>
                            <table class="one_tbl" id="abstArtByArtTb">
                                <thead>
                                <tr>
                                    <th rowspan="2" style="width: 65px;border-right: 1px solid white;">학과</th>
                                    <th colspan="3"
                                        style="border-right: 1px solid white;border-bottom: 1px solid white;">국제논문
                                    </th>
                                    <th colspan="3"
                                        style="border-right: 1px solid white;border-bottom: 1px solid white;">국내논문
                                    </th>
                                    <th rowspan="2" style="border-right: 1px solid white;">총계</th>
                                    <th colspan="4"
                                        style="border-right: 1px solid white;border-bottom: 1px solid white;">SCI/SSCI
                                    </th>
                                    <th rowspan="2">전임재직<br/>교원수</th>
                                </tr>
                                <tr>
                                    <th style="width: 56px;border-right: 1px solid white;">국제전문<br/>학술지</th>
                                    <th style="width: 56px;border-right: 1px solid white;">국제일반<br/>학술지</th>
                                    <th style="border-right: 1px solid white;">소계</th>
                                    <th style="width: 56px;border-right: 1px solid white;">국내전문<br/>학술지</th>
                                    <th style="width: 56px;border-right: 1px solid white;">국내일반<br/>학술지</th>
                                    <th style="border-right: 1px solid white;">소계</th>
                                    <th style="border-right: 1px solid white;">국내<br/>논문</th>
                                    <th style="border-right: 1px solid white;">국제<br/>논문</th>
                                    <th style="width: 56px;border-right: 1px solid white;">피인용수<br/>합계</th>
                                    <th style="border-right: 1px solid white;">IF<br/>합계</th>
                                </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <div id="div_abstRsch" class="onepage_wrap">
                <div class="overview_box">
                    <span class="overview_text">Journal by Professor</span>
                </div>
                <div class="onepage_inner" style="margin-bottom: 10px; margin-bottom: 10px;">
                    <div class="op_title_box">
                        <div class="op_title">
                            <img src="<c:url value="/images/analysis/background/onepage_title01.png"/>" width="436px"
                                 height="auto"/>
                        </div>
                        <div class="year_rbox stndYearDiv"></div>
                    </div>
                    <div class="one_con_wrap">
                        <div class="row_box">
                            <h4 class="onepage_title mgb_0">국내/국제 논문 기준 요약 통계</h4>
                            <table class="one_tbl" id="abstArtByRschTb">
                                <thead>
                                <tr>
                                    <th rowspan="2" style="width: 65px;border-right: 1px solid white;">학과</th>
                                    <th colspan="3"
                                        style="border-right: 1px solid white;border-bottom: 1px solid white;">국제논문
                                    </th>
                                    <th colspan="3"
                                        style="border-right: 1px solid white;border-bottom: 1px solid white;">국내논문
                                    </th>
                                    <th rowspan="2" style="border-right: 1px solid white;">총계</th>
                                    <th colspan="4"
                                        style="border-right: 1px solid white;border-bottom: 1px solid white;">SCI/SSCI
                                    </th>
                                    <th rowspan="2">전임재직<br/>교원수</th>
                                </tr>
                                <tr>
                                    <th style="width: 56px;border-right: 1px solid white;">국제전문<br/>학술지</th>
                                    <th style="width: 56px;border-right: 1px solid white;">국제일반<br/>학술지</th>
                                    <th style="border-right: 1px solid white;">소계</th>
                                    <th style="width: 56px;border-right: 1px solid white;">국내전문<br/>학술지</th>
                                    <th style="width: 56px;border-right: 1px solid white;">국내일반<br/>학술지</th>
                                    <th style="border-right: 1px solid white;">소계</th>
                                    <th style="border-right: 1px solid white;">국내<br/>논문</th>
                                    <th style="border-right: 1px solid white;">국제<br/>논문</th>
                                    <th style="width: 56px;border-right: 1px solid white;">피인용수<br/>합계</th>
                                    <th style="border-right: 1px solid white;">IF<br/>합계</th>
                                </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="onepage_footer">
            <p style="font-size: 11px;letter-spacing:-0.5px">이 Report는 RIMS 데이터를 기반으로 작성되었습니다. 각 성과별 수치는 참조용이며 연구과제, 특허는
                현재기준 ERP 데이터와 다를 수 있습니다.</p>
            Export Date : <span></span>, Data Source : RIMS
        </div>
        <br/>
    </div>
    <textarea id="text" style="display: none;"></textarea>
</div>
<form id="svgToImgForm"></form>

<%--<div id="dialog" class="popup_box modal modal_layer" style="width: 500px;height: 580px;display: none;">--%>
<%--<div class="popup_header">--%>
<%--<h3>Explorer로 인쇄시 필요한 설정</h3>--%>
<%--<a href="#" class="close_bt closeBtn">닫기</a>--%>
<%--</div>--%>
<%--<div class="popup_inner">--%>
<%--<div style="text-align:center;">--%>
<%--<img src="<c:url value="/images/analysis/background/print_help.png"/>" width="436px"height="auto" />--%>
<%--</div>--%>
<%--<div style="margin-top: 20px;">--%>
<%--<span>1. 인쇄 미리보기 화면에서 페이지 설정(Alt+U) 클릭</span><br/>--%>
<%--<span>2. 배경색 및 이미지 인쇄(C) 클릭</span><br/>--%>
<%--<span>3. 머리글/바닥글 모두 비어 있음으로 설정</span><br/>--%>
<%--<span>4. 확인 클릭 후 인쇄</span>--%>
<%--</div>--%>
<%--</div>--%>
<%--</div>--%>

</body>
</html>
