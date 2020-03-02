<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%><%@ page import="kr.co.argonet.r2rims.util.LanguageUtil"%>
<%@include file="../../pageInit.jsp"%>
<form id="formArea" action="${contextPath}/techtrans/modifyTechtrans.do" method="post">
	<input type="hidden" id="techtransId" name="techtransId" value="${techtrans.techtransId}"/>
	<input type="hidden" name="relisUser" value="N" />
	<input type="hidden" name="deleteUser" value="N" />
		
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
					<input type="text" maxLength="4" style="width: 62px;text-align: right;" name="techTransrYear" id="techTransrYear" class="input_type required"  value="<c:out value="${techtrans.techTransrYear}"/>"/><spring:message code='common.year'/>
					<input type="text" maxLength="2" style="width: 32px;text-align: right;" name="techTransrMonth" id="techTransrMonth" class="input_type required"  value="<c:out value="${techtrans.techTransrMonth}"/>" /><spring:message code='common.month'/>
				</td>
				<th class="add_help">
					<spring:message code='tech.transr.corp.nm'/><a href="javascript:void(0);" onclick="showTooltip($(this))" class="tbl_help_a"></a>
					<p class="th_help_box"><span><spring:message code='tooltip.tech1'/></span></p>
				</th>
				<td>
					<input type="text" name="techTransrCorpNm"  id="techTransrCorpNm" class="input_type" style="width: 200px;" value="<c:out value="${techtrans.techTransrCorpNm}"/>"/>
					<input type="checkbox" name="techTransrCorpOpenCd" id="techTransrCorpOpenCd" ${techtrans.techTransrCorpOpenCd == 'Y' ? 'checked=\"checked\"' : ''} value="Y"/><label for="techTransrCorpOpenCd">기업공개시</label>
				</td>
			</tr>
			<tr>
				<th><spring:message code='tech.transr.type'/></th>
				<td>
					<select name="techTransrCd" id="techTransrCd" class="select_type">${rims:makeCodeList('tech.techTransrCd', true, techtrans.techTransrCd)}</select>
				</td>
				<th><spring:message code='tech.collection.type'/></th>
				<td>
					<select name="collectionCd" id="collectionCd" class="select_type">${rims:makeCodeList('tech.collectionCd', true, techtrans.collectionCd)}</select>
				</td>
			</tr>
			<tr>
				<th class="essential_th"><spring:message code='tech.transr.nm'/></th>
				<td colspan="3">
					<input type="text" name="techTransrNm" id="techTransrNm" class="input_type" value="<c:out value="${techtrans.techTransrNm}"/>"/>
				</td>
			</tr>
			<tr>
				<th class="essential_th"><spring:message code='tech.transr.cnt'/></th>
				<td><input type="text" name="techTransrCnt" id="techTransrCnt" maxLength="6" class="input_type required" value="<c:out value="${techtrans.techTransrCnt}"/>" /></td>
				<th class="essential_th add_help">
					<spring:message code='tech.asso.tech.poss.cnt'/><a href="javascript:void(0);" onclick="showTooltip($(this))" class="tbl_help_a"></a>
					<p class="th_help_box"><span><spring:message code='tooltip.tech2'/></span></p>
				</th>
				<td>
					<input type="text" name="assoTechPossCnt" id="assoTechPossCnt" maxLength="6" class="input_type required" value="<c:out value="${techtrans.assoTechPossCnt}"/>" />
				</td>
			</tr>
			<tr>
				<th><spring:message code='tech.blng.univ'/></th>
				<td>
					<span class="dk_bt_box">
						<input type="text" style="color: #aaa;" onclick="getOrgCodeGeneralWin($('#blngUnivCdKey'), $('#blngUnivCdValue'), event);" readonly="readonly" id="blngUnivCdValue" name="blngUnivNm" class="input_type" value="<c:out value="${techtrans.blngUnivNm}"/>"/>
						<input type="hidden" id="blngUnivCdKey" name="blngUnivCd" value="<c:out value="${techtrans.blngUnivCd}"/>"/>
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
					<c:choose>
						<c:when test="${sessionScope.auth.adminDvsCd eq 'M' }">
							<input type="text" name="cntrctManageNo" id="cntrctManageNo" class="input_type" value="<c:out value="${techtrans.cntrctManageNo}"/>" />
						</c:when>
						<c:otherwise>
							<c:out value="${techtrans.cntrctManageNo}"/>
							<input type="hidden" name="cntrctManageNo" id="cntrctManageNo" value="<c:out value="${techtrans.cntrctManageNo}"/>" />
						</c:otherwise>
					</c:choose>
				</td>
				<th><spring:message code='tech.cntrct.period'/></th>
				<td>
				  <input type="text" name="cntrctSttYear" id="cntrctSttYear" class="input_type" style="width: 40px;" value="<c:out value="${techtrans.cntrctSttYear }"/>"/><spring:message code='common.year'/>
	              <input type="text" name="cntrctSttMonth" id="cntrctSttMonth" class="input_type" style="width: 25px;" value="<c:out value="${techtrans.cntrctSttMonth}"/>"/><spring:message code='common.month'/>
	              &nbsp;~&nbsp;
	              <input type="text" name="cntrctEndYear" id="cntrctEndYear" class="input_type" style="width: 40px;" value="<c:out value="${techtrans.cntrctEndYear}"/>" /><spring:message code='common.year'/>
	              <input type="text" name="cntrctEndMonth" id="cntrctEndMonth" class="input_type" style="width: 25px;" value="<c:out value="${techtrans.cntrctEndMonth}"/>" /><spring:message code='common.month'/>
				</td>
			</tr>
			<tr>
				<th><spring:message code='tech.cntrct.amt'/></th>
				<td>
					<input type="text" style="width: 234px;text-align: right;" name="cntrctAmt" id="cntrctAmt" maxLength="15" class="input_type" value="<fmt:formatNumber value="${techtrans.cntrctAmt}"/>" onkeyup="getNumber($(this));" onkeydown="getNumber($(this));"/>
					<select style="width: 65px;" name="rpmAmtUnit" id="rpmAmtUnit" class="select_type">${rims:makeCodeList('tech.rpmAmtUnit', true, techtrans.rpmAmtUnit)}</select>
				</td>
				<th><spring:message code='tech.oprtn.cnd'/></th>
				<td>
					<input type="text" name="oprtnCnd" id="oprtnCnd" class="input_type" value="<c:out value="${techtrans.oprtnCnd}"/>"/>
				</td>
			</tr>
			<tr>
				<th><spring:message code='tech.rpm'/></th>
				<td colspan="3"></td>
			</tr>
			<tr>
				<td colspan="4" class="inner_tbl_td">
					<div id="rpmDiv" style="overflow: auto;">
						<table class="inner_tbl move_tbl" id="royaltyTbl">
							<thead>
								<tr>
									<th colspan="2" style="width:50px;">No</th>
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
									<th style="width: 60px;"></th>
								</tr>
							</thead>
							<tbody>
								<c:set var="royaltyIdx" value="0"/>
								<c:if test="${not empty techtrans.royaltyList}">
								<c:forEach items="${techtrans.royaltyList}" var="rl" varStatus="idx">
								<tr>
									<td style="width:10px;text-align: left;"><img src="<c:url value='/images/icon/dragpoint.png' />" /></td>
									<td style="text-align: center;width: 40px;">
							  			<input type="hidden" name="royaltyIndex" id="royaltyIndex_${idx.count}" value="${idx.count}"/>
							  			<input type="hidden" name="seqRoyalty" id="seqRoyalty_${idx.count}" value="${empty rl.seqRoyalty ? 'N' : rl.seqRoyalty}"/>
							  			<span class="royalty_order" id="order_${idx.count}">${idx.count}</span>
							  		</td>
									<td style="width: 140px;"><select name="collectionType" id="collectionType_${idx.count}" class="select_type">${rims:makeCodeList('tech.collectionType', true, rl.collectionType)}</select></td>
									<td style="width: 50px;"><input type="text" name="rpmTme" id="rpmTme_${idx.count}" value="<c:out value="${rl.rpmTme}"/>" maxlength="4" class="input_type"/></td>
									<td style="width: 100px;"><input type="text" name="rpmDate" id="rpmDate_${idx.count}" value="<c:out value="${rl.rpmDate}"/>" maxlength="10" class="input_type"/></td>
									<td style="width: 120px;">
										<input type="text" style="width :100px; text-align: right;" name="rpmAmt"  id="rpmAmt_${idx.count}" maxLength="15" class="input_type" value="<fmt:formatNumber value="${rl.rpmAmt}"/>" onkeyup="getNumber($(this));" onkeydown="getNumber($(this));"/><spring:message code='fund.won'/>
								  		<input type="hidden" name="ddcAmt" value="${rl.ddcAmt}" />
								  		<input type="hidden" name="ddcResn" value="<c:out value="${rl.ddcResn}"/>" />
								  		<input type="hidden" name="diffAmt" value="${rl.diffAmt}" />
								  		<input type="hidden" name="invnterDstbAmt" value="<fmt:formatNumber value="${rl.invnterDstbAmt}"/>" />
								  		<input type="hidden" name="univDstbAmt" value="<fmt:formatNumber value="${rl.univDstbAmt}"/>" />
								  		<input type="hidden" name="deptDstbAmt" value="<fmt:formatNumber value="${rl.deptDstbAmt}"/>" />
								  		<input type="hidden" name="acdincpDstbAmt" value="<fmt:formatNumber value="${rl.acdincpDstbAmt}"/>" />
									</td>
									<!-- 
									<td><input type="text" style="width :85px; text-align: right;" name="ddcAmt"  id="ddcAmt_${idx.count}" maxLength="15" class="input_type" value="<fmt:formatNumber value="${rl.ddcAmt}"/>" onkeyup="getNumber($(this));" onkeydown="getNumber($(this));"/><spring:message code='fund.won'/></td>
									<td><input type="text" name="ddcResn" id="ddcResn" value="<c:out value="${rl.ddcResn}"/>" class="input_type"/></td>
									<td><input type="text" style="width :85px; text-align: right;" name="diffAmt"  id="diffAmt_${idx.count}" maxLength="15" class="input_type" value="<fmt:formatNumber value="${rl.diffAmt}"/>" onkeyup="getNumber($(this));" onkeydown="getNumber($(this));"/><spring:message code='fund.won'/></td>
									<td><input type="text" style="width :85px; text-align: right;" name="invnterDstbAmt"  id="invnterDstbAmt_${idx.count}" maxLength="15" class="input_type" value="<fmt:formatNumber value="${rl.invnterDstbAmt}"/>" onkeyup="getNumber($(this));" onkeydown="getNumber($(this));"/><spring:message code='fund.won'/></td>
									<td><input type="text" style="width :85px; text-align: right;" name="univDstbAmt"  id="univDstbAmt_${idx.count}" maxLength="15" class="input_type" value="<fmt:formatNumber value="${rl.univDstbAmt}"/>" onkeyup="getNumber($(this));" onkeydown="getNumber($(this));"/><spring:message code='fund.won'/></td>
									<td><input type="text" style="width :85px; text-align: right;" name="deptDstbAmt"  id="deptDstbAmt_${idx.count}" maxLength="15" class="input_type" value="<fmt:formatNumber value="${rl.deptDstbAmt}"/>" onkeyup="getNumber($(this));" onkeydown="getNumber($(this));"/><spring:message code='fund.won'/></td>
									<td><input type="text" style="width :85px; text-align: right;" name="acdincpDstbAmt"  id="acdincpDstbAmt_${idx.count}" maxLength="15" class="input_type" value="<fmt:formatNumber value="${rl.acdincpDstbAmt}"/>" onkeyup="getNumber($(this));" onkeydown="getNumber($(this));"/><spring:message code='fund.won'/></td>
									-->
									<c:if test="${sessionScope.login_user.adminDvsCd eq 'M' or sessionScope.login_user.adminDvsCd eq 'P' }">
										<td style="text-align: center;">
											<select name="royaltyApprDvsCd" class="select_type">${rims:makeCodeList('1400', true, rl.apprDvsCd) }</select>
										</td>
									</c:if>
									<c:if test="${sessionScope.login_user.adminDvsCd ne 'M' and sessionScope.login_user.adminDvsCd ne 'P' }">
										<td style="text-align: center;">${rims:codeValue('1400', rl.apprDvsCd)}
											<input type="hidden" name="royaltyApprDvsCd" value="<c:out value="${empty rl.apprDvsCd ? '1' : rl.apprDvsCd}"/>"/>
										</td>
									</c:if>
									<td style="text-align: center;" class="dispRoyaltyApprDate"><fmt:formatDate var="royaltyApprDate" value="${rl.apprDate}" pattern="yyyy-MM-dd" /><c:out value="${royaltyApprDate}"/></td>
									<c:if test="${sessionScope.login_user.adminDvsCd eq 'M' or sessionScope.login_user.adminDvsCd eq 'P' }">
										<td style="text-align: center;"><input type="text" name="royaltyApprRtrnCnclRsnCntn" value="<c:out value="${rl.apprRtrnCnclRsnCntn}"/>" class="input_type"/></td>
									</c:if>
									<c:if test="${sessionScope.login_user.adminDvsCd ne 'M' and sessionScope.login_user.adminDvsCd ne 'P' }">
										<td style="text-align: center;"><input type="text" name="royaltyApprRtrnCnclRsnCntn_disabled" value="<c:out value="${rl.apprRtrnCnclRsnCntn}"/>" class="input_type" disabled="disabled" /><input type="hidden" name="royaltyApprRtrnCnclRsnCntn" value="<c:out value="${rl.apprRtrnCnclRsnCntn}"/>" class="input_type"/></td>
									</c:if>
									<td style="width: 60px;">
										<a href="javascript:void(0);" class="tbl_icon_a row_add_bt" onclick="addRoyalty($(this));" ><spring:message code='common.add'/></a>
										<a href="javascript:void(0);" class="tbl_icon_a red_del" onclick="removeRoyalty($(this));"><spring:message code='common.row.delete'/></a>
									</td>
								</tr>
								<c:set var="royaltyIdx" value="${idx.count}"/>
								</c:forEach>
								</c:if>
								<script type="text/javascript">var royaltyIdx = '${royaltyIdx}';</script>
							</tbody>
						</table>
					</div>
				</td>
			</tr>
			<tr>
			   	<th><spring:message code='tech.parti'/></th>
			   	<td colspan="3"></td>
			</tr>
			<tr>
				<td colspan="4" class="inner_tbl_td">
					<table class="inner_tbl move_tbl" id="prtcpntTbl">
						<thead>
							<tr>
								<th colspan="2" style="width:50px;">No</th>
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
						  <c:if test="${not empty techtrans.partiList}">
						    <c:forEach items="${techtrans.partiList}" var="pl" varStatus="idx">
								<tr>
									<td style="width:10px;text-align: left;"><img src="<c:url value='/images/icon/dragpoint.png' />" /></td>
									<td style="text-align: center;width: 40px;">
		 					  			<input type="hidden" name="prtcpntIndex" id="prtcpntIndex_${idx.count}" value="${idx.count}"/>
						                <input type="hidden" name="seqAuthor" id="seqAuthor_${idx.count}" value="${pl.seqAuthor}"/>
		 					  			<span id="order_${idx.count}" class="prtcpnt_order">${idx.count}</span>
									</td>
		 					  		<td style="width:110px;">
						                <input type="text"  name="prtcpntNm" maxLength="30" id="prtcpntNm_${idx.count}" class="input_type required" value="<c:out value="${pl.prtcpntNm}"/>" onkeydown="if(event.keyCode==13){findUser($(this),event);}"/>
		 					  		</td>
		 					  		<td style="width:120px">
		 					  		    <input type="text" name="prtcpntFullNm" maxLength="100" id="prtcpntFullNm_${idx.count}" class="input_type" value="<c:out value="${pl.prtcpntFullNm}"/>" onkeydown="if(event.keyCode==13){findUser($(this),event);}"/>
		 					  		</td>
		 					  		<td style="width:110px;">
		 					  		   <select name="tpiDvsCd" id="tpiDvsCd_${idx.count}" class="select_type">${rims:makeCodeList('1340', true, pl.tpiDvsCd) }</select>
		 					  		</td>
									<td style="width: 140px;">
										<span class="dk_bt_box">
										  <input type="text" name="prtcpntId" id="prtcpntId_${idx.count}" value="<c:out value="${pl.prtcpntId}"/>"  class="input_type" onkeydown="if(event.keyCode==13){findUser($(this),event);}"/>
										 <span class="dk_r_bt">
											<a href="javascript:void(0);" class="tbl_icon_a tbl_search_icon" onclick="findUser($(this),event);">검색</a>
											<a href="javascript:void(0);" class="tbl_icon_a tbl_trash_icon" onclick="clearPrtcpnt($(this));">지우기</a>
										 </span>
										</span>
									</td>
									<td style="width: 190px;">
										<div class="r_add_bt">
											<input type="hidden" name="blngAgcCd" id="blngAgcCd_${idx.count}" value="<c:out value="${pl.blngAgcCd}"/>"/>
											<input type="text"  name="blngAgcNm" id="blngAgcNm_${idx.count}"  class="input_type" style="${pl.blngAgcNm eq '' && pl.blngAgcCd eq '' ? 'background-color: #fef3d7;' : ''}" value="<c:out value="${pl.blngAgcNm}"/>" onkeydown="if(event.keyCode==13){getCodeOrgWin($(this),event);}"/>
											<span class="r_span_box">
												<a href="javascript:void(0);" class="tbl_icon_a tbl_search_icon" onclick="getCodeOrgWin($(this),event);">검색</a>
											</span>
										</div>
									</td>
		 					  		<td style="width:150px" class="dispDept">
		 					  			<c:if test="${not empty pl.blngAgcNm and pl.blngAgcNm eq instName}"><c:out value="${pl.deptKor}"/></c:if>
		 					  		</td>
									<td style="width:60px">
										<a href="javascript:void(0);" class="tbl_icon_a row_add_bt" onclick="addPrtcpnt($(this),'${sessionScope.login_user.adminDvsCd}')"><spring:message code='common.add'/></a>
										<a href="javascript:void(0);" class="tbl_icon_a red_del" onclick="removePrtcpnt($(this));"><spring:message code='common.row.delete'/></a>
										<input type="hidden" name="tpiRate" value="<c:out value="${empty pl.tpiRate ? '_blank' : pl.tpiRate}"/>"/>
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
			   	<th>관련특허</th>
			   	<td colspan="3"></td>
			</tr>
			<tr>
				<td colspan="4" class="inner_tbl_td">
					<table class="inner_tbl" id="pmsPatent">
						<colgroup>
							<col style="width:60px;" />
							<col style="width:140px;" />
							<col />
						</colgroup>
						<thead>
							<tr>
								<th>번호</th>
								<th>출원번호</th>
								<th>지식재산권명</th>
							</tr>
						</thead>
						<tbody>
							<c:if test="${not empty techtrans.patentMapngList}">
							<c:forEach items="${techtrans.patentMapngList}" var="pml" varStatus="idx">
							<tr>
								<td style="text-align: center;"><span>${idx.count}</span></td>
	 					  		<td><c:out value="${pml.applRegNo}"/></td>
	 					  		<td><c:out value="${pml.itlPprRgtNm}"/></td>
							</tr>
							</c:forEach>
							</c:if>
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
						<option value="PMS" ${techtrans.src eq 'PMS' ? 'selected="selected"' : ''}>PPMS</option>
					</select>
				</td>
				<th>특허시스템ID</th>
				<td><input type="text" name="srcId" id="srcId" class="input_type" value="<c:out value="${techtrans.srcId}"/>"/></td>
			</tr>
			</c:if>
			<c:if test="${sessionScope.auth.adminDvsCd eq 'M' or sessionScope.auth.adminDvsCd eq 'P'}">
			<tr>
				<th><spring:message code='tech.appr.dvs.cd'/></th>
				<td>
					<select id="apprDvsCdValue" name="apprDvsCd"  class="select_type" style="width: 100px;">${rims:makeCodeList('1400', true, techtrans.apprDvsCd) }</select>
				</td>
				<th rowspan="2"><spring:message code='tech.rtrn'/></th>
				<td rowspan="2">
					<div class="tbl_textarea">
						<textarea name="apprRtrnCnclRsnCntn" id="apprRtrnCnclRsnCntn" rows="3" maxLength="4000" ><c:out value="${techtrans.apprRtrnCnclRsnCntn}"/></textarea>
					</div>
				</td>
			</tr>
			<tr>
				<th><spring:message code='tech.appr.dvs.date'/></th>
				<td><fmt:formatDate value="${techtrans.apprDate}" pattern="yyyy-MM-dd" /></td>
			</tr>
			</c:if>
			<c:if test="${sessionScope.auth.adminDvsCd ne 'M' and sessionScope.auth.adminDvsCd ne 'P'}">
			<tr>
				<th><spring:message code='tech.appr.dvs.cd'/></th>
				<td>
					${rims:codeValue('1400',techtrans.apprDvsCd)}
					<input type="hidden" name="apprDvsCd" value="<c:out value="${empty techtrans.apprDvsCd ? '1' : techtrans.apprDvsCd}"/>"/>
				</td>
				<th rowspan="2"><spring:message code='tech.rtrn'/></th>
				<td rowspan="2">
					<c:out value="${techtrans.apprRtrnCnclRsnCntn}"/>
					<input type="hidden" name="apprRtrnCnclRsnCntn" id="apprRtrnCnclRsnCntn" value="<c:out value="${techtrans.apprRtrnCnclRsnCntn}"/>"/>
				</td>
			</tr>
			<tr>
				<th><spring:message code='tech.appr.dvs.date'/></th>
				<td><fmt:formatDate var="apprDate" value="${techtrans.apprDate}" pattern="yyyy-MM-dd" /></td>
			</tr>
			</c:if>
			<tr>
				<th><spring:message code='common.reg.date'/></th>
				<td>
					<fmt:formatDate var="regDate" value="${techtrans.regDate}" pattern="yyyy-MM-dd" /> <c:out value="${regDate}"/> ( <c:out value="${empty techtrans.regUserNm ? 'ADMIN' : techtrans.regUserNm}"/> )
				</td>
				<th><spring:message code='common.mod.date'/></th>
				<td>
					<fmt:formatDate var="modDate" value="${techtrans.modDate}" pattern="yyyy-MM-dd" /> <c:out value="${modDate}"/> ( <c:out value="${empty techtrans.modUserNm ? 'ADMIN' : techtrans.modUserNm}"/> )
				</td>
			</tr>
		</tbody>
	</table>
</form>
<form id="removeFormArea" >
	<input type="hidden" id="techtransId" name="techtransId" value="${techtrans.techtransId}"/>
</form>
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
    $("#royaltyTbl tbody").sortable({
        placeholder: "ui-state-highlight",
        deactivate: function(event, ui){
            $('#royaltyTbl span[class="royalty_order"]').each(function(i, obj){ $(obj).text(i+1); });
            isChange = true;
        }
    });

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
