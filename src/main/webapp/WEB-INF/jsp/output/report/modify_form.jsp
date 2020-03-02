<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.argonet.r2rims.util.LanguageUtil"%>
<%@include file="../../pageInit.jsp" %>

<form id="formArea" action="${contextPath}/report/modifyReport.do" method="post" enctype="multipart/form-data" >
  <input type="hidden" id="reportId" name="reportId" value="${report.reportId}"/>

  <table class="write_tbl mgb_10" >
	<colgroup>
		<col style="width:170px;" />
		<col style="width:296px;" />
		<col style="width:170px" />
		<col style="" />
	</colgroup>
	<tbody>
		<tr>
		  <th class="essential_th"><spring:message code='rprt.date'/></th>
		  <td>
			<select name="pblicteYear" id="pblicteYear" class="select_type required" onchange="changePblcYear('pblicteYear');" style="width: 80px;">${rims:makeYearList(2000, report.pblicteYear, true, false)}</select>&nbsp;<spring:message code='common.year'/>&nbsp;&nbsp;
	        <select name="pblicteMonth" id="pblicteMonth" class="select_type" onchange="changePblcMonth('itlPprRgtReg');" style="width: 45px;">${rims:makeMonthList(report.pblicteMonth, true)}</select>&nbsp;<spring:message code='common.month'/>&nbsp;&nbsp;
		  </td>
		  <th><spring:message code='rprt.ntn.cd'/></th>
		  <td>
		  	<input type="text" name="pblicteNationNm" id="pblicteNationNm"  class="input_type" value="<c:out value="${report.pblicteNationNm}"/>"/>
		  </td>
		</tr>
		<tr>
		  <th class="essential_th"><spring:message code='rprt.nm'/></th>
		  <td colspan="3">
		  	<input type="text" name="reportTitle" id="reportTitle"  class="input_type required" value="<c:out value="${report.reportTitle}"/>"/>
		  </td>
		</tr>
		<tr>
			<th><spring:message code='rprt.related.projt.nm'/></th>
			<td colspan="3">
				<div class="r_add_bt">
					<input type="text" name="rschSbjtNm" id="rschSbjtNm"  class="input_type" value="<c:out value="${report.rschSbjtNm}"/>"/>
					<a href="javascript:void(0);" onclick="findReportFunding($(this),event);" class="tbl_search_bt">검색</a>
				</div>
			</td>
		</tr>
		<tr>
		  <th><spring:message code='rprt.agc.nm'/></th>
		  <td>
			 <input type="text" name="orderInsttNm" id="orderInsttNm"  class="input_type" value="<c:out value="${report.orderInsttNm}"/>"/>
		  </td>
		  <th><spring:message code='rprt.type'/></th>
		  <td>
			 <select name="reportTypeCode" id="reportTypeCode" class="select_type" style="width: 50%;">${rims:makeCodeList('report.type',true,report.reportTypeCode)}</select>
		  </td>
		</tr>
		<tr>
			<th><spring:message code='rprt.sbjt.no'/></th>
			<td>
				<input type="text" name="sbjtNo" id="sbjtNo"  class="input_type" value="<c:out value="${report.sbjtNo}"/>"/>
			</td>
			<th><spring:message code='rprt.instt.sbjt.no'/></th>
			<td>
				<input type="text" name="detailSbjtNo" id="detailSbjtNo"  class="input_type" value="<c:out value="${report.detailSbjtNo}"/>"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code='rprt.this.year.stt.date'/></th>
			<td>
			  <input name="thsyrRsrchSttYear" id="thsyrRsrchSttYear" class="input_type" style="width: 80px;" value="<c:out value="${report.thsyrRsrchSttYear}"/>"/>&nbsp;<spring:message code='common.year'/>&nbsp;&nbsp;
              <input name="thsyrRsrchSttMonth" id="thsyrRsrchSttMonth" class="input_type" style="width: 45px;" value="<c:out value="${report.thsyrRsrchSttMonth }"/>"/>&nbsp;<spring:message code='common.month'/>&nbsp;&nbsp;
              <input name="thsyrRsrchSttDay" id="thsyrRsrchSttDay" class="input_type" style="width: 45px;" value="<c:out value="${report.thsyrRsrchSttDay }"/>"/>&nbsp;<spring:message code='common.day'/>&nbsp;&nbsp;
			</td>
			<th><spring:message code='rprt.this.year.end.date'/></th>
			<td>
			  <input name="thsyrRsrchEndYear" id="thsyrRsrchEndYear" class="input_type" style="width: 80px;" value="<c:out value="${report.thsyrRsrchEndYear}"/>"/>&nbsp;<spring:message code='common.year'/>&nbsp;&nbsp;
              <input name="thsyrRsrchEndMonth" id="thsyrRsrchEndMonth" class="input_type" style="width: 45px;" value="<c:out value="${report.thsyrRsrchEndMonth }"/>"/>&nbsp;<spring:message code='common.month'/>&nbsp;&nbsp;
              <input name="thsyrRsrchEndDay" id="thsyrRsrchEndDay" class="input_type" style="width: 45px;" value="<c:out value="${report.thsyrRsrchEndDay }"/>"/>&nbsp;<spring:message code='common.day'/>&nbsp;&nbsp;
			</td>
		</tr>
		<tr>
			<th><spring:message code='rprt.total.stt.date'/></th>
			<td>
			  <input name="totRsrchSttYear" id="totRsrchSttYear" class="input_type" style="width: 80px;" value="<c:out value="${report.totRsrchSttYear }"/>"/>&nbsp;<spring:message code='common.year'/>&nbsp;&nbsp;
              <input name="totRsrchSttMonth" id="totRsrchSttMonth" class="input_type" style="width: 45px;" value="<c:out value="${report.totRsrchSttMonth }"/>"/>&nbsp;<spring:message code='common.month'/>&nbsp;&nbsp;
              <input name="totRsrchSttDay" id="totRsrchSttDay" class="input_type" style="width: 45px;" value="<c:out value="${report.totRsrchSttDay }"/>"/>&nbsp;<spring:message code='common.day'/>&nbsp;&nbsp;
			</td>
			<th><spring:message code='rprt.total.end.date'/></th>
			<td>
			  <input name="totRsrchEndYear" id="totRsrchEndYear" class="input_type" style="width: 80px;" value="<c:out value="${report.totRsrchEndYear }"/>"/>&nbsp;<spring:message code='common.year'/>&nbsp;&nbsp;
              <input name="totRsrchEndMonth" id="totRsrchEndMonth" class="input_type" style="width: 45px;" value="<c:out value="${report.totRsrchEndMonth}"/>"/>&nbsp;<spring:message code='common.month'/>&nbsp;&nbsp;
              <input name="totRsrchEndDay" id="totRsrchEndDay" class="input_type" style="width: 45px;" value="<c:out value="${report.totRsrchEndDay }"/>"/>&nbsp;<spring:message code='common.day'/>&nbsp;&nbsp;
			</td>
		</tr>
		<tr>
			<th><spring:message code='rprt.exec.instt.nm'/></th>
			<td>
				<input type="text" name="sbjtExcInsttNm" id="sbjtExcInsttNm"  class="input_type" value="<c:out value="${report.sbjtExcInsttNm}"/>"/>
			</td>
			<th><spring:message code='rprt.mgt.instt.nm'/></th>
			<td>
				<input type="text" name="sbjtManageInsttNm" id="sbjtManageInsttNm"  class="input_type" value="<c:out value="${report.sbjtManageInsttNm}"/>"/>
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
					  <c:set var="prtcpntIdx" value="0"/>
					  <c:if test="${not empty report.partiList}">
					    <c:forEach items="${report.partiList}" var="pl" varStatus="idx">
 					  	<tr <c:if test="${sessionScope.sess_user.userId eq pl.prtcpntId}">style="background-color: #FFCC66;"</c:if> >
 					  		<td style="text-align: center;">
 					  			<input type="hidden" name="prtcpntIndex" id="prtcpntIndex_${idx.count}" value="${idx.count}"/>
 					  			<span id="order_${idx.count}">${idx.count}</span>
 					  		</td>
 					  		<td>
				                <input type="text"  name="prtcpntNm" maxLength="30" id="prtcpntNm_${idx.count}" class="input_type required" value="<c:out value="${pl.prtcpntNm}"/>" onkeydown="if(event.keyCode==13){findUser($(this),event);}"/>
				                <input type="hidden" name="pcnRschrRegNo" id="pcnRschrRegNo_${idx.count}" value="<c:out value="${pl.pcnRschrRegNo}"/>"/>
				                <input type="hidden" name="seqAuthor" id="seqAuthor_${idx.count}" value="${pl.seqAuthor}"/>
 					  		</td>
 					  		<td>
 					  		    <input type="text" name="prtcpntFullNm" maxLength="100" id="prtcpntFullNm_${idx.count}" class="input_type" value="<c:out value="${pl.prtcpntFullNm}"/>" onkeydown="if(event.keyCode==13){findUser($(this),event);}"/>
 					  		</td>
 					  		<td>
 					  		   <select name="tpiDvsCd" id="tpiDvsCd_${idx.count}" class="select_type">${rims:makeCodeList('1340', true, pl.tpiDvsCd) }</select>
 					  		</td>
 					  		<td>
 					  			<span class="dk_bt_box">
	 					  			<input type="text" name="prtcpntId" style="width: 80px;" id="prtcpntId_${idx.count}" value="<c:out value="${pl.prtcpntId}"/>" class="input_type"/>
	 					  			<span class="dk_r_bt">
										<a href="javascript:void(0);" class="tbl_icon_a tbl_search_icon" onclick="findUser($(this),event);">검색</a>
										<a href="javascript:void(0);" class="tbl_icon_a tbl_trash_icon" onclick="clearPrtcpnt($(this));">지우기</a>
									</span>
								</span>
 					  		</td>
 					  		<td>
 					  		  <div class="r_add_bt">
		               		  <input type="hidden" name="blngAgcCd" id="blngAgcCd_${idx.count}" value="<c:out value="${pl.blngAgcCd}"/>"/>
		                	  <input type="text" name="blngAgcNm" id="blngAgcNm_${idx.count}" class="input_type" style="<c:if test="${not empty pl.blngAgcNm and empty pl.blngAgcCd }">background-color: #fef3d7;</c:if>" value="<c:out value="${pl.blngAgcNm}"/>" onkeydown="if(event.keyCode==13){getCodeOrgWin($(this),event);}"/>
							  <span class="r_span_box">
								<a href="javascript:void(0);" class="tbl_icon_a tbl_search_icon" onclick="getCodeOrgWin($(this),event);">검색</a>
							  </span>
							  </div>
			                  <input type="hidden" name="tpiRate" value="<c:out value="${empty pl.tpiRate ? '_blank' : pl.tpiRate}"/>"/>
			                  <input type="hidden" name="dgrDvsCd" value="<c:out value="${empty pl.dgrDvsCd ? '_blank' : pl.dgrDvsCd}"/>"/>
			                  <input type="hidden" name="posiCd" value="<c:out value="${empty pl.posiCd ? '_blank' : pl.posiCd}"/>"/>
 					  		</td>
 					  		<td>
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
			<th><spring:message code='rprt.keyword'/></th>
			<td colspan="3">
				<input type="text" name="keyword" id="keyword"  class="input_type" value="<c:out value="${report.keyword}"/>"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code='con.org.file'/></th>
			<td colspan="5">
				<div class="fileupload_box">
				<c:set var="fIdx" value="1"/>
				<c:forEach items="${report.fileList}" var="fd" varStatus="idx">
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
				<input name="orginlOthbcAt" type="radio" value="Y" ${report.orginlOthbcAt eq 'Y' ? "checked='checked'" : ''} />&nbsp;<spring:message code='rprt.open.y'/>&nbsp;&nbsp;
				<input name="orginlOthbcAt" type="radio" value="N" ${empty report.orginlOthbcAt or report.orginlOthbcAt eq 'N' ? "checked='checked'" : ''}/>&nbsp;<spring:message code='rprt.open.n'/>&nbsp;&nbsp;
			</td>
			<th><spring:message code='rprt.security.at'/></th>
			<td>
				<input name="scrtySbjtAt" type="radio" value="Y" ${report.scrtySbjtAt eq 'Y' ? "checked='checked'" : ''} />&nbsp;<spring:message code='common.radio.yes'/>&nbsp;&nbsp;
				<input name="scrtySbjtAt" type="radio" value="N" ${empty report.scrtySbjtAt or report.scrtySbjtAt eq 'N' ? "checked='checked'" : ''}/>&nbsp;<spring:message code='common.radio.no'/>&nbsp;&nbsp;
			</td>
		</tr>
		<c:if test="${sessionScope.login_user.adminDvsCd eq 'M'}">
			<tr>
				<th><spring:message code='rprt.appr.dvs'/></th>
				<td>
					<select id="apprDvsCd" name="apprDvsCd"  class="select_type" style="width: 100px;">${rims:makeCodeList('1400', true, report.apprDvsCd) }</select>
				</td>
				<th rowspan="2"><spring:message code='rprt.appr.rtrn'/></th>
				<td rowspan="2">
					<div class="tbl_textarea">
						<textarea maxLength="4000" rows="2" id="apprRtrnCnclRsnCntn" name="apprRtrnCnclRsnCntn"><c:out value="${report.apprRtrnCnclRsnCntn}"/></textarea>
					</div>
				</td>
			</tr>
			<tr>
				<th><spring:message code='rprt.appr.dvs.date'/></th>
				<td><fmt:formatDate value="${report.apprDate}" pattern="yyyy-MM-dd" /></td>
			</tr>
		</c:if>
		<c:if test="${sessionScope.login_user.adminDvsCd ne 'M'}">
			<tr>
				<th><spring:message code='rprt.appr.dvs'/></th>
				<td>
					${rims:codeValue('1400',report.apprDvsCd)}
					<input type="hidden" name="apprDvsCd" value="<c:out value="${empty report.apprDvsCd ? '1' : report.apprDvsCd}"/>"/>
				</td>
				<th rowspan="2"><spring:message code='rprt.appr.rtrn'/></th>
				<td rowspan="2">
					<c:out value="${report.apprRtrnCnclRsnCntn}"/>
					<input type="hidden" name="apprRtrnCnclRsnCntn" value="<c:out value="${report.apprRtrnCnclRsnCntn}"/>"/>
				</td>
			</tr>
			<tr>
				<th><spring:message code='rprt.appr.dvs.date'/></th>
				<td><fmt:formatDate value="${report.apprDate}" pattern="yyyy-MM-dd" /></td>
			</tr>
		</c:if>
		<tr>
			<th><spring:message code='common.reg.date'/></th>
			<td>
				<fmt:formatDate var="regDate" value="${report.regDate}" pattern="yyyy-MM-dd" /> <c:out value="${regDate}"/> ( <c:out value="${empty report.regUserNm ? 'ADMIN' : report.regUserNm}"/> )
			</td>
			<th><spring:message code='common.mod.date'/></th>
			<td>
				<fmt:formatDate var="modDate" value="${report.modDate}" pattern="yyyy-MM-dd" /> <c:out value="${modDate}"/> ( <c:out value="${empty report.modUserNm ? 'ADMIN' : report.modUserNm}"/> )
			</td>
		</tr>
	</tbody>
  </table>
</form>
<form id="removeFormArea" action="${contextPath}/report/removeReport.do" method="post">
	<input type="hidden" name="reportId" value="${report.reportId}"/>
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
});
</script>