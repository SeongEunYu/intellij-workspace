package kr.co.argonet.r2rims.core.resume;

import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Element;
import com.lowagie.text.Paragraph;

import kr.co.argonet.r2rims.core.tag.RimsCumstomTagUtil;
import kr.co.argonet.r2rims.core.vo.UserVo;
import kr.co.argonet.r2rims.scholar.vo.StudentVo;

/**
 * <pre>
 * 학생배출 Resume 출력을 위한 모듈
 *  kr.co.argonet.r2rims.core.resume
 *      ┗ ResumeStudent.java
 *
 * </pre>
 * @date 2016. 12. 20.
 * @version
 * @author : hojkim
 */
public class ResumeStudent extends ResumeCommon implements ResumeInterface {

	Logger log = LoggerFactory.getLogger(ResumeStudent.class);

	@Override
	public Document pdf(Document doc,List<Object> list, UserVo user) {

		if(list == null || list.size() <= 0)
		{
			return doc;
		}
		else
		{
			for(int i=0; i < list.size(); i++)
			{
				StudentVo student = (StudentVo) list.get(i);
				try {
					Paragraph paragraph = new Paragraph(getContentsFromStudentVo((i+1), student), getFont(10));
					paragraph.add("");
					paragraph.setIndentationLeft(18);
					paragraph.setFirstLineIndent(-12);
					doc.add(paragraph);
					doc.add(new Paragraph("\n"));
				} catch (DocumentException e) {
					log.debug(e.getMessage());
				}
			}
		}
		doc.newPage();
		return doc;
	}

	@Override
	public Document word(Document doc, List<Object> list, UserVo user) {
		if(list == null || list.size() <= 0)
		{
			return doc;
		}
		else
		{
			for(int i=0; i < list.size(); i++)
			{
				StudentVo student = (StudentVo) list.get(i);
				try {
					Paragraph paragraph = new Paragraph(getContentsFromStudentVo((i+1), student), getFont(10));
					paragraph.setAlignment(Element.ALIGN_LEFT);
					paragraph.setSpacingAfter(7);
					paragraph.setIndentationLeft(18);
					paragraph.setFirstLineIndent(-12);
					doc.add(paragraph);
				} catch (DocumentException e) {
					log.debug(e.getMessage());
				}

			}
		}
		doc.newPage();
		return doc;
	}

	private String getContentsFromStudentVo(int order, StudentVo student){
		StringBuffer sb = new StringBuffer();

		sb.append(order+". ");

		String grdtnDate = student.getGrdtnDate();
		if(grdtnDate.length() > 4)
			sb.append(emptyString(RimsCumstomTagUtil.toDateFormatToken(grdtnDate, "."), "", ", "));
		else
			sb.append(emptyString(grdtnDate, "", ", "));

		sb.append(emptyString(student.getStdntNo(), "", ", "));

		if(StringUtils.isNotBlank(student.getStdntNm()))
		sb.append(emptyString(student.getStdntNm().trim(), "", ""));
		if(StringUtils.isNotBlank(student.getStdntLastNm()))
		{
		   sb.append("(").append(emptyString(student.getStdntLastNm().trim(), "", ", "));
		   if(StringUtils.isNotBlank(student.getStdntFirstNm()))
		   	sb.append(emptyString(student.getStdntFirstNm().trim(), "", ""));
		  sb.append("), ");

		}
		sb.append(emptyString(student.getDeptKor(), "", ", "));

		String courseName = student.getCrseSeNm();
		if(courseName.length() > 2)
			sb.append(emptyString(courseName.substring(0, 2), "", ", "));
		else
			sb.append(emptyString(courseName, "", ", "));

		sb.append(emptyString(student.getSknrgsStatus(), "", ""));

		log.debug("Lecture Resume Content : {}",sb.toString());

		return StringUtils.strip(sb.toString(), ",");
	}

	private String getTermNameByEstblSemstr(String estblSemstr){
		String termName = "";
		if("1".equals(estblSemstr)) termName = "Spring";
		else if("2".equals(estblSemstr)) termName = "Summer";
		else if("3".equals(estblSemstr)) termName = "Fall";
		else if("4".equals(estblSemstr)) termName = "Winter";
		return termName;
	}

}
