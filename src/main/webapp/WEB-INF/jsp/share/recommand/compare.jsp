<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<head>
<%@include file="../pageInit.jsp" %>
	<script type="text/javascript">

	var checkList = new Array();

	$(function () {

        $('.checkJournal').change(function(e){
			var id = $(e.currentTarget).attr("id");
            if(checkList.length < 3){
                if($("#" + id).is(":checked")){
                    checkList.push(id);
                    console.log(checkList);
                } else {
                    checkList.splice($.inArray(id, checkList),1);
                    console.log(checkList);
                }
            } else {
                alert("최대 3개까지 선택할 수 있습니다.");
                e.preventDefault();
                $("#" + id).prop("checked",false);
            }
        });
	});


	function goCompareJournal() {
		if(checkList.length > 3){
			alert("최대 3개까지 선택할 수 있습니다.");
		} else {
			var url = "${s2jApiUrl}" + "/recommend/compare/comparePopup.do?jIds=";
			for(var i=0 ; i < checkList.length ; i++){
				if(i != 0)
					url += ";";
				console.log(checkList[i]);
				url += checkList[i];
			}
			console.log(url);
			var width = $(document).width() * 0.7;
			var height = $(document).height() * 0.8;

			var left = ($(document).width()/2)-(width/2);
			var top = ($(document).height()/2)-(height/2);
			window.open(url, "Journal Compare", ' height=' + height + 'px, width=' + width + 'px, resizable=yes, location=no, scrollbars=yes');
		}
	}

	function viewDetail(seq){

		var width = $(document).width() * 0.7;
		var height = $(document).height() * 0.8;

		var left = ($(document).width()/2)-(width/2);
		var top = ($(document).height()/2)-(height/2);

		var win = window.open('${s2jUrl}/journal/journalDetailPopup.do?jrnlId='+seq,'jorunalDtl',' height=' + height + 'px, width=' + width + 'px, resizable=yes, location=no, scrollbars=yes');
		win.moveTo(left, top);
		win.focus();
	}


	function editFavorite(itemId){
		var ajaxURL = "${pageContext.request.contextPath}/editFavorite.do";
		var svcgrp = "VJOUR";
		var type = "remove";


		$.ajax({
			url: ajaxURL,
			data: {itemId:itemId, svcgrp:svcgrp, type:type, url:'', elseList:''}
		}).done(function(){
			location.reload();
		});
	}

</script>
<link rel="stylesheet" type="text/css" href="<c:url value="/share/css/mquery.css"/>" />
</head>
<body><!--nav_wrap : e  -->
	<div class="top_search_wrap">

		<div class="ts_title">
			<a href="${pageContext.request.contextPath}/personal/selection.do" class="prev_bt" style="float:right;">저널 추천 서비스</a>
			<%--<h3><spring:message code="disc.anls.topif.title"/></h3>--%>
			<h3>Journal Compare Service</h3>
		</div>
		<div class="ts_text_box">
			<div class="ts_text_inner">
				<p>
					<%--<span  style="font-weight:bold;"><spring:message code="disc.anls.topif.desc"/></span>--%>
					<span  style="font-weight:bold;"> 관심 등록한 저널에 대한 정보를 서로 비교할 수 있습니다.(최대 3개)</span>
				</p>
			</div>
		</div>
	</div>
	<div class="sub_container" style="min-height:720px; padding-top: 10px">
		<div class="jss_wrap">
			<div class="al_right">
				<a href="javascript:goCompareJournal();" class="normal_bt">Compare Journal</a>
			</div>
			<%--<div class="language_r_box">
                <a href="${pageContext.request.contextPath}/share/user/kboard.do?language=en" ${lang=='en'?'class="on"':''}><spring:message code="disc.language.eng"/></a>
                <a href="${pageContext.request.contextPath}/share/user/kboard.do?language=ko" ${lang=='ko'?'class="on"':''}><spring:message code="disc.language.kor"/></a>
            </div>--%>
				<div class="left_list_box" style="width: 1200px; margin-top: 15px;">
					<table class="tbl_type" id="journalTbl">
						<colgroup>
							<col width="10%">
							<col width="45%">
							<col width="15%">
							<col width="15%">
							<col width="15%">
						</colgroup>
						<thead>
						<tr>
							<th></th>
							<th>저널명</th>
							<th>ISSN</th>
							<th>발행처</th>
							<th>등록일</th>
						</tr>
						</thead>
						<tbody>
						<c:choose>
							<c:when test="${fn:length(journalList) > 0}">
								<c:forEach items="${journalList}" var="journal">
									<tr>
										<td class='al_center' style="padding-left: 0px; padding-right: 0px"><span style="font-size: 13px;"><span class='favorite_star star_fill' style="margin-right: 15px; margin-top: -2px;" onclick="editFavorite('${journal.dataId}')"></span><input style="margin-top: -8px;" type="checkbox" id="${journal.dataId}" class="checkJournal" ></span></td>
										<td class='al_left'><a href="javascript:viewDetail('${journal.dataId}')">${journal.title}</a></td>
										<td class='al_center' style="padding-left: 0px; padding-right: 0px"><span style="font-size: 13px">${journal.issn}</span></td>
										<td class='al_center' style="padding-left: 0px; padding-right: 0px"><span style="font-size: 13px">${journal.author}</span></td>
										<td class='al_center' style="padding-left: 0px; padding-right: 0px"><span style="font-size: 13px"><fmt:formatDate value="${journal.regDate}" pattern="yyyy-MM-dd"/></span></td>
									</tr>
								</c:forEach>
							</c:when>
							<c:otherwise>
								<tr>
									<td class='al_center' colspan="5">관심 저널 데이터가 없습니다.</td>
								</tr>
							</c:otherwise>
						</c:choose>
						</tbody>
					</table>
				</div><!-- left side -->
			</div>
		<a id="toTop" href="#">상단으로 이동</a>
	</div>

</body>