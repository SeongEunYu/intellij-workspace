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
 * 총괄연구비정보(CBO_PA_BUDGET_NOTE_NEW_V)
 *  kr.co.argonet.r2rims.erp.vo
 *      ┗ CboPaBudgetNoteVo.java
 *
 * </pre>
 * @date 2017. 1. 10.
 * @version
 * @author : hojkim
 */
@Getter @Setter
public class CboPaBudgetNoteVo {

    private String contractId;
    private String projectId;
    private String contractYear;
    private String curRndAmount;
    private String rndAmount;
    private String overheadAmount;
    private String inFund;
    private String outFund;
    private String laborSch;
    private String budgetAmount;
    private String creationDate;
    private String lastUpdateDate;

}
