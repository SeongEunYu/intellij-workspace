<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.argonet.r2rims.util.LanguageUtil"%>
<%@include file="../../pageInit.jsp" %>

<form id="formArea" action="${contextPath}/activity/addActivity.do" method="post">

  <table class="write_tbl mgb_10" >
	<colgroup>
		<col style="width:140px;" />
		<col style="width:326px;" />
		<col style="width:140px" />
		<col style="" />
	</colgroup>
  	<tbody>
  		<tr>
  			<th><spring:message code='act.stt.date'/></th>
  			<td>
				<select name="sttYear" id="sttYear" class="select_type" onchange="changePblcYear('stt');" style="width: 70px;">${rims:makeYearWithAddYearList(1900, '', true, false, 5)}</select>&nbsp;<spring:message code='common.year'/>&nbsp;
				<select name="sttMonth" id="sttMonth" class="select_type" onchange="changePblcMonth('stt');" style="width: 55px;">${rims:makeMonthList('', true)}</select>&nbsp;<spring:message code='common.month'/>&nbsp;
				<select name="sttDay" id="sttDay" class="select_type" onchange="changePblcDay('stt');" style="width: 55px;">${rims:makeDayList('', '', '', true)}</select>&nbsp;<spring:message code='common.day'/>&nbsp;
  			</td>
  			<th><spring:message code='act.end.date'/></th>
  			<td>
				<select name="endYear" id="endYear" class="select_type" onchange="changePblcYear('end');" style="width: 70px;">${rims:makeYearWithAddYearList(1900, '', true, false, 5)}</select>&nbsp;<spring:message code='common.year'/>&nbsp;
				<select name="endMonth" id="endMonth" class="select_type" onchange="changePblcMonth('end');" style="width: 55px;">${rims:makeMonthList('', true)}</select>&nbsp;<spring:message code='common.month'/>&nbsp;
				<select name="endDay" id="endDay" class="select_type" onchange="changePblcDay('end');" style="width: 55px;">${rims:makeDayList('', '', '', true)}</select>&nbsp;<spring:message code='common.day'/>&nbsp;
  			</td>
  		</tr>
  		<tr>
  			<th class="essential_th"><spring:message code='act.scope'/></th>
  			<td>
  				<select name="actScopeCd" id="actScopeCd" class="select_type required" >${rims:makeCodeList('act.scope', true, '')}</select>
  			</td>
  			<th><spring:message code='act.gubun'/></th>
  			<td>
  				<select name="actvtyDvsCd" id="actvtyDvsCd" class="select_type">${rims:makeCodeList('ACT_TYPE', true, '')}</select>
  			</td>
  		</tr>
  		<tr>
  			<th class="essential_th"><spring:message code='act.content'/></th>
  			<td colspan="3">
				<div class="tbl_textarea">
					<textarea name="actvtyNm" id="actvtyNm" maxLength="1000" rows="2" class="required" ></textarea>
				</div>
  			</td>
  		</tr>
  		<tr>
  			<th><spring:message code='act.mngt.instt.nm'/></th>
  			<td colspan="3">
  				<input name="mngtInsttNm" id="mngtInsttNm" class="input_type" />
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