<%@ page import="kr.co.argonet.r2rims.core.util.HashMap2" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<head>
<%@include file="../pageInit.jsp" %>
<%!
	public String changeIssn(Object issn){
		if(issn == null || ((String)issn).length() != 8) return ((String)issn);
		return ((String)issn).substring(0, 4) + "-" + ((String)issn).substring(4, 8);
	}

%>
<%
	List<HashMap2> resultList = (List<HashMap2>)request.getAttribute("resultList");
	if(resultList == null) resultList = new ArrayList<HashMap2>();

	HashMap2 summaryMap = (HashMap2)request.getAttribute("summaryMap");
	if(summaryMap == null) summaryMap = new HashMap2();

	String favoriteItem = (String)request.getAttribute("favoriteString");
%>
	<script type="text/javascript">

	$(function () {

		$(".sub_container").hide();
		$("input[type=checkbox]").on("change", function(){
			goSearch();
		});

		if('${isSearch}' == 'Y' && <%= summaryMap.size() %> == 0 ){
			alert("검색된 결과가 없습니다. 다시 시도해 주세요.");
		}
		if('${isSearch}' == 'Y'){
			$(".sub_container").show();
		}

	});

	function sampleInput(){
		$("#recom_title").val("Tumorigenic and Immunosuppressive Effects of Endoplasmic Reticulum Stress in Cancer");
		//$("#recom_keyword").val("ER stress UPR IRE1 XBP1 PERK CHOP ATF6 cancer immunotherapy");
		$("#abstracts").val("Malignant cells utilize diverse strategies that enable them to thrive under adverse conditions while simultaneously inhibiting the development of anti-tumor immune responses. Hostile microenvironmental conditions within tumor masses, such as nutrient deprivation, oxygen limitation, high metabolic demand, and oxidative stress, disturb the protein-folding capacity of the endoplasmic reticulum (ER), thereby provoking a cellular state of “ER stress.” Sustained activation of ER stress sensors endows malignant cells with greater tumorigenic, metastatic, and drug-resistant capacity. Additionally, recent studies have uncovered that ER stress responses further impede the development of protective anti-cancer immunity by manipulating the function of myeloid cells in the tumor microenvironment. Here, we discuss the tumorigenic and immunoregulatory effects of ER stress in cancer, and we explore the concept of targeting ER stress responses to enhance the efficacy of standard chemotherapies and evolving cancer immunotherapies in the clinic.");
		goSearch();
	}

	function goSearch(){
		showLoad();
		$("#searchSelectionForm").submit();
	}

	function viewDetail(seq){

		var width = $(document).width() * 0.7;
		var height = $(document).height() * 0.8;

		var left = ($(document).width()/2)-(width/2);
		var top = ($(document).height()/2)-(height/2);

		var win = window.open('${s2jUrl}/journal/journalDetailPopup.do?jrnlId='+seq,'jorunalDtl',' height=' + height + 'px, width=' + width + 'px, resizable=yes, location=no, scrollbars=yes');
		win.moveTo(left, top);
		win.focus();
	}

	function showLoad(){
		$("#loadImgDiv").css("left", $("body").width()/2);
		$("#loadImgDiv").css("top", $("body").height()/2);
		$("#loadImgDiv").show();

		$("#loadImgDiv2").css("height", ($("body").height()+300) + "px");
		$("#loadImgDiv2").show();
	}

	function checkEnter(code){
		if(code == 13) goSearch();
	}

	function editFavorite(itemId, publisher, oa, issn, title){
		var ajaxURL = "${pageContext.request.contextPath}/editFavorite.do";
		var svcgrp = "VJOUR";
		var type = "";
		if($(".favorite_star").hasClass("star_fill")){
			type = "remove";
		}
		if($(".favorite_star").hasClass("star_empty")){
			type = "add";
		}
		var url = '${s2jUrl}/journal/journalDetailPopup.do?jrnlId='+itemId;

		var elseList = title + ";" + issn + ";" + oa + ";" + publisher;

		$.ajax({
			url: ajaxURL,
			data: {itemId:itemId, svcgrp:svcgrp, type:type, url:url, elseList:elseList}
		}).done(function(){
			if(type == 'remove'){
				$("#" + itemId).addClass("star_empty");
				$("#" + itemId).removeClass("star_fill");
			}
			if(type == 'add'){
				$("#" + itemId).addClass("star_fill");
				$("#" + itemId).removeClass("star_empty");
			}

			// checkFavorite(itemId);
		});
	}

</script>
<link rel="stylesheet" type="text/css" href="<c:url value="/share/css/mquery.css"/>" />
</head>
<body><!--nav_wrap : e  -->
<form id="searchSelectionForm" method="post" action="${pageContext.request.contextPath}/personal/selection.do">
	<div class="top_search_wrap" style="padding-bottom: 20px;">
		<div class="ts_title">
			<%--<h3><spring:message code="disc.anls.topif.title"/></h3>--%>
			<h3>Journal Selection Service</h3>
		</div>
		<div class="ts_text_box">
			<div class="ts_text_inner">
				<p>
					<%--<span  style="font-weight:bold;"><spring:message code="disc.anls.topif.desc"/></span>--%>
					<span  style="font-weight:bold;"> 저널 선택 서비스는 PubMed, DOAJ, Crossref 등에 수록된 저널 정보를 기반으로 하고 있으며,</span>
					<br>
					<span  style="font-weight:bold;">100건 이상의 논문 데이터를 가지고 있는 9천여 종의 저널(1억여 건 이상의 논문 데이터) 정보를 수집하여 제공하고 있습니다.</span>
				</p>
			</div>
		</div>
		<div class="search_select_option2">
			<input type="hidden" name="isSearch" value="Y">
			<div class="ts_wrap">
				<dl class="ts_dl">
					<dt>Title</dt>
					<dd>
						<input type="text" class="int_type02" id="recom_title" name="recom_title" value="${recom_title}" placeholder=" Enter Title or Keyword">
					</dd>
				</dl>
				<dl class="ts_dl">
					<dt>Keyword</dt>
					<dd>
						<input type="text" class="int_type02" id="recom_keyword" name="recom_keyword" value="${recom_keyword}" placeholder=" Enter Keyword">
					</dd>
				</dl>
				<dl class="ts_dl">
					<dt>Abstract</dt>
					<dd style="text-align: left;">
						<textarea style="width: 1075px; max-width: 1075px;" id="abstracts" rows="5" name="abstracts" placeholder=" Enter Abstracts">${abstracts}</textarea>
					</dd>
				</dl>
				<div class="al_right">
					<a href="#" class="normal_bt2" onclick="javascript:sampleInput();">Sample</a>
					<a href="#" class="normal_bt" onclick="javascript:goSearch();">Recommend Journal</a>
				</div>
			</div>
			<div style="text-align: left; margin-left: 20px;">
				<h5 style="font-weight: bold; font-size: 15px;">Database별 투고 저널 추천 사이트</h5>
				<ul style="list-style: unset;" class="sub_research_comment">
					<li>Web of Science Master Journal List(<a href="https://mjl.clarivate.com" target="_blank">https://mjl.clarivate.com</a>)
						<br>
						논문의 제목과 초록을 기반으로 SCI급 저널 추천, Web of Science 무료 회원가입 필수
					</li>
					<li>Elsevier Journal Finder(<a href="https://journalfinder.elsevier.com" target="_blank">https://journalfinder.elsevier.com</a>)</li>
					<li>Springer Journal Suggester(<a href="https://journalsuggester.springer.com">https://journalsuggester.springer.com</a>)</li>
					<li>Wiley Journal Finder(<a herf="https://journalfinder.wiley.com/search?type=match">https://journalfinder.wiley.com/search?type=match</a>)</li>
				</ul>
			</div>
			<span style="display: block; position: relative;" class="al_right" ><a href="${pageContext.request.contextPath}/personal/compare.do" class="nomal_bt"><span class="compare_icon">Compare Journals</span></a></span>
		</div>
	</div>
	<div class="sub_container" style="min-height:720px;">
		<%
			if(summaryMap.size() > 0){
		%>
		<div class="jss_wrap">
			<div class="jss_title"><h4 class="h4_title">Selection Criteria</h4><span class="round_num"><em>${allCount}</em></span></div>
			<div class="jss_inner">
				<div class="jss_lbox">

					<div class="option_select_box add_top_line" style="margin-top: 37px;">
						<h5 class="discover_title">Ranking</h5>
						<div class="discover_ratio">
							<span class="ratio_text">Top</span>
							<input type="text" class="int_type01" title="Ratio" name="under_per" onkeydown="javascript:checkEnter(event.keyCode);" value="${not empty under_per ? under_per : '100'}" /><em>%</em>
						</div>
						<div class="discover_list">
							<ul>
								<li><input type="checkbox" name="rank_jcr" value="Y" <%= "Y".equals(request.getParameter("rank_jcr")) ? "checked=\"checked\"" : "" %> /><span>JCR</span><em>(<%= summaryMap.getInt("jcr", 0) %>)</em></li>
								<li><input type="checkbox" name="rank_sjr" value="Y" <%= "Y".equals(request.getParameter("rank_sjr")) ? "checked=\"checked\"" : "" %> /><span>SJR</span><em>(<%= summaryMap.getInt("sjr", 0) %>)</em></li>
								<li><input type="checkbox" name="rank_cs" value="Y"  <%= "Y".equals(request.getParameter("rank_cs")) ? "checked=\"checked\"" : "" %> /><span>CiteScore</span><em>(<%= summaryMap.getInt("citescore", 0) %>)</em></li>
								<li><input type="checkbox" name="rank_kci" value="Y" <%= "Y".equals(request.getParameter("rank_kci")) ? "checked=\"checked\"" : "" %> /><span>KCI</span><em>(<%= summaryMap.getInt("kci", 0) %>)</em></li>
							</ul>
						</div>
					</div>
					<div class="option_select_box">
						<h5 class="discover_title">Listing</h5>
						<div class="discover_list">
							<ul>
								<li><input type="checkbox" name="list_sci" 	value="Y"  	 <%= "Y".equals(request.getParameter("list_sci")) ? "checked=\"checked\"" : "" %>><span>SCI</span><em>(<%= summaryMap.getInt("sci", 0) %>)</em></li>
								<li><input type="checkbox" name="list_scie" 	value="Y" 	 <%= "Y".equals(request.getParameter("list_scie")) ? "checked=\"checked\"" : "" %>><span>SCIE</span><em>(<%= summaryMap.getInt("scie", 0) %>)</em></li>
								<li><input type="checkbox" name="list_ssci" 	value="Y" 	 <%= "Y".equals(request.getParameter("list_ssci")) ? "checked=\"checked\"" : "" %>><span>SSCI</span><em>(<%= summaryMap.getInt("ssci", 0) %>)</em></li>
								<li><input type="checkbox" name="list_ahci" 	value="Y" 	 <%= "Y".equals(request.getParameter("list_ahci")) ? "checked=\"checked\"" : "" %>><span>A&amp;HCI</span><em>(<%= summaryMap.getInt("ahci", 0) %>)</em></li>
								<li><input type="checkbox" name="list_esci" 	value="Y" 	 <%= "Y".equals(request.getParameter("list_esci")) ? "checked=\"checked\"" : "" %>><span>ESCI</span><em>(<%= summaryMap.getInt("esci", 0) %>)</em></li>
								<li><input type="checkbox" name="list_cc" 		value="Y"    <%= "Y".equals(request.getParameter("list_cc")) ? "checked=\"checked\"" : "" %>><span>CC</span><em>(<%= summaryMap.getInt("cc", 0) %>)</em></li>
								<li><input type="checkbox" name="list_scopus" 	value="Y" 	 <%= "Y".equals(request.getParameter("list_scopus")) ? "checked=\"checked\"" : "" %>><span>SCOPUS</span><em>(<%= summaryMap.getInt("scopus", 0) %>)</em></li>
								<li><input type="checkbox" name="list_medline" 	value="Y"  	 <%= "Y".equals(request.getParameter("list_medline")) ? "checked=\"checked\"" : "" %>><span>MEDLINE</span><em>(<%= summaryMap.getInt("medline", 0) %>)</em></li>
								<li><input type="checkbox" name="list_doaj" 	value="Y" 	 <%= "Y".equals(request.getParameter("list_doaj")) ? "checked=\"checked\"" : "" %>><span>DOAJ</span><em>(<%= summaryMap.getInt("doaj", 0) %>)</em></li>
								<li><input type="checkbox" name="list_kci_reg" 	value="Y"  	 <%= "Y".equals(request.getParameter("list_kci_reg")) ? "checked=\"checked\"" : "" %>><span>KCI</span><em>(<%= summaryMap.getInt("kci_reg", 0) %>)</em></li>
								<li><input type="checkbox" name="list_kci_reg_can" value="Y" <%= "Y".equals(request.getParameter("list_kci_reg_can")) ? "checked=\"checked\"" : "" %>><span>KCICandidate</span><em>(<%= summaryMap.getInt("kci_reg_can", 0) %>)</em></li>
								<li><input type="checkbox" name="list_embase" 	value="Y" 	 <%= "Y".equals(request.getParameter("list_embase")) ? "checked=\"checked\"" : "" %>><span>EMBASE</span><em>(<%= summaryMap.getInt("embase", 0) %>)</em></li>
							</ul>
						</div>
					</div>
					<div class="option_select_box">
						<h5 class="discover_title">Open Access</h5>
						<div class="discover_list">
							<ul>
								<li><input type="checkbox" name="etc_oa" value="Y" <%= "Y".equals(request.getParameter("etc_oa")) ? "checked=\"checked\"" : "" %>><span>Open Access</span><em>(<%= summaryMap.getInt("oa", 0) %>)</em></li>
							</ul>
						</div>
					</div>

				</div>


				<div class="jss_rbox">

					<table style="width: 100%;">
						<tr>
							<td><div class="jss_title" style="margin-top: 6px;"><h4 class="h4_title">Selected Journals</h4><span class="round_num"><em><%= resultList.size() %></em></span></div></td>
						</tr>
					</table>

					<div class="list_line_box">
						<%
							for(HashMap2 map:resultList){
								String id = map.getString("jrnl_id");
								String publisher = map.getString("publisher");
								String isOA = "Y".equals(map.getString("is_oa")) ? "Y" : "N";
								String issn = map.getString("issn_1");
								String title = map.getString("title");
						%>
						<div class="inter_search_box">
							<dl>
								<dt>
									<span id="<%= map.get("jrnl_id") %>" class='favorite_star
										<%
											if(favoriteItem.contains((String)map.get("jrnl_id"))){
										%>
												star_fill
										<%
											} else {
										%>
												star_empty
										<%
											}
										%>
									' style="margin-left: 5px; top: 8px;" onclick='editFavorite("<%= id %>", "<%= publisher %>","<%= isOA %>","<%= issn %>","<%= title %>")'></span>
									<a href="javascript:viewDetail('<%= map.get("jrnl_id") %>');"><%= map.get("title") %></a>
									<% if("Y".equals(map.get("is_oa"))){ %>
									<img src="<c:url value="/share/img/icon/oa_icon.png"/>" width="10px" style="position: relative; top:1px;">
									<% } %>
								</dt>
								<dd><span class="publisher_text"><%= map.getString("publisher") %></span><%= changeIssn(map.getString("issn_1")) %></dd>
								<dd>
										<%= "Y".equals(map.get("IS_JCR")) ? "JCR<em>(Ranking)</em>" : "" %>
										<%= "Y".equals(map.get("IS_SJR")) ? "SJR<em>(Ranking)</em>" : "" %>
										<%= "Y".equals(map.get("IS_CiteScore")) ? "CiteScore<em>(Ranking)</em>" : "" %>
										<%= "Y".equals(map.get("IS_KCI")) ? "KCI<em>(Ranking)</em>" : "" %>
										<%= "Y".equals(map.get("IS_SCI")) ? "SCI<em>(Master)</em>" : "" %>
										<%= "Y".equals(map.get("IS_SCIE")) ? "SCIE<em>(Master)</em>" : "" %>
										<%= "Y".equals(map.get("IS_SSCI")) ? "SSCI<em>(Master)</em>" : "" %>
										<%= "Y".equals(map.get("IS_A&HCI")) ? "A&amp;HCI<em>(Master)</em>" : "" %>
										<%= "Y".equals(map.get("IS_ESCI")) ? "ESCI<em>(Master)</em>" : "" %>
										<%= "Y".equals(map.get("IS_CC")) ? "CC<em>(Master)</em>" : "" %>
										<%= "Y".equals(map.get("IS_MEDLINE")) ? "MEDLINE<em>(Master)</em>" : "" %>
										<%= "Y".equals(map.get("IS_DOAJ")) ? "DOAJ<em>(Master)</em>" : "" %>
										<%= "Y".equals(map.get("IS_KCI_REG")) ? "KCI<em>(Master)</em>" : "" %>
										<%= "Y".equals(map.get("IS_KCI_REG_CAN")) ? "KCI Candidate<em>(Master)</em>" : "" %>
										<%= "Y".equals(map.get("IS_EMBASE")) ? "EMBASE<em>(Master)</em>" : "" %>
										<%= "Y".equals(map.get("IS_SCOPUS")) ? "SCOPUS<em>(Master)</em>" : "" %>
							</dl>
							<p class="line_num"><%= map.getString("score") %></p>
						</div>
						<%
							}
						%>

						<%
							if(resultList.size() == 0){
						%>

						<div class="inter_search_box">
							<dl>
								<dt>
									No Results.
								</dt>
							</dl>
						</div>
						<%
							}
						%>

					</div>
				</div>

			</div>
		</div>
		<%
			}
		%>

		<a id="toTop" href="#">상단으로 이동</a>
	</div>
</form>








<!-- sub_container : e -->

<div id="loadImgDiv" class="loadImg defaultNone" style="position: absolute; display: none;"><img src="<c:url value="/images/analysis/common/ajax-loader.gif"/>" /></div>
<div id="loadImgDiv2" style="position: absolute; width: 100%; height: 100%; background-color: #ddd; top: 0px; left: 0px; z-index: 0; opacity: 0.7; display: none;"></div>

</body>