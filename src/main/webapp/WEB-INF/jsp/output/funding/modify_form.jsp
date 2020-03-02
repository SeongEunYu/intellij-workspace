<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.argonet.r2rims.util.LanguageUtil"%>
<%@include file="../../pageInit.jsp" %>
<c:set var="setDisable" value=""/>
<c:set var="clickAlert" value=""/>
<c:if test="${not empty funding.erpId and ( sessionScope.auth.adminDvsCd ne 'M' and sessionScope.auth.adminDvsCd ne 'P' )}">
	<c:set var="setDisable" value='disabled="disabled"'/>
	<c:set var="clickAlert" value='onclick="javascript:dhtmlx.alert({type:"alert-warning",text:"ERP에서 연계된 데이터는 ERP에서만 수정 가능합니다.",callback:function(){}})'/>
</c:if>
<form id="formArea" action="<c:url value="/funding/modifyFunding.do"/>" method="post">
  <input type="hidden" id="fundingId" name="fundingId" value="${funding.fundingId}"/>
  <input type="hidden" id="overallFlag" name="overallFlag" value="<c:out value="${funding.overallFlag}"/>"/>
  <input type="hidden" id="listUrl" name="listUrl" value="${contextPath}/funding/funding_mgt.do"/>
  <input type="hidden" name="deleteUser" value="N" />
  <input type="hidden" name="relisUser" value="N" />
	<c:if test="${sessionScope.auth.adminDvsCd ne 'M' and sessionScope.auth.adminDvsCd ne 'P' }">
		<input type="hidden" name="cntcSystemInfoOthbcYn" value="<c:out value="${funding.cntcSystemInfoOthbcYn}"/>" />
	</c:if>

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
				<select name="rsrcctSpptDvsCd" id="rsrcctSpptDvsCd" class="select_type required">${rims:makeCodeList('1280', true, funding.rsrcctSpptDvsCd)}</select>
			</td>
			<th><spring:message code='fund.cpt.gov.offic.nm'/></th>
			<td ${clickAlert}>
				<input type="text" name="cptGovOfficNm" id="cptGovOfficNm"  class="input_type" value="<c:out value="${funding.cptGovOfficNm}"/>" ${setDisable}/>
			</td>
		</tr>
	    <tr>
	    	<th class="essential_th"><spring:message code='fund.rsrcct.sppt.agc.nm'/></th>
	    	<td ${clickAlert}>
	    		<input type="text" name="rsrcctSpptAgcNm" id="rsrcctSpptAgcNm"  class="input_type required" value="<c:out value="${funding.rsrcctSpptAgcNm}"/>" ${setDisable}/>
	    	</td>
	    	<th class="essential_th"><spring:message code='fund.biz.nm'/></th>
	    	<td>
	    		<input type="text" name="bizNm" id="bizNm"  class="input_type required" value="<c:out value="${funding.bizNm}"/>" ${setDisable}/>
	    	</td>
	    </tr>
	    <tr>
			<th class="essential_th add_help">
				<spring:message code='fund.sbjt.no'/><a href="javascript:void(0);" onclick="showTooltip($(this))" class="tbl_help_a"></a>
				<p class="th_help_box"><span><spring:message code='tooltip.fund1'/></span></p>
			</th>
	    	<td>
	    		<input type="text" name="sbjtNo" id="sbjtNo"  class="input_type" value="<c:out value="${funding.sbjtNo}"/>" ${setDisable}/>
	    	</td>
	    	<th><spring:message code='fund.sbjt.no.kaist'/></th>
	    	<td>
	    		<input type="text" name="agcSbjtNo" id="agcSbjtNo"  class="input_type" value="<c:out value="${funding.agcSbjtNo}"/>" ${setDisable}/>
	    	</td>
	    </tr>
	    <tr>
			<th class="essential_th"><spring:message code='fund.rsch.sbjt.nm'/></th>
			<td colspan="3">
				<input type="text" name="rschSbjtNm" id="rschSbjtNm"  class="input_type required" value="<c:out value="${funding.rschSbjtNm}"/>" ${setDisable}/>
			</td>
	    </tr>
	    <tr>
			<th class="essential_th"><spring:message code='fund.rsch.date'/></th>
			<td ${clickAlert}>
			  <input type="text" name="rschCmcmYear" id="rschCmcmYear" class="input_type required" style="width: 57px;" value="<c:out value="${funding.rschCmcmYear}"/>" ${setDisable} />&nbsp;<spring:message code='common.year'/>&nbsp;&nbsp;
              <input type="text" name="rschCmcmMonth" id="rschCmcmMonth" class="input_type" style="width: 40px;" value="<c:out value="${funding.rschCmcmMonth}"/>" ${setDisable} />&nbsp;<spring:message code='common.month'/>&nbsp;&nbsp;
              ~&nbsp;
              <input type="text"  name="rschEndYear" id="rschEndYear" class="input_type required" style="width: 57px;" value="<c:out value="${funding.rschEndYear}"/>" ${setDisable} />&nbsp;<spring:message code='common.year'/>&nbsp;&nbsp;
              <input type="text"  name="rschEndMonth" id="rschEndMonth" class="input_type" style="width: 40px;" value="<c:out value="${funding.rschEndMonth}"/>" ${setDisable} />&nbsp;<spring:message code='common.month'/>&nbsp;&nbsp;
			</td>
	    	<th class="essential_th"><spring:message code='fund.mny.yr.sbjt.nm'/></th>
	    	<td ${clickAlert}>
	    		<select name="mnyYrSbjtYn" id="mnyYrSbjtYn" class="select_type required" ${setDisable}>${rims:makeCodeList('1450',true,funding.mnyYrSbjtYn)}</select>
	    	</td>
	    </tr>
	    <tr>
	    	<th class="essential_th"><spring:message code='fund.rsch.sbjt.stdy.sphe.cd'/></th>
	    	<td ${clickAlert}>
	    		<select name="rschSbjtStdySpheCd" id="rschSbjtStdySpheCd" class="select_type required" ${setDisable}>${rims:makeCodeList('1350',true,funding.rschSbjtStdySpheCd)}</select>
	    	</td>
	    	<th><spring:message code='fund.blng.univ'/></th>
	    	<td ${clickAlert}>
				<span class="dk_bt_box">
					<input type="text" style="color: #aaa;" onclick="getOrgCodeGeneralWin($('#blngUnivCdKey'), $('#blngUnivCdValue'), event);" readonly="readonly" id="blngUnivCdValue" name="blngUnivNm" class="input_type" value="<c:out value="${funding.blngUnivNm}"/>"/>
					<input type="hidden" id="blngUnivCdKey" name="blngUnivCd" value="<c:out value="${funding.blngUnivCd}"/>"/>
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
				<table id="detailTbl" class="inner_tbl" style="table-layout:fixed;">
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
					  <c:set var="detailIdx" value="0"/>
					  <c:if test="${not empty funding.detailList}">
					  	<c:forEach items="${funding.detailList}" var="dl" varStatus="idx">
							<tr>
							  <td style="text-align: center;">
					  			<input type="hidden" name="detailIndex" id="detailIndex_${idx.count}" value="${idx.count}"/>
					  			<input type="hidden" name="seqFunding" id="seqFunding_${idx.count}" value="${empty dl.seqFunding ? 'N' : dl.seqFunding}"/>
					  			<span id="detailOrder_${idx.count}">${idx.count}</span>
					  		  </td>
					  		  <td ${clickAlert}>
					  		  	<input type="text" style="width: 40px; text-align: right;" name="rsrcctContYr" id="rsrcctContYr_${idx.count}" value="<c:out value="${dl.rsrcctContYr}"/>" maxlength="4" class="input_type required" ${setDisable}/><spring:message code='common.year'/>
					  		  </td>
					  		  <td style="text-align: center;">
					  		  	<input type="text" style="width: 80px; text-align: right;" name="totRsrcct" id="totRsrcct_${idx.count}" maxLength="15" class="input_type required" ${setDisable} value="<fmt:formatNumber value="${fn:trim(dl.totRsrcct)}"/>" onkeyup="getNumber($(this));" onkeydown="getNumber($(this));"/><spring:message code='fund.won'/>
					  		  </td>
					  		  <td style="text-align: center;">
					  		  	<input type="text" style="width: 80px; text-align: right;" name="prtyRsrcct"  id="prtyRsrcct_${idx.count}" maxLength="15" class="input_type required" ${setDisable} value="<fmt:formatNumber value="${fn:trim(dl.prtyRsrcct)}"/>" onkeyup="getNumber($(this));" onkeydown="getNumber($(this));"/><spring:message code='fund.won'/>
					  		  </td>
					  		  <td style="text-align: center;">
					  		  	<input type="text" style="width: 80px; text-align: right;" name="indrfee" id="indrfee_${idx.count}" maxLength="15" class="input_type required" ${setDisable} value="<fmt:formatNumber value="${fn:trim(dl.indrfee)}"/>" onkeyup="getNumber($(this));" onkeydown="getNumber($(this));"/><spring:message code='fund.won'/>
					  		  </td>
					  		  <td style="text-align: center;">
					  		  	<input type="text" style="width: 60px; text-align: right;" name="sclgrndCorrFund" id="sclgrndCorrFund_${idx.count}" maxLength="15" class="input_type required" ${setDisable} value="<fmt:formatNumber value="${fn:trim(dl.sclgrndCorrFund)}"/>" onkeyup="getNumber($(this));" onkeydown="getNumber($(this));"/><spring:message code='fund.won'/>
					  		  </td>
					  		  <td style="text-align: center;">
					  		  	<input type="text" style="width: 60px; text-align: right;" name="schoutCorrFund" id="schoutCorrFund_${idx.count}" maxLength="15" class="input_type required" ${setDisable} value="<fmt:formatNumber value="${fn:trim(dl.schoutCorrFund)}"/>" onkeyup="getNumber($(this));" onkeydown="getNumber($(this));"/><spring:message code='fund.won'/>
					  		  </td>
					  		  <td style="text-align: center;">
					  		  	<input type="text" style="width: 30px; text-align: right;" name="assoRschrCnt" id="assoRschrCnt_${idx.count}" maxLength="3" class="input_type required" ${setDisable} value="<c:out value="${dl.assoRschrCnt}"/>" />
					  		  </td>
					  		  <td style="text-align: center;">
					  		  	<input type="text" style="width: 30px; text-align: right;" name="asstRschrCnt" id="asstRschrCnt_${idx.count}" maxLength="3" class="input_type required" ${setDisable} value="<c:out value="${dl.asstRschrCnt}"/>" />
					  		  </td>
					  		  <c:if test="${sessionScope.login_user.adminDvsCd eq 'M' or sessionScope.login_user.adminDvsCd eq 'P' }">
						  		  <td style="text-align: center;">
						  		  	<select id="detailApprDvsCd_${idx.count}" name="detailApprDvsCd"  class="select_type">${rims:makeCodeList('1400', true, dl.apprDvsCd) }</select>
						  		  </td>
						  		  <td style="text-align: center;" class="dispDetailApprDate">
						  		  	<fmt:formatDate var="apprDate" value="${dl.apprDate}" pattern="yyyy-MM-dd" /><c:out value="${apprDate}"/>
						  		  </td>
					  		  </c:if>
					  		  <c:if test="${sessionScope.login_user.adminDvsCd ne 'M' and sessionScope.login_user.adminDvsCd ne 'P' }">
						  		  <td style="text-align: center;">
						  		  	${rims:codeValue('1400',dl.apprDvsCd)}
						  		  	<input type="hidden" name="apprDvsCd" value="<c:out value="${empty dl.apprDvsCd ? '1' : dl.apprDvsCd}"/>"/>
						  		  </td>
						  		  <td style="text-align: center;" class="dispDetailApprDate">
						  		  	<fmt:formatDate var="apprDate" value="${dl.apprDate}" pattern="yyyy-MM-dd" /><c:out value="${apprDate}"/>
						  		  </td>
					  		  </c:if>
						  		<td style="width:34px;" ${clickAlert}>
									<a href="javascript:void(0);" class="tbl_icon_a row_add_bt" onclick="addDetail($(this),'${sessionScope.login_user.adminDvsCd}')" ><spring:message code='common.add'/></a>
									<a href="javascript:void(0);" class="tbl_icon_a red_del" onclick="removeDetail($(this));"><spring:message code='common.row.delete'/></a>
						  		</td>
							</tr>
							<c:set var="detailIdx" value="${idx.count}"/>
					  	</c:forEach>
					  </c:if>
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
						<c:set var="prtcpntIdx" value="0"/>
						<c:if test="${not empty funding.partiList}">
						  <c:forEach items="${funding.partiList}" var="pl" varStatus="idx">
						  	<tr>
						  		<td style="width:10px;text-align: left;"><img src="<c:url value='/images/icon/dragpoint.png' />" /></td>
						  		<td style="width: 40px; text-align: center;">
						  			<input type="hidden" name="prtcpntIndex" id="prtcpntIndex_${idx.count}" value="${idx.count}"/>
						  			<span id="prtcpntOrder_${idx.count}">${idx.count}</span>
						  		</td>
						  		<td style="width:80px;" ${clickAlert}>
						  			<input type="text"  name="prtcpntNm" maxLength="30" id="prtcpntNm_${idx.count}" class="input_type required" value="<c:out value="${pl.prtcpntNm}"/>" ${setDisable} onkeydown="if(event.keyCode==13){findUser($(this),event);}"/>
						  			<input type="hidden" name="pcnRschrRegNo" id="pcnRschrRegNo_${idx.count}" value="<c:out value="${pl.pcnRschrRegNo}"/>"/>
				                	<input type="hidden" name="seqAuthor" id="seqAuthor_${idx.count}" value="${empty pl.seqParti ? 'N' : pl.seqParti}"/>
						  		</td>
						  		<td style="width:100px;" ${clickAlert}>
						  			<select name="tpiDvsCd" id="tpiDvsCd_${idx.count}" class="select_type required" ${setDisable}>${rims:makeCodeList('1360', true, pl.tpiDvsCd) }</select>
						  		</td>
						  		<td	style="width:140px;" ${clickAlert}>
									<span class="dk_bt_box">
									  <input type="text" name="prtcpntId" id="prtcpntId_${idx.count}" value="<c:out value="${pl.prtcpntId}"/>"  class="input_type" ${setDisable} onkeydown="if(event.keyCode==13){findUser($(this),event);}"/>
									 <span class="dk_r_bt">
										<a href="javascript:void(0);" class="tbl_icon_a tbl_search_icon" onclick="findUser($(this),event);">검색</a>
										<a href="javascript:void(0);" class="tbl_icon_a tbl_trash_icon" onclick="clearPrtcpnt($(this));">지우기</a>
									 </span>
									</span>
						  		</td>
						  		<td style="width:160px;" ${clickAlert}>
									<div class="r_add_bt">
										<input type="hidden" name="blngAgcCd" id="blngAgcCd_${idx.count}" value="<c:out value="${pl.blngAgcCd}"/>"/>
										<input type="text"  name="blngAgcNm" id="blngAgcNm_${idx.count}"  class="input_type"  ${setDisable} style="${pl.blngAgcNm eq '' && pl.blngAgcCd eq '' ? 'background-color: #fef3d7;' : ''}" value="<c:out value="${pl.blngAgcNm}"/>" onkeydown="if(event.keyCode==13){getCodeOrgWin($(this),event);}"/>
										<span class="r_span_box">
											<a href="javascript:void(0);" class="tbl_icon_a tbl_search_icon" onclick="getCodeOrgWin($(this),event);">검색</a>
										</span>
									</div>
						  		</td>
						  		<td style="width:240px;" ${clickAlert}>
									  <input type="hidden" name="tpiRate" maxLength="3" class="input_type" ${setDisable} value="<c:out value="${pl.tpiRate}"/>"/>
									  <input type="text" name="tpiSttYear" id="tpiSttYear_${idx.count}" class="input_type required" style="width: 40px;" value="<c:out value="${pl.tpiSttYear }"/>" ${setDisable} /><spring:message code='common.year'/>
						              <input type="text" name="tpiSttMonth" id="tpiSttMonth_${idx.count}" class="input_type" style="width: 25px;" value="<c:out value="${pl.tpiSttMonth}"/>" ${setDisable} /><spring:message code='common.month'/>
						              &nbsp;~&nbsp;
						              <input type="text" name="tpiEndYear" id="tpiEndYear_${idx.count}" class="input_type required" style="width: 40px;" value="<c:out value="${pl.tpiEndYear}"/>" ${setDisable} /><spring:message code='common.year'/>
						              <input type="text" name="tpiEndMonth" id="tpiEndMonth_${idx.count}" class="input_type" style="width: 25px;" value="<c:out value="${pl.tpiEndMonth}"/>" ${setDisable} /><spring:message code='common.month'/>
						  		</td>
						  		<td style="width:60px;" ${clickAlert}>
									<a href="javascript:void(0);" class="tbl_icon_a row_add_bt" onclick="addPrtcpnt($(this),'${sessionScope.login_user.adminDvsCd}')" ><spring:message code='common.add'/></a>
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
			<th><spring:message code='fund.keyword.kor'/></th>
			<td colspan="3">
				<input type="text"  id="keywordKor" name="keywordKor" class="input_type" maxlength="1000" value="<c:out value="${funding.keywordKor}"/>"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code='fund.keyword.eng'/></th>
			<td colspan="3">
				<input type="text"  id="keywordEng" name="keywordEng" class="input_type" maxlength="1000" value="<c:out value="${funding.keywordEng}"/>"/>
			</td>
		</tr>
	    <tr>
	    	<th><spring:message code='kri.link'/></th>
	    	<td>
	    		<c:set var="flag" value="${fn:substring(fn:trim(funding.interfaceFlag),0,1)}"/>
	    		<input type="radio" name="interfaceFlag" id="interfaceFlag1" value="1" class="" <c:if test="${flag eq '1'}">checked="checked"</c:if>/><spring:message code='kri.link.yes'/>
				<input type="radio" name="interfaceFlag" id="interfaceFlag0" value="0" class="" <c:if test="${empty  funding.interfaceFlag or flag eq '0' or funding.overallFlag eq 'S' }">checked="checked"</c:if>/><spring:message code='kri.link.no'/>
	    	</td>
	    	<th>Source</th>
	    	<td>
	    		<c:choose>
	    			<c:when test="${funding.overallFlag eq 'T'}">Principal</c:when>
	    			<c:when test="${funding.overallFlag eq 'S'}">Task</c:when>
	    			<c:otherwise>Manual</c:otherwise>
	    		</c:choose>
	    		<c:if test="${sessionScope.login_user.adminDvsCd eq 'M'}">
	    			<input style="margin-left:10px;" type="checkbox" name="isFixed" id="isFixed" value="Y" class="input2" <c:if test="${funding.isFixed eq 'Y'}">checked="checked"</c:if> /><spring:message code='fund.check'/>
	    		</c:if>
	    	</td>
	    </tr>
	    <c:if test="${sessionScope.auth.adminDvsCd eq 'M' or sessionScope.auth.adminDvsCd eq 'P'}">
	    <tr>
	    	<th>ERP No.</th>
	    	<td>${funding.erpId}</td>
			<th><spring:message code="fund.cntcSystem.info.open.yn"/></th>
			<td>
				<spring:message code="common.radio.yes"/> <input type="radio" name="cntcSystemInfoOthbcYn" value="Y" ${empty funding.cntcSystemInfoOthbcYn or funding.cntcSystemInfoOthbcYn eq 'Y' ? 'checked="checked"' : '' }/>
				&nbsp;&nbsp;&nbsp;<spring:message code="common.radio.no"/> <input type="radio" name="cntcSystemInfoOthbcYn" value="N" ${not empty funding.cntcSystemInfoOthbcYn and funding.cntcSystemInfoOthbcYn eq 'N' ? 'checked="checked"' : '' }/>
			</td>
	    </tr>
		<tr>
			<th><spring:message code='fund.appr'/></th>
			<td>
				<select id="apprDvsCdValue" name="apprDvsCd"  class="select_type" style="width: 100px;">${rims:makeCodeList('1400', true, funding.apprDvsCd) }</select>
			</td>
	    	<th rowspan="2"><spring:message code='fund.rtrn'/></th>
	    	<td rowspan="2">
				<div class="tbl_textarea">
					<textarea name="apprRtrnCnclRsnCntn" id="apprRtrnCnclRsnCntn" rows="3" maxLength="4000" ><c:out value="${funding.apprRtrnCnclRsnCntn}"/></textarea>
				</div>
	    	</td>
		</tr>
		<tr>
			<th><spring:message code='fund.appr.date'/></th>
			<td>
				<fmt:formatDate var="apprDate" value="${funding.apprDate}" pattern="yyyy-MM-dd" /><c:out value="${apprDate}"/>
			</td>
		</tr>
	    </c:if>
	    <c:if test="${sessionScope.auth.adminDvsCd ne 'M' and sessionScope.auth.adminDvsCd ne 'P'}">
	    <tr>
	    	<th>ERP No.</th>
	    	<td>${funding.erpId}</td>
	    	<th rowspan="3"><spring:message code='fund.rtrn'/></th>
	    	<td rowspan="3">
				<c:out value="${funding.apprRtrnCnclRsnCntn}"/>
				<input type="hidden" name="apprRtrnCnclRsnCntn" id="apprRtrnCnclRsnCntn" value="<c:out value="${funding.apprRtrnCnclRsnCntn}"/>"/>
	    	</td>
	    </tr>
		<tr>
			<th><spring:message code='fund.appr'/></th>
			<td>
				${rims:codeValue('1400',funding.apprDvsCd)}
				<input type="hidden" name="apprDvsCd" value="<c:out value="${empty funding.apprDvsCd ? '1' : funding.apprDvsCd}"/>"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code='fund.appr.date'/></th>
			<td>
				<fmt:formatDate var="apprDate" value="${funding.apprDate}" pattern="yyyy-MM-dd" /><c:out value="${apprDate}"/>
			</td>
		</tr>
	    </c:if>
		<tr>
			<th><spring:message code='common.reg.date'/></th>
			<td>
				<fmt:formatDate var="regDate" value="${funding.regDate}" pattern="yyyy-MM-dd" /> <c:out value="${regDate}"/> ( <c:out value="${empty funding.regUserNm ? 'ADMIN' : funding.regUserNm}"/> )
			</td>
			<th><spring:message code='common.mod.date'/></th>
			<td>
				<fmt:formatDate var="modDate" value="${funding.modDate}" pattern="yyyy-MM-dd" /> <c:out value="${modDate}"/> ( <c:out value="${empty funding.modUserNm ? 'ADMIN' : funding.modUserNm}"/> )
			</td>
		</tr>
	</tbody>
  </table>
</form>
<form id="removeFormArea" action="<c:url value="/funding/removeFunding.do"/>" method="post">
  <input type="hidden" name="fundingId" value="${funding.fundingId}"/>
</form>
<script type="text/javascript">
$(document).ready(function(){
	  $('input, select, textarea').change(function(){ isChange = true; });
	  $('input:checkbox, input:radio').click(function(){ isChange = true; });
	  $("#prtcpntTbl tbody").sortable({
		  placeholder: "ui-state-highlight",
		  deactivate: function(event, ui){
			  $('span[id^="prtcpntOrder_"]').each(function(i, obj){ $(obj).text(i+1); });
			  isChange = true;
		  }
	  });
	  //$("#prtcpntTbl tbody").disableSelection();
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