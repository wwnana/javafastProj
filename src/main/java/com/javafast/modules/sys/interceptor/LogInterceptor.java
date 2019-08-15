package com.javafast.modules.sys.interceptor;

import java.text.SimpleDateFormat;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.NamedThreadLocal;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.javafast.common.service.BaseService;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.MD5Util;
import com.javafast.modules.sys.service.UserService;
import com.javafast.modules.sys.utils.AccountUtils;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.LogUtils;

/**
 * 日志拦截器
 */
public class LogInterceptor extends BaseService implements HandlerInterceptor {

	@Autowired
	private UserService userService;
	
	private static final ThreadLocal<Long> startTimeThreadLocal =
			new NamedThreadLocal<Long>("ThreadLocal StartTime");
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, 
			Object handler) throws Exception {
		if (logger.isDebugEnabled()){
			long beginTime = System.currentTimeMillis();//1、开始时间  
	        startTimeThreadLocal.set(beginTime);		//线程绑定变量（该数据只有当前请求的线程可见）  
	        logger.debug("开始计时: {}  URI: {}", new SimpleDateFormat("hh:mm:ss.SSS")
	        	.format(beginTime), request.getRequestURI());
		}
		
		String requestPath = request.getRequestURI();
		System.out.println(requestPath);
		
		//包含路径 opp:开放接口，但是需要校验KEY
		if (requestPath.contains("opp")) {
			
			String dataType = request.getParameter("dataType");//'终端类型  0：后台， 2：微信， 3：网站， 4：安卓， 5：苹果';
			String mobile = request.getParameter("mobile");
			String appSecret = request.getParameter("appSecret");
			String secret = MD5Util.string2MD5(mobile + Contants.APP_KEY);
			if(appSecret == null || !appSecret.equals(secret)){
				System.out.println("警告：无效的appSecret");
				//return false;
			}
		}
		
		//包含路径 app:APP请求接口，需要校验token
		if (requestPath.contains("app") && !requestPath.contains("wechat")) {

			String dataType = request.getParameter("dataType");//'终端类型   1：后台， 2：微信， 3：网站， 4：安卓， 5：苹果';
			System.out.println("提示：终端'"+dataType);
			
			String userId = request.getParameter("userId");
			String token = request.getParameter("token");
			
			System.out.println("会员userId:"+userId+",会员token:"+token);
			
			//会员TOKEN身份校验
			boolean flag = userService.checkToken(userId, token);
			
			if(!flag){
				System.out.println("警告：身份校验不通过");
				return false;
			}
		}
		
		//包含路径 api:开放接口，但是需要校验KEY
		if (requestPath.contains("api")) {
			
			String accountId = request.getParameter("accountId");
			String apiSecret = request.getParameter("apiSecret");
			if(StringUtils.isBlank(accountId) || StringUtils.isBlank(apiSecret)){	
				return false;
			}
			
			if(!AccountUtils.checkKeySecret(accountId, apiSecret)){				
				System.out.println("警告：无效的apiSecret");
				return false;
			}
		}
		return true;
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, 
			ModelAndView modelAndView) throws Exception {
		if (modelAndView != null){
			if (logger.isDebugEnabled())
				logger.info("ViewName: " + modelAndView.getViewName());
		}
	}

	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, 
			Object handler, Exception ex) throws Exception {

		// 保存日志
		LogUtils.saveLog(request, handler, ex, null);
		
		// 打印JVM信息。
		if (logger.isDebugEnabled()){
			long beginTime = startTimeThreadLocal.get();//得到线程绑定的局部变量（开始时间）  
			long endTime = System.currentTimeMillis(); 	//2、结束时间  
	        logger.debug("计时结束：{}  耗时：{}  URI: {}  最大内存: {}m  已分配内存: {}m  已分配内存中的剩余空间: {}m  最大可用内存: {}m",
	        		new SimpleDateFormat("hh:mm:ss.SSS").format(endTime), DateUtils.formatDateTime(endTime - beginTime),
					request.getRequestURI(), Runtime.getRuntime().maxMemory()/1024/1024, Runtime.getRuntime().totalMemory()/1024/1024, Runtime.getRuntime().freeMemory()/1024/1024, 
					(Runtime.getRuntime().maxMemory()-Runtime.getRuntime().totalMemory()+Runtime.getRuntime().freeMemory())/1024/1024); 
		}
		
	}

}
