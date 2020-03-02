/*
 * Copyright www.argonet.co.kr
 * All rights reserved.
 *
 */
package kr.co.argonet.r2rims.gotit;

import com.lowagie.text.Document;
import com.lowagie.text.PageSize;
import com.lowagie.text.rtf.RtfWriter2;
import kr.co.argonet.r2rims.core.resume.ResumeInterface;
import kr.co.argonet.r2rims.core.resume.ResumeLecture;
import kr.co.argonet.r2rims.core.resume.ResumeStudent;
import kr.co.argonet.r2rims.core.vo.UserVo;
import kr.co.argonet.r2rims.gotit.mapper.GotitMapper;
import kr.co.argonet.r2rims.scholar.vo.LectureVo;
import kr.co.argonet.r2rims.scholar.vo.StudentVo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.util.FileCopyUtils;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * <pre>
 * gotit 서비스
 *  kr.co.argonet.r2rims.gotit.service
 *      ┗ gotitService.java
 *
 * </pre>
 * @date 2020. 02. 25.
 * @version
 * @author : woosik
 */
@Service("gotitService")
public class GotitService {

	Logger log = LoggerFactory.getLogger(GotitService.class);

	@Resource(name="gotitMapper")
	private GotitMapper gotitMapper;

	// gotit 최근 추천 리스트 (recently 5 count)
	public List<Map<String, Object>> findTop5(String userId){

		List<Map<String, Object>> gotitTopList = gotitMapper.findTop5(userId);

		return gotitTopList;
	}

	// gotit favorite 리스트
	public List<Map<String, Object>> findFavorite(String userId){

		List<Map<String, Object>> gotitList = gotitMapper.findFavorite(userId);

		return gotitList;
	}
}
