<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title></title>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/dhtmlx/dhtmlx.js"></script>
</head>
<body>
	<form name="frmSch" id="frmSch" action="${param.kriAction}" method="post">
		<input type="hidden" name="Kri_Param1"  id="kriParam1" value="610400"/>				<%-- 기관ID(필수) --%>
		<input type="hidden" name="Kri_Param2" id="kriParam2" value="${param.Kri_Param2}"/> <%-- 연구자등록번호 또는 직원 사번(필수)--%>
		<input type="hidden" name="Kri_Param3" id="kriParam3" value="${param.Kri_Param3}"/>
		<input type="hidden" name="Kri_Param4" id="kriParam4" value="${param.Kri_Param4}"/> <%-- 논문제목(필수) --%>
		<input type="hidden" name="Kri_Param5" id="kriParam5" value="${param.Kri_Param5}"/> <%-- 학술지명(선택) --%>
		<input type="hidden" name="Kri_Param6" id="kriParam6" value="${param.Kri_Param6}"/> <%-- 한국연구재단 등재구분 (선택필수) 1-등재, 2-등재후보 --%>
		<input type="hidden" name="Kri_Param7" id="kriParam7" value="${param.Kri_Param7}"/> <%-- 해외우수 학술지 구분(선택필수) 1-SCI, 2-SCIE, 3-SSCI, 4-A&HCI, 5-SCOPUS --%>
		<input type="hidden" name="Kri_Param8" id="kriParam8" value="${param.Kri_Param8}"/> <%-- 게재년도 --%>
		<input type="hidden" name="Kri_Param9" id="kriParam9" value="${param.returnUrl}"/> <%-- 기관에서 돌려받을URL(필수) --%>
		<input type="hidden" name="Kri_Param10" id="kriParam10" value="${param.Kri_Param10}"/>
		<input type="hidden" name="Kri_Service" id="kriService" value="${param.Kri_Service}"/> <%-- 서비스코드(필수) --%>
		<input type="hidden" name="Kri_certify" id="kriCertify" value=""/> <%-- 기관PW(필수) --%>
		<input type="hidden" name="Kri_charset" id="kriCharset" value=""/> <%-- CHARSET(선택) --%>
		<input type="hidden" name="Kri_rshcrRegNo" id="kriRshcrRegNo" value=""/> <%-- 암호화된 연구자등록번호(필수) --%>
	</form>
	<form name="frm" id="frm">
		<input type="hidden" name="AgcId" id="AgcId" value="610400"/>
		<input type="hidden" name="rschrRegNo" id="rschrRegNo" value="${param.Kri_Param2}"/>
		<input type="hidden" name="returnUrl" id="returnUrl" value="${param.returnUrl}"/>
	</form>
	<iframe id="encode" name="encode" src="" marginwidth="0" marginheight="0" frameborder="0" Width="0" height="0" SCROLLING="no"></iframe>
</body>
<script type="text/javascript">
$(document).ready(function(){
	var frm = $('#frm');
	frm.attr('action','${pageContext.request.contextPath}/kriCntc/vrfc.do');
	frm.attr('method','post');
	frm.attr('target','encode');
	frm.submit();
});
</script>
</html>