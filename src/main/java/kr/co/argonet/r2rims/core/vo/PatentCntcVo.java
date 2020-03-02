/*
 * Copyright www.argonet.co.kr
 * All rights reserved.
 *
 */
package kr.co.argonet.r2rims.core.vo;

import java.util.Date;
import java.util.List;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/**
 * <pre>
 *  kr.co.argonet.r2rims.core.vo
 *      ┗ PatentCntcVo.java
 *
 * </pre>
 * @date 2016. 12. 5.
 * @version
 * @author : hojkim
 */
@Getter @Setter @ToString
public class PatentCntcVo {

	private static final long serialVersionUID = 1L;
	private Integer seqNo;
	private Integer srcId;					/* 소스관리번호 */
	private Integer pmsId;
	private Integer modHistId;
	private String familyCode;
	private Integer patentId;
	private String cntcStatus;
	private Date srcModDate;
	private Date srcRegDate;
	private Date regDate;
	private String regUserId;
	private String regUserNm;
	private Date modDate;
	private String modUserId;
	private String modUserNm;

	List<Integer> srcIds;
}
