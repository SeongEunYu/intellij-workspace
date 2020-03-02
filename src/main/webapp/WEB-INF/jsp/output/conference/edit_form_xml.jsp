<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../pageInit.jsp" %>
<items>
	<item type="settings" position="label-top" offsetLeft="25" offsetTop="3"/>

	<item type="block" inputWidth="auto" offsetLeft="0" offsetTop="8">
		<item type="hidden" name="articleId" label="논문제어번호" value="${article.articleId}"/>
		<item type="input" name="orgLangPprNm" label="논문명(원어)" value="${fn:escapeXml(article.orgLangPprNm)}" rows="2" inputWidth="850" required="true" />
	</item>

	<item type="block" inputWidth="auto" offsetLeft="0" offsetTop="8">
		<item type="input" name="scjnlNm" label="저널명" value="${fn:escapeXml(article.scjnlNm)}" inputWidth="825"  required="true" info="true" tooltip="논문이 게재된 학술지명을 검색을 통해 입력. 학술지명을 검색하여 입력하는 경우 ISSN, 출판사, 발행국 정보가 함께 입력됨">
			<userdata name="info">논문이 게재된 학술지명을 검색을 통해 입력. 학술지명을 검색하여 입력하는 경우 ISSN, 출판사, 발행국 정보가 함께 입력됨</userdata>
		</item>
		<item type="newcolumn"/>
		<item type="button" name="findJournalMaster" label="" value="" className="button_save" inputWidth="16" inputHeight="16" offsetLeft="0" offsetTop="32"/>
	</item>

	<item type="block" inputWidth="auto" offsetLeft="0" offsetTop="8">
		<item type="input" name="pblcYm" label="게재년월" value="${fn:escapeXml(article.pblcYm)}"  inputWidth="150"  required="true">
			<note>ex) 2015년 7월  → 201507</note>
		</item>
		<item type="newcolumn"/>
		<item type="input" name="volume" label="게재권집" value="${fn:escapeXml(article.volume)}"  inputWidth="150" info="true">
			<note>ex) vol.10 → 10</note>
			<userdata name="info"><![CDATA[ Volume 10, No 2와 같은 경우 '10'을 입력, 제 5권, 4호와 같은 경우 '5'를 입력하십시오.]]></userdata>
		</item>
		<item type="newcolumn"/>
		<item type="input" name="issue" label="게재호" value="${fn:escapeXml(article.issue)}"  inputWidth="150">
			<note>ex) no.4 → 4</note>
		</item>
		<item type="newcolumn"/>
		<item type="input" name="sttPage" label="시작페이지" value="${article.sttPage}"  inputWidth="150" info="true">
			<userdata name="info"><![CDATA[ 저널에 게재된 시작페이지를 입력하십시오.]]></userdata>
		</item>
		<item type="newcolumn"/>
		<item type="input" name="endPage" label="끝페이지" value="${article.endPage}"  inputWidth="150" info="true">
			<userdata name="info"><![CDATA[ 저널에 게재된 끝페이지를 입력하십시오.]]></userdata>
		</item>
	</item>

	<item type="block" inputWidth="auto" offsetLeft="0" offsetTop="8">
		<item type="hidden" name="totalAthrCnt" label="전체저자수" value="${article.totalAthrCnt}"/>
		<item type="container" name="authorGrid"  label="저자" inputWidth="848" inputHeight="140"  required="true" info="true">
			<userdata name="info"><![CDATA[- 저자명(ABBR.): “성, 이니셜” 형태로 기입  ex) Hong, GD <br/>- 저자명(FULL): “성, 이름” 형태로 기입 ex) Hong, Gil Dong <br/>* (${instAbrv} 소속으로 저술한 논문이면 ‘실적여부’에 반드시 체크해주세요.)]]></userdata>
		</item>
	</item>

	<item type="block" inputWidth="auto" offsetLeft="0" offsetTop="8">
		<item type="container" name="fileVault"  label="원문파일" inputWidth="848" inputHeight="120"/>
	</item>

	<item type="block" inputWidth="auto" offsetLeft="0" offsetTop="8">
		<item type="select" name="scjnlDvsCd" label="저널구분" value="${article.scjnlDvsCd}" inputWidth="150">
			${rims:makeCodeList('1100',true,'')}
		</item>
		<item type="newcolumn"/>
		<item type="select" name="ovrsExclncScjnlPblcYn" label="SCI구분" value="${article.ovrsExclncScjnlPblcYn}" inputWidth="150">
			${rims:makeCodeList('1380',true,'')}
		</item>
		<item type="newcolumn"/>
		<item type="select" name="docTypeCd" label="문서유형" value="${article.docTypeCd}" inputWidth="150">
			${rims:makeCodeList('4001',true,'')}
		</item>
		<item type="newcolumn"/>
		<item type="select" name="pprLangDvsCd" label="발행언어" value="${article.pprLangDvsCd}" inputWidth="150">
			${rims:makeCodeList('2020',true,'')}
		</item>
		<item type="newcolumn"/>
		<item type="input" name="issnNo" label="ISSN번호" value="${article.issnNo}"  inputWidth="150" />
	</item>

	<item type="block" inputWidth="auto" offsetLeft="0" offsetTop="8">
		<item type="input" name="pblcPlcNm" label="발행처(출판사)" value="${fn:escapeXml(article.pblcPlcNm)}"  inputWidth="325" />
		<item type="newcolumn"/>
		<item type="select" name="pblcNtnCd" label="발행국" value="${article.pblcNtnCd}" inputWidth="150">
			${rims:makeCodeList('2000',true,'')}
		</item>
		<item type="newcolumn"/>
		<item type="input" name="impctFctr" label="Impact Factor(최신)" value="${article.impctFctr}"  inputWidth="150" />
		<item type="newcolumn"/>
		<item type="input" name="impctFctrUsrYear" label="Impact Factor(출판년)" value="${article.impctFctrUsrYear}"  inputWidth="150" />
	</item>

	<item type="block" inputWidth="auto" offsetLeft="0" offsetTop="8">
		<item type="input" name="diffLangPprNm" label="논문명(타언어)" value="${fn:escapeXml(article.diffLangPprNm)}"  rows="1" inputWidth="850" />
	</item>

	<item type="block" inputWidth="auto" offsetLeft="0" offsetTop="8">
		<item type="input" name="rsrchacpsStdySpheValue" label="연구학문분야" value="${article.rsrchacpsStdySpheValue}" inputWidth="150" />
		<item type="hidden" name="rsrchacpsStdySpheCd" label="연구학문분야코드" value="${article.rsrchacpsStdySpheCd}"/>
		<item type="newcolumn"/>
		<item type="input" name="keywords" label="키워드" value="${fn:escapeXml(article.keywords)}" inputWidth="675" />
	</item>

	<item type="block" inputWidth="auto" offsetLeft="0" offsetTop="8">
		<item type="input" name="idSci" label="WOS ID" value="${article.idSci}" inputWidth="200" />
		<item type="newcolumn"/>
		<item type="input" name="tc" label="WOS Times Cited" value="${article.tc}" inputWidth="150" readonly="true" >
			<fmt:formatDate var="tcFmtDate" value="${article.tcDate}" pattern="yyyy-MM-dd" />
			<note>updated : ${tcFmtDate}</note>
		</item>
		<item type="newcolumn"/>
		<item type="input" name="idScopus" label="SCOPUS ID" value="${article.idScopus}" inputWidth="200" />
		<item type="newcolumn"/>
		<item type="input" name="scpTc" label="SCOPUS Times Cited" value="${article.scpTc}" inputWidth="150" readonly="true" >
			<fmt:formatDate var="scpFmtDate" value="${article.scpTcDate}" pattern="yyyy-MM-dd" />
			<note>updated: ${scpFmtDate}</note>
		</item>
	</item>

	<item type="block" inputWidth="auto" offsetLeft="0" offsetTop="8">
		<item type="input" name="doi" label="DOI" value="${fn:escapeXml(article.doi)}" inputWidth="325" />
		<item type="newcolumn"/>
		<item type="input" name="url" label="URL" value="${fn:escapeXml(article.url)}" inputWidth="500" />
	</item>

	<item type="block" inputWidth="auto" offsetLeft="0" offsetTop="8">
		<item type="input" name="abstCntn" label="초록" value="${fn:escapeXml(article.abstCntn)}"  rows="5" inputWidth="850" />
	</item>

	<item type="block" inputWidth="auto" offsetLeft="0" offsetTop="8">
		<fmt:formatDate var="regFrmtDate" value="${article.regDate}" pattern="yyyy-MM-dd" />
		<item type="template" name="regDateAndRegUser" label="최초입력일" value="${regFrmtDate}(${empty article.regUserNm ? article.regUserId : article.regUserNm})" inputWidth="200" />
		<item type="newcolumn"/>
		<fmt:formatDate var="modFrmtDate" value="${article.modDate}" pattern="yyyy-MM-dd" />
		<item type="template" name="modDateAndModUser" label="최종수정일" value="${modFrmtDate}(${empty article.modUserNm ? article.modUserId : article.modUserNm})" inputWidth="200" />
	</item>

</items>