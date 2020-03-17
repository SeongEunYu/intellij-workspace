package kr.co.argonet.r2rims.sysCntc.blncUpdate;

import kr.co.argonet.r2rims.sysCntc.blncUpdate.module.ArticlePartiBlncAgcNmUpdate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.Map;

/**
 * <pre>
 * BlncAgcNm 업데이트 관리를 위한 컨트롤러클래스
 * </pre>
 * @date 2019. 03. 29.
 * @version
 * @author : woo
 */
@Controller(value = "blncAgcNmUpdateController")
public class BlncAgcNmUpdateController {

	Logger log = LoggerFactory.getLogger(BlncAgcNmUpdateController.class);

	@RequestMapping(value="/artPartiBlncAgcNmUpdate", method=RequestMethod.GET, produces="application/json;charset=UTF-8")
	public @ResponseBody Map<String, String> artPartiBlncAgcNmUpdate(
			HttpServletRequest req, HttpServletResponse res
			){
		Map<String, String> result = new HashMap<String, String>();

		try {
			ArticlePartiBlncAgcNmUpdate articlePartiBlncAgcNmUpdate = new ArticlePartiBlncAgcNmUpdate();
			articlePartiBlncAgcNmUpdate.updateArticlePartiBlngAgcNm();

			result.put("code", "010");
			result.put("msg", "Run ArticlePartiBlngAgcNm Update ~ ");

		} catch (Exception e) {
			result.put("code", "001");
			result.put("msg", "Fail ArticlePartiBlngAgcNm Update ~ ");
		}

		return result;
	}
}