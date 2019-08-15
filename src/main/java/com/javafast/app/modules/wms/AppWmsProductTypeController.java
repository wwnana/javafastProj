package com.javafast.app.modules.wms;

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
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.utils.DictUtils;
import com.javafast.modules.wms.entity.WmsProduct;
import com.javafast.modules.wms.entity.WmsProductType;
import com.javafast.modules.wms.service.WmsProductTypeService;

/**
 * 产品 API Controller
 * @author syh
 *
 */
@Controller
@RequestMapping(value = "${adminPath}/app/wms/wmsProductType")
public class AppWmsProductTypeController {

	@Autowired
	private WmsProductTypeService wmsProductTypeService;
	
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
			
			WmsProductType wmsProductType = new WmsProductType();
			wmsProductType.setIsApi(true);
			wmsProductType.setAccountId(accountId);//企业账号
			List<WmsProductType> list = wmsProductTypeService.findList(wmsProductType);
			
			JSONArray jsonArray = new JSONArray();
			for(int i=0;i<list.size();i++){			
				
				WmsProductType obj = list.get(i);
				
				JSONObject objJson = new JSONObject();
				objJson.put("id", obj.getId());
				objJson.put("name", obj.getName());
				
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
			
			WmsProductType entity = wmsProductTypeService.get(id);
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
	public JSONObject save(String id, String name, String accountId, String userId) {
	
		JSONObject json =new JSONObject();
		json.put("code", "0");
		try {
			
			WmsProductType wmsProductType;
			
			//校验输入参数
			if(StringUtils.isBlank(name) || name.length()>50){
				json.put("msg", "name参数错误");
				return json;
			}
			
			if(StringUtils.isNotBlank(id)){
				wmsProductType = wmsProductTypeService.get(id);
				wmsProductType.setUpdateBy(new User(userId));
			}else{
				//新增
				wmsProductType = new WmsProductType();
				
				wmsProductType.setAccountId(accountId);
				wmsProductType.setCreateBy(new User(userId));
				wmsProductType.setUpdateBy(new User(userId));
			}
			
			//产品基本信息
			wmsProductType.setName(name);
			
			//保存产品信息
			wmsProductTypeService.save(wmsProductType);
			
			json.put("id", wmsProductType.getId());
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
			
			wmsProductTypeService.delete(new WmsProductType(id));
			
			json.put("code", "1");
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			return json;
		}
	}
}
