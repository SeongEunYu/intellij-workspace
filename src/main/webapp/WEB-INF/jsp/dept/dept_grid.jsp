<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8"
    pageEncoding="UTF-8"%><%@
    page import="java.util.Map"%><%@
		page import="java.util.List"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fn" uri="/WEB-INF/tld/fn.tld" %>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld" %>
<%@ taglib prefix="rims" uri="/WEB-INF/tld/rims.tld" %>
<rows>
	<c:if test="${not empty deptList and not empty clgList}">
		<row open="1" id="root_1">
			<cell>KAIST</cell>
			<c:forEach items="${clgList}" var="clg">
				<row id="clg_${clg.clgCode}">
					<cell>${clg.clgNm}</cell>
					<cell><![CDATA[${clg.clgNmEng}]]></cell>
					<cell>${clg.dispOrder}</cell>
					<cell/>
					<cell/>
					<cell/>
					<cell>${clg.clgCode}</cell>
					<cell>${clg.isUsed}</cell>
					<c:forEach items="${deptList}" var="dept" varStatus="idx">
						<c:if test="${clg.clgCode eq dept.clgCode}">
							<row id='dept_${dept.deptCode}' parent="${dept.clgCode}">
								<cell>${dept.deptKorNm}</cell>
								<cell><![CDATA[${dept.deptEngNm}]]></cell>
								<cell>${dept.dispOrder}</cell>
								<cell><![CDATA[${dept.deptEngAbbr}]]></cell>
								<cell><![CDATA[${dept.deptEngMostAbbr}]]></cell>
								<cell>${dept.drhfEmpNm}</cell>
								<cell>${dept.deptCode}</cell>
								<cell>${dept.isUsed}</cell>
								<cell>${dept.drhfEmpId}</cell>
							</row>
						</c:if>
					</c:forEach>
				</row>
			</c:forEach>
		</row>
	</c:if>
	<c:if test="${empty deptList or empty clgList}">
		<row colspan="3">no result! try again</row>
	</c:if>
</rows>