package com.javafast.api.qywx.system.api;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.javafast.common.utils.HttpRequestUtils;
import com.javafast.api.qywx.core.api.WxAccessTokenAPI;
import com.javafast.api.qywx.core.entity.AccessToken;
import com.javafast.api.qywx.system.entity.WxUser;

/**
 * 企业微信 - 成员
 * @author JavaFast
 */
public class WxUserAPI {

	private static final Logger logger = LoggerFactory.getLogger(WxUserAPI.class);

	//创建成员 
	private static String user_create_url = "https://qyapi.weixin.qq.com/cgi-bin/user/create?access_token=ACCESS_TOKEN";  
	
	//更新成员  
	private static String user_update_url = "https://qyapi.weixin.qq.com/cgi-bin/user/update?access_token=ACCESS_TOKEN";  
	
	//删除成员
	private static String user_delete_url = "https://qyapi.weixin.qq.com/cgi-bin/user/delete?access_token=ACCESS_TOKEN&userid=USERID";  
	
	//批量删除成员
	private static String user_delete_all_url = "https://qyapi.weixin.qq.com/cgi-bin/user/batchdelete?access_token=ACCESS_TOKEN";  
	
	//获取成员
	private static String user_get_url_byuserid = "https://qyapi.weixin.qq.com/cgi-bin/user/get?access_token=ACCESS_TOKEN&userid=USERID";  
	
	//获取部门成员
	private static String user_get_dep_all_url = "https://qyapi.weixin.qq.com/cgi-bin/user/simplelist?access_token=ACCESS_TOKEN&department_id=DEPARTMENT_ID&fetch_child=FETCH_CHILD";  
	
	//获取部门成员详情
	private static String user_get_dep_users_url = "https://qyapi.weixin.qq.com/cgi-bin/user/list?access_token=ACCESS_TOKEN&department_id=DEPARTMENT_ID&fetch_child=FETCH_CHILD";  
	
	/**
	 * 创建成员
	 * @param user 用户实例
	 * @param accessToken 调用接口凭证 
	 * @return
	 */
	public static boolean createUser(WxUser user, String accessToken){
		
		// 拼装获取成员列表的url  
	    String requestUrl = user_create_url.replace("ACCESS_TOKEN", accessToken);  
	    
	    // 将成员对象转换成json字符串  
	    String jsonUser = JSONObject.toJSONString(user);  
	    
	    // 调用接口创建用户 
	    JSONObject jsonObject = HttpRequestUtils.httpsRequest(requestUrl, "POST", jsonUser);
	    
	    if (null != jsonObject) {  
	    	
	    	int errcode = jsonObject.getIntValue("errcode");
	    	if(errcode == 0)
	    		return true;
	    }
	    return false;
	}
	
	/**
	 * 更新成员
	 * @param user 用户实例
	 * @param accessToken 调用接口凭证 
	 * @return
	 */
	public static boolean updateUser(WxUser user, String accessToken){
		
		// 拼装更新成员列表的url  
	    String requestUrl = user_update_url.replace("ACCESS_TOKEN", accessToken);  
	    
	    // 将成员对象转换成json字符串  
	    String jsonUser = JSONObject.toJSONString(user);  
	    
	    // 调用接口更新用户 
	    JSONObject jsonObject = HttpRequestUtils.httpsRequest(requestUrl, "POST", jsonUser);
	    
	    if (null != jsonObject) {  
	    	int errcode = jsonObject.getIntValue("errcode");
	    	if(errcode == 0)
	    		return true;
	    }  
		return false;
	}
	
	/**
	 * 删除成员
	 * @param userid
	 * @param accessToken
	 * @return
	 */
	public static boolean deleteUser(String userid, String accessToken){
		
		// 拼装删除成员列表的url  
	    String requestUrl = user_delete_url.replace("ACCESS_TOKEN", accessToken).replace("USERID", userid);  
	    
	    // 调用接口删除用户 
	    JSONObject jsonObject = HttpRequestUtils.httpsRequest(requestUrl, "GET", null);
	    
	    if (null != jsonObject) {  
	    	int errcode = jsonObject.getIntValue("errcode");
	    	if(errcode == 0)
	    		return true;
	    }  
		return false;
	}
	
	/**
	 * 批量删除成员
	 * @param useridlist
	 * @param accessToken
	 * @return
	 */
	public static boolean batchDeleteUsers(String[] useridlist, String accessToken){
		
		// 拼装批量删除成员列表的url  
	    String requestUrl = user_delete_all_url.replace("ACCESS_TOKEN", accessToken);  
	   
	    // 将成员对象转换成json字符串  
	    Map<String, String[]> paramtermap=new HashMap<String, String[]>();
	    paramtermap.put("useridlist", useridlist);
	    String jsonUserids = JSONObject.toJSONString(paramtermap); 
	   
	    // 调用接口批量删除
	    JSONObject jsonObject = HttpRequestUtils.httpsRequest(requestUrl, "POST", jsonUserids);

	    if (null != jsonObject) {  
	    	int errcode = jsonObject.getIntValue("errcode");
	    	if(errcode == 0)
	    		return true;
	    }  
		return false;
	}
	
	/**
	 * 读取成员，在通讯录同步助手中此接口可以读取企业通讯录的所有成员信息，而自建应用可以读取该应用设置的可见范围内的成员信息。
	 * @param userid
	 * @param accessToken
	 * @return
	 */
	public static WxUser getUserByUserid(String userid, String accessToken){
		
		// 拼装获取成员的url  
	    String requestUrl = user_get_url_byuserid.replace("ACCESS_TOKEN", accessToken).replace("USERID", userid);  
	    
	    // 调用接口获取成员
	    JSONObject jsonObject = HttpRequestUtils.httpsRequest(requestUrl, "GET", null);
	    
	    //把对象转换成user
	    if (null != jsonObject) {  
	    	int errcode = jsonObject.getIntValue("errcode");
	        if(errcode==0){
	        	WxUser user =	JSONObject.toJavaObject(jsonObject, WxUser.class);
	        	return user;
	        }
	    }  
		return null;
	}
	

	/**
	 * 获取部门成员
	 * @param department_id 获取的部门id
	 * @param fetch_child 1/0：是否递归获取子部门下面的成员
	 * @param accessToken
	 * @return
	 */
	public static List<WxUser> getUsersByDepartid(String department_id, String fetch_child, String accessToken){
		
		// 拼装获取部门成员的列表的url  
	    String requestUrl = user_get_dep_all_url.replace("ACCESS_TOKEN", accessToken).replace("DEPARTMENT_ID", department_id);
	    if(fetch_child!=null){
	    	requestUrl = requestUrl.replace("FETCH_CHILD", fetch_child);
	    }
	    
	    // 调用接口获取部门成员
	    JSONObject jsonObject = HttpRequestUtils.httpsRequest(requestUrl, "GET", null);
	    if (null != jsonObject) {  
	    	int errcode = jsonObject.getIntValue("errcode");
	        if(errcode==0){

	        	List<WxUser> users  = JSON.parseArray(jsonObject.getString("userlist"),WxUser.class);
	        	return users;
	        }
	    }  
		return null;
	}
	
	/**
	 * 获取部门成员详情
	 * @param department_id 获取的部门id
	 * @param fetch_child 1/0：是否递归获取子部门下面的成员
	 * @param accessToken
	 * @return
	 */
	public static List<WxUser> getDetailUsersByDepartid(String department_id, String fetch_child, String accessToken){
		if(null==fetch_child){
			fetch_child="1";
		}

		// 拼装获取部门成员(详情)的列表的url  
	    String requestUrl = user_get_dep_users_url.replace("ACCESS_TOKEN", accessToken).replace("DEPARTMENT_ID", department_id).replace("FETCH_CHILD", fetch_child);
	    
	    // 调用接口获取部门成员(详情)
	    JSONObject jsonObject = HttpRequestUtils.httpsRequest(requestUrl, "GET", null);
	    
	    System.out.println("获取部门成员详情jsonObject="+jsonObject);
	    if (null != jsonObject) {  
	    	int errcode = jsonObject.getIntValue("errcode");
	        if(errcode==0){

	        	List<WxUser> users  = JSON.parseArray(jsonObject.getString("userlist"),WxUser.class);
	        	return users;
	        }
	    }  
		return null;
	}
}
