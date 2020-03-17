package kr.co.argonet.r2rims.sysCntc.syncrslt.module;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * <pre>
 *  kr.co.argonet.r2rims.sysCntc.syncrslt.module
 *      ┗ SyncExhibitionService.java
 *
 * </pre>
 *
 * @author : hojkim
 * @date 2018-09-07
 */
public class SyncExhibitionService extends SyncExhibition {

    Logger log = LoggerFactory.getLogger(SyncExhibitionService.class);

    public void sync() {
        System.out.println(syncType);
        System.out.println(regUserId);
        System.out.println(stdrDate);
    }
}
