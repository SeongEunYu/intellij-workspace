<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><spring:message code="menu.asrms.clg.overview"/></title>
<script type="text/javascript">

</script>
<style type="text/css">
	.top_summary_wrap{border-top: 2px solid #626262; margin: 0 0;}
</style>
</head>
<body>

	<form id="frm" name="frm" action="${contextPath}/analysis/college/overview.do" method="post">
	<input type="hidden" name="userId" id="userId" value="${param.userid}"/>
	<input type="hidden" name="clgCd" id="clgCd" value="<c:out value="${clgCd}"/>"/>

	<h3><spring:message code="menu.asrms.clg.overview"/></h3>
	<div class="help_text mgb_30"><spring:message code="asrms.college.overview.desc"/></div>
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
			<h3 class="circle_h3"><spring:message code="menu.asrms.clg.artco"/></h3>
			<a href="javascript:$('#topFrm').attr('action','${pageContext.request.contextPath}/analysis/college/departNoArts.do').submit();" class="more_plus">more</a>
			<div class="graph_box">
				<fc:render chartId="ChartId2" swfFilename="MSLine" width="100%" height="288" debugMode="false" registerWithJS="false"
					dataFormat="xml" xmlData="${pubChartXML}" renderer="javascript" windowMode="transparent" />
			</div>
		</div>
		<div class="right_contents">
			<h3 class="circle_h3"><spring:message code="menu.asrms.clg.latest"/></h3>
			<a href="#" onclick="javascript:$('#topFrm').attr('action','${contextPath}/analysis/college/latestArticles.do').submit();" class="more_plus">more</a>
			<div class="main_list_box">
				<ul>
				<c:if test="${fn:length(lastedArtList) > 0}">
					<c:forEach items="${lastedArtList}" var="item" varStatus="status" begin="0" end="3">
					<li>
						<c:set var="uri" value="${not empty item.doi ? item.doi : '' }"/>
						<c:if test="${not empty uri}">
						<a href="http://dx.doi.org/${uri}" target="_blank" style="font-size: 8.5pt;text-overflow:ellipsis;overflow: hidden;white-space:nowrap;">${item.orgLangPprNm}</a>
						</c:if>
						<c:if test="${empty uri}">
						<a href="javascript:popArticle('${item.articleId}');" style="font-size: 8.5pt;text-overflow:ellipsis;overflow: hidden;white-space:nowrap;">${item.orgLangPprNm}</a>
						</c:if>
						<span>${item.authors } &nbsp; ( ${item.pblcPlcNm},&nbsp;v.${item.volume},&nbsp;no.${item.issue},&nbsp;pp.${item.sttPage}~${item.endPage},&nbsp;<ui:dateformat value="${item.pblcYm}" pattern="yyyy.MM.dd" /> )</span>
					</li>
					</c:forEach>
				</c:if>
				</ul>
			</div>
		</div>
	</div>
	<div class="main_contents_box">
		<div class="left_contents">
			<h3 class="circle_h3"><spring:message code="menu.asrms.clg.avgif"/></h3>
			<a href="javascript:$('#topFrm').attr('action','${pageContext.request.contextPath}/analysis/college/departIF.do').submit();" class="more_plus">more</a>
			<div class="graph_box">
				<fc:render chartId="ChartId1" swfFilename="Column2D" width="100%" height="288" debugMode="false" registerWithJS="false"
					dataFormat="xml" xmlData="${avgrIFChartXML}" renderer="javascript" windowMode="transparent" />
			</div>
		</div>
		<div class="right_contents">
			<h3 class="circle_h3"><spring:message code="menu.asrms.clg.cited"/></h3>
			<a href="javascript:$('#topFrm').attr('action','${pageContext.request.contextPath}/analysis/college/departTimeCited.do').submit();" class="more_plus">more</a>
			<div class="graph_box">
				<fc:render chartId="ChartId4" swfFilename="Column2D" width="100%" height="288" debugMode="false" registerWithJS="false"
					dataFormat="xml" xmlData="${citedChartXML}" renderer="javascript" windowMode="transparent" />
			</div>
		</div>
	</div>
	</form>
</body>
</html>
