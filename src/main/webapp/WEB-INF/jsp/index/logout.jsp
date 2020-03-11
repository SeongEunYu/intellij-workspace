<%@ page import="java.util.List" %>
<%@ page import="java.util.Arrays" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // sso cookie names
    List<String> ssoCookieList = Arrays.asList(
            "InitechEamUID_V42",
            "InitechEamUIP_V42",
            "InitechEamULAT_V42",
            "InitechEamUTOA_V42",
            "InitechEamUPID_V42",
            "InitechEamUHMAC_V42");

    // 쿠키 삭제
    Cookie[] cookies = request.getCookies();
    if(cookies != null){

        for(Cookie c: cookies) {
            String name = c.getName(); // 쿠키 이름 가져오기

            if(ssoCookieList.contains( name ) ) {
                c.setDomain("rss.bwise.kr");
                c.setPath("/");

                c.setMaxAge(0); // 유효시간을 0으로 설정
                response.addCookie(c); // 응답 헤더에 추가
            }

        }

    }


%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<title>${sysConf['system.rss.jsp.title']} Logout</title>
<%@include file="../pageInit.jsp" %>
<link type="text/css" href="${pageContext.request.contextPath}/js/dhtmlx/skins/${sysConf['dhtmlx.skin']}/dhtmlx.css" rel="stylesheet" />
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/dhtmlx/dhtmlx.js"></script>
<script type="text/javascript">
$(document).ready(function()
{
	dhtmlx.alert({type:"alert-error",text:"로그아웃 되었습니다.",callback:function(){
		//document.location.href='https://iam.kaist.ac.kr/iamps/cmm/main/IampsExitSelect.do';
        document.location.href='${sysConf['system.url']}';
	}})
});
</script>
</head>
<body>
</body>
</html>
