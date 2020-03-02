<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%
    request.getSession().removeAttribute("sess_user");
    request.getSession().removeAttribute("login_user");
%><!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<script type="text/javascript">
//alert("로그아웃 되었습니다.");
//window.close();
location.href = "https://iam.kaist.ac.kr/iamps/cmm/main/IampsExitSelect.do";		// 운영 로그아웃
//location.href = "https://apps2.kaist.ac.kr/iamps/cmm/main/IampsExitSelect.do";		// 개발 로그아웃
</script>
</body>
</html>