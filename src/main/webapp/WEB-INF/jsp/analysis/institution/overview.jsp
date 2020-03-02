<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><spring:message code="menu.asrms.inst.overview"/></title>
<script type="text/javascript">
	$(function () {
		$.ajax({
			url:"<c:url value="/analysis/institution/chartXmlAjax.do"/>",
			dataType: "json",
			data: $('#frm').serialize(),
			method: "POST",
			beforeLoad: $('.wrap-loading').css('display', '')

		}).done(function(data){
			chart_ChartId1 =  new FusionCharts({
                id:'ChartId1',
                type:'Column2D',
                width:'100%',
                height:'288',
                debugMode:'false',
                registerWithJS:'false',
                dataFormat:'xml',
                dataSource:data.pubChartXML,
                renderAt:'chartdiv1'
            }).render();
			chart_ChartId2 =  new FusionCharts({
                id:'ChartId2',
                type:'stackedbar2d',
                width:'100%',
                height:'288',
                debugMode:'false',
                registerWithJS:'false',
                dataFormat:'xml',
                dataSource:data.avgrIFChartXML,
                renderAt:'chartdiv2'
            }).render();
			chart_ChartId3 =  new FusionCharts({
                id:'ChartId3',
                type:'Column2D',
                width:'100%',
                height:'288',
                debugMode:'false',
                registerWithJS:'false',
                dataFormat:'xml',
                dataSource:data.citedChartXML,
                renderAt:'chartdiv3'
            }).render();

			var html = '';
			var lastedArtList = data.lastedArtList;
			var cnt = lastedArtList.length >= 4 ? 4 : lastedArtList.length;
			for(var i = 0; i < cnt; i++){
				var item = lastedArtList[i];
				html += '<li>';
				if(item.doi != undefined && item.doi != null && item.doi != ''){
					html += '<a href="http://dx.doi.org/'+item.doi+'" target="_blank" style="font-size: 8.5pt;text-overflow:ellipsis;overflow: hidden;white-space:nowrap;">'+item.orgLangPprNm+'</a>';
				}else{
					html += '<a href="javascript:popArticle('+item.articleId+');" style="font-size: 8.5pt;text-overflow:ellipsis;overflow: hidden;white-space:nowrap;">'+item.orgLangPprNm+'</a>';
				}
				var date = item.pblcYm
				html += '<span>'+item.authors+' &nbsp; ( '+item.pblcPlcNm+',&nbsp;v.'+item.volume+',&nbsp;no.'+item.issue+',&nbsp;pp.'+item.sttPage+'~'+item.endPage+',&nbsp;<%--<ui:dateformat value="${item.pblcYm}" pattern="yyyy.MM.dd" />--%> )</span>';
				html += '</li>'
			}
			$('.main_list_box ul').append(html);

			$('.wrap-loading').css('display', 'none')
		});
	})
</script>
<style type="text/css">
	.top_summary_wrap{border-top: 2px solid #626262; margin: 0 0;}
</style>
</head>
<body>
<form id="frm" name="frm">
	<input type="hidden" name="gubun" value="<c:out value="${parameter.gubun}"/>"/>
	<input type="hidden" name="hldofYn" value="<c:out value="${parameter.hldofYn}"/>"/>
	<input type="hidden" name="isFulltime" value="<c:out value="${parameter.isFulltime}"/>"/>
	<input type="hidden" name="rownum" value="<c:out value="${parameter.rownum}"/>"/>
	<input type="hidden" name="topNm" value="<c:out value="${parameter.topNm}"/>"/>
	<input type="hidden" name="fromYear" value="<c:out value="${parameter.fromYear}"/>"/>
	<input type="hidden" name="toYear" value="<c:out value="${parameter.toYear}"/>"/>
	<input type="hidden" name="type" value="<c:out value="${parameter.type}"/>"/>
</form>
	<h3><spring:message code="menu.asrms.inst.overview"/></h3>
	<div class="help_text mgb_30"><spring:message code="asrms.institution.overview.desc"/></div>
	<div>
		<div class="top_summary_wrap">
			<div class="top_summary_row">
				<div class="summary_box">
					<div class="sb_inner">
						<span><img src="<c:url value="/images/background/onepage_icon01.png"/>" width="44px" height="auto" alt="Journal Articles"/></span>
						<div class="sb_num">
							<dl>
								<dt>저널논문</dt>
								<dd><fmt:formatNumber value="${rsltCo.artsCo}" groupingUsed="true"/></dd>
							</dl>
						</div>
					</div>
				</div>
				<div class="summary_box">
					<div class="sb_inner">
						<span><img src="<c:url value="/images/background/onepage_icon02.png"/>" width="44px" height="auto" alt="Research Fundings"/></span>
						<div class="sb_num">
							<dl>
								<dt>연구비(연구과제)</dt>
								<dd><fmt:formatNumber value="${rsltCo.fundCo}" groupingUsed="true"/></dd>
							</dl>
						</div>
					</div>
				</div>
				<div class="summary_box">
					<div class="sb_inner">
						<span><img src="<c:url value="/images/background/onepage_icon03.png"/>" width="44px" height="auto" alt="Patents"/></span>
						<div class="sb_num">
							<dl>
								<dt>지식재산(특허)</dt>
								<dd><fmt:formatNumber value="${rsltCo.patentCo}" groupingUsed="true"/></dd>
							</dl>
						</div>
					</div>
				</div>
				<div class="summary_box">
					<div class="sb_inner">
						<span><img src="<c:url value="/images/background/onepage_icon04.png"/>" width="44px" height="auto" alt="Conference"/></span>
						<div class="sb_num">
							<dl>
								<dt>학술활동(학술대회)</dt>
								<dd><fmt:formatNumber value="${rsltCo.confereneceCo}" groupingUsed="true"/></dd>
							</dl>
						</div>
					</div>
				</div>
			</div>
			<em class="faculty_rb"><c:out value="${parameter.fromYear}"/> ~ <c:out value="${parameter.toYear}"/></em>
		</div>

		<div class="faculty_wrap" style="padding: 0 0; margin:0 0; padding-top: 30px;margin-bottom: 42px;">

			<c:set var="assisProCo" value="0"/>
			<c:set var="assocProCo" value="0"/>
			<c:set var="proCo" value="0"/>

			<c:forEach var="faculty" items="${facultyList}">
				<c:if test="${faculty.grade1 eq '조교수'}">
					<c:set var="assisProCo" value="${faculty.cnt}"/>
				</c:if>
				<c:if test="${faculty.grade1 eq '부교수'}">
					<c:set var="assocProCo" value="${faculty.cnt}"/>
				</c:if>
				<c:if test="${faculty.grade1 eq '교수'}">
					<c:set var="proCo" value="${faculty.cnt}"/>
				</c:if>
			</c:forEach>

			<div class="faculty_inner" id="facultyDiv1">
				<div class="faculty_box">
					<div class="faculty_t" style="padding-left: 120px; padding-top: 30px;">
						<p>교원수 <span><fmt:formatNumber value="${assisProCo + assocProCo + proCo}" groupingUsed="true"/></span></p>
					</div>
				</div>
				<div class="professor_wrap">
					<div class="professor_row">
						<div class="professor_box">
							<div class="professor_inner">
								<p>조교수</p>
								<span><fmt:formatNumber value="${assisProCo}" groupingUsed="true"/></span>
							</div>
						</div>
					</div>
					<div class="professor_row">
						<div class="professor_box ap_type">
							<div class="professor_inner">
								<p>부교수</p>
								<span><fmt:formatNumber value="${assocProCo}" groupingUsed="true"/></span>
							</div>
						</div>
					</div>
					<div class="professor_row">
						<div class="professor_box p_type">
							<div class="professor_inner">
								<p>교수</p>
								<span><fmt:formatNumber value="${proCo}" groupingUsed="true"/></span>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div><!-- faculty_wrap : e -->
	</div>

	<div class="main_contents_box mgb_30">
		<div class="left_contents">
			<h3 class="circle_h3"><spring:message code="asrms.inst.overview.artco"/></h3>
			<div class="graph_box">
				<div id="chartdiv1"></div>
			</div>
		</div>
		<div class="right_contents">
			<h3 class="circle_h3"><spring:message code="menu.asrms.inst.latest"/></h3>
			<div class="main_list_box">
				<ul>

				</ul>
			</div>
		</div>
	</div>
	<div class="main_contents_box">
		<div class="left_contents">
			<h3 class="circle_h3"><spring:message code="asrms.inst.overview.avgif"/></h3>
			<div class="graph_box" id="chartdiv2">
			</div>
		</div>
		<div class="right_contents">
			<h3 class="circle_h3"><spring:message code="asrms.inst.overview.cited"/></h3>
			<div class="graph_box" id="chartdiv3">
			</div>
		</div>
	</div>
</body>
</html>
