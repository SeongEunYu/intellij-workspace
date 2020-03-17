package kr.co.argonet.r2rims.analysis.rawdata;

import kr.co.argonet.r2rims.analysis.rawdata.module.RawdataUpdate;
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
 * Rawdata 업데이트 관리를 위한 컨트롤러클래스
 * </pre>
 * @date 2018. 08. 08.
 * @version
 * @author : woo
 */
@Controller(value = "rawdataUpdateController")
public class RawdataUpdateController {

	Logger log = LoggerFactory.getLogger(RawdataUpdateController.class);

	@RequestMapping(value="/rawdataUpdate", method=RequestMethod.GET, produces="application/json;charset=UTF-8")
	public @ResponseBody Map<String, String> rawdataUpdate(
			HttpServletRequest req, HttpServletResponse res
			){
		Map<String, String> result = new HashMap<String, String>();

		try {
			RawdataUpdate rawdataUpdate = new RawdataUpdate();
			rawdataUpdate.rawdataUpdate();

			result.put("code", "010");
			result.put("msg", "Run Rawdata Update ~ ");

		} catch (Exception e) {
			result.put("code", "001");
			result.put("msg", "Fail Rawdata Update ~ ");
		}

		return result;
	}
}