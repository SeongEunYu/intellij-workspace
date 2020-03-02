<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.argonet.r2rims.util.LanguageUtil"%>
<%@include file="../../pageInit.jsp" %>
<c:if test="${sessMode or (sessionScope.auth.adminDvsCd eq 'R' or sessionScope.auth.adminDvsCd eq 'S' )}">
  <c:set var="prtpntId" value="${sessionScope.sess_user.userId}"/><c:set var="prtcpntNm" value="${sessionScope.sess_user.abbrLastName}, ${sessionScope.sess_user.abbrFirstName}"/>
  <c:set var="prtcpntFullNm" value="${sessionScope.sess_user.lastName}, ${sessionScope.sess_user.firstName}"/><c:set var="pcnRschrRegNo" value="${sessionScope.sess_user.rschrRegNo}"/>
  <c:set var="deptKor" value="${sessionScope.sess_user.groupDept}"/><c:set var="blngAgcCd" value="${sysConf['inst.blng.agc.code']}"/><c:set var="blngAgcNm" value="${sysConf['inst.blng.agc.name']}"/>
</c:if>
<form id="formArea" action="${contextPath}/report/addReport.do" method="post" enctype="multipart/form-data" >

  <table class="write_tbl mgb_10" >
	<colgroup>
		<col style="width:140px;" />
		<col style="width:326px;" />
		<col style="width:140px" />
		<col style="" />
	</colgroup>
	<tbody>
		<tr>
		  <th class="essential_th"><spring:message code='rprt.date'/></th>
		  <td>
			<select name="pblicteYear" id="pblicteYear" class="select_type required" onchange="changePblcYear('pblicte');" style="width: 80px;">${rims:makeYearList(2000, '', true, false)}</select>&nbsp;<spring:message code='common.year'/>&nbsp;&nbsp;
	        <select name="pblicteMonth" id="pblicteMonth" class="select_type" onchange="changePblcMonth('pblicte');" style="width: 45px;">${rims:makeMonthList('', true)}</select>&nbsp;<spring:message code='common.month'/>&nbsp;&nbsp;
		  </td>
		  <th><spring:message code='rprt.ntn.cd'/></th>
		  <td>
		  	<input type="text" name="pblicteNationNm" id="pblicteNationNm"  class="input_type" value="${report.pblicteNationNm}"/>
		  </td>
		</tr>
		<tr>
		  <th class="essential_th"><spring:message code='rprt.nm'/></th>
		  <td colspan="3">
		  	<input type="text" name="reportTitle" id="reportTitle"  class="input_type required" value="${report.reportTitle}"/>
		  </td>
		</tr>
		<tr>
			<th><spring:message code='rprt.related.projt.nm'/></th>
			<td colspan="3">
				<div class="r_add_bt">
					<input type="text" name="rschSbjtNm" id="rschSbjtNm"  class="input_type"/>
					<a href="javascript:void(0);" onclick="findReportFunding($(this),event);" class="tbl_search_bt">검색</a>
				</div>
			</td>
		</tr>
		<tr>
		  <th><spring:message code='rprt.agc.nm'/></th>
		  <td>
			 <input type="text" name="orderInsttNm" id="orderInsttNm"  class="input_type"/>
		  </td>
		  <th><spring:message code='rprt.type'/></th>
		  <td>
			 <select name="reportTypeCode" id="reportTypeCode" class="select_type" style="width: 50%;">${rims:makeCodeList('report.type',true,'')}</select>
		  </td>
		</tr>
		<tr>
			<th><spring:message code='rprt.sbjt.no'/></th>
			<td>
				<input type="text" name="sbjtNo" id="sbjtNo"  class="input_type"/>
			</td>
			<th><spring:message code='rprt.instt.sbjt.no'/></th>
			<td>
				<input type="text" name="detailSbjtNo" id="detailSbjtNo"  class="input_type"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code='rprt.this.year.stt.date'/></th>
			<td>
			  <input name="thsyrRsrchSttYear" id="thsyrRsrchSttYear" class="input_type" style="width: 80px;"/>&nbsp;<spring:message code='common.year'/>&nbsp;&nbsp;
              <input name="thsyrRsrchSttMonth" id="thsyrRsrchSttMonth" class="input_type" style="width: 45px;"/>&nbsp;<spring:message code='common.month'/>&nbsp;&nbsp;
              <input name="thsyrRsrchSttDay" id="thsyrRsrchSttDay" class="input_type" style="width: 45px;"/>&nbsp;<spring:message code='common.day'/>&nbsp;&nbsp;
			</td>
			<th><spring:message code='rprt.this.year.end.date'/></th>
			<td>
			  <input name="thsyrRsrchEndYear" id="thsyrRsrchEndYear" class="input_type" style="width: 80px;"/>&nbsp;<spring:message code='common.year'/>&nbsp;&nbsp;
              <input name="thsyrRsrchEndMonth" id="thsyrRsrchEndMonth" class="input_type" style="width: 45px;"/>&nbsp;<spring:message code='common.month'/>&nbsp;&nbsp;
              <input name="thsyrRsrchEndDay" id="thsyrRsrchEndDay" class="input_type" style="width: 45px;"/>&nbsp;<spring:message code='common.day'/>&nbsp;&nbsp;
			</td>
		</tr>
		<tr>
			<th><spring:message code='rprt.total.stt.date'/></th>
			<td>
			  <input name="totRsrchSttYear" id="totRsrchSttYear" class="input_type" style="width: 80px;"/>&nbsp;<spring:message code='common.year'/>&nbsp;&nbsp;
              <input name="totRsrchSttMonth" id="totRsrchSttMonth" class="input_type" style="width: 45px;"/>&nbsp;<spring:message code='common.month'/>&nbsp;&nbsp;
              <input name="totRsrchSttDay" id="totRsrchSttDay" class="input_type" style="width: 45px;"/>&nbsp;<spring:message code='common.day'/>&nbsp;&nbsp;
			</td>
			<th><spring:message code='rprt.total.end.date'/></th>
			<td>
			  <input name="totRsrchEndYear" id="totRsrchEndYear" class="input_type" style="width: 80px;"/>&nbsp;<spring:message code='common.year'/>&nbsp;&nbsp;
              <input name="totRsrchEndMonth" id="totRsrchEndMonth" class="input_type" style="width: 45px;"/>&nbsp;<spring:message code='common.month'/>&nbsp;&nbsp;
              <input name="totRsrchEndDay" id="totRsrchEndDay" class="input_type" style="width: 45px;"/>&nbsp;<spring:message code='common.day'/>&nbsp;&nbsp;
			</td>
		</tr>
		<tr>
			<th><spring:message code='rprt.exec.instt.nm'/></th>
			<td>
				<input type="text" name="sbjtExcInsttNm" id="sbjtExcInsttNm"  class="input_type"/>
			</td>
			<th><spring:message code='rprt.mgt.instt.nm'/></th>
			<td>
				<input type="text" name="sbjtManageInsttNm" id="sbjtManageInsttNm"  class="input_type"/>
			</td>
		</tr>
		<tr>
		  <th><spring:message code='rprt.authors'/></th>
		  <td colspan="3"></td>
		</tr>
		<tr>
			<td colspan="4" class="inner_tbl_td">
				<table class="inner_tbl move_tbl" id="prtcpntTbl" style="height: 50px;">
					<colgroup>
						<col style="width: 8%;" />
						<col style="width: 16%;" />
						<col style="width: 16%;" />
						<col style="width: 10%;" />
						<col style="width: 18%;" />
						<col />
						<col style="width: 8%;" />
					</colgroup>
					<thead>
					  <tr>
						<th><spring:message code='rprt.order'/></th>
						<th class="essential_th"><spring:message code='rprt.abbr.nm'/></th>
						<th><spring:message code='rprt.full.nm'/></th>
						<th class="essential_th"><spring:message code='rprt.tpi.dvs.cd'/></th>
						<th><spring:message code='rprt.user.id'/></th>
						<th><spring:message code='rprt.aff.nm'/></th>
						<th></th>
					  </tr>
					</thead>
					<tbody id="prtcpntTbody">
					  <c:set var="prtcpntIdx" value="1"/>
 					  	<tr <c:if test="${sessionScope.sess_user.userId eq pl.prtcpntId}">style="background-color: #FFCC66;"</c:if> >
 					  		<td style="text-align: center;">
 					  			<input type="hidden" name="prtcpntIndex" id="prtcpntIndex_${prtcpntIdx}" value="${prtcpntIdx}"/>
 					  			<span id="order_${prtcpntIdx}">${prtcpntIdx}</span>
 					  		</td>
 					  		<td>
				                <input type="text"  name="prtcpntNm" maxLength="30" id="prtcpntNm_${prtcpntIdx}" value="${prtcpntNm}" class="input_type required" onkeydown="if(event.keyCode==13){findUser($(this),event);}"/>
				                <input type="hidden" name="pcnRschrRegNo" id="pcnRschrRegNo_${prtcpntIdx}" value="${pcnRschrRegNo}"/>
				                <input type="hidden" name="seqAuthor" id="seqAuthor_${prtcpntIdx}" />
 					  		</td>
 					  		<td>
 					  		    <input type="text" name="prtcpntFullNm" maxLength="100" id="prtcpntFullNm_${prtcpntIdx}" value="${prtcpntFullNm}" class="input_type" onkeydown="if(event.keyCode==13){findUser($(this),event);}"/>
 					  		</td>
 					  		<td>
 					  		   <select name="tpiDvsCd" id="tpiDvsCd_${prtcpntIdx}" class="select_type">${rims:makeCodeList('1340', true, '') }</select>
 					  		</td>
 					  		<td>
 					  			<span class="ck_bt_box">
	 					  			<input type="text" name="prtcpntId" style="width: 80px;" id="prtcpntId_${prtcpntIdx}" value="${prtpntId}" class="input_type"/>
	 					  			<span class="ck_r_bt">
										<a href="javascript:void(0);" class="tbl_icon_a tbl_search_icon" onclick="findUser($(this),event);">검색</a>
										<a href="javascript:void(0);" class="tbl_icon_a tbl_trash_icon" onclick="clearPrtcpnt($(this));">지우기</a>
									</span>
								</span>
 					  		</td>
 					  		<td>
 					  		  <div class="r_add_bt">
		               		  <input type="hidden" name="blngAgcCd" id="blngAgcCd_${prtcpntIdx}" value="${blngAgcCd}"/>
		                	  <input type="text" name="blngAgcNm" id="blngAgcNm_${prtcpntIdx}" value="${blngAgcNm}" class="input_type" onkeydown="if(event.keyCode==13){getCodeOrgWin($(this),event);}"/>
							  <span class="r_span_box">
								<a href="javascript:void(0);" class="tbl_icon_a tbl_search_icon" onclick="getCodeOrgWin($(this),event);">검색</a>
							  </span>
							  </div>
			                  <input type="hidden" name="tpiRate" value="_blank"/>
			                  <input type="hidden" name="dgrDvsCd" value="_blank"/>
			                  <input type="hidden" name="posiCd" value="_blank"/>
 					  		</td>
 					  		<td>
								<a href="javascript:void(0);" class="tbl_icon_a row_add_bt" onclick="addPrtcpnt($(this),'${sessionScope.login_user.adminDvsCd}')"><spring:message code='common.add'/></a>
								<a href="javascript:void(0);" class="tbl_icon_a red_del" onclick="removePrtcpnt($(this));"><spring:message code='common.row.delete'/></a>
 					  		</td>
 					  </tr>
					   <script type="text/javascript">var prtcpntIdx = '${prtcpntIdx}';</script>
					</tbody>
				</table>
			</td>
		</tr>
		<tr>
			<th><spring:message code='rprt.keyword'/></th>
			<td colspan="3">
				<input type="text" name="keyword" id="keyword"  class="input_type"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code='con.org.file'/></th>
			<td colspan="5">
				<div class="fileupload_box">
				<c:set var="fIdx" value="1"/>
				<ul>
				  <li>
					<span class="upload_int">
						<input type="text" class="up_input" id="fileInput${fIdx}" onclick="$('#file${fIdx}').trigger('click');" readonly="readonly"/>
						<a href="javascript:void(0);" class="upload_int_bt" onclick="$('#file${fIdx}').trigger('click');"><spring:message code="rprt.file" /></a>
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
			<th><spring:message code='rprt.file.open.at'/></th>
			<td>
				<input name="orginlOthbcAt" type="radio" value="Y"/>&nbsp;<spring:message code='rprt.open.y'/>&nbsp;&nbsp;
				<input name="orginlOthbcAt" type="radio" value="N" checked="checked"/>&nbsp;<spring:message code='rprt.open.n'/>&nbsp;&nbsp;
			</td>
			<th><spring:message code='rprt.security.at'/></th>
			<td>
				<input name="scrtySbjtAt" type="radio" value="Y" />&nbsp;<spring:message code='common.radio.yes'/>&nbsp;&nbsp;
				<input name="scrtySbjtAt" type="radio" value="N"  checked="checked"/>&nbsp;<spring:message code='common.radio.no'/>&nbsp;&nbsp;
			</td>
		</tr>
		<c:if test="${sessionScope.login_user.adminDvsCd eq 'M'}">
			<tr>
				<th><spring:message code='rprt.appr.dvs'/></th>
				<td>
					<select id="apprDvsCd" name="apprDvsCd"  class="select_type" style="width: 100px;">${rims:makeCodeList('1400', true, '') }</select>
				</td>
				<th rowspan="2"><spring:message code='rprt.appr.rtrn'/></th>
				<td rowspan="2">
					<div class="tbl_textarea">
						<textarea maxLength="4000" rows="2" id="apprRtrnCnclRsnCntn" name="apprRtrnCnclRsnCntn"></textarea>
					</div>
				</td>
			</tr>
			<tr>
				<th><spring:message code='rprt.appr.dvs.date'/></th>
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
});
</script>