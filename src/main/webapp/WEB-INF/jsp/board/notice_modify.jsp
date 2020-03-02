<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="../pageInit.jsp" %>
<link type="text/css" href="${contextPath}/css/layout.css" rel="stylesheet" />
<script type="text/javascript" src="${contextPath}/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="${contextPath}/js/jquery/jquery-ui.min.js"></script>
<script type="text/javascript" src="${contextPath}/js/jquery/jquery.mask.min.js"></script>
<script type="text/javascript" src="${contextPath}/js/script.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	$('#title').focus();
	$('#noticeSttDate').mask('0000-00-00',{placeholder:'____-__-__'});
	$('#noticeEndDate').mask('0000-00-00',{placeholder:'____-__-__'});
});
</script>
</head>
<body>
<div id="noticeInfo">
	<form id="noticeFrm">
	<input type="hidden" name="type" id="type" value="top_notice">
	<table	class="write_tbl">
		<colgroup>
			<col style="width: 120px;"/>
			<col style="width: 350px;"/>
		</colgroup>
		<tbody>
			<tr>
				<th class="essential_th">언어</th>
				<td>
					<select id="languageFlag" name="languageFlag" class="select_type" style="width: 50%;">
						<option value="KOR" ${ empty bbs.languageFlag or bbs.languageFlag eq 'KOR' ? 'selected="selected"':''}>한국어</option>
						<option value="ENG" ${not empty bbs.languageFlag and bbs.languageFlag eq 'ENG' ? 'selected="selected"':''}>영어</option>
					</select>
				</td>
			</tr>
			<tr>
				<th class="essential_th">제목</th>
				<td>
					<input type="hidden" id="bbsId" name="bbsId" value="${bbs.bbsId}">
					<input type="text" maxLength="300" id="title" name="title" class="input_type required"  value="${bbs.title}"/>
				</td>
			</tr>
			<tr>
				<th class="essential_th">URL</th>
				<td>
					/kboard.do?cateId=1&boardPath=/ri_notice/<input type="text" style="width: 32%;" id="content" name="content" class="input_type required" value="${bbs.content}"/>
				</td>
			</tr>
			<tr style="height: 44px;">
				<th>게시여부</th>
				<td>
					<input type="radio" id="delDvsCd_N" name="delDvsCd"  value="N"  class="radio" ${empty bbs.delDvsCd or bbs.delDvsCd eq 'N' ? 'checked="checked"':''} />
						<label for="delDvsCd_N" class="radio_label">게시함</label>
					<input type="radio" id="delDvsCd_Y" name="delDvsCd"  value="Y" class="radio" ${not empty bbs.delDvsCd and bbs.delDvsCd eq 'Y' ? 'checked="checked"':''}/>
						<label for="delDvsCd_Y" class="radio_label">게시안함</label>
				</td>
			</tr>
			<tr>
				<th class="essential_th">게시기간</th>
				<td>
					<input type="text" maxLength="300" style="width: 28%;" id="noticeSttDate" name="noticeSttDate" class="input_type required"  value="${bbs.noticeSttDate}" />
					~ <input type="text" maxLength="300" style="width: 28%;" id="noticeEndDate" name="noticeEndDate" class="input_type required"  value="${bbs.noticeEndDate}"/>
					(YYYY-MM-DD 형식)
				</td>
			</tr>
		</tbody>
	</table>
	</form>
</div>
</body>
</html>