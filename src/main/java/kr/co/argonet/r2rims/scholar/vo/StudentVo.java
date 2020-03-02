package kr.co.argonet.r2rims.scholar.vo;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class StudentVo {
	private static final long serialVersionUID = 1L;
	private String profsrEmpno;
	private String profsrNm;
	private String stdntNo;
	private String stdntNm;
	private String stdntFirstNm;
	private String stdntLastNm;
	private String deptKor;
	private String crseSeNm;
	private String crseSeCode;
	private String sknrgsStatus;
	private String grdtnDate;
	private String coachingSe;

	/*
	private String profId;			//교수사번			PROFSR_EMPNO
	private String studentNo;		//학생번호			STDNT_NO
	private String kName;			//학생이름			STDNT_NM
	private String eFirstName;		//학생영문성		STDNT_FIRST_NM
	private String eLastName;		//학생영문이름		STDNT_LAST_NM
	private String detpName;		//소속학과			DEPT_KOR
	private String courseName;		//과정구분			CRSE_SE
	private String statusName;		//학적상태			SKNRGS_STATUS
	private String graduateDate;	//졸업일자			GRDTN_DATE
	private String teachId;			//구분				COACHING_SE
	*/

}
