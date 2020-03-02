<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%><!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${sysConf['system.rims.jsp.title']} No Authority</title>
<%@include file="../pageInit.jsp" %>
<link rel="shortcut icon" href="${pageContext.request.contextPath}/images/${sysConf['shortcut.icon']}">
<link type="text/css" href="${pageContext.request.contextPath}/css/errorpage.css" rel="stylesheet" />
<link type="text/css" href="${pageContext.request.contextPath}/js/dhtmlx/skins/${sysConf['dhtmlx.skin']}/dhtmlx.css" rel="stylesheet" />
<style type="text/css">
.error_box { width: 650px; margin: 0 auto; background: url(../images/common/error_icon.png) no-repeat 50% 38px; padding: 220px 0 0 0;}
.error_box .top_error_text { border-top: 1px solid #95c8e0; font-size: 17px; font-weight: bold; color: #3b3b3b; padding: 20px 0 0 0; margin-bottom: 20px;}
.error_box .top_error_text strong { font-size: 23px; color: #305eb3; display: block; }
</style>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/dhtmlx/dhtmlx.js"></script>
<script type="text/javascript">
$(document).ready(function()
{
	/*
	dhtmlx.alert({type:"alert-error",text:"${msg}",callback:function(){
		top.window.close();
	}})
	*/
});
</script>
</head>
<body>
	<div class="error_wrap">
		<div class="error_box">
			<div class="top_error_text">
				<strong>RIMS의 사용권한이 없는 이용자입니다.</strong>
				교원, 박사과정, 대리입력자, RIMS 관리자로 지정된 이용자만 접속 가능합니다.
			</div>
			<div class="error_text_box">
				<p><b>[교원이 직접 대리입력자를 지정하는 방법]<b></p>
				<p>① RIMS 접속 후 ‘대리입력자관리’ 클릭 → ② 대상자 검색 → 권한 설정/저장</p>
				<br/>
				<p><b>[대리입력자 권한 신청하는 방법]</b></p>
				<p>① 성과관리 허락(교원) → </p>
				<p>② rims@kaist.ac.kr로 대리입력자 지정 신청 →</p>
				<p>③ 신청시 정보 : 대상 교원 성명, 대리입력자 이름, 학과, 학번, 연락처, 메일 주소) →</p>
				<p>④ 메일 참조에 교수님 메일 주소 추가 →</p>
				<p>⑤ RIMS 담당자가 대리입력자 추가 후 메일로 승인처리 메일 발송</p>
			</div>
			<div class="top_error_text">
				<strong>You don’t have any authority to access RIMS.</strong>
				Only Faculty, PhD student, Assistant and manager can access RIMS.
			</div>
			<div class="error_text_box">
				<p><b>[How to register an assistant]</b></p>
				<p>① Login RIMS as portal ID -> Move the “Configure Assistant Access”</p>
				<p>② Click the “New” </p>
				<p>③ Setting permission after assistant target search</p>
			</div>
			<div class="error_info_box" style="line-height: 250%;text-align: center;">
				<p>
					Contact the RIMS administrator if you have other questions.
					<br/>
					<a href="http://rims.kaist.ac.kr" target="_BLANK" >http://rims.kaist.ac.kr</a>
				</p>
				<span>T: ${sysConf['system.admin.telno']}</span>
				<span class="customer_mail">E-Mail: ${sysConf['system.admin.email']}</span>
			</div>
		</div>
	</div>

</body>
</html>
