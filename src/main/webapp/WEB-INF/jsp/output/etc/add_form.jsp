<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.argonet.r2rims.util.LanguageUtil"%>
<%@include file="../../pageInit.jsp" %>

<form id="formArea" action="${contextPath}/etc/addEtc.do" method="post">
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
		  <th class="essential_th"><spring:message code='etc.nm'/></th>
		  <td colspan="3">
		  	<input type="text" name="subject" id="subject"  class="input_type required" />
		  </td>
		</tr>
		<tr>
		  <th><spring:message code='etc.authors'/></th>
		  <td colspan="3">
			 <input type="text" name="authorList" id="authorList"  class="input_type" />
		  </td>
		</tr>
		<tr>
		  <th><spring:message code='etc.date'/></th>
		  <td colspan="3">
			<input type="text" maxLength="4" style="width: 62px;text-align: right;" name="year" id="year" class="input_type" /><spring:message code='common.year'/>
			<input type="text" maxLength="4" style="width: 32px;text-align: right;" name="month" id="month" class="input_type" /><spring:message code='common.month'/>
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