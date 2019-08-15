package com.javafast.api.qywx.system.api;

import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.alibaba.fastjson.JSONObject;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.javafast.common.utils.HttpRequestUtils;
import com.javafast.api.qywx.core.api.WxAccessTokenAPI;
import com.javafast.api.qywx.core.entity.AccessToken;
import com.javafast.api.qywx.system.entity.WxDepartment;

/**
 * 企业微信 - 部门
 * @author JavaFast
 */
public class WxDepartmentAPI {

	private static final Logger logger = LoggerFactory.getLogger(WxDepartmentAPI.class);
	
	//创建部门（POST）   
	private static String department_create_url = "https://qyapi.weixin.qq.com/cgi-bin/department/create?access_token=ACCESS_TOKEN";  
		
	//更新部门（POST）   
	private static String department_update_url = "https://qyapi.weixin.qq.com/cgi-bin/department/update?access_token=ACCESS_TOKEN";  
		
	//删除部门（GET）   
	private static String department_delete_url = "https://qyapi.weixin.qq.com/cgi-bin/department/delete?access_token=ACCESS_TOKEN&id=ID";  
		
	//获取部门列表（GET） 
	private static String department_list_url = "https://qyapi.weixin.qq.com/cgi-bin/department/list?access_token=ACCESS_TOKEN";  

	/**
	 * 创建部门
	 * @param department
	 * @param accessToken
	 */
	public static boolean createDepartment(WxDepartment department, String accessToken){
		
		// 拼装创建部门的url  
	    String requestUrl = department_create_url.replace("ACCESS_TOKEN", accessToken);  
	   
	    // 将菜单对象转换成json字符串  
	    String jsonParam = JSONObject.toJSONString(department);  
	    
	    // 调用接口获取创建部门
	    JSONObject jsonObject = HttpRequestUtils.httpsRequest(requestUrl, "POST", jsonParam);
	    
	    if (null != jsonObject) {
	    	int errcode = jsonObject.getIntValue("errcode");
	    	if(errcode == 0)
	    		return true;
	    }
	    return false;
	}
	
	/**
	 * 更新部门
	 * @param department
	 * @param accessToken
	 * @return
	 */
	public static boolean updateDepartment(WxDepartment department, String accessToken){
		
		// 拼装更新部门的url  
	    String requestUrl = department_update_url.replace("ACCESS_TOKEN", accessToken);  
	   
	    // 将菜单对象转换成json字符串  
	    String jsonParam = JSONObject.toJSONString(department);  
	    
	    // 调用接口更新部门
	    JSONObject jsonObject = HttpRequestUtils.httpsRequest(requestUrl, "POST", jsonParam);
	    
	    if (null != jsonObject) {
	    	int errcode = jsonObject.getIntValue("errcode");
	    	if(errcode == 0)
	    		return true;
	    }
	    return false;
	}
	
	/**
	 * 删除部门
	 * @param department
	 * @param id 部门id。（注：不能删除根部门；不能删除含有子部门、成员的部门）
	 * @param accessToken
	 * @return
	 */
	public static boolean deleteDepartment(WxDepartment department, String id, String accessToken){
		
		// 拼装删除部门的url  
	    String requestUrl = department_delete_url.replace("ACCESS_TOKEN", accessToken).replace("ID", id);  
	   
	    // 将菜单对象转换成json字符串  
	    String jsonParam = JSONObject.toJSONString(department);  
	    
	    // 调用接口删除部门
	    JSONObject jsonObject = HttpRequestUtils.httpsRequest(requestUrl, "GET", jsonParam);
	    
	    if (null != jsonObject) {	    	
	    	int errcode = jsonObject.getIntValue("errcode");	    	
	    	if(errcode == 0)
	    		return true;
	    }
	    return false;
	}
	
	/**
	 * 获取部门列表
	 * @param accessToken
	 * @param id 部门id。获取指定部门及其下的子部门。 如果不填，默认获取全量组织架构
	 * @return
	 */
	public static List<WxDepartment> getAllDepartment(String accessToken, String id) {
		
		// 1.拼装创建部门的url  
	    String requestUrl = department_list_url.replace("ACCESS_TOKEN", accessToken);
	    
	    if(id != null){
	    	requestUrl = requestUrl + "&id="+id;
	    }
	    
	    // 2.调用接口获取部门列表
	    JSONObject jsonObject = HttpRequestUtils.httpsRequest(requestUrl, "GET", null);
	    
	    if (null != jsonObject) { 
	    	
	    	int errcode = jsonObject.getIntValue("errcode");	    	
	    	String departmentjson = jsonObject.getString("department");
	    	
	    	if(errcode == 0){
	    		Gson gson = new Gson();
		    	List<WxDepartment> ps = gson.fromJson(departmentjson, new TypeToken<List<WxDepartment>>(){}.getType());
		    	return ps;
	    	}else{
	    		
	    		String errmsg = jsonObject.getString("errmsg");
	    		logger.info("获取部门列表出错："+errmsg);
	    	}
	    }
	    return null;
	}
}
