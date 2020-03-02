<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.argonet.r2rims.util.LanguageUtil"%>
<%@include file="../pageInit.jsp" %>

<form name="deptForm">
	<c:if test="${gubun eq 'clg'}">
		<div style="padding: 5px 0 0 15px;">
			<h1>단과대</h1>
		</div>
	</c:if>
	<c:if test="${gubun eq 'dept'}">
		<div style="padding: 5px 0 0 15px;">
			<h1>학과</h1>
		</div>
	</c:if>
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
				<c:out value="${empty info.isUsed ? 'New' : gubun eq 'clg' ? info.clgCode : info.deptCode}"/>
				<input id="deptCode" name="deptCode" type="hidden" value="<c:out value="${empty info.isUsed ? '0' : gubun eq 'clg' ? info.clgCode : info.deptCode}"/>"/>
			</td>
		</tr>
		<c:if test="${gubun ne 'clg'}">
		<tr>
			<th>대표</th>
			<td colspan="3">
				<c:if test="${info.src ne 'ERP'}">
					<a href="javascript:void(0);" class="tbl_icon_a tbl_search_icon" onclick="searchResearcher($(this));">검색</a>
				</c:if>
				<c:if test="${not empty info.drhfEmpNm}">
					<span style="margin-left: 12px;"><c:out value="${info.drhfEmpNm}"/></span>
					<input id="drhfEmpId" name="drhfEmpId" type="hidden" value="<c:out value="${info.drhfEmpId}"/>">
				</c:if>
			</td>
		</tr>
		</c:if>
		<c:if test="${gubun ne 'clg'}">
		<tr>
			<th>사용여부</th>
			<td colspan="3">
				<select id="isUsed" name="isUsed" <c:if test="${info.src eq 'ERP'}">disabled</c:if>>
					<option value="Y"<c:if test="${info.isUsed eq 'Y'}">selected="true"</c:if>>사용함</option>
					<option value="N"<c:if test="${info.isUsed eq 'N'}">selected="true"</c:if>>사용안함</option>
				</select>
			</td>
		</tr>
		</c:if>
		<tr>
			<th>한글명</th>
			<td colspan="3">
				<input id="deptKorNm" name="deptKorNm" class="input_type" type="text" value="<c:out value="${gubun eq 'clg' ? info.clgNm : info.deptKorNm}"/>" <c:if test="${info.src eq 'ERP'}">disabled</c:if>>
			</td>`
		</tr>
		<tr>
			<th>영문명</th>
			<td colspan="3">
				<input id="deptEngNm" name="deptEngNm" class="input_type" type="text" value="<c:out value="${gubun eq 'clg' ? info.clgNmEng : info.deptEngNm}"/>" <c:if test="${info.src eq 'ERP'}">disabled</c:if>>
			</td>
		</tr>
		<c:if test="${gubun ne 'clg'}">
		<tr>
			<th>영문 축약형</th>
			<td colspan="3">
				<input id="deptEngAbbr" name="deptEngAbbr" class="input_type" type="text" value="<c:out value="${info.deptEngAbbr}"/>" <c:if test="${info.src eq 'ERP'}">disabled</c:if>>
			</td>
		</tr>
		<tr>
			<th>영문 최대 축약형</th>
			<td colspan="3">
				<input id="deptEngMostAbbr" name="deptEngMostAbbr" class="input_type" type="text" value="<c:out value="${info.deptEngMostAbbr}"/>" <c:if test="${info.src eq 'ERP'}">disabled</c:if>>
			</td>
		</tr>
		</c:if>
	</tbody>
</table>
	<c:if test="${info.src eq 'ERP'}">
		<div style="padding: 15px;">
			<h2>기관 연계데이터는 수정하실 수 없습니다.</h2>
		</div>
	</c:if>
</form>