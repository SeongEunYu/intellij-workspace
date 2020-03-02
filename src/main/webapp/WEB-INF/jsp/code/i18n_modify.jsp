<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.argonet.r2rims.util.LanguageUtil"%>
<%@include file="../pageInit.jsp" %>

<form id="i18nForm" >
<table id="i18nTbl" class="write_tbl mgb_20">
	<colgroup>
		<col style="width:20%;" />
		<col style="width:30%;" />
		<col style="width:20%" />
		<col style="" />
	</colgroup>
	<tbody>
		<tr>
			<th>CODE</th>
			<td>
				${i18n.code} <input type="hidden" name="code" id="code" value="${i18n.code}"/>
			</td>
			<td></td>
			<td></td>
		</tr>
		<tr>
			<th>설명</th>
			<td colspan="3">
				<input type="text" name="description" id="description" value="${i18n.description}" class="input_type"/>
			</td>
		</tr>
	</tbody>
</table>
<table id="messageTbl" class="write_tbl mgb_10">
	<colgroup>
		<col style="width:20%;" />
		<col style="width:30%;" />
		<col style="width:20%" />
		<col style="" />
	</colgroup>
	<tbody>
		<c:forEach items="${i18nDetailList}" var="idl" varStatus="idx">
			<tr>
				<th>
					${idl.languageName}
					<input type="hidden" name="language" id="language_${idx.count}" value="${idl.language}">
				</th>
				<td colspan="3">
					<div class="tbl_textarea">
						<textarea name="message" id="message_${idx.count}" maxLength="4000">${idl.message}</textarea>
					</div>
				</td>
			</tr>
		</c:forEach>
	</tbody>
</table>
</form>