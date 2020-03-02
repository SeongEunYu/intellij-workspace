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
 *      ┗ CboPaTaskConMstNoteVo.java
 *
 * </pre>
 * @date 2017. 1. 10.
 * @version
 * @author : hojkim
 */
@Getter @Setter
public class CboPaTaskConMstNoteVo {

	private String projectId;
    private String taskId;
    private String projectCode;
    private String taskNum;
    private String taskManager;
    private String taskName;
    private String taskManagerEmpNo;
    private String projectStatusCode;
    private String startDate;
    private String endDate;
    private String createDate;
    private String lastUpdateDate;


}
