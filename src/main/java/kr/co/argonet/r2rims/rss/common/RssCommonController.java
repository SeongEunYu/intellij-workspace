package kr.co.argonet.r2rims.rss.common;

import kr.co.argonet.r2rims.core.annotation.NoAuthCheck;
import kr.co.argonet.r2rims.core.annotation.NoShareSessionCheck;
import org.apache.solr.client.solrj.SolrServerException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * <pre>
 *  kr.co.argonet.r2rims.rss.common
 *      ┗ RssCommonController.java
 *
 * </pre>
 *
 * @author : woosik
 * @date 2020-03-30
 */
@Controller(value="rssCommonController")
public class RssCommonController {

    Logger log = LoggerFactory.getLogger(RssCommonController.class);

    @Resource(name="rssCommonService")
    private RssCommonService rssCommonService;


    // RIS 파일형식 다운로드
    @NoAuthCheck
    @NoShareSessionCheck
    @RequestMapping(value = "/assets/ris/{articleId}", method = RequestMethod.GET)
    public @ResponseBody
    ResponseEntity<InputStreamResource> risFile(HttpServletRequest req, HttpServletResponse res, @PathVariable("articleId") String articleId) throws IOException {
        Date date = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
        String stringDate = sdf.format(date);

        Map<String, Object> articleMap = new HashMap<>();
        articleMap = rssCommonService.findArticleDetail(articleId);

        InputStream resource = null;
        File mfile = null;
        String fileName = "";
        if(!articleMap.isEmpty()){
            log.info("file create");
            mfile = new File("C:/data/gotit/files/article_ris_" + stringDate + ".ris");
            fileName = "article_ris_" + stringDate + ".ris";
            FileWriter writer = null;
            try{
                mfile.createNewFile();
                writer = new FileWriter(mfile, true);
                writer.write("TY  - " + articleMap.get("TY") + "\n");
                List<String> au = (List<String>) articleMap.get("AU");
                if(au.size() > 0) {
                    for (String a : au) {
                        writer.write("AU  - " + a + "\n");
                    }
                }
                writer.write("PY  - " + articleMap.get("PY") + "\n");
                writer.write("DA  - " + articleMap.get("DA") + "\n");
                writer.write("TI  - " + articleMap.get("TI") + "\n");
                writer.write("JO  - " + articleMap.get("JO") + "\n");
                writer.write("SP  - " + articleMap.get("SP") + "\n");
                writer.write("EP  - " + articleMap.get("EP") + "\n");
                writer.write("VL  - " + articleMap.get("VL") + "\n");
                writer.write("IS  - " + articleMap.get("IS") + "\n");
                writer.write("AB  - " + articleMap.get("AB") + "\n");
                writer.write("LA  - " + articleMap.get("LA") + "\n");
                writer.write("SN  - " + articleMap.get("SN") + "\n");
                writer.write("UR  - " + articleMap.get("UR") + "\n");
                writer.write("DO  - " + articleMap.get("DO") + "\n");
                writer.flush();
                log.info("file create done");
            }catch(IOException e){
                e.printStackTrace();
            }

            resource = new FileInputStream(mfile);
        }

//		ResponseEntity.BodyBuilder r = ResponseEntity.ok();
//		if(mfile.length() > 0)
//			r.contentLength(mfile.length());
//		r.contentType(MediaType.parseMediaType("application/octet-stream"));
//		return r.body(new InputStreamResource(resource));
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION,
                        "attachment;filename=\"" + new String(fileName.getBytes("EUC-KR"), "ISO-8859-1") + "\"")
                .contentType(MediaType.parseMediaType("application/octet-stream"))
                .body(new InputStreamResource(resource));
    }
}
