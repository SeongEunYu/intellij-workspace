<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.argonet.r2rims.util.LanguageUtil"%>
<%@include file="../../pageInit.jsp" %>
<c:set var="readonly" value=""/>
<c:if test="${not empty patent.srcId and sessionScope.auth.adminDvsCd ne 'M' and sessionScope.auth.adminDvsCd ne 'P'}">
	<c:set var="readonly" value='readonly="readonly" onclick="javascript:dhtmlx.alert({type:"alert-warning",text:"특허관리시스템(PPMS)과 연계된 데이터는 지식재산권명을 수정할 수 없습니다.",callback:function(){}})'/>
</c:if>
 <c:set var="rschRequiredClass" value=""/><c:set var="rschEssentialTh" value=""/>
 	<c:if test="${sessionScope.auth.adminDvsCd eq 'R' or sessionScope.auth.adminDvsCd eq 'S'}">
	<c:set var="rschRequiredClass" value="required"/><c:set var="rschEssentialTh" value="essential_th"/>
 </c:if>
<form id="formArea" action="<c:url value="/${preUrl}/patent/modifyPatent.do"/>" method="post">
	<input type="hidden" name="patentId" value="${patent.patentId}"/>
	<input type="hidden" id="listUrl" name="listUrl" value="<c:url value="/patent/findPatentList.do"/>"/>
  	<input type="hidden" name="relisUser" value="N" />
	<input type="hidden" name="deleteUser" value="N" />
	<c:if test="${sessionScope.auth.adminDvsCd ne 'M' and sessionScope.auth.adminDvsCd ne 'P' }">
		<input type="hidden" name="cntcSystemInfoOthbcYn" value="<c:out value="${patent.cntcSystemInfoOthbcYn}"/>" />
	</c:if>
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
					<spring:message code="common.radio.yes"/> <input type="radio" name="isReprsntPatent" value="Y" ${not empty patent.isReprsntPatent and patent.isReprsntPatent eq 'Y' ? 'checked="checked"' : '' }/>
					&nbsp;&nbsp;&nbsp;<spring:message code="common.radio.no"/> <input type="radio" name="isReprsntPatent" value="N" ${empty patent.isReprsntPatent or patent.isReprsntPatent eq 'N' ? 'checked="checked"' : '' }/>
				</td>
			</tr>
		</c:if>
			<tr>
				<th class="essential_th"><spring:message code='patn.itl.ppr.rgt.dvs.cd'/></th>
				<td>
					<select name="itlPprRgtDvsCd" id="itlPprRgtDvsCd" class="select_type required">${rims:makeCodeList('1080',true,patent.itlPprRgtDvsCd)}</select>
				</td>
				<th class="essential_th"><spring:message code='patn.acqs.dvs.cd'/></th>
				<td>
					<select name="acqsDvsCd" id="acqsDvsCd" class="select_type required" style="width: 49%;">${rims:makeCodeList('1090',true,patent.acqsDvsCd)}</select>
					<select name="status" id="status" class="select_type" style="width: 49%;">${rims:makeCodeList('patent.status',true,patent.status)}</select>
				</td>
			</tr>
			<tr>
				<th class="essential_th"><spring:message code='patn.acqs.ntn.dvs.cd'/></th>
				<td>
					<select name="acqsNtnDvsCd" id="acqsNtnDvsCd" class="select_type required" >${rims:makeCodeList('1140',true,patent.acqsNtnDvsCd)}</select>
				</td>
				<th class="essential_th"><spring:message code='patn.appl.reg.ntn.cd'/></th>
				<td>
					<select name="applRegNtnCd" id="applRegNtnCd" class="select_type required">${rims:makeCodeList('2000', true, patent.applRegNtnCd) }</select>
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
						<textarea maxLength="500" rows="3" name="itlPprRgtNm" id="itlPprRgtNm" class="required" ${readonly}><c:out value="${patent.itlPprRgtNm}"/></textarea>
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
						<textarea maxLength="500" rows="2" name="diffItlPprRgtNm" id="diffItlPprRgtNm" ${readonly}><c:out value="${patent.diffItlPprRgtNm}"/></textarea>
					</div>
				</td>
			</tr>
			<tr>
				<th class="essential_th"><spring:message code='patn.appl.reg.date'/></th>
				<td>
				  <input type="text" name="applRegYear" id="applRegYear" class="input_type required" style="width: 80px;" value="<c:out value="${patent.applRegYear}"/>"/>&nbsp;<spring:message code='common.year'/>&nbsp;&nbsp;
	              <input type="text" name="applRegMonth" id="applRegMonth" class="input_type" style="width: 45px;" value="<c:out value="${patent.applRegMonth}"/>"/>&nbsp;<spring:message code='common.month'/>&nbsp;&nbsp;
	              <input type="text" name="applRegDay" id="applRegDay" class="input_type" style="width: 45px;" value="<c:out value="${patent.applRegDay}"/>"/>&nbsp;<spring:message code='common.day'/>&nbsp;&nbsp;
				</td>
				<th class="essential_th"><spring:message code='patn.appl.reg.no'/></th>
				<td>
					<input type="text" name="applRegNo" id="applRegNo" maxLength="32" class="input_type required" value="<c:out value="${patent.applRegNo}"/>" />
				</td>
			</tr>
			<tr>
				<th><spring:message code='patn.itl.ppr.rgt.reg.date'/></th>
				<td>
				  <input type="text" name="itlPprRgtRegYear" id="itlPprRgtRegYear" class="input_type " style="width: 80px;" value="<c:out value="${patent.itlPprRgtRegYear}"/>"/>&nbsp;<spring:message code='common.year'/>&nbsp;&nbsp;
	              <input type="text" name="itlPprRgtRegMonth" id="itlPprRgtRegMonth" class="input_type " style="width: 45px;" value="<c:out value="${patent.itlPprRgtRegMonth}"/>"/>&nbsp;<spring:message code='common.month'/>&nbsp;&nbsp;
	              <input type="text" name="itlPprRgtRegDay" id="itlPprRgtRegDay" class="input_type " style="width: 45px;" value="<c:out value="${patent.itlPprRgtRegDay}"/>"/>&nbsp;<spring:message code='common.day'/>&nbsp;&nbsp;
				</td>
				<th><spring:message code='patn.itl.ppr.rgt.reg.no'/></th>
				<td>
					<input type="text" maxLength="50" name="itlPprRgtRegNo" id="itlPprRgtRegNo" class="input_type" value="<c:out value="${patent.itlPprRgtRegNo}"/>" />
				</td>
			</tr>
			<tr>
				<th class="essential_th add_help">
					<spring:message code='patn.appr.regt.nm'/><a href="javascript:void(0);" onclick="showTooltip($(this))" class="tbl_help_a"></a>
					<p class="th_help_box"><span><spring:message code='tooltip.pat2'/></span></p>
				</th>
				<td>
					<input type="text" maxLength="150" name="applRegtNm"  id="applRegtNm" class="input_type required" value="<c:out value="${patent.applRegtNm}"/>" />
				</td>
				<th><spring:message code='patn.pat.cls.cd'/></th>
				<td>
					<select name="patClsCd" id="patClsCd" class="select_type">${rims:makeCodeList('1710',true, patent.patClsCd)}</select>
				</td>
			</tr>
			<tr>
				<th><spring:message code='patn.invt.nm'/></th>
				<td colspan="3">
					<div class="writer_td_inner">
						<em class="td_left_ex"><c:out value="${patent.invtNm}"/></em>
						<input type="hidden" name="invtNm" value="<c:out value="${patent.invtNm}"/>" />
						<p>
						<spring:message code='patn.invt.cnt'/>
						<input type="text" id="invtCnt" name="invtCnt" class="input_type" style="width:20px;text-align: center;" value="<c:out value="${patent.invtCnt}"/>" maxlength="3" onkeyup="getNumber($(this));" onkeydown="getNumber($(this));"/>
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
						<c:set var="prtcpntIdx" value="0"/>
						<c:if test="${not empty patent.partiList}">
							<c:forEach items="${patent.partiList}" var="pl" varStatus="st">
								<tr>
									<td style="width:10px;text-align: left;"><img src="<c:url value='/images/icon/dragpoint.png' />" /></td>
									<td style="text-align: center;width: 40px;">
										<span class="prtcpnt_order">${st.count}</span>
										<input type="hidden" name="prtcpntIndex" id="prtcpntIndex_${st.count}" value="${st.count}"/>
									</td>
									<td style="width: 150px;">
										<input type="text" name="prtcpntNm" maxLength="30" id="prtcpntNm_${st.count}" class="input_type required" value="<c:out value="${pl.prtcpntNm}"/>" onkeydown="if(event.keyCode==13){findUser($(this),event,true);}"/>
										<input type="hidden" name="pcnRschrRegNo" id="pcnRschrRegNo_${st.count}" value="<c:out value="${pl.pcnRschrRegNo}"/>"/>
										<input type="hidden" name="seqAuthor" id="seqAuthor_${st.count}" value="${pl.seqAuthor}"/>
									</td>
									<td style="width: 200px;">
										<span class="dk_bt_box">
										  <input type="text" name="prtcpntId" id="prtcpntId_${st.count}" value="<c:out value="${pl.prtcpntId}"/>"  class="input_type" onkeydown="if(event.keyCode==13){findUser($(this),event,true);}"/>
										 <span class="dk_r_bt">
											<a href="javascript:void(0);" class="tbl_icon_a tbl_search_icon" onclick="findUser($(this),event,true);">검색</a>
											<a href="javascript:void(0);" class="tbl_icon_a tbl_trash_icon" onclick="clearPrtcpnt($(this));">지우기</a>
										 </span>
										</span>
									</td>
									<td style="width: 200px;">
										<div class="r_add_bt">
											<input type="hidden" name="blngAgcCd" id="blngAgcCd_${st.count}" value="<c:out value="${pl.blngAgcCd}"/>"/>
											<input type="text"  name="blngAgcNm" id="blngAgcNm_${st.count}"  class="input_type" style="${pl.blngAgcNm eq '' && pl.blngAgcCd eq '' ? 'background-color: #fef3d7;' : ''}" value="<c:out value="${pl.blngAgcNm}"/>" onkeydown="if(event.keyCode==13){getCodeOrgWin($(this),event);}"/>
											<span class="r_span_box">
												<a href="javascript:void(0);" class="tbl_icon_a tbl_search_icon" onclick="getCodeOrgWin($(this),event);">검색</a>
											</span>
										</div>
									</td>
		 					  		<td style="width:150px" class="dispDept">
		 					  			<c:if test="${not empty pl.blngAgcNm and pl.blngAgcNm eq instName}"><c:out value="${pl.deptKor}"/></c:if>
		 					  		</td>
									<td style="width: 60px;">
										<a href="javascript:void(0);" class="tbl_icon_a row_add_bt" onclick="addPrtcpnt($(this),'${sessionScope.login_user.adminDvsCd}')"><spring:message code='common.add'/></a>
										<a href="javascript:void(0);" class="tbl_icon_a red_del" onclick="removePrtcpnt($(this));"><spring:message code='common.row.delete'/></a>
									</td>
								</tr>
								<c:set var="prtcpntIdx" value="${prtcpntIdx + 1}"/>
							</c:forEach>
						</c:if>
						<script type="text/javascript">var prtcpntIdx = '${prtcpntIdx}';</script>
						</tbody>
					</table>
				</td>
			</tr>
			<tr>
				<th><spring:message code='patn.acqs.dtl.dvs.cd'/></th>
				<td>
					<input name="acqsDtlDvsCd" type="radio" value="1" ${patent.acqsDtlDvsCd eq '1' ? "checked='checked'" : ''} />&nbsp;<spring:message code='patn.dtl'/>&nbsp;&nbsp;
					<input name="acqsDtlDvsCd" type="radio" value="2" ${patent.acqsDtlDvsCd eq '2' ? "checked='checked'" : ''}/>&nbsp;<spring:message code='patn.pct'/>&nbsp;&nbsp;
					<input name="acqsDtlDvsCd" type="radio" value="3" ${patent.acqsDtlDvsCd eq '3' ? "checked='checked'" : ''}/>&nbsp;<spring:message code='patn.epo'/>&nbsp;&nbsp;
				</td>
				<th class="add_help"><spring:message code='patn.pct.epo'/><a href="javascript:void(0);" onclick="showTooltip($(this))" class="tbl_help_a"></a>
					<p class="th_help_box"><span><spring:message code='tooltip.pat4'/></span></p>
				</th>
				<td>
					<input type="text" name="pctEpoApplNtnCnt" id="pctEpoApplNtnCnt" class="input_type" value="<c:out value="${patent.pctEpoApplNtnCnt}"/>" maxlength="3"/>
				</td>
			</tr>
			<tr>
				<th><spring:message code='patn.smmr.cntn'/></th>
				<td colspan="3">
					<div class="tbl_textarea">
						<textarea name="smmrCntn" id="smmrCntn" rows="7"><c:out value="${patent.smmrCntn}"/></textarea>
					</div>
				</td>
			</tr>
			<tr>
				<th rowspan="2" class="${rschEssentialTh}"><spring:message code='patn.sbjt.no'/></th>
				<td>
					<input type="checkbox" id="relateFundingAt" name="relateFundingAt" value="N" ${patent.relateFundingAt eq 'N' ? 'checked="checked"' : '' }/><spring:message code="art.relate.funding.lable" />
				</td>
				<th rowspan="2"><spring:message code='patn.blng.univ'/></th>
				<td rowspan="2">
					<span class="dk_bt_box">
						<input type="text" style="color: #aaa;" onclick="getOrgCodeGeneralWin($('#blngUnivCdKey'), $('#blngUnivCdValue'), event);" readonly="readonly" id="blngUnivCdValue" name="blngUnivNm" class="input_type" value="<c:out value="${patent.blngUnivNm}"/>"/>
						<input type="hidden" id="blngUnivCdKey" name="blngUnivCd" value="<c:out value="${patent.blngUnivCd}"/>"/>
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
							<c:forEach items="${patent.fundingMapngList}" var="fml" varStatus="idx">
							<tr>
								<td>
									<input type="text" name="sbjtNo"  id="sbjtNo_${idx.count}" value="<c:out value="${fml.sbjtNo}"/>" class="input_type"  readonly="readonly" />
									<input type="hidden" name="seqNo"  id="seqNo_${idx.count}" value="${empty fml.seqNo ? '_blank' : fml.seqNo}">
									<input type="hidden" name="fundIndex"  id="fundIndex_${idx.count}" value="${idx.count}">
								</td>
								<td>
									<div class="r_add_bt">
				               		  <input type="hidden" name="fundingId" id="fundingId_${idx.count}" value="${fml.fundingId}"/>
				                	  <input type="text" name="rschSbjtNm" id="rschSbjtNm_${idx.count}" class="input_type" value="<c:out value="${fml.rschSbjtNm}"/>" onkeydown="if(event.keyCode==13){findFunding($(this),event);}"/>
									  <span class="r_span_box">
										<a href="javascript:void(0);" class="tbl_icon_a tbl_search_icon" onclick="findFunding($(this),event);">검색</a>
									  </span>
									</div>
								</td>
								<td>
									<a href="javascript:void(0);" class="tbl_icon_a row_add_bt" onclick="addFunding($(this),'${sessionScope.login_user.adminDvsCd}')"><spring:message code='common.add'/></a>
									<a href="javascript:void(0);" class="tbl_icon_a red_del" onclick="removeFunding($(this));"><spring:message code='common.row.delete'/></a>
								</td>
							</tr>
							<c:set var="fundingIdx" value="${fundingIdx + 1}"/>
							</c:forEach>
							<script type="text/javascript">var fundingIdx = '${fundingIdx}';</script>
						</tbody>
					</table>
				</td>
			</tr>
			<tr>
				<th>IPC</th>
				<td colspan="3"><input type="text" name="ipc" id="ipc" class="input_type" value="<c:out value="${patent.ipc}"/>" /></td>
			</tr>
			<c:if test="${sessionScope.login_user.adminDvsCd eq 'M' or sessionScope.auth.adminDvsCd eq 'P'}">
			<tr>
				<th><spring:message code='patn.src.id'/></th>
				<td><input type="text" id="srcId" name="srcId" class="input_type" value="<c:out value="${patent.srcId }"/>"/></td>
				<th><spring:message code='patn.family.code'/></th>
				<td>
					<span class="dk_bt_box">
						<input type="text" id="familyCode" name="familyCode" class="input_type" style="width: 100px;" value="<c:out value="${patent.familyCode}"/>" />
						<select id="applDvsCd" name="applDvsCd" class="select_type" style="width: 60px;">
							<option value=""></option>
							<option value="1" ${patent.applDvsCd=='1'?'selected=\'selected\'':''}>국내</option>
							<option value="2" ${patent.applDvsCd=='2'?'selected=\'selected\'':''}>해외</option>
							<option value="3" ${patent.applDvsCd=='3'?'selected=\'selected\'':''}>PCT</option>
							<option value="4" ${patent.applDvsCd=='4'?'selected=\'selected\'':''}>변경</option>
							<option value="5" ${patent.applDvsCd=='5'?'selected=\'selected\'':''}>분할</option>
							<option value="6" ${patent.applDvsCd=='6'?'selected=\'selected\'':''}>우선권</option>
						</select>
						<span class="dk_r_bt">
							<a href="javascript:void(0);" class="tbl_icon_a tbl_search_icon" onclick="getFamilyWin(${patent.patentId}, $('#itlPprRgtNm').val());">검색</a>
							<a href="javascript:void(0);" class="tbl_icon_a tbl_trash_icon" onclick="$('#familyCode').val('');">지우기</a>
					 	</span>
					</span>
				</td>
			</tr>
			</c:if>
			<c:if test="${!(sessionScope.login_user.adminDvsCd eq 'M' or sessionScope.auth.adminDvsCd eq 'P')}">
			<tr>
				<th><spring:message code='patn.src.id'/></th>
				<td>${patent.srcId }</td>
				<th><spring:message code='patn.family.code'/></th>
				<td>
					<input type="text" class="input_type" disabled="disabled" style="width: 100px;" value="<c:out value="${patent.familyCode}"/>" />
					<select class="select_type" disabled="disabled" style="width: 60px;">
						<option value=""></option>
						<option value="1" ${patent.applDvsCd=='1'?'selected=\'selected\'':''}>국내</option>
						<option value="2" ${patent.applDvsCd=='2'?'selected=\'selected\'':''}>해외</option>
						<option value="3" ${patent.applDvsCd=='3'?'selected=\'selected\'':''}>PCT</option>
						<option value="4" ${patent.applDvsCd=='4'?'selected=\'selected\'':''}>변경</option>
						<option value="5" ${patent.applDvsCd=='5'?'selected=\'selected\'':''}>분할</option>
						<option value="6" ${patent.applDvsCd=='6'?'selected=\'selected\'':''}>우선권</option>
					</select>
				</td>
			</tr>
			</c:if>
			<c:if test="${sessionScope.login_user.adminDvsCd eq 'M' or sessionScope.auth.adminDvsCd eq 'P'}">
			<tr>
				<th>신고서ID</th>
				<td><input type="text" id="pmsId" name="pmsId" class="input_type" value="<c:out value="${patent.pmsId }"/>"/></td>
				<th>기관실적여부</th>
				<td>
					${sysConf['inst.abrv']} <input type="radio" name="insttRsltAt" onchange="changOtherValue(this.value);" value="Y" ${not empty patent.insttRsltAt and patent.insttRsltAt eq 'Y' ? 'checked="checked"' : '' }/>
					&nbsp;Other <input type="radio" name="insttRsltAt" onchange="changOtherValue(this.value);" value="N" ${empty patent.insttRsltAt or patent.insttRsltAt eq 'N' ? 'checked="checked"' : '' }/>
					<input type="hidden" value="" name="otherValue" id="otherValue">
				</td>
			</tr>
			</c:if>
			<tr>
				<th><spring:message code='patn.vrfc.dvs.cd'/></th>
				<td>
					<label id="vrfcDvsCdValue" class="kriGray">${empty rims:codeValue('1420',patent.vrfcDvsCd) ? '미검증' : rims:codeValue('1420',patent.vrfcDvsCd)}</label>
					<input type="hidden" id="vrfcDvsCdKey" name="vrfcDvsCd" value="<c:out value="${empty patent.vrfcDvsCd ? '1' : patent.vrfcDvsCd}"/>"/>
				</td>
				<th><spring:message code='patn.vrfc.dvs.date'/></th>
				<td>
					<span class="kriGray" id="vrfcDate"><fmt:formatDate var="vrfcFormatDate" value="${patent.vrfcDate}" pattern="yyyy-MM-dd" /><c:out value="${vrfcFormatDate}"/></span>
				</td>
			</tr>
			<c:if test="${sessionScope.auth.adminDvsCd eq 'M' or  sessionScope.auth.adminDvsCd eq 'P' }">
			<tr>
				<th><spring:message code="patn.cntcSystem.info.open.yn"/></th>
				<td>
					<spring:message code="common.radio.yes"/> <input type="radio" name="cntcSystemInfoOthbcYn" value="Y" ${empty patent.cntcSystemInfoOthbcYn or patent.cntcSystemInfoOthbcYn eq 'Y' ? 'checked="checked"' : '' }/>
					&nbsp;&nbsp;&nbsp;<spring:message code="common.radio.no"/> <input type="radio" name="cntcSystemInfoOthbcYn" value="N" ${not empty patent.cntcSystemInfoOthbcYn and patent.cntcSystemInfoOthbcYn eq 'N' ? 'checked="checked"' : '' }/>
				</td>
				<th><spring:message code='patn.rtrn'/></th>
				<td>
					<div class="tbl_textarea">
						<textarea maxLength="4000" rows="2" id="appr_rtrn_cncl_rsn_cntn" name="apprRtrnCnclRsnCntn"><c:out value="${patent.apprRtrnCnclRsnCntn}"/></textarea>
					</div>
				</td>
			</tr>
			<tr>
				<th><spring:message code='patn.appr.dvs.cd'/></th>
				<td>
					<select id="apprDvsCdValue" name="apprDvsCd"  class="select_type" style="width: 100px;">${rims:makeCodeList('1400', true, patent.apprDvsCd) }</select>
				</td>
				<th><spring:message code='patn.appr.dvs.date'/></th>
				<td>
					<fmt:formatDate var="apprDate" value="${patent.apprDate}" pattern="yyyy-MM-dd" /><c:out value="${apprDate}"/>
				</td>
			</tr>
			</c:if>
			<c:if test="${sessionScope.login_user.adminDvsCd ne 'M' and sessionScope.login_user.adminDvsCd ne 'P'}">
			<tr>
				<th><spring:message code='patn.rtrn'/></th>
				<td colspan="3">
					<c:out value="${patent.apprRtrnCnclRsnCntn}"/>
					<input type="hidden" name="apprRtrnCnclRsnCntn" value="<c:out value="${patent.apprRtrnCnclRsnCntn}"/>" />
				</td>
			</tr>
			<tr>
				<th><spring:message code='patn.appr.dvs.cd'/></th>
				<td>
					${rims:codeValue('1400',patent.apprDvsCd)}
					<input type="hidden" name="apprDvsCd" value="<c:out value="${empty patent.apprDvsCd ? '1' : patent.apprDvsCd}"/>"/>
				</td>
				<th><spring:message code='patn.appr.dvs.date'/></th>
				<td>
					<fmt:formatDate var="apprDate" value="${patent.apprDate}" pattern="yyyy-MM-dd" /><c:out value="${apprDate}"/>
				</td>
			</tr>
			</c:if>
			<tr>
				<th><spring:message code='common.reg.date'/></th>
				<td>
					<fmt:formatDate var="regDate" value="${patent.regDate}" pattern="yyyy-MM-dd" /> <c:out value="${regDate}"/> ( <c:out value="${empty patent.regUserNm ? 'ADMIN' : patent.regUserNm}"/> )
				</td>
				<th><spring:message code='common.mod.date'/></th>
				<td>
					<fmt:formatDate var="modDate" value="${patent.modDate}" pattern="yyyy-MM-dd" /> <c:out value="${modDate}"/> ( <c:out value="${empty patent.modUserNm ? 'ADMIN' : patent.modUserNm}"/> )
				</td>
			</tr>
		</tbody>
	</table>


</form>
<form id="removeFormArea" action="<c:url value="/patent/removePatent.do"/>" method="post">
	<input type="hidden" name="patentId" value="${patent.patentId}"/>
</form>
<form id="repairFormArea" action="<c:url value="/patent/repairPatent.do"/>" method="post">
	<input type="hidden" name="patentId" value="${patent.patentId}"/>
</form>
<form name="vrfcFrm" id="vrfcFrm" method="post"></form>
<script type="text/javascript">
$(document).ready(function(){
	$('input, select, textarea').change(function(){ isChange = true; });
	$('input:checkbox, input:radio').click(function(){ isChange = true; });
	$("#prtcpntTbl tbody").sortable({
		placeholder: "ui-state-highlight",
		deactivate: function(event, ui){
			$('#prtcpntTbody span[class="prtcpnt_order"]').each(function(i, obj){ $(obj).text(i+1); });
			isChange = true;
		}
	});
	//$("#invtTbl tbody").disableSelection();
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