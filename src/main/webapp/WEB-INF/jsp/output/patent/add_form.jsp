<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.argonet.r2rims.util.LanguageUtil"%>
<%@include file="../../pageInit.jsp" %>
 <c:set var="rschRequiredClass" value=""/><c:set var="rschEssentialTh" value=""/>
 	<c:if test="${sessionScope.auth.adminDvsCd eq 'R' or sessionScope.auth.adminDvsCd eq 'S'}">
	<c:set var="rschRequiredClass" value="required"/><c:set var="rschEssentialTh" value="essential_th"/>
 </c:if>
 <c:if test="${sessMode or (sessionScope.auth.adminDvsCd eq 'R' or sessionScope.auth.adminDvsCd eq 'S' )}">
  <c:set var="prtpntId" value="${sessionScope.sess_user.userId}"/><c:set var="prtcpntNm" value="${sessionScope.sess_user.abbrLastName}, ${sessionScope.sess_user.abbrFirstName}"/>
  <c:set var="prtcpntFullNm" value="${sessionScope.sess_user.lastName}, ${sessionScope.sess_user.firstName}"/><c:set var="pcnRschrRegNo" value="${sessionScope.sess_user.rschrRegNo}"/>
  <c:set var="deptKor" value="${sessionScope.sess_user.groupDept}"/><c:set var="blngAgcCd" value="${sysConf['inst.blng.agc.code']}"/><c:set var="blngAgcNm" value="${sysConf['inst.blng.agc.name']}"/>
</c:if>
<form id="vrfcFrm">
<table class="write_tbl mgb_10"  style="border: 3px solid gray;">
	<colgroup>
		<col style="" />
		<col style="width: 120px;" />
	</colgroup>
	<tbody>
		<tr>
			<td><spring:message code='patn.dup.info'/></td>
			<td>
				<div style="padding: 0px 0px 0px 0px;">
					<div class="list_set">
						<ul>
							<li><a href="javascript:dplctPatentCheck();" class="list_icon19"><spring:message code='common.button.search'/></a></li>
						</ul>
					</div>
				</div>
			</td>
		</tr>
	</tbody>
</table>
</form>
<form id="formArea" action="<c:url value="/${preUrl}/patent/addPatent.do"/>" method="post">
	<table class="write_tbl mgb_10" >
		<colgroup>
			<col style="width: 165px;"></col>
			<col style="width: 331px;"></col>
			<col style="width: 165px;"></col>
			<col style=""></col>
		</colgroup>
		<tbody>
		<c:if test="${sessMode or (sessionScope.auth.adminDvsCd eq 'R' or sessionScope.auth.adminDvsCd eq 'S' )}">
			<tr style="height: 35px;">
				<th><spring:message code="pat.reprsnt.patent.at"/></th>
				<td colspan="3">
					<spring:message code="common.radio.yes"/> <input type="radio" name="isReprsntPatent" value="Y"/>
					&nbsp;&nbsp;&nbsp;<spring:message code="common.radio.no"/> <input type="radio" name="isReprsntPatent" value="N" checked="checked"/>
				</td>
			</tr>
		</c:if>
			<tr>
				<th class="essential_th"><spring:message code='patn.itl.ppr.rgt.dvs.cd'/></th>
				<td>
					<select name="itlPprRgtDvsCd" id="itlPprRgtDvsCd" class="select_type required">${rims:makeCodeList('1080',true,'')}</select>
				</td>
				<th class="essential_th"><spring:message code='patn.acqs.dvs.cd'/></th>
				<td>
					<select name="acqsDvsCd" id="acqsDvsCd" class="select_type required" style="width: 49%;">${rims:makeCodeList('1090',true,'')}</select>
					<select name="status" class="select_type" style="width: 49%;">${rims:makeCodeList('patent.status',true,'')}</select>
				</td>
			</tr>
			<tr>
				<th class="essential_th"><spring:message code='patn.acqs.ntn.dvs.cd'/></th>
				<td>
					<select name="acqsNtnDvsCd" id="acqsNtnDvsCd" class="select_type required" >${rims:makeCodeList('1140',true,'')}</select>
				</td>
				<th class="essential_th"><spring:message code='patn.appl.reg.ntn.cd'/></th>
				<td>
					<select name="applRegNtnCd" id="applRegNtnCd" class="select_type required">${rims:makeCodeList('2000', true, '') }</select>
					<script type="text/javascript"> jQuery(document).ready(function(){ $('#applRegNtnCd > option').eq(9).after($('<option value="">====================</option>')); }); </script>
				</td>
			</tr>
			<tr>
				<th class="essential_th add_help">
					<spring:message code='patn.itl.title.org'/><a href="javascript:void(0);" onclick="showTooltip($(this))" class="tbl_help_a"></a>
					<p class="th_help_box"><span><spring:message code='tooltip.pat1'/></span></p>
				</th>
				<td colspan="3">
					<div class="tbl_textarea">
						<textarea maxLength="500" rows="2" name="itlPprRgtNm" id="itlPprRgtNm" class="required" ></textarea>
					</div>
				</td>
			</tr>
			<tr>
				<th class="add_help">
					<spring:message code='patn.itl.title.dif'/><a href="javascript:void(0);" onclick="showTooltip($(this))" class="tbl_help_a"></a>
					<p class="th_help_box"><span><spring:message code='tooltip.pat1'/></span></p>
				</th>
				<td colspan="3">
					<div class="tbl_textarea">
						<textarea maxLength="500" rows="2" name="diffItlPprRgtNm" id="diffItlPprRgtNm"></textarea>
					</div>
				</td>
			</tr>
			<tr>
				<th class="essential_th"><spring:message code='patn.appl.reg.date'/></th>
				<td>
				  <input type="text" name="applRegYear" id="applRegYear" class="input_type required" style="width: 80px;" />&nbsp;<spring:message code='common.year'/>&nbsp;&nbsp;
	              <input type="text" name="applRegMonth" id="applRegMonth" class="input_type" style="width: 45px;" />&nbsp;<spring:message code='common.month'/>&nbsp;&nbsp;
	              <input type="text" name="applRegDay" id="applRegDay" class="input_type" style="width: 45px;" />&nbsp;<spring:message code='common.day'/>&nbsp;&nbsp;
				</td>
				<th class="essential_th"><spring:message code='patn.appl.reg.no'/></th>
				<td>
					<input type="text" name="applRegNo" id="applRegNo" maxLength="32" class="input_type required"/>
				</td>
			</tr>
			<tr>
				<th><spring:message code='patn.itl.ppr.rgt.reg.date'/></th>
				<td>
				  <input type="text" name="itlPprRgtRegYear" id="itlPprRgtRegYear" class="input_type " style="width: 80px;" />&nbsp;<spring:message code='common.year'/>&nbsp;&nbsp;
	              <input type="text" name="itlPprRgtRegMonth" id="itlPprRgtRegMonth" class="input_type " style="width: 45px;" />&nbsp;<spring:message code='common.month'/>&nbsp;&nbsp;
	              <input type="text" name="itlPprRgtRegDay" id="itlPprRgtRegDay" class="input_type " style="width: 45px;" />&nbsp;<spring:message code='common.day'/>&nbsp;&nbsp;
				</td>
				<th><spring:message code='patn.itl.ppr.rgt.reg.no'/></th>
				<td>
					<input type="text" maxLength="50" name="itlPprRgtRegNo" id="itlPprRgtRegNo" class="input_type"/>
				</td>
			</tr>
			<tr>
				<th class="essential_th add_help">
					<spring:message code='patn.appr.regt.nm'/><a href="javascript:void(0);" onclick="showTooltip($(this))" class="tbl_help_a"></a>
					<p class="th_help_box"><span><spring:message code='tooltip.pat2'/></span></p>
				</th>
				<td>
					<input type="text" maxLength="150" name="applRegtNm"  id="applRegtNm" class="input_type required"/>
				</td>
				<th><spring:message code='patn.pat.cls.cd'/></th>
				<td>
					<select name="patClsCd" id="patClsCd" class="select_type">${rims:makeCodeList('1710',true, '')}</select>
				</td>
			</tr>
			<tr>
				<th><spring:message code='patn.invt.nm'/></th>
				<td colspan="3">
					<div class="writer_td_inner">
						<em class="td_left_ex"></em>
						<input type="hidden" name="invtNm" value="" />
						<p>
						<spring:message code='patn.invt.cnt'/>
						<input type="text" id="invtCnt" name="invtCnt" class="input_type" style="width:20px;text-align: center;" maxlength="3" onchange="CheckValue()"/>
						<em>ex) 5</em>
						</p>
					</div>
				</td>
			</tr>
			<tr>
				<td colspan="4" class="inner_tbl_td">
					<table class="inner_tbl move_tbl" id="prtcpntTbl">
						<thead>
							<tr>
								<th colspan="2" style="width: 50px;"><spring:message code='patn.order'/></th>
								<th style="width: 150px;" class="essential_th"><spring:message code='patn.abbr.nm'/></th>
								<th style="width: 200px;"><spring:message code='patn.user.id'/></th>
								<th style="width: 200px;"><spring:message code='patn.blng.agc.nm'/></th>
								<th style="width: 150px"><spring:message code='patn.author.dept'/></th>
								<th style="width: 60px;"></th>
							</tr>
						</thead>
						<tbody id="prtcpntTbody">
						<c:set var="prtcpntIdx" value="1"/>
							<tr>
								<td style="width:10px;text-align: left;"><img src="<c:url value='/images/icon/dragpoint.png' />" /></td>
								<td style="text-align: center;width: 40px;">
									<span class="prtcpnt_order">${prtcpntIdx}</span>
									<input type="hidden" name="prtcpntIndex" id="prtcpntIndex_${prtcpntIdx}" value="${prtcpntIdx}"/>
								</td>
								<td style="width: 150px;">
									<input type="text" name="prtcpntNm" maxLength="30" id="prtcpntNm_${prtcpntIdx}" class="input_type required" value="${prtcpntNm}" onkeydown="if(event.keyCode==13){findUser($(this),event);}"/>
									<input type="hidden" name="pcnRschrRegNo" id="pcnRschrRegNo_${prtcpntIdx}" value="${pcnRschrRegNo}"/>
									<input type="hidden" name="seqAuthor" id="seqAuthor_${prtcpntIdx}"/>
								</td>
								<td style="width: 200px;">
									<span class="dk_bt_box">
									  <input type="text" name="prtcpntId" id="prtcpntId_${prtcpntIdx}"  value="${prtpntId}" class="input_type" onkeydown="if(event.keyCode==13){findUser($(this),event);}"/>
									 <span class="dk_r_bt">
										<a href="javascript:void(0);" class="tbl_icon_a tbl_search_icon" onclick="findUser($(this),event);">검색</a>
										<a href="javascript:void(0);" class="tbl_icon_a tbl_trash_icon" onclick="clearPrtcpnt($(this));">지우기</a>
									 </span>
									</span>
								</td>
								<td style="width: 200px;">
									<div class="r_add_bt">
										<input type="hidden" name="blngAgcCd" id="blngAgcCd_${prtcpntIdx}" value="${blngAgcCd}"/>
										<input type="text"  name="blngAgcNm" id="blngAgcNm_${prtcpntIdx}"  value="${blngAgcNm}" class="input_type" onkeydown="if(event.keyCode==13){getCodeOrgWin($(this),event);}"/>
										<span class="r_span_box">
											<a href="javascript:void(0);" class="tbl_icon_a tbl_search_icon" onclick="getCodeOrgWin($(this),event);">검색</a>
										</span>
									</div>
								</td>
								<td style="width: 150px" class="dispDept"></td>
								<td style="width: 60px;">
									<a href="javascript:void(0);" class="tbl_icon_a row_add_bt" onclick="addPrtcpnt($(this),'${sessionScope.auth.adminDvsCd}')"><spring:message code='common.add'/></a>
									<a href="javascript:void(0);" class="tbl_icon_a red_del" onclick="removePrtcpnt($(this));"><spring:message code='common.row.delete'/></a>
								</td>
							</tr>
						<script type="text/javascript">var prtcpntIdx = '${prtcpntIdx}';</script>
						</tbody>
					</table>
				</td>
			</tr>
			<tr>
				<th><spring:message code='patn.acqs.dtl.dvs.cd'/></th>
				<td>
					<input name="acqsDtlDvsCd" type="radio" value="1" />&nbsp;<spring:message code='patn.dtl'/>&nbsp;&nbsp;
					<input name="acqsDtlDvsCd" type="radio" value="2" />&nbsp;<spring:message code='patn.pct'/>&nbsp;&nbsp;
					<input name="acqsDtlDvsCd" type="radio" value="3" />&nbsp;<spring:message code='patn.epo'/>&nbsp;&nbsp;
				</td>
				<th class="add_help"><spring:message code='patn.pct.epo'/><a href="javascript:void(0);" onclick="showTooltip($(this))" class="tbl_help_a"></a>
					<p class="th_help_box"><span><spring:message code='tooltip.pat4'/></span></p>
				</th>
				<td>
					<input type="text" name="pctEpoApplNtnCnt" id="pctEpoApplNtnCnt" class="input_type" maxlength="3"/>
				</td>
			</tr>
			<tr>
				<th><spring:message code='patn.smmr.cntn'/></th>
				<td colspan="3">
					<div class="tbl_textarea">
						<textarea name="smmrCntn" id="smmrCntn" rows="7"></textarea>
					</div>
				</td>
			</tr>
			<tr>
				<th rowspan="2" class="${rschEssentialTh}"><spring:message code='patn.sbjt.no'/></th>
				<td>
					<input type="checkbox" id="relateFundingAt" name="relateFundingAt" value="N" /><spring:message code="art.relate.funding.lable" />
				</td>
				<th rowspan="2"><spring:message code='patn.blng.univ'/></th>
				<td rowspan="2">
					<span class="dk_bt_box">
						<input type="text" style="color: #aaa;" onclick="getOrgCodeGeneralWin($('#blngUnivCdKey'), $('#blngUnivCdValue'), event);" readonly="readonly" id="blngUnivCdValue" name="blngUnivNm" class="input_type"/>
						<input type="hidden" id="blngUnivCdKey" name="blngUnivCd"/>
					 <span class="dk_r_bt">
						<a href="javascript:void(0);" class="tbl_icon_a tbl_search_icon" onclick="getOrgCodeGeneralWin($('#blngUnivCdKey'), $('#blngUnivCdValue'), event);">검색</a>
						<a href="javascript:void(0);" class="tbl_icon_a tbl_trash_icon" onclick="clearCode($('#blngUnivCdKey'), $('#blngUnivCdValue'));">지우기</a>
					 </span>
					</span>
				</td>
			</tr>
			<tr>
				<td style="padding: 1px 1px;">
					<table class="in_tbl inner_tbl">
						<colgroup>
							<col style="width:105px;" />
							<col style="width:162px;" />
							<col style="width: 70px;" />
						</colgroup>
						<tbody>
							<c:set var="fundingIdx" value="0"/>
							<tr>
								<td>
									<input type="text" name="sbjtNo"  id="sbjtNo_${fundingIdx}" class="input_type"  readonly="readonly" />
									<input type="hidden" name="seqNo"  id="seqNo_${fundingIdx}" value="_blank">
									<input type="hidden" name="fundIndex"  id="fundIndex_${fundingIdx}" value="${fundingIdx}">
								</td>
								<td>
									<div class="r_add_bt">
				               		  <input type="hidden" name="fundingId" id="fundingId_${fundingIdx}"/>
				                	  <input type="text" name="rschSbjtNm" id="rschSbjtNm_${fundingIdx}" class="input_type" onkeydown="if(event.keyCode==13){findFunding($(this),event);}"/>
									  <span class="r_span_box">
										<a href="javascript:void(0);" class="tbl_icon_a tbl_search_icon" onclick="findFunding($(this),event);">검색</a>
									  </span>
									</div>
								</td>
								<td>
									<a href="javascript:void(0);" class="tbl_icon_a row_add_bt" onclick="addFunding($(this),'${sessionScope.auth.adminDvsCd}')"><spring:message code='common.add'/></a>
									<a href="javascript:void(0);" class="tbl_icon_a red_del" onclick="removeFunding($(this));"><spring:message code='common.row.delete'/></a>
								</td>
							</tr>
							<script type="text/javascript">var fundingIdx = '${fundingIdx}';</script>
						</tbody>
					</table>
				</td>
			</tr>
			<tr>
				<th>IPC</th>
				<td colspan="3"><input type="text" name="ipc" id="ipc" class="input_type"/></td>
			</tr>
			<c:if test="${sessionScope.auth.adminDvsCd eq 'M' or sessionScope.auth.adminDvsCd eq 'P'}">
			<tr>
				<th><spring:message code='patn.src.id'/></th>
				<td></td>
				<th><spring:message code='patn.family.code'/></th>
				<td>
					<span class="dk_bt_box">
						<input type="text" id="familyCode" name="familyCode" class="input_type" style="width: 100px;"/>
						<select id="applDvsCd" name="applDvsCd" class="select_type" style="width: 60px;">
							<option value=""></option>
							<option value="1">국내</option>
							<option value="2">해외</option>
							<option value="3">PCT</option>
							<option value="4">변경</option>
							<option value="5">분할</option>
							<option value="6">우선권</option>
						</select>
						<span class="dk_r_bt">
							<a href="javascript:void(0);" class="tbl_icon_a tbl_search_icon" onclick="getFamilyWin('', $('#itlPprRgtNm').val());">검색</a>
							<a href="javascript:void(0);" class="tbl_icon_a tbl_trash_icon" onclick="$('#familyCode').val('');">지우기</a>
					 	</span>
					</span>
				</td>
			</tr>
			<tr>
			 	<th>신고서ID</th>
			 	<td><input type="text" id="pmsId" name="pmsId" class="input_type"/></td>
			 	<th>기관실적여부</th>
			 	<td>
					${sysConf['inst.abrv']} <input type="radio" name="insttRsltAt" onchange="changOtherValue(this.value);" value="Y" checked="checked" />
		            &nbsp;Other <input type="radio" name="insttRsltAt" onchange="changOtherValue(this.value);" value="N" />
		            <input type="hidden" value="" name="otherValue" id="otherValue">
			 	</td>
			</tr>
			</c:if>
			<tr>
				<th><spring:message code='patn.vrfc.dvs.cd'/></th>
				<td>
					<label id="vrfcDvsCdValue" class="kriGray">${empty rims:codeValue('1420','') ? '미검증' : rims:codeValue('1420','')}</label>
					<input type="hidden" id="vrfcDvsCdKey" name="vrfcDvsCd" value="1"/>
				</td>
				<th><spring:message code='patn.vrfc.dvs.date'/></th>
				<td>
					<span class="kriGray" id="vrfcDate"></span>
				</td>
			</tr>
			<c:if test="${sessionScope.auth.adminDvsCd eq 'M' or  sessionScope.auth.adminDvsCd eq 'P' }">
			<tr>
				<th><spring:message code='patn.rtrn'/></th>
				<td colspan="3">
					<div class="tbl_textarea">
						<textarea maxLength="4000" rows="2" id="appr_rtrn_cncl_rsn_cntn" name="apprRtrnCnclRsnCntn"></textarea>
					</div>
				</td>
			</tr>
			<tr>
				<th><spring:message code='patn.appr.dvs.cd'/></th>
				<td>
					<select id="apprDvsCdValue" name="apprDvsCd"  class="select_type" style="width: 100px;">${rims:makeCodeList('1400', true, '') }</select>
				</td>
				<th><spring:message code='patn.appr.dvs.date'/></th>
				<td></td>
			</tr>
			</c:if>
		</tbody>
	 </table>
</form>
<script type="text/javascript">
$('#fnDelete').hide();
$(document).ready(function(){
	  $('input, select, textarea').change(function(){ isChange = true; });
	  $('input:checkbox, input:radio').click(function(){ isChange = true; });
	  $("#prtcpntTbl tbody").sortable({
		  placeholder: "ui-state-highlight",
		  deactivate: function(event, ui){
			  $(this).$('span[id^="order_"]').each(function(i, obj){ $(obj).text(i+1); });
			  isChange = true;
		  }
	  });
	  makeOrgUserList();
});
var orgUserList;
function makeOrgUserList(){
	orgUserList = new Array();
	var indexs =  $('input[name="prtcpntIndex"]');
	for(var i = 0; i < indexs.length; i++){
		var idx = indexs.eq(i).val();
		var seqAuthor = $('#seqAuthor_'+idx).val();
		var prtcpntId = $('#prtcpntId_'+idx).val();
		if(seqAuthor != '' && seqAuthor != 'N' && prtcpntId != '')
			orgUserList.push(seqAuthor+"_"+prtcpntId);
	}
}

function userCheck() {
	var indexs =  $('input[name="prtcpntIndex"]');
	for(var i = 0; i < indexs.length; i++){
		var idx = indexs.eq(i).val();
		var seqAuthor = $('#seqAuthor_'+idx).val();
		var prtcpntId = $('#prtcpntId_'+idx).val();

		if(seqAuthor != '' && seqAuthor != 'N' )
		{
			for(var j =0; j < orgUserList.length; j++)
			{
				var orgUser = orgUserList[j].split("_");
				if(seqAuthor == orgUser[0] && prtcpntId != orgUser[1])
					$('#formArea').append($('<input type="hidden" name="relisUser" value="'+orgUser[1]+'" />)'));
			}
		}
	}
}

</script>