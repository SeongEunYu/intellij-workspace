<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.argonet.r2rims.util.LanguageUtil"%>
<%@include file="../../pageInit.jsp" %>
<c:set var="setDisable" value=""/>
<c:set var="setReadonly" value=""/>
<c:set var="colorGray" value=""/>
<c:if test="${not empty degree.src and degree.src eq 'ERP'}">
	<c:set var="setDisable" value='disabled="disabled"'/>
	<c:set var="setReadonly" value='readonly="readonly"'/>
	<c:set var="colorGray" value='color:gray;'/>
</c:if>
<form id="formArea" action="<c:url value="/degree/modifyDegree.do"/>" method="post" enctype="multipart/form-data" >
  <input type="hidden" id="degreeId" name="degreeId" value="${degree.degreeId}"/>
  <input type="hidden" id="userId" name="userId" value="${degree.userId}"/>
  <table class="write_tbl mgb_10" >
	<colgroup>
		<col style="width:140px;" />
		<col style="width:171px;" />
		<col style="width:140px" />
		<col style="width:171px;" />
		<col style="width:140px" />
		<col style="" />
	</colgroup>
	<tbody>
		<!--
		<c:if test="${sessionScope.auth.adminDvsCd ne 'R' and sessionScope.auth.adminDvsCd ne 'S'}">
		<tr>
			<th class="essential_th">연구자</th>
			<td colspan="5">${degree.korNm} [ ${degree.userId} ]</td>
		</tr>
		</c:if>
		-->
		<tr>
			<th class="essential_th"><spring:message code='degr.acqs.dgr.dvs.cd'/></th>
			<td>
				<input type="hidden" id="acqsDgrDvsCd" name="acqsDgrDvsCd" value="<c:out value="${degree.acqsDgrDvsCd}"/>" />
				<select class="select_type" onchange="$('#acqsDgrDvsCd').val($(this).val());" ${setDisable}>${rims:makeCodeList('1240', true, degree.acqsDgrDvsCd)}</select>
			</td>
			<th class="essential_th"><spring:message code='degr.dgr.stt.ym'/></th>
			<td>
				<input type="text" maxLength="4" style="width: 36px;text-align: right; ${colorGray}" name="dgrSttYear" id="dgrSttYear" class="input_type required"  value="<c:out value="${degree.dgrSttYear}"/>"  ${setReadonly}/><spring:message code='common.year'/>
				<input type="text" maxLength="4" style="width: 22px;text-align: right; ${colorGray}" name="dgrSttMonth" id="dgrSttMonth" class="input_type"  value="<c:out value="${degree.dgrSttMonth}"/>"  ${setReadonly}/><spring:message code='common.month'/>
				<input type="hidden" maxLength="4" name="dgrSttDay" id="dgrSttDay" class="input_type"  value="<c:out value="${degree.dgrSttDay}"/>"  ${setReadonly}/><spring:message code='common.day'/>
				<%--
				<input type="text" maxLength="4" style="width: 22px;text-align: right; ${colorGray}" name="dgrSttDay" id="dgrSttDay" class="input_type"  value="<c:out value="${degree.dgrSttDay}"/>"  ${setReadonly}/><spring:message code='common.day'/>
				 --%>
			</td>
			<th class="essential_th"><spring:message code='degr.dgr.acqs.ym'/></th>
			<td>
				<input type="text" maxLength="4" style="width: 36px;text-align: right; ${colorGray}" name="dgrAcqsYear" id="dgrAcqsYear" class="input_type required"  value="<c:out value="${degree.dgrAcqsYear}"/>"  ${setReadonly}/><spring:message code='common.year'/>
				<input type="text" maxLength="4" style="width: 22px;text-align: right; ${colorGray}" name="dgrAcqsMonth" id="dgrAcqsMonth" class="input_type"  value="<c:out value="${degree.dgrAcqsMonth}"/>"  ${setReadonly}/><spring:message code='common.month'/>
				<input type="hidden" maxLength="4" name="dgrAcqsDay" id="dgrAcqsDay" value="<c:out value="${degree.dgrAcqsDay}"/>"  ${setReadonly}/><spring:message code='common.day'/>
				<%--
				<input type="text" maxLength="4" style="width: 22px;text-align: right; ${colorGray}" name="dgrAcqsDay" id="dgrAcqsDay" class="input_type"  value="<c:out value="${degree.dgrAcqsDay}"/>"  ${setReadonly}/><spring:message code='common.day'/>
				 --%>
			</td>
		</tr>
		<tr>
			<th><spring:message code='degr.blng.univ.erp'/></th>
			<td>
				<input type="text" name="dgrAcqsAgcNm" id="dgrAcqsAgcNm"  class="input_type" style="${colorGray}" value="<c:out value="${degree.dgrAcqsAgcNm}"/>" ${setReadonly}/>
			</td>
			<th><spring:message code='degr.dgr.acqs.clg.nm'/></th>
			<td>
			  	 <div class="r_add_bt">
	               <span class="add_int_del">
					  <input type="hidden" name="dgrAcqsClgNmKey" id="dgrAcqsClgNmKey"/>
		              <input type="text" name="dgrAcqsClgNm" id="dgrAcqsClgNmValue" class="input_type" style="<c:if test="${not empty degree.dgrAcqsClgNm }">background-color: #fef3d7;</c:if>" value="<c:out value="${degree.dgrAcqsClgNm}"/>" onclick="getCodeWin('2030', 'dgrAcqsClgNm', '<spring:message code='degr.univ'/>', $(this).val());" readonly="readonly"/>
					  <a href="javascript:void(0);" class="tbl_int_del" onclick="clearCode($('#dgrAcqsClgNmKey'),$('#dgrAcqsClgNmValue'));">지우기</a>
	               </span>
				   <span class="r_span_box">
					  <a href="javascript:void(0);" class="tbl_icon_a tbl_search_icon" onclick="getCodeWin('2030', 'dgrAcqsClgNm', '<spring:message code='degr.univ'/>', $('#dgrAcqsClgNmValue').val());">검색</a>
				   </span>
				 </div>
			</td>
			<th class="essential_th"><spring:message code='degr.dgr.acqs.ntn.cd'/></th>
			<td>
		        <select name="dgrAcqsNtnCd" id="dgrAcqsNtnCd" class="select_type required">
		          	${rims:makeCodeList('2000', true, degree.dgrAcqsNtnCd) }
		        </select>
		        <script type="text/javascript">
		        	jQuery(document).ready(function(){ $('#dgrAcqsNtnCd > option').eq(9).after($('<option value="">====================</option>')); });
		        </script>
			</td>
		</tr>
		<tr>
			<th class="essential_th"><spring:message code='degr.blng.univ'/></th>
			<td>
			  	 <div class="r_add_bt">
			  	   <span class="add_int_del">
				     <input type="hidden" name="dgrAcqsAgcCd" id="dgrAcqsAgcCdKey"  value="<c:out value="${degree.dgrAcqsAgcCd}"/>" class="required"/>
	                 <input type="text" name="dgrAcqsAgcCdValue" id="dgrAcqsAgcCdValue" class="input_type" value="<c:out value="${degree.dgrAcqsAgcCdNm}"/>" onclick="getCodeOrgWin('dgrAcqsAgcCd',event);"/>
					 <a href="javascript:void(0);" class="tbl_int_del" onclick="clearCode($('#dgrAcqsAgcCdKey'),$('#dgrAcqsAgcCdValue'));">지우기</a>
	               </span>
				   <span class="r_span_box">
					  <a href="javascript:void(0);" class="tbl_icon_a tbl_search_icon" onclick="getCodeOrgWin('dgrAcqsAgcCd',event);">검색</a>
				   </span>
				 </div>
			</td>
			<th><spring:message code='degr.drg.sbjt.no'/></th>
			<td>
			  	 <div class="r_add_bt">
			  	   <span class="add_int_del">
				      <input type="hidden" name="dgrAcqsSbjtNmKey" id="dgrAcqsSbjtNmKey" />
	                  <input type="text" name="dgrAcqsSbjtNm" id="dgrAcqsSbjtNmValue" class="input_type" value="<c:out value="${degree.dgrAcqsSbjtNm}"/>" readonly="readonly" onclick="getCodeWin('2050','dgrAcqsSbjtNm','<spring:message code='degr.dep'/>',$(this).val());" />
					  <a href="javascript:void(0);" class="tbl_int_del" onclick="clearCode($('#dgrAcqsSbjtNmKey'),$('#dgrAcqsSbjtNmValue'));">지우기</a>
	               </span>
				   <span class="r_span_box">
					  <a href="javascript:void(0);" class="tbl_icon_a tbl_search_icon" onclick="getCodeWin('2050','dgrAcqsSbjtNm','<spring:message code='degr.dep'/>',$('#dgrAcqsSbjtNmValue').val());">검색</a>
				   </span>
				 </div>
			</td>
			<th><spring:message code='degr.tutor.nm'/></th>
			<td>
			  	 <div class="r_add_bt">
			  	   <span class="add_int_del">
				      <input type="hidden" name="tutorRschrRegNo" id="tutorRschrRegNoKey"  value="<c:out value="${degree.tutorRschrRegNo}"/>"/>
	                  <input type="text" name="tutorNm" id="tutorNmValue" class="input_type" value="<c:out value="${degree.tutorNm}"/>"  <c:if test="${empty degree.tutorNm}">style="background-color:#FFCC66"</c:if> />
					  <a href="javascript:void(0);" class="tbl_int_del" onclick="clearCode($('#tutorRschrRegNoKey'),$('#tutorNmValue'));">지우기</a>
	               </span>
				   <span class="r_span_box">
					  <a href="javascript:void(0);" class="tbl_icon_a tbl_search_icon" onclick="searchTutorRschr();">검색</a>
				   </span>
				 </div>
			</td>
		</tr>
		<tr>
			<th><spring:message code='degr.dgr.spcl.cd'/></th>
			<td>
			  	 <div class="r_add_bt">
			  	   <span class="add_int_del">
				     <c:set var="dgrSpclValue" value="${pageContext.response.locale eq 'en' ? degree.dgrSpclEngNm : degree.dgrSpclNm }" />
				     <input type="hidden" name="dgrSpclCd" id="dgrSpclCdKey" value="${degree.dgrSpclCd}"/>
	                 <input type="text" name="dgrSpclCdValue" id="dgrSpclCdValue" class="input_type" value="<c:out value="${dgrSpclValue}"/>" onclick="findResArea('dgrSpclCd','7',$(this).val());" readonly="readonly"  <c:if test="${empty degree.dgrSpclCd}">style="background-color:#FFCC66"</c:if> />
					 <a href="javascript:void(0);" class="tbl_int_del" onclick="clearCode($('#dgrSpclCdKey'),$('#dgrSpclCdValue'));">지우기</a>
			  	   </span>
				   <span class="r_span_box">
					  <a href="javascript:void(0);" class="tbl_icon_a tbl_search_icon" onclick="findResArea('dgrSpclCd','7',$('#dgrSpclCdValue').val());">검색</a>
				   </span>
				 </div>
			</td>
			<th><spring:message code='degr.dgr.dtl.spcl.nm'/></th>
			<td>
				<input type="text" name="dgrDtlSpclNm" id="dgrDtlSpclNm"  class="input_type" value="<c:out value="${degree.dgrDtlSpclNm}"/>" maxlength="50" <c:if test="${empty degree.dgrDtlSpclNm}">style="background-color:#FFCC66"</c:if>/>
			</td>
			<th><spring:message code='degr.last.dgr.slct.cd'/></th>
			<td>
				<input type="checkbox" name="lastDgrSlctCd"  id="lastDgrSlctCd" onclick="dgrCheck('lastDgrCheck');"class="input2" value="1"  ${not empty degree.lastDgrSlctCd and degree.lastDgrSlctCd eq '1' ? 'checked="checked"' : '' }/>
				<font color="blue"><spring:message code='degr.check'/></font>
			</td>
		</tr>
		<tr>
			<th><spring:message code='degr.title.org'/></th>
			<td colspan="5">
				<div class="tbl_textarea">
					<textarea name="orgLangDgrPprNm" maxLength="1000" rows="2" id="orgLangDgrPprNm"><c:out value="${degree.orgLangDgrPprNm}"/></textarea>
				</div>
			</td>
		</tr>
		<tr>
			<th><spring:message code='degr.title.etc'/></th>
			<td colspan="5">
				<div class="tbl_textarea">
					<textarea name="diffLangDgrPprNm" maxLength="1000" rows="2" id="diffLangDgrPprNm"><c:out value="${degree.diffLangDgrPprNm}"/></textarea>
				</div>
			</td>
		</tr>
		<tr>
			<th><spring:message code='degr.abstract'/></th>
			<td colspan="5">
				<div class="tbl_textarea">
					<textarea name="dgrPprXcptCntn" id="dgrPprXcptCntn" rows="3" maxLength="4000"><c:out value="${degree.dgrPprXcptCntn}"/></textarea>
				</div>
			</td>
		</tr>
		<tr>
			<th><spring:message code='degr.org.file'/></th>
			<td colspan="5">
				<div class="fileupload_box">
				<c:set var="fIdx" value="0"/>
				<c:forEach items="${degree.fileList}" var="fd" varStatus="idx">
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
						<a href="javascript:void(0);" class="upload_int_bt" onclick="$('#file${fIdx}').trigger('click');"><spring:message code="common.file.select" /></a>
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
			<th><spring:message code='kri.link'/></th>
			<td colspan="5">
	    		<input type="radio" name="interfaceFlag" id="interfaceFlag1" value="1" class="" <c:if test="${empty degree.interfaceFlag or degree.interfaceFlag eq '1'}">checked="checked"</c:if>/><spring:message code='kri.link.yes'/>
				<input type="radio" name="interfaceFlag" id="interfaceFlag0" value="0" class="" <c:if test="${not empty degree.interfaceFlag and degree.interfaceFlag eq '0' }">checked="checked"</c:if>/><spring:message code='kri.link.no'/>
			</td>
		</tr>
		<tr>
			<th><spring:message code='common.reg.date'/></th>
			<td>
				<fmt:formatDate var="regDate" value="${degree.regDate}" pattern="yyyy-MM-dd" /> <c:out value="${regDate}"/> ( <c:out value="${empty degree.regUserNm ? 'ADMIN' : degree.regUserNm}"/> )
			</td>
			<th><spring:message code='common.mod.date'/></th>
			<td>
				<fmt:formatDate var="modDate" value="${degree.modDate}" pattern="yyyy-MM-dd" /> <c:out value="${modDate}"/> ( <c:out value="${empty degree.modUserNm ? 'ADMIN' : degree.modUserNm}"/> )
			</td>
			<th><spring:message code='common.source'/></th>
			<td>
				${empty degree.src or degree.src eq 'USER' ? '직접입력' : 'ERP'}
			</td>
		</tr>
	</tbody>
  </table>
 </form>
 <form id="removeFormArea" action="<c:url value="/degree/removeDegree.do"/>" method="post">
	<input type="hidden" name="degreeId" value="${degree.degreeId}"/>
</form>
<script type="text/javascript">
$(document).ready(function(){
	$('input, select, textarea').change(function(){ isChange = true; });
	$('input:checkbox, input:radio').click(function(){ isChange = true; });
});
</script>