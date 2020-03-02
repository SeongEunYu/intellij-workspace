package kr.co.argonet.r2rims.scholar.lecture;

import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import kr.co.argonet.r2rims.core.mapper.UserMapper;
import kr.co.argonet.r2rims.core.vo.RimsSearchVo;
import kr.co.argonet.r2rims.core.vo.UserVo;
import kr.co.argonet.r2rims.scholar.mapper.LectureMapper;
import kr.co.argonet.r2rims.scholar.vo.LectureVo;


/**
 * <pre>
 * 강의실적 관리 서비스클래스
 *  kr.co.argonet.r2rims.scholar.lecture
 *      ┗ LectureService.java
 *
 * </pre>
 * @date 2016. 12. 20.
 * @version
 * @author : hojkim
 */
@Service(value = "lectureService")
public class LectureService {

	Logger log = LoggerFactory.getLogger(LectureService.class);

	@Resource(name = "lectureMapper")
	private LectureMapper lectureMapper;
	@Resource(name = "userMapper")
	private UserMapper userMapper;
	@Resource(name = "scholarSqlSession")
	private SqlSessionTemplate scholarSqlSession;

	@Value("#{sysConf['anlaysis.user.dept.field']}")
	private String deptField;
	@Value("#{sysConf['anlaysis.user.college.field']}")
	private String clgField;


	public Integer countBySearchVo(RimsSearchVo searchVo){
		return lectureMapper.countBySearchVo(searchVo);
	}

	public List<LectureVo> findLetureListWithPagingBySearchVo(RimsSearchVo searchVo){

		searchVo.setClgField(clgField);
		searchVo.setDeptField(deptField);

		List<UserVo> srchUserIds = userMapper.findBySearchVo(searchVo);
		searchVo.setSrchUserIds(srchUserIds);

		RowBounds rowBounds = new RowBounds(searchVo.getPs(), searchVo.getCt());
		List<LectureVo> lectureList = scholarSqlSession.selectList("kr.co.argonet.r2rims.scholar.mapper.LectureMapper.findBySearchVo", searchVo, rowBounds);
		return lectureList;
	}

	public List<LectureVo> findLetureListBySearchVo(RimsSearchVo searchVo){
		return lectureMapper.findBySearchVo(searchVo);
	}

	public String makeExportLectureTable(List<LectureVo> list, RimsSearchVo searchVo, UserVo user){

		String lang = "en".equals(searchVo.getLang()) ? "ENG" : "KOR";

		StringBuffer table = new StringBuffer();
		StringBuffer colgroup = new StringBuffer();
		StringBuffer thead = new StringBuffer();
		StringBuffer tbody = new StringBuffer();

		colgroup.append("<colgroup>");
		thead.append("<thead>");

		thead.append("<tr>");

		thead.append("<th>NO</th>");
		colgroup.append("<col width='80'>");

		thead.append("<th>ID</th>");
		colgroup.append("<col width='150'>");

		thead.append("<th>ADVISOR NAME</th>");
		colgroup.append("<col width='150'>");

		thead.append("<th>OPENING YEAR</th>");
		colgroup.append("<col width='150'>");

		thead.append("<th>OPENING SEMESTER</th>");
		colgroup.append("<col width='150'>");

		thead.append("<th>OPENING DEPARTMENT</th>");
		colgroup.append("<col width='150'>");

		thead.append("<th>CLASSIFICATION</th>");
		colgroup.append("<col width='150'>");

		thead.append("<th>COURSE TITLE(KOREAN)</th>");
		colgroup.append("<col width='250'>");

		thead.append("<th>COURSE TITLE(ENGLISH)</th>");
		colgroup.append("<col width='250'>");

		thead.append("<th>LECTURE</th>");
		colgroup.append("<col width='100'>");

		thead.append("<th>LAB</th>");
		colgroup.append("<col width='100'>");

		thead.append("<th>CREDITS</th>");
		colgroup.append("<col width='100'>");

		thead.append("<th>TOTAL STUDENT</th>");
		colgroup.append("<col width='100'>");

		thead.append("<th>COURSE NO.</th>");
		colgroup.append("<col width='150'>");

		thead.append("<th>COURSE CODE</th>");
		colgroup.append("<col width='150'>");

		thead.append("<th>SECTION</th>");
		colgroup.append("<col width='150'>");

		thead.append("<th>IS ENGLISH LECTURE?</th>");
		colgroup.append("<col width='200'>");

		thead.append("</tr>");

		thead.append("</thead>");
		colgroup.append("</colgroup>");

		tbody.append("<tbody>");

		for(int i=0; i < list.size(); i++)
		{
			LectureVo lecture = list.get(i);

			tbody.append("<tr>");
			tbody.append("<td>"+(i+1)+"</td>");
			tbody.append("<td>"+(StringUtils.defaultString(lecture.getProfsrEmpno()))+"</td>");
			tbody.append("<td>"+(StringUtils.defaultString(lecture.getProfsrNm()))+"</td>");
			tbody.append("<td>"+(StringUtils.defaultString(lecture.getEstblYear()))+"</td>");
			tbody.append("<td>"+(StringUtils.defaultString(lecture.getEstblSemstr()))+"</td>");
			tbody.append("<td>"+(StringUtils.defaultString(lecture.getEstblDeptKor()))+"</td>");
			tbody.append("<td>"+(StringUtils.defaultString(lecture.getSbjectSe() ))+"</td>");
			tbody.append("<td>"+(StringUtils.defaultString(lecture.getSbjectNmKor() ))+"</td>");
			tbody.append("<td>"+(StringUtils.defaultString(lecture.getSbjectNmEng() ))+"</td>");
			tbody.append("<td>"+(StringUtils.defaultString(lecture.getLctre()))+"</td>");
			tbody.append("<td>"+(StringUtils.defaultString(lecture.getExper()))+"</td>");
			tbody.append("<td>"+(lecture.getPoint() == null ? 0 : lecture.getPoint())+"</td>");
			tbody.append("<td>"+(StringUtils.defaultString(lecture.getAtnlcNmpr()))+"</td>");
			tbody.append("<td>"+(StringUtils.defaultString(lecture.getSbjectNo()))+"</td>");
			tbody.append("<td>"+(StringUtils.defaultString(lecture.getSbjectCode()))+"</td>");
			tbody.append("<td>"+(StringUtils.defaultString(lecture.getLctreClass()))+"</td>");
			tbody.append("<td>"+(StringUtils.defaultString(lecture.getEngLctreAt()))+"</td>");
			tbody.append("</tr>");
		}

		table.append("<table>")
             .append("<caption>").append("Courses").append("</caption>")
             .append(colgroup.toString())
             .append(thead.toString())
             .append(tbody.toString())
             .append("</table>");

		return table.toString();
	}

}
