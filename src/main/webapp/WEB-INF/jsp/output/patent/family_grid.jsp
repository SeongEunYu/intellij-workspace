<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%><%@
page import="java.util.List"%><%@
page import="java.text.SimpleDateFormat"%><%@
page import="org.apache.commons.lang3.StringUtils"%><%@
page import="org.apache.commons.lang3.StringEscapeUtils"%><%@
page import="kr.co.argonet.r2rims.core.vo.PatentVo"%><%@
page import="kr.co.argonet.r2rims.core.tag.RimsCumstomTagUtil"%><%
	List<PatentVo> familyList = (List<PatentVo>) request.getAttribute("familyList");
%><?xml version="1.0" encoding="UTF-8"?>
<rows><%
	if (familyList != null && familyList.size() > 0) {
		for (int i = 0; i < familyList.size(); i++) {
	%>
	<row id='<%=familyList.get(i).getPatentId() %>_<%=StringEscapeUtils.escapeXml10(familyList.get(i).getFamilyCode()) %>'>
		<cell><%=familyList.get(i).getPatentId() %></cell>
		<cell><%=StringEscapeUtils.escapeXml10(familyList.get(i).getItlPprRgtNm()) %></cell>
		<cell><%=StringEscapeUtils.escapeXml10(familyList.get(i).getFamilyCode()) %></cell>
	</row><%
		}
	}
	%>
</rows>
