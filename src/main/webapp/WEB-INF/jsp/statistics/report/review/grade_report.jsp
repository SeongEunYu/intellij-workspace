<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../../gridInit.jsp"%>
<table class="table_layout">
	<colgroup>
		<col/>
		<col/>
		<col/>
		<col style="width: 9%;"/>
		<col style="width: 9%;"/>
		<col style="width: 9%;"/>
		<col style="width: 9%;"/>
		<col style="width: 9%;"/>
		<col style="width: 9%;"/>
		<col style="width: 9%;"/>
		<col style="width: 9%;"/>
	</colgroup>
	<thead>
	<tr>
		<th colspan="3" rowspan="2" style="border-left: 0;"><spring:message code='stats.report.integ.division'/></th>
		<th colspan="2"><spring:message code='stats.report.integ.assistant'/></th>
		<th colspan="2"><spring:message code='stats.report.integ.associate'/></th>
		<th colspan="2"><spring:message code='stats.report.integ.professor'/></th>
		<th colspan="2" style="border-right: 0;"><spring:message code='stats.report.integ.total'/></th>
	</tr>
	<tr>
		<th><spring:message code='stats.report.integ.otherorg'/></th>
		<th>CAU</th>
		<th><spring:message code='stats.report.integ.otherorg'/></th>
		<th>CAU</th>
		<th><spring:message code='stats.report.integ.otherorg'/></th>
		<th>CAU</th>
		<th><spring:message code='stats.report.integ.otherorg'/></th>
		<th style="border-right: 0;">CAU</th>
	</tr>
	</thead>
	<tbody>
	<tr>
		<th rowspan="6" style="border-left: 0;"><spring:message code='stats.report.integ.intl'/></th>
		<th rowspan="3"><spring:message code='stats.report.integ.intl.sci'/></th>
		<th><spring:message code='stats.report.integ.firstauthor'/></th>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${articleReport.ASSISTANT2 }" /></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${articleReport.ASSISTANT1 }" /></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${articleReport.ASSOCIATE2 }" /></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${articleReport.ASSOCIATE1 }" /></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${articleReport.PROFESSOR2 }" /></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${articleReport.PROFESSOR1 }" /></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${articleReport.ASSISTANT2+articleReport.ASSOCIATE2+articleReport.PROFESSOR2 }" /></td>
		<td style="text-align: right;padding: 0 5px;border-right: 0;"><c:out value="${articleReport.ASSISTANT1+articleReport.ASSOCIATE1+articleReport.PROFESSOR1 }" /></td>
	</tr>
	<tr>
		<th><spring:message code='stats.report.integ.coauthor'/></th>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${articleReport.ASSISTANT4 }" /></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${articleReport.ASSISTANT3 }" /></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${articleReport.ASSOCIATE4 }" /></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${articleReport.ASSOCIATE3 }" /></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${articleReport.PROFESSOR4 }" /></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${articleReport.PROFESSOR3 }" /></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${articleReport.ASSISTANT4+articleReport.ASSOCIATE4+articleReport.PROFESSOR4 }" /></td>
		<td style="text-align: right;padding: 0 5px;border-right: 0;"><c:out value="${articleReport.ASSISTANT3+articleReport.ASSOCIATE3+articleReport.PROFESSOR3 }" /></td>
	</tr>
	<tr>
		<th><spring:message code='stats.report.integ.sum'/></th>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${articleReport.ASSISTANT2+articleReport.ASSISTANT4 }" /></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${articleReport.ASSISTANT1+articleReport.ASSISTANT3 }" /></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${articleReport.ASSOCIATE2+articleReport.ASSOCIATE4 }" /></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${articleReport.ASSOCIATE1+articleReport.ASSOCIATE3 }" /></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${articleReport.PROFESSOR2+articleReport.PROFESSOR4 }" /></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${articleReport.PROFESSOR1+articleReport.PROFESSOR3 }" /></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${articleReport.ASSISTANT2+articleReport.ASSOCIATE2+articleReport.PROFESSOR2+articleReport.ASSISTANT4+articleReport.ASSOCIATE4+articleReport.PROFESSOR4 }" /></td>
		<td style="text-align: right;padding: 0 5px;border-right: 0;"><c:out value="${articleReport.ASSISTANT1+articleReport.ASSOCIATE1+articleReport.PROFESSOR1+articleReport.ASSISTANT3+articleReport.ASSOCIATE3+articleReport.PROFESSOR3 }" /></td>
	</tr>
	<tr>
		<th rowspan="3"><spring:message code='stats.report.integ.intl.other'/></th>
		<th><spring:message code='stats.report.integ.firstauthor'/></th>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${articleReport.ASSISTANT6 }" /></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${articleReport.ASSISTANT5 }" /></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${articleReport.ASSOCIATE6 }" /></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${articleReport.ASSOCIATE5 }" /></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${articleReport.PROFESSOR6 }" /></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${articleReport.PROFESSOR5 }" /></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${articleReport.ASSISTANT6+articleReport.ASSOCIATE6+articleReport.PROFESSOR6 }" /></td>
		<td style="text-align: right;padding: 0 5px;border-right: 0;"><c:out value="${articleReport.ASSISTANT5+articleReport.ASSOCIATE5+articleReport.PROFESSOR5 }" /></td>
	</tr>
	<tr>
		<th><spring:message code='stats.report.integ.coauthor'/></th>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${articleReport.ASSISTANT8 }" /></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${articleReport.ASSISTANT7 }" /></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${articleReport.ASSOCIATE8 }" /></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${articleReport.ASSOCIATE7 }" /></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${articleReport.PROFESSOR8 }" /></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${articleReport.PROFESSOR7 }" /></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${articleReport.ASSISTANT8+articleReport.ASSOCIATE8+articleReport.PROFESSOR8 }" /></td>
		<td style="text-align: right;padding: 0 5px;border-right: 0;"><c:out value="${articleReport.ASSISTANT7+articleReport.ASSOCIATE7+articleReport.PROFESSOR7 }" /></td>
	</tr>
	<tr>
		<th><spring:message code='stats.report.integ.sum'/></th>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${articleReport.ASSISTANT6+articleReport.ASSISTANT8 }" /></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${articleReport.ASSISTANT5+articleReport.ASSISTANT7 }" /></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${articleReport.ASSOCIATE6+articleReport.ASSOCIATE8 }" /></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${articleReport.ASSOCIATE5+articleReport.ASSOCIATE7 }" /></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${articleReport.PROFESSOR6+articleReport.PROFESSOR8 }" /></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${articleReport.PROFESSOR5+articleReport.PROFESSOR7 }" /></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${articleReport.ASSISTANT6+articleReport.ASSOCIATE6+articleReport.PROFESSOR6+articleReport.ASSISTANT8+articleReport.ASSOCIATE8+articleReport.PROFESSOR8 }" /></td>
		<td style="text-align: right;padding: 0 5px;border-right: 0;"><c:out value="${articleReport.ASSISTANT5+articleReport.ASSOCIATE5+articleReport.PROFESSOR5+articleReport.ASSISTANT7+articleReport.ASSOCIATE7+articleReport.PROFESSOR7 }" /></td>
	</tr>
	<tr>
		<th colspan="2" rowspan="3" style="border-left: 0;"><spring:message code='stats.report.integ.conference.intl'/></th>
		<th><spring:message code='stats.report.integ.firstauthor'/></th>
		<td style="text-align: right;padding: 0 5px;"></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${conferenceReport.ASSISTANT1 }" /></td>
		<td style="text-align: right;padding: 0 5px;"></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${conferenceReport.ASSOCIATE1 }" /></td>
		<td style="text-align: right;padding: 0 5px;"></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${conferenceReport.PROFESSOR1 }" /></td>
		<td style="text-align: right;padding: 0 5px;"></td>
		<td style="text-align: right;padding: 0 5px;border-right: 0;"><c:out value="${conferenceReport.ASSISTANT1+conferenceReport.ASSOCIATE1+conferenceReport.PROFESSOR1 }" /></td>
	</tr>
	<tr>
		<th><spring:message code='stats.report.integ.coauthor'/></th>
		<td style="text-align: right;padding: 0 5px;"></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${conferenceReport.ASSISTANT2 }" /></td>
		<td style="text-align: right;padding: 0 5px;"></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${conferenceReport.ASSOCIATE2 }" /></td>
		<td style="text-align: right;padding: 0 5px;"></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${conferenceReport.PROFESSOR2 }" /></td>
		<td style="text-align: right;padding: 0 5px;"></td>
		<td style="text-align: right;padding: 0 5px;border-right: 0;"><c:out value="${conferenceReport.ASSISTANT2+conferenceReport.ASSOCIATE2+conferenceReport.PROFESSOR2 }" /></td>
	</tr>
	<tr>
		<th><spring:message code='stats.report.integ.sum'/></th>
		<td style="text-align: right;padding: 0 5px;"></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${conferenceReport.ASSISTANT1+conferenceReport.ASSISTANT2 }" /></td>
		<td style="text-align: right;padding: 0 5px;"></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${conferenceReport.ASSOCIATE1+conferenceReport.ASSOCIATE2 }" /></td>
		<td style="text-align: right;padding: 0 5px;"></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${conferenceReport.PROFESSOR1+conferenceReport.PROFESSOR2 }" /></td>
		<td style="text-align: right;padding: 0 5px;"></td>
		<td style="text-align: right;padding: 0 5px;border-right: 0;"><c:out value="${conferenceReport.ASSISTANT1+conferenceReport.ASSISTANT2+conferenceReport.ASSOCIATE1+conferenceReport.ASSOCIATE2+conferenceReport.PROFESSOR1+conferenceReport.PROFESSOR2 }" /></td>
	</tr>
	<tr>
		<th rowspan="3" style="border-left: 0;"><spring:message code='stats.report.integ.patent'/></th>
		<th colspan="2"><spring:message code='stats.report.integ.patent.intl'/></th>
		<td style="text-align: right;padding: 0 5px;"></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${patentReport.ASSISTANT2 }" /></td>
		<td style="text-align: right;padding: 0 5px;"></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${patentReport.ASSOCIATE2 }" /></td>
		<td style="text-align: right;padding: 0 5px;"></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${patentReport.PROFESSOR2 }" /></td>
		<td style="text-align: right;padding: 0 5px;"></td>
		<td style="text-align: right;padding: 0 5px;border-right: 0;"><c:out value="${patentReport.ASSISTANT2+patentReport.ASSOCIATE2+patentReport.PROFESSOR2 }" /></td>
	</tr>
	<tr>
		<th colspan="2"><spring:message code='stats.report.integ.patent.dmst'/></th>
		<td style="text-align: right;padding: 0 5px;"></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${patentReport.ASSISTANT1 }" /></td>
		<td style="text-align: right;padding: 0 5px;"></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${patentReport.ASSOCIATE1 }" /></td>
		<td style="text-align: right;padding: 0 5px;"></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${patentReport.PROFESSOR1 }" /></td>
		<td style="text-align: right;padding: 0 5px;"></td>
		<td style="text-align: right;padding: 0 5px;border-right: 0;"><c:out value="${patentReport.ASSISTANT1+patentReport.ASSOCIATE1+patentReport.PROFESSOR1 }" /></td>
	</tr>
	<tr>
		<th colspan="2"><spring:message code='stats.report.integ.sum'/></th>
		<td style="text-align: right;padding: 0 5px;"></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${patentReport.ASSISTANT1+patentReport.ASSISTANT2 }" /></td>
		<td style="text-align: right;padding: 0 5px;"></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${patentReport.ASSOCIATE1+patentReport.ASSOCIATE2 }" /></td>
		<td style="text-align: right;padding: 0 5px;"></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${patentReport.PROFESSOR1+patentReport.PROFESSOR2 }" /></td>
		<td style="text-align: right;padding: 0 5px;"></td>
		<td style="text-align: right;padding: 0 5px;border-right: 0;"><c:out value="${patentReport.ASSISTANT1+patentReport.ASSISTANT2+patentReport.ASSOCIATE1+patentReport.ASSOCIATE2+patentReport.PROFESSOR1+patentReport.PROFESSOR2 }" /></td>
	</tr>
	<tr>
		<th rowspan="3" style="border-left: 0;"><spring:message code='stats.report.integ.book'/></th>
		<th colspan="2"><spring:message code='stats.report.integ.book.intl'/></th>
		<td style="text-align: right;padding: 0 5px;"></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${bookReport.ASSISTANT2 }" /></td>
		<td style="text-align: right;padding: 0 5px;"></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${bookReport.ASSOCIATE2 }" /></td>
		<td style="text-align: right;padding: 0 5px;"></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${bookReport.PROFESSOR2 }" /></td>
		<td style="text-align: right;padding: 0 5px;"></td>
		<td style="text-align: right;padding: 0 5px;border-right: 0;"><c:out value="${bookReport.ASSISTANT2+bookReport.ASSOCIATE2+bookReport.PROFESSOR2 }" /></td>
	</tr>
	<tr>
		<th colspan="2"><spring:message code='stats.report.integ.book.dmst'/></th>
		<td style="text-align: right;padding: 0 5px;"></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${bookReport.ASSISTANT1 }" /></td>
		<td style="text-align: right;padding: 0 5px;"></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${bookReport.ASSOCIATE1 }" /></td>
		<td style="text-align: right;padding: 0 5px;"></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${bookReport.PROFESSOR1 }" /></td>
		<td style="text-align: right;padding: 0 5px;"></td>
		<td style="text-align: right;padding: 0 5px;border-right: 0;"><c:out value="${bookReport.ASSISTANT1+bookReport.ASSOCIATE1+bookReport.PROFESSOR1 }" /></td>
	</tr>
	<tr>
		<th colspan="2"><spring:message code='stats.report.integ.sum'/></th>
		<td style="text-align: right;padding: 0 5px;"></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${bookReport.ASSISTANT1+bookReport.ASSISTANT2 }" /></td>
		<td style="text-align: right;padding: 0 5px;"></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${bookReport.ASSOCIATE1+bookReport.ASSOCIATE2 }" /></td>
		<td style="text-align: right;padding: 0 5px;"></td>
		<td style="text-align: right;padding: 0 5px;"><c:out value="${bookReport.PROFESSOR1+bookReport.PROFESSOR2 }" /></td>
		<td style="text-align: right;padding: 0 5px;"></td>
		<td style="text-align: right;padding: 0 5px;border-right: 0;"><c:out value="${bookReport.ASSISTANT1+bookReport.ASSISTANT2+bookReport.ASSOCIATE1+bookReport.ASSOCIATE2+bookReport.PROFESSOR1+bookReport.PROFESSOR2 }" /></td>
	</tr>
	</tbody>
</table>