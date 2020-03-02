package kr.co.argonet.r2rims.kaist.board;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.co.argonet.r2rims.core.vo.AcessModeVo;

/**
 * <pre>
 * KAIST 에서 제공하는 게시판을 사용하기 위한 컨트롤러클래스
 *  kr.co.argonet.r2rims.kaist.board
 *      ┗ KaistBoardController.java
 *
 * </pre>
 * @date 2016. 12. 20.
 * @version
 * @author : hojkim
 */
@Controller(value="kaistBoardController")
public class KaistBoardController {

	Logger log = LoggerFactory.getLogger(KaistBoardController.class);

	@RequestMapping("/kboard")
	public String notice(@ModelAttribute AcessModeVo acessModeVo, ModelMap model) {
		model.addAttribute("acessMode", acessModeVo.getAcessMode());
		return "/board/kboard";
	}

}