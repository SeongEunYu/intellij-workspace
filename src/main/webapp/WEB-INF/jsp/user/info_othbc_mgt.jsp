<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="cache-Control" content="co-cache" />
<title>${sysConf['system.rims.jsp.title']}</title>
<%@include file="../pageInit.jsp" %>
<c:set var="setDisable" value=""/>
<c:if test="${ sessionScope.auth.adminDvsCd ne 'M'}">
	<c:set var="setDisable" value='disabled="disabled"'/>
</c:if>
<style type="text/css">
.write_tbl tbody td{border: 1px solid #b1b1b1;}
.write_tbl tbody th{border: 1px solid #b1b1b1;}
.write_tbl thead td{border: 1px solid #b1b1b1;}
.write_tbl thead th{border: 1px solid #b1b1b1;}
</style>
<link type="text/css" href="<c:url value="/css/layout.css"/>" rel="stylesheet" />
<link type="text/css" href="<c:url value="/js/dhtmlx_461/skins/${sysConf['dhtmlx.skin']}/dhtmlx.css"/>" rel="stylesheet" />
<script type="text/javascript" src="<c:url value="/js/jquery/jquery-1.11.3.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/dhtmlx_461/dhtmlx.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/script.js"/>"></script>
<script type="text/javascript">
function fn_save(){

	var kriFlagValue = $('input:radio[name="kriFlag"]:checked').val();
	var irFlagValue = $('input:radio[name="irFlag"]:checked').val();
	var ridFlagValue = $('input:radio[name="ridFlag"]:checked').val();

	//console.log(kriFlagValue + irFlagValue + ridFlagValue);
	$('#interfaceFlag').val(kriFlagValue + irFlagValue + ridFlagValue);
	$.post('<c:url value="/user/updateInfoOthbc.do"/>',$('#formArea').serializeArray(),null,'text').done(function(data){
		if(data == 1)
		{
			dhtmlx.alert({type:"alert-warning",text:"저장되었습니다.. <br/> 창을 닫습니다.",callback:function(){
				top.window.close();
			}});
		}
	});
}
</script>
</head>
<c:set var="othAgcInfoOffrYn" value="${user.othAgcInfoOffrYn}"/>
<c:set var="kriFlag" value="${fn:substring(user.interfaceFlag, 0,1)}"/>
<c:set var="irFlag" value="${fn:substring(user.interfaceFlag, 1,2)}"/>
<c:set var="ridFlag" value="${fn:substring(user.interfaceFlag, 2,5)}"/>
<body style="overflow-y: auto;">
<form id="formArea">
<input type="hidden" id="interfaceFlag" name="interfaceFlag" value="${user.interfaceFlag}">
<div class="popup_wrap">
	<div class="title_box">
		<h3><spring:message code='menu.shared.info'/></h3>
	</div>
	<c:if test="${sessionScope.auth.adminDvsCd eq 'M'}">
	<div class="list_bt_area">
		<div class="list_set">
			<ul>
				<li class="first_li"><a href="javascript:fn_save();" class="list_icon02"><spring:message code='common.button.save'/></a></li>
			</ul>
		</div>
	</div>
	</c:if>
	<table class="write_tbl mgb_30"  >
		<thead>
			<tr>
				<th><spring:message code='info.comment1'/></th>
				<th><spring:message code='info.comment2'/></th>
				<th><spring:message code='info.comment3'/></th>
				<th><spring:message code='info.comment4'/></th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<th rowspan="2">KRI</th>
				<td><spring:message code='info.comment5'/></td>
				<td>
					<input type="radio" id="kriFlag_1" name="kriFlag" class="typeRadio" value="1"  ${setDisable} ${kriFlag eq '1' ? 'checked="checked"' : '' } />
					<label for=""><spring:message code='info.comment9'/></label>
					<br/>
					<input type="radio" id="kriFlag_0" name="kriFlag" class="typeRadio" value="0"  ${setDisable} ${empty kriFlag or kriFlag eq '0' ? 'checked="checked"' : '' }/>
					<label for=""><spring:message code='info.comment10'/></label>
				</td>
				<td><spring:message code='info.comment14'/></td>
			</tr>
			<tr>
				<td><spring:message code='info.comment6'/></td>
				<td>
					<input type="radio" id="othAgcInfoOffrYn_1" name="othAgcInfoOffrYn" class="typeRadio" value="1"  ${setDisable} ${empty othAgcInfoOffrYn or othAgcInfoOffrYn eq '1' ? 'checked="checked"' : '' }/>
					<label for=""><spring:message code='info.comment11'/></label>
					<br/>
					<input type="radio" id="othAgcInfoOffrYn_2" name="othAgcInfoOffrYn" class="typeRadio" value="2"  ${setDisable} ${othAgcInfoOffrYn eq '2' ? 'checked="checked"' : '' }/>
					<label for=""><spring:message code='info.comment12'/></label>
					<br/>
					<input type="radio" id="othAgcInfoOffrYn_3" name="othAgcInfoOffrYn" class="typeRadio" value="3"  ${setDisable} ${othAgcInfoOffrYn eq '3' ? 'checked="checked"' : '' }/>
					<label for=""><spring:message code='info.comment13'/></label>
				</td>
				<td><spring:message code='info.comment15'/></td>
			</tr>
			<tr>
				<th>IR<c:if test="${not empty sysConf['inst.repo.name']}">(${sysConf['inst.repo.name']})</c:if></th>
				<td><spring:message code='info.comment7'/></td>
				<td>
					<input type="radio" id="irFlag_1" name="irFlag" class="typeRadio" value="1"  ${setDisable} ${irFlag eq '1' ? 'checked="checked"' : '' }/>
					<label for=""><spring:message code='info.comment9'/></label>
					<br/>
					<input type="radio" id="irFlag_0" name="irFlag" class="typeRadio" value="0"  ${setDisable} ${empty irFlag or irFlag eq '0' ? 'checked="checked"' : '' }/>
					<label for=""><spring:message code='info.comment10'/></label>
				</td>
				<td><spring:message code='info.comment16'/></td>
			</tr>
			<tr>
				<th>Researcher ID</th>
				<td><spring:message code='info.comment8'/></td>
				<td>
					<input type="radio" id="ridFlag_100" name="ridFlag" class="typeRadio" value="100"  ${setDisable} ${ridFlag eq '100' ? 'checked="checked"' : '' }/>
					<label for=""><spring:message code='info.comment9'/></label>
					<br/>
					<input type="radio" id="ridFlag_000" name="ridFlag" class="typeRadio" value="000"  ${setDisable} ${ empty ridFlag or ridFlag eq '000' ? 'checked="checked"' : '' }/>
					<label for=""><spring:message code='info.comment10'/></label>
				</td>
				<td><spring:message code='info.comment17'/></td>
			</tr>
		</tbody>
	</table>
</div>
</form>
</body>
</html>


