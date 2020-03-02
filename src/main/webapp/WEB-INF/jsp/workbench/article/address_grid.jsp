<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<c:set var="dhtmlXIconPath" value="${dhtmlXImagePath}icons_${sysConf['dhtmlx.skin']}"/>
<rows>
   <head>
   	<column width="*" type="ro" id="add1" align="center" sort="str"><![CDATA[<div style='text-align:center;font-weight:bold;'>ADD1</div>]]></column>
   	<column width="180" type="co" id="reInst" align="center" sort="str"><![CDATA[<div style='text-align:center;font-weight:bold;'>ORG</div>]]>
   		<c:forEach items="${instList }" var="il" varStatus="idx">
   			<option value="${il.orgName}">${il.orgName}</option>
   		</c:forEach>
   	</column>
   	<column width="50" type="img" id="ref" align="center" sort="str"><![CDATA[<div style='text-align:center;font-weight:bold;'>Ref.</div>]]></column>
   	<column width="180" type="ro" id="reDept" align="center" sort="str"><![CDATA[<div style='text-align:center;font-weight:bold;'>DEPT</div>]]></column>
   	<column width="200" type="ro" id="add2" align="center" sort="str"><![CDATA[<div style='text-align:center;font-weight:bold;'>ADD2</div>]]></column>
   	<column width="200" type="ro" id="add3" align="center" sort="str"><![CDATA[<div style='text-align:center;font-weight:bold;'>ADD3</div>]]></column>
   	<settings>
   		<colwidth>PX</colwidth>
   	</settings>
   </head>
<c:if test="${not empty articleAdresList}">
	<c:forEach items="${articleAdresList}" var="al" varStatus="st">
		<row id="${al.articleId}|${al.adresSeq }">
			<cell>${fn:escapeXml(al.add1)}</cell>
			<cell>${fn:escapeXml(al.reInst)}</cell>
			<cell>${abc}<c:if test="${al.isRefered ne 'Y' and not empty al.reInst}">${dhtmlXIconPath}/new.gif^Add Reference^javascript:addReference("${al.articleId}|${al.adresSeq}");</c:if></cell>
			<cell>${fn:escapeXml(al.reDept)}</cell>
			<cell>${fn:escapeXml(al.add2)}</cell>
			<cell>${fn:escapeXml(al.add3)}</cell>
		</row>
	</c:forEach>
</c:if>
</rows>
