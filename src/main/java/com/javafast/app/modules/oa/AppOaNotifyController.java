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

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.google.common.collect.Lists;
import com.javafast.common.persistence.Page;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.IdUtils;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.oa.entity.OaNotify;
import com.javafast.modules.oa.entity.OaNotifyRecord;
import com.javafast.modules.oa.entity.OaTask;
import com.javafast.modules.oa.service.OaNotifyService;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.service.UserService;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 通知公告 API Controller
 * @author syh
 *
 */
@Controller
@RequestMapping(value = "${adminPath}/app/oa/oaNotify")
public class AppOaNotifyController {

	@Autowired
	private OaNotifyService oaNotifyService;
	
	@Autowired
	private UserService userService;
	
	/**
	 * 分页查询列表
	 * @param pageNo 当前页码
	 * @param title
	 * @return
	 */
	@SuppressWarnings("finally")
	@RequestMapping(value = "getList", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject getList(String userId, String accountId, String pageNo, HttpServletRequest request, HttpServletResponse response) {
		
		JSONObject json =new JSONObject();
		json.put("code", "0");
		
		try {

			//校验输入参数
			if(StringUtils.isBlank(pageNo)){
				json.put("msg", "缺少参数pageNo");
				return json;
			}
			if(StringUtils.isBlank(accountId)){
				json.put("msg", "缺少参数accountId");
				return json;
			}
			if(StringUtils.isBlank(userId)){
				json.put("msg", "缺少参数userId");
				return json;
			}
			
			OaNotify oaNotify = new OaNotify();
			oaNotify.setIsApi(true);
			oaNotify.setAccountId(accountId);//企业账号
			oaNotify.setCurrentUser(new User(userId));//当前用户
			Page<OaNotify> conPage = new Page<OaNotify>(request, response);
			conPage.setPageNo(Integer.parseInt(pageNo));
			oaNotify.setPage(conPage);
			Page<OaNotify> page =oaNotifyService.findPageByUser(conPage, oaNotify);
			
			if(Integer.parseInt(pageNo) > page.getLast()){
				return null;
			}
			
			List<OaNotify> list = page.getList();
			JSONArray jsonArray = new JSONArray();
			for(int i=0;i<list.size();i++){			
				
				OaNotify obj = list.get(i);
				
				JSONObject objJson = new JSONObject();
				objJson.put("id", obj.getId());
				objJson.put("title", obj.getTitle());
				objJson.put("createDate", DateUtils.formatDate(obj.getUpdateDate(), "yyyy-MM-dd"));
				objJson.put("createName", obj.getCreateBy().getName());
				
				jsonArray.add(objJson);
			}
			
			json.put("list", jsonArray);
			json.put("lastPage", page.isLastPage());
			json.put("count", page.getCount());
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
	public JSONObject getById(String id, String userId) {
	
		JSONObject json =new JSONObject();
		json.put("code", "0");
		try {
			
			//校验输入参数
			if(StringUtils.isBlank(id)){
				json.put("msg", "缺少参数id");
				return json;
			}
			
			OaNotify entity = oaNotifyService.getById(id);
			if(entity != null){
				
				oaNotifyService.updateReadFlag(entity, new User(userId));
				
				json.put("createDate", DateUtils.formatDate(entity.getUpdateDate(), "yyyy-MM-dd"));
				json.put("createName", entity.getCreateBy().getName());
				json.put("createBy", entity.getCreateBy().getId());
				
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
	 * 保存
	 * @param id
	 * @param title
	 * @param content
	 * @param accountId
	 * @param userId
	 * @return
	 */
	@SuppressWarnings("finally")
	@RequestMapping(value = "save", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject save(String id, String title, String content, String accountId, String userId) {
	
		JSONObject json =new JSONObject();
		json.put("code", "0");
		try {
			
			OaNotify oaNotify;
			
			//校验输入参数
			if(StringUtils.isBlank(title) || title.length()>50){
				json.put("msg", "name参数错误");
				return json;
			}
			
			if(StringUtils.isNotBlank(id)){
				
				oaNotify = oaNotifyService.get(id);
				oaNotify.setTitle(title);
				oaNotify.setContent(content);
				oaNotify.setUpdateBy(new User(userId));
				oaNotifyService.update(oaNotify);
			}else{
				
				oaNotify = new OaNotify();
				
				oaNotify.setTitle(title);
				oaNotify.setContent(content);
				oaNotify.setAccountId(accountId);
				oaNotify.setCreateBy(new User(userId));
				oaNotify.setUpdateBy(new User(userId));
				oaNotify.setType("2");
				oaNotify.setStatus("1");
				
				List<OaNotifyRecord> oaNotifyRecordList = Lists.newArrayList();
				User conUser = new User();
				conUser.setIsApi(true);
				conUser.setAccountId(accountId);
				conUser.getSqlMap().put("dsf", " AND a.account_id='"+accountId+"' ");
				List<User> userList = userService.findList(conUser);
				for(int i=0;i<userList.size();i++){
					User user = userList.get(i);
					OaNotifyRecord oaNotifyRecord = new OaNotifyRecord();
					oaNotifyRecord.setOaNotify(oaNotify);
					oaNotifyRecord.setUser(user);
					oaNotifyRecord.setReadFlag("0");
					oaNotifyRecord.setAccountId(accountId);
					oaNotifyRecord.setId(IdUtils.getId());
					oaNotifyRecordList.add(oaNotifyRecord);
				}
				oaNotify.setOaNotifyRecordList(oaNotifyRecordList);
				
				oaNotifyService.save(oaNotify);
			}
			
			json.put("id", oaNotify.getId());
			json.put("code", "1");
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			return json;
		}
	}
}
