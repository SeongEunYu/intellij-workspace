<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator"%>
<%@ taglib prefix="page" uri="http://www.opensymphony.com/sitemesh/page"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="spring" uri="/WEB-INF/tld/spring.tld" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
	<c:set var="dSessMode" value="${not empty acessMode and acessMode eq 'rchfs' ? true : false }"/>
	<c:set var="dPreUrl" value="${not empty acessMode and acessMode eq 'rchfs' ?  acessMode : 'auth' }"/>
	<c:set var="dNotStdn" value="${(sessionScope.auth.adminDvsCd ne 'R' or sessionScope.sess_user.gubun ne 'S') and (not dSessMode or sessionScope.sess_user.gubun ne 'S') }"/>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta http-equiv="cache-Control" content="co-cache" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=yes" />
	<title>${sysConf['system.rss.jsp.title']}</title>
	<link rel="shortcut icon" href="<c:url value="/images/${sysConf['shortcut.icon']}"/>">
	<link type="text/css" href="<c:url value="/css/style.css"/>?t=20200115" rel="stylesheet" />
	<link type="text/css" href="<c:url value="/css/layout.css"/>?t=20200115" rel="stylesheet" />
	<link type="text/css" href="<c:url value="/js/dhtmlx/skins/${sysConf['dhtmlx.skin']}/dhtmlx.css"/>" rel="stylesheet" />
	<script type="text/javascript" src="<c:url value="/js/jquery/jquery-1.11.3.min.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/js/jquery/jquery-ui.min.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/js/jquery/jquery.modal.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/js/jquery/jquery.cookie-1.4.1.min.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/js/dhtmlx/dhtmlx.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/js/script.js"/>?t=20200115"></script>
	<script type="text/javascript" src="<c:url value="/js/main_nav.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/js/left_nav.js"/>"></script>
	<c:if test="${ dSessMode or (sessionScope.auth.adminDvsCd eq 'R' or sessionScope.auth.adminDvsCd eq 'S') }">
		<style type="text/css">#gnb .menu{width: 180px;}</style>
	</c:if>
	<script type="text/javascript">
		var dPreUrl = "<c:out value="${dPreUrl}"/>";

        $(function(){
            $('#resume_tabs').tabs();
            //현재 년도, 월을 구함
			<c:if test="${not empty sysConf['export.research.plan'] and sysConf['export.research.plan'] eq 'Y'}">
			var yearMonth = getCurrentYearMonth();
			var year = yearMonth.split('-')[0];
			var month = yearMonth.split('-')[1];
			if(month < 7)
				$('#hml_stdr_year').val(year -1);
			else
                $('#hml_stdr_year').val(year);
			</c:if>
        });

		function checkSearch(){
		    if($("#searchAllName").val().trim().length == 0){
                dhtmlx.alert("Please enter a researcher's name,<br/>research area or keyword.");
                return false;
			}
		}

        function fn_impHistoryListPopup(historyId, status){
            var userWindow =  window.open("<c:url value="/import/impHistoryListPopup.do"/>?historyId="+historyId+"&status="+status,"historyListWindow", "top=100, left=350, height=600, width=800, location=no, resizable=no, menubar=no");
            userWindow.focus();
        }

        function toggleIsReprsntRadio(action){
		    if(action == 'none') $('input[name="isReprsnt"]').prop('disabled', false);
		    else if(action == 'disabled')
			{
			    $('#isReprsnt_all').prop('checked', true);
                $('input[name="isReprsnt"]').prop('disabled', true);
			}
		}

		function fn_labPopup(){
			var wWidth = 1050;
			var wHeight = (screenHeight - 180);
			var leftPos = (screenWidth - wWidth)/2;
			var topPos = 0;
			var mappingPopup = window.open('about:blank', 'labPopup', 'width='+wWidth+',height='+wHeight+',top='+topPos+',left='+leftPos+' location=no,scrollbars=yes,resizable=yes');
			var popFrm = $('#popFrm');
			popFrm.empty();
			popFrm.attr('target', 'labPopup');
			popFrm.attr('action', '<c:url value="/${dPreUrl}/lab/labPopup.do"/>');
			popFrm.attr('method', 'POST');
			popFrm.submit();
			mappingPopup.focus();
		}
	</script>
	<decorator:head />
</head>
<%--<body class="dhxwins_vp_dhx_terrace">--%>
<body>
<form id="menuFrm" name="menuFrm" method="post"></form>
<c:if test="${not empty topNotice }">
	<div class="notice_top_wrap" style="display: none;">
		<div class="notice_top_box">
			<div class="notice_top_inner">
				<h3><spring:message code="main.alert.notice.title" /></h3>
				<div class="notice_list">
					<ul>
						<li style="font-size: 14px;">
							<a href="<c:url value="/kboard.do?cateId=1&boardPath=/ri_notice/${topNotice.content}"/>">${topNotice.title}</a>
								<%--
                                <c:choose>
                                    <c:when test="${pageContext.response.locale eq 'en'}">
                                        <a href="<c:url value="/kboard.do?cateId=1&boardPath=/ri_notice/11482043807246"/>">RIMS Renewal Open ( New Interface and Design)</a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="<c:url value="/kboard.do?cateId=1&boardPath=/ri_notice/11482043807246"/>">RIMS 리뉴얼 오픈 안내 (인터페이스 및 디자인 변경)</a>
                                    </c:otherwise>
                                </c:choose>
                                 --%>
						</li>
					</ul>
					<a href="<c:url value="/kboard.do?cateId=1"/>" class="notice_more">공지사항 더보기</a>
				</div>
				<a href="javascript:void(0);" class="close_bt" onclick="$('.notice_top_wrap').css('display','none');"></a>
				<p class="n_ck_box"><label for="notice_chk"><spring:message code="main.alert.noshow.today" /></label> <input type="checkbox" id="notice_chk" onclick="registNoteiceCookie($('.notice_top_wrap'));"></p>
			</div>
		</div>
	</div>
</c:if>
<div class="header_wrap">
	<h1><a href="<c:url value="/${dPreUrl}/main.do"/>" class="${pageContext.response.locale}">${sysConf['system.rss.jsp.title']}</a></h1>
	<div class="top_search_wrap">
		<p class="search_opion h_fix">
			<%--<button id="btnRsrchr" class="${empty param.srchTrget or param.srchTrget eq 'researcher' ? 'on' : ''  }" onclick="javascript:fn_selectOption($(this), '<spring:message code='main.search.keywordf'/>');"><span><spring:message code='main.search.researcher'/></span></button>
            <button id="btnOutput" class="${not empty param.srchTrget and param.srchTrget eq 'output' ? 'on' : ''  }" onclick="javascript:fn_selectOption($(this), '<spring:message code='main.search.keyword'/>');"><span><spring:message code='main.search.performance'/></span></button>--%>
			<button id="btnRD" class="on" style="width: 150px;"><span>RIMS Discovery</span></button>
		</p>
		<form action="<c:url value="/share/user/searchAll.do"/>" method="get" target="_blank" onsubmit="return checkSearch()">
			<div class="search_int_box" style="margin-left: 160px;">
				<%--<spring:message var="reseacherMessage" code='main.search.keywordf'/><spring:message var="outputMessage" code='main.search.keyword'/>
				<c:if test="${empty param.srchTrget or param.srchTrget eq 'researcher'}"><c:set var="placeholderMessage" value="${reseacherMessage}"/></c:if>
				<c:if test="${not empty param.srchTrget and param.srchTrget eq 'output'}"><c:set var="placeholderMessage" value="${outputMessage }"/></c:if>--%>
				<input type="text" id="searchAllName" name="searchAllName" class="search_int" title="RIMS Discovery 검색" placeholder="Find KAIST researchers & research output through RIMS Discovery" />
				<%--<input type="hidden" id="srchTrget" name="srchTrget" value="${param.srchTrget eq 'output' ? 'output' : 'researcher'}" />--%>
				<input type="submit" class="search_bt" value="검색" style="border: 0;" />
			</div>
		</form>
	</div>
	<div class="top_gnav">
		<ul>
			<li class="home_li"><a href="<c:url value="/${dPreUrl}/main.do"/>">Home</a></li>
			<li><a href="<c:url value="/share/user/main.do"/>">RIMS Discovery</a></li>
			<li><a href="javascript:moveSolution('${pageContext.request.contextPath}/index/${dPreUrl}/goAsRIMS.do?gubun=M','ASRIMS');">RIMS Analysis</a></li>
			<li class="member_li">
				<em>
					<c:choose>
						<c:when test="${pageContext.response.locale eq 'ko'}">
							${sessionScope.login_user.korNm}
						</c:when>
						<c:otherwise>
							<c:if test="${not empty sessionScope.sess_user.lastName}">
								${sessionScope.login_user.lastName}, ${sessionScope.login_user.firstName}
							</c:if>
							<c:if test="${empty sessionScope.sess_user.lastName}">
								${sessionScope.login_user.engNm}
							</c:if>
						</c:otherwise>
					</c:choose>
					<c:if test="${dSessMode}">
						<c:choose>
							<c:when test="${pageContext.response.locale eq 'ko'}">
								[${sessionScope.sess_user.korNm}]
							</c:when>
							<c:otherwise>
								<c:if test="${not empty sessionScope.sess_user.lastName}">
									[${sessionScope.sess_user.lastName}, ${sessionScope.sess_user.firstName}]
								</c:if>
								<c:if test="${empty sessionScope.sess_user.lastName}">
									[${sessionScope.sess_user.engNm}]
								</c:if>
							</c:otherwise>
						</c:choose>
					</c:if>
				</em>&nbsp;
				<a href="<c:url value="/index/logout.do"/>">Logout</a>
			</li>
			<c:if test="${ dSessMode or (sessionScope.auth.adminDvsCd eq 'R' or sessionScope.auth.adminDvsCd eq 'S') }">
				<c:if test="${pageContext.response.locale eq 'ko'}">
					<li><a href="<c:url value='/index/setLocale.do?locale=en'/>">ENG</a></li>
				</c:if>
				<c:if test="${pageContext.response.locale eq 'en'}">
					<li><a href="<c:url value='/index/setLocale.do?locale=ko'/>">KOR</a></li>
				</c:if>
			</c:if>
		</ul>
	</div>
</div>

<div class="nav_wrap  <c:if test="${ not dSessMode and sessionScope.auth.adminDvsCd ne 'R' and  sessionScope.auth.adminDvsCd ne 'S'}">admin_nav</c:if>">
	<div id="navul_wrap">
		<ul id="gnb" class="gnb">
			<c:if test="${ dSessMode or (sessionScope.auth.adminDvsCd eq 'R' or sessionScope.auth.adminDvsCd eq 'S') }">
				<li class="menu">
					<a href="#" class="nav_menu_a" title="기본정보"><spring:message code="menu.user.info"/></a>
					<div class="sub_menu" style="display:none;">
						<ul style="display: none;">
							<li><a href="javascript:void(0);" onclick="javascript:fn_userPopup('<c:url value="/${dPreUrl}/user/userPopup.do"/>')"><spring:message code="menu.researcher.info"/></a></li>
							<li><a href="javascript:void(0);" onclick="javascript:fn_userPopup('<c:url value="/${dPreUrl}/user/infoProvdPopup.do"/>')"><spring:message code="menu.othr.agc.linked"/></a></li>
							<li><a href="<c:url value="/${dPreUrl}/rsrchrealm.do"/>"><spring:message code="menu.nrf.stdy.field"/></a></li>
							<c:if test="${dNotStdn and sessionScope.auth.adminDvsCd ne 'S' and sessionScope.auth.adminDvsCd ne 'V'}">
								<li><a href="<c:url value='/${dPreUrl}/member/agncy.do'/>"><spring:message code="menu.assistant.mgt"/></a></li>
							</c:if>
							<c:if test="${sessionScope.auth.adminDvsCd eq 'S' or sessionScope.auth.adminDvsCd eq 'V'}">
								<li><a href="#" onclick="javascript:dhtmlx.alert('<spring:message code="main.noAuthor.alert.message"/>');"><spring:message code="menu.assistant.mgt"/></a></li>
							</c:if>
							<c:if test="${dNotStdn and (sessionScope.auth.adminDvsCd eq 'R' or sessionScope.auth.adminDvsCd eq 'M')}">
								<li><a href="javascript:void(0);" onclick="javascript:fn_userPopup('<c:url value="/user/infoOthbcForm.do"/>');" ><spring:message code="menu.shared.info"/></a></li>
							</c:if>
							<c:if test="${sessionScope.auth.adminDvsCd ne 'R' and sessionScope.auth.adminDvsCd ne 'M'}">
								<li><a href="javascript:void(0);" onclick="javascript:dhtmlx.alert('<spring:message code="main.noAuthor.alert.message"/>');" ><spring:message code="menu.shared.info"/></a></li>
							</c:if>
							<li><a href="<c:url value='/${dPreUrl}/requestMgt.do'/>"><spring:message code="menu.request.result"/></a></li>
							<c:if test="${r2Conf['usr.rims.info.lab'] eq '3'}">
								<li><a href="javascript:void(0);" onclick="javascript:fn_labPopup();"><spring:message code='menu.lab'/></a></li>
							</c:if>
						</ul>
					</div>
				</li>
			</c:if>
			<li class="menu">
				<a href="#" class="nav_menu_a" title="주요성과"><spring:message code="menu.main.performance"/></a>
				<div class="sub_menu" style="display: none;">
					<ul style="display: none;">
						<c:if test="${not dSessMode and sessionScope.auth.adminDvsCd ne 'R' and sessionScope.auth.adminDvsCd ne 'S' }">
							<c:if test="${r2Conf['adm.env.user.rsrcher'] eq '3' }">
								<c:if test="${sessionScope.auth.adminDvsCd eq 'M' or sessionScope.auth.user_user eq '1' }">
									<li><a href="<c:url value="/auth/user/user.do"/>"><spring:message code='menu.researcher.manage'/></a></li>
								</c:if>
							</c:if>
						</c:if>
						<c:if test="${r2Conf['adm.rms.rslt.atcl'] eq '3' and sessionScope.auth.ART gt 0 }">
							<li><a href="<c:url value="/${dPreUrl}/article/article.do"/>"><spring:message code='menu.article'/></a></li>
						</c:if>
						<c:if test="${r2Conf['adm.rms.rslt.porcd'] eq '3' and sessionScope.auth.CON gt 0 }">
							<li><a href="<c:url value="/${dPreUrl}/conference/conference.do"/>"><spring:message code='menu.conference'/></a></li>
						</c:if>
						<c:if test="${dNotStdn and r2Conf['adm.rms.rslt.book'] eq '3' and sessionScope.auth.BOOK gt 0 }">
							<li><a href="<c:url value="/${dPreUrl}/book/book.do"/>"><spring:message code='menu.book'/></a></li>
						</c:if>
						<c:if test="${dNotStdn and r2Conf['adm.rms.rslt.rsrch'] eq '3' and sessionScope.auth.FUD gt 0 }">
							<li><a href="<c:url value="/${dPreUrl}/funding/funding.do"/>"><spring:message code='menu.funding'/></a></li>
						</c:if>
						<c:if test="${dNotStdn and r2Conf['adm.rms.rslt.pat'] eq '3' and sessionScope.auth.PAT gt 0 }">
							<li><a href="<c:url value="/${dPreUrl}/patent/patent.do"/>"><spring:message code='menu.patent'/></a></li>
						</c:if>
						<c:if test="${dNotStdn and r2Conf['adm.rms.rslt.tech'] eq '3' and sessionScope.auth.TECH gt 0 }">
							<li><a href="<c:url value="/${dPreUrl}/techtrans/techtrans.do"/>"><spring:message code='menu.techtrans'/></a></li>
						</c:if>
						<c:if test="${dNotStdn and r2Conf['adm.rms.rslt.exbi'] eq '3' and sessionScope.auth.EXHI gt 0 }">
							<li><a href="<c:url value="/${dPreUrl}/exhibition/exhibition.do"/>"><spring:message code='menu.exhibition'/></a></li>
						</c:if>
						<c:if test="${dNotStdn and r2Conf['adm.rms.rslt.report'] eq '3' and sessionScope.auth.RPT gt 0 }">
							<li><a href="<c:url value="/${dPreUrl}/report/report.do"/>"><spring:message code='menu.report'/></a></li>
						</c:if>
					</ul>
				</div>
			</li>
			<c:if test="${dNotStdn}">
				<li class="menu">
					<a href="javascript:void(0);" class="nav_menu_a" title="기타성과"><spring:message code="menu.etc.performance"/></a>
					<div class="sub_menu" style="display: none;">
						<ul style="display: none;">
							<c:if test="${r2Conf['adm.rms.rslt.career'] eq '3' and sessionScope.auth.CAR gt 0 }">
								<li><a href="<c:url value="/${dPreUrl}/career/career.do"/>"><spring:message code='menu.career'/></a></li>
							</c:if>
							<c:if test="${r2Conf['adm.rms.rslt.dgri'] eq '3' and sessionScope.auth.DGR gt 0 }">
								<li><a href="<c:url value="/${dPreUrl}/degree/degree.do"/>"><spring:message code='menu.degree'/></a></li>
							</c:if>
							<c:if test="${r2Conf['adm.rms.rslt.agtc'] eq '3' and sessionScope.auth.AWD gt 0 }">
								<li><a href="<c:url value="/${dPreUrl}/award/award.do"/>"><spring:message code='menu.award'/></a></li>
							</c:if>
							<c:if test="${r2Conf['adm.rms.rslt.qualf'] eq '3' and sessionScope.auth.LNC gt 0 }">
								<li><a href="<c:url value="/${dPreUrl}/license/license.do"/>"><spring:message code='menu.license'/></a></li>
							</c:if>
								<%--
                                <c:if test="${r2Conf['adm.rms.rslt.realm'] eq '3' and sessionScope.auth.CATE gt 0 }">
                                <li><a href="<c:url value="/${dPreUrl}/rsrchrealm.do"/>"><spring:message code='menu.major'/></a></li>
                                </c:if>
                                --%>
							<c:if test="${dSessMode or sessionScope.auth.adminDvsCd eq 'R' or sessionScope.auth.adminDvsCd eq 'S' }">
								<c:if test="${r2Conf['adm.rms.rslt.lecture'] eq '3' and sessionScope.auth.LEC gt 0 }">
									<li><a href="<c:url value="/${dPreUrl}/lecture/lecture.do"/>"><spring:message code='menu.lecture'/></a></li>
								</c:if>
								<c:if test="${r2Conf['adm.rms.rslt.exust'] eq '3' and sessionScope.auth.STD gt 0 }">
									<li><a href="<c:url value="/${dPreUrl}/student/student.do"/>"><spring:message code='menu.student'/></a></li>
								</c:if>
							</c:if>
							<c:if test="${r2Conf['adm.rms.rslt.etc'] eq '3' and sessionScope.auth.ETC gt 0 }">
								<li><a href="<c:url value="/${dPreUrl}/etc/etc.do"/>"><spring:message code='menu.etc'/></a></li>
							</c:if>
							<c:if test="${r2Conf['adm.rms.rslt.etcact'] eq '3' and sessionScope.auth.ACT gt 0 }">
								<li><a href="<c:url value="/${dPreUrl}/activity/activity.do"/>"><spring:message code='menu.activity'/></a></li>
							</c:if>
						</ul>
					</div>
				</li>
			</c:if>
			<li class="menu">
				<a href="#" class="nav_menu_a" title="자료실"><spring:message code='menu.resource'/></a>
				<div class="sub_menu" style="display:none;">
					<ul style="display: none;">
						<c:if test="${not dSessMode }">
							<li><a href="<c:url value="/kboard.do?cateId=1"/>" title="공지사항"><spring:message code='menu.notice'/></a></li>
							<li><a href="<c:url value="/kboard.do?cateId=2"/>" title="매뉴얼"><spring:message code='menu.manual'/></a></li>
							<li><a href="<c:url value="/kboard.do?cateId=3"/>" title="SCI/IF List"><spring:message code='menu.scilist'/></a></li>
						</c:if>
						<c:if test="${not dSessMode and sessionScope.auth.adminDvsCd ne 'R' and sessionScope.auth.adminDvsCd ne 'S'}">
							<c:if test="${sessionScope.auth.adminDvsCd eq 'M'}">
								<li><a href="<c:url value="/board/noticeMgt.do"/>">공지사항관리</a></li>
							</c:if>
							<c:if test="${r2Conf['adm.rms.jrnl.mstr'] eq '3' }">
								<li><a href="<c:url value="/journal/journalWbPage.do"/>"><spring:message code='menu.journal.master'/></a></li>
							</c:if>
						</c:if>
						<c:if test="${r2Conf['adm.rms.jrnl.masterList'] eq '3' }">
							<li><a href="<c:url value="/${dPreUrl}/journal/journalMasterList.do"/>"><spring:message code='menu.master.list'/></a></li>
						</c:if>
						<c:if test="${r2Conf['adm.rms.jrnl.jcr'] eq '3' }">
							<li><a href="<c:url value="/${dPreUrl}/jcr/jcrPage.do"/>"><spring:message code='menu.jcr'/></a></li>
						</c:if>
						<c:if test="${r2Conf['adm.rms.jrnl.jcrRank'] eq '3' }">
							<li><a href="<c:url value="/${dPreUrl}/jcr/jcrCategoryRankingPage.do"/>"><spring:message code='menu.jcr.ranking'/></a></li>
						</c:if>
						<c:if test="${r2Conf['adm.rms.jrnl.jcrList'] eq '3' }">
							<li><a href="<c:url value="/${dPreUrl}/jcr/jcrList.do"/>"><spring:message code='menu.jcr.list'/></a></li>
						</c:if>
						<c:if test="${r2Conf['adm.rms.jrnl.sjr'] eq '3' }">
							<li><a href="<c:url value="/${dPreUrl}/sjr/sjrPage.do"/>"><spring:message code='menu.sjr'/></a></li>
						</c:if>
						<c:if test="${r2Conf['adm.rms.jrnl.sjrRank'] eq '3' }">
							<li><a href="<c:url value="/${dPreUrl}/sjr/sjrCategoryRankingPage.do"/>"><spring:message code='menu.sjr.ranking'/></a></li>
						</c:if>
						<c:if test="${r2Conf['adm.rms.jrnl.sjrList'] eq '3' }">
							<li><a href="<c:url value="/${dPreUrl}/sjr/sjrList.do"/>"><spring:message code='menu.sjr.list'/></a></li>
						</c:if>
						<c:if test="${r2Conf['adm.rms.jrnl.kci'] eq '3' }">
							<li><a href="<c:url value="/${dPreUrl}/kci/kciPage.do"/>"><spring:message code='menu.kci'/></a></li>
						</c:if>
						<%--<li><a href="<c:url value="/${dPreUrl}/board/policy.do"/>"><spring:message code='menu.policy'/></a></li>--%>
					</ul>
				</div>
			</li>
			<c:if test="${not dSessMode and (sessionScope.auth.adminDvsCd eq 'M' or sessionScope.auth.adminDvsCd eq 'P') }">
				<li class="menu">
					<a href="#" class="nav_menu_a">시스템연계</a>
					<div class="sub_menu" style="display: none;">
						<ul style="display: none;">
							<c:if test="${r2Conf['adm.rms.io.exr'] eq '3' }">
								<li><a href="<c:url value="/erCntc/exrimsTarget.do"/>">논문정보연계</a></li>
							</c:if>
							<c:if test="${r2Conf['adm.rms.io.ir'] eq '3' }">
								<li><a href="<c:url value="/reposCntc/reopsTarget.do"/>">IR연계</a></li>
							</c:if>
							<li><a href="<c:url value="/fundingCntc/fundingTarget.do"/>">연구비(연구과제)연계</a></li>
							<c:if test="${r2Conf['adm.rms.io.patent'] eq '3' }">
								<li><a href="<c:url value="/patentCntc/patentTarget.do"/>"><spring:message code='menu.cntc.patent'/></a></li>
							</c:if>
							<c:if test="${r2Conf['adm.rms.io.techtrans'] eq '3' }">
								<li><a href="<c:url value="/techtransCntc/techTarget.do"/>"><spring:message code='menu.cntc.techtrans'/></a></li>
							</c:if>
							<c:if test="${r2Conf['adm.rms.io.kri'] eq '3' }">
								<li><a href="<c:url value="/kriCntc/kriTarget.do"/>"><spring:message code='menu.cntc.kri'/></a></li>
							</c:if>
							<c:if test="${r2Conf['adm.rms.io.tc'] eq '3' }">
								<li><a href="<c:url value="/tcUpdate/tcUpdatePage.do"/>">TC업데이트</a></li>
							</c:if>
							<c:if test="${r2Conf['adm.rms.extrl.rid'] eq '3' }">
								<li><a href="<c:url value="/auth/user/ridMgt.do"/>">RID관리</a></li>
							</c:if>
							<c:if test="${r2Conf['adm.rms.history.extrl'] eq '3' }">
								<li><a href="<c:url value="/syncExtrl/syncHistPage.do"/>"><spring:message code='menu.cntc.syncextrl'/></a></li>
							</c:if>
							<c:if test="${r2Conf['adm.rms.history.email'] eq '3' }">
								<li><a href="<c:url value="/mail/mailHist.do"/>">메일이력/템플릿</a></li>
							</c:if>
						</ul>
					</div>
				</li>
			</c:if>
			<c:if test="${not dSessMode and (sessionScope.auth.adminDvsCd eq 'M' or sessionScope.auth.adminDvsCd eq 'P') }">
				<li class="menu">
					<a href="#" class="nav_menu_a">데이터반입</a>
					<div class="sub_menu" style="display: none;">
						<ul style="display: none;">
							<c:if test="${r2Conf['adm.exr.atcl.wos'] eq '3' }">
								<li><a href="<c:url value="/import/wosImport.do"/>"><spring:message code="menu.wos.import"/></a></li>
								<c:if test="${r2Conf['adm.exr.imp.wos.webservice'] eq '3' }">
									<li><a href="<c:url value="/import/wosImportByApi.do"/>">WOS 반입(웹서비스)</a></li>
								</c:if>
								<li><a href="<c:url value="/workbench/wosArtclWbPage.do"/>"><spring:message code="menu.wos.identify"/></a></li>
							</c:if>
							<c:if test="${r2Conf['adm.exr.atcl.scp'] eq '3' }">
								<li><a href="<c:url value="/import/scopusImport.do"/>"><spring:message code="menu.scopus.import"/></a></li>
								<li><a href="<c:url value="/workbench/scpArtclWbPage.do"/>"><spring:message code="menu.scopus.identify"/></a></li>
							</c:if>
							<c:if test="${r2Conf['adm.exr.atcl.kci'] eq '3' }">
								<li><a href="<c:url value="/import/kciImport.do"/>"><spring:message code="menu.kci.import"/></a></li>
								<li><a href="<c:url value="/workbench/kciArtclWbPage.do"/>"><spring:message code="menu.kci.identify"/></a></li>
							</c:if>
							<c:if test="${r2Conf['adm.exr.atcl.kri'] eq '3' }">
								<li><a href="<c:url value="/kriCntc/importTarget.do"/>">KRI 논문반입</a></li>
							</c:if>
							<c:if test="${r2Conf['adm.exr.exp.dplct'] eq '3' }">
								<li><a href="<c:url value="/dplct/dplctPage.do"/>"><spring:message code='menu.article.dplct'/></a></li>
							</c:if>
							<c:if test="${r2Conf['adm.exr.exp.extrc'] eq '3' }">
								<li><a href="<c:url value="/extract/extractPage.do"/>"><spring:message code='menu.article.extract'/></a></li>
							</c:if>
							<c:if test="${r2Conf['adm.exr.exp.revisn'] eq '3' }">
								<li><a href="<c:url value="/revision/revisionPage.do"/>"><spring:message code='menu.article.revision'/></a></li>
							</c:if>
						</ul>
					</div>
				</li>
			</c:if>
			<c:if test="${not dSessMode and sessionScope.auth.adminDvsCd eq 'M'}">
				<li class="menu">
					<a href="#" class="nav_menu_a"><spring:message code='menu.env'/></a>
					<div class="sub_menu" style="display: none;">
						<ul style="display: none;">
							<c:if test="${r2Conf['adm.env.code.code'] eq '3' }">
								<li><a href="<c:url value="/code/code.do"/>"><spring:message code='menu.code'/></a></li>
							</c:if>
							<c:if test="${r2Conf['adm.env.code.captin'] eq '3' }">
								<li><a href="<c:url value="/i18n/message.do"/>"><spring:message code='menu.language'/></a></li>
							</c:if>
							<c:if test="${r2Conf['adm.env.vriabl.rms'] eq '3' }">
								<li><a href="<c:url value="/code/config.do"/>"><spring:message code='menu.variables'/></a></li>
							</c:if>
							<c:if test="${r2Conf['adm.env.user.dept'] eq '3' }">
								<li><a href="<c:url value="/member/authMgt.do"/>"><spring:message code='menu.authority'/></a></li>
							</c:if>
							<c:if test="${r2Conf['adm.env.org.alias'] eq '3' }">
								<li><a href="<c:url value="/orgAlias/comOrgMgt.do"/>"><spring:message code='menu.orgalias'/></a></li>
							</c:if>
							<c:if test="${r2Conf['adm.rms.env.track'] eq '3' }">
								<li><a href="<c:url value="/auth/track/trackMgt.do"/>"><spring:message code='menu.track'/></a></li>
							</c:if>
							<c:if test="${'3' eq '3' }">
								<li><a href="<c:url value="/code/dept/dept.do"/>">학과관리</a></li>
							</c:if>
							<c:if test="${'3' eq '3' }">
								<li><a href="<c:url value="/code/orgChart/orgChart.do"/>">조직관리</a></li>
							</c:if>
							<c:if test="${r2Conf['adm.rms.env.request'] eq '3' }">
								<li><a href="<c:url value="/auth/requestMgt.do"/>"><spring:message code="menu.request.result"/></a></li>
							</c:if>
							<c:if test="${r2Conf['adm.rms.env.userchghst'] eq '3' }">
								<li><a href="<c:url value="/indvdlinfo/userchghstMgt.do"/>">이용자변경이력</a></li>
							</c:if>
							<c:if test="${r2Conf['adm.rms.env.authchghst'] eq '3' }">
								<li><a href="<c:url value="/indvdlinfo/authchghstMgt.do"/>">권한변경이력</a></li>
							</c:if>
							<c:if test="${r2Conf['adm.rms.env.indvdlinfoTrtmnt'] eq '3' }">
								<li><a href="<c:url value="/indvdlinfo/indvdlinfoTrtmntMgt.do"/>">개인정보취급관리</a></li>
							</c:if>
							<c:if test="${r2Conf['adm.rms.env.statistics'] eq '3' }">
								<li><a href="<c:url value="/auth/statistics/statsTemplate.do"/>">통계반출관리</a></li>
							</c:if>
						</ul>
					</div>
				</li>
			</c:if>
			<li class="menu">
				<a href="#" class="nav_menu_a" title="통계및성과활용"><spring:message code='menu.statistics'/></a>
				<div class="menu_last sub_menu" style="display: none;">
					<ul style="display: none;">
						<li><a href="<c:url value='/${dPreUrl}/statistics/article/article.do'/>"><spring:message code='menu.article'/></a></li>
						<li><a href="<c:url value='/${dPreUrl}/statistics/conference/conference.do'/>"><spring:message code='menu.conference'/></a></li>
						<c:if test="${dNotStdn}">
							<li><a href="<c:url value='/${dPreUrl}/statistics/book/book.do'/>"><spring:message code='menu.book'/></a></li>
							<li><a href="<c:url value='/${dPreUrl}/statistics/patent/patent.do'/>"><spring:message code='menu.patent'/></a></li>
							<c:if test="${not dSessMode and sessionScope.auth.adminDvsCd ne 'R' and sessionScope.auth.adminDvsCd ne 'S' }">
								<li><a href="<c:url value='/statistics/conect/conectReport.do'/>"><spring:message code="menu.stats.access.report" /></a></li>
								<li><a href="<c:url value='/statistics/conect/conectLog.do'/>">접속로그분석</a></li>
								<li><a href="<c:url value='/statistics/conect/articleConfirm.do'/>">논문확인현황</a></li>
								<li><a href="<c:url value='/statistics/conect/articleFuning.do'/>">논문사사정보현황</a></li>
								<li><a href="<c:url value='/statistics/output/outputReport.do'/>">성과리포트</a></li>
							</c:if>
							<li><a href="<c:url value='/${dPreUrl}/statistics/funding/funding.do'/>"><spring:message code='menu.funding.report'/></a></li>
							<c:if test="${sessionScope.sess_user.gubun eq 'M' and (dSessMode or (sessionScope.auth.adminDvsCd eq 'R' or sessionScope.auth.adminDvsCd eq 'S'))}">
								<%-- 세션모드(관리자), 연구자, 대리입력자접속했을때 대상자가 전임일 경우만 확인 가능 --%>
								<li><a href="<c:url value='/${dPreUrl}/statistics/report/review/integReport.do'/>"><spring:message code='menu.report.integ'/></a></li>
							</c:if>
						</c:if>
					</ul>
				</div>
			</li>
			<c:if test="${dNotStdn}">
				<li class="right_nav"><a href="#" class="nav_menu_a" title="성과분석"><spring:message code='menu.output.analysis'/></a>
					<div class="sub_menu" style="display: none;">
						<ul style="display: none;">
							<li><a href="javascript:moveSolution('${pageContext.request.contextPath}/index/${dPreUrl}/goAsRIMS.do?gubun=M','ASRIMS');">RIMS Analysis</a></li>
							<li><a href="<c:url value="/share/user/main.do"/>">RIMS Discovery</a></li>
							<li><a href="/selca/" target="_blank">SelCA</a></li>
							<!--
							<li><a href="#">Research Performances</a></li>
							-->
							<c:if test="${sessionScope.auth.userId eq '00081582' or sessionScope.auth.userId eq '1585' or sessionScope.auth.userId eq '29368' or sessionScope.auth.userId eq '28222' }">
								<li><a href="javascript:void(0);" onclick="fn_searchResearcherPopup();">Prototype</a></li>
							</c:if>
							<c:if test="${not dSessMode and sessionScope.auth.adminDvsCd eq 'M'}">
								<li><a href="<c:url value="/${dPreUrl}/hcp/hcpFieldPage.do"/>">HCPapers</a></li>
							</c:if>
						</ul>
					</div>
				</li>
			</c:if>
		</ul>
	</div>
	<div class="gnb_bg" style="display: none; height:300px;"><div class="bg_wrap"></div></div>
</div>
<div class="content_inner">
	<decorator:body />
</div>
<form name="popFrm" id="popFrm" method="post"></form>
<div id="modal_area" class="overlay" style="display: none;"></div>
<div id="resumeDialog" class="popup_box modal modal_layer" style="width: 500px;height:480px; display: none;">
	<form id="resumeFrm">
		<input type="hidden" name="userId" value="${sessionScope.sess_user.userId}" />
		<input type="hidden" name="type" id="resumeType" value="" />
		<div class="popup_header">
			<h3>Resume Download</h3>
			<a href="#" id="closeBtn" class="close_bt closeBtn">닫기</a>
		</div>
		<div class="popup_inner">
			<div id="resume_tabs" class="tab_wrap">
				<ul>
					<li><a href="#resume_tabs-1"><spring:message code="resume.tab.resume"/></a></li>
					<c:if test="${not empty sysConf['export.research.plan'] and sysConf['export.research.plan'] eq 'Y'}">
					<li><a href="#resume_tabs-2"><spring:message code="resume.tab.plan"/></a></li>
					</c:if>
				</ul>
				<div id="resume_tabs-1">
					<table class="write_tbl mgb_20" style="border-top: 1px;">
						<colgroup>
							<col style="width:26%;" />
							<col style="width:37%;" />
							<col style="width:37%;" />
						</colgroup>
						<tbody>
						<tr>
							<th rowspan="2"><spring:message code="resume.select.output"/></th>
							<td colspan="2">
								<input type="checkbox" id="chk_all" name="chk_all" class="radio" onclick="javascript:if($(this).prop('checked')){$('.chk_rslt').prop('checked',true);}else{$('.chk_rslt').prop('checked',false);}"/>
								<label for="chk_all" class="radio_label"><spring:message code="resume.chk"/></label>
							</td>
						</tr>
						<tr>
							<td>
								<input type="checkbox" id="resume_art" name="gubun" value="article" class="chk_rslt radio"/>
								<label for="resume_art" class="radio_label"><spring:message code="resume.art"/></label>
								<div style="margin-bottom: 10px;"></div>
								<input type="checkbox" id="resume_con" name="gubun" value="conference" class="chk_rslt radio"/>
								<label for="resume_con" class="radio_label"><spring:message code="resume.con"/></label>
								<div style="margin-bottom: 10px;"></div>
								<input type="checkbox" id="resume_book" name="gubun" value="book" class="chk_rslt radio"/>
								<label for="resume_book" class="radio_label"><spring:message code="resume.book"/></label>
								<div style="margin-bottom: 10px;"></div>
								<input type="checkbox" id="resume_pat" name="gubun" value="patent" class="chk_rslt radio"/>
								<label for="resume_pat" class="radio_label"><spring:message code="resume.pat"/></label>
								<div style="margin-bottom: 10px;"></div>
								<input type="checkbox" id="resume_tech" name="gubun" value="techtrans" class="chk_rslt radio"/>
								<label for="resume_tech" class="radio_label"><spring:message code="resume.tech"/></label>
								<div style="margin-bottom: 10px;"></div>
								<input type="checkbox" id="resume_car" name="gubun" value="career" class="chk_rslt radio"/>
								<label for="resume_car" class="radio_label"><spring:message code="resume.car"/></label>
								<div style="margin-bottom: 10px;"></div>
								<input type="checkbox" id="resume_awd" name="gubun" value="award" class="chk_rslt radio"/>
								<label for="resume_awd" class="radio_label"><spring:message code="resume.awd"/></label>
							</td>
							<td style="vertical-align: top;">
								<input type="checkbox" id="resume_res" name="gubun" value="funding" class="chk_rslt radio"/>
								<label for="resume_res" class="radio_label"><spring:message code="resume.res"/></label>
								<div style="margin-bottom: 10px;"></div>
								<input type="checkbox" id="resume_rep" name="gubun" value="report" class="chk_rslt radio"/>
								<label for="resume_rep" class="radio_label"><spring:message code="resume.rep"/></label>
								<div style="margin-bottom: 10px;"></div>
								<input type="checkbox" id="resume_adv" name="gubun" value="student" class="chk_rslt radio"/>
								<label for="resume_adv" class="radio_label"><spring:message code="resume.adv"/></label>
								<div style="margin-bottom: 10px;"></div>
								<input type="checkbox" id="resume_lect" name="gubun" value="lecture" class="chk_rslt radio"/>
								<label for="resume_lect" class="radio_label"><spring:message code="resume.lect"/></label>
								<div style="margin-bottom: 10px;"></div>
								<input type="checkbox" id="resume_etcr" name="gubun" value="etc" class="chk_rslt radio"/>
								<label for="resume_etcr" class="radio_label"><spring:message code="resume.etcr"/></label>
								<div style="margin-bottom: 10px;"></div>
								<input type="checkbox" id="resume_act" name="gubun" value="activity" class="chk_rslt radio"/>
								<label for="resume_act" class="radio_label"><spring:message code="resume.act"/></label>
							</td>
						</tr>
						<tr>
							<th><spring:message code="resume.limit.year"/></th>
							<td colspan="2">
								<input type="text" id="sttDate" name="sttDate" class="input2"  maxlength="4" style="width: 80px;"/>
								~ <input type="text" id="endDate" name="endDate" class="input2" maxlength="4" style="width: 80px;"/>
								<input type="checkbox" name="isAccept" id="isAccept" value="true" class="radio"/>
								<label for="isAccept" class="radio_label"><spring:message code='search.art9'/></label>
							</td>
						</tr>
						<tr>
							<th><spring:message code="resume.include.basicinfo"/></th>
							<td colspan="2">
								<input type="radio" id="basicInfoInclsAt_Y" name="basicInfoInclsAt" value="Y" checked="checked" class="radio"/>
								<label for="basicInfoInclsAt_Y" class="radio_label"><spring:message code='common.radio.yes' /></label>&nbsp;&nbsp;
								<input type="radio" id="basicInfoInclsAt_N" name="basicInfoInclsAt" value="N" class="radio" />
								<label for="basicInfoInclsAt_N" class="radio_label"><spring:message code='common.radio.no'/></label>
							</td>
						</tr>
						<tr>
							<th><spring:message code="resume.include.photo"/></th>
							<td colspan="2">
								<input type="radio" id="proflImageInclsAt_Y" name="proflImageInclsAt" value="Y" checked="checked" class="radio"/>
								<label for="proflImageInclsAt_Y" class="radio_label"><spring:message code='common.radio.yes' /></label>&nbsp;&nbsp;
								<input type="radio" id="proflImageInclsAt_N" name="proflImageInclsAt" value="N" class="radio"/>
								<label for="proflImageInclsAt_N" class="radio_label"><spring:message code='common.radio.no' /></label>
							</td>
						</tr>
						</tbody>
					</table>
					<div class="list_set">
						<ul>
							<li><a href="javascript:$('#resumeType').val('word');fn_resume();" class="list_icon24">WORD Download</a></li>
							<li><a href="javascript:$('#resumeType').val('pdf');fn_resume();" class="list_icon23">PDF Download</a></li>
						</ul>
					</div>
				</div>
				<c:if test="${not empty sysConf['export.research.plan'] and sysConf['export.research.plan'] eq 'Y'}">
				<div id="resume_tabs-2">
					<table class="write_tbl mgb_20" style="border-top: 1px;">
						<colgroup>
							<col style="width:26%;" />
							<col style="width:37%;" />
							<col style="width:37%;" />
						</colgroup>
						<tbody>
							<tr>
								<th><spring:message code="resume.plan.stdr.year"/></th>
								<td colspan="2">
									<input type="text" name="stdrYear" id="hml_stdr_year" value="" class="input_type" style="width: 50%;"/>
									<p><spring:message code="resume.plan.stdr.year.cmmt"/></p>
								</td>
							</tr>
							<tr>
								<th><spring:message code="resume.plan.term"/></th>
								<td colspan="2">
									<p>
									<input type="radio" name="trgetOutput"  id="2year_output" value="2Y" class="radio" checked="checked" onclick="toggleIsReprsntRadio('disabled');"/>
									<label for="2year_output" class="radio_label"><spring:message code="resume.plan.term.2year"/></label>
									</p>
									<p style="margin-top: 5px;">
									<input type="radio" name="trgetOutput"  id="5year_output" value="5Y" class="radio" onclick="toggleIsReprsntRadio('none');"/>
									<label for="5year_output" class="radio_label"><spring:message code="resume.plan.term.5year"/></label>
									</p>
								</td>
							</tr>
							<tr>
								<th><spring:message code="resume.plan.range"/></th>
								<td colspan="2">
									<p>
									<input type="radio" name="isReprsnt"  id="isReprsnt_all" value="" class="radio" checked="checked" disabled="disabled"/>
									<label for="isReprsnt_all" class="radio_label"><spring:message code="resume.plan.range.all"/></label>
									</p>
									<p style="margin-top: 5px;">
									<input type="radio" name="isReprsnt"  id="isReprsnt_y" value="Y" class="radio" disabled="disabled"/>
									<label for="isReprsnt_y" class="radio_label"><spring:message code="resume.plan.range.reprsnt"/></label>
									</p>
								</td>
							</tr>
							<tr>
								<th><spring:message code="resume.plan.contents"/></th>
								<td colspan="2">
									<ul>
										<li style="color: mediumblue;"><spring:message code="resume.plan.userinfo"/></li>
										<li style="margin-top: 3px;color: mediumblue;"><spring:message code="resume.plan.degree"/></li>
										<li style="margin-top: 3px;color: mediumblue;"><spring:message code="resume.plan.career"/></li>
										<li style="margin-top: 3px;color: mediumblue;"><spring:message code="resume.plan.award"/></li>
										<li style="margin-top: 3px;color: mediumblue;"><spring:message code="resume.plan.article"/></li>
										<li style="margin-top: 3px;color: mediumblue;"><spring:message code="resume.plan.conference"/></li>
										<li style="margin-top: 3px;color: mediumblue;"><spring:message code="resume.plan.patent"/></li>
										<li style="margin-top: 3px;color: mediumblue;"><spring:message code="resume.plan.book"/></li>
									</ul>
								</td>
							</tr>
						</tbody>
					</table>
						<div class="list_set">
							<ul>
								<li><a href="javascript:$('#resumeType').val('hwp');fn_resume();" class="list_icon25">HWP Download</a></li>
							</ul>
						</div>
				</div>
				</c:if>
			</div>
		</div>
	</form>
</div>
<c:if test="${sessionScope.auth.adminDvsCd ne 'R' and sessionScope.auth.infoPrtcAgreAt ne 'Y' }">
	<script type="text/javascript">
        $(document).ready(function(){bindModalLink(); var infoPrtcAgreAt = '${sessionScope.auth.infoPrtcAgreAt}'; if(infoPrtcAgreAt == 'N') $('#infoPrtcAgreBtn').triggerHandler('click');});
        function clickInfoPrtcArge(){
            $.post("<c:url value="/member/argeeInfoPrtc.do"/>", null,null,'text').done(function(data){ $('#infoPrtcAgreDialog #closeBtn').triggerHandler('click'); });
        }
	</script>
	<a href="#infoPrtcAgreDialog" id="infoPrtcAgreBtn" class="modalLink quick_icon04" style="display: none;">개인정보보호동의</a>
	<div id="infoPrtcAgreDialog" class="popup_box modal modal_layer" style="width: 500px;height:280px; display: none;">
		<div class="popup_header">
			<h3>개인정보보호법에 따른 개인정보 준수 안내</h3>
			<a href="#" id="closeBtn" class="close_bt closeBtn">닫기</a>
		</div>
		<div class="popup_inner">
			<div id="content" style="margin-top:20px;">
				<div style="font-weight:bold; font-size:13px; width:392px; height:90px; border:1px solid #cacaca; margin:auto; text-align:center; line-height:26px; padding-top:8px;">
					본인은 RIMS 연구성과정보를 "개인정보보호법"에 관한 법률에<br />
					따라 교육 및 연구 업무 등의 목적으로만 시스템을 사용할<br />
					것이며, 개인정보보호법을 준수하겠습니다.
				</div>
				<div style="text-align:center; margin-top:10px; padding-bottom:10px;">
					<label>
						<input type="checkbox" onclick="clickInfoPrtcArge();" style="margin-right:3px; vertical-align:middle;" />동의함
					</label>
				</div>
			</div>
			<div class="list_set">
				<ul>
					<li><a href="javascript:$('#infoPrtcAgreDialog #closeBtn').triggerHandler('click');" class="list_icon10">닫기</a></li>
				</ul>
			</div>
		</div>
	</div>
</c:if>
</body>

</html>
