<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.argonet.r2rims.util.LanguageUtil"%>
<%@include file="../../pageInit.jsp" %>
<c:if test="${sessMode or (sessionScope.auth.adminDvsCd eq 'R' or sessionScope.auth.adminDvsCd eq 'S' )}">
  <c:set var="prtpntId" value="${sessionScope.sess_user.userId}"/><c:set var="prtcpntNm" value="${sessionScope.sess_user.abbrLastName}, ${sessionScope.sess_user.abbrFirstName}"/>
  <c:set var="prtcpntFullNm" value="${sessionScope.sess_user.lastName}, ${sessionScope.sess_user.firstName}"/><c:set var="pcnRschrRegNo" value="${sessionScope.sess_user.rschrRegNo}"/>
  <c:set var="deptKor" value="${sessionScope.sess_user.groupDept}"/><c:set var="blngAgcCd" value="${sysConf['inst.blng.agc.code']}"/><c:set var="blngAgcNm" value="${sysConf['inst.blng.agc.name']}"/>
</c:if>
<form id="formArea" action="${contextPath}/techtrans/addTechtrans.do" method="post">
	<table class="write_tbl mgb_10">
		<colgroup>
			<col style="width: 140px;" />
			<col style="width: 326px;" />
			<col style="width: 140px" />
			<col style="" />
		</colgroup>
		<tbody>
			<tr>
				<th class="essential_th"><spring:message code='tech.transr.ym'/></th>
				<td>
					<input type="text" maxLength="4" style="width: 62px;text-align: right;" name="techTransrYear" id="techTransrYear" class="input_type required" /><spring:message code='common.year'/>
					<input type="text" maxLength="2" style="width: 32px;text-align: right;" name="techTransrMonth" id="techTransrMonth" class="input_type required"/><spring:message code='common.month'/>
				</td>
				<th class="add_help">
					<spring:message code='tech.transr.corp.nm'/><a href="javascript:void(0);" onclick="showTooltip($(this))" class="tbl_help_a"></a>
					<p class="th_help_box"><span><spring:message code='tooltip.tech1'/></span></p>
				</th>
				<td>
					<input type="text" name="techTransrCorpNm"  id="techTransrCorpNm" class="input_type" style="width: 200px;"/>
					<input type="checkbox" name="techTransrCorpOpenCd" id="techTransrCorpOpenCd" value="Y"/><label for="techTransrCorpOpenCd">기업공개시</label>
				</td>
			</tr>
			<tr>
				<th><spring:message code='tech.transr.type'/></th>
				<td>
					<select name="techTransrCd" id="techTransrCd" class="select_type">${rims:makeCodeList('tech.techTransrCd', true, '')}</select>
				</td>
				<th><spring:message code='tech.collection.type'/></th>
				<td>
					<select name="collectionCd" id="collectionCd" class="select_type">${rims:makeCodeList('tech.collectionCd', true, '')}</select>
				</td>
			</tr>
			<tr>
				<th class="essential_th"><spring:message code='tech.transr.nm'/></th>
				<td colspan="3">
					<input type="text" name="techTransrNm"  id="techTransrNm" class="input_type"/>
				</td>
			</tr>
			<tr>
				<th class="essential_th"><spring:message code='tech.transr.cnt'/></th>
				<td><input type="text" name="techTransrCnt" id="techTransrCnt" maxLength="6" class="input_type required" /></td>
				<th class="essential_th add_help">
					<spring:message code='tech.asso.tech.poss.cnt'/><a href="javascript:void(0);" onclick="showTooltip($(this))" class="tbl_help_a"></a>
					<p class="th_help_box"><span><spring:message code='tooltip.tech2'/></span></p>
				</th>
				<td><input type="text" name="assoTechPossCnt" id="assoTechPossCnt" maxLength="6" class="input_type required" /></td>
			</tr>
			<tr>
				<th><spring:message code='tech.blng.univ'/></th>
				<td>
					<span class="dk_bt_box">
						<input type="text" style="color: #aaa;" onclick="getOrgCodeGeneralWin($('#blngUnivCdKey'), $('#blngUnivCdValue'), event);" readonly="readonly" id="blngUnivCdValue" name="blngUnivNm" class="input_type"/>
						<input type="hidden" id="blngUnivCdKey" name="blngUnivCd" />
					 <span class="dk_r_bt">
						<a href="javascript:void(0);" class="tbl_icon_a tbl_search_icon" onclick="getOrgCodeGeneralWin($('#blngUnivCdKey'), $('#blngUnivCdValue'), event);">검색</a>
						<a href="javascript:void(0);" class="tbl_icon_a tbl_trash_icon" onclick="clearCode($('#blngUnivCdKey'), $('#blngUnivCdValue'));">지우기</a>
					 </span>
					</span>
				</td>
				<td></td>
				<td></td>
			</tr>
			<tr>
				<th><spring:message code='tech.cntrct.mgt.no'/></th>
				<td>
					<input type="text" name="cntrctManageNo" id="cntrctManageNo" class="input_type"/>
				</td>
				<th><spring:message code='tech.cntrct.period'/></th>
				<td>
				  <input type="text" name="cntrctSttYear" id="cntrctSttYear" class="input_type" style="width: 40px;"/><spring:message code='common.year'/>
	              <input type="text" name="cntrctSttMonth" id="cntrctSttMonth" class="input_type" style="width: 25px;"/><spring:message code='common.month'/>
	              &nbsp;~&nbsp;
	              <input type="text" name="cntrctEndYear" id="cntrctEndYear" class="input_type" style="width: 40px;"/><spring:message code='common.year'/>
	              <input type="text" name="cntrctEndMonth" id="cntrctEndMonth" class="input_type" style="width: 25px;"/><spring:message code='common.month'/>
				</td>
			</tr>
			<tr>
				<th><spring:message code='tech.cntrct.amt'/></th>
				<td>
					<input type="text" style="width: 234px;text-align: right;" name="cntrctAmt"  id="cntrctAmt" maxLength="15" class="input_type" onkeyup="getNumber($(this));" onkeydown="getNumber($(this));"/>
					<select style="width: 65px;" name="rpmAmtUnit" id="rpmAmtUnit" class="select_type">${rims:makeCodeList('tech.rpmAmtUnit', true, '')}</select>
				</td>
				<th><spring:message code='tech.oprtn.cnd'/></th>
				<td>
					<input type="text" name="oprtnCnd" id="oprtnCnd" class="input_type"/>
				</td>
			</tr>
			<tr>
				<th><spring:message code='tech.rpm'/></th>
				<td colspan="3"></td>
			</tr>
			<tr>
				<td colspan="4" class="inner_tbl_td">
					<div id="rpmDiv" style="overflow: auto;">
						<table class="inner_tbl" id="royaltyTbl">
							<thead>
								<tr>
									<th style="width:50px;">No</th>
									<th style="width:140px;"><spring:message code='tech.rooyalty.type'/></th>
									<th style="width:50px;"><spring:message code='tech.rpm.tme'/></th>
									<th style="width:100px;"><spring:message code='tech.rpm.date'/></th>
									<th style="width:120px;"><spring:message code='tech.rpm.amt'/></th>
									<!-- 
									<th><spring:message code='tech.ddc.amt'/></th>
									<th><spring:message code='tech.ddc.resn'/></th>
									<th><spring:message code='tech.diff.amt'/></th>
									<th><spring:message code='tech.invnter.dstb'/></th>
									<th><spring:message code='tech.univ.dstb'/></th>
									<th><spring:message code='tech.dept.dstb'/></th>
									<th><spring:message code='tech.acdincp.dstb'/></th>
									-->
									<th style="width:70px;">KAIST승인</th>
									<th style="width:100px;">승인일자</th>
									<th style="width:160px;">담당자의견</th>
									<th style="width:60px;"></th>
								</tr>
							</thead>
							<tbody>
								<c:set var="royaltyIdx" value="1"/>
								<tr>
									<td style="text-align: center;width:50px;">
										<input type="hidden" name="royaltyIndex" id="royaltyIndex_${royaltyIdx}" value="${royaltyIdx}"/>
										<input type="hidden" name="seqRoyalty" id="seqRoyalty_${royaltyIdx}" value="${empty rl.seqRoyalty ? 'N' : rl.seqRoyalty}"/>
										<span class="royalty_order" id="order_${royaltyIdx}">${royaltyIdx}</span>
							  		</td>
							  		<td style="width:140px;"><select name="collectionType" id="collectionType_${royaltyIdx}" class="select_type">${rims:makeCodeList('tech.collectionType', true, '')}</select></td>
							  		<td style="width:50px;"><input type="text" name="rpmTme" id="rpmTme_${royaltyIdx}" maxlength="4" class="input_type"/></td>
							  		<td style="width:100px;"><input type="text" name="rpmDate" id="rpmDate_${royaltyIdx}" maxlength="10" class="input_type"/></td>
							  		<td style="width:120px;">
							  			<input type="text" style="width :100px; text-align: right;" name="rpmAmt"  id="rpmAmt_${royaltyIdx}" maxLength="15" class="input_type" onkeyup="getNumber($(this));" onkeydown="getNumber($(this));"/><spring:message code='fund.won'/>
								  		<input type="hidden" name="ddcAmt" />
								  		<input type="hidden" name="ddcResn" />
								  		<input type="hidden" name="diffAmt"  />
								  		<input type="hidden" name="invnterDstbAmt" />
								  		<input type="hidden" name="univDstbAmt" />
								  		<input type="hidden" name="deptDstbAmt" />
								  		<input type="hidden" name="acdincpDstbAmt" />
							  		</td>
							  		<!-- 
							  		<td><input type="text" style="width :85px; text-align: right;" name="ddcAmt"  id="ddcAmt_${royaltyIdx}" maxLength="15" class="input_type" onkeyup="getNumber($(this));" onkeydown="getNumber($(this));"/><spring:message code='fund.won'/></td>
							  		<td><input type="text" name="ddcResn" id="ddcResn" class="input_type"/></td>
							  		<td><input type="text" style="width :85px; text-align: right;" name="diffAmt"  id="diffAmt_${royaltyIdx}" maxLength="15" class="input_type" onkeyup="getNumber($(this));" onkeydown="getNumber($(this));"/><spring:message code='fund.won'/></td>
							  		<td><input type="text" style="width :85px; text-align: right;" name="invnterDstbAmt"  id="invnterDstbAmt_${royaltyIdx}" maxLength="15" class="input_type" onkeyup="getNumber($(this));" onkeydown="getNumber($(this));"/><spring:message code='fund.won'/></td>
							  		<td><input type="text" style="width :85px; text-align: right;" name="univDstbAmt"  id="univDstbAmt_${royaltyIdx}" maxLength="15" class="input_type" onkeyup="getNumber($(this));" onkeydown="getNumber($(this));"/><spring:message code='fund.won'/></td>
							  		<td><input type="text" style="width :85px; text-align: right;" name="deptDstbAmt"  id="deptDstbAmt_${royaltyIdx}" maxLength="15" class="input_type" onkeyup="getNumber($(this));" onkeydown="getNumber($(this));"/><spring:message code='fund.won'/></td>
							  		<td><input type="text" style="width :85px; text-align: right;" name="acdincpDstbAmt"  id="acdincpDstbAmt_${royaltyIdx}" maxLength="15" class="input_type" onkeyup="getNumber($(this));" onkeydown="getNumber($(this));"/><spring:message code='fund.won'/></td>
							  		-->
									<c:if test="${sessionScope.login_user.adminDvsCd eq 'M' or sessionScope.login_user.adminDvsCd eq 'P' }">
										<td style="text-align: center;">
											<select name="royaltyApprDvsCd" class="select_type">${rims:makeCodeList('1400', true, '') }</select>
										</td>
									</c:if>
									<c:if test="${sessionScope.login_user.adminDvsCd ne 'M' and sessionScope.login_user.adminDvsCd ne 'P' }">
										<td style="text-align: center;"><input type="hidden" name="royaltyApprDvsCd" value=""/></td>
									</c:if>
									<td style="text-align: center;" class="dispRoyaltyApprDate"></td>
									<c:if test="${sessionScope.login_user.adminDvsCd eq 'M' or sessionScope.login_user.adminDvsCd eq 'P' }">
										<td style="text-align: center;"><input type="text" name="royaltyApprRtrnCnclRsnCntn" value="" class="input_type"/></td>
									</c:if>
									<c:if test="${sessionScope.login_user.adminDvsCd ne 'M' and sessionScope.login_user.adminDvsCd ne 'P' }">
										<td style="text-align: center;"><input type="text" name="royaltyApprRtrnCnclRsnCntn_disabled" value="" class="input_type" disabled="disabled" /><input type="hidden"  name="royaltyApprRtrnCnclRsnCntn" value=""/></td>
									</c:if>
							  		<td style="width:60px;">
							  			<a href="javascript:void(0);" class="tbl_icon_a row_add_bt" onclick="addRoyalty($(this));" ><spring:message code='common.add'/></a>
							  			<a href="javascript:void(0);" class="tbl_icon_a red_del" onclick="removeRoyalty($(this));"><spring:message code='common.row.delete'/></a>
							  		</td>
							  	</tr>
							  	<script type="text/javascript">var royaltyIdx = '${royaltyIdx}';</script>
							</tbody>
						</table>
					</div>
				</td>
			</tr>
			<tr>
			   	<th>참여자</th>
			   	<td colspan="3"></td>
			</tr>
			<tr>
				<td colspan="4" class="inner_tbl_td">
					<table class="inner_tbl" id="prtcpntTbl">
						<thead>
							<tr>
								<th>No</th>
								<th class="essential_th"><spring:message code='tech.parti.name'/></th>
								<th><spring:message code='tech.parti.full.name'/></th>
								<th><spring:message code='tech.parti.role'/></th>
								<th><spring:message code='tech.parti.id'/></th>
								<th><spring:message code='tech.parti.aff'/></th>
								<th><spring:message code='tech.parti.dept'/></th>
								<th></th>
							</tr>
						</thead>
						<tbody id="prtcpntTbody">
						  <c:set var="prtcpntIdx" value="1"/>
								<tr>
									<td style="width:57px;text-align: center;">
		 					  			<input type="hidden" name="prtcpntIndex" id="prtcpntIndex_${prtcpntIdx}" value="${prtcpntIdx}"/>
						                <input type="hidden" name="seqAuthor" id="seqAuthor_${prtcpntIdx}" value="N"/>
		 					  			<span id="order_${prtcpntIdx}" class="prtcpnt_order">${prtcpntIdx}</span>
									</td>
		 					  		<td style="width:110px;">
						                <input type="text"  name="prtcpntNm" maxLength="30" id="prtcpntNm_${prtcpntIdx}" value="${prtcpntFullNm}" class="input_type required" onkeydown="if(event.keyCode==13){findUser($(this),event);}"/>
		 					  		</td>
		 					  		<td style="width:120px">
		 					  		    <input type="text" name="prtcpntFullNm" maxLength="100" id="prtcpntFullNm_${prtcpntIdx}" value="${prtcpntFullNm}" class="input_type" onkeydown="if(event.keyCode==13){findUser($(this),event);}"/>
		 					  		</td>
		 					  		<td style="width:110px;">
		 					  		   <select name="tpiDvsCd" id="tpiDvsCd_${prtcpntIdx}" class="select_type">${rims:makeCodeList('1340', true, '') }</select>
		 					  		</td>
									<td style="width: 140px;">
										<span class="dk_bt_box">
										  <input type="text" name="prtcpntId" id="prtcpntId_${prtcpntIdx}" value="${prtpntId}" class="input_type" onkeydown="if(event.keyCode==13){findUser($(this),event);}"/>
										 <span class="dk_r_bt">
											<a href="javascript:void(0);" class="tbl_icon_a tbl_search_icon" onclick="findUser($(this),event);">검색</a>
											<a href="javascript:void(0);" class="tbl_icon_a tbl_trash_icon" onclick="clearPrtcpnt($(this));">지우기</a>
										 </span>
										</span>
									</td>
									<td style="width: 190px;">
										<div class="r_add_bt">
											<input type="hidden" name="blngAgcCd" id="blngAgcCd_${prtcpntIdx}" value="${blngAgcCd}"/>
											<input type="text"  name="blngAgcNm" id="blngAgcNm_${prtcpntIdx}" value="${blngAgcNm}"  class="input_type" onkeydown="if(event.keyCode==13){getCodeOrgWin($(this),event);}"/>
											<span class="r_span_box">
												<a href="javascript:void(0);" class="tbl_icon_a tbl_search_icon" onclick="getCodeOrgWin($(this),event);">검색</a>
											</span>
										</div>
									</td>
		 					  		<td style="width:150px" class="dispDept"></td>
									<td style="width:60px">
										<a href="javascript:void(0);" class="tbl_icon_a row_add_bt" onclick="addPrtcpnt($(this),'${sessionScope.login_user.adminDvsCd}')"><spring:message code='common.add'/></a>
										<a href="javascript:void(0);" class="tbl_icon_a red_del" onclick="removePrtcpnt($(this));"><spring:message code='common.row.delete'/></a>
										<input type="hidden" name="tpiRate" value="_blank"/>
									</td>
								</tr>
						  <script type="text/javascript">var prtcpntIdx = '${prtcpntIdx}';</script>
						</tbody>
					</table>
				</td>
			</tr>
			<c:if test="${sessionScope.auth.adminDvsCd eq 'M' }">
			<tr>
				<th>소스구분</th>
				<td>
					<select name="src" id="src" class="select_type" style="width: 100px;">
						<option value="">직접입력</option>
						<option value="PMS">PPMS</option>
					</select>
				</td>
				<th>특허시스템ID</th>
				<td><input type="text" name="srcId" id="srcId" class="input_type" value=""/></td>
			</tr>
			</c:if>
			<c:if test="${sessionScope.auth.adminDvsCd eq 'M' or sessionScope.auth.adminDvsCd eq 'P'}">
			<tr>
				<th><spring:message code='tech.appr.dvs.cd'/></th>
				<td>
					<select id="apprDvsCdValue" name="apprDvsCd"  class="select_type" style="width: 100px;">${rims:makeCodeList('1400', true, '') }</select>
				</td>
				<th rowspan="2"><spring:message code='tech.rtrn'/></th>
				<td rowspan="2">
					<div class="tbl_textarea">
						<textarea name="apprRtrnCnclRsnCntn" id="apprRtrnCnclRsnCntn" rows="3" maxLength="4000" ></textarea>
					</div>
				</td>
			</tr>
			<tr>
				<th><spring:message code='tech.appr.dvs.date'/></th>
				<td></td>
			</tr>
			</c:if>
		</tbody>
</form>
<script type="text/javascript">
$(document).ready(function(){
	  $('input, select, textarea').change(function(){ isChange = true; });
	  $('input:checkbox, input:radio').click(function(){ isChange = true; });
	  //$("#prtcpntTbl tbody").disableSelection();
	  $('#rpmDiv').css('width',$('.list_bt_area').width() + 'px');
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