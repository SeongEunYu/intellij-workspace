package kr.co.argonet.r2rims.core.resume;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Element;
import com.lowagie.text.Paragraph;

import kr.co.argonet.r2rims.core.vo.UserVo;
import kr.co.argonet.r2rims.scholar.vo.LectureVo;

/**
 * <pre>
 * 강의실적 Rsume 출력을 위한 모듈
 *  kr.co.argonet.r2rims.core.resume
 *      ┗ ResumeLecture.java
 *
 * </pre>
 * @date 2016. 12. 20.
 * @version
 * @author : hojkim
 */
public class ResumeLecture extends ResumeCommon implements ResumeInterface {

	Logger log = LoggerFactory.getLogger(ResumeLecture.class);

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
				LectureVo lecture = (LectureVo) list.get(i);
				try {
					Paragraph paragraph = new Paragraph(getContentsFromLectureVo((i+1), lecture), getFont(10));
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
				LectureVo lecture = (LectureVo) list.get(i);
				try {
					Paragraph paragraph = new Paragraph(getContentsFromLectureVo((i+1), lecture), getFont(10));
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

	private String getContentsFromLectureVo(int order, LectureVo lecture){
		StringBuffer sb = new StringBuffer();

		sb.append(order+". ")
		  .append(emptyString(lecture.getSbjectNo(), "", " "))
		  .append(emptyString(lecture.getSbjectNmEng(), "", ""))
		  .append("(")
		  .append(emptyString(lecture.getEstblYear(), "", " "))
		  .append(emptyString(getTermNameByEstblSemstr(lecture.getEstblSemstr()), "", " "))
		  .append(")");

		log.debug("Lecture Resume Content : {}",sb.toString());

		return sb.toString();
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
