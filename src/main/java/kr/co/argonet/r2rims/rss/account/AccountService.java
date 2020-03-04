package kr.co.argonet.r2rims.rss.account;

import kr.co.argonet.r2rims.core.account.Account;
import kr.co.argonet.r2rims.core.index.IndexService;
import kr.co.argonet.r2rims.core.mapper.UserMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.annotation.Resource;
import java.util.Map;

public class AccountService implements Account {

	Logger log = LoggerFactory.getLogger(IndexService.class);

	@Resource(name="userMapper")
	private UserMapper userMapper;

	public String getLoginPage() {
		return "index/admin_login";
	}

	public String join(Map<String, String> param) {
		return null;
	}

	public String findPwd(Map<String, String> param) {
		return null;
	}

	public String changePwd(Map<String, String> param) {
		return null;
	}

}
