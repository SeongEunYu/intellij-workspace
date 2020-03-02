<%--
  Created by IntelliJ IDEA.
  User: hojkim
  Date: 2017-08-30
  Time: 오전 11:18
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <%@include file="../pageInit.jsp" %>
    <style type="text/css">
        .dhxacc_base_dhx_terrace div.dhx_cell_acc div.dhx_cell_statusbar_def div.dhx_cell_statusbar_paging, .dhxlayout_base_dhx_terrace div.dhx_cell_layout div.dhx_cell_statusbar_def div.dhx_cell_statusbar_paging, .dhxtabbar_base_dhx_terrace div.dhx_cell_tabbar div.dhx_cell_statusbar_def div.dhx_cell_statusbar_paging {line-height: normal;}
    </style>
    <script type="text/javascript" src="<c:url value="/js/mainLayout.js"/>"></script>
    <script type="text/javascript">
        var dhxLayout, dhxTabbar, histGrid, templateLayout, templateToolbar, templateGrid, templateEditor, templateDp, editorToolBar, editorDp,  t;
        $(document).ready(function(){
            setMainLayoutHeight($('#mainLayout'), -47);
            if (window.attachEvent)  window.attachEvent("onresize",resizeLayout);
            else  window.addEventListener("resize",resizeLayout, false);
            //set layout
            dhxLayout = new dhtmlXLayoutObject("mainLayout","1C");
            dhxLayout.cells("a").hideHeader();
            dhxLayout.setSizes(false);

            dhxTabbar = dhxLayout.cells('a').attachTabbar({
                tabs:[
                    {id:'a1', text:'템플릿', active:true},
                    {id:'a2', text:'이력'},
                ]
            });
            dhxTabbar.setArrowsMode("auto");
            dhxTabbar.enableAutoReSize(true)
            loadHistTab();
            loadTemplateTab();
        });

        function loadHistTab(){
            dhxTabbar.tabs("a2").attachStatusBar({text:"<div id='pagingArea'></div>",paging:true,height:40});
            histGrid = dhxTabbar.tabs("a2").attachGrid();
            histGrid.setImagePath("${dhtmlXImagePath}");
            histGrid.setHeader("No,업무,관리번호,수신,제목,일자", null, grid_head_center_bold);
            histGrid.setColumnIds("no,rsltSe,rsltId,rcv,emailTitle,regDate");
            histGrid.setInitWidths("40,120,100,250,*,150");
            histGrid.setColAlign("center,center,center,left,left,center");
            histGrid.setColSorting("na,str,str,str,str,str,str");
            histGrid.setColTypes("ro,ro,ro,ro,ro,ro,ro");
            histGrid.enablePaging(true,100,10,"pagingArea",true);
            histGrid.setPagingSkin("${dhtmlXPagingSkin}");
            histGrid.init();
            histGrid_load();
        }

        function histGrid_load(){
            var url = getHistListURL();
            histGrid.clearAndLoad(url,function(){});
        }

        function getHistListURL() {
            var url = "<c:url value="/mail/findSndngHistList.do"/>";
            return url;
        }

        function loadTemplateTab(){

            templateLayout = dhxTabbar.tabs("a1").attachLayout("2U");
            templateLayout.cells("a").setWidth("400");
            templateLayout.cells("a").setText("템플릿 목록");
            templateLayout.cells("b").setText("내용");

            templateToolbar = templateLayout.cells("a").attachToolbar();
            templateToolbar.setIconsPath("${dhtmlXImagePath}/icons_${sysConf['dhtmlx.skin']}/");
            templateToolbar.setIconSize(18);
            templateToolbar.setAlign("right");
            templateToolbar.addButton("add", 1, "추가", "new.gif", "new_dis.gif");
            templateToolbar.addSeparator("sp1",2);
            templateToolbar.addButton("del", 3, "삭제", "del.png", "del_dis.png");

            templateToolbar.attachEvent("onClick",function(id){
                if(id == 'add') // 템플릿 추가
                {
                    templateGrid.addRow((new Date()).valueOf(),['',''], templateGrid.getSelectedRowId());
                }
                else if(id == 'del') // 템플릿 삭제
                {
                    templateGrid.deleteSelectedRows();
                    templateDp.sendData();
                    if(templateGrid.getRowsNum() > 0){
                        templateGrid.selectRow(0,true,true,true);
                        templateGrid.showRow(templateGrid.getRowId(0));
                    }
                    else
                    {
                        templateEditor.setContent("");
                    }
                }

            });

            editorToolBar = templateLayout.cells("b").attachToolbar();
            editorToolBar.setIconsPath("${dhtmlXImagePath}/icons_${sysConf['dhtmlx.skin']}/");
            editorToolBar.setIconSize(18);
            editorToolBar.setAlign("right");
            editorToolBar.addButton("save", 1, "저장", "save.gif", "save_dis.gif");
            <%--
            editorToolBar.addSeparator("sp1",2);
            editorToolBar.addButton("view", 3, "미리보기", "text_document.gif", "text_document.gif");
            --%>
            editorToolBar.attachEvent("onClick",function(id){
                if(id == 'save')
                {
                    var cIdex_sn = templateGrid.getColIndexById("sn");
                    var templateSn = templateGrid.cellById(templateGrid.getSelectedRowId(), cIdex_sn).getValue();
                    $.post(contextpath+"/mail/updateTemplateContents.do", {'sn':templateSn, 'contents':templateEditor.getContent()},null,'json').done(function(data){
                        var cIdex_contents = templateGrid.getColIndexById("contents");
                        templateGrid.cellById(templateGrid.getSelectedRowId(), cIdex_contents).setValue(templateEditor.getContent());
                        dhtmlx.alert("저장되었습니다.");
                    });
                }
            });

            templateEditor = templateLayout.cells("b").attachEditor({
                  toolbar: true,
                  iconsPath :"${dhtmlXImagePath}"
            });

            templateGrid = templateLayout.cells("a").attachGrid();
            templateGrid.setImagePath("${dhtmlXImagePath}");
            templateGrid.setHeader("sn,업무구분,제목,내용", null, grid_head_center_bold);
            templateGrid.setColumnIds("sn,jobGubun,title,contents");
            templateGrid.setInitWidths("1,100,*,0");
            templateGrid.setColAlign("center,center,left,center");
            templateGrid.setColSorting("na,str,str,na");
            templateGrid.setColTypes("ro,co,ed,ro");
            var jobGubunCombo = templateGrid.getCombo( templateGrid.getColIndexById("jobGubun"));
            jobGubunCombo.put('AUTH','권한');
            jobGubunCombo.put('ART','논문실적');
            jobGubunCombo.put('ERR_HANDLE','오류처리');
            jobGubunCombo.put('ERR_REPORT','오류신고');
            jobGubunCombo.put('LAB','LAB');
            jobGubunCombo.put('LAB_REQ','LAB_REQ');
            jobGubunCombo.put('DEGREE','취득학위');
            jobGubunCombo.put('AGRE','동의서');
            templateGrid.enableEditEvents(false,true,true);
            templateGrid.enableAutoHiddenColumnsSaving(true);
            templateGrid.setColumnHidden(templateGrid.getColIndexById("contents"),true);
            templateGrid.setColumnHidden(templateGrid.getColIndexById("sn"),true);
            templateGrid.attachEvent("onBeforeSelect",function(new_row, old_row, new_col_index){
               if(old_row != null && old_row != '0')
               {
                    var cIdex_contents = templateGrid.getColIndexById("contents");
                    var original_contents = templateGrid.cellById(old_row, cIdex_contents).getValue();
                    var current_contents = templateEditor.getContent();
                    current_contents = current_contents.replace(/\&nbsp;/gm, ' ');

                    if(original_contents != current_contents)
                    {
                        dhtmlx.confirm({
                            type:"confirm-warning",
                            title:"수정 중인 내용 저장",
                            text:"수정 중인 내용을 저장하시겠습니까?<br/>취소하시면 수정하신 부분은 저장되지 않습니다.",
                            ok:"저장", cancel:"취소",
                            callback:function(result){
                                if(result == true){
                                    var cIdex_sn = templateGrid.getColIndexById("sn");
                                    var templateSn = templateGrid.cells(old_row, cIdex_sn).getValue();
                                    $.post(contextpath+"/mail/updateTemplateContents.do", {'sn':templateSn, 'contents':templateEditor.getContent()},null,'json').done(function(data){
                                        var cIdex_contents = templateGrid.getColIndexById("contents");
                                        var editor_contents = templateEditor.getContent();
                                        editor_contents.replace(/\&nbsp;/gm, ' ');
                                        templateGrid.cells(old_row, cIdex_contents).setValue(editor_contents);
                                        templateGrid.selectRowById(new_row, false,false,true);
                                    });
                                }
                                else
                                {
                                    var cIdex_contents = templateGrid.getColIndexById("contents");
                                    var template_contents = templateGrid.cells(old_row, cIdex_contents).getValue();
                                    templateEditor.setContent(template_contents);
                                    templateGrid.selectRowById(new_row, false,false,true);
                                }
                            }
                        });
                    }
                    else
                    {
                        return true;
                    }
               }
               else
               {
                   return true;
               }
            });
            templateGrid.attachEvent("onRowSelect", function(rowId, cIndex){
                var cIdex_contents = templateGrid.getColIndexById("contents");
                var template_contents = templateGrid.cells(rowId, cIdex_contents).getValue();
                templateEditor.setContent(template_contents);
            });
            templateGrid.init();

            templateDp = new dataProcessor("<c:url value="/mail/templateCUD.do"/>");
            templateDp.init(templateGrid);
            templateDp.setTransactionMode("POST",false);
            templateDp.setUpdateMode("cell");
            templateDp.enableDataNames(true);
            templateDp.attachEvent("onAfterUpdate", function(id, action, tid, response){
                if(action == 'inserted')
                {
                    var cIndex_sn = templateGrid.getColIndexById("sn");
                    templateGrid.cellById(id, cIndex_sn).setValue(response.rowId);
                }
            });
            templateGrid.clearAndLoad("<c:url value="/mail/findTemplateList.do"/>", templateGrid_onSelectPageFirstRow);
        }

        function resizeLayout(){ window.clearTimeout(t); t = window.setTimeout(function(){ setMainLayoutHeight($('#mainLayout'),-47); dhxLayout.setSizes(false); },10);}
        //function doOnGridLoaded(){setTimeout(function() {dhxLayout.cells("a").progressOff();}, 100);}RI_PATENT_170330
        //function doBeforeGridLoad(){dhxLayout.cells("a").progressOn();}
        function templateGrid_onSelectPageFirstRow(){
            if(templateGrid.getRowsNum() > 0){
                templateGrid.selectRow(0,true,true,true);
                templateGrid.showRow(templateGrid.getRowId(0));
            }
        }
    </script>
</head>
<body>
    <div class="title_box">
        <h3>메일템플릿/이력</h3>
    </div>
    <div class="contents_box">
        <div id="mainLayout" style="position: relative; width: 100%;"></div>
    </div>
</body>
</html>
