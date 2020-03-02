<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.argonet.r2rims.util.LanguageUtil"%>
<%@include file="../../pageInit.jsp" %>
<c:if test="${sessMode or (sessionScope.auth.adminDvsCd eq 'R' or sessionScope.auth.adminDvsCd eq 'S' )}">
  <c:set var="prtpntId" value="${sessionScope.sess_user.userId}"/><c:set var="prtcpntNm" value="${sessionScope.sess_user.abbrLastName}, ${sessionScope.sess_user.abbrFirstName}"/>
  <c:set var="prtcpntFullNm" value="${sessionScope.sess_user.lastName}, ${sessionScope.sess_user.firstName}"/><c:set var="pcnRschrRegNo" value="${sessionScope.sess_user.rschrRegNo}"/>
  <c:set var="deptKor" value="${sessionScope.sess_user.groupDept}"/><c:set var="blngAgcCd" value="${sysConf['inst.blng.agc.code']}"/><c:set var="blngAgcNm" value="${sysConf['inst.blng.agc.name']}"/>
</c:if>
<form id="formArea" action="<c:url value="/funding/addFunding.do"/>" method="post">
  <table class="write_tbl mgb_10" >
	<colgroup>
		<col style="width:140px;" />
		<col style="width:326px;" />
		<col style="width:140px" />
		<col style="" />
	</colgroup>
	<tbody>
		<tr>
			<th class="essential_th"><spring:message code='fund.rsrcct.sppt.dvs.cd'/></th>
			<td>
				<select name="rsrcctSpptDvsCd" id="rsrcctSpptDvsCd" class="select_type required">${rims:makeCodeList('1280', true, '')}</select>
			</td>
			<th><spring:message code='fund.cpt.gov.offic.nm'/></th>
			<td>
				<input type="text" name="cptGovOfficNm" id="cptGovOfficNm"  class="input_type"/>
			</td>
		</tr>
		<tr>
	    	<th class="essential_th"><spring:message code='fund.rsrcct.sppt.agc.nm'/></th>
	    	<td>
	    		<input type="text" name="rsrcctSpptAgcNm" id="rsrcctSpptAgcNm"  class="input_type required"/>
	    	</td>
	    	<th class="essential_th"><spring:message code='fund.biz.nm'/></th>
	    	<td>
	    		<input type="text" name="bizNm" id="bizNm"  class="input_type required"/>
	    	</td>
		</tr>
		<tr>
			<th class="essential_th add_help">
				<spring:message code='fund.sbjt.no'/><a href="javascript:void(0);" onclick="showTooltip($(this))" class="tbl_help_a"></a>
				<p class="th_help_box"><span><spring:message code='tooltip.fund1'/></span></p>
			</th>
	    	<td>
	    		<input type="text" name="sbjtNo" id="sbjtNo"  class="input_type"/>
	    	</td>
	    	<th><spring:message code='fund.sbjt.no.kaist'/></th>
	    	<td>
	    		<input type="text" name="agcSbjtNo" id="agcSbjtNo"  class="input_type"/>
	    	</td>
		</tr>
		<tr>
			<th class="essential_th"><spring:message code='fund.rsch.sbjt.nm'/></th>
			<td colspan="3">
				<input type="text" name="rschSbjtNm" id="rschSbjtNm"  class="input_type required"/>
			</td>
		</tr>
		<tr>
			<th class="essential_th"><spring:message code='fund.rsch.date'/></th>
			<td>
			  <input type="text" name="rschCmcmYear" id="rschCmcmYear" class="input_type required" style="width: 57px;" />&nbsp;<spring:message code='common.year'/>&nbsp;&nbsp;
              <input type="text" name="rschCmcmMonth" id="rschCmcmMonth" class="input_type" style="width: 40px;" />&nbsp;<spring:message code='common.month'/>&nbsp;&nbsp;
              ~&nbsp;
              <input type="text"  name="rschEndYear" id="rschEndYear" class="input_type required" style="width: 57px;" />&nbsp;<spring:message code='common.year'/>&nbsp;&nbsp;
              <input type="text"  name="rschEndMonth" id="rschEndMonth" class="input_type" style="width: 40px;" />&nbsp;<spring:message code='common.month'/>&nbsp;&nbsp;
			</td>
	    	<th class="essential_th"><spring:message code='fund.mny.yr.sbjt.nm'/></th>
	    	<td>
	    		<select name="mnyYrSbjtYn" id="mnyYrSbjtYn" class="select_type required">${rims:makeCodeList('1450',true,'')}</select>
	    	</td>
		</tr>
		<tr>
	    	<th class="essential_th"><spring:message code='fund.rsch.sbjt.stdy.sphe.cd'/></th>
	    	<td>
	    		<select name="rschSbjtStdySpheCd" id="rschSbjtStdySpheCd" class="select_type required">${rims:makeCodeList('1350',true,'')}</select>
	    	</td>
	    	<th><spring:message code='fund.blng.univ'/></th>
	    	<td>
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
			<th class="add_help"><spring:message code='fund.detail'/><a href="javascript:void(0);" onclick="showTooltip($(this))" class="tbl_help_a"></a>
				<p class="th_help_box"><span><spring:message code='tooltip.fund2'/></span></p>
			</th>
	    	<td colspan="3"></td>
		</tr>
		<tr>
			<td colspan="4" class="inner_tbl_td">
				<div id="detailDiv" style="overflow: auto;">
				<table id="detailTbl" class="in_tbl inner_tbl" style="table-layout:fixed;">
					<colgroup>
						<col style="width:55px;" />
						<col style="width:80px;" />
						<col style="width:110px;" />
						<col style="width:110px;" />
						<col style="width:110px;" />
						<col style="width:100px;" />
						<col style="width:100px;" />
						<col style="width:50px;" />
						<col style="width:50px;" />
						<col style="width:80px;" />
						<col style="width:100px;" />
						<col style="width:65px;" />
					</colgroup>
					<thead>
						<tr>
							<th rowspan="2"><spring:message code='fund.order'/></th>
							<th rowspan="2" class="essential_th"><spring:message code='fund.rsrcct.cont.yr'/></th>
							<th rowspan="2" class="essential_th"><spring:message code='fund.tot.rsrcct'/></th>
							<th rowspan="2" class="essential_th"><spring:message code='fund.prty.rsrcct'/></th>
							<th rowspan="2" class="essential_th"><spring:message code='fund.indrfee'/></th>
							<th rowspan="2" class="essential_th"><spring:message code='fund.sclgrnd.corr.fund'/></th>
							<th rowspan="2" class="essential_th"><spring:message code='fund.schout.corr.fund'/></th>
							<th colspan="2" class="essential_th"><spring:message code='fund.rschr.cnt'/></th>
							<th rowspan="2"><spring:message code='fund.appr'/></th>
							<th rowspan="2"><spring:message code='fund.appr.date'/></th>
							<th rowspan="2"></th>
						</tr>
						<tr>
							<th><spring:message code='fund.asso.rschr.cnt'/></th>
							<th><spring:message code='fund.asst.rschr.cnt'/></th>
						</tr>
					</thead>
					<tbody>
					  <c:set var="detailIdx" value="1"/>
						<tr>
						  <td style="text-align: center;">
				  			<input type="hidden" name="detailIndex" id="detailIndex_${detailIdx}" value="${detailIdx}"/>
				  			<input type="hidden" name="seqFunding" id="seqFunding_${detailIdx}" value="${dl.seqFunding}"/>
				  			<span id="detailOrder_${detailIdx}">${detailIdx}</span>
				  		  </td>
				  		  <td>
				  		  	<input type="text" style="width: 40px; text-align: right;" name="rsrcctContYr" id="rsrcctContYr_${detailIdx}" maxlength="4" class="input_type required"/><spring:message code='common.year'/>
				  		  	<input type="hidden" name="seqFunding" value="${dl.seqFunding}"/>
				  		  </td>
				  		  <td style="text-align: center;">
				  		  	<input type="text" style="width: 80px; text-align: right;" name="totRsrcct" id="totRsrcct_${detailIdx}" maxLength="15" class="input_type required" onkeyup="getNumber($(this));" onkeydown="getNumber($(this));"/><spring:message code='fund.won'/>
				  		  </td>
				  		  <td style="text-align: center;">
				  		  	<input type="text" style="width: 80px; text-align: right;" name="prtyRsrcct"  id="prtyRsrcct_${detailIdx}" maxLength="15" class="input_type required" onkeyup="getNumber($(this));" onkeydown="getNumber($(this));"/><spring:message code='fund.won'/>
				  		  </td>
				  		  <td style="text-align: center;">
				  		  	<input type="text" style="width: 80px; text-align: right;" name="indrfee" id="indrfee_${detailIdx}" maxLength="15" class="input_type required" onkeyup="getNumber($(this));" onkeydown="getNumber($(this));"/><spring:message code='fund.won'/>
				  		  </td>
				  		  <td style="text-align: center;">
				  		  	<input type="text" style="width: 60px; text-align: right;" name="sclgrndCorrFund" id="sclgrndCorrFund_${detailIdx}" maxLength="15" class="input_type required"  onkeyup="getNumber($(this));" onkeydown="getNumber($(this));"/><spring:message code='fund.won'/>
				  		  </td>
				  		  <td style="text-align: center;">
				  		  	<input type="text" style="width: 60px; text-align: right;" name="schoutCorrFund" id="schoutCorrFund_${detailIdx}" maxLength="15" class="input_type required" onkeyup="getNumber($(this));" onkeydown="getNumber($(this));"/><spring:message code='fund.won'/>
				  		  </td>
				  		  <td style="text-align: center;">
				  		  	<input type="text" style="width: 30px; text-align: right;" name="assoRschrCnt" id="assoRschrCnt_${detailIdx}" maxLength="3" class="input_type required" />
				  		  </td>
				  		  <td style="text-align: center;">
				  		  	<input type="text" style="width: 30px; text-align: right;" name="asstRschrCnt" id="asstRschrCnt_${detailIdx}" maxLength="3" class="input_type required"/>
				  		  </td>
				  		  <c:if test="${sessionScope.auth.adminDvsCd eq 'M' or sessionScope.auth.adminDvsCd eq 'P' }">
					  		  <td style="text-align: center;">
					  		  	<select id="detailApprDvsCd_${detailIdx}" name="detailApprDvsCd"  class="select_type">${rims:makeCodeList('1400', true, '') }</select>
					  		  </td>
					  		  <td style="text-align: center;" class="dispDetailApprDate"></td>
				  		  </c:if>
				  		  <c:if test="${sessionScope.auth.adminDvsCd ne 'M' and sessionScope.auth.adminDvsCd ne 'P' }">
					  		  <td style="text-align: center;">
					  		  	${rims:codeValue('1400','')}
					  		  	<input type="hidden" name="apprDvsCd"/>
					  		  </td>
					  		  <td style="text-align: center;" class="dispDetailApprDate"></td>
				  		  </c:if>
					  		<td style="width:34px;">
								<a href="javascript:void(0);" class="tbl_icon_a row_add_bt" onclick="addDetail($(this),'${sessionScope.auth.adminDvsCd}')" ><spring:message code='common.add'/></a>
								<a href="javascript:void(0);" class="tbl_icon_a red_del" onclick="removeDetail($(this));"><spring:message code='common.row.delete'/></a>
					  		</td>
						</tr>
					  <script type="text/javascript">var detailIdx = '${detailIdx}';</script>
					</tbody>
				</table>
				</div>
			</td>
		</tr>
		<tr>
	    	<th><spring:message code='fund.authors'/></th>
	    	<td colspan="3"></td>
		</tr>
		<tr>
			<td colspan="4" class="inner_tbl_td">
				<table class="in_tbl inner_tbl" id="prtcpntTbl">
					<thead>
						<tr>
							<th colspan="2"><spring:message code='fund.order'/></th>
							<th class="essential_th"><spring:message code='fund.name'/></th>
							<th class="essential_th"><spring:message code='fund.tpi.dvs.cd'/></th>
							<th><spring:message code='fund.user.id'/></th>
							<th><spring:message code='fund.agc.nm'/></th>
							<th><spring:message code='fund.tpi.date'/></th>
							<th></th>
						</tr>
					</thead>
					<tbody>
						<c:set var="prtcpntIdx" value="1"/>
					  	<tr>
					  		<td style="width:10px;text-align: left;"><img src="<c:url value='/images/icon/dragpoint.png' />" /></td>
					  		<td style="width: 40px; text-align: center;">
					  			<input type="hidden" name="prtcpntIndex" id="prtcpntIndex_${prtcpntIdx}" value="${prtcpntIdx}"/>
					  			<span id="prtcpntOrder_${prtcpntIdx}">${prtcpntIdx}</span>
					  		</td>
					  		<td style="width:80px;">
					  			<input type="text"  name="prtcpntNm" maxLength="30" id="prtcpntNm_${prtcpntIdx}" value="${prtcpntNm}" class="input_type required" onkeydown="if(event.keyCode==13){findUser($(this),event);}"/>
					  			<input type="hidden" name="pcnRschrRegNo" id="pcnRschrRegNo_${prtcpntIdx}" value="${pcnRschrRegNo}"/>
			                	<input type="hidden" name="seqAuthor" id="seqAuthor_${prtcpntIdx}" value="N"/>
					  		</td>
					  		<td style="width:100px;">
					  			<select name="tpiDvsCd" id="tpiDvsCd_${prtcpntIdx}" class="select_type required" >${rims:makeCodeList('1360', true, '') }</select>
					  		</td>
					  		<td	style="width:140px;">
								<span class="dk_bt_box">
								  <input type="text" name="prtcpntId" id="prtcpntId_${prtcpntIdx}" value="${prtpntId}" class="input_type" onkeydown="if(event.keyCode==13){findUser($(this),event);}"/>
								 <span class="dk_r_bt">
									<a href="javascript:void(0);" class="tbl_icon_a tbl_search_icon" onclick="findUser($(this),event);">검색</a>
									<a href="javascript:void(0);" class="tbl_icon_a tbl_trash_icon" onclick="clearPrtcpnt($(this));">지우기</a>
								 </span>
								</span>
					  		</td>
					  		<td style="width:160px;">
								<div class="r_add_bt">
									<input type="hidden" name="blngAgcCd" id="blngAgcCd_${prtcpntIdx}" value="${blngAgcCd}"/>
									<input type="text"  name="blngAgcNm" id="blngAgcNm_${prtcpntIdx}"  value="${blngAgcNm}" class="input_type" onkeydown="if(event.keyCode==13){getCodeOrgWin($(this),event);}"/>
									<span class="r_span_box">
										<a href="javascript:void(0);" class="tbl_icon_a tbl_search_icon" onclick="getCodeOrgWin($(this),event);">검색</a>
									</span>
								</div>
					  		</td>
					  		<td style="width:240px;">
								  <input type="hidden" name="tpiRate" maxLength="3" class="input_type" />
								  <input type="text" name="tpiSttYear" id="tpiSttYear_${prtcpntIdx}" class="input_type required" style="width: 40px;"/><spring:message code='common.year'/>
					              <input type="text" name="tpiSttMonth" id="tpiSttMonth_${prtcpntIdx}" class="input_type" style="width: 25px;"/><spring:message code='common.month'/>
					              &nbsp;~&nbsp;
					              <input type="text" name="tpiEndYear" id="tpiEndYear_${prtcpntIdx}" class="input_type required" style="width: 40px;" /><spring:message code='common.year'/>
					              <input type="text" name="tpiEndMonth" id="tpiEndMonth_${prtcpntIdx}" class="input_type" style="width: 25px;" /><spring:message code='common.month'/>
					  		</td>
					  		<td style="width:60px;">
								<a href="javascript:void(0);" class="tbl_icon_a row_add_bt" onclick="addPrtcpnt($(this),'${sessionScope.auth.adminDvsCd}')" ><spring:message code='common.add'/></a>
								<a href="javascript:void(0);" class="tbl_icon_a red_del" onclick="removePrtcpnt($(this));"><spring:message code='common.row.delete'/></a>
					  		</td>
					  	</tr>
						<script type="text/javascript">var prtcpntIdx = '${prtcpntIdx}';</script>
					</tbody>
				</table>
			</td>
		</tr>
		<tr>
			<th><spring:message code='fund.keyword.kor'/></th>
			<td colspan="3">
				<input type="text"  id="keywordKor" name="keywordKor" class="input_type" maxlength="1000" value=""/>
			</td>
		</tr>
		<tr>
			<th><spring:message code='fund.keyword.eng'/></th>
			<td colspan="3">
				<input type="text"  id="keywordEng" name="keywordEng" class="input_type" maxlength="1000" value=""/>
			</td>
		</tr>
		<tr>
	    	<th><spring:message code='kri.link'/></th>
	    	<td colspan="3">
	    		<c:set var="flag" value="${fn:substring(fn:trim(funding.interfaceFlag),0,1)}"/>
	    		<input type="radio" name="interfaceFlag" id="interfaceFlag1" value="1" checked="checked"/><spring:message code='kri.link.yes'/>
				<input type="radio" name="interfaceFlag" id="interfaceFlag0" value="0" /><spring:message code='kri.link.no'/>
	    	</td>
		</tr>
	    <c:if test="${sessionScope.auth.adminDvsCd eq 'M' or sessionScope.auth.adminDvsCd eq 'P'}">
	    <tr>
			<th><spring:message code='fund.appr'/></th>
			<td>
				<select id="apprDvsCdValue" name="apprDvsCd"  class="select_type" style="width: 100px;">${rims:makeCodeList('1400', true, '') }</select>
			</td>
	    	<th rowspan="2"><spring:message code='fund.rtrn'/></th>
	    	<td rowspan="2">
				<div class="tbl_textarea">
					<textarea name="apprRtrnCnclRsnCntn" id="apprRtrnCnclRsnCntn" rows="2" maxLength="4000" ></textarea>
				</div>
	    	</td>
	    </tr>
		<tr>
			<th><spring:message code='fund.appr.date'/></th>
			<td></td>
		</tr>
	    </c:if>
	</tbody>
  </table>
</form>
<script type="text/javascript">
$(document).ready(function(){
	  $('input, select, textarea').change(function(){ isChange = true; });
	  $('input:checkbox, input:radio').click(function(){ isChange = true; });
	  $('#fnDelete').hide();
	  //$("#prtcpntTbl tbody").disableSelection();
	$("#prtcpntTbl tbody").sortable({
		  placeholder: "ui-state-highlight",
		  deactivate: function(event, ui){
			  $('span[id^="prtcpntOrder_"]').each(function(i, obj){ $(obj).text(i+1); });
			  isChange = true;
		  }
	  });
	  $('#detailDiv').css('width', $('#formArea').width() + 'px');
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

//유저리스트와 비교하여 삭제된 저자를 재배열 및 listDeleteUser에 등록
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