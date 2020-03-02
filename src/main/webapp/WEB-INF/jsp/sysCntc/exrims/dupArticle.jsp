<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="cache-Control" content="co-cache" />
<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=yes" />
<title>${sysConf['system.rims.jsp.title']}</title>
<%@include file="../../pageInit.jsp" %>
<link type="text/css" href="${pageContext.request.contextPath}/css/layout.css" rel="stylesheet" />
<link type="text/css" href="${pageContext.request.contextPath}/js/dhtmlx/skins/${sysConf['dhtmlx.skin']}/dhtmlx.css" rel="stylesheet" />
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/dhtmlx/dhtmlx.js"></script>
<script type="text/javascript">
	function toMerge(eId){
		var radio = document.getElementsByName("dupArt");
		var flag  = 0;
		var rId   = "";
		for(var i = 0 ; i < radio.length ; i++){
			if(radio[i].checked == true){
				rId = radio[i].value;
				flag++;
			}
		}
		if(flag == 0){
			dhtmlx.alert({type:"alert-warning",text:"선택된 데이터가 없습니다.",callback:function(){ $('#dupArt').focus();}});
			return;
		}else {
			if(rId == "None"){
				dhtmlx.confirm({
					title:"논문으로 반입",
					ok:"Yes", cancel:"No",
					text:"ExRIMS 논문자료를 반입합니다.",
					callback:function(result){
						if(result == true){
							$.ajax({
								url: "${contextPath}/erCntc/toArticle.do",
								dataType: "xml",
								data: {"flag":"1", "idList": eId},
								method: "POST",
								success: function(data){}
							}).done(function(data){
								if(data.code == "001")
								{
									dhtmlx.alert({type:"alert-warning",text:"반입되었습니다.",callback:function(){}})
									window.opener.location.reload();
									window.close();
								}
							});
						}
					}
				});
			}else {
				dhtmlx.confirm({
					title:"논문자료 병합",
					ok:"Yes", cancel:"No",
					text:"ExRIMS 논문자료를 병합합니다.<br/>병합 후 병합된 자료의 수정화면으로 이동합니다.",
					callback:function(result){
						if(result == true){
							window.opener.location.reload();
							location.href = '${contextPath}/erCntc/dupConfirm.do?rId='+rId+'&eId='+eId;
						}
						else
						{
							return;
						}
					}
				});
			}
		}
	}
</script>
<body>

<div class="popup_wrap">
	<div class="title_box">
		<h3>유사데이터</h3>
	</div>

	<div class="list_bt_area">
		<div class="list_set">
			<ul>
				<li><a href="javascript:toMerge('${exRimsData.resultId}');" class="list_icon16">논문병합</a></li>
			</ul>
		</div>
	</div>

	<!-- left table (ExRIMS데이터) -->
	<div style="position: absolute;border-left: 1px;border-left-color: #a2afc0;border-left-style: solid; ">
		<table class="write_tbl" cellpadding="0" cellspacing="0" style="width:474px; height:600px; border-collapse:collapse;">
			<colgroup>
				<col style="width:1px;" />
				<col style="width:461px;" />
				<col style="width:1px;" />
			</colgroup>
			<tbody>
				<tr style="height: 40px;">
					<td></td>
					<td style="text-align: center;"><b>Exrims Data</b></td>
					<td></td>
				</tr>
				<tr style="vertical-align: top;">
					<td colspan="3">
						<span style="font-size: 13px; font-weight: bold; color: #1d6dc6;padding: 0 0 0 13px;">${exRimsData.articleTtl}</span><br/>
						<c:if test="${not empty exRimsData.diffLangTtl}">
							<span style="font-weight: bold; color: #777;padding: 0 0 0 13px;"> (${exRimsData.diffLangTtl}) </span><br/>
						</c:if>
						<span style="font-weight: bold; color: #777;padding: 0 0 0 13px;">
							/&nbsp;${exRimsData.plscmpnNm}, &nbsp;${exRimsData.pblshrNm}, &nbsp;
							<c:if test="${not empty exRimsData.vlm}">v.${exRimsData.vlm},&nbsp;</c:if>
						    <c:if test="${not empty exRimsData.issue}">no.${exRimsData.issue},&nbsp;</c:if>
						    <c:if test="${not empty exRimsData.beginPage}">pp.${exRimsData.beginPage} <c:if test="${not empty exRimsData.endPage}">~ ${exRimsData.endPage},&nbsp;</c:if></c:if>
						    <c:if test="${not empty exRimsData.pblcateYear}">${exRimsData.pblcateYear},&nbsp;</c:if>
						    <c:if test="${not empty exRimsData.doi}"><br/>doi : <a href="http://dx.doi.org/${al.doi}" target="_blank">${exRimsData.doi}</a></c:if>
						</span>
						<p>
							<c:if test="${empty exRimsAuts}">
								저자정보 없음
							</c:if>
							<c:if test="${not empty exRimsAuts}">
								<c:forEach items="${exRimsAuts}" var="ea" varStatus="idx">
									<span style="margin-top: 5px;">${idx.count}.&nbsp;${ea.authrAbrv}&nbsp;[${ea.authrNm}]&nbsp;${ea.rePerno}</span><br/>
								</c:forEach>
							</c:if>
						</p>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
	<div style="margin-left:474px; border-left:1px solid #a2afc0; border-right:1px solid #a2afc0; position: absolute;">
		<table class="write_tbl"  cellpadding="0" cellspacing="0" style="width:474px; height:600px; border-collapse:collapse;">
			<colgroup>
				<col style="width:1px;" />
				<col style="width:461px;" />
				<col style="width:1px;" />
			</colgroup>
			<tbody>
				<tr style="height: 40px;">
					<td></td>
					<td style="text-align: center;"><b>Rims Data</b></td>
					<td></td>
				</tr>
				<tr style="vertical-align: top;height: 40px;">
					<td colspan="3">
						<input type="radio" id="dupArt" name="dupArt" value="None" class="radio"/>
						<label for="dupArt" class="radio_label"><span class="txt_black"><b>중복데이터 아님(신규반입)</b></span></label>
					</td>
				</tr>
				<tr style="vertical-align: top;">
					<td colspan="3" style="padding: 0;">
						<table style="width: 100%;">
							<colgroup>
								<col style="width:1px;" />
								<col style="width:461px;" />
								<col style="width:1px;" />
							</colgroup>
							<tbody>
								<c:if test="${not empty rimsArticles }">
									<c:forEach items="${rimsArticles}" var="ra" varStatus="idx">
									<tr style="vertical-align: top;">
										<td colspan="3">
											<input type="radio" type="radio" id="dupArt_${idx.count}" name="dupArt" value="${ra.articleId}"/>
											<span style="font-size: 13px; font-weight: bold; color: #1d6dc6;">${ra.orgLangPprNm}</span><br/>
											<c:if test="${not empty ra.diffLangPprNm}">
												<span style="font-weight: bold; color: #777;padding: 0 0 0 13px;"> (${ra.diffLangPprNm}) </span><br/>
											</c:if>
											<span style="font-weight: bold; color: #777;padding: 0 0 0 13px;">
												/&nbsp;${ra.scjnlNm}, &nbsp;${ra.pblcPlcNm}, &nbsp;
												<c:if test="${not empty ra.volume}">v.${ra.volume},&nbsp;</c:if>
											    <c:if test="${not empty ra.issue}">no.${ra.issue},&nbsp;</c:if>
											    <c:if test="${not empty ra.sttPage}">pp.${ra.sttPage} <c:if test="${not empty ra.endPage}">~ ${ra.endPage},&nbsp;</c:if></c:if>
											    <c:if test="${not empty ra.pblcYm}">${ra.pblcYm},&nbsp;</c:if>
											    <c:if test="${not empty ra.doi}"><br/>doi : <a href="http://dx.doi.org/${ra.doi}" target="_blank">${ra.doi}</a></c:if>
											</span>
											<c:if test="${empty ra.partiList}">
												<p>저자정보 없음</p>
											</c:if>
											<c:if test="${not empty ra.partiList}">
												<p>
													<c:forEach items="${ra.partiList}" var="pl" varStatus="pi">
														<span style="margin-top: 5px;">${pi.count}.&nbsp;${pl.prtcpntNm}&nbsp;[${pl.prtcpntFullNm}]&nbsp;${pl.prtcpntId}</span><br/>
													</c:forEach>
												</p>
											</c:if>
										</td>
									</tr>
									</c:forEach>
								</c:if>
							</tbody>
						</table>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
</div>
</body>