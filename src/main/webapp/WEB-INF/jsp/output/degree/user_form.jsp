<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
<title>Title</title>
<%@include file="../../pageInit.jsp" %>
<link type="text/css" href="<c:url value="/css/layout.css"/>" rel="stylesheet" />
<link type="text/css" href="<c:url value="/js/dhtmlx/skins/"/>${sysConf['dhtmlx.skin']}/dhtmlx.css" rel="stylesheet" />
<script type="text/javascript" src="<c:url value="/js/jquery/jquery-1.11.3.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/dhtmlx/dhtmlx.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/script.js"/>"></script>
<script type="text/javascript">
var dhxUserLayout, userGrid;
var url = '<c:url value="/degree/findUserDegreeList.do"/>';
$(function(){
    dhxUserLayout = new dhtmlXLayoutObject("userLayout","1C");
    dhxUserLayout.cells("a").hideHeader();
    initRcvrLayout();
});

function initRcvrLayout(){
    userGrid = dhxUserLayout.cells("a").attachGrid();
    userGrid.setImagePath("${dhtmlXImagePath}");
    userGrid.setHeader("No.,사번,성명,학과명,미입력학위,알림", null, grid_head_center_bold);
    userGrid.setColumnIds("no,userId,korNm,groupDept,acqsDgrDvsCd,notice");
    userGrid.setInitWidths("30,40,70,70,*,70");
    userGrid.setColAlign("center,center,center,center,center,center");
    userGrid.setColTypes("ro,ro,ro,ro,ro,ro");
    userGrid.setColSorting("na,str,str,str,na,na");
    userGrid.enablePaging(true,100,10,"userPagingArea",true);
    userGrid.setPagingSkin("${dhtmlXPagingSkin}");
    userGrid.attachEvent("onXLS", doBeforeGridLoad);
    userGrid.attachEvent("onXLE", doOnGridLoaded);
    userGrid.attachEvent("onBeforeSorting",userGrid_onBeforeSorting);

    userGrid.init();
    userGrid_load();

    $('#searchForm').on('submit', function() {
        return false;
    });

}

function userGrid_onBeforeSorting(ind,type,direct){
    userGrid.clearAndLoad(url+"?orderby="+(userGrid.getColumnId(ind))+"&direct="+direct);
    userGrid.setSortImgState(true,ind,direct);
    return false;
}

function userGrid_load(){
    var fomrUrl = url + "?"  + $('#searchForm').serialize();
    userGrid.clearAndLoad(fomrUrl, function(){
        userGrid.changePage(1);
    });
    return false;
}

function doOnGridLoaded(){setTimeout(function() {dhxUserLayout.cells("a").progressOff();}, 100);}
function doBeforeGridLoad(){dhxUserLayout.cells("a").progressOn();}
</script>
</head>
<body>
    <form id="searchForm">
        <table class="view_tbl mgb_10" >
            <colgroup>
                <col style="width: 15%;"/>
                <col style="width: 37%;"/>
                <col style="width: 15%;"/>
                <col style="width: 37%;"/>
                <col />
            </colgroup>
            <tbody>
            <tr>
                <th>사번</th>
                <td><input type="text" name="srchUserId" class="input2" onKeyup="javascript:if(event.keyCode=='13')userGrid_load();"/></td>
                <th>성명</th>
                <td><input type="text" name="userNm" class="input2" maxlength="20" onKeyup="javascript:if(event.keyCode=='13')userGrid_load();"/></td>
                <td class="option_search_td" onclick="javascript:userGrid_load();"><em>search</em></td>
            </tr>
            </tbody>
        </table>
    </form>
    <div id="userLayout" style="position: relative; width: 576px;height: 570px;"></div>
    <div id="pagingObj" style="z-index: 1; height: 40px; margin-top: 5px;" >
        <div id="userPagingArea" style="z-index: 1;"></div>
    </div>
</body>
</html>
