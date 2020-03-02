package kr.co.argonet.r2rims.scholar.vo;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class LectureVo {
	private static final long serialVersionUID = 1L;
	private String profsrEmpno;
	private String profsrNm;
	private String estblYear;
    private String estblSemstr;
    private String estblDeptKor;
    private String lctreClass;
    private String sbjectNmKor;
    private String sbjectNmEng;
    private String sbjectSe;
    private String sbjectNo;
    private String sbjectCode;
    private String lctre;
    private String exper;
    private Integer point;
    private String atnlcNmpr;
    private String engLctreAt;
    private Integer actUnit;

	/*
	profId;			//교수_사번	    PROFSR_EMPNO
	lectureYear;	//개설_년도	    ESTBL_YEAR
	lectureTerm;	//개설_학기     ESTBL_SEMSTR
	subjectNo;		//과목_번호	    SBJECT_NO
	lectureClass;	//분반		    LCTRE_CLASS
	deptName;		//개설_학과     ESTBL_DEPT_KOR
	subTitle;		//과목_명(국문) SBJECT_NM_KOR
	eSubTitle;		//과목_명(영문) SBJECT_NM_ENG
	subjectType;	//과목_구분     SBJECT_SE
	lecture;		//강의		    LCTRE
	lab;			//실험		    EXPER
	credit;			//학점		    POINT
	lCurrent;		//수강_인원	    ATNLC_NMPR
	profNames;		//교수_명	    PROFSR_NM
	oldNo;			//과목_코드     SBJECT_CODE
	englishLec;		//영어_강의_구분      ENG_LCTRE_AT
	actUnit;		//
	*/
}
