<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.argonet.r2rims.util.LanguageUtil"%>
<%@include file="../../pageInit.jsp" %>
<form id="formArea" action="${contextPath}/degree/addDegree.do" method="post" enctype="multipart/form-data" >
 	 <input type="hidden" name="src" id="src" value="USER">
  <c:if test="${sessionScope.auth.adminDvsCd eq 'R' or sessionScope.auth.adminDvsCd eq 'S'}">
  	 <input type="hidden" name="userId" id="userId" value="${sessionScope.auth.workTrget}">
  </c:if>
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
			<td>
			   <input type="hidden" name="userId" id="userId">
			   <div class="r_add_bt">
			   	 <span class="add_int_del">
			   	 	<input type="text" name="korNm" id="korNm" class="input_type required"  readonly="readonly"  onclick="findDegreeUser();"/>
			   	 	<a href="javascript:void(0);" class="tbl_int_del" onclick="clearPrtcpnt($(this));">지우기</a>
			   	 </span>
			   	 <span class="r_span_box">
			   	 	<a href="javascript:void(0);" class="tbl_icon_a tbl_search_icon" onclick="findDegreeUser();">검색</a>
			   	 </span>
			   </div>
			</td>
			<td colspan="4"></td>
		</tr>
		</c:if>
		-->
		<tr>
			<th class="essential_th"><spring:message code='degr.acqs.dgr.dvs.cd'/></th>
			<td>
				<select name="acqsDgrDvsCd" class="select_type">${rims:makeCodeList('1240', true, '')}</select>
			</td>
			<th class="essential_th"><spring:message code='degr.dgr.stt.ym'/></th>
			<td>
				<input type="text" maxLength="4" style="width: 36px;text-align: right; ${colorGray}" name="dgrSttYear" id="dgrSttYear" class="input_type required" /><spring:message code='common.year'/>
				<input type="text" maxLength="4" style="width: 22px;text-align: right; ${colorGray}" name="dgrSttMonth" id="dgrSttMonth" class="input_type"/><spring:message code='common.month'/>
				<input type="hidden" maxLength="4" name="dgrSttDay" id="dgrSttDay" class="input_type"/><spring:message code='common.day'/>
				<%--
				<input type="text" maxLength="4" style="width: 22px;text-align: right; ${colorGray}" name="dgrSttDay" id="dgrSttDay" class="input_type"/><spring:message code='common.day'/>
				 --%>
			</td>
			<th class="essential_th"><spring:message code='degr.dgr.acqs.ym'/></th>
			<td>
				<input type="text" maxLength="4" style="width: 36px;text-align: right; ${colorGray}" name="dgrAcqsYear" id="dgrAcqsYear" class="input_type required" /><spring:message code='common.year'/>
				<input type="text" maxLength="4" style="width: 22px;text-align: right; ${colorGray}" name="dgrAcqsMonth" id="dgrAcqsMonth" class="input_type" /><spring:message code='common.month'/>
				<input type="hidden" maxLength="4" name="dgrAcqsDay" id="dgrAcqsDay" class="input_type" /><spring:message code='common.day'/>
				<%--
				<input type="text" maxLength="4" style="width: 22px;text-align: right; ${colorGray}" name="dgrAcqsDay" id="dgrAcqsDay" class="input_type" /><spring:message code='common.day'/>
				 --%>
			</td>
		</tr>
		<tr>
			<th><spring:message code='degr.blng.univ.erp'/></th>
			<td>
				<input type="text" name="dgrAcqsAgcNm" id="dgrAcqsAgcNm"  class="input_type"/>
			</td>
			<th><spring:message code='degr.dgr.acqs.clg.nm'/></th>
			<td>
			  	 <div class="r_add_bt">
	               <span class="add_int_del">
					  <input type="hidden" name="dgrAcqsClgNmKey" id="dgrAcqsClgNmKey"/>
		              <input type="text" name="dgrAcqsClgNm" id="dgrAcqsClgNmValue" class="input_type" onclick="getCodeWin('2030', 'dgrAcqsClgNm', '<spring:message code='degr.univ'/>', $(this).val());" readonly="readonly"/>
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
		          	${rims:makeCodeList('2000', true, '')}
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
				     <input type="hidden" name="dgrAcqsAgcCd" id="dgrAcqsAgcCdKey" class="required"/>
	                 <input type="text" name="dgrAcqsAgcCdValue" id="dgrAcqsAgcCdValue" class="input_type required" onclick="getCodeOrgWin('dgrAcqsAgcCd',event);"/>
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
	                  <input type="text" name="dgrAcqsSbjtNm" id="dgrAcqsSbjtNmValue" class="input_type" readonly="readonly" onclick="getCodeWin('2050','dgrAcqsSbjtNm','<spring:message code='degr.dep'/>',$(this).val());" />
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
				      <input type="hidden" name="tutorRschrRegNo" id="tutorRschrRegNoKey"/>
	                  <input type="text" name="tutorNm" id="tutorNmValue" class="input_type"/>
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
				     <input type="hidden" name="dgrSpclCd" id="dgrSpclCdKey" />
	                 <input type="text" name="dgrSpclCdValue" id="dgrSpclCdValue" class="input_type" onclick="findResArea('dgrSpclCd','7',$(this).val());" readonly="readonly" />
					 <a href="javascript:void(0);" class="tbl_int_del" onclick="clearCode($('#dgrSpclCdKey'),$('#dgrSpclCdValue'));">지우기</a>
			  	   </span>
				   <span class="r_span_box">
					  <a href="javascript:void(0);" class="tbl_icon_a tbl_search_icon" onclick="findResArea('dgrSpclCd','7',$('#dgrSpclCdValue').val());">검색</a>
				   </span>
				 </div>
			</td>
			<th><spring:message code='degr.dgr.dtl.spcl.nm'/></th>
			<td>
				<input type="text" name="dgrDtlSpclNm" id="dgrDtlSpclNm"  class="input_type" maxlength="50"/>
			</td>
			<th><spring:message code='degr.last.dgr.slct.cd'/></th>
			<td>
				<input type="checkbox" name="lastDgrSlctCd"  id="lastDgrSlctCd" onclick="dgrCheck('lastDgrCheck');"class="input2" value="1"  />
				<font color="blue"><spring:message code='degr.check'/></font>
			</td>
		</tr>
		<tr>
			<th><spring:message code='degr.title.org'/></th>
			<td colspan="5">
				<div class="tbl_textarea">
					<textarea name="orgLangDgrPprNm" maxLength="1000" rows="2" id="orgLangDgrPprNm"></textarea>
				</div>
			</td>
		</tr>
		<tr>
			<th><spring:message code='degr.title.etc'/></th>
			<td colspan="5">
				<div class="tbl_textarea">
					<textarea name="diffLangDgrPprNm" maxLength="1000" rows="2" id="diffLangDgrPprNm"></textarea>
				</div>
			</td>
		</tr>
		<tr>
			<th><spring:message code='degr.abstract'/></th>
			<td colspan="5">
				<div class="tbl_textarea">
					<textarea name="dgrPprXcptCntn" id="dgrPprXcptCntn" rows="3" maxLength="4000"></textarea>
				</div>
			</td>
		</tr>
		<tr>
			<th><spring:message code='degr.org.file'/></th>
			<td colspan="5">
				<div class="fileupload_box">
				<c:set var="fIdx" value="1"/>
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
	    		<c:set var="flag" value="${fn:substring(fn:trim(degree.interfaceFlag),0,1)}"/>
	    		<input type="radio" name="interfaceFlag" id="interfaceFlag1" value="1" class="" checked="checked"/><spring:message code='kri.link.yes'/>
				<input type="radio" name="interfaceFlag" id="interfaceFlag0" value="0" class="" /><spring:message code='kri.link.no'/>
			</td>
		</tr>
	</tbody>
  </table>
</form>
<script type="text/javascript">
$(document).ready(function(){
	$('input, select, textarea').change(function(){ isChange = true; });
	$('input:checkbox, input:radio').click(function(){ isChange = true; });
});
</script>