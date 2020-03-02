<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<head>
<%@include file="../pageInit.jsp" %>
	<style>
		.dept_tab_box { left: 0;}
		.dept_tab_box ul li { float: left; margin-left: 0px; margin-right: 10px;}
		.dept_l_title { font-size: 18px;  margin-bottom: 10px;}
		.dept_list a { padding: 0 12px 0 12px; }

		.col-lg-3.col-sm-4 a {border:1.5px solid #d9d9d9;}
	</style>

	<script type="text/javascript">
		$(function () {
		    //대메뉴 researcher에 형광색 들어오게하기
            $("#bigResearcher").addClass("on");

            //모든 학과 가져오기
			getDeptLi('All');
        });

		function clickTab(tabId){
            $(".dept_tab_box a").removeClass();
		    $("."+tabId+" a").attr("class","on");
            getDeptLi($("."+tabId+" a").text());
		}

		function goUser(clgCode, deptCode){
		    $(location).attr('href',"${pageContext.request.contextPath}/share/user/usersAtDept.do?clgCode="+clgCode+"&deptCode="+deptCode);
		}


		function getDeptLi(clgCode) {
			var clg = {
				"1218":"01",
				"1269":"02",
				"0492":"03",
				"0136":"04",
				"0140":"05"
			};
            $.ajax({
				url:"${pageContext.request.contextPath}/share/user/deptList.do?clgCode="+clgCode,
				method: "GET"
            }).done(function(data){
                if(data.length > 0){
                    $(".dept_list").empty();

                    for(var i=0; i<data.length; i++){
                        var dept = data[i];
						$("#"+dept.clgCode).append('<div class="col-lg-3 col-sm-4"><a class="dept_icon'+clg[dept.clgCode]+'" href="javascript:goUser(\''+dept.clgCode+'\',\''+dept.deptCode+'\')"><span>'+(language=='ko'?dept.deptKorNm:dept.deptEngNm)+'</span></a></div>');
                    }
                }else{
                   		 dhtmlx.alert("<spring:message code='disc.alert.no.result'/>");
				}

				if(clgCode == "All"){
                    $(".deptDiv").removeClass("hidden");
				}else{
                    $(".deptDiv").attr("class","deptDiv hidden");
				    $("#"+clgCode).parent().removeClass("hidden");
				}

			});
        }
	</script>
</head>
<body>
<div class="sub_container">
	<h3 class="h3_title"><spring:message code="disc.rsch.dept.title"/></h3>
	<div class="sub_title add_r_box h_fix">
		<h4>&nbsp;</h4>
		<div class="dept_tab_box">
			<ul>
				<li class="all_li"><a href="javascript:clickTab('all_li');" class="on">All</a></li>
				<c:forEach items="${collegeList}" var="clg" varStatus="idx">
					<li class="dept_tab<c:choose><c:when test="${idx.count < 10}">0<c:out value="${idx.count}"/></c:when><c:otherwise><c:out value="${idx.count}"/></c:otherwise></c:choose>">
						<a href="javascript:clickTab('dept_tab<c:choose><c:when test="${idx.count < 10}">0<c:out value="${idx.count}"/></c:when><c:otherwise><c:out value="${idx.count}"/></c:otherwise></c:choose>');" data-toggle="tooltip" title="<c:out value="${language eq 'ko'? clg.clgNm : clg.clgNmEng} (${clg.numOfCollege})"/>" data-placement="top"><c:out value="${clg.clgCode}"/></a>
					</li>
				</c:forEach>
			</ul>
		</div>
	</div>
	<c:forEach items="${collegeList}" var="clg" varStatus="idx">
		<div class="deptDiv hidden">
			<h4 class="dept_l_title"><span class="dept_l_icon<c:choose><c:when test="${idx.count < 10}">0<c:out value="${idx.count}"/></c:when><c:otherwise><c:out value="${idx.count}"/></c:otherwise></c:choose>"></span><c:out value="${language eq 'ko'? clg.clgNm : clg.clgNmEng}"/></h4>
			<div class="row dept_list" id="<c:out value="${clg.clgCode}"/>"></div>
			<c:if test="${!idx.end}"><br/></c:if>
		</div>
	</c:forEach>
</div><!-- sub_container : e -->
</body>