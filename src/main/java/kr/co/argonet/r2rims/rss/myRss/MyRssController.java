package kr.co.argonet.r2rims.rss.myRss;

import kr.co.argonet.r2rims.constant.R2Constant;
import kr.co.argonet.r2rims.core.vo.UserVo;
import kr.co.argonet.r2rims.rss.vo.FavoriteVo;
import kr.co.argonet.r2rims.share.ShareUserService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * <pre>
 *  kr.co.argonet.r2rims.rss.myRSS
 *      ┗ MyRssController.java
 *
 * </pre>
 *
 * @author : woosik
 * @date 2020-02-21
 */

@Controller(value="myRssController")
public class MyRssController {

    @Resource(name = "myRssService")
    private MyRssService myRssService;
    @Resource(name="shareUserService")
    private ShareUserService userService;

    // My Document 리스트
    @RequestMapping(value = "/share/myRss/myDocument")
    private String findMyDocument(ModelMap model, HttpServletRequest req,
                                  @RequestParam(value = "page", defaultValue = "1") String page,
                                  @RequestParam(value = "sort", defaultValue = "date") String sort,
                                  @RequestParam(value = "order", defaultValue = "desc") String order){

        UserVo sessUser = (UserVo) req.getSession().getAttribute(R2Constant.SESSION_USER);
        String userId = sessUser.getUserId();

        int ct = 5;
        int ps = Integer.parseInt(page);
        int totalFavorite;
        int end;

        ps = (ps-1)*ct;   // 페이지 시작부분 index

        totalFavorite = myRssService.totalFavorite(userId);

        if(ps+ct > totalFavorite){
            end = totalFavorite;
        }else{
            end = ps+ct;
        }

        List<FavoriteVo> favoriteList = myRssService.findFavorite(userId, ps, end, sort, order);


        model.addAttribute("pageList", userService.drawPages(Integer.parseInt(page), (double)ct, (double)totalFavorite));

        model.addAttribute("favoriteList",favoriteList);

        model.addAttribute("ps",ps+1);
        model.addAttribute("end",end);
        model.addAttribute("totalFavorite",totalFavorite);
        model.addAttribute("page",page);

        return "/share/aboutRims/mydocument";
    }

    // EDIT Favorite
    @RequestMapping(value = "/editFavorite")
    private @ResponseBody void editMyDocument(ModelMap model, HttpServletRequest req,
                                              @RequestParam("flag") String flag,
                                              @RequestParam("id") String id,
                                              @RequestParam("type") String type,
                                              @RequestParam("url") String url){

        UserVo sessUser = (UserVo) req.getSession().getAttribute(R2Constant.SESSION_USER);

        String userId = sessUser.getUserId();

        /*myRssService.addFavorite(userId, id, flag, type);*/
    }
}
