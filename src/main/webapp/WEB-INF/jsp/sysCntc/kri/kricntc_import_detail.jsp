<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%@
    page import="java.util.Map"%><%@
    page import="org.apache.commons.lang.ObjectUtils"%><%@
    page import="java.util.List"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=application.getInitParameter("exrimsTitle") %></title>
<%@include file="../../adminRimsInit.jsp" %>
<script type="text/javascript">
function insertKriData(mngNo){
	if(confirm('iROMS로 반입하시겠습니까?')){
		$j.ajax({
			url:'<%=request.getContextPath()%>/KRIWorkBench/kriDataInputProc.do',
			dataType:'json',
			method:'POST',
			data:{'mng_no':mngNo},
			success:function(data){
				alert(data.msg);
				if(data.code == 'success'){
					window.opener.myGRID_load();
					self.close();
				}
			}
		});
	}
}
function exceptKriData(mngNo){
	if(confirm('제외 처리하시겠습니까?')){
		$j.ajax({
			url:'<%=request.getContextPath()%>/KRIWorkBench/kriDataExceptProc.do',
			dataType:'json',
			method:'POST',
			data:{'mng_no':mngNo},
			success:function(data){
				alert(data.msg);
				if(data.code == 'success'){
					window.opener.myGRID_load();
					self.close();
				}
			}
		});
	}
}
</script>
<style type="text/css">
 .pfmc_input_tb th{
 	padding: 6px 6px 6px 6px;
 }
 .pfmc_input_tb td{
 	padding: 6px 6px 6px 6px;
 }
 .txt_line{
 	word-break:normal;
 }
 .title {
 	float:left; 
 	color:#3f3f3f; 
 	font:bold 15px "맑은고딕","Malgun Gothic","Arial"; 
 	text-decoration:none;
 }
</style>
</head>
	<body style="height: 100%; overflow: auto;">
		<div id="content_wrapper_sub" style="width: 752px;padding-bottom: 15px;">
			<!-- START 페이지탑 -->
		<div id="page_top" >
			<div class="page_title">KRI Data Process</div>
			<!-- START 탑 버튼 영역 -->
			<div class="top_btnarea">
				<c:if test="${article.IS_MIG eq 'N' }">
					<a href="#" onclick="javascript:insertKriData('${article.MNG_NO}');">
						<img src='<%=request.getContextPath() %>/images/KOR/button/btn_carry.gif' alt="반입" id="input"/>
					</a>
					<a href="#" onclick="javascript:exceptKriData('${article.MNG_NO}');">
						<img src='<%=request.getContextPath() %>/images/KOR/button/btn_except.gif' alt="반입" id="except"/>
					</a>
				</c:if>
				<c:if test="${article.IS_MIG eq 'E' }">
					<a href="#" onclick="javascript:insertKriData('${article.MNG_NO}');">
						<img src='<%=request.getContextPath() %>/images/KOR/button/btn_carry.gif' alt="반입" id="input"/>
					</a>
				</c:if>
			</div>
		</div>	
			<table class="pfmc_input_tb" style="table-layout: fixed;">
				<colgroup>
					<col style="width: 40px;"/>
					<col style="width: 150px;"/>
					<col style="width: 40px;"/>
					<col style="width: 150px;"/>				
				</colgroup>
				<tbody>
					<tr>
						<th>논문명</th>
						<td colspan="3">
							<div class="txt_line">${article.ORG_LANG_PPR_NM}</div>
						</td>
					</tr>	
					<tr>
						<th>저널명</th>
						<td colspan="3">
							<div class="txt_line">${article.SCJNL_NM}</div>
						</td>
					</tr>	
					<tr>
						<th>저널구분</th>
						<td class="borderRight">${rims:codeValue('1100',article.SCJNL_DVS_CD)}</td>
						<th>SCI구분</th>
						<td>${rims:codeValue('1380',article.OVRS_EXCLNC_SCJNL_PBLC_YN)}</td>
					</tr>	
					<tr>
						<th>출판사</th>
						<td class="borderRight">${article.PBLC_PLC_NM}</td>
						<th>발행국</th>
						<td>${rims:codeValue('2000',article.PBLC_NTN_CD)}</td>
					</tr>
					<tr>
						<th>게재년월</th>
						<td class="borderRight"><u:dateformat value="${article.PBLC_YM}" pattern="yyyy.MM.dd" /></td>
						<th>ISSN</th>
						<td>${article.ISSN_NO}</td>
					</tr>
					<tr>
						<th>VOL</th>
						<td class="borderRight">${article.PBLC_VOL_NO}</td>
						<th>NO</th>
						<td>${article.PBLC_BK_NO}</td>
					</tr>
					<tr>
						<th>시작페이지</th>
						<td class="borderRight">${article.STT_PAGE}</td>
						<th>종료페이지</th>
						<td>${article.END_PAGE}</td>
					</tr>
					<tr>
						<th>저자</th>
						<td colspan="3">
						<c:set var="divHeight" value="200" />
						<c:if test="${fn:length(partiList) < 6 }">
							<c:set var="divHeight" value="${(fn:length(partiList)+1)*29 }" />
						</c:if>
						<div style="height : ${divHeight}px; overflow: auto;width:100%; padding: 1px 0px 0px;">
							<table class="pfmc_input_tb" style="padding: 3px 3px 3px 3px;">
								<colgroup>
									<col style="width: 30px;"/>
									<col style="width: 140px;"/>
									<col style="width: 70px;"/>
									<col style="width: 140px;"/>
									<col style="width: 50px;"/>
								</colgroup>
								<thead>
									<tr>
										<th style="text-align: center;" class="borderRight">NO</th>
										<th style="text-align: center;" class="borderRight">자저명</th>
										<th style="text-align: center;" class="borderRight">역할</th>
										<th style="text-align: center;" class="borderRight">소속기관</th>
										<th style="text-align: center;" class="borderRight">IBS ID</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach items="${partiList }" var="pl" varStatus="idx">
										<tr>
											<td style="text-align: center;" class="borderRight"><fmt:formatNumber type="number" value="${idx.count}"/></td>
											<td style="text-align: center;" class="borderRight">${pl.PRTCPNT_NM}</td>
											<td style="text-align: center;" class="borderRight">${rims:codeValue('1180',pl.TPI_DVS_CD)}</td>
											<td style="text-align: center;" class="borderRight">${pl.BLNG_AGC_NM}</td>
											<td style="text-align: center;" class="borderRight">${pl.USER_ID}</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>
						</td>
					</tr>
					<tr>
						<th>초록</th>
						<td colspan="3">
							<div class="txt_line">${article.ABST_CNTN}</div>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<c:if test="${dpltArtCnt > 0 }">
		<div id="content_wrapper_sub" style="width: 752px;padding-bottom: 15px;"> <%-- 중복 논문 목록 표시 --%>
			<div class="title">Duplicate Article</div>
			<div style="float: right;">(논문명,ISSN번호,권,호,시작페이지으로 중복체크)</div>
			<table class="pfmc_input_tb" style="table-layout: fixed;margin-top: 0px;">
				<colgroup>
					<col style="width: 10px;"/>
					<col style="width: 150px;"/>
				</colgroup>			
				<tbody>
					<c:forEach items="${dpltArtilceList}" var="dal" varStatus="idx">
						<c:if test="${empty dal.MNG_NO}">
							<tr>
								<td style="text-align: center;" class="borderRight">${idx.count }</td>
								<td>
									<div class="txt_line">
										[${dal.ARTICLE_ID}<c:if test="${dal.DEL_DVS_CD eq 'Y' }">:<font style="color: red;font-weight: bold;">삭제됨</font></c:if>]
										<a href="#" onclick="javascript:articleInfo('${dal.ARTICLE_ID}')">
										<font style="color: highlighttext;font-weight: bold;">
											<b>${dal.ORG_LANG_PPR_NM}</b>
										</font>	
										</a>
									</div>
									<div>
										&nbsp;/ ${dal.AUTHORS } &nbsp; 
									</div>
									<div>
										( <c:if test="${not empty dal.PBLC_PLC_NM }" >${dal.PBLC_PLC_NM },&nbsp;</c:if>${dal.SCJNL_NM},&nbsp;v.${dal.VOLUME},&nbsp;no.${dal.ISSUE},&nbsp;pp.${dal.STT_PAGE}~${dal.END_PAGE},&nbsp;<u:dateformat value="${dal.PBLC_YM}" pattern="yyyy.MM.dd" />)	
									</div>
								</td>
							</tr>
						</c:if>
					</c:forEach>
				</tbody>
			</table>			
		</div>
		</c:if>
		<c:if test="${reflctArtCnt > 0 }">
		<div id="content_wrapper_sub" style="width: 752px;padding-bottom: 15px;"> <%-- 반영 논문 목록 표시 --%>
			<div class="title">Reflected Article</div>
			<table class="pfmc_input_tb" style="table-layout: fixed;margin-top: 0px;">
				<colgroup>
					<col style="width: 10px;"/>
					<col style="width: 100px;"/>
				</colgroup>				
				<tbody>
					<c:forEach items="${dpltArtilceList}" var="dal" varStatus="idx">
						<c:if test="${not empty dal.MNG_NO}">
							<tr>
								<td style="text-align: center;" class="borderRight">${idx.count }</td>
								<td>
									<div class="txt_line">
										[${dal.ARTICLE_ID}<c:if test="${dal.DEL_DVS_CD eq 'Y' }">:<font style="color: red;font-weight: bold;">삭제됨</font></c:if>]
										<a href="#" onclick="javascript:articleInfo('${dal.ARTICLE_ID}')">											
											<b>${dal.ORG_LANG_PPR_NM}</b>
										</a>
									</div>
									<div>
										&nbsp;/ ${dal.AUTHORS } &nbsp; 
									</div>
									<div>
										( <c:if test="${not empty dal.PBLC_PLC_NM }" >${dal.PBLC_PLC_NM },&nbsp;</c:if>${dal.SCJNL_NM},&nbsp;v.${dal.VOLUME},&nbsp;no.${dal.ISSUE},&nbsp;pp.${dal.STT_PAGE}~${dal.END_PAGE},&nbsp;<u:dateformat value="${dal.PBLC_YM}" pattern="yyyy.MM.dd" />)	
									</div>
								</td>
							</tr>
						</c:if>
					</c:forEach>
				</tbody>
			</table>			
		</div>
		</c:if>
	</body>
<script type="text/javascript">
function articleInfo(id) {
	window.open( rimsPath+"/article/articleInfo.do?article_id="+id, "articleInfo", "width=776,height=920,scrollbars=yes");
}
</script>	
</html>
