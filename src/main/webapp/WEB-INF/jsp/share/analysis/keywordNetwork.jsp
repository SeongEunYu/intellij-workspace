<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="../pageInit.jsp" %>
<head>
<link rel="stylesheet" type="text/css" href="<c:url value="/share/css/network/vis.css"/>" />
<script type="text/javascript" src="<c:url value="/share/js/d3.v3.js"/>"></script>
<script type="text/javascript" src="<c:url value="/share/js/network/net.js"/>"></script>
<script type="text/javascript" src="<c:url value="/share/js/network/vis.js"/>"></script>
<script type="text/javascript">
    var prevFromYear = "${fromYear}";
    var prevToYear = "${toYear}";
    var network;
    var lineLength = 350;

	$(document).ready(function(){
		//대메뉴 researcher에 형광색 들어오게하기
		$("#bigAnalysis").addClass("on");
		$("#language").val(language);

		//학과 코드로 들어올 경우.
		if('${deptCode}' != ''){
			$('#dept').val('${deptCode}');
		}

        drawNetworkChart();
	});


	function drawNetworkChart(){
        lineLength = 350;

		if(!validateRange()){
			dhtmlx.alert("<spring:message code='disc.alert.year'/>");
			$("#fromYear").val(prevFromYear);
			$("#toYear").val(prevToYear);

			return;
		}

		$.ajax({
			url:"keywordNetworkAjax.do",
			data:$('#frm').serializeArray(),
			method:'post',
			beforeSend:function(){
				$('.wrap-loading').css('display','');
			}

		}).done(function(data){
            var colNm_all = [];
            var pf_group_val = [];
            var circle_size = [];
            var pf_val = [];

            for(var i=0; i<data.names.length; i++){
                var name = data.names[i];
                colNm_all.push(name.KEYWORD.toString().replace(/\'/g,"`"));
                pf_group_val.push({source: name.KEYWORD.toString().replace(/\'/g,"`"), group: parseInt(name.group)});
                circle_size.push(parseInt(name.CNT));

			}

			for(var j=0; j<data.coOccList.length; j++){
                var map = data.coOccList[j];

                pf_val.push({source: map.start.toString().replace(/\'/g,"`"), target: map.end.toString().replace(/\'/g,"`"), weight:map.weight});
			}


			//KEYWORD CLOUD 목록
			if(data.names.length == 0){
                dhtmlx.alert("<spring:message code='disc.alert.no.result'/> ("+$("#fromYear").val()+" ~ "+$("#toYear").val()+")");
                $('.wrap-loading').css('display','none');
                $("#fromYear").val(prevFromYear);
                $("#toYear").val(prevToYear);
                return false;
			}

            prevFromYear = $("#fromYear").val();
            prevToYear = $("#toYear").val();

            $("#networkTbody").empty();
            $("#pathFinderTbody").empty();
			/*$("#tbTh").css("border-top","1px solid");
			 $("#tbTh").css("border-bottom","1px solid #d2d2d2");
			 $("#tbTh").css("background","#f3f3f3");*/

            for(var i=0; i< data.names.length; i++){

                var name = data.names[i];

                $("#networkTbody").append(
                    "<tr>" +
                    "<td class='al_center'>"+name.KEYWORD+"</td>"+
                    "<td class='al_center'><a class='td_link' href=' javascript: clickNoPublications(\"networkDiv\",\""+name.KEYWORD+"\")'>"+ name.CNT.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + " </a></td>" +
                    "<td class='al_center'>"+ name.group + " </td>"+
                    " </tr>"
                );
            }

            for(var i=0; i< data.coOccList.length; i++){
                var co = data.coOccList[i];

                $("#pathFinderTbody").append(
                    "<tr>" +
                    "<td class='al_center'>"+co.start+"</td>"+
                    "<td class='al_center'>"+co.end+"</td>"+
                    "<td class='al_right'>"+ co.weight.toFixed(3) + " </td>"+
                    " </tr>"
                );
            }

			if(data.names.length > 0) {

                var nodes = [];
                for (var a = 0; a < colNm_all.length; a++) {
                    var group = 1;
                    for (var b = 0; b < pf_group_val.length; b++) {
                        if (colNm_all[a] == pf_group_val[b]['source']) {
                            group = pf_group_val[b]['group'];
                            break;
                        }
                    }

                    nodes.push({label: colNm_all[a], id: a, group: group, value: circle_size[a], color:cricleColor_1[group-1]});
                    //nodes.push({ label : colNm_all[a], id : a, value: circle_size[a] });
                }

                var edges = [];
                for (var a = 0; a < pf_val.length; a++) {
                    for (var b = 0; b < colNm_all.length; b++) {
                        if (pf_val[a].source == colNm_all[b]) {
                            pf_val[a].s_idx = b;
                        }
                        if (pf_val[a].target == colNm_all[b]) {
                            pf_val[a].t_idx = b;
                        }
                    }
                    edges.push({ from : pf_val[a].s_idx, to : pf_val[a].t_idx, value: pf_val[a]['weight']*100, dashes: pf_val[a]['weight'] >= 0 ? false : true    });
                }

                // create a network
                var container = document.getElementById('networkDiv');
                var data = {
                    nodes: nodes,
                    edges: edges
                };
                var options = {
                    nodes: {
                        shape: 'dot',
                        size: 30,
                        font: {size: 32, color: '#222222'},
                        borderWidth: 1,
                        scaling: {
                            min: 25,
                            max: 80
                        }
                    },
                    edges: {width: 1, length:350},
                    interaction: {zoomView: false},
                    layout: {
                        improvedLayout: true,
                        hierarchical: {
                            enabled: false
                        }
                    }
                };

                network = new vis.Network(container, data, options);

				}

			$(".wrap-loading").css('display','none');

		});
	}

    function validateRange(){
        var isRst = true;
        var fy = parseInt($('#fromYear').val());
        var ty = parseInt($('#toYear').val());

        if(fy > ty){
            isRst = false;
        }

        return isRst;
    }

    function clickNoPublications(type, keyword){
        $('.modal-body').empty();

        var fromY = $("#fromYear").val();
        var toY = $("#toYear").val();

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

               // var title = keyword + " ("+data.content.length+")";
                var title = keyword;
                $('#modalTitle').html(title);

                $('.wrap-loading').css('display','none');
                $("#dialog").modal('show');
            }
        });
    }

    function setLength(type){

        if(type == "add")lineLength+=50;
        if(type == "subtract")lineLength-=50;

        var option = {
            nodes: {
                shape: 'dot',
                    size: 30,
                    font: {size: 32, color: '#222222'},
                borderWidth: 1,
                    scaling: {
                    min: 25,
                        max: 80
                }
            },
            edges: {width: 1, length:lineLength},
            interaction: {zoomView: false},
            layout: {
                improvedLayout: true,
                    hierarchical: {
                    enabled: false
                }
            }
        };

        network.setOptions(option);
	}
</script>
</head>
<body>
<form id="frm" name="frm" method="post">
<div class="top_search_wrap">
	<div class="ts_title">
		<h3><spring:message code="disc.anls.keyNet.title"/></h3>
	</div>
	<div class="ts_text_box">
		<div class="ts_text_inner"><p style="font-weight:bold;"><spring:message code="disc.anls.keyNet.desc"/></p></div>
	</div>
	<div class="search_select_option">
		<ul>
			<li>
				<span class="sel_label"><spring:message code="disc.search.filter.department"/></span>
				<span class="sel_type">
					<select class="form-control" id="dept" name="dept" onchange="drawNetworkChart();">
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
						<select class="form-control" name="fromYear" id="fromYear" onchange="drawNetworkChart();">
							<c:forEach var="year" items="${pubYearList}">
								<option value="${year}" ${year == fromYear ? 'selected=selected' : ''}><c:out value="${year}"/></option>
							</c:forEach>
						</select>
					</span>
					~
					<span class="sel_type">
						<select class="form-control" name="toYear" id="toYear" onchange="drawNetworkChart();">
							<c:forEach var="year" items="${pubYearList}">
								<option value="${year}" ${year == toYear ? 'selected=selected' : ''}><c:out value="${year}"/></option>
							</c:forEach>
						</select>
					</span>
					<button type="button" class="btn btn-default" onclick="drawNetworkChart();"><img src="<c:url value="/share/img/background/sub_search_bt.png"/>" style="background: no-repeat 50% 50%;" ></button>
				</p>
			</li>
		</ul>
	</div>
</div>
<div class="sub_container">
	<%--<button type="button" class="btn btn-default" onclick="setLength('add');">+</button>
	<button type="button" class="btn btn-default" onclick="setLength('subtract');"> - </button>--%>
	<div id="networkDiv" style="width:100%; height:700px; " class="chart_box">
	</div>
	<span style="font-size: 18px"><spring:message code="disc.anls.keyNet.top30.keyword"/></span>
	<table class="tbl_type" style="margin-bottom: 30px;margin-top: 5px;border : none;">
		<colgroup>
			<col width="70%">
			<col width="15%">
			<col width="15%">
		</colgroup>
		<thead>
		<tr>
			<th style="border-top: 1px solid;"><spring:message code="disc.table.keyword"/></th>
			<th style="border-top: 1px solid;"><spring:message code="disc.table.frequency"/></th>
			<th style="border-top: 1px solid;"><spring:message code="disc.table.group"/></th>
		</tr>
		</thead>
		<tbody id="networkTbody"></tbody>
	</table>

	<span style="font-size: 18px"><spring:message code="disc.anls.keyNet.network"/></span>
	<table class="tbl_type" style="margin-top: 5px;border : none;">
		<colgroup>
			<col width="40%">
			<col width="40%">
			<col width="20%">
		</colgroup>
		<thead>
		<tr>
			<th style="border-top: 1px solid;"><spring:message code="disc.table.keyword1"/></th>
			<th style="border-top: 1px solid;"><spring:message code="disc.table.keyword2"/></th>
			<th style="border-top: 1px solid;"><spring:message code="disc.table.weight"/></th>
		</tr>
		</thead>
		<tbody id="pathFinderTbody"></tbody>
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
