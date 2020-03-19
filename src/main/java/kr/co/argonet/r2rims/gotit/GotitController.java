package kr.co.argonet.r2rims.gotit;

import kr.co.argonet.r2rims.constant.R2Constant;
import kr.co.argonet.r2rims.core.vo.UserVo;
import kr.co.argonet.r2rims.gotit.vo.SvcMessageVo;
import kr.co.argonet.r2rims.share.ShareUserService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * <pre>
 *  kr.co.argonet.r2rims.gotit
 *      ┗ GotitController.java
 *
 * </pre>
 *
 * @author : woosik
 * @date 2020-02-25
 */
@Controller(value="gotitController")
public class GotitController {

    @Resource(name="gotitService")
    private GotitService gotitService;

    @RequestMapping(value = "/gotitTop")
    public @ResponseBody List<Map<String, Object>> gotitTop5 (HttpServletRequest req, ModelMap model){

        UserVo sessUser = (UserVo) req.getSession().getAttribute(R2Constant.SESSION_USER);
        String userId = sessUser.getUserId();
        List<Map<String, Object>> gotitTopList = gotitService.findTop5(userId);

        return gotitTopList;
    }

    @RequestMapping(value = "/gotitTocTop")
    public @ResponseBody List<Map<String, Object>> gotitTocTop5 (HttpServletRequest req, ModelMap model){

        UserVo sessUser = (UserVo) req.getSession().getAttribute(R2Constant.SESSION_USER);
        String userId = sessUser.getUserId();
        List<Map<String, Object>> indexMailing = gotitService.findMailingTop5(userId);

        return indexMailing;
    }

}
