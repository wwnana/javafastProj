package com.javafast.app.modules.oa;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSONObject;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.crm.service.CrmCustomerService;
import com.javafast.modules.iim.entity.MyCalendar;
import com.javafast.modules.iim.service.MyCalendarService;
import com.javafast.modules.sys.entity.User;

/**
 * 日程 API Controller
 * @author syh
 *
 */
@Controller
@RequestMapping(value = "${adminPath}/app/oa/oaCalendar")
public class AppOaCalendarController {

	@Autowired
	private MyCalendarService myCalendarService;
	
	@Autowired
	private CrmCustomerService crmCustomerService;
	
	/**
	 * 分页查询列表
	 * @param pageNo 当前页码
	 * @param title
	 * @return
	 */
	@SuppressWarnings("finally")
	@RequestMapping(value = "getList", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject getList(String userId, String pageNo, HttpServletRequest request, HttpServletResponse response) {
		
		JSONObject json =new JSONObject();
		json.put("code", "0");
		
		try {

			//校验输入参数
			if(StringUtils.isBlank(userId)){
				json.put("msg", "缺少参数userId");
				return json;
			}
			
			List list = myCalendarService.findListByUser(new User(userId));

			json.put("list", list);
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
	
	/**
	 * 根据ID查询
	 * @param id
	 * @return
	 */
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
			
			MyCalendar entity = myCalendarService.get(id);
			if(entity != null){
				
				json.put("entity", entity);				
				json.put("code", "1");
			}			
		} catch (Exception e) {
			
			e.printStackTrace();
		} finally {
			return json;
		}
	}
	
	
	@SuppressWarnings("finally")
	@RequestMapping(value = "save", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject save(String id, String title, String start, String end, String accountId, String userId) {
	
		JSONObject json =new JSONObject();
		json.put("code", "0");
		try {
			
			MyCalendar myCalendar;
			
			//校验输入参数
			if(StringUtils.isBlank(title) || title.length()>50){
				json.put("msg", "title参数错误");
				return json;
			}
			
			if(StringUtils.isNotBlank(id)){
				myCalendar = myCalendarService.get(id);
				myCalendar.setUpdateBy(new User(userId));
			}else{
				//新增
				myCalendar = new MyCalendar();
				
				myCalendar.setUser(new User(userId));
				myCalendar.setAccountId(accountId);
				myCalendar.setCreateBy(new User(userId));
				myCalendar.setUpdateBy(new User(userId));
			}
			
			//日程基本信息
			myCalendar.setTitle(title);
			myCalendar.setStart(start);
			
			if(StringUtils.isNotBlank(end) && start.equals(end)){
				end = null;
			}
			myCalendar.setEnd(end);
			
			//保存日程信息
			myCalendarService.save(myCalendar);
			
			json.put("id", myCalendar.getId());
			json.put("code", "1");
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			return json;
		}
	}
	
	/**
	 * 删除
	 * @param id
	 * @return
	 */
	@SuppressWarnings("finally")
	@RequestMapping(value = "del", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject del(String id) {
	
		JSONObject json =new JSONObject();
		json.put("code", "0");
		try {
			
			//校验输入参数
			if(StringUtils.isBlank(id)){
				json.put("msg", "缺少参数id");
				return json;
			}
			
			myCalendarService.delete(new MyCalendar(id));
			
			json.put("code", "1");
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			return json;
		}
	}
	
}
