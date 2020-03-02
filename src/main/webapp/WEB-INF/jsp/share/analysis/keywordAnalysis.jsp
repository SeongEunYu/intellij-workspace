<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="../pageInit.jsp" %>
<head>
	<style>
		.keyword_trnd_box_l{float: left; width: 47%;}
		.keyword_trnd_box_r{float: right; width: 47%;}
		
		@media (max-width: 1199px) {
			.keyword_trnd_box_l{float: none; width: auto;}
			.keyword_trnd_box_r{float: none; width: auto;}
		}

	</style>
	
<script type="text/javascript" src="<c:url value="/share/js/d3.v3.js"/>"></script>
<script type="text/javascript" src="<c:url value="/share/js/cloud.min.js"/>"></script>
<script type="text/javascript">
    var prevFromYear = "${fromYear}";
    var prevToYear = "${toYear}";
	var prevCompareFromYear = "${compareFromYear}";
	var prevCompareToYear = "${compareToYear}";

	$(document).ready(function(){
		//대메뉴 researcher에 형광색 들어오게하기
		$("#bigAnalysis").addClass("on");
		$("#language").val(language);

		//학과 코드로 들어올 경우.
		if('${deptCode}' != ''){
			$('#dept').val('${deptCode}');
		}

        extDateSizing();
		btnState();
        drawCloudChart();
	});

    $(window).resize(function(){
        extDateSizing();
		btnState();
    });

    function extDateSizing(){
        var width_size = window.outerWidth;

        if(width_size <= 1215){
            $("#compareDiv").attr("style","padding-top: 10px;");
        }else{
			<c:if test="${language eq 'en'}">
				$("#compareDiv").attr("style","margin-left: 240px;padding-top: 10px;");
			</c:if>
			<c:if test="${language eq 'ko'}">
				$("#compareDiv").attr("style","margin-left: 98px;padding-top: 10px;");
			</c:if>
        }
    }

	function btnState(){
		var width_size = window.outerWidth;

		if(width_size <= 786){
			$('.lg_search_btn').attr("style","display:none;");
			$('.sm_search_btn').removeAttr("style");
		}else{
			$('.lg_search_btn').removeAttr("style");
			$('.sm_search_btn').attr("style","display:none;");
		}
	}

	function drawCloudChart(){
		if(!validateRange()){
			dhtmlx.alert("<spring:message code='disc.alert.year'/>");
			$("#fromYear").val(prevFromYear);
			$("#toYear").val(prevToYear);
            $("#compareFromYear").val(prevCompareFromYear);
            $("#compareToYear").val(prevCompareToYear);

			return;
		}

		$.ajax({
			url:"keywordAnalysisAjax.do",
			data:$('#frm').serializeArray(),
			method:'post',
			beforeSend:function(){
				$('.wrap-loading').css('display','');
			}

		}).done(function(data){
			if($("#compareYn").prop("checked")){
				$(".keyword_com_box").addClass("keyword_trnd_box_r");
			}else{
				$(".keyword_com_box").removeClass("keyword_trnd_box_r");
			}

			//KEYWORD CLOUD 목록
			if(data.keywordList.length == 0){
                dhtmlx.alert("<spring:message code='disc.alert.no.result'/> ("+$("#fromYear").val()+" ~ "+$("#toYear").val()+")");
                $('.wrap-loading').css('display','none');
                $("#fromYear").val(prevFromYear);
                $("#toYear").val(prevToYear);
                return false;
			}

            prevFromYear = $("#fromYear").val();
            prevToYear = $("#toYear").val();

			if(data.keywordList.length > 0){

                if($("#compareYn").prop("checked")){

                    if(data.compareKeywordList.length == 0){
                        dhtmlx.alert("<spring:message code='disc.alert.no.result'/> ("+$("#compareFromYear").val()+" ~ "+$("#compareToYear").val()+")");
                        $('.wrap-loading').css('display','none');
                        $("#compareFromYear").val(prevCompareFromYear);
                        $("#compareToYear").val(prevCompareToYear);
                        return false;
					}

                    prevCompareFromYear = $("#compareFromYear").val();
                    prevCompareToYear = $("#compareToYear").val();

                    $("#cloudTbody").empty();

                    $("#tbTh").css("border-top","0px");
                    $("#tbTh").css("border-bottom","0px");
                    $("#tbTh").css("background","#FFFFFF");

              		var compareText = "";
					for(var j=0; j<data.compareKeywordList.length; j++){
						$("#cloudTbody").append("<tr></tr>");
						var compareKeyword = data.compareKeywordList[j];

						$("#cloudTbody tr").eq(j).append(
							"<td class='al_left' style='padding-left: 30px;'>"+compareKeyword.name+"</td>"+
							"<td class='al_center'><a class='td_link' href='javascript:clickNoPublications(\"cloudDiv0\",\""+compareKeyword.name+"\")'>"+compareKeyword.num.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+"</a></td>"+
							"<td style='border-bottom : 0px;background:#FFFFFF;'></td>"
						);

						if(j != 0 ) compareText += ";split;";
						compareText += compareKeyword.name +":"+compareKeyword.num+".0 ";
						// 키워드 50개
						if(j==49) break;
					}
                }else{
                    $("#cloudTbody").empty();

                    $("#tbTh").css("border-top","1px solid");
                    $("#tbTh").css("border-bottom","1px solid #d2d2d2");
                    $("#tbTh").css("background","#f3f3f3");
				}

                var text = "";
				for(var i=0; i<data.keywordList.length; i++){
                    var countTr;

                    //비교 키워드 여부에 따라
                    if($("#compareYn").prop("checked")){
                        // 키워드 50개
                        if(i==50) break;
                        countTr = i;

                        //키워드가 더 많을 경우
                        if(i >= data.compareKeywordList.length) {
                            $("#cloudTbody").append("<tr></tr>");
                            $("#cloudTbody tr").eq(countTr).append(
                                "<td style='border-bottom : 0px;background:#FFFFFF;'></td>"+
                                "<td style='border-bottom : 0px;background:#FFFFFF;'></td>"+
                                "<td style='border-bottom : 0px;background:#FFFFFF;'></td>");
                        }

                    }else{
                        // 키워드 70개
                        if(i==70) break;
                        countTr = parseInt(i/2);
                        if(i%2 == 0) $("#cloudTbody").append("<tr></tr>");

                        if(i!=0 && i%2 != 0){
                            $("#cloudTbody tr").eq(countTr).append(
                                "<td></td>"
                            );
                        }
                    }

                    var keyword = data.keywordList[i];

                    $("#cloudTbody tr").eq(countTr).append(
                        "<td class='al_left' style='padding-left: 30px;'>"+keyword.name+"</td>"+
                        "<td class='al_center'><a class='td_link' href='javascript: clickNoPublications(\"cloudDiv\",\""+keyword.name+"\")'>"+keyword.num.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,')+"</a></td>"
                    );

                    if(i != 0 ) text += ";split;";
                    text += keyword.name +":"+keyword.num+".0 ";
				}

                //Cloud Data
                $("#text").html(text);
                $("#cloudDiv").html("");

				/*var cloudWidth = 1150;*/
				var cloudWidth = $(".sub_container").width();
				var cloudHeight = 530;

                //비교 키워드 여부에 따라
                if($("#compareYn").prop("checked")){
                    $("#mainCloud").css("float","right");
                    $("#cloudCaption0").text(prevCompareFromYear+"~"+prevCompareToYear);
                    $("#cloudCaption1").text(prevFromYear+"~"+prevToYear);
                    $("#cloudCaption0").removeClass("hidden");
                    $("#cloudCaption1").removeClass("hidden");
                    $("#cloudCaption2 td").eq(0).text(prevCompareFromYear+"~"+prevCompareToYear);
                    $("#cloudCaption2 td").eq(2).text(prevFromYear+"~"+prevToYear);
                    $("#cloudCaption2").removeClass("hidden");

                    /*cloudWidth = 530;*/
                    cloudWidth = ($(".sub_container").width()/2)-70;

                    /*$("#cloudDiv").css("width","572px");*/

                    $("#cloudDiv0").removeClass("hidden");

                    drawCloud(cloudWidth, cloudHeight, "cloudDiv");
                    $("#text").html(compareText);
                    $("#cloudDiv0").html("");


                    drawCloud(cloudWidth, cloudHeight, "cloudDiv0");
                }else{
                    $("#mainCloud").removeAttr("style");
                    $("#cloudCaption0").addClass("hidden");
                    $("#cloudCaption1").addClass("hidden");
                    $("#cloudCaption2").addClass("hidden");

                   /* $("#cloudDiv").css("width","1200px");*/
                    $("#cloudDiv").css("width","100%");
                    $("#cloudDiv0").addClass("hidden");

                    drawCloud(cloudWidth, cloudHeight, "cloudDiv");
				}

				setTimeout(function() {
				    $.each($("text"), function(i,v){
                        var type = $("text").eq(i).parent().parent().parent().attr("id");
                        var keyword = $("text").eq(i).text();
						$("text").eq(i).css("cursor","pointer"); //손모양

                        $("text")[i].addEventListener('click',function(){
                            clickNoPublications(type,keyword);
                        },false);
					});
                    }
                , 1000);
            }

			$(".wrap-loading").css('display','none');
		});
	}

	function checkCompareYn(){
	    if($("#compareYn").prop("checked")){
	        $("#compareFromYear").removeAttr("disabled");
	        $("#compareToYear").removeAttr("disabled");
		}else{
            $("#compareFromYear").attr("disabled","disabled");
            $("#compareToYear").attr("disabled","disabled");
		}
	}

    function validateRange(){
        var isRst = true;
        var fy = parseInt($('#fromYear').val());
        var ty = parseInt($('#toYear').val());
        var fy2 = parseInt($('#compareFromYear').val());
        var ty2 = parseInt($('#compareToYear').val());

        if(fy > ty){
            isRst = false;
        }

        if(fy2 > ty2){
            isRst = false;
        }
        return isRst;
    }

    function clickNoPublications(type, keyword){
        $('.modal-body').empty();

        var fromY = $("#fromYear").val();
        var toY = $("#toYear").val();

        if(type == 'cloudDiv0'){
            fromY = $("#compareFromYear").val();
            toY = $("#compareToYear").val();
		}

        $.ajax({
            url : "findArticleListByKeywordAjax.do",
            dataType : 'json',
            data : { "deptCd": $('#dept').val(),
                "fromYear": fromY,
                "toYear": toY,
				"keyword" : keyword
            },
            beforeSend:function(){
                $('.wrap-loading').css('display','');
            },
            success : function(data){
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

                //var title = keyword + " ("+data.content.length+")";
                var title = keyword;
                $('#modalTitle').html(title);

                $('.wrap-loading').css('display','none');
                $("#dialog").modal('show');
            }
        });
    }
</script>
</head>
<body>
<form id="frm" name="frm" method="post">
<div class="top_search_wrap">
	<div class="ts_title">
		<h3><spring:message code="disc.anls.key.title"/></h3>
	</div>
	<div class="ts_text_box">
		<div class="ts_text_inner"><p style="font-weight:bold;"><spring:message code="disc.anls.key.desc"/></p></div>
	</div>
	<div class="search_select_option">
		<ul>
			<li>
				<span class="sel_label"><spring:message code="disc.search.filter.department"/></span>
				<span class="sel_type">
					<select class="form-control" id="dept" name="dept">
						 <c:forEach items="${deptList}" var="dl" varStatus="stat">
							<option value="${dl.deptCode }" ${stat.index == deptNum ? 'selected="selected"' : ''} >
									${language == 'en' ? dl.deptEngAbbr : dl.deptKorNm}
							</option>
						 </c:forEach>
					</select>
				</span>
			</li>
			<li>
				<span class="sel_label"><spring:message code="disc.search.filter.period"/></span>
				<p class="sel_col_date">
					<span class="sel_type">
						<select class="form-control" name="fromYear" id="fromYear">
							<c:forEach var="year" items="${pubYearList}">
								<option value="${year}" ${year == fromYear ? 'selected=selected' : ''}><c:out value="${year}"/></option>
							</c:forEach>
						</select>
					</span> ~
					<span class="sel_type">
						<select class="form-control" name="toYear" id="toYear">
							<c:forEach var="year" items="${pubYearList}">
								<option value="${year}" ${year == toYear ? 'selected=selected' : ''}><c:out value="${year}"/></option>
							</c:forEach>
						</select>
					</span>
					<button type="button" class="lg_search_btn btn btn-default" onclick="drawCloudChart();"><img src="<c:url value="/share/img/background/sub_search_bt.png"/>" style="background: no-repeat 50% 50%;" ></button>
				</p>
			</li>
		</ul>
	</div>

	<div class="search_select_option" id="compareDiv">
		<ul>
			<li>
				<span class="sel_label"><spring:message code="disc.search.filter.compare"/></span>
				<span class="sel_type">
					<input style="margin-bottom: 7px; margin-top: 12px;" type="checkbox" value="true" id="compareYn" name="compareYn" onclick="checkCompareYn();" checked>
				</span>
			</li>
			<li style="margin-right: 0;">
				<span class="sel_label"><spring:message code="disc.search.filter.period"/></span>
				<p class="sel_col_date">
					<span class="sel_type">
						<select class="form-control" name="compareFromYear" id="compareFromYear">
							<c:forEach var="year" items="${pubYearList}">
								<option value="${year}" ${year == compareFromYear ? 'selected=selected' : ''}><c:out value="${year}"/></option>
							</c:forEach>
						</select>
					</span> ~
					<span class="sel_type">
						<select class="form-control" name="compareToYear" id="compareToYear">
							<c:forEach var="year" items="${pubYearList}">
								<option value="${year}" ${year == compareToYear ? 'selected=selected' : ''}><c:out value="${year}"/></option>
							</c:forEach>
						</select>
					</span>
				</p>
			</li>
			<li class="sm_search_btn">
				<span class="sel_label"/>
				<p class="sel_col_date">
					<button type="button" class="btn btn-default" onclick="drawCloudChart();"><img src="<c:url value="/share/img/background/sub_search_bt.png"/>" style="background: no-repeat 50% 50%;" ></button>
				</p>
			</li>
		</ul>
	</div>
</div>
<div class="sub_container">
	<div style="text-align: center">
		<div class="keyword_trnd_box_l">
			<div id="cloudCaption0" style="display: inline-block;font-size: 30px;"></div>
			<div id="cloudDiv0" class="chart_box hidden"></div>
		</div>
		<div class="keyword_com_box">
			<span id="cloudCaption1" style="display: inline-block;font-size: 30px;"></span>
			<div id="cloudDiv" class="chart_box"></div>
		</div>
	</div>
	<textarea id="text" style="display: none;"></textarea>
	<table class="tbl_type" style="border : none;">
		<colgroup>
			<col width="30%">
			<col width="17%">
			<col width="5%">
			<col width="30%">
			<col width="17%">
		</colgroup>
		<thead>
		<tr id="cloudCaption2" class="hidden">
			<td colspan="2" style="font-size: 18px;text-align: center;"></td>
			<td></td>
			<td colspan="2" style="font-size: 18px;text-align: center;"></td>
		</tr>
		<tr>
			<th style="border-top: 1px solid;"><spring:message code="disc.table.keyword"/></th>
			<th style="border-top: 1px solid;"><spring:message code="disc.table.frequency"/></th>
			<th id="tbTh" style="border-top: 1px solid;"></th>
			<th style="border-top: 1px solid;"><spring:message code="disc.table.keyword"/></th>
			<th style="border-top: 1px solid;"><spring:message code="disc.table.frequency"/></th>
		</tr>
		</thead>
		<tbody id="cloudTbody"></tbody>
	</table>

</div>
</form>

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
</body>
