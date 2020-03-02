<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="ko" xml:lang="ko">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>${sysConf['system.rss.jsp.title']} 권한선택</title>
	<%@include file="../pageInit.jsp" %>
	<link rel="shortcut icon" href="${pageContext.request.contextPath}/images/${sysConf['shortcut.icon']}">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/layout.css" />
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery/jquery-1.11.3.min.js"></script>
	<script type="text/javascript">
        function fn_submit(userId, uId, adminDvsCd, authorId, workTrget, mgtAt){
            $('#userId').val(userId);
            $('#uId').val(uId);
            $('#dvsCd').val(adminDvsCd);
            $('#authorId').val(authorId);
            $('#workTrget').val(workTrget);
            $('#mgtAt').val(mgtAt);
            $('#frm').submit();
        }
	</script>
	<style type="text/css">
		.user_select_box ul {
			border-top: 1px solid #3791d0;
		}
		.user_select_box ul li a {
			font-size: 16px;
		}

		.login_box {  height: 442px; }
		.login_bottom_text { color: #fff; padding: 20px 0 0 0; font-size: 11px;}
		.line_type { padding: 0 0 10px 0; background: url(${pageContext.request.contextPath}/images/background/box_shadow.png) no-repeat 50% bottom; margin-bottom: 22px;}
		.line_type_inner {border:1px solid #4b72b8; border-radius: 4px; padding: 20px; }
		.rd_box a{  display: block; background: url(${pageContext.request.contextPath}/images/background/bt_arrow.png) no-repeat right 50%;}

	</style>
	<script type="text/javascript">
        $(function(){
            var authNum = $("ul li").length;
            var authSize = authNum*42;
            var h = 30 + authSize;
            var h2 = authSize;
            if(authNum > 5){
                h = 30 + (5*42);
                h2 = 190;

                $(".user_select_box ul").css("overflow-y","auto");
            }

            $(".user_select_box").css("height",h+"px");

            $(".user_select_box ul").css("height",h2+"px");

        });
	</script>
</head>
<body class="login_wrap">
<div class="login_box">
	<div class="line_type">
		<div class="line_type_inner rd_box">
			<a href="${pageContext.request.contextPath}/share/user/main.do" style="font-weight: normal; font-size: 35px; margin-bottom: 0px; color: #fff;">
				<table>
					<tr>
						<td><em style="font-size: 13px;padding-left: 2px;"></em></td>
					</tr>
					<tr>
						<td rowspan="2"><em style='color: rgb(207, 147, 41);'>R</em><em>ESEARCH </em><em style='color: rgb(207, 147, 41);'>S</em><em>UPPORT </em><em style='color: rgb(207, 147, 41);'>S</em><em>YSTEM</em></td>
					</tr>
				</table>
			</a>
			<%--<a href="${pageContext.request.contextPath}/share/user/main.do"><img src="${pageContext.request.contextPath}/images/common/rims_discovery_bt.png" alt="rims discovery"></a>--%>
		</div>
	</div>


</div>
<span class="deco_box"></span>
<span class="bottom_span"></span>
<form id="frm" name="frm" method="post" action="${pageContext.request.contextPath}/index/authLogin.do">
	<input type="hidden" name="mgtAt" id="mgtAt">
	<input type="hidden" name="userId" id="userId">
	<input type="hidden" name="uId" id="uId">
	<input type="hidden" name="dvsCd" id="dvsCd">
	<input type="hidden" name="workTrget" id="workTrget">
	<input type="hidden" name="authorId" id="authorId">
	<input type="hidden" name="conectMth" value="${conectMth}">
</form>
</body>
</html>