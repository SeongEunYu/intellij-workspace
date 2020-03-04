package kr.co.argonet.r2rims.rss.myRss;

import kr.co.argonet.r2rims.rss.mapper.MyRssMapper;
import kr.co.argonet.r2rims.rss.vo.FavoriteVo;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

/**
 * <pre>
 *  kr.co.argonet.r2rims.rss.myRSS
 *      ┗ MyRssService.java
 *
 * </pre>
 *
 * @author : woosik
 * @date 2020-02-21
 */

@Service(value = "myRssService")
public class MyRssService {

    @Resource(name = "myRssMapper")
    private MyRssMapper myRssMapper;

    public List<FavoriteVo> findFavorite (String userId, int ps, int end, String sort, String order){
        List<FavoriteVo> favoriteList = new ArrayList<>();
        favoriteList = myRssMapper.findFavorite(userId, ps, end, sort, order);
        return favoriteList;
    }

    public int totalFavorite (String userId){
        int total = myRssMapper.totalFavorite(userId);
        return total;
    }
}
