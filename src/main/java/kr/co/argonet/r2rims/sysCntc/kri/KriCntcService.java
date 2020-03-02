/*
 * Copyright www.argonet.co.kr
 * All rights reserved.
 *
 */
package kr.co.argonet.r2rims.sysCntc.kri;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import kr.co.argonet.r2rims.core.mapper.KriCntcMapper;
import kr.co.argonet.r2rims.core.vo.ArticleVo;
import kr.co.argonet.r2rims.core.vo.RimsSearchVo;

/**
 * <pre>
 *  kr.co.argonet.r2rims.sysCntc.kri
 *      ┗ KriCntcService.java
 *
 * </pre>
 * @date 2017. 2. 8.
 * @version
 * @author : KIMHOJIN
 */
@Service(value="kriCntcService")
public class KriCntcService {

	Logger log = LoggerFactory.getLogger(KriCntcService.class);

	@Resource(name="kriCntcMapper")
	private KriCntcMapper kriCntcMapper;

	public Integer countNkrdd505ByCond(RimsSearchVo searchVo){
		return kriCntcMapper.countNkrdd505ByCond(searchVo);
	}

	public List<ArticleVo> findNkrdd505ListByCond(RimsSearchVo searchVo){
		return kriCntcMapper.findNkrdd505ListByCond(searchVo);
	}

}
