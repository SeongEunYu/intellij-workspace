function addDetail(btn){
	detailIdx++;
	var $tbody = $(btn).parent().parent().parent();
	var $tr = $(btn).parent().parent();
	var newTr = $tr.clone();
	var inputs = newTr.find('input');
	for(var i=0; i < inputs.length; i++)
	{
		var objName = inputs.eq(i).prop('name');
		if(objName == 'detailIndex')
		{
		   inputs.eq(i).prop('id', objName+"_"+detailIdx).prop('value',detailIdx);
		}
		if(objName == 'seqFunding')
		{
			inputs.eq(i).prop('id', objName+"_"+detailIdx).val('N');
		}
		else
		{
			inputs.eq(i).prop('id', objName+"_"+detailIdx).val('');
		}

	}
	newTr.find('select[name="detailApprDvsCd"]').prop('id', 'detailApprDvsCd'+detailIdx).val('1');
	newTr.find('.ck_round_bt').remove();
	newTr.find('.dispDetailApprDate').eq(0).empty();
	newTr.css('background-color','#FFFFFF');
	$tr.after(newTr);
	$('#detailIndex_'+detailIdx).val(detailIdx);
	$tbody.find('span[id^="order_"]').each(function(i, obj){ $(obj).text(i+1); });
	isChange = true;
	//changeOrder($tbody);
}

function removeDetail(btn){
	var $tbody = $(btn).parent().parent().parent();
	var $thisTr = $(btn).parent().parent();
	var $trs = $tbody.find('tr');
	if($trs.length == 1){
		addDetail(btn);
	}
	var seqFunding = $thisTr.find('input[name="seqFunding"]').val();
	$('#formArea').append($('<input type="hidden" name="deleteDetail" value="'+seqFunding+'" />)'));
	$thisTr.remove();
	$tbody.find('span[id^="order_"]').each(function(i, obj){ $(obj).text(i+1); });
	isChange = true;
	//changeOrder($tbody);
}