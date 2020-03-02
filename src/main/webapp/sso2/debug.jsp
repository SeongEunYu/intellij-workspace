<%@ page import = "java.io.*, javax.servlet.*, java.util.*, javax.servlet.http.*" %>
<html>
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html;CHARSET=UTF-8">
<META HTTP-EQUIV="pragma" content="no-cache">

<STYLE TYPE="text/css">
<!--
  A:link { color: "#000080"; }
  A:visited { color: "#000000"; }
BODY 	{ background: teal;
	color: white;
	font-size: 8pt;
	font-family: Verdana, Arial, Helvetica, sans-serif }
P 	{ color: black;
	font-size: 10pt;
	font-family: Verdana, Arial, Helvetica, sans-serif } 
P.redintro	{ color: #ff3300;
	font-size: 9pt;
	line-height: 12pt;
	font-weight: bold;
	font-family: Verdana, Arial, Helvetica, sans-serif } 
P.blueintro	{ color: #0099ff;
	font-size: 9pt;
	line-height: 12pt;
	font-weight: bold;
	font-family: Verdana, Arial, Helvetica, sans-serif } 
P.note 	{ color: black;
	font-size: 8pt;
	font-family: Verdana, Arial, Helvetica, sans-serif } 
..indent 	{ color: black;
	font-size: 10pt;
	text-indent: 15pt;
	font-family: Verdana, Arial, Helvetica, sans-serif } 
H1, H2 { font-size: 13pt; 
	font-weight: bold;
	color: white; 
	font-family: Verdana, Arial, Helvetica, sans-serif }
H3, H4 { font-size: 9pt; 
	font-weight: bold;
	color: white; 
	font-family: Verdana, Arial, Helvetica, sans-serif }
-->

</STYLE>
</head>
<body>
<%

	Enumeration enames = request.getHeaderNames();
%>
<h1> Header Variable List </h1> <br> 

<!-- SSO 로그인 성공 시 기본 파라미터와 협의된 파라미터가 표시되는 부분 -->
<table width="800" border="0" cellspacing="0" cellpadding="0" >
<%	
	while(enames.hasMoreElements()) {
%>
<tr> 
<%
	         String name = (String) enames.nextElement();
        	 String value = request.getHeader(name);
%>
<td>	 <%=name.toUpperCase()%> </td> <td> <%=value%> </td>  
</tr>
<%		 	        	 
         }
%>

</table>

<!--  -->


<!-- 현재 세션에 있는 보여준다...!!! -->
<p>
<h1> Session Variable List </h1> <br> 
<h3>Session Idle Time Out : <%=session.getMaxInactiveInterval()%> </p> </h3>
<%	
	int ssCount = 0;
	
	
	String sessitem="",appItem="";
	out.print("SessionId: " + session.getId() + "<P>");
	String strSesList[]=session.getValueNames();
	
	out.print("List of " + strSesList.length + " items in Session   contents collection:<HR>");
	
		for(Enumeration enum_ses=session.getAttributeNames();enum_ses.hasMoreElements();){
		sessitem = enum_ses.nextElement().toString();
			out.print(sessitem + " : " + session.getAttribute(sessitem).toString()+"<BR>");
		ssCount = ssCount + 1;
	}
%>
<body>
<html>