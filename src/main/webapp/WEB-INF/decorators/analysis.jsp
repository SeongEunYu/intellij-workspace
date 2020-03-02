<%@page import="kr.co.argonet.r2rims.constant.R2Constant"%>
<%@page import="kr.co.argonet.r2rims.core.vo.UserVo"%>
<%@page import="java.util.Map"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator"%>
<%@ taglib prefix="page" uri="http://www.opensymphony.com/sitemesh/page"%>
<%@ page isELIgnored ="false" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--
<!DOCTYPE html>
-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<title>${sysConf['system.arms.jsp.title']}</title>
<%@ include file="../jsp/pageInit.jsp"%>
<link rel="shortcut icon" href="<c:url value="/images/${sysConf['shortcut.icon']}"/>">
<link href="<c:url value="/css/analysis_${instAbrv}/layout.css"/>" rel="stylesheet"  type="text/css" />
<link type="text/css" href="<c:url value="/js/dhtmlx/skins/${sysConf['dhtmlx.skin']}/dhtmlx.css"/>" rel="stylesheet" />
<script type="text/javascript" src="<c:url value="/js/jquery/jquery-1.11.3.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jquery/jquery-ui.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jquery/jquery.modal.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jquery/jquery.word-break-keep-all.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/script.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/chart/fusioncharts.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/chart/fusioncharts-jquery-plugin.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/chart/opts/fusioncharts.opts.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/dhtmlx/dhtmlx.js"/>"></script>
<style type="text/css" >
</style>
<%
	String isResearcher = (String)session.getAttribute("is_researcher");
	String isDepartment = (String)session.getAttribute("is_department");
	String isCollege = (String)session.getAttribute("is_college");
	String isInstitution = (String)session.getAttribute("is_institution");
	String isTrack = (String)session.getAttribute("is_track");
	String photoUrl = (String)session.getAttribute("photo_url");
	String aslang = (String)session.getAttribute("aslang");
	int bg_size = 385;

	Object userKey = session.getAttribute("user_key");
	Object deptKey = session.getAttribute("dept_key");
	Object collegeKey = session.getAttribute("college_key");
	Object trackKey = session.getAttribute("track_key");

	userKey = (userKey == null ? "" : userKey);
	deptKey = (deptKey == null ? "" : deptKey);
	collegeKey = (collegeKey == null ? "" : collegeKey);
	UserVo user = (UserVo)request.getSession().getAttribute("ASRIMS_USER");
	//Map user = (Map) request.getSession().getAttribute(AuthenticationController.SESSIONKEY_USER);
%>

<script type="text/javascript">

	$(function() {
		$('.sideToggle').click(function (e) {
			e.preventDefault();

			$(".sideToggle").removeClass('show');
			var $this = $(this);
			$this.addClass('show');

			if ($this.next().hasClass('on')) {
				$(".sideToggle").removeClass('show');
				$this.next().removeClass('on');
				$this.next().slideUp(350);
			} else {
				$this.parent().parent().find('li .nav_sub').removeClass('on');
				$this.parent().parent().find('li .nav_sub').slideUp(350);
				$this.next().toggleClass('on');
				$this.next().slideToggle(350);
			}
		});

		$(".lnb ul li .nav_sub li a.on").parent().parent().parent().find(".sideToggle").click();
	});

	function makeHeight() {
		var outmain = document.getElementById("bg_main_content");
		outmain.style.height = "612px";
		var inmain = document.getElementById("main_content");
		if (outmain.offsetHeight < inmain.offsetHeight) outmain.style.height=inmain.offsetHeight+"px";
	}
	function moveResearchSearch(){
		var searcherWindow =  window.open( "${pageContext.request.contextPath}/analysis/researcherSearchPopup.do?mode="+$('#topFrm > input[name="mode"]').val(),
			"searchWindow", "top=150, left=500, height=242, width=360, location=no, resizable=no, menubar=no");
		searcherWindow.focus();
	}
	function moveGroupSearch(gubun){
		var searcherWindow =  window.open( "${pageContext.request.contextPath}/analysis/groupSearchPopup.do?gubun="+gubun,
			"searchWindow", "top=150, left=500, height=400, width=310, location=no, resizable=no, menubar=no");
		searcherWindow.focus();
	}
	function selectMenu(id) {
		$(".coll_menu").css("font-weight", "");
		document.getElementById("coll_" + id).style.fontWeight = "bold";
	}
	function popArticle(articleId) {
		var mappingPopup = window.open('about:blank', 'articleInfo', 'height=752px,width=1050px,location=no,scrollbars=yes');
		var popFrm = $('#popFrm');
		popFrm.empty();
		popFrm.append($('<input type="hidden" name="articleId" value="'+articleId+'"/>'));
		popFrm.attr('action', '${contextPath}/article/viewPopup.do');
		popFrm.attr('target', 'articleInfo');
		popFrm.attr('method', 'POST');
		popFrm.submit();
		mappingPopup.focus();
	}
	function changeLang(form){
		var lang = 'KOR';
		if($('#aslang').val() == 'KOR') lang = 'ENG';
		else if($('#aslang').val() == 'ENG') lang = 'KOR';
		$.ajax({
			url : "${pageContext.request.contextPath}/analysis/langChangeAjax.do",
			dataType : 'text',
			data : { "aslang": lang  },
			success : function(data, textStatus, jqXHR){
				//alert($(form).find('input[name="lang"]').val());
				$(form).find('input[name="aslang"]').val(data);
				//alert($(form).find('input[name="aslang"]').val());
				$(form).submit();
			}
		}).done(function(){});

	}
	function popupUser(){
		//논문건수가 없는 교수는 open하지 않음
		if($('#researcher').val() != ''){
			//window.open("${pageContext.request.contextPath}/analysis/researcher/overview.do?srchUserId="+$('#researcher').val()+'&mode=onlyview', "researcher");
			var action = "${pageContext.request.contextPath}/analysis/researcher/overview.do?srchUserId="+$('#researcher').val()+'&mode=onlyview';
			var popupUser = window.open('','popupUser','height=932px,width=1024px,resizable=yes,location=no,scrollbars=yes');
			var popFrm = $('#popFrm');
			popFrm.empty();
			//popFrm.append($('<input type="hidden" name="maskYear" value="'+$('#maskYear').val()+'"/>'));
			//popFrm.append($('<input type="hidden" name="maskCateg" value="'+$('#maskCateg').val()+'"/>'));
			//popFrm.append($('<input type="hidden" name="maskRatio" value="'+per+'"/>'));
			popFrm.attr('action', action);
			popFrm.attr('target', "popupUser");
			popFrm.attr('method', "post");
			popFrm.submit();
		}
	}
	function changeImage(form, changeSrc) {
		form.src= changeSrc;
	}
	function exportLog(form, filename){
		var param = getFormData(form);
		param["filename"] = filename;
		param["exportPage"] = document.location.href;
		$.ajax({
			url : "${pageContext.request.contextPath}/analysis/exportLogAjax.do",
			dataType : 'json',
			async : false,
			data : param,
			success : function(data, textStatus, jqXHR){
			}
		}).done(function(){});
	}

	var myGrid;
	$(document).ready(function(){
		$('.breakKeepAll').wordBreakKeepAll();
		$('.yu_as_rims_wrap .container > br').remove();
		bindModalLink();

		myGrid = new dhtmlXGridObject('exportGrid');
		myGrid.setImagePath("${dhtmlXImagePath}");
		myGrid.enableColSpan(true);
		myGrid.init();

		$('.yu_as_rims_wrap').css('height',$(window).height()+'px').css('overflow-y','auto');

		if (window.attachEvent)  window.attachEvent("onresize",resizeWin);
		else  window.addEventListener("resize",resizeWin, false);

	});
	function resizeWin(){ $('.yu_as_rims_wrap').css('height',$(window).height()+'px');}

	if (!('remove' in Element.prototype)) {
		Element.prototype.remove = function() {
			if (this.parentNode) {
				this.parentNode.removeChild(this);
			}
		};
	}
</script>
<decorator:head />
</head>
<body>
<div id="modal_area" class="overlay" style="display: none;"></div>
<form id="topFrm" name="topFrm" method="post" action="<c:url value="/analysis/home/overview.do"/>" >
	<input type="hidden" id="topNm" name="topNm" value="<c:out value="${topNm}"/>"/>
	<input type="hidden" id="userId" name="userId" value="<%=userKey%>"/>
	<input type="hidden" id="deptKor" name="deptKor" value="<%=deptKey%>"/>
	<input type="hidden" id="clgCd" name="clgCd" value="<%=collegeKey%>"/>
	<input type="hidden" id="trackId" name="trackId" value="<%=trackKey%>"/>
	<input type="hidden" id="aslang" name="aslang" value="<%=aslang%>"/>
	<input type="hidden" id="mode" name="mode" value="<c:out value="${parameter.mode}"/>"/>
	<input type="hidden" id="srchUserId" name="srchUserId" value="<c:out value="${parameter.srchUserId}"/>"/>
	<input type="hidden" id="srchUserPhotoUrl" name="srchUserPhotoUrl" value="<c:out value="${parameter.srchUserPhotoUrl}"/>"/>
</form>
<c:set var="aslang" value="<%=aslang%>"/>

<div class="header_wrap">
	<div class="header_box">
		<h1><a href="#">${sysConf['system.arms.jsp.title']}</a></h1>
		<div class="nav_box">
			<ul>
				<c:set var="instfl" value=""/><c:set var="clgfl" value=""/><c:set var="deptfl" value=""/><c:set var="rschfl" value=""/><c:set var="homefl" value=""/>
				<c:if test="${not empty sessionScope.is_institution and sessionScope.is_institution eq 'Y'}">
					<%--<c:set var="instfl" value="first_li"/>--%>
					<li>
						<c:choose>
							<c:when test="${sessionScope.auth.adminDvsCd eq 'M' or sessionScope.auth.adminDvsCd eq 'V' or sessionScope.auth.adminDvsCd eq 'P'}">
								<a class="${instfl} <c:if test="${topNm eq 'institution' }">on</c:if>" href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/institution/overview.do"/>').submit();"><spring:message code="menu.asrms.inst"/></a>
							</c:when>
							<c:otherwise></c:otherwise>
						</c:choose>
					</li>
				</c:if>

				<c:if test="${not empty sessionScope.is_college and sessionScope.is_college eq 'Y'}">
					<%--<c:if test="${empty instfl}"><c:set var="clgfl" value="first_li"/></c:if>--%>
					<li>
						<c:choose>
							<c:when test="${sessionScope.auth.adminDvsCd eq 'M' or sessionScope.auth.adminDvsCd eq 'V' or sessionScope.auth.adminDvsCd eq 'P'}">
								<a class="${clgfl} <c:if test="${topNm eq 'college' }">on</c:if>" href="#" onclick="javascript:moveGroupSearch('C');">College</a>
							</c:when>
							<c:otherwise>
								<a class="<c:if test="${topNm eq 'college' }">on</c:if>" href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/college/overview.do"/>').submit();"><spring:message code="menu.asrms.clg"/></a>
							</c:otherwise>
						</c:choose>
					</li>
				</c:if>
				<c:if test="${( not empty sessionScope.is_department and sessionScope.is_department eq 'Y' ) or ( sessionScope.is_track != null and sessionScope.is_track eq 'Y' ) }">
					<%--<c:if test="${empty instfl and empty clgfl}"><c:set var="deptfl" value="first_li"/></c:if>--%>
					<li>
						<c:choose>
							<c:when test="${sessionScope.auth.adminDvsCd eq 'M' or  sessionScope.auth.adminDvsCd eq 'C' or sessionScope.auth.adminDvsCd eq 'V' or sessionScope.auth.adminDvsCd eq 'P'}">
								<c:set var="p"  value="D" /><c:if test="${sessionScope.auth.adminDvsCd eq 'M'}"><c:set var="p"  value="DT" /></c:if>
								<a class="${deptfl} <c:if test="${topNm eq 'department' }">on</c:if>" href="#" onclick="javascript:moveGroupSearch('${p}');">Department</a>
							</c:when>
							<c:otherwise>
								<a class="${deptfl} <c:if test="${topNm eq 'department'}">on</c:if>" href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/department/overview.do"/>').submit();"><spring:message code="menu.asrms.dept"/></a>
							</c:otherwise>
						</c:choose>
					</li>
				</c:if>
				<c:if test="${not empty sessionScope.is_researcher and sessionScope.is_researcher eq 'Y'}">
					<%--<c:if test="${empty instfl and empty clgfl and empty deptfl}"><c:set var="rschfl" value="first_li"/></c:if>--%>
					<li>
						<c:choose>
							<c:when test="${sessionScope.auth.adminDvsCd eq 'M' or  sessionScope.auth.adminDvsCd eq 'C' or sessionScope.auth.adminDvsCd eq 'D' or sessionScope.auth.adminDvsCd eq 'V' or sessionScope.auth.adminDvsCd eq 'P' or sessionScope.auth.adminDvsCd eq 'T'}">
								<a class="${rschfl} <c:if test="${topNm eq 'researcher' }">on</c:if>" href="#"  onclick="javascript:moveResearchSearch();">Researcher</a>
								<%--
                                <a class="modalLink ${rschfl} <c:if test="${topNm eq 'researcher' }">on</c:if>" href="#searchResearcherDialog" >Researcher</a>
                                 --%>
							</c:when>
							<c:otherwise>
								<a class="${rschfl} <c:if test="${topNm eq 'researcher' }">on</c:if>" href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/researcher/overview.do"/>').submit();"><spring:message code="menu.asrms.rsch"/></a>
							</c:otherwise>
						</c:choose>
					</li>
				</c:if>
				<%--
                <c:if test="${empty instfl and empty clgfl and empty deptfl and empty rschfl}"><c:set var="homefl" value="first_li"/></c:if>
                <li><a class="${homefl}" href="#" onclick="javascript:$('#topFrm').attr('action','${pageContext.request.contextPath}/analysis/home/overview.do').submit();"><spring:message code="menu.asrms.about"/></a></li>
                 --%>
			</ul>
		</div>
	</div>
</div>

<div class="shadow_box">
	<div class="contenst_wrap">
		<!-- ajax loading -->
		<%--<div class="wrap-loading" style="margin: 0px 0px 0 245px;display: none;">
			<div><img src='${pageContext.request.contextPath}/images/analysis/common/ajax-loader.gif' /></div>
		</div>--%>
		<div class="loading_box wrap-loading" style="display: none;">
			<span style="padding-bottom: 10px;">Loading...</span><br/>
			<em><img src='${pageContext.request.contextPath}/images/analysis/common/ajax-loader.gif' /></em>
		</div>
		<div class="lnb"> <!-- lnb : 왼쪽 메뉴 -->
			<c:if test="${topNm eq 'home'}">
				<div class="lnb_title">
					<h2><spring:message code="menu.asrms.about"/></h2>
				</div> <%-- lnb_title : end--%>
				<ul>
					<li><a class="left_menu01 <c:if test="${leftNm eq 'overview'}">on</c:if>" href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/home/overview.do"/>').submit();"><span></span><spring:message code="menu.asrms.about.overview"/></a></li>
					<c:if test="${r2Conf['usr.arms.about.latest'] eq '4' }">
						<li><a class="left_menu02 <c:if test="${leftNm eq 'latestArticles'}">on</c:if>" href="#" onclick="javascript:$('#topFrm').attr('action','${pageContext.request.contextPath}/analysis/home/latestArticles.do').submit();"><span></span><spring:message code="menu.asrms.about.latest"/></a></li>
					</c:if>
					<!-- pblication -->
					<c:if test="${r2Conf['usr.arms.about.trend'] eq '4' }">
						<li><a class="left_menu03 <c:if test="${leftNm eq 'publicationSCI' }">on</c:if>" href="#" onclick="javascript:$('#topFrm').attr('action','${pageContext.request.contextPath}/analysis/home/publicationSCI.do').submit();"><span></span><spring:message code="menu.asrms.about.trend"/></a></li>
					</c:if>
					<!-- subject -->
					<c:if test="${r2Conf['usr.arms.about.sbjt'] eq '4' }">
						<li><a class="left_menu04 <c:if test="${leftNm eq 'deptTrendSubject' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','${pageContext.request.contextPath}/analysis/home/deptTrendSubject.do').submit();"><span></span><spring:message code="menu.asrms.about.sbuject"/></a></li>
					</c:if>
					<!-- h-index -->
					<c:if test="${r2Conf['usr.arms.about.ifcat'] eq '4' }">
						<li><a class="left_menu05 <c:if test="${leftNm eq 'jcrRankingByCategory' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','${pageContext.request.contextPath}/analysis/home/jcrRankingByCategory.do').submit();"><span></span><spring:message code="menu.asrms.about.ranking"/></a></li>
					</c:if>
					<!-- cited vs uncited -->
					<c:if test="${r2Conf['usr.arms.about.ifdept'] eq '4' }">
						<li><a class="left_menu06 <c:if test="${leftNm eq 'subjectDepartJcrRanking' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','${pageContext.request.contextPath}/analysis/home/subjectDepartJcrRanking.do').submit();"><span></span>IF Ranking by Dept</a></li>
					</c:if>
					<!-- coauthor network -->
					<c:if test="${r2Conf['usr.arms.about.journal'] eq '4' }">
						<li><a class="left_menu07 <c:if test="${leftNm eq 'deptJournal' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','${pageContext.request.contextPath}/analysis/home/deptJournal.do').submit();"><span></span><spring:message code="menu.asrms.about.journal"/></a></li>
					</c:if>
					<!-- similar expert -->
					<c:if test="${r2Conf['usr.arms.about.coauthor'] eq '4' }">
						<li><a class="left_menu08 <c:if test="${leftNm eq 'deptCoAuthor' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','${pageContext.request.contextPath}/analysis/home/deptCoAuthor.do').submit();"><span></span><spring:message code="menu.asrms.about.coauthor"/></a></li>
					</c:if>
					<!-- 자료실 sci journal list -->
					<c:if test="${r2Conf['usr.arms.about.sci'] eq '4' }">
						<li><a class="left_menu09 <c:if test="${leftNm eq 'dataSciJournalList' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','${pageContext.request.contextPath}/analysis/home/dataSciJournalList.do').submit();"><span></span>SCI Journal List</a></li>
					</c:if>
					<!-- 자료실 jcr journal subject list -->
					<c:if test="${r2Conf['usr.arms.about.if'] eq '4' }">
						<li><a class="left_menu10 <c:if test="${leftNm eq 'dataJcrJournalSubjectList' }">on</c:if>" href="#" onclick="javascript:$('#topFrm').attr('action','${pageContext.request.contextPath}/analysis/home/dataJcrJournalSubjectList.do').submit();"><span></span>Journal IF List</a></li>
					</c:if>
					<!-- 자료실 일반-->
					<c:if test="${r2Conf['usr.arms.about.resourc'] eq '4' }">
						<li><a class="left_menu11 <c:if test="${leftNm eq 'dataGeneralList' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','${pageContext.request.contextPath}/analysis/home/dataGeneralList.do').submit();"><span></span>Resources</a></li>
					</c:if>
					<c:if test="${sessionScope.auth.adminDvsCd eq 'M' and r2Conf['usr.arms.about.search_link'] eq '4' }">
						<li>
							<a href="javascript:void(0);" onclick="javascript:moveSolution('${sysConf['system.srch.uri']}', 'SEARCH');" style="font-size: 18px;color: #aacff8;padding: 15px 0 0px 28px;font-family: Malgun Gothic,맑은 고딕, Verdana,Arial, '돋움', Dotum;font-weight: normal;height: 35px;">${sysConf['system.srch.name']}</a>
						</li>
					</c:if>
					<c:if test="${sessionScope.auth.adminDvsCd eq 'M' and r2Conf['usr.arms.about.ugas_link'] eq '4' }">
						<li><a style="font-size: 18px;color: #aacff8;padding: 15px 0 0px 28px;font-family: Malgun Gothic,맑은 고딕, Verdana,Arial, '돋움', Dotum;font-weight: normal;height: 35px;" href="${sysConf['system.ugas.uri']}" target="_blank">${sysConf['system.ugas.name']}</a></li>
					</c:if>
					<c:if test="${r2Conf['usr.arms.about.repo_link'] eq '4' }">
						<li><a style="font-size: 20px;color: #aacff8;padding: 15px 0 0px 28px;font-family: Calibri;font-weight: normal;height: 35px;" href="http://ir.yu.ac.kr" target="_blank">${instAbrv}-Repository</a></li>
					</c:if>
				</ul>
			</c:if>
			<c:if test="${topNm eq 'researcher'}">
				<div class="lnb_title">
					<h2 class="researcher_text"><spring:message code="menu.asrms.rsch"/></h2>
				</div>
				<ul>
					<c:if test="${r2Conf['usr.arms.rschr.onePageReport'] eq '4' }">
						<li>
							<a href="javascript:void(0);" class="sideToggle"><span>Performance Summary</span></a>
							<ul class="nav_sub">
								<!-- profile -->
								<c:if test="${r2Conf['usr.arms.rschr.overview'] eq '4' }">
									<li><a class="left_menu01 <c:if test="${leftNm eq 'overview' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/researcher/overview.do"/>').submit();"><span></span><spring:message code="menu.asrms.rsch.overview"/></a></li>
								</c:if>
								<c:if test="${r2Conf['usr.arms.rschr.profile'] eq '4' }">
									<li><a class="left_menu13 <c:if test="${leftNm eq 'profile' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/researcher/profile.do"/>').submit();"><span></span><spring:message code="menu.asrms.rsch.profile"/></a></li>
								</c:if>
								<c:if test="${r2Conf['usr.arms.rschr.onePageReport'] eq '4' }">
									<li><a class="left_menu07 <c:if test="${leftNm eq 'onePageReport' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/researcher/onePageReport.do"/>').submit();"><span></span><spring:message code="menu.asrms.rsch.onePageReport"/></a></li>
								</c:if>
							</ul>
						</li>
					</c:if>
					<li>
						<a href="javascript:void(0);" class="sideToggle"><span>Journal</span></a>
						<ul class="nav_sub">
							<!-- publication -->
							<c:if test="${r2Conf['usr.arms.rschr.publication'] eq '4' }">
								<li><a class="left_menu18 <c:if test="${leftNm eq 'publication' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/researcher/publication.do"/>').submit();"><span></span><spring:message code="menu.asrms.rsch.artco"/></a></li>
							</c:if>
							<!-- h-index -->
							<c:if test="${r2Conf['usr.arms.rschr.hindex'] eq '4' }">
								<li><a class="left_menu20 <c:if test="${leftNm eq 'h-index' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/researcher/h-index.do"/>').submit();"><span></span><spring:message code="menu.asrms.rsch.hindex"/></a></li>
							</c:if>
							<!-- cited vs uncited -->
							<c:if test="${r2Conf['usr.arms.rschr.cited'] eq '4' }">
								<li><a class="left_menu05 <c:if test="${leftNm eq 'trend' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/researcher/trend.do"/>').submit();"><span></span><spring:message code="menu.asrms.rsch.cited"/></a></li>
							</c:if>
							<!-- coauthor network -->
							<c:if test="${r2Conf['usr.arms.rschr.coauthor'] eq '4' }">
								<li><a class="left_menu16 <c:if test="${leftNm eq 'coauthor' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/researcher/coauthor.do"/>').submit();"><span></span><spring:message code="menu.asrms.rsch.coauthor"/></a></li>
							</c:if>
							<!-- similar expert -->
							<c:if test="${r2Conf['usr.arms.rschr.similar'] eq '4' }">
								<li><a class="left_menu04 <c:if test="${leftNm eq 'similar' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/researcher/similar.do"/>').submit();"><span></span><spring:message code="menu.asrms.rsch.similar"/></a></li>
							</c:if>
							<!-- journal -->
							<c:if test="${r2Conf['usr.arms.rschr.journal'] eq '4' }">
								<li><a class="left_menu22 <c:if test="${leftNm eq 'journals' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/researcher/journals.do"/>').submit();"><span></span><spring:message code="menu.asrms.rsch.journal"/></a></li>
							</c:if>
						</ul>
					</li>
					<c:if test="${r2Conf['usr.arms.rschr.patent'] eq '4' }">
						<li>
							<a href="javascript:void(0);" class="sideToggle"><span>Patent</span></a>
							<ul class="nav_sub">
								<!-- patent -->
								<c:if test="${r2Conf['usr.arms.rschr.patent'] eq '4' }">
									<li><a class="left_menu03 <c:if test="${leftNm eq 'patentTrend' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/researcher/patentTrend.do"/>').submit();"><span></span><spring:message code="menu.asrms.rsch.patent"/></a></li>
								</c:if>
								<c:if test="${r2Conf['usr.arms.rschr.patentNation'] eq '4' }">
									<li><a class="left_menu03 <c:if test="${leftNm eq 'patentByNation' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/researcher/patentByNation.do"/>').submit();"><span></span><spring:message code="menu.asrms.rsch.patentNation"/></a></li>
								</c:if>
								<!-- techtrans -->
								<c:if test="${r2Conf['usr.arms.rschr.techtrans'] eq '4' }">
									<li><a class="left_menu07 <c:if test="${leftNm eq 'tcntrns' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/researcher/tcntrns.do"/>').submit();"><span></span><spring:message code="menu.asrms.rsch.techtrans"/></a></li>
								</c:if>
							</ul>
						</li>
					</c:if>
				</ul>
			</c:if>
			<c:if test="${ (topNm eq 'department') and ( (empty mode) or (mode ne 'onlyview')) }">
				<div class="lnb_title">
					<h2 class="department_text"><spring:message code="menu.asrms.dept"/></h2>
				</div>
				<ul>
					<c:if test="${r2Conf['usr.arms.dept.onePageReport'] eq '4' }">
						<li>
							<a href="javascript:void(0);" class="sideToggle"><span>성과종합</span></a>
							<ul class="nav_sub">
								<c:if test="${r2Conf['usr.arms.dept.overview'] eq '4' }">
									<li><a class="left_menu01 <c:if test="${leftNm eq 'overview' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/department/overview.do"/>').submit();"><span></span><spring:message code="menu.asrms.dept.overview"/></a></li>
								</c:if>
								<c:if test="${r2Conf['usr.arms.dept.onePageReport'] eq '4' }">
									<li><a class="left_menu07 <c:if test="${leftNm eq 'onePageReport' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/department/onePageReport.do"/>').submit();"><span></span><spring:message code="menu.asrms.dept.onePageReport"/></a></li>
								</c:if>
							</ul>
						</li>
					</c:if>
					<li>
						<a href="javascript:void(0);" class="sideToggle"><span>저널논문</span></a>
						<ul class="nav_sub">
							<!-- Latest Articles -->
							<c:if test="${r2Conf['usr.arms.dept.latest'] eq '4' }">
								<li><a class="left_menu02 <c:if test="${leftNm eq 'latestArticles' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/department/latestArticles.do"/>').submit();"><span></span><spring:message code="menu.asrms.dept.latest"/></a></li>
							</c:if>
							<%if(isTrack == null || !"Y".equals(isTrack) ){ %>
							<c:if test="${r2Conf['usr.arms.dept.codept'] eq '4' }">
								<li><a class="left_menu16 <c:if test="${leftNm eq 'coAuthor' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/department/coAuthor.do"/>').submit();"><span></span>학과간 네트워크</a></li>
							</c:if>
							<%} %>
							<c:if test="${r2Conf['usr.arms.dept.corschr'] eq '4' }">
								<li><a class="left_menu17 <c:if test="${leftNm eq 'coAuthorWithinSameDepartment' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/department/coAuthorWithinSameDepartment.do"/>').submit();"><span></span><%if(isTrack != null && "Y".equals(isTrack) ){ %>Track<%}else{%>학과<%}%>내 네트워크</a></li>
							</c:if>
							<c:if test="${r2Conf['usr.arms.dept.publication'] eq '4' }">
								<li><a class="left_menu18 <c:if test="${leftNm eq 'trendNoArts' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/department/trendNoArts.do"/>').submit();"><span></span><spring:message code="menu.asrms.dept.artco"/></a></li>
							</c:if>
							<c:if test="${r2Conf['usr.arms.dept.impact'] eq '4' }">
								<li><a class="left_menu19 <c:if test="${leftNm eq 'trendIF' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/department/trendIF.do"/>').submit();"><span></span><spring:message code="menu.asrms.dept.avgif"/></a></li>
							</c:if>
							<c:if test="${r2Conf['usr.arms.dept.cited'] eq '4' }">
								<li><a class="left_menu05 <c:if test="${leftNm eq 'citation' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/department/citation.do"/>').submit();"><span></span><spring:message code="menu.asrms.dept.cited"/></a></li>
							</c:if>
							<c:if test="${r2Conf['usr.arms.dept.hindex'] eq '4' }">
								<li><a class="left_menu20 <c:if test="${leftNm eq 'h-index' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/department/h-index.do"/>').submit();"><span></span><spring:message code="menu.asrms.dept.hindex"/></a></li>
							</c:if>
							<c:if test="${r2Conf['usr.arms.dept.subject'] eq '4' }">
								<li><a class="left_menu21 <c:if test="${leftNm eq 'subject' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/department/subject.do"/>').submit();"><span></span><spring:message code="menu.asrms.dept.sbuject"/></a></li>
							</c:if>
							<c:if test="${r2Conf['usr.arms.dept.journal'] eq '4' }">
								<li><a class="left_menu22 <c:if test="${leftNm eq 'journal' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/department/journal.do"/>').submit();"><span></span><spring:message code="menu.asrms.dept.journal"/></a></li>
							</c:if>
							<%if(isTrack == null || !"Y".equals(isTrack) ){ %>
							<c:if test="${r2Conf['usr.arms.dept.fullPub'] eq '4' }">
								<li><a class="left_menu <c:if test="${leftNm eq 'fulltimeArticle' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/department/fulltimeArticle.do"/>').submit();"><span></span><spring:message code="menu.asrms.dept.fulltimeArticle"/></a></li>
							</c:if>
							<c:if test="${r2Conf['usr.arms.dept.fullSci'] eq '4' }">
								<li><a class="left_menu <c:if test="${leftNm eq 'fulltimeSci' }">on</c:if>" href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/department/fulltimeSci.do"/>').submit();"><span></span><spring:message code="menu.asrms.dept.fulltimeSci"/></a></li>
							</c:if>
							<%--<c:if test="${deptKor ne '인문사회과학과'}">
								<c:if test="${r2Conf['usr.arms.dept.difUnivIF'] eq '4' }">
									<li><a class="left_menu <c:if test="${leftNm eq 'difUnivCompareIF' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/department/difUnivCompareIF.do"/>').submit();"><span></span>미국대학 vs KAIST (JIF)</a></li>
								</c:if>
								<c:if test="${r2Conf['usr.arms.dept.difUnivTC'] eq '4' }">
									<li><a class="left_menu <c:if test="${leftNm eq 'difUnivCompareTC' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/department/difUnivCompareTC.do"/>').submit();"><span></span>미국대학 vs KAIST (TC)</a></li>
								</c:if>
							</c:if>--%>
							<c:if test="${r2Conf['usr.arms.dept.oaArticleByYear'] eq '4' }">
								<li><a class="left_menu <c:if test="${leftNm eq 'oaArticleByYear' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/department/oaArticleByYear.do"/>').submit();"><span></span><spring:message code="menu.asrms.dept.oaByYear"/></a></li>
							</c:if>

							<%} %>
						</ul>
					</li>
					<c:if test="${r2Conf['usr.arms.dept.fundingByDvs'] eq '4' }">
						<li>
							<a href="javascript:void(0);" class="sideToggle"><span>연구과제</span></a>
							<ul class="nav_sub">
								<!-- 2010-10-20 우완기 추가 funding-->
								<c:if test="${r2Conf['usr.arms.dept.fundingByDvs'] eq '4' }">
									<li><a class="left_menu <c:if test="${leftNm eq 'fundingByDvs' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/department/fundingByDvs.do"/>').submit();"><span></span><spring:message code="menu.asrms.dept.fundingByDvs"/></a></li>
								</c:if>
								<c:if test="${r2Conf['usr.arms.dept.fundingByGov'] eq '4' }">
									<li><a class="left_menu <c:if test="${leftNm eq 'fundingByGov' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/department/fundingByGov.do"/>').submit();"><span></span><spring:message code="menu.asrms.dept.fundingByGov"/></a></li>
								</c:if>
								<c:if test="${r2Conf['usr.arms.dept.fundingByResearchers'] eq '4' }">
									<li><a class="left_menu <c:if test="${leftNm eq 'fundingByResearchers' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/department/fundingByResearchers.do"/>').submit();"><span></span><spring:message code="menu.asrms.dept.fundingByResearchers"/></a></li>
								</c:if>
								<c:if test="${r2Conf['usr.arms.dept.funding'] eq '4' }">
									<li><a class="left_menu <c:if test="${leftNm eq 'funding' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/department/funding.do"/>').submit();"><span></span><spring:message code="menu.asrms.dept.funding"/></a></li>
								</c:if>
								<c:if test="${r2Conf['usr.arms.dept.fulltimeFunding'] eq '4' }">
									<li><a class="left_menu <c:if test="${leftNm eq 'fulltimeFunding' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/department/fulltimeFunding.do"/>').submit();"><span></span><spring:message code="menu.asrms.dept.fulltimeFunding"/></a></li>
								</c:if>
							</ul>
						</li>
					</c:if>
					<c:if test="${r2Conf['usr.arms.dept.patentByAcqs'] eq '4' }">
						<li>
							<a href="javascript:void(0);" class="sideToggle"><span>지식재산</span></a>
							<ul class="nav_sub">
								<!--우완기 추가 patent -->
								<c:if test="${r2Conf['usr.arms.dept.patentByAcqs'] eq '4' }">
									<li><a class="left_menu <c:if test="${leftNm eq 'patentByAcqs' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/department/patentByAcqs.do"/>').submit();"><span></span><spring:message code="menu.asrms.dept.patentByAcqs"/></a></li>
								</c:if>
								<c:if test="${r2Conf['usr.arms.dept.patentTrend'] eq '4' }">
									<li><a class="left_menu <c:if test="${leftNm eq 'patentTrend' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/department/patentTrend.do"/>').submit();"><span></span><spring:message code="menu.asrms.dept.patentTrend"/></a></li>
								</c:if>
								<c:if test="${r2Conf['usr.arms.dept.patentByNation'] eq '4' }">
									<li><a class="left_menu <c:if test="${leftNm eq 'patentByNation' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/department/patentByNation.do"/>').submit();"><span></span><spring:message code="menu.asrms.dept.patentByNation"/></a></li>
								</c:if>
								<%--<c:if test="${r2Conf['usr.arms.dept.patentByIPC'] eq '4' }">
									<li><a class="left_menu <c:if test="${leftNm eq 'patentByIPC' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/department/patentByIPC.do"/>').submit();"><span></span><spring:message code="menu.asrms.dept.patentByIPC"/></a></li>
								</c:if>--%>
								<c:if test="${r2Conf['usr.arms.dept.patent'] eq '4' }">
									<li><a class="left_menu03 <c:if test="${leftNm eq 'trendNoPats' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/department/trendNoPats.do"/>').submit();"><span></span><spring:message code="menu.asrms.dept.patentByResearchers"/></a></li>
								</c:if>
								<c:if test="${r2Conf['usr.arms.dept.patentByResearchers'] eq '4' }">
									<li><a class="left_menu <c:if test="${leftNm eq 'patentByResearchers' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/department/patentByResearchers.do"/>').submit();"><span></span><spring:message code="menu.asrms.dept.patentByResearchers2"/></a></li>
								</c:if>
								<!-- techtrans -->
								<c:if test="${r2Conf['usr.arms.dept.techtrans'] eq '4' }">
									<li><a class="left_menu07 <c:if test="${leftNm eq 'tcntrns' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/department/tcntrns.do"/>').submit();"><span></span><spring:message code="menu.asrms.dept.techtrans"/></a></li>
								</c:if>
							</ul>
						</li>
					</c:if>
				</ul>
			</c:if>
			<c:if test="${topNm eq 'college'}">
				<div class="lnb_title">
					<h2 class="college_text"><spring:message code="menu.asrms.clg"/></h2>
				</div>
				<ul>
					<li>
						<a href="javascript:void(0);" class="sideToggle"><span>성과종합</span></a>
						<ul class="nav_sub">
							<c:if test="${r2Conf['usr.arms.clg.overview'] eq '4' }">
								<li><a class="left_menu01 <c:if test="${leftNm eq 'overview' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/college/overview.do"/>').submit();"><span></span><spring:message code="menu.asrms.clg.overview"/></a></li>
							</c:if>
						</ul>
					</li>
					<li>
						<a href="javascript:void(0);" class="sideToggle"><span>저널논문</span></a>
						<ul class="nav_sub">
							<!-- Latest Articles -->
							<c:if test="${r2Conf['usr.arms.clg.latest'] eq '4' }">
								<li><a class="left_menu02 <c:if test="${leftNm eq 'latestArticles' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/college/latestArticles.do"/>').submit();"><span></span><spring:message code="menu.asrms.clg.latest"/></a></li>
							</c:if>
							<c:if test="${r2Conf['usr.arms.clg.hindexBy'] eq '4' }">
								<li><a class="left_menu20 <c:if test="${leftNm eq 'publicationByHindex' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/college/publicationByHindex.do"/>').submit();"><span></span><spring:message code="menu.asrms.clg.hindex"/></a></li>
							</c:if>
							<c:if test="${r2Conf['usr.arms.clg.publication'] eq '4' }">
								<li><a class="left_menu18 <c:if test="${leftNm eq 'departNoArts' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/college/departNoArts.do"/>').submit();"><span></span><spring:message code="menu.asrms.clg.artco"/></a></li>
							</c:if>
							<c:if test="${r2Conf['usr.arms.clg.impact'] eq '4' }">
								<li><a class="left_menu19 <c:if test="${leftNm eq 'departIF' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/college/departIF.do"/>').submit();"><span></span><spring:message code="menu.asrms.clg.avgif"/></a></li>
							</c:if>
							<c:if test="${r2Conf['usr.arms.clg.cited'] eq '4' }">
								<li><a class="left_menu05 <c:if test="${leftNm eq 'departTimeCited' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/college/departTimeCited.do"/>').submit();"><span></span><spring:message code="menu.asrms.clg.cited"/></a></li>
							</c:if>
							<c:if test="${r2Conf['usr.arms.clg.coauthor'] eq '4' }">
								<li><a class="left_menu17 <c:if test="${leftNm eq 'departCoAuthor' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/college/departCoAuthor.do"/>').submit();"><span></span><spring:message code="menu.asrms.clg.coauthor"/></a></li>
							</c:if>
							<c:if test="${r2Conf['usr.arms.clg.fullRslt'] eq '4' }">
								<li><a class="left_menu <c:if test="${leftNm eq 'fulltimeStats' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/college/fulltimeStats.do"/>').submit();"><span></span><spring:message code="menu.asrms.clg.fulltimeStats"/></a></li>
							</c:if>
							<c:if test="${r2Conf['usr.arms.clg.fullTotalPub'] eq '4' }">
								<li><a class="left_menu <c:if test="${leftNm eq 'fulltimeArticle' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/college/fulltimeArticle.do"/>').submit();"><span></span><spring:message code="menu.asrms.clg.fulltimeArticle"/></a></li>
							</c:if>
							<c:if test="${r2Conf['usr.arms.clg.fullSciPub'] eq '4' }">
								<li><a class="left_menu <c:if test="${leftNm eq 'fulltimeSci' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/college/fulltimeSci.do"/>').submit();"><span></span><spring:message code="menu.asrms.clg.fulltimeSci"/></a></li>
							</c:if>
                            <c:if test="${r2Conf['usr.arms.clg.oaArticleByYear'] eq '4' }">
                                <li><a class="left_menu <c:if test="${leftNm eq 'oaArticleByYear' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/college/oaArticleByYear.do"/>').submit();"><span></span><spring:message code="menu.asrms.clg.oaByYear"/></a></li>
                            </c:if>
                            <c:if test="${r2Conf['usr.arms.clg.oaArticleByDepart'] eq '4' }">
                                <li><a class="left_menu <c:if test="${leftNm eq 'oaArticleByDepart' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/college/oaArticleByDepart.do"/>').submit();"><span></span><spring:message code="menu.asrms.clg.oaByDepart"/></a></li>
                            </c:if>
							<c:if test="${r2Conf['usr.arms.clg.oaJournals'] eq '4' }">
								<li><a class="left_menu <c:if test="${leftNm eq 'oaJournals' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/college/oaJournals.do"/>').submit();"><span></span><spring:message code="menu.asrms.clg.oaJournals"/></a></li>
							</c:if>
							<c:if test="${r2Conf['usr.arms.clg.oaSubjects'] eq '4' }">
								<li><a class="left_menu <c:if test="${leftNm eq 'oaSubjects' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/college/oaSubjects.do"/>').submit();"><span></span><spring:message code="menu.asrms.clg.oaSubjects"/></a></li>
							</c:if>
						</ul>
					</li>
					<!-- 2010-10-20 우완기 추가 funding-->
					<c:if test="${r2Conf['usr.arms.clg.fundingByDvs'] eq '4' }">
						<li>
							<a href="javascript:void(0);" class="sideToggle"><span>연구과제</span></a>
							<ul class="nav_sub">
								<c:if test="${r2Conf['usr.arms.clg.fundingByDvs'] eq '4' }">
									<li><a class="left_menu <c:if test="${leftNm eq 'fundingByDvs' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/college/fundingByDvs.do"/>').submit();"><span></span><spring:message code="menu.asrms.clg.fundingByDvs"/></a></li>
								</c:if>
								<c:if test="${r2Conf['usr.arms.clg.fundingByGov'] eq '4' }">
									<li><a class="left_menu <c:if test="${leftNm eq 'fundingByGov' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/college/fundingByGov.do"/>').submit();"><span></span><spring:message code="menu.asrms.clg.fundingByGov"/></a></li>
								</c:if>
								<c:if test="${r2Conf['usr.arms.clg.fundingByDepart'] eq '4' }">
									<li><a class="left_menu <c:if test="${leftNm eq 'fundingByDepart' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/college/fundingByDepart.do"/>').submit();"><span></span><spring:message code="menu.asrms.clg.fundingByDepart"/></a></li>
								</c:if>
								<c:if test="${r2Conf['usr.arms.clg.fundingByResearchers'] eq '4' }">
									<li><a class="left_menu <c:if test="${leftNm eq 'fundingByResearchers' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/college/fundingByResearchers.do"/>').submit();"><span></span><spring:message code="menu.asrms.clg.fundingByResearchers"/></a></li>
								</c:if>
								<c:if test="${r2Conf['usr.arms.clg.funding'] eq '4' }">
									<li><a class="left_menu <c:if test="${leftNm eq 'funding' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/college/funding.do"/>').submit();"><span></span><spring:message code="menu.asrms.clg.funding"/></a></li>
								</c:if>
								<c:if test="${r2Conf['usr.arms.clg.fulltimeFunding'] eq '4' }">
									<li><a class="left_menu <c:if test="${leftNm eq 'fulltimeFunding' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/college/fulltimeFunding.do"/>').submit();"><span></span><spring:message code="menu.asrms.clg.fulltimeFunding"/></a></li>
								</c:if>
							</ul>
						</li>
					</c:if>
					<!--우완기 추가 patent -->
					<c:if test="${r2Conf['usr.arms.clg.patentByAcqs'] eq '4' }">
						<li>
							<a href="javascript:void(0);" class="sideToggle"><span>지식재산</span></a>
							<ul class="nav_sub">
								<c:if test="${r2Conf['usr.arms.clg.patentByAcqs'] eq '4' }">
									<li><a class="left_menu <c:if test="${leftNm eq 'patentByAcqs' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/college/patentByAcqs.do"/>').submit();"><span></span><spring:message code="menu.asrms.clg.patentByAcqs"/></a></li>
								</c:if>
								<c:if test="${r2Conf['usr.arms.clg.patentTrend'] eq '4' }">
									<li><a class="left_menu <c:if test="${leftNm eq 'patentTrend' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/college/patentTrend.do"/>').submit();"><span></span><spring:message code="menu.asrms.clg.patentTrend"/></a></li>
								</c:if>
								<c:if test="${r2Conf['usr.arms.clg.patentByNation'] eq '4' }">
									<li><a class="left_menu <c:if test="${leftNm eq 'patentByNation' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/college/patentByNation.do"/>').submit();"><span></span><spring:message code="menu.asrms.clg.patentByNation"/></a></li>
								</c:if>
								<%--<c:if test="${r2Conf['usr.arms.clg.patentByIPC'] eq '4' }">
									<li><a class="left_menu <c:if test="${leftNm eq 'patentByIPC' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/college/patentByIPC.do"/>').submit();"><span></span><spring:message code="menu.asrms.clg.patentByIPC"/></a></li>
								</c:if>--%>
								<c:if test="${r2Conf['usr.arms.clg.patent'] eq '4' }">
									<li><a class="left_menu03 <c:if test="${leftNm eq 'departNoPats' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/college/departNoPats.do"/>').submit();"><span></span><spring:message code="menu.asrms.clg.patent"/></a></li>
								</c:if>
								<c:if test="${r2Conf['usr.arms.clg.patentByResearchers'] eq '4' }">
									<li><a class="left_menu <c:if test="${leftNm eq 'patentByResearchers' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/college/patentByResearchers.do"/>').submit();"><span></span><spring:message code="menu.asrms.clg.patentByResearchers"/></a></li>
								</c:if>
								<c:if test="${r2Conf['usr.arms.clg.techtrans'] eq '4' }">
									<li><a class="left_menu07 <c:if test="${leftNm eq 'tcntrns' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/college/tcntrns.do"/>').submit();"><span></span><spring:message code="menu.asrms.clg.techtrans"/></a></li>
								</c:if>
							</ul>
						</li>
					</c:if>
				</ul>
			</c:if>
			<c:if test="${topNm eq 'institution'}">
				<div class="lnb_title">
					<h2 class="institution_text"><spring:message code="menu.asrms.inst"/></h2>
				</div>
				<ul>
					<c:if test="${r2Conf['usr.arms.inst.onePageReport'] eq '4' }">
						<li>
							<a href="javascript:void(0);" class="sideToggle"><span>성과종합</span></a>
							<ul class="nav_sub">
								<c:if test="${r2Conf['usr.arms.inst.overview'] eq '4' }">
									<li><a class="left_menu07 <c:if test="${leftNm eq 'overview' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/institution/overview.do"/>').submit();"><span></span><spring:message code="menu.asrms.inst.overview"/></a></li>
								</c:if>
								<c:if test="${r2Conf['usr.arms.inst.onePageReport'] eq '4' }">
									<li><a class="left_menu07 <c:if test="${leftNm eq 'onePageReport' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/institution/onePageReport.do"/>').submit();"><span></span><spring:message code="menu.asrms.inst.onePageReport"/></a></li>
								</c:if>
							</ul>
						</li>
					</c:if>
					<c:if test="${r2Conf['usr.arms.inst.hindexBy'] eq '4' }">
						<li>
							<a href="javascript:void(0);" class="sideToggle"><span>저널논문</span></a>
							<ul class="nav_sub">
								<c:if test="${r2Conf['usr.arms.inst.hindexBy'] eq '4' }">
									<li><a class="left_menu07 <c:if test="${leftNm eq 'byHindex' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/institution/byHindex.do"/>').submit();"><span></span><spring:message code="menu.asrms.inst.hindex"/></a></li>
								</c:if>
								<c:if test="${r2Conf['usr.arms.inst.pubBy'] eq '4' }">
									<li><a class="left_menu10 <c:if test="${leftNm eq 'byPublications' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/institution/byPublications.do"/>').submit();"><span></span><spring:message code="menu.asrms.inst.pub"/></a></li>
								</c:if>
								<c:if test="${r2Conf['usr.arms.inst.citedBy'] eq '4' }">
									<li><a class="left_menu21 <c:if test="${leftNm eq 'topArticles' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/institution/topArticles.do"/>').submit();"><span></span><spring:message code="menu.asrms.inst.artCited"/></a></li>
								</c:if>
								<c:if test="${r2Conf['usr.arms.inst.publication'] eq '4' }">
									<li><a class="left_menu18 <c:if test="${leftNm eq 'departNoArts' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/institution/departNoArts.do"/>').submit();"><span></span><spring:message code="menu.asrms.inst.artco"/></a></li>
								</c:if>
								<c:if test="${r2Conf['usr.arms.inst.impact'] eq '4' }">
									<li><a class="left_menu19 <c:if test="${leftNm eq 'departIF' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/institution/departIF.do"/>').submit();"><span></span><spring:message code="menu.asrms.inst.avgif"/></a></li>
								</c:if>
								<c:if test="${r2Conf['usr.arms.inst.cited'] eq '4' }">
									<li><a class="left_menu05 <c:if test="${leftNm eq 'departTimeCited' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/institution/departTimeCited.do"/>').submit();"><span></span><spring:message code="menu.asrms.inst.cited"/></a></li>
								</c:if>
								<c:if test="${r2Conf['usr.arms.inst.coauthor'] eq '4' }">
									<li><a class="left_menu17 <c:if test="${leftNm eq 'departCoAuthor' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/institution/departCoAuthor.do"/>').submit();"><span></span><spring:message code="menu.asrms.inst.coauthor"/></a></li>
								</c:if>
								<c:if test="${r2Conf['usr.arms.inst.fullPub'] eq '4' }">
									<li><a class="left_menu <c:if test="${leftNm eq 'fulltimeArticle' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/institution/fulltimeArticle.do"/>').submit();"><span></span><spring:message code="menu.asrms.inst.fulltimeArticle"/></a></li>
								</c:if>
								<c:if test="${r2Conf['usr.arms.inst.fullTotalPub'] eq '4' }">
									<li><a class="left_menu <c:if test="${leftNm eq 'deptFulltimeArticle' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/institution/deptFulltimeArticle.do"/>').submit();"><span></span><spring:message code="menu.asrms.inst.deptFulltimeArticle"/></a></li>
								</c:if>
								<c:if test="${r2Conf['usr.arms.inst.fullSciPub'] eq '4' }">
									<li><a class="left_menu <c:if test="${leftNm eq 'fulltimeSci' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/institution/fulltimeSci.do"/>').submit();"><span></span><spring:message code="menu.asrms.inst.fulltimeSci"/></a></li>
								</c:if>
								<c:if test="${r2Conf['usr.arms.inst.fullSciDept'] eq '4' }">
									<li><a class="left_menu <c:if test="${leftNm eq 'departFulltimeSci' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/institution/departFulltimeSci.do"/>').submit();"><span></span><spring:message code="menu.asrms.inst.departFulltimeSci"/></a></li>
								</c:if>
								<c:if test="${r2Conf['usr.arms.inst.oaArticleByYear'] eq '4' }">
									<li><a class="left_menu <c:if test="${leftNm eq 'oaArticleByYear' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/institution/oaArticleByYear.do"/>').submit();"><span></span><spring:message code="menu.asrms.inst.oaByYear"/></a></li>
								</c:if>
								<c:if test="${r2Conf['usr.arms.inst.oaArticleByDepart'] eq '4' }">
									<li><a class="left_menu <c:if test="${leftNm eq 'oaArticleByDepart' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/institution/oaArticleByDepart.do"/>').submit();"><span></span><spring:message code="menu.asrms.inst.oaByDepart"/></a></li>
								</c:if>
								<c:if test="${r2Conf['usr.arms.inst.oaJournals'] eq '4' }">
									<li><a class="left_menu <c:if test="${leftNm eq 'oaJournals' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/institution/oaJournals.do"/>').submit();"><span></span><spring:message code="menu.asrms.inst.oaJournals"/></a></li>
								</c:if>
								<c:if test="${r2Conf['usr.arms.inst.oaSubjects'] eq '4' }">
									<li><a class="left_menu <c:if test="${leftNm eq 'oaSubjects' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/institution/oaSubjects.do"/>').submit();"><span></span><spring:message code="menu.asrms.inst.oaSubjects"/></a></li>
								</c:if>
							</ul>
						</li>
					</c:if>
					<c:if test="${r2Conf['usr.arms.inst.fundingByDvs'] eq '4' }">
						<li>
							<a href="javascript:void(0);" class="sideToggle"><span>연구과제</span></a>
							<ul class="nav_sub">
								<!-- 2010-10-20 우완기 추가 funding-->
								<c:if test="${r2Conf['usr.arms.inst.fundingByDvs'] eq '4' }">
									<li><a class="left_menu <c:if test="${leftNm eq 'fundingByDvs' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/institution/fundingByDvs.do"/>').submit();"><span></span><spring:message code="menu.asrms.inst.fundingByDvs"/></a></li>
								</c:if>
								<c:if test="${r2Conf['usr.arms.inst.fundingByGov'] eq '4' }">
									<li><a class="left_menu <c:if test="${leftNm eq 'fundingByGov' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/institution/fundingByGov.do"/>').submit();"><span></span><spring:message code="menu.asrms.inst.fundingByGov"/></a></li>
								</c:if>
								<c:if test="${r2Conf['usr.arms.inst.fundingByDepart'] eq '4' }">
									<li><a class="left_menu <c:if test="${leftNm eq 'fundingByDepart' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/institution/fundingByDepart.do"/>').submit();"><span></span><spring:message code="menu.asrms.inst.fundingByDepart"/></a></li>
								</c:if>
								<c:if test="${r2Conf['usr.arms.inst.fundingByResearchers'] eq '4' }">
									<li><a class="left_menu <c:if test="${leftNm eq 'fundingByResearchers' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/institution/fundingByResearchers.do"/>').submit();"><span></span><spring:message code="menu.asrms.inst.fundingByResearchers"/></a></li>
								</c:if>
								<c:if test="${r2Conf['usr.arms.inst.funding'] eq '4' }">
									<li><a class="left_menu <c:if test="${leftNm eq 'funding' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/institution/funding.do"/>').submit();"><span></span><spring:message code="menu.asrms.inst.funding"/></a></li>
								</c:if>
								<c:if test="${r2Conf['usr.arms.inst.fulltimeFunding'] eq '4' }">
									<li><a class="left_menu <c:if test="${leftNm eq 'fulltimeFunding' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/institution/fulltimeFunding.do"/>').submit();"><span></span><spring:message code="menu.asrms.inst.fulltimeFunding"/></a></li>
								</c:if>
							</ul>
						</li>
					</c:if>
					<c:if test="${r2Conf['usr.arms.inst.patentByAcqs'] eq '4' }">
						<li>
							<a href="javascript:void(0);" class="sideToggle"><span>지식재산</span></a>
							<ul class="nav_sub">
								<!--우완기 추가 patent -->
								<c:if test="${r2Conf['usr.arms.inst.patentByAcqs'] eq '4' }">
									<li><a class="left_menu <c:if test="${leftNm eq 'patentByAcqs' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/institution/patentByAcqs.do"/>').submit();"><span></span><spring:message code="menu.asrms.inst.patentByAcqs"/></a></li>
								</c:if>
								<c:if test="${r2Conf['usr.arms.inst.patentTrend'] eq '4' }">
									<li><a class="left_menu <c:if test="${leftNm eq 'patentTrend' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/institution/patentTrend.do"/>').submit();"><span></span><spring:message code="menu.asrms.inst.patentTrend"/></a></li>
								</c:if>
								<c:if test="${r2Conf['usr.arms.inst.patentByNation'] eq '4' }">
									<li><a class="left_menu <c:if test="${leftNm eq 'patentByNation' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/institution/patentByNation.do"/>').submit();"><span></span><spring:message code="menu.asrms.inst.patentByNation"/></a></li>
								</c:if>
								<%--<c:if test="${r2Conf['usr.arms.inst.patentByIPC'] eq '4' }">
									<li><a class="left_menu <c:if test="${leftNm eq 'patentByIPC' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/institution/patentByIPC.do"/>').submit();"><span></span><spring:message code="menu.asrms.inst.patentByIPC"/></a></li>
								</c:if>--%>
								<c:if test="${r2Conf['usr.arms.inst.patent'] eq '4' }">
									<li><a class="left_menu03 <c:if test="${leftNm eq 'departNoPats' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/institution/departNoPats.do"/>').submit();"><span></span><spring:message code="menu.asrms.inst.patent"/></a></li>
								</c:if>
								<c:if test="${r2Conf['usr.arms.inst.patentByResearchers'] eq '4' }">
									<li><a class="left_menu <c:if test="${leftNm eq 'patentByResearchers' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/institution/patentByResearchers.do"/>').submit();"><span></span><spring:message code="menu.asrms.inst.patentByResearchers"/></a></li>
								</c:if>
								<!-- techtrans -->
								<c:if test="${r2Conf['usr.arms.inst.techtrans'] eq '4' }">
									<li><a class="left_menu13 <c:if test="${leftNm eq 'tcntrns' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/institution/tcntrns.do"/>').submit();"><span></span><spring:message code="menu.asrms.inst.techtrans"/></a></li>
								</c:if>
							</ul>
						</li>
					</c:if>
					<c:if test="${r2Conf['usr.arms.inst.connUser'] eq '4' }">
						<li>
							<a href="javascript:void(0);" class="sideToggle"><span>로그분석</span></a>
							<ul class="nav_sub">
								<c:if test="${r2Conf['usr.arms.inst.logByMenu'] eq '4' }">
									<li><a class="left_menu08 <c:if test="${leftNm eq 'logStatsByMenu' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/institution/logStatsByMenu.do"/>').submit();"><span></span><spring:message code="menu.asrms.inst.logByMenu"/></a></li>
								</c:if>
								<c:if test="${r2Conf['usr.arms.inst.logByDate'] eq '4' }">
									<li><a class="left_menu11 <c:if test="${leftNm eq 'logStatsByDate' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/institution/logStatsByDate.do"/>').submit();"><span></span><spring:message code="menu.asrms.inst.logByDate"/></a></li>
								</c:if>
								<c:if test="${r2Conf['usr.arms.inst.connUser'] eq '4' }">
									<li><a class="left_menu09 <c:if test="${leftNm eq 'logStatsList' }">on</c:if>"  href="#" onclick="javascript:$('#topFrm').attr('action','<c:url value="/analysis/institution/logStatsList.do"/>').submit();"><span></span><spring:message code="menu.asrms.inst.connUser"/></a></li>
								</c:if>
							</ul>
						</li>
					</c:if>
				</ul>
			</c:if>
		</div> <!-- lnb : 왼쪽 메뉴 -->

		<div class="contents_box">
			<c:if test="${topNm ne 'institution' }">
				<div class="ct_wrap">
					<c:if test="${topNm eq 'researcher' }">
						<div class="contents_title researcher_type">
							<div class="pic_box">
								<c:if test="${not empty mode and mode eq 'onlyview' }">
									<c:set var="photoUrl" value="${parameter.srchUserPhotoUrl}"/>
								</c:if>
								<c:if test="${empty mode or mode ne 'onlyview' }">
									<c:set var="photoUrl" value="<%=photoUrl%>"/>
								</c:if>
								<c:if test="${not empty item.profPhotoFileId}">
									<img src="${contextPath }/servlet/image/profile.do?fileid=<c:out value="${item.profPhotoFileId}"/>" alt="<c:out value="${item.korNm}"/>" style="width: 53px;height: 53px;"/><span></span>
								</c:if>
								<c:if test="${empty item.profPhotoFileId}">
									<img src="${contextPath }/servlet/image/profile.do?userId=<c:out value="${item.userId}"/>" alt="<c:out value="${item.korNm}"/>" style="width: 53px;height: 53px;"/><span></span>
									<%--
                                    <img src="${contextPath }/images/analysis/common/anonymous_profile.png" alt="anonymous" style="width:54px;"/><span></span>
                                     --%>
								</c:if>
							</div>
							<div class="ct_text">
								<p class="name_p"><c:out value="${item.korNm}"/><em><c:out value="${item.lastName}"/>,&nbsp;<c:out value="${item.firstName}"/></em></p>
								<p class="college_p"><c:out value="${item.deptKor}"/><em><c:out value="${item.deptEng}"/></em></p>
							</div>
						</div>
					</c:if>
					<c:if test="${topNm eq 'department' }">
						<div class="contents_title department_type">
							<div class="ct_text">
								<c:out value="${item.deptKor}"/><span><c:out value="${item.deptEng}"/></span>
								<div class="researcher_select">
									<em><select id="researcher" name="researcher">
										<option value="">Researcher list</option>
										<c:forEach items="${resercherList}" var="rl" varStatus="idx">
											<option value="<c:out value="${rl.userId}"/>"><c:out value="${rl.korNm }"/></option>
										</c:forEach>
									</select></em>
									<a href="javascript:void(0);" onclick="javascript:popupUser();" class="go_bt">이동</a>
								</div>
							</div>
						</div>
					</c:if>
					<c:if test="${topNm eq 'college' }">
						<div class="contents_title college_type">
							<div class="ct_text">${item.codeDisp}<span>${item.codeDispEng}</span></div>
						</div>
					</c:if>
				</div>
			</c:if>
			<div class="contents_area">
				<decorator:body />
				<div class="footer_wrap">
					<p class="footer_text">Copyright (C) 2018, ${sysConf['inst.name.eng.full']}, All Rights Reserved.</p>
					<div class="footer_right">
						<span class="text_t footer_icon01">${sysConf['system.admin.telno']}</span>
						<a href="mailto:${sysConf['system.admin.email']}">${sysConf['system.admin.email']}</a>
					</div>
				</div> <%-- footer_wrap : end --%>
			</div> <%-- contents_area : end  --%>
		</div> <%-- contents_box : end  --%>
	</div>  <%-- contenst_wrap : end  --%>
</div> <%-- shadow_box : end  --%>

<div id="warningDialog" title="Warning" style="display: none;">
	<sapn style="margin-top:10px;">
		${sysConf['system.abbr']}에 입력된 SCI 논문 실적이 없는 교원입니다. <br/>
		(This researcher is a professor who is no SCI data in ${sysConf['system.abbr']}.)
	</sapn>
</div>
<form name="popFrm" id="popFrm" method="post"></form>


<div id="searchResearcherDialog" class="popup_select_box modal modal_layer" style="width: 360px;height:242px; display: none;" >
	<div class="popup_header">
		<h3>연구자검색</h3>
		<a href="#" class="close_bt closeBtn">닫기</a>
	</div>
	<div class="popup_inner">
		<table width="100%" class="list_tbl mgb_20" style="text-align: left;">
			<tr>
				<td><input name="searchWord" id="searchWord" class=""/></td>
			</tr>
		</table>
	</div>
</div>

<div style="height: 0px;display: none;">
	<div id="exportGrid"></div>
</div>
<script type="text/javascript">
    function toggleAll(chkbox){
        if(chkbox.is(':checked'))
        {
            $('input[name="gubun"]').prop('checked', true);
        }
        else
        {
            $('input[name="gubun"]').prop('checked', false);
        }
    }

    function resumeDownload(userId){
        $('#resumeUserId').val(userId);
        $('.popup_header > h3 ').html("Resume");
    }

    function exportDownload(userId){
        $('#exportUserId').val(userId);
        $('.popup_header > h3 ').html("Export");
        loadYearRange($('input[name="exportGubun"]:checked'), userId);
    }

    function loadYearRange(radio, userId){
        //alert($(radio).val());
        $.ajax({
            url : '${pageContext.request.contextPath}/analysis/researcher/findYearRangeAjax.do',
            method : 'POST',
            dataType : 'json',
            data : {'type': $(radio).val(), 'userId': userId},
            success : function(data){

            }
        }).done(function(data){
            var gubun = $('input[name="exportGubun"]:checked').val();

            $('#expSttYear').empty();
            $('#expEndYear').empty();

            for(var i=0; i < data.length; i++)
            {
                var year = "";
                if(gubun == 'article') year = data[i].pubYear;
                else if(gubun == 'patent') year = data[i].patYear;
                else if(gubun == 'techtrans') year = data[i].transYear;
                $('#expSttYear').append($('<option value="'+year+'">'+year+'</option>'));
                $('#expEndYear').append($('<option value="'+year+'">'+year+'</option>'));
            }
            if( data.length < 4)
            {
                $('#expSttYear option').eq(data.length-1).prop('selected','selected');
            }
            else
            {
                $('#expSttYear option').eq(4).prop('selected','selected');
            }
        });

    }

    function exportOutput(){

        var exportGubun = $('input[name="exportGubun"]:checked').val();

        var url = "${pageContext.request.contextPath}/analysis/researcher/";
        if(exportGubun == 'article') url += "findExportArticleListByUserId.do";
        else if(exportGubun == 'patent') url += "findExportPatentListByUserId.do";
        else if(exportGubun == 'techtrans') url += "findExportTechtransListByUserId.do";

        var param = "?topNm=researcher&userId="+$('#exportUserId').val()+"&sttYm="+$('#expSttYear').val()+$('#expSttMonth').val()+"&endYm="+$('#expEndYear').val()+$('#expEndMonth').val();
        myGrid.clearAndLoad(url+param, exportGridExcel);
    }

    function exportGridExcel(){
        //myGrid.setInitWidths("50,80,300,200,150");
        //myGrid.setColWidth(2,"500");
        var exportGubun = $('input[name="exportGubun"]:checked').val();
        var fileName = "";
        if(exportGubun == 'article') fileName = "User_Article_Data.xls";
        else if(exportGubun == 'patent') fileName = "User_Patent_Data.xls";
        else if(exportGubun == 'techtrans') fileName = "User_Techtrans_Data.xls";

        set_myGridColumnWidth();
        myGrid.toExcel('${contextPath}/servlet/xlsGenerate.do?file_name='+fileName);

    }

    var myGrid_Article_ColWidth = ["50","80","550","300","250","60","60","60","60","60","60","60","60","60","60","60","60","60","60","60","113","113","113","200","60","60","60","60"];
    var myGrid_Patent_ColWidth = ["50","80","100","50","100","100","500","60","60","60","60","60","200","200","60","60"];
    var myGrid_Techtrans_ColWidth = ["50","80","100","250","150","100","150"];

    function set_myGridColumnWidth(){
        var exportGubun = $('input[name="exportGubun"]:checked').val();
        var colwidth = null;
        if(exportGubun == 'article') colwidth = myGrid_Article_ColWidth;
        else if(exportGubun == 'patent') colwidth = myGrid_Patent_ColWidth;
        else if(exportGubun == 'techtrans') colwidth = myGrid_Techtrans_ColWidth;
        for(var i=0; i< colwidth.length; i++) myGrid.setColWidth(i,colwidth[i]);
    }

    function moveSolution(action, system){
        if("SEARCH" == system)
        {
            var asRims = window.open('','SEARCH','height=783,width=914,innerHeight=919, resizable=no,location=no,scrollbars=yes');
            var popFrm = $('#popFrm');
            popFrm.empty();
            popFrm.attr('action', action);
            popFrm.attr('target', "SEARCH");
            popFrm.attr('method', "post");
            popFrm.submit();
        }
        else if("UGAS" == system)
        {
            var asRims = window.open('','UGAS','height=845px,width=1145px,resizable=no,location=no,scrollbars=yes');
            var popFrm = $('#popFrm');
            popFrm.empty();
            popFrm.attr('action', action);
            popFrm.attr('target', "UGAS");
            popFrm.attr('method', "post");
            popFrm.submit();
        }
    }
</script>
</body>
</html>