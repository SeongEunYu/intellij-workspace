<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="../pageInit.jsp" %>
<head>
<script type="text/javascript" src="${pageContext.request.contextPath}/share/js/chart/opts/fusioncharts.opts.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/share/js/chart/fusioncharts.js"></script>
<title><spring:message code="menu.asrms.about.journal"/></title>
<script type="text/javascript">
	var prevFromYear = "${fromYear}";
	var prevToYear = "${toYear}";
	var clickedRow;
	var clickedRowColor;


	$(document).ready(function(){
		//대메뉴 researcher에 형광색 들어오게하기
		$("#bigAnalysis").addClass("on");

		//학과 코드로 들어올 경우.
		if('${deptCode}' != ''){
			$('#dept').val('${deptCode}');
		}

		drawJournalChart(1);
	});


	function selectRow(issn){
		if(issn == 'ISSN') return false;

		$.ajax({
			url : "findJournalInfoByIssnNoAjax.do",
			dataType : 'json',
			data : { "issnNo":issn,
				"gubun": $('#gubun').val()
			},
			success : function(data, textStatus, jqXHR){
				var indct = data.data;
				$('#info_body').empty();
				for(var i=0; i < indct.length; i++){
					var dataValue = indct[i].dataValue == null ? '-' : indct[i].DATA_VALUE;
					var $tr = $('<tr></tr>');
					$tr.append($('<td>'+indct[i].prodYear+'</td>'));
					$tr.append($('<td>'+indct[i].dataValue+'</td>'));
					$('#info_body').append($tr);
				}

				var sbjt = data.cat;
				$('#sbjt_body').empty();
				for(var j=0; j < sbjt.length; j++){
					var $tr = $('<tr></tr>');
					//$tr.append($('<td style="text-align:center;">'+sbjt[j].ctgryCode+'</td>'));
					$tr.append($('<td>'+sbjt[j].ctgryName+'</td>'));
					$('#sbjt_body').append($tr);
				}

			}

		});
	}

	function drawJournalChart(first){

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
		if(FusionCharts('journalChart')) {
			FusionCharts('journalChart').dispose();
			$('#chartdiv1').disposeFusionCharts().empty();
		//    $('#chartdiv1').css('height','350');
		}

		var tcChartOpt = $.extend(true, {}, pieChartOpt);
		tcChartOpt['id'] = 'journalChart';
		tcChartOpt['type'] = 'pie2d';
		tcChartOpt['renderAt'] = 'chartdiv1';
		tcChartOpt['height'] = '350';


		$("#journalTbody").empty();
		$("#info_body").empty();
		$("#sbjt_body").empty();

		$.ajax({
			url:"journalForDeptChartData.do",
			data:$('#frm').serializeArray(),
			method:'post',
			beforeSend:function(){
				$('.wrap-loading').css('display','');
			}

		}).done(function(data){

			$('#chartdiv1').off('fusionchartsrendercomplete').on('fusionchartsrendercomplete',function(eventObj, dataObj){});
			tcChartOpt.dataSource['categories'] = data.categories;
			tcChartOpt.dataSource['dataset'] = data.dataset;

		//    $('#chartdiv1').css('height','');
			$('#chartdiv1').insertFusionCharts(tcChartOpt);

			//저널목록
			if(data.journalList.length > 0){
				for(var i=0; i<data.journalList.length; i++){
					var count = i+1;
					var title = data.journalList[i].title;
					if(title == null){
						title = "";
					}

					if(title.length > 59){
						title = data.journalList[i].title.substr(0,59)+"...";
					}

					$("#journalTbody").append("<tr>" +
						"<td>"+count+"</td>" +
						"<td class='al_left'><span title='"+data.journalList[i].title+"'>"+title+"</span></td>" +
						"<td>"+data.journalList[i].issnNo+"</td>" +
						"<td><a href='javascript:clickNoPublications(\""+data.journalList[i].issnNo+"\",\""+title+"\");' class='td_link'>"+data.journalList[i].artsCo+"</a></td>" +
						"<td>"+data.journalList[i].userCo+"</td>" +
						"</tr>");
				}
			}else{
				$("#journalTbody").append("<tr>" +
											"<td colspan='5' style='padding-left:5px;'><img src='${contextPath}/images/layout/ico_info.png' /> <spring:message code='disc.display.nodata'/></td>"+
										  "</tr>");
			}

			$('#info_tbl').fixedHeaderTable({ footer: false, cloneHeadToFoot: true, fixedColumn: false });
			$('#sbjt_tbl').fixedHeaderTable({ footer: false, cloneHeadToFoot: true, fixedColumn: false });

			var jtHeight =parseInt($('#journalTbl').height(),10);
			var infoHeight = jtHeight*0.5;

			//if(jtHeight < 415) infoHeight = 270;
			var sbjtHeight = parseInt(jtHeight, 10) - infoHeight -27;

			$('#info_tbl').fixedHeaderTable({ height: infoHeight });
			$('#sbjt_tbl').fixedHeaderTable({ height: sbjtHeight });

			$(".fht-thead").css("overflow", "visible");
			$(".right_subject_wrap th").eq(0).css("padding-left","10px");

			$('#journalTbl tr').bind('click',function(){
				$('#journalTbl tr').removeClass('select_row');

				if(clickedRow != undefined){
					$(clickedRow).css("background-color",clickedRowColor);
				}

				clickedRowColor = $(this).css("background-color");
				clickedRow = this;

				$(this).addClass('select_row');
				//$(".select_row").css("background","rgb(166,233,232)");
				$(".select_row").css("background","rgb(74, 81, 84)");

				var child = $(this).children();
				var issn = child.eq(2).text();

				selectRow(issn);
			});

			var firstRow = $('#journalTbl tr').eq(1);
			$('#journalTbl tr').removeClass('select_row');
			$(firstRow).addClass('select_row');
			var child = $(firstRow).children();
			var issn = child.eq(2).text();
			selectRow(issn);

			$(".wrap-loading").css('display','none');
		});

		<%--$('#chartdiv1').off('fusionchartsrendercomplete').on('fusionchartsrendercomplete',function(eventObj, dataObj){});--%>
		<%--tcChartOpt.dataSource['categories'] = ${fn:replace(categories,'=',':')};--%>
		<%--tcChartOpt.dataSource['dataset'] = ${fn:replace(dataset,'=',':')};--%>
		<%--$('#chartdiv1').insertFusionCharts(tcChartOpt);--%>

	}

	function clickNoPublications(issn_no, magazine){
		if(issn_no == 'ISSN') return;
		//alert("chartClick event execute !!" + year);
		$('.modal-body').empty();
		//loading publication list of year by ajax

		$.ajax({
			url : "findArticleListByIssnNoAjax.do",
			dataType : 'json',
			data : { "deptKor": $('#dept').val(),
				"fromYear": $('#fromYear').val(),
				"toYear": $('#toYear').val(),
				"gubun" : $('#gubun').val(),
				"issnNo" : issn_no
			},
			beforeSend:function(){
				$('.wrap-loading').css('display','');
			},
			success : function(data, textStatus, jqXHR){

				for(var i=0; i<data.content.length; i++){

					var content = $(".article_list_box.hidden").clone();
					content.removeClass("hidden");

					// 피인용 횟수가 있으면
					if(data.content[i].kciTc+data.content[i].scpTc+data.content[i].tc != 0){
						content.find("div").append("<div class='list_r_info'><ul></ul></div>");
					}

					content.find(".al_title").text(data.content[i].orgLangPprNm);    //논문 명
					content.find(".al_title").attr("href","${pageContext.request.contextPath}/share/article/articleDetail.do?id="+data.content[i].articleId);    //세부정보로 이동

					(data.content[i].tc != null && data.content[i].tc != 0 ? content.find(".list_r_info ul").append('<li>SCI<span>'+data.content[i].tc+'</span></li>') : "");      // WOS 피인용 횟수
					(data.content[i].scpTc != null && data.content[i].scpTc != 0 ? content.find(".list_r_info ul").append('<li class="l_scopus">SCOPUS<span>'+data.content[i].scpTc+'</span></li>') : "");      //Scopus 피인용 횟수
					(data.content[i].kciTc != null && data.content[i].kciTc != 0 ? content.find(".list_r_info ul").append('<li class="l_kci">KCI<span>'+data.content[i].kciTc+'</span></li>') : "");      //KCI 피인용 횟수

					content.find(".al_title").attr("target","_self");
					content.find("p").html(data.content[i].content);  //간략 내용

                    if(data.content[i].keywordList.length != 0){
                        var keyArr = data.content[i].keywordList;

                        content.append('<div class="l_keyword_box"></div>');
                        content.find(".l_keyword_box").append("<span>Keywords</span>");
                        //키워드
                        for(var j=0; j<keyArr.length; j++){
                            content.find(".l_keyword_box").append('<a href="javascript:searchAll(\''+keyArr[j].trim()+'\');">'+ keyArr[j].trim() + '</a>');
                        }
                    }

					$(".modal-body").append(content);
				}

				var title = magazine + " ("+data.content.length+")";
				$('#modalTitle').html(title);

				$('.wrap-loading').css('display','none');
				$("#dialog").modal('show');
			}
		});
	}
</script>
	<style>
		@media (max-width: 989px) {
			.left_list_box{ width: 100%;}
		}

		.fht-table thead th{padding-left: 0 !important;}
	</style>
</head>
<body>
	<div class="top_search_wrap">
		<div class="ts_title">
			<h3><spring:message code="disc.anls.jnl.title"/></h3>
		</div>
		<div class="ts_text_box">
			<div class="ts_text_inner"><p style="font-weight:bold;"><spring:message code="disc.anls.jnl.desc"/></p></div>
		</div>
		<form id="frm" name="frm">
			<div class="search_select_option">
				<ul>
					<li>
						<span class="sel_label"><spring:message code="disc.search.filter.department"/></span>
						<span class="sel_type ">
							<select class="form-control" id="dept" name="dept" onchange="drawJournalChart();">
								<c:forEach items="${deptList}" var="dl" varStatus="idx">
									<c:if test="${idx.count == 1}">
										<option value="ALL"  selected="selected">
											<spring:message code="disc.search.filter.option.all"/>
										</option>
									</c:if>
									<option value="${dl.deptCode }" ${idx.index == deptNum ? 'selected="selected"' : ''}>
										<c:if test="${language != 'en' }"> ${dl.deptKorNm }</c:if>
										<c:if test="${language == 'en' }"> ${dl.deptEngAbbr }</c:if>
									</option>
								</c:forEach>
							</select>
						</span>
					</li>
					<li>
						<span class="sel_label"><spring:message code="disc.search.filter.classification"/></span>
						<span class="sel_type ">
							<select class="form-control" name="gubun" id="gubun" onchange="drawJournalChart();">
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
								<select class="form-control" name="fromYear" id="fromYear" onchange="drawJournalChart();">
									<c:forEach var="year" items="${pubYearList}">
										<option value="${year}" ${fromYear == year ? 'selected="selected"' : ''}>${year}</option>
									</c:forEach>
								</select>
							</span> ~
							<span class="sel_type">
								<select class="form-control" name="toYear" id="toYear" onchange="drawJournalChart();">
									<c:forEach var="year" items="${pubYearList}">
										<option value="${year}" ${toYear == year ? 'selected="selected"' : ''}>${year}</option>
									</c:forEach>
								</select>
							</span>
						</p>
					</li>
				</ul>



			</div>
		</form>
	</div>
	<div class="sub_container">
		<div id="chartdiv1" class="chart_box" style="text-align:center;"></div>
		<div class="add_discover">
			<div class="left_list_box">
				<div>
					<table class="tbl_type" id="journalTbl">
						<colgroup>
							<col width="30%">
							<col width="70%">
						</colgroup>
						<thead>
						<tr>
							<th><spring:message code="disc.table.no"/></th>
							<th><spring:message code="disc.table.journal"/></th>
							<th><spring:message code="disc.table.issn"/></th>
							<th><spring:message code="disc.table.pub.total"/></th>
							<th><spring:message code="disc.table.reseachers.total"/></th>
						</tr>
						</thead>
						<tbody id="journalTbody"></tbody>
					</table>
				</div>
			</div>

			<div class="right_subject_wrap">
				<div class="subject_box">
					<table class="subject_tbl" id="info_tbl">
						<colgroup>
							<col width="30%">
							<col width="70%">
						</colgroup>
						<thead>
						<tr>
							<th><spring:message code="disc.facet.year"/></th>
							<th><spring:message code="disc.facet.if"/></th>
						</tr>
						</thead>
						<tbody id="info_body"></tbody>
					</table>
				</div>

				<div class="subject_box sb_type">
					<table class="subject_tbl" id="sbjt_tbl">
						<thead>
						<tr>
							<th class="al_left"><spring:message code="disc.facet.subject"/></th>
						</tr>
						</thead>
						<tbody id="sbjt_body"></tbody>
					</table>
				</div>
			</div>
		</div>

		<!-- Modal -->
		<div class="modal fade" id="dialog" tabindex="-1" role="dialog" aria-labelledby="exampleModalLongTitle" aria-hidden="true">
			<div class="modal-dialog" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
						<h5 class="modal-title" id="modalTitle"></h5>
					</div>
					<div class="modal-body">
					</div>
				</div>
			</div>
		</div>

		<div class="article_list_box hidden">
			<div class="alb_text_box">
				<a class="al_title"></a>
				<p></p>
			</div>
		</div>
	</div>
</body>
