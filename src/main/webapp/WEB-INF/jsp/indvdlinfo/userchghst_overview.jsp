<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.argonet.r2rims.util.LanguageUtil"%>
<%@include file="../pageInit.jsp" %>

<form id="requestForm" >
<div>
<table id="userchghstTbl" class="write_tbl mgb_30">
	<colgroup>
		<col style="width:100px;" />
		<col style="" />
	</colgroup>
	<tbody>
		<tr>
			<th>사번</th>
			<td>
				${userchghst.trgterKorNm} [ ${userchghst.trgterId} ]
			</td>
		</tr>
		<tr>
			<th>수정자</th>
			<td>
				${userchghst.modUserId eq 'SYSTEM' ? 'SYSTEM' : userchghst.modUserNm} [ ${userchghst.modUserId} ]
			</td>
		</tr>
		<tr>
			<th>수정일자</th>
			<td><fmt:formatDate value="${userchghst.modDate}" pattern="yyyy-MM-dd" /></td>
		</tr>
		<tr>
			<th>접속IP</th>
			<td>${userchghst.conectIp}</td>
		</tr>
		<tr class="cnTr">
			<th>변경내용</th>
			<td colspan="3" style="vertical-align: top;">${userchghst.changeContents}</td>
		</tr>
	</tbody>
</table>
</div>
</form>