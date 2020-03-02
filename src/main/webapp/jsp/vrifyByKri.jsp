<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String userAgent = request.getHeader("User-Agent");
	if (userAgent.indexOf("Trident") != -1 || userAgent.indexOf("MSIE") != -1)
		request.setCharacterEncoding("EUC-KR");
	String sKri_Param1  = request.getParameter("okri_param1");  // 학술지 명, 지식재산권명
	String sKri_Param2  = request.getParameter("okri_param2");  // 논문제목 (원어), 취득구분
	String sKri_Param3  = request.getParameter("okri_param3");  // 논문제목 (타 원어), 발명인명
	String sKri_Param4  = request.getParameter("okri_param4");  // 게재 년 월, 출원등록번호
	String sKri_Param5  = request.getParameter("okri_param5");  // 권, 출원등록일자
	String sKri_Param6  = request.getParameter("okri_param6");  // 호, 출원 및 등록인명
	String sKri_Param7  = request.getParameter("okri_param7");  // 시작페이지, 요약
	String sKri_Param8  = request.getParameter("okri_param8");  // 종료페이지
	String sKri_Param9  = request.getParameter("okri_param9");  // ISSN번호
	String sKri_Param10 = request.getParameter("okri_param10"); // 인용지수
	String sKri_Param11 = request.getParameter("okri_param11"); // 발행처
	String sKri_Param12 = request.getParameter("okri_param12"); // 전체저자수
	String sKri_Param13 = request.getParameter("okri_param13"); // 논문초록
	String sKri_Param14 = request.getParameter("okri_param14"); // 논문 ID
	String sKri_Param15 = request.getParameter("okri_param15"); // 논문 구분
	String sKri_Param16 = request.getParameter("okri_param16"); // 참여자
	String sKri_Param17 = request.getParameter("okri_param17"); // 학진등재구분(1.학진등재 2.학진등재후보 3.학진등재(후보)(등재나 등재후보가 아닌 학술지))
	String sKri_Gubun   = request.getParameter("okri_gubun");   // 서비스 구분
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title></title>
<link type="text/css" href="${pageContext.request.contextPath}/js/dhtmlx/skins/terrace/dhtmlx.css" rel="stylesheet" />
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery/jquery-ui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/dhtmlx/dhtmlx.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	var gubun = $('#kriGubun').val();
	if(gubun == '4') //논문
	{
		$(window.opener.document).find('#scjnlNm').val($('#kriParam1').val());
		$(window.opener.document).find('#orgLangPprNm').val($('#kriParam2').val());
		$(window.opener.document).find('#diffLangPprNm').val($('#kriParam3').val());
		$(window.opener.document).find('#pblcVolume').val($('#kriParam5').val());
		$(window.opener.document).find('#pblcIssue').val($('#kriParam6').val());
		$(window.opener.document).find('#sttPage').val($('#kriParam7').val());
		$(window.opener.document).find('#endPage').val($('#kriParam8').val());

		var issnNo = $('#kriParam9').val();
		if(issnNo != '')
		{
			if(issnNo.indexOf('-') == -1) issnNo = issnNo.substr(0,4) + "-" + issnNo.substr(4,4);
			$(window.opener.document).find('#issnNo').val(issnNo);
		}

		$(window.opener.document).find('#pblcPlcNm').val($('#kriParam11').val());
		$(window.opener.document).find('#totalAthrCnt').val($('#kriParam12').val());
		$(window.opener.document).find('#abstCntn').val($('#kriParam13').val());
		$(window.opener.document).find('#vrfcPprId').val($('#kriParam14').val());
		$(window.opener.document).find('#vrfcSrcDvsCd').val($('#kriParam15').val());

		//발행년월
		var pblcYm = $('#kriParam4').val();
		pblcYm = pblcYm.replace(/[.]/g,'');
		if(pblcYm.length == 4){
			$(window.opener.document).find('#pblcYear').val(pblcYm);
		}
		else if(pblcYm.length == 6)
		{
			$(window.opener.document).find('#pblcYear').val(pblcYm.substr(0,4));
			$(window.opener.document).find('#pblcMonth').val(pblcYm.substr(4,2));
		}
		//저널구분
		var scjnlGubun = $('#kriParam15').val();
		if(scjnlGubun == '1')
		{
			$(window.opener.document).find('#scjnlDvsCd').val('3');
			$(window.opener.document).find('#krfRegPblcYn').val($('#kriParam17').val());
			$(window.opener.document).find('#idKci').val($('#kriParam14').val());
		}
		else if(scjnlGubun == '2')
		{
			$(window.opener.document).find('#scjnlDvsCd').val('1');
			$(window.opener.document).find('#ovrsExclncScjnlPblcYn').val('1');
			$(window.opener.document).find('#idSci').val($('#kriParam14').val());
		}
		else if(scjnlGubun == '3')
		{
			$(window.opener.document).find('#scjnlDvsCd').val('1');
			$(window.opener.document).find('#ovrsExclncScjnlPblcYn').val('5');
			$(window.opener.document).find('#idScopus').val($('#kriParam14').val());
		}
		else
		{
			$(window.opener.document).find('#scjnlDvsCd').val('');
		}

		$(window.opener.document).find('#vrfcDvsValue').text('검증완료');
		$(window.opener.document).find('#selectVrfcDvsCd').val('2');
		$(window.opener.document).find('#vrfcDvsCdKey').val('2');
		var my_date_string = $.datepicker.formatDate( "yy-mm-dd",  new Date() );
		$(window.opener.document).find('#vrfcDate').text(my_date_string);
		window.opener.setChange();

		//저자
		dhtmlx.alert({
			title : "저자처리선택",
			ok:"확인",
			type : "alert",
			text:"<div style='text-align:left;padding-left:50px;'><input type='radio' name='authorMethod' value='1' checked='checked' onClick='javascript:$(\"#apply\").val($(this).val());' />현재 저자 유지(변경없음)<br/><input type='radio' name='authorMethod' value='2' onClick='javascript:$(\"#apply\").val($(this).val());' />현재 저자에 KRI저자를 추가<br/><input type='radio' name='authorMethod' value='3' onClick='javascript:$(\"#apply\").val($(this).val());'/>현재 저자를 KRI저자로 변경</div>",
			callback:function(){
				window.opener.updatePrtcpnt($('#apply').val(), $('#kriParam16').val());
				window.close();
			}
		});
	}
	else if(gubun == '5') // 지식재산권
	{
		$(window.opener.document).find('#itlPprRgtNm').val($('#kriParam1').val());
		$(window.opener.document).find('#acqsDvsCd').val($('#kriParam2').val());
		$(window.opener.document).find('#invtNm').val($('#kriParam3').val());
		$(window.opener.document).find('#applRegNo').val($('#kriParam4').val());
		$(window.opener.document).find('#applRegDate').val($('#kriParam5').val());
		$(window.opener.document).find('#applRegtNm').val($('#kriParam6').val());
		$(window.opener.document).find('#smmrCntn').val($('#kriParam7').val());
		$(window.opener.document).find('#applRegNo').val($('#kriParam8').val());
		$(window.opener.document).find('#itlPprRgtRegNo').val($('#kriParam10').val());

		$(window.opener.document).find('#vrfcDvsCdValue').text('검증완료');
		$(window.opener.document).find('#vrfcDvsCdKey').val('2');
		var my_date_string = $.datepicker.formatDate( "yy-mm-dd",  new Date() );
		$(window.opener.document).find('#vrfcDate').text(my_date_string);

		var itlPprRgtRegDate = $('#kriParam11').val();
		itlPprRgtRegDate = itlPprRgtRegDate.replace(/[.]/g,'');
		if(itlPprRgtRegDate.length == 4){
			$(window.opener.document).find('#itlPprRgtRegYear').val(itlPprRgtRegDate);
		}
		else if(itlPprRgtRegDate.length == 6)
		{
			$(window.opener.document).find('#itlPprRgtRegYear').val(itlPprRgtRegDate.substr(0,4));
			$(window.opener.document).find('#itlPprRgtRegMonth').val(itlPprRgtRegDate.substr(4,2));
		}
		else if(itlPprRgtRegDate.length == 8)
		{
			$(window.opener.document).find('#itlPprRgtRegYear').val(itlPprRgtRegDate.substr(0,4));
			$(window.opener.document).find('#itlPprRgtRegMonth').val(itlPprRgtRegDate.substr(4,2));
			$(window.opener.document).find('#itlPprRgtRegDay').val(itlPprRgtRegDate.substr(6,2));
		}

		var applRegDate = $('#kriParam9').val();
		applRegDate = applRegDate.replace(/[.]/g,'');
		if(applRegDate.length == 4){
			$(window.opener.document).find('#applRegYear').val(applRegDate);
		}
		else if(applRegDate.length == 6)
		{
			$(window.opener.document).find('#applRegYear').val(applRegDate.substr(0,4));
			$(window.opener.document).find('#applRegMonth').val(applRegDate.substr(4,2));
		}
		else if(applRegDate.length == 8)
		{
			$(window.opener.document).find('#applRegYear').val(applRegDate.substr(0,4));
			$(window.opener.document).find('#applRegMonth').val(applRegDate.substr(4,2));
			$(window.opener.document).find('#applRegDay').val(applRegDate.substr(6,2));
		}
		window.opener.setChange();
		//저자
		dhtmlx.alert({
			title : "저자처리선택",
			ok:"확인",
			type : "alert",
			text:"<div style='text-align:left;padding-left:50px;'><input type='radio' name='authorMethod' value='1' checked='checked' onClick='javascript:$(\"#apply\").val($(this).val());' />현재 저자 유지(변경없음)<br/><input type='radio' name='authorMethod' value='2' onClick='javascript:$(\"#apply\").val($(this).val());' />현재 저자에 KRI저자를 추가<br/><input type='radio' name='authorMethod' value='3' onClick='javascript:$(\"#apply\").val($(this).val());'/>현재 저자를 KRI저자로 변경</div>",
			callback:function(){
				window.opener.updatePrtcpnt($('#apply').val(), $('#kriParam3').val());
				window.close();
			}
		});
	}
	else if(gubun == '7') // 저역서
	{
		if($('#kriParam1').val() != '') $(window.opener.document).find('#orgLangBookNm').val($('#kriParam1').val());
		if($('#kriParam2').val() != '') $(window.opener.document).find('#pblcPlcNm').val($('#kriParam2').val());
		if($('#kriParam3').val() != '') $(window.opener.document).find('#bookPblcY').val($('#kriParam3').val());
		if($('#kriParam4').val() != '') $(window.opener.document).find('#dlgtAthrNm').val($('#kriParam4').val());
		if($('#kriParam5').val() != '') $(window.opener.document).find('#jnlDvsCd').val($('#kriParam5').val());
		if($('#kriParam7').val() != '') $(window.opener.document).find('#diffLangBookNm').val($('#kriParam7').val());
		if($('#kriParam8').val() != '') $(window.opener.document).find('#mkoutLangCd').val($('#kriParam8').val());
		if($('#kriParam10').val() != '') $(window.opener.document).find('#bookDvsCd').val($('#kriParam10').val());
		if($('#kriParam11').val() != '') $(window.opener.document).find('#totalAthrCnt').val($('#kriParam11').val());
		if($('#kriParam12').val() != '') $(window.opener.document).find('#totalPage').val($('#kriParam12').val());
		if($('#kriParam13').val() != '') $(window.opener.document).find('#isbnNo').val($('#kriParam13').val());

		$(window.opener.document).find('#vrfcDvsValue').text('검증완료');
		$(window.opener.document).find('#vrfcDvsCdKey').val('2');
		var my_date_string = $.datepicker.formatDate( "yy-mm-dd",  new Date() );
		$(window.opener.document).find('#vrfcDate').text(my_date_string);
		window.opener.setChange();
		window.close();

	}
	else if(gubun == '13') // 지도교수 검색
	{
		$(window.opener.document).find('#tutorNmValue').val($('#kriParam1').val()); //연구자명
		$(window.opener.document).find('#tutorRschrRegNoKey').val($('#kriParam2').val());	//연구자등록번호
		window.opener.setChange();
		window.close();
	}
	else if(gubun == '99') // 암호화
	{
		$(top.document).find('#kriRshcrRegNo').val($('#kriParam1').val());
		//alert($('#kriParam1').val() + ", " + $(top.document).find('#kriRshcrRegNo').val());
		$(top.document).find('#frmSch').submit();
		//$(window.opener.document).find('#kriRshcrRegNo').val($('#kriParam1').val());
		//$(window.opener.document).find('#frmSch').submit();
		window.close();
	}

});
</script>
</head>
<body>
	<form name="frmPop" id="frmPop">
		<input type="hidden" name="Kri_Param1" id="kriParam1" value="<%=sKri_Param1 %>"/>    <%-- 학술지 명, 지식재산권명 --%>
		<input type="hidden" name="Kri_Param2" id="kriParam2" value="<%=sKri_Param2 %>"/>    <%-- 논문제목 (원어), 취득구분 --%>
		<input type="hidden" name="Kri_Param3" id="kriParam3" value="<%=sKri_Param3 %>"/>    <%-- 논문제목 (타 원어), 발명인명 --%>
		<input type="hidden" name="Kri_Param4" id="kriParam4" value="<%=sKri_Param4 %>"/>    <%-- 게재 년 월, 출원등록번호 --%>
		<input type="hidden" name="Kri_Param5" id="kriParam5" value="<%=sKri_Param5 %>"/>    <%-- 권, 출원등록일자 --%>
		<input type="hidden" name="Kri_Param6" id="kriParam6" value="<%=sKri_Param6 %>"/>    <%-- 호, 출원 및 등록인명 --%>
		<input type="hidden" name="Kri_Param7" id="kriParam7" value="<%=sKri_Param7 %>"/>    <%-- 시작페이지, 요약 --%>
		<input type="hidden" name="Kri_Param8" id="kriParam8" value="<%=sKri_Param8 %>"/>    <%-- 종료페이지 --%>
		<input type="hidden" name="Kri_Param9" id="kriParam9" value="<%=sKri_Param9 %>"/>    <%-- ISSN번호 --%>
		<input type="hidden" name="Kri_Param10" id="kriParam10" value="<%=sKri_Param10 %>"/> <%-- 인용지수  --%>
		<input type="hidden" name="Kri_Param11" id="kriParam11" value="<%=sKri_Param11 %>"/> <%-- 발행처 --%>
		<input type="hidden" name="Kri_Param12" id="kriParam12" value="<%=sKri_Param12 %>"/> <%-- 전체저자수 --%>
		<input type="hidden" name="Kri_Param13" id="kriParam13" value="<%=sKri_Param13 %>"/> <%-- 논문초록 --%>
		<input type="hidden" name="Kri_Param14" id="kriParam14" value="<%=sKri_Param14 %>"/> <%-- 논문 ID --%>
		<input type="hidden" name="Kri_Param15" id="kriParam15" value="<%=sKri_Param15 %>"/> <%-- 논문 구분 --%>
		<input type="hidden" name="Kri_Param16" id="kriParam16" value="<%=sKri_Param16 %>"/> <%-- 참여자 --%>
		<input type="hidden" name="Kri_Param17" id="kriParam17" value="<%=sKri_Param17 %>"/> <%-- 학진등재구분(1.학진등재 2.학진등재후보 3.학진등재(후보)(등재나 등재후보가 아닌 학술지)) --%>
		<input type="hidden" name="Kri_Gubun" id="kriGubun" value="<%=sKri_Gubun %>"/> 		<%-- 서비스 구분 --%>
	</form>
	<input type="hidden" id="apply" value="1"/>
</body>
</html>