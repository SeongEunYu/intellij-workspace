<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@include file="../../pageInit.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Extract Article</title>
<script type="text/javascript" src="<c:url value="/js/mainLayout.js"/>"></script>
<style type="text/css">
.btn-disabled, .btn-disabled[disabled] { opacity: .4; cursor: default !important; pointer-events: none; }
</style>
<script type="text/javascript">
var dhxLayout, myGrid, t;
$(document).ready(function(){
	if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
	else  window.addEventListener("resize",resizeLayout, false);
	//set layout
	dhxLayout = new dhtmlXLayoutObject("mainLayout","1C");
	dhxLayout.cells("a").hideHeader();
	dhxLayout.setSizes(false);
	myGrid = dhxLayout.cells("a").attachGrid();
	myGrid.setImagePath("${dhtmlXImagePath}");
	myGrid.setHeader("No,Article No.,Title,Journal,DocType,Researcher", null, grid_head_center_bold);
	myGrid.setInitWidths("50,120,*,180,100,150");
	myGrid.setColAlign("center,left,left,left,center,center");
	myGrid.setColSorting("str,str,str,str,str,str");
	myGrid.setColTypes("ro,ro,ro,ro,ro,ro");
	myGrid.enablePaging(true,100,10,"pagingArea",true);
	myGrid.setPagingSkin("${dhtmlXPagingSkin}");
	myGrid.enableColSpan(true);
	myGrid.init();

});

function viewExtractTarget(){
    doBeforeGridLoad();
	var url = "<c:url value="/extract/initExtract.do?"/>"+$('#formArea').serialize();
	myGrid.clearAndLoad(url, displayMessage);
}

function displayMessage(){
	var sourcDvsnCd = $(":input:radio[name='sourcDvsnCd']:checked").val();
	var sourcName = "";
	if(sourcDvsnCd == "WOS") sourcName = "WoS";
	else if(sourcDvsnCd == "SCP") sourcName = "SCOPUS";
	else if(sourcDvsnCd == "KCI") sourcName = "KCI";
	var message = sourcName + " 실적정보 <p/>추출 대상 건수는 [" + myGrid.getRowsNum() + "]건 입니다."
    doOnGridLoaded();
	dhtmlx.alert({type:"alert",text:message,callback:function(){}})
	if(myGrid.getRowsNum() > 0){
		$(":input:radio[name='sourcDvsnCd']").attr('disabled', 'disabled');
		 $("#cle").show();
	}else{
		$(":input:radio[name='sourcDvsnCd']").removeAttr('disabled');
		$("#cle").hide();
	}
}

function doExtract(){
	if(myGrid.getRowsNum() > 0){
		if(!$('btn_extract').prop('disabled'))
		{
			doBeforeGridLoad();
			$('.list_set a').addClass('btn-disabled').prop('disabled ','disabled');
			var sourcDvsnCd = $(":radio[name='sourcDvsnCd']:checked").val();
            var formData = $('#formArea').serialize() + "&sourcDvsnCd=" + sourcDvsnCd;
			var url = "<c:url value="/extract/exeExtract.do?"/>"+formData;
			jQuery.get(url, function(data){
				var sourcName = "";
				if(sourcDvsnCd == "WOS") sourcName = "WoS";
				else if(sourcDvsnCd == "SCP") sourcName = "SCOPUS";
				else if(sourcDvsnCd == "KCI") sourcName = "KCI";
				var message = sourcName + " 실적정보 추출을 완료하였습니다."
				dhtmlx.alert({type:"alert",text:message,callback:function(){}})
				$(":input:radio[name='sourcDvsnCd']").removeAttr('disabled');
				myGrid.clearAll();
				$('.list_set a').removeClass('btn-disabled').removeProp('disabled');
				$("#cle").hide();
				doOnGridLoaded();
			});
		}
	}
	else{
		dhtmlx.alert({type:"alert-warning",text:"추출대상 건수가 없습니다. 확인해주세요.",callback:function(){}})
	}

}

function cancelExtract(tableString) {
	dhtmlx.confirm({
		title:"실적추출 취소",
		ok:"Yes", cancel:"No",
		text:"취소하시겠습니까?",
		callback:function(result){
			if(result == true){
				$(":input:radio[name='sourcDvsnCd']").removeAttr('disabled');
				myGrid.clearAll();
				$("#cle").hide();
			}
		}
	});
}

function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){ dhxLayout.setSizes(false); },200);}
function doOnGridLoaded(){setTimeout(function() {dhxLayout.cells("a").progressOff();}, 100);}
function doBeforeGridLoad(){dhxLayout.cells("a").progressOn();}

function doChangeHistory(sourceDvsCd){
    $.ajax({
        url:"<c:url value="/extract/findHisotryList.do"/>",
        dataType: "json",
        data: {"sourcDvsnCd":sourceDvsCd},
        method: "POST",
        success: function(){}
    }).done(function(data){
        console.log(data);
        $('#importId').empty();
        $('#importId').append($("<option selected='selected' value=''>전체</option>"));
        for(var i=0; i < data.length; i++)
        {
            var regdate = $.datepicker.formatDate('yy-mm-dd',new Date(data[i].regdate));
            $('#importId').append($("<option value='"+data[i].id+"'>"+data[i].id+":"+regdate+":"+data[i].title+"</option>"));
        }
    });
}

</script>

</head>
<body>
	<!-- Page Title -->
	<div class="title_box">
		<h3><spring:message code='menu.article.extract'/></h3>
	</div>
	<!-- Main Content -->
	<div class="contents_box">
		<form id="formArea">
		<div class="formObj" onkeydown="if (event.keyCode == 13) viewExtractTarget();">
			<!-- START 테이블 1 -->
			<table class="view_tbl mgb_10">
				<colgroup>
					<col style="width: 13%"/>
					<col style="width: 25%"/>
					<col />
					<col style="width: 50px;"/>
				</colgroup>
				<tbody>
				<tr>
					<th>추출대상</th>
					<td class="borderRight" style="border-right: 1px solid #ddd;">
						<input type="radio" id="sourcDvsnCd0" name="sourcDvsnCd" class="radio" value="WOS" checked="checked" onclick="javascript:doChangeHistory($(this).val())"/>
							<label for="WoS" class="radio_label">WoS</label>
						<input type="radio" id="sourcDvsnCd1" name="sourcDvsnCd" class="radio" value="SCP" onclick="javascript:doChangeHistory($(this).val())"/>
							<label for="Scopus" class="radio_label">Scopus</label>
						<input type="radio" id="sourcDvsnCd1" name="sourcDvsnCd" class="radio" value="KCI" onclick="javascript:doChangeHistory($(this).val())"/>
							<label for="KCI" class="radio_label">KCI</label>
					</td>
					<td style="height: 58px;" rowspan="2">
						<span class='inline_help'>* 아직 실적으로 추출되지 않은 WOS, SCOPUS 정보를 추출합니다. </span><br>
						<span class='inline_help'>* 논문의 저자가 실적관리 대상 연구자로 식별된 정보를 대상으로 합니다. </span><br>
						<span class='inline_help'>* WOS와 중복된 SCOPUS 정보는 추출하지 않습니다. </span>
					</td>
					<td class="option_search_td" onclick="javascript: viewExtractTarget();" rowspan="2"><em>search</em></td>
				</tr>
				<tr>
					<th>반입 ID</th>
					<td style="border-right: 1px solid #ddd;">
						<select class="select_type" style="width:100%;" id="importId" name="importId">
							<option selected='selected' value=''>전체</option>
							<c:if test="${not empty rdHistList }">
								<c:forEach items="${rdHistList}" var="rhl" varStatus="st">
									<fmt:formatDate value="${rhl.regdate}" var="regdate" pattern="yyyy-MM-dd"/>
									<option value='${fn:escapeXml(rhl.id)}' >
											${fn:escapeXml(rhl.id)}:${regdate}:${fn:escapeXml(rhl.title)}
									</option>
								</c:forEach>
							</c:if>
						</select>
					</td>
				</tr>
				</tbody>
			</table>
			<!-- end 테이블 1 -->
		</div>
		</form>
		<div class="list_bt_area">
			<div class="list_set">
				<ul>
					<li><a href="#" onclick="javascript:doExtract();" class="list_icon11 btn_extract">추출</a></li>
					<li id="cle" name="cle"  style="display:none;"><a href="#" onclick="javascript:cancelExtract();" class="list_icon10 btn_cancel">취소</a></li>
				</ul>
			</div>
		</div>

		<div id="mainLayout" style="position: relative; width: 100%;height: 100%;"></div>
		<script type="text/javascript">setMainLayoutHeight($('#mainLayout'));</script>
		<div id="pagingObj" style="z-index: 1; height: 60px; margin-top: 5px;" >
			<div id="pagingArea" style="z-index: 1;"></div>
		</div>
	</div>
</body>
</html>