<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="cache-Control" content="co-cache" />
<title>${sysConf['system.rims.jsp.title']}</title>
<%@include file="../pageInit.jsp" %>
<link type="text/css" href="${contextPath}/css/layout.css" rel="stylesheet" />
<link type="text/css" href="${contextPath}/js/dhtmlx/skins/${sysConf['dhtmlx.skin']}/dhtmlx.css" rel="stylesheet" />
<script type="text/javascript" src="${contextPath}/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="${contextPath}/js/jquery/jquery-ui.min.js"></script>
<script type="text/javascript" src="${contextPath}/js/jquery/jquery.tmpl.min.js"></script>
<script type="text/javascript" src="${contextPath}/js/jquery/jquery.switchbutton.min.js"></script>
<script type="text/javascript" src="${contextPath}/js/dhtmlx/dhtmlx.js"></script>
<script type="text/javascript" src="${contextPath}/js/script.js"></script>
<script type="text/javascript">
function fn_profileUpload(){
	var url = "${contextPath}/auth/user/profileUpload.do?"+$('#formArea').serialize();
	$.get(url, null, null, 'json').done(function(data){
		var masessage = data.msg;
		if(data.code == '001')
		{
			dhtmlx.alert({text:masessage,callback:function(){reloadAndClose();}});
		}
		else
		{
			dhtmlx.alert({type:"alert-warning",text:masessage,callback:function(){reloadAndClose();}});
		}
	});
}
function reloadAndClose(){
	window.opener.myGrid_load();
	top.window.close();
}
</script>
</head>
<body>
	<div class="popup_wrap">
		<div class="title_box">
			<h3>Researcher ID 발급 요청 페이지</h3>
		</div>
		<div class="list_bt_area">
			<div class="list_set">
				<ul>
					<li><a href="javascript:fn_profileUpload();" class="list_icon12">Upload</a></li>
				</ul>
			</div>
		</div>
		<div id="formObj">
		<form id="formArea">
			<table class="write_tbl">
				<colgroup>
					<col style="width:100px;" />
					<col style="width:120px;" />
					<col style="width:80px" />
					<col style="width:420px" />
					<col style="width:160px" />
					<col style="width:90px" />
					<col style="width:80px" />
					<col/>
				</colgroup>
				<thead>
					<tr>
						<th>사번</th>
						<th>First Name</th>
						<th>List Name</th>
						<th>학과</th>
						<th>이메일</th>
						<th>임용일</th>
						<th>캠퍼스</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${list}" var="user" varStatus="idx">
						<tr>
							<td style="text-align: center;">
								${user.userId}
								<input type="hidden" name="seqNo" id="seqNo_${idx.count}"  value="${user.idntfrSeqNo}" />
								<input type="hidden" name="userId" id="userId_${idx.count}"  value="${user.userId}" />
							</td>
							<td>
								<input type="text" class="input_type" name="firstName" id="firstName_${idx.count}" value="${user.firstName}"/>
							</td>
							<td>
								<input type="text" class="input_type" name="lastName" id="lastName_${idx.count}" value="${user.lastName}"/>
							</td>
							<td>
								<input type="text" class="input_type" name="deptEng" id="deptEng_${idx.count}" value="${user.deptEng}"/>
							</td>
							<td>
								<input type="text" class="input_type" name="emalAddr" id="emalAddr_${idx.count}" value="${user.emalAddr}"/>
							</td>
							<td>
								<input type="text" class="input_type" name="aptmDate" id="aptmDate_${idx.count}" value="${user.aptmDate}"/>
							</td>
							<td>
							 	<select name="campus" id="campus_${idx.count}" class="select_type">
							 		<option value="1" selected="selected" >대전</option>
							 		<option value="2">서울</option>
							 	</select>
							</td>
						</tr>
					</c:forEach>
				</tbody>
		    </table>
		</form>
	    </div>
	</div>
</body>
</html>