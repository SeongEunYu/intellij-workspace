<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.argonet.r2rims.util.LanguageUtil"%>
<%@include file="../../pageInit.jsp" %>
<form id="formArea" action="${contextPath}/license/addLicense.do" method="post">
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
				<th class="essential_th"><spring:message code='licn.qlf.acqs.ym'/></th>
				<td>
					<input type="text" maxLength="4" style="width: 62px;text-align: right;" name="qlfAcqsYear" id="qlfAcqsYear" class="input_type required" /><spring:message code='common.year'/>
					<input type="text" maxLength="4" style="width: 32px;text-align: right;" name="qlfAcqsMonth" id="qlfAcqsMonth" class="input_type" /><spring:message code='common.month'/>
				</td>
				<th class="essential_th"><spring:message code='licn.qlf.grnt.agc.nm'/></th>
				<td>
					<input type="text" name="qlfGrntAgcNm" id="qlfGrntAgcNm"  class="input_type required" />
				</td>
			</tr>
			<tr>
				<th class="essential_th"><spring:message code='licn.cr.qfc.nm'/></th>
				<td>
					<input type="text" name="crQfcNm" id="crQfcNm"  class="input_type required" />
				</td>
				<th><spring:message code='licn.blng.univ'/></th>
				<td>
			  	 <div class="r_add_bt">
			  	 	<input type="hidden" name="prtcpntIndex" value="1">
	             	<input type="hidden" name="blngUnivCd" id="blngAgcCd_1" />
	              	<input type="text" name="blngUnivNm" id="blngAgcNm_1" class="input_type" <c:if test="${not empty license.blngUnivNm and empty license.blngUnivCd }">background-color: #fef3d7;</c:if>" readonly="readonly" onkeydown="if(event.keyCode==13){getCodeOrgWin($(this),event);}" />
				  	<span class="r_span_box">
					<a href="javascript:void(0);" class="tbl_icon_a tbl_search_icon" onclick="getCodeOrgWin($(this),event);">검색</a>
				  </span>
				 </div>
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