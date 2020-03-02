<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="../../pageInit.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<title>researcher detail</title>
<link href="${contextPath}/css/common.css" rel="stylesheet" type="text/css"/>
<link href="${contextPath}/css/layout.css" rel="stylesheet" type="text/css"/>
<link href="${contextPath}/css/class.css" rel="stylesheet" type="text/css"/>
 <script type="text/javascript" src="${contextPath}/js/lib/jquery.js"></script>
 <script language="JavaScript" src="${contextPath}/Charts/JSClass/FusionCharts.js"></script>
 <script language="JavaScript" src="${contextPath}/Charts/JSClass/FusionChartsExportComponent.js"></script>
</head>
<body>

	<!--start #header-->
	<div id="header">
		<div class="logo">
			<a href="${contextPath}/index.do"><img src="${contextPath}/images/common/site_logo.png" alt="site logo" title="HOME" style="margin-top:4px; float:left;"/></a>
			<a href="http://www.kist.re.kr"><img src="${contextPath}/images/common/org_logo.png" alt="KIST logo" title="KIST" style="float:right;"/></a>
		</div>
		<div class="top_mn">
			<div><a href="${contextPath}/index.do"><img src="${contextPath}/images/common/topmn_tab01_off.gif" alt="Home" title="Home"/></a></div>
			<div><a href="${contextPath}/researcher/list.do"><img src="${contextPath}/images/common/topmn_tab02_on.gif" alt="researcher" title="researcher"/></a></div>
			<div><a href="${contextPath}/org/list.do"><img src="${contextPath}/images/common/topmn_tab03_off.gif" alt="Organizations" title="Organizations"/></a></div>
		</div>
	</div>
	<!--end #header-->


	<!-- start #wrapper-->
	<div id="wrapper">

		<div class="researcher_info_detail">
			<div class="researcher_info_img"><img src="http://n.kist.re.kr:8088/file/photo/<c:out value="${item.PHOTOPATH}"/>" height="150"/></div>
			<div class="researcher_info_name" >
				<div class="h2"><b><c:out value="${item.KORNM}"/> (<c:out value="${item.CDNM}"/>)</b></div>
				<div style="margin-top:20px;"><c:out value="${item.DEPTNM}"/></div>
				<div style="margin-top:8px;">TEL) <c:out value="${item.COMTELNO}"/>, &nbsp;HP) <c:out value="${item.HPHONNO}"/></div>
				<div style="margin-top:8px;">E-Mail) <c:out value="${item.MAINEMAIL}"/></div>
			</div>
		</div>


		<!-- start #content-->
		<div id="content">

			<div class="sub_title_bar" style="width:100% margin:auto; margin-top:47px;">
				<div style="float:left;"><img src="${contextPath}/images/layout/ico_leftmn.png" style="margin:5px 7px 0 0;"/></div>
				<div class="h2">Publication</div>
			</div>
			<div id="content_wrap">
				<div style="width:305px; float:left;">
					<div class="px11" style="float:left;margin-right:30px;">Articles : <c:out value="${total_arts}"/></div>
					<div class="px11">H-Index : <c:out value="${hindex}"/></div>
					<div class="px11" style="margin-top:5px;">Co-authors : <c:out value="${no_coauthors}"/></div>
					<div class="px11" style="margin-top:5px;">Citations : total (<c:out value="${total_citations}"/>), average (<c:out value="${avg_citations}"/>)</div>
					<div class="px11" style="margin-top:5px;">Avg. of Impact Factors : <c:out value="${avg_if.AVG_IF}"/></div>
					<div class="px11" style="margin-top:20px;"><img src="${contextPath}/images/layout/ico_author_network.gif" style="padding-right:5px;"/><a href="./pub.do?userid=<c:out value="${param.userid}"/>">Publication trend</a></div>
					<div class="px11" style="margin-top:7px;"><img src="${contextPath}/images/layout/ico_mapofscience.gif" style="padding-right:5px;"/><a href="./coauthor.do?userid=<c:out value="${param.userid}"/>">Co-author network</a></div>
					<div class="px11" style="margin-top:7px;"><img src="${contextPath}/images/layout/ico_trend.gif" style="padding-right:5px;"/><a href="./citation.do?userid=<c:out value="${param.userid}"/>">Citation trend</a></div>
				</div>
				<div style="width:545px; border-left:1px dotted #d8d8d0; float:right;">
				   <div id="chartdiv1" align="center">FusionCharts. </div>
			       <script type="text/javascript">
					   var chart1 = new FusionCharts("${contextPath}/Charts/flash/MSLine.swf", "ChartId1", "500", "250");
					   chart1.addParam("WMode", "Transparent");
					   chart1.setDataXML("<c:out value="${chartXML1}" escapeXml="false"/>");
					   chart1.render("chartdiv1");
					</script>
				</div>
			</div>
		</div>
		<!-- end #content-->

	</div>
	<!-- end# wrapper-->

</body>
</html>
