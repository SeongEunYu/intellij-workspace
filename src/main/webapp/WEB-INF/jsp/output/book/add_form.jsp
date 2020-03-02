<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.argonet.r2rims.util.LanguageUtil"%>
<%@include file="../../pageInit.jsp" %>
<c:set var="rschRequiredClass" value=""/><c:set var="rschEssentialTh" value=""/>
  <c:if test="${sessionScope.auth.adminDvsCd eq 'R' or sessionScope.auth.adminDvsCd eq 'S'}">
  <c:set var="rschRequiredClass" value="required"/><c:set var="rschEssentialTh" value="essential_th"/>
</c:if>
<c:if test="${sessMode or (sessionScope.auth.adminDvsCd eq 'R' or sessionScope.auth.adminDvsCd eq 'S' )}">
  <c:set var="prtpntId" value="${sessionScope.sess_user.userId}"/><c:set var="prtcpntNm" value="${sessionScope.sess_user.abbrLastName}, ${sessionScope.sess_user.abbrFirstName}"/>
  <c:set var="prtcpntFullNm" value="${sessionScope.sess_user.lastName}, ${sessionScope.sess_user.firstName}"/><c:set var="pcnRschrRegNo" value="${sessionScope.sess_user.rschrRegNo}"/>
  <c:set var="deptKor" value="${sessionScope.sess_user.groupDept}"/><c:set var="blngAgcCd" value="${sysConf['inst.blng.agc.code']}"/><c:set var="blngAgcNm" value="${sysConf['inst.blng.agc.name']}"/>
</c:if>
<form name="vrfcFrm" id="vrfcFrm" method="post"></form>
<form id="formArea" action="${contextPath}/book/addBook.do" method="post" enctype="multipart/form-data"  >
  <input type="hidden"  name="vrfcDvsCd" id="vrfcDvsCdKey" value="1"/>
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
		<tr>
			<th class="essential_th">
				<spring:message code='book.dvs.cd'/>
			</th>
			<td>
				<select name="bookDvsCd" id="bookDvsCd" class="select_type required">${rims:makeCodeList('1110', true, '')}</select>
				<label for="chapter"><spring:message code='book.chapter'/></label>
				<input type="checkbox" id="chapter" name="chapter" value="Y" style="vertical-align: middle;" />
			</td>
	        <th>
	        	<spring:message code='book.char.cd'/>
	        </th>
	        <td>
	        	<select name="bookCharCd" id="bookCharCd" class="select_type">${rims:makeCodeList('1330', true, '')}</select>
	        </td>
	        <th>
	        	<spring:message code='book.rvsn.yn'/>
	        </th>
			<td>
				<select name="rvsnYn" id="rvsnYn" class="select_type">${rims:makeCodeList('1120', true, '')}</select>
			</td>
		</tr>
		<tr>
			<th class="essential_th">
				<spring:message code='book.title.org'/>
			</th>
			<td colspan="5">
				<input type="text" maxLength="300" name="orgLangBookNm" id="orgLangBookNm" class="input_type required" value=""/>
			</td>
		</tr>
		<tr>
			<th>
				<spring:message code='book.chapter.title'/>
			</th>
			<td colspan="5">
				<input type="text" name="chapterTitle" id="chapterTitle" maxLength="300" class="input_type" value=""/>
			</td>
		</tr>
		<tr>
			<th>
				<spring:message code='book.title.etc'/>
			</th>
			<td colspan="5">
				<input type="text" maxLength="300" name="diffLangBookNm" id="diffLangBookNm" class="input_type" value=""/>
			</td>
		</tr>
		<tr>
			<th>
				<spring:message code='book.series'/>
			</th>
			<td colspan="5">
				<input type="text" maxLength="300" name="seriesNm" id="seriesNm" class="input_type" value=""/>
			</td>
		</tr>
		<tr>
			<th class="essential_th">
				<spring:message code='book.pblc.date'/>
			</th>
			<td>
				<input type="text" name="bookPblcYear" id="bookPblcYear" class="input_type required" style="width: 60px;" value="" />&nbsp;<spring:message code='common.year'/>&nbsp;&nbsp;
				<input type="text" name="bookPblcMonth" id="bookPblcMonth" class="input_type" style="width: 40px;" value="" />&nbsp;<spring:message code='common.month'/>&nbsp;&nbsp;
			</td>
			<th class="essential_th">
				<spring:message code='book.pblc.plc.nm'/>
			</th>
			<td colspan="3">
				<input type="text" name="pblcPlcNm" id="pblcPlcNm" maxLength="150" class="input_type required" value=""/>
			</td>
		</tr>
		<tr>
			<th class="essential_th">
				<spring:message code='book.jnl.dvs.cd'/>
			</th>
			<td>
				<select name="jnlDvsCd" id="jnlDvsCd" class="select_type required">${rims:makeCodeList('1140', true, '')}</select>
			</td>
			<th class="essential_th">
				<spring:message code='book.total.page'/>
			</th>
			<td>
				<input type="text" name="totalPage" id="totalPage" class="input_type required" maxLength="20" value=""/>
			</td>
			<th><spring:message code='book.wrt.page'/></th>
			<td>
				<input type="text" style="width: 80px;" name="wrtSttEndPage" id="wrtSttEndPage" class="input_type" maxLength="20" value=""/>
				<span class="exText">ex) 12-50</span>
			</td>
		</tr>
		<tr>
			<th class="essential_th"><spring:message code='book.mkout.lang.cd'/></th>
			<td>
				<select name="mkoutLangCd" id="mkoutLangCd" class="select_type required">${rims:makeCodeList('1130', true, '')}</select>
			</td>
			<th>ISBN</th>
			<td>
				<input type="text" name="isbnNo" id="isbnNo" class="input_type" maxLength="20" value="" />
			</td>
			<th>ISSN</th>
			<td>
				<input type="text" name="issnNo" id="issnNo" maxLength="9" class="input_type" value="" />
			</td>
		</tr>
		<tr>
			<th rowspan="2">
				<spring:message code='book.dlgt.athr.nm'/>
			</th>
			<td rowspan="2">
				<input type="text" name="dlgtAthrNm" id="dlgtAthrNm" maxLength="30" class="input_type" value=""/>
			</td>
			<th rowspan="2">
				<spring:message code='book.sbjt.no'/>
			</th>
			<td colspan="3">
				<input type="checkbox" id="relateFundingAt" name="relateFundingAt" value="N"/>&nbsp;<spring:message code="art.relate.funding.lable" />
			</td>
		</tr>
		<tr>
			<td colspan="3">
				<div class="r_add_bt">
					<c:set var="fundIndex" value="0"/>
					<input type="hidden" name="fundIndex"  id="fundIndex_${fundIndex}" value="${fundIndex}">
					<input type="hidden" name="seqNo" value="_blank">
					<input type="hidden" name="fundingId" id="fundingId_${fundIndex}" value=""/>
					<input type="text" name="sbjtNo" id="sbjtNo_${fundIndex}" value="" class="input_type" readonly="readonly" style="width: 80px;" />
					<input type="text" name="rschSbjtNm" id="rschSbjtNm_${fundIndex}" class="input_type" value="" style="width: 346px;" onkeydown="if(event.keyCode==13){findFunding($(this),event);}"/>
					<span class="r_span_box">
						<a href="javascript:void(0);" class="tbl_icon_a tbl_search_icon" onclick="findFunding($(this),event);">검색</a>
					</span>
				</div>
			</td>
		</tr>
		<tr>
			<th><spring:message code='book.authors'/></th>
			<td colspan="5">
				<div class="writer_td_inner">
				  <em class="td_left_ex">ex) Eng : Hong, Gil dong / Kor : 홍길동</em>
				  <p>
					  <span style="font-weight: bold;"><spring:message code="book.total.athr.cnt"/></span>
				  	<input type="text"  name="totalAthrCnt" id="totalAthrCnt" maxlength="4" class="input_type required" style="width:40px;text-align: center;" value=""/>
				  	<em>ex) 17</em>
				  </p>
				</div>
			</td>
		</tr>
		<tr>
			<td colspan="6" class="inner_tbl_td">
				<table class="inner_tbl move_tbl" id="prtcpntTbl" style="height: 50px;">
					<thead>
					  <tr>
						<th colspan="2" style="width: 50px;"><spring:message code='book.order'/></th>
						<th class="essential_th" style="width:150px;"><spring:message code='book.abbr.nm'/></th>
						<th style="width:150px;"><spring:message code='book.full.nm'/></th>
						<th style="width:80px;"><spring:message code='book.tpi.dvs.cd'/></th>
						<th style="width:160px"><spring:message code='book.user.id'/></th>
						<th style="width:160px"><spring:message code='book.agc.nm'/></th>
						<th style="width: 60px;"></th>
					  </tr>
					</thead>
					<tbody id="prtcpntTbody">
					  <c:set var="prtcpntIdx" value="1"/>
					  <c:if test="${not empty book.partiList}">
					    <c:forEach items="${book.partiList}" var="pl" varStatus="idx">
 					  	<tr <c:if test="${sessionScope.sess_user.userId eq pl.prtcpntId}">style="background-color: #FFCC66;"</c:if> >
 					  		<td style="width:10px;text-align: left;"><img src="<c:url value='/images/icon/dragpoint.png' />" /></td>
 					  		<td style="width:40px;text-align: center;">
 					  			<input type="hidden" name="prtcpntIndex" id="prtcpntIndex_${prtcpntIdx}" value="${prtcpntIdx}"/>
 					  			<span id="order_${idx.count}">${idx.count}</span>
 					  		</td>
 					  		<td style="width:150px;">
				                <input type="text"  name="prtcpntNm" maxLength="30" id="prtcpntNm_${prtcpntIdx}" value="${prtcpntNm}" class="input_type required" onkeydown="if(event.keyCode==13){findUser($(this),event);}"/>
				                <input type="hidden" name="pcnRschrRegNo" id="pcnRschrRegNo_${prtcpntIdx}" value="${pcnRschrRegNo}"/>
				                <input type="hidden" name="seqAuthor" id="seqAuthor_${prtcpntIdx}" value="N"/>
 					  		</td>
 					  		<td style="width:150px;">
 					  		    <input type="text" name="prtcpntFullNm" maxLength="100" id="prtcpntFullNm_${prtcpntIdx}" value="${prtcpntFullNm}" class="input_type" onkeydown="if(event.keyCode==13){findUser($(this),event);}"/>
 					  		</td>
 					  		<td style="width:80px;">
 					  		   <select name="tpiDvsCd" id="tpiDvsCd_${prtcpntIdx}" class="select_type">${rims:makeCodeList('1340', true, '') }</select>
 					  		</td>
 					  		<td style="width:160px;">
 					  			<span class="ck_bt_box">
	 					  			<input type="text" name="prtcpntId" style="width: 80px;" id="prtcpntId_${prtcpntIdx}" value="${prtpntId}" class="input_type"/>
	 					  			<span class="ck_r_bt">
										<a href="javascript:void(0);" class="tbl_icon_a tbl_search_icon" onclick="findUser($(this),event);">검색</a>
										<a href="javascript:void(0);" class="tbl_icon_a tbl_trash_icon" onclick="clearPrtcpnt($(this));">지우기</a>
									</span>
								</span>
 					  		</td>
 					  		<td style="width:160px">
 					  		  <div class="r_add_bt">
		               		  <input type="hidden" name="blngAgcCd" id="blngAgcCd_${prtcpntIdx}"   value="${blngAgcCd}"/>
		                	  <input type="text" name="blngAgcNm" id="blngAgcNm_${prtcpntIdx}" value="${blngAgcNm}"  class="input_type" onkeydown="if(event.keyCode==13){getCodeOrgWin($(this),event);}"/>
							  <span class="r_span_box">
								<a href="javascript:void(0);" class="tbl_icon_a tbl_search_icon" onclick="getCodeOrgWin($(this),event);">검색</a>
							  </span>
							  </div>
							  <input type="hidden" name="recordStatus" id="recordStatus_${prtcpntIdx}" />
							  <input type="hidden" name="isRecord"  id="isRecord_${prtcpntIdx}" value="Y"/>
			                  <input type="hidden" name="tpiRate" value="_blank"/>
			                  <input type="hidden" name="dgrDvsCd" value="_blank"/>
			                  <input type="hidden" name="posiCd" value="_blank"/>
 					  		</td>
 					  		<td style="width:60px;">
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
			<th><spring:message code='book.org.file'/></th>
			<td colspan="5">
				<div class="fileupload_box">
				<c:set var="fIdx" value="0"/>
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
			<th>URL</th>
			<td colspan="5">
				<div class="r_add_bt">
					<input type="text" name="url" id="url" class="input_type" value=""><br>
					<span class="r_span_box">
						<a href="javascript:void(0);" onclick="if($('#url').val()) window.open($('#url').val());" target="_blank" class="tbl_icon_a tbl_link_icon">링크</a>
					</span>
				</div>
			</td>
		</tr>
		<c:choose>
			<c:when test="${sessionScope.login_user.adminDvsCd eq 'M' || sessionScope.login_user.adminDvsCd eq 'P'}">
				<tr>
					<th><spring:message code='book.author.keyword'/></th>
					<td colspan="5">
						<input type="text"  id="authorKeyword" name="authorKeyword" class="input_type" maxlength="1000" value=""/>
					</td>
				</tr>
				<tr>
					<th><spring:message code='book.vrfc.dvs.cd'/></th>
					<td>
						${rims:codeValue('1420', '')}
						<span id="vrfcDvsValue"></span>
					</td>
					<th><spring:message code='book.vrfc.date'/>

					</th>
					<td>
						<span id="vrfcDate"></span>
					</td>
					<th rowspan="2"><spring:message code='book.rtrn'/><br/></th>
					<td rowspan="2">
						<div class="tbl_textarea">
							<textarea maxLength="4000" rows="3" id="apprRtrnCnclRsnCntn" name="apprRtrnCnclRsnCntn" class="textarea_type"></textarea>
						</div>
					</td>
				</tr>
				<tr>
					<th><spring:message code='book.appr.dvs.cd'/></th>
					<td>
						<select id="apprDvsCdValue" name="apprDvsCd"  class="select_type">${rims:makeCodeList('1400', true, '1')}</select>
					</td>
					<th><spring:message code='book.appr.dvs.date'/></th>
					<td></td>
				</tr>
			</c:when>
			<c:otherwise>
				<tr>
					<th><spring:message code='book.vrfc.dvs.cd'/></th>
					<td></td>
					<th><spring:message code='book.vrfc.date'/></th>
					<td>
						<span id="vrfcDate"></span>
					</td>
					<th rowspan="2"><spring:message code='book.rtrn'/><br/></th>
					<td rowspan="2"></td>
				</tr>
				<tr>
					<th><spring:message code='book.appr.dvs.cd'/></th>
					<td>
						<input type="hidden" name="apprDvsCd" id="apprDvsCd" value="1" />
					</td>
					<th><spring:message code='book.appr.dvs.date'/></th>
					<td></td>
				</tr>
			</c:otherwise>
		</c:choose>
	</tbody>
  </table>
</form>
<form id="removeFormArea" action="${contextPath}/book/removeBook.do" method="post">
  <input type="hidden" name="bookId" value="${book.bookId}"/>
</form>
<form id="userRemoveFormArea" action="${contextPath}/book/userRemoveBook.do" method="post">
  <input type="hidden" name="bookId" value="${book.bookId}"/>
  <input type="hidden" name="srchUserId" value="${sessionScope.sess_user.userId}"/>
</form>
<form id="repairFormArea" action="${contextPath}/book/repairBook.do" method="post">
  <input type="hidden" name="bookId" value="${book.bookId}"/>
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
</script>
