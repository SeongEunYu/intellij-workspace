<%--
  Created by IntelliJ IDEA.
  User: hojkim
  Date: 2019-10-07
  Time: 오후 5:15
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp" %>
<html>
<head>
    <title><spring:message code="menu.asrms.clg.oaByDepart"/></title>
    <script type="text/javascript" src="<c:url value="/js/chart/opts/fusioncharts.opts.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/js/chart/fusioncharts.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/js/jquery/jquery.tablesorter.min.js"/>"></script>
    <script type="text/javascript">

        $(function() {
            $.tablesorter.addParser({
                // set a unique id
                id: 'numFmt',
                is: function(s) {
                    // return false so this parser is not auto detected
                    return false;
                },
                format: function(s) {
                    return NumberWithoutComma(s);
                },
                // set type, either numeric or text
                type: 'numeric'
            });

            oaByDepartAjax('0');
        });

        function oaByDepartAjax(idx){
            if(!validateRange()){errorMsg(this); return false;}

            $.ajax({
                url:"<c:url value="/analysis/college/oaArticleByDepartAjax.do"/>",
                dataType: "json",
                data: $('#frm').serialize(),
                method: "POST",
                beforeLoad: $('.wrap-loading').css('display', '')
            }).done(function(data){

                if(FusionCharts('oaByDepartChart1')) {
                    FusionCharts('oaByDepartChart1').dispose();
                    $('#chartdiv1').disposeFusionCharts().empty();
                }

                var oaByDepartChartOpt = $.extend(true, {}, chartOpt);
                oaByDepartChartOpt['id'] = 'oaByDepartChart1';
                oaByDepartChartOpt['type'] = 'msstackedcolumn2d';
                oaByDepartChartOpt['renderAt'] = 'chartdiv1';
                oaByDepartChartOpt['width'] = '100%';
                oaByDepartChartOpt['height'] = '350';

                oaByDepartChartOpt.dataSource.chart['exportHandler'] = '${contextPath}/servlet/FCExporter/export.do';
                oaByDepartChartOpt.dataSource.chart['exportCallBack'] ='myFN';
                oaByDepartChartOpt.dataSource.chart['interactiveLegend'] ='0';
                oaByDepartChartOpt.dataSource.chart['xAxisName'] ='학과';
                oaByDepartChartOpt.dataSource.chart['yAxisName'] ='논문수';

                oaByDepartChartOpt.dataSource['categories'] = data.categories;
                oaByDepartChartOpt.dataSource['dataset'] = data.dataset;

                //console.log(oaByYearChartOpt);
                new FusionCharts(oaByDepartChartOpt).render();

                var $tbody = "";
                if(data.oaByDepartDetailList.length > 0){
                    $("#oaByYearTbl tbody").empty();

                    for(var i=0; i<data.oaByDepartDetailList.length; i++){
                        var fd = data.oaByDepartDetailList[i];

                        var $tr = '<tr style="height:17px;">';
                        $tr += '<td class="al_left">'+fd.deptKor+'</td>';
                        $tr += '<td class="al_right">'+fd.artsTotal.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+'</td>';
                        $tr += '<td class="al_right">'+fd.notOaArtCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+'</td>';
                        $tr += '<td class="al_right">'+fd.oaArtCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+'</td>';
                        $tr += '<td class="al_right">'+(fd.avgOaPerArtcl*100).toFixed(2)+'%</td>';
                        $tr += '<td class="al_right">'+(fd.wosCitedSum.toFixed(2)*1).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+'</td>';
                        $tr += '<td class="al_right">'+(fd.notOaArtTcSum.toFixed(2)*1).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+'</td>';
                        $tr += '<td class="al_right">'+(fd.oaArtTcSum.toFixed(2)*1).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+'</td>';
                        $tr += '<td class="al_right">'+(fd.wosCitedAvrg.toFixed(2)*1).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+'</td>';
                        $tr += '<td class="al_right">'+(fd.notOaArtCitedAvrg.toFixed(2)*1).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+'</td>';
                        $tr += '<td class="al_right">'+(fd.oaArtCitedAvrg.toFixed(2)*1).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+'</td>';
                        $tr += '</tr>';
                        $tbody += $tr;
                    }
                }else{
                    var $tr = '<tr><td colspan="99" style="padding-left:5px;"><img src="${contextPath}/images/layout/ico_info.png" /> 검색된 Data가 없습니다.</td></tr>';
                    $tbody += $tr;
                }

                $("#oaByDepartTbl tbody").html($tbody);

                if(data.oaByDepartDetailList.length > 0){
                    if(idx == '0'){
                        $("#oaByDepartTbl").tablesorter({
                            sortList:[[0,0]],
                            headers: {
                                1: { sorter:'numFmt'},
                                2: { sorter:'numFmt'},
                                3: { sorter:'numFmt'}
                            }
                        });
                    }else{
                        $("#oaByDepartTbl th").removeClass('headerSortUp');
                        $("#oaByDepartTbl th").removeClass('headerSortDown');
                        $("#oaByDepartTbl th").eq(0).addClass('headerSortDown');
                    }

                    $("#oaByDepartTbl").trigger("update");
                }

                $('#fromYear').data('prev', $('#fromYear').val());
                $('#toYear').data('prev', $('#toYear').val());

                $('.wrap-loading').css('display', 'none');
            });
        }

    </script>
</head>
<body>
    <h3 class="page_title"><spring:message code="menu.asrms.clg.oaByDepart"/></h3>
    <div class="help_text mgb_30"><spring:message code="asrms.clg.oaByDepart.desc"/></div>

    <form id="frm" name="frm">
        <input type="hidden" id="topNm" name="topNm" value="<c:out value="${topNm}"/>"/>
        <input type="hidden" name="clgCd" id="clgCd" value="<c:out value="${parameter.clgCd}"/>"/>

        <!--START page_function-->
        <div class="top_option_box">
            <div class="to_inner">
                <span>재직구분</span>
                <em>
                    <select name="hldofYn" id="hldofYn">
                        <option value="ALL">전체</option>
                        <option value="1" selected="selected">재직</option>
                        <option value="2">퇴직</option>
                    </select>
                </em>
                <span>신분구분</span>
                <em>
                    <select name="isFulltime" id="isFulltime">
                        <option value="ALL">전체</option>
                        <option value="M" selected="selected">전임</option>
                        <option value="U">비전임</option>
                    </select>
                </em>
                <span>학술지구분</span>
                <em>
                    <select name="gubun" id="gubun">
                        <option value="ALL">전체</option>
                        <option value="SCI">SCI</option>
                        <option value="SCOPUS">SCOPUS</option>
                        <option value="KCI">KCI</option>
                    </select>
                </em>
                <span>실적구분</span>
                <em>
                    <select name="insttRsltAt" id="insttRsltAt">
                        <option value="" selected="selected">전체</option>
                        <option value="Y">${sysConf['inst.abrv']}</option>
                        <option value="N">타기관</option>
                    </select>
                </em>
                <span>실적기간</span>
                <em>
                    <select name="fromYear" id="fromYear">
                        <c:forEach var="yl" items="${pubYearList}" varStatus="idx" end="50">
                            <c:if test="${yl.pubYear >= 2010}">
                                <option value="${yl.pubYear }" ${idx.index == 5 ? 'selected="selected"' : '' }>${yl.pubYear }</option>
                            </c:if>
                        </c:forEach>
                    </select>
                </em>
                ~
                <em>
                    <select name="toYear" id="toYear">
                        <c:forEach var="yl" items="${pubYearList}" varStatus="idx" end="50">
                            <c:if test="${yl.pubYear >= 2010}">
                                <option value="${yl.pubYear }">${yl.pubYear }</option>
                            </c:if>
                        </c:forEach>
                    </select>
                </em>
            </div>
            <p class="ts_bt_box">
                <a href="javascript:oaByYearAjax();" class="to_search_bt"><span>Search</span></a>
            </p>
        </div>
    </form>

    <h3 class="circle_h3">Chart</h3>

    <div class="sub_content_wrapper mgb_10">
        <div class="chart_box">
            <div id="chartdiv1"></div>
        </div>
    </div>

    <p class="bt_box mgb_10"><a href="#" onclick="exportExcel();" class="black_bt"><em class="export_icon">Export</em></a></p>

    <h3 class="circle_h3">Data</h3>

    <div class="sub_content_wrapper">
        <table width="100%" id="oaByDepartTbl" class="list_tbl mgb_20">
            <colgroup>
                <col style="width: 13%"/>
                <col style="width: 9%"/>
                <col style="width: 9%"/>
                <col style="width: 9%"/>
                <col style="width: 8%"/>
                <col style="width: 8%"/>
                <col style="width: 8%"/>
                <col style="width: 8%"/>
                <col style="width: 8%"/>
                <col style="width: 8%"/>
                <col style="width: 8%"/>
            </colgroup>
            <thead>
            <tr style="text-align: center;height:25px">
                <th><span>학과명</span></th>
                <th><span>전체논문수</span></th>
                <th><span>비OA논문수</span></th>
                <th><span>OA논문수</span></th>
                <th><span>OA논문수<br/>/총 논문수</span></th>
                <th><span>전체논문<br/>피인용합계</span></th>
                <th><span>비OA논문<br/>피인용합계</span></th>
                <th><span>OA논문<br/>피인용합계</span></th>
                <th><span>전체논문<br/>논문1편당<br/>피인용평균</span></th>
                <th><span>비OA논문<br/>논문1편당<br/>피인용평균</span></th>
                <th><span>OA논문<br/>논문1편당<br/>피인용평균</span></th>
            </tr>
            </thead>
            <tbody></tbody>
        </table>
    </div>

    <form id="excelFrm" method="post" action="${contextPath}/jsp/excelExport.jsp">
        <input type="hidden" id="tableHTML" name="tableHTML" value="" />
        <input type="hidden" id="fileName" name="fileName" value="OA_ARTICLE_BY_YEAR.xls" />
        <!--
        <input type="button" onclick="gotoExcel('tableData', 'tableHTML');" value="Export these results" />
         -->
    </form>
</body>
</html>
