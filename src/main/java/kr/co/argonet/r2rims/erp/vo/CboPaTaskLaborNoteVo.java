/*
 * Copyright www.argonet.co.kr
 * All rights reserved.
 *
 */
package kr.co.argonet.r2rims.erp.vo;

import lombok.Getter;
import lombok.Setter;

/**
 * <pre>
 *  kr.co.argonet.r2rims.erp.vo
 *      ┗ CboPaTaskLaborNoteVo.java
 *
 * </pre>
 * @date 2017. 1. 10.
 * @version
 * @author : hojkim
 */
@Getter @Setter
public class CboPaTaskLaborNoteVo {

	private String headerId;
	private String projectId;
	private String taskId;
	private String personName;
	private String employeeNumber;
	private String laborType;
	private String org;
	private String grade;
	private String scholarship;
	private String checkFlag;
	private String invitedRate;
	private String startDate;
	private String endDate;
	private String creationDate;
	private String lastUpdateDate;
}
