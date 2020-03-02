<%@page import="org.apache.commons.lang.RandomStringUtils"%>
<%@page import="java.util.Date"%>
<%@page import="java.io.File"%>
<%@ page language="java" contentType="application/vnd.ms-excel; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.io.PrintWriter" %>
<%
StringBuffer sbUrl = request.getRequestURL();
String url = "";
if(sbUrl.indexOf(":") != -1 && (request.getServerPort() != 80 && request.getServerPort() != 8080 && request.getServerPort() != 8091)){
	url = sbUrl.substring(0, sbUrl.lastIndexOf(":"));
	url = url + request.getContextPath();	
}else{
	 url = sbUrl.substring(0, sbUrl.lastIndexOf("/"));
	 url = url.substring(0, url.lastIndexOf("/"));
}

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<HTML>
	<HEAD>
		<TITLE></TITLE>
		<META HTTP-EQUIV=Content-Type CONTENT="application/vnd.ms-excel; charset=UTF-8">
		
<style type="text/css" rel="stylesheet">
/* h1 */
h1{
	COLOR: #585858; 
	FONT:normal 23px "NanumGothic","나눔고딕","Malgun Gothic", "맑은 고딕","Dotum";
	TEXT-DECORATION: none;
	LINE-HEIGHT:20px; 
}
h2{
	COLOR: #585858; 
	FONT:normal 20px "NanumGothic","나눔고딕","Malgun Gothic", "맑은 고딕","Dotum";
	TEXT-DECORATION: none;
	LINE-HEIGHT:20px; 
}
h3{
	COLOR: #585858; 
	FONT:normal 17px "NanumGothic","나눔고딕","Malgun Gothic", "맑은 고딕","Dotum";
	TEXT-DECORATION: none;
	LINE-HEIGHT:20px; 
}
h4{
	COLOR: #585858; 
	FONT:normal 14px "NanumGothic","나눔고딕","Malgun Gothic", "맑은 고딕","Dotum";
	TEXT-DECORATION: none;
	LINE-HEIGHT:20px; 
}
/*sub_list*/
.sub_list th{
	padding:5px;
	background-color:#f1f5f9; 
	border:1 dotted #c4cfd7;
	color: #474747; 
	font:bold 12px "NanumGothic","나눔고딕","Malgun Gothic", "맑은 고딕","Dotum";
	text-decoration: none;
	line-height:14px;
}
.sub_list td{
	padding:5px 0 5px 0;
	border:1 dotted #c4cfd7;
	font:normal 12px "NanumGothic","나눔고딕","Malgun Gothic", "맑은 고딕","Dotum";
	text-decoration: none;
	line-height:14px;
}
.sub_list td.center {
	text-align:center;
}
</style>		
		
	</HEAD>
<BODY>
<%  

 	request.setCharacterEncoding("UTF-8");
    //response.reset();   
    //request.setCharacterEncoding("euc-kr");
    response.setContentType("application/vnd.ms-excel; charset:utf-8");
   // response.setHeader("Content-type","application/vnd.ms-excel; charset:utf-8");    
    String fileName =  request.getParameter("fileName");   
    
    long millis=System.currentTimeMillis();
    fileName = fileName.substring(0, fileName.lastIndexOf("."));
    String rndchars=RandomStringUtils.randomAlphanumeric(8);
    String downFileName = fileName + "_" + rndchars + "_" + millis + ".xls";
    
    response.setHeader("Content-disposition","attachment; filename=" + downFileName);   
    //response.setHeader("Content-disposition","attachment; filename=" + fileName);   
  
    PrintWriter op = response.getWriter();   
    String CSV = request.getParameter("tableHTML"); 
    if (CSV == null)   
    {   
        CSV="NO DATA";   
    }
    if (fileName == null)   
	{  
    CSV="NO FILE NAME SPECIFIED";   
	} 
//op.write(CSV);
out.print(CSV);
%>
</BODY>
</HTML>	
