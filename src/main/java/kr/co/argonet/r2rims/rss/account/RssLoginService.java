package kr.co.argonet.r2rims.rss.account;

import kr.co.argonet.r2rims.analysis.utils.ChartUtils;
import kr.co.argonet.r2rims.constant.R2Constant;
import kr.co.argonet.r2rims.core.mapper.MemberMapper;
import kr.co.argonet.r2rims.core.mapper.UserMapper;
import kr.co.argonet.r2rims.core.util.EncryptionUtil;
import kr.co.argonet.r2rims.core.vo.KeywordVo;
import kr.co.argonet.r2rims.core.vo.MemberVo;
import kr.co.argonet.r2rims.core.vo.UserVo;
import kr.co.argonet.r2rims.rss.main.RssMainController;
import kr.co.argonet.r2rims.rss.mapper.RssMainMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * <pre>
 *  kr.co.argonet.r2rims.rss.account
 *      ┗ RssLoginService.java
 *
 * </pre>
 *
 * @author : woosik
 * @date 2020-02-21
 */

@Service(value = "rssLoginService")
public class RssLoginService {

    Logger log = LoggerFactory.getLogger(RssLoginService.class);

    @Resource(name = "userMapper")
    private UserMapper userMapper;
    @Resource(name = "memberMapper")
    private MemberMapper memberMapper;

    @Value("#{sysConf['default.language']}")
    private String defaultLanguage;

    public UserVo loginById(String id){
        log.debug("RssLoginService : loginById");
        Map<String, Object> param = new HashMap<String, Object>();
        param.put("id", id);
        UserVo retVo = userMapper.findByEncptUserId(id);
        id = retVo.getUserId();
        if(retVo == null){
            log.debug("RssLoginService : retVo null");
            MemberVo member = memberMapper.findByEncryptId(id);
            id = member.getUserId();
            if(member != null && member.getUserId() != null)
            {
                retVo = userMapper.findByUserId(id);
                if(retVo == null) retVo = new UserVo();
                retVo.setUserId(member.getUserId());
                retVo.setKorNm(member.getKorNm());
                retVo.setEngNm(member.getEngNm());
                retVo.setDeptKor(member.getPsitnDeptNm());
                retVo.setOfcTelno(member.getTelno());
                retVo.setEmalAddr(member.getEmailAdres());
                retVo.setMgtAt(member.getMgtAt());
                retVo.setLanguageFlag(defaultLanguage);
            }
        }
        else
        {
            log.debug("RssLoginService : retVo not null");
            retVo.setAdminDvsCd(R2Constant.RESEARCHER_DVS_CD);
        }
        return retVo;
    }


    // 개발 서버 반영시 삭제
    public UserVo loginById2(String id){
        log.debug("RssLoginService : loginById");
        Map<String, Object> param = new HashMap<String, Object>();
        param.put("id", id);
        UserVo retVo = userMapper.findByUserId(id);
        id = retVo.getUserId();
        if(retVo == null){
            log.debug("RssLoginService : retVo null");
            MemberVo member = memberMapper.findByUserId(id);
            id = member.getUserId();
            if(member != null && member.getUserId() != null)
            {
                retVo = userMapper.findByUserId(id);
                if(retVo == null) retVo = new UserVo();
                retVo.setUserId(member.getUserId());
                retVo.setKorNm(member.getKorNm());
                retVo.setEngNm(member.getEngNm());
                retVo.setDeptKor(member.getPsitnDeptNm());
                retVo.setOfcTelno(member.getTelno());
                retVo.setEmalAddr(member.getEmailAdres());
                retVo.setMgtAt(member.getMgtAt());
                retVo.setLanguageFlag(defaultLanguage);
            }
        }
        else
        {
            log.debug("RssLoginService : retVo not null");
            retVo.setAdminDvsCd(R2Constant.RESEARCHER_DVS_CD);
        }
        return retVo;
    }
}
