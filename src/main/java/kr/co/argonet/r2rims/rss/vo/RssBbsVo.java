package kr.co.argonet.r2rims.rss.vo;

import java.io.Serializable;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import kr.co.argonet.r2rims.core.vo.FileVo;
import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class RssBbsVo implements Serializable, Comparable<RssBbsVo> {
	private static final long serialVersionUID = 1L;
	private Integer bbsId;
	private String content;
	private String delDvsCd;
	private String languageFlag;
	private Date modDate;
	private String modUserId;
	private String modUserNm;
	private Date regDate;
	private String regUserId;
	private String regUserNm;
	private String title;
	private String type;
	private int viewCnt;
	private String noticeSttDate;
	private String noticeEndDate;
	private String url;
	private List<FileVo> fileList;
	private Integer[] deleteFileIds;

	private String trgetSe;
	private String trgetCd;
	private String trgetNm;

	private String popupYn;

	@Override
	public int compareTo(RssBbsVo rbv) {
		return this.noticeSttDate.compareTo(rbv.noticeSttDate);
	}
}