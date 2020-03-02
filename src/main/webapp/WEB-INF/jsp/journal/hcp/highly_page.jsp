<%@page import="kr.co.argonet.r2rims.util.LanguageUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<style type="text/css" >
	.wrap-loading{ /*화면 전체를 어둡게 합니다.*/
		position: fixed;
		left:0;
		right:0;
		top:0;
		bottom:0;
		background: rgba(0,0,0,0.2); /*not in ie */
		z-index: 99999;
		filter: progid:DXImageTransform.Microsoft.Gradient(startColorstr='#20000000', endColorstr='#20000000');    /* ie */
	}

	.wrap-loading div{ /*로딩 이미지*/
		position: fixed;
		top:50%;
		left:50%;
		margin-left: -21px;
		margin-top: -21px;

	}
	.display-none{ /*감추기*/
		display:none;
	}
</style>

<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<%@include file="../../pageInit.jsp" %>
	<c:if test="${sessMode or (sessionScope.auth.adminDvsCd eq 'R' or  sessionScope.auth.adminDvsCd eq 'S' )}">
		<style type="text/css">.appr { color: #f26522; font-weight: bold; }</style>
	</c:if>
	<script type="text/javascript" src="${contextPath}/js/jquery/jquery.filedownload.js"></script>
	<script type="text/javascript" src="${contextPath}/js/mainLayout.js"></script>
	<script type="text/javascript">
        var dhxLayout, myGrid, t;
        $(document).ready(function(){

            if("${extractionDate}" != ""){
                $("#extractionDate").val("${extractionDate}");
            }

            bindModalLink();
            setMainLayoutHeight($('#mainLayout'));
            if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
            else  window.addEventListener("resize",resizeLayout, false);
            //set layout
            dhxLayout = new dhtmlXLayoutObject("mainLayout","1C");
            dhxLayout.cells("a").hideHeader();
            dhxLayout.setSizes(false);
            //attach myGrid
            var header = "No,Research Fields,Web of Science Documents,TC,TC/Paper,Top Papers";
            var columnIds = "No,rschField,paperCo,tc,tcPerPaper,topPaperCo,";
            var initWidths = "50,*,*,*,*,*";
            var colAlign = "center,center,center,center,center,center";
            var colTypes = "ro,ro,ro,ro,ro,ro";
            var colSorting = "int,str,int,int,int,int";
            var serializable = "false,fasle,false,false,false,false";

            myGrid = dhxLayout.cells("a").attachGrid();
            myGrid.setImagePath("${dhtmlXImagePath}");
            myGrid.setHeader(header,null,grid_head_center_bold);
            myGrid.setColumnIds(columnIds);
            myGrid.setInitWidths(initWidths);
            myGrid.setColAlign(colAlign);
            myGrid.setColTypes(colTypes);
            myGrid.setColSorting(colSorting);
            myGrid.setSerializableColumns(serializable);
            myGrid.attachEvent("onRowSelect", myGrid_onRowSelect);
            myGrid.attachEvent("onXLS", doBeforeGridLoad);
            myGrid.attachEvent("onXLE", doOnGridLoaded);
            myGrid.enableMultiselect(true);
            myGrid.enableColSpan(true);
            myGrid.enableColumnAutoSize(true);
            myGrid.init();
            myGrid_load();
        });
        function myGrid_load(){
            var url = getGridRequestURL();
            myGrid.clearAndLoad(url, function(){
                $("#exportEx").attr("href","/rims/servlet/download.do?fileid="+myGrid.getRowId(0).split(":")[1] );
            });
        }
        function getGridRequestURL(){
            var url = "${contextPath}/${preUrl}/hcp/findHcpFieldGrid.do";

            if($("#extractionDate").val() != null){
                url += "?extractionDate="+$("#extractionDate").val();
            }

            return url;
        }

        function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){ setMainLayoutHeight($('#mainLayout')); dhxLayout.setSizes(false); },10);}
        function doOnGridLoaded(){setTimeout(function() {dhxLayout.cells("a").progressOff();}, 100);}
        function doBeforeGridLoad(){dhxLayout.cells("a").progressOn();}

        function myGrid_onRowSelect(rowID,celInd){
            // html entity 변환
			var fieldNm = myGrid.cells(rowID,1).getValue().replace(/&amp;/g, 'amp');

            $(location).attr("href","${contextPath}/${preUrl}/hcp/hcpArticlePage.do?extractionDate="+$("#extractionDate").val()+"&field="+ fieldNm);
        }


        $("#file").change(function(){
            var val = $(this).val();
            var date = $("#importDialog input[type=date]");

            if(val.substring(val.lastIndexOf(".") + 1).toLocaleLowerCase() != "xlsx"){
                dhtmlx.alert("Only xslx file can accept")
                return false;
            }
        });

        function importXlsx(){
            for(var i=0; i<$("input[type=date]").length; i++){
                if($("input[type=date]").eq(i).val() == ""){
                    dhtmlx.alert("날짜 올바로 입력해주세요.");
                    $("input[type=date]").eq(i).focus();
                    return false;
                }
            }


            var fileNm = $("input[name=file]").val();

            if(fileNm.slice(fileNm.indexOf(".")+1).toLowerCase()  != "xlsx"){
                dhtmlx.alert("${language == 'en' ? 'Please select xlsx file.' : 'xlsx 파일을 선택해주세요.'}");
                $("#file").focus();

                return false;
            }

            var frm = document.getElementById('importFrm');

            frm.method = "POST";
            frm.enctype = "multipart/form-data";

            var fileData = new FormData(frm);

            setTimeout(function(){
				$.ajax({
					url: "${contextPath}/${preUrl}/hcp/importXlsx.do",
					type: "POST",
					data : fileData,
					async:false,
					cache:false,
					contentType:false,
					processData:false,
                    beforeSend:function(){
                        $('.wrap-loading').removeClass('display-none');
                    }
				}).done(function(data){
					$('.wrap-loading').addClass('display-none');
					if(data.msg != "false"){
						dhtmlx.alert({
							text: "엑셀 반입을 완료했습니다.",
							callback: function(){
								$(location).attr("href","${contextPath}/${preUrl}/hcp/hcpFieldPage.do?extractionDate="+data.msg);
							}
						});
					}else{
						dhtmlx.alert({
							type: "alert-warning",
							text: "엑셀 반입에 실패했습니다.",
							callback: function(){
								window.location.reload();
							}
						});
					}
				})
            },500);
        }
	</script>
</head>
<body>
<div class="title_box">
	<h3><spring:message code='menu.hcp'/></h3>
</div>
<div class="contents_box">
	<!-- START 테이블 1 -->
	<form id="formArea" >
		<table class="view_tbl mgb_10" >
			<colgroup>
				<col style="width: 15%;"/>
				<col />
				<col style="width: 50px;"/>
			</colgroup>
			<tbody>
			<tr>
				<th>Extraction date</th>
				<td>
					<select id="extractionDate" onchange="myGrid_load();">
						<c:forEach items="${dateList}" var="date">
							<option value="${date.extractionDate}:${date.periodFrom}:${date.periodTo}">추출날짜:${date.extractionDate} (대상날짜:${date.periodFrom} ~ ${date.periodTo})</option>
						</c:forEach>
					</select>
				</td>
				<td class="option_search_td" onclick="javascript:myGrid_load();"><em>search</em></td>
			</tr>
			</tbody>
		</table>
	</form>
	<c:if test="${sessionScope.auth.adminDvsCd eq 'M'}">
		<div class="list_bt_area">
			<div class="list_set">
				<ul>
					<li><a href="#importDialog" class="modalLink list_icon16">엑셀 반입</a></li>
					<li><a class="list_icon26" id="exportEx">엑셀 반출</a></li>
				</ul>
			</div>
		</div>
	</c:if>
	<!-- layout (grid)  -->
	<div id="mainLayout" style="position: relative; width: 100%; height: 100%;"></div>
</div>

<c:if test="${sessionScope.auth.adminDvsCd eq 'M'}">
	<div id="importDialog" class="popup_box modal modal_layer" style="width: 480px;height:290px; display: none;">
		<form id="importFrm">
			<div class="popup_header">
				<h3>엑셀 반입</h3>
				<a href="#" id="closeBtn" class="close_bt closeBtn">닫기</a>
			</div>
			<div class="popup_inner">
				<table class="write_tbl mgb_10">
					<colgroup>
						<col style="width:27%;" />
						<col style="width:37%;" />
					</colgroup>
					<tbody>
					<tr>
						<th>Extraction date</th>
						<td>
							<input type="date" name="extractionDate" min="1000-01-01" max="9999-01-01" style="width: 118px;" placeholder="ex)2017-01-01"/>
						</td>
					</tr>
					<tr>
						<th>대상기간</th>
						<td>
							<input type="date" name="periodFrom" min="1000-01-01" max="9999-01-01" style="width: 118px;" placeholder="ex)2017-01-01"/>
							~ <input type="date" name="periodTo" min="1000-01-01" max="9999-01-01" style="width: 118px;" placeholder="ex)2017-01-01"/>
						</td>
					</tr>
					<tr>
						<th>파일 선택<br/>
							<span style="color:red">※ 주의사항 <br/>- sheet1: 논문 상세정보 <br/>- sheet2: 논문 요약정보</span></th>
						<td>
							<input type="file" name="file"/>
						</td>
					</tr>
					</tbody>
				</table>
				<div class="list_set">
					<ul>
						<li><a href="javascript:importXlsx();" class="list_icon05">반입</a></li>
						<li><a href="javascript:$('#importDialog #closeBtn').triggerHandler('click');" class="list_icon10">취소</a></li>
					</ul>
				</div>
			</div>
		</form>
	</div>
</c:if>

<div class="wrap-loading display-none">
	<div><img src="${contextPath}/images/dthmlx/skins/terrace/imgs/dhxlayout_terrace/dhxlayout_cell_progress.gif" /></div>
</div>
</body>
</html>