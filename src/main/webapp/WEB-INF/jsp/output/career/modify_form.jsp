<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.argonet.r2rims.util.LanguageUtil"%>
<%@include file="../../pageInit.jsp" %>
<c:set var="setDisable" value=""/>
<c:set var="clickAlert" value=""/>
<c:if test="${not empty career.src and career.src eq 'ERP'}">
	<c:set var="setDisable" value='disabled="disabled"'/>
	<c:set var="clickAlert" value='onclick="javascript:dhtmlx.alert({type:\'alert-warning\',text:\'ERP에서 연계된 데이터는 ERP에서만 수정 가능합니다.\',callback:function(){}});"'/>
</c:if>
<form id="formArea" action="${contextPath}/career/modifyCareer.do" method="post">
  <input type="hidden" id="careerId" name="careerId" value="${career.careerId}"/>
  <input type="hidden" id="listUrl" name="listUrl" value="${contextPath}/career/findCareerList.do"/>

  <table class="write_tbl mgb_10" >
	<colgroup>
		<col style="width:140px;" />
		<col style="width:326px;" />
		<col style="width:140px" />
		<col style="" />
	</colgroup>
	<tbody>
		<tr>
			<th class="essential_th"><spring:message code='carr.work.stt.ym'/></th>
			<td ${clickAlert}>
				<input type="text" maxLength="4" style="width: 62px;text-align: right;" name="workSttYear" id="workSttYear" class="input_type required"  value="<c:out value="${career.workSttYear}"/>"  ${setDisable}/><spring:message code='common.year'/>
				<input type="text" maxLength="4" style="width: 32px;text-align: right;" name="workSttMonth" id="workSttMonth" class="input_type"  value="<c:out value="${career.workSttMonth}"/>"  ${setDisable}/><spring:message code='common.month'/>
			</td>
			<th><spring:message code='carr.work.end.ym'/></th>
			<td ${clickAlert}>
				<input type="text" maxLength="4" style="width: 62px;text-align: right;" name="workEndYear" id="workEndYear" class="input_type"  value="<c:out value="${career.workEndYear}"/>"  ${setDisable}/><spring:message code='common.year'/>
				<input type="text" maxLength="4" style="width: 32px;text-align: right;" name="workEndMonth" id="workEndMonth" class="input_type"  value="<c:out value="${career.workEndMonth}"/>"  ${setDisable}/><spring:message code='common.month'/>
			</td>
		</tr>
		<tr>
			<th class="essential_th"><spring:message code='carr.work.agc.nm'/></th>
			<td colspan="3" ${clickAlert}>
				<input type="text" name="workAgcNm" id="workAgcNm"  class="input_type required" value="<c:out value="${career.workAgcNm}"/>" ${setDisable}/>
			</td>
		</tr>
		<tr>
			<th><spring:message code='carr.posi.nm'/></th>
			<td ${clickAlert}>
				<input type="text" name="posiNm" id="posiNm"  class="input_type" value="<c:out value="${career.posiNm}"/>" ${setDisable}/>
			</td>
			<th><spring:message code='carr.chg.biz.nm'/></th>
			<td ${clickAlert}>
				<input type="text" name="chgBizNm" id="chgBizNm"  class="input_type" value="<c:out value="${career.chgBizNm}"/>" ${setDisable}/>
			</td>
		</tr>
		<tr>
			<th><spring:message code='kri.link'/></th>
			<td>
	    		<input type="radio" name="interfaceFlag" id="interfaceFlag1" value="1" ${fn:startsWith(career.interfaceFlag, '1') ? 'checked' : ''}/><spring:message code='kri.link.yes'/>
				<input type="radio" name="interfaceFlag" id="interfaceFlag0" value="0" ${fn:startsWith(career.interfaceFlag, '0') ? 'checked' : ''}/><spring:message code='kri.link.no'/>
			</td>
			<th><spring:message code='common.source'/></th>
			<td>
				<input type="hidden" name="src" value="<c:out value="${career.src}"/>" />
				<c:if test="${empty career.src or career.src eq 'USER'}">직접입력</c:if>
				<c:if test="${not empty career.src and career.src ne 'USER'}"><c:out value="${career.src}"/></c:if>
			</td>
		</tr>
		<tr>
			<th><spring:message code='common.reg.date'/></th>
			<td>
				<fmt:formatDate var="regDate" value="${career.regDate}" pattern="yyyy-MM-dd" /> <c:out value="${regDate}"/> ( <c:out value="${empty career.regUserNm ? 'ADMIN' : career.regUserNm}"/> )
			</td>
			<th><spring:message code='common.mod.date'/></th>
			<td>
				<fmt:formatDate var="modDate" value="${career.modDate}" pattern="yyyy-MM-dd" /> <c:out value="${modDate}"/> ( <c:out value="${empty career.modUserNm ? 'ADMIN' : career.modUserNm}"/> )
			</td>
		</tr>
	</tbody>
  </table>
</form>
<form id="removeFormArea" action="${contextPath}/award/removeAward.do" method="post">
	<input type="hidden" name="careerId" value="${career.careerId}"/>
</form>
<script type="text/javascript">
$(document).ready(function(){
	  $('input, select, textarea').change(function(){ isChange = true; });
	  $('input:checkbox, input:radio').click(function(){ isChange = true; });
});
</script>