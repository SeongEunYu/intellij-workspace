<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.argonet.r2rims.util.LanguageUtil"%>
<%@include file="../pageInit.jsp" %>

<form name="deptForm">
<table class="write_tbl mgb_20">
	<colgroup>
		<col style="width:20%;" />
		<col style="width:30%;" />
		<col style="width:20%" />
		<col style="" />
	</colgroup>
	<tbody>
		<tr>
			<th>코드</th>
			<td colspan="3">
				<c:out value="${empty info.orgCd ? 'New' : info.orgCd}"/>
				<input id="orgCd" name="orgCd" type="hidden" value="<c:out value="${empty info.orgCd ? 'New' : info.orgCd}"/>"/>
			</td>
		</tr>
		<c:if test="${info.orgLevel ne 'TOP'}">
		<tr>
			<th>대표</th>
			<td colspan="3">
				<c:if test="${info.etcAttrb ne 'ERP'}">
					<a href="javascript:void(0);" class="tbl_icon_a tbl_search_icon" onclick="searchResearcher($(this));">검색</a>
				</c:if>
				<c:if test="${not empty info.orgHeadNm}">
					<span style="margin-left: 12px;"><c:out value="${info.orgHeadNm}"/></span>
					<input id="orgHeadId" name="orgHeadId" type="hidden" value="<c:out value="${info.orgHeadId}"/>">
					<input id="orgHeadNm" name="orgHeadNm" type="hidden" value="<c:out value="${info.orgHeadNm}"/>">
				</c:if>
			</td>
		</tr>
		</c:if>
		<tr>
			<th>사용여부</th>
			<td colspan="3">
				<select id="status" name="status" <c:if test="${info.etcAttrb eq 'ERP'}">disabled</c:if>>
					<option value="C"<c:if test="${info.status eq 'C'}">selected="true"</c:if>>사용함</option>
					<option value="P"<c:if test="${info.status eq 'P'}">selected="true"</c:if>>사용안함</option>
				</select>
			</td>
		</tr>
		<tr>
			<th>한글명</th>
			<td colspan="3">
				<input id="orgKorNm" name="orgKorNm" class="input_type" type="text" value="<c:out value="${info.orgKorNm}"/>" <c:if test="${info.etcAttrb eq 'ERP'}">disabled</c:if>>
			</td>
		</tr>
		<tr>
			<th>영문명</th>
			<td colspan="3">
				<input id="orgEngNm" name="orgEngNm" class="input_type" type="text" value="<c:out value="${info.orgEngNm}"/>" <c:if test="${info.etcAttrb eq 'ERP'}">disabled</c:if>>
			</td>
		</tr>
		<tr>
			<th>영문 축약형</th>
			<td colspan="3">
				<input id="orgEngAbbrNm" name="orgEngAbbrNm" class="input_type" type="text" value="<c:out value="${info.orgEngAbbrNm}"/>" <c:if test="${info.etcAttrb eq 'ERP'}">disabled</c:if>>
			</td>
		</tr>
	</tbody>
</table>
	<c:if test="${info.etcAttrb eq 'ERP'}">
		<div style="padding: 15px;">
			<h2>기관 연계데이터는 수정하실 수 없습니다.</h2>
		</div>
	</c:if>
</form>