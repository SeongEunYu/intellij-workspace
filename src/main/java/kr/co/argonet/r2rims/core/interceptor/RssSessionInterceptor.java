package kr.co.argonet.r2rims.core.interceptor;

import kr.co.argonet.r2rims.constant.R2Constant;
import kr.co.argonet.r2rims.core.annotation.NoLoginCheck;
import kr.co.argonet.r2rims.core.vo.UserVo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.PrintWriter;

/**
 * <pre>
 * 세션 유무를 체크하는 인터셉터
 *  kr.co.argonet.r2rims.core.interceptor
 *      ┗ RssSessionInterceptor.java
 *
 * </pre>
 */
public class RssSessionInterceptor extends HandlerInterceptorAdapter{

	Logger log = LoggerFactory.getLogger(RssSessionInterceptor.class);

	@Value("#{sysConf['system.url']}")
	private String systemUrl;

	@Override
	public boolean preHandle(HttpServletRequest request,
			HttpServletResponse response, Object handler) throws Exception {

		log.debug("session check Interceptor : preHandle");

		NoLoginCheck usingAuth = ((HandlerMethod)handler).getMethodAnnotation(NoLoginCheck.class);

		if(usingAuth == null)
		{
			HttpSession session = request.getSession();
			UserVo loginUser = (UserVo) session.getAttribute(R2Constant.LOGIN_USER);
			if(loginUser == null || loginUser.getUserId() == null)
			{
				response.setCharacterEncoding("UTF-8");
				response.setContentType("text/html;charset:UTF-8");
				PrintWriter pw = response.getWriter();
				pw.println("<link type=\"text/css\" href=\""+request.getContextPath()+"/js/dhtmlx/skins/terrace/dhtmlx.css\" rel=\"stylesheet\" />");
				pw.println("<script type=\"text/javascript\" src=\""+request.getContextPath()+"/js/jquery/jquery-1.11.3.min.js\"></script>");
				pw.println("<script type=\"text/javascript\" src=\""+request.getContextPath()+"/js/dhtmlx/dhtmlx.js\"></script>");
				pw.println("<script type='text/javascript'>");
				pw.println(" $('.header_wrap, .nav_wrap').remove(); ");
				pw.println(" $(document).ready(function(){");
				pw.println(" dhtmlx.alert({type:\"alert-warning\",text:\"세션종료되었습니다.\",callback:function(){location.href='"+systemUrl+"';}})");
				pw.println("});");
				pw.println("</script>");
				pw.close();
				return false;
			}
			else
			{
				log.debug("current login user : {} - {}", loginUser.getUserId(), loginUser.getKorNm());
				return true;
			}
		}
		else
		{
			return true;
		}
	}
}
