<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.argonet.r2rims.util.LanguageUtil"%>
<%@include file="../../pageInit.jsp" %>
<!-- 검증Form (KRI,RIMS,DOI 검색 입력) -->
<c:set var="prtpntId" value=""/><c:set var="prtcpntNm" value=""/><c:set var="prtcpntFullNm" value=""/><c:set var="pcnRschrRegNo" value=""/><c:set var="blngAgcCd" value=""/><c:set var="blngAgcNm" value=""/><c:set var="deptKor" value=""/><c:set var="posiCd" value=""/>
<c:if test="${sessMode or (sessionScope.auth.adminDvsCd eq 'R' or sessionScope.auth.adminDvsCd eq 'S' )}">
  <c:set var="prtpntId" value="${sessionScope.sess_user.userId}"/><c:set var="prtcpntNm" value="${sessionScope.sess_user.abbrLastName}, ${sessionScope.sess_user.abbrFirstName}"/>
  <c:set var="prtcpntFullNm" value="${sessionScope.sess_user.lastName}, ${sessionScope.sess_user.firstName}"/><c:set var="pcnRschrRegNo" value="${sessionScope.sess_user.rschrRegNo}"/>
  <c:set var="deptKor" value="${sessionScope.sess_user.groupDept}"/><c:set var="blngAgcCd" value="${sysConf['inst.blng.agc.code']}"/><c:set var="blngAgcNm" value="${sysConf['inst.blng.agc.name']}"/>
  <c:set var="posiCd" value="${sessionScope.sess_user.posiMapngCd}"/>
</c:if>
<c:set var="rschRequiredClass" value=""/><c:set var="rschEssentialTh" value=""/><c:set var="rschReadonly" value=""/>
<c:if test="${sessionScope.auth.adminDvsCd eq 'R' or sessionScope.auth.adminDvsCd eq 'S'}">
    <c:set var="rschRequiredClass" value="required"/><c:set var="rschEssentialTh" value="essential_th"/><c:set var="rschReadonly" value="readonly='readonly'"/>
</c:if>
<c:set var="adminEssentialTh" value=""/><c:set var="adminRequiredClass" value=""/>
<c:if test="${sessionScope.auth.adminDvsCd eq 'M'}">
    <c:set var="adminRequiredClass" value="required"/><c:set var="adminEssentialTh" value="essential_th"/>
</c:if>
<div id="vrfcArea">
<form id="vrfcFrm">
<input type="hidden" id="sessUserRschrRegNo" name="sessUserRschrRegNo" value="${sessionScope.sess_user.rschrRegNo}"/>
<table class="write_tbl mgb_10"  style="border: 3px solid #eb7835;">
  <colgroup>
    <col style="width:140px;" />
    <col style="width:171px;" />
    <col style="width:140px" />
    <col style="width:171px;" />
    <col style="width:140px" />
    <col style="" />
    <col style="width: 50px;"/>
  </colgroup>
  <tbody>
    <tr>
      <td colspan="6" style="color: red;"><spring:message code='art.add.search'/> >> <spring:message code='art.add.search.comment'/></td>
      <td rowspan="3" onclick="javascript:addVrfcPopup();" class="option_search_td"></td>
    </tr>
    <tr>
      <th><spring:message code='art.search.type'/></th>
      <td>
        <input name="srchTrget" id="srchTrget_KRI" type="radio" style="vertical-align: middle;" value="kri" checked="checked" onclick="onClickTaget($(this))"/><label for="srchTrget_KRI">NRF</label>&nbsp;
        <%--
        <input name="srchTrget" id="srchTrget_DOI" type="radio" style="vertical-align: middle;" value="doi" onclick="onClickTaget($(this))"/><label for="srchTrget_DOI">DOI</label>&nbsp;
         --%>
        <input name="srchTrget" id="srchTrget_corssref" type="radio" style="vertical-align: middle;" value="crossref" onclick="onClickTaget($(this))"/><label for="srchTrget_corssref">DOI</label>&nbsp;
        <input name="srchTrget" id="srchTrget_RIMS" type="radio" style="vertical-align: middle;" value="rims" onclick="onClickTaget($(this))"/><label for="srchTrget_RIMS">RIMS</label>&nbsp;
      </td>
      <th><spring:message code='art.search.db.choice'/></th>
      <td>
        <input name="srchScjnlDvsCd" id="srchScjnlDvsCd_SCI" type="radio" style="vertical-align: middle;" value="SCI" checked/>SCI&nbsp;
        <input name="srchScjnlDvsCd" id="srchScjnlDvsCd_SCP" type="radio" style="vertical-align: middle;" value="SCP"/>SCOPUS&nbsp;
        <input name="srchScjnlDvsCd" id="srchScjnlDvsCd_KCI" type="radio" style="vertical-align: middle;" value="KCI"/>KCI&nbsp;
      </td>
      <th><spring:message code='art.add.pblc.ym'/></th>
      <td>
        <input type="text" name="srchPblcYear" id="srchPblcYear" maxLength="4" class="input_type" />
      </td>
    </tr>
    <tr>
      <th><span id="titleSpan"><spring:message code='art.add.title'/></span><span id="doiSpan" style="display: none;">DOI</span></th>
      <td colspan="5">
        <label for="srchKeyword" id="srchKeywordLabel" class="labelHelp">
          <span id="titleLable">
          		<spring:message code='art.add.bro'/>
          </span>
          <span id="doiLable" style="display: none;">
          		<spring:message code='art.add.doi'/>
          </span>
          <span id="rimsLable" style="display: none;">
          		<spring:message code='art.add.rims'/>
          </span>
        </label>
        <input type="text" name="srchKeyword" id="srchKeyword"  class="input_type" onfocus="onFocusHelp('srchKeyword');" onblur="onBlurHelp('srchKeyword');"/>
      </td>
    </tr>
  </tbody>
</table>
</form>
</div>
<form id="formArea" action="<c:url value="/${preUrl}/article/addArticle.do"/>" method="post" enctype="multipart/form-data"  >
<input type="hidden"  name="vrfcDvsCd" id="vrfcDvsCdKey" value="1"/>
<input type="hidden" name="vrfcSrcDvsCd" id="vrfcSrcDvsCd"/>
<input type="hidden" name="vrfcPprId" id="vrfcPprId"/>
<c:if test="${sessionScope.auth.adminDvsCd ne 'M' and sessionScope.auth.adminDvsCd ne 'P' }">
<input type="hidden" name="insttRsltAt" value="Y" />
</c:if>
<div id="mainTabbar" style="position: relative; width: 100%;height: 100%; overflow: visible;"></div>
<c:if test="${sessMode or (sessionScope.auth.adminDvsCd eq 'R' or sessionScope.auth.adminDvsCd eq 'S' )}">
<div id="reqItem" style="overflow: auto;width: 100%;height: 100%;position: relative;">
</c:if>
  <table id="reqTbl"  class="write_tbl">
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
                <spring:message code="common.radio.yes"/> <input type="radio" name="isReprsntArticle" value="Y"/>
                &nbsp;&nbsp;&nbsp;<spring:message code="common.radio.no"/> <input type="radio" name="isReprsntArticle" value="N" checked="checked"/>
            </td>
        </tr>
    </c:if>
      <tr>
        <th class="add_help">
          <spring:message code='art.scjnl.dvs.cd'/><a href="javascript:void(0);" onclick="showTooltip($(this))" class="tbl_help_a"></a>
          <p class="th_help_box"><span><spring:message code='tooltip.art1'/></span></p>
        </th>
        <td>
            <span id="scjnlDvsSpan" style="color: #afafaf"></span>
            <input type="hidden" name="scjnlDvsCd" id="scjnlDvsCd" value="" />
        </td>
            <th id="artOvrsTh" ><spring:message code='art.scjnl.detail.cd'/></th>
            <td id="scjnlDetailTd">
                <span id="scjnlDetailSpan" style="color: #afafaf"></span>
                <c:choose>
                    <c:when test="${sessMode or (sessionScope.auth.adminDvsCd eq 'R' or sessionScope.auth.adminDvsCd eq 'S' )}">
                        <input type="hidden" name="ovrsExclncScjnlPblcYn" id="ovrsExclncScjnlPblcYn" value="" />
                    </c:when>
                    <c:otherwise>
                        <select name="ovrsExclncScjnlPblcYn" id="ovrsExclncScjnlPblcYn" class="select_type">${rims:makeCodeList('1380', true, '')}</select>
                    </c:otherwise>
                </c:choose>
                <c:choose>
                    <c:when test="${sessMode or (sessionScope.auth.adminDvsCd eq 'R' or sessionScope.auth.adminDvsCd eq 'S' )}">
                        <input type="hidden" name="krfRegPblcYn" id="krfRegPblcYn" value="" />
                    </c:when>
                    <c:otherwise>
                        <select name="krfRegPblcYn" id="krfRegPblcYn" class="select_type">${rims:makeCodeList('1390', true, '')}</select>
                    </c:otherwise>
                </c:choose>
            </td>
        <th><spring:message code='art.pblc.language'/></th>
        <td>
          <select name="pprLangDvsCd" id="pprLangDvsCd" class="select_type">${rims:makeCodeList('2020',true,'')}</select>
        </td>
      </tr>
      <tr style="height: 37px;">
          <th class="${adminEssentialTh}"><spring:message code='art.scjnl.regist.cd'/></th>
          <td colspan="5">
              <input type="checkbox" id="isSci" name="isSci"  value="Y" class="radio regst_info" onclick="regstOnClick($(this))" ${rschReadonly} />
              <label for="isSci" class="radio_label">SCI</label>
              <input type="checkbox" id="isScie" name="isScie"  value="Y" class="radio regst_info" onclick="regstOnClick($(this))" ${rschReadonly} />
              <label for="isScie" class="radio_label">SCIE</label>
              <input type="checkbox" id="isSsci" name="isSsci"  value="Y" class="radio regst_info"  onclick="regstOnClick($(this))" ${rschReadonly} />
              <label for="isSsci" class="radio_label">SSCI</label>
              <input type="checkbox" id="isAhci" name="isAhci"  value="Y" class="radio regst_info" onclick="regstOnClick($(this))" ${rschReadonly} />
              <label for="isAhci" class="radio_label">A&HCI</label>
              <input type="checkbox" id="isScopus" name="isScopus"  value="Y" class="radio regst_info"  onclick="regstOnClick($(this))" ${rschReadonly} />
              <label for="isScopus" class="radio_label">SCOPUS</label>
              <input type="checkbox" id="isEsci" name="isEsci"  value="Y" class="radio regst_info" onclick="regstOnClick($(this))" ${rschReadonly} />
              <label for="isEsci" class="radio_label">ESCI</label>
              <input type="checkbox" id="isForeign" name="isForeign"  value="Y" class="radio regst_info"  onclick="regstOnClick($(this))" ${rschReadonly} />
              <label for="isForeign" class="radio_label"><spring:message code='art.scjnl.intl.cd'/></label>
              <input type="checkbox" id="isKci" name="isKci"  value="Y" class="radio regst_info" onclick="regstOnClick($(this))" ${rschReadonly} />
              <label for="isKci" class="radio_label"><spring:message code='art.scjnl.nrf.cd'/></label>
              <input type="checkbox" id="isKciCandi" name="isKciCandi"  value="Y" class="radio regst_info" onclick="regstOnClick($(this))" ${rschReadonly} />
              <label for="isKciCandi" class="radio_label"><spring:message code='art.scjnl.nrf.candi.cd'/></label>
              <input type="checkbox" id="isDomestic" name="isDomestic"  value="Y" class="radio regst_info" onclick="regstOnClick($(this))" ${rschReadonly} />
              <label for="isDomestic" class="radio_label"><spring:message code='art.scjnl.domestic.cd'/></label>
              <input type="checkbox" id="isOther" name="isOther"  value="Y" class="radio regst_info" onclick="regstOnClick($(this))" ${rschReadonly} />
              <label for="isOther" class="radio_label"><spring:message code='art.scjnl.other.cd'/></label>
          </td>
      </tr>
      <tr>
        <th class="essential_th add_help">
          <spring:message code='art.scjnl.nm'/><a href="javascript:void(0);" onclick="showTooltip($(this))" class="tbl_help_a"></a>
          <p class="th_help_box"><span><spring:message code='tooltip.art4'/></span></p>
        </th>
        <td colspan="3">
          <div class="r_add_bt">
                <input type="text" maxLength="300" id="scjnlNm" name="scjnlNm" class="required input_type" onkeydown="if(event.keyCode==13){findJournalFromExtrlSource($('#scjnlNm'));}"/>
                <a href="javascript:void(0);" onclick="findJournalFromExtrlSource($('#scjnlNm'));" class="tbl_search_bt">검색</a>
              </div>
        </td>
        <th>
          <spring:message code='art.issn.no'/>
        </th>
        <td>
          <div class="r_add_bt">
              <input type="text" name="issnNo"  maxLength="9" id="issnNo" class="input_type"/>
              <a href="javascript:void(0);" onclick="findJournalFromExtrlSource($('#issnNo'));" class="tbl_search_bt">검색</a>
              </div>
        </td>
      </tr>
      <tr>
        <th class="essential_th">
          <spring:message code='art.pblc.plc'/>
        </th>
        <td colspan="3">
          <input type="text" id="pblcPlcNm" maxLength="150" name="pblcPlcNm" class="input_type required"/>
        </td>
        <th class="essential_th">
          <spring:message code='art.pblc.ntn'/>
        </th>
        <td>
              <select name="pblcNtnCd" id="pblcNtnCd" class="select_type required">
                  ${rims:makeCodeList('2000', true, '') }
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
            <input type="text" name="pblcYear" id="pblcYear" class="input_type required" style="width: 80px;">&nbsp;<spring:message code='common.year'/>&nbsp;&nbsp;
                <input type="text" name="pblcMonth" id="pblcMonth" class="input_type"  style="width: 45px;">&nbsp;<spring:message code='common.month'/>&nbsp;&nbsp;
                <c:if test="${not empty sysConf['article.pblcday.input.at'] and sysConf['article.pblcday.input.at'] eq 'Y' }">
                  <input type="text" name="pblcDay" id="pblcDay" class="input_type" style="width: 45px;">&nbsp;<spring:message code='common.day'/>&nbsp;&nbsp;
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
          Vol. <input type="text" name="volume" id="pblcVolume" class="input_type" style="width: 50px;" maxLength="10" />
        </td>
        <th>
          <spring:message code='art.issue'/>
        </th>
        <td>
          No. <input type="text" name="issue" id="pblcIssue" class="input_type" style="width: 50px;" maxLength="10"/>
        </td>
        <th class="add_help">
          <spring:message code='art.page'/><a href="javascript:void(0);" onclick="showTooltip($(this))" class="tbl_help_a"></a>
          <p class="th_help_box"><span><spring:message code='tooltip.art8'/></span></p>
        </th>
        <td>
          <input type="text" name="sttPage" class="input_type" id="sttPage" maxLength="10" style="width: 50px;"/>
          -<input type="text" name="endPage" class="input_type" id="endPage" maxLength="10" style="width: 50px;" />
        </td>
      </tr>
      <tr>
        <th class="add_help">
          Impact Factor<a href="javascript:void(0);" onclick="showTooltip($(this))" class="tbl_help_a"></a>
          <p class="th_help_box"><span><spring:message code='tooltip.art7'/></span></p>
        </th>
        <td>
          <c:if test="${sessionScope.login_user.adminDvsCd eq 'M'}">
            <div class="r_add_bt">
                    <input type="text" name="impctFctr" id="impctFctr" class="input_type"/>
                    <a href="javascript:void(0);" onclick="findImpactIndexByIssnAndIndexType('if');" class="tbl_search_bt">검색</a>
                  </div>
          </c:if>
          <c:if test="${sessionScope.login_user.adminDvsCd ne 'M'}">
                  <input type="hidden" name="impctFctr" id="impctFctr" />
                  <span id="impctFctrView" style="color: gray;"></span>
          </c:if>
        </td>
        <th><spring:message code='art.corprRsrchDvsCd'/></th>
        <td>
            <select name="corprRsrchDvsCd" id="corprRsrchDvsCd" class="select_type">
                ${rims:makeCodeList('corpr.rsrch.dvs', true, '') }
            </select>
        </td>
        <td colspan="2">
        </td>
        <%--<th>ORNIF</th>
        <td>
          <c:if test="${sessionScope.auth.adminDvsCd eq 'M'}">
                  <input type="text" name="ornif" id="ornif" class="input_type"  value="${article.ornif}" />
          </c:if>
          <c:if test="${sessionScope.auth.adminDvsCd ne 'M'}">
                  <input type="hidden" name="ornif" id="ornif" value="${article.ornif}" />
                  <span id="impctFctrView" style="color: gray;">${empty article.ornif ? '없음' : article.ornif}</span>
          </c:if>
        </td>
        <th>SJR</th>
        <td>
          <c:if test="${sessionScope.auth.adminDvsCd eq 'M'}">
                  <input type="text" name="sjr" id="sjr" class="input_type"  value="${article.sjr}" />
          </c:if>
          <c:if test="${sessionScope.auth.adminDvsCd ne 'M'}">
                  <input type="hidden" name="sjr" id="sjr" value="${article.sjr}" />
                  <span id="impctFctrView" style="color: gray;">${empty article.sjr ? '없음' : article.sjr}</span>
          </c:if>
        </td>--%>
      </tr>
      <tr>
        <th class="essential_th">
          <spring:message code='art.title.org'/>
        </th>
        <td colspan="5">
          <div class="tbl_textarea">
            <textarea name="orgLangPprNm" maxLength="1000" rows="3" id="orgLangPprNm" class="required" ></textarea>
          </div>
        </td>
      </tr>
      <tr>
        <th>
          <spring:message code='art.title.diff'/>
        </th>
        <td colspan="5">
          <div class="tbl_textarea">
            <textarea name="diffLangPprNm" maxLength="1000" rows="2" id="diffLangPprNm" ></textarea>
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
                <input type="text" name="rsrchacpsStdySpheCdValue" id="rsrchacpsStdySpheCdValue" class="input_type ${rschRequiredClass}" value="" onclick="findResArea('rsrchacpsStdySpheCd','7',$('#rsrchacpsStdySpheCdValue').val(),event);" readonly="readonly"/>
                <input type="hidden" name="rsrchacpsStdySpheCd" id="rsrchacpsStdySpheCdKey"  class="input_type ${rschRequiredClass}" value=""/>
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
        <th rowspan="2" class="${rschEssentialTh}"><spring:message code='art.sbjt.no'/></th>
        <td colspan="3">
          <input type="checkbox" id="relateFundingAt" name="relateFundingAt" value="N"/><spring:message code="art.relate.funding.lable" />
        </td>
      </tr>
      <tr>
        <td colspan="3" style="padding: 1px 1px;">
          <table class="in_tbl">
            <colgroup>
              <col style="width:110px;" />
              <col style="width:283px;" />
              <col style="" />
            </colgroup>
            <tbody>
              <c:set var="fundingIdx" value="0"/>
              <tr>
                <td>
                  <input type="text" name="sbjtNo"  id="sbjtNo_1" value="" class="input_type"  readonly="readonly" />
                  <input type="hidden" name="seqNo"  id="seqNo_1" value="_blank">
                  <input type="hidden" name="fundIndex"  id="fundIndex_1" value="1">
                </td>
                <td>
                  <div class="r_add_bt">
                             <input type="hidden" name="fundingId" id="fundingId_1" value=""/>
                            <input type="text" name="rschSbjtNm" id="rschSbjtNm_1" class="input_type" value="" onkeydown="if(event.keyCode==13){findFunding($(this),event);}"/>
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
              <input type="text"  name="totalAthrCnt" id="totalAthrCnt" maxlength="4" class="input_type" style="width:20px;text-align: center;" onchange="CheckValue();"/>
              <em>ex) 17</em>
            </p>
          </div>
        </td>
      </tr>
      <tr>
        <td colspan="6" class="inner_tbl_td">
          <table class="inner_tbl move_tbl" id="prtcpntTbl" style="table-layout: fixed;">
            <thead>
              <tr>
	              <th colspan="2" style="width: 50px;"><spring:message code='art.order'/></th>
	              <th style="width: 90px;" class="essential_th"><spring:message code='art.short.name'/></th>
	              <th style="width: 110px;"><spring:message code='art.full.name'/></th>
	              <th style="width: 100px;"><spring:message code='art.tpi.dvs'/></th>
	              <th style="width: 150px;"><spring:message code='art.user.id'/></th>
                  <th style="width: 110px;"><spring:message code='art.author.posi'/></th>
	              <th style="width: 150px;"><spring:message code='art.agc.nm'/></th>
	              <th style="width: 80px;"><spring:message code='art.author.dept'/></th>
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
                          <input type="text"  name="prtcpntNm" maxLength="30" id="prtcpntNm_${prtcpntIdx}" value="${prtcpntNm}" placeholder="예)Hong, GD" class="input_type required" onkeydown="if(event.keyCode==13){findUser($(this),event);}"/>
                          <input type="hidden" name="pcnRschrRegNo" id="pcnRschrRegNo_${prtcpntIdx}"  value="${pcnRschrRegNo}"/>
                          <input type="hidden" name="seqAuthor" id="seqAuthor_${prtcpntIdx}" value="${prtcpntIdx}"/>
                   </td>
                   <td style="width:100px">
                       <input type="text" name="prtcpntFullNm" maxLength="100" id="prtcpntFullNm_${prtcpntIdx}" value="${prtcpntFullNm}" placeholder="예)Hong, Gil Dong" class="input_type" onkeydown="if(event.keyCode==13){findUser($(this),event);}"/>
                   </td>
                   <td style="width:80px;">
                      <select name="tpiDvsCd" id="tpiDvsCd_${prtcpntIdx}" class="select_type">${rims:makeCodeList('1180', true, '4') }</select>
                   </td>
                   <td style="width:160px">
                      <span class="ck_bt_box">
                     <input type="text" name="prtcpntId" style="width: 80px;" id="prtcpntId_${prtcpntIdx}"  value="${prtpntId}" class="input_type"/>
                        <span class="ck_r_bt">
                    <a href="javascript:void(0);" class="tbl_icon_a tbl_search_icon" onclick="findUser($(this),event);">검색</a>
                    <a href="javascript:void(0);" class="tbl_icon_a tbl_trash_icon" onclick="clearPrtcpnt($(this));">지우기</a>
                          <c:if test="${sessionScope.login_user.adminDvsCd eq 'M'}">
                            <input type="checkbox" name="tempChk" id="tempChk_${prtcpntIdx}"  onclick="changeIsRecord($(this));" style="vertical-align: middle;"/>
                          </c:if>
                        </span>
                      </span>
	                   <input type="hidden" name="isRecord"  id="isRecord_${prtcpntIdx}"/>
                   <c:choose>
                   	 <c:when test="${sessionScope.auth.adminDvsCd eq 'R' or sessionScope.auth.adminDvsCd eq 'S'}">
                 	  <input type="hidden" name="recordStatus" id="recordStatus_${prtcpntIdx}" value="1"/>
                   	 </c:when>
                   	 <c:otherwise>
                 	  <input type="hidden" name="recordStatus" id="recordStatus_${prtcpntIdx}" />
                   	 </c:otherwise>
                   </c:choose>
                   </td>
                   <td style="width:100px;">
                         <select name="posiCd" id="posiCd_${prtcpntIdx}" class="select_type">${rims:makeCodeList('prtcpnt.position', true,  posiCd)}</select>
                         <input type="hidden" name="posiNm" id="posiNm_${prtcpntIdx}" value="<c:out value="${empty pl.posiNm ? '_blank' : pl.posiNm}"/>"/>
                     </td>
                  <td style="width:160px;">
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
              <input type="radio" name="postIrOpen" value="Y" />&nbsp;<spring:message code='file.ir.open.y'/>&nbsp;&nbsp;
              <input type="radio" name="postIrOpen" value="N" checked="checked"/>&nbsp;<spring:message code='file.ir.open.n'/>
                </td>
                <td>
              <input type="text" id="postIrOpenDate" name="postIrOpenDate" readonly="readonly" class="input_type" value=""/>
                </td>
                </c:if>
                <td>
              <div class="fileupload_box">
               <ul>
                <li>
                <span class="upload_int">
                  <input type="text" class="up_input" id="fileInputPost" onclick="$('#filePost').trigger('click');" readonly="readonly"/>
                  <a href="javascript:void(0);" class="upload_int_bt" onclick="$('#filePost').trigger('click');"><spring:message code="art.file.select" /></a>
                  <input type="file"  class="typeFile" style="display: none;" name="filePost"  id="filePost" onchange="$('#fileInputPost').val($(this).val().split('\\').pop());"/>
                </span>
                </li>
               </ul>
              </div>
                </td>
             </tr>
             <tr>
                <td><b><spring:message code="art.file.pub.version" /></b></td>
                <c:if test="${not sessMode and sessionScope.auth.adminDvsCd ne 'R' and  sessionScope.auth.adminDvsCd ne 'S' }">
                <td>
              <input type="radio" name="pubIrOpen" value="Y" />&nbsp;<spring:message code='file.ir.open.y'/>&nbsp;&nbsp;
              <input type="radio" name="pubIrOpen" value="N" checked="checked"/>&nbsp;<spring:message code='file.ir.open.n'/>
                </td>
                <td>
              <input type="text" id="pubIrOpenDate" name="pubIrOpenDate" readonly="readonly" class="input_type" value=""/>
                </td>
                </c:if>
                <td>
              <div class="fileupload_box">
               <ul>
                <li>
                <span class="upload_int">
                  <input type="text" class="up_input" id="fileInputPub" onclick="$('#filePub').trigger('click');" readonly="readonly"/>
                  <a href="javascript:void(0);" class="upload_int_bt" onclick="$('#filePub').trigger('click');"><spring:message code="art.file.select" /></a>
                  <input type="file"  class="typeFile" style="display: none;" name="filePub"  id="filePub" onchange="$('#fileInputPub').val($(this).val().split('\\').pop());"/>
                </span>
                </li>
               </ul>
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
</div>
</c:if>

<c:if test="${sessMode or (sessionScope.auth.adminDvsCd eq 'R' or sessionScope.auth.adminDvsCd eq 'S' )}">
<div id="optItem" style="overflow: auto;width: 100%;height: 100%;position: relative;">
</c:if>
  <table id="optTbl" class="write_tbl mgb_10"  <c:if test="${sessionScope.auth.adminDvsCd ne 'R' and sessionScope.auth.adminDvsCd ne 'S' }">style="border-top: 0px;"</c:if>>
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
        <th class="add_help">
          WOS ID<a href="javascript:void(0);" onclick="showTooltip($(this))" class="tbl_help_a"></a>
          <p class="th_help_box"><span><spring:message code='tooltip.art14'/></span></p>
        </th>
        <td>
          <div class="r_add_bt">
          <input type="text" name="idSci" id="idSci" class="input_type" <c:if test="${sessionScope.auth.adminDvsCd ne 'M' }">readonly="readonly"</c:if>/>
          <input type="hidden" name="orgIdSci">
          <span class="r_span_box">
            <a href="javascript:void(0);" class="tbl_icon_a tbl_link_n_icon">링크</a>
          </span>
          </div>
        </td>
        <th class="add_help">
          SCOPUS ID<a href="javascript:void(0);" onclick="showTooltip($(this))" class="tbl_help_a"></a>
          <p class="th_help_box"><span><spring:message code='tooltip.art15'/></span></p>
        </th>
        <td>
          <div class="r_add_bt">
          <input type="text" name="idScopus" id="idScopus" class="input_type" <c:if test="${sessionScope.auth.adminDvsCd ne 'M' }">readonly="readonly"</c:if>/>
          <span class="r_span_box">
            <a href="javascript:void(0);" class="tbl_icon_a tbl_link_n_icon">링크</a>
          </span>
          <input type="hidden" name="orgIdScopus">
          </div>
        </td>
        <th>KCI ID</th>
        <td>
          <div class="r_add_bt">
          <input type="text" name="idKci" id="idKci" class="input_type" <c:if test="${sessionScope.auth.adminDvsCd ne 'M' }">readonly="readonly"</c:if>/>
          <span class="r_span_box">
            <a href="javascript:void(0);" class="tbl_icon_a tbl_link_n_icon">링크</a>
          </span>
          <input type="hidden" name="orgIdKci">
          </div>
        </td>
      </tr>
      <tr>
        <th>DOI</th>
        <td colspan="5">
          <div class="r_add_bt">
            http://dx.doi.org/<input type="text" name="doi" id="doi" class="input_type" style="width: 77%;" />
            <span class="r_span_box">
              <a href="javascript:void(0);" class="tbl_icon_a tbl_link_n_icon">링크</a>
            </span>
          </div>
        </td>
      </tr>
      <tr>
        <th>URL</th>
        <td colspan="5">
          <div class="r_add_bt">
            <input type="text" name="url" id="url" class="input_type"/>
            <span class="r_span_box">
              <a href="javascript:void(0);" class="tbl_icon_a tbl_link_n_icon">링크</a>
            </span>
          </div>
        </td>
      </tr>
    <c:if test="${sessionScope.auth.adminDvsCd eq 'M' or sessionScope.auth.adminDvsCd eq 'P' }">
      <tr>
        <th>Open Access</th>
        <td>
            Yes <input type="radio" name="openAccesAt" value="Y"/>
            &nbsp;&nbsp;&nbsp;No <input type="radio" name="openAccesAt" value="N" />

        </td>
        <th><spring:message code='art.isother'/></th>
        <td>
            ${sysConf['inst.abrv']} <input type="radio" name="insttRsltAt" onchange="changOtherValue(this.value);" value="Y" />
            &nbsp;Other <input type="radio" name="insttRsltAt" onchange="changOtherValue(this.value);" value="N"/>
            <input type="hidden" value="" name="otherValue" id="otherValue">
        </td>
        <th><spring:message code='art.issource'/></th>
        <td>
            SCI UT 없음 <input type="checkbox" name="sciAt" value="Y" />
            &nbsp;SCOPUS EID 없음 <input type="checkbox" name="scopusAt" value="Y"/>
          <%--
            &nbsp;KCI <input type="checkbox" name="kciAt" value="Y"/>
           --%>
        </td>
      </tr>
    </c:if>
      <tr>
        <th>
          <spring:message code='art.abst'/>
        </th>
        <td colspan="5">
          <div class="tbl_textarea">
            <textarea name="abstCntn" id="abstCntn" rows="7" maxLength="4000" ></textarea>
          </div>
        </td>
      </tr>
    <c:if test="${sessionScope.auth.adminDvsCd eq 'M' or sessionScope.auth.adminDvsCd eq 'P' }">
      <tr>
        <th>
          <spring:message code='art.doc.type.cd'/>
        </th>
        <td>
           <input type="text" name="docType" id="docType"  class="input_type"/>
        </td>
        <th>WOS DOCTYPE</th>
        <td>
          <input type="text" name="wosDocType" id="wosDocType"  class="input_type"/>
        </td>
        <th>SCOPUS DOCTYPE</th>
        <td>
          <input type="text" name="scpDocType" id="scpDocType"  class="input_type"/>
        </td>
      </tr>
      <tr>
        <th>WOS Categories</th>
        <td>
          <input type="text"  id="sc" name="sc" class="input_type" maxlength="1000" value=""/>
        </td>
        <th>WOS Subject Categories</th>
        <td colspan="3">
          <input type="text"  id="wc" name="wc" class="input_type" maxlength="1000" value=""/>
        </td>
      </tr>
        <tr>
            <th>
                <spring:message code='art.author.keyword'/>
            </th>
            <td colspan="5">
                <input type="text"  id="authorKeyword" name="authorKeyword" class="input_type" maxlength="1000" value=""/>
            </td>
        </tr>
        <tr>
            <th>
                <spring:message code='art.plus.keyword'/>
            </th>
            <td colspan="5">
                <input type="text"  id="plusKeyword" name="plusKeyword" class="input_type" maxlength="1000" value=""/>
            </td>
        </tr>
      <tr>
        <th><spring:message code='art.vrfc.dvs'/></th>
        <td>
          ${rims:codeValue('1420', '')}<span id="vrfcDvsValue"></span>
        </td>
        <th><spring:message code='art.vrfc.dvs.date'/></th>
        <td>
            <span id="vrfcDate"></span>
        </td>
        <th rowspan="2"><spring:message code='art.appr.rtrn'/></th>
        <td rowspan="2">
          <div class="tbl_textarea">
            <textarea maxLength="4000" rows="3" id="appr_rtrn_cncl_rsn_cntn" name="apprRtrnCnclRsnCntn"></textarea>
          </div>
        </td>
      </tr>
      <tr>
        <th><spring:message code='art.appr.dvs'/></th>
        <td>
          <select id="apprDvsCdValue" name="apprDvsCd"  class="select_type" style="width: 100px;">${rims:makeCodeList('1400', true, '') }</select>
          <input type="hidden" id="is_open_files" name="isOpenFiles"/>
          <input type="hidden" id="is_open" name="isOpen"/>
        </td>
        <th><spring:message code='art.appr.dvs.date'/></th>
        <td></td>
      </tr>
    </c:if>
    </tbody>
  </table>
<c:if test="${sessMode or (sessionScope.auth.adminDvsCd eq 'R' or sessionScope.auth.adminDvsCd eq 'S' )}">
</div>
</c:if>
</form>
<script type="text/javascript">
var pblcYearCombo, pblcMonthCombo;
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
    $('#fnDelete').hide();
    changeScjnlDvs();

    dhxCanlendar = new dhtmlXCalendarObject(["preIrOpenDate","postIrOpenDate","pubIrOpenDate"]);
    dhxCanlendar.hideTime();
    dhxCanlendar.loadUserLanguage("ko");
    dhxCanlendar.attachEvent("onClick", function(date, state){ isChange = true; });

    if(sessMode == 'true' || loginAuthor == 'R' || loginAuthor == 'S')
    {

     var hSize = ($(window).height()-(80+$('.title_box').height()+$('#vrfcArea').height()+$('.top_help_wrap').height()+$('.list_bt_area').height()))+"px";
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
    /*
    pblcYearCombo = dhtmlXComboFromSelect("pblcYear");
    pblcMonthCombo = dhtmlXComboFromSelect("pblcMonth");
    var comboObj = $('.dhxcombo_dhx_terrace');
    comboObj.parent().css('float','left');
    comboObj.css('height','20px');
    comboObj.find('.dhxcombo_input').css('height','20px');
    comboObj.find('.dhxcombo_select_button').css('top','2px').css('width','12px');
    */
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
    $('input[name="srchScjnlDvsCd"]').prop('checked', false).prop('disabled', true);
    $('#srchPblcYear').prop('disabled', true);
    $('#titleSpan').css('display','none');
    $('#titleLable').css('display','none');
    $('#doiSpan').css('display','');
    $('#doiLable').css('display','');
  }
  else
  {
    if(rdo.val() == 'rims')
    {
      $('input[name="srchScjnlDvsCd"]').prop('checked', false).prop('disabled', true);
	  $('#rimsLable').css('display','');
	  $('#titleLable').css('display','none');
    }
    else
    {
      $('input[name="srchScjnlDvsCd"]').prop('disabled', false);
      $('input[name="srchScjnlDvsCd"]').eq(0).prop('checked', true);
	  $('#rimsLable').css('display','none');
	  $('#titleLable').css('display','');
    }
    $('#srchPblcYear').prop('disabled', false);
    $('#titleSpan').css('display','');
    $('#doiSpan').css('display','none');
    $('#doiLable').css('display','none');
  }
}

</script>

