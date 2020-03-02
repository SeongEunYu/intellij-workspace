/*
 * Copyright www.argonet.co.kr
 * All rights reserved.
 *
 */
package kr.co.argonet.r2rims.core.service;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.util.FileCopyUtils;

import com.lowagie.text.Document;
import com.lowagie.text.PageSize;
import com.lowagie.text.rtf.RtfWriter2;

import kr.co.argonet.r2rims.core.resume.ResumeInterface;
import kr.co.argonet.r2rims.core.resume.ResumeLecture;
import kr.co.argonet.r2rims.core.resume.ResumeStudent;
import kr.co.argonet.r2rims.core.vo.UserVo;
import kr.co.argonet.r2rims.scholar.vo.LectureVo;
import kr.co.argonet.r2rims.scholar.vo.StudentVo;

/**
 * <pre>
 * Resume 파일 다운로드 서비스클래스
 *  kr.co.argonet.r2rims.core.service
 *      ┗ KaistResumeDownloadService.java
 *
 * </pre>
 * @date 2016. 11. 25.
 * @version
 * @author : hojkim
 */
@Service("kaistResumeDownloadService")
public class KaistResumeDownloadService {

	Logger log = LoggerFactory.getLogger(KaistResumeDownloadService.class);

	@Value("#{sysConf['resume.file.path']}")
	private String filePath;

	public void downloadLectureResume(String fileName, List<LectureVo> lectures, UserVo user, HttpServletRequest request, HttpServletResponse response){

		File resumeDirectory = new File(filePath);
		if (!resumeDirectory.exists() || resumeDirectory.isFile()) resumeDirectory.mkdirs();

		String tempRtfFile = getMakeTemporaryFile("rtf");
		Document document = null;

		try {

			document = new Document(PageSize.A4, 70, 70, 80, 70);

			RtfWriter2.getInstance(document, new FileOutputStream(tempRtfFile));
			document.open();

			ResumeInterface ri = new ResumeLecture();
			List<Object> lectureList =  this.convertToObjectListFromLectureList(lectures);

			if(lectureList != null && lectureList.size() > 0)
			{
				document = ri.addHeader(document, "Courses");
				document = ri.word(document, lectureList, user);
			}

			document.close();

			fileDownload(tempRtfFile, fileName, response);

		}catch(Exception e){
			log.error("error occurred!----handleResume");
			e.printStackTrace();
			log.debug(e.getMessage());
		}finally{

		}

	}

	public void downloadStudentResume(String fileName, List<StudentVo> students, UserVo user, HttpServletRequest request, HttpServletResponse response){

		File resumeDirectory = new File(filePath);
		if (!resumeDirectory.exists() || resumeDirectory.isFile()) resumeDirectory.mkdirs();

		String tempRtfFile = getMakeTemporaryFile("rtf");
		Document document = null;

		try {

			document = new Document(PageSize.A4, 70, 70, 80, 70);

			RtfWriter2.getInstance(document, new FileOutputStream(tempRtfFile));
			document.open();

			ResumeInterface ri = new ResumeStudent();
			List<Object> studentList =  this.convertToObjectListFromStudentList(students);

			if(studentList != null && studentList.size() > 0)
			{
				document = ri.addHeader(document, "Alumni");
				document = ri.word(document, studentList, user);
			}

			document.close();

			fileDownload(tempRtfFile, fileName, response);

		}catch(Exception e){
			log.error("error occurred!----handleResume");
			e.printStackTrace();
			log.debug(e.getMessage());
		}finally{

		}

	}

	private void fileDownload(String path, String fileName, HttpServletResponse response){
		try {
			File f = new File(path);
			int filesize = (int)f.length();
			response.setContentType("application/octet-stream");
			fileName = new String(fileName.getBytes("EUC_KR"),"8859_1")+".rtf";
			response.setHeader("Set-Cookie", "fileDownload=true; path=/");
			response.setHeader("Content-Disposition", "attachment;filename="+fileName+";");
			response.setContentLength(filesize);
			FileCopyUtils.copy(FileCopyUtils.copyToByteArray(f), response.getOutputStream());
			f.delete();

		} catch (UnsupportedEncodingException e) {
			log.error("error occurred!----handleResume word(rtf) Encoding");
			log.debug(e.getMessage());
		} catch (IOException e) {
			log.error("error occurred!----handleResume word(rtf) file Download");
			log.debug(e.getMessage());
		}
	}

	private List<Object> convertToObjectListFromStudentList(List<StudentVo> studentVos){
		List<Object> rsltList = new ArrayList<Object>();
		for(StudentVo student : studentVos) rsltList.add(student);
		return rsltList;
	}

	private List<Object> convertToObjectListFromLectureList(List<LectureVo> lectureVos){
		List<Object> rsltList = new ArrayList<Object>();
		for(LectureVo lecture : lectureVos) rsltList.add(lecture);
		return rsltList;
	}

	private String getMakeTemporaryFile(String ext){
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
		String dateStr = dateFormat.format(System.currentTimeMillis());
		return filePath+ File.separator +"resume_temp_"+dateStr+"."+ext;
	}

}
