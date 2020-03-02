/*
 * Copyright www.argonet.co.kr
 * All rights reserved.
 *
 */
package kr.co.argonet.r2rims.erp.vo;

import lombok.Getter;
import lombok.Setter;

/**
 *  <pre>
 *  총괄연구참여자정보(CBO_PA_LABOR_NOTE_V) VO
 *  kr.co.argonet.r2rims.erp.vo
 *      ┗ CboPaLaborNoteVo.java
 *
 * </pre>
 * @date 2017. 1. 10.
 * @version
 * @author : hojkim
 */
@Getter @Setter
public class CboPaLaborNoteVo {

	private String headerId;
    private String projectId;
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
