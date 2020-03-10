<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="../../pageInit.jsp" %>
<script type="text/javascript">
$(document).ready(function(){
	dhtmlx.confirm({
		type:"confirm-warning",
		title:"<spring:message code='kri.move.alert.title'/>",
		text:"<spring:message code='kri.move.alert.message'/>",
		ok:"<spring:message code='common.button.move'/>",
		cancel:"<spring:message code='common.button.cancel'/>",
		callback:function(result){
			if(result == true){
			  lfn_sso();
			}
		}
	});
});

function lfn_sso() {
	var url = "http://www.kri.go.kr/kri/ra/cm/sso/wisesso.jsp?"+$('#kriApiFrm').serialize();
	var name = "_majorFrame";
	var prop = "status=1,toolbar=0,scrollbars=yes,width=935,height=800";
	window.open(url, name, prop);
}
</script>
</head>
<body>
	<div class="title_box">
		<h3><spring:message code='menu.major'/></h3>
	</div>
	<div class="contents_box">
		<!-- START 테이블 1 -->
		<form id="formArea" >
			<center><font color="blue"><b><spring:message code='kri.rsrchacps.link'/></b></font></center>
		</form>
	</div>
<form id="kriApiFrm" action="http://www.kri.go.kr/kri/ra/cm/sso/wisesso_api.jsp">
	<input type="hidden"  name="AgcId"  value="610400"/>
	<input type="hidden"  name="AgcPw"  value="cau_argonet"/>
	<input type="hidden"  name="Type"  value="1"/>
	<input type="hidden"  name="RschrRegNo"  value="${sessionScope.sess_user.rschrRegNo}"/>
</form>
<iframe id="majorFrame" src="" name="majorFrame"  marginheight="0" marginwidth="0" frameborder="0" width="100%" height="400" scrolling="auto"></iframe>
</body>
</html>