package kr.co.argonet.r2rims.book;

import java.util.List;
import java.util.Map;

/**
 * <pre>
 *  kr.co.argonet.r2rims.book
 *      ┗ BookPostService.java
 *
 * </pre>
 *
 * @author : hojkim
 * @date 2017-07-11
 */
public class BookPostService implements BookPostAction{

    @Override
    public List<Map<String, String>> action(Integer bookId) {
        return null;
    }

    @Override
    public List<Map<String, String>> deleteAuthrAction(Integer bookId, String userId) {
        return null;
    }
}
