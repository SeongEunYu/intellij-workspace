<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../pageInit.jsp"%>
<div class="contents_menu">
	<div class="menu_box">
		<ul>
			<c:if test="${not empty sessionScope.is_institution and sessionScope.is_institution eq 'Y'}">
				<li><a class="<c:if test="${topNm eq 'institution' }">on</c:if>" href="#" onclick="javascript:$('#topFrm').attr('action','${pageContext.request.contextPath}/analysis/institution/byHindex.do').submit();"><spring:message code="menu.asrms.inst"/></a></li>
			</c:if>
			<c:if test="${not empty sessionScope.is_college and sessionScope.is_college eq 'Y'}">
			<li>
				<c:choose>
					<c:when test="${sessionScope.login_user.adminDvsCd eq 'M' or sessionScope.login_user.adminDvsCd eq 'V'}">
						<a class="<c:if test="${topNm eq 'college' }">on</c:if>" href="#" onclick="javascript:moveGroupSearch('C');">College</a>
					</c:when>
					<c:otherwise>
						<a class="<c:if test="${topNm eq 'college' }">on</c:if>" href="#" onclick="javascript:$('#topFrm').attr('action','${pageContext.request.contextPath}/analysis/college/overview.do').submit();"><spring:message code="menu.asrms.clg"/></a>
					</c:otherwise>
				</c:choose>

			</li>
			</c:if>
			<c:if test="${( not empty sessionScope.is_department and sessionScope.is_department eq 'Y' ) or ( sessionScope.is_track != null and sessionScope.is_track eq 'Y' ) }">
			<li>
				<c:choose>
					<c:when test="${sessionScope.login_user.adminDvsCd eq 'M' or  sessionScope.login_user.adminDvsCd eq 'C' or sessionScope.login_user.adminDvsCd eq 'V'}">
						<c:set var="p"  value="D" /><c:if test="${sessionScope.login_user.adminDvsCd eq 'M'}"><c:set var="p"  value="DT" /></c:if>
						<a class="<c:if test="${topNm eq 'department' }">on</c:if>" href="#" onclick="javascript:moveGroupSearch('${p}');">Department</a>
					</c:when>
					<c:otherwise>
						<a class="<c:if test="${topNm eq 'department'}">on</c:if>" href="#" onclick="javascript:$('#topFrm').attr('action','${pageContext.request.contextPath}/analysis/department/overview.do').submit();"><spring:message code="menu.asrms.dept"/></a>
					</c:otherwise>
				</c:choose>

			</li>
			</c:if>
			<c:if test="${not empty sessionScope.is_researcher and sessionScope.is_researcher eq 'Y'}">
			<li>
				<c:choose>
					<c:when test="${sessionScope.login_user.adminDvsCd eq 'M' or  sessionScope.login_user.adminDvsCd eq 'C' or sessionScope.login_user.adminDvsCd eq 'D' or sessionScope.login_user.adminDvsCd eq 'V' or sessionScope.login_user.adminDvsCd eq 'T'}">
						<a class="<c:if test="${topNm eq 'researcher' }">on</c:if>" href="#"  onclick="javascript:moveResearchSearch();">Researcher</a>
					</c:when>
					<c:otherwise>
						<a class="<c:if test="${topNm eq 'researcher' }">on</c:if>" href="#" onclick="javascript:$('#topFrm').attr('action','${pageContext.request.contextPath}/analysis/researcher/overview.do').submit();"><spring:message code="menu.asrms.rsch"/></a>
					</c:otherwise>
				</c:choose>
			</li>
			</c:if>
			<%--
			<li><a class="<c:if test="${topNm eq 'home' }">on</c:if>" href="#" onclick="javascript:$('#topFrm').attr('action','${pageContext.request.contextPath}/analysis/home/overview.do').submit();"><spring:message code="menu.asrms.about"/></a></li>
			 --%>
		</ul>
	</div>
	<div class="top_member">
		<strong>${sessionScope.login_user.korNm}</strong>
		<%--
		${sessionScope.login_user.userId}
		 --%>
	</div>
</div><!-- 상단 메뉴-->