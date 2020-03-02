<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.argonet.r2rims.util.LanguageUtil"%>
<%@include file="../../pageInit.jsp" %>
<form id="formArea" action="${contextPath}/etc/modifyEtc.do" method="post">
  <input type="hidden" id="etcId" name="etcId" value="${etc.etcId}"/>
  <input type="hidden" id="listUrl" name="listUrl" value="${contextPath}/etc/findEtcList.do"/>

  <table class="write_tbl mgb_10" >
	<colgroup>
		<col style="width:140px;" />
		<col style="width:326px;" />
		<col style="width:140px" />
		<col style="" />
	</colgroup>
	<tbody>
		<tr>
		  <th class="essential_th"><spring:message code='etc.nm'/></th>
		  <td colspan="3">
		  	<input type="text" name="subject" id="subject"  class="input_type required" value='<c:out value="${etc.subject}"/>'/>
		  </td>
		</tr>
		<tr>
		  <th><spring:message code='etc.authors'/></th>
		  <td colspan="3">
			 <input type="text" name="authorList" id="authorList"  class="input_type" value="<c:out value="${etc.authorList}"/>"/>
		  </td>
		</tr>
		<tr>
		  <th><spring:message code='etc.date'/></th>
		  <td>
			<input type="text" maxLength="4" style="width: 62px;text-align: right;" name="year" id="year" class="input_type"  value="<c:out value="${etc.year}"/>"/><spring:message code='common.year'/>
			<input type="text" maxLength="4" style="width: 32px;text-align: right;" name="month" id="month" class="input_type"  value="<c:out value="${etc.month}"/>" /><spring:message code='common.month'/>
		  </td>
		  <th><spring:message code='common.source'/></th>
		  <td>
		  	<input type="hidden" name="src" value="<c:out value="${etc.src}"/>" />
			<c:if test="${empty etc.src or etc.src eq 'USER'}">직접입력</c:if>
			<c:if test="${not empty etc.src and etc.src ne 'USER'}"><c:out value="${career.src}"/></c:if>
		  </td>
		</tr>
		<tr>
			<th><spring:message code='common.reg.date'/></th>
			<td>
				<fmt:formatDate var="regDate" value="${etc.regDate}" pattern="yyyy-MM-dd" /> <c:out value="${regDate}"/> ( <c:out value="${empty etc.regUserNm ? 'ADMIN' : etc.regUserNm}"/> )
			</td>
			<th><spring:message code='common.mod.date'/></th>
			<td>
				<fmt:formatDate var="modDate" value="${etc.modDate}" pattern="yyyy-MM-dd" /> <c:out value="${modDate}"/> ( <c:out value="${empty etc.modUserNm ? 'ADMIN' : etc.modUserNm}"/> )
			</td>
		</tr>
	</tbody>
  </table>
</form>
<form id="removeFormArea" action="${contextPath}/etc/removeEtc.do" method="post">
  <input type="hidden" name="etcId" value="${etc.etcId}"/>
</form>
<script type="text/javascript">
$(document).ready(function(){
	  $('input, select, textarea').change(function(){ isChange = true; });
	  $('input:checkbox, input:radio').click(function(){ isChange = true; });
});
</script>