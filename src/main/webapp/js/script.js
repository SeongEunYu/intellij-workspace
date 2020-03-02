var grid_head_center_bold = ["text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;", "text-align:center;font-weight:bold;"];
var grid_head_right_bold = ["text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;", "text-align:right;font-weight:bold;"];
var fillColors = new Array( "AFD8F8","F6BD0F","8BBA00","FF8E46","008E8E","D64646","8E468E","588526","B3AA00","008ED6","9D080D","A186BE","CC6600","FDC689","ABA000","F26D7D","FFF200","0054A6","F7941C","CC3300","006600","663300","6DCFF6");

function convertFormat(value){
	 return value.replace(/0.00.*/, '0');
}

String.prototype.trim = function() {
    return this.replace(/(^\s*)|(\s*$)/gi, "");
}

String.prototype.startsWith = function(str){
    if (this.length < str.length) { return false; }
    return this.indexOf(str) == 0;
}

// Design Javascript Start //
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}
function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}
function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
function showSubMenu(obj){
	hideSubMenu(obj);
	document.all[obj].style.display = 'block';
}
function hideSubMenu(obj){
	var menuName = "submenu0";
	for(var i = 1; i < 7; i++) {
		var menuId = [menuName, i];
		document.all[menuId.join("")].style.display = 'none';
	}
}
function stageView(id, num){
		for (i=1;i<num;i++){
				var obj = document.getElementById("stage0" + i);
				var menuObj = document.getElementById("stageMenu0" + i);
				if(i == id){
						obj.style.display = "block";
				}else{
						obj.style.display = "none";

				}
		}
}
function stageMenu(id,imgObj){
		var obj = document.getElementById("stage0" + id);
		if(obj.style.display == "block"){
				imgObj.style.filter = "none";
		}else{

		}
}
function bluring(){
        if(event.srcElement.tagName=="A"||event.srcElement.tagName=="IMG")
        document.body.focus();
}
// Desgin Javascript End //


function CheckLen(valF, cntF,max) {
	var temp;
	var memocount;

	memocount = 0;
	var len = valF.value.length;
	for(k=0;k<len;k++){
		temp = valF.value.charAt(k);
		if(escape(temp).length > 4)
			memocount += 2;
		else
			memocount++;

		if (memocount/2>max) {
			alert(max+"자까지만 쓸 수 있습니다.");
			valF.value = valF.value.substring(0,k);
			if(escape(temp).length > 4)
				memocount -= 2;
			else
				memocount--;
			break;
		}

	}
	cntF.value = memocount/2;

	return memocount/2;
}

var regexp1 = /^[12]$/;
var regexp2 = /^[12][09]$/;
var regexp3 = /^[12][09][019]$/;
var regexp4 = /^[12][09][019][0-9]$/;
var regexp5 = /^[12][09][019][0-9][\-]$/;
var regexp6 = /^[12][09][019][0-9][\-][01]$/;
var regexp7 = /^[12][09][019][0-9][\-][01][0-9]$/;
var regexp8 = /^[12][09][019][0-9][\-][01][0-9][\-]$/;
var regexp9 = /^[12][09][019][0-9][\-][01][0-9][\-][0-3]$/;
var regexp10 = /^[12][09][019][0-9][\-][01][0-9][\-][0-3][0-9]$/;
var regexp11 = /^[12][09][019][0-9][\-][01][0-9][\-][0-3][0-9][ ]$/;
var regexp12 = /^[12][09][019][0-9][\-][01][0-9][\-][0-3][0-9][ ][0-2]$/;
var regexp13 = /^[12][09][019][0-9][\-][01][0-9][\-][0-3][0-9][ ][0-2][0-9]$/;
var regexp14 = /^[12][09][019][0-9][\-][01][0-9][\-][0-3][0-9][ ][0-2][0-9][:]$/;
var regexp15 = /^[12][09][019][0-9][\-][01][0-9][\-][0-3][0-9][ ][0-2][0-9][:][0-6]$/;
var regexp16 = /^[12][09][019][0-9][\-][01][0-9][\-][0-3][0-9][ ][0-2][0-9][:][0-6][0-9]$/;
var seperator = "-";

function validDate(valF, e, maxlength) {

	if(valF.value.length==0) return;
	if(!maxlength) maxlength=10;

 	if(!e) e = window.event;
 	if(e.type=='keyup'&&e.keyCode==8) return;

	if(valF.value.length==4)
		valF.value = valF.value + seperator;
	else if(valF.value.length==7)
		valF.value = valF.value + seperator;
	else if(valF.value.length==10 && maxlength>10)
		valF.value = valF.value + " ";
	else if(valF.value.length==13 && maxlength>13) valF.value = valF.value + ":";

	var chkFlag = eval("regexp"+valF.value.length).test(valF.value);
	if(!chkFlag) {
		for(var ii=valF.value.length-1;ii>=0;ii--) {
			valF.value = valF.value.substring(0,ii);
			if(ii==0||eval("regexp"+valF.value.length).test(valF.value)) break;
		}
		alert("날짜형식이 유효하지 않습니다.");
	}

}

function validation(form) {

	var elements = form.all;
	var prev;
	for(var i=0;i<elements.length;i++) {
		var e = elements[i];
		var tagName = e.tagName.toUpperCase();

		if(tagName=="INPUT"&&e.type.toUpperCase()=="TEXT") {
			if(!validTextField(e)) return false;
		}else if(tagName=="TEXTAREA") {
			if(!validTextField(e)) return false;
		}else if(tagName=="INPUT"&&(e.type.toUpperCase()=="RADIO"||e.type.toUpperCase()=="CHECKBOX")) {
			if(i!=0&&e.name==prev.name) continue;
			if(!isCheckedRadio(form,e)) {
				alert(e.title+"은(는) 1개이상 선택하여야 합니다.");
				e.focus();
				return false;
			}
		}else if(tagName=="SELECT") {
			if(!isFieldSelected(e)) return false;
		}
		prev = e;
	}

	return true;

}

function validTextField(field) {

	if("true"==field.required && field.value=="") {
		alert(field.title+"을(를) 입력하여야 합니다.");
		field.focus();
		return false;
	}else if(field.min&&countTextLength(field.value)>parseInt(field.min)) {
		alert(field.title+"은(는) 한글기준 "+field.min+"이상입니다.");
		field.focus();
		return false;
	}else if(field.max&&countTextLength(field.value)>parseInt(field.max)) {
		alert(field.title+"은(는) 한글기준 "+field.max+"이하입니다.");
		field.focus();
		return false;
	}

	return true;
}

function countTextLength(text) {
	var memocount = 0;
	for(var k=0;k<text.length;k++){
		var temp = text.charAt(k);
		if(escape(temp).length > 4)
			memocount += 2;
		else
			memocount++;
	}
	return memocount/2;
}

function isCheckedRadio(form,field) {

	var vals = form.all[field.name];
	if(!vals.length) {
		if("true"!=vals.required||vals.checked) return true;
		else return false;
	}

	if("true"!=vals[0].required) return true;

	for(var i=0;i<vals.length;i++) {
		if(vals[i].checked) return true;
	}

	return false;
}

function isFieldSelected(field) {
	if("true"==field.required&&field[field.selectedIndex].value=="") {
		alert(field.title+"을(를) 선택하여야 합니다.");
		field.focus();
		return false;
	}

	return true;
}

function initSelect(select,value) {
	var len = select.length;
	for(i=0;i<len;i++)
		if(select[i].value==value) select.selectedIndex = i;
}

function initRadio(radio,value) {
	var len = radio.length;
	for(i=0;i<len;i++)
		if(radio[i].value==value) radio[i].checked = true;
}

function initChcekbox(checkbox,arr,txtField) {
	var len = checkbox.length;
	for(var j=0;j<arr.length;j++) {
	  var has = false;
	  var text = arr[j];
	  if(text&&text!="") text = text.replace(" ","");
	  for(var i=0;i<len;i++) {
		  if(checkbox[i].value==text) {checkbox[i].checked = true;has = true;}
      }
      if(txtField&&!has) {txtField.value=text;checkbox[len-1].checked = true;}
	}
}

var emp_win;
function searchUser(fieldId,fieldName) {
	   var win_weight=400;
	   var win_height=480;
	   if(emp_win) emp_win.close();
	   emp_win = window.open(context+'/approval/process/searchUser.do?fieldId='+fieldId+'&fieldName='+fieldName,'win_emp','left='+(screen.width-win_weight)/2+',top='+(screen.height-win_height)/2+',width='+win_weight+',height='+win_height+',toolbar=no,menubar=no,status=no,scrollbars=yes,resizable=yes');
}
function searchApvUser(fieldId) {
	   var win_weight=400;
	   var win_height=480;
	   if(emp_win) emp_win.close();
	   emp_win = window.open(context+'/approval/process/searchApvUser.do?fieldId='+fieldId,'win_emp','left='+(screen.width-win_weight)/2+',top='+(screen.height-win_height)/2+',width='+win_weight+',height='+win_height+',toolbar=no,menubar=no,status=no,scrollbars=yes,resizable=yes');
}


function reject(form) {
	if(confirm('정말로 반려하시겠습니까?')) {
		form.action=context+"/approval/process/reject.do";
		form.submit();
	}
}

function approve(form) {
	if(confirm('정말로 승인하시겠습니까?')) {
		form.action=context+"/approval/process/approve.do";
		form.submit();
	}
}

//
//getPageScroll()
//Returns array with x,y page scroll values.
//Core code from - quirksmode.org
//
function getPageScroll(){

	var yScroll;

	if (self.pageYOffset) {
		yScroll = self.pageYOffset;
	} else if (document.documentElement && document.documentElement.scrollTop){	 // Explorer 6 Strict
		yScroll = document.documentElement.scrollTop;
	} else if (document.body) {// all other Explorers
		yScroll = document.body.scrollTop;
	}

	arrayPageScroll = new Array('',yScroll)
	return arrayPageScroll;
}



//
//getPageSize()
//Returns array with page width, height and window width, height
//Core code from - quirksmode.org
//Edit for Firefox by pHaez
//
function getPageSize(){

	var xScroll, yScroll;

	if (window.innerHeight && window.scrollMaxY) {
		xScroll = document.body.scrollWidth;
		yScroll = window.innerHeight + window.scrollMaxY;
	} else if (document.body.scrollHeight > document.body.offsetHeight){ // all but Explorer Mac
		xScroll = document.body.scrollWidth;
		yScroll = document.body.scrollHeight;
	} else { // Explorer Mac...would also work in Explorer 6 Strict, Mozilla and Safari
		xScroll = document.body.offsetWidth;
		yScroll = document.body.offsetHeight;
	}

	var windowWidth, windowHeight;
	if (self.innerHeight) {	// all except Explorer
		windowWidth = self.innerWidth;
		windowHeight = self.innerHeight;
	} else if (document.documentElement && document.documentElement.clientHeight) { // Explorer 6 Strict Mode
		windowWidth = document.documentElement.clientWidth;
		windowHeight = document.documentElement.clientHeight;
	} else if (document.body) { // other Explorers
		windowWidth = document.body.clientWidth;
		windowHeight = document.body.clientHeight;
	}

	// for small pages with total height less then height of the viewport
	if(yScroll < windowHeight){
		pageHeight = windowHeight;
	} else {
		pageHeight = yScroll;
	}

	// for small pages with total width less then width of the viewport
	if(xScroll < windowWidth){
		pageWidth = windowWidth;
	} else {
		pageWidth = xScroll;
	}


	arrayPageSize = new Array(pageWidth,pageHeight,windowWidth,windowHeight)
	return arrayPageSize;
}

function serializeForm(form) {
	var arr = form.elements;
	var params = "";
  for(i=0;i<arr.length;i++) {
    if(i!=0) params += "&";
    params += arr[i].name+"="+encodeURIComponent(arr[i].value);
  }
  return params;
}


/**
* 영문자만 입력받도록 체크하는 함수
*/
function isAlpha(param, title){
	if(param.length == 0){
		return false;
	}

	if(param.match(/[a-zA-Z]+/g)!= param){
		window.alert('영문자만 입력가능합니다.');
		return false;
	}
	return true;
}

/**
* 영문과 숫자만 입력받도록 체크하는 함수
*/
function isAlphaDigit(param, title){
	if(param.length == 0){
		return false;
	}

	if(param.match(/[a-zA-Z0-9]+/g)!= param){
		window.alert('영문자와 숫자만 입력가능합니다.');
		return false;
	}
	return true;
}

/**
* 숫자만 입력받도록 체크하는 함수
*/
function isDigit(param, title){
	if(param.length == 0){
		return true;
	}

	if(param.match(/[0-9.]+/g)!= param){
		return false;
	}
	return true;
}

function checkNumField(field) {
	var param = field.value;
	if(!isDigit(param)) {
		alert(field.title+"은 숫자만 가능합니다.");
		field.value='';
	}
}

var notNumRgx = /\D/g; //숫자가 아닌 것
var commaRgx = /(\d+)(\d{3})/;
function getNumber(obj){
	var numberValue;
	var objValue;
	objValue = obj.val();
	numberValue = objValue.replace(notNumRgx, "");
	objValue = Number(numberValue).toLocaleString('en');
	obj.val(objValue);
	isChange = true;
}

var navForm;
function goPage(num,args) {

	if(!navForm&&document.forms.length>0) {
		navForm = document.forms[0];
	} else if(document.forms.length==0) {
		navForm = document.createElement("form");
		document.body.appendChild(navForm);
	}

	var input = navForm.pageNo;
	if(!input) {
	     var input = document.createElement("input");
	     input.name = "pageNo";
	     input.type = "hidden";
	     navForm.appendChild(input);
	}
    input.value = num;

	for (var key in args){
		var param = eval("navForm."+key);
		if(!param) {
			param = document.createElement("input");
			param.name = key;
			param.type = "hidden";
		    navForm.appendChild(param);
		}
		param.value = args[key];
	}

    navForm.method="get";

	navForm.submit();
}

function getCookie( name )
{
	var nameOfCookie = name + "=";
	var x = 0;
	while ( x <= document.cookie.length )
	{
		var y = (x+nameOfCookie.length);
		if (document.cookie.substring( x, y ) == nameOfCookie ) {
			if ((endOfCookie=document.cookie.indexOf( ";", y )) == -1 )
				endOfCookie = document.cookie.length;
			return unescape( document.cookie.substring( y, endOfCookie ) );
		}
		x = document.cookie.indexOf( " ", x ) + 1;
		if ( x == 0 )
		break;
	}
	return "";
}

function setCookie( name, value, expiredays )
{
	var todayDate = new Date();
	var cookieVal = name + "=" + escape( value ) + "; path=/;";
	if(expiredays) {
		todayDate.setDate( todayDate.getDate() + expiredays );
		cookieVal += todayDate.toGMTString() + ";";
	}

	document.cookie = cookieVal;
}
function f_openEdu(cid,width,height)
{
	if(!width) width = 860;
	if(!height) height=660;

	height = height+50;
	var popUp = window.open(context+"/edu/contents/detail.do?cid="+cid,"","width="+width+",height="+height);
	popUp.focus();

}

function onMouseOver(obj){
	obj.style.backgroundColor="#e5f0f8";
}

/* onmouseout시에 스타일 제거 */
function outMouseOut(obj){
	obj.style.backgroundColor="#FFFFFF";
}
/* 현황관리 차트 */
function changeChartData(form) {
	form.submit();
}
function stageView02(id, num){
	for (i=1;i<num;i++){
			var obj = document.getElementById("stage00" + i);
			var menuObj = document.getElementById("stageMenu0" + i);
			if(i == id){
					obj.style.display = "block";
			}else{
					obj.style.display = "none";

			}
	}
}
function stageMenu02(id,imgObj){
	var obj = document.getElementById("stage0" + id);
	if(obj.style.display == "block"){
			imgObj.style.filter = "none";
	}else{

	}
}
function winMydesk(contextPath) {
	   var win_width=750;
	   var win_height=600;
	   emp_win = window.open(contextPath+'/main/mydesk.do','win_emp','left='+(screen.width-win_width)/2+',top='+(screen.height-win_height)/2+',width='+win_width+',height='+win_height+',toolbar=no,menubar=no,status=no,scrollbars=yes,resizable=yes');
}


function createOverlay(topHtml) {

	if(!document.getElementById('__div_overlay')) {
		var objBody = document.getElementsByTagName("body").item(0);

		// create overlay div and hardcode some functional styles (aesthetic styles are in CSS file)
		var objOverlay = document.createElement("div");
		objOverlay.setAttribute('id','__div_overlay');
		objOverlay.style.display = 'none';
		objOverlay.style.position = 'absolute';
		objOverlay.style.top = '0';
		objOverlay.style.left = '0';
		objOverlay.style.zIndex = '90';
	 	objOverlay.style.width = '100%';
	 	objOverlay.innerHTML = "<iframe width='100%' height='100%'></iframe>";
		objBody.insertBefore(objOverlay, objBody.firstChild);
	}

	if(!document.getElementById('__div_progress')) {
		var objProgress = document.createElement("div");
		objProgress.setAttribute('id','__div_progress');
		objProgress.style.position = 'absolute';
		objProgress.style.zIndex = '150';
		objProgress.style.display = 'none';
		document.body.appendChild(objProgress);
	}
	if(!topHtml) topHtml = "<img src='"+CONTEXT+"/images/loading.gif'>";
	document.getElementById('__div_progress').innerHTML = topHtml;
}

function showOverlay(topHtml) {
   createOverlay(topHtml);
   var objOverlay = document.getElementById('__div_overlay');
   var objProgress = document.getElementById('__div_progress');

	var arrayPageSize = getPageSize();
	var arrayPageScroll = getPageScroll();

    var es = $(document.body).childElements();
    var height = 0;
    for(var i=0;i<es.length;i++) {
    	height += es[i].offsetHeight;
    }

	// set height of Overlay to take up whole page and show
	objOverlay.style.height = (height + 'px');
	objOverlay.style.display = 'block';
	objOverlay.setStyle({backgroundColor:'#666666'});
	if(Prototype.Browser.Gecko) objOverlay.setOpacity(0.3);
	else objOverlay.setOpacity(0.5);

	if (objProgress) {
		objProgress.style.display = 'block';
		objProgress.style.top = (arrayPageScroll[1] + ((arrayPageSize[3] - 35 - objProgress.offsetHeight) / 2) + 'px');
		objProgress.style.left = (((arrayPageSize[0] - 20 - objProgress.offsetWidth) / 2) + 'px');
	}
}

function hideOverlay() {

	document.getElementById('__div_overlay').style.display = "none";
	document.getElementById('__div_progress').style.display = "none";

}

function gotoPage(url) {
	showOverlay(document.getElementById("divOverlayMsg").innerHTML);
	document.location=url;
}

function viewReport(url, limit, sort,asc){

	showOverlay(document.getElementById("divOverlayMsg").innerHTML);

	var sparam="";
	if(sort) sparam = "&sort="+sort+"&asc="+asc;
	document.location = url+"&limit="+limit+sparam;

}

function dateFormat(date){
	var val = date.trim();
	var len = val.length;
	var ret;
	if(len == 4){
		ret = val.substr(0,4);
		return ret;
	}else if(len!=6&&len!=8&&len!=10&&len!=12&&len!=14&&len!=16){
		ret = '1900';
		return ret;
	}
	formatdate = "yyyy.MM.dd";
	if(formatdate.indexOf("yyyy")!=-1) formatdate = formatdate.replace("yyyy", val.substring(0,4));
	if(formatdate.indexOf("MM")!=-1) formatdate = formatdate.replace("MM", val.substring(4,6));
	if(formatdate.indexOf("dd")!=-1) formatdate = formatdate.replace("dd", val.substring(6,8));

	var last = formatdate.length;
	for(var i=formatdate.length; i > 0; i--){
		var c = formatdate.charAt(i-1);
		if(c >= '0' && c <= '9') break;
		last = i-1;
	}

	if(formatdate.length != last) ret = formatdate.substr(0, last);
	else ret = formatdate;

	return ret;
}

function getFileSize(filesize){
	var DATASIZE_KB = 1024;
	var DATASIZE_MB = 1024*1024;
	var DATASIZE_GB = 1024*1024*1024;
	var DATASIZE_TB = 1024*1024*1024*1024;
	var datasize = "";
	if(filesize  < DATASIZE_KB){
		datasize = filesize;
	}else if(filesize >= DATASIZE_KB && filesize < DATASIZE_MB){
		datasize = Math.round(filesize / DATASIZE_KB) + " KB";
	}else if(filesize >= DATASIZE_MB && filesize < DATASIZE_GB){
		datasize = Math.round(filesize / DATASIZE_MB) + " MB";
	}else if(filesize >= DATASIZE_GB && filesize < DATASIZE_TB){
		datasize = Math.round(filesize / DATASIZE_GB) + " GB";
	}else if(filesize >= DATASIZE_TB){
		datasize = Math.round(filesize / DATASIZE_TB) + " TB";
	}
	return datasize;
}

jQuery.browser={};(function(){jQuery.browser.msie=false;
jQuery.browser.version=0;if(navigator.userAgent.match(/MSIE ([0-9]+)\./)){
jQuery.browser.msie=true;jQuery.browser.version=RegExp.$1;}})();
if(!!navigator.userAgent.match(/.*Trident.*rv\:[1-9][0-9]\./)){
	var version = navigator.userAgent.replace(/.*Trident.*rv\:([1-9][0-9])\..*/, '$1');
	jQuery.browser.version = version;
	jQuery.browser.msie = true;
}

function StringtoXML(text, window){
    //console.log(text);
    //console.log(window.ActiveXObject);
	if (window.ActiveXObject){
      var doc=new ActiveXObject('Microsoft.XMLDOM');
      doc.async='false';
      doc.loadXML(text);
    } else {
      var parser=new DOMParser();
      var doc=parser.parseFromString(text,'text/xml');
    }
    return doc;
}
function validateRange(){

	 var isRst = true;
	 var fy = parseInt($('#fromYear').val());
	 var ty = parseInt($('#toYear').val());

	 if(fy > ty){
		 isRst = false;
	 }
	 return isRst;
}
function errorMsg(obj){
	 if($(obj).attr('id') == 'fromYear'){
		 alert("Start year of year range must be less than end year!!");
	 }else{
		 alert("End year of year range must be greater than start year!!");
	 }
}
/**
 * Clears the selected form elements.
 */
$.fn.clearFields = $.fn.clearInputs = function(includeHidden) {
    var re = /^(?:color|date|datetime|email|month|number|password|range|search|tel|text|time|url|week)$/i; // 'hidden' is not in this list
    return this.each(function() {
        var t = this.type, tag = this.tagName.toLowerCase();
        if (re.test(t) || tag == 'textarea') {
            this.value = '';
        }
        else if (t == 'checkbox' || t == 'radio') {
            this.checked = false;
        }
        else if (tag == 'select') {
            this.selectedIndex = -1;
        }
        else if (t == "file") {
            if (/MSIE/.test(navigator.userAgent)) {
                $(this).replaceWith($(this).clone(true));
            } else {
                $(this).val('');
            }
        }
        else if (includeHidden) {
            // includeHidden can be the value true, or it can be a selector string
            // indicating a special test; for example:
            //  $('#myForm').clearForm('.special:hidden')
            // the above would clean hidden inputs that have the class of 'special'
            if ( (includeHidden === true && /hidden/.test(t)) ||
                 (typeof includeHidden == 'string' && $(this).is(includeHidden)) )
                this.value = '';
        }
    });
};


function commaNum(double) {
	var parts = "";
	if(double.toString().indexOf(".") != -1)
	{
		parts = (double*1).toFixed(3).toString().split(".");
	}
	else
	{
		parts = double.toString().split(".");
	}
    parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    return parts.join(".");
  }

//천 단위 콤마 빼기
function NumberWithoutComma(double) {
    return double.replace(/[,]/g, "");
}

function getFormData($form){
    var unindexed_array = $form.serializeArray();
    var indexed_array = {};

    $.map(unindexed_array, function(n, i){
        indexed_array[n['name']] = n['value'];
    });

    return indexed_array;
}

function comAppendQueryString(query,name,value) {
	return query+(query.indexOf("?")>=0?"&":"?")+name+"="+value;
}

function getMouseClickPosition(e) {
	var posx = 0;
	var posy = 0;
	if (!e || e== null) var e = window.event;
	posx = e.clientX + $(document).scrollLeft();
	posy = e.clientY + $(document).scrollTop();
	return [posx, posy];
}

function hideAppr(id, contextPath){
	var alt = $j('#'+id).prop('alt');
	if(alt == 'block'){
		$j('#'+id).prop('src',contextPath+"/images/ENG/button/btn_more.png");
		$j('#apprDiv').css('display','none');
		$j('#'+id).prop('alt','none');
	}else {
		$j('#'+id).prop('src',contextPath+"/images/ENG/button/btn_nomore.png");
		$j('#apprDiv').css('display','block');
		$j('#'+id).prop('alt','block');
	}
}

function getText(text_code)
{
	if (language=='ko') {
		if (text_code=='tit_res_sear') {return '연구자 검색';}
		else if (text_code=='tit_res_grid') {return '사번,영문명(Abbr),영문명(Full),한글명,소속,직급,PosiCd';}
		else if (text_code=='tit_area_sear') {return '연구학문분야 검색';}
		else if (text_code=='tit_area_grid') {return '분야';}
		else if (text_code=='tit_area_alert') {return '입력한내용이 없습니다.';}
		else if (text_code=='tit_agc_sear') {return '대학/기관 검색';}
		else if (text_code=='tit_agc_grid') {return '대학/기관명';}
		else if (text_code=='tit_fund_sear') {return '관련연구과제';}
		else if (text_code=='tit_fund_sub') {return '과제정보:';}

		else if (text_code=='tit_fund_gubun_person') {return '개인';}
		else if (text_code=='tit_fund_gubun_all') {return '전체';}
		else if (text_code=='tit_fund_period') {return '연구기간:';}

		else if (text_code=='tit_fund_grid') {return '관리번호,연구기간,과제명,기관과제번호,과제번호';}
		else if (text_code=='sitter_tit') {return '대리입력자 검색';}
		else if (text_code=='sitter_grid') {return '사번,이름,학과명,부서명,이메일';}
	}else {
		if (text_code=='tit_res_sear') {return 'Researcher Search';}
		else if (text_code=='tit_res_grid') {return 'ID,Eng(Abbr),Eng(Full),Kor,Affiliation,Position,PosiCd';}
		else if (text_code=='tit_area_sear') {return 'Research Area Search';}
		else if (text_code=='tit_area_grid') {return 'Research Area';}
		else if (text_code=='tit_agc_sear') {return 'Affiliation Search';}
		else if (text_code=='tit_agc_grid') {return 'Affiliation';}
		else if (text_code=='tit_area_alert') {return '입력한내용이 없습니다.';}
		else if (text_code=='tit_fund_sear') {return 'Search Related Research Project ';}
		else if (text_code=='tit_fund_sub') {return 'Pjt. Info.:';}

		else if (text_code=='tit_fund_gubun_person') {return 'My Pjt.';}
		else if (text_code=='tit_fund_gubun_all') {return 'All';}
		else if (text_code=='tit_fund_period') {return 'Period:';}

		else if (text_code=='tit_fund_grid') {return 'Item No.,Period,Project Name,Project No.,Project No.(KAIST)';}
		else if (text_code=='sitter_tit') {return 'User search for assistant reqistration';}
		else if (text_code=='sitter_grid') {return 'Emp No,Stu No,Name,Dept,Tel,Email';}
	}
}

function openPop(url, option, popName ,cookieName){
	 if(getCookie(cookieName) != "done"){
		 window.open(url,popName, option);
	 }
}
var wins, w1, winGrid, dhxWins, w2, dhxAccord, flag, dhxLayout, elementIndex;

// 사용자 검색
function findUser(obj,e){

	var $tr = null;

	if($(obj).prop('type') == "text")
	{
		$tr = $(obj).parent().parent();
	}
	else
	{
		$tr = $(obj).parent().parent().parent().parent();
	}
	var index = $tr.find('input[name="prtcpntIndex"]').eq(0).val();

    var wWidth = 600;
    var wHeight = 350;
    pageX = $(window).width() /2 - wWidth /2 + $(window).scrollLeft();
    pageY = $(window).height() /2 - wHeight /2 + $(window).scrollTop();

	if(wins != null && wins.unload != null)
	{
		wins.unload();
		wins = null;
	}

	wins = new dhtmlXWindows({
		viewport : {objec : 'windVP'},
		wins : [ {id : 'w1', left : pageX, top : pageY, width: wWidth, height: wHeight, text: getText("tit_res_sear"), resize : false} ]
	});
	wins.window('w1').setModal(true);

	elementIndex = index;
	var idValue = '';

	if (idValue == "" && $(obj).prop('type') == "text")
	{
		idValue = $(obj).val();
	}
	else
	{
		idValue = $('#prtcpntId_'+elementIndex).val();
	}

	if (idValue == "") idValue = $('#prtcpntId_'+elementIndex).val();
	if (idValue == "") idValue = $('#prtcpntNm_'+elementIndex).val();
	if (idValue == "") idValue = $('#prtcpntFullNm_'+elementIndex).val();

	idType = "USER_ID";

	dhxLayout = wins.window('w1').attachLayout('2E');
	dhxLayout.cells("a").hideHeader();
	dhxLayout.cells("b").hideHeader();
    dhxLayout.cells("a").attachURL(contextpath+"/"+preUrl+"/i18n/winhelp/help_findUser.do");
	dhxLayout.cells("a").setHeight(55);

	winToolbar = dhxLayout.cells("b").attachToolbar();
	winToolbar.setIconsPath(contextpath+"/images/common/icon/");
	winToolbar.addInput("keyword", 0, idValue, 515);
	winToolbar.addButton("search", 1, "", "tbl_search_icon.png", "tbl_search_icon.png");
	winToolbar.attachEvent("onClick", function(id) {
		if (id == "search"){
			winGrid.clearAndLoad(contextpath+'/user/findAuthorListByKeyword.do?keyword=' + encodeURIComponent(winToolbar.getValue('keyword')));
		}
	});
	winToolbar.attachEvent("onEnter", function(id,value) {
		if (value == "")
		{
			dhtmlx.alert({type:"alert-warning",text:"검색어를 입력하세요.",callback:function(){}});
		}
		else
		{
			winGrid.clearAndLoad(contextpath+ '/user/findAuthorListByKeyword.do?keyword=' + encodeURIComponent(winToolbar.getValue('keyword')));
		}
	});

	winGrid = dhxLayout.cells("b").attachGrid();
	winGrid.setImagePath(contextpath+'/js/codebase/imgs/');
	winGrid.setHeader(getText("tit_res_grid"),null,grid_head_center_bold);
	//사번,영문명(Abbr),영문명(Full),한글명,소속,직급,PosiCd
	winGrid.setColumnIds("userId,engAbbr,engFull,korNm,deptKor,posiNm,posiCd");
	winGrid.setInitWidths("60,90,90,90,*,100,1");
	winGrid.setColAlign("center,left,left,center,left,left,center");
	winGrid.setColTypes("ro,ro,ro,ro,ro,ro,ro");
	winGrid.setColSorting("str,str,str,str,str,str,str");
	winGrid.enableColSpan(true);
	winGrid.setColumnHidden(winGrid.getColIndexById("posiCd"),true);
	winGrid.attachEvent("onXLS", function() {
		wins.window('w1').progressOn();
	});
	winGrid.attachEvent("onXLE", function() {
		wins.window('w1').progressOff();
	});
	winGrid.attachEvent('onRowSelect', doOnRowSelectedUser);
	winGrid.init();
	$('.dhxtoolbar_input').focus();
	if (winToolbar.getValue('keyword') != "") winGrid.loadXML(contextpath+'/user/findAuthorListByKeyword.do?keyword=' + encodeURIComponent(winToolbar.getValue('keyword')));
}

function doOnRowSelectedUser(id, index) {

	var userId =  winGrid.cells(id, winGrid.getColIndexById("userId")).getValue();
    var engAbbr = winGrid.cells(id, winGrid.getColIndexById("engAbbr")).getValue();
    var engFull = winGrid.cells(id, winGrid.getColIndexById("engFull")).getValue();
    var korNm = winGrid.cells(id, winGrid.getColIndexById("korNm")).getValue();
    var deptKor = winGrid.cells(id, winGrid.getColIndexById("deptKor")).getValue();
    var posiCd = winGrid.cells(id, winGrid.getColIndexById("posiCd")).getValue();

    if(index < 4)
    {
        if(index == 0)
            $("#prtcpntId_"+elementIndex).val(userId);
        else if (index == 1 || index == 2)
        {
			$("#prtcpntId_"+elementIndex).val(userId);
			$("#prtcpntNm_"+elementIndex).val(engAbbr);

            if($("#prtcpntFullNm_"+elementIndex).length != 0)
                $("#prtcpntFullNm_"+elementIndex).val(engFull);
            else
                $("#prtcpntNm_"+elementIndex).val(engFull);
        }
        else if (index == 3)
        {
			$("#prtcpntId_"+elementIndex).val(userId);
            $("#prtcpntNm_"+elementIndex).val(korNm);
            if($("#prtcpntFullNm_"+elementIndex).length != 0)
                $("#prtcpntFullNm_"+elementIndex).val(korNm);
        }
        if($("#posiCd_"+elementIndex))
        	$("#posiCd_"+elementIndex).val(posiCd);

        if($("#blngAgcNm_"+elementIndex).val() == null || $("#blngAgcNm_"+elementIndex).val() == '')
		{
			$("#blngAgcCd_"+elementIndex).val(instcode);
			$("#blngAgcNm_"+elementIndex).val(instname);
		}
        $("#prtcpntIndex_"+elementIndex).parent().parent().find('.dispDept').eq(0).text(deptKor);
        isChange = true;
        wins.window('w1').close();
    }
    else
    {
        dhtmlx.alert({type:"alert-warning",text:"영문논문은 영문명, 한글논문은 한글명, 사번만 입력시 사번을 선택 입력하십시오.",callback:function(){}})
        winGrid.clearSelection();
    }
	/*
	if (index == 1 || index == 2) {
		$("#prtcpntId_"+elementIndex).val(userData[0]);
		if($("#prtcpntFullNm_"+elementIndex) != null && $("#prtcpntFullNm_"+elementIndex).attr("type") == "text") {
            $("#prtcpntNm_"+elementIndex).val(userData[3]);
			$("#prtcpntFullNm_"+elementIndex).val(userData[2]);
        } else {
			if (index == 1) $("#prtcpntNm_"+elementIndex).val(userData[3]);
			else if (index == 2) $("#prtcpntNm_"+elementIndex).val(userData[2]);
        }
		$("#blngAgcCd_"+elementIndex).val(instcode);
		$("#blngAgcNm_"+elementIndex).val(instname);
		$("#prtcpntIndex_"+elementIndex).parent().parent().find('.dispDept').eq(0).text(userData[4])
		wins.window('w1').close();
		isChange = true;
	} else if (index == 3) {
		$("#prtcpntId_"+elementIndex).val(userData[0]);
		$("#prtcpntNm_"+elementIndex).val(userData[1]);
		if($("#prtcpntFullNm_"+elementIndex) != null)
		{
			$("#prtcpntFullNm_"+elementIndex).val(userData[1]);
		}
		$("#blngAgcCd_"+elementIndex).val(instcode);
		$("#blngAgcNm_"+elementIndex).val(instname);
		$("#prtcpntIndex_"+elementIndex).parent().parent().find('.dispDept').eq(0).text(userData[4])
		isChange = true;
		wins.window('w1').close();
	} else {
		dhtmlx.alert({type:"alert-warning",text:"영문논문은 영문명, 한글논문은 한글명을 선택 입력하십시오.",callback:function(){}})
		winGrid.clearSelection();
	}
	*/
}

//기관 검색
function getOrgCodeWin(obj,e) {

	var $tr = null;

	if($(obj).prop('type') == "text")
	{
		$tr = $(obj).parent().parent().parent();
	}
	else
	{
		$tr = $(obj).parent().parent().parent().parent();
	}

	var index = $tr.find('input[name="prtcpntIndex"]').eq(0).val();


	var wWidth = 600;
	var wHeight = 350;

	pageX = $(window).width() /2 - wWidth /2 + $(window).scrollLeft();
	pageY = $(window).height() /2 - wHeight /2 + $(window).scrollTop();

	if(wins != null && wins.unload != null)
	{
		wins.unload();
		wins = null;
	}

	wins = new dhtmlXWindows({
		viewport : {objec : 'windVP'},
		wins : [ {id : 'w1', left : pageX, top : pageY, width: wWidth, height: wHeight, text: getText("tit_agc_sear"), resize : false} ]
	});
	wins.window('w1').setModal(true);

	elementIndex = index;

	var keywordStr = "";

	if (keywordStr == "" && $(obj).prop('type') == "text")
	{
		keywordStr = $(obj).val();
	}
	else
	{
		keywordStr = $('#blngAgcNm_'+elementIndex).val();
	}

	if(keywordStr == "" || keywordStr == undefined) keywordStr = instname;

	dhxLayout = wins.window('w1').attachLayout('2E');
	dhxLayout.cells("a").hideHeader();
	dhxLayout.cells("b").hideHeader();
	dhxLayout.cells("a").attachURL(contextpath+"/"+preUrl+"/i18n/winhelp/help_findOrganization.do");
	dhxLayout.cells("a").setHeight(55);

    winToolbar = dhxLayout.cells("b").attachToolbar();
    winToolbar.setIconsPath(contextpath+"/images/common/icon/");
    winToolbar.addInput("keyword", 0, keywordStr, 515);
    winToolbar.addButton("search", 1, "", "tbl_search_icon.png", "tbl_search_icon.png");
    winToolbar.attachEvent("onClick", function(id) {
    	if (id == "search")
    	{
    		winGrid.clearAndLoad(contextpath+'/code/findOrgCodeList.do?keyword=' + encodeURIComponent(winToolbar.getValue('keyword')));
    	}
    });
    winToolbar.attachEvent("onEnter", function(id,value) {
    	if(value == "")
    	{
    		dhtmlx.alert({type:"alert-warning",text:getText('tit_area_alert'),callback:function(){}});
    	}
    	else
    	{
    		winGrid.clearAndLoad(contextpath+'/code/findOrgCodeList.do?keyword=' + encodeURIComponent(winToolbar.getValue('keyword')));
    	}
    });

    winGrid = dhxLayout.cells("b").attachGrid();
	winGrid.setImagePath(contextpath+'/js/codebase/imgs/');
	winGrid.setHeader(getText('tit_agc_grid'),null,grid_head_center_bold);
	winGrid.setColAlign('left');
	winGrid.setColTypes('ro');
	winGrid.attachEvent("onXLS", function() {
		wins.window('w1').progressOn();
	});
	winGrid.attachEvent("onXLE", function() {
		wins.window('w1').progressOff();
	});
	winGrid.attachEvent('onRowSelect', function(id){
		var code = id.split('_');
		var codeKey = code[0];
		var codeValue = code[1];
		if(index != undefined){
			$('#blngAgcCd_'+elementIndex).val(codeKey);
			$('#blngAgcNm_'+elementIndex).val(codeValue);
			// 참여자의 기관색상 변경을 위해 추가
			$('#blngAgcNm_'+elementIndex).css('background','#fff');
		}
		else
		{
			$('#'+obj+'Key').val(codeKey);
			$('#'+obj+'Value').val(codeValue);
		}
		isChange = true;
		wins.window('w1').close();
	});
	winGrid.init();
	$('.dhxtoolbar_input').focus();
	winGrid.loadXML(contextpath+'/code/findOrgCodeList.do?keyword=' + encodeURIComponent(winToolbar.getValue('keyword')));
}

function testArea(id,index,cont,e) {

    var wWidth = 450;
    var wHeight = 350;
    pageX = $(window).width() /2 - wWidth /2 + $(window).scrollLeft();
    pageY = $(window).height() /2 - wHeight /2 + $(window).scrollTop();

	if(wins != null && wins.unload != null)
	{
		wins.unload();
		wins = null;
	}

	wins = new dhtmlXWindows({
		viewport : {objec : 'windVP'},
		wins : [ {id : 'w1', left : pageX, top : pageY, width: wWidth, height: wHeight, text: getText("tit_area_sear"), resize : false} ]
	});
	wins.window('w1').setModal(true);

	inputId = id;
	dhxLayout = wins.window('w1').attachLayout('2E');
	dhxLayout.cells("a").hideHeader();
	dhxLayout.cells("b").hideHeader();
	dhxLayout.cells("a").attachURL(contextpath+"/"+preUrl+"/i18n/winhelp/help_findRsrchStdyArea.do");
	dhxLayout.cells("a").setHeight(70);

    winToolbar = dhxLayout.cells("b").attachToolbar();
	winToolbar.setIconsPath(contextpath+"/images/common/icon/");
    winToolbar.addInput("keyword", 0, cont, 365);
    winToolbar.addButton("search", 1, "", "tbl_search_icon.png", "tbl_search_icon.png");
	winToolbar.attachEvent("onClick", function(id) {
		if (id == "search")
		{
			if(winToolbar.getValue('keyword') != '')
			{
				winGrid.clearAndLoad(contextpath+'/code/findResAreaByKeyword.do?keyword=' + encodeURIComponent(winToolbar.getValue('keyword')));
			}
			else
			{
				dhtmlx.alert({type:"alert-warning",text:getText('tit_area_alert'),callback:function(){}});
			}
		}
	});
	winToolbar.attachEvent("onEnter", function(id,value) {
		if(value == "")
		{
			dhtmlx.alert({type:"alert-warning",text:getText('tit_area_alert'),callback:function(){}});
		}
		else
		{
			winGrid.clearAndLoad(contextpath+'/code/findResAreaByKeyword.do?keyword=' + encodeURIComponent(winToolbar.getValue('keyword')));
		}
    });

	winGrid = dhxLayout.cells("b").attachGrid();
	winGrid.setImagePath(contextpath+'/js/codebase/imgs/');
	winGrid.setHeader(getText('tit_area_grid'),null,grid_head_center_bold);
	winGrid.setColAlign('left');
	winGrid.setColTypes('ro');
	winGrid.setColSorting('str');
	winGrid.attachEvent("onXLS", function() {
		wins.window('w1').progressOn();
	});
	winGrid.attachEvent("onXLE", function() {
		wins.window('w1').progressOff();
	});
	winGrid.attachEvent('onRowSelect', doOnRowSelectedCode);
	winGrid.init();
	$('.dhxtoolbar_input').focus();
	if(cont != null && cont != '' )
		winGrid.loadXML(contextpath+'/code/findResAreaByKeyword.do?keyword=' + encodeURIComponent(winToolbar.getValue('keyword'))+"&flag=1");
}

function doOnRowSelectedCode(id) {
	var code = id.split('_');
	var codeKey = code[0];
	var codeValue = code[1];
	$('#'+inputId+'Key').val(codeKey);
	$('#'+inputId+'Value').val(codeValue);
	// 참여자의 기관색상 변경을 위해 추가
	$('#'+inputId+'Value').css('background','#fff');
	isChange = true;
	wins.window('w1').close();
}


//학술연구분야분류 검색
var dhxResTree;
var dhxResTreeXml;
function findResArea(inputId,index,cont,e){
  var wWidth = 650;
  var wHeight = 550;
  pageX = $(window).width() /2 - wWidth /2 + $(window).scrollLeft();
  pageY = $(window).height() /2 - wHeight /2 + $(window).scrollTop();

	if(wins != null && wins.unload != null)
	{
		wins.unload();
		wins = null;
	}

	wins = new dhtmlXWindows({
		viewport : {objec : 'windVP'},
		wins : [ {id : 'w1', left : pageX, top : pageY, width: wWidth, height: wHeight, text: getText("tit_area_sear"), resize : false} ]
	});
	wins.window('w1').setModal(true);

	//inputId = id;
	var cdValue = $('#'+inputId+'Key').val();


	dhxLayout = wins.window('w1').attachLayout('2E');
	dhxLayout.cells("a").hideHeader();
	dhxLayout.cells("b").hideHeader();
	dhxLayout.cells("a").attachURL(contextpath+"/"+preUrl+ "/i18n/winhelp/help_findRsrchStdyArea.do");
	dhxLayout.cells("a").setHeight(70);

  	winToolbar = dhxLayout.cells("b").attachToolbar();
	winToolbar.setIconsPath(contextpath+"/images/common/icon/");
  	winToolbar.addInput("keyword", 0, cont, 472);
  	winToolbar.addButton("search", 1, "", "tbl_search_icon.png", "tbl_search_icon.png");
  	winToolbar.addButton("next", 2, "Next", "", "");
  	winToolbar.addButton("prev", 3, "Prev", "", "");
	winToolbar.attachEvent("onClick", function(id) {
		if (id == "search")
		{

			if(winToolbar.getValue('keyword') != '')
			{
				//winGrid.clearAndLoad(contextpath+'/code/findResAreaByKeyword.do?keyword=' + encodeURIComponent(winToolbar.getValue('keyword')));
				//dhxResTree.findItem(winToolbar.getValue('keyword'), 1, 1);
				findExtactResArea(winToolbar.getValue('keyword'));
			}
			else
			{
				dhtmlx.alert({type:"alert-warning",text:getText('tit_area_alert'),callback:function(){}});
			}
		}
		else if(id == "next")
		{
			dhxResTree.findItem(winToolbar.getValue('keyword'));
		}
		else if(id == "prev")
		{
			dhxResTree.findItem(winToolbar.getValue('keyword'), 1);
		}
	});
	winToolbar.attachEvent("onEnter", function(id,value) {
		if(value == "")
		{
			dhtmlx.alert({type:"alert-warning",text:getText('tit_area_alert'),callback:function(){}});
		}
		else
		{
			//winGrid.clearAndLoad(contextpath+'/code/findResAreaByKeyword.do?keyword=' + encodeURIComponent(winToolbar.getValue('keyword')));
			//dhxResTree.findItem(winToolbar.getValue('keyword'));
			findExtactResArea(winToolbar.getValue('keyword'));
		}
  });

	dhxResTree = dhxLayout.cells("b").attachTree();
	dhxResTree.setImagePath(dhtmlximagepath+"dhxtree_terrace/");
	dhxResTree.enableTreeLines(true);
	dhxResTree.enableHighlighting(true);
	dhxResTree.attachEvent("onXLS", function(){dhxLayout.cells("b").progressOn();});
	dhxResTree.attachEvent("onXLE", function(){dhxLayout.cells("b").progressOff();});
	dhxResTree.enableKeyboardNavigation(true);
	dhxResTree.enableKeySearch(true);
    dhxResTree.enableSmartXMLParsing(true);
	//dhxResTree.setSerializationLevel(false,true);
	//dhxResTree.setOnClickHandler(function);
	dhxResTree.attachEvent("onClick", function(id){
		dhxResTree.openItem(id);
	});
	dhxResTree.attachEvent("onDblClick", function(id){
		dhxResTree.openItem(id);
		$('#'+inputId+"Key").val(id);
		$('#'+inputId+"Value").val(dhxResTree.getSelectedItemText());
		wins.window('w1').close();
		isChange = true;
	});
	//dhxResTree.enableSmartXMLParsing(true);
	dhxLayout.cells("b").progressOn();
	$.post(contextpath+'/code/findResAreaTree.do', null,null,'text').done(function(data){
		dhxResTreeXml = data;
		dhxResTree.loadXMLString(dhxResTreeXml, function(){
			if(cdValue == '')
				dhxResTree.findItem(winToolbar.getValue('keyword'));
			else
				dhxResTree.selectItem(cdValue, true, true);
				dhxResTree.focusItem(cdValue);
			dhxLayout.cells("b").progressOff();
		}, 'xml');
	});
}

function findExtactResArea(keyword){
	var isNotExtactMatched = true;
	var korReg = /^[가-힣0-1\/]+/;
	var engReg = / [\(A-Za-z0-9\)'\/ ]+/;
	var engReg2 = /[A-Za-z0-9\/]+/;

	var xmlDoc = $.parseXML(dhxResTreeXml);
	$(xmlDoc).find('item').each(function(){
		var textValue = $(this).attr('text');
		if(korReg.test(textValue))
		{
			var kortext = korReg.exec(textValue)[0];
			if(keyword == kortext.trim())
			{
				dhxResTree.selectItem($(this).attr('id'), true, true);
				dhxResTree.focusItem($(this).attr('id'));
				isNotExtactMatched = false;
				return false;
			}
		}
		if(engReg.test(textValue))
		{
			var engtext = engReg.exec(textValue)[0];
			if(engReg2.test(engtext))
			{
				var engtext2 = engReg2.exec(engtext)[0];
				if(keyword.toLowerCase() == engtext2.toLowerCase())
				{
					dhxResTree.selectItem($(this).attr('id'), true, true);
					dhxResTree.focusItem($(this).attr('id'));
					isNotExtactMatched = false;
					return false;
				}
			}
		}
	});

	if(isNotExtactMatched) dhxResTree.findItem(keyword);

}


//기관 검색
function getOrgCodeGeneralWin(keyObj, valueObj, e) {

	var wWidth = 650;
	var wHeight = 450;

	pageX = $(window).width() /2 - wWidth /2 + $(window).scrollLeft();
	pageY = $(window).height() /2 - wHeight /2 + $(window).scrollTop();

	if(wins != null && wins.unload != null)
	{
		wins.unload();
		wins = null;
	}

	wins = new dhtmlXWindows({
		viewport : {objec : 'windVP'},
		wins : [ {id : 'w1', left : pageX, top : pageY, width: wWidth, height: wHeight, text: getText("tit_agc_sear"), resize : false} ]
	});

	var keywordStr = "";
	keywordStr = valueObj.val();
	if(keywordStr == null || keywordStr == "") keywordStr = instname;

	wins.window('w1').setModal(true);
	dhxLayout = wins.window('w1').attachLayout('2E');
	dhxLayout.cells("a").hideHeader();
	dhxLayout.cells("b").hideHeader();
	dhxLayout.cells("a").attachURL(contextpath+"/"+preUrl+"/i18n/winhelp/help_findOrganization.do");
	dhxLayout.cells("a").setHeight(55);

	winToolbar = dhxLayout.cells("b").attachToolbar();
	winToolbar.setIconsPath(contextpath+"/images/common/icon/");
	winToolbar.addInput("keyword", 0, keywordStr, 565);
	winToolbar.addButton("search", 1, "", "tbl_search_icon.png", "tbl_search_icon.png");
	winToolbar.attachEvent("onClick", function(id) {
		if (id == "search")
		{
			winGrid.clearAndLoad(contextpath+'/code/findCodeOrgList.do?srchKeyword=' + encodeURIComponent(winToolbar.getValue('keyword')));
		}
	});
	winToolbar.attachEvent("onEnter", function(id,value) {
		if(value == "")
		{
			dhtmlx.alert({type:"alert-warning",text:getText('tit_area_alert'),callback:function(){}});
		}
		else
		{
			winGrid.clearAndLoad(contextpath+'/code/findCodeOrgList.do?srchKeyword=' + encodeURIComponent(winToolbar.getValue('keyword')));
		}
	});

	dhxLayout.cells("b").attachStatusBar({
		text : '<div id="grid_pagingArea"></div>',
		paging : true
	});
	winGrid = dhxLayout.cells("b").attachGrid();
	winGrid.setImagePath(dhtmlximagepath);
	winGrid.setHeader('value,'+getText('tit_agc_grid'),null,grid_head_center_bold);
	winGrid.setColumnIds("codeValue,codeDisp");
	winGrid.setInitWidths("1,*");
	winGrid.setColAlign('center,left');
	winGrid.setColTypes('ro,ro');
	winGrid.setColumnHidden(winGrid.getColIndexById("codeValue"),true);
	winGrid.attachEvent("onXLS", function() {
		wins.window('w1').progressOn();
	});
	winGrid.attachEvent("onXLE", function() {
		wins.window('w1').progressOff();
	});
	winGrid.attachEvent('onRowSelect', function(id){
		var codeKey = winGrid.cells(winGrid.getSelectedId(),winGrid.getColIndexById("codeValue")).getValue();
		var codeValue = winGrid.cells(winGrid.getSelectedId(),winGrid.getColIndexById("codeDisp")).getValue();

		keyObj.val(codeKey);
		valueObj.val(codeValue);
		isChange = true;
		wins.window('w1').close();
	});
	winGrid.enablePaging(true,100,10,"grid_pagingArea");
	winGrid.setPagingSkin("toolbar");

	winGrid.init();
	$('.dhxtoolbar_input').focus();
	winGrid.loadXML(contextpath+'/code/findCodeOrgList.do?srchKeyword=' + encodeURIComponent(winToolbar.getValue('keyword')));
}

function clearCode(keyObj, valueObj){
	keyObj.val('');
	valueObj.val('');
	isChange = true;
}

function getMouseClickPosition(e) {
	var posx = 0;
	var posy = 0;
	if (!e || e== null) var e = window.event;
	// 위치에 문제가 있어 수정 by HJ Lee
	posx = e.clientX + $(window).scrollLeft();
	posy = e.clientY + $(window).scrollTop();
	return [posx, posy];
}

function bindModalLink(){
    $('.modalLink').modal({
        trigger: '.modalLink',                                          // id or class of link or button to trigger modal
        olay:'div.overlay',                                             // id or class of overlay
        modals:'div.modal',                                           // id or class of modal
        //modals: $(this).attr('href'),                                   // id or class of modal
        animationEffect: 'fadeIn',   	                                // overlay effect | slideDown or fadeIn | default=fadeIn
        animationSpeed: 200,                                            // speed of overlay in milliseconds | default=400
        moveModalSpeed: 'slow',                                         // speed of modal movement when window is resized | slow or fast | default=false
        background: '000',           	                                // hexidecimal color code - DONT USE #
        opacity: 0.5,                                                   // opacity of modal |  0 - 1 | default = 0.8
        openOnLoad: false,                                              // open modal on page load | true or false | default=false
        docClose: true,                                                 // click document to close | true or false | default=true
        closeByEscape: false,                                            // close modal by escape key | true or false | default=true
        moveOnScroll: false,                                            // move modal when window is scrolled | true or false | default=false
        resizeWindow: true,                                             // move modal when window is resized | true or false | default=false
        video: 'http://player.vimeo.com/video/2355334?color=eb5a3d',    // enter the url of the video
        videoClass:'video',             								// class of video element(s)
        close:'.closeBtn'               								// id or class of close button
    });
}

function onSubmit(formName){
	var elements = document.forms[formName];
	for(var i=0;i<elements.length;i++) {
		var e = elements[i];
		var tagName = e.tagName.toUpperCase();
		if(tagName=="INPUT"&&e.type.toUpperCase()=="TEXT") {
		//	alert("INPUT NAME : "+e.name+"\nSIZE : "+e.maxLength);
			if(e.maxLength != -1 && countTextLength(e,e.maxLength,3) == false){
				document.body.focus();
				e.focus();
				return ;
			}
		}else if(tagName=="TEXTAREA"&&e.type.toUpperCase()=="TEXTAREA"){
		//	alert("TEXTAREA NAME : "+e.name+"\nSIZE : "+e.maxLength);
			if(e.maxLength != -1 && countTextLength(e,e.maxLength,3) == false){
				document.body.focus();
				e.focus();
				return ;
			}
		}
	}
	return true;
}

//폼내용저장
var formValue = Array();
function elementSave(form){
	formValue = Array();
	var elements = document.forms[form];
	var cnt = 0;
	for(var i=0;i<elements.length;i++) {
		var element = elements[i];
		var tagName = element.tagName.toUpperCase();
		if((tagName == 'INPUT' || tagName == 'TEXTAREA' || tagName == 'SELECT')
			&& element.name != "" && element.name != "radioAu" ){
			if(element.type.toUpperCase() == 'CHECKBOX' || element.type.toUpperCase() == 'RADIO') {
				formValue[element.name+i] = element.checked;
			}else{
				formValue[element.name+i] = element.value;
			}
		}
	}
}

function countTextLength(input, leng, byteSize) {
	var text = input.value;
	var memocount = 0;
	for(var k=0;k<text.length;k++){
		var temp = text.charAt(k);
		if(escape(temp).length > 4){
			memocount += byteSize;
		}
		else memocount++;

	}
//	alert("현재/오라클("+memocount+"/"+(leng)+")"+"length : "+text.length);
	if(memocount > (leng)){
		alert("입력 범위를 초과하였습니다.");
		return false;
	}else{
		return true;
	}
}

function validation(){
	var reqs = $('.required');
	var emptyCnt = 0;
	if(reqs.length > 0)
	{
		$(reqs).each(function(idx){
			var obj_type = $(reqs[idx]);
			var obj_name = $(reqs[idx]).attr('reqName');
			var data = $(obj_type).val().trim();
			if(data.length < 1){
				emptyCnt++;
				obj_type.css('background-color','#FFCC66');
			}
			else
			{
				obj_type.css('background-color','');
			}
		});
		if(emptyCnt == 0) return true;
		else return false;
	}
	else
	{
		return true;
	}
}

function focusRequired(){
	var reqs = $('.required');
	var count = 0;
	if(reqs.length > 0)
	{
		$(reqs).each(function(idx){
			var obj_type = $(reqs[idx]);
			var data = $(obj_type).val().trim();
			if(data.length < 1){
				$(obj_type).focus();
				return false;
			}
		});
	}
}

function addFile(btn){
	fileIdx++;
	var $ul = $(btn).parent().parent().parent();
	var $li = $('<li></li>');
	var $span = $('<span class="upload_int"></span>');
	$span.append($('<input type="text" class="up_input" id="fileInput'+fileIdx+'" onclick="$(\'#file'+fileIdx+'\').trigger(\'click\');" readonly="readonly" />'));
	$span.append($('<a href="javascript:void(0);" class="upload_int_bt" onclick="$(\'#file'+fileIdx+'\').trigger(\'click\');">파일 선택</a>'));
	$span.append($('<input type="file"  class="typeFile" style="display: none;" name="file"  id="file'+fileIdx+'" onchange="$(\'#fileInput'+fileIdx+'\').val($(this).val().split(\'\\\\\').pop());"/>'));
	$li.append($span);
	var $p = $('<p class="up_right_p"></p>');
	$p.append($('<a href="javascript:void(0);" class="tbl_icon_a row_add_bt" onclick="addFile($(this));">줄추가</a>&nbsp;'));
	$p.append($('<a href="javascript:void(0);" class="tbl_icon_a red_del" onclick="removeFile($(this));">줄삭제</a>'));
	$li.append($p);
	$ul.append($li);
	isChange = true;
}

function removeFile(btn){
	var $li = $(btn).parent().parent();
	var $ul = $li.parent();
	if($ul.find('li').length == 1){
		addFile(btn);
	}
	$li.remove();
	isChange = true;
}

function removeFileItem(btn){
	$(btn).parent().remove();
	isChange = true;
}

function clearPrtcpnt(btn){

	var $tr = $(btn).parent().parent().parent().parent();
	//console.log($tr.html());
	var index = $tr.find('input[name="prtcpntIndex"]').eq(0).val();
	//console.log(index);

	//$('#prtcpntNm_'+index).val('');
	$('#pcnRschrRegNo_'+index).val('');
	//$('#seqAuthor_'+index).val('');
	//$('#prtcpntFullNm_'+index).val('');
	//$('#tpiDvsCd_'+index).val('4');
	$('#prtcpntId_'+index).val('');
	$('#isRecord_'+index).val('');
	$('#recordStatus_'+index).val('');
	$('#blngAgcCd_'+index).val('');
	$('#blngAgcNm_'+index).val('');
	$('#tpiRate_'+index).val('');
	$('#dgrDvsCd_'+index).val('');
	$('#posiCd_'+index).val('');
	$tr.find('input[id="tempChk_'+index+'"]').prop('checked','');
	$tr.find('.ck_round_bt').remove();
	$tr.find('.dispDept').eq(0).empty();
	isChange = true;
}

function addPrtcpnt(btn){
	prtcpntIdx++;
	var $tbody = $(btn).parent().parent().parent();
	var $tr = $(btn).parent().parent();
	var newTr = $tr.clone();
	var inputs = newTr.find('input');
	for(var i=0; i < inputs.length; i++)
	{
		var objName = inputs.eq(i).prop('name');

		//console.log(objName + " : " + (objName == 'prtcpntIndex') + " : " + prtcpntIdx);
		if(objName == 'prtcpntIndex')
		{
		   inputs.eq(i).prop('id', objName+"_"+prtcpntIdx).prop('value',prtcpntIdx);
		}

		if(objName == 'seqAuthor')
		{
			inputs.eq(i).prop('id', objName+"_"+prtcpntIdx).val('N');
		}
		else if(objName == 'seqParti')
		{
			inputs.eq(i).prop('id', objName+"_"+prtcpntIdx).val('N');
		}
		else
		{
			inputs.eq(i).prop('id', objName+"_"+prtcpntIdx).val('');
		}

	}
	var tpiDvsCd = $(newTr).find('select[name="tpiDvsCd"]').prop('id', 'tpiDvsCd_'+prtcpntIdx).find('option:last').val();
	var posiCd = $(newTr).find('select[name="posiCd"]').prop('id', 'posiCd_'+prtcpntIdx).find('option:first').val();

	newTr.find('select[name="tpiDvsCd"]').prop('id', 'tpiDvsCd_'+prtcpntIdx).val(tpiDvsCd);
	newTr.find('select[name="posiCd"]').prop('id', 'posiCd_'+prtcpntIdx).val(posiCd);
    newTr.find('input[id="tempChk_'+prtcpntIdx+'"]').prop('checked','');
	newTr.find('input[id="recordStatus_'+prtcpntIdx+'"]').val('');
	newTr.find('.ck_round_bt').remove();
	newTr.find('.dispDept').eq(0).empty();
	newTr.css('background-color','#FFFFFF');
	$tr.after(newTr);
	$('#prtcpntIndex_'+prtcpntIdx).val(prtcpntIdx);
	$tbody.find('span[id^="order_"]').each(function(i, obj){ $(obj).text(i+1); });
	isChange = true;
	//changeOrder($tbody);
}

function removePrtcpnt(btn){
	var $tbody = $(btn).parent().parent().parent();
	var $trs = $tbody.find('tr')
	if($trs.length == 1){
		addPrtcpnt(btn);
	}
	var  $thisTr = $(btn).parent().parent();
	var seqAuthor = $thisTr.find('input[name="seqAuthor"]').val();
	$('#formArea').append($('<input type="hidden" name="deleteUser" value="'+seqAuthor+'" />)'));
	$thisTr.remove();
	$tbody.find('span[id^="order_"]').each(function(i, obj){ $(obj).text(i+1); });
	isChange = true;
	//changeOrder($tbody);
}

function changeOrder(body){
	var $tbody = $(body);
	var $trs = $tbody.find('tr')
	for(var i = 0; i < $trs.length; i++)
	{
		$trs.eq(i).find('td').eq(0).empty().text(i+1);
	}
	isChange = true;
}

function changeIsRecord(chk){
	var $tr = $(chk).parent().parent().parent().parent();
	var index = $tr.find('input[name="prtcpntIndex"]').eq(0).val();
	if($(chk).prop('checked'))
	{
		$('#isRecord_' + index).val('Y');
	}
	else
	{
		$('#isRecord_' + index).val('N');
	}
	isChange = true;
}

function browserType(){
	/*
	 * return value
	 * Chrome -> C
	 * Safari -> S
	 * Firefox -> F
	 * IE      -> I
	 * Edge    -> E
	*/
	var agent = navigator.userAgent.toLowerCase();
	if (agent.indexOf("chrome") != -1) return "C";
	else if (agent.indexOf("safari") != -1) return "S";
	else if (agent.indexOf("firefox") != -1) return "F";
	else if (agent.indexOf("edge") != -1) return "E";
	else if ( (navigator.appName == 'netscape' && navigator.userAgent.search('trident') != -1) || (agent.indexOf("trident") != -1) || (agent.indexOf("msie") != -1) ) return "I";
}

function getToday(){
	 var today = new Date(); 								// 날자 변수 선언
     var dateNow = fn_lpad(String(today.getDate()),"0",2);   //일자를 구함
     var monthNow = fn_lpad(String((today.getMonth()+1)),"0",2); // 월(month)을 구함
     var yearNow = String(today.getFullYear()); 				//년(year)을 구함
     return yearNow + monthNow + dateNow;
}

function fn_lpad(val,set,cnt)
{
     if( !set || !cnt || val.length >= cnt)
     {
          return val;
     }

     var max = (cnt - val.length)/set.length;

     for(var i = 0; i < max; i++)
     {
          val = set + val;
     }

     return val;
}

function showTooltip(btn){
	$('.th_help_box').css('display','none');
	$(document).off("click");

	btn.parent().find('.th_help_box').css('display','block');
	 setTimeout(function() {
			$(document).on("click",function(e) {
				if($(e.target).parents('.th_help_box').size() == 0){
					$('.th_help_box').css('display','none');
					$(document).off("click");
				}
			});
	 }, 100);
}

function changePblcYear(id){
	var yearValue = $('#' + id + 'Year').val();
	if(yearValue == '' ||  yearValue == 'ACCEPT')
	{
		$('#' + id + 'Month').val('').prop('disabled','disabled').css('background-color','#f0f0f0');
		$('#' + id + 'Day').val('').prop('disabled','disabled').css('background-color','#f0f0f0');
	}
	else
	{
		$('#' + id + 'Month').removeProp('disabled').css('background-color','#ffffff');
		$('#' + id + 'Day').removeProp('disabled').css('background-color','#ffffff');
		if($('#' + id + 'Month').val() != '')
			changePblcMonth();
	}

	setPblcYm(id);
}

function changePblcMonth(id){
	var to_year = $('#' + id + 'Year').val();
	var to_month = $('#' + id + 'Month').val();
	var pblcYm = new Date(to_year, to_month, "");
	var lastDay = pblcYm.getDate();
	var dayValue = $('#' + id + 'Day').val();
	$('#' + id + 'Day').empty().append($('<option value=""></option>'));
	for(var i = 1; i < lastDay + 1 ; i ++)
	{
		var selected = "";
		var value = i < 10 ? '0'+i : ''+i ;
		if(value == dayValue) selected = 'selected="selected"';
		$('#' + id + 'Day').append($('<option value="'+value+'" '+selected+'>'+value+'</option>'))
	}
	setPblcYm(id);
}

function changePblcDay(id){
	setPblcYm(id);
}

function setPblcYm(id){
	var pblcYmValue = "";
	var yearValue = $('#' + id + 'Year').val();
	var monthValue = $('#' + id + 'Month').val();
	var dayValue = $('#' + id + 'Day').val();
	//pblcYmValue = yearValue +  monthValue + dayValue;
	if(yearValue != null) pblcYmValue +=  yearValue;
	if(monthValue != null) pblcYmValue +=  monthValue;
	if(dayValue != null) pblcYmValue +=  dayValue;
	var target = $('#' + id + 'Ym');
	if(target != null) $('#' + id + 'Ym').val(pblcYmValue.trim());
	isChange = true;
}

function onFocusHelp(id) {
	$('#'+id+'Label').css('display','none');
}

function onBlurHelp(id) {
	if($('#'+id).val()=="") $('#'+id+'Label').css('display','');
}

function addFunding(btn){
	fundingIdx++;
	var $tbody = $(btn).parent().parent().parent();
	var $tr = $(btn).parent().parent();
	var newTr = $tr.clone();
	var inputs = newTr.find('input');
	for(var i=0; i < inputs.length; i++)
	{
		var objName = inputs.eq(i).prop('name');
		if(objName == 'fundIndex')
		{
			inputs.eq(i).prop('id', objName+"_"+fundingIdx).prop('value',fundingIdx);
		}
		else if(objName == 'seqNo')
		{
			inputs.eq(i).prop('id', objName+"_"+fundingIdx).prop('value','_blank');
		}
		else
		{
			inputs.eq(i).prop('id', objName + "_" + fundingIdx).val('');
		}
	}
	$tr.after(newTr);
	isChange = true;
}

function removeFunding(btn){
	var $tbody = $(btn).parent().parent().parent();
	var $trs = $tbody.find('tr');
	if($trs.length == 1){
		addFunding(btn);
	}
	var  $thisTr = $(btn).parent().parent();
	$thisTr.remove();
	isChange = true;
}

var fundIndex;
function findFunding(btn,e){

	var $tr = null;
	if($(btn).prop('type') == "text")
	{
		$tr = $(btn).parent().parent().parent();
	}
	else
	{
		$tr = $(btn).parent().parent().parent().parent();
	}
	fundIndex = $tr.find('input[name="fundIndex"]').eq(0).val();

	var wWidth = 950;
	var wHeight = 350;

	pageX = $(window).width() /2 - wWidth /2 + $(window).scrollLeft();
	pageY = $(window).height() /2 - wHeight /2 + $(window).scrollTop();


	if(dhxWins != null && dhxWins.unload != null)
	{
		dhxWins.unload();
		dhxWins = null;
	}

	var srchKeyword = $('#rschSbjtNm_'+fundIndex).val();

	dhxWins = new dhtmlXWindows({
		viewport : {objec : 'windVP'},
		wins : [ {id : 'w1', left : pageX, top : pageY, width: wWidth, height: wHeight, text: getText('tit_fund_sear'), resize : false} ]
	});
	dhxWins.window('w1').setModal(true);
	myLayout = dhxWins.window('w1').attachLayout('2E')
	myLayout.cells('a').hideHeader();
	myLayout.cells('b').hideHeader();
	myLayout.cells("a").setHeight(60);
	myLayout.cells("a").attachURL(contextpath+"/"+preUrl+"/i18n/winhelp/help_findFunding.do");

	var initYearMonth = (new Date().getFullYear() - 7) + "01" ;
	var endYearMonth = '999912';

	var toolbarText = '<div class="r_add_bt" style="margin-top:-2px;">';
		toolbarText += '<form id="srchFundingFrm">';
		if(sessMode == 'true' || loginAuthor == 'R' || loginAuthor == 'S')
			toolbarText += '<input type="radio" name="srchGroup" id="srchGroup_User" value="USER" style="vertical-align:middle;width:12px;height:12px;" checked="checked" />';
		else
			toolbarText += '<input type="radio" name="srchGroup" id="srchGroup_User" value="USER" style="vertical-align:middle;width:12px;height:12px;" />';
		toolbarText += '<label for="group_p">'+getText('tit_fund_gubun_person')+'</label>&nbsp;&nbsp;';
		if(sessMode == 'true' || loginAuthor == 'R' || loginAuthor == 'S')
			toolbarText += '<input type="radio" name="srchGroup" id="srchGroup_All" value="ALL" style="vertical-align:middle;width:12px;height:12px;" />';
		else
			toolbarText += '<input type="radio" name="srchGroup" id="srchGroup_All" value="ALL" style="vertical-align:middle;width:12px;height:12px;" checked="checked"/>';
		toolbarText += '<label for="group_a">'+getText('tit_fund_gubun_all')+'</label>&nbsp;&nbsp;';
		toolbarText += '<span style="margin-right:20px;"></span>';
		toolbarText += getText('tit_fund_period');
		if(sessMode == 'true' || loginAuthor == 'R' || loginAuthor == 'S')
		{
			toolbarText += '<input type="text" id="sttDate" name="sttDate" class="input_type" value="" maxlength="6" style="text-align:center;width:100px;" /> ~ ';
			toolbarText += '<input type="text" id="endDate" name="endDate" class="input_type" value="" maxlength="6" style="text-align:center;width:100px;" />';
		}
		else
		{
			toolbarText += '<input type="text" id="sttDate" name="sttDate" class="input_type" value="'+initYearMonth+'" maxlength="6" style="text-align:center;width:100px;" /> ~ ';
			toolbarText += '<input type="text" id="endDate" name="endDate" class="input_type" value="'+endYearMonth+'" maxlength="6" style="text-align:center;width:100px;" />';
		}
		toolbarText += '<span style="margin-right:20px;"></span>';
		toolbarText += getText('tit_fund_sub');
		toolbarText += '<input type="text" id="srchKeyword" name="srchKeyword" class="input_type" value="'+srchKeyword+'" style="width:400px;" onkeydown="if(event.keyCode==13){$(\'#srchBtn\').trigger(\'click\');}"/>';
		//toolbarText += '<div style="float: right;margin: 0px 0px 0px 0px;vertical-align:middle;">';
		toolbarText += '<a href="javascript:void(0);" id="srchBtn" class="tbl_search_bt" >검색</a>';
		//toolbarText += '</div>';
		toolbarText += '</form>';
	winToolbar = myLayout.cells("b").attachToolbar();
	winToolbar.setIconsPath(contextpath + "/images/common/icon/");
	winToolbar.setIconSize(18);
	winToolbar.addText("funding", 0, toolbarText);
	setTimeout(function() {
		var dhxCellToolbarDef =  $('#srchFundingFrm').parent().parent().parent().parent().parent();
		dhxCellToolbarDef.css({'border-width':'1px', 'border-bottom':'0px'});
		$('#srchBtn').click(function(){
			var srchGubun = $('input:radio[name="srchGroup"]:checked').val();
			if(srchGubun == 'ALL' && ($('#srchFundingFrm #sttDate').val() == '' || $('#srchFundingFrm #endDate').val() == '') )
			{
				dhtmlx.alert({type:"alert-warning",text:"전체 연구과제 검색의 경우 연구기간을 입력해야합니다.",callback:function(){
					if($('#srchFundingFrm #sttDate').val() == '') $('#sttDate').focus();
					else $('#srchFundingFrm #endDate').focus();
				}})
				return;
			}
			else
			{
				var sttDateValue = $('#srchFundingFrm #sttDate').val();
				var endDateVaoue = $('#srchFundingFrm #endDate').val();
				if( sttDateValue != '' && endDateVaoue != '' &&  sttDateValue > endDateVaoue)
				{
					dhtmlx.alert({type:"alert-warning",text:"시작년월은 종료년월보다 작아야 합니다. 다시 입력하세요",callback:function(){
						$('#srchFundingFrm #sttDate').val('').focus();
					}})
					return;
				}

				winGrid.clearAndLoad(contextpath+'/article/getFunding.do?' + $('#srchFundingFrm').serialize());
			}
		});

	}, 100);

	 winGrid = myLayout.cells("b").attachGrid();
	 winGrid.setImagePath(dhtmlximagepath);
	 winGrid.setHeader(getText('tit_fund_grid'),null, grid_head_center_bold);
	 winGrid.setColumnIds("fundingId,rschYm,rschSbjtNm,agcSbjtNo,sbjtNo");
	 winGrid.setInitWidths("80,145,*,120,150");
	 winGrid.setColAlign('center,center,left,center,center');
	 winGrid.setColTypes('ro,ro,ro,ro,ro');
	 winGrid.setColSorting('str,str,str,str,str');
	 winGrid.enableColSpan(true);
	 winGrid.attachEvent("onXLS", function() { myLayout.cells("b").progressOn(); });
	 winGrid.attachEvent("onXLE", function() { myLayout.cells("b").progressOff();});
	 winGrid.attachEvent('onRowSelect', funding_onRowSelect);
	 winGrid.init();
	 if(sessMode == 'true' || loginAuthor == 'R' || loginAuthor == 'S')
	 {
		 winGrid.loadXML(contextpath+'/article/getFunding.do?' + $('#srchFundingFrm').serialize());
	 }
	 else
	 {
		 if(srchGubun == 'ALL' && ($('#sttDate').val() != ''|| $('#endDate').val() != '' || $('#srchKeyword').val() != '' ))
			 winGrid.loadXML(contextpath+'/article/getFunding.do?' + $('#srchFundingFrm').serialize());
	 }
}

function funding_onRowSelect(rowId,celInd){
	if(winGrid != null)
	{
		$('#sbjtNo_'+fundIndex).val(winGrid.cells(rowId, winGrid.getColIndexById("sbjtNo")).getValue());
		$('#fundingId_'+fundIndex).val(winGrid.cells(rowId, winGrid.getColIndexById("fundingId")).getValue());
		$('#rschSbjtNm_'+fundIndex).val(winGrid.cells(rowId, winGrid.getColIndexById("rschSbjtNm")).getValue());
	}
	isChange = true;
	dhxWins.window('w1').close();
}

var dhxCodeWins, dhxCodeLayout, dhxCodeToolbar, dhxCodeGrid;
function getCodeWin(gubun, inputId, winsTitle, value, isUsed){

	if(isUsed == undefined) isUsed = '';

	var wWidth = 350;
	var wHeight = 350;
	var leftPos = Math.max(0, (($(document).width() - wWidth) / 2) + $(document).scrollLeft());
	var topPos = Math.max(0, (($(document).height() - wHeight) / 2) + $(document).scrollTop());

	if(dhxCodeWins != null && dhxCodeWins.unload != null)
	{
		dhxCodeWins.unload();
		dhxCodeWins = null;
	}

	dhxCodeWins = new dhtmlXWindows({
		viewport : {objec : 'windVP'},
		wins : [ {id : 'w1', left : leftPos, top : topPos, width: wWidth, height: wHeight, text: winsTitle, resize : false} ]
	});
	dhxCodeWins.window('w1').setModal(true);

	dhxCodeLayout = dhxCodeWins.window('w1').attachLayout('2E');
	dhxCodeLayout.cells("a").hideHeader();
	dhxCodeLayout.cells("b").hideHeader();
	//dhxCodeLayout.cells("a").attachURL(rimsPath+"/windowHelp/help"+index+".jsp");
	dhxCodeLayout.cells("a").setHeight(50);

	dhxCodeToolbar = dhxCodeLayout.cells("b").attachToolbar();
	dhxCodeToolbar.setIconsPath(contextpath+"/images/common/icon/");
	dhxCodeToolbar.addInput("keyword", 0, value, 265);
	dhxCodeToolbar.addButton("search", 1, "", "btn_search.png", "btn_search.png");
	dhxCodeToolbar.attachEvent("onClick", function(id) {
		if (id == "search"){
			dhxCodeGrid.clearAndLoad(contextpath+'/code/findByGubunAndKeyword.do?gubun='+gubun+"&isUsed="+isUsed+"&srchKeyword=" + encodeURIComponent(dhxCodeToolbar.getValue('keyword')));
		}
	});
	dhxCodeToolbar.attachEvent("onEnter", function(id,value) {
		if(value == "") alert("입력한내용이 없습니다.");
		else dhxCodeGrid.clearAndLoad(contextpath+'/code/findByGubunAndKeyword.do?gubun='+gubun+"&isUsed="+isUsed+"&srchKeyword=" + encodeURIComponent(dhxCodeToolbar.getValue('keyword')));
    });

	dhxCodeGrid = dhxCodeLayout.cells("b").attachGrid();
	dhxCodeGrid.setImagePath(contextpath+'/js/codebase/imgs/');
	dhxCodeGrid.setHeader(winsTitle,null,grid_head_center_bold);
	dhxCodeGrid.setColAlign('left');
	dhxCodeGrid.setColTypes('ro');
	dhxCodeGrid.setColSorting('str');
	dhxCodeGrid.attachEvent("onXLS", function() { dhxCodeLayout.cells("b").progressOn(); });
	dhxCodeGrid.attachEvent("onXLE", function() { dhxCodeLayout.cells("b").progressOff(); });

	dhxCodeGrid.attachEvent('onRowSelect', function(id){
		var code = id.split('_');
		var codeKey = code[0];
		var codeValue = code[1];
		$('#'+inputId+'Key').val(codeKey);
		$('#'+inputId+'Value').val(codeValue);
		// 참여자의 기관색상 변경을 위해 추가
		isChange = true;
		dhxCodeWins.window('w1').close();
	});
	dhxCodeGrid.init();
	if(value != null && value != '')
		dhxCodeGrid.clearAndLoad(contextpath+'/code/findByGubunAndKeyword.do?gubun='+gubun+'&isUsed='+isUsed+'&srchKeyword=' + encodeURIComponent(dhxCodeToolbar.getValue('keyword')));
}

function setChange(){
	isChange = true;
}

function getCurrentDate(){
	var week = new Array('일','월','화','수','목','금','토');
	var today = new Date();
	var year = today.getFullYear();
	var month = today.getMonth() + 1;
	var day = today.getDate();
	var dayName = week[today.getDay()];

    return 	year + "년 "+month+"월 "+day+"일 ("+dayName+")";
}

var imageExtensionReg = /gif|jpg|jpeg|png/i; // 업로드 가능 확장자.

Date.prototype.format = function(f) {
    if (!this.valueOf()) return " ";

    var weekName = ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"];
    var d = this;

    return f.replace(/(yyyy|yy|MM|dd|E|hh|mm|ss|a\/p)/gi, function($1) {
        switch ($1) {
            case "yyyy": return d.getFullYear();
            case "yy": return (d.getFullYear() % 1000).zf(2);
            case "MM": return (d.getMonth() + 1).zf(2);
            case "dd": return d.getDate().zf(2);
            case "E": return weekName[d.getDay()];
            case "HH": return d.getHours().zf(2);
            case "hh": return ((h = d.getHours() % 12) ? h : 12).zf(2);
            case "mm": return d.getMinutes().zf(2);
            case "ss": return d.getSeconds().zf(2);
            case "a/p": return d.getHours() < 12 ? "오전" : "오후";
            default: return $1;
        }
    });
};

String.prototype.string = function(len){var s = '', i = 0; while (i++ < len) { s += this; } return s;};
String.prototype.zf = function(len){return "0".string(len - this.length) + this;};
Number.prototype.zf = function(len){return this.toString().zf(len);};

//url prameter -> json
function query_to_hash(q){
    var j;
    q = q.replace(/\?/, "").split("&");
    j = {};
    $.each(q, function(i, arr) {
    	if(arr.indexOf("=") != -1)
		{
			arr = arr.split('=');
        	return j[arr[0]] = arr[1];
        }
    });
    return j;
}
function getCurrentYearMonth(){
    var today = new Date();
    var year = today.getFullYear();
    var month = today.getMonth() + 1;
    return year + "-" + month;
}
function getCurrentYear(){
    var today = new Date();
    var year = today.getFullYear();
    return year;
}

function getCodeOrgWin(obj,e){

    var $tr = null;
	var keywordStr = "";

	if($(obj).prop('type') == "text")
	{
		$tr = $(obj).parent().parent().parent();
	}
	else
	{
		$tr = $(obj).parent().parent().parent().parent();
	}

    var index = $tr.find('input[name="prtcpntIndex"]').eq(0).val();
	elementIndex = index;

    if(obj != 'dgrAcqsAgcCd')
	{

		if (keywordStr == "" && $(obj).prop('type') == "text")
		{
			keywordStr = $(obj).val();
		}
		else
		{
			keywordStr = $('#blngAgcNm_'+elementIndex).val();
		}
	}
    else
	{
		keywordStr = $( '#' + obj + "Value").val();
	}

    var wWidth = 650;
    var wHeight = 450;

    pageX = $(window).width() /2 - wWidth /2 + $(window).scrollLeft();
    pageY = $(window).height() /2 - wHeight /2 + $(window).scrollTop();

    if(wins != null && wins.unload != null)
    {
        wins.unload();
        wins = null;
    }

    wins = new dhtmlXWindows({
        viewport : {objec : 'windVP'},
        wins : [ {id : 'w1', left : pageX, top : pageY, width: wWidth, height: wHeight, text: getText("tit_agc_sear"), resize : false} ]
    });
    wins.window('w1').setModal(true);

    if(keywordStr == "" || keywordStr == undefined) keywordStr = instname;

    dhxLayout = wins.window('w1').attachLayout('2E');
    dhxLayout.cells("a").hideHeader();
    dhxLayout.cells("b").hideHeader();
    dhxLayout.cells("a").attachURL(contextpath+"/"+preUrl+"/i18n/winhelp/help_findOrganization.do");
    dhxLayout.cells("a").setHeight(55);

    winToolbar = dhxLayout.cells("b").attachToolbar();
    winToolbar.setIconsPath(contextpath+"/images/common/icon/");
    winToolbar.addInput("keyword", 0, keywordStr, 565);
    winToolbar.addButton("search", 1, "", "tbl_search_icon.png", "tbl_search_icon.png");
    winToolbar.attachEvent("onClick", function(id) {
        if (id == "search")
        {
            winGrid.clearAndLoad(contextpath+'/code/findCodeOrgList.do?srchKeyword=' + encodeURIComponent(winToolbar.getValue('keyword')));
        }
    });
    winToolbar.attachEvent("onEnter", function(id,value) {
        if(value == "")
        {
            dhtmlx.alert({type:"alert-warning",text:getText('tit_area_alert'),callback:function(){}});
        }
        else
        {
            winGrid.clearAndLoad(contextpath+'/code/findCodeOrgList.do?srchKeyword=' + encodeURIComponent(winToolbar.getValue('keyword')));
        }
    });

    dhxLayout.cells("b").attachStatusBar({
        text : '<div id="grid_pagingArea"></div>',
        paging : true
	});

    winGrid = dhxLayout.cells("b").attachGrid();
    winGrid.setImagePath(dhtmlximagepath);
    winGrid.setHeader('value,'+getText('tit_agc_grid'),null,grid_head_center_bold);
    winGrid.setColumnIds("codeValue,codeDisp");
    winGrid.setInitWidths("1,*");
    winGrid.setColAlign('center,left');
    winGrid.setColTypes('ro,ro');
    winGrid.setColumnHidden(winGrid.getColIndexById("codeValue"),true);
    winGrid.attachEvent("onXLS", function() {
        wins.window('w1').progressOn();
    });
    winGrid.attachEvent("onXLE", function() {
        wins.window('w1').progressOff();
    });
    winGrid.attachEvent('onRowSelect', function(id){
    	var codeKey = winGrid.cells(winGrid.getSelectedId(),winGrid.getColIndexById("codeValue")).getValue();
    	var codeDisp = winGrid.cells(winGrid.getSelectedId(),winGrid.getColIndexById("codeDisp")).getValue();
        if(index != undefined){
            $('#blngAgcCd_'+elementIndex).val(codeKey);
            $('#blngAgcNm_'+elementIndex).val(codeDisp);
            // 참여자의 기관색상 변경을 위해 추가
            $('#blngAgcNm_'+elementIndex).css('background','#fff');
        }
        else
        {
            $('#'+obj+'Key').val(codeKey);
            $('#'+obj+'Value').val(codeDisp);
        }
        isChange = true;
        wins.window('w1').close();
    });
    winGrid.enablePaging(true,100,10,"grid_pagingArea");
    winGrid.setPagingSkin("toolbar");

    winGrid.init();
    $('.dhxtoolbar_input').focus();
    winGrid.loadXML(contextpath+'/code/findCodeOrgList.do?srchKeyword=' + encodeURIComponent(winToolbar.getValue('keyword')));
}