package kr.co.argonet.r2rims.core.vo;

import java.io.Serializable;
import java.util.Date;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class TechtransCntcVo implements Serializable {
	private static final long serialVersionUID = 1L;
	private Integer seqNo;
	private Integer srcId;					/* 소스관리번호 */
	private Integer techtransId;
	private String cntrctManageNo;
	private String cntrctSttDate;			/* 계약시작일자 */
	private String cntrctEndDate;			/* 계약종료일자 */
	private String cntrctAmt;				/* 계약금액 */
//	private String rpmAmt;				/* 기술이전금액(계약금액) */
	private String rpmAmtUnit;				/* 기술이전금액 단위 (KW,US 등) */
	private String techTransrNm;			/* 기술이전명 */
	private String cntcStatus;
	private Date srcModDate;
	private Date srcRegDate;
}