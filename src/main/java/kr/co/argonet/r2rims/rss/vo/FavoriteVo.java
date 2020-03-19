package kr.co.argonet.r2rims.rss.vo;

/**
 * <pre>
 *  kr.co.argonet.r2rims.myRSS.vo
 *      ┗ MyDocumentVo.java
 *
 * </pre>
 *
 * @author : woosik
 * @date 2020-02-21
 */

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serializable;
import java.util.Date;

@Getter @Setter @ToString
public class FavoriteVo implements Serializable {
    private Integer no;
    private String title;
    private String svcgrp;
    private Date regDate;
    private String solution;
    private String dataId;
    private String url;
    private String userId;
    private Integer recIssueNo;
    private String pubYear;
    private String volume;
    private String issue;
    private String page;
    private String clgNm;
    private String deptNm;
    private String author;
    private String issn;
    private String isOA;
}
