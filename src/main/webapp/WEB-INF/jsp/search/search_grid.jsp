<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../gridInit.jsp" %>
<rows>
<c:if test="${not empty resultList}">
<c:forEach items="${resultList}" var="rl" varStatus="st">
	<row id="${rl.userId}">
		<cell>${st.count}</cell>
		<cell>${rl.korNm}</cell>
		<cell>${rl.posiNm}</cell>
		<cell>${rl.deptKor}</cell>
		<cell>
			<![CDATA[
				<c:if test="${rl.matchArticleCo eq '0'}">${rl.matchArticleCo}</c:if>
				<c:if test="${rl.matchArticleCo ne '0'}">
				<a href="#dialog" class="modalLink" onclick="matchArticleViewPopup('${rl.userId}','${rl.korNm}','${param.tabName}')">${rl.matchArticleCo}</a>
				</c:if>
				/
				<c:if test="${rl.totArticleCo eq '0'}">${rl.totArticleCo}</c:if>
				<c:if test="${rl.totArticleCo ne '0'}">
				<a href="#dialog" class="modalLink" onclick="totalArticleViewPopup('${rl.userId}','${rl.korNm}')">${rl.totArticleCo}</a>
				</c:if>
			]]>
		</cell>
		<cell>
			<![CDATA[
				<c:if test="${rl.matchPatentCo eq '0'}">${rl.matchPatentCo}</c:if>
				<c:if test="${rl.matchPatentCo ne '0'}">
				<a href="#dialog" class="modalLink" onclick="matchPatentViewPopup('${rl.userId}','${rl.korNm}','${param.tabName}')" title="">${rl.matchPatentCo}</a>
				</c:if>
				/
				<c:if test="${rl.totPatentCo eq '0'}">${rl.totPatentCo}</c:if>
				<c:if test="${rl.totPatentCo ne '0'}">
				<a href="#dialog" class="modalLink" onclick="totalPatentViewPopup('${rl.userId}','${rl.korNm}')" title="">${rl.totPatentCo}</a>
				</c:if>
			]]>
		</cell>
		<cell>
			<![CDATA[
				<c:if test="${rl.matchFundingCo eq '0'}">${rl.matchFundingCo}</c:if>
				<c:if test="${rl.matchFundingCo ne '0'}">
				<a href="#dialog" class="modalLink" onclick="matchFundingViewPopup('${rl.userId}','${rl.korNm}','${param.tabName}')" title="">${rl.matchFundingCo}</a>
				</c:if>
				/
				<c:if test="${rl.totFundingCo eq '0'}">${rl.totFundingCo}</c:if>
				<c:if test="${rl.totFundingCo ne '0'}">
				<a href="#dialog" class="modalLink" onclick="totalFundingViewPopup('${rl.userId}','${rl.korNm}')" title="">${rl.totFundingCo}</a>
				</c:if>
			]]>
		</cell>
		<cell>
			<![CDATA[
				<c:if test="${rl.matchExFundingCo eq '0'}">${rl.matchExFundingCo}</c:if>
				<c:if test="${rl.matchExFundingCo ne '0'}">
				<a href="#dialog" class="modalLink" onclick="matchFundingViewPopup('${rl.userId}','${rl.korNm}','${param.tabName}')" title="">${rl.matchExFundingCo}</a>
				</c:if>
				/
				<c:if test="${rl.totExFundingCo eq '0'}">${rl.totExFundingCo}</c:if>
				<c:if test="${rl.totExFundingCo ne '0'}">
				<a href="#dialog" class="modalLink" onclick="totalExFundingViewPopup('${rl.userId}','${rl.korNm}')" title="">${rl.totExFundingCo}</a>
				</c:if>
			]]>
		</cell>
		<cell>${rl.score}</cell>
		<cell>
			<![CDATA[
				<a href="#dialog" class="in_network_icon" onclick="coAuthorNetworkWithinInstView('${rl.userId}','${rl.korNm}','${param.tabName}')" title="">보기</a>
			]]>
		</cell>
		<cell>
			<![CDATA[
				<a href="#dialog" class="out_network_icon" onclick="coAuthorNetworkWithinOtherInstView('${rl.userId}','${rl.korNm}','${param.tabName}')" title="">보기</a>
			]]>
		</cell>
	</row>
</c:forEach>
</c:if>
<c:if test="${empty resultList}">
	<row id="0">
		<cell colspan="10">No Results. Try Again!</cell>
	</row>
</c:if>
</rows>