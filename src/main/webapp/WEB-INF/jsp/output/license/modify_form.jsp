<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.argonet.r2rims.util.LanguageUtil"%>
<%@include file="../../pageInit.jsp" %>

<c:set var="setDisable" value=""/>
<c:set var="clickAlert" value=""/>
<c:if test="${not empty license.src and license.src eq 'ERP'}">
	<c:set var="setDisable" value='disabled="disabled"'/>
	<c:set var="clickAlert" value='onclick="javascript:dhtmlx.alert({type:\'alert-warning\',text:\'ERP에서 연계된 데이터는 ERP에서만 수정 가능합니다.\',callback:function(){}});"'/>
</c:if>
<form id="formArea" action="${contextPath}/license/modifyLicense.do" method="post">
  <input type="hidden" id="licenseId" name="licenseId" value="${license.licenseId}"/>
  <input type="hidden" id="listUrl" name="listUrl" value="${contextPath}/license/findLicenseList.do"/>

  <table class="write_tbl mgb_10" >
	<colgroup>
		<col style="width:140px;" />
		<col style="width:326px;" />
		<col style="width:140px" />
		<col style="" />
	</colgroup>
	<tbody>
		<tr>
			<th class="essential_th"><spring:message code='licn.qlf.acqs.ym'/></th>
			<td ${clickAlert}>
				<input type="text" maxLength="4" style="width: 62px;text-align: right;" name="qlfAcqsYear" id="qlfAcqsYear" class="input_type required"  value="<c:out value="${license.qlfAcqsYear}"/>"  ${setDisable}/><spring:message code='common.year'/>
				<input type="text" maxLength="4" style="width: 32px;text-align: right;" name="qlfAcqsMonth" id="qlfAcqsMonth" class="input_type"  value="<c:out value="${license.qlfAcqsMonth}"/>"  ${setDisable}/><spring:message code='common.month'/>
			</td>
			<th class="essential_th"><spring:message code='licn.qlf.grnt.agc.nm'/></th>
			<td ${clickAlert}>
				<input type="text" name="qlfGrntAgcNm" id="qlfGrntAgcNm"  class="input_type required" value="<c:out value="${license.qlfGrntAgcNm}"/>" ${setDisable}/>
			</td>
		</tr>
		<tr>
			<th class="essential_th"><spring:message code='licn.cr.qfc.nm'/></th>
			<td ${clickAlert}>
				<input type="text" name="crQfcNm" id="crQfcNm"  class="input_type required" value="<c:out value="${license.crQfcNm}"/>" ${setDisable}/>
			</td>
			<th><spring:message code='licn.blng.univ'/></th>
			<td ${clickAlert}>
		  	 <div class="r_add_bt">
		  	 	<input type="hidden" name="prtcpntIndex" value="1">
             	<input type="hidden" name="blngUnivCd" id="blngAgcCd_1" value="<c:out value="${license.blngUnivCd}"/>"/>
              	<input type="text" name="blngUnivNm" id="blngAgcNm_1" class="input_type" style="<c:if test="${not empty license.blngUnivNm and empty license.blngUnivCd }">background-color: #fef3d7;</c:if>" readonly="readonly" value="<c:out value="${license.blngUnivNm}"/>" onkeydown="if(event.keyCode==13){getCodeOrgWin($(this),event);}" ${setDisable}/>
			  	<span class="r_span_box">
				<a href="javascript:void(0);" class="tbl_icon_a tbl_search_icon" onclick="getCodeOrgWin($(this),event);">검색</a>
			  </span>
			 </div>
			</td>
		</tr>
		<tr>
			<th class="essential_th"><spring:message code='kri.link'/></th>
			<td ${clickAlert}>
	    		<input type="radio" name="interfaceFlag" id="interfaceFlag1" value="1" class="" ${fn:startsWith(license.interfaceFlag, '1') ? 'checked' : ''} /><spring:message code='kri.link.yes'/>
				<input type="radio" name="interfaceFlag" id="interfaceFlag0" value="0" class="" ${fn:startsWith(license.interfaceFlag, '0') ? 'checked' : ''} /><spring:message code='kri.link.no'/>
			</td>
			<th><spring:message code='common.source'/></th>
			<td ${clickAlert}>
				<input type="hidden" name="src" value="<c:out value="${license.src}"/>" />
				<c:if test="${empty license.src or license.src eq 'USER'}">직접입력</c:if>
				<c:if test="${not empty license.src and license.src ne 'USER'}"><c:out value="${license.src}"/></c:if>
			</td>
		</tr>
		<tr>
			<th><spring:message code='common.reg.date'/></th>
			<td>
				<fmt:formatDate var="regDate" value="${license.regDate}" pattern="yyyy-MM-dd" /> <c:out value="${regDate}"/> ( <c:out value="${empty license.regUserNm ? 'ADMIN' : license.regUserNm}"/> )
			</td>
			<th><spring:message code='common.mod.date'/></th>
			<td>
				<fmt:formatDate var="modDate" value="${license.modDate}" pattern="yyyy-MM-dd" /> <c:out value="${modDate}"/> ( <c:out value="${empty license.modUserNm ? 'ADMIN' : license.modUserNm}"/> )
			</td>
		</tr>
	</tbody>
  </table>
 </form>
 <form id="removeFormArea" action="${contextPath}/license/removeActivity.do" method="post">
	<input type="hidden" name="licenseId" value="${license.licenseId}"/>
</form>
 <script type="text/javascript">
$(document).ready(function(){
	  $('input, select, textarea').change(function(){ isChange = true; });
	  $('input:checkbox, input:radio').click(function(){ isChange = true; });
});
</script>