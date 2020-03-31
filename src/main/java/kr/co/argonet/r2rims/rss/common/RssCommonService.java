package kr.co.argonet.r2rims.rss.common;

import kr.co.argonet.r2rims.core.mapper.ArticleMapper;
import kr.co.argonet.r2rims.core.vo.*;
import kr.co.argonet.r2rims.rss.mapper.RssCommonMapper;
import kr.co.argonet.r2rims.util.StringUtil;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * <pre>
 *  kr.co.argonet.r2rims.rss.common
 *      ┗ CommonService.java
 *
 * </pre>
 *
 * @author : woosik
 * @date 2020-03-30
 */

@Service(value = "rssCommonService")
public class RssCommonService {

    @Resource(name = "articleMapper")
    private ArticleMapper articleMapper;
    @Resource(name = "rssCommonMapper")
    private RssCommonMapper commonMapper;


    public Map<String, Object> findArticleDetail(String articleId) {

        Map<String, Object> resultMap = new HashMap<>();
        ArticleVo articleVo = articleMapper.findForDetail(articleId);	//논문 상세내용 (원문파일 ID 포함)
        List<Map<String, Object>> articlePartiVoList = commonMapper.findPrtcpntIdListByArticleId(articleId);	//저자명 리스트

        //키워드, content 세팅
        setContentKeyword(articleVo);

//        resultMap.put("articleVo", articleVo);
//        resultMap.put("articlePartiVoList", articlePartiVoList);

        resultMap.put("TY", "JOUR");

        List<String> author = new ArrayList<>();
        for (Map<String, Object> map : articlePartiVoList) {
            if (map.get("PRTCPNT_FULL_NM") != null) {
                author.add(map.get("PRTCPNT_FULL_NM").toString());
            } else {
                author.add(map.get("PRTCPNT_NM").toString());
            }
        }
        if(!author.isEmpty() || author != null){
            resultMap.put("AU", author);
        } else {
            resultMap.put("AU", "");
        }

        if(articleVo.getPblcYm().length() == 4){
            resultMap.put("PY", articleVo.getPblcYm());
        } else if(articleVo.getPblcYm().length() > 4 && articleVo.getPblcYm().length() < 7){
            resultMap.put("PY", articleVo.getPblcYm().substring(0,5));
            resultMap.put("DA", articleVo.getPblcYm().substring(0,5) + "/" + articleVo.getPblcYm().substring(5));
        } else if(articleVo.getPblcYm().length() == 8){
            resultMap.put("PY", articleVo.getPblcYm().substring(0,5));
            resultMap.put("DA", articleVo.getPblcYm().substring(0,5) + "/" + articleVo.getPblcYm().substring(5,7) + "/" + articleVo.getPblcYm().substring(7));
        }

        if(articleVo.getOrgLangPprNm() != null){
            resultMap.put("TI", articleVo.getOrgLangPprNm());
        } else {
            resultMap.put("TI", "");
        }

        if(articleVo.getScjnlNm() != null){
            resultMap.put("JO", articleVo.getScjnlNm());
        } else {
            resultMap.put("JO", "");
        }

        if(articleVo.getSttPage() != null){
            resultMap.put("SP", articleVo.getSttPage());
        } else {
            resultMap.put("SP", "");
        }

        if(articleVo.getEndPage() != null){
            resultMap.put("EP", articleVo.getEndPage());
        } else {
            resultMap.put("EP", "");
        }

        if(articleVo.getVolume() != null){
            resultMap.put("VL", articleVo.getVolume());
        } else {
            resultMap.put("VL", "");
        }

        if(articleVo.getIssue() != null){
            resultMap.put("IS", articleVo.getIssue());
        } else {
            resultMap.put("IS", "");
        }

        if(articleVo.getAbstCntn() != null){
            resultMap.put("AB", articleVo.getAbstCntn());
        } else {
            resultMap.put("AB", "");
        }

        if(articleVo.getPblcNtnCd() != null){
            resultMap.put("LA", articleVo.getPblcNtnCd());
        } else {
            resultMap.put("LA", "");
        }

        if(articleVo.getEissnNo() != null){
            resultMap.put("SN", articleVo.getEissnNo());
        } else {
            resultMap.put("SN", "");
        }

        if(articleVo.getDoi() != null){
            resultMap.put("UR", "https://doi.org/" + articleVo.getDoi());
        } else {
            resultMap.put("UR", "");
        }

        if(articleVo.getDoi() != null){
            resultMap.put("DO", articleVo.getDoi());
        } else {
            resultMap.put("DO", "");
        }

        return resultMap;
    }

    public void setContentKeyword(ArticleVo articleVo){
        NumberFormat nf = NumberFormat.getInstance();

        //Content 세팅
        List<String> content = new ArrayList<>();
        KeywordVo keywordVo = new KeywordVo();

        keywordVo.setRsltId(articleVo.getArticleId());
        keywordVo.setRsltType("ART");
        keywordVo.setSrc("ATH");	//저자키워드 추출

        //content 내용 세팅
        if(articleVo.getScjnlNm() != null){
            content.add("<span style='font-style:italic'>"+articleVo.getScjnlNm()+"</span>");
        }
        if(articleVo.getVolume() != null){
            content.add("v."+articleVo.getVolume());
        }
        if(articleVo.getIssue() != null){
            content.add("no."+articleVo.getIssue());
        }
        if(articleVo.getEndPage() != null && StringUtil.isNumeric(articleVo.getSttPage()) && StringUtil.isNumeric(articleVo.getEndPage()) && !articleVo.getEndPage().contains("-")){
            if(!articleVo.getEndPage().equals("") || !articleVo.getSttPage().equals("")){
                content.add("pp."+nf.format(Long.parseLong(articleVo.getSttPage()))+" - "+nf.format(Long.parseLong(articleVo.getEndPage())));
            }
        }
        if(articleVo.getPblcYm() != null){
            String pblcYm;
            if(articleVo.getPblcYm().length() == 4){
                pblcYm = articleVo.getPblcYm();
            }else{
                pblcYm = articleVo.getPblcYm().substring(0,4) + "-" + articleVo.getPblcYm().substring(4,6);
            }
            content.add(pblcYm);
        }

        articleVo.setContent(StringUtils.join(content,", "));
    }
}
