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
 * 연구과제성과정보(CBO_PA_CONTRACT_MST_NOTE_V) VO
 *  kr.co.argonet.r2rims.erp.vo
 *      ┗ CboPaContractMstNoteVo.java
 *
 * </pre>
 * @date 2017. 1. 10.
 * @version
 * @author : hojkim
 */
@Getter @Setter
public class CboPaContractMstNoteVo {

	private String projectId;
    private String projectCode;
    private String projectPm;
    private String prjno;
    private String projectName;
    private String startDate;
    private String endDate;
    private String custName;
    private String classCategory;
    private String businessName;
    private String attribute5;
    private String techCategory;
    private String techCategoryName;
    private String creationDate;
    private String lastUpdateDate;
    private String researchPart;
    private String fundsSupport;
    private String projectStatusCode;
    private String projectPmnum;

}
