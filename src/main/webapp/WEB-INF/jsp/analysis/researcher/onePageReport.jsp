<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>One Page Report</title>
<style type="text/css">
.list_tbl {margin-bottom: 20px;}
.black_bt .pdf_icon { background:url("<c:url value="/images/analysis/background/pdf_icon.png"/>") no-repeat 0 6px; }
.black_bt .print_icon { background:url("<c:url value="/images/analysis/background/print_icon.png"/>") no-repeat 0 6px; }
.black_bt .question_icon { background:url("<c:url value="/images/analysis/background/question_icon.png"/>") no-repeat 0 6px; }
@media print {
    * {-webkit-print-color-adjust: exact;  }
}
@page {
    margin:5mm 5mm 5mm 5mm;
}
table, td { border: 1px solid gray;  }
.to_bt_box a{background:#e56d28;color: #fff;padding: 0 16px;  display: inline-block;  line-height: 20px; font-size: 12px;  }
.to_bt_box a:hover { background:#ca5d1e;  }
.enTag {font-family:Arial Narrow}
/*.koTag {font-family:맑은 고딕}*/

.op_title_box { overflow: hidden; margin-bottom: 10px; position: relative; border-bottom: 1px dashed #bebebe;  padding: 0 0 15px 0;}
.op_title p img{ vertical-align: middle; }
.op_title p span { display: inline-block; vertical-align: middle;   font-size: 18px; color: #4f4f4f;  margin: 0 0 0 12px; }
.top_summary_wrap { background: #f0f0f0; margin: 0 0 20px 0; padding: 26px 25px 34px 25px;  position: relative; }
.highly_tbl td { border: 0px; }
.one_con_wrap {margin-top: 20px;}

@media all and (min-width :1440px)  {
    .header_box {width:1140px; margin: 0 auto;}
    .contenst_wrap { width:1140px; margin: 0 auto;}
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
var resFlag1,resFlag2,resFlag3,resFlag5 = false;
var colors = '#5e83d0,#FFDC00';
var colors2 = '#358ada,#FF4136';
var initNum = 1;

$(function(){
    bindModalLink();
    subTab("tab1","chart");
    search();
    $("#tabs").tabs({
        activate: function( event, ui ) {
            if(ui.newPanel.is('#tabs-1')){
                tabOnOff("tab1");
                subTab("tab1","chart");

                if(!resFlag1){
                    $('.wrap-loading').css('display', '');
                }else{
                    $('.wrap-loading').css('display','none');
                }
            }

            if(ui.newPanel.is('#tabs-2')){
                tabOnOff("tab2");
                subTab("tab2","chart");

                if(!resFlag3){
                    $('.wrap-loading').css('display', '');
                }else{
                    $('.wrap-loading').css('display','none');
                }
            }

            if(ui.newPanel.is('#tabs-3')){
                tabOnOff("tab3");
                subTab("tab3","chart");

                if(!resFlag5){
                    $('.wrap-loading').css('display', '');
                }else{
                    $('.wrap-loading').css('display','none');
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

function tabOnOff(tabId){
    $('#'+tabId).blur();
    $('.tab_menu').removeClass("on");
    $('#'+tabId).addClass("on");
}

function search() {

    if(initNum != 1 && (!resFlag1 || !resFlag2 || !resFlag3 || !resFlag5)){
        dhtmlx.alert("모든 탭의 결과가 표시된 후 다시 눌러주세요.");
        return;
    }
    initNum = 0;

    if(!validateRange()){
        dhtmlx.alert("실적기간 범위를 올바로 선택해주세요.");
        $("#fromYear").val(prevFromYear);
        $("#toYear").val(prevToYear);

        return;
    }else{
        prevFromYear = $("#fromYear").val();
        prevToYear = $("#toYear").val();
    }
    resFlag1,resFlag2,resFlag3,resFlag5 = false;

    if($("#lang").val() == 'ko') {
        $(".enTag").css("display","none");
        $(".koTag").css("display","");
    }else {
        $(".koTag").css("display","none");
        $(".enTag").css("display","");
    }
    $(".yearRange").html("("+$("#fromYear").val() + "~" + $("#toYear").val()+")");

    $('.wrap-loading').css('display','');

    overviewGraph();
    overviewData();
    sciGraph();
    scpGraph();
}

function overviewGraph(){
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

    var fudChart_obj =  $.extend(true, {}, chartOpt);
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
    fudChart_obj.dataSource.chart['interactiveLegend'] ='0';
    fudChart_obj.dataSource.chart['divLineAlpha'] = '0';

    if($("#lang").val() == 'ko'){
        fudChart_obj.dataSource.chart['sYAxisName'] ='총연구비(백만원)';
        fudChart_obj.dataSource.chart['pYAxisName'] ='과제건수';
    }else{
        fudChart_obj.dataSource.chart['sYAxisName'] ='Total Research Fundings(1 million unit)';
        fudChart_obj.dataSource.chart['pYAxisName'] ='No. of Research Project';
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
        if(FusionCharts('artChart')) {
            FusionCharts('artChart').dispose();
            $('#artChartDiv').disposeFusionCharts().empty();
        }
        if(FusionCharts('conChart')) {
            FusionCharts('conChart').dispose();
            $('#conChartDiv').disposeFusionCharts().empty();
        }
        if(FusionCharts('fudChart')) {
            FusionCharts('fudChart').dispose();
            $('#fudChartDiv').disposeFusionCharts().empty();
        }
        if(FusionCharts('patChart')) {
            FusionCharts('patChart').dispose();
            $('#patChartDiv').disposeFusionCharts().empty();
        }

        //performance 총 수
       /* $(".performArt").text(data.total.artsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'));
        $(".performFud").text(data.total.fundCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'));
        $(".performPat").text(data.total.patentCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'));
        $(".performCon").text(data.total.confereneceCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'));*/

        $(".performArt").text(data.periodTotal.artsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+"("+data.total.artsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+")");
        $(".performFud").text(data.periodTotal.fundCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+"("+data.total.fundCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+")");
        $(".performPat").text(data.periodTotal.patentCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+"("+data.total.patentCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+")");
        $(".performCon").text(data.periodTotal.confereneceCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+"("+data.total.confereneceCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+")");

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
        if($("#tab1Chart").hasClass("active")){
            setTimeout(function(){ $(".wrap-loading").css('display','none')},500);
        }
    });
}

function overviewData(){
    $.ajax({
        url: "reportAjax.do",
        data: $("#selectForm").serialize(),
        method: "post"
    }).done(function (data) {
        $("#artOverTb tbody").empty();
        $("#fundTb tbody").empty();
        $("#patTb tbody").empty();
        $("#conTb tbody").empty();
        //저널논문
        for (var i = 0; i < data.articlePubyearList1.length; i++) {
            var article = data.articlePubyearList1[i];
            var rsrchCo = article.rsrchCo == null ? 0 : article.rsrchCo;

            var $tr = "<tr>" +
                "<td>" + article.pubYear + "</td>" +
                "<td>" + article.artsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
                "<td>" + article.sciArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
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
                "<td>" + (parseInt(funding.totRsrcct/1000000)).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "</td>" +
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
        if($("#tab1Data").hasClass("active")){
            setTimeout(function(){ $(".wrap-loading").css('display','none')},500);
        }
    });
}

function sciGraph(){

    var sciArtChart_obj = $.extend(true, {}, chartOpt);
    sciArtChart_obj['id'] = 'sciArtChart';
    sciArtChart_obj['type'] = 'MSLine';
    sciArtChart_obj['renderAt'] = 'sciArtChartDiv';
    sciArtChart_obj['height'] = '240';
    sciArtChart_obj.dataSource.chart['showValues'] = '1';
    sciArtChart_obj.dataSource.chart['yAxisValuesStep'] = '5';
    sciArtChart_obj.dataSource.chart['showplotborder'] = '0';
    sciArtChart_obj.dataSource.chart['usePlotGradientColor'] = '0';
    sciArtChart_obj.dataSource.chart['divLineAlpha'] = '0';
    sciArtChart_obj.dataSource.chart['paletteColors'] = colors2;
    sciArtChart_obj.dataSource.chart['labelDisplay'] = "Auto";

    var sciIfChart_obj = $.extend(true, {}, chartOpt);
    sciIfChart_obj['id'] = 'sciIfChart';
    sciIfChart_obj['type'] = 'mscolumn2d';
    sciIfChart_obj['renderAt'] = 'sciIfChartDiv';
    sciIfChart_obj['height'] = '240';
    sciIfChart_obj.dataSource.chart['showValues'] = '1';
    sciIfChart_obj.dataSource.chart['yAxisValuesStep'] = '5';
    sciIfChart_obj.dataSource.chart['showplotborder'] = '0';
    sciIfChart_obj.dataSource.chart['usePlotGradientColor'] = '0';
    sciIfChart_obj.dataSource.chart['divLineAlpha'] = '0';
    sciIfChart_obj.dataSource.chart['plotSpacePercent'] = '50';
    sciIfChart_obj.dataSource.chart['paletteColors'] = colors2;
    sciIfChart_obj.dataSource.chart['labelDisplay'] = "Auto";

    $.ajax({
        url: "graphAjaxByGubun.do?gubun=SCI",
        data: $("#selectForm").serialize(),
        method: "post"
    }).done(function (data) {
        var totArt = 0;
        var totTc = 0;
        var totTcAvg = 0;
        var totIf = 0;
        var totIfAvg = 0;

        var periodTotArt = 0;
        var periodTotTc = 0;
        var periodTotTcAvg = 0;
        var periodTotIf = 0;
        var periodTotIfAvg = 0;

        var $tbody = "";

        //전체 논문수 피인용횟수 등등..
        for(var i = 0; i < data.articleTotPubyearList1.length; i++) {
            var article = data.articleTotPubyearList1[i];

            totArt += parseInt(article.sciArtsCo);
            totTc += parseInt(article.tcSum);
            totIf += parseFloat(article.ifSum);
        }

        //논문수 피인용횟수 등등..
        for(var i = 0; i < data.articlePubyearList1.length; i++) {
            var article = data.articlePubyearList1[i];

            periodTotArt += parseInt(article.sciArtsCo);
            periodTotTc += parseInt(article.tcSum);
            periodTotIf += parseFloat(article.ifSum);
        }

        totTcAvg = (totArt == 0 ? 0 : totTc/totArt);
        totIfAvg = (totArt == 0 ? 0 : totIf/totArt);

        periodTotTcAvg = (periodTotArt == 0 ? 0 : periodTotTc/periodTotArt);
        periodTotIfAvg = (periodTotArt == 0 ? 0 : periodTotIf/periodTotArt);

        //performance 총 수
        $(".performSciArt").text(periodTotArt.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+"("+totArt.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+")");
        $(".performSciTcAvg").text(periodTotTcAvg.toFixed(2).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+"("+totTcAvg.toFixed(2).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+")");
        $(".performSciIf").text(periodTotIfAvg.toFixed(2).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+"("+totIfAvg.toFixed(2).replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+")");
        $(".performSciHindex").text(data.periodHindex.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+"("+data.totHindex.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+")");

        //차트가 있을경우 지우고 다시 그리기
        if(FusionCharts('sciArtChart')) {
            FusionCharts('sciArtChart').dispose();
            $('#sciArtChartDiv').disposeFusionCharts().empty();
        }
        if(FusionCharts('sciIfChart')) {
            FusionCharts('sciIfChart').dispose();
            $('#sciIfChartDiv').disposeFusionCharts().empty();
        }

        sciArtChart_obj.dataSource['categories'] = data.artCategories;
        sciArtChart_obj.dataSource['dataset'] = data.artDataset;
        sciArtChart_obj.dataSource['styles'] = data.artStyles;

        sciIfChart_obj.dataSource['categories'] = data.ifCategories;
        sciIfChart_obj.dataSource['dataset'] = data.ifDataset;
        sciIfChart_obj.dataSource['styles'] = data.ifStyles;

        new FusionCharts(sciArtChart_obj).render();
        new FusionCharts(sciIfChart_obj).render();

        for(var i=0; i<data.articleList.length; i++){
            if(i>3)break;

            var article = data.articleList[i];
            var volume = article.volume ? 'v.'+article.volume+', ' : '';
            var issue = article.issue ? 'no.'+article.issue+', ' : '';
            var page = article.sttPage ? 'pp.'+article.sttPage+' - '+article.endPage+', ' : '';
            var pblcYm = article.pblcYm ? (article.pblcYm.length >= 6 ? article.pblcYm.toString().substr(0,4)+'-'+article.pblcYm.toString().substr(4,6)  : article.pblcYm.toString().substr(0,4)) : '';
            var content = article.authors+' / '+article.scjnlNm+volume+issue+page+pblcYm;

            if(content.length > 105)content=content.substr(0,95)+"...";

            var $tr = '<tr>' +
                      '<td class="h_link_td">'+'<a href="javascript:popArticle(\''+article.articleId+'\')" ">'+article.orgLangPprNm+'</a>'+'<span>'+content+'</span>'+'</td>' +
                      '<td><em class="round_num">'+article.tc+'</em></td>' +
                      '</tr>';

            $tbody += $tr;
        }

        $("#sciHighlyTb tbody").html($tbody);

        resFlag3 = true;
        if($("#tab2Chart").hasClass("active")){
            setTimeout(function(){ $(".wrap-loading").css('display','none')},500);
        }
    });
}

function scpGraph(){

    var scpArtChart_obj = $.extend(true, {}, chartOpt);
    scpArtChart_obj['id'] = 'scpArtChart';
    scpArtChart_obj['type'] = 'MSLine';
    scpArtChart_obj['renderAt'] = 'scpArtChartDiv';
    scpArtChart_obj['height'] = '240';
    scpArtChart_obj.dataSource.chart['showValues'] = '1';
    scpArtChart_obj.dataSource.chart['yAxisValuesStep'] = '5';
    scpArtChart_obj.dataSource.chart['showplotborder'] = '0';
    scpArtChart_obj.dataSource.chart['usePlotGradientColor'] = '0';
    scpArtChart_obj.dataSource.chart['divLineAlpha'] = '0';
    scpArtChart_obj.dataSource.chart['paletteColors'] = colors2;
    scpArtChart_obj.dataSource.chart['labelDisplay'] = "Auto";

    var scpIfChart_obj = $.extend(true, {}, chartOpt);
    scpIfChart_obj['id'] = 'scpIfChart';
    scpIfChart_obj['type'] = 'mscolumn2d';
    scpIfChart_obj['renderAt'] = 'scpIfChartDiv';
    scpIfChart_obj['height'] = '240';
    scpIfChart_obj.dataSource.chart['showValues'] = '1';
    scpIfChart_obj.dataSource.chart['yAxisValuesStep'] = '5';
    scpIfChart_obj.dataSource.chart['showplotborder'] = '0';
    scpIfChart_obj.dataSource.chart['usePlotGradientColor'] = '0';
    scpIfChart_obj.dataSource.chart['divLineAlpha'] = '0';
    scpIfChart_obj.dataSource.chart['plotSpacePercent'] = '50';
    scpIfChart_obj.dataSource.chart['paletteColors'] = colors2;
    scpIfChart_obj.dataSource.chart['labelDisplay'] = "Auto";

    $.ajax({
        url: "graphAjaxByGubun.do?gubun=SCOPUS",
        data: $("#selectForm").serialize(),
        method: "post"
    }).done(function (data) {
        var totArt = 0;
        var totTc = 0;
        var totTcAvg = 0;
        var totIf = 0;
        var totIfAvg = 0;

        var periodTotArt = 0;
        var periodTotTc = 0;
        var periodTotTcAvg = 0;
        var periodTotIf = 0;
        var periodTotIfAvg = 0;

        var $tbody = "";

        //전체 논문수 피인용횟수 등등..
        for(var i = 0; i < data.articleTotPubyearList1.length; i++) {
            var article = data.articleTotPubyearList1[i];

            totArt += parseInt(article.artsCo);
            totTc += parseInt(article.tcSum);
            totIf += parseFloat(article.ifSum);
        }

        //논문수 피인용횟수 등등..
        for(var i = 0; i < data.articlePubyearList1.length; i++) {
            var article = data.articlePubyearList1[i];

            periodTotArt += parseInt(article.artsCo);
            periodTotTc += parseInt(article.tcSum);
            periodTotIf += parseFloat(article.ifSum);
        }

        totTcAvg = (totArt == 0 ? 0 : totTc/totArt);
        totIfAvg = (totArt == 0 ? 0 : totIf/totArt);

        periodTotTcAvg = (periodTotArt == 0 ? 0 : periodTotTc/periodTotArt);
        periodTotIfAvg = (periodTotArt == 0 ? 0 : periodTotIf/periodTotArt);

        //performance 총 수
        $(".performScpArt").text(periodTotArt.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+"("+totArt.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+")");
        $(".performScpTcAvg").text(periodTotTcAvg.toFixed(2).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+"("+totTcAvg.toFixed(2).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+")");
        $(".performScpIf").text(periodTotIfAvg.toFixed(2).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+"("+totIfAvg.toFixed(2).replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+")");
        $(".performScpHindex").text(data.periodHindex.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+"("+data.totHindex.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+")");

        //차트가 있을경우 지우고 다시 그리기
        if(FusionCharts('scpArtChart')) {
            FusionCharts('scpArtChart').dispose();
            $('#scpArtChartDiv').disposeFusionCharts().empty();
        }
        if(FusionCharts('scpIfChart')) {
            FusionCharts('scpIfChart').dispose();
            $('#scpIfChartDiv').disposeFusionCharts().empty();
        }

        scpArtChart_obj.dataSource['categories'] = data.artCategories;
        scpArtChart_obj.dataSource['dataset'] = data.artDataset;
        scpArtChart_obj.dataSource['styles'] = data.artStyles;

        scpIfChart_obj.dataSource['categories'] = data.ifCategories;
        scpIfChart_obj.dataSource['dataset'] = data.ifDataset;
        scpIfChart_obj.dataSource['styles'] = data.ifStyles;

        new FusionCharts(scpArtChart_obj).render();
        new FusionCharts(scpIfChart_obj).render();

        for(var i=0; i<data.articleList.length; i++){
            if(i>3)break;

            var article = data.articleList[i];
            var volume = article.volume ? 'v.'+article.volume+', ' : '';
            var issue = article.issue ? 'no.'+article.issue+', ' : '';
            var page = article.sttPage ? 'pp.'+article.sttPage+' - '+article.endPage+', ' : '';
            var pblcYm = article.pblcYm ? (article.pblcYm.length >= 6 ? article.pblcYm.toString().substr(0,4)+'-'+article.pblcYm.toString().substr(4,6)  : article.pblcYm.toString().substr(0,4)) : '';
            var content = article.authors+' / '+article.scjnlNm+volume+issue+page+pblcYm;

            if(content.length > 105)content=content.substr(0,95)+"...";

            var $tr = '<tr>' +
                '<td class="h_link_td">'+'<a href="javascript:popArticle(\''+article.articleId+'\')" ">'+article.orgLangPprNm+'</a>'+'<span>'+content+'</span>'+'</td>' +
                '<td><em class="round_num">'+article.scpTc+'</em></td>' +
                '</tr>';

            $tbody += $tr;
        }

        $("#scpHighlyTb tbody").html($tbody);

        resFlag5 = true;
        if($("#tab3Chart").hasClass("active")){
            setTimeout(function(){ $(".wrap-loading").css('display','none')},500);
        }
    });
}

function pdfWork(){
    var browser = navigator.userAgent.toLowerCase();
    var currentTab = $(".tab_menu.on").attr("href").replace("#","");

    $(".header_wrap").css("display","none");
    $(".shadow_box").css("display","none");
    $(".sub_top_box").css("display","none");
    $(".onepage_footer").css("display","none");

    var $pdfDiv = $("<div id='pdfDiv' style='max-width: 100%;overflow:hidden;background:#ffffff;'></div>");
    $pdfDiv.append(  $(".asrims_contents").html());
//    $pdfDiv.find(".professor_box span").css("font-size","17px");
//    $pdfDiv.find(".faculty_box span").css("font-size","19px");
//    $pdfDiv.find(".sb_num dl dd").css("font-size","17px");
    /*if(browser.indexOf("chrome") == -1){
     $pdfDiv.find("text").css("font-weight","bold");
     }*/
    var footer = $(".onepage_footer").clone().css("width","100%").css("position","absolute").css("bottom","0px").css("display","");

    $("body").prepend($pdfDiv);
    $("#pdfDiv").append(footer);
    $("#pdfDiv").css('position', 'relative');
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

function makePdf(){
    var browser = navigator.userAgent.toLowerCase();
    if ( -1 != browser.indexOf('chrome') ){
        window.print();
    }else if ( -1 != browser.indexOf('trident') ){
        try{
            //웹 브라우저 컨트롤 생성
            var webBrowser = '<OBJECT ID="previewWeb" WIDTH=0 HEIGHT=0 CLASSID="CLSID:8856F961-340A-11D0-A96B-00C04FD705A2"></OBJECT>';

            //웹 페이지에 객체 삽입
            document.body.insertAdjacentHTML('beforeEnd', webBrowser);

            //ExexWB 메쏘드 실행 (7 : 미리보기 , 8 : 페이지 설정 , 6 : 인쇄하기(대화상자))
            previewWeb.ExecWB(7, 1);

            //객체 해제
            previewWeb.outerHTML = "";
        }catch (e) {
            alert("- 도구 > 인터넷 옵션 > 보안 탭 > 신뢰할 수 있는 사이트 선택\n   1. 사이트 버튼 클릭 > 사이트 추가\n   2. 사용자 지정 수준 클릭 > 스크립팅하기 안전하지 않은 것으로 표시된 ActiveX 컨트롤 (사용)으로 체크\n\n※ 위 설정은 프린트 기능을 사용하기 위함임");
        }

    }

    /*var element = $("#pdfDiv")[0];
     html2pdf(element, {
     filename: "onePageReport.pdf",
     margin : [0,1,0,1],
     dpi: "300"
     });*/

    setTimeout(function() {
        $("#pdfDiv").remove();
        //$(".onepage_footer").eq(0).remove();
        $(".header_wrap").css("display","");
        $(".shadow_box").css("display","");
        $(".sub_top_box").css("display","");
        $(".onepage_footer").css("display","");
    }, 100);
}

function deptChartClick(){
}

function subTab(tabId, subTab){

    $('.sub_menuC').parent().parent().css("display","none");
    $(".sub_menuC").removeClass("active");

    if(tabId == "tab1"){
        $("#div_overviewChart").css("display","none");
        $("#div_overviewData").css("display","none");

        if(subTab == "chart"){
            if(!resFlag1){
                $('.wrap-loading').css('display', '');
            }else{
                $('.wrap-loading').css('display','none');
            }

            $("#div_overviewChart").css("display","");
            //sub tab 효과
            $("#tab1Chart").addClass("active");
            $('#tab1Chart').parent().parent().css("display","");
        }

        if(subTab == "data"){
            if(!resFlag2){
                $('.wrap-loading').css('display', '');
            }else{
                $('.wrap-loading').css('display','none');
            }

            $("#div_overviewData").css("display","");
            //sub tab 효과
            $("#tab1Data").addClass("active");
            $('#tab1Data').parent().parent().css("display","");
        }
    }else if(tabId == "tab2"){
        $("#div_sciChart").css("display","none");

        if(subTab == "chart"){
            if(!resFlag3){
                $('.wrap-loading').css('display', '');
            }else{
                $('.wrap-loading').css('display','none');
            }

            $("#div_sciChart").css("display","");
            //sub tab 효과
            $("#tab2Chart").addClass("active");
            $('#tab2Chart').parent().parent().css("display","");
        }
    }else if(tabId == "tab3"){
        $("#div_scpChart").css("display","none");

        if(subTab == "chart"){
            if(!resFlag5){
                $('.wrap-loading').css('display', '');
            }else{
                $('.wrap-loading').css('display','none');
            }

            $("#div_scpChart").css("display","");
            //sub tab 효과
            $("#tab3Chart").addClass("active");
            $('#tab3Chart').parent().parent().css("display","");
        }
    }
}

//파이차트
function animate(elementId, endPercent) {
    var canvas = document.getElementById(elementId);
    var context = canvas.getContext('2d');
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
}
</script>
</head>
<body style="font-family: NanumBarunGothic-Regular, NanumBarunGothic-Bold, Malgun Gothic, 맑은 고딕, Verdana, Arial, 돋움, Dotum;">
<link media="print" href="${pageContext.request.contextPath}/css/analysis_${instAbrv}/layout.css" rel="stylesheet"  type="text/css" />
<h3 class="page_title"><spring:message code="menu.asrms.rsch.onePageReport"/></h3>
<div class="help_text mgb_15"><spring:message code="asrms.researcher.onePageReport.desc"/></div>
<p class="bt_box mgb_10">
    <a href="javascript:pdfWork()" class="black_bt"><em class="print_icon">Print (Chrome recommended)</em></a>
    <c:if test="${fn:contains(header['User-Agent'],'MSIE') || fn:contains(header['User-Agent'],'Trident')}">
        <a href="javascript:alert('인쇄 미리보기 화면에서 \'페이지 설정(Alt+U) -> 배경색 및 이미지 인쇄 클릭, 머리글/바닥글 모두 비어있음 설정\' 을 하시면 머리글/바닥글이 내용을 가리지 않습니다.');" class="black_bt"><em class="question_icon">Help</em></a>
    </c:if>
    <%--<c:if test="${fn:contains(header['User-Agent'],'MSIE')}">
        <a href="#dialog" class="black_bt modalLink"><em class="question_icon">Help</em></a>
    </c:if>--%>
</p>
<div class="top_option_box">
    <form id="selectForm">
        <input type="hidden" id="topNm" name="topNm" value="<c:out value="${topNm}"/>"/>
        <div class="to_inner">
            <input type="hidden" name="userId" value="${item.userId}">
            <span>실적구분(논문)</span>
            <em>
                <select name="insttRsltAt" id="insttRsltAt">
                    <option value="ALL" selected="selected">전체</option>
                    <option value="Y">${sysConf['inst.abrv']}</option>
                    <option value="N">타기관</option>
                </select>
            </em>
            <c:set var="now" value="<%=new java.util.Date()%>" />
            <c:set var="sysYear"><fmt:formatDate value="${now}" pattern="yyyy" /></c:set>
            <span>실적기간</span>
            <em>
                <select name="fromYear" id="fromYear">
                    <c:choose>
                        <c:when test="${empty pubYearList[0]}">
                            <c:forEach begin="0" end="9" var="yl" varStatus="idx" >
                                <option value="${sysYear - yl }" ${idx.index == 4 ? 'selected="selected"' : '' }>${sysYear - yl }</option>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="yl" items="${pubYearList}" varStatus="idx">
                                <option value="${yl.pubYear }" ${idx.index == 4 ? 'selected="selected"' : '' }>${yl.pubYear }</option>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </select>
            </em>
            ~
            <em>
                <select name="toYear" id="toYear">
                    <c:choose>
                        <c:when test="${empty pubYearList[0]}">
                            <c:forEach begin="0" end="9" var="yl" varStatus="idx" >
                                <option value="${sysYear - yl }">${sysYear - yl }</option>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="yl" items="${pubYearList}" varStatus="idx">
                                <option value="${yl.pubYear }">${yl.pubYear }</option>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </select>
            </em>
            <span>언어</span>
            <em>
                <select name="lang" id="lang">
                    <option value="ko">한글</option>
                    <option value="en">영문</option>
                </select>
            </em>
        </div>
    </form>
    <p class="al_right">
        <a href="javascript:search();" class="to_search_bt"><span>Search</span></a>
    </p>
</div>

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
                    <li style="width: 160px;"><a href='javascript:subTab("tab2","chart")' class="sub_menuC" id="tab2Chart">Chart</a></li>
                </ul>
            </li>
            <li>
                <a href="#tabs-3" class="tab_menu" id="tab3">SCOPUS Report</a>
                <ul>
                    <li style="width: 160px;"><a href='javascript:subTab("tab3","chart")' class="sub_menuC" id="tab3Chart">Chart</a></li>
                </ul>
            </li>
        </ul>
    </div>
    <div class="asrims_contents" style="margin-bottom: 0px;">
        <c:set value="${fn:substring(item.aptmDate,4,6)}" var="monthNum"/>
        <c:set value="${monthNum eq '01'?'January':monthNum eq '02'?'February':monthNum eq '03'?'March':monthNum eq '04'?'April':monthNum eq '05'?'May':monthNum eq '06'?'June':monthNum eq '07'?'July':monthNum eq '08'?'August':monthNum eq '09'?'September':monthNum eq '10'?'October':monthNum eq '11'?'November':monthNum eq '12'?'December':''}" var="month"/>
        <c:set var="koTextLen1" value="${fn:length(item.majorKor1)}"/>
        <c:set var="koTextLen2" value="${koTextLen1 + fn:length(item.majorKor2)}"/>
        <c:set var="koTextLen3" value="${koTextLen2 + fn:length(item.majorKor3)}"/>
        <c:set var="enTextLen1" value="${koTextLen3 + fn:length(item.majorEng1)}"/>
        <c:set var="enTextLen2" value="${enTextLen1 + fn:length(item.majorEng2)}"/>
        <c:set var="enTextLen3" value="${enTextLen2 + fn:length(item.majorEng3)}"/>

        <div id="tabs-1">
            <div id="div_overviewChart" class="onepage_wrap">
                <div class="overview_box">
                    <em class="enTag"><span class="overview_text">Overview Chart<span class="yearRange" style="margin-left: 3px;"></span></span></em>
                    <em class="koTag"><span class="overview_text">요약차트<span class="yearRange" style="margin-left: 3px;"></span></span></em>
                </div>
                <div class="onepage_inner" style="margin-bottom: 10px; margin-bottom: 10px;">
                <div class="op_title_box">
                    <div class="op_title">
                        <img src="<c:url value="/images/analysis/background/onepage_title01.png"/>" width="436px" height="auto"/>
                        <div class="top_info_box">
                            <em class="r_name koTag"><c:out value="${item.korNm}"/></em><em class="r_info koTag"><c:out value="${item.deptKor}"/>, <c:out value="${item.posiNm}"/>, <c:out value="${fn:substring(item.aptmDate,0,4)}.${fn:substring(item.aptmDate,4,6)}.${fn:substring(item.aptmDate,6,8)}"/> 임용</em>
                            <em class="r_name enTag"><c:out value="${item.lastName}, ${item.firstName}"/></em><em class="r_info enTag" style="margin-right: 5px;"><c:out value="${fn:length(item.deptEng) > 65 ? fn:substring(item.deptEng,0,64) : item.deptEng}"/>${fn:length(item.deptEng) > 65 ? '...':''},</em><em class="r_info enTag"><c:out value="${item.posiNm == '교수' ? 'Professor' : item.posiNm == '조교수' ? 'Assistant Professor' : item.posiNm == '부교수' ? 'Associate Professor' : item.posiNm}"/> (Appointed on <c:out value="${month}"/>
                            <c:out value="${fn:substring(item.aptmDate,6,8)}"/>, <c:out value="${fn:substring(item.aptmDate,0,4)}"/>)</em>
                        </div>
                    </div>
                </div>
                <div class="r_info_box">
                    <dl>
                        <dt class="enTag">Research Area</dt>
                        <dt class="koTag">연구분야</dt>
                        <dd><c:out value="${not empty item.majorKor1 and koTextLen1 < 65 ? item.majorKor1 : ''}"/><c:out value="${not empty item.majorKor2 and koTextLen2 < 65 ? ' ; ':''}"/><c:out value="${not empty item.majorKor2 and koTextLen2 < 65 ? item.majorKor2 : ''}"/><c:out value="${not empty item.majorKor3 and koTextLen3 < 65 ? ' ; ':''}"/><c:out value="${not empty item.majorKor3 and koTextLen3 < 65 ? item.majorKor3 : ''}"/><c:out value="${not empty item.majorEng1 and enTextLen1 < 65 ? ' ; ':''}"/><c:out value="${not empty item.majorEng1 and enTextLen1 < 65 ? item.majorEng1 : ''}"/><c:out value="${not empty item.majorEng2 and enTextLen2 < 65 ? ' ; ':''}"/><c:out value="${not empty item.majorEng2 and enTextLen2 < 65 ? item.majorEng2 : ''}"/><c:out value="${not empty item.majorEng3 and enTextLen3 < 65 ? ' ; ':''}"/><c:out value="${not empty item.majorEng3 and enTextLen3 < 65 ? item.majorEng3 : ''}"/></dd>
                    </dl>
                    <dl>
                        <dt class="enTag">Major Subject</dt>
                        <dt class="koTag">주요 주제분야</dt>
                        <dd>
                            <c:set var="catTextLen" value="0"/>
                            <c:forEach items="${categoryList}" var="category" varStatus="stats">
                                <c:set var="catTextLen" value="${catTextLen + fn:length(category.category)}"/>
                                <c:if test="${stats.index < 3 and catTextLen < 65}"><c:if test="${!stats.first}"> ; </c:if><c:out value="${category.category}"/></c:if>
                            </c:forEach>
                        </dd>
                    </dl>
                    <dl class="ri_keyword_dl">
                        <dt class="enTag">Author Paper Keyword</dt>
                        <dt class="koTag">저자 논문 키워드</dt>
                        <dd>
                            <c:set var="keyTextLen" value="0"/>
                            <c:forEach items="${keywordList}" var="keyword" varStatus="stat">
                                <c:set var="keyTextLen" value="${keyTextLen + fn:length(keyword.name)}"/>
                                <c:if test="${keyTextLen < 65}">
                                        <span href="javascript:void(0);"class="keyword_graph">
                                            <canvas class="chart_b" id="keyGraph1_${stat.index}" width="200" height="200"></canvas>
                                            <script>
                                                animate("keyGraph1_${stat.index}", (${keyword.num}*100)/${keywordList[0].num});
                                            </script>
                                            <span class="keyword_b keyw"><c:out value="${keyword.name}"/></span>
                                        </span>
                                </c:if>
                            </c:forEach>
                        </dd>
                    </dl>
                </div>
                <div class="top_summary_wrap">
                    <div class="top_summary_row">
                        <div class="summary_box">
                            <div class="sb_inner">
                                <span><img src="<c:url value="/images/background/onepage_icon01.png"/>" width="44px"height="auto" alt="Journal Articles"/></span>
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
                                <span><img src="<c:url value="/images/background/onepage_icon02.png"/>" width="44px"height="auto" alt="Research Fundings" /></span>
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
                                <span><img src="<c:url value="/images/background/onepage_icon03.png"/>" width="44px"height="auto" alt="Patents"/></span>
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
                                <span><img src="<c:url value="/images/background/onepage_icon04.png"/>" width="44px"height="auto" alt="Conference" /></span>
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
                    <p class="summary_text">※( ) All Period</p>
                </div>

                <div class="one_con_wrap">
                    <div class="one_col_lb" style="padding-bottom: 10px;">
                        <h4 class="onepage_title enTag"><span><img src="<c:url value="/images/analysis/background/chart_icon01.png"/>" width="16"/></span>Journal Article</h4>
                        <h4 class="onepage_title koTag"><span><img src="<c:url value="/images/analysis/background/chart_icon01.png"/>" width="16"/></span>저널논문</h4>
                        <div class="one_chart_box" id="artChartDiv"></div>
                    </div>
                    <div class="one_col_rb" style="padding-bottom: 10px;">
                        <h4 class="onepage_title enTag"><span><img src="<c:url value="/images/analysis/background/chart_icon02.png"/>" width="16"/></span>Research Project</h4>
                        <h4 class="onepage_title koTag"><span><img src="<c:url value="/images/analysis/background/chart_icon02.png"/>" width="16"/></span>연구비(연구과제)</h4>
                        <div class="one_chart_box" id="fudChartDiv"></div>
                    </div>
                    <div class="one_col_lb">
                        <h4 class="onepage_title enTag"><span><img src="<c:url value="/images/analysis/background/chart_icon03.png"/>" width="16"/></span>Patent</h4>
                        <h4 class="onepage_title koTag"><span><img src="<c:url value="/images/analysis/background/chart_icon03.png"/>" width="16"/></span>지식재산(특허)</h4>
                        <div class="one_chart_box" id="patChartDiv"></div>
                    </div>
                    <div class="one_col_rb">
                        <h4 class="onepage_title enTag"><span><img src="<c:url value="/images/analysis/background/chart_icon04.png"/>" width="16"/></span>Conference Proceeding</h4>
                        <h4 class="onepage_title koTag"><span><img src="<c:url value="/images/analysis/background/chart_icon04.png"/>" width="16"/></span>학술활동(학술대회)</h4>
                        <div class="one_chart_box" id="conChartDiv"></div>
                    </div>
                </div>
            </div>
            </div>
            <div id="div_overviewData" class="onepage_wrap">
                <div class="overview_box">
                    <em class="enTag"><span class="overview_text">Overview Table<span class="yearRange" style="margin-left: 3px;"></span></span></em>
                    <em class="koTag"><span class="overview_text">요약표<span class="yearRange" style="margin-left: 3px;"></span></span></em>
                </div>
                <div class="onepage_inner" style="margin-bottom: 10px; margin-bottom: 10px;">
                    <div class="op_title_box">
                        <div class="op_title">
                            <img src="<c:url value="/images/analysis/background/onepage_title01.png"/>" width="436px" height="auto"/>
                            <div class="top_info_box">
                                <em class="r_name koTag"><c:out value="${item.korNm}"/></em><em class="r_info koTag"><c:out value="${item.deptKor}"/>, <c:out value="${item.posiNm}"/>, <c:out value="${fn:substring(item.aptmDate,0,4)}.${fn:substring(item.aptmDate,4,6)}.${fn:substring(item.aptmDate,6,8)}"/> 임용</em>
                                <em class="r_name enTag"><c:out value="${item.lastName}, ${item.firstName}"/></em><em class="r_info enTag" style="margin-right: 5px;"><c:out value="${fn:length(item.deptEng) > 65 ? fn:substring(item.deptEng,0,64) : item.deptEng}"/>${fn:length(item.deptEng) > 65 ? '...':''},</em><em class="r_info enTag"><c:out value="${item.posiNm == '교수' ? 'Professor' : item.posiNm == '조교수' ? 'Assistant Professor' : item.posiNm == '부교수' ? 'Associate Professor' : item.posiNm}"/> (Appointed on <c:out value="${month}"/>
                                <c:out value="${fn:substring(item.aptmDate,6,8)}"/>, <c:out value="${fn:substring(item.aptmDate,0,4)}"/>)</em>
                            </div>
                        </div>
                    </div>
                    <div class="r_info_box">
                        <dl>
                            <dt class="enTag">Research Area</dt>
                            <dt class="koTag">연구분야</dt>
                            <dd><c:out value="${not empty item.majorKor1 and koTextLen1 < 65 ? item.majorKor1 : ''}"/><c:out value="${not empty item.majorKor2 and koTextLen2 < 65 ? ' ; ':''}"/><c:out value="${not empty item.majorKor2 and koTextLen2 < 65 ? item.majorKor2 : ''}"/><c:out value="${not empty item.majorKor3 and koTextLen3 < 65 ? ' ; ':''}"/><c:out value="${not empty item.majorKor3 and koTextLen3 < 65 ? item.majorKor3 : ''}"/><c:out value="${not empty item.majorEng1 and enTextLen1 < 65 ? ' ; ':''}"/><c:out value="${not empty item.majorEng1 and enTextLen1 < 65 ? item.majorEng1 : ''}"/><c:out value="${not empty item.majorEng2 and enTextLen2 < 65 ? ' ; ':''}"/><c:out value="${not empty item.majorEng2 and enTextLen2 < 65 ? item.majorEng2 : ''}"/><c:out value="${not empty item.majorEng3 and enTextLen3 < 65 ? ' ; ':''}"/><c:out value="${not empty item.majorEng3 and enTextLen3 < 65 ? item.majorEng3 : ''}"/></dd>
                        </dl>
                        <dl>
                            <dt class="enTag">Major Subject</dt>
                            <dt class="koTag">주요 주제분야</dt>
                            <dd>
                                <c:set var="catTextLen" value="0"/>
                                <c:forEach items="${categoryList}" var="category" varStatus="stats">
                                    <c:set var="catTextLen" value="${catTextLen + fn:length(category.category)}"/>
                                    <c:if test="${stats.index < 3 and catTextLen < 65}"><c:if test="${!stats.first}"> ; </c:if><c:out value="${category.category}"/></c:if>
                                </c:forEach>
                            </dd>
                        </dl>
                        <dl class="ri_keyword_dl">
                            <dt class="enTag">Author Paper Keyword</dt>
                            <dt class="koTag">저자 논문 키워드</dt>
                            <dd>
                                <c:set var="keyTextLen" value="0"/>
                                <c:forEach items="${keywordList}" var="keyword" varStatus="stat">
                                    <c:set var="keyTextLen" value="${keyTextLen + fn:length(keyword.name)}"/>
                                    <c:if test="${keyTextLen < 65}">
                                        <span href="javascript:void(0);"class="keyword_graph">
                                            <canvas class="chart_b" id="keyGraph2_${stat.index}" width="200" height="200"></canvas>
                                            <script>
                                                animate("keyGraph2_${stat.index}", (${keyword.num}*100)/${keywordList[0].num});
                                            </script>
                                            <span class="keyword_b keyw"><c:out value="${keyword.name}"/></span>
                                        </span>
                                    </c:if>
                                </c:forEach>
                            </dd>
                        </dl>
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
                                    <span><img src="<c:url value="/images/background/onepage_icon02.png"/>" width="44px"height="auto" alt="Research Fundings" /></span>
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
                                    <span><img src="<c:url value="/images/background/onepage_icon03.png"/>" width="44px"height="auto" alt="Patents"/></span>
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
                                    <span><img src="<c:url value="/images/background/onepage_icon04.png"/>" width="44px"height="auto" alt="Conference" /></span>
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
                        <p class="summary_text">※( ) All Period</p>
                    </div>
                    <div class="one_con_wrap">
                        <div class="row_box">
                            <h4 class="onepage_title mgb_0 koTag"><span><img src="<c:url value="/images/analysis/background/chart_icon01.png"/>" width="16"/></span>저널논문</h4>
                            <h4 class="onepage_title mgb_0 enTag"><span><img src="<c:url value="/images/analysis/background/chart_icon01.png"/>" width="16"/></span>Journal Article</h4>
                            <table class="one_tbl" id="artOverTb">
                                <thead>
                                <tr>
                                    <th style="width: 70px;border-right: 1px solid white;" class="koTag">연도</th>
                                    <th style="width: 70px;border-right: 1px solid white;" class="enTag">Year</th>
                                    <th class="koTag" style="border-right: 1px solid white;">전체 논문수</th>
                                    <th class="enTag" style="border-right: 1px solid white;">Total No. of papers</th>
                                    <th class="koTag" style="border-right: 1px solid white;">SCI 논문수</th>
                                    <th class="enTag" style="border-right: 1px solid white;">SCI papers</th>
                                </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                        <div class="row_box">
                            <h4 class="onepage_title mgb_0 koTag"><span><img src="<c:url value="/images/analysis/background/chart_icon02.png"/>" width="16"/></span>연구비(연구과제)</h4>
                            <h4 class="onepage_title mgb_0 enTag"><span><img src="<c:url value="/images/analysis/background/chart_icon02.png"/>" width="16"/></span>Research Project</h4>
                            <table class="one_tbl one_tbl" id="fundTb">
                                <thead>
                                <tr>
                                    <th style="width: 70px;border-right: 1px solid white;" class="koTag">연도</th>
                                    <th style="width: 70px;border-right: 1px solid white;" class="enTag">Year</th>
                                    <th class="koTag" style="border-right: 1px solid white;">과제건수</th>
                                    <th class="enTag" style="border-right: 1px solid white;">No. of<br/>Research Project</th>
                                    <th class="koTag" style="border-right: 1px solid white;">총연구비(백만원)</th>
                                    <th class="enTag" style="border-right: 1px solid white;">Total Research Fundings<br/>(1 million unit)</th>
                                </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                        <div class="one_col_lb" style="margin-bottom: 40px">
                            <h4 class="onepage_title mgb_0 koTag"><span><img src="<c:url value="/images/analysis/background/chart_icon03.png"/>" width="16"/></span>지식재산(특허)</h4>
                            <h4 class="onepage_title mgb_0 enTag"><span><img src="<c:url value="/images/analysis/background/chart_icon03.png"/>" width="16"/></span>Patent</h4>
                            <table class="one_tbl" id="patTb">
                                <thead>
                                <tr>
                                    <th style="width: 70px;border-right: 1px solid white;" class="koTag">연도</th>
                                    <th style="width: 70px;border-right: 1px solid white;" class="enTag">Year</th>
                                    <th class="koTag" style="border-right: 1px solid white;">출원건수</th>
                                    <th class="enTag" style="border-right: 1px solid white;">Total No. of Application Patents</th>
                                    <th class="koTag">등록건수</th>
                                    <th class="enTag">Total No. of Registration Patents</th>
                                </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                        <div class="one_col_rb" style="margin-bottom: 40px">
                            <h4 class="onepage_title mgb_0 koTag"><span><img src="<c:url value="/images/analysis/background/chart_icon04.png"/>" width="16"/></span>학술활동(학술대회)</h4>
                            <h4 class="onepage_title mgb_0 enTag"><span><img src="<c:url value="/images/analysis/background/chart_icon04.png"/>" width="16"/></span>Conference Proceeding</h4>
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
                    <em class="enTag"><span class="overview_text">SCI Summary<span class="yearRange" style="margin-left: 3px;"></span></span></em>
                    <em class="koTag"><span class="overview_text">SCI 요약<span class="yearRange" style="margin-left: 3px;"></span></span></em>
                </div>
                <div class="onepage_inner" style="margin-bottom: 10px; margin-bottom: 10px;">
                    <div class="op_title_box">
                        <div class="op_title">
                            <img src="<c:url value="/images/analysis/background/onepage_title01.png"/>" width="436px" height="auto"/>
                            <div class="top_info_box">
                                <em class="r_name koTag"><c:out value="${item.korNm}"/></em><em class="r_info koTag"><c:out value="${item.deptKor}"/>, <c:out value="${item.posiNm}"/>, <c:out value="${fn:substring(item.aptmDate,0,4)}.${fn:substring(item.aptmDate,4,6)}.${fn:substring(item.aptmDate,6,8)}"/> 임용</em>
                                <em class="r_name enTag"><c:out value="${item.lastName}, ${item.firstName}"/></em><em class="r_info enTag" style="margin-right: 5px;"><c:out value="${fn:length(item.deptEng) > 65 ? fn:substring(item.deptEng,0,64) : item.deptEng}"/>${fn:length(item.deptEng) > 65 ? '...':''},</em><em class="r_info enTag"><c:out value="${item.posiNm == '교수' ? 'Professor' : item.posiNm == '조교수' ? 'Assistant Professor' : item.posiNm == '부교수' ? 'Associate Professor' : item.posiNm}"/> (Appointed on <c:out value="${month}"/>
                                <c:out value="${fn:substring(item.aptmDate,6,8)}"/>, <c:out value="${fn:substring(item.aptmDate,0,4)}"/>)</em>
                            </div>
                        </div>
                    </div>
                    <div class="r_info_box">
                        <dl>
                            <dt class="enTag">Research Area</dt>
                            <dt class="koTag">연구분야</dt>
                            <dd><c:out value="${not empty item.majorKor1 and koTextLen1 < 65 ? item.majorKor1 : ''}"/><c:out value="${not empty item.majorKor2 and koTextLen2 < 65 ? ' ; ':''}"/><c:out value="${not empty item.majorKor2 and koTextLen2 < 65 ? item.majorKor2 : ''}"/><c:out value="${not empty item.majorKor3 and koTextLen3 < 65 ? ' ; ':''}"/><c:out value="${not empty item.majorKor3 and koTextLen3 < 65 ? item.majorKor3 : ''}"/><c:out value="${not empty item.majorEng1 and enTextLen1 < 65 ? ' ; ':''}"/><c:out value="${not empty item.majorEng1 and enTextLen1 < 65 ? item.majorEng1 : ''}"/><c:out value="${not empty item.majorEng2 and enTextLen2 < 65 ? ' ; ':''}"/><c:out value="${not empty item.majorEng2 and enTextLen2 < 65 ? item.majorEng2 : ''}"/><c:out value="${not empty item.majorEng3 and enTextLen3 < 65 ? ' ; ':''}"/><c:out value="${not empty item.majorEng3 and enTextLen3 < 65 ? item.majorEng3 : ''}"/></dd>
                        </dl>
                        <dl>
                            <dt class="enTag">Major Subject</dt>
                            <dt class="koTag">주요 주제분야</dt>
                            <dd>
                                <c:set var="catTextLen" value="0"/>
                                <c:forEach items="${categoryList}" var="category" varStatus="stats">
                                    <c:set var="catTextLen" value="${catTextLen + fn:length(category.category)}"/>
                                    <c:if test="${stats.index < 3 and catTextLen < 65}"><c:if test="${!stats.first}"> ; </c:if><c:out value="${category.category}"/></c:if>
                                </c:forEach>
                            </dd>
                        </dl>
                        <dl class="ri_keyword_dl">
                            <dt class="enTag">Author Paper Keyword</dt>
                            <dt class="koTag">저자 논문 키워드</dt>
                            <dd>
                                <c:set var="keyTextLen" value="0"/>
                                <c:forEach items="${keywordList}" var="keyword" varStatus="stat">
                                    <c:set var="keyTextLen" value="${keyTextLen + fn:length(keyword.name)}"/>
                                    <c:if test="${keyTextLen < 65}">
                                        <span href="javascript:void(0);"class="keyword_graph">
                                            <canvas class="chart_b" id="keyGraph3_${stat.index}" width="200" height="200"></canvas>
                                            <script>
                                                animate("keyGraph3_${stat.index}", (${keyword.num}*100)/${keywordList[0].num});
                                            </script>
                                            <span class="keyword_b keyw"><c:out value="${keyword.name}"/></span>
                                        </span>
                                    </c:if>
                                </c:forEach>
                            </dd>
                        </dl>
                    </div>
                    <div class="top_summary_wrap">
                        <div class="top_summary_row">
                            <div class="summary_box">
                                <div class="sb_inner">
                                    <span><img src="<c:url value="/images/background/onepage_icon01.png"/>" width="44px"height="auto"/></span>
                                    <div class="sb_num">
                                        <dl>
                                            <dt class="enTag">Papers</dt>
                                            <dt class="koTag">논문수</dt>
                                            <dd class="performSciArt"></dd>
                                        </dl>
                                    </div>
                                </div>
                            </div>
                            <div class="summary_box">
                                <div class="sb_inner">
                                    <span><img src="<c:url value="/images/background/onepage_icon06.png"/>" width="44px"height="auto"/></span>
                                    <div class="sb_num">
                                        <dl>
                                            <dt class="enTag">Avg Citaton per Paper</dt>
                                            <dt class="koTag">논문당 피인용횟수</dt>
                                            <dd class="performSciTcAvg"></dd>
                                        </dl>
                                    </div>
                                </div>
                            </div>
                            <div class="summary_box">
                                <div class="sb_inner">
                                    <span><img src="<c:url value="/images/background/onepage_icon07.png"/>" width="44px"height="auto"/></span>
                                    <div class="sb_num">
                                        <dl>
                                            <dt class="enTag">Avg IF per Paper</dt>
                                            <dt class="koTag">논문당 IF</dt>
                                            <dd class="performSciIf"></dd>
                                        </dl>
                                    </div>
                                </div>
                            </div>
                            <div class="summary_box">
                                <div class="sb_inner">
                                    <span><img src="<c:url value="/images/background/onepage_icon05.png"/>" width="44px"height="auto"/></span>
                                    <div class="sb_num">
                                        <dl>
                                            <dt>H-index</dt>
                                            <dd class="performSciHindex"></dd>
                                        </dl>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <p class="summary_text">※( ) All Period</p>
                    </div>
                    <div class="one_con_wrap">
                        <div class="one_col_lb">
                            <h4 class="onepage_title enTag">SCI Papers</h4>
                            <h4 class="onepage_title koTag">SCI 논문수</h4>
                            <div class="one_chart_box" id="sciArtChartDiv"></div>
                        </div>
                        <div class="one_col_rb">
                            <h4 class="onepage_title">Impact Factor(IF)</h4>
                            <div class="one_chart_box" id="sciIfChartDiv"></div>
                        </div>
                    </div>
                    <div class="highly_list">
                        <div class="hl_title_box">
                            <h4 class="onepage_title enTag">Highly Cited Papers</h4>
                            <h4 class="onepage_title koTag">상위 피인용논문</h4>
                            <%--<span>Since 2014</span>--%>
                        </div>
                        <table class="highly_tbl" style="border: 0px;" summary="상위 피인용논문" id="sciHighlyTb">
                            <caption>상위 피인용논문</caption>
                            <colgroup>
                                <col style="" />
                                <col style="width:100px;" />
                            </colgroup>
                            <thead>
                            <tr>
                                <th class="enTag">Papers</th>
                                <th class="koTag">논문정보</th>
                                <th class="enTag">Times Cited</th>
                                <th class="koTag">피인용횟수</th>
                            </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <div id="tabs-3">
            <div id="div_scpChart" class="onepage_wrap">
                <div class="overview_box">
                    <em class="enTag"><span class="overview_text">SCOPUS Summary<span class="yearRange" style="margin-left: 3px;"></span></span></em>
                    <em class="koTag"><span class="overview_text">SCOPUS 요약<span class="yearRange" style="margin-left: 3px;"></span></span></em>
                </div>
                <div class="onepage_inner" style="margin-bottom: 10px; margin-bottom: 10px;">
                    <div class="op_title_box">
                        <div class="op_title">
                            <img src="<c:url value="/images/analysis/background/onepage_title01.png"/>" width="436px" height="auto"/>
                            <div class="top_info_box">
                                <em class="r_name koTag"><c:out value="${item.korNm}"/></em><em class="r_info koTag"><c:out value="${item.deptKor}"/>, <c:out value="${item.posiNm}"/>, <c:out value="${fn:substring(item.aptmDate,0,4)}.${fn:substring(item.aptmDate,4,6)}.${fn:substring(item.aptmDate,6,8)}"/> 임용</em>
                                <em class="r_name enTag"><c:out value="${item.lastName}, ${item.firstName}"/></em><em class="r_info enTag" style="margin-right: 5px;"><c:out value="${fn:length(item.deptEng) > 65 ? fn:substring(item.deptEng,0,64) : item.deptEng}"/>${fn:length(item.deptEng) > 65 ? '...':''},</em><em class="r_info enTag"><c:out value="${item.posiNm == '교수' ? 'Professor' : item.posiNm == '조교수' ? 'Assistant Professor' : item.posiNm == '부교수' ? 'Associate Professor' : item.posiNm}"/> (Appointed on <c:out value="${month}"/>
                                <c:out value="${fn:substring(item.aptmDate,6,8)}"/>, <c:out value="${fn:substring(item.aptmDate,0,4)}"/>)</em>
                            </div>
                        </div>
                    </div>
                    <div class="r_info_box">
                        <dl>
                            <dt class="enTag">Research Area</dt>
                            <dt class="koTag">연구분야</dt>
                            <dd><c:out value="${not empty item.majorKor1 and koTextLen1 < 65 ? item.majorKor1 : ''}"/><c:out value="${not empty item.majorKor2 and koTextLen2 < 65 ? ' ; ':''}"/><c:out value="${not empty item.majorKor2 and koTextLen2 < 65 ? item.majorKor2 : ''}"/><c:out value="${not empty item.majorKor3 and koTextLen3 < 65 ? ' ; ':''}"/><c:out value="${not empty item.majorKor3 and koTextLen3 < 65 ? item.majorKor3 : ''}"/><c:out value="${not empty item.majorEng1 and enTextLen1 < 65 ? ' ; ':''}"/><c:out value="${not empty item.majorEng1 and enTextLen1 < 65 ? item.majorEng1 : ''}"/><c:out value="${not empty item.majorEng2 and enTextLen2 < 65 ? ' ; ':''}"/><c:out value="${not empty item.majorEng2 and enTextLen2 < 65 ? item.majorEng2 : ''}"/><c:out value="${not empty item.majorEng3 and enTextLen3 < 65 ? ' ; ':''}"/><c:out value="${not empty item.majorEng3 and enTextLen3 < 65 ? item.majorEng3 : ''}"/></dd>
                        </dl>
                        <dl>
                            <dt class="enTag">Major Subject</dt>
                            <dt class="koTag">주요 주제분야</dt>
                            <dd>
                                <c:set var="catTextLen" value="0"/>
                                <c:forEach items="${categoryList}" var="category" varStatus="stats">
                                    <c:set var="catTextLen" value="${catTextLen + fn:length(category.category)}"/>
                                    <c:if test="${stats.index < 3 and catTextLen < 65}"><c:if test="${!stats.first}"> ; </c:if><c:out value="${category.category}"/></c:if>
                                </c:forEach>
                            </dd>
                        </dl>
                        <dl class="ri_keyword_dl">
                            <dt class="enTag">Author Paper Keyword</dt>
                            <dt class="koTag">저자 논문 키워드</dt>
                            <dd>
                                <c:set var="keyTextLen" value="0"/>
                                <c:forEach items="${keywordList}" var="keyword" varStatus="stat">
                                    <c:set var="keyTextLen" value="${keyTextLen + fn:length(keyword.name)}"/>
                                    <c:if test="${keyTextLen < 65}">
                                        <span href="javascript:void(0);"class="keyword_graph">
                                            <canvas class="chart_b" id="keyGraph4_${stat.index}" width="200" height="200"></canvas>
                                            <script>
                                                animate("keyGraph4_${stat.index}", (${keyword.num}*100)/${keywordList[0].num});
                                            </script>
                                            <span class="keyword_b keyw"><c:out value="${keyword.name}"/></span>
                                        </span>
                                    </c:if>
                                </c:forEach>
                            </dd>
                        </dl>
                    </div>
                    <div class="top_summary_wrap">
                        <div class="top_summary_row">
                            <div class="summary_box">
                                <div class="sb_inner">
                                    <span><img src="<c:url value="/images/background/onepage_icon01.png"/>" width="44px"height="auto"/></span>
                                    <div class="sb_num">
                                        <dl>
                                            <dt class="enTag">Papers</dt>
                                            <dt class="koTag">논문수</dt>
                                            <dd class="performScpArt"></dd>
                                        </dl>
                                    </div>
                                </div>
                            </div>
                            <div class="summary_box">
                                <div class="sb_inner">
                                    <span><img src="<c:url value="/images/background/onepage_icon06.png"/>" width="44px"height="auto"/></span>
                                    <div class="sb_num">
                                        <dl>
                                            <dt class="enTag">Avg Citaton per Paper</dt>
                                            <dt class="koTag">논문당 피인용횟수</dt>
                                            <dd class="performScpTcAvg"></dd>
                                        </dl>
                                    </div>
                                </div>
                            </div>
                            <div class="summary_box">
                                <div class="sb_inner">
                                    <span><img src="<c:url value="/images/background/onepage_icon07.png"/>" width="44px"height="auto"/></span>
                                    <div class="sb_num">
                                        <dl>
                                            <dt class="enTag">Avg IF per Paper</dt>
                                            <dt class="koTag">논문당 IF</dt>
                                            <dd class="performScpIf"></dd>
                                        </dl>
                                    </div>
                                </div>
                            </div>
                            <div class="summary_box">
                                <div class="sb_inner">
                                    <span><img src="<c:url value="/images/background/onepage_icon05.png"/>" width="44px"height="auto"/></span>
                                    <div class="sb_num">
                                        <dl>
                                            <dt>H-index</dt>
                                            <dd class="performScpHindex"></dd>
                                        </dl>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <p class="summary_text">※( ) All Period</p>
                    </div>
                    <div class="one_con_wrap">
                        <div class="one_col_lb">
                            <h4 class="onepage_title enTag">SCOPUS Papers</h4>
                            <h4 class="onepage_title koTag">SCOPUS 논문수</h4>
                            <div class="one_chart_box" id="scpArtChartDiv"></div>
                        </div>
                        <div class="one_col_rb">
                            <h4 class="onepage_title">Impact Factor(IF)</h4>
                            <div class="one_chart_box" id="scpIfChartDiv"></div>
                        </div>
                    </div>
                    <div class="highly_list">
                        <div class="hl_title_box">
                            <h4 class="onepage_title enTag">Highly Cited Papers</h4>
                            <h4 class="onepage_title koTag">상위 피인용논문</h4>
                            <%--<span>Since 2014</span>--%>
                        </div>
                        <table class="highly_tbl" style="border: 0px;" summary="상위 피인용논문" id="scpHighlyTb">
                            <caption>상위 피인용논문</caption>
                            <colgroup>
                                <col style="" />
                                <col style="width:100px;" />
                            </colgroup>
                            <thead>
                            <tr>
                                <th class="enTag">Papers</th>
                                <th class="koTag">논문정보</th>
                                <th class="enTag">Times Cited</th>
                                <th class="koTag">피인용횟수</th>
                            </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <div class="onepage_footer">
            <p class="enTag" style="font-size: 11px;letter-spacing:-0.5px">This report is created by data based on RIMS</p>
            <p class="koTag" style="font-size: 11px;letter-spacing:-0.5px">이 Report는 RIMS 데이터를 기반으로 작성되었습니다.</p>
            Export Date : <span></span>, Data Source : RIMS
        </div>
        <br/>
    </div>
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
