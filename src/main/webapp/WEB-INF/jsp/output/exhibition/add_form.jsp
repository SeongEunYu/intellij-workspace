<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.argonet.r2rims.util.LanguageUtil"%>
<%@include file="../../pageInit.jsp" %>

<form id="formArea" action="${contextPath}/exhibition/addExhibition.do" method="post">

  <table class="write_tbl mgb_10" >
	<colgroup>
		<col style="width:140px;" />
		<col style="width:326px;" />
		<col style="width:140px" />
		<col style="" />
	</colgroup>
	<tbody>
		<tr>
			<th class="essential_th"><spring:message code='exhi.ancm.acps.dvs.cd'/></th>
			<td>
				<select name="ancmAcpsDvsCd" id="ancmAcpsDvsCd" class="select_type">${rims:makeCodeList('1170', true, '')}</select>
			</td>
			<th><spring:message code='exhi.dtl.dvs.nm'/></th>
			<td>
				<input type="text" name="dtlDvsNm" id="dtlDvsNm"  class="input_type" />
			</td>
		</tr>
		<tr>
			<th class="essential_th"><spring:message code='exhi.ancm.ym'/></th>
			<td>
				<input type="text" maxLength="4" style="width: 62px;text-align: right;" name="ancmYear" id="ancmYear" class="input_type required" /><spring:message code='common.year'/>
				<input type="text" maxLength="4" style="width: 32px;text-align: right;" name="ancmMonth" id="ancmMonth" class="input_type" /><spring:message code='common.month'/>
			</td>
			<th><spring:message code='exhi.plan.mng.crp.nm'/></th>
			<td>
				<input type="text" name="planMngCrpNm" id="planMngCrpNm"  class="input_type" />
			</td>
		</tr>
		<tr>
			<th class="essential_th"><spring:message code='exhi.ancm.ntn.cd'/></th>
			<td>
		        <select name="ancmNtnCd" id="ancmNtnCd" class="select_type required">
		          	${rims:makeCodeList('2000', true, '') }
		        </select>
		        <script type="text/javascript">
		        	jQuery(document).ready(function(){
		        			//$('#pblcNtnCd > option').eq(7).remove();
		        			$('#ancmNtnCd > option').eq(9).after($('<option value="">====================</option>')); });
		        </script>
			</td>
			<th><spring:message code='exhi.ancm.plc.nm'/></th>
			<td>
				<input type="text" name="ancmPlcNm" id="ancmPlcNm"  class="input_type" />
			</td>
		</tr>

		<tr>
			<th><spring:message code='exhi.agc.nm'/></th>
			<td colspan="3">
				<div class="r_add_bt">
		  	 	<input type="hidden" name="prtcpntIndex" value="1">
             	<input type="hidden" name="blngAgcCd" id="blngAgcCd_1" />
              	<input type="text" name="blngAgcNm" id="blngAgcNm_1" class="input_type" readonly="readonly" onkeydown="if(event.keyCode==13){getCodeOrgWin($(this),event);}"/>
			  	<span class="r_span_box">
				<a href="javascript:void(0);" class="tbl_icon_a tbl_search_icon" onclick="getCodeOrgWin($(this),event);">검색</a>
			  </span>
			 </div>
			</td>
		</tr>
		<tr>
			<th class="essential_th"><spring:message code='exhi.title.org'/></th>
			<td colspan="3">
				<input type="text" name="orgLangXhbtAncmNm" maxLength="400" class="input_type required" />
			</td>
		</tr>
		<tr>
			<th><spring:message code='exhi.title.etc'/></th>
			<td colspan="3">
				<input type="text" name="diffLangXhbtAncmNm" maxLength="400" class="input_type" />
			</td>
		</tr>
		<tr>
			<th class="add_help">
				<spring:message code='exhi.prfmc.times.rdt.cnt'/>
				<a href="javascript:void(0);" onclick="showTooltip($(this))" class="tbl_help_a"></a>
				<p class="th_help_box"><span><spring:message code='tooltip.exi1'/></span></p>
			</th>
			<td><input type="text" name="prfmcTimesPrdtCnt" maxLength="3" class="input_type" /></td>
			<th><spring:message code='exhi.anuc.pe.cnt'/></th>
			<td><input type="text" name="anucPeCnt" class="input_type" maxLength="3" maxlength="3" /></td>
		</tr>
		<tr>
			<th class="add_help">
				<spring:message code='exhi.prdt.nm'/>
				<a href="javascript:void(0);" onclick="showTooltip($(this))" class="tbl_help_a"></a>
				<p class="th_help_box"><span><spring:message code='tooltip.exi2'/></span></p>
			</th>
			<td colspan="3"><input type="text" name="prdtNm" class="input_type" maxLength="300" /></td>
		</tr>
		<tr>
			<th class="add_help">
				<spring:message code='exhi.xhbt.cntn'/>
				<a href="javascript:void(0);" onclick="showTooltip($(this))" class="tbl_help_a"></a>
				<p class="th_help_box"><span><spring:message code='tooltip.exi3'/></span></p>
			</th>
			<td colspan="3">
				<div class="tbl_textarea">
					<textarea rows="2" name="xhbtCntn" maxlength="1000" ></textarea>
				</div>
			</td>
		</tr>
		<c:choose>
			<c:when test="${sessionScope.auth.adminDvsCd == 'S' || sessionScope.auth.adminDvsCd == 'M' || sessionScope.auth.adminDvsCd == 'P'}">
				<tr>
					<th><spring:message code='exhi.appr.dvs.cd'/></th>
					<td colspan="3">
						<select name="apprDvsCd" id="apprDvsCd" class="select_type">${rims:makeCodeList('1400', true, '')}</select>
					</td>
				</tr>
				<tr>
					<th><spring:message code='exhi.rtrn'/></th>
					<td colspan="3">
						<div class="tbl_textarea">
							<textarea rows="2" name="apprRtrnCnclRsnCntn" maxlength="4000" ></textarea>
						</div>
					</td>
				</tr>
			</c:when>
			<c:otherwise>
				<tr>
					<th><spring:message code='exhi.appr.dvs.cd'/></th>
					<td colspan="3">
						${rims:codeValue('1400', '1')}
						<input type="hidden" name="apprDvsCd" value="1" />
					</td>
				</tr>
			</c:otherwise>
		</c:choose>
	</tbody>
  </table>
</form>
<script type="text/javascript">
$(document).ready(function(){
	  $('input, select, textarea').change(function(){ isChange = true; });
	  $('input:checkbox, input:radio').click(function(){ isChange = true; });
});
</script>