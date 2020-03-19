<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<head>
<%@include file="../pageInit.jsp" %>
<script type="text/javascript" src="${pageContext.request.contextPath}/share/js/chart/opts/fusioncharts.opts.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/share/js/chart/fusioncharts.js"></script>
<script type="text/javascript">
    $(function () {
        //대메뉴 researcher에 형광색 들어오게하기
        $("#bigAnalysis").addClass("on");

        if('${extractionDate}' != ''){
            $("#extractionDate").val('${extractionDate}');
        }

        loadData();
    });


    function loadData(){

        //차트가 있을경우 지우고 다시 그리기
        if(FusionCharts('fieldChart')) {
            FusionCharts('fieldChart').dispose();
            $('#chartdiv1').disposeFusionCharts().empty();
        }
        var fieldChartOpt = $.extend(true, {}, pieChartOpt);
        fieldChartOpt['id'] = 'fieldChart';
        fieldChartOpt['type'] = 'pie2d';
        fieldChartOpt['renderAt'] = 'chartdiv1';
        fieldChartOpt['height'] = '350';

        $("#coAuthorTbody").empty();

        $.ajax({
           	url :  "highlyCitedPaperByFieldAjax.do",
			data : { extractionDate : $("#extractionDate").val() }
		}).done(function(data){
            $('#chartdiv1').off('fusionchartsrendercomplete').on('fusionchartsrendercomplete',function(eventObj, dataObj){});
            fieldChartOpt.dataSource['categories'] = data.categories;
            fieldChartOpt.dataSource['dataset'] = data.dataset;

            $('#chartdiv1').insertFusionCharts(fieldChartOpt);

            $(".dt").remove();
            
            var dataTable = $(".hidden").clone();
            dataTable.addClass("dt");
            

            for(var i=0; i<data.fieldVoList.length; i++){
                var count = i+1;
                var dataTr = '<tr><td>'+count+'</td>';
                	dataTr += '<td style="text-align:left"><a href="javascript:goByArticle(\''+data.fieldVoList[i].rschField+'\');" style="color: #2f56d8; display: inline-block; padding: 0 16px 0 0;">'+data.fieldVoList[i].rschField+'</a></td>';
                	dataTr += '<td style="text-align:center">'+data.fieldVoList[i].paperCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+'</td>';
                	dataTr += '<td style="text-align:center">'+data.fieldVoList[i].tc.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+'</td>';
                	dataTr += '<td style="text-align:center">'+parseFloat(data.fieldVoList[i].tcPerPaper.toFixed(2))+'%</td>';
                	dataTr += '<td style="text-align:center"><a href="javascript:goByArticle(\''+data.fieldVoList[i].rschField+'\');" class="td_link">'+data.fieldVoList[i].topPaperCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+'</a></td>';
                	dataTr += '</tr>';

                dataTable.find("tbody").append(dataTr);
            }

            dataTable.removeClass("hidden");
            
			$("#chartdiv1").after(dataTable);
		});

    }
    

    function goByArticle(field){
        // & 변환
        field = field.replace(/&/g, 'amp');

        if($("#extractionDate").val() != "0"){
            $(location).attr("href","${pageContext.request.contextPath}/share/article/highlyCitedPaperByArticle.do?extractionDate="+$("#extractionDate").val()+"&field="+field);
        }else{
            dhtmlx.alert("<spring:message code='disc.alert.no.result'/>");
        }
    }
</script>
</head>
<body><!--nav_wrap : e  -->
	<div class="top_search_wrap">
		<div class="ts_title">
			<%--<h3><spring:message code="disc.anls.toprf.title"/></h3>--%>
			<h3>Top papers by research fields</h3>
		</div>
		<div class="ts_text_box">
			<%--<div class="ts_text_inner"><p><span  style="font-weight:bold;"><spring:message code="disc.anls.toprf.desc"/></span></p></div>--%>
			<div class="ts_text_inner">
				<p>
					<span  style="font-weight:bold;">최근 10년간 출판된 논문 중에서 연구분야별로 피인용수가 세계 상위 1%안에 드는 중앙대학교 논문 현황을 보실 수 있습니다.</span>
					<br>
					<span>(출처: Essential Science Indicator by CLARIVATE ANALYTICS)</span>
				</p>
			</div>
		</div>
		<div class="search_select_option">
			<span class="sel_label"><spring:message code="disc.search.filter.pub.date"/></span>
			<span class="sel_type hc_sel">
					<select id="extractionDate" class="form-control" onchange="loadData();">
						<c:if test="${fn:length(dateList) == 0}">
							<option value="0"><spring:message code="disc.search.filter.option.nodata"/></option>
						</c:if>
						<c:if test="${fn:length(dateList) > 0}">
							<c:forEach items="${dateList}" var="date">
								<option value="${date.extractionDate}:${date.periodFrom}:${date.periodTo}"> ${fn:replace(fn:substring(date.periodFrom,0,7),'-',' / ')}&#160;&#160;&#160;-&#160;&#160;&#160;${fn:replace(fn:substring(date.periodTo,0,7),'-',' / ')}&#160;&#160;&#160;&#160;&#160;(<spring:message code="disc.search.filter.option.extraction.date"/>: ${fn:replace(date.extractionDate,'-',' / ')})</option>
							</c:forEach>
						</c:if>
					</select>
				</span>
		</div>
	</div>
	<div class="sub_container">
		<div class="chart_box" id="chartdiv1" style="text-align:center;height: 395.5px;"></div>
	</div>
	<div>
		<table class="tbl_type hidden">
			<thead>
				<tr>
					<th><spring:message code="disc.table.no"/></th>
					<th><spring:message code="disc.table.research.areas"/></th>
					<th><spring:message code="disc.table.sci.papers"/></th>
					<th><spring:message code="disc.table.tc"/></th>
					<th><spring:message code="disc.table.tc.paper"/></th>
					<th><spring:message code="disc.table.top.papers"/></th>
				</tr>
			</thead>
			<tbody>
			</tbody>
		</table>
	</div>
	<!-- sub_container : e -->
</body>