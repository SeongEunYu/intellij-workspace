<%@ page import="kr.co.argonet.r2rims.core.vo.DeptVo" %>
<%@ page import="kr.co.argonet.r2rims.core.code.CodeConfiguration" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.argonet.r2rims.core.vo.CodeVo" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>H-index By Researchers </title>
<script type="text/javascript" src="${contextPath}/js/jquery/jquery.tablesorter.min.js"></script>
<style type="text/css" rel="stylesheet">
th.header {
    cursor: pointer;
    background-repeat: no-repeat;
    background-position: center right;
    padding-right: 13px;
    margin-right: -1px;
}
</style>
<script>
$.tablesorter.addParser({
    // set a unique id
    id: 'numFmt',
    is: function(s) {
        // return false so this parser is not auto detected
        return false;
    },
    format: function(s) {
    	//console.log(s + " ::" + NumberWithoutComma(s) + "::");
   	 return NumberWithoutComma(s);
    },
    // set type, either numeric or text
    type: 'numeric'
});

 function exportExcel(){

	 var table = $('<table></table>');
	 //append document title
	 var docTitle = $('<tr><td style="text-align:center;"><h1><p>College - '+$('.page_title').html()+'</p></h1></td></tr>');
	 table.append(docTitle);
	 //make table with data of checked researcher
	 table.append($('<tr><td>'+$('#publicationsTbl').clone().wrapAll('<div/>').parent().html()+'</td></tr>'));
	 $('#tableHTML').val(table.wrapAll('<div/>').parent().html());
	 var excelFileName = "H-indexByResearchers_"+$('#gubun').val() + "_from_" + $('#fromYear').val() +"_to_" + $('#toYear').val() + ".xls";
	 $('#fileName').val(excelFileName);
	 exportLog($('#frm'), excelFileName);
	 $('#excelFrm').submit();
 }

 $(document).ready(function(){
     publicationByHindexAjax('0');
 });

function publicationByHindexAjax(idx){
    $.ajax({
        url:"<c:url value="/analysis/college/publicationByHindexAjax.do"/>",
        dataType: "json",
        data: $('#frm').serialize(),
        method: "POST",
        beforeLoad: $('.wrap-loading').css('display', '')

    }).done(function(data){
        if(data.topList.length > 0){
            var sum_tc;
            var no_arts;
            var avg_tc;
            var sum_if;
            var $tbody = "";

            for(var j=0; j < data.topList.length; j++){
                var item = data.topList[j];

                if($('#gubun').val() == 'SCI'){
                    sum_tc = item.wosCitedSum.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
                    no_arts = item.sciArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
                    avg_tc = (item.wosCitedAvrg.toFixed(2)*1).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
                    sum_if = (item.impctFctrSum.toFixed(2)*1).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
                }else if($('#gubun').val() == 'SCOPUS'){
                    sum_tc = item.scpCitedSum.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
                    no_arts = item.scpArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
                    avg_tc = (item.scpCitedAvrg.toFixed(2)*1).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
                    sum_if = (item.sjrSum.toFixed(2)*1).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
                }else if($('#gubun').val() == 'KCI'){
                    sum_tc = item.kciCitedSum.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
                    no_arts = item.kciArtsCo.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
                    avg_tc = (item.kciCitedAvrg.toFixed(2)*1).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
                    sum_if = (item.kciIFSum.toFixed(2)*1).toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
                }

                var $tr = '<tr style="height:25px;">';
                $tr += '<td style="font-size: 10pt;" align="center">'+(j+1)+'</td>';
                $tr += '<td align="center" style="font: normal 12px"><span class="breakKeepAll">'+item.korNm+'</span></td>';
                $tr += '<td align="center" style="font: normal 12px">'+item.userId+'</td>';
                $tr += '<td style="text-align: center;"><span class="breakKeepAll">'+item.posiNm+'</span></td>';
                $tr += '<td style="text-align: left; padding-left: 5px;"><span class="breakKeepAll">'+item.deptKor+'</span></td>';
                $tr += '<td class="center">'+no_arts+'</td>';
                $tr += '<td style="text-align: right;">'+sum_if+'</td>';
                $tr += '<td style="text-align: right;">'+sum_tc+'</td>';
                $tr += '<td class="center" style="display: none;">'+avg_tc+'</td>';
                $tr += '<td style="text-align: right;">'+item.hindex+'</td>';
                $tr += '</tr>';

                $tbody += $tr;
            }
        }else{
            var $tr = "<tr style='background-color: #ffffff;' height='17px'>";
            $tr += "<td style='font-size: 10pt;' align='center' colspan=99><img src='${contextPath}/images/layout/ico_info.png' /> 검색된 Researcher가 없습니다.</td></tr>";
            $tbody += $tr;
        }

        $("#publicationsTbl tbody").html($tbody);

        if(idx == "0"){
            $("#publicationsTbl").tablesorter({
                sortList:[[9,1]],
                headers: {
                    0: { sorter: false },
                    5: { sorter:'numFmt'},
                    6: { sorter:'numFmt'},
                    7: { sorter:'numFmt'},
                    8: { sorter: false},
                    9: { sorter:'numFmt'}
                }
            });
        }else{
            $("#publicationsTbl th").removeClass('headerSortUp');
            $("#publicationsTbl th").removeClass('headerSortDown');
            $("#publicationsTbl th").eq(9).addClass('headerSortUp');
        }

        $("#publicationsTbl").trigger("update");

        $("#publicationsTbl").bind("sortStart",function() {
            var artTr = $('#publicationsTbl > tbody > tr');
            for(var i=0; i < artTr.length; i++){
                artTr.eq(i).children('td:first').text('');
            }
        }).bind("sortEnd",function() {
            var artTr = $('#publicationsTbl > tbody > tr');
            for(var i=0; i < artTr.length; i++){
                artTr.eq(i).children('td:first').text(i+1);
            }
        });

        $('#fromYear').data('prev', $('#fromYear').val());
        $('#toYear').data('prev', $('#toYear').val());

        $('.wrap-loading').css('display', 'none');
    });
}

   </script>
</head>
<body>
	<h3 class="page_title">H-index by Researcher</h3>
	<div class="help_text mgb_30"><spring:message code="asrms.college.hindex.desc"/></div>

	<form id="frm" name="frm">
	<input type="hidden" name="isUserChanged" id="isUserChanged" value="true"/>
	<input type="hidden" id="topNm" name="topNm" value="<c:out value="${topNm}"/>"/>
	<input type="hidden" name="clgCd" id="clgCd" value="<c:out value="${parameter.clgCd}"/>"/>


		<div class="top_option_box">
			<div class="to_inner">
				<span>학술지구분</span>
				<em>
					<select name="gubun" id="gubun">
						<option value="SCI" selected="selected">SCI</option>
						<option value="SCOPUS">SCOPUS</option>
						<option value="KCI">KCI</option>
					</select>
				</em>
				<span>재직구분</span>
				<em>
					<select name="hldofYn" id="hldofYn">
						<option value="ALL">전체</option>
						<option value="1" selected="selected">재직</option>
						<option value="2">퇴직</option>
					</select>
				</em>
				<span>실적기간</span>
				<em>
					<select name="fromYear" id="fromYear">
						<c:forEach var="yl" items="${pubYearList}" varStatus="idx" end="50">
							<option value="${yl.pubYear }" ${idx.index == 5 ? 'selected="selected"' : '' }>${yl.pubYear }</option>
						</c:forEach>
					</select>
				</em>
				~
				<em>
					<select name="toYear" id="toYear">
						<c:forEach var="yl" items="${pubYearList}" varStatus="idx" end="50">
							<option value="${yl.pubYear }">${yl.pubYear }</option>
						</c:forEach>
					</select>
				</em>
				<span>실적구분</span>
				<em>
					<select name="insttRsltAt" id="insttRsltAt">
						<option value="" selected="selected">전체</option>
						<option value="Y">${sysConf['inst.abrv']}</option>
						<option value="N">타기관</option>
					</select>
				</em>
				<p style="margin-top: 5px;">
					<span>목록수</span>
					<em>
						<select name="rownum">
							<option value="ALL">전체</option>
							<option value="20" selected="selected">20</option>
							<option value="50">50</option>
						</select>
					</em>
					<span>대상학(부)과</span>
					<em>
						<select name="searchDept" id="searchDept" style="width: 142px;">
							<option value="">전체</option>
							<%
								String clgCd = ((CodeVo)request.getAttribute("item")).getCodeValue();
								List<DeptVo> deptList = CodeConfiguration.getDeptList(clgCd);
								if(deptList == null) return;
								//학과 이름순 정렬
								Collections.sort(deptList,new Comparator() {
									@Override
									public int compare(Object o1,Object o2) {
										String v1 = ((DeptVo)o1).getDeptKorNm();
										String v2 = ((DeptVo)o2).getDeptKorNm();

										return v1.compareTo(v2);
									}
								});

								for(int i=0; i<deptList.size(); i++){
							%>
							<option value="<%=deptList.get(i).getDeptKorNm() %>" ><%=deptList.get(i).getDeptKorNm() %></option>
							<%	}	%>
						</select>
					</em>
					<span>신분구분</span>
					<em>
						<select name="isFulltime" id="isFulltime">
							<option value="ALL">전체</option>
							<option value="M" selected="selected">전임</option>
							<option value="U">비전임</option>
						</select>
					</em>
				</p>
			</div>
			<p class="ts_bt_box">
				<a href="javascript:publicationByHindexAjax();" class="to_search_bt"><span>Search</span></a>
			</p>
		</div>

	<p class="bt_box mgb_10"><a href="#" onclick="exportExcel();" class="black_bt"><em class="export_icon">Export</em></a></p>

	<table width="100%" id="publicationsTbl" class="list_tbl mgb_20">
		   <colgroup>
				<col style="width: 5%"/>
				<col style="width: 9%"/>
				<col style="width: 8%"/>
				<col style="width: 6%"/>
				<col style="width: 17%"/>
				<col style="width: 9%"/>
				<col style="width: 11%"/>
				<col style="width: 10%"/>
				<col style="width: 9%;display: none;"/>
				<col style="width: 9%"/>
		   </colgroup>
			<thead>
				<tr style="height: 25px;">
					<th><span>NO</span></th>
					<th><span>성명</span></th>
					<th><span>ID</span></th>
					<th><span>직급</span></th>
					<th><span>학(부)과</span></th>
					<th><span>논문수</span></th>
					<th><span>I.F 합계 </span></th>
					<th><span>피인용횟수 <br/> 합계</span></th>
					<th style="display: none;"><span>피인용횟수 <br/> 평균</span></th>
					<th><span>H-index</span></th>
				</tr>
			</thead>
			<tbody></tbody>
		</table>
	</form>

<form id="excelFrm" method="post" action="${contextPath}/jsp/excelExport.jsp">
      <input type="hidden" id="tableHTML" name="tableHTML" value="" />
      <input type="hidden" id="fileName" name="fileName" value="publication.xls" />
</form>
<div id="exportDiv" style="display: none;"></div>
</body>
</html>
