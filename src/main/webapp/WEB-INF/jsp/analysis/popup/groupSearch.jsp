<%@page import="kr.co.argonet.r2rims.core.vo.AnalysisVo"%>
<%@page import="java.util.List"%>
<%@page import="org.apache.commons.lang.ObjectUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%
	String contextPath = request.getContextPath();
	List<AnalysisVo> itemList = null;
	List<AnalysisVo> itemListT = null;
	String gubun = (String)request.getAttribute("gubun");
	String title = "";
	if(gubun.equals("D"))
	{
		itemList = (List<AnalysisVo>) request.getSession().getAttribute("dept_keys");
		title = "학과";
	}
	else if(gubun.equals("T"))
	{
		itemList = (List<AnalysisVo>) request.getSession().getAttribute("track_keys");
		title = "트랙";
	}
	else if(gubun.equals("C"))
	{
		itemList = (List<AnalysisVo>) request.getSession().getAttribute("college_keys");
		title = "단과대학";
	}
	else if(gubun.equals("DT"))
	{
		title = "학과";
		itemList = (List<AnalysisVo>) request.getSession().getAttribute("dept_keys");
		itemListT = (List<AnalysisVo>) request.getSession().getAttribute("track_keys");
	}
%>
<title><%=title %> 목록</title>
<style type="text/css">
	*{margin:0; padding:0;}

	/* body, td, div, img, form 공통적용 */
	body{
		width: 310px;
		height: auto;
		margin: 0;
		padding: 0;
		background-color:#ffffff;
		border:1px solid #c3c3c3;
		color: #5a5a5a;
		font:normal 12px "NanumGothic","나눔고딕","맑은고딕","Malgun Gothic","Arial";
		text-decoration: none;
		line-height: 18px;
	}

	a:link {color:#5a5a5a; font:normal 12px "NanumGothic","나눔고딕","맑은고딕","Malgun Gothic","Arial"; text-decoration: none; line-height: 18px;}
	a:visited {color:#5a5a5a; font:normal 12px "NanumGothic","나눔고딕","맑은고딕","Malgun Gothic","Arial"; text-decoration: none; line-height: 18px;}
	a:active {color:#5a5a5a; font:normal 12px "NanumGothic","나눔고딕","맑은고딕","Malgun Gothic","Arial"; text-decoration: none; line-height: 18px;}
	a:hover {color:#003cc6; font:normal 12px "NanumGothic","나눔고딕","맑은고딕","Malgun Gothic","Arial"; text-decoration: underline; line-height: 18px;}
	#wrap_division{width:296px; margin:auto; margin-top:5px; margin-bottom:5px; background-color:#e9ecf1; border:1px solid #e0e2e7;}
	#wrap{width:274px; margin:auto; margin-top:8px; padding-bottom:13px;}

	h1{color:#000000; font:bold 16px "NanumGothic","나눔고딕","맑은고딕","Malgun Gothic","Arial"; text-decoration: none; line-height: 18px; display:inline; vertical-align:-1px; margin-left:5px;}

	.search{width:100%; margin:10px 0 0 0;}
	.list{margin:12px 0 0 0;}

	img {border:0; vertical-align:middle; display:inline;}
	div {margin:0; padding:0;}

	ul {margin:0; padding:0;}
	li {list-style:none; margin:0; padding:0 0 2px 0;}
	input {width:210px; height:20px; border:1px solid #aeaeae; vertical-align:-1px; margin-right:3px;}
	#foot{width:100%; height:20px; background-color:#d5d8dc; text-align:right;}
	#foot img{margin:5px 13px 0 0;}
	#tabs .ui-tabs-nav .ui-icon {  display: inline-block; }
</style>
<script type="text/javascript" src="${contextPath}/js/jquery/jquery-1.11.3.min.js"></script>
<link rel="stylesheet" href="https://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css" />
<script src="https://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>
<script type="text/javascript">
function completeSearch(id,gubun,value){
	var userDeptField = "${sysConf['anlaysis.user.dept.field']}";
	var userCollegeField = "${sysConf['anlaysis.user.college.field']}";

	var params = "id="+id+"&gubun="+gubun+"&value="+value;
	 $.ajax({
	        	type : 'POST',
	        	url : "<c:url value="/analysis/changeSession.do"/>",
	        	data : params,
	        	success : function (data) {
	        		if(data != ""){
	        			if(gubun == "D"){
	        				var fieldValue = userDeptField == 'GROUP_DEPT' ? value : id
	        				opener.parent.location='${contextPath}/analysis/department/overview.do?deptKor='+fieldValue;
	        			}
	        			else if(gubun == "C") opener.parent.location='<c:url value="/analysis/college/overview.do?clgCd="/>'+id;
	        			else if(gubun == "T") opener.parent.location='<c:url value="/analysis/department/overview.do?trackId="/>'+id;
	        			else if(gubun == "DT"){
	        				var fieldValue = userDeptField == 'GROUP_DEPT' ? value : id
	        				opener.parent.location='<c:url value="/analysis/department/overview.do?"/>'+userDeptField+'='+fieldValue;
	        			}
	        			window.close();
	        		}
	        	}
	        });
}
$(document).ready(function(){
	 $( "#tabs" ).tabs({
			active: '<c:out value="${sTabIdx}"/>',
			activate: function( event, ui ) {
			},
			beforeActivate:function( event, ui ) {
			}
	});
	 $("#tabs").css("display", "block");
});
</script>

</head>
<body>
		<%
		if(gubun.equals("D") || gubun.equals("C") || gubun.equals("T")){%>
			<div id="wrap_division">
			<div id="wrap">
			<div><img src="<c:url value="/images/searchPopup/ico_searchImg.png"/>" alt="검색아이콘" /><h1><%=title %> 그룹목록</h1></div>
			<div class="list" id="list" style="overflow: auto; height: 288px;" >
		<%
			if(itemList == null || itemList.size() <= 0){
		%>
			<ul>
				<li>검색된 그룹이 없습니다.</li>
				<li></li>
			</ul>
			<%}else {
				for(int i =0 ; i < itemList.size() ; i++){
			%>
			<ul>
				<li><a href="javascript:completeSearch('<%=itemList.get(i).getItemId()%>','<%=gubun%>','<%=itemList.get(i).getItemNm()%>')">
						<%=itemList.get(i).getItemNm()%>
					</a>
				</li>
			</ul>
			<%
				}
			}
		%>
		</div>
		</div>
		</div>
		<%
		}else if(gubun.equals("DT")){%>
			<div id="tabs" class="tab_wrap" style="display: none;">
				<ul>
					<li><a href="#tabs-1"><span class="ui-icon ui-icon-search"></span>학과그룹</a></li>
					<li><a href="#tabs-2"><span class="ui-icon ui-icon-search"></span>트랙그룹</a></li>
				</ul>
				<div id="tabs-1">
					<div id="list" style="overflow: auto; height: 288px;" >
					<%
						if(itemList == null || itemList.size() <= 0){
					%>
						<ul>
							<li>검색된 학과 그룹이 없습니다.</li>
							<li></li>
						</ul>
						<%}else {
							for(int i =0 ; i < itemList.size() ; i++){
						%>
						<ul>
							<li><a href="javascript:completeSearch('<%=itemList.get(i).getItemId()%>','D', '<%=itemList.get(i).getItemNm()%>')">
									<%=itemList.get(i).getItemNm()%>
								</a>
							</li>
						</ul>
						<%
						}
					} %>
					</div>
			</div>
			<div id="tabs-2">
				<div id="list" style="overflow: auto; height: 288px" >
				<%
					if(itemListT == null || itemListT.size() <= 0){
				%>
					<ul>
						<li>검색된 트랙 그룹이 없습니다.</li>
						<li></li>
					</ul>
					<%}else {
						for(int i =0 ; i < itemListT.size() ; i++){
					%>
					<ul>
						<li><a href="javascript:completeSearch('<%=itemListT.get(i).getItemId()%>','T')">
								<%=itemListT.get(i).getItemNm()%>
							</a>
						</li>
					</ul>
					<%
					}
				} %>
				</div>
			</div>
			<%

		}%>
		</div>

	<div id="foot"><a href="javascript:window.close()"><img src="<c:url value="/images/searchPopup/btn_popClose.png"/>" alt="닫기버튼" title="팝업창 닫기" /></a></div>
</body>
</html>