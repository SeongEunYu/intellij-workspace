<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@page import="kr.co.argonet.r2rims.core.vo.UserVo"%>
<%@page import="kr.co.argonet.r2rims.constant.R2Constant"%>
<%@page import="org.apache.commons.lang3.ObjectUtils"%>
<%@ page import="java.util.Map"%>
<%@ include file="../../pageInit.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>연구자 검색</title>
<%
	String contextPath = request.getContextPath();
	String groupKey = "";
	UserVo user = (UserVo) request.getSession().getAttribute(R2Constant.LOGIN_USER);
	if(ObjectUtils.toString(user.getAdminDvsCd()).equals(R2Constant.DEPT_DVS_CD)){
		groupKey = ObjectUtils.toString(request.getSession().getAttribute("dept_key"));
	}else if(ObjectUtils.toString(user.getAdminDvsCd()).equals(R2Constant.COLLEGE_DVS_CD)){
		groupKey = ObjectUtils.toString(request.getSession().getAttribute("college_key"));
	}else if(ObjectUtils.toString(user.getAdminDvsCd()).equals(R2Constant.TRACK_DVS_CD)){
		groupKey = ObjectUtils.toString(request.getSession().getAttribute("track_key"));
	}

%>
<style type="text/css">
	*{margin:0; padding:0;}

	/* body, td, div, img, form 공통적용 */
	body{
		width: 355px;
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


	#wrap_division{width:350px; margin:auto; margin-top:5px; margin-bottom:5px; background-color:#e9ecf1; border:1px solid #e0e2e7;}
	#wrap{width:340px; margin:auto; margin-top:8px; padding-bottom:13px;}

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
</style>
<script type="text/javascript" src="${contextPath}/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript">
function searchReasearcher(){
	if($("#searchWord").val() == ""){
		alert("이름 또는 사번을 입력해주세요");
	}
	 $.ajax({
	        	url : "${contextPath}/analysis/findResearcherListAjax.do",
	        	method : 'POST',
	        	dataType : 'json',
	        	data : {'gubun':'<%=user.getAdminDvsCd()%>', 'searchWord' : $("#searchWord").val(), 'groupKey':'<%=groupKey%>'},
	        	success : function (data, textStatus, jqXHR) {
	        		$('#list').empty();
	        		if(data.length > 0)
	        		{

	        			for(var i=0; i < data.length; i++)
	        			{
			        		var ul = $('<ul></ul>');
			        		var li = $('<li></li>');
			        		if(data[i].artsCo != undefined )
			        		{
			        			li.append($('<a href="javascript:completeSearch(\''+data[i].userId+'\');"></a>').append(data[i].korNm + " [" +data[i].userId+"]" +" / "+data[i].deptKor));
			        			/*
			        			if(data[i].artsCo <= 0) li.append("(No Article)");
			        			if(data[i].artsCo > 0)
			        			{
			        				li.append($('<a href="javascript:completeSearch(\''+data[i].userId+'\');"></a>').append(data[i].korNm + " [" +data[i].userId+"]" +" / "+data[i].deptKor));
			        			}
			        			else
			        			{
			        				li.append(data[i].korNm + " [" +data[i].userId+"]" +" / "+data[i].deptKor +" - Not link (No Article)"  );
			        			}
			        			*/
			        		}
			        		ul.append(li);
			        		$('#list').append(ul);
	        			}
	        		}
	        		else
	        		{
	        			$('#list').append($("<ul><li>검색된 연구자가 없습니다.</li></ul>"));
	        		}
	        	}
	        }).done(function(data){});
}
function completeSearch(id){
	var params = "id="+id+"&gubun=R";
	 $.ajax({
	        	type : 'POST',
	        	url : "<c:url value="/analysis/changeSession.do"/>",
	        	data : params,
	        	success : function (args) {
	        		if(args != ""){
	        			opener.parent.location='<c:url value="/analysis/researcher/overview.do?userId="/>'+id;
	        			window.close();
	        		}
	        	}
	        });
}
</script>
</head>
<body>
	<div id="wrap_division">
	<div id="wrap">
		<div><img src="<c:url value="/images/searchPopup/ico_searchImg.png"/>" alt="검색아이콘" /><h1>연구자 검색 (이름 또는 사번)</h1></div>
		<div class="search" onkeydown="if(event.keyCode == 13){searchReasearcher();} ">
			<input type="text" name="searchWord" id="searchWord">
			<a href="javascript:searchReasearcher()" >
				<img src="<c:url value="/images/searchPopup/btn_popSearch.png"/>" alt="검색버튼" title="검색하기" />
			</a>
		</div>
		<div class="list" id="list" style="overflow: auto; height: 115px;" >
		</div>
	</div>
	<div id="foot"><a href="javascript:window.close()"><img src="<c:url value="/images/searchPopup/btn_popClose.png"/>" alt="닫기버튼" title="팝업창 닫기" /></a></div>
</div>
</body>
</html>