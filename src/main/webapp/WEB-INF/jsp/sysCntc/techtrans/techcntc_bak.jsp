<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${sysConf['system.rims.jsp.title']}</title>
<%@include file="../../pageInit.jsp" %>
<script type="text/javascript">
 var contextpath = '${contextPath}';
 var dhtmlximagepath = '${dhtmlXImagePath}';
 var dhtmlxskin = '${dhtmlXSkin}';
 var dhtmlxpagingskin = '${dhtmlXPagingSkin}';
 var language = '${language}';
 var instname = "${sysConf['inst.blng.agc.name']}";
 var instcode = "${sysConf['inst.blng.agc.code']}";
 var isChange = false;
 var mode = '${param.mode}';
 </script>
<link type="text/css" href="${contextPath}/css/layout.css" rel="stylesheet" />
<link type="text/css" href="${contextPath}/js/dhtmlx/skins/${sysConf['dhtmlx.skin']}/dhtmlx.css" rel="stylesheet" />
<style type="text/css">
.dhxwins_vp_dhx_terrace {overflow: auto;} .dhx_toolbar_dhx_terrace { padding: 0 0px; }
.dhxwins_vp_dhx_terrace div.dhxwin_active div.dhx_cell_wins div.dhx_cell_toolbar_def, .dhxwins_vp_dhx_terrace div.dhxwin_inactive div.dhx_cell_wins div.dhx_cell_toolbar_def { padding: 10px 0px 0; }
div.dhxform_item_label_left.button_search div.dhxform_btn { height: 25px; margin: 0px 2px; background-color: #ffffff;}
div.dhxform_item_label_left.button_search div.dhxform_btn_txt { top:0;right:0;background: url(${contextPath}/images/background/tbl_search_icon.png) no-repeat 50% 50%; text-indent: -9999px;display: block;width: 23px; height: 25px;margin: 0 0px;}
.alignLeft{text-align: left;} .alignLeft div.dhxform_txt_label2{font-weight: normal;}
.write_tbl tbody td { padding: 3px 10px; border-bottom: 1px solid #ddd; }
</style>
<script type="text/javascript" src="${contextPath}/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="${contextPath}/js/jquery/jquery-ui.min.js"></script>
<script type="text/javascript" src="${contextPath}/js/dhtmlx/dhtmlx.js"></script>
<script type="text/javascript" src="${contextPath}/js/script.js"></script>
<script type="text/javascript" src="${contextPath}/js/mainLayout.js"></script>
<script type="text/javascript">
var dhxLayout, dhxWins, patentGrid;
var dhxBLayout, pmsLayout, rimsLayout;
$(document).ready(function(){
	if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
	else  window.addEventListener("resize",resizeLayout, false);
	dhxLayout = new dhtmlXLayoutObject("mainLayout","3E");
	dhxLayout.setSizes(false);
	dhxLayout.cells("a").setText("계약정보");
	dhxLayout.cells("a").setHeight("270");
	dhxLayout.cells("a").appendObject("transferContractDiv");

	dhxLayout.cells("b").fixSize(true,false);
	loadDhxBLayout();

	dhxLayout.cells("c").setText("관련특허");
	dhxLayout.cells("c").setHeight("200");
	dhxLayout.cells("c").collapse();
	loadPathentLayout();
});

function loadDhxBLayout(){

	dhxBLayout = dhxLayout.cells("b").attachLayout('2U');

	pmsLayout = dhxBLayout.cells("a").attachLayout('2E');
	pmsLayout.cells("a").setText("참여자(PMS)");
	pmsLayout.cells("b").setText("입금/배분(PMS)");
	pmsLayout.cells("a").setHeight("400");
	pmsLayout.cells("b").setHeight("100");
	pmsLayout.cells("a").hideArrow();
	pmsLayout.cells("b").hideArrow();
	pmsLayout.cells("a").fixSize(false,true);
	pmsLayout.cells("b").fixSize(false,true);

	rimsLayout = dhxBLayout.cells("b").attachLayout('2E');
	rimsLayout.cells("a").setText("참여자(RIMS)");
	rimsLayout.cells("b").setText("입금/배분(RIMS)");
	rimsLayout.cells("a").setHeight("400");
	rimsLayout.cells("b").setHeight("100");
	rimsLayout.cells("a").fixSize(false,true);
	rimsLayout.cells("b").fixSize(false,true);

	rimsLayout.attachEvent("onExpand", function(name){
		pmsLayout.cells(name).expand();
	});
	rimsLayout.attachEvent("onCollapse", function(name){
		pmsLayout.cells(name).collapse();
	});

	loadPartiComponent();
	loadAmtComponent();
}

function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){ dhxLayout.setSizes(false); },200);}
function doOnGridLoaded(){setTimeout(function() {dhxLayout.cells("a").progressOff();}, 100);}
function doBeforeGridLoad(){dhxLayout.cells("a").progressOn();}

var pmsPartiGrid, rimsPartiGrid
function loadPartiComponent(){

	pmsPartiGrid = pmsLayout.cells("a").attachGrid();
	pmsPartiGrid.setImagePath("${dhtmlXImagePath}");
	pmsPartiGrid.setHeader("사번,성명,성명(영문),소속", null, grid_head_center_bold);
	pmsPartiGrid.setInitWidths("80,120,100,*");
	pmsPartiGrid.setColAlign("center,center,left,left");
	pmsPartiGrid.setColTypes("ro,ro,ro,ro");
	pmsPartiGrid.setColSorting("str,str,str,str");
	pmsPartiGrid.enableColSpan(true);
	pmsPartiGrid.attachEvent("onXLS", function() { pmsLayout.cells("a").progressOn(); });
	pmsPartiGrid.attachEvent("onXLE", function() { pmsLayout.cells("a").progressOff(); });
	pmsPartiGrid.init();
	pmsPartiGrid.clearAndLoad('${contextPath}/techtransCntc/findPmsTechtransPartiList.do?srcId=' + $('#srcId').val());

	rimsPartiGrid = rimsLayout.cells("a").attachGrid();
	rimsPartiGrid.setImagePath("${dhtmlXImagePath}");
	rimsPartiGrid.setHeader("사번,성명,소속", null, grid_head_center_bold);
	rimsPartiGrid.setInitWidths("100,120,*");
	rimsPartiGrid.setColAlign("center,center,left");
	rimsPartiGrid.setColTypes("ro,ro,ro");
	rimsPartiGrid.setColSorting("str,str,str");
	rimsPartiGrid.attachEvent("onXLS", function() { rimsLayout.cells("a").progressOn(); });
	rimsPartiGrid.attachEvent("onXLE", function() { rimsLayout.cells("a").progressOff(); });
	rimsPartiGrid.init();
	//pmsPartiGrid.clearAndLoad('${contextPath}/user/findAuthorListByKeyword.do?keyword=' + encodeURIComponent(w1Toolbar.getValue('keyword')));

}


var pmsAmtGrid, rimsAmtGrid
function loadAmtComponent(){
	pmsAmtGrid = pmsLayout.cells("b").attachGrid();
	pmsAmtGrid.setImagePath("${dhtmlXImagePath}");
	pmsAmtGrid.setHeader(",형태,입금일자,회차,입금액,공제금액,공제내역,차액,발명자,학교,학과,산단", null, grid_head_center_bold);
	pmsAmtGrid.setColumnIds(",collectionType,rpmDate,srcTme,rpmAmt,ddcAmt,ddcResn,diffAmt,invnterDstbAmt,univDstbAmt,deptDstbAmt,acdincpDstbAmt");
	pmsAmtGrid.setInitWidths("30,100,80,50,110,100,150,100,100,100,100,100");
	pmsAmtGrid.setColAlign("center,center,center,center,right,right,left,right,right,right,right,right");
	pmsAmtGrid.setColTypes("sub_row,ro,ro,ro,edn,edn,ro,edn,edn,edn,edn,edn");
	pmsAmtGrid.setColSorting("na,str,str,str,int,int,str,int,int,int,int,int");
	//pmsAmtGrid.splitAt(4);
	//pmsAmtGrid.enableColSpan(true);
	pmsAmtGrid.setEditable(false);
	pmsAmtGrid.setNumberFormat("0,000",pmsAmtGrid.getColIndexById("rpmAmt"));
	pmsAmtGrid.setNumberFormat("0,000",pmsAmtGrid.getColIndexById("ddcAmt"));
	pmsAmtGrid.setNumberFormat("0,000",pmsAmtGrid.getColIndexById("diffAmt"));
	pmsAmtGrid.setNumberFormat("0,000",pmsAmtGrid.getColIndexById("invnterDstbAmt"));
	pmsAmtGrid.setNumberFormat("0,000",pmsAmtGrid.getColIndexById("univDstbAmt"));
	pmsAmtGrid.setNumberFormat("0,000",pmsAmtGrid.getColIndexById("deptDstbAmt"));
	pmsAmtGrid.setNumberFormat("0,000",pmsAmtGrid.getColIndexById("acdincpDstbAmt"));
	pmsAmtGrid.attachEvent("onXLS", function() { pmsLayout.cells("b").progressOn(); });
	pmsAmtGrid.attachEvent("onXLE", function() { pmsLayout.cells("b").progressOff(); });
	pmsAmtGrid.attachEvent("onSubGridCreated", function(sgrid){
		console.log("onSubGridCreated");
        sgrid.enableAutoHeight(true,400)
        sgrid.setSizes()
        return true;
	});
	pmsAmtGrid.init();
	pmsAmtGrid.clearAndLoad('${contextPath}/techtransCntc/findPmsTechtransRcpmnyList.do?srcId=' + $('#srcId').val());

	rimsAmtGrid = rimsLayout.cells("b").attachGrid();
	rimsAmtGrid.setImagePath("${dhtmlXImagePath}");
	rimsAmtGrid.setHeader("형태,입금일자,회차,입금액,공제금액,공제내역,차액", null, grid_head_center_bold);
	rimsAmtGrid.init();


}

var patGrid;
function loadPathentLayout(){
	patGrid = dhxLayout.cells("c").attachGrid();
	patGrid.setImagePath("${dhtmlXImagePath}");
	patGrid.setHeader("Case-ID,P-Code,특허명,발명자,출원번호,등록번호", null, grid_head_center_bold);
	patGrid.setInitWidths("100,100,*,150,120,120");
	patGrid.setColAlign("center,center,left,center,center,center");
	patGrid.setColTypes("ro,ro,ro,ro,ro,ro");
	patGrid.setColSorting("na,na,na,na,na,na");
	patGrid.attachEvent("onXLS", function() { dhxLayout.cells("c").progressOn(); });
	patGrid.attachEvent("onXLE", function() { dhxLayout.cells("c").progressOff(); });
	patGrid.init();
	patGrid.clearAndLoad('${contextPath}/techtransCntc/findPmsTechtransPatentList.do?srcId=' + $('#srcId').val());
}
</script>
</head>
<body style="background: none;padding-left: 20px;width: 97%;" class="dhxwins_vp_dhx_terrace">
	<div class="title_box">
		<h3><spring:message code='menu.cntc.techtrans'/></h3>
	</div>
	<form id="formArea" action="${contextPath}/member/modifyMember.do" method="post">
	   <input type="hidden" name="trgetUserId" id="trgetUserId" value="${member.userId}"/>
	   <input type="hidden" name="trgetAuthorId" id="trgetAuthorId" value="${param.trgetAuthorId}"/>
	   <div id="mainLayout" style="position: relative; width: 100%;height: 100%;"></div>
	</form>
	<script type="text/javascript">setMainLayoutHeight($('#mainLayout'));</script>
	<div id="transferContractDiv" style="display: none;">
		<table class="write_tbl">
			<colgroup>
				<col style="width:150px;" />
				<col style="width:431px;" />
				<col style="width:20px" />
				<col/>
			</colgroup>
			<tbody>
				<tr>
					<th style="text-align: center;">항목명</th>
					<th style="text-align: center;">PMS</th>
					<th></th>
					<th style="text-align: center;">RIMS</th>
				</tr>
				<tr>
					<th>기술이전년월</th>
					<td style="border-right: 1px solid #ddd;">
						${not empty pmsTechtrans ? pmsTechtrans.techTransrYm : ''}
					</td>
					<td style="border-right: 1px solid #ddd;">
					</td>
					<td>${not empty techtrans ? techtrans.techTransrYm : ''}</td>
				</tr>
				<tr>
					<th>기술이전명</th>
					<td style="border-right: 1px solid #ddd;">
						<input type="hidden" name="srcId"  id="srcId" value="${pmsTechtrans.srcId}"/>
						${not empty pmsTechtrans ? pmsTechtrans.techTransrNm : ''}
					</td>
					<td style="border-right: 1px solid #ddd;">
					</td>
					<td>${not empty techtrans ? techtrans.techTransrNm : ''}</td>
				</tr>
				<tr>
					<th>이전기업명</th>
					<td style="border-right: 1px solid #ddd;">
						${not empty pmsTechtrans ? pmsTechtrans.techTransrCorpNm : ''}
					</td>
					<td style="border-right: 1px solid #ddd;">
					</td>
					<td>${not empty techtrans ? techtrans.techTransrCorpNm : ''}</td>
				</tr>
				<tr>
					<th>이전형태</th>
					<td style="border-right: 1px solid #ddd;">
						${not empty pmsTechtrans ? pmsTechtrans.techTransrCd : ''}
					</td>
					<td style="border-right: 1px solid #ddd;">
					</td>
					<td>${not empty techtrans ? techtrans.techTransrCd : ''}</td>
				</tr>
				<tr>
					<th>계약금액</th>
					<td style="border-right: 1px solid #ddd;">
						<c:if test="${not empty pmsTechtrans}">
							<fmt:formatNumber value="${pmsTechtrans.rpmAmt}"/>(${pmsTechtrans.rpmAmtUnit})
						</c:if>
					</td>
					<td style="border-right: 1px solid #ddd;">
					</td>
					<td>${not empty techtrans ? techtrans.rpmAmt : ''}</td>
				</tr>
				<tr>
					<th>징수형태</th>
					<td style="border-right: 1px solid #ddd;">
						${not empty pmsTechtrans ? pmsTechtrans.collectionCd : ''}
					</td>
					<td style="border-right: 1px solid #ddd;">
					</td>
					<td>${not empty techtrans ? techtrans.collectionCd : ''}</td>
				</tr>
				<tr>
					<th>계약번호</th>
					<td style="border-right: 1px solid #ddd;">
						${not empty pmsTechtrans ? pmsTechtrans.cntrctManageNo : ''}
					</td>
					<td style="border-right: 1px solid #ddd;">
					</td>
					<td>${not empty techtrans ? techtrans.cntrctManageNo : ''}</td>
				</tr>
			</tbody>
		</table>
	</div>
</body>
</html>