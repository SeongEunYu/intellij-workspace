<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="../pageInit.jsp" %>
<head>
<style type="text/css">
	th {	text-align: center;  }
</style>
<script type="text/javascript" src="${pageContext.request.contextPath}/share/js/chart/opts/fusioncharts.opts.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/share/js/chart/fusioncharts.js"></script>
<script type="text/javascript">
    var chart_ChartId1;
    var orginlChartData;
    var sort = "date";
    var order = "desc";
    var prevFromYear = "${fromYear}";
    var prevToYear = "${toYear}";
    var targetDeptNm = "";
    var targetDeptCode = "";
    var fromUser = "";
    var toUser = "";

	$(document).ready(function(){
	$("#bigNetwork").addClass("on");

	$( "#tabs" ).tabs({
		active: '0',
		activate: function( event, ui ) {
			$('.tab_wrap a').removeClass("on");

            if(ui.newPanel.is('#tabs-1')){
                $("#tab1").focus();
                $('#sTabIdx').val('0');
                $('.tab_wrap a').eq(0).addClass("on");
            }
			if(ui.newPanel.is('#tabs-2')){
				$("#tab2").focus();
				$('#sTabIdx').val('1');
				$('.tab_wrap a').eq(1).addClass("on");
                // Researchers 차트가 아직 완성안됬을 경우, loading 화면전환
                if(!FusionCharts('coAuthorChart')){
                    $(".wrap-loading").css('display','');
                }
			}
			if(ui.newPanel.is('#tabs-3')){
				$("#tab3").focus();
				$('#sTabIdx').val('2');
				$('.tab_wrap a').eq(2).addClass("on");

				// Researchers 차트가 아직 완성안됬을 경우, loading 화면전환
				if(!FusionCharts('sameCoAuthorChart')){
					$(".wrap-loading").css('display','');
				}
			}
		}
	});

	//학과 코드로 들어올 경우.
	 if('${deptCode}' != ''){
		 $('#searchDept').val('${deptCode}');
	 }

	 //관련 학과 article이 있을경우 지우기
	 $(".sub_container .article_list_box").remove();
	 $(".paging_nav").empty();
	 $(".list_top_box").addClass("hidden");
	 $("#list_title").css("display","none");

	 drawOutCoAuthorChart(1);
	 drawCoAuthorChart();
	 drawcoAuthorWithinSameDeptChart();

	});

	function drawAllCharts(){

	if(!validateRange()){
		dhtmlx.alert("<spring:message code='disc.alert.year'/>");
		$("#fromYear").val(prevFromYear);
		$("#toYear").val(prevToYear);

		return;
	}else{
		prevFromYear = $("#fromYear").val();
		prevToYear = $("#toYear").val();
	}

	 //관련 학과 article이 있을경우 지우기
	 $(".sub_container .article_list_box").remove();
	 $(".paging_nav").empty();
	 $(".list_top_box").addClass("hidden");
	 $("#list_title").css("display","none");

	 drawOutCoAuthorChart();
	 drawCoAuthorChart();
	 drawcoAuthorWithinSameDeptChart();
	}

	function drawCoAuthorChart(){


	 //차트가 있을경우 지우고 다시 그리기
	 if(FusionCharts('coAuthorChart')) {
		 FusionCharts('coAuthorChart').dispose();
		 $('#chartdiv1').disposeFusionCharts().empty();
	 }


	 var coChartOpt = $.extend(true, {}, chartOpt);
	 coChartOpt['id'] = 'coAuthorChart';
	 coChartOpt['type'] = 'dragnode';
	 coChartOpt['renderAt'] = 'chartdiv1';
	 coChartOpt['height'] = '550';
	 coChartOpt['width'] = '550';
	 coChartOpt.dataSource.chart['baseFontSize'] = "13";

	 $("table").addClass("hidden");
	 $("#coAuthorTbody").empty();

		$.ajax({
			url: "coAuthorChartData.do",
			data: $('#frm').serializeArray(),
			method:'post',
			beforeSend:function(){
				$('.wrap-loading').css('display','');
			},
			error:function(){
				$(".wrap-loading").css('display','none');
				dhtmlx.alert("<spring:message code='disc.alert.error'/>");
			}
		}).done(function(data){

		 //$('#chartdiv1').off('fusionchartsrendercomplete').on('fusionchartsrendercomplete',function(eventObj, dataObj){});
		 coChartOpt.dataSource['dataset'] = data.dataset;
		 coChartOpt.dataSource['connectors'] = data.connectors;
		 coChartOpt.dataSource['styles'] = data.styles;

		 $('#chartdiv1').insertFusionCharts(coChartOpt);

		 //coAuthorList
		 for(var i=0; i<data.coAuthorList.length; i++){
			 if(i >= 10){
				 break;
			 }

			 var count = i+1;
			 var dept;
			 if(language == 'en'){
				 dept = data.coAuthorList[i].deptEngNm;
			 }else{
				 dept = data.coAuthorList[i].deptKor;
			 }

			 $("#coAuthorTbody").append("<tr>" +
				 "<td>"+count+"</td>" +
				 "<td>"+dept+"</td>" +
				 "<td><a class='td_link' href='javascript:deptChartClick(\""+data.coAuthorList[i].deptCode+"__"+dept+"\");'>"+data.coAuthorList[i].coArtsCo+"</a></td>" +
				 "</tr>");
		 }

		 if(data.coAuthorList.length == 0){
			 $("#coAuthorTbody").append("<tr>" +
										 "<td colspan='5' style='padding-left:5px;'><img src='<c:url value="/share/img/common/ico_info.png"/>' /> <spring:message code='disc.display.nodata'/></td>"+
										 "</tr>");
		 }

		 $("table").removeClass("hidden");

		if($("#tabs a").eq(0).hasClass("on")){
            setTimeout(function(){ $(".wrap-loading").css('display','none')},1000);
		}
	 });

	}

    function drawOutCoAuthorChart(){

        //차트가 있을경우 지우고 다시 그리기
        if(FusionCharts('outCoAuthorChart')) {
            FusionCharts('outCoAuthorChart').dispose();
            $('#chartdiv2').disposeFusionCharts().empty();
        }


        var coChartOpt = $.extend(true, {}, chartOpt);
        coChartOpt['id'] = 'outCoAuthorChart';
        coChartOpt['type'] = 'dragnode';
        coChartOpt['renderAt'] = 'chartdiv2';
        coChartOpt['height'] = '550';
        coChartOpt['width'] = '550';

        $("table").addClass("hidden");
        $("#outCoAuthorTbody").empty();

        $.ajax({
            url:"outCoAuthorChartData.do",
            data:$('#frm').serializeArray(),
            method:'post',
            beforeSend:function(){
                $('.wrap-loading').css('display','');
            }
        }).done(function(data){

            $('#chartdiv2').off('fusionchartsrendercomplete').on('fusionchartsrendercomplete',function(eventObj, dataObj){});
            coChartOpt.dataSource['dataset'] = data.dataset;
            coChartOpt.dataSource['connectors'] = data.connectors;
            coChartOpt.dataSource['styles'] = data.styles;

            $('#chartdiv2').insertFusionCharts(coChartOpt);

            //coAuthorList
            for(var i=0; i<data.outCoAuthorList.length; i++){
                if(i >= 10){
                    break;
                }

                var count = i+1;
                var dept;
                if(language == 'en' && data.outCoAuthorList[i].deptEng != null){
                    dept = data.outCoAuthorList[i].deptEng;
                }else{
                    dept = data.outCoAuthorList[i].deptKor;
                }

                $("#outCoAuthorTbody").append("<tr style='height:17px'>" +
                    "<td>"+count+"</td>" +
                    "<td>"+dept+"</td>" +
                    "<td><a class='td_link' href='javascript:outChartClick(\""+dept+"\");'>"+data.outCoAuthorList[i].coArtsCo+"</td>" +
                    "</tr>");
            }

            if(data.outCoAuthorList.length == 0){
                $("#outCoAuthorTbody").append("<tr>" +
                    "<td colspan='5' style='padding-left:5px;'><img src='<c:url value="/share/img/common/ico_info.png"/>'/> <spring:message code='disc.display.nodata'/></td>"+
                    "</tr>");
            }

            $("table").removeClass("hidden");

            if($("#tabs a").eq(1).hasClass("on")){
                setTimeout(function(){ $(".wrap-loading").css('display','none')},1000);
            }
        });
    }

    function drawcoAuthorWithinSameDeptChart(){
        //차트가 있을경우 지우고 다시 그리기
        if(FusionCharts('sameCoAuthorChart')) {
            FusionCharts('sameCoAuthorChart').dispose();
            $('#chartdiv3').disposeFusionCharts().empty();
        }

        var dataplotDragEnd = function (eventObj, dataObj) {
            var index = dataObj['datasetIndex'];
            orginlChartData.dataset[index].data[0].x = dataObj["x"];
            orginlChartData.dataset[index].data[0].y = dataObj["y"];
            //rims검토?
        };

        var renderComplete = function(){
            orginlChartData = chart_ChartId1.getJSONData();

            if($("#tabs a").eq(2).hasClass("on")){
                setTimeout(function(){ $(".wrap-loading").css('display','none')},1000);
            }
        };

        var coChartOpt2 = $.extend(true, {}, chartOpt);
        coChartOpt2.dataSource.chart['showPlotBorder'] = '0';
        coChartOpt2.dataSource.chart['plotFillAlpha'] = '0';
        coChartOpt2['type'] = 'dragnode';
        coChartOpt2['renderAt'] = 'chartdiv3';
        coChartOpt2['id'] = 'sameCoAuthorChart';
        coChartOpt2['height'] = '450';
        coChartOpt2['width'] = '100%';
        coChartOpt2.dataSource.chart['baseFontSize'] = "13";

        $.ajax({
			url:"${pageContext.request.contextPath}/share/user/coAuthorWithinSameDepartmentChartData.do",
			data:$('#frm').serializeArray(),
			method:'post',
            beforeSend:function(){
                $('.wrap-loading').css('display','');
            }
        }).done(function(data){
            coChartOpt2.dataSource['dataset'] = data.dataset;
            coChartOpt2.dataSource['connectors'] = data.connectors;
            coChartOpt2.dataSource['styles'] = data.styles;

            chart_ChartId1 =  new FusionCharts(coChartOpt2);
            chart_ChartId1.addEventListener("renderComplete",renderComplete);
            chart_ChartId1.addEventListener("dataplotDragEnd",dataplotDragEnd);
            chart_ChartId1.render();

            setTimeout(function(){ $(".wrap-loading").css('display','none')},1000);
        });
    }

	function deptChartClick(args){
        targetDeptCode = args.split("__")[0];
        targetDeptNm = args.split("__")[1];

		deptArticles(1,'y');
	}

	function sameChartClick(args) {
		var param = args.split(";");
		fromUser = param[0];
		toUser = param[1];

		$('#list_title').css('display', '');


		ResearcherArticles(1, 'y');
	}

    function outChartClick(args) {
        targetDeptNm = args;

        $('#list_title').css('display', '');


        outArticles(1, 'y');
    }

	function deptArticles(page, init){
		$(".sub_container .article_list_box").addClass("willBeDeleted");
		$(".paging_nav").empty();

		if(init != null){
			sort = "date";
			order = "desc";
		}

		$.ajax({
			url : "findArticleListByCoAuthorDepartmentAjax.do",
			dataType : 'json',
			mehtod : 'POST',
			data : {	 "deptKor": $('#searchDept').val(),
					 "fromYear": $('#fromYear').val(),
					 "toYear": $('#toYear').val(),
					 "gubun" : $('#gubun').val(),
					 "topNm" : "department",
				   //  "trgetSe" : trgetSe,
					 "targetDeptKor" : targetDeptCode,
					 "page":page,
					 "sort":sort,
					 "order":order
			},
            beforeSend:function(){
                $('.wrap-loading').css('display','');
            },
			success : function(data, textStatus, jqXHR){
                $('#list_title').css('display','');
                $('#list_title').text("<spring:message code='disc.ntwk.dept.pub'/> (with "+targetDeptNm+")");

                makeArticles(data,page,init,"deptArticles");
			}
		}).done(function(){});
	}

    function ResearcherArticles(page,init){
        $(".sub_container .article_list_box").addClass("willBeDeleted");
        $(".paging_nav").empty();

        if(init != null){
            sort = "date";
            order = "desc";
        }

        $.ajax({
            url : "${pageContext.request.contextPath}/share/user/findArticleListByCoAuthorAjax.do",
            dataType : 'json',
            data : {
                "gubun" : $('#gubun').val(),
                "userId": fromUser,
                "fromYear": $('#fromYear').val(),
                "toYear": $('#toYear').val(),
                "coauthorUser" : toUser,
                "page":page,
                "sort":sort,
                "order":order
            },
            beforeSend:function(){
                $('.wrap-loading').css('display','');
            },
            success : function(data, textStatus, jqXHR){
                $('#list_title').text("<spring:message code='disc.ntwk.dept.pub'/> (with " +findUserName(fromUser) +" & " + findUserName(toUser)+")");
                makeArticles(data,page,init,"ResearcherArticles");
            }
        });

    }

    function outArticles(page, init){
        $(".sub_container .article_list_box").addClass("willBeDeleted");
        $(".paging_nav").empty();

        if(init != null){
            sort = "date";
            order = "desc";
        }

        $.ajax({
            url : "findArticleListByOutCoAuthorDepartmentAjax.do",
            dataType : 'json',
            mehtod : 'POST',
            data : { "deptKor": $('#searchDept').val(),
                "fromYear": $('#fromYear').val(),
                "toYear": $('#toYear').val(),
                "gubun" : $('#gubun').val(),
                "topNm" : "department",
                //                "trgetSe" : trgetSe,
                "targetDeptKor" : targetDeptNm,
                "page":page,
                "sort":sort,
                "order":order
            },
            beforeSend:function(){
                $('.wrap-loading').css('display','');
            },
            success : function(data, textStatus, jqXHR){

                $('#list_title').css('display', '');
                $('#list_title').text("<spring:message code='disc.ntwk.dept.pub'/> (with " + targetDeptNm + ")");

                makeArticles(data,page,init,"outArticles");
            }
        }).done(function(){});
    }

	 function makeArticles(data, page, init, name){

		 //sorting
		 $(".list_sort_box a").removeClass();

		 $("#date").css("font-weight","");
		 $("#title").css("font-weight","");
		 $("#tc").css("font-weight","");

		 $("#"+sort).css("font-weight","bold");
		 $("#"+sort).addClass(order.slice(0,-1)+"_type");

		 for(var i=0; i<data.content.length; i++){
			 var content = $(".article_list_box.hidden").clone();
			 content.removeClass("hidden");

			 content.find("div").addClass("alb_text_box");

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

			 $(".paging_nav").before(content);
		 }

		 if(init != null){
			 $(".list_top_box").removeClass("hidden");
		 }

		 $(".willBeDeleted").remove();


		 <c:if test="${language eq 'en'}">
			 $(".page_num_box").text(String(data.count.ps).replace(/\B(?=(\d{3})+(?!\d))/g, ",")+" - "+String(data.count.end).replace(/\B(?=(\d{3})+(?!\d))/g, ",")+" out of "+String(data.count.total).replace(/\B(?=(\d{3})+(?!\d))/g, ",")+" results");
		 </c:if>
		 <c:if test="${language eq 'ko'}">
			 $(".page_num_box").text(String(data.count.ps).replace(/\B(?=(\d{3})+(?!\d))/g, ",")+" - "+String(data.count.end).replace(/\B(?=(\d{3})+(?!\d))/g, ",")+"건 / "+String(data.count.total).replace(/\B(?=(\d{3})+(?!\d))/g, ",")+"건");
		 </c:if>

		 var span = 1;
		 //페이징
		 for(var i=0; i<data.pageList.length; i++){
			 //처음, 다음, 이전, 이후 페이지
			 if(data.pageList[i].classNm != null) {
				 $(".paging_nav").append(" <a class='page_select "+data.pageList[i].classNm+"' href='javascript:"+name+"(\""+data.pageList[i].page+"\")'></a> ");
			 }else{
				 //페이지 숫자표기
				 if(span != 0){
					 $(".paging_nav").append(" <span></span> ");
					 span--;
				 }

				 if(page.toString() == data.pageList[i].page){
					 $(".paging_nav span").append(" <strong>"+data.pageList[i].page+"</strong>");
				 }else{
					 $(".paging_nav span").append(" <a href='javascript:"+name+"(\""+data.pageList[i].page+"\")'>"+data.pageList[i].page+"</a>");
				 }
			 }
		 }

		 $(window).scrollTop($("#list_title").offset().top-10);
         setTimeout(function(){ $(".wrap-loading").css('display','none')},1000);
	 }
	function findUserName(userId){
		var compareUserId = 'id_' + userId;
		for(var i=1; i < orginlChartData.dataset.length;i++)
		{
			var dataset = orginlChartData.dataset[i];

			if(dataset.data[0].id == compareUserId)
				return dataset.data[0].name;
		}
		return '';
	}

    //sort 클릭시
    function sortTab(inSortNm){
        if(sort == inSortNm){
            if(order == "desc"){
                order = "asc";
            }else{
                order = "desc";
            }
        }else{
            sort = inSortNm;

            if(inSortNm == "date")  order = "desc";
            if(inSortNm == "title")  order = "asc";
            if(inSortNm == "tc")  order = "desc";
        }
        if($('#sTabIdx').val() == 0){
            outArticles("1");
        }else if($('#sTabIdx').val() == 1){
            deptArticles("1");
		}else{
            ResearcherArticles("1");
        }
    }

 </script>
</head>
<body>
<form id="frm" name="frm" method="post">
	<div class="top_search_wrap">
		<div class="ts_title">
			<h3><spring:message code="disc.ntwk.dept.title"/></h3>
		</div>
		<div class="ts_text_box">
			<div class="ts_text_inner">
				<%--<p style="font-weight:bold;"><spring:message code="disc.ntwk.dept.desc"/></p>--%>
				<p style="font-weight:bold;">논문의 저자 소속 정보를 분석하여 기관단위, 학과단위, 연구자단위로 협력 현황 정보를 제공합니다.</p>
			</div>
		</div>
		<input type="hidden" id="sTabIdx"/>
		<div class="search_select_option">
			<ul>
				<li>
					<span class="sel_label"><spring:message code="disc.search.filter.department"/></span>
					<span class="sel_type ">
						<select class="form-control" id="searchDept" name="searchDept" onchange="drawAllCharts();">
							 <c:forEach items="${deptList}" var="dl" varStatus="stat">
								<option value="${dl.deptCode }" ${stat.index == deptNum? 'selected="selected"' : ''}>
										${language == 'en' ? dl.deptEngAbbr : dl.deptKorNm}
								</option>
							 </c:forEach>
						</select>
					</span>
				</li>
				<li>
					<span class="sel_label"><spring:message code="disc.search.filter.classification"/></span>
					<span class="sel_type ">
						<select class="form-control" id="gubun" name="gubun" onchange="drawAllCharts();">
							<option value="ALL"><spring:message code="disc.search.filter.option.all"/></option>
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
							<select class="form-control" name="fromYear" id="fromYear" onchange="drawAllCharts();">
								<c:forEach var="year" items="${pubYearList}">
									<option value="${year}" ${fromYear == year ? 'selected="selected"' : ''}>${year}</option>
								</c:forEach>
							</select>
						</span> ~
						<span class="sel_type">
							<select class="form-control" name="toYear" id="toYear" onchange="drawAllCharts();">
								<c:forEach var="year" items="${pubYearList}">
									<option value="${year}" ${toYear == year ? 'selected="selected"' : ''}>${year}</option>
								</c:forEach>
							</select>
						</span>
					</p>
				</li>
				<%--<li>
					<button type="button" class="btn btn-default" onclick="drawAllCharts();"><img src="<c:url value="/share/img/background/sub_search_bt.png"/>" style="background: no-repeat 50% 50%;" ></button>
				</li>--%>
			</ul>
		</div>
	</div>
	<div class="sub_container">
		<div id="tabs">
			<div class="tab_wrap w_33">
				<ul>
					<li id="tab1"><a class="on" href="#tabs-1"><spring:message code="disc.tab.institution"/></a></li>
					<li id="tab2"><a href="#tabs-2"><spring:message code="disc.tab.department"/></a></li>
					<li id="tab3"><a href="#tabs-3"><spring:message code="disc.tab.researcher"/></a></li>
				</ul>
			</div>
			<div id="tabs-1">
				<div class="row">
					<div class="col-md-6 al_center" id="chartdiv2"></div>
					<div class="col-md-6">
						<br/><br/><br/><br/><br/>
						<table class="tbl_type">
							<thead>
							<tr>
								<th><spring:message code="disc.table.no"/></th>
								<th><spring:message code="disc.table.institution"/></th>
								<th><spring:message code="disc.table.pub.no"/></th>
							</tr>
							</thead>
							<tbody id="outCoAuthorTbody"></tbody>
						</table>
					</div>
				</div>
			</div>
			<div id="tabs-2">

				<div class="row">
					<div class="col-md-6 al_center" id="chartdiv1"></div>
					<div class="col-md-6">
						<br/><br/><br/><br/><br/>
						<table class="tbl_type">
							<thead>
							<tr>
								<th><spring:message code="disc.table.no"/></th>
								<th><spring:message code="disc.table.department"/></th>
								<th><spring:message code="disc.table.pub.no"/></th>
							</tr>
							</thead>
							<tbody id="coAuthorTbody"></tbody>
						</table>
					</div>
				</div>
			</div>
			<div id="tabs-3">
				<div id="chartdiv3"></div>
			</div>
		</div>
		<p class="view_title" id="list_title" style="display: none;"><spring:message code="disc.ntwk.dept.pub"/></p>


		<div class="list_top_box hidden">
			<p class="page_num_box"></p>
			<div class="list_sort_box">
				<ul>
					<li><i><span style="padding-right: 30px;"><spring:message code="disc.sort.sort"/></span></i><a id="date" href="javascript:sortTab('date');" style="display: inline;"><span><spring:message code="disc.sort.date"/></span><em>정렬</em></a></li>
					<li><a id="tc" href="javascript:sortTab('tc');"><span><spring:message code="disc.sort.citation"/></span><em>정렬</em></a></li>
					<li><a id="title" href="javascript:sortTab('title');"><span><spring:message code="disc.sort.title"/></span><em>정렬</em></a></li>
				</ul>
			</div>
		</div>
			<div class="paging_nav"></div>
	</div>
</form>
<!-- end# wrapper-->
<form id="excelFrm" method="post" action="${contextPath}/jsp/excelExport.jsp">
      <input type="hidden" id="tableHTML" name="tableHTML" value="" />
      <input type="hidden" id="fileName" name="fileName" value="test.xls" />
</form>
<!-- 복사해서 쓸 article -->
<div class="article_list_box hidden">
	<div>
		<a href="#" class="al_title"></a>
		<p></p>
	</div>
</div>
</body>
