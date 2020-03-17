/*
 * Copyright www.argonet.co.kr
 * All rights reserved.
 *
 */
package kr.co.argonet.r2rims.core.interceptor;

import java.io.PrintWriter;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import kr.co.argonet.r2rims.constant.R2Constant;
import kr.co.argonet.r2rims.core.annotation.NoInfoPrtcAgreCheck;

/**
 * <pre>
 * 개인정보보호 동의를 위한 인터셉터클래스
 *  kr.co.argonet.r2rims.core.interceptor
 *      ┗ InfoPrtcAgreInterceptor.java
 *
 * </pre>
 * @date 2016. 12. 18.
 * @version
 * @author : hojkim
 */
public class InfoPrtcAgreInterceptor extends HandlerInterceptorAdapter{

	Logger log = LoggerFactory.getLogger(InfoPrtcAgreInterceptor.class);

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {


		NoInfoPrtcAgreCheck infoPrtcAgreCheck = ((HandlerMethod)handler).getMethodAnnotation(NoInfoPrtcAgreCheck.class);

		if(infoPrtcAgreCheck == null)
		{

			HttpSession session = request.getSession();
			Map<String, String> authMap = (Map<String, String>) session.getAttribute("auth");
			if(authMap != null && !R2Constant.RESEARCHER_DVS_CD.equals(authMap.get("adminDvsCd")))
			{
				if("N".equals(authMap.get("infoPrtcAgreAt")))
				{
					String domain =  StringUtils.strip(request.getRequestURI().replace(request.getContextPath(), ""),"/");
					String path = domain;
					while (path.indexOf("/") != -1) path = path.substring(0, path.lastIndexOf("/"));
					response.setCharacterEncoding("UTF-8");
					response.setContentType("text/html;charset:UTF-8");
					PrintWriter pw = response.getWriter();
					pw.println("<link type=\"text/css\" href=\""+request.getContextPath()+"/js/dhtmlx/skins/terrace/dhtmlx.css\" rel=\"stylesheet\" />");
					pw.println("<script type=\"text/javascript\" src=\""+request.getContextPath()+"/js/jquery/jquery-1.11.3.min.js\"></script>");
					pw.println("<script type=\"text/javascript\" src=\""+request.getContextPath()+"/js/dhtmlx/dhtmlx.js\"></script>");
					pw.println("<script type='text/javascript'>");
					pw.println("$(document).ready(function(){");
					pw.println(" $('.header_wrap, .nav_wrap').remove(); ");
					pw.println(" dhtmlx.alert({type:\"alert-warning\",text:\"개인정보보호법에 따른 <br/>개인정보보호 준수에 동의해 주십시오.\",callback:function(){document.location.href='"+request.getContextPath()+"/"+path+"/main.do';}})");
					pw.println("});");
					pw.println("</script>");
					pw.close();
					//response.sendRedirect(request.getContextPath()+"/index/login.do");
					return false;
				}
				else
				{
					log.debug("current user infoPrtcAgre is Y : {}", authMap.get("userId"));
					return true;
				}

			}
			else
			{
				if(authMap != null)
					log.debug("current user is reseaecher : {} - {}", authMap.get("userId"), authMap.get("adminDvsCd"));
				return true;
			}
		}
		else
		{
			return true;
		}

	}

}
