<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<head>
<%@include file="../pageInit.jsp" %>
<style>
.jqstooltip {width:35px; height: 40px;} /* 차트 mouseover 창 넓이 높이 */
.kor_dept_card { height: 152px; }
.researcher_info_top dl .ra_dd {font-weight: bold;}
.researcher_card {border:1.5px solid #d9d9d9;}
</style>
<script type="text/javascript">

	$(function () {
        //대메뉴 researcher에 형광색 들어오게하기
        $("#bigResearcher").addClass("on");

		//단과대학 로고 및 이름
		var clgFlag;
		var clgNm;
		var pageClass = [];
		var pageNm = [];

		<c:forEach items="${pageList}" var="pages">
			pageClass.push('${pages.classNm == null ? "null" : pages.classNm}');
			pageNm.push(${pages.page});
		</c:forEach>

		/*switch(${deptList[0].clgCode}){
			case 0492: clgFlag = "dept_l_icon01"; clgNm = language == 'ko'? '자연과학대학' : 'College of Natural Sciences';
			break;
			case 1218: clgFlag = "dept_l_icon02"; clgNm = language == 'ko'? '생명과학기술대학' : "College of Life Science and Bioengineering";
			break;
			case 0140: clgFlag = "dept_l_icon03"; clgNm = language == 'ko'? '공과대학' : "College of Engineering";
			break;
			case 1269: clgFlag = "dept_l_icon04"; clgNm = language == 'ko'? '인문사회융합과학대학' : "College of Liberal Arts and Convergence Science";
			break;
			case 0136: clgFlag = "dept_l_icon05"; clgNm = language == 'ko'? '경영대학' : "College of Business";
			break;
  		}*/

		/*$(".dept_l_title span").attr("class",clgFlag);
		$(".dept_l_title span").text(clgNm);
		$(".dept_l_title").append(clgNm);*/

        $('.mouseoverdemo').bind('sparklineRegionChange', function(ev) {
            var sparkline = ev.sparklines[0],
                region = sparkline.getCurrentRegionFields(),
                value = region[0].value;
        });

        $('.mouseoverdemo').sparkline('html', { enableTagOptions: true , tooltipFormat: '{{value}}', barWidth: 2 });

        drawPages(pageClass, pageNm);
    });

	function goUser(clgCode, deptCode, page){
		$(location).attr('href',"${pageContext.request.contextPath}/share/user/usersAtDept.do?clgCode="+clgCode+"&deptCode="+deptCode+"&page="+page);
	}

	//페이지 그리기
    function drawPages(pageClass, pageNm){
        var span = 1;
        var clgCd = "${userList[0].clgCd}";
        var deptCode = "${userList[0].deptCode}";
        var currentPage = "${page}";

        //페이징
        for(var i=0; i<pageClass.length; i++){
            //처음, 다음, 이전, 이후 페이지
            if(pageClass[i] != 'null') {
                $(".paging_nav").append(" <a class='page_select '"+pageClass[i]+"' href='javascript:goUser(\""+ clgCd +"\",\""+ deptCode +"\",\""+pageNm[i]+"\")'></a> ");
            }else{
                //페이지 숫자표기
                if(span != 0){
                    $(".paging_nav").append(" <span style='margin-left: 0px;'></span> ");
                    span--;
                }

                if(currentPage == pageNm[i]){
                    $(".paging_nav span").append(" <strong>"+pageNm[i]+"</strong>");
                }else{
                    $(".paging_nav span").append(" <a href='javascript:goUser(\""+ clgCd +"\",\""+ deptCode +"\",\""+pageNm[i]+"\")'>"+pageNm[i]+"</a>");
                }
            }
        }
    }
</script>
</head>
<body>
<div class="sub_container">
	<div class="rl_top_box h_fix">
		<a href="javascript:history.go(-1);" class="prev_bt" style="float:right;"><spring:message code="disc.anls.toprf.article.prev"/></a>
		<h4 class="dept_l_title"><span></span></h4>
		<h5>${language == 'en' ? userList[0].deptEng : userList[0].deptKor}<em>(${totalUser})</em></h5>
		<div class="r_dept_bt navbar-right">
			<div class="dept_bt_box">
				<div class="btn-group">
					<button class="btn btn-default btn-sm dropdown-toggle" type="button" data-toggle="dropdown" aria-expanded="false">
						<span><spring:message code="disc.dept.user.department"/></span> <em class="fm_up"></em><!-- <span class="caret"></span> -->
					</button>
					<ul class="dropdown-menu" role="menu" id="deptList">
						<c:forEach items="${deptList}" var="dept" varStatus="st">
							<li><a href="javascript:goUser('<c:out value="${dept.clgCode}"/>','<c:out value="${dept.deptCode}"/>','1')"><c:out value='${language=="ko" ? dept.deptKorNm : dept.deptEngNm}'/></a></li>
						</c:forEach>
					</ul>
				</div>
			</div>
		</div>
	</div>

	<div class="row">
	<c:forEach items="${userList}" var="user" varStatus="st">
		<div class="col-lg-3 col-md-4 col-sm-6">
			<div class="researcher_card kor_dept_card">
				<div class="researcher_info_top">
					<span class="researcher_img ${user.profPhotoFileId == null ? 'none_img' : ''}">
						<c:if test="${user.profPhotoFileId != null}">
							<img src="${contextPath}/rims/servlet/image/profile.do?fileid=<c:out value="${user.profPhotoFileId}"/>"/>
						</c:if>
					</span>
					<dl>
						<form action="userDetail.do" method="get">
							<input type="hidden" name="id" value="<c:out value="${user.encptUserId}"/>">
							<dt><a href="#" onclick="$(this).closest('form').submit()"><c:out value='${language=="en"? user.engNm : user.korNm}' escapeXml="false"/></a></dt>
						</form>
						<dd class="dept_dd" id="dept"><c:out value='${language=="ko"? user.deptKor : user.abbrName}' escapeXml="false"/></dd>
						<dd class="ra_dd"><c:out value='${language=="ko"? (user.majorKor1 != null ? user.majorKor1 : "&nbsp;") : (user.majorEng1 != null ? user.majorEng1 : "&nbsp;")}' escapeXml="false"/></dd>
					</dl>
				</div>
				<div class="article_year_wrap">
				<div class="article_year_box"><!-- 샘플 차트 영역-->
					<span class="g_year_t" style="padding-top: 6px;"><c:out value="${fn:substring(user.fromYm,0,4)}"/></span>
					<span class= '${user.fromYm eq null ? "": "mouseoverdemo"}' sparkType="bar" sparkBarColor="#888"><c:out value="${user.numOfArticle}"/></span>
					<span class="g_year_t"><c:out value="${fn:substring(user.toYm,0,4)}"/></span>
				</div>
				</div>
			</div>
		</div>
	</c:forEach>
	</div>

	<div class="paging_nav" style="padding-top: 20px;"></div>
</div>
<!-- sub_container : e -->
</body>