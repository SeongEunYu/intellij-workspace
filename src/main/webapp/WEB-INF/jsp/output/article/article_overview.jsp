<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../pageInit.jsp" %>
<style>
table#overviewTbl tr {height: 32px;}
table#overviewTbl td {padding: 5px 12px;}
</style>
<div class="contents_box" style="width:887px;">
<div class="list_bt_area">
	<div class="list_set">
		<ul>
			<c:if test="${not empty param.mode and param.mode eq 'dplct'}">
			<li><a href="javascript:articleMove('${article.articleId}');" class="list_icon04">선택된 논문 수정페이지로 이동</a></li>
			</c:if>
			<c:if test="${not empty param.mode and param.mode eq 'search'}">
			<li><a href="javascript:resultArticleInput('${article.mngNo}');" class="list_icon04">논문 입력</a></li>
			</c:if>
		</ul>
	</div>
</div>
<table id="overviewTbl" class="write_tbl mgb_10">
	<colgroup>
		<col style="width:130px;" />
		<col style="width:151px;" />
		<col style="width:130px" />
		<col style="width:151px;" />
		<col style="width:130px" />
		<col style="" />
	</colgroup>
	<tbody>
		<c:if test="${sysConf['modifiy.show.mngno'] eq 'Y' and not empty article.mngNo }">
		<tr>
			<th>URP 제어번호</th>
			<td colspan="5">
				${article.mngNo}
				<p class="tbl_addbt_p">URP 시스템과 연계 결과로 생성된 논문 제어번호입니다.</p>
			</td>
		</tr>
		</c:if>
		<c:if test="${not empty param.mode and param.mode eq 'dplct'}">
		<tr>
			<th><spring:message code='art.scjnl.dvs.cd'/></th>
			<td>${rims:codeValue('1100',article.scjnlDvsCd)}</td>
	        <th <c:if test="${article.scjnlDvsCd eq 3 or article.scjnlDvsCd eq 4 }" >style="display:none;"</c:if> >
	        	<spring:message code='art.ovrs.exclnc.scjnl'/>
	        </th>
	        <td <c:if test="${article.scjnlDvsCd eq 3 or article.scjnlDvsCd eq 4 }" >style="display:none;"</c:if> >
	        	${rims:codeValue('1380',article.ovrsExclncScjnlPblcYn)}
	        </td>
	        <th <c:if test="${article.scjnlDvsCd ne 3 and article.scjnlDvsCd ne 4 }" >style="display:none;"</c:if> >
	        	<spring:message code='art.krf.reg.pblc'/>
	        </th>
	        <td <c:if test="${article.scjnlDvsCd ne 3 and article.scjnlDvsCd ne 4 }" >style="display:none;"</c:if> >
	        	${rims:codeValue('1390',article.krfRegPblcYn)}
	        </td>
	        <th><spring:message code='art.doc.type.cd'/></th>
	        <td>${article.docType}</td>
		</tr>
		</c:if>
		<tr>
			<th><spring:message code='art.scjnl.nm'/></th>
			<td colspan="3">
				<input type="hidden" id="result_scjnlNm"  value="<c:out value="${article.scjnlNm}"/>"/>
				<c:out value="${article.scjnlNm}"/>
			</td>
			<th><spring:message code='art.issn.no'/></th>
			<td>
				<input type="hidden" id="result_issnNo"  value="<c:out value="${article.issnNo}"/>"/>
				${article.issnNo}
			</td>
		</tr>
		<tr>
			<th><spring:message code='art.pblc.plc'/></th>
			<td colspan="3">
				<input type="hidden" id="result_pblcPlcNm"  value="<c:out value="${article.pblcPlcNm}"/>"/>
				<c:out value="${article.pblcPlcNm}"/>
			</td>
			<th><spring:message code='art.pblc.ntn'/></th>
			<td>
				<input type="hidden" id="result_pblcNtnCd"  value="<c:out value="${article.pblcNtnCd}"/>"/>
				${rims:codeValue('2000',article.pblcNtnCd)}
			</td>
		</tr>
		<tr>
			<th><spring:message code='art.pblc.ym'/></th>
			<td colspan="5">
				<input type="hidden" id="result_pblcYm"  value="<c:out value="${article.pblcYm}"/>"/>
				<ui:dateformat value="${article.pblcYm}" pattern="yyyy.MM.dd" />
			</td>
		</tr>
		<tr>
			<th><spring:message code='art.volume'/></th>
			<td>
				Vol. <c:out value="${article.volume}"/>
				<input type="hidden" id="result_volume"  value="<c:out value="${article.volume}"/>"/>
			</td>
			<th><spring:message code='art.issue'/></th>
			<td>
				No. <c:out value="${article.issue}"/>
				<input type="hidden" id="result_issue"  value="<c:out value="${article.issue}"/>"/>
			</td>
			<th><spring:message code='art.page'/></th>
			<td>
				<c:out value="${article.sttPage}"/> - <c:out value="${article.endPage}"/>
				<input type="hidden" id="result_sttPage"  value="<c:out value="${article.sttPage}"/>"/>
				<input type="hidden" id="result_endPage"  value="<c:out value="${article.endPage}"/>"/>
			</td>
		</tr>
		<c:if test="${not empty param.mode and param.mode eq 'dplct'}">
		<tr>
			<th><spring:message code='art.pblc.language'/></th>
			<td>
				${rims:codeValue('2020',article.pprLangDvsCd)}
				<input type="hidden" id="result_pprLangDvsCd"  value="<c:out value="${article.pprLangDvsCd}"/>"/>
			</td>
			<th>ImpactFactor(Official)</th>
			<td>${empty article.impctFctr ? '없음' : article.impctFctr}</td>
			<th>ImpactFactor(Private)</th>
			<td>${fn:escapeXml(article.impctFctrUsr)}</td>
		</tr>
		</c:if>
		<tr>
			<th><spring:message code='art.title.org'/></th>
			<td colspan="5">
				<input type="hidden" id="result_orgLangPprNm"  value="<c:out value="${article.orgLangPprNm}"/>"/>
				<c:out value="${article.orgLangPprNm}"/>
			</td>
		</tr>
		<c:if test="${not empty article.diffLangPprNm or (not empty param.mode and param.mode eq 'dplct')}">
		<tr>
			<th><spring:message code='art.title.diff'/></th>
			<td colspan="5">
				<input type="hidden" id="result_diffLangPprNm"  value="<c:out value="${article.diffLangPprNm}"/>"/>
				${article.diffLangPprNm}
			</td>
		</tr>
		</c:if>
		<tr>
			<th><spring:message code='art.authors'/></th>
			<td colspan="5">
				<div class="writer_td_inner">
				  <input type="hidden" id="result_totalAthrCnt"  value="<c:out value="${article.totalAthrCnt}"/>"/>
				  <p>전체저자수 : <c:out value="${article.totalAthrCnt}"/></p>
				</div>
			</td>
		</tr>
		<tr>
			<td colspan="6" class="inner_tbl_td">
				<table class="inner_tbl" id="prtcpntTbl" style="height: 50px;">
					<colgroup>
						<col style="width:60px;" />
						<col style="width:140px;" />
						<col style="width:160px" />
						<col style="width:120px;" />
						<%--
						<col style="width:170px" />
						 --%>
						<col style="" />
						<col style="width:150px;" />
					</colgroup>
					<thead>
					  <tr>
						<th>No</th>
						<th><spring:message code='art.short.name'/></th>
						<th><spring:message code='art.full.name'/></th>
						<th><spring:message code='art.tpi.dvs'/></th>
						<%--
						<th>개인번호</th>
						 --%>
						<th><spring:message code='art.agc.nm'/></th>
						<th><spring:message code='art.author.dept'/></th>
					  </tr>
					</thead>
					<tbody>
				<c:if test="${not empty article.partiList}">
					<c:forEach items="${article.partiList}" var="parti" varStatus="idx">
						<tr id="prtcpnt${idx.count}" class="prtcpnt">
							<td style="text-align: center;">
								${idx.count}
								<input type="hidden" id="parti_prtcpntId${idx.count}"  value="<c:out value="${parti.prtcpntId}"/>"/>
							</td>
							<td style="text-align: center;">
								<c:out value="${parti.prtcpntNm}"/>
								<input type="hidden" id="parti_prtcpntNm${idx.count}"  value="<c:out value="${parti.prtcpntNm}"/>"/>
							</td>
							<td style="text-align: center;">
								<c:out value="${parti.prtcpntFullNm}"/>
								<input type="hidden" id="parti_prtcpntFullNm${idx.count}"  value="<c:out value="${parti.prtcpntFullNm}"/>"/>
							</td>
							<td style="text-align: center;">
								${rims:codeValue('1180', parti.tpiDvsCd) }
								<input type="hidden" id="parti_tpiDvsCd${idx.count}"  value="<c:out value="${parti.tpiDvsCd}"/>"/>
							</td>
							<%--
							<td style="text-align: center;">${fn:escapeXml(parti.prtcpntId)}</td>
							 --%>
							<td style="text-align: left;">
								<c:out value="${parti.blngAgcNm}"/>
								<input type="hidden" id="parti_blngAgcNm${idx.count}"  value="<c:out value="${parti.blngAgcNm}"/>"/>
							</td>
							<td style="text-align: left;"><c:out value="${parti.deptKor}"/></td>
						</tr>
					</c:forEach>
				</c:if>
				<c:if test="${empty article.partiList and  not empty article.authors }">
					<c:set var="authors"  value="${fn:split(article.authors,' and ')}" />
					<c:forEach var="authr"  items="${authors}" varStatus="idx">
						<tr id="prtcpnt${idx.count}" class="prtcpnt">
							<td style="text-align: center;">${idx.count}</td>
							<td style="text-align: center;"></td>
							<td style="text-align: center;">${fn:escapeXml(authr)}</td>
							<td style="text-align: center;"></td>
							<%--
							<td style="text-align: center;">${fn:escapeXml(parti.prtcpntId)}</td>
							 --%>
							<td style="text-align: left;"></td>
							<td style="text-align: left;"></td>
						</tr>
					</c:forEach>
				</c:if>
					</tbody>
			  </table>
			</td>
		</tr>
		<tr>
			<th>DOI</th>
			<td colspan="5">
				<c:if test="${not empty article.doi}">
					<a href="http://dx.doi.org/${article.doi}" target="_blank">http://dx.doi.org/${article.doi}</a>
				</c:if>
				<input type="hidden" id="result_doi"  value="<c:out value="${article.doi}"/>"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code='art.abst'/></th>
			<td colspan="5">
				<input type="hidden" id="result_abstCntn"  value="<c:out value="${article.abstCntn}"/>"/>
				<c:out value="${article.abstCntn}"/>
			</td>
		</tr>
	</tbody>
</table>
</div>
