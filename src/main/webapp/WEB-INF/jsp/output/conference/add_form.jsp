<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.argonet.r2rims.util.LanguageUtil"%>
<%@include file="../../pageInit.jsp" %>
<c:if test="${sessMode or (sessionScope.auth.adminDvsCd eq 'R' or sessionScope.auth.adminDvsCd eq 'S' )}">
  <c:set var="prtpntId" value="${sessionScope.sess_user.userId}"/><c:set var="prtcpntNm" value="${sessionScope.sess_user.abbrLastName}, ${sessionScope.sess_user.abbrFirstName}"/>
  <c:set var="prtcpntFullNm" value="${sessionScope.sess_user.lastName}, ${sessionScope.sess_user.firstName}"/><c:set var="pcnRschrRegNo" value="${sessionScope.sess_user.rschrRegNo}"/>
  <c:set var="deptKor" value="${sessionScope.sess_user.groupDept}"/><c:set var="blngAgcCd" value="${sysConf['inst.blng.agc.code']}"/><c:set var="blngAgcNm" value="${sysConf['inst.blng.agc.name']}"/>
  <c:set var="posiCd" value="${sessionScope.sess_user.posiMapngCd}"/>
</c:if>

<c:set var="rschRequiredClass" value=""/><c:set var="rschEssentialTh" value=""/>
<c:if test="${sessionScope.auth.adminDvsCd eq 'R' or sessionScope.auth.adminDvsCd eq 'S'}">
<c:set var="rschRequiredClass" value="required"/><c:set var="rschEssentialTh" value="essential_th"/>
</c:if>
<!-- 검증Form (KRI,RIMS,DOI 검색 입력) -->
<form id="vrfcFrm">
<table class="write_tbl mgb_10"  style="border: 3px solid #eb7835;">
	<colgroup>
		<col style="width: 15%;"/>
		<col style="width: 37%;"/>
		<col style="width: 15%;"/>
		<col />
		<col style="width: 50px;"/>
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="con.search.db.choice"/></th>
			<td>
				<input name="srchTrget" id="srchTrget_SCOPUS" type="radio" style="vertical-align: middle;" value="scopus" onclick="onClickTaget($(this))" checked="checked"/>
					<label for="srchTrget_SCOPUS"><spring:message code="con.search.trget.scopus"/></label>&nbsp;
				<%--
				<input name="srchTrget" id="srchTrget_DOI" type="radio" style="vertical-align: middle;" value="doi" onclick="onClickTaget($(this))"/>
					<label for="srchTrget_DOI"><spring:message code="con.search.trget.doi"/></label>&nbsp;
				 --%>
                <input name="srchTrget" id="srchTrget_corssref" type="radio" style="vertical-align: middle;" value="crossref" onclick="onClickTaget($(this))"/><label for="srchTrget_corssref">DOI</label>&nbsp;
				<input name="srchTrget" id="srchTrget_RIMS" type="radio" style="vertical-align: middle;" value="rims" onclick="onClickTaget($(this))" />
					<label for="srchTrget_RIMS"><spring:message code="con.search.trget.rims"/></label>&nbsp;
			</td>
			<th><spring:message code='art.add.pblc.ym'/></th>
			<td>
				<input type="text" name="srchAncmYear" id="srchAncmYear" maxLength="4" class="input_type" style="width:100px;"/>
			</td>
			<td rowspan="2" onclick="javascript:srchCnfrnc();" class="option_search_td"></td>
		</tr>
		<tr>
			<th><span id="titleSpan"><spring:message code='art.add.title'/></span><span id="doiSpan" style="display: none;">DOI</span></th>
			<td colspan="3">
				<label for="srchKeyword" id="srchKeywordLabel" class="labelHelp">
					<span id="scopusLable"><spring:message code='con.scopus.search.comment'/></span>
					<span id="titleLable" style="display: none;"><spring:message code='con.keyword.search.comment'/></span>
					<span id="doiLable" style="display: none;"><spring:message code='con.doi.search.comment'/></span>
				</label>
				<input type="text" name="srchKeyword" id="srchKeyword"  class="input_type" onfocus="onFocusHelp('srchKeyword');" onblur="onBlurHelp('srchKeyword');"/>
			</td>
		</tr>
	</tbody>
</table>
</form>
<form id="formArea" action="<c:url value="/${preUrl}/conference/addConference.do"/>" method="post" enctype="multipart/form-data" >
  <table class="write_tbl mgb_10" >
	  <colgroup>
		  <col style="width:15%;" />
		  <col style="width:20%;" />
		  <col style="width:15%;" />
		  <col style="width:20%;" />
		  <col style="width:15%;" />
		  <col style="width:20%;" />
		  <col style="width:20%;" />
	  </colgroup>
	<tbody>
	<c:if test="${sessMode or (sessionScope.auth.adminDvsCd eq 'R' or sessionScope.auth.adminDvsCd eq 'S' )}">
		<tr style="height: 35px;">
			<th><spring:message code="con.reprsnt.conference.at"/></th>
			<td colspan="6">
				<spring:message code="common.radio.yes"/> <input type="radio" name="isReprsntConference" value="Y"/>
				&nbsp;&nbsp;&nbsp;<spring:message code="common.radio.no"/> <input type="radio" name="isReprsntConference" value="N" checked="checked"/>
			</td>
		</tr>
	</c:if>
		<tr>
			<th class="essential_th add_help">
				<spring:message code='con.cfrc.dvs.cd'/><a href="javascript:void(0);" onclick="showTooltip($(this))" class="tbl_help_a"></a>
				<p class="th_help_box"><span><spring:message code='tooltip.con1'/></span></p>
			</th>
			<td>
				<select name="scjnlDvsCd" id="scjnlDvsCd" class="select_type required">
					<option value="1"><spring:message code='con.domestic'/></option>
					<option value="2"><spring:message code='con.international'/></option>
				</select>
			</td>
			<th class="essential_th">
				<spring:message code='con.cfrc.hctr.cd'/>
			</th>
			<td>
				<select name="pblcNtnCd" id="pblcNtnCd" class="select_type required">
		          	${rims:makeCodeList('2000', true, '') }
		        </select>
		        <script type="text/javascript">
		        	jQuery(document).ready(function(){ $('#pblcNtnCd > option').eq(9).after($('<option value="">====================</option>')); });
		        </script>
			</td>
			<th>ISSN</th>
			<td colspan="2">
				<input type="text" name="issnNo"  maxLength="9" id="issnNo" class="input_type" value="${conference.issnNo}"/>
			</td>
		</tr>
		<tr>
			<th class="essential_th"><spring:message code='con.hld.date'/></th>
			<td colspan="3">
				<input type="text" name="hldSttYear" id="hldSttYear" class="input_type required" style="width: 40px;" maxLength="4" /><spring:message code='common.year'/>&nbsp;
				<input type="text" name="hldSttMonth" id="hldSttMonth" class="input_type" style="width: 25px;" maxLength="2" /><spring:message code='common.month'/>&nbsp;
				<input type="text" name="hldSttDay" id="hldSttDay" class="input_type" style="width: 25px;" maxLength="2" /><spring:message code='common.day'/>&nbsp;
				~
				<input type="text" name="hldEndYear" id="hldEndYear" class="input_type required" style="width: 40px;" maxLength="4" /><spring:message code='common.year'/>&nbsp;
				<input type="text" name="hldEndMonth" id="hldEndMonth" class="input_type" style="width: 25px;" maxLength="2" /><spring:message code='common.month'/>&nbsp;
				<input type="text" name="hldEndDay" id="hldEndDay" class="input_type" style="width: 25px;" maxLength="2" /><spring:message code='common.day'/>&nbsp;
			</td>
			<th class="essential_th">
				<spring:message code='con.ancm.date'/>
			</th>
			<td colspan="2">
				<input type="text" name="ancmYear" id="ancmYear" class="input_type required" style="width: 39px;" maxLength="4" /><spring:message code='common.year'/>&nbsp;
				<input type="text" name="ancmMonth" id="ancmMonth" class="input_type required" style="width: 24px;" maxLength="2" /><spring:message code='common.month'/>&nbsp;
				<input type="text" name="ancmDay" id="ancmDay" class="input_type" style="width: 24px;" maxLength="2" /><spring:message code='common.day'/>&nbsp;
			</td>
		</tr>
		<tr>
			<th class="essential_th">
				<spring:message code='con.hld.agc.nm'/>
			</th>
			<td colspan="6">
				<input type="text" name="pblcPlcNm" id="pblcPlcNm" class="input_type required"/>
			</td>
		</tr>
		<c:if test="${sessionScope.auth.adminDvsCd eq 'M' or sessionScope.auth.adminDvsCd eq 'P' or sessionScope.sess_user.deptCode eq '2783'  or sessionScope.sess_user.deptCode eq '2785' }">
		<tr>
			<th><spring:message code='con.cfrc.nm'/>(BK)</th>
			<td colspan="4">
				<div class="r_add_bt">
            	  <span class="add_int_del">
  				    <label for="schlshpCnfrncNm" id="schlshpCnfrncNmLabel" class="labelHelp"><spring:message code="con.schlshp.cnfrn.comment" /></label>
               	  	<input type="text" name="schlshpCnfrncNm" id="schlshpCnfrncNm" class="input_type" readonly="readonly"  onclick="findConferenceMaster($(this));" onfocus="onFocusHelp('schlshpCnfrncNm');" onblur="onBlurHelp('schlshpCnfrncNm');"/>
               	  	<a href="javascript:void(0);" class="tbl_int_del" onclick="clearBkData();">지우기</a>
				  </span>
				  <span class="r_span_box">
					<a href="javascript:void(0);" class="tbl_icon_a tbl_search_icon" onclick="findConferenceMaster($(this));">검색</a>
				  </span>
				</div>
			</td>
			<th><spring:message code="con.regarded.if"/></th>
			<td>
				<input type="hidden" name="schlshpCnfrncCode" id="schlshpCnfrncCode" class="input_type" value="">
				<input type="text" name="impctFctr" id="impctFctr" class="input_type" value="" readonly="readonly"/>
			</td>
		</tr>
		</c:if>
		<tr>
			<th class="essential_th">
				<spring:message code='con.cfrc.nm'/>
			</th>
			<td colspan="6">
				<input type="text" name="cfrcNm" id="cfrcNm" class="input_type required"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code="con.sctf.cfrc.ancm.clct.ppr.nm"/></th>
			<td colspan="3">
				<input type="text" name="scjnlNm" id="scjnlNm" class="input_type"/>
			</td>
			<th><spring:message code='con.ancm.plc.nm'/></th>
			<td colspan="2">
				<input type="text" name="ancmPlcNm" id="ancmPlcNm" class="input_type"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code="con.ancm.stle"/></th>
			<td>
				<select name="ancmStleCd" id="ancmStleCd" class="select_type">${rims:makeCodeList('con.ancm.stle', true, conference.ancmStleCd)}</select>
			</td>
			<th><spring:message code='con.language'/></th>
			<td>
				<select name="pprLangDvsCd" id="pprLangDvsCd" class="select_type">${rims:makeCodeList('2020', true, '')}</select>
			</td>
			<th><spring:message code='con.page'/></th>
			<td colspan="2">
				<input type="text" name="sttPage" class="input_type" id="sttPage" maxLength="10" style="width: 50px;"/>
				-&nbsp;&nbsp;<input type="text" name="endPage" class="input_type" id="endPage" maxLength="10" style="width: 50px;" />
			</td>
		</tr>
		<tr>
			<th class="essential_th">
				<spring:message code='con.title.org'/>
			</th>
			<td colspan="6">
				<div class="tbl_textarea">
					<textarea name="orgLangPprNm" maxLength="1000" rows="3" id="orgLangPprNm" class="required" ></textarea>
				</div>
			</td>
		</tr>
		<tr>
			<th><spring:message code='con.title.etc'/></th>
			<td colspan="6">
				<div class="tbl_textarea">
					<textarea name="diffLangPprNm" maxLength="1000" rows="2" id="diffLangPprNm" ></textarea>
				</div>
			</td>
		</tr>
		<tr>
			<th class="add_help ${rschEssentialTh}" rowspan="2">
				<spring:message code='con.rsrchacps'/><a href="javascript:void(0);" onclick="showTooltip($(this))" class="tbl_help_a"></a>
				<p class="th_help_box"><span><spring:message code='tooltip.art9'/></span></p>
			</th>
			<td rowspan="2">
				<div class="r_add_bt">
					<span class="add_int_del">
			        <input type="text" name="rsrchacpsStdySpheCdValue" id="rsrchacpsStdySpheCdValue" class="input_type ${rschRequiredClass}" onclick="findResArea('rsrchacpsStdySpheCd','7',$('#rsrchacpsStdySpheCdValue').val(),event);" readonly="readonly"/>
			        <input type="hidden" name="rsrchacpsStdySpheCd" id="rsrchacpsStdySpheCdKey"  class="input_type ${rschRequiredClass}" />
			        <a href="javascript:void(0);" class="tbl_int_del" onclick="clearCode($('#rsrchacpsStdySpheCdKey'),$('#rsrchacpsStdySpheCdValue'));">지우기</a>
					</span>
					<span class="r_span_box">
					<a href="javascript:void(0);" onclick="findResArea('rsrchacpsStdySpheCd','7',$('#rsrchacpsStdySpheCdValue').val(),event);" class="tbl_search_bt">검색</a>
					</span>
					<%--
					<a href="javascript:void(0);" onclick="clearCode('rsrchacpsStdySpheCd');" class="int_del">입력삭제</a>
					 --%>
		        </div>
			</td>
			<th class="add_help ${rschEssentialTh}" rowspan="2">
				<spring:message code='con.sbjt.no'/><a href="javascript:void(0);" onclick="showTooltip($(this))" class="tbl_help_a"></a>
				<p class="th_help_box"><span><spring:message code='tooltip.art10'/></span></p>
			</th>
			<td colspan="4">
				<input type="checkbox" id="relateFundingAt" name="relateFundingAt" value="N"/><spring:message code="art.relate.funding.lable" />
			</td>
		</tr>
		<tr>
			<td colspan="4" style="padding: 1px 1px;">
				<table class="in_tbl">
					<colgroup>
						<col style="width:115px;" />
						<col style="width:281px;" />
						<col style="" />
					</colgroup>
					<tbody>
						<c:set var="fundingIdx" value="1"/>
						<tr>
							<td>
								<input type="text" name="sbjtNo"  id="sbjtNo_${fundingIdx}" value="" class="input_type"  readonly="readonly" />
								<input type="hidden" name="seqNo"  id="seqNo_${fundingIdx}" value="_blank">
								<input type="hidden" name="fundIndex"  id="fundIndex_${fundingIdx}" value="${fundingIdx}">
							</td>
							<td>
								<div class="r_add_bt">
			               		  <input type="hidden" name="fundingId" id="fundingId_${fundingIdx}" value=""/>
			                	  <input type="text" name="rschSbjtNm" id="rschSbjtNm_${fundingIdx}" class="input_type" value="" onkeydown="if(event.keyCode==13){findFunding($(this),event);}"/>
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
						<script type="text/javascript">var fundingIdx = '${fundingIdx}';</script>
					</tbody>
				</table>
			</td>
		</tr>
		<tr>
			<th><spring:message code='con.authors'/></th>
			<td colspan="6">
				<div class="writer_td_inner">
				  <em class="td_left_ex">ex) Eng : Hong, Gil dong / Kor : 홍길동</em>
				  <p>
					<spring:message code="con.total.athr.cnt" />
				  	<input type="text"  name="totalAthrCnt" id="totalAthrCnt" maxlength="4" class="input_type" style="width:40px;text-align: center;" onchange="CheckValue();"/>
				  	<em>ex) 17</em>
				  </p>
				</div>
			</td>
		</tr>
		<tr>
			<td colspan="7" class="inner_tbl_td">
				<table class="inner_tbl move_tbl" id="prtcpntTbl" style="height: 50px;">
					<thead>
					  <tr>
						<th colspan="2" style="width: 50px;"><spring:message code='con.order'/></th>
						<th style="width: 100px;" class="essential_th"><spring:message code='con.abbr.nm'/></th>
						<th style="width: 100px;"><spring:message code='con.full.nm'/></th>
						<th style="width: 80px;"><spring:message code='con.tpi.dvs.cd'/></th>
						<th style="width: 160px;"><spring:message code='con.user.id'/></th>
						<th style="width: 110px;"><spring:message code='con.author.posi'/></th>
						<th style="width: 150px;"><spring:message code='con.blng.agc.nm'/></th>
						<th style="width: 100px;"><spring:message code='con.author.dept'/></th>
						<th style="width: 60px;"></th>
					  </tr>
					</thead>
					<tbody id="prtcpntTbody">
						<c:set var="prtcpntIdx" value="1"/>
				 		<tr>
				 			<td style="width:10px;text-align: left;"><img src="<c:url value='/images/icon/dragpoint.png' />" /></td>
 					  		<td style="width:40px;text-align: center;">
 					  			<input type="hidden" name="prtcpntIndex" id="prtcpntIndex_${prtcpntIdx}" value="${prtcpntIdx}"/>
 					  			<span id="order_${prtcpntIdx}">${prtcpntIdx}</span>
 					  		</td>
 					  		<td style="width:100px;">
				                <input type="text"  name="prtcpntNm" maxLength="30" id="prtcpntNm_${prtcpntIdx}" value="${prtcpntNm}" class="input_type required" placeholder="예)Hong, GD" onkeydown="if(event.keyCode==13){findUser($(this),event);}"/>
				                <input type="hidden" name="pcnRschrRegNo" id="pcnRschrRegNo_${prtcpntIdx}" value="${pcnRschrRegNo}"/>
				                <input type="hidden" name="seqAuthor" id="seqAuthor_${prtcpntIdx}" />
 					  		</td>
 					  		<td style="width:100px">
 					  		    <input type="text" name="prtcpntFullNm" maxLength="100" id="prtcpntFullNm_${prtcpntIdx}" value="${prtcpntFullNm}" class="input_type" placeholder="예)Hong, Gil Dong" onkeydown="if(event.keyCode==13){findUser($(this),event);}"/>
 					  		</td>
 					  		<td style="width:80px;">
 					  		   <select name="tpiDvsCd" id="tpiDvsCd_${prtcpntIdx}" class="select_type">${rims:makeCodeList('1180', true, '4') }</select>
 					  		</td>
 					  		<td style="width:160px">
 					  		   <span class="ck_bt_box">
 					  			<input type="text" name="prtcpntId" style="width: 80px;" id="prtcpntId_${prtcpntIdx}" value="${prtpntId}" class="input_type"/>
 					  		   	<span class="ck_r_bt">
									<a href="javascript:void(0);" class="tbl_icon_a tbl_search_icon" onclick="findUser($(this),event);">검색</a>
									<a href="javascript:void(0);" class="tbl_icon_a tbl_trash_icon" onclick="clearPrtcpnt($(this));">지우기</a>
 					  		   	</span>
 					  		   </span>
							   <input type="hidden" name="isRecord"  id="isRecord_${prtcpntIdx}"/>
		                	   <input type="hidden" name="recordStatus" id="recordStatus_${prtcpntIdx}" />
 					  		</td>
							<td style="width: 110px;">
								<select name="posiCd" id="posiCd_${idx.count}" class="select_type">${rims:makeCodeList('prtcpnt.position', true, posiCd)}</select>
								<input type="hidden" name="posiNm" id="posiNm_${idx.count}" value="_blank"/>
							</td>
 					  		<td style="width:160px">
 					  		  <div class="r_add_bt">
		               		  <input type="hidden" name="blngAgcCd" id="blngAgcCd_${prtcpntIdx}" value="${blngAgcCd}"/>
		                	  <input type="text" name="blngAgcNm" id="blngAgcNm_${prtcpntIdx}" value="${blngAgcNm}" class="input_type" onkeydown="if(event.keyCode==13){getCodeOrgWin($(this),event);}"/>
							  <span class="r_span_box">
								<a href="javascript:void(0);" class="tbl_icon_a tbl_search_icon" onclick="getCodeOrgWin($(this),event);">검색</a>
							  </span>
							  </div>
			                  <input type="hidden" name="tpiRate" value="_blank"/>
			                  <input type="hidden" name="dgrDvsCd" value="_blank"/>
 					  		</td>
 					  		<td style="width:100px" class="dispDept">${deptKor}</td>
 					  		<td style="width:60px">
								<a href="javascript:void(0);" class="tbl_icon_a row_add_bt" onclick="addPrtcpnt($(this),'${sessionScope.auth.adminDvsCd}')"><spring:message code='common.add'/></a>
								<a href="javascript:void(0);" class="tbl_icon_a red_del" onclick="removePrtcpnt($(this));"><spring:message code='common.row.delete'/></a>
 					  		</td>
				 		</tr>
				 		<c:set var="prtcpntIdx" value="${prtcpntIdx}"/>
						<script type="text/javascript">var prtcpntIdx = '${prtcpntIdx}';</script>
					</tbody>
				</table>
			</td>
		</tr>
		<tr>
			<th><spring:message code='con.abstract'/></th>
			<td colspan="6">
				<div class="tbl_textarea">
					<textarea name="abstCntn" id="abstCntn" rows="5" maxLength="4000" ></textarea>
				</div>
			</td>
		</tr>
		<tr>
			<th><spring:message code='con.file.open.at'/></th>
			<td>
				<input type="radio" name="isOpen" value="Y" checked="checked" />&nbsp;<spring:message code='file.ir.open.y'/>&nbsp;&nbsp;
				<input type="radio" name="isOpen" value="N" />&nbsp;<spring:message code='file.ir.open.n'/>
			</td>
			<th><spring:message code='con.org.file'/></th>
			<td colspan="4">
				<div class="fileupload_box">
				<c:set var="fIdx" value="1"/>
				<ul>
				  <li>
					<span class="upload_int">
						<input type="text" class="up_input" id="fileInput${fIdx}" onclick="$('#file${fIdx}').trigger('click');" readonly="readonly"/>
						<a href="javascript:void(0);" class="upload_int_bt" onclick="$('#file${fIdx}').trigger('click');"><spring:message code='common.file.select'/></a>
						<input type="file"  class="typeFile" style="display: none;" name="file"  id="file${fIdx}" onchange="$('#fileInput${fIdx}').val($(this).val().split('\\').pop());"/>
					</span>
				 	<p class="up_right_p">
				 	<a href="javascript:void(0);" class="tbl_icon_a row_add_bt" onclick="addFile($(this));">줄추가</a><a href="javascript:void(0);" class="tbl_icon_a red_del" onclick="removeFile($(this));">줄삭제</a>
				 	</p>
				  </li>
				 </ul>
				 <script type="text/javascript">var fileIdx = '${fIdx}';</script>
				</div>
			</td>
		</tr>
		<tr>
			<th class="add_help">
				WOS ID<a href="javascript:void(0);" onclick="showTooltip($(this))" class="tbl_help_a"></a>
				<p class="th_help_box"><span><spring:message code='tooltip.art14'/></span></p>
			</th>
			<td>
				<div class="r_add_bt">
					<input type="text" name="idSci" id="idSci" class="input_type" <c:if test="${sessionScope.auth.adminDvsCd ne 'M' }">disabled="disabled"</c:if>/>
					<input type="hidden" name="orgIdSci">
					<span class="r_span_box"><a href="javascript:void(0);" class="tbl_icon_a tbl_link_n_icon">링크</a></span>
				</div>
			</td>
			<th class="add_help">
				SCOPUS ID<a href="javascript:void(0);" onclick="showTooltip($(this))" class="tbl_help_a"></a>
				<p class="th_help_box"><span><spring:message code='tooltip.art15'/></span></p>
			</th>
			<td>
				<div class="r_add_bt">
					<input type="text" name="idScopus" id="idScopus" class="input_type" <c:if test="${sessionScope.auth.adminDvsCd ne 'M' }">disabled="disabled"</c:if>/>
					<span class="r_span_box"><a href="javascript:void(0);" class="tbl_icon_a tbl_link_n_icon">링크</a></span>
					<input type="hidden" name="orgIdScopus">
				</div>
			</td>
			<th>KCI ID</th>
			<td colspan="2">
				<div class="r_add_bt">
					<input type="text" name="idKci" id="idKci" class="input_type" <c:if test="${sessionScope.auth.adminDvsCd ne 'M' }">disabled="disabled"</c:if>/>
					<span class="r_span_box"><a href="javascript:void(0);" class="tbl_icon_a tbl_link_n_icon">링크</a></span>
					<input type="hidden" name="orgIdKci">
				</div>
			</td>
		</tr>
		<tr>
			<th>DOI</th>
			<td colspan="4">
				<div class="r_add_bt">
					http://dx.doi.org/<input type="text" name="doi" id="doi" class="input_type" style="width: 508.6px;"/>
					<span class="r_span_box"><a href="javascript:void(0);" class="tbl_icon_a tbl_link_n_icon">링크</a></span>
				</div>
			</td>
			<td></td>
			<td></td>
		</tr>
		<tr>
			<th>URL</th>
			<td colspan="4">
				<div class="r_add_bt">
					<input type="text" name="url" id="url" class="input_type"/>
					<span class="r_span_box"><a href="javascript:void(0);" class="tbl_icon_a tbl_link_n_icon">링크</a></span>
				</div>
			</td>
			<td></td>
			<td></td>
		</tr>
		<tr>
			<th><spring:message code='con.author.keyword'/></th>
			<td colspan="6">
				<input type="text"  id="authorKeyword" name="authorKeyword" class="input_type" maxlength="1000" value=""/>
			</td>
		</tr>
		<c:if test="${sessionScope.auth.adminDvsCd eq 'M' or  sessionScope.auth.adminDvsCd eq 'P' }">
			<tr>
				<th>
					<spring:message code='con.rtrn'/><br/>
				</th>
				<td colspan="6">
					<div class="tbl_textarea">
						<textarea maxLength="4000" rows="2" id="appr_rtrn_cncl_rsn_cntn" name="apprRtrnCnclRsnCntn"></textarea>
					</div>
				</td>
			</tr>
			<tr>
				<th><spring:message code='con.appr.dvs'/></th>
				<td colspan="2">
					<select id="apprDvsCdValue" name="apprDvsCd"  class="select_type" style="width: 100px;">${rims:makeCodeList('1400', true, '') }</select>
					<input type="hidden" id="is_open_files" name="isOpenFiles"/>
				</td>
				<th><spring:message code='con.appr.dvs.date'/></th>
				<td colspan="3">
					<fmt:formatDate var="apprDate" value="${conference.apprDate}" pattern="yyyy-MM-dd" />${apprDate}
				</td>
			</tr>
		</c:if>
	</tbody>
  </table>
</form>
<script type="text/javascript">
$(document).ready(function(){
	  $('input, select, textarea').change(function(){ isChange = true; });
	  $('input:checkbox, input:radio').click(function(){ isChange = true; });
	  $("#prtcpntTbl tbody").sortable({
		  placeholder: "ui-state-highlight",
		  deactivate: function(event, ui){
			  $('span[id^="order_"]').each(function(i, obj){ $(obj).text(i+1); });
			  isChange = true;
		  }
	  });
	  //$("#prtcpntTbl tbody").disableSelection();
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

function onClickTaget(rdo){
	  if(rdo.val() == 'doi' || rdo.val() == 'crossref')
	  {
	    $('#srchPblcYear').prop('disabled', true);
	    $('#titleSpan').css('display','none');
	    $('#titleLable').css('display','none');
	    $('#scopusLable').css('display','none');
	    $('#doiSpan').css('display','');
	    $('#doiLable').css('display','');
	  }
	  else
	  {
	    if(rdo.val() == 'scopus')
	    {
		  $('#scopusLable').css('display','');
		  $('#titleLable').css('display','none');
	    }
	    else
	    {
		  $('#scopusLable').css('display','none');
		  $('#titleLable').css('display','');
	    }

	    $('#srchPblcYear').prop('disabled', false);
	    $('#titleSpan').css('display','');
	    $('#doiSpan').css('display','none');
	    $('#doiLable').css('display','none');
	  }
}

</script>