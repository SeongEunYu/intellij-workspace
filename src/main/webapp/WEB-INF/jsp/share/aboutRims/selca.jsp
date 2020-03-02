<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@include file="../pageInit.jsp" %>
<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta http-equiv="cache-Control" content="co-cache" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=yes" />
	<title>RIMS Discovery</title>
	<style type="text/css">
div, dl, dt, dd, ul, ol, menu, li, h1, h2, h3, h4, h5, h6, pre, form, fieldset, input, textarea, blockquote, th, td, p { margin: 0px; padding: 0px; }
ol,ul,menu { list-style: none; }
.one_layout {  width:1200px; margin:0 auto;  padding-bottom: 40px;}
.one_layout  h3 { font-weight: normal; font-size: 20px; margin-bottom: 22px;color: #222; }
.ol_inner { background: #fff; border-top: 2px solid #4c5356;  }

.selca_text { font-style: italic;}
.selca_text em{ color: #e84c4c; font-style: normal;}

.about_wrap { padding: 22px 30px 40px 30px;}
.about_title { padding: 0 0 0 17px;  background: url(<c:url value="/share/img/background/about_bullet.png"/>) no-repeat 0 2px;  font-size: 20px;font-weight: bold;margin-bottom: 28px;}
.about_title .selca_text { font-weight: bold;}
.about_text { font-size: 16px;  line-height: 28px;}

.about_box01 { margin-bottom: 42px;  padding: 0px 0px 0px 0px;  }
.mgb_10 { margin-bottom:10px !important;}
.mgb_20 { margin-bottom:20px !important;}

.about_row_wrap { }
.about_row_wrap  .col-md-4 { padding: 0 23px;}
.about_row_box {  overflow: hidden; }
.about_row_box h5 {    width: 156px;border-top: 1px solid #1762ad;background: url(<c:url value="/share/img/background/selca_icon01.png"/>) no-repeat 18px 30px;padding: 46px 0 0 114px;float: left; height: 80px;   font-size: 20px;font-weight: bold;  margin-bottom: 12px; }
.about_row_box .ar_t  {  line-height: 28px; font-size: 15px;  margin: 45px 0 0 300px;}
.about_row_box .ar_type01  {  margin: 32px 0 0 300px;}
.about_row_box .ar_type02  {  margin: 14px 0 0 300px;}

.about_line02 h5{  background: url(<c:url value="/share/img/background/selca_icon02.png"/>) no-repeat 18px 30px;  border-top:1px solid #688fd0;  }
.about_line03 h5{  background: url(<c:url value="/share/img/background/selca_icon03.png"/>) no-repeat 18px 30px;  border-top:1px solid #e54d8e;  }
.about_line04 h5{  background: url(<c:url value="/share/img/background/selca_icon04.png"/>) no-repeat 18px 30px; border-top:1px solid #ffb27f;   }
.about_line05 h5{  background: url(<c:url value="/share/img/background/selca_icon05.png"/>) no-repeat 18px 30px; border-top:1px solid #e574b1;   }

.bar_ul{ padding: 4px 0 0 14px}
.bar_ul li {   margin-bottom: 4px; }
.bar_ul li:last-child  {  margin-bottom: 0px; }

.result_title {
    font-size: 18px;
    margin-bottom: 0px;
    font-weight: bold;
}
.language_r_box a {
    display: inline-block;
    font-size: 12px;
    line-height: 23px;
    padding: 0 16px;
    border-radius: 16px;
    text-decoration: none;
    background: #4e5558 !important;
    color: #fff !important;
    border: 1px solid #4e5558;
    float: right;
    position: relative;
    top: -43px;
}
.language_r_box  {
    position: static;
}

	</style>
</head>
<body>

<%--
<div class="one_layout" style="margin-top: 40px;">
	<h3><span class="selca_text">Sel<em>CA</em></span> <spring:message code="disc.about.selca.title"/></h3>
	<div class="language_r_box">
		<a href="https://rims.kaist.ac.kr/selca/" target="_blank"><spring:message code="disc.about.selca.direct"/></a>
	</div>
	<div class="ol_inner">
		<div class="about_wrap">
			<div class="about_box01">
				<h4 class="about_title"><span class="selca_text">Sel<em>CA</em></span>란?</h4>
				<div class="about_text mgb_20">SelCA는 이용자가 직접 기관별 비교대상 논문 데이터를 업로드하여 입력된 데이터를 기반으로 다양한 분석정보를 제공하는 시스템이며<br/>기관종합, 기관상세, 연구자별로 분석결과를 확인 가능</div>
			</div>
			<div class="about_row_wrap">
				<div class="about_row_box">
					<h5 style="color:black;width: 270px;height: 127px;">파일 반입</h5>
					<div class="ar_t ar_type01">데이터 소스는 Web of Science(WOS)에서 반출한 데이터를 업로드 했을 때 가장 정확한 비교 분석이 가능하며,<br/>그 외 자료는 데이터 필드에 따라 제한적인 비교 분석이 가능</div>
				</div>
				<div class="about_row_box about_line02">
					<h5 style="color:black;width: 270px;height: 127px;">파일 유형</h5>
					<div class="ar_t ar_type02">
						<ul>
							<li>1) WOS 반출데이터 : 텍스트(탭으로 구분된 방식), Excel</li>
							<li>2) SCOPUS 반출 데이터 : CVS</li>
							<li>3) RIMS 반출데이터: Excel</li>
							<li>4) 개인 파일: Excel (출판년도, ISSN, 논문명, 저널명 필수)</li>
						</ul>
					</div>
				</div>
				<div class="about_row_box about_line03">
					<h5 style="color:black;width: 270px;height: 127px;">저널 매핑하기</h5>
					<div class="ar_t">반입된 논문정보를 기준으로 저널 등재구분, IF, SJR 등 다양한 지수정보 추출 및 매핑</div>
				</div>
				<div class="about_row_box about_line04">
					<h5 style="color:black;width: 270px;height: 127px;">IF 매핑기준</h5>
					<div class="ar_t ar_type02">IF는 논문의 출판년도 기준 또는 최신 Edition 기준 중 선택하여 사용 가능
						<ul class="bar_ul mgb_10">
							<li>1) 출판년도 : 논문의 출판년도와 동일한 연도의 IF 값(IF 값 변동 없음)</li>
							<li>2) 최신년도 : 가장 최신 IF 값을 적용(IF 값은 해마다 변경됨)</li>
							<li>※ 출판년도 IF 미제공시 가장 최신년도 IF값으로 적용됨.</li>
						</ul>
					</div>

				</div>
				<div class="about_row_box about_line05">
					<h5 style="color:black;width: 270px;height: 127px;">분석 실행하기</h5>
					<div class="ar_t">다양한 지수정보가 포함된 논문 데이터를 엑셀파일로 반출 가능하며, 기관종합, 기관상세, 연구자별로 분석이 진행됨</div>
				</div>
			</div>
		</div>
	</div>
</div><!-- one_layout : e -->
--%>

<div class="sub_container">
	<h3 class="result_title"><span class="selca_text">Sel<em>CA</em></span> <spring:message code="disc.about.selca.title"/></h3>
	<div class="about_top_wrap">
		<div class="language_r_box">
			<a href="https://rims.kaist.ac.kr/selca/" target="_blank"><spring:message code="disc.about.selca.direct"/></a>
		</div>
		<div class="selca_info_top">
			<h4><span class="selca_text">Sel<em>CA</em></span> 란?</h4>
			<p>SelCA는 이용자가 직접 기관별 비교대상 논문 데이터를 업로드하여 입력된 데이터를 기반으로 다양한 분석정보를 제공하는 시스템이며
				기관종합, 기관상세, 연구자별로 분석결과를 확인 가능</p>
		</div>
		<div class="selca_t_box">
			<dl>
				<dt>파일 반입</dt>
				<dd>데이터 소스는 Web of Science(WOS)에서 반출한 데이터를 업로드 했을 때 가장 정확한 비교 분석이 가능하며, 그 외 자료는 데이터 필드에 따라 제한적인 비교 분석이 가능</dd>
			</dl>
		</div>
		<div class="selca_t_box">
			<dl>
				<dt class="selca_dt_icon02">파일 유형</dt>
				<dd>
					<ol class="as_list">
						<li>1) WOS 반출데이터 : 텍스트(탭으로 구분된 방식), Excel</li>
						<li>2) SCOPUS 반출 데이터 : CVS</li>
						<li>3) RIMS 반출데이터: Excel</li>
						<li>4) 개인 파일: Excel (출판년도, ISSN, 논문명, 저널명 필수)</li>

					</ol>
				</dd>
			</dl>
		</div>
		<div class="selca_t_box">
			<dl>
				<dt class="selca_dt_icon03">저널 매핑하기</dt>
				<dd>반입된 논문정보를 기준으로 저널 등재구분, IF, SJR 등 다양한 지수정보 추출 및 매핑</dd>
			</dl>
		</div>
		<div class="selca_t_box">
			<dl>
				<dt class="selca_dt_icon04">IF 매핑기준</dt>
				<dd>IF는 논문의 출판년도 기준 또는 최신 Edition 기준 중 선택하여 사용 가능
					<ul class="as_list">
						<li>1) 출판년도 : 논문의 출판년도와 동일한 연도의 IF 값(IF 값 변동 없음)</li>
						<li>2) 최신년도 : 가장 최신 IF 값을 적용(IF 값은 해마다 변경됨)</li>
					</ul>
					<p class="l_arrow_p">출판년도 IF 미제공시 가장 최신년도 IF값으로 적용됨.</p>
				</dd>
			</dl>
		</div>
		<div class="selca_t_box">
			<dl>
				<dt class="selca_dt_icon05">분석 실행하기</dt>
				<dd>다양한 지수정보가 포함된 논문 데이터를 엑셀파일로 반출 가능하며, 기관종합, 기관상세, 연구자별로 분석이 진행됨</dd>
			</dl>
		</div>
	</div><!-- about_top_wrap : e   -->
</div>
</body>