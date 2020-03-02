/*
 * Copyright www.argonet.co.kr
 * All rights reserved.
 *
 */
package kr.co.argonet.r2rims.core.servlets;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.co.argonet.r2rims.core.mapper.*;
import kr.co.argonet.r2rims.core.resume.*;
import kr.co.argonet.r2rims.core.vo.*;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.ibatis.session.SqlSession;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.lowagie.text.Document;
import com.lowagie.text.PageSize;
import com.lowagie.text.pdf.PdfWriter;
import com.lowagie.text.rtf.RtfWriter2;

import kr.co.argonet.r2rims.constant.R2Constant;
import kr.co.argonet.r2rims.scholar.mapper.LectureMapper;
import kr.co.argonet.r2rims.scholar.mapper.StudentMapper;
import kr.co.argonet.r2rims.scholar.vo.LectureVo;
import kr.co.argonet.r2rims.scholar.vo.StudentVo;

/**
 * <pre>
 * Resume 출력을 위한 서블릿클래스
 *  kr.co.argonet.r2rims.core.servlets
 *      ┗ KaistResumeExportServlet.java
 *
 * </pre>
 * @date 2016. 11. 22.
 * @version
 * @author : hojkim
 */
public class KaistResumeExportServlet extends HttpServlet {

	private SqlSession sqlSession;
	private SqlSession scholarSqlSession;
	private UserMapper userMapper;
	private ArticleMapper articleMapper;
	private ArticlePartiMapper articlePartiMapper;
	private ConferenceMapper conferenceMapper;
	private ConferencePartiMapper conferencePartiMapper;
	private PatentMapper patentMapper;
	private PatentPartiMapper patentPartiMapper;
	private BookMapper bookMapper;
	private BookPartiMapper bookPartiMapper;
	private TechtransMapper techtransMapper;
	private TechtransPartiMapper techtransPartiMapper;
	private FundingMapper fundingMapper;
	private FundingPartiMapper fundingPartiMapper;
	private CareerMapper careerMapper;
	private AwardMapper awardMapper;
	private EtcMapper etcMapper;
	private ActivityMapper activityMapper;
	private ReportMapper reportMapper;
	private ReportPartiMapper reportPartiMapper;
	private DegreeMapper degreeMapper;
	private LectureMapper lectureMapper;
	private StudentMapper studentMapper;

	private Properties sysConf;
	private String filePath;

	private static Log log = LogFactory.getLog(KaistResumeExportServlet.class.getName());

	@Override
	public void init() throws ServletException {
		WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(getServletContext());
		sqlSession =  (SqlSession) context.getBean("sqlSession");
		userMapper = sqlSession.getMapper(UserMapper.class);
		articleMapper = sqlSession.getMapper(ArticleMapper.class);
		articlePartiMapper = sqlSession.getMapper(ArticlePartiMapper.class);
		conferenceMapper = sqlSession.getMapper(ConferenceMapper.class);
		conferencePartiMapper = sqlSession.getMapper(ConferencePartiMapper.class);
		patentMapper = sqlSession.getMapper(PatentMapper.class);
		patentPartiMapper = sqlSession.getMapper(PatentPartiMapper.class);
		bookMapper = sqlSession.getMapper(BookMapper.class);
		bookPartiMapper = sqlSession.getMapper(BookPartiMapper.class);
		techtransMapper = sqlSession.getMapper(TechtransMapper.class);
		techtransPartiMapper = sqlSession.getMapper(TechtransPartiMapper.class);
		fundingMapper = sqlSession.getMapper(FundingMapper.class);
		fundingPartiMapper = sqlSession.getMapper(FundingPartiMapper.class);
		careerMapper = sqlSession.getMapper(CareerMapper.class);
		awardMapper = sqlSession.getMapper(AwardMapper.class);
		etcMapper = sqlSession.getMapper(EtcMapper.class);
		activityMapper = sqlSession.getMapper(ActivityMapper.class);
		reportMapper = sqlSession.getMapper(ReportMapper.class);
		reportPartiMapper = sqlSession.getMapper(ReportPartiMapper.class);
		degreeMapper = sqlSession.getMapper(DegreeMapper.class);
		scholarSqlSession =  (SqlSession) context.getBean("scholarSqlSession");
		lectureMapper = scholarSqlSession.getMapper(LectureMapper.class);
		studentMapper = scholarSqlSession.getMapper(StudentMapper.class);

		sysConf = (Properties) context.getBean("sysConf");
		filePath = sysConf.getProperty("resume.file.path");

		super.init();
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		handleResume(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		handleResume(request, response);
	}

	public void handleResume(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		RimsSearchVo searchVo = new RimsSearchVo();

		searchVo.setPs(0);
		searchVo.setCt(999999);

		String userId = request.getParameter("userId");
		String sttDate = request.getParameter("sttDate");
		String endDate = request.getParameter("endDate");
		String isAccept = request.getParameter("isAccept");

		if(userId != null && !"".equals(userId))
		{
			searchVo.setUserId(userId);
			searchVo.setSrchUserId(userId);
		}
		if(sttDate != null && !"".equals(sttDate)) searchVo.setSttDate(sttDate);
		if(endDate != null && !"".equals(endDate)) searchVo.setEndDate(endDate);
		if(isAccept != null && !"".equals(isAccept)) searchVo.setIsAccept(isAccept);

		UserVo user = userMapper.findByUserId(userId);

		String basicInfoInclsAt = request.getParameter("basicInfoInclsAt");
		String proflImageInclsAt = request.getParameter("proflImageInclsAt");

		if(basicInfoInclsAt != null && !"".equals(basicInfoInclsAt))
			user.setBasicInfoInclsAt(basicInfoInclsAt);
		if(proflImageInclsAt != null && !"".equals(proflImageInclsAt))
			user.setProflImageInclsAt(proflImageInclsAt);


		String[] gubuns = request.getParameterValues("gubun");
		String type = request.getParameter("type");

		File resumeDirectory = new File(filePath);
		if (!resumeDirectory.exists() || resumeDirectory.isFile()) resumeDirectory.mkdirs();

		try {

			String tempRtfFile = getMakeTemporaryFile("rtf");
			Document document = null;

			if("word".equals(type))
			{
				document = new Document(PageSize.A4, 70, 70, 80, 70);

				RtfWriter2.getInstance(document, new FileOutputStream(tempRtfFile));
				document.open();

				ResumeInterface ri = null;
				//user정보
				if("Y".equals(basicInfoInclsAt) || "Y".equals(proflImageInclsAt))
				{
					ri = new ResumeProfile();
					document = ri.word(document, null, user);
				}
				//Education
				ri = new ResumeDegree();
				List<DegreeVo> degrees = degreeMapper.findByUserId(searchVo);
				List<Object> degreeList = convertToObjectListFromDegreeList(degrees);
				document = ri.addHeader(document, "Education");
				document = ri.word(document, degreeList, user);

				for(String gubun : gubuns)
				{
					if("article".equals(gubun))
					{
						ri = new ResumeArticle();

						searchVo.setArticleGubun("sdc_sci");
						List<ArticleVo> sciArticles = articleMapper.findByCond(searchVo);
						List<Object> sciArticleList =  this.getArticleListWithPartiInfo(sciArticles);
						if(sciArticleList != null && sciArticleList.size() > 0)
						{
							document = ri.addHeader(document, "SCI Journal Papers");
							document = ri.word(document, sciArticleList, user);
						}

						searchVo.setArticleGubun("sdc_other");
						List<ArticleVo> nonSciArticles = articleMapper.findByCond(searchVo);
						List<Object> nonSciArticleList =  this.getArticleListWithPartiInfo(nonSciArticles);
						if(nonSciArticleList != null && nonSciArticleList.size() > 0)
						{
							document = ri.addHeader(document, "Other Journal Papers");
							document = ri.word(document, nonSciArticleList, user);
						}

					}
					else if("conference".equals(gubun))
					{
						ri = new ResumeConference();

						searchVo.setScjnlDvsCd("2");
						List<ConferenceVo> intlConfereces = conferenceMapper.findByCond(searchVo);
						List<Object> intlConferenceList = this.getConferenceListWithPartiInfo(intlConfereces);
						if(intlConferenceList != null && intlConferenceList.size() > 0)
						{
							document = ri.addHeader(document, "International Conference Papers");
							document = ri.word(document, intlConferenceList, user);
						}

						searchVo.setScjnlDvsCd("1");
						List<ConferenceVo> dmstConfereces = conferenceMapper.findByCond(searchVo);
						List<Object> dmstcConferenceList = this.getConferenceListWithPartiInfo(dmstConfereces);
						if(dmstcConferenceList != null && dmstcConferenceList.size() > 0)
						{
							document = ri.addHeader(document, "Domestic Conference Papers");
							document = ri.word(document, dmstcConferenceList, user);
						}

					}
					else if("patent".equals(gubun))
					{
						ri = new ResumePatent();
						List<PatentVo> patents = patentMapper.findRegistPatentByUserId(searchVo);
						List<Object> patentList = this.getPatentListWithPartiInfo(patents);
						if(patentList != null && patentList.size() > 0)
						{
							document = ri.addHeader(document, "Patents");
							document = ri.word(document, patentList, user);
						}
					}
					else if("book".equals(gubun))
					{
						ri = new ResumeBook();
						List<BookVo> books = bookMapper.findByCond(searchVo);
						List<Object> bookList = this.getBookListWithPartiInfo(books);
						if(bookList != null && bookList.size() > 0)
						{
							document = ri.addHeader(document, "Books");
							document = ri.word(document, bookList, user);
						}

					}
					else if("techtrans".equals(gubun))
					{
						ri = new ResumeTechtrans();
						List<TechtransVo> techtransList = techtransMapper.findByCond(searchVo);
						List<Object> list = this.getTechtransListWithPartiInfo(techtransList);
						if(list != null && list.size() > 0)
						{
							document = ri.addHeader(document, "Technology Transfer");
							document = ri.word(document, list, user);
						}
					}
					else if("funding".equals(gubun))
					{
						ri = new ResumeFunding();
						List<FundingVo> fundings = fundingMapper.findByCond(searchVo);
						List<Object> fundingList = this.getFundingListWithPartiInfo(fundings);
						if(fundingList != null && fundingList.size() > 0)
						{
							document = ri.addHeader(document, "Projects");
							document = ri.word(document, fundingList, user);
						}

					}
					else if("career".equals(gubun))
					{
						ri = new ResumeCareer();
						List<CareerVo> careers = careerMapper.findByCond(searchVo);
						List<Object> careerList = convertToObjectListFromCareerList(careers);
						if(careerList != null && careerList.size() > 0)
						{
							document = ri.addHeader(document, "Activities");
							document = ri.word(document, careerList, user);
						}

					}
					else if("award".equals(gubun))
					{
						ri = new ResumeAward();
						List<AwardVo> awards = awardMapper.findByCond(searchVo);
						if(awards != null && awards.size() > 0)
						{
							List<Object> awardList = convertToObjectListFromAwardList(awards);
							document = ri.addHeader(document, "Awards");
							document = ri.word(document, awardList, user);
						}
					}
					else if("report".equals(gubun))
					{
						ri = new ResumeReport();
						List<ReportVo> reportList = reportMapper.findByCond(searchVo);
						List<Object> list = getReportLIstWithPartiInfo(reportList);
						if(list != null && list.size() > 0)
						{
							document = ri.addHeader(document, "Final Research Reports");
							document = ri.word(document, list, user);
						}
					}
					else if("student".equals(gubun))
					{
						ri = new ResumeStudent();
						searchVo.setSknrgsStatus(R2Constant.STUDENT_STATUS_GRADUATION);
						List<StudentVo> students = studentMapper.findBySearchVo(searchVo);
						List<Object> list = convertToObjectListFromStudentList(students);
						if(list != null && list.size() > 0)
						{
							document = ri.addHeader(document, "Alumni");
							document = ri.word(document, list, user);
						}
					}
					else if("lecture".equals(gubun))
					{
						ri = new ResumeLecture();
						searchVo.setSbjectSe("resume");
						List<LectureVo> lectures = lectureMapper.findBySearchVo(searchVo);
						List<Object> list = convertToObjectListFromLectureList(lectures);
						if(list != null && list.size() > 0)
						{
							document = ri.addHeader(document, "Courses");
							document = ri.word(document, list, user);
						}
					}
					else if("etc".equals(gubun))
					{
						ri = new ResumeEtc();
						List<EtcVo> etcs = etcMapper.findByCond(searchVo);
						List<Object> list = convertToObjectListFromEtcList(etcs);
						if(list != null && list.size() > 0)
						{
							document = ri.addHeader(document, "Other Research Activities");
							document = ri.word(document, list, user);
						}
					}
					else if("activity".equals(gubun))
					{
						ri = new ResumeActivity();
						List<ActivityVo> activities = activityMapper.findByCond(searchVo);
						List<Object> list = convertToObjectListFromActivityList(activities);
						if(list != null && list.size() > 0)
						{
							document = ri.addHeader(document, "Other Activities");
							document = ri.word(document, list, user);
						}
					}
				}// end for gubuns

				document.close();

				File f = new File(tempRtfFile);
				int filesize = (int)f.length();
				response.setContentType("application/octet-stream");
				String filename = "resume.rtf";
				filename = new String(filename.getBytes("EUC_KR"),"8859_1");
				response.setHeader("Content-Disposition", "attachment;filename="+filename+";");
				response.setContentLength(filesize);
				FileCopyUtils.copy(FileCopyUtils.copyToByteArray(f), response.getOutputStream());
				f.delete();

			}
			else if("pdf".equals(type))
			{

				String tempPdfFile = getMakeTemporaryFile("pdf");

				document = new Document(PageSize.A4, 50, 50, 50, 50);
				PdfWriter.getInstance(document, new FileOutputStream(tempPdfFile));
				document.open();

				ResumeInterface ri = null;
				if("Y".equals(basicInfoInclsAt) || "Y".equals(proflImageInclsAt))
				{
					ri = new ResumeProfile();
					document = ri.pdf(document, null, user);
				}

				//Education
				ri = new ResumeDegree();
				List<DegreeVo> degrees = degreeMapper.findByUserId(searchVo);
				List<Object> degreeList = convertToObjectListFromDegreeList(degrees);
				document = ri.addHeader(document, "Education");
				document = ri.pdf(document, degreeList, user);

				for(String gubun : gubuns)
				{
					if("article".equals(gubun))
					{
						ri = new ResumeArticle();

						searchVo.setArticleGubun("sdc_sci");
						List<ArticleVo> sciArticles = articleMapper.findByCond(searchVo);
						List<Object> sciArticleList =  this.getArticleListWithPartiInfo(sciArticles);
						if(sciArticleList != null && sciArticleList.size() > 0)
						{
							document = ri.addHeader(document, "SCI Journal Papers");
							document = ri.pdf(document, sciArticleList, user);
						}

						searchVo.setArticleGubun("sdc_other");
						List<ArticleVo> nonSciArticles = articleMapper.findByCond(searchVo);
						List<Object> nonSciArticleList =  this.getArticleListWithPartiInfo(nonSciArticles);
						if(nonSciArticleList != null && nonSciArticleList.size() > 0)
						{
							document = ri.addHeader(document, "Other Journal Papers");
							document = ri.pdf(document, nonSciArticleList, user);
						}

					}
					else if("conference".equals(gubun))
					{
						ri = new ResumeConference();

						searchVo.setScjnlDvsCd("2");
						List<ConferenceVo> intlConfereces = conferenceMapper.findByCond(searchVo);
						List<Object> intlConferenceList = this.getConferenceListWithPartiInfo(intlConfereces);
						if(intlConferenceList != null && intlConferenceList.size() > 0)
						{
							document = ri.addHeader(document, "International Conference Papers");
							document = ri.pdf(document, intlConferenceList, user);
						}

						searchVo.setScjnlDvsCd("1");
						List<ConferenceVo> dmstConfereces = conferenceMapper.findByCond(searchVo);
						List<Object> dmstcConferenceList = this.getConferenceListWithPartiInfo(dmstConfereces);
						if(dmstcConferenceList != null && dmstcConferenceList.size() > 0)
						{
							document = ri.addHeader(document, "Domestic Conference Papers");
							document = ri.pdf(document, dmstcConferenceList, user);
						}

					}
					else if("patent".equals(gubun))
					{
						ri = new ResumePatent();
						List<PatentVo> patents = patentMapper.findRegistPatentByUserId(searchVo);
						List<Object> patentList = this.getPatentListWithPartiInfo(patents);
						if(patentList != null && patentList.size() > 0)
						{
							document = ri.addHeader(document, "Patents");
							document = ri.pdf(document, patentList, user);
						}
					}
					else if("book".equals(gubun))
					{
						ri = new ResumeBook();
						List<BookVo> books = bookMapper.findByCond(searchVo);
						List<Object> bookList = this.getBookListWithPartiInfo(books);
						if(bookList != null && bookList.size() > 0)
						{
							document = ri.addHeader(document, "Books");
							document = ri.pdf(document, bookList, user);
						}

					}
					else if("techtrans".equals(gubun))
					{
						ri = new ResumeTechtrans();
						List<TechtransVo> techtransList = techtransMapper.findByCond(searchVo);
						List<Object> list = this.getTechtransListWithPartiInfo(techtransList);
						if(list != null && list.size() > 0)
						{
							document = ri.addHeader(document, "Technology Transfer");
							document = ri.pdf(document, list, user);
						}
					}
					else if("funding".equals(gubun))
					{
						ri = new ResumeFunding();
						List<FundingVo> fundings = fundingMapper.findByCond(searchVo);
						List<Object> fundingList = this.getFundingListWithPartiInfo(fundings);
						if(fundingList != null && fundingList.size() > 0)
						{
							document = ri.addHeader(document, "Projects");
							document = ri.pdf(document, fundingList, user);
						}

					}
					else if("career".equals(gubun))
					{
						ri = new ResumeCareer();
						List<CareerVo> careers = careerMapper.findByCond(searchVo);
						List<Object> careerList = convertToObjectListFromCareerList(careers);
						if(careerList != null && careerList.size() > 0)
						{
							document = ri.addHeader(document, "Activities");
							document = ri.pdf(document, careerList, user);
						}

					}
					else if("award".equals(gubun))
					{
						ri = new ResumeAward();
						List<AwardVo> awards = awardMapper.findByCond(searchVo);
						if(awards != null && awards.size() > 0)
						{
							List<Object> awardList = convertToObjectListFromAwardList(awards);
							document = ri.addHeader(document, "Awards");
							document = ri.pdf(document, awardList, user);
						}
					}
					else if("report".equals(gubun))
					{
						ri = new ResumeReport();
						List<ReportVo> reportList = reportMapper.findByCond(searchVo);
						List<Object> list = getReportLIstWithPartiInfo(reportList);
						if(list != null && list.size() > 0)
						{
							document = ri.addHeader(document, "Final Research Reports");
							document = ri.pdf(document, list, user);
						}
					}
					else if("student".equals(gubun))
					{
						ri = new ResumeStudent();
						searchVo.setSknrgsStatus(R2Constant.STUDENT_STATUS_GRADUATION);
						List<StudentVo> students = studentMapper.findBySearchVo(searchVo);
						List<Object> list = convertToObjectListFromStudentList(students);
						if(list != null && list.size() > 0)
						{
							document = ri.addHeader(document, "Alumni");
							document = ri.pdf(document, list, user);
						}
					}
					else if("lecture".equals(gubun))
					{
						ri = new ResumeLecture();
						searchVo.setSbjectSe("resume");
						List<LectureVo> lectures = lectureMapper.findBySearchVo(searchVo);
						List<Object> list = convertToObjectListFromLectureList(lectures);
						if(list != null && list.size() > 0)
						{
							document = ri.addHeader(document, "Courses");
							document = ri.pdf(document, list, user);
						}
					}
					else if("etc".equals(gubun))
					{
						ri = new ResumeEtc();
						List<EtcVo> etcs = etcMapper.findByCond(searchVo);
						List<Object> list = convertToObjectListFromEtcList(etcs);
						if(list != null && list.size() > 0)
						{
							document = ri.addHeader(document, "Other Research Activities");
							document = ri.pdf(document, list, user);
						}
					}
					else if("activity".equals(gubun))
					{
						ri = new ResumeActivity();
						List<ActivityVo> activities = activityMapper.findByCond(searchVo);
						List<Object> list = convertToObjectListFromActivityList(activities);
						if(list != null && list.size() > 0)
						{
							document = ri.addHeader(document, "Other Activities");
							document = ri.pdf(document, list, user);
						}
					}
				}// end for gubuns

				document.close();

				File f = new File(tempPdfFile);
				int filesize = (int)f.length();
				response.setContentType("application/octet-stream");
				String filename = "resume.pdf";
				filename = new String(filename.getBytes("EUC_KR"),"8859_1");
				response.setHeader("Content-Disposition", "attachment;filename="+filename+";");
				response.setContentLength(filesize);
				FileCopyUtils.copy(FileCopyUtils.copyToByteArray(f), response.getOutputStream());
				f.delete();
			}

		}catch(Exception e){
			log.error("error occurred!----handleResume");
			e.printStackTrace();
			log.debug(e.getMessage());
		}finally{

		}

	}

	private List<Object> getArticleListWithPartiInfo(List<ArticleVo> articles){
		List<Object> rsltList = new ArrayList<Object>();
		for(ArticleVo article : articles)
		{
			List<ArticlePartiVo> partiList = articlePartiMapper.findByArticleId(article.getArticleId().toString());
			article.setPartiList(partiList);
			rsltList.add(article);
		}
		return rsltList;
	}

	private List<Object> getConferenceListWithPartiInfo(List<ConferenceVo> conferences){
		List<Object> rsltList = new ArrayList<Object>();
		for(ConferenceVo conference : conferences)
		{
			List<ConferencePartiVo> partiList = conferencePartiMapper.findByConferenceId(conference.getConferenceId().toString());
			conference.setPartiList(partiList);
			rsltList.add(conference);
		}
		return rsltList;
	}

	private List<Object> getPatentListWithPartiInfo(List<PatentVo> patents){
		List<Object> rsltList = new ArrayList<Object>();
		for(PatentVo patent : patents)
		{
			List<PatentPartiVo> partiList = patentPartiMapper.findByPatentId(patent.getPatentId().toString());
			patent.setPartiList(partiList);
			rsltList.add(patent);
		}
		return rsltList;
	}

	private List<Object> getBookListWithPartiInfo(List<BookVo> books){
		List<Object> rsltList = new ArrayList<Object>();
		for(BookVo book : books)
		{
			List<BookPartiVo> partiList = bookPartiMapper.findByBookId(book.getBookId().toString());
			book.setPartiList(partiList);
			rsltList.add(book);
		}
		return rsltList;
	}

	private List<Object> getTechtransListWithPartiInfo(List<TechtransVo> techtransList){
		List<Object> rsltList = new ArrayList<Object>();
		for(TechtransVo techtrans : techtransList)
		{
			List<TechtransPartiVo> partiList = techtransPartiMapper.findByTechtransId(techtrans.getTechtransId().toString());
			techtrans.setPartiList(partiList);
			rsltList.add(techtrans);
		}
		return rsltList;
	}

	private List<Object> getFundingListWithPartiInfo(List<FundingVo> fundings){
		List<Object> rsltList = new ArrayList<Object>();
		for(FundingVo funding : fundings)
		{
			List<FundingPartiVo> partiList = fundingPartiMapper.findByFundingId(funding.getFundingId().toString());
			funding.setPartiList(partiList);
			rsltList.add(funding);
		}
		return rsltList;
	}

	private List<Object> getReportLIstWithPartiInfo(List<ReportVo> reports){
		List<Object> rsltList = new ArrayList<Object>();
		for(ReportVo report : reports)
		{
			List<ReportPartiVo> partiList =  reportPartiMapper.findByReportId(report.getReportId());
			report.setPartiList(partiList);
			rsltList.add(report);
		}
		return rsltList;
	}

	private List<Object> convertToObjectListFromCareerList(List<CareerVo> careerVos){
		List<Object> rsltList = new ArrayList<Object>();
		for(CareerVo career : careerVos) rsltList.add(career);
		return rsltList;
	}

	private List<Object> convertToObjectListFromAwardList(List<AwardVo> awardVos){
		List<Object> rsltList = new ArrayList<Object>();
		for(AwardVo award : awardVos) rsltList.add(award);
		return rsltList;
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

	private List<Object> convertToObjectListFromEtcList(List<EtcVo> etcVos){
		List<Object> rsltList = new ArrayList<Object>();
		for(EtcVo etc : etcVos) rsltList.add(etc);
		return rsltList;
	}

	private List<Object> convertToObjectListFromActivityList(List<ActivityVo> activityVos){
		List<Object> rsltList = new ArrayList<Object>();
		for(ActivityVo activity : activityVos) rsltList.add(activity);
		return rsltList;
	}

	private List<Object> convertToObjectListFromDegreeList(List<DegreeVo> degreeVos){
		List<Object> rsltList = new ArrayList<Object>();
		for(DegreeVo dgree : degreeVos) rsltList.add(dgree);
		return rsltList;
	}


	private String getMakeTemporaryFile(String ext){
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
		String dateStr = dateFormat.format(System.currentTimeMillis());
		return filePath+ File.separator +"resume_temp_"+dateStr+"."+ext;
	}

}
