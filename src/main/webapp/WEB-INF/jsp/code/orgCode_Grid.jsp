<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8"
    pageEncoding="UTF-8"%><%@
    page import="java.util.Map"%><%@
    page import="java.util.Iterator"%><%@
    page import="java.util.Set"%><%@
    page import="kr.co.argonet.r2rims.core.code.CodeConfiguration"%><%@
    page import="org.apache.commons.lang3.StringEscapeUtils"%><%@
    page import="org.apache.commons.lang3.ObjectUtils"%><%
	String keyword = (String) request.getAttribute("keyword");
    String[] keywords = ObjectUtils.toString(keyword).split(" ");
    String instName = (String) request.getAttribute("instName");
	Map<String, String> codeOrg = CodeConfiguration.getCode("ORG");
%>
<rows><%
	if (!keyword.equals("")) {
		if (codeOrg != null && codeOrg.size() > 0) {
			Set<String> set = codeOrg.keySet();
			Iterator<String> it = set.iterator();
			String s = "";
			while (it.hasNext()) {
				s = it.next();
				boolean haveKeyword = false;
				for (int i = 0; i < keywords.length; i++) {
					if (ObjectUtils.toString(codeOrg.get(s).toLowerCase()).indexOf(keywords[i].toLowerCase()) != -1) {
						haveKeyword = true;
					} else {
						haveKeyword = false;
						break;
					}
				}
				if (haveKeyword) {
%>
					<row id='<%=s %>_<%=StringEscapeUtils.escapeXml10(codeOrg.get(s)) %>'>
						<cell><%=StringEscapeUtils.escapeXml10(codeOrg.get(s)) %></cell>
					</row><%
				} else if (ObjectUtils.toString(codeOrg.get(s)).indexOf(instName) != -1) {
				%>
					<row id='<%=s %>_<%=StringEscapeUtils.escapeXml10(codeOrg.get(s)) %>'>
						<cell><%=StringEscapeUtils.escapeXml10(codeOrg.get(s)) %></cell>
					</row><%
				}
			}
		}
	}
%>
</rows>