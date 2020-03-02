<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.argonet.r2rims.util.LanguageUtil"%>
<%@include file="../../pageInit.jsp" %>
<c:set var="setDisable" value=""/>
<c:set var="clickAlert" value=""/>
<c:if test="${not empty award.src and award.src eq 'ERP'}">
	<c:set var="setDisable" value='disabled="disabled"'/>
	<c:set var="clickAlert" value='onclick="javascript:dhtmlx.alert({type:\'alert-warning\',text:\'ERP에서 연계된 데이터는 ERP에서만 수정 가능합니다.\',callback:function(){}});"'/>
</c:if>
<form id="formArea" action="${contextPath}/award/modifyAward.do" method="post">
  <input type="hidden" id="awardId" name="awardId" value="<c:out value="${award.awardId}"/>"/>
  <input type="hidden" id="listUrl" name="listUrl" value="${contextPath}/award/findAwardList.do"/>

  <table class="write_tbl mgb_10" >
	<colgroup>
		<col style="width:140px;" />
		<col style="width:326px;" />
		<col style="width:140px" />
		<col style="" />
	</colgroup>
	<tbody>
		<tr>
			<th class="essential_th"><spring:message code='awrd.ym'/></th>
			<td ${clickAlert}>
				<input type="text" maxLength="4" style="width: 62px;text-align: right;" name="awrdYear" id="awrdYear" class="input_type required"  value="<c:out value="${award.awrdYear}"/>"  ${setDisable}/><spring:message code='common.year'/>
				<input type="text" maxLength="4" style="width: 32px;text-align: right;" name="awrdMonth" id="awrdMonth" class="input_type"  value="<c:out value="${award.awrdMonth}"/>"  ${setDisable}/><spring:message code='common.month'/>
			</td>
			<th class="essential_th"><spring:message code='awrd.nm'/></th>
			<td ${clickAlert}>
				<input type="text" name="awrdNm" id="awrdNm"  class="input_type required" value="<c:out value="${award.awrdNm}"/>" ${setDisable}/>
			</td>
		</tr>
		<tr>
			<th class="essential_th add_help">
				<spring:message code='awrd.cfmt.agc.nm'/><a href="javascript:void(0);" onclick="showTooltip($(this))" class="tbl_help_a"></a>
				<p class="th_help_box"><span><spring:message code='tooltip.awrd1'/></span></p>
			</th>
			<td ${clickAlert}>
				<input type="text" name="cfmtAgcNm" id="cfmtAgcNm"  class="input_type required" value="<c:out value="${award.cfmtAgcNm}"/>" ${setDisable}/>
			</td>
			<th class="essential_th"><spring:message code='awrd.cfmt.ntn.cd'/></th>
			<td ${clickAlert}>
		        <select name="cfmtNtnCd" id="cfmtNtnCd" class="select_type required" ${setDisable}>
		          	${rims:makeCodeList('2000', true, award.cfmtNtnCd) }
		        </select>
		        <script type="text/javascript">
		        	jQuery(document).ready(function(){
		        			//$('#pblcNtnCd > option').eq(7).remove();
		        			$('#cfmtNtnCd > option').eq(9).after($('<option value="">====================</option>')); });
		        </script>
			</td>
		</tr>
		<tr>
			<th><spring:message code='awrd.dvs.cd'/></th>
			<td ${clickAlert}>
				<select name="awrdDvsCd" id="awrdDvsCd" class="select_type" ${setDisable}>${rims:makeCodeList('1210', true, award.awrdDvsCd)}</select>
			</td>
			<th><spring:message code='awrd.blng.univ'/></th>
			<td ${clickAlert}>
		  	 <div class="r_add_bt">
		  	 	<input type="hidden" name="prtcpntIndex" value="1">
             	<input type="hidden" name="blngUnivCd" id="blngAgcCd_1" value="<c:out value="${award.blngUnivCd}"/>"/>
              	<input type="text" name="blngUnivNm" id="blngAgcNm_1" class="input_type" style="<c:if test="${not empty award.blngUnivNm and empty award.blngUnivCd }">background-color: #fef3d7;</c:if>" readonly="readonly" value="<c:out value="${award.blngUnivNm}"/>" onkeydown="if(event.keyCode==13){getCodeOrgWin($(this),event);}" ${setDisable}/>
			  	<span class="r_span_box">
				<a href="javascript:void(0);" class="tbl_icon_a tbl_search_icon" onclick="getCodeOrgWin($(this),event);">검색</a>
			  </span>
			 </div>
			</td>
		</tr>
		<tr>
			<th><spring:message code='kri.link'/></th>
			<td ${clickAlert}>
	    		<input type="radio" name="interfaceFlag" id="interfaceFlag1" value="1" class="" ${fn:startsWith(award.interfaceFlag, '1') ? 'checked' : ''} /><spring:message code='kri.link.yes'/>
				<input type="radio" name="interfaceFlag" id="interfaceFlag0" value="0" class="" ${fn:startsWith(award.interfaceFlag, '0') ? 'checked' : ''} /><spring:message code='kri.link.no'/>
			</td>
			<th><spring:message code='common.source'/></th>
			<td ${clickAlert}>
				<input type="hidden" name="src" value="<c:out value="${award.src}"/>" />
				<c:if test="${empty award.src or award.src eq 'USER'}">직접입력</c:if>
				<c:if test="${not empty award.src and award.src ne 'USER'}"><c:out value="${award.src}"/></c:if>
			</td>
		</tr>
		<tr>
			<th><spring:message code='common.reg.date'/></th>
			<td>
				<fmt:formatDate var="regDate" value="${award.regDate}" pattern="yyyy-MM-dd" /> <c:out value="${regDate}"/> ( <c:out value="${empty award.regUserNm ? 'ADMIN' : award.regUserNm}"/> )
			</td>
			<th><spring:message code='common.mod.date'/></th>
			<td>
				<fmt:formatDate var="modDate" value="${award.modDate}" pattern="yyyy-MM-dd" /> <c:out value="${modDate}"/> ( <c:out value="${empty award.modUserNm ? 'ADMIN' : award.modUserNm}"/> )
			</td>
		</tr>
	</tbody>
  </table>
</form>
<form id="removeFormArea" action="${contextPath}/award/removeAward.do" method="post">
	<input type="hidden" name="awardId" value="<c:out value="${award.awardId}"/>"/>
</form>
<script type="text/javascript">
$(document).ready(function(){
	  $('input, select, textarea').change(function(){ isChange = true; });
	  $('input:checkbox, input:radio').click(function(){ isChange = true; });
});
</script>