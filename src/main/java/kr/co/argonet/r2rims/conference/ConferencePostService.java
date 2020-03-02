package kr.co.argonet.r2rims.conference;

import java.util.List;
import java.util.Map;

/**
 * <pre>
 *  kr.co.argonet.r2rims.conference
 *      ┗ ConferencePostService.java
 *
 * </pre>
 *
 * @author : hojkim
 * @date 2017-07-11
 */
public class ConferencePostService  implements ConferencePostAction{
    @Override
    public List<Map<String, String>> action(Integer conferenceId) {
        return null;
    }

    @Override
    public List<Map<String, String>> deleteAuthrAction(Integer conferenceId, String userId) {
        return null;
    }
}
