/*
 * Copyright www.argonet.co.kr
 * All rights reserved.
 *
 */
package kr.co.argonet.r2rims.gotit;

import kr.co.argonet.r2rims.gotit.mapper.GotitMapper;
import kr.co.argonet.r2rims.gotit.vo.SvcMessageVo;
import kr.co.argonet.r2rims.rss.vo.FavoriteVo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
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

	// gotit 목차정보 서비스
	public List<Map<String, Object>> findMailingTop5(String userId){
		List<Map<String, Object>> indexList = gotitMapper.findMailingTop5(userId);
		return indexList;
	}

	// 목차정보 서비스 total count
	public int totalMailCount(String userId){
		int count = gotitMapper.totalMail(userId);
		return count;
	}

	// gotit 목차정보 서비스 목록
	public List<Map<String, Object>> getMailList(String userId, int ps, int ct, String sort, String order){
		List<Map<String, Object>> mailList = new ArrayList<>();
		mailList = gotitMapper.findMailList(userId, ps, ct, sort, order);
		return mailList;
	}

	// gotit 목차정보 서비스 논문목록
	public List<Map<String, Object>> getMailArticle(String msgId, String userId){
		List<Map<String, Object>> articleList = gotitMapper.getMailArticle(msgId, userId);
		return articleList;
	}
}
