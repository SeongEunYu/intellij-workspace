package kr.co.argonet.r2rims.gotit.vo;

/**
 * <pre>
 *  kr.co.argonet.r2rims.gotit.vo
 *      ┗ SvcMessageVo.java
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
public class SvcMessageVo implements Serializable {
    private Integer msgId;
    private String message;
    private String mesageAdmin;
    private String issueId;
    private String sendYn;
    private String userId;
    private Date regDate;
    private Date sendDate;
}
