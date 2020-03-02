<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <%@include file="../pageInit.jsp" %>
    <link type="text/css" href="<c:url value="/css/layout.css"/>" rel="stylesheet" />
    <link type="text/css" href="<c:url value="/js/dhtmlx/skins/"/>${sysConf['dhtmlx.skin']}/dhtmlx.css" rel="stylesheet" />
    <style type="text/css">.dhx_combo_select{height: 31px;}</style>
    <script type="text/javascript" src="<c:url value="/js/jquery/jquery-1.11.3.min.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/js/dhtmlx/dhtmlx.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/js/script.js"/>"></script>
    <script type="text/javascript">
        var dhxLayout, dhxMailFormLayout, dhxMailContentsEditor, dhxMailFtrToolbar, rcvrGrid, rcvrToolbar, rschGrid, rschToolbar, rcvGubunCombo, templateCombo;

        $(function(){
            dhxLayout = new dhtmlXLayoutObject("mainLayout","1C");

            dhxMailFormLayout = dhxLayout.cells("a").attachLayout({
            //dhxMailFormLayout = new dhtmlXLayoutObject({
                                pattern: "4F",
                                cells: [
                                    {id: "a", text: "수신/참조", height: 220},
                                    {id: "b", text: "대상"},
                                    {id: "c", text: "템플릿선택/제목입력", height: 61},
                                    {id: "d", text: "내용"}
                                ]
            });
            dhxMailFormLayout.attachFooter("layoutFooter");

            dhxMailFtrToolbar = new dhtmlXToolbarObject("layoutFooter");
            dhxMailFtrToolbar.setIconsPath("<c:url value="/images/dthmlx/skins/"/>${sysConf['dhtmlx.skin']}/imgs/icons_${sysConf['dhtmlx.skin']}/");
            dhxMailFtrToolbar.addButton("send", 0, "보내기", "send.gif", 'send_dis.gif');
            dhxMailFtrToolbar.setAlign("right");
            dhxMailFtrToolbar.attachEvent("onClick",confirmSendMail);

            dhxMailFormLayout.cells("b").collapse();    //대상 란 닫힌상태로 시작
            //dhxMailFormLayout.cells("c").attachHTMLString('<span style="padding-right: 8px;">제목 :</span><input type="text" name="subject" id="subject" value="" style="width:99.9%;height:34px;"/>');
            dhxMailFormLayout.cells("c").attachHTMLString('<div id="mail_template"></div>');

            dhxMailContentsEditor = dhxMailFormLayout.cells("d").attachEditor({
                toolbar: true,
                iconsPath :"${dhtmlXImagePath}"
            });

            initRcvrLayout();
            initRschLayout();
            loadTemplateCombo();

        });

        function loadTemplateCombo(){
            var rsltSe = '${param.rsltSe == 'ARTICLE' ? 'ART' : param.rsltSe == 'AUTHORITY' ? 'AUTH' : param.rsltSe}';
            templateCombo = new dhtmlXCombo("mail_template", "combo", 910);
            templateCombo.load("<c:url value="/mail/findTemplateComboOptions.do?jobGubun="/>"+rsltSe,function(){
                //메일 들어가자마자 해당 템플릿 자동선택
                    templateCombo.selectOption(0);
            });
            templateCombo.attachEvent("onChange", function(value, text){
                loadTemplateContents(value);
            });
        }

        function loadTemplateContents(sn){
            var rsltSe = '${param.rsltSe == 'ARTICLE' ? 'ART' : param.rsltSe == 'AUTHORITY' ? 'AUTH' : param.rsltSe}';
            $.post( "<c:url value="/mail/findTemplate.do"/>", {'sn':sn, 'jobGubun':rsltSe},null,'json').done(function(data){

                var content = data.contents;

                if(rsltSe == 'ART'){
                    content = content.replace("{current_date}", getCurrentDate());
                    content = content.replace("{article_id}", $(parent.document).find('#articleId').val());
                    content = content.replace("{journal_title}",$(parent.document).find('#scjnlNm').val());
                    content = content.replace("{article_title}",$(parent.document).find('#orgLangPprNm').val());
                    content = content.replace("{pub_year}",$(parent.document).find('#pblcYear').val());
                    content = content.replace("{volume}",$(parent.document).find('#pblcVolume').val());
                    content = content.replace("{issue}",$(parent.document).find('#pblcIssue').val());
                }else if (rsltSe == 'AUTH'){
                    content = content.replace("{current_date}", getCurrentDate());
                    content = content.replace("{auth_type}", $(parent.myGrid.getRowById(parent.myGrid.getSelectedRowId())).find("td").eq(3).text());
                    content = content.replace("{work_trget_nm}", $(parent.myGrid.getRowById(parent.myGrid.getSelectedRowId())).find("td").eq(5).text());
                    content = content.replace("{work_trget_dept}", $(parent.myGrid.getRowById(parent.myGrid.getSelectedRowId())).find("td").eq(7).text());
                    content = content.replace("{kor_nm}", $(parent.myGrid.getRowById(parent.myGrid.getSelectedRowId())).find("td").eq(2).text());
                    content = content.replace("{dept_kor}", $(rcvrGrid.getRowById(rcvrGrid.getRowId(0))).find("td").eq(3).text());
                    content = content.replace("{email_adres}", $(parent.myGrid.getRowById(parent.myGrid.getSelectedRowId())).find("td").eq(9).text());
                }else if (rsltSe == 'ERR_HANDLE'){
                    var requestStatus = $(parent.document).find("#requestStatus").val();
                    var rsltType = $(parent.document).find("#trgetRsltType").val();
                    rsltType = (rsltType == "article" ? "<spring:message code='menu.article'/>"
                            : rsltType == "conference" ? "<spring:message code='menu.conference'/>"
                            : rsltType == "book" ? "<spring:message code='menu.book'/>"
                            : rsltType == "patent" ? "<spring:message code='menu.patent'/>"
                            : rsltType == "funding" ? "<spring:message code='menu.funding'/>"
                            : rsltType == "exhibition" ? "<spring:message code='menu.exhibition'/>"
                            : rsltType == "techtrans" ? "<spring:message code='menu.techtrans'/>"
                            :'');


                    content = content.replace("{current_date}", getCurrentDate());
                    content = content.replace("{request_user_nm}", $(parent.document).find("#requestUserNm").val());
                    content = content.replace("{work_trget_nm}", $(rcvrGrid.getRowById(rcvrGrid.getRowId(0))).find("td").eq(4).text());
                    content = content.replace("{request_date}", $(parent.document).find("#requestDate").val());
                    content = content.replace("{trget_rslt_type}", rsltType);
                    content = content.replace("{trget_rslt_id}", $(parent.document).find("#trgetRsltId").val());
                    content = content.replace("{trget_rslt_nm}", $(parent.document).find("#trgetRsltNm").val());
                    content = content.replace("{request_se_cd}", $(parent.document).find("#requestSeCd").val());
                    content = content.replace("{request_cn}", $(parent.document).find("#requestCn").val());
                    content = content.replace("{request_user_admin_dvs_cd}", $(rcvrGrid.getRowById(rcvrGrid.getRowId(0))).find("td").eq(3).text());

                    content = content.replace("{trget_user_nm}", $(parent.document).find("#tretUserNm").val());
                    content = content.replace("{trget_date}", $(parent.document).find("#tretDate").val());
                    content = content.replace("{trget_result_cn}", $(parent.document).find("#tretResultCn").val().replace(/\n/g,'<br/>'));
                    content = content.replace("{request_status}", (requestStatus == '1' ? '요청' : requestStatus == '2' ? '미반영' : requestStatus == '3' ? '완료' : '보류'));
                }else if (rsltSe == 'DEGREE'){
                    var degreeNum = $(parent.document).find("#winVp").find("#acqs_dgr_dvs_nm").val().split(',').length;
                    content = content.replace("{current_date}", getCurrentDate());

                    var $div = $("<div></div>");
                    $div.append(content);

                    var parentTb = $($div).find("#informTb").parent();
                    var informTb = $($div).find("#informTb").clone().attr("id","");
                    $($div).find("#informTb").remove();

                    var korNm = $(parent.document).find("#winVp").find("#kor_nm").val();

                    var degreeIdArr = $(parent.document).find("#winVp").find("#degree_id").val().split(',');
                    var dgrAcqsYmArr = $(parent.document).find("#winVp").find("#dgr_acqs_ym").val().split(',');
                    var acqsDgrDvsNmArr = $(parent.document).find("#winVp").find("#acqs_dgr_dvs_nm").val().split(',');
                    var tutorNmArr = $(parent.document).find("#winVp").find("#tutor_nm").val().split(',');
                    var dgrSpclNmArr = $(parent.document).find("#winVp").find("#dgr_spcl_nm").val().split(',');
                    var dgrDtlSpclNmArr = $(parent.document).find("#winVp").find("#dgr_dtl_spcl_nm").val().split(',');


                    for(var i=0; i<degreeNum; i++){
                        var informTable = $(informTb).clone();
                        var degreeId = degreeIdArr[i] ? degreeIdArr[i] : '';
                        var dgrAcqsYm = dgrAcqsYmArr[i] ? dgrAcqsYmArr[i] : '';
                        var acqsDgrDvsNm = acqsDgrDvsNmArr[i] ? acqsDgrDvsNmArr[i] : '';
                        var tutorNm = tutorNmArr[i] ? tutorNmArr[i] : '';
                        var dgrSpclNm = dgrSpclNmArr[i] ? dgrSpclNmArr[i] : '';
                        var dgrDtlSpclNm = dgrDtlSpclNmArr[i] ? dgrDtlSpclNmArr[i] : '';

                        $(informTable).html($(informTable).html().replace("{degree_id}", degreeId));
                        $(informTable).html($(informTable).html().replace("{kor_nm}", korNm));
                        $(informTable).html($(informTable).html().replace("{dgr_acqs_ym}", dgrAcqsYm));
                        $(informTable).html($(informTable).html().replace("{acqs_dgr_dvs_nm}", acqsDgrDvsNm));
                        $(informTable).html($(informTable).html().replace("{tutor_nm}", tutorNm));
                        $(informTable).html($(informTable).html().replace("{dgr_spcl_nm}", dgrSpclNm));
                        $(informTable).html($(informTable).html().replace("{dgr_dtl_spcl_nm}", dgrDtlSpclNm));

                        $(parentTb).append(informTable);
                    }

                    content = $($div).html().toString();
                }else if(rsltSe == 'LAB'){
                    content = content.replace("{current_date}", getCurrentDate());
                }

                dhxMailContentsEditor.setContent(content);
            });
        }

        function confirmSendMail(id){
            if(id == 'send')
            {
                dhtmlx.confirm({ type:"confirm-warning", title:"메일발송", text:"메일을 발송하시겠습니까?", ok:"발송", cancel:"취소",
                    callback:function(result){
                        if(result == true){
                            doSendMail();
                        }
                    }
                });
            }
        }

        function doSendMail(){
            var rcvrGridforhist = "";
            var rcvrlist = "";
            var cclist = "";
            var cIndex_emailAddr = rcvrGrid.getColIndexById('emailAddr');
            var cIndex_rcvGubunAddr = rcvrGrid.getColIndexById('rcvGubun');
            var cIndex_korNmAddr = rcvrGrid.getColIndexById('korNm');
            var cIndex_userIdAddr = rcvrGrid.getColIndexById('userId');
            var cIndex_deptKorAddr = rcvrGrid.getColIndexById('deptKor');
            var k = 0;

            rcvrGrid.forEachRow(function(id){
                var emailAddr = rcvrGrid.cells(id, cIndex_emailAddr).getValue();
                var rcvGubun = rcvrGrid.cells(id, cIndex_rcvGubunAddr).getValue();
                var korNm = rcvrGrid.cells(id, cIndex_korNmAddr).getValue();
                var userId = rcvrGrid.cells(id, cIndex_userIdAddr).getValue();
                var deptKor = rcvrGrid.cells(id, cIndex_deptKorAddr).getValue();

                if(emailAddr != ''){
                    if(rcvGubun == 'TO') rcvrlist += korNm + "|" + emailAddr + ";";
                    else if(rcvGubun == 'CC') cclist += korNm + "|" + emailAddr + ";";
                }

                if(k!=0)rcvrGridforhist+="\r\n";
                rcvrGridforhist+=rcvGubun+"|"+korNm+"|"+emailAddr+"|"+deptKor+"|"+userId;
                k++
            });
            if(rcvrlist.length > 0)
            {
                dhxLayout.cells("a").progressOn();
               $('#rsltId').val('').val('${param.itemId}');
               $('#rsltSe').val('').val('${param.rsltSe}');
               $('#mailSubject').val('').val(templateCombo.getComboText());
               $('#mailContent').val('').val(dhxMailContentsEditor.getContent());
               $('#mailRcvrList').val('').val(rcvrlist);
               $('#mailCcList').val('').val(cclist);

               $('#mailRcvrGrid').val('').val(rcvrGridforhist);
               $.post('<c:url value="/mail/sendMail.do"/>', $('#mailForm').serializeArray(), null, 'json').done(function(data){
                   dhtmlx.alert(data.msg,function(){
                       dhxLayout.cells("a").progressOff();
                       if(data.code == '001')
                       {
                           parent.unloadDhxMailWins();
                       }
                   });
               });
            }
            else
            {
                dhtmlx.alert('수신자 메일 주소를 확인하세요.');
                return false;
            }

        }

        function initRcvrLayout(){
            rcvrToolbar = dhxMailFormLayout.cells("a").attachToolbar();
            rcvrToolbar.setIconsPath("<c:url value="/images/dthmlx/skins/"/>${sysConf['dhtmlx.skin']}/imgs/icons_${sysConf['dhtmlx.skin']}/");
            rcvrToolbar.addButton("delete", 0, "삭제", "del.png", "del_dis.png");
            rcvrToolbar.setAlign("right");
            rcvrToolbar.attachEvent("onClick", onRcvrDelete);

            rcvrGrid = dhxMailFormLayout.cells("a").attachGrid();
            rcvrGrid.setImagePath("${dhtmlXImagePath}");
            rcvrGrid.setHeader("No.,수신/참조,성명,권한,대상자,이메일,소속,사번", null, grid_head_center_bold);
            rcvrGrid.setColumnIds("no,rcvGubun,korNm,adminDvsCd,workTrgetNm,emailAddr,deptKor,userId");
            rcvrGrid.setSerializableColumns("true,true,true,true,true,true,true,true");
            rcvrGrid.setInitWidths("30,70,70,70,70,90,*,1");
            rcvrGrid.setColAlign("center,center,center,center,center,left,left,left");
            rcvrGrid.setColTypes("ro,co,ro,ro,ro,ed,ro,ro");
            rcvrGrid.setColSorting("na,na,na,na,na,na,na,na");
            rcvGubunCombo = rcvrGrid.getCombo(rcvrGrid.getColIndexById("rcvGubun"));
            rcvGubunCombo.put("TO","수신");
            rcvGubunCombo.put("CC","참조");
            rcvrGrid.setColumnHidden(rcvrGrid.getColIndexById("userId"),true);
            rcvrGrid.enableEditEvents(true,false,true);
            rcvrGrid.enableDragAndDrop(true);
            rcvrGrid.enableMultiselect(true);
            rcvrGrid.init();
            rcvrGrid.load("<c:url value="/mail/findMailRcvrList.do"/>?rsltSe=${param.rsltSe}&itemId=${param.itemId}");
        }

        function onRcvrDelete(id){
            if(id == 'delete')
            {
                var rowId = rcvrGrid.getSelectedRowId();
                if(rowId == null)
                {
                    dhtmlx.alert('삭제할 수신자를 선택하세요.');
                    return false;
                }
                else
                {
                    rcvrGrid.deleteSelectedRows();

                    for(var i=0; i< rcvrGrid.getRowsNum(); i++){
                        rcvrGrid.cellByIndex(i,0).setValue(i+1);
                    }
                }
            }
        }

        function initRschLayout(){
            rschToolbar = dhxMailFormLayout.cells("b").attachToolbar();
            rschToolbar.setIconsPath("<c:url value="/images/dthmlx/skins/"/>${sysConf['dhtmlx.skin']}/imgs/icons_${sysConf['dhtmlx.skin']}/");
            rschToolbar.addButton("add", 0, "추가", "new.gif", "new_dis.gif");
            rschToolbar.setAlign('right');
            rschToolbar.attachEvent("onClick",onRcvrAdd);

            var rschFilterHeader = new Array();
            if(!window.chrome){
                rschFilterHeader.push('');
                rschFilterHeader.push('');
            }
            rschFilterHeader.push('<input type="text" name="srchUserNm" id="srchUserNm" onkeyup="javascript:if(event.keyCode == 13){rschGrid_load();}" style="width:90%"/>');
            if(!window.chrome) {
                rschFilterHeader.push('');
                rschFilterHeader.push('');
            }
            rschFilterHeader.push('<input type="text" name="srchEmalAddr" id="srchEmalAddr" onkeyup="javascript:if(event.keyCode == 13){rschGrid_load();}" style="width:90%"/>');
            rschFilterHeader.push('<input type="text" name="srchDeptKor" id="srchDeptKor" onkeyup="javascript:if(event.keyCode == 13){rschGrid_load();}" style="width:90%"/>');
            if(!window.chrome) {
                rschFilterHeader.push('');
            }

            rschGrid = dhxMailFormLayout.cells("b").attachGrid();
            rschGrid.setImagePath("${dhtmlXImagePath}");
            rschGrid.setHeader("No.,수신/참조,성명,권한,대상자,이메일,소속,사번", null, grid_head_center_bold);
            rschGrid.attachHeader(rschFilterHeader,grid_head_center_bold);
            rschGrid.setColumnIds("no,rcvGubun,korNm,adminDvsCd,workTrgetNm,emailAddr,deptKor,userId");
            rschGrid.setInitWidths("1,1,100,1,1,130,*,1");
            rschGrid.setColAlign("center,center,center,center,center,left,left,left");
            rschGrid.setColTypes("ro,ro,ro,ro,ro,ro,ro,ro");
            rschGrid.setColSorting("na,na,na,na,na,na,na,na");
            rschGrid.attachEvent("onXLS", doBeforeGridLoad);
            rschGrid.attachEvent("onXLE", doOnGridLoaded);
            rschGrid.setColumnHidden(rschGrid.getColIndexById("userId"),true);
            rschGrid.setColumnHidden(rschGrid.getColIndexById("rcvGubun"),true);
            rschGrid.setColumnHidden(rschGrid.getColIndexById("no"),true);
            rschGrid.setColumnHidden(rschGrid.getColIndexById("adminDvsCd"),true);
            rschGrid.setColumnHidden(rschGrid.getColIndexById("workTrgetNm"),true);
            rschGrid.enableDragAndDrop(true);
            rschGrid.enableMultiselect(true);
            rschGrid.init();
            rschGrid.enableSmartRendering(true,50);
            rschGrid.setAwaitedRowHeight(26);
            rschGrid_load();
        }

        function onRcvrAdd(id){
            if(id == 'add')
            {
                if(rschGrid.getSelectedRowId() == null)
                {
                    dhtmlx.alert('수신자에 추가할 대상자를 선택하세요.');
                    return false;
                }
                var sIds = new Array();
                var selectedIds = rschGrid.getSelectedRowId();
                sIds = selectedIds.split(',');
                for(var i=0; i < sIds.length; i++)
                {
                    rcvrGrid.moveRowTo(sIds[i],sIds[i],"move","sibling",rschGrid, rcvrGrid);
                }
                for(var j=0; j< rcvrGrid.getRowsNum(); j++){
                    rcvrGrid.cellByIndex(j,0).setValue(j+1);
                }
            }
        }

        function rschGrid_load(){
            var url = "<c:url value="/mail/findTargetList.do"/>?type=0";
            if($('#srchUserNm').val()) url += "&srchUserNm=" + encodeURIComponent($('#srchUserNm').val());
            if($('#srchEmalAddr').val()) url += "&srchEmalAddr=" + encodeURIComponent($('#srchEmalAddr').val());
            if($('#srchDeptKor').val()) url += "&srchDeptKor=" + encodeURIComponent($('#srchDeptKor').val());
            rschGrid.clearAndLoad(url);
        }

        function doOnGridLoaded(){setTimeout(function() {dhxMailFormLayout.cells("b").progressOff();}, 100);}
        function doBeforeGridLoad(){dhxMailFormLayout.cells("b").progressOn();}
    </script>
</head>
<body>
    <div id="mainLayout" style="position: relative; width: 100%;height: 780px;"></div>
    <div id="layoutFooter" style="height: 35px;padding-top:5px;text-align: right;"></div>
    <form id="mailForm">
        <input type="hidden" name="rsltId" id="rsltId"/>
        <input type="hidden" name="rsltSe" id="rsltSe"/>
        <input type="hidden" name="emailTitle" id="mailSubject"/>
        <input type="hidden" name="emailContents" id="mailContent"/>
        <input type="hidden" name="rcvrlist" id="mailRcvrList"/>
        <input type="hidden" name="cclist" id="mailCcList"/>
        <input type="hidden" name="rcvrgrid" id="mailRcvrGrid"/>
    </form>
</body>
</html>
