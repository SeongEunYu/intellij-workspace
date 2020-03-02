<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
  <head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta http-equiv="cache-Control" content="co-cache" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=yes" />
  	<title>${sysConf['system.rss.jsp.title']}</title>
	<%@include file="../pageInit.jsp" %>
	<style type="text/css">
	.nav_wrap {margin-bottom: 40px; height: 42px;}
	<c:if test="${sessMode or (sessionScope.auth.adminDvsCd eq 'R' or  sessionScope.auth.adminDvsCd eq 'S' )}">#gnb .menu{width: 180px;}</c:if>
	</style>
	<script type="text/javascript">
		$(document).ready(function(){
			$('.content_inner').removeClass('content_inner');
			if($.cookie('noticeCheck') != 'done'){
				if($('.notice_top_wrap')) $('.notice_top_wrap').css('display','');
			}
		});
	</script>
  </head>
  <body>
	<c:if test="${sessMode or (sessionScope.auth.adminDvsCd eq 'R' or  sessionScope.auth.adminDvsCd eq 'S')}">
	<div class="my_info_wrap h_fix">
		<div class="my_info_box">
			<table class="my_tbl">
				<tbody>
					<tr>
						<td>
							<div class="my_name_box">
								<c:choose>
									<c:when test="${pageContext.response.locale eq 'ko'}">
										${sessionScope.sess_user.korNm}
									</c:when>
									<c:otherwise>
										<c:if test="${not empty sessionScope.sess_user.lastName}">
											${sessionScope.sess_user.lastName}, ${sessionScope.sess_user.firstName}
										</c:if>
										<c:if test="${empty sessionScope.sess_user.lastName}">
											${sessionScope.sess_user.engNm}
										</c:if>
									</c:otherwise>
								</c:choose>
							</div>
							<div class="my_link_box">
								<c:if test="${not empty idntfrList}">
									<c:forEach items="${idntfrList}" var="id" varStatus="idx">
									   <c:choose>
									   		<c:when test="${id.idntfrSe eq 'RID' and not empty id.idntfr}">
									   			<a href="http://www.researcherid.com/rid/${id.idntfr}" target="_blank" class="my_link link_icon01" title="http://www.researcherid.com/rid/${id.idntfr}">researchID</a>
									   		</c:when>
									   		<c:when test="${id.idntfrSe eq 'RID' and empty id.idntfr}">
									   			<a href="javascript:void(0);" class="my_link link_icon01 disabled_link" onclick="javascript:fn_userPopup('${pageContext.request.contextPath}/${preUrl}/user/researcherIdPopup.do')" >researchID</a>
									   		</c:when>
									   		<c:when test="${id.idntfrSe eq 'ORC' and not empty id.idntfr}">
												<a href="http://orcid.org/${id.idntfr}" target="_blank" class="my_link link_icon04" title="http://orcid.org/${id.idntfr}">Orcid</a>
									   		</c:when>
									   		<c:when test="${id.idntfrSe eq 'ORC' and  empty id.idntfr}">
												<a href="javascript:void(0);" class="my_link link_icon04 disabled_link" onclick="javascript:fn_userPopup('${pageContext.request.contextPath}/${preUrl}/user/researcherIdPopup.do')" >Orcid</a>
									   		</c:when>
									   		<c:when test="${id.idntfrSe eq 'SCP' and not empty id.idntfr}">
												<a href="https://www.scopus.com/authid/detail.uri?authorId=${id.idntfr}" target="_blank" class="my_link link_icon02" title="https://www.scopus.com/authid/detail.uri?authorId=${id.idntfr}">ScopusID</a>
									   		</c:when>
									   		<c:when test="${id.idntfrSe eq 'SCP' and empty id.idntfr}">
												<a href="javascript:void(0);" class="my_link link_icon02 disabled_link" onclick="javascript:fn_userPopup('${pageContext.request.contextPath}/${preUrl}/user/researcherIdPopup.do')" >ScopusID</a>
									   		</c:when>
									   		<c:when test="${id.idntfrSe eq 'RGT' and not empty id.idntfr}">
												<a href="https://www.researchgate.net/profile/${id.idntfr}" target="_blank" class="my_link link_icon05" title="https://www.researchgate.net/profile/${id.idntfr}">ResearcherGate</a>
									   		</c:when>
									   		<c:when test="${id.idntfrSe eq 'RGT' and empty id.idntfr}">
												<a href="javascript:void(0);" class="my_link link_icon05 disabled_link" onclick="javascript:fn_userPopup('${pageContext.request.contextPath}/${preUrl}/user/researcherIdPopup.do')" >ScopusID</a>
									   		</c:when>
									   </c:choose>
									</c:forEach>
								</c:if>
								<%--
								onclick="javascript:fn_userPopup('${pageContext.request.contextPath}/${dPreUrl}/user/researcherIdPopup.do')"
								 --%>
							</div>
							<c:if test="${r2Conf['usr.rims.info.lab'] eq '3'}">
								<div class="my_box">
									<a href="javascript:void(0);" onclick="javascript:fn_labPopup();" class="lab_link">My Lab</a>
								</div>
							</c:if>
							<c:if test="${empty r2Conf['usr.rims.info.lab'] or r2Conf['usr.rims.info.lab'] ne '3'}">
								<c:if test="${not empty sessionScope.sess_user.rid}">
									<div class="my_box">
										<a href="http://www.researcherid.com/rid/${sessionScope.sess_user.rid}" target="_blank" class="researchid_link">My researchID</a>
									</div>
								</c:if>
							</c:if>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div class="top_quick_box">
			<div class="unconfirmed_thesis">
				 <a href="${contextPath}/${preUrl}/article/article.do?appr=app" >
					<em class="uc_num">${empty totRecord.extArtCnt ? '0' : totRecord.extArtCnt}</em>
					<em><spring:message code="art.unconfirm.cnt"/></em>
				</a>
			</div>
			<ul>
				<c:if test="${notStdn and sessionScope.auth.adminDvsCd ne 'S' and sessionScope.auth.adminDvsCd ne 'V'}">
				<li><a href="<c:url value='/${preUrl}/member/agncy.do'/>" class="quick_icon01"><spring:message code="menu.assistant.mgt"/></a></li>
				</c:if>
				<c:if test="${not notStdn or sessionScope.auth.adminDvsCd eq 'S' or sessionScope.auth.adminDvsCd eq 'V'}">
				<li class="disabled_li"><a href="javascript:void(0);" class="quick_icon01"><spring:message code="menu.assistant.mgt"/></a></li>
				</c:if>
				<li><a href="${contextPath}/${preUrl}/article/highlycited.do" class="quick_icon02">MY HIGHLY CITED</a></li>
				<li><a href="${contextPath}/${preUrl}/statistics/article/article.do" class="quick_icon03"><spring:message code="main.menu.statistics.article"/></a></li>
				<c:if test="${notStdn}">
					<li><a href="#resumeDialog" class="modalLink quick_icon04"><spring:message code="menu.resume"/></a></li>
					<li><a href="javascript:moveSolution('${pageContext.request.contextPath}/index/${preUrl}/goAsRIMS.do?gubun=M','ASRIMS');" class="quick_icon05"><spring:message code="menu.asrims"/></a></li>
				</c:if>
				<c:if test="${not notStdn}">
					<li class="disabled_li"><a href="javascript:void(0);" class="quick_icon04"><spring:message code="menu.resume"/></a></li>
					<li class="disabled_li"><a href="javascript:void(0);" class="quick_icon05"><spring:message code="menu.asrims"/></a></li>
				</c:if>
			</ul>
		</div>
	</div><!-- my_info_wrap : e -->
	<script type="text/javascript">$(document).ready(function(){bindModalLink();});</script>
	</c:if>
	<c:if test="${not sessMode and sessionScope.auth.adminDvsCd ne 'R' and  sessionScope.auth.adminDvsCd ne 'S'}">
		<div class="my_info_wrap h_fix">
			<div class="my_info_box admin_info">
				<table class="my_tbl">
				<tbody>
				<tr>
				<td>
					<div class="my_name_box">${sessionScope.login_user.korNm}</div>
				 	<div class="my_box">
				 	<a href="#" class="">
				 		<c:choose>
				 			<c:when test="${sessionScope.auth.adminDvsCd eq 'M' }">관리자</c:when>
				 			<c:when test="${sessionScope.auth.adminDvsCd eq 'D' }">학과관리자</c:when>
				 			<c:when test="${sessionScope.auth.adminDvsCd eq 'C' }">단과대관리자</c:when>
				 			<c:when test="${sessionScope.auth.adminDvsCd eq 'T' }">트랙관리자</c:when>
				 			<c:when test="${sessionScope.auth.adminDvsCd eq 'P' }">성과관리자</c:when>
				 			<c:when test="${sessionScope.auth.adminDvsCd eq 'V' }">성과열람자</c:when>
				 			<c:otherwise>Unknown Authority</c:otherwise>
				 		</c:choose>
				 	</a>
				 	</div>
				</td>
				</tr>
				</tbody>
				</table>
			</div>
			<div class="top_quick_box">
				<ul>
				<li class="br_none"><a href="<c:url value='/article/latest.do'/>" class="quick_icon09">최신논문</a></li>
				<li><a href="<c:url value='/statistics/conect/conectReport.do'/>" class="quick_icon06">로그인현황</a></li>
				<li><a href="<c:url value='/statistics/conect/articleConfirm.do'/>" class="quick_icon07">논문확인현황</a></li>
				<li><a href="<c:url value='/statistics/conect/articleFuning.do'/>" class="quick_icon08">논문사사정보현황</a></li>
				<li><a href="<c:url value='/${preUrl}/statistics/article/article.do'/>" class="quick_icon03">논문통계</a></li>
				<li><a href="javascript:moveSolution('${pageContext.request.contextPath}/index/${preUrl}/goAsRIMS.do?gubun=M','ASRIMS');" class="quick_icon05">성과분석</a></li>
				</ul>

			</div>
		</div><!-- my_info_wrap : e -->
	</c:if>
	<div class="research_quick_wrap">
		<div class="research_quick_inner">
			<ul class="research_quick_list">
				<c:if test="${not sessMode and sessionScope.auth.adminDvsCd ne 'R' and  sessionScope.auth.adminDvsCd ne 'S' }">
					<c:if test="${sessionScope.auth.adminDvsCd eq 'M' or  sessionScope.auth.user_user eq '1' }">
						<li>
							<a href="${pageContext.request.contextPath}/auth/user/user.do"><span class="rq_icon01">연구자관리</span></a>
						</li>
					</c:if>
					<c:if test="${sessionScope.auth.adminDvsCd ne 'M' and  sessionScope.auth.user_user ne '1'}">
						<li class="disabled_li">
							<a href="javascript:void(0);"><span class="rq_icon01">연구자관리</span><em></em></a>
						</li>
					</c:if>
				</c:if>
				<c:if test="${sessMode or (sessionScope.auth.adminDvsCd eq 'R' or  sessionScope.auth.adminDvsCd eq 'S' )}">
					<li>
						<a href="javascript:void(0);" onclick="javascript:fn_userPopup('${contextPath}/${preUrl}/user/userPopup.do')"><span class="rq_icon01"><spring:message code='main.user'/></span>
					    <c:if test="${notStdn and not empty userInputTrgetCo and userInputTrgetCo ne 0 }"><p class="badge_num"><em title="<spring:message code='main.performance.alert.msg'/>">${userInputTrgetCo}</em></p></c:if>
						</a>
					</li>
				</c:if>
				<c:choose>
					<c:when test="${r2Conf['adm.rms.rslt.atcl'] eq '3' and sessionScope.auth.ART gt 0}">
						<li>
							<a href="${contextPath}/${preUrl}/article/article.do"><span class="rq_icon02"><spring:message code='menu.article'/></span>
								<em>(<c:if test="${not sessMode and sessionScope.auth.adminDvsCd ne 'R' and  sessionScope.auth.adminDvsCd ne 'S' }"><font style="color: red;"><fmt:formatNumber value="${totRecord.articleCnt}"/></font>/</c:if><fmt:formatNumber value="${totRecord.articleTotal}"/>)</em>
								<c:if test="${notStdn and (sessMode or (sessionScope.auth.adminDvsCd eq 'R' or sessionScope.auth.adminDvsCd eq 'S' ) and not empty totRecord.extArtCnt and totRecord.extArtCnt ne '0' )}">
									<p class="badge_num"><em title="<spring:message code='main.performance.alert.msg'/>">${totRecord.extArtCnt}</em></p>
								</c:if>
							</a>
						</li>
					</c:when>
					<c:otherwise>
						<li class="disabled_li">
							<a href="javascript:void(0);"><span class="rq_icon02"><spring:message code='menu.article'/></span><em></em></a>
						</li>
					</c:otherwise>
				</c:choose>
				<c:choose>
					<c:when test="${r2Conf['adm.rms.rslt.porcd'] eq '3' and sessionScope.auth.CON gt 0}">
						<li>
							<a href="${contextPath}/${preUrl}/conference/conference.do"><span class="rq_icon03"><spring:message code='menu.conference'/></span>
							    <em>(<c:if test="${not sessMode and sessionScope.auth.adminDvsCd ne 'R' and  sessionScope.auth.adminDvsCd ne 'S' }"><font style="color: red;"><fmt:formatNumber value="${totRecord.conCnt}"/></font>/</c:if><fmt:formatNumber value="${totRecord.conTotal}"/>)</em>
							</a>
						</li>
					</c:when>
					<c:otherwise>
						<li class="disabled_li">
							<a href="javascript:void(0);"><span class="rq_icon03"><spring:message code='menu.conference'/></span><em></em></a>
						</li>
					</c:otherwise>
				</c:choose>
				<c:choose>
					<c:when test="${r2Conf['adm.rms.rslt.book'] eq '3' and sessionScope.auth.BOOK gt 0 and notStdn}">
						<li>
							<a href="${contextPath}/${preUrl}/book/book.do"><span class="rq_icon04"><spring:message code='menu.book'/></span>
							    <em>(<c:if test="${not sessMode and sessionScope.auth.adminDvsCd ne 'R' and  sessionScope.auth.adminDvsCd ne 'S' }"><font style="color: red;"><fmt:formatNumber value="${totRecord.bookCnt}"/></font>/</c:if><fmt:formatNumber value="${totRecord.bookTotal}"/>)</em>
							</a>
						</li>
					</c:when>
					<c:otherwise>
						<li class="disabled_li">
							<a href="javascript:void(0);"><span class="rq_icon04"><spring:message code='menu.book'/></span><em></em></a>
						</li>
					</c:otherwise>
				</c:choose>
				<c:choose>
					<c:when test="${r2Conf['adm.rms.rslt.rsrch'] eq '3' and sessionScope.auth.FUD gt 0 and notStdn }">
						<li>
							<a href="${contextPath}/${preUrl}/funding/funding.do"><span class="rq_icon05"><spring:message code='menu.funding'/></span>
								<em>(<c:if test="${not sessMode and sessionScope.auth.adminDvsCd ne 'R' and  sessionScope.auth.adminDvsCd ne 'S' }"><font style="color: red;"><fmt:formatNumber value="${totRecord.fundingCnt}"/></font>/</c:if><fmt:formatNumber value="${totRecord.fundingTotal}"/>)</em>
							</a>
						</li>
					</c:when>
					<c:otherwise>
						<li class="disabled_li">
							<a href="javascript:void(0);"><span class="rq_icon05"><spring:message code='menu.funding'/></span><em></em></a>
						</li>
					</c:otherwise>
				</c:choose>
				<c:choose>
					<c:when test="${r2Conf['adm.rms.rslt.report'] eq '3' and sessionScope.auth.RPT gt 0 and notStdn}">
						<li class="last_li">
							<a href="${contextPath}/${preUrl}/report/report.do"><span class="rq_icon06"><spring:message code='menu.report'/></span>
							    <em>(<c:if test="${not sessMode and sessionScope.auth.adminDvsCd ne 'R' and  sessionScope.auth.adminDvsCd ne 'S' }"><font style="color: red;"><fmt:formatNumber value="${totRecord.reportCnt}"/></font>/</c:if><fmt:formatNumber value="${totRecord.reportTotal}"/>)</em>
							</a>
						</li>
					</c:when>
					<c:otherwise>
						<li class="last_li disabled_li">
							<a href="javascript:void(0);"><span class="rq_icon06"><spring:message code='menu.report'/></span><em></em></a>
						</li>
					</c:otherwise>
				</c:choose>
				<c:choose>
					<c:when test="${r2Conf['adm.rms.rslt.pat'] eq '3' and sessionScope.auth.PAT gt 0 and notStdn}">
						<li>
							<a href="${contextPath}/${preUrl}/patent/patent.do"><span class="rq_icon07"><spring:message code='menu.patent'/></span>
							   <em>(<c:if test="${not sessMode and sessionScope.auth.adminDvsCd ne 'R' and  sessionScope.auth.adminDvsCd ne 'S' }"><font style="color: red;"><fmt:formatNumber value="${totRecord.patentCnt}"/></font>/</c:if><fmt:formatNumber value="${totRecord.patentTotal}"/>)</em>
							</a>
						</li>
					</c:when>
					<c:otherwise>
						<li class="disabled_li">
							<a href="javascript:void(0);"><span class="rq_icon07"><spring:message code='menu.patent'/></span><em></em></a>
						</li>
					</c:otherwise>
				</c:choose>
				<c:choose>
					<c:when test="${r2Conf['adm.rms.rslt.tech'] eq '3' and sessionScope.auth.TECH gt 0 and notStdn}">
						<li>
							<a href="${contextPath}/${preUrl}/techtrans/techtrans.do"><span class="rq_icon08"><spring:message code='menu.techtrans'/></span>
								<em>(<c:if test="${not sessMode and sessionScope.auth.adminDvsCd ne 'R' and  sessionScope.auth.adminDvsCd ne 'S' }"><font style="color: red;"><fmt:formatNumber value="${totRecord.techtransCnt}"/></font>/</c:if><fmt:formatNumber value="${totRecord.techtransTotal}"/>)</em>
							</a>
						</li>
					</c:when>
					<c:otherwise>
						<li class="disabled_li">
							<a href="javascript:void(0);"><span class="rq_icon08"><spring:message code='menu.techtrans'/></span><em></em></a>
						</li>
					</c:otherwise>
				</c:choose>
				<c:choose>
					<c:when test="${r2Conf['adm.rms.rslt.exbi'] eq '3' and sessionScope.auth.EXHI gt 0 and notStdn }">
						<li>
							<a href="${contextPath}/${preUrl}/exhibition/exhibition.do"><span class="rq_icon11"><spring:message code='menu.exhibition'/></span>
								<em>(<c:if test="${not sessMode and sessionScope.auth.adminDvsCd ne 'R' and  sessionScope.auth.adminDvsCd ne 'S' }"><font style="color: red;"><fmt:formatNumber value="${totRecord.exhCnt}"/></font>/</c:if><fmt:formatNumber value="${totRecord.exhTotal}"/>)</em>
							</a>
						</li>
					</c:when>
					<c:otherwise>
						<li class="disabled_li">
							<a href="javascript:void(0);"><span class="rq_icon11"><spring:message code='menu.exhibition'/></span><em></em></a>
						</li>
					</c:otherwise>
				</c:choose>
				<c:choose>
					<c:when test="${r2Conf['adm.rms.rslt.etc'] eq '3' and sessionScope.auth.ETC gt 0 and  notStdn}">
						<li>
							<a href="${contextPath}/${preUrl}/etc/etc.do"><span class="rq_icon10"><spring:message code='menu.etc'/></span><em>(<fmt:formatNumber value="${totRecord.researchCnt}"/>)</em></a>
						</li>
					</c:when>
					<c:otherwise>
						<li class="disabled_li">
							<a href="javascript:void(0);"><span class="rq_icon10"><spring:message code='menu.etc'/></span><em></em></a>
						</li>
					</c:otherwise>
				</c:choose>
				<c:choose>
					<c:when test="${r2Conf['adm.rms.rslt.etcact'] eq '3' and sessionScope.auth.ACT gt 0 and notStdn }">
						<li>
							<a href="${contextPath}/${preUrl}/activity/activity.do"><span class="rq_icon12"><spring:message code='menu.activity'/></span><em>(<fmt:formatNumber value="${totRecord.activityCnt}"/>)</em></a>
						</li>
					</c:when>
					<c:otherwise>
						<li class="disabled_li">
							<a href="javascript:void(0);"><span class="rq_icon12"><spring:message code='menu.activity'/></span><em></em></a>
						</li>
					</c:otherwise>
				</c:choose>
				<c:choose>
					<c:when test="${r2Conf['adm.rms.rslt.dgri'] eq '3' and sessionScope.auth.DGR gt 0 and  notStdn}">
						<li class="last_li">
							<a href="${contextPath}/${preUrl}/degree/degree.do"><span class="rq_icon09"><spring:message code='menu.degree'/></span><em title="<spring:message code='main.performance.alert.msg'/>">(<fmt:formatNumber value="${totRecord.degreeTotal}"/>)</em>
							<c:if test="${notStdn and (sessMode or (sessionScope.auth.adminDvsCd eq 'R' or  sessionScope.auth.adminDvsCd eq 'S' ))}">
								 <c:if test="${not empty degreeInputTrgetCo and degreeInputTrgetCo ne 0 }"><p class="badge_num"><em title="<spring:message code='main.degree.alert.msg'/>">${degreeInputTrgetCo}</em></p></c:if>
							</c:if>
							</a>
						</li>
					</c:when>
					<c:otherwise>
						<li class="last_li disabled_li">
							<a href="javascript:void(0);"><span class="rq_icon09"><spring:message code='menu.degree'/></span><em></em></a>
						</li>
					</c:otherwise>
				</c:choose>
			</ul>
			<div class="rq_under_box">
				<ul>
				<c:choose>
					<c:when test="${r2Conf['adm.rms.rslt.career'] eq '3' and sessionScope.auth.CAR gt 0 and notStdn}">
						<li><a href="${contextPath}/${preUrl}/career/career.do"><spring:message code='menu.career'/><em>(<fmt:formatNumber value="${totRecord.careerTotal}"/>)</em></a></li>
					</c:when>
					<c:otherwise>
						<li class="disabled_li disabled_first"><a href="javascript:void(0);" class="row_text"><spring:message code='menu.career'/><em></em></a></li>
					</c:otherwise>
				</c:choose>
				<c:choose>
					<c:when test="${r2Conf['adm.rms.rslt.agtc'] eq '3' and sessionScope.auth.AWD gt 0 and notStdn }">
						<li><a href="${contextPath}/${preUrl}/award/award.do"><spring:message code='menu.award'/><em>(<fmt:formatNumber value="${totRecord.awardTotal}"/>)</em></a></c:when>
					<c:otherwise>
						<li class="disabled_li"><a href="javascript:void(0);" class="row_text"><spring:message code='menu.award'/><em></em></a></li>
					</c:otherwise>
				</c:choose>
				<c:choose>
					<c:when test="${r2Conf['adm.rms.rslt.qualf'] eq '3' and sessionScope.auth.LNC gt 0 and notStdn }">
						<li><a href="${contextPath}/${preUrl}/license/license.do"><spring:message code='menu.license'/><em>(<fmt:formatNumber value="${totRecord.licenseTotal}"/>)</em></a></li>
					</c:when>
					<c:otherwise>
						<li class="disabled_li"><a href="javascript:void(0);" class="row_text"><spring:message code='menu.license'/><em></em></a></li>
					</c:otherwise>
				</c:choose>
				<c:choose>
					<c:when test="${r2Conf['adm.rms.rslt.exust'] eq '3' and sessionScope.auth.STD gt 0 and notStdn }">
						<li><a href="${contextPath}/${preUrl}/student/student.do" class="row_text"><spring:message code='menu.student'/></a></li>
					</c:when>
					<c:otherwise>
						<li class="disabled_li"><a href="javascript:void(0);" class="row_text"><spring:message code='menu.student'/></a></li>
					</c:otherwise>
				</c:choose>
				<c:choose>
					<c:when test="${r2Conf['adm.rms.rslt.lecture'] eq '3' and sessionScope.auth.LEC gt 0 and notStdn }">
						<li><a href="${contextPath}/${preUrl}/lecture/lecture.do" class="row_text"><spring:message code='menu.lecture'/></a></li>
					</c:when>
					<c:otherwise>
						<li class="disabled_li"><a href="javascript:void(0);" class="row_text"><spring:message code='menu.lecture'/></a></li>
					</c:otherwise>
				</c:choose>
				<c:choose>
					<c:when test="${r2Conf['adm.rms.rslt.realm'] eq '3' and sessionScope.auth.CATE gt 0 and notStdn}">
						<li class="last_li"><a href="${contextPath}/${preUrl}/rsrchrealm.do" class="row_text"><spring:message code='menu.major'/></a></li>
					</c:when>
					<c:otherwise>
						<li class="disabled_li disabled_last last_li"><a href="javascript:void(0);" class="row_text"><spring:message code='menu.major'/></a></li>
					</c:otherwise>
				</c:choose>
				</ul>
			</div>
		</div>
	</div>

	<div class="footer_banner">
		<ul>
			<li>
				<a href="http://koasas.kaist.ac.kr/" target="_blank"><img src="${contextPath}/images/background/banner_img01.png" alt="KOASAS" /></a>
			</li>
			<li>
				<a href="http://www.scimagojr.com/journalrank.php" target="_blank"><img src="${contextPath}/images/background/banner_img02.png" alt="SJR" /></a>
			</li>
			<li>
				<a href="http://ip-science.thomsonreuters.com/mjl/" target="_blank"><img src="${contextPath}/images/background/banner_img03.png" alt="SCI Journals" /></a>
			</li>
			<li>
				<a href="http://webofknowledge.com" target="_blank"><img src="${contextPath}/images/background/banner_img04.png" alt="WEB OF SCIENCE" /></a>
			</li>
			<li>
				<a href="https://www.kri.go.kr/kri2" target="_blank"><img src="${contextPath}/images/background/banner_img05.png" alt="KRI" /></a>
			</li>
			<li class="last_banner">
				<a href="http://www.researcherid.com/rid/${sessionScope.login_user.ridWos}" target="_blank">
					<img src="${contextPath}/images/background/banner_img06.png" alt="RESEARCHERID" />
				</a>
			</li>
		</ul>
	</div>
	<div class="footer_wrap">
		<div class="footer_inner">
			<dl>
				<dt>Contact</dt>
				<dd>Academic Information Development Team <em class="footer_phone">${sysConf['system.admin.telno']}</em><a href="mailto:${sysConf['system.admin.email']}" class="footer_mail">${sysConf['system.admin.email']}</a></dd>
			</dl>
			<p class="footer_text">Copyright (C) 2018, ${sysConf['inst.name.eng.full']}, All Rights Reserved</p>
		</div>
	</div>
  </body>
</html>
