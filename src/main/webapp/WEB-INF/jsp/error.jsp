<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en-US">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<link rel="shortcut icon" href="${pageContext.request.contextPath}/images/${sysConf['shortcut.icon']}">
<title>죄송합니다.</title>
</head>
<link type="text/css" href="${pageContext.request.contextPath}/css/errorpage.css" rel="stylesheet" />
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery/jquery-1.11.3.min.js"></script>
<body>
	<div class="error_wrap">
		<div class="error_box">
			<div class="top_error_text">
				<strong>죄송합니다.</strong> 요청하신 페이지를 찾을 수 없습니다.
			</div>
			<div class="error_text_box">
				방문하시려는 페이지의 주소가 잘못 입력되었거나,<br />
				페이지의 주소가 변경 혹은 삭제되어 요청하신 페이지를 찾을 수 없습니다.<br />
				주소가 정확함에도 현재 오류 메세지가 계속 나타나는 경우 관리자에게 문의하시기 바랍니다.
			</div>
			<div class="error_text_box">
				I'm sorry. The page you requested could not be found.<br/>
				Please check the URL for mistakes<br/>
				If the URL is accurate, or if the current error message is displayed,<br/> 
				please contact the administrator.<br/>			
			</div>
			<div class="error_info_box">
				<span>T : ${sysConf['system.admin.telno']}</span>
				<span class="customer_mail">E-Mail : ${sysConf['system.admin.email']}</span>
				<span class="customer_mail">E-Mail : ${sysConf['system.admin.email']}</span>
			</div>
		</div>
	</div>
</body>
</html>