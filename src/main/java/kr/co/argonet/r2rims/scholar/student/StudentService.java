package kr.co.argonet.r2rims.scholar.student;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
import kr.co.argonet.r2rims.scholar.mapper.StudentMapper;
import kr.co.argonet.r2rims.scholar.vo.StudentVo;
import kr.co.argonet.r2rims.util.StringUtil;


/**
 * <pre>
 * 학생배출 서비스클래스
 *  kr.co.argonet.r2rims.scholar.student
 *      ┗ StudentService.java
 *
 * </pre>
 * @date 2016. 12. 20.
 * @version
 * @author : hojkim
 */
@Service(value = "studentService")
public class StudentService {

	Logger log = LoggerFactory.getLogger(StudentService.class);

	@Resource(name = "studentMapper")
	private StudentMapper studentMapper;
	@Resource(name = "userMapper")
	private UserMapper userMapper;
	@Resource(name = "scholarSqlSession")
	private SqlSessionTemplate scholarSqlSession;

	@Value("#{sysConf['anlaysis.user.dept.field']}")
	private String deptField;
	@Value("#{sysConf['anlaysis.user.college.field']}")
	private String clgField;

	public Integer countBySearchVo(RimsSearchVo searchVo){

		Integer count = 0;

		searchVo.setClgField(clgField);
		searchVo.setDeptField(deptField);

		List<UserVo> srchUserIds = userMapper.findBySearchVo(searchVo);
		searchVo.setSrchUserIds(srchUserIds);
		count = studentMapper.countBySearchVo(searchVo);

		return count;
	}

	public List<StudentVo> findStudentListWithPagingBySearchVo(RimsSearchVo searchVo){

		List<StudentVo> studentList = null;

		searchVo.setClgField(clgField);
		searchVo.setDeptField(deptField);

		List<UserVo> srchUserIds = userMapper.findBySearchVo(searchVo);
		if(srchUserIds != null && srchUserIds.size() > 0)
		{
			searchVo.setSrchUserIds(srchUserIds);
			RowBounds rowBounds = new RowBounds(searchVo.getPs(), searchVo.getCt());
			studentList = scholarSqlSession.selectList("kr.co.argonet.r2rims.scholar.mapper.StudentMapper.findBySearchVo", searchVo, rowBounds);

			if(studentList != null && studentList.size() > 0)
			{
				List<String> profIds = new ArrayList<String>();
				for(StudentVo std : studentList)
				{
					if(!profIds.contains(std.getProfsrEmpno()))
						profIds.add(std.getProfsrEmpno());
				}
				List<UserVo> userList = userMapper.findByUserIds(profIds.toArray());
				Map<String, String> reUserMap = new HashMap<String, String>();
				for(int i =0; i < studentList.size(); i++)
				{
					String profsrNm = null;
					if(reUserMap.containsKey(studentList.get(i).getProfsrEmpno()))
					{
						profsrNm = reUserMap.get(studentList.get(i).getProfsrEmpno());
					}
					else
					{
						profsrNm = getProfsrNmByProfIdFromAllUserList(studentList.get(i).getProfsrEmpno(), userList);
						reUserMap.put(studentList.get(i).getProfsrEmpno(), profsrNm);
					}
					studentList.get(i).setProfsrNm(profsrNm);
				}
			}
		}

		return studentList;
	}

	public List<StudentVo> findStudentListBySearchVo(RimsSearchVo searchVo){
		if(searchVo.getSrchUserNm() != null)
		{
			List<UserVo> srchUserIds = userMapper.findByKorNmAndDeptKor(searchVo.getSrchUserNm(), null);
			searchVo.setSrchUserIds(srchUserIds);
		}
		return studentMapper.findBySearchVo(searchVo);
	}

	private String getProfsrNmByProfIdFromAllUserList(String profId, List<UserVo> allUserList){
		String profsrNm = null;
		for(UserVo user : allUserList){
			if(user.getUserId().equals(profId)) {
				profsrNm = user.getKorNm();
				break;
			}
		}
		return profsrNm;
	}

	public String makeExportStudentTable(List<StudentVo> list, RimsSearchVo searchVo, UserVo user){

		String lang = "en".equals(searchVo.getLang()) ? "ENG" : "KOR";

		StringBuffer table = new StringBuffer();
		StringBuffer colgroup = new StringBuffer();
		StringBuffer thead = new StringBuffer();
		StringBuffer tbody = new StringBuffer();

		colgroup.append("<colgroup>");
		thead.append("<thead>");

		thead.append("<tr>");

		thead.append("<th>No</th>");
		colgroup.append("<col width='80'>");

		thead.append("<th>Graduate Date</th>");
		colgroup.append("<col width='150'>");

		thead.append("<th>ID</th>");
		colgroup.append("<col width='150'>");

		thead.append("<th>Name(kor)</th>");
		colgroup.append("<col width='150'>");

		thead.append("<th>Name(eng)</th>");
		colgroup.append("<col width='150'>");

		thead.append("<th>Department</th>");
		colgroup.append("<col width='150'>");

		thead.append("<th>Degree</th>");
		colgroup.append("<col width='150'>");

		thead.append("<th>Status</th>");
		colgroup.append("<col width='150'>");

		thead.append("<th>Type</th>");
		colgroup.append("<col width='150'>");

		thead.append("</tr>");

		thead.append("</thead>");
		colgroup.append("</colgroup>");

		tbody.append("<tbody>");

		for(int i=0; i < list.size(); i++)
		{
			StudentVo student = list.get(i);

			tbody.append("<tr>");
			tbody.append("<td>"+(i+1)+"</td>");
			tbody.append("<td>"+(StringUtils.defaultString(StringUtil.toHyphen(student.getGrdtnDate() , ".")))+"</td>");
			tbody.append("<td>"+(StringUtils.defaultString(student.getStdntNo()))+"</td>");
			tbody.append("<td>"+(StringUtils.defaultString(student.getStdntNm()))+"</td>");
			tbody.append("<td>"+(StringUtils.defaultString(student.getStdntLastNm() + ", " + student.getStdntFirstNm()))+"</td>");
			tbody.append("<td>"+(StringUtils.defaultString(student.getDeptKor()))+"</td>");
			tbody.append("<td>"+(StringUtils.defaultString(student.getCrseSeNm()))+"</td>");
			tbody.append("<td>"+(StringUtils.defaultString(student.getSknrgsStatus()))+"</td>");
			tbody.append("<td>"+(StringUtils.defaultString(student.getCoachingSe()))+"</td>");
			tbody.append("</tr>");
		}

		table.append("<table>")
             .append("<caption>").append("Alumni").append("</caption>")
             .append(colgroup.toString())
             .append(thead.toString())
             .append(tbody.toString())
             .append("</table>");

		return table.toString();

	}

}
