function addRoyalty(btn){
	royaltyIdx++;
	var $tbody = $(btn).parent().parent().parent();
	var $tr = $(btn).parent().parent();
	var newTr = $tr.clone();
	var inputs = newTr.find('input');
	for(var i=0; i < inputs.length; i++)
	{
		var objName = inputs.eq(i).prop('name');
		if(objName == 'royaltyIndex')
		{
		   inputs.eq(i).prop('id', objName+"_"+royaltyIdx).prop('value',royaltyIdx);
		}
		if(objName == 'seqRoyalty')
		{
			inputs.eq(i).prop('id', objName+"_"+royaltyIdx).val('N');
		}
		else
		{
			inputs.eq(i).prop('id', objName+"_"+royaltyIdx).val('');
		}

	}
	newTr.find('select[name="collectionType"] option').prop('selected','');
	newTr.css('background-color','#FFFFFF');
	$tr.after(newTr);
	$tbody.find('span[id^="order_"]').each(function(i, obj){ $(obj).text(i+1); });
	isChange = true;
}

function removeRoyalty(btn){
	var $tbody = $(btn).parent().parent().parent();
	var $thisTr = $(btn).parent().parent();
	var $trs = $tbody.find('tr');
	if($trs.length == 1){
		addRoyalty(btn);
	}
	var seqRoyalty = $thisTr.find('input[name="seqRoyalty"]').val();
	$('#formArea').append($('<input type="hidden" name="deleteRoyalty" value="'+seqRoyalty+'" />)'));
	$thisTr.remove();
	$tbody.find('span[id^="order_"]').each(function(i, obj){ $(obj).text(i+1); });
	isChange = true;
}
