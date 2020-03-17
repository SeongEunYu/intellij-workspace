<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>
<%@page import="java.util.Objects"%>
<%@ page import="org.apache.commons.lang3.StringUtils" %>
<%--<%@include file="./pageInit.jsp" %>--%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
	<%--<script src="${pageContext.request.contextPath}/share/js/jquery-1.9.1.min.js"></script>--%>
	<script type="text/javascript" src="<c:url value='/js/jquery/jquery-1.11.3.min.js' />"></script>
	<%

		//GOTIT
		// String ssoClientId = "CL_GOTIT";
		// String ssoClientSecret = "DFA0B68EF2300564C5FA9E7E03A29F57C93781A2";
// 		String  redirectUrl = "http://127.0.0.1:8080" + request.getContextPath() + "/auth/rsch/main";
		// String  redirectUrl = "https://gotit.bwise.kr" + request.getContextPath() + "/auth/rsch/main";

		//RSS
		String ssoClientId = "CL_RSS";
		String ssoClientSecret = "786114A50368F709926AA24C0FC31EC6CB4C6227";
		String  redirectUrl = "https://rss.bwise.kr/home/login.do";
//		String  redirectUrl = "http://localhost:8080/rss/home/login.do";


// 		String ssoServerUrl = "http://127.0.0.1:18080/common/login";
		String ssoServerUrl = "https://iam.bwise.kr/common/login";

		String user_id = "";
		String user_name = "";
		String user_email = "";
		String user_dept = "";
		String user_pstn = "";
		String solutions = "";
		String redirect_url = "";

		//파라미터 체크
		String success = (String)request.getAttribute("success");

		if(StringUtils.isNotBlank(success) && "true".equals(success)) //로그인 정보 존재하는 경우
		{
			/*
			*  {user_info :
							{
				             user_id:"P4567",
		              		 name:"홍길동",
				             email:'hongGD@argonet.com'
				           	 dept:'00학과'
				             position:'교수'
							},
			    solution:[{
			    			module: "RIMS"
			    			,admin:"N"
			    			,user:"Y"
			    			},
			              {
				    		module: "GOTIT"
				    		,admin:"N"
				    		,user:"Y"
				    		}
			    			...
			              ]
				}
			*
			*/
			String result = request.getParameter("data");
			System.out.println("result >>> \n" + result);

			JSONObject resultJson = new JSONObject(result);
			if(resultJson != null)
			{
				JSONObject userInfo = resultJson.getJSONObject("user_info");
				if(userInfo.has("user_id") &&  userInfo.get("user_id") != null)
					user_id = Objects.toString(userInfo.get("user_id"));
				if(userInfo.has("name") &&  userInfo.get("name") != null)
					user_name = Objects.toString(userInfo.get("name"));
				if(userInfo.has("email") &&  userInfo.get("email") != null)
					user_email = Objects.toString(userInfo.get("email"));
				if(userInfo.has("dept") &&  userInfo.get("dept") != null)
					user_dept = Objects.toString(userInfo.get("dept"));
				if(userInfo.has("position") &&  userInfo.get("position") != null)
					user_pstn = Objects.toString(userInfo.get("position"));

				JSONArray solutionArray = (JSONArray) resultJson.get("solution");
				solutions = solutionArray.toString();
// 				for(int i=0; i<solutionArray.length(); i++){
// 					JSONObject module = solutionArray.get(i);
// 	                solutions += solutionArray.get(i) + ";";
// 	            }
			}
	%>
	<script type="text/javascript">
		$(function(){
			var id = "<%=user_id%>";
			var name = "<%=user_name%>";
			var email = "<%=user_email%>";
			var dept = "<%=user_dept%>";
			var pstn = "<%=user_pstn%>";
			var solutions = '<%=solutions%>';
			$('#user_id').val(id);
			$('#user_name').val(name);
			$('#user_email').val(email);
			$('#user_dept').val(dept);
			$('#user_pstn').val(pstn);
			$('#solutions').val(solutions);
			$('#formArea').submit();
		});
	</script>
	<%
	}
	else // 사용자 정보가 없는 경우
	{
	%>
	<script type="text/javascript">
		$(function(){
			$('#formIam').submit();
		});
	</script>
	<%
		}
	%>
</head>
<body>
<form id="formArea" action="${pageContext.request.contextPath}/home.do" method="post">
	<input type="hidden" name="user_id" id="user_id" />
	<input type="hidden" name="user_name" id="user_name" />
	<input type="hidden" name="user_email" id="user_email" />
	<input type="hidden" name="user_dept" id="user_dept" />
	<input type="hidden" name="user_pstn" id="user_pstn" />
	<input type="hidden" name="solutions" id="solutions" />
</form>
<form id="formIam" action="<%=ssoServerUrl%>" method="post">
	<input type="hidden" name="client_id" value="<%=ssoClientId%>" />
	<input type="hidden" name="client_secret" value="<%=ssoClientSecret%>" />
	<input type="hidden" name="redirect_url" value="<%=redirectUrl%>" />
</form>
</body>
</html>

