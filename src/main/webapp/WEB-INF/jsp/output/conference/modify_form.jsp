<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../pageInit.jsp" %>
 <c:set var="rschRequiredClass" value=""/><c:set var="rschEssentialTh" value=""/>
 	<c:if test="${sessionScope.auth.adminDvsCd eq 'R' or sessionScope.auth.adminDvsCd eq 'S'}">
	<c:set var="rschRequiredClass" value="required"/><c:set var="rschEssentialTh" value="essential_th"/>
 </c:if>
<form id="formArea" action="<c:url value="/${preUrl}/conference/modifyConference.do"/>" method="post" enctype="multipart/form-data" >
	<input type="hidden" name="conferenceId" id="conferenceId" value="${conference.conferenceId}"/>
	<input type="hidden" id="listUrl" name="listUrl" value="<c:url value="/conference/findConferenceList.do"/>"/>
	<input type="hidden" name="deleteUser" value="N" />
	<input type="hidden" name="relisUser" value="N" />
	<c:if test="${sessionScope.auth.adminDvsCd ne 'M' and sessionScope.auth.adminDvsCd ne 'P' }">
		<input type="hidden" name="cntcSystemInfoOthbcYn" value="<c:out value="${conference.cntcSystemInfoOthbcYn}"/>" />
	</c:if>
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
				<spring:message code="common.radio.yes"/> <input type="radio" name="isReprsntConference" value="Y" ${not empty conference.isReprsntConference and conference.isReprsntConference eq 'Y' ? 'checked="checked"' : '' }/>
				&nbsp;&nbsp;&nbsp;<spring:message code="common.radio.no"/> <input type="radio" name="isReprsntConference" value="N" ${empty conference.isReprsntConference or conference.isReprsntConference eq 'N' ? 'checked="checked"' : '' }/>
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
					<option value="1" ${conference.scjnlDvsCd eq '1' ? 'selected="selected"' : ''}><spring:message code='con.domestic'/></option>
					<option value="2" ${conference.scjnlDvsCd eq '2' ? 'selected="selected"' : ''}><spring:message code='con.international'/></option>
				</select>
			</td>
			<th class="essential_th">
				<spring:message code='con.cfrc.hctr.cd'/>
			</th>
			<td>
				<select name="pblcNtnCd" id="pblcNtnCd" class="select_type required">
		          	${rims:makeCodeList('2000', true, conference.pblcNtnCd) }
		        </select>
		    <script type="text/javascript">$(document).ready(function(){ $('#pblcNtnCd > option').eq(9).after($('<option value="">====================</option>')); });</script>
			</td>
			<th>ISSN</th>
			<td colspan="2">
				<input type="text" name="issnNo"  maxLength="9" id="issnNo" class="input_type" value="<c:out value="${conference.issnNo}"/>"/>
			</td>
		</tr>
		<tr>
			<th class="essential_th"><spring:message code='con.hld.date'/></th>
			<td colspan="3">
				<input type="text" name="hldSttYear" id="hldSttYear" class="input_type required" style="width: 40px;" maxLength="4" value="<c:out value="${conference.hldSttYear}"/>" /><spring:message code='common.year'/>&nbsp;
				<input type="text" name="hldSttMonth" id="hldSttMonth" class="input_type" style="width: 25px;" maxLength="2" value="<c:out value="${conference.hldSttMonth}"/>"/><spring:message code='common.month'/>&nbsp;
				<input type="text" name="hldSttDay" id="hldSttDay" class="input_type" style="width: 25px;" maxLength="2" value="<c:out value="${conference.hldSttDay}"/>" /><spring:message code='common.day'/>&nbsp;
				~
				<input type="text" name="hldEndYear" id="hldEndYear" class="input_type required" style="width: 40px;" maxLength="4" value="<c:out value="${conference.hldEndYear}"/>" /><spring:message code='common.year'/>&nbsp;
				<input type="text" name="hldEndMonth" id="hldEndMonth" class="input_type" style="width: 25px;" maxLength="2" value="<c:out value="${conference.hldEndMonth}"/>"/><spring:message code='common.month'/>&nbsp;
				<input type="text" name="hldEndDay" id="hldEndDay" class="input_type" style="width: 25px;" maxLength="2" value="<c:out value="${conference.hldEndDay}"/>" /><spring:message code='common.day'/>&nbsp;
			</td>
			<th class="essential_th">
				<spring:message code='con.ancm.date'/>
			</th>
			<td colspan="2">
				<input type="text" name="ancmYear" id="ancmYear" class="input_type required" style="width: 39px;" maxLength="4" value="<c:out value="${conference.ancmYear}"/>" /><spring:message code='common.year'/>&nbsp;
				<input type="text" name="ancmMonth" id="ancmMonth" class="input_type required" style="width: 24px;" maxLength="2" value="<c:out value="${conference.ancmMonth}"/>"/><spring:message code='common.month'/>&nbsp;
				<input type="text" name="ancmDay" id="ancmDay" class="input_type" style="width: 24px;" maxLength="2" value="<c:out value="${conference.ancmDay}"/>" /><spring:message code='common.day'/>&nbsp;

			</td>
		</tr>
		<tr>
			<th class="essential_th">
				<spring:message code='con.hld.agc.nm'/>
			</th>
			<td colspan="6">
				<input type="text" name="pblcPlcNm" id="pblcPlcNm" class="input_type required" value="<c:out value="${conference.pblcPlcNm}"/>" />
			</td>
		</tr>
		<c:if test="${sessionScope.auth.adminDvsCd eq 'M' or sessionScope.auth.adminDvsCd eq 'P' or sessionScope.sess_user.deptCode eq '2783'  or sessionScope.sess_user.deptCode eq '2785' }">
		<tr>
			<th><spring:message code='con.cfrc.nm'/>(BK)</th>
			<td colspan="4">
				<div class="r_add_bt">
				  <span class="add_int_del">
	               	 <input type="text" name="schlshpCnfrncNm" id="schlshpCnfrncNm" class="input_type" value="<c:out value="${conference.schlshpCnfrncNm}"/>"  <c:if test="${not empty conference.schlshpCnfrncNm }">readonly="readonly"</c:if>/>
					 <a href="javascript:void(0);" class="tbl_int_del" onclick="clearBkData();">지우기</a>
				  </span>
				  <span class="r_span_box">
					<a href="javascript:void(0);" class="tbl_icon_a tbl_search_icon" onclick="findConferenceMaster($(this));">검색</a>
				  </span>
				</div>
			</td>
			<th><spring:message code="con.regarded.if"/></th>
			<td>
				<input type="hidden" name="schlshpCnfrncCode" id="schlshpCnfrncCode" class="input_type" value="<c:out value="${conference.schlshpCnfrncCode}"/>">
				<input type="text" name="impctFctr" id="impctFctr" class="input_type" value="<c:out value="${conference.impctFctr}"/>" readonly="readonly"/>
			</td>
		</tr>
		</c:if>
		<tr>
			<th class="essential_th">
				<spring:message code='con.cfrc.nm'/>
			</th>
			<td colspan="6">
				<input type="text" name="cfrcNm" id="cfrcNm" class="input_type required" value="<c:out value="${conference.cfrcNm}"/>"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code="con.sctf.cfrc.ancm.clct.ppr.nm"/></th>
			<td colspan="3">
				<input type="text" name="scjnlNm" id="scjnlNm" class="input_type" value="<c:out value="${conference.scjnlNm}"/>"/>
			</td>
			<th><spring:message code='con.ancm.plc.nm'/></th>
			<td colspan="2">
				<input type="text" name="ancmPlcNm" id="ancmPlcNm" class="input_type" value="<c:out value="${conference.ancmPlcNm}"/>"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code="con.ancm.stle"/></th>
			<td>
				<select name="ancmStleCd" id="ancmStleCd" class="select_type">${rims:makeCodeList('con.ancm.stle', true, conference.ancmStleCd)}</select>
			</td>
			<th><spring:message code='con.language'/></th>
			<td>
				<select name="pprLangDvsCd" id="pprLangDvsCd" class="select_type">${rims:makeCodeList('2020', true, conference.pprLangDvsCd)}</select>
			</td>
			<th>
				<spring:message code='con.page'/>
			</th>
			<td colspan="2">
				<input type="text" name="sttPage" class="input_type" id="sttPage" maxLength="10" value="<c:out value="${conference.sttPage}"/>" style="width: 50px;"/>
				-&nbsp;&nbsp;<input type="text" name="endPage" class="input_type" id="endPage" maxLength="10" value="<c:out value="${conference.endPage}"/>" style="width: 50px;" />
			</td>
		</tr>
		<tr>
			<th class="essential_th">
				<spring:message code='con.title.org'/>
			</th>
			<td colspan="6">
				<div class="tbl_textarea">
					<textarea name="orgLangPprNm" maxLength="1000" rows="3" id="orgLangPprNm" class="required" ><c:out value="${conference.orgLangPprNm}"/></textarea>
				</div>
			</td>
		</tr>
		<tr>
			<th>
				<spring:message code='con.title.etc'/>
			</th>
			<td colspan="6">
				<div class="tbl_textarea">
					<textarea name="diffLangPprNm" maxLength="1000" rows="2" id="diffLangPprNm" ><c:out value="${conference.diffLangPprNm}"/></textarea>
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
					<c:set var="resAreaValue" value="${pageContext.response.locale eq 'en' ? conference.rsrchacpsStdySpheEngValue : conference.rsrchacpsStdySpheValue }" />
			        <input type="text" name="rsrchacpsStdySpheCdValue" id="rsrchacpsStdySpheCdValue" class="input_type ${rschRequiredClass}" value="<c:out value="${resAreaValue}"/>" onclick="findResArea('rsrchacpsStdySpheCd','7',$('#rsrchacpsStdySpheCdValue').val(),event);" readonly="readonly"/>
			        <input type="hidden" name="rsrchacpsStdySpheCd" id="rsrchacpsStdySpheCdKey"  class="input_type ${rschRequiredClass}" value="<c:out value="${conference.rsrchacpsStdySpheCd}"/>"/>
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
				<input type="checkbox" id="relateFundingAt" name="relateFundingAt" value="N" ${conference.relateFundingAt eq 'N' ? 'checked="checked"' : '' }/><spring:message code="art.relate.funding.lable" />
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
						<c:set var="fundingIdx" value="0"/>
						<c:forEach items="${conference.fundingMapngList}" var="fml" varStatus="idx">
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
			<th><spring:message code='con.authors'/></th>
			<td colspan="6">
				<div class="writer_td_inner">
				  <em class="td_left_ex">ex) Eng : Hong, Gil dong / Kor : 홍길동</em>
				  <p>
					<spring:message code="con.total.athr.cnt" />
				  	<input type="text"  name="totalAthrCnt" id="totalAthrCnt" maxlength="4" class="input_type" style="width:40px;text-align: center;" onchange="CheckValue();" value="<c:out value="${conference.totalAthrCnt}"/>"/>
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
					<tbody>
						 <c:set var="prtcpntIdx" value="1"/>
						 <c:if test="${not empty conference.partiList}">
						 	<c:forEach items="${conference.partiList}" var="pl" varStatus="idx">
						 		<tr <c:if test="${sessionScope.sess_user.userId eq pl.prtcpntId}">style="background-color: #FFCC66;"</c:if>>
				                   <td style="width:10px;text-align: left;"><img src="<c:url value='/images/icon/dragpoint.png' />" /></td>
		 					  		<td style="width:40px;text-align: center;">
		 					  			<input type="hidden" name="prtcpntIndex" id="prtcpntIndex_${idx.count}" value="${idx.count}"/>
		 					  			<span id="order_${idx.count}">${idx.count}</span>
		 					  		</td>
		 					  		<td style="width:100px;">
						                <input type="text"  name="prtcpntNm" maxLength="30" id="prtcpntNm_${idx.count}" class="input_type required" placeholder="예)Hong, GD" value="<c:out value="${pl.prtcpntNm}"/>" onkeydown="if(event.keyCode==13){findUser($(this),event);}"/>
						                <input type="hidden" name="pcnRschrRegNo" id="pcnRschrRegNo_${idx.count}" value="<c:out value="${pl.pcnRschrRegNo}"/>"/>
						                <input type="hidden" name="seqAuthor" id="seqAuthor_${idx.count}" value="${pl.seqAuthor}"/>
		 					  		</td>
		 					  		<td style="width:100px">
		 					  		    <input type="text" name="prtcpntFullNm" maxLength="100" id="prtcpntFullNm_${idx.count}" class="input_type" placeholder="예)Hong, Gil Dong" value="<c:out value="${pl.prtcpntFullNm}"/>" onkeydown="if(event.keyCode==13){findUser($(this),event);}"/>
		 					  		</td>
		 					  		<td style="width:80px;">
		 					  		   <select name="tpiDvsCd" id="tpiDvsCd_${idx.count}" class="select_type">${rims:makeCodeList('1180', true, pl.tpiDvsCd) }</select>
		 					  		</td>
		 					  		<td style="width:160px">
		 					  		   <span class="dk_bt_box">
		 					  			<input type="text" name="prtcpntId" style="width: 80px;" id="prtcpntId_${idx.count}" value="<c:out value="${pl.prtcpntId}"/>" class="input_type" />
		 					  		   	<span class="dk_r_bt">
											<a href="javascript:void(0);" class="tbl_icon_a tbl_search_icon" onclick="findUser($(this),event);">검색</a>
											<a href="javascript:void(0);" class="tbl_icon_a tbl_trash_icon" onclick="clearPrtcpnt($(this));">지우기</a>
		 					  		   	</span>
		 					  		   </span>
									   <input type="hidden" name="isRecord"  id="isRecord_${idx.count}"  value="<c:out value="${pl.isRecord}"/>" />
				                	   <input type="hidden" name="recordStatus" id="recordStatus_${idx.count}" value="<c:out value="${pl.recordStatus}"/>"  />
		 					  		</td>
									<td style="width:110px;">
										<select name="posiCd" id="posiCd_${idx.count}" class="select_type">${rims:makeCodeList('prtcpnt.position', true, pl.posiCd)}</select>
										<input type="hidden" name="posiNm" id="posiNm_${idx.count}" value="<c:out value="${empty pl.posiNm ? '_blank' : pl.posiNm}"/>"/>
									</td>
		 					  		<td style="width:160px">
		 					  		  <div class="r_add_bt">
				               		  <input type="hidden" name="blngAgcCd" id="blngAgcCd_${idx.count}" value="<c:out value="${pl.blngAgcCd}"/>"/>
				                	  <input type="text" name="blngAgcNm" id="blngAgcNm_${idx.count}" class="input_type" style="<c:if test="${not empty pl.blngAgcNm and empty pl.blngAgcCd }">background-color: #fef3d7;</c:if>" value="<c:out value="${pl.blngAgcNm}"/>" onkeydown="if(event.keyCode==13){getCodeOrgWin($(this),event);}"/>
									  <span class="r_span_box">
										<a href="javascript:void(0);" class="tbl_icon_a tbl_search_icon" onclick="getCodeOrgWin($(this),event);">검색</a>
									  </span>
									  </div>
					                  <input type="hidden" name="tpiRate" value="<c:out value="${empty pl.tpiRate ? '_blank' : pl.tpiRate}"/>"/>
					                  <input type="hidden" name="dgrDvsCd" value="<c:out value="${empty pl.dgrDvsCd ? '_blank' : pl.dgrDvsCd}"/>"/>
		 					  		</td>
		 					  		<td style="width:100px" class="dispDept">
		 					  			<c:if test="${not empty pl.blngAgcNm and pl.blngAgcNm eq instName}"><c:out value="${pl.deptKor}"/></c:if>
		 					  		</td>
		 					  		<td style="width:60px">
										<a href="javascript:void(0);" class="tbl_icon_a row_add_bt" onclick="addPrtcpnt($(this),'${sessionScope.login_user.adminDvsCd}')"><spring:message code='common.add'/></a>
										<a href="javascript:void(0);" class="tbl_icon_a red_del" onclick="removePrtcpnt($(this));"><spring:message code='common.row.delete'/></a>
		 					  		</td>
						 		</tr>
						 		<c:set var="prtcpntIdx" value="${idx.count}"/>
						 	</c:forEach>
						 </c:if>
						  <script type="text/javascript">var prtcpntIdx = '${prtcpntIdx}';</script>
					</tbody>
				</table>
			</td>
		</tr>
		<tr>
			<th>
				<spring:message code='con.abstract'/>
			</th>
			<td colspan="6">
				<div class="tbl_textarea">
					<textarea name="abstCntn" id="abstCntn" rows="5" maxLength="4000" ><c:out value="${conference.abstCntn}"/></textarea>
				</div>
			</td>
		</tr>
		<tr>
			<th><spring:message code='con.file.open.at'/></th>
			<td>
				<input type="radio" name="isOpen" value="Y" <c:if test="${empty conference.isOpen and conference.isOpen eq 'Y' }">checked="checked"</c:if>/>&nbsp;<spring:message code='file.ir.open.y'/>&nbsp;&nbsp;
				<input type="radio" name="isOpen" value="N" <c:if test="${not empty conference.isOpen or conference.isOpen eq 'N' }">checked="checked"</c:if>/>&nbsp;<spring:message code='file.ir.open.n'/>
			</td>
			<th><spring:message code='con.org.file'/></th>
			<td colspan="4">
				<div class="fileupload_box">
				<c:set var="fIdx" value="0"/>
				<c:forEach items="${conference.fileList}" var="fd" varStatus="idx">
					<p class="upload_file_text">
						<a href="<c:url value="/servlet/download.do?fileid=${fd.fileId}"/>"><c:out value="${fd.fileNm}"/></a>&nbsp;&nbsp;
						<a href="javascript:void(0);" onclick="removeFileItem($(this));" class="del_file">삭제</a>
						<input type="hidden" name="fileId" value="${fd.fileId}"/>
					</p>
					<c:set var="fIdx" value="${idx.count + 1}"/>
				</c:forEach>
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
		<tr> <!--  논문 외부정보원 ID -->
			<th class="add_help">
				WOS ID<a href="javascript:void(0);" onclick="showTooltip($(this))" class="tbl_help_a"></a>
				<p class="th_help_box"><span><spring:message code='tooltip.art14'/></span></p>
			</th>
			<td>
				<div class="r_add_bt">
					<input type="text" name="idSci" id="idSci" class="input_type" value="<c:out value="${conference.idSci}"/>"/><br>
					<span class="r_span_box">
					<c:if test="${empty conference.idSci}">
						<a href="javascript:void(0);" class="tbl_icon_a tbl_link_n_icon">링크</a>
					</c:if>
					<c:if test="${not empty conference.idSci}">
						<a href="<c:out value="${conference.wosSourceUrl}"/>" target="_blank" class="tbl_icon_a tbl_link_icon">링크</a>
					</c:if>
				</span>
				</div>
			</td>
			<th class="add_help">
				SCOPUS ID<a href="javascript:void(0);" onclick="showTooltip($(this))" class="tbl_help_a"></a>
				<p class="th_help_box"><span><spring:message code='tooltip.art15'/></span></p>
			</th>
			<td>
				<div class="r_add_bt">
					<input type="text" name="idScopus" id="idScopus" class="input_type" value="<c:out value="${conference.idScopus}"/>"/>
					<span class="r_span_box">
					<c:if test="${empty conference.idScopus}">
						<a href="javascript:void(0);" class="tbl_icon_a tbl_link_n_icon">링크</a>
					</c:if>
					<c:if test="${not empty conference.idScopus}">
						<a href="${sysConf['scopus.search.view.url']}&origin=inward&scp=<c:out value="${fn:replace(conference.idScopus,'2-s2.0-','')}"/>" class="tbl_icon_a tbl_link_icon" target="_blank">링크</a>
					</c:if>
				</span>
					<input type="hidden" name="orgIdScopus" value="<c:out value="${conference.idScopus}"/>">
				</div>
			</td>
			<th>KCI ID</th>
			<td colspan="2">
				<div class="r_add_bt">
					<input type="text" name="idKci" id="idKci" class="input_type" value="<c:out value="${conference.idKci}"/>"/>
					<span class="r_span_box">
					<c:if test="${empty conference.idKci}">
						<a href="javascript:void(0);" class="tbl_icon_a tbl_link_n_icon">링크</a>
					</c:if>
					<c:if test="${not empty conference.idKci}">
						<a href="${sysConf['kci.search.view.url']}?sereArticleSearchBean.artiId=<c:out value="${conference.idKci}"/>" class="tbl_icon_a tbl_link_icon" target="_blank">링크</a>
					</c:if>
				</span>
					<input type="hidden" name="orgIdKci" value="<c:out value="${conference.idKci}"/>">
				</div>
			</td>
		</tr>
		<tr>
			<th>DOI</th>
			<td colspan="4">
				<div class="r_add_bt">
					http://dx.doi.org/<input type="text" name="doi" id="doi" class="input_type" style="width: 508.6px;" value="<c:out value="${conference.doi}"/>" />
					<span class="r_span_box">
						<c:if test="${empty conference.doi}">
							<a href="javascript:void(0);" class="tbl_icon_a tbl_link_n_icon">링크</a>
						</c:if>
						<c:if test="${not empty conference.doi}">
							<a href="http://dx.doi.org/<c:out value="${conference.doi}"/>" class="tbl_icon_a tbl_link_icon" target="_blank">링크</a>
						</c:if>
					</span>
				</div>
			</td>
			<td></td>
			<td></td>
		</tr>
		<tr>
			<th>URL</th>
			<td colspan="4">
				<div class="r_add_bt">
					<input type="text" name="url" id="url" class="input_type" value="<c:out value="${conference.url}"/>" />
					<span class="r_span_box">
						<c:if test="${empty conference.url}">
							<a href="javascript:void(0);" class="tbl_icon_a tbl_link_n_icon">링크</a>
						</c:if>
						<c:if test="${not empty conference.url}">
							<a href="<c:out value="${conference.url}"/>" class="tbl_icon_a tbl_link_icon" target="_blank">링크</a>
						</c:if>
					</span>
				</div>
			</td>
			<td></td>
			<td></td>
		</tr>
		<tr>
			<th><spring:message code='con.author.keyword'/></th>
			<td colspan="6">
				<input type="text"  id="authorKeyword" name="authorKeyword" class="input_type" maxlength="1000" value="<c:out value="${conference.authorKeyword}"/>"/>
			</td>
		</tr>
		<c:if test="${sessionScope.auth.adminDvsCd eq 'M' or  sessionScope.auth.adminDvsCd eq 'P' }">
			<tr>
				<th><spring:message code="con.cntcSystem.info.open.yn"/></th>
				<td>
					<spring:message code="common.radio.yes"/> <input type="radio" name="cntcSystemInfoOthbcYn" value="Y" ${empty conference.cntcSystemInfoOthbcYn or conference.cntcSystemInfoOthbcYn eq 'Y' ? 'checked="checked"' : '' }/>
					&nbsp;&nbsp;&nbsp;<spring:message code="common.radio.no"/> <input type="radio" name="cntcSystemInfoOthbcYn" value="N" ${not empty conference.cntcSystemInfoOthbcYn and conference.cntcSystemInfoOthbcYn eq 'N' ? 'checked="checked"' : '' }/>
				</td>
				<td colspan="2"></td>
				<th rowspan="2">
					<spring:message code='con.rtrn'/><br/>
				</th>
				<td rowspan="2" colspan="2">
					<div class="tbl_textarea">
						<textarea maxLength="4000" rows="4" id="appr_rtrn_cncl_rsn_cntn" name="apprRtrnCnclRsnCntn"><c:out value="${conference.apprRtrnCnclRsnCntn}"/></textarea>
					</div>
				</td>
			</tr>
			<tr>
				<th><spring:message code='con.appr.dvs'/></th>
				<td>
					<select id="apprDvsCdValue" name="apprDvsCd"  class="select_type" style="width: 100px;">${rims:makeCodeList('1400', true, conference.apprDvsCd) }</select>
				</td>
				<th><spring:message code='con.appr.dvs.date'/></th>
				<td>
					<fmt:formatDate var="apprDate" value="${conference.apprDate}" pattern="yyyy-MM-dd" /><c:out value="${apprDate}"/>
				</td>
			</tr>
		</c:if>
		<c:if test="${sessionScope.login_user.adminDvsCd ne 'M' and sessionScope.login_user.adminDvsCd ne 'P'}">
			<tr>
				<th><spring:message code='art.appr.dvs'/></th>
				<td>
					${rims:codeValue('1400',conference.apprDvsCd)}
					<input type="hidden" name="apprDvsCd" value="<c:out value="${empty conference.apprDvsCd ? '1' : conference.apprDvsCd}"/>"/>
				</td>
				<th><spring:message code='con.appr.dvs.date'/></th>
				<td>
					<fmt:formatDate var="apprDate" value="${conference.apprDate}" pattern="yyyy-MM-dd" /><c:out value="${apprDate}"/>
				</td>
				<th><spring:message code='con.rtrn'/></th>
				<td colspan="2">
					<c:out value="${conference.apprRtrnCnclRsnCntn}"/>
					<input type="hidden" name="apprRtrnCnclRsnCntn" value="<c:out value="${conference.apprRtrnCnclRsnCntn}"/>" />
				</td>
			</tr>
		</c:if>
		<tr>
			<th><spring:message code='common.reg.date'/></th>
			<td>
				<fmt:formatDate var="regDate" value="${conference.regDate}" pattern="yyyy-MM-dd" /> <c:out value="${regDate}"/> ( <c:out value="${empty conference.regUserNm ? 'ADMIN' : conference.regUserNm}"/> )
			</td>
			<th><spring:message code='common.mod.date'/></th>
			<td>
				<fmt:formatDate var="modDate" value="${conference.modDate}" pattern="yyyy-MM-dd" /> <c:out value="${modDate}"/> ( <c:out value="${empty conference.modUserNm ? 'ADMIN' : conference.modUserNm}"/> )
			</td>
			<td></td>
			<td colspan="2"></td>
		</tr>
	</tbody>
  </table>
</form>
<form id="removeFormArea" action="<c:url value="/conference/removeConference.do"/>" method="post">
	<input type="hidden" id="conference_id" name="conferenceId" value="${conference.conferenceId}"/>
</form>
<form id="userRemoveFormArea" action="<c:url value="/conference/userRemoveConference.do"/>" method="post">
	<input type="hidden" name="conferenceId" value="${conference.conferenceId}"/>
	<input type="hidden" name="srchUserId" value="${sessionScope.sess_user.userId}"/>
</form>
<form id="repairFormArea" action="<c:url value="/conference/repairConference.do"/>" method="post">
	<input type="hidden" id="conference_id" name="conferenceId" value="${conference.conferenceId}"/>
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








