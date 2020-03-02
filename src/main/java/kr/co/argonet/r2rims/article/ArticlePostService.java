package kr.co.argonet.r2rims.article;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.ContextLoaderListener;

import kr.co.argonet.r2rims.core.mapper.ArticleMapper;

/**
 * <pre>
 *  kr.co.argonet.r2rims.article
 *      ┗ ArticlePostService.java
 *
 * </pre>
 *
 * @author : hojkim
 * @date 2017-07-11
 */
public class ArticlePostService implements ArticlePostAction {

    @Override
    public List<Map<String, String>> action(Integer articleId) {
        return null;
    }

    @Override
    public List<Map<String, String>> deleteAuthrAction(Integer articleId, String userId) {
        return null;
    }
}
