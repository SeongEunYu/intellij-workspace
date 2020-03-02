package kr.co.argonet.r2rims.user;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import kr.co.argonet.r2rims.core.vo.RimsSearchVo;
import kr.co.argonet.r2rims.core.vo.UserVo;
import kr.co.argonet.r2rims.erp.mapper.ErpUserMapper;


/**
 * <pre>
 * ERP 유저 검색을 위한 서비스클래스
 *  kr.co.argonet.r2rims.user
 *      ┗ ErpUserService.java
 *
 * </pre>
 * @date 2016. 12. 20.
 * @version
 * @author : hojkim
 */
@Service(value = "erpUserService")
public class ErpUserService {

	Logger log = LoggerFactory.getLogger(ErpUserService.class);

	@Resource(name = "erpUserMapper")
	private ErpUserMapper erpUserMapper;

	public Integer countByKeyword(String keyword){
		return erpUserMapper.countByKeyword(keyword);
	}

	public Integer countByKeyword(RimsSearchVo searchVo){
		return erpUserMapper.countByKeyword(searchVo);
	}

	public List<UserVo> findUserListByKeyword(RimsSearchVo searchVo){
		return erpUserMapper.findUserListByKeyword(searchVo);
	}

}
