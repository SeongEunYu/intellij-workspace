<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="../pageInit.jsp" %>
<head>
	<%@include file="../pageInit.jsp" %>
</head>
<script type="text/javascript">
    $(document).ready(function(){
        $("#bigNetwork").addClass("on");
        $( "#tabs" ).tabs({
            active: '0',
            activate: function( event, ui ) {
                $('.tab_wrap a').removeClass("on");

                if(ui.newPanel.is('#tabs-1')){
                    $("#tab1").focus();
                    $('.tab_wrap a').eq(0).addClass("on");
                }
                if(ui.newPanel.is('#tabs-2')){
                    $("#tab2").focus();
                    $('.tab_wrap a').eq(1).addClass("on");
                }
            }
        });

        $("#tabs-2").append('<iframe width="100%" height="480px" style="border: none; overflow: hidden;" src="https://www.researchgate.net/plugins/department?stats=true&faces=true&publications=true&theme=light&type=department&installationId='+$("#dept").val()+'" />');
    });


    function changeDept(){
        $("#tabs-2 iframe").attr('src','https://www.researchgate.net/plugins/department?stats=true&faces=true&publications=true&theme=light&type=department&installationId='+$("#dept").val());
    }
</script>
<body>
	<script type="text/javascript" async="true" src="https://www.researchgate.net/javascript/plugin/plugin-api-min.js"></script>

	<div class="top_search_wrap">
		<div class="ts_title">
			<h3><spring:message code="disc.ntwk.extn.title"/></h3>
		</div>
		<div class="ts_text_box">
			<div class="ts_text_inner">
				<p style="font-weight:bold;"><spring:message code="disc.ntwk.extn.desc"/></p>
			</div>
		</div>
	</div>
	<div class="sub_container">
		<div id="tabs">
			<div class="tab_wrap w_33">
				<ul>
					<li id="tab1"><a href="#tabs-1" class="on"><spring:message code="disc.tab.institution"/></a></li>
					<li id="tab2"><a href="#tabs-2"><spring:message code='disc.tab.department'/></a></li>
				</ul>
			</div>
			<div id="tabs-1"><!-- 처음 탭 영역-->
				<div class="rg-plugin" data-stats="true" data-faces="true" data-publications="true" data-theme="light"  data-height="500" data-width="100%"  data-type="institution" data-installationId="5919585ab0366daab3350103"></div>
			</div>
			<div id="tabs-2"><!-- 두번째 탭 영역-->
				<div class="mgb_10">
					<span class="sel_label"><spring:message code="disc.search.filter.department"/></span>
					<span class="sel_type ">
						<select class="form-control" id="dept" style="width: auto;" onchange="javascript:changeDept();">
							<c:forEach items="${deptList}" var="dl">
								<c:if test="${dl.deptCode != '0'}">
									<option value="${dl.deptCode }">
											${language == 'en' ? dl.deptEngNm : dl.deptKorNm}
									</option>
								</c:if>
							</c:forEach>
						</select>
					</span>
				</div>
			</div>
		</div>
	</div>
</body>


