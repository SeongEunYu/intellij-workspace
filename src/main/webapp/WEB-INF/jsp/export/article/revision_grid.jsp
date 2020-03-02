<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../gridInit.jsp" %>
<rows total_count="${totalCount}" pos="${posStart}">
	<c:if test="${not empty revisionList}">
		<c:forEach items="${revisionList}" var="al" varStatus="st">
			<row id="${fn:escapeXml(al.resultId)}">
					<cell>${fn:escapeXml(al.status)}</cell>
					<cell>${fn:escapeXml(al.wosIdntfcNo)}</cell>
					<cell>${fn:escapeXml(al.scpIdntfcNo)}</cell>
					<cell>${fn:escapeXml(al.kciIdntfcNo)}</cell>
					<cell>${fn:escapeXml(al.perno)}</cell>
					<cell>${fn:escapeXml(al.nameKor)}</cell>
					<cell>${fn:escapeXml(al.nameEng)}</cell>
					<cell>${fn:escapeXml(al.dept)}</cell>
					<cell>${fn:escapeXml(al.articleTtl)}</cell>
					<cell>${fn:escapeXml(al.plscmpnNm)}</cell>
					<cell>${fn:escapeXml(al.ry)}</cell>
					<cell>${fn:escapeXml(al.pblcateYear)}</cell>
					<cell>${fn:escapeXml(al.pblcateDate)}</cell>
					<cell>${fn:escapeXml(al.vlm)}</cell>
					<cell>${fn:escapeXml(al.issue)}</cell>
					<cell>${fn:escapeXml(al.beginPage)}</cell>
					<cell>${fn:escapeXml(al.endPage)}</cell>
					<cell>${fn:escapeXml(al.doi)}</cell>
					<cell>${fn:escapeXml(al.issn)}</cell>
					<cell>${fn:escapeXml(al.pblshrNm)}</cell>
					<cell>${fn:escapeXml(al.pblshrCity)}</cell>
					<cell>${fn:escapeXml(al.lang)}</cell>
					<cell>${fn:escapeXml(al.authrNm)}</cell>
					<cell>${fn:escapeXml(al.isscie)}</cell>
					<cell>${fn:escapeXml(al.issci)}</cell>
					<cell>${fn:escapeXml(al.isssci)}</cell>
					<cell>${fn:escapeXml(al.isahci)}</cell>
					<cell>${fn:escapeXml(al.isscopus)}</cell>
					<cell>${fn:escapeXml(al.iskci)}</cell>
					<cell>${fn:escapeXml(al.isetc)}</cell>
					<cell>${fn:escapeXml(al.autone)}</cell>
					<cell>${fn:escapeXml(al.autmain)}</cell>
					<cell>${fn:escapeXml(al.autcr)}</cell>
					<cell>${fn:escapeXml(al.autco)}</cell>
					<cell>${fn:escapeXml(al.docType)}</cell>
					<cell>${fn:escapeXml(al.rpntAdres)}</cell>
					<cell>${fn:escapeXml(al.emailAdres)}</cell>
					<cell></cell>
				</row>
		</c:forEach>
	</c:if>
</rows>