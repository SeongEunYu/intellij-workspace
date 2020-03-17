package kr.co.argonet.r2rims.gotit.vo;

/**
 * <pre>
 *  kr.co.argonet.r2rims.gotit.vo
 *      ┗ SvcIssueVo.java
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
public class SvcIssueVo implements Serializable {
    private String issueId;
    private String issn;
    private String journalName;
    private String volume;
    private String issue;
    private String msgYn;
    private String sendYn;
    private Date regDate;
    private Date sendDate;
    private String identity;
}
