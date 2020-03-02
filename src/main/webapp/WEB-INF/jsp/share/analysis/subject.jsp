<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="../pageInit.jsp" %>
<head>
<script type="text/javascript" src="${pageContext.request.contextPath}/share/js/chart/opts/fusioncharts.opts.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/share/js/chart/fusioncharts.js"></script>
<style type="text/css">
    .search_select_option .sel_col_5 { width:100px;}
</style>
<script type="text/javascript">
	var prevFromYear = "${fromYear}";
	var prevToYear = "${toYear}";
	var chart_ChartId;
	var cjArr;


	$(document).ready(function(){
		//대메뉴 researcher에 형광색 들어오게하기
		$("#bigAnalysis").addClass("on");
        $("#language").val(language);

		//학과 코드로 들어올 경우.
		if('${deptCode}' != ''){
			$('#dept').val('${deptCode}');
		}

        $( "#tabs" ).tabs({
            active: '0',
            activate: function( event, ui ) {
                $('.tab_wrap a').removeClass("on");

                if(ui.newPanel.is('#tabs-1')){
                    $("#tab1").focus();
                    $('.tab_wrap a').eq(0).addClass("on");

                    //전체 체크 및 dim처리
					$('input:checkbox').each(function(){
					    if(this.checked){
					        $(this).addClass("orig");
						}else{
					        this.checked = true;
						}
					})
                    $('input:checkbox').attr("disabled","disabled");
                }
                if(ui.newPanel.is('#tabs-2')){
                    $('input:checkbox').removeAttr("disabled");
                    //전체 체크 해제후 원래 체크된 영역만 표시
                    $('input:checkbox').each(function(){
                        if(!$(this).hasClass("orig")){
                            this.checked = false;
                        }
                    })

                    $("#tab2").focus();
                    $('.tab_wrap a').eq(1).addClass("on");
                }
            }
        });
        drawSubjectChart(1);
	});

	function clickCheckbox(obj){

        if($(obj).prop('id') == "toggleChkbox"){
            if($(obj).prop("checked") == true)
            {
                $('input[id^="chkbox_"]').prop('checked', true);
                $('input[id^="chkbox_"]').addClass('orig');
            }
            else
            {
                $('input[id^="chkbox_"]').prop('checked', false);
                $('input[id^="chkbox_"]').removeClass('orig');
            }
        }

		if($(obj).hasClass("orig")){
           $(obj).removeClass("orig");
		}

		var category = "<categories>";
		var dataset = "";
		var fy = parseInt($('#fromYear').val(),10);
		var ty = parseInt($('#toYear').val(),10);

		for(var i=fy; i <= ty; i++){
			category += "<category label='"+i+"' />";
		}
		category += "</categories>";

		var chb = $('input[id^="chkbox_"]:checked');
		for(var j=0; j < chb.length; j++){
			var fcIdx = $('input[id^="chkbox_"]').index(chb.eq(j)) % 23;
			var yearJson = getYearMap(chb.eq(j).val());
			var catName = $('#catNm_'+chb.eq(j).val()).val();
			var color = colorArray[fcIdx];
			dataset += "<dataset seriesName='"+catName+"' id='"+chb.eq(j).val()+"' color='"+color+"'>";
			//dataset += "<dataset seriesName='"+catName+"' id='"+chb.eq(j).val()+"'>";
			for(var i=fy; i <= ty; i++){
				if(yearJson[i] == undefined) dataset += "<set value='0' toolText='"+catName+" "+i+" : 0' />";
				else dataset += "<set value='"+yearJson[i]+"' toolText='"+catName+" "+i+" : "+yearJson[i]+"' />";
			}
			dataset += "</dataset>";
		}

		var chartData = chart_ChartId.getChartData('xml');
		chartData = chartData.replace(/(<chart .*>)(<categories.*)(<styles.*)/, '$1'+category+dataset+'<styles>$3');

		chart_ChartId.setDataXML(chartData);
		//chartObject.setDataXML(preVars.replace(/(.*dataXML=)(<chart .*>)(<categories.*)(<styles.*)/, '$2$3$4'));
	}

	function getYearMap(chkValue){
		var retString = "{";
		for(var i=0; i < cjArr.length; i++){
			if(cjArr[i].ctgryCode == chkValue) retString += cjArr[i].prodYear + ":" + cjArr[i].artsCo + ",";
		}
		retString = retString.substring(0, retString.length-1) + "}";
		return eval('('+retString+')');
	}

	function drawSubjectChart(first){
		if(!validateRange()){
			dhtmlx.alert("<spring:message code='disc.alert.year'/>");
			$("#fromYear").val(prevFromYear);
			$("#toYear").val(prevToYear);

			return;
		}else{
			prevFromYear = $("#fromYear").val();
			prevToYear = $("#toYear").val();
		}

		//차트가 있을경우 지우고 다시 그리기
		if(FusionCharts('subjectChart')) {
			FusionCharts('subjectChart').dispose();
			FusionCharts('pieChart').dispose();
			$('#chartdiv1').disposeFusionCharts().empty();
			$('#chartdiv2').disposeFusionCharts().empty();
			//    $('#chartdiv1').css('height','350');
		}
        var chart_pie = $.extend(true, {}, pieChartOpt);
        chart_pie['id'] = 'pieChart';
        chart_pie['type'] = 'pie2d';
        chart_pie['renderAt'] = 'chartdiv1';
        chart_pie['height'] = '350';


        var chart_line = $.extend(true, {}, chartOpt);
        chart_line['id'] = 'subjectChart';
        chart_line['type'] = 'MSLine';
        chart_line['renderAt'] = 'chartdiv2';
        chart_line['height'] = '350';
        chart_line.dataSource.chart['divlineColor'] = '#999999';
        chart_line.dataSource.chart['divlineThickness'] = '1';
        chart_line.dataSource.chart['divLineIsDashed'] = '1';
        chart_line.dataSource.chart['divLineDashLen'] = '1';
        chart_line.dataSource.chart['divLineGapLen'] = '1';
        chart_line.dataSource.chart['showHoverEffect'] = '1';
        chart_line.dataSource.chart['formatNumberScale'] = '0';
        chart_line.dataSource.chart['labelDisplay'] = 'rotate';
        chart_line.dataSource.chart['slantLabels'] = '1';
        chart_line.dataSource.chart['adjustDiv'] = '1';

		$("#subjectTbody").empty();
		$.ajax({
			url:"subjectForDeptChartData.do",
			data:$('#frm').serializeArray(),
			method:'post',
			beforeSend:function(){
				$('.wrap-loading').css('display','');
			}

		}).done(function(data){
            cjArr = eval('('+ data.dataJson+')');

			var pubYearList = data.pubYearList;

            chart_line.dataSource['categories'] = data.categories;
            chart_line.dataSource['dataset'] = data.dataset;
            chart_line.dataSource['styles'] = data.styles;
            chart_pie.dataSource['dataset'] = data.dataset2;
            chart_pie.dataSource['styles'] = data.styles2;

            $('#chartdiv1').insertFusionCharts(chart_pie);
            chart_ChartId = new FusionCharts(chart_line).render();

			//Subject 목록
			if(data.subjectList.length > 0){
				for(var i=0; i<data.subjectList.length; i++){
					var sl = data.subjectList[i];
                    $("#subjectTbody").append("<tr>" +
                        "<td><input type='checkbox'  id='chkbox_"+sl.ctgryCode+"' value='"+sl.ctgryCode+"'><input type='hidden'  id='catNm_"+sl.ctgryCode+"' id='catNm_"+sl.ctgryCode+"' value='"+sl.ctgryName+"'></td>" +
                        "<td class='al_left'><span title='"+sl.ctgryName+"'>"+sl.ctgryName+"</span></td>" +
                        "<td class='al_center'>"+sl.artsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+"</td>" +
                        "<td class='al_center'>"+parseFloat(((sl.artsCo/data.totPublication)*100).toFixed(2))+"%</td>" +
                        "</tr>");

                    if(i <= 4){
                        $("#chkbox_"+sl.ctgryCode).attr("checked",true);
                    }
				}

				if($("#tab1 a").hasClass("on")){
                    //전체 체크 및 dim처리
                    $('td input:checkbox').each(function(){
                        if(this.checked){
                            $(this).addClass("orig");
                        }else{
                            this.checked = true;
                        }
                    })
                    $('input:checkbox').attr("disabled","disabled");
				}

            }else{
				$("#subjectTbody").append("<tr>" +
					"<td colspan='5' style='padding-left:5px;'><spring:message code='disc.display.nodata'/></td>"+
					"</tr>");
			}


			$('input:checkbox').bind('click', function(){ clickCheckbox($(this));});

			$(".wrap-loading").css('display','none');
		});
	}
</script>
</head>
<body>
<div class="top_search_wrap">
	<div class="ts_title">
		<h3><spring:message code="disc.anls.sbj.title"/></h3>
	</div>
	<div class="ts_text_box">
		<div class="ts_text_inner"><p style="font-weight:bold;"><spring:message code="disc.anls.sbj.desc"/></p></div>
	</div>
	<form id="frm" name="frm">
		<input type="hidden" id="language" name="language"/>
		<div class="search_select_option">
			<ul>
				<li>
					<span class="sel_label"><spring:message code="disc.search.filter.department"/></span>
					<span class="sel_type ">
						<select class="form-control" id="dept" name="dept" onchange="drawSubjectChart();">
							<c:forEach items="${deptList}" var="dl" varStatus="idx">
								<c:if test="${idx.count == 1}">
									<option value="All"  selected="selected"><spring:message code="disc.search.filter.option.all"/></option>
								</c:if>
								<option value="${dl.deptCode }" ${idx.index == deptNum ? 'selected="selected"' : ''}>${language == 'en' ? dl.deptEngAbbr : dl.deptKorNm }</option>
							</c:forEach>
						</select>
					</span>
				</li>
				<li>
					<span class="sel_label"><spring:message code="disc.search.filter.classification"/></span>
					<span class="sel_type ">
						<select class="form-control" name="gubun" id="gubun" onchange="drawSubjectChart();">
							<option value="SCI">SCI</option>
							<option value="SCOPUS">SCOPUS</option>
							<option value="KCI">KCI</option>
						</select>
					</span>
				</li>
				<li>
					<span class="sel_label"><spring:message code="disc.search.filter.period"/></span>
					<p class="sel_col_date">
						<span class="sel_type">
							<select class="form-control" name="fromYear" id="fromYear" onchange="drawSubjectChart();">
								<c:forEach var="year" items="${pubYearList}">
									<option value="${year}" ${fromYear == year ? 'selected="selected"' : ''}>${year}</option>
								</c:forEach>
							</select>
						</span> ~
						<span class="sel_type">
							<select class="form-control" name="toYear" id="toYear" onchange="drawSubjectChart();">
								<c:forEach var="year" items="${pubYearList}">
									<option value="${year}" ${toYear == year ? 'selected="selected"' : ''}>${year}</option>
								</c:forEach>
							</select>
						</span>
					</p>
				</li>
				<li>
					<span class="sel_label"><spring:message code="disc.search.filter.list"/></span>
					<span class="sel_type">
						<select class="form-control" name="rownum" id="rownum" onchange="drawSubjectChart();">
							<option value="20" selected="selected">20</option>
							<option value="50">50</option>
						</select>
					</span>
				</li>
			</ul>
		</div>
	</form>
</div>
<div class="sub_container">
	<div id="tabs">
		<div class="tab_wrap w_33">
			<ul>
				<li id="tab1"><a class="on" href="#tabs-1"><spring:message code="disc.tab.chart.pie"/></a></li>
				<li id="tab2"><a href="#tabs-2"><spring:message code="disc.tab.chart.line"/></a></li>
			</ul>
		</div>
		<div id="tabs-1"><!-- 처음 탭 영역-->
			<div id="chartdiv1" class="chart_box"></div>
		</div>
		<div id="tabs-2">
			<div id="chartdiv2" class="chart_box"></div>
		</div>
	</div>
	<table class="tbl_type">
		<thead>
		<tr>
			<th>
				<input type="checkbox" name="toggleChkbox" id="toggleChkbox" value="0"/>
			</th>
			<th><spring:message code="disc.table.subject"/></th>
			<th><spring:message code="disc.table.pub.total"/></th>
			<th><spring:message code="disc.table.percentage"/></th>
		</tr>
		</thead>
		<tbody id="subjectTbody"></tbody>
	</table>
</div>
</body>
