<%@ page language="java" contentType="text/html; charset=UTF-8" 	pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>일반자료실</title>
<style type="text/css">
.detail_table td{
	font-size: 9pt;
	padding: 5px 10px;
	vertical-align: middle;
	border: 0px;
	border-top: solid 1px #c5c8d2;
	border-bottom: solid 1px #c5c8d2;
}
.select_row {
	background: #fee79a !important;
}
.detail_table a:visited {
	text-decoration: none;
	FONT-SIZE: 9pt;
	color: #464646;
}
.detail_table a:link {
	text-decoration: none;
	FONT-SIZE: 9pt;
	color: #464646;
}
.detail_table a:hover {
	text-decoration: underline;
	FONT-SIZE: 9pt;
	color: #4FB0F3;
}

.detail_table a:active {
	text-decoration: none;
	FONT-SIZE: 9pt;
	color: #464646;
}
</style>
<script>
//var sjArr = eval('('+ '${sciJson}'+')');

 $(document).ready(function(){
	    $('#publicationsTbl tr').bind('click',function(){
	    	$('#publicationsTbl tr').removeClass('select_row');
	    	$(this).addClass('select_row');
	    	selectRow($(this));
	    });
	    var firstRow = $('#publicationsTbl tr').eq(1);
	    $('#publicationsTbl tr').removeClass('select_row');
	    $(firstRow).addClass('select_row');
	    selectRow($(firstRow));

		 //$('#fromYear').data('prev', $('#fromYear').val());
		 //$('#toYear').data('prev', $('#toYear').val());

 });
 function selectRow($row){
	 //detail view
	 var child = $row.children();
	 var title = child.eq(1).text();
	 var regDate = child.eq(2).text();
	 var content = child.eq(3).html();
	 var bbsId = child.eq(4).text();
	 content = content.replace(/<[pP]><[aA].*\<\/[aA]><\/[pP]><br>/gi, '').replace(/<[pP]><\/[pP]>/gi, '').replace(/<p>&nbsp;<\/p><br>/gi, '');
	 $('#bbsTitle').text(title);
	 $('#bbsRegDate').text(regDate);
	 $('#bbsContent').html(content);

		$.ajax({
			 url : "${contextPath}/home/getFilesAjax.do",
			 dataType : 'json',
			 data : { "bbsId": bbsId},
			 success : function(data, textStatus, jqXHR){
				 $('#bbsFile').empty();
				 var $ul = $('<ul></ul>');
				 for(var i=0; i < data.length; i++){
					 var extension = data[i].EXTENSION;
					 var strExt = 'etc';
					 if(   extension == 'gif' || extension == 'html' || extension == 'hwp' || extension == 'jpg'
						 || extension == 'pdf' || extension == 'movie' || extension == 'mp3' || extension == 'png'
						 || extension == 'ppt' || extension == 'pptx' || extension == 'swf' || extension == 'txt'
						 || extension == 'word' || extension == 'doc' || extension == 'docx'
						 || extension == 'xls' || extension == 'xlsx' || extension == 'zip'
					   )  strExt = extension;
					 var $li = $('<li><a href="http://rims.kaist.ac.kr/rims/servlet/download.do?fileid='+data[i].FILE_ID+'"><img src="${contextPath}/images/icon/p_'+strExt+'_s.gif"/>&nbsp;'+data[i].FILE_NM+'</a> ( '+getFileSize(data[i].FILE_SIZE)+' )</li>');
					 $ul.append($li);
				 }
				 $('#bbsFile').append($ul);
			 }
		 });
 }
</script>
</head>
<body>

<jsp:scriptlet>
    pageContext.setAttribute("cr", "\r");
    pageContext.setAttribute("lf", "\n");
    pageContext.setAttribute("crlf", "\r\n");
</jsp:scriptlet>

		<form id="frm" name="frm" action="${contextPath}/home/dataSciJournalList.jsp.do" method="post">
		<input type="hidden" name="bbsType" id="bbsType" value="${bbsType}"/>
			<!--START page_title-->
	<h3>Resources</h3>
			<!--END page_title-->


			<!--START page_function-->
			<%--
			<div class="sub_top_box">
				<span>재직</span>
				<span class="select_span">
					<select name="hldofYn" id="hldofYn" onchange="javascript:$('#frm').submit();">
						<option value="ALL" ${parameter.hldofYn eq 'ALL' ? 'selected="selected"' : '' }>전체</option>
						<option value="1" ${parameter.hldofYn eq '1' ? 'selected="selected"' : '' }>재직</option>
						<option value="2" ${parameter.hldofYn eq '2' ? 'selected="selected"' : '' }>퇴직</option>
					</select>
				</span>
				<span style="margin-left:10px;">Position</span>
				<span class="select_span">
					<select name="position" id="position" onchange="javascript:$('#frm').submit();">
						<option value="ALL" ${parameter.position eq 'ALL' ? 'selected="selected"' : '' }>전체</option>
						<c:forEach var="pl" items="${positionList}" varStatus="idx">
						  <option value="${pl.codeValue }" ${parameter.position eq pl.codeValue ? 'selected="selected"' : '' }>${pl.codeDisp }</option>
						</c:forEach>
					</select>
				</span>
				<span style="margin-left:10px;">Journal</span>
				<span class="select_span">
					<select name="gubun" id="gubun" onchange="javascript:$('#frm').submit();">
						<option value="ALL" ${parameter.gubun eq 'ALL' ? 'selected="selected"' : '' }>전체</option>
						<option value="SCI" ${parameter.gubun eq 'SCI' ? 'selected="selected"' : '' }>SCI</option>
						<option value="SCOPUS" ${parameter.gubun eq 'SCOPUS' ? 'selected="selected"' : '' }>SCOPUS</option>
					</select>
				</span>
				<span style="margin-left:10px;">실적기간</span>
				<span class="select_span">
					<select name="fromYear" id="fromYear" onchange="javascript:if(validateRange()){ $('#frm').submit();}else{ errorMsg(this); $(this).val($(this).data('prev')); return false;}">
						<c:forEach var="yl" items="${pubYearList}" varStatus="idx">
						  <option value="${yl.pubYear }" ${parameter.fromYear eq yl.pubYear ? 'selected="selected"' : '' }>${yl.pubYear }</option>
						</c:forEach>
					</select>
				</span>					~<span class="select_span">
					<select name="toYear" id="toYear" onchange="javascript:if(validateRange()){ $('#frm').submit();}else{ errorMsg(this); $(this).val($(this).data('prev')); return false;}">
						<c:forEach var="yl" items="${pubYearList}" varStatus="idx">
						  <option value="${yl.pubYear }" ${parameter.toYear eq yl.pubYear ? 'selected="selected"' : '' }>${yl.pubYear }</option>
						</c:forEach>
					</select>
				</span>
				<p style="margin-top: 5px;">
				<span style="margin-left:10px;">대상학(부)과</span>
				<span class="select_span">
					<select name="deptKor" id="deptKor" onchange="javascript:$('#frm').submit();">
						<c:forEach var="dl" items="${deptList}" varStatus="idx">
						  <option value="${dl.DEPT_KOR }" ${deptKor eq dl.DEPT_KOR ? 'selected="selected"' : '' }>${dl.DEPT_KOR }</option>
						</c:forEach>
					</select>
				</span>
				<span style="margin-left:10px;">목록수</span>
				<span class="select_span">
					<select name="rownum" onchange="javascript:$('#frm').submit();">
						<option value="ALL" ${rownum eq 'ALL' ? 'selected="selected"' : '' }>전체</option>
						<option value="20" ${rownum eq '20' ? 'selected="selected"' : '' }>20</option>
					</select>
				</span>
				</p>
			</div>
			<!--END page_function-->
			 --%>
			<div class="help_text mgb_30"><spring:message code="asrms.aboutsci.resources.desc"/></div>
			<div class="sub_content_wrapper" style="border: 0px;">
				<table width="100%" class="detail_table">
					<colgroup>
						<col style="width: 9%"/>
						<col style="width: 68%"/>
						<col style="width: 9%"/>
						<col style="width: 15%"/>
					</colgroup>
						<tr>
							<td style="text-align:center; border-top: solid 3px #c5c8d2;border-right: solid 1px #c5c8d2;">Title</td>
							<td style="border-top: solid 3px #c5c8d2;border-right: solid 1px #c5c8d2;">
								<b><span style="font-size: 9pt;color: #474747;" id="bbsTitle"></span></b>
							</td>
							<td style="font-size: 9pt;text-align:center;border-top: solid 3px #c5c8d2;border-right: solid 1px #c5c8d2;">Date</td>
							<td style="border-top: solid 3px #c5c8d2;"><span style="font-size: 9pt;color: #474747;" id="bbsRegDate"></span></td>
						</tr>
						<tr>
							<td style="font-size: 9pt;text-align:center;border-right: solid 1px #c5c8d2;">File</td>
							<td colspan="3" style=""><span style="font-size: 9pt;color: #474747;" id="bbsFile"></span></td>
						</tr>
						<tr>
							<!--
							<td style="font-size: 9pt;height:75px; text-align:right;border-right: solid 1px #c5c8d2;">Content</td>
							 -->
							<td colspan="4" style="vertical-align:top; padding: 15px 15px 15px 15px;"><span style="font-size: 9pt;color: #555;" id="bbsContent"></span></td>
						</tr>
				</table>
			</div>

			<!--START sub_title-->
			<h3 class="circle_h3">Resources List</h3>
			<!--END sub_title-->

			<!--START sub_content_wrapper-->
			<div class="sub_content_wrapper">
				<table width="100%" id="publicationsTbl" class="list_tbl mgb_20">
					   <colgroup>
					   	 <col style="width: 8%;text-align: center;"/>
					   	 <col style="width: 72%"/>
					   	 <col style="width: 20%"/>
					   </colgroup>
						<thead>
							<tr style="height: 25px;">
								<th><span>NO</span></th>
								<th><span>Title</span></th>
								<th><span>Date</span></th>
							</tr>
						</thead>
						<tbody>
							<c:if test="${fn:length(genList) > 0}">
								<c:forEach items="${genList}" var="item" varStatus="status">
									<tr style='height:25px;cursor: pointer;'>
										<td style="font-size: 9pt;text-align: center;">${status.count }</td>
										<td align="left" style='font-size: 9pt;width:72%; overflow: hidden; text-overflow:ellipsis; white-space:nowrap;' title="${item.TITLE}">
											${item.TITLE}
										</td>
										<td style="font-size: 9pt;text-align: center;">${item.REG_DATE }</td>
										<td style="display: none;">${fn:replace(item.CONTENT, crlf, '<br/>')}</td>
										<td style="display: none;">${item.BBS_ID }</td>
									</tr>
								</c:forEach>
							</c:if>
						<c:if test="${fn:length(genList) == 0}">
							<tr style='background-color: #ffffff;' height="17px">
								<td style='font-size: 10pt;' align="center" colspan=99><img
									src="${contextPath}/images/layout/ico_info.png" /> There are no item.</td>
							</tr>
						</c:if>
						</tbody>
					</table>
			</div>
			<!--END sub_content_wrapper-->
	</form>
</body>
</html>
