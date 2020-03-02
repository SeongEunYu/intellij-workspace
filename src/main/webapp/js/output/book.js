function vriferByKri(){

	if($('#orgLangBookNm').val() == "")
	{
		dhtmlx.alert({type:"alert-warning",text:"저역서명(원어)은 필수입니다.",callback:function(){ $('#orgLangBookNm').focus();}});
		return;
	}
	else if($('#bookPblcYear').val() == "")
	{
		dhtmlx.alert({type:"alert-warning",text:"발행년월은 필수입니다.",callback:function(){ $('#bookPblcYear').focus();}});
		return;
	}

	var wWidth = 935;
	var wHeight = 700;
	var leftPos = (screenWidth - wWidth)/2;
	var topPos = (screenHeight - wHeight)/2;

	var pcnRschrRegNo = "";
	var pcnRschrRegNos = $('input[name="pcnRschrRegNo"]');
	for(var i = 0; i<pcnRschrRegNos.length; i++)
	{
		if(pcnRschrRegNos.eq(i).val() != ''){
			pcnRschrRegNo = pcnRschrRegNos.eq(i).val();
			break;
		}
	}

	var kriPopup = window.open('about:blank', 'kriSearchPopup', 'width='+wWidth+'px,height='+wHeight+'px,top='+topPos+',left='+leftPos+' location=no,scrollbars=yes,resizable=yes');
	var vrfcFrm = $('#vrfcFrm');
	vrfcFrm.empty();
	vrfcFrm.append($('<input type="hidden" name="Kri_Param2" value="'+pcnRschrRegNo+'"/>'));
	vrfcFrm.append($('<input type="hidden" name="Kri_Param3" value="'+$('#orgLangBookNm').val()+'"/>'));
	vrfcFrm.append($('<input type="hidden" name="Kri_Param4" value="'+$('#bookPblcYear').val()+'"/>'));
	vrfcFrm.append($('<input type="hidden" name="Kri_Param5" value="'+$('#isbnNo').val()+'"/>'));
	vrfcFrm.append($('<input type="hidden" name="returnUrl" value="'+rimsUrl+contextpath+'/jsp/vrifyByKri.jsp"/>'));
	vrfcFrm.append($('<input type="hidden" name="kriAction" value="'+kriAction+'"/>'));
	vrfcFrm.append($('<input type="hidden" name="Kri_Service" value="7"/>'));
	vrfcFrm.attr('action',contextpath+'/jsp/kriVrfc.jsp');
	vrfcFrm.attr('target','kriSearchPopup');
	vrfcFrm.submit();
	vrfcFrm.focus();

}