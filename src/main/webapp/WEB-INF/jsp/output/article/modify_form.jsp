<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../pageInit.jsp" %>
<c:set var="rschRequiredClass" value=""/><c:set var="rschEssentialTh" value=""/><c:set var="rschReadonly" value=""/>
 	<c:if test="${sessionScope.auth.adminDvsCd eq 'R' or sessionScope.auth.adminDvsCd eq 'S'}">
		<c:set var="rschRequiredClass" value="required"/><c:set var="rschEssentialTh" value="essential_th"/><c:set var="rschReadonly" value="readonly='readonly'"/>
 	</c:if>
<c:set var="adminEssentialTh" value=""/><c:set var="adminRequiredClass" value=""/>
<c:if test="${sessionScope.auth.adminDvsCd eq 'M'}">
	<c:set var="adminRequiredClass" value="required"/><c:set var="adminEssentialTh" value="essential_th"/>
</c:if>

<form id="formArea" action="<c:url value="/${preUrl}/article/modifyArticle.do"/>" method="post" enctype="multipart/form-data"  >
  <input type="hidden" id="articleId" name="articleId" value="${article.articleId}" />
  <input type="hidden" id="listUrl" name="listUrl" value="<c:url value="/article/findArticleList.do"/>"/>
  <input type="hidden" name="deleteUser" value="N" />
  <input type="hidden" name="relisUser" value="N" />


  <c:set  var="apprDvsCd" value="${empty article.apprDvsCd ? '1' : article.apprDvsCd}" />
  <c:if test="${sessionScope.auth.adminDvsCd ne 'M' and sessionScope.auth.adminDvsCd ne 'P' }">
	  <input type="hidden" name="sciAt" value="<c:out value="${article.sciAt}"/>" />
	  <input type="hidden" name="scopusAt" value="<c:out value="${article.scopusAt}"/>" />
	  <input type="hidden" name="kciAt" value="<c:out value="${article.kciAt}"/>">
	  <input type="hidden" name="insttRsltAt" value="<c:out value="${article.insttRsltAt}"/>" />
	  <input type="hidden" name="openAccesAt" value="<c:out value="${article.openAccesAt}"/>" />
	  <input type="hidden" name="docType" value="<c:out value="${article.docType}"/>" />
	  <input type="hidden" name="sc" value="<c:out value="${article.sc}"/>" />
	  <input type="hidden" name="wc" value="<c:out value="${article.wc}"/>" />
	  <input type="hidden" name="plusKeyword" value="<c:out value="${article.plusKeyword }"/>" />
	  <input type="hidden" name="authorKeyword" value="<c:out value="${article.authorKeyword }"/>" />
	  <input type="hidden" name="cntcSystemInfoOthbcYn" value="<c:out value="${article.cntcSystemInfoOthbcYn }"/>" />
	  <input type="hidden" name="wosDocType" value="<c:out value="${article.wosDocType}"/>" />
	  <input type="hidden" name="scpDocType" value="<c:out value="${article.scpDocType}"/>" />
  </c:if>

  <c:if test="${sessMode or sessionScope.auth.adminDvsCd eq 'R' or sessionScope.auth.adminDvsCd eq 'S' }">
	  <c:if test="${not empty article.postFile}"><input type="hidden" name="postIrOpen" value="<c:out value="${article.postFile.irOpen}"/>" /></c:if>
	  <c:if test="${not empty article.pubFile}"><input type="hidden" name="pubIrOpen" value="<c:out value="${article.pubFile.irOpen}"/>" /></c:if>
  </c:if>



<div id="mainTabbar" style="position: relative; width: 100%;height: 100%; overflow: visible;"></div>
<c:if test="${sessMode or (sessionScope.auth.adminDvsCd eq 'R' or sessionScope.auth.adminDvsCd eq 'S' )}">
<div id="reqItem" style="overflow: auto;width: 100%;height: 100%;position: relative;">
</c:if>
  <table id="reqTbl" class="write_tbl"  >
	<colgroup>
		<col style="width:140px;" />
		<col style="width:171px;" />
		<col style="width:140px" />
		<col style="width:171px;" />
		<col style="width:140px" />
		<col style="" />
	</colgroup>
	<tbody>
<c:if test="${sessMode or (sessionScope.auth.adminDvsCd eq 'R' or sessionScope.auth.adminDvsCd eq 'S' )}">
		<tr style="height: 35px;">
			<th><spring:message code="art.reprsnt.article.at"/></th>
			<td colspan="5">
				<spring:message code="common.radio.yes"/> <input type="radio" name="isReprsntArticle" value="Y" ${not empty article.isReprsntArticle and article.isReprsntArticle eq 'Y' ? 'checked="checked"' : '' }/>
				&nbsp;&nbsp;&nbsp;<spring:message code="common.radio.no"/> <input type="radio" name="isReprsntArticle" value="N" ${empty article.isReprsntArticle or article.isReprsntArticle eq 'N' ? 'checked="checked"' : '' }/>
			</td>
		</tr>
</c:if>
		<tr>
			<th class="add_help">
				<spring:message code='art.scjnl.dvs.cd'/><a href="javascript:void(0);" onclick="showTooltip($(this))" class="tbl_help_a"></a>
				<p class="th_help_box"><span><spring:message code='tooltip.art1'/></span></p>
			</th>
			<td>
				<span id="scjnlDvsSpan" style="color: #afafaf">${rims:codeValue('1100',article.scjnlDvsCd)}</span>
				<input type="hidden" name="scjnlDvsCd" id="scjnlDvsCd" value="<c:out value="${article.scjnlDvsCd}"/>" />
			</td>
			<th id="artOvrsTh"><spring:message code='art.scjnl.detail.cd'/></th>

			<td id="scjnlDetailTd">
				<span id="scjnlDetailSpan" style="color: #afafaf"></span>
				<c:choose>
					<c:when test="${article.apprDvsCd eq '3' and (sessMode or (sessionScope.auth.adminDvsCd eq 'R' or sessionScope.auth.adminDvsCd eq 'S' ))}">
						<input type="hidden" name="ovrsExclncScjnlPblcYn" id="ovrsExclncScjnlPblcYn" value="<c:out value="${article.ovrsExclncScjnlPblcYn}"/>" />
					</c:when>
					<c:otherwise>
						<select name="ovrsExclncScjnlPblcYn" id="ovrsExclncScjnlPblcYn" class="select_type">${rims:makeCodeList('1380', true, article.ovrsExclncScjnlPblcYn)}</select>
					</c:otherwise>
				</c:choose>
				<c:choose>
					<c:when test="${article.apprDvsCd eq '3' and (sessMode or (sessionScope.auth.adminDvsCd eq 'R' or sessionScope.auth.adminDvsCd eq 'S' ))}">
						<input type="hidden" name="krfRegPblcYn" id="krfRegPblcYn" value="<c:out value="${article.krfRegPblcYn}"/>" />
					</c:when>
					<c:otherwise>
						<select name="krfRegPblcYn" id="krfRegPblcYn" class="select_type">${rims:makeCodeList('1390', true, article.krfRegPblcYn)}</select>
					</c:otherwise>
				</c:choose>
			</td>
			<%--
			<td id="artOvrsTd" >
				<span id="scjnlDetailSpan" style="color: #afafaf">
					<c:if test="${not empty article.ovrsExclncScjnlPblcYn}">
						${rims:codeValue('1380',article.ovrsExclncScjnlPblcYn)}
					</c:if>
					<c:if test="${empty article.ovrsExclncScjnlPblcYn and not empty article.ovrsExclncScjnlPblcYn}">
						${rims:codeValue('1390',article.krfRegPblcYn)}
					</c:if>
				</span>
				<input type="hidden" name="ovrsExclncScjnlPblcYn" id="ovrsExclncScjnlPblcYn" value="<c:out value="${article.ovrsExclncScjnlPblcYn}"/>" />
				<input type="hidden" name="krfRegPblcYn" id="krfRegPblcYn" value="<c:out value="${article.krfRegPblcYn}"/>" />
			</td>
			--%>
			<%--
			<th class="add_help" id="krfRegTh">
				<spring:message code='art.krf.reg.pblc'/><a href="javascript:void(0);" onclick="showTooltip($(this))" class="tbl_help_a"></a>
				<p class="th_help_box"><span><spring:message code='tooltip.art2'/></span></p>
			</th>
			<td id="krfRegTd">
				<span id="krfRegSpan" style="color: #afafaf">${rims:codeValue('1390',article.krfRegPblcYn)}</span>
			</td>
			--%>
			<th><spring:message code='art.pblc.language'/></th>
			<td>
				<select name="pprLangDvsCd" id="pprLangDvsCd" class="select_type">${rims:makeCodeList('2020',true,article.pprLangDvsCd)}</select>
			</td>
		</tr>
		<tr style="height: 37px;">
			<th class="${adminEssentialTh}"><spring:message code='art.scjnl.regist.cd'/></th>
			<td colspan="5">
				<input type="checkbox" id="isSci" name="isSci"  value="Y" class="radio regst_info" ${not empty article.isSci and article.isSci  eq 'Y' ? 'checked="checked"' : '' } onclick="regstOnClick($(this))"  ${rschReadonly} />
				<label for="isSci" class="radio_label">SCI</label>
				<input type="checkbox" id="isScie" name="isScie"  value="Y" class="radio regst_info" ${not empty article.isScie and article.isScie  eq 'Y' ? 'checked="checked"' : '' } onclick="regstOnClick($(this))" ${rschReadonly}/>
				<label for="isScie" class="radio_label">SCIE</label>
				<input type="checkbox" id="isSsci" name="isSsci"  value="Y" class="radio regst_info" ${not empty article.isSsci and article.isSsci  eq 'Y' ? 'checked="checked"' : '' } onclick="regstOnClick($(this))" ${rschReadonly}/>
				<label for="isSsci" class="radio_label">SSCI</label>
				<input type="checkbox" id="isAhci" name="isAhci"  value="Y" class="radio regst_info" ${not empty article.isAhci and article.isAhci  eq 'Y' ? 'checked="checked"' : '' } onclick="regstOnClick($(this))" ${rschReadonly}/>
				<label for="isAhci" class="radio_label">A&HCI</label>
				<input type="checkbox" id="isScopus" name="isScopus"  value="Y" class="radio regst_info" ${not empty article.isScopus and article.isScopus  eq 'Y' ? 'checked="checked"' : '' } onclick="regstOnClick($(this))" ${rschReadonly}/>
				<label for="isScopus" class="radio_label">SCOPUS</label>
				<input type="checkbox" id="isEsci" name="isEsci"  value="Y" class="radio regst_info" ${not empty article.isEsci and article.isEsci  eq 'Y' ? 'checked="checked"' : '' } onclick="regstOnClick($(this))" ${rschReadonly}/>
				<label for="isEsci" class="radio_label">ESCI</label>
				<input type="checkbox" id="isForeign" name="isForeign"  value="Y" class="radio regst_info" ${not empty article.isForeign and article.isForeign  eq 'Y' ? 'checked="checked"' : '' } onclick="regstOnClick($(this))" ${rschReadonly}/>
				<label for="isForeign" class="radio_label"><spring:message code='art.scjnl.intl.cd'/></label>
				<input type="checkbox" id="isKci" name="isKci"  value="Y" class="radio regst_info" ${not empty article.isKci and article.isKci  eq 'Y' ? 'checked="checked"' : '' } onclick="regstOnClick($(this))" ${rschReadonly}/>
				<label for="isKci" class="radio_label"><spring:message code='art.scjnl.nrf.cd'/></label>
				<input type="checkbox" id="isKciCandi" name="isKciCandi"  value="Y" class="radio regst_info" ${not empty article.isKciCandi and article.isKciCandi  eq 'Y' ? 'checked="checked"' : '' } onclick="regstOnClick($(this))" ${rschReadonly}/>
				<label for="isKciCandi" class="radio_label"><spring:message code='art.scjnl.nrf.candi.cd'/></label>
				<input type="checkbox" id="isDomestic" name="isDomestic"  value="Y" class="radio regst_info" ${not empty article.isDomestic and article.isDomestic  eq 'Y' ? 'checked="checked"' : '' } onclick="regstOnClick($(this))" ${rschReadonly}/>
				<label for="isDomestic" class="radio_label"><spring:message code='art.scjnl.domestic.cd'/></label>
				<input type="checkbox" id="isOther" name="isOther"  value="Y" class="radio regst_info" ${not empty article.isOther and article.isOther  eq 'Y' ? 'checked="checked"' : '' } onclick="regstOnClick($(this))" ${rschReadonly}/>
				<label for="isOther" class="radio_label"><spring:message code='art.scjnl.other.cd'/></label>
			</td>
		</tr>
		<tr>
			<th class="essential_th add_help">
				<spring:message code='art.scjnl.nm'/><a href="javascript:void(0);" onclick="showTooltip($(this))" class="tbl_help_a"></a>
				<p class="th_help_box"><span><spring:message code='tooltip.art4'/></span></p>
			</th>
			<td colspan="3">
				<div <c:if test="${sessionScope.auth.adminDvsCd ne 'R' and  sessionScope.auth.adminDvsCd ne 'S' }">class="r_add_bt"</c:if> >
					<input type="text" maxLength="300" id="scjnlNm" name="scjnlNm" class="required input_type" value="<c:out value="${article.scjnlNm}"/>" onkeydown="if(event.keyCode==13){findJournalFromExtrlSource($('#scjnlNm'));}" />
					<c:if test="${sessionScope.auth.adminDvsCd ne 'R' and  sessionScope.auth.adminDvsCd ne 'S' }">
						<a href="javascript:void(0);" onclick="findJournalFromExtrlSource($('#scjnlNm'));" class="tbl_search_bt">검색</a>
					</c:if>
        		</div>
			</td>
			<th>
				<spring:message code='art.issn.no'/>
			</th>
			<td>
				<div <c:if test="${sessionScope.auth.adminDvsCd ne 'R' and  sessionScope.auth.adminDvsCd ne 'S' }">class="r_add_bt"</c:if>>
	        		<input type="text" name="issnNo"  maxLength="9" id="issnNo" class="input_type" value="<c:out value="${article.issnNo}"/>" />
					<c:if test="${sessionScope.auth.adminDvsCd ne 'R' and  sessionScope.auth.adminDvsCd ne 'S' }">
						<a href="javascript:void(0);" onclick="findJournalFromExtrlSource($('#issnNo'));" class="tbl_search_bt">검색</a>
					</c:if>
					<input type="hidden" name="orgIssnNo"  value="<c:out value="${article.issnNo}"/>"/>
		        </div>
			</td>
		</tr>
		<tr>
			<th class="essential_th">
				<spring:message code='art.pblc.plc'/>
			</th>
			<td colspan="3">
				<input type="text" id="pblcPlcNm" maxLength="150" name="pblcPlcNm" class="input_type required" value="<c:out value="${article.pblcPlcNm}"/>" />
			</td>
			<th class="essential_th">
				<spring:message code='art.pblc.ntn'/>
			</th>
			<td>
		        <select name="pblcNtnCd" id="pblcNtnCd" class="select_type required">
		          	${rims:makeCodeList('2000', true, article.pblcNtnCd) }
		        </select>
		        <script type="text/javascript">
		        	jQuery(document).ready(function(){ $('#pblcNtnCd > option').eq(9).after($('<option value="">====================</option>')); });
		        </script>
			</td>
		</tr>
		<tr>
			<th class="essential_th add_help">
				<spring:message code='art.pblc.ym'/><a href="javascript:void(0);" onclick="showTooltip($(this))" class="tbl_help_a"></a>
				<p class="th_help_box"><span><spring:message code='tooltip.art5'/></span></p>
			</th>
			<td colspan="5">
		  	  <input type="text" name="pblcYear" id="pblcYear" class="input_type required" style="width: 80px;" value="<c:out value="${article.pblcYear}"/>" />&nbsp;<spring:message code='common.year'/>&nbsp;&nbsp;
			  <c:if test="${article.pblcYear eq 'ACCEPT' }">
	              <input type="text" name="pblcMonth" id="pblcMonth" class="input_type" style="width: 45px;" value="" />&nbsp;<spring:message code='common.month'/>&nbsp;&nbsp;
	             <c:if test="${not empty sysConf['article.pblcday.input.at'] and sysConf['article.pblcday.input.at'] eq 'Y' }">
	              <input type="text" name="pblcDay" id="pblcDay" class="input_type" style="width: 45px;" value="" />&nbsp;<spring:message code='common.day'/>&nbsp;&nbsp;
	             </c:if>
			  </c:if>
			  <c:if test="${article.pblcYear ne 'ACCEPT' }">
	              <input type="text" name="pblcMonth" id="pblcMonth" class="input_type" style="width: 45px;" value="<c:out value="${article.pblcMonth}"/>" />&nbsp;<spring:message code='common.month'/>&nbsp;&nbsp;
	             <c:if test="${not empty sysConf['article.pblcday.input.at'] and sysConf['article.pblcday.input.at'] eq 'Y' }">
	              <input type="text" name="pblcDay" id="pblcDay" class="input_type" style="width: 45px;" value="<c:out value="${article.pblcDay}"/>" />&nbsp;<spring:message code='common.day'/>&nbsp;&nbsp;
	             </c:if>
			  </c:if>
              <a href="javascript:void(0);" onclick="clearPblc();" class="int_del">입력삭제</a>
              <p class="tbl_addbt_p">
	              <a href="javascript:void(0);" onclick="pblcAccept();" class="accept_bt">Accept</a>
	              <spring:message code='art.accept.comment'/> <spring:message code='art.online.comment'/>
              </p>
			</td>
		</tr>
		<tr>
			<th class="add_help">
				<spring:message code='art.volume'/><a href="javascript:void(0);" onclick="showTooltip($(this))" class="tbl_help_a"></a>
				<p class="th_help_box"><span><spring:message code='tooltip.art6'/></span></p>
			</th>
			<td>
				Vol. <input type="text" name="volume" id="pblcVolume" class="input_type" style="width: 50px;" maxLength="10" value="<c:out value="${article.volume}"/>" />
			</td>
			<th>
				<spring:message code='art.issue'/>
			</th>
			<td>
				No. <input type="text" name="issue" id="pblcIssue" class="input_type" style="width: 50px;" maxLength="10" value="<c:out value="${article.issue}"/>" />
			</td>
			<th class="add_help">
				<spring:message code='art.page'/><a href="javascript:void(0);" onclick="showTooltip($(this))" class="tbl_help_a"></a>
				<p class="th_help_box"><span><spring:message code='tooltip.art8'/></span></p>
			</th>
			<td>
				<input type="text" name="sttPage" class="input_type" id="sttPage" maxLength="10" value="<c:out value="${article.sttPage}"/>" style="width: 50px;" />
				- <input type="text" name="endPage" class="input_type" id="endPage" maxLength="10" value="<c:out value="${article.endPage}"/>" style="width: 50px;" />
			</td>
		</tr>
		<tr>
			<th class="add_help">
				Impact Factor<a href="javascript:void(0);" onclick="showTooltip($(this))" class="tbl_help_a"></a>
				<p class="th_help_box"><span><spring:message code='tooltip.art7'/></span></p>
			</th>
			<td>
			  <c:if test="${sessionScope.auth.adminDvsCd eq 'M'}">
			  <div class="r_add_bt">
                <input type="text" name="impctFctr" id="impctFctr" class="input_type"  value="<c:out value="${article.impctFctr}"/>" />
                <a href="javascript:void(0);" onclick="findImpactIndexByIssnAndIndexType('if');" class="tbl_search_bt">검색</a>
              </div>
			  </c:if>
			  <c:if test="${sessionScope.auth.adminDvsCd ne 'M'}">
                <input type="hidden" name="impctFctr" id="impctFctr" value="<c:out value="${article.impctFctr}"/>" />
                <span id="impctFctrView" style="color: gray;"><c:out value="${empty article.impctFctr ? '없음' : article.impctFctr}"/></span>
			  </c:if>
			</td>
			<th><spring:message code='art.corprRsrchDvsCd'/></th>
			<td>
				<select name="corprRsrchDvsCd" id="corprRsrchDvsCd" class="select_type">
					${rims:makeCodeList('corpr.rsrch.dvs', true, article.corprRsrchDvsCd) }
				</select>
			</td>
			<td colspan="2">
			</td>
			<%--<th>ORNIF</th>
			<td>
			  <c:if test="${sessionScope.auth.adminDvsCd eq 'M'}">
                 <div class="r_add_bt">
                    <input type="text" name="ornif" id="ornif" class="input_type"  value="<c:out value="${article.ornif}"/>" />
                     <a href="javascript:void(0);" onclick="findImpactIndexByIssnAndIndexType('ornif');" class="tbl_search_bt">검색</a>
                 </div>
			  </c:if>
			  <c:if test="${sessionScope.auth.adminDvsCd ne 'M'}">
                <input type="hidden" name="ornif" id="ornif" value="<c:out value="${article.ornif}"/>" />
                <span id="impctFctrView" style="color: gray;"><c:out value="${empty article.ornif ? '없음' : article.ornif}" /></span>
			  </c:if>
			</td>
			<th>SJR</th>
			<td>
			  <c:if test="${sessionScope.auth.adminDvsCd eq 'M'}">
			   <div class="r_add_bt">
                	<input type="text" name="sjr" id="sjr" class="input_type" value="<c:out value="${article.sjr}"/>" />
				   	<a href="javascript:void(0);" onclick="findImpactIndexByIssnAndIndexType('sjr');" class="tbl_search_bt">검색</a>
			   </div>
			  </c:if>
			  <c:if test="${sessionScope.auth.adminDvsCd ne 'M'}">
                <input type="hidden" name="sjr" id="sjr" value="<c:out value="${article.sjr}"/>" />
                <span id="impctFctrView" style="color: gray;"><c:out value="${empty article.sjr ? '없음' : article.sjr}"/></span>
			  </c:if>
			</td>--%>
		</tr>
		<tr>
			<th class="essential_th">
				<spring:message code='art.title.org'/>
			</th>
			<td colspan="5">
				<div class="tbl_textarea">
					<textarea name="orgLangPprNm" maxLength="1000" rows="3" id="orgLangPprNm" class="required" ><c:out value="${article.orgLangPprNm}"/></textarea>
				</div>
			</td>
		</tr>
		<tr>
			<th>
				<spring:message code='art.title.diff'/>
			</th>
			<td colspan="5">
				<div class="tbl_textarea">
					<textarea name="diffLangPprNm" maxLength="1000" rows="2" id="diffLangPprNm" ><c:out value="${article.diffLangPprNm}"/></textarea>
				</div>
			</td>
		</tr>
		<tr>
			<th class="add_help ${rschEssentialTh}" rowspan="2">
				<spring:message code='art.rsrchacps'/><a href="javascript:void(0);" onclick="showTooltip($(this))" class="tbl_help_a"></a>
				<p class="th_help_box"><span><spring:message code='tooltip.art9'/></span></p>
			</th>
			<td rowspan="2">
				<div class="r_add_bt">
					<span class="add_int_del">
					<c:set var="resAreaValue" value="${pageContext.response.locale eq 'en' ? article.rsrchacpsStdySpheEngValue : article.rsrchacpsStdySpheValue }" />
				        <input type="text" name="rsrchacpsStdySpheCdValue" id="rsrchacpsStdySpheCdValue" class="input_type ${rschRequiredClass}" value="<c:out value="${resAreaValue}"/>" onclick="javascript:findResArea('rsrchacpsStdySpheCd','7',$('#rsrchacpsStdySpheCdValue').val(),event);" readonly="readonly" />
				        <input type="hidden" name="rsrchacpsStdySpheCd" id="rsrchacpsStdySpheCdKey"  class="input_type ${rschRequiredClass}" value="<c:out value="${article.rsrchacpsStdySpheCd}"/>" />
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
			<th class="${rschEssentialTh}" rowspan="2"><spring:message code='art.sbjt.no'/></th>
			<td colspan="3">
				<input type="checkbox" id="relateFundingAt" name="relateFundingAt" value="N" ${article.relateFundingAt eq 'N' ? 'checked="checked"' : '' }/><spring:message code="art.relate.funding.lable" />
			</td>
		</tr>
		<tr>
			<td colspan="3" style="padding: 1px 1px;">
				<table class="in_tbl">
					<colgroup>
						<col style="width:26%;" />
						<col style="width:62%;" />
						<col style="width:200px;" />
					</colgroup>
					<tbody>
						<c:forEach items="${article.fundingMapngList}" var="fml" varStatus="idx">
						<tr>
							<td>
								<input type="text" name="sbjtNo" id="sbjtNo_${idx.count}" value="<c:out value="${fml.sbjtNo}"/>" class="input_type"  readonly="readonly" />
								<input type="hidden" name="seqNo"  id="seqNo_${idx.count}" value="${empty fml.seqNo ? '_blank' : fml.seqNo}" />
								<input type="hidden" name="fundIndex"  id="fundIndex_${idx.count}" value="${idx.count}">
							</td>
							<td>
								<div class="r_add_bt">
			               		  <input type="hidden" name="fundingId" id="fundingId_${idx.count}" value="${fml.fundingId}" />
			                	  <input type="text" name="rschSbjtNm" id="rschSbjtNm_${idx.count}" class="input_type" value="<c:out value="${fml.rschSbjtNm}"/>" onkeydown="if(event.keyCode==13){findFunding($(this),event);}" />
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
						<c:set var="fundingIdx" value="${idx.count}"/>
						</c:forEach>
						<script type="text/javascript">var fundingIdx = '${fundingIdx}';</script>
					</tbody>
				</table>
			</td>
		</tr>
		<tr>
			<th><spring:message code='art.authors'/></th>
			<td colspan="5">
				<div class="writer_td_inner">
				  <em class="td_left_ex">ex) Eng : Hong, Gil dong / Kor : 홍길동</em>
				  <p><spring:message code="art.total.author"/>
				  	<input type="text"  name="totalAthrCnt" id="totalAthrCnt" maxlength="4" class="input_type" style="width:40px;text-align: center;" onchange="CheckValue();" value="<c:out value="${article.totalAthrCnt}"/>" />
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
			              <th colspan="2" style="width: 50px;"><spring:message code='art.order'/></th>
			              <th style="width: 90px;" class="essential_th"><spring:message code='art.short.name'/></th>
			              <th style="width: 110px;"><spring:message code='art.full.name'/></th>
			              <th style="width: 80px;"><spring:message code='art.tpi.dvs'/></th>
			              <th style="width: 160px;"><spring:message code='art.user.id'/></th>
			              <th style="width: 110px;"><spring:message code='art.author.posi'/></th>
			              <th style="width: 150px;"><spring:message code='art.agc.nm'/></th>
			              <th style="width: 100px;"><spring:message code='art.author.dept'/></th>
			              <th style="width: 60px;"></th>
					  </tr>
					</thead>
					<tbody id="prtcpntTbody">
					  <c:set var="sessUserConfirmAt" value="false"/>
					  <c:set var="prtcpntIdx" value="1"/>
					  <c:if test="${not empty article.partiList}">
					    <c:forEach items="${article.partiList}" var="pl" varStatus="idx">
 					  	<c:if test="${not empty sessionScope.auth.workTrget and sessionScope.auth.workTrget eq pl.prtcpntId}">style="background-color: #FFCC66;"</c:if>
		                   <td style="width:10px;text-align: left;">
							 <img src="<c:url value='/images/icon/dragpoint.png' />" />
		                   </td>
 					  		<td style="width:40px;text-align: center;">
 					  			<input type="hidden" name="prtcpntIndex" id="prtcpntIndex_${idx.count}" value="${idx.count}"/>
 					  			<span id="order_${idx.count}">${idx.count}</span>
 					  		</td>
 					  		<td style="width:100px;">
				                <input type="text"  name="prtcpntNm" maxLength="30" id="prtcpntNm_${idx.count}" class="input_type required" placeholder="예)Hong, GD" value="<c:out value="${pl.prtcpntNm}"/>" onkeydown="if(event.keyCode==13){findUser($(this),event);}"/>
				                <input type="hidden" name="pcnRschrRegNo" id="pcnRschrRegNo_${idx.count}" value="<c:out value="${pl.pcnRschrRegNo}"/>"/>
				                <input type="hidden" name="seqAuthor" id="seqAuthor_${idx.count}" value="${not empty pl.seqAuthor ? pl.seqAuthor : 'N'}"/>
 					  		</td>
 					  		<td style="width:100px">
 					  		    <input type="text" name="prtcpntFullNm" maxLength="100" id="prtcpntFullNm_${idx.count}" class="input_type" placeholder="예)Hong, Gil Dong" value="<c:out value="${pl.prtcpntFullNm}"/>" onkeydown="if(event.keyCode==13){findUser($(this),event);}"/>
 					  		</td>
 					  		<td style="width:80px;">
 					  		   <select name="tpiDvsCd" id="tpiDvsCd_${idx.count}" class="select_type">${rims:makeCodeList('1180', true, pl.tpiDvsCd) }</select>
 					  		</td>
 					  		<td style="width:160px">
 					  		   <span class="ck_bt_box">
 					  		   	  <span class="add_int_del">
	 					  			<input type="text" name="prtcpntId" style="width: 80px;" id="prtcpntId_${idx.count}" value="<c:out value="${pl.prtcpntId}"/>" class="input_type"/>
									<a href="javascript:void(0);" class="tbl_int_del" onclick="clearPrtcpnt($(this));">지우기</a>
 					  		   	  </span>
 					  		   	<span class="ck_r_bt">
									<a href="javascript:void(0);" class="tbl_icon_a tbl_search_icon" onclick="findUser($(this),event);">검색</a>
 					  		   		<c:if test="${sessionScope.auth.adminDvsCd eq 'M'}">
 					  		   			<input type="checkbox" name="tempChk" id="tempChk_${idx.count}"  onclick="changeIsRecord($(this));" style="vertical-align: middle;"<c:if test="${not empty pl.isRecord and pl.isRecord eq 'Y' }">checked="checked"</c:if>/>
 					  		   			<c:if test="${not empty pl.prtcpntId and ( empty pl.recordStatus or pl.recordStatus ne '1')}">
 					  		   				<a href="javascript:confirmPrtcpnt('${article.articleId}','<c:out value="${pl.prtcpntId}"/>','${idx.count}');" id="prtcpntConfirm_${idx.count}" class="ck_round_bt"><spring:message code='art.user.confirm'/></a>
 					  		   			</c:if>
 					  		   			<c:if test="${not empty pl.prtcpntId and not empty pl.recordStatus and pl.recordStatus eq '1'}">
 					  		   				<a href="javascript:void(0);" class="ck_round_bt ck_round_gray" id="prtcpntConfirm_${idx.count}"><spring:message code='art.user.noconfirm'/></a>
 					  		   			</c:if>
 					  		   		</c:if>
 					  		   		<c:if test="${sessionScope.auth.adminDvsCd ne 'M'}">
 					  		   			<c:if test="${not empty pl.prtcpntId and (empty pl.recordStatus or pl.recordStatus ne '1')}">
 					  		   				<a href="javascript:confirmPrtcpnt('${article.articleId}','<c:out value="${pl.prtcpntId}"/>','${idx.count}');" class="ck_round_bt" id="prtcpntConfirm_${idx.count}"><spring:message code='art.user.confirm'/></a>
 					  		   			</c:if>
 					  		   			<c:if test="${not empty pl.prtcpntId and pl.recordStatus eq '1'}">
 					  		   				<a href="javascript:void(0);" class="ck_round_bt ck_round_gray" id="prtcpntConfirm_${idx.count}"><spring:message code='art.user.noconfirm'/></a>
 					  		   			</c:if>
 					  		   		</c:if>
 					  		   	</span>
 					  		   </span>
							   <input type="hidden" name="isRecord"  id="isRecord_${idx.count}"  value="<c:out value="${pl.isRecord}"/>" />
		                	   <input type="hidden" name="recordStatus" id="recordStatus_${idx.count}" value="<c:out value="${pl.recordStatus}"/>"  />
		                	   <c:if test="${( (not empty pl.prtcpntId and pl.prtcpntId eq sessionScope.sess_user.userId) or ( not empty pl.userIdntfr and pl.userIdntfr eq sessionScope.sess_user.uId)) and not empty pl.recordStatus and pl.recordStatus eq '1' }">
		                	   	 <c:set var="sessUserConfirmAt" value="true"/>
		                	   </c:if>
 					  		</td>
							<td style="width: 100px;">
								<select name="posiCd" id="posiCd_${idx.count}" class="select_type">${rims:makeCodeList('prtcpnt.position', true, pl.posiCd)}</select>
								<input type="hidden" name="posiNm" id="posiNm_${idx.count}" value="<c:out value="${pl.posiNm}"/>"/>
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
					  <c:if test="${empty article.partiList}">
	 					  	<tr>
			                   <td style="width:10px;text-align: left;">
								 <img src="<c:url value='/images/icon/dragpoint.png' />" />
			                   </td>
	 					  		<td style="width:40px;text-align: center;">
	 					  			<input type="hidden" name="prtcpntIndex" id="prtcpntIndex_${prtcpntIdx}" value="${prtcpntIdx}"/>
	 					  			<span id="order_${prtcpntIdx}">${prtcpntIdx}</span>
	 					  		</td>
	 					  		<td style="width:100px;">
					                <input type="text"  name="prtcpntNm" maxLength="30" id="prtcpntNm_${prtcpntIdx}" class="input_type required" placeholder="예)Hong, GD" onkeydown="if(event.keyCode==13){findUser($(this),event);}"/>
					                <input type="hidden" name="pcnRschrRegNo" id="pcnRschrRegNo_${prtcpntIdx}" />
					                <input type="hidden" name="seqAuthor" id="seqAuthor_${prtcpntIdx}" value="N"/>
	 					  		</td>
	 					  		<td style="width:100px">
	 					  		    <input type="text" name="prtcpntFullNm" maxLength="100" id="prtcpntFullNm_${prtcpntIdx}" class="input_type" placeholder="예)Hong, Gil Dong" onkeydown="if(event.keyCode==13){findUser($(this),event);}"/>
	 					  		</td>
	 					  		<td style="width:80px;">
	 					  		   <select name="tpiDvsCd" id="tpiDvsCd_${prtcpntIdx}" class="select_type">${rims:makeCodeList('1180', true, '4') }</select>
	 					  		</td>
	 					  		<td style="width:160px">
	 					  		   <span class="ck_bt_box">
	 					  			<input type="text" name="prtcpntId" style="width: 80px;" id="prtcpntId_${prtcpntIdx}" class="input_type"  readonly="readonly" />
	 					  		   	<span class="ck_r_bt">
										<a href="javascript:void(0);" class="tbl_icon_a tbl_search_icon" onclick="findUser($(this),event);">검색</a>
										<a href="javascript:void(0);" class="tbl_icon_a tbl_trash_icon" onclick="clearPrtcpnt($(this));">지우기</a>
	 					  		   		<c:if test="${sessionScope.login_user.adminDvsCd eq 'M'}">
	 					  		   			<input type="checkbox" name="tempChk" id="tempChk_${prtcpntIdx}"  onclick="changeIsRecord($(this));" style="vertical-align: middle;"/>
	 					  		   		</c:if>
	 					  		   	</span>
	 					  		   </span>
								   <input type="hidden" name="isRecord"  id="isRecord_${prtcpntIdx}"/>
			                	   <input type="hidden" name="recordStatus" id="recordStatus_${prtcpntIdx}" />
	 					  		</td>
								<td style="width:100px;">
									<select name="posiCd" id="posiCd_${prtcpntIdx}" class="select_type">${rims:makeCodeList('prtcpnt.position', true, '')}</select>
									<input type="hidden" name="posiNm" id="posiNm_${prtcpntIdx}" value="_blank"/>
								</td>
	 					  		<td style="width:160px">
	 					  		  <div class="r_add_bt">
			               		  <input type="hidden" name="blngAgcCd" id="blngAgcCd_${prtcpntIdx}" />
			                	  <input type="text" name="blngAgcNm" id="blngAgcNm_${prtcpntIdx}" class="input_type" onkeydown="if(event.keyCode==13){getCodeOrgWin($(this),event);}"/>
								  <span class="r_span_box">
									<a href="javascript:void(0);" class="tbl_icon_a tbl_search_icon" onclick="getCodeOrgWin($(this),event);">검색</a>
								  </span>
								  </div>
				                  <input type="hidden" name="tpiRate" value="_blank"/>
				                  <input type="hidden" name="dgrDvsCd" value="_blank"/>
	 					  		</td>
	 					  		<td style="width:100px" class="dispDept"></td>
	 					  		<td style="width:60px">
									<a href="javascript:void(0);" class="tbl_icon_a row_add_bt" onclick="addPrtcpnt($(this),'${sessionScope.login_user.adminDvsCd}')"><spring:message code='common.add'/></a>
									<a href="javascript:void(0);" class="tbl_icon_a red_del" onclick="removePrtcpnt($(this));"><spring:message code='common.row.delete'/></a>
	 					  		</td>
	 					  </tr>
					  </c:if>
					   <script type="text/javascript">var prtcpntIdx = '${prtcpntIdx}';</script>
					</tbody>
				</table>
			</td>
		</tr>
		<tr>
			<th rowspan="2"><spring:message code='art.org.file'/></th>
		</tr>
		<tr>
			<td colspan="5" class="inner_tbl_td">
				<table class="inner_tbl">
					<colgroup>
						<col style="width:245px;">
						<c:if test="${not sessMode and sessionScope.auth.adminDvsCd ne 'R' and  sessionScope.auth.adminDvsCd ne 'S' }">
						<col style="width:120px;">
						<col style="width:87px;">
						</c:if>
						<col style="">
					</colgroup>
					<thead>
					  <tr>
						<th><spring:message code="art.file.type" /></th>
						<c:if test="${not sessMode and sessionScope.auth.adminDvsCd ne 'R' and  sessionScope.auth.adminDvsCd ne 'S' }">
						<th><spring:message code="art.file.open.at" /></th>
						<th><spring:message code="art.file.open.date" /></th>
						</c:if>
						<th><spring:message code="art.file" /></th>
					  </tr>
					</thead>
					<tbody>
					   <tr>
					   	 <td><b><spring:message code="art.file.post.version" /></b></td>
					   	 <c:if test="${not sessMode and sessionScope.auth.adminDvsCd ne 'R' and  sessionScope.auth.adminDvsCd ne 'S' }">
					   	 <td>
							<input type="radio" name="postIrOpen" value="Y" <c:if test="${not empty article.postFile and article.postFile.irOpen eq 'Y' }">checked="checked"</c:if>/>&nbsp;<spring:message code='file.ir.open.y'/>&nbsp;&nbsp;
							<input type="radio" name="postIrOpen" value="N" <c:if test="${empty article.postFile or article.postFile.irOpen eq 'N' }">checked="checked"</c:if>/>&nbsp;<spring:message code='file.ir.open.n'/>
					   	 </td>
					   	 <td>
							<input type="text" id="postIrOpenDate" name="postIrOpenDate" readonly="readonly" class="input_type" value="<fmt:formatDate value="${article.postFile.irOpenDate}" pattern="yyyy-MM-dd" />"/>
					   	 </td>
					   	 </c:if>
					   	 <td>
							<div class="fileupload_box">
							 <c:if test="${not empty article.postFile}">
								<p class="upload_file_text">
									<a href="<c:url value="/servlet/download.do?fileid=${article.postFile.fileId}"/>"><c:out value="${article.postFile.fileNm}"/></a>&nbsp;&nbsp;
									<a href="javascript:void(0);" onclick="removeArticleOrgFile($(this),'Post');" class="del_file">삭제</a>
									<input type="hidden" name="fileId" value="${article.postFile.fileId}"/>
								</p>
							 </c:if>
							 <c:if test="${empty article.postFile}">
							 <ul>
							  <li>
								<span class="upload_int">
									<input type="text" class="up_input" id="fileInputPost" onclick="$('#filePost').trigger('click');" readonly="readonly"/>
									<a href="javascript:void(0);" class="upload_int_bt" onclick="$('#filePost').trigger('click');"><spring:message code="art.file.select" /></a>
									<input type="file"  class="typeFile" style="display: none;" name="filePost"  id="filePost" onchange="$('#fileInputPost').val($(this).val().split('\\').pop());"/>
								</span>
							  </li>
							 </ul>
							 </c:if>
							</div>
					   	 </td>
					   </tr>
					   <tr>
					   	 <td><b><spring:message code="art.file.pub.version" /></b></td>
					   	 <c:if test="${not sessMode and sessionScope.auth.adminDvsCd ne 'R' and  sessionScope.auth.adminDvsCd ne 'S' }">
					   	 <td>
							<input type="radio" name="pubIrOpen" value="Y" <c:if test="${not empty article.pubFile and article.pubFile.irOpen eq 'Y' }">checked="checked"</c:if>/>&nbsp;<spring:message code='file.ir.open.y'/>&nbsp;&nbsp;
							<input type="radio" name="pubIrOpen" value="N" <c:if test="${empty article.pubFile or article.pubFile.irOpen eq 'N' }">checked="checked"</c:if>/>&nbsp;<spring:message code='file.ir.open.n'/>
					   	 </td>
					   	 <td>
							<input type="text" id="pubIrOpenDate" name="pubIrOpenDate" readonly="readonly" class="input_type" value="<fmt:formatDate value="${article.pubFile.irOpenDate}" pattern="yyyy-MM-dd" />"/>
					   	 </td>
					   	 </c:if>
					   	 <td>
							<div class="fileupload_box">
							 <c:if test="${not empty article.pubFile}">
								<p class="upload_file_text">
									<a href="<c:url value="/servlet/download.do?fileid=${article.pubFile.fileId}"/>"><c:out value="${article.pubFile.fileNm}"/></a>&nbsp;&nbsp;
									<a href="javascript:void(0);" onclick="removeArticleOrgFile($(this),'Pub');" class="del_file"><spring:message code="common.button.delete" /></a>
									<input type="hidden" name="fileId" value="${article.pubFile.fileId}"/>
								</p>
							 </c:if>
							 <c:if test="${empty article.pubFile}">
							 <ul>
							  <li>
								<span class="upload_int">
									<input type="text" class="up_input" id="fileInputPub" onclick="$('#filePub').trigger('click');" readonly="readonly"/>
									<a href="javascript:void(0);" class="upload_int_bt" onclick="$('#filePub').trigger('click');"><spring:message code="art.file.select" /></a>
									<input type="file"  class="typeFile" style="display: none;" name="filePub"  id="filePub" onchange="$('#fileInputPub').val($(this).val().split('\\').pop());"/>
								</span>
							  </li>
							 </ul>
							 </c:if>
							</div>
					   	 </td>
					   </tr>
					</tbody>
				</table>
			 </td>
		</tr>

	 </tbody>
  </table>
<c:if test="${sessMode or (sessionScope.auth.adminDvsCd eq 'R' or sessionScope.auth.adminDvsCd eq 'S' )}">
  <table class="write_tbl mgt_10 mgb_10">
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
			<th><spring:message code='art.vrfc.dvs'/></th>
			<td>
				<c:set var="vrfcDvsCd"  value="${empty article.vrfcDvsCd ? '1' : article.vrfcDvsCd}"/>
				<span id="vrfcDvsValue">${rims:codeValue('1420', vrfcDvsCd)}</span>
				<input type="hidden"  name="vrfcDvsCd" id="vrfcDvsCdKey" value="<c:out value="${vrfcDvsCd}"/>"/>
				<input type="hidden"  name="vrfcSrcDvsCd" id="vrfcSrcDvsCd" value="<c:out value="${article.vrfcSrcDvsCd}"/>"/>
				<input type="hidden"  name="vrfcPprId" id="vrfcPprId" value="<c:out value="${article.vrfcPprId}"/>"/>
			</td>
			<th><spring:message code='art.vrfc.dvs.date'/></th>
			<td><span id="vrfcDate"><fmt:formatDate value="${article.vrfcDate}" pattern="yyyy-MM-dd" /></span></td>
			<th rowspan="2"><spring:message code='art.appr.rtrn'/></th>
			<td rowspan="2">
				<c:out value="${article.apprRtrnCnclRsnCntn}"/>
				<input type="hidden" name="apprRtrnCnclRsnCntn" value="<c:out value="${article.apprRtrnCnclRsnCntn}"/>" />
			</td>
		</tr>
		<tr>
			<th><spring:message code='art.appr.dvs'/></th>
			<td>
				${rims:codeValue('art.appr.dvs',apprDvsCd)}
				<input type="hidden" name="apprDvsCd" value="<c:out value="${apprDvsCd}"/>"/>
        		<input type="hidden" id="is_open_files" name="isOpenFiles" value="<c:out value="${article.isOpenFiles}"/>" />
        		<input type="hidden" id="is_open" name="isOpen" value="<c:out value="${article.isOpenFiles}"/>"  />
			</td>
			<th><spring:message code='art.appr.dvs.date'/></th>
			<td>
				<fmt:formatDate value="${article.apprDate}" pattern="yyyy-MM-dd" />
			</td>
		</tr>
		<tr>
			<th><spring:message code='common.reg.date'/></th>
			<td>
				<fmt:formatDate var="regDate" value="${article.regDate}" pattern="yyyy-MM-dd" /> <c:out value="${regDate}"/> ( <c:out value="${empty article.regUserNm ? 'ADMIN' : article.regUserNm}"/> )
			</td>
			<th><spring:message code='common.mod.date'/></th>
			<td>
				<fmt:formatDate var="modDate" value="${article.modDate}" pattern="yyyy-MM-dd" /> <c:out value="${modDate}"/> ( <c:out value="${empty article.modUserNm ? 'ADMIN' : article.modUserNm}"/> )
			</td>
			<th><spring:message code='common.source'/></th>
			<td>
				<c:set var="vrfcSrcDvsCd" value="${empty article.vrfcSrcDvsCd ? '개인' : article.vrfcSrcDvsCd}" />
				${rims:codeValue('1750', vrfcSrcDvsCd)}
			</td>
		</tr>
	  </tbody>
  </table>
</c:if>
<c:if test="${sessMode or (sessionScope.auth.adminDvsCd eq 'R' or sessionScope.auth.adminDvsCd eq 'S' )}">
</div>
<div id="optItem" style="overflow: auto;width: 100%;height: 100%;position: relative;">
</c:if>
  <table id="optTbl" class="write_tbl mgb_10"  <c:if test="${sessionScope.auth.adminDvsCd ne 'R' and sessionScope.auth.adminDvsCd ne 'S' }">style="border-top: 0px;"</c:if> >
	<colgroup>
		<col style="width:140px;" />
		<col style="width:171px;" />
		<col style="width:140px" />
		<col style="width:171px;" />
		<col style="width:140px" />
		<col style="" />
	</colgroup>
	  <tbody>
	  	<tr> <!--  피인용횟수 -->
			<th class="add_help">
				<spring:message code='art.tc'/>
				<a href="javascript:void(0);" onclick="showTooltip($(this))" class="tbl_help_a"></a>
				<p class="th_help_box"><span><spring:message code='tooltip.art12'/></span></p>
			</th>
			<td colspan="5">
				<div class="tbl_num_box">
					WOS&nbsp;:&nbsp;
					<c:if test="${not empty article.idSci and article.idSci != ''}">
						<a href="javascript:tcHisotry('${article.articleId}','${article.idSci}')"><span id="sciTcSpan"><c:out value="${empty article.tc ? 0 : article.tc}"/></span></a>&nbsp;
						<em id="sciTcDateEm"><fmt:formatDate var="tcDate" value="${article.tcDate}" pattern="yyyy-MM-dd" /><c:out value="${tcDate}"/></em>
					</c:if>
					<c:if test="${empty article.idSci}">
						<span id="sciTcSpan" >-</span>&nbsp;
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					</c:if>
					<input type="hidden" name="tc" id="tc" value="<c:out value="${article.tc}"/>">
					SCOPUS&nbsp;:&nbsp;
					<c:if test="${not empty article.idScopus and article.idScopus != ''}">
						<a href="javascript:tcHisotry('${article.articleId}','${article.idScopus}')"><span id="scpTcSpan"><c:out value="${article.scpTc}"/></span></a> &nbsp;
						<em id="scpTcDateEm"><fmt:formatDate var="scpTcDate" value="${article.scpTcDate}" pattern="yyyy-MM-dd" /><c:out value="${scpTcDate}"/></em>
					</c:if>
					<c:if test="${empty article.idScopus}">
						<span id="scpTcSpan">-</span>&nbsp;
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					</c:if>
					<input type="hidden" name="scpTc" id="scp_tc" value="<c:out value="${article.scpTc}"/>">
					KCI&nbsp;:&nbsp;
					<c:if test="${not empty article.idKci and article.idKci != ''}">
						<a href="javascript:tcHisotry('${article.articleId}','${article.idKci}')"><span id="kciTcSpan"><c:out value="${article.kciTc}"/></span></a>&nbsp;
						<em id="kciTcDateEm"><fmt:formatDate var="kciTcDate" value="${article.kciTcDate}" pattern="yyyy-MM-dd" /><c:out value="${kciTcDate}"/></em>
					</c:if>
					<c:if test="${empty article.idKci}">
						<span id="kciTcSpan">-</span>&nbsp;
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					</c:if>
					<input type="hidden" name="kciTc" id="kci_tc" value="<c:out value="${article.kciTc}"/>">
					<a href="javascript:void(0);" onclick="updateTimeCited();" class="tbl_icon_a tbl_refresh_icon">update</a>
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
				<input type="text" name="idSci" id="idSci" class="input_type" value="<c:out value="${article.idSci}"/>"/><br>
				<span class="r_span_box">
					<c:if test="${empty article.idSci}">
						<a href="javascript:void(0);" class="tbl_icon_a tbl_link_n_icon">링크</a>
					</c:if>
					<c:if test="${not empty article.idSci}">
						<a href="<c:out value="${article.wosSourceUrl}"/>" target="_blank" class="tbl_icon_a tbl_link_icon">링크</a>
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
					<input type="text" name="idScopus" id="idScopus" class="input_type" value="<c:out value="${article.idScopus}"/>"/>
				<span class="r_span_box">
					<c:if test="${empty article.idScopus}">
						<a href="javascript:void(0);" class="tbl_icon_a tbl_link_n_icon">링크</a>
					</c:if>
					<c:if test="${not empty article.idScopus}">
						<a href="${sysConf['scopus.search.view.url']}&origin=inward&scp=<c:out value="${fn:replace(article.idScopus,'2-s2.0-','')}"/>" class="tbl_icon_a tbl_link_icon" target="_blank">링크</a>
					</c:if>
				</span>
				<input type="hidden" name="orgIdScopus" value="<c:out value="${article.idScopus}"/>">
			  </div>
			</td>
			<th>KCI ID</th>
			<td>
			  <div class="r_add_bt">
				<input type="text" name="idKci" id="idKci" class="input_type" value="<c:out value="${article.idKci}"/>"/>
				<span class="r_span_box">
					<c:if test="${empty article.idKci}">
						<a href="javascript:void(0);" class="tbl_icon_a tbl_link_n_icon">링크</a>
					</c:if>
					<c:if test="${not empty article.idKci}">
						<a href="${sysConf['kci.search.view.url']}?sereArticleSearchBean.artiId=<c:out value="${article.idKci}"/>" class="tbl_icon_a tbl_link_icon" target="_blank">링크</a>
					</c:if>
				</span>
				<input type="hidden" name="orgIdKci" value="<c:out value="${article.idKci}"/>">
			  </div>
			</td>
		</tr>
		<c:if test="${sessionScope.auth.adminDvsCd eq 'M' or sessionScope.auth.adminDvsCd eq 'P' }">
		<tr>
			<th>Open Access</th>
			<td>
					<spring:message code="common.radio.yes"/><input type="radio" name="openAccesAt" value="Y" ${not empty article.openAccesAt and article.openAccesAt eq 'Y' ? 'checked="checked"' : '' }/>
					&nbsp;&nbsp;&nbsp;<spring:message code="common.radio.no"/> <input type="radio" name="openAccesAt" value="N" ${empty article.openAccesAt or article.openAccesAt eq 'N' ? 'checked="checked"' : '' }/>

			</td>
			<th><spring:message code='art.isother'/></th>
			<td>
					${sysConf['inst.abrv']} <input type="radio" name="insttRsltAt" onchange="changOtherValue(this.value);" value="Y" ${not empty article.insttRsltAt and article.insttRsltAt eq 'Y' ? 'checked="checked"' : '' }/>
					&nbsp;Other <input type="radio" name="insttRsltAt" onchange="changOtherValue(this.value);" value="N" ${empty article.insttRsltAt or article.insttRsltAt eq 'N' ? 'checked="checked"' : '' }/>
					<input type="hidden" value="" name="otherValue" id="otherValue">
			</td>
			<th><spring:message code='art.issource'/></th>
			<td>
					SCI UT 없음 <input type="checkbox" name="sciAt" value="Y" ${not empty article.sciAt and article.sciAt eq 'Y' ? 'checked="checked"' : '' } />
					&nbsp;SCOPUS EID 없음 <input type="checkbox" name="scopusAt" value="Y" ${not empty article.scopusAt and article.scopusAt eq 'Y' ? 'checked="checked"' : '' }/>
					<%--
					&nbsp;KCI <input type="checkbox" name="kciAt" value="Y" ${not empty article.kciAt and article.kciAt eq 'Y' ? 'checked="checked"' : '' }/>
					 --%>
			</td>
		</tr>
		</c:if>
		<tr>
			<th>DOI</th>
			<td colspan="5">
				<div class="r_add_bt">
					http://dx.doi.org/<input type="text" name="doi" id="doi" class="input_type" style="width: 77%;" value="<c:out value="${article.doi}"/>" />
					<span class="r_span_box">
						<c:if test="${empty article.doi}">
							<a href="javascript:void(0);" class="tbl_icon_a tbl_link_n_icon">링크</a>
						</c:if>
						<c:if test="${not empty article.doi}">
							<a href="http://dx.doi.org/<c:out value="${article.doi}"/>" class="tbl_icon_a tbl_link_icon" target="_blank">링크</a>
						</c:if>
					</span>
				</div>
			</td>
		</tr>
		<tr>
			<th>URL</th>
			<td colspan="5">
				<div class="r_add_bt">
					<input type="text" name="url" id="url" class="input_type" value="<c:out value="${article.url}"/>" />
					<span class="r_span_box">
						<c:if test="${empty article.url}">
							<a href="javascript:void(0);" class="tbl_icon_a tbl_link_n_icon">링크</a>
						</c:if>
						<c:if test="${not empty article.url}">
							<a href="<c:out value="${article.url}"/>" class="tbl_icon_a tbl_link_icon" target="_blank">링크</a>
						</c:if>
					</span>
				</div>
			</td>
		</tr>
		<tr>
			<th>
				<spring:message code='art.abst'/>
			</th>
			<td colspan="5">
				<div class="tbl_textarea">
					<textarea name="abstCntn" id="abstCntn" rows="7" maxLength="4000" ><c:out value="${article.abstCntn}"/></textarea>
				</div>
			</td>
		</tr>
		<c:if test="${sessionScope.auth.adminDvsCd eq 'M' or sessionScope.auth.adminDvsCd eq 'P' }">
			<tr>
				<th>
					<spring:message code='art.doc.type.cd'/>
				</th>
				<td>
					<input type="text" name="docType" id="docType"  class="input_type" value="<c:out value="${article.docType}"/>"/>
				</td>
				<th>WOS DOCTYPE</th>
				<td>
					<input type="text" name="wosDocType" id="wosDocType"  class="input_type" value="<c:out value="${article.wosDocType}"/>"/>
				</td>
				<th>SCOPUS DOCTYPE</th>
				<td>
					<input type="text" name="scpDocType" id="scpDocType"  class="input_type" value="<c:out value="${article.scpDocType}"/>"/>
				</td>
			</tr>
			<tr>
				<th>WOS Categories</th>
				<td>
					<input type="text"  id="sc" name="sc" class="input_type" maxlength="1000" value="<c:out value="${article.sc}"/>"/>
				</td>
				<th>WOS Subject Categories</th>
				<td colspan="3">
					<input type="text"  id="wc" name="wc" class="input_type" maxlength="1000" value="<c:out value="${article.wc}"/>"/>
				</td>
			</tr>
			<tr>
				<th>
					<spring:message code='art.author.keyword'/>
				</th>
				<td colspan="5">
					<input type="text"  id="authorKeyword" name="authorKeyword" class="input_type" maxlength="1000" value="<c:out value="${article.authorKeyword}"/>"/>
				</td>
			</tr>
			<tr>
				<th>
					<spring:message code='art.plus.keyword'/>
				</th>
				<td colspan="5">
					<input type="text"  id="plusKeyword" name="plusKeyword" class="input_type" maxlength="1000" value="<c:out value="${article.plusKeyword}"/>"/>
				</td>
			</tr>
		</c:if>
		<c:if test="${not sessMode and sessionScope.auth.adminDvsCd ne 'R' and  sessionScope.auth.adminDvsCd ne 'S' }">
		 <c:if test="${sessionScope.auth.adminDvsCd eq 'M' or  sessionScope.auth.adminDvsCd eq 'P' }">
			<tr>
				<th><spring:message code='art.vrfc.dvs'/></th>
				<td>
					<c:set var="vrfcDvsCd"  value="${empty article.vrfcDvsCd ? '1' : article.vrfcDvsCd}"/>
					<select id="selectVrfcDvsCd" class="select_type" style="width: 100px;" onchange="javascript:$('#vrfcDvsCdKey').val($(this).val());">${rims:makeCodeList('1420', true, vrfcDvsCd) }</select>
					<input type="hidden"  name="vrfcDvsCd" id="vrfcDvsCdKey" value="<c:out value="${vrfcDvsCd}"/>"/>
				</td>
				<th><spring:message code='art.vrfc.dvs.date'/></th>
				<td><span id="vrfcDate"><fmt:formatDate value="${article.vrfcDate}" pattern="yyyy-MM-dd" /></span></td>
				<th rowspan="2"><spring:message code='art.appr.rtrn'/></th>
				<td rowspan="2">
					<div class="r_add_bt">
						<div class="tbl_textarea">
							<textarea maxLength="4000" rows="3" id="appr_rtrn_cncl_rsn_cntn" name="apprRtrnCnclRsnCntn"><c:out value="${article.apprRtrnCnclRsnCntn}"/></textarea>
							<c:if test="${sysConf['mail.use.art.at'] eq 'Y'}">
								<span class="r_span_box">
									<a href="javascript:sendMailArticle('${article.articleId}');" class="tbl_icon_a tbl_mail_icon">전송</a>
								</span>
							</c:if>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<th>검증소스구분</th>
				<td>
					<select id="vrfcSrcDvsCd" name="vrfcSrcDvsCd"  class="select_type" style="width: 100px;">${rims:makeCodeList('art.vrfc.src.cd', true, article.vrfcSrcDvsCd) }</select>
				</td>
				<th>검증소스ID</th>
				<td>
					<input type="text"  id="vrfcPprId" name="vrfcPprId" class="input_type" maxlength="1000" value="<c:out value="${article.vrfcPprId}"/>"/>
				</td>
			</tr>
			<tr>
				<th><spring:message code='art.appr.dvs'/></th>
				<td>
					<select id="apprDvsCdValue" name="apprDvsCd"  class="select_type" style="width: 100px;">${rims:makeCodeList('art.appr.dvs', true, apprDvsCd) }</select>
					<input type="hidden" id="is_open" name="isOpen" value="<c:out value="${article.isOpenFiles}"/>"  />
				</td>
				<th><spring:message code='art.appr.dvs.date'/></th>
				<td><fmt:formatDate value="${article.apprDate}" pattern="yyyy-MM-dd" /></td>
				<th><spring:message code="art.cntcSystem.info.open.yn"/></th>
				<td>
					<spring:message code="common.radio.yes"/> <input type="radio" name="cntcSystemInfoOthbcYn" value="Y" ${empty article.cntcSystemInfoOthbcYn or article.cntcSystemInfoOthbcYn eq 'Y' ? 'checked="checked"' : '' }/>
					&nbsp;&nbsp;&nbsp;<spring:message code="common.radio.no"/> <input type="radio" name="cntcSystemInfoOthbcYn" value="N" ${not empty article.cntcSystemInfoOthbcYn and article.cntcSystemInfoOthbcYn eq 'N' ? 'checked="checked"' : '' }/>
				</td>
			</tr>
		 </c:if>
		<c:if test="${sessionScope.auth.adminDvsCd ne 'M' and sessionScope.auth.adminDvsCd ne 'P' }">
			<tr>
				<th><spring:message code='art.vrfc.dvs'/></th>
				<td>
					<c:set var="vrfcDvsCd"  value="${empty article.vrfcDvsCd ? '1' : article.vrfcDvsCd}"/>
					<span id="vrfcDvsValue">${rims:codeValue('1420', vrfcDvsCd)}</span>
					<input type="hidden"  name="vrfcDvsCd" id="vrfcDvsCdKey" value="<c:out value="${vrfcDvsCd}"/>"/>
					<input type="hidden"  name="vrfcSrcDvsCd" id="vrfcSrcDvsCd" value="<c:out value="${article.vrfcSrcDvsCd}"/>"/>
					<input type="hidden"  name="vrfcPprId" id="vrfcPprId" value="<c:out value="${article.vrfcPprId}"/>"/>
				</td>
				<th><spring:message code='art.vrfc.dvs.date'/></th>
				<td><span id="vrfcDate"><fmt:formatDate value="${article.vrfcDate}" pattern="yyyy-MM-dd" /></span></td>
				<th rowspan="2"><spring:message code='art.appr.rtrn'/></th>
				<td rowspan="2">
					<div class="r_add_bt">
						<div class="tbl_textarea">
							<textarea maxLength="4000" rows="3" id="appr_rtrn_cncl_rsn_cntn" name="apprRtrnCnclRsnCntn"><c:out value="${article.apprRtrnCnclRsnCntn}"/></textarea>
							<c:if test="${sysConf['mail.use.art.at'] eq 'Y'}">
								<span class="r_span_box">
									<a href="javascript:sendMailArticle('${article.articleId}');" class="tbl_icon_a tbl_mail_icon">전송</a>
								</span>
							</c:if>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<th><spring:message code='art.appr.dvs'/></th>
				<td>
					<select id="apprDvsCdValue" name="apprDvsCd"  class="select_type" style="width: 100px;">${rims:makeCodeList('art.appr.dvs', true, apprDvsCd) }</select>
					<input type="hidden" id="is_open" name="isOpen" value="<c:out value="${article.isOpenFiles}"/>"  />
				</td>
				<th><spring:message code='art.appr.dvs.date'/></th>
				<td><fmt:formatDate value="${article.apprDate}" pattern="yyyy-MM-dd" /></td>
			</tr>
		</c:if>


		<tr>
			<th><spring:message code='common.reg.date'/></th>
			<td>
				<fmt:formatDate var="regDate" value="${article.regDate}" pattern="yyyy-MM-dd" /> <c:out value="${regDate}"/> ( <c:out value="${empty article.regUserNm ? 'ADMIN' : article.regUserNm}"/> )
			</td>
			<th><spring:message code='common.mod.date'/></th>
			<td>
				<fmt:formatDate var="modDate" value="${article.modDate}" pattern="yyyy-MM-dd" /> <c:out value="${modDate}"/> ( <c:out value="${empty article.modUserNm ? 'ADMIN' : article.modUserNm}"/> )
			</td>
			<th><spring:message code='common.source'/></th>
			<td>
				<c:set var="vrfcSrcDvsCd" value="${empty article.vrfcSrcDvsCd ? '개인' : article.vrfcSrcDvsCd}" />
				${rims:codeValue('1750', vrfcSrcDvsCd)}
			</td>
		</tr>
		</c:if>
	</tbody>
  </table>
<c:if test="${sessMode or (sessionScope.auth.adminDvsCd eq 'R' or sessionScope.auth.adminDvsCd eq 'S' )}">
</div>
</c:if>
<div id="winVp"></div>
</form>
<form id="removeFormArea" action="<c:url value="/article/removeArticle.do"/>" method="post">
  <input type="hidden" name="articleId" value="${article.articleId}"/>
</form>
<form id="userRemoveFormArea" action="<c:url value="/article/userRemoveArticle.do"/>" method="post">
  <input type="hidden" name="articleId" value="${article.articleId}"/>
  <input type="hidden" name="srchUserId" value="${sessionScope.sess_user.userId}"/>
</form>
<form id="repairFormArea" action="<c:url value="/article/repairArticle.do"/>" method="post">
  <input type="hidden" name="articleId" value="${article.articleId}"/>
</form>
<form name="vrfcFrm" id="vrfcFrm" method="post"></form>
<script type="text/javascript">
var dhxCanlendar, myTabbar;
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
	  changeScjnlDvs();

	  dhxCanlendar = new dhtmlXCalendarObject(["preIrOpenDate","postIrOpenDate","pubIrOpenDate"]);
	  dhxCanlendar.hideTime();
	  dhxCanlendar.loadUserLanguage("ko");
	  dhxCanlendar.attachEvent("onClick", function(date, state){ isChange = true; });

	  if(sessMode == 'true' || loginAuthor == 'R' || loginAuthor == 'S')
	  {
		 var sessUserConfirmAt = '<c:out value="${sessUserConfirmAt}"/>';
		 var articleId = '${article.articleId}';
		 if(sessUserConfirmAt != 'true' && $.cookie('openCheck_'+articleId) != 'done')
		 	$('.top_alert_wrap').css('display','');

		 var topAlert = $('.top_alert_wrap').css('display');
		 var topAlertHeight = topAlert == 'none' ? 0 : $('.top_alert_wrap').height();
		 var hSize = ($(window).height()-(85+$('.title_box').height()+$('.top_help_wrap').height()+$('.list_bt_area').height()+topAlertHeight))+"px";
		 $('#mainTabbar').css({'height':hSize});

		 myTabbar = new dhtmlXTabBar('mainTabbar');
		 myTabbar.setArrowsMode("auto");
		 myTabbar.enableAutoReSize(true);

		 myTabbar.addTab('a1','<spring:message code="art.tab1"/>');
		 myTabbar.addTab('a2','<spring:message code="art.tab2"/>');

		 myTabbar.tabs('a1').attachObject('reqItem');
		 myTabbar.tabs('a2').attachObject('optItem');
		 myTabbar.tabs('a1').setActive();
		 $('#reqTbl').addClass('mgt_10');
		 $('#optTbl').addClass('mgt_10');

	  }

	 makeOrgUserList();
     $('input[type="checkbox"][readonly]').attr('onclick', '').unbind('click').on("click.readonly", function(event){event.preventDefault();}).css("opacity", "0.5");
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

function updateTimeCited(){
	$.ajax({
		url : "<c:url value="/tcUpdate/updateTimeCitedAjax.do"/>",
		 dataType : 'json',
		 data : { "articleId": $('#articleId').val() },
		 success : function(data, textStatus, jqXHR){}
	}).done(function(data){
		var today = getToday();
		today = today.substring(0,4)+"-"+today.substring(4,6)+"-"+today.substring(6,8);
		if(data.wosTc != null && data.wosTc != 'null'){
			$('#sciTcSpan').text(data.wosTc);
			$('#sciTcDateEm').text(today);
		}else{
			$('#sciTcSpan').text('-');
		}
		if(data.scpTc != null){
			$('#scpTcSpan').text(data.scpTc);
			$('#scpTcDateEm').text(today);
		}else{
			$('#scpTcSpan').text('-');
		}
		if(data.kciTc != null){
			$('#kciTcSpan').text(data.kciTc);
			$('#kciTcDateEm').text(today);
		}else{
			$('#kciTcSpan').text('-');
		}
		dhtmlx.alert({type:"alert",text:"피인용횟수 업데이트 완료하였습니다.",callback:function(){}})
	});
}

function topAlertClose(){
	$('.top_alert_wrap').css('display','none');
	var hSize = ($(window).height()-(85+$('.title_box').height()+$('.top_help_wrap').height()+$('.list_bt_area').height()))+"px";
	$('#mainTabbar').css({'height':hSize});
	myTabbar.setSizes();
}

function tcHisotry(articleId, sourcIdntfcNo){
    $.post('<c:url value="/article/findTcHisoty.do"/>',{'articleId' : articleId,'sourcIdntfcNo':sourcIdntfcNo},null,'json').done(function(data){
        if(data.length > 0)
        {
            $('#tcHistoryDialog h3').empty().text('피인용횟수 이력')
            $('#tcHistoryDialog tbody').empty();
            for(var i=0; i < data.length; i++)
            {
                var tr = $('<tr></tr>');
                tr.append('<td style="text-align: center">'+data[i].yearMonth+'</td>');
                tr.append('<td style="text-align: center">'+(data[i].tc ? data[i].tc : 0)+'</td>');
                $('#tcHistoryDialog tbody').append(tr);
            }
            $('#tcHistoryBtn').triggerHandler('click');
        }
    });
}


</script>
