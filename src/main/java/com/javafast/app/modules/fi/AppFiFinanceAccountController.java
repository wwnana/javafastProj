package com.javafast.app.modules.fi;

import java.math.BigDecimal;
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
import com.javafast.common.persistence.Page;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.fi.entity.FiFinanceAccount;
import com.javafast.modules.fi.service.FiFinanceAccountService;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.utils.DictUtils;

/**
 * 结算账户 API Controller
 * @author syh
 *
 */
@Controller
@RequestMapping(value = "${adminPath}/app/fi/fiFinanceAccount")
public class AppFiFinanceAccountController {

	@Autowired
	private FiFinanceAccountService fiFinanceAccountService;
	
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
			
			FiFinanceAccount fiFinanceAccount = new FiFinanceAccount();
			fiFinanceAccount.setIsApi(true);
			fiFinanceAccount.setAccountId(accountId);//企业账号
			fiFinanceAccount.setCurrentUser(new User(userId));//当前用户
			Page<FiFinanceAccount> conPage = new Page<FiFinanceAccount>(request, response);
			conPage.setPageNo(Integer.parseInt(pageNo));
			fiFinanceAccount.setPage(conPage);
			Page<FiFinanceAccount> page =fiFinanceAccountService.findPage(conPage, fiFinanceAccount);
			
			if(Integer.parseInt(pageNo) > page.getLast()){
				return null;
			}
			
			List<FiFinanceAccount> list = page.getList();
			JSONArray jsonArray = new JSONArray();
			for(int i=0;i<list.size();i++){			
				
				FiFinanceAccount obj = list.get(i);
				
				JSONObject objJson = new JSONObject();
				objJson.put("id", obj.getId());
				objJson.put("name", obj.getName());
				
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
	public JSONObject getById(String id) {
	
		JSONObject json =new JSONObject();
		json.put("code", "0");
		try {
			
			//校验输入参数
			if(StringUtils.isBlank(id)){
				json.put("msg", "缺少参数id");
				return json;
			}
			
			FiFinanceAccount entity = fiFinanceAccountService.get(id);
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
	
	/**
	 * 保存
	 * @param id
	 * @param name
	 * @return
	 */
	@SuppressWarnings("finally")
	@RequestMapping(value = "save", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject save(String id, String name, String remarks, String accountId, String userId) {
	
		JSONObject json =new JSONObject();
		json.put("code", "0");
		try {
			
			FiFinanceAccount fiFinanceAccount;
			
			//校验输入参数
			if(StringUtils.isBlank(name) || name.length()>50){
				json.put("msg", "name参数错误");
				return json;
			}
			
			if(StringUtils.isNotBlank(id)){
				fiFinanceAccount = fiFinanceAccountService.get(id);
				fiFinanceAccount.setUpdateBy(new User(userId));
			}else{
				//新增
				fiFinanceAccount = new FiFinanceAccount();
				
				fiFinanceAccount.setAccountId(accountId);
				fiFinanceAccount.setCreateBy(new User(userId));
				fiFinanceAccount.setUpdateBy(new User(userId));
			}
			
			//结算账户基本信息
			fiFinanceAccount.setName(name);
			fiFinanceAccount.setRemarks(remarks);
			
			//保存结算账户信息
			fiFinanceAccountService.save(fiFinanceAccount);
			
			json.put("id", fiFinanceAccount.getId());
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
	public JSONObject delById(String id) {
	
		JSONObject json =new JSONObject();
		json.put("code", "0");
		try {
			
			//校验输入参数
			if(StringUtils.isBlank(id)){
				json.put("msg", "缺少参数id");
				return json;
			}
			
			fiFinanceAccountService.delete(new FiFinanceAccount(id));
			
			json.put("code", "1");
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			return json;
		}
	}
}
