package com.javafast.app.modules.oa;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.javafast.common.persistence.Page;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.oa.entity.OaWorkLog;
import com.javafast.modules.sys.entity.Office;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.service.OfficeService;
import com.javafast.modules.sys.service.UserService;
import com.javafast.modules.sys.utils.Contants;
import com.javafast.modules.sys.utils.DictUtils;

/**
 * APP接口 通讯录
 * @author syh
 *
 */
@Controller
@RequestMapping(value = "${adminPath}/app/oa/oaContact")
public class AppContactController {

	@Autowired
	private UserService userService;
	
	@Autowired
	private OfficeService officeService;
	
	@SuppressWarnings("finally")
	@RequestMapping(value = "getList", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject getList(String userId, String accountId, String pageNo, HttpServletRequest request, HttpServletResponse response) {
		
		JSONObject json =new JSONObject();
		json.put("code", "0");
		
		try {

			//校验输入参数
			if(StringUtils.isBlank(accountId)){
				json.put("msg", "缺少参数accountId");
				return json;
			}
			if(StringUtils.isBlank(userId)){
				json.put("msg", "缺少参数userId");
				return json;
			}
			
			User user = new User();
			user.setIsApi(true);
			user.setAccountId(accountId);//企业账号
			user.setCurrentUser(new User(userId));//当前用户

			List<User> list = userService.findUser(user);
			
			JSONArray jsonArray = new JSONArray();
			for(int i=0;i<list.size();i++){			
				
				User obj = list.get(i);
				
				JSONObject objJson = new JSONObject();
				objJson.put("id", obj.getId());
				objJson.put("name", obj.getName());
				objJson.put("mobile", obj.getMobile());
				objJson.put("officeName", obj.getOffice().getName());
				
				if(StringUtils.isNotBlank(obj.getPhoto())){
					if(!obj.getPhoto().contains("http")){
						objJson.put("photo", Contants.SITE_URL + obj.getPhoto());
					}else{
						objJson.put("photo", obj.getPhoto());
					}
				}else{
					objJson.put("photo", Contants.SITE_URL + Contants.TEMP_USER_IMG);
				}
				
				jsonArray.add(objJson);
			}
			
			json.put("list", jsonArray);
			json.put("lastPage", true);
			json.put("count", list.size());
			json.put("code", "1");
		} catch (Exception e) {
			json.put("error", "");
			e.printStackTrace();
		} finally {
			return json;
		}
	}
	
	@SuppressWarnings("finally")
	@RequestMapping(value = "getById", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject getById(String id) {
	
		JSONObject json =new JSONObject();
		json.put("code", "0");
		try {
			
			//校验输入参数
			if(StringUtils.isBlank(id)){
				json.put("msg", "缺少参数id");
				return json;
			}
			
			User entity = userService.get(id);
			if(entity != null){
				
				
				json.put("officeName", entity.getOffice().getName());
				json.put("companyName", entity.getCompany().getName());
				
				if(StringUtils.isNotBlank(entity.getPhoto())){
					if(!entity.getPhoto().contains("http")){
						entity.setPhoto(Contants.SITE_URL + entity.getPhoto());
					}
				}
				
				json.put("entity", entity);		
				json.put("code", "1");
			}			
		} catch (Exception e) {
			
			e.printStackTrace();
		} finally {
			return json;
		}
	}
	
	
	/**
	 * 查询组织架构
	 * @param accountId
	 * @param parentId
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@SuppressWarnings("finally")
	@RequestMapping(value = "getOfficeList", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject getOfficeList(String accountId, String officeId, HttpServletRequest request, HttpServletResponse response, Model model) {
		
		JSONObject json =new JSONObject();
		json.put("code", "0");
		
		Office conOffice = new Office();
		conOffice.setIsApi(true);
		conOffice.setAccountId(accountId);
		
		if(StringUtils.isBlank(officeId)){
			officeId = "0";			
		}
		conOffice.setParent(new Office(officeId));
		List<Office> officeList = officeService.findList(conOffice);
		json.put("officeList", officeList);
		
		List<User> userList = userService.findUserByOfficeId(officeId);
		json.put("userList", userList);
		
		json.put("code", "1");
		return json;
	}
}
