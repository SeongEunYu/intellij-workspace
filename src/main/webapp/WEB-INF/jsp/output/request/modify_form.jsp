<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.argonet.r2rims.util.LanguageUtil"%>
<%@include file="../../pageInit.jsp" %>

<form id="requestForm" >
<h3 class="circle_h3">요청정보</h3>
<table id="requestTbl" class="write_tbl mgb_20">
	<colgroup>
		<col style="width:20%;" />
		<col style="width:30%;" />
		<col style="width:20%" />
		<col style="" />
	</colgroup>
	<tbody>
		<tr>
			<th>요청자</th>
			<td>
				${request.requestUserNm} [ ${request.requestUserId} ]
				<input type="hidden" name="seqNo" id="seqNo" value="${request.seqNo}"/>
				<input type="hidden" id="requestUserId" value="${request.requestUserId}"/>
				<input type="hidden" id="requestUserNm" value="${request.requestUserNm}"/>
				<input type="hidden" id="requestGroupDept" value="${request.requestGroupDept}"/>
				<input type="hidden" id="requestEmalAddr" value="${request.requestEmalAddr}"/>
				<input type="hidden" id="requestEmalAddr" value="${request.requestEmalAddr}"/>
			</td>
			<th>요청일자</th>
			<td><fmt:formatDate value="${request.requestDate}" pattern="yyyy-MM-dd" /></td>
			<input type="hidden" id="requestDate" value="<fmt:formatDate value="${request.requestDate}" pattern="yyyy-MM-dd" />"/>
		</tr>
		<tr>
			<th>요청성과[관리번호]</th>
			<td>${request.trgetRsltType } [${request.trgetRsltId}]
				<div class="list_set"><ul><li><a href="javascript:fn_edit();" class="list_icon09">수정</a></li></ul></div>
				<input type="hidden" name="trgetRsltType" id="trgetRsltType" value="${request.trgetRsltType}"/>
				<input type="hidden" name="trgetRsltId" id="trgetRsltId" value="${request.trgetRsltId}"/>
				<input type="hidden" id="trgetRsltNm" value="${request.trgetRsltNm}"/>
			</td>
			<th>요청구분</th>
			<td>${rims:codeValue('request.se',request.requestSeCd)}</td>
			<input type="hidden" id="requestSeCd" value="${rims:codeValue('request.se',request.requestSeCd)}"/>
		</tr>
		<tr class="cnTr">
			<th>요청내용</th>
			<td colspan="3" style="vertical-align: top;">${request.requestCn}</td>
			<input type="hidden" id="requestCn" value="${request.requestCn}"/>
		</tr>
	</tbody>
</table>
<h3 class="circle_h3">처리결과</h3>
<table id="trgetTbl" class="write_tbl mgb_10">
	<colgroup>
		<col style="width:20%;" />
		<col style="width:30%;" />
		<col style="width:20%" />
		<col style="" />
	</colgroup>
	<tbody>
		<c:if test="${not empty request.requestStatus and  request.requestStatus ne '1'  and request.requestStatus ne '2'}">
		<tr>
			<th>처리자</th>
			<td>${request.tretUserNm} [ ${request.tretUserId} ]
				<input type="hidden" id="tretUserNm" value="${request.tretUserNm}"/>
			</td>
			<th>처리일자</th>
			<td><fmt:formatDate value="${request.tretDate}" pattern="yyyy-MM-dd" /></td>
			<input type="hidden" id="tretDate" value="<fmt:formatDate value="${request.tretDate}" pattern="yyyy-MM-dd" />"/>
		</tr>
		</c:if>
		<tr>
			<th>처리내용</th>
			<td colspan="3">
				<div class="tbl_textarea">
					<textarea name="tretResultCn" id="tretResultCn" maxLength="4000">${request.tretResultCn}</textarea>
				</div>
			</td>
		</tr>
		<tr>
			<th>상태</th>
			<td>
				${rims:codeValue('request.status', request.requestStatus)}
				<input type="hidden" name="requestStatus" id="requestStatus" value="${request.requestStatus}">
			</td>
			<td></td>
			<td></td>
		</tr>
	</tbody>
</table>
<div class="list_bt_area" style="border: 0px solid #fff; ">
	<div class="list_set">
		<ul>
			<li class="first_li"><a href="javascript:fn_complete();" class="list_icon05">완료</a></li>
			<c:if test="${sysConf['mail.use.req.at'] eq 'Y'}">
				<li class="first_li"><a href="javascript:fn_completeAndMail();" class="list_icon05">완료후 메일발송</a></li>
			</c:if>
			<li><a href="javascript:fn_pause();" class="list_icon03">보류</a></li>
			<!--
			<li><a href="javascript:fn_delete();" class="list_icon10">불가</a></li>
			 -->
		</ul>
	</div>
</div>
</form>