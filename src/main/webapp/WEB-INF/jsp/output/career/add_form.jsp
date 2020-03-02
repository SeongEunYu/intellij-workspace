<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.argonet.r2rims.util.LanguageUtil"%>
<%@include file="../../pageInit.jsp" %>

<form id="formArea" action="${contextPath}/career/addCareer.do" method="post">
  <input type="hidden" name="src" value="USER" />
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
			<td>
				<input type="text" maxLength="4" style="width: 62px;text-align: right;" name="workSttYear" id="workSttYear" class="input_type required"  /><spring:message code='common.year'/>
				<input type="text" maxLength="4" style="width: 32px;text-align: right;" name="workSttMonth" id="workSttMonth" class="input_type"  /><spring:message code='common.month'/>
			</td>
			<th class="essential_th"><spring:message code='carr.work.end.ym'/></th>
			<td>
				<input type="text" maxLength="4" style="width: 62px;text-align: right;" name="workEndYear" id="workEndYear" class="input_type required" /><spring:message code='common.year'/>
				<input type="text" maxLength="4" style="width: 32px;text-align: right;" name="workEndMonth" id="workEndMonth" class="input_type"  /><spring:message code='common.month'/>
			</td>
		</tr>
		<tr>
			<th class="essential_th"><spring:message code='carr.work.agc.nm'/></th>
			<td colspan="3">
				<input type="text" name="workAgcNm" id="workAgcNm"  class="input_type required" />
			</td>
		</tr>
		<tr>
			<th class="essential_th"><spring:message code='carr.posi.nm'/></th>
			<td>
				<input type="text" name="posiNm" id="posiNm"  class="input_type required" />
			</td>
			<th class="essential_th"><spring:message code='carr.chg.biz.nm'/></th>
			<td>
				<input type="text" name="chgBizNm" id="chgBizNm"  class="input_type required" />
			</td>
		</tr>
		<tr>
			<th class="essential_th"><spring:message code='kri.link'/></th>
			<td colspan="3">
	    		<input type="radio" name="interfaceFlag" id="interfaceFlag1" value="1" checked="checked" /><spring:message code='kri.link.yes'/>
				<input type="radio" name="interfaceFlag" id="interfaceFlag0" value="0" /><spring:message code='kri.link.no'/>
			</td>
		</tr>
	</tbody>
  </table>
</form>

<script type="text/javascript">
$(document).ready(function(){
	  $('input, select, textarea').change(function(){ isChange = true; });
	  $('input:checkbox, input:radio').click(function(){ isChange = true; });
});
</script>