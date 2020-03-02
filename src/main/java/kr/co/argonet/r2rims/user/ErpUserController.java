package kr.co.argonet.r2rims.user;


import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import kr.co.argonet.r2rims.core.view.XlsxView;
import kr.co.argonet.r2rims.core.vo.RimsSearchVo;
import kr.co.argonet.r2rims.core.vo.UserVo;

/**
 * <pre>
 * ERP 유저 조회를 위한 컨트롤러클래스
 *  kr.co.argonet.r2rims.user
 *      ┗ ErpUserController.java
 *
 * </pre>
 * @date 2016. 12. 20.
 * @version
 * @author : hojkim
 */
@Controller(value="erpUserController")
public class ErpUserController {

	Logger log = LoggerFactory.getLogger(ErpUserController.class);

	@Resource(name="erpUserService")
	private ErpUserService erpUserService;

	@Autowired
	XlsxView xlsxView;

	@RequestMapping("/erpUser/findUserList")
	public ModelAndView findErpUserList(
			@RequestParam(value = "posStart", required = false, defaultValue = "0") String posStart,
			@RequestParam(value = "count", required = false, defaultValue = "100") String count,
			@ModelAttribute RimsSearchVo searchVo){
		ModelAndView mvo = new ModelAndView();

		int ps = Integer.parseInt(posStart); // 페이지 숫자
		int ct = Integer.parseInt(count); // 페이지당 row수
		searchVo.setPs(ps);
		searchVo.setCt(ct);

		Integer totalCount = erpUserService.countByKeyword(searchVo);
		List<UserVo> userList = erpUserService.findUserListByKeyword(searchVo);
		mvo.addObject("totalCount", totalCount);
		mvo.addObject("posStart", posStart);
		mvo.addObject("userList", userList);
		mvo.setViewName("user/erpUser_grid");
		return mvo;
	}



}