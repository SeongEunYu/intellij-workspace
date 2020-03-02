<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="kr.co.argonet.r2rims.util.LanguageUtil" %>
<%@ page import="java.util.LinkedHashMap" %>
<%@ page import="kr.co.argonet.r2rims.core.code.CodeConfiguration" %>
<%@ page import="org.apache.commons.lang3.StringUtils" %>
<%@include file="../pageInit.jsp" %>
<div id="mainTabbar" style="position: relative; width: 100%;height: 100%; overflow: visible;"></div>
<form id="formArea" action="<c:url value="/${preUrl}/lab/modifyLab.do"/>" method="post" enctype="multipart/form-data">
    <div id="labInfo">
        <div id="comItem" style="overflow: auto;">
            <input type="hidden" name="labId" id="labId" value="<c:out value="${lab.labId}"/>"/>
            <input type="hidden" name="sendEmail" id="sendEmail" value="0"/>
            <input type="hidden" name="emailAddr" value="${emailAddr}"/>
            <table class="write_tbl mgb_30">
                <colgroup>
                    <col style="width:15%">
                    <col style="width:35%">
                    <col style="width:15%">
                    <col style="width:35%">
                </colgroup>
                <tbody>
                <tr>
                    <th class="essential_th"><spring:message code="lab.kor.nm"/></th>
                    <td>
                        <input type="text" name="korNm" id="korNm" class="input_type required"
                               value="<c:out value="${lab.korNm}"/>"/>
                    </td>
                    <th class="essential_th"><spring:message code="lab.eng.nm"/></th>
                    <td>
                        <input type="text" name="engNm" class="input_type required"
                               value="<c:out value="${lab.engNm}"/>"/>
                    </td>
                </tr>
                <tr>
                    <th><spring:message code="lab.abbr.nm"/></th>
                    <td>
                        <input type="text" name="abbrNm" class="input_type" value="<c:out value="${lab.abbrNm}"/>"/>
                    </td>
                    <th><spring:message code="lab.homepage"/></th>
                    <td>
                        <input type="text" name="homePageAddr" class="input_type"
                               value="<c:out value="${lab.homePageAddr}"/>"/>
                    </td>
                </tr>
                <%--<th><spring:message code="lab.logo.img"/></th>
                    <td>
                        <c:if test="${not empty logoFileList}">
                            <div class="list_set" style="float:left;">
                                <ul>
                                    <li>
                                        <input type="hidden" name="fileId" value="${logoFileList[0].fileId}"/>
                                        <img class="labImg" name="modal_logoFile"
                                             src="${contextPath}/servlet/image/labImg.do?fileid=<c:out value="${logoFileList[0].fileId}"/>"/>
                                    </li>
                                    <a href="javascript:void(0);" style="padding:0px;"
                                       onclick="removeLabFile($(this), 'logoFile');" class="del_file">삭제</a>
                                </ul>
                            </div>
                        </c:if>
                        <c:if test="${empty logoFileList}">
                            <div class="list_set" style="float:left;">
                                <ul>
                                    <li>
                                        <label>
                                            <span class="list_icon12"><spring:message code="lab.upload"/></span>
                                            <span style="font-size:15px;"><spring:message code="lab.logo.img.size"/></span>
                                            <input type="file" name="logoFile" style="display:none;"
                                                   onchange="labFileUpload(this,'logoFile');"/>
                                        </label>
                                    </li>
                                </ul>
                            </div>
                        </c:if>
                    </td>--%>
                <tr>
                    <td colspan="4" style="padding: 0;">
                        <table class="write_tbl" style="border-top: none; table-layout: fixed;">
                            <tr>
                                <th style="width:33%;text-align: center;"><spring:message code="lab.cover.img"/></th>
                                <th style="width:33%;text-align: center;"><spring:message code="lab.rep.img"/>1</th>
                                <th style="width:33%;text-align: center;"><spring:message code="lab.rep.img"/>2</th>
                            </tr>
                            <tr>
                                <td style="width:33%;border-right: 1px solid #b1b1b1;border-bottom: 0px;padding: 20px 0;">
                                    <c:if test="${not empty coverFileList}">
                                        <div class="list_set" style="float:left;">
                                            <ul>
                                                <li>
                                                    <input type="hidden" name="fileId" value="${coverFileList[0].fileId}"/>
                                                    <img class="labImg" name="modal_coverFile"
                                                         src="${contextPath}/servlet/image/labImg.do?fileid=<c:out value="${coverFileList[0].fileId}"/>"/>
                                                </li>
                                                <a href="javascript:void(0);" style="padding:0px;"
                                                   onclick="removeLabFile($(this), 'coverFile');" class="del_file">삭제</a>
                                            </ul>
                                        </div>
                                    </c:if>
                                    <c:if test="${empty coverFileList}">
                                        <div class="list_set" style="float:left;">
                                            <ul>
                                                <li>
                                                    <label>
                                                        <span class="list_icon12"><spring:message code="lab.upload"/></span>
                                                        <span style="font-size:15px;"><spring:message code="lab.cover.img.size"/></span>
                                                        <input type="file" name="coverFile" style="display:none;"
                                                               onchange="labFileUpload(this,'coverFile');"/>
                                                    </label>
                                                </li>
                                            </ul>
                                        </div>
                                    </c:if>
                                </td>
                                <td style="width:33%;border-right: 1px solid #b1b1b1;border-bottom: 0px;padding: 20px 0;">
                                    <c:if test="${not empty repFile1List}">
                                        <div class="list_set" style="float:left;">
                                            <ul>
                                                <li>
                                                    <input type="hidden" name="fileId" value="${repFile1List[0].fileId}"/>
                                                    <img class="labImg" name="modal_repFile1"
                                                         src="${contextPath}/servlet/image/labImg.do?fileid=<c:out value="${repFile1List[0].fileId}"/>"/>
                                                </li>
                                                <a href="javascript:void(0);" style="padding:0px;"
                                                   onclick="removeLabFile($(this), 'repFile1');" class="del_file">삭제</a>
                                            </ul>
                                        </div>
                                    </c:if>
                                    <c:if test="${empty repFile1List}">
                                        <div class="list_set" style="float:left;">
                                            <ul>
                                                <li>
                                                    <label>
                                                        <span class="list_icon12"><spring:message code="lab.upload"/></span>
                                                        <span style="font-size:15px;"><spring:message code="lab.rep.img.size"/></span>
                                                        <input type="file" name="repFile1" style="display:none;"
                                                               onchange="labFileUpload(this,'repFile1');"/>
                                                    </label>
                                                </li>
                                            </ul>
                                        </div>
                                    </c:if>
                                </td>
                                <td style="width:33%;border-bottom: 0px;padding: 20px 0;">
                                    <c:if test="${not empty repFile2List}">
                                        <div class="list_set" style="float:left;">
                                            <ul>
                                                <li>
                                                    <input type="hidden" name="fileId" value="${repFile2List[0].fileId}"/>
                                                    <img class="labImg" name="modal_repFile2"
                                                         src="${contextPath}/servlet/image/labImg.do?fileid=<c:out value="${repFile2List[0].fileId}"/>"/>
                                                </li>
                                                <a href="javascript:void(0);" style="padding:0px;"
                                                   onclick="removeLabFile($(this), 'repFile2');" class="del_file">삭제</a>
                                            </ul>
                                        </div>
                                    </c:if>
                                    <c:if test="${empty repFile2List}">
                                        <div class="list_set" style="float:left;">
                                            <ul>
                                                <li>
                                                    <label>
                                                        <span class="list_icon12"><spring:message code="lab.upload"/></span>
                                                        <span style="font-size:15px;"><spring:message code="lab.rep.img.size"/></span>
                                                        <input type="file" name="repFile2" style="display:none;"
                                                               onchange="labFileUpload(this,'repFile2');"/>
                                                    </label>
                                                </li>
                                            </ul>
                                        </div>
                                    </c:if>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <th><spring:message code="lab.rep.user"/></th>
                    <td>
                        <div style="padding-top: 5px;padding-bottom: 5px;">
                            <input type="hidden" name="repUserId" id="repUserId" value="${repUser.userId}"/>
                            <span style="vertical-align: sub;margin-right: 10px;" id="repUserNm">
                                <c:if test="${language eq 'en'}">
                                    <c:out value="${repUser.engNm}"/>(<c:out value="${repUser.korNm}"/>)
                                </c:if>
                                <c:if test="${language eq 'ko'}">
                                    <c:out value="${repUser.korNm}"/>(<c:out value="${repUser.engNm}"/>)
                                </c:if>
                            </span>
                            <%--<span>
                                <a href="javascript:void(0);" class="tbl_icon_a tbl_search_icon" onclick="searchRepUser($(this));">검색</a>
                            </span>--%>
                        </div>
                    </td>
                    <th rowspan="2"><spring:message code="lab.video.link"/></th>
                    <td rowspan="2">
                        <input class="input_type youtube_input" type="text" name="videoLink" style="width: 100%;"
                               value="<c:out value="${lab.videoLink}"/>" onkeyup="loadThumbnail($(this).val());" placeholder="ex) https://www.youtube.com/watch?v=wEdvGqxafq8"/>
                        <img id="youtubeImg" class="labImg" style="display: none;"/>
                    </td>
                </tr>
                <tr>
                    <th><spring:message code="lab.parti.user"/></th>
                    <td>
                        <c:if test="${empty labUserList}">
                            <div style="padding-top: 5px;padding-bottom: 5px;">
                                <span style="vertical-align: sub;"></span>
                                <span>
                            <a href="javascript:void(0);" class="tbl_icon_a row_add_bt just_button"
                               onclick="addUser($(this));"><spring:message code='common.add'/></a>
                        </span>
                            </div>
                        </c:if>
                        <c:if test="${not empty labUserList}">
                            <c:forEach var="user" items="${labUserList}" varStatus="idx">
                                <div style="padding-top: 5px;padding-bottom: 5px;">
                                    <input type="hidden" name="userId" value="${user.userId}"/>
                                    <span style="vertical-align: sub;margin-right: 10px;">
                                        <c:if test="${language eq 'en'}">
                                            <c:out value="${user.engNm}"/>(<c:out value="${user.korNm}"/>)
                                        </c:if>
                                        <c:if test="${language eq 'ko'}">
                                            <c:out value="${user.korNm}"/>(<c:out value="${user.engNm}"/>)
                                        </c:if>
                                    </span>
                                    <span>
                                <a href="javascript:void(0);" class="tbl_icon_a row_add_bt" onclick="addUser($(this));"><spring:message
                                        code='common.add'/></a>
                                <a href="javascript:void(0);" class="tbl_icon_a red_del" onclick="removeUser($(this));"><spring:message
                                        code='common.row.delete'/></a>
                            </span>
                                </div>
                            </c:forEach>
                        </c:if>
                    </td>
                </tr>
                <tr>
                    <th rowspan="2"><spring:message code="lab.rep.art"/></th>
                    <td colspan="3">
                        <div style="padding-top: 5px;padding-bottom: 5px;">
                            <span>
                                <a href="javascript:void(0);" class="tbl_icon_a tbl_search_icon" onclick="searhRepRslt($('#art_ul'),'art');">검색</a>
                            </span>
                            <span style="vertical-align: sub;margin-left: 3px;">
                                <spring:message code='lab.rep.art.comment'/>
                            </span>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td colspan="3">
                        <div class="list_set" style="float:left;width: 100%;">
                            <ul id="art_ul">
                                <c:forEach items="${repArticleList}" var="art" varStatus="idx">
                                    <c:set var="pblcYm" value="${art.pblcYm}"/>
                                    <c:if test="${fn:length(pblcYm) > 4}">
                                        <c:set var="pblcYm"
                                               value="${fn:substring(art.pblcYm,0,4)}-${fn:substring(art.pblcYm,4,8)}"/>
                                    </c:if>
                                    <li class="rslt_li" id="art${art.articleId}" style="width: 100%;">
                                        <input type="hidden" name="rsltType" value="ART"/>
                                        <input type="hidden" name="rsltId" value="${art.articleId}"/>
                                        <h3 style="width: 20px;height:30px;float:left;">ㆍ</h3>
                                        <button onclick="removeRep('art${art.articleId}');$(this).remove();"
                                                style="width:30px;height:30px;float:right;" class="keyword_close">x
                                        </button>
                                        <span class="repArtSpan">
                                        <span style="font-weight: bold;"><c:out
                                                value="${art.orgLangPprNm}"/></span><br/>
                                        <span style="font-weight: bold; color: #777;">
                                            <c:out value="${art.scjnlNm}"/>, &nbsp;
                                            <c:if test="${not empty art.volume}">v.<c:out value="${art.volume}"/>,&nbsp;</c:if>
                                            <c:if test="${not empty art.issue}">no.<c:out value="${art.issue}"/>,&nbsp;</c:if>
                                            pp.<c:out value="${art.sttPage}"/> ~ <c:out
                                                value="${art.endPage}"/>,&nbsp;<c:out value="${pblcYm}"/>
                                        </span>
                                    </span>
                                    </li>
                                </c:forEach>
                            </ul>
                        </div>
                    </td>
                </tr>
                <tr>
                    <th rowspan="2"><spring:message code="lab.rep.con"/></th>
                    <td colspan="3">
                        <div style="padding-top: 5px;padding-bottom: 5px;">
                            <span>
                                <a href="javascript:void(0);" class="tbl_icon_a tbl_search_icon" onclick="searhRepRslt($('#con_ul'),'con');">검색</a>
                            </span>
                            <span style="vertical-align: sub;margin-left: 3px;">
                                <spring:message code='lab.rep.con.comment'/>
                            </span>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td colspan="3">
                        <div class="list_set" style="float:left;width: 100%;">
                            <ul id="con_ul">
                                <c:forEach items="${repConferenceList}" var="con" varStatus="idx">
                                    <c:set var="ancmDate" value="${con.ancmDate}"/>
                                    <c:set var="hldSttDate" value="${con.hldSttDate}"/>
                                    <c:set var="hldEndDate" value="${con.hldEndDate}"/>
                                    <c:if test="${fn:length(con.ancmDate) eq 8}">
                                        <c:set var="ancmDate"
                                               value="${fn:substring(con.ancmDate,0,4)}-${fn:substring(con.ancmDate,4,6)}-${fn:substring(con.ancmDate,6,8)}"/>
                                    </c:if>
                                    <c:if test="${fn:length(con.ancmDate) eq 6}">
                                        <c:set var="ancmDate"
                                               value="${fn:substring(con.ancmDate,0,4)}-${fn:substring(con.ancmDate,4,6)}"/>
                                    </c:if>
                                    <c:if test="${fn:length(con.hldSttDate) eq 8}">
                                        <c:set var="hldSttDate"
                                               value="${fn:substring(con.hldSttDate,0,4)}-${fn:substring(con.hldSttDate,4,6)}-${fn:substring(con.hldSttDate,6,8)}"/>
                                    </c:if>
                                    <c:if test="${fn:length(con.hldSttDate) eq 6}">
                                        <c:set var="hldSttDate"
                                               value="${fn:substring(con.hldSttDate,0,4)}-${fn:substring(con.hldSttDate,4,6)}"/>
                                    </c:if>
                                    <c:if test="${fn:length(con.hldEndDate) eq 8 }">
                                        <c:set var="hldEndDate"
                                               value="${fn:substring(con.hldEndDate,0,4)}-${fn:substring(con.hldEndDate,4,6)}-${fn:substring(con.hldEndDate,6,8)}"/>
                                    </c:if>
                                    <c:if test="${fn:length(con.hldEndDate) eq 6 }">
                                        <c:set var="hldEndDate"
                                               value="${fn:substring(con.hldEndDate,0,4)}-${fn:substring(con.hldEndDate,4,6)}"/>
                                    </c:if>
                                    <li class="rslt_li" id="con${con.conferenceId}" style="width: 100%;">
                                        <input type="hidden" name="rsltType" value="CON"/>
                                        <input type="hidden" name="rsltId" value="${con.conferenceId}"/>
                                        <h3 style="width: 20px;height:30px;float:left;">ㆍ</h3>
                                        <button onclick="removeRep('con${con.conferenceId}');$(this).remove();"
                                                style="width:30px;height:30px;float:right;" class="keyword_close">x
                                        </button>
                                        <span style="font-weight: bold;"><c:out
                                                value="${con.orgLangPprNm}"/></span><br/>
                                        <span style="font-weight: bold; color: #777;">
                                        <c:if test="${not empty con.scjnlNm}"><c:out
                                                value="${con.scjnlNm}"/>,&nbsp;</c:if>
                                        <c:if test="${not empty con.scjnlNm}"><c:out
                                                value="${con.pblcPlcNm}"/>,&nbsp;</c:if>
                                        <c:if test="${not empty con.volume}">v.<c:out
                                                value="${con.volume}"/>,&nbsp;</c:if>
                                        <c:if test="${not empty con.issue}">no.<c:out
                                                value="${con.issue}"/>,&nbsp;</c:if>
                                        <c:if test="${not empty hldSttDate}"><c:out value="${hldSttDate}"/> </c:if>
                                        <c:if test="${not empty hldEndDate}">~ <c:out value="${hldEndDate}"/></c:if>
                                    </span>
                                    </li>
                                </c:forEach>
                            </ul>
                        </div>
                    </td>
                </tr>
                <tr>
                    <th><spring:message code="lab.appr.state"/></th>
                    <td>
                        <c:if test="${sessionScope.auth.adminDvsCd eq 'M'}">
                        <span>
                            <select name="apprDvsCd" id="apprDvsCd" class="form-apprDvsCd">
                                <c:if test="${pageContext.response.locale eq 'en'}">
                                    <c:if test="${lab.apprDvsCd eq '1'}">
                                        <option value='1' selected="selected">Writing</option>
                                        <option value='2'>Apply</option>
                                        <option value='3'>Complate</option>
                                    </c:if>
                                    <c:if test="${lab.apprDvsCd eq '2'}">
                                        <option value='1'>Writing</option>
                                        <option value='2' selected="selected">Apply</option>
                                        <option value='3'>Complate</option>
                                    </c:if>
                                    <c:if test="${lab.apprDvsCd eq '3'}">
                                        <option value='1'>Writing</option>
                                        <option value='2'>Apply</option>
                                        <option value='3' selected="selected">Complate</option>
                                    </c:if>
                                </c:if>
                                <c:if test="${pageContext.response.locale eq 'ko'}">
                                    <c:if test="${lab.apprDvsCd eq '1'}">
                                        <option value='1' selected="selected">작성 중</option>
                                        <option value='2'>승인 요청</option>
                                        <option value='3'>승인 완료</option>
                                    </c:if>
                                    <c:if test="${lab.apprDvsCd eq '2'}">
                                        <option value='1'>작성 중</option>
                                        <option value='2' selected="selected">승인 요청</option>
                                        <option value='3'>승인 완료</option>
                                    </c:if>
                                    <c:if test="${lab.apprDvsCd eq '3'}">
                                        <option value='1'>작성 중</option>
                                        <option value='2'>승인 요청</option>
                                        <option value='3' selected="selected">승인 완료</option>
                                    </c:if>
                                </c:if>
                            </select>
                        </span>
                        </c:if>
                        <c:if test="${sessionScope.auth.adminDvsCd ne 'M'}">
                            <input type="hidden" name="apprDvsCd" id="apprDvsCd" value="${lab.apprDvsCd}"/>
                            <span>
                                <c:if test="${pageContext.response.locale eq 'en'}">
                                    <c:if test="${lab.apprDvsCd eq '1' or lab.apprDvsCd == null}">
                                        Writing
                                    </c:if>
                                    <c:if test="${lab.apprDvsCd eq '2'}">
                                        Apply
                                    </c:if>
                                    <c:if test="${lab.apprDvsCd eq '3'}">
                                        Complate
                                    </c:if>
                                </c:if>
                                <c:if test="${pageContext.response.locale eq 'ko'}">
                                    <c:if test="${lab.apprDvsCd eq '1' or lab.apprDvsCd == null}">
                                        작성 중
                                    </c:if>
                                    <c:if test="${lab.apprDvsCd eq '2'}">
                                        승인 요청
                                    </c:if>
                                    <c:if test="${lab.apprDvsCd eq '3'}">
                                        승인 완료
                                    </c:if>
                                </c:if>
                        </span>
                        </c:if>
                    </td>
                    <th><spring:message code="lab.appr.date"/></th>
                    <td>
                    <span>
                        <c:if test="${lab.apprDvsCd eq '3'}">
                            <fmt:formatDate value="${lab.apprDate}" var="apprDate"
                                            type="date" pattern="yyyy-MM-dd"/>
                            <c:out value="${apprDate}"/>
                            <c:if test="${language eq 'en'}">
                                (<c:out value="${lab.apprUserEngNm}"/>)
                            </c:if>
                            <c:if test="${language eq 'ko'}">
                                (<c:out value="${lab.apprUserKorNm}"/>)
                            </c:if>
                        </c:if>
                    </span>
                    </td>
                </tr>
                <tr>
                    <th><spring:message code="common.reg.date"/></th>
                    <td>
                        <c:set var="regUserNm" value="${language == 'en' ? lab.regUserEngNm : lab.regUserKorNm}"/>
                        <fmt:formatDate var="regDate" value="${lab.regDate}" pattern="yyyy-MM-dd" /> <c:out value="${regDate}"/> ( <c:out value="${empty regUserNm ? 'ADMIN' : regUserNm}"/> )
                    </td>
                    <th><spring:message code="common.mod.date"/></th>
                    <td>
                        <c:set var="modUserNm" value="${language == 'en' ? lab.modUserEngNm : lab.modUserKorNm}"/>
                        <fmt:formatDate var="modDate" value="${lab.modDate}" pattern="yyyy-MM-dd" /> <c:out value="${modDate}"/> ( <c:out value="${empty modUserNm ? 'ADMIN' : modUserNm}"/> )
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
        <div id="intrItem" style="overflow: auto;">
            <table class="write_tbl mgb_30">
                <colgroup>
                    <col style="width:15%">
                    <col/>
                    <col/>
                    <col/>
                </colgroup>
                <tbody>
                <tr>
                    <th class="essential_th"><spring:message code="lab.intro.kor"/></th>
                    <td colspan="3">
                        <input type="hidden" name="korIntrcn" value="<c:out value="${lab.korIntrcn}"/>"/>
                        <div id="korIntrcnDiv"></div>
                    </td>
                </tr>
                <tr>
                    <th class="essential_th"><spring:message code="lab.intro.eng"/></th>
                    <td colspan="3">
                        <input type="hidden" name="engIntrcn" value="<c:out value="${lab.engIntrcn}"/>"/>
                        <div id="engIntrcnDiv"></div>
                    </td>
                </tr>
                <tr>
                    <th><spring:message code="lab.keyword.kor"/></th>
                    <td colspan="3">
                        <input class="input_type" style="width: 100%; margin-top: 4px;"
                                placeholder="<spring:message code="lab.keyword.placeholder"/>"
                               onkeyup="javascript:if(event.keyCode=='13')addKeyword($(this), 'kor');"/><br/>
                        <c:set var="keySet" value=""/>
                        <div style="margin-top: 4px; margin-left: 20px;" class="korKeywordArea">
                        <c:if test="${not empty korKeywordList}">
                            <c:forEach items="${korKeywordList}" var="keyword" varStatus="idx">
                                <c:set var="keySet" value="${keySet};${keyword.keyword}"/>
                                <c:set var="index" value="A${idx.count}"/>
                                <span>
                                    <input type="text" id="korKeyword${index}T" style="display:none;font-size:16px;"
                                           onkeyup="javascript:if(event.keyCode=='13')modKeyword('${index}','korEnd');">
                                    <span class="keyword_span">
                                        <a href="javascript:modKeyword('${index}','korStart');"
                                           id="korKeyword${index}A"><c:out value="${keyword.keyword}"/></a><button
                                            onclick="removeKeyword($(this),'kor');" class="keyword_close">x</button>
                                    </span>
                                </span>
                            </c:forEach>
                        </c:if>
                        </div>
                        <input type="hidden" name="korKeyword" value="<c:out value="${keySet}"/>"/>
                    </td>
                </tr>
                <tr>
                    <th><spring:message code="lab.keyword.eng"/></th>
                    <td colspan="3">
                        <input class="input_type" style="width: 100%; margin-top: 4px;"
                                placeholder="<spring:message code="lab.keyword.placeholder"/>"
                               onkeyup="javascript:if(event.keyCode=='13')addKeyword($(this), 'eng');"/><br/>
                        <c:set var="keySet" value=""/>
                        <div style="margin-top: 4px; margin-left: 20px;" class="engKeywordArea">
                        <c:if test="${not empty engKeywordList}">
                            <c:forEach items="${engKeywordList}" var="keyword" varStatus="idx">
                                <c:set var="keySet" value="${keySet};${keyword.keyword}"/>
                                <c:set var="index" value="A${idx.count}"/>
                                <span>
                                    <input type="text" id="engKeyword${index}T" style="display:none;font-size:16px;"
                                           onkeyup="javascript:if(event.keyCode=='13')modKeyword('${index}','engEnd');">
                                    <span class="keyword_span">
                                        <a href="javascript:modKeyword('${index}','engStart');"
                                           id="engKeyword${index}A"><c:out value="${keyword.keyword}"/></a><button
                                            onclick="removeKeyword($(this),'eng');" class="keyword_close">x</button>
                                    </span>
                                </span>
                            </c:forEach>
                        </c:if>
                        </div>
                        <input type="hidden" name="engKeyword" value="<c:out value="${keySet}"/>">
                    </td>
                </tr>
                <%--<tr>
                    <th><spring:message code="lab.faq.kor"/></th>
                    <td colspan="3">
                        <table style="width: 100%">
                            <c:if test="${not empty korFaqList}">
                                <c:forEach items="${korFaqList}" var="korFaq">
                                    <tbody>
                                    <tr>
                                        <th style="width: 6%; background: #c1c1c1;"><spring:message
                                                code="lab.faq.question"/></th>
                                        <td style="text-align: center;">
                                            <input type="text" name="korFaqQ" class="input_type"
                                                   value="<c:out value="${korFaq.question}"/>"
                                                   placeholder="<spring:message code='lab.faqQ.placeholder'/>"/>
                                        </td>
                                        <td rowspan="2" style="width:50px;">
                                            <a href="javascript:void(0);" class="tbl_icon_a row_add_bt"
                                               onclick="addFaq($(this));"><spring:message code='common.add'/></a>
                                            <a href="javascript:void(0);" class="tbl_icon_a red_del"
                                               onclick="removeFaq($(this));"><spring:message
                                                    code='common.row.delete'/></a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><spring:message code="lab.faq.answer"/></th>
                                        <td>
                                            <input type="text" name="korFaqA" class="input_type"
                                                   value="<c:out value="${korFaq.answer}"/>"/>
                                        </td>
                                    </tr>
                                    </tbody>
                                </c:forEach>
                            </c:if>
                            <c:if test="${empty korFaqList}">
                                <tbody>
                                <tr>
                                    <th style="width: 6%; background: #c1c1c1;"><spring:message
                                            code="lab.faq.question"/></th>
                                    <td style="text-align: center;">
                                        <input type="text" name="korFaqQ" class="input_type" value=""
                                               placeholder="<spring:message code='lab.faqQ.placeholder'/>"/>
                                    </td>
                                    <td rowspan="2" style="width:50px;">
                                        <a href="javascript:void(0);" class="tbl_icon_a row_add_bt"
                                           onclick="addFaq($(this));"><spring:message code='common.add'/></a>
                                        <a href="javascript:void(0);" class="tbl_icon_a red_del"
                                           onclick="removeFaq($(this));"><spring:message code='common.row.delete'/></a>
                                    </td>
                                </tr>
                                <tr>
                                    <th><spring:message code="lab.faq.answer"/></th>
                                    <td>
                                        <input type="text" name="korFaqA" class="input_type" value=""/>
                                    </td>
                                </tr>
                                </tbody>
                            </c:if>
                        </table>
                    </td>
                </tr>
                <tr>
                    <th><spring:message code="lab.faq.eng"/></th>
                    <td colspan="3">
                        <table style="width: 100%">
                            <c:if test="${not empty engFaqList}">
                                <c:forEach items="${engFaqList}" var="engFaq">
                                    <tbody>
                                    <tr>
                                        <th style="width: 6%; background: #c1c1c1;"><spring:message
                                                code="lab.faq.question"/></th>
                                        <td style="text-align: center;">
                                            <input type="text" name="engFaqQ" class="input_type"
                                                   value="<c:out value="${engFaq.question}"/>"
                                                   placeholder="<spring:message code='lab.faqQ.placeholder'/>"/>
                                        </td>
                                        <td rowspan="2" style="width:50px;">
                                            <a href="javascript:void(0);" class="tbl_icon_a row_add_bt"
                                               onclick="addFaq($(this));"><spring:message code='common.add'/></a>
                                            <a href="javascript:void(0);" class="tbl_icon_a red_del"
                                               onclick="removeFaq($(this));"><spring:message
                                                    code='common.row.delete'/></a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><spring:message code="lab.faq.answer"/></th>
                                        <td>
                                            <input type="text" name="engFaqA" class="input_type"
                                                   value="<c:out value="${engFaq.answer}"/>"/>
                                        </td>
                                    </tr>
                                    </tbody>
                                </c:forEach>
                            </c:if>
                            <c:if test="${empty engFaqList}">
                                <tbody>
                                <tr>
                                    <th style="width: 6%; background: #c1c1c1;"><spring:message
                                            code="lab.faq.question"/></th>
                                    <td style="text-align: center;">
                                        <input type="text" name="engFaqQ" class="input_type" value=""
                                               placeholder="<spring:message code='lab.faqQ.placeholder'/>"/>
                                    </td>
                                    <td rowspan="2" style="width:50px;">
                                        <a href="javascript:void(0);" class="tbl_icon_a row_add_bt"
                                           onclick="addFaq($(this));"><spring:message code='common.add'/></a>
                                        <a href="javascript:void(0);" class="tbl_icon_a red_del"
                                           onclick="removeFaq($(this));"><spring:message code='common.row.delete'/></a>
                                    </td>
                                </tr>
                                <tr>
                                    <th><spring:message code="lab.faq.answer"/></th>
                                    <td>
                                        <input type="text" name="engFaqA" class="input_type" value=""/>
                                    </td>
                                </tr>
                                </tbody>
                            </c:if>
                        </table>
                    </td>
                </tr>--%>
                </tbody>
            </table>
        </div>
        <div id="faqItem" style="overflow: auto;">
            <table class="write_tbl mgb_30">
                <colgroup>
                    <col style="width:15%">
                    <col/>
                    <col/>
                    <col/>
                </colgroup>
                <tbody>
                <tr>
                    <th><spring:message code="lab.faq.kor"/></th>
                    <td colspan="3">
                        <table style="width: 100%">
                            <c:if test="${not empty korFaqList}">
                                <c:forEach items="${korFaqList}" var="korFaq">
                                    <tbody>
                                    <tr>
                                        <th style="width: 6%; background: #c1c1c1;"><spring:message
                                                code="lab.faq.question"/></th>
                                        <td style="text-align: center;">
                                            <input type="text" name="korFaqQ" class="input_type" style="height: 30px;"
                                                   value="<c:out value="${korFaq.question}"/>"
                                                   placeholder="<spring:message code='lab.faqQ.placeholder'/>"/>
                                        </td>
                                        <td rowspan="2" style="width:50px;">
                                            <a href="javascript:void(0);" class="tbl_icon_a row_add_bt"
                                               onclick="addFaq($(this));"><spring:message code='common.add'/></a>
                                            <a href="javascript:void(0);" class="tbl_icon_a red_del"
                                               onclick="removeFaq($(this));"><spring:message
                                                    code='common.row.delete'/></a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><spring:message code="lab.faq.answer"/></th>
                                        <td>
                                            <%--<input type="text" name="korFaqA" class="input_type"
                                                   value="<c:out value="${korFaq.answer}"/>"/>--%>
                                            <textarea name="korFaqA" class="input_type"
                                                      onchange="$(this).parent().children('input').val($(this).val());"
                                                      style="padding: 4px 2px 2px 6px; height: 50px;">${korFaq.answer}</textarea>
                                            <input type="hidden" name="korFaqA" value="${korFaq.answer}"/>
                                        </td>
                                    </tr>
                                    </tbody>
                                </c:forEach>
                            </c:if>
                            <c:if test="${empty korFaqList}">
                                <%
                                    LinkedHashMap<String, String> korFaqQMap = CodeConfiguration.getCode("lab.faq.question","KOR");
                                    LinkedHashMap<String, String> korFaqAMap = CodeConfiguration.getCode("lab.faq.answer","KOR");
                                    System.out.println("korFaqQMap.size() >>>" + korFaqQMap.size());
                                    if(korFaqQMap != null && korFaqQMap.size() > 0){
                                        for(String key : korFaqQMap.keySet()){
                                            String korQ = StringUtils.defaultString(korFaqQMap.get(key));
                                            String korA = StringUtils.defaultString(korFaqAMap.get(key));
                                %>
                                <tbody>
                                <tr>
                                    <th style="width: 6%; background: #c1c1c1;"><spring:message code="lab.faq.question"/></th>
                                    <td style="text-align: center;">
                                        <input style="height: 30px;" type="text" name="korFaqQ" class="input_type" value="" placeholder="<%=korQ%>"/>
                                    </td>
                                    <td rowspan="2" style="width:50px;">
                                        <a href="javascript:void(0);" class="tbl_icon_a row_add_bt" onclick="addFaq($(this));"><spring:message code='common.add'/></a>
                                        <a href="javascript:void(0);" class="tbl_icon_a red_del" onclick="removeFaq($(this));"><spring:message code='common.row.delete'/></a>
                                    </td>
                                </tr>
                                <tr>
                                    <th><spring:message code="lab.faq.answer"/></th>
                                    <td>
                                        <%--<input type="text" name="korFaqA" class="input_type" value="" placeholder="<%=korA%>"/>--%>
                                        <textarea name="korFaqA" class="input_type" placeholder="<%=korA%>"
                                                  onchange="$(this).parent().children('input').val($(this).val());"
                                                  style="padding: 4px 2px 2px 6px; height: 50px;"></textarea>
                                        <input type="hidden" name="korFaqA" value=""/>
                                    </td>
                                </tr>
                                </tbody>
                                <%
                                    }
                                }else
                                    {
                                %>
                                <tbody>
                                <tr>
                                    <th style="width: 6%; background: #c1c1c1;"><spring:message code="lab.faq.question"/></th>
                                    <td style="text-align: center;">
                                        <input style="height: 30px;" type="text" name="korFaqQ" class="input_type" value="" placeholder="<spring:message code='lab.faqQ.placeholder'/>"/>
                                    </td>
                                    <td rowspan="2" style="width:50px;">
                                        <a href="javascript:void(0);" class="tbl_icon_a row_add_bt" onclick="addFaq($(this));"><spring:message code='common.add'/></a>
                                        <a href="javascript:void(0);" class="tbl_icon_a red_del" onclick="removeFaq($(this));"><spring:message code='common.row.delete'/></a>
                                    </td>
                                </tr>
                                <tr>
                                    <th><spring:message code="lab.faq.answer"/></th>
                                    <td>
                                        <%--<input type="text" name="korFaqA" class="input_type" value=""/>--%>
                                        <textarea name="korFaqA" class="input_type"
                                                  onchange="$(this).parent().children('input').val($(this).val());"
                                                  style="padding: 4px 2px 2px 6px; height: 50px;"></textarea>
                                        <input type="hidden" name="korFaqA" value=""/>
                                    </td>
                                </tr>
                                </tbody>
                                <%
                                    }
                                %>
                            </c:if>
                        </table>
                    </td>
                </tr>
                <tr>
                    <th><spring:message code="lab.faq.eng"/></th>
                    <td colspan="3">
                        <table style="width: 100%">
                            <c:if test="${not empty engFaqList}">
                                <c:forEach items="${engFaqList}" var="engFaq">
                                    <tbody>
                                    <tr>
                                        <th style="width: 6%; background: #c1c1c1;"><spring:message
                                                code="lab.faq.question"/></th>
                                        <td style="text-align: center;">
                                            <input type="text" name="engFaqQ" class="input_type" style="height: 30px;"
                                                   value="<c:out value="${engFaq.question}"/>"
                                                   placeholder="<spring:message code='lab.faqQ.placeholder'/>"/>
                                        </td>
                                        <td rowspan="2" style="width:50px;">
                                            <a href="javascript:void(0);" class="tbl_icon_a row_add_bt"
                                               onclick="addFaq($(this));"><spring:message code='common.add'/></a>
                                            <a href="javascript:void(0);" class="tbl_icon_a red_del"
                                               onclick="removeFaq($(this));"><spring:message
                                                    code='common.row.delete'/></a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><spring:message code="lab.faq.answer"/></th>
                                        <td>
                                            <%--<input type="text" name="engFaqA" class="input_type"
                                                   value="<c:out value="${engFaq.answer}"/>"/>--%>
                                            <textarea name="engFaqA" class="input_type"
                                                      onchange="$(this).parent().children('input').val($(this).val());"
                                                      style="padding: 4px 2px 2px 6px; height: 50px;">${engFaq.answer}</textarea>
                                            <input type="hidden" name="engFaqA" value="${engFaq.answer}"/>
                                        </td>
                                    </tr>
                                    </tbody>
                                </c:forEach>
                            </c:if>
                            <c:if test="${empty engFaqList}">
                                <%
                                    LinkedHashMap<String, String> engFaqQMap = CodeConfiguration.getCode("lab.faq.question","ENG");
                                    LinkedHashMap<String, String> engFaqAMap = CodeConfiguration.getCode("lab.faq.answer","ENG");
                                    if(engFaqQMap != null && engFaqQMap.size() > 0){
                                        for(String key : engFaqQMap.keySet()){
                                            String engQ = StringUtils.defaultString(engFaqQMap.get(key));
                                            String engA = StringUtils.defaultString(engFaqAMap.get(key));
                                %>
                                <tbody>
                                <tr>
                                    <th style="width: 6%; background: #c1c1c1;"><spring:message code="lab.faq.question"/></th>
                                    <td style="text-align: center;">
                                        <input style="height: 30px;" style="height: 30px;" type="text" name="engFaqQ" class="input_type" value="" placeholder="<%=engQ%>"/>
                                    </td>
                                    <td rowspan="2" style="width:50px;">
                                        <a href="javascript:void(0);" class="tbl_icon_a row_add_bt" onclick="addFaq($(this));"><spring:message code='common.add'/></a>
                                        <a href="javascript:void(0);" class="tbl_icon_a red_del" onclick="removeFaq($(this));"><spring:message code='common.row.delete'/></a>
                                    </td>
                                </tr>
                                <tr>
                                    <th><spring:message code="lab.faq.answer"/></th>
                                    <td>
                                        <%--<input type="text" name="engFaqA" class="input_type" value="" placeholder="<%=engA%>"/>--%>
                                        <textarea name="engFaqA" class="input_type" placeholder="<%=engA%>"
                                                  onchange="$(this).parent().children('input').val($(this).val());"
                                                  style="padding: 4px 2px 2px 6px; height: 50px;"></textarea>
                                        <input type="hidden" name="engFaqA" value=""/>
                                    </td>
                                </tr>
                                </tbody>
                                <%
                                    }
                                }else{
                                %>
                                <tbody>
                                <tr>
                                    <th style="width: 6%; background: #c1c1c1;"><spring:message code="lab.faq.question"/></th>
                                    <td style="text-align: center;">
                                        <input style="height: 30px;" type="text" name="engFaqQ" class="input_type" value=""
                                               placeholder="<spring:message code='lab.faqQ.placeholder'/>"/>
                                    </td>
                                    <td rowspan="2" style="width:50px;">
                                        <a href="javascript:void(0);" class="tbl_icon_a row_add_bt"
                                           onclick="addFaq($(this));"><spring:message code='common.add'/></a>
                                        <a href="javascript:void(0);" class="tbl_icon_a red_del"
                                           onclick="removeFaq($(this));"><spring:message code='common.row.delete'/></a>
                                    </td>
                                </tr>
                                <tr>
                                    <th><spring:message code="lab.faq.answer"/></th>
                                    <td>
                                        <%--<input type="text" name="engFaqA" class="input_type" value=""/>--%>
                                        <textarea name="engFaqA" class="input_type" onchange="$(this).parent().children('input').val($(this).val());"
                                                  style="padding: 4px 2px 2px 6px; height: 50px;"></textarea>
                                        <input type="hidden" name="engFaqA" value=""/>
                                    </td>
                                </tr>
                                </tbody>
                                <%
                                    }
                                %>
                            </c:if>
                        </table>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>
</form>
<%--<c:set var="search" value="'" />--%>
<%--<c:set var="replace" value="\\'" />--%>
<%--<c:set var="korIntrcn" value="${fn:replace(lab.korIntrcn, search, replace)}"/>--%>
<%--<c:set var="engIntrcn" value="${fn:replace(lab.engIntrcn, search, replace)}"/>--%>
<%--<input type="hidden" id="korIntrcn" value="<c:out value="${korIntrcn}" escapeXml="true"/>"/>--%>
<%--<input type="hidden" id="engIntrcn" value="<c:out value="${engIntrcn}" escapeXml="true"/>"/>--%>
<script type="text/javascript">
    var myTabbar;

    $(document).ready(function () {

        myTabbar = new dhtmlXTabBar('mainTabbar');
        myTabbar.setArrowsMode("auto");
        myTabbar.enableAutoReSize(true);

        myTabbar.addTab('a1', '<spring:message code="lab.tab1"/>');
        myTabbar.addTab('a2', '<spring:message code="lab.tab2"/>');
        myTabbar.addTab('a3', '<spring:message code="lab.tab4"/>');

        myTabbar.tabs('a1').attachObject('comItem');
        myTabbar.tabs('a2').attachObject('intrItem');
        myTabbar.tabs('a3').attachObject('faqItem');

        $('input, select, textarea').change(function () {
            isChange = true;
        });
        $('input:checkbox, input:radio').click(function () {
            isChange = true;
        });

        var hSize = ($(window).height() - (80 + $('.title_box').height() + $('#vrfcArea').height() + $('.top_help_wrap').height() + $('.list_bt_area').height())) + "px";
        $('#mainTabbar').css({'height': hSize});

        myTabbar.tabs('a1').setActive();

        $('#korIntrcnDiv').summernote({
            height: 180,
            placeholder: '"맑은 고딕" 혹은 "Arial" 글씨체와 "14" 폰트 사용을 권고합니다.',
            toolbar: [
                ['style', ['style']],
                ['font', ['fontsize', 'bold', 'underline', 'clear']],
                ['fontname', ['fontname']],
                ['color', ['color']],
                ['para', ['paragraph']],
                ['table', ['table']],
                ['insert', ['link', 'picture']]
            ]
        });

        $('#engIntrcnDiv').summernote({
            height: 180,
            placeholder: 'It is recommended to enter "맑은 고딕" or "Arial" fonts and "14" fonts.',
            toolbar: [
                ['style', ['style']],
                ['font', ['fontsize', 'bold', 'underline', 'clear']],
                ['fontname', ['fontname']],
                ['color', ['color']],
                ['para', ['paragraph']],
                ['table', ['table']],
                ['insert', ['link', 'picture']]
            ]
        });

        <c:if test="${not empty lab.korIntrcn}">
        setTimeout(function() {
            $("#korIntrcnDiv").summernote("code", document.getElementsByName("korIntrcn")[0].value);
            $("#korIntrcnDiv").summernote('fontName', '맑은 고딕');
        }, 1000);
        </c:if>
        <c:if test="${not empty lab.engIntrcn}">
        setTimeout(function() {
            $("#engIntrcnDiv").summernote("code", document.getElementsByName("engIntrcn")[0].value);
            $("#engIntrcnDiv").summernote("fontName", 'Arial');
        }, 1000);
        </c:if>

        $(".dhx_cell_cont_tabbar").css("overflow", "auto");

        if ($("input[name='videoLink']").val() != '') loadThumbnail($("input[name='videoLink']").val());
    });
</script>

