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
 *      ┗ CboPaTaskBudgetNoteVo.java
 *
 * </pre>
 * @date 2017. 1. 10.
 * @version
 * @author : hojkim
 */
@Getter @Setter
public class CboPaTaskBudgetNoteVo {

	private String projectId;
    private String taskId;
    private String projectCode;
    private String taskNumber;
    private String projectName;
    private String startDate;
    private String endDate;
    private String taskManager;
    private String rowCost;
    private String laborProf;
    private String laborSch;
    private String createDate;
    private String lastUpdateDate;

}
