package com.javafast.modules.oa.web;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolationException;

import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import org.hibernate.validator.constraints.Length;

import com.alibaba.fastjson.JSONObject;
import com.google.common.collect.Lists;
import com.javafast.common.utils.DateUtils;
import com.javafast.common.utils.MyBeanUtils;
import com.javafast.common.config.Global;
import com.javafast.common.persistence.Page;
import com.javafast.common.web.BaseController;
import com.javafast.common.utils.StringUtils;
import com.javafast.common.utils.excel.ExportExcel;
import com.javafast.common.utils.excel.ImportExcel;
import com.javafast.modules.oa.entity.OaNote;
import com.javafast.modules.oa.service.OaNoteService;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.sys.utils.UserUtils;

/**
 * 便签Controller
 * @author javafast
 * @version 2017-07-16
 */
@Controller
@RequestMapping(value = "${adminPath}/oa/oaNote")
public class OaNoteController extends BaseController {

	@Autowired
	private OaNoteService oaNoteService;
	
	@ModelAttribute
	public OaNote get(@RequestParam(required=false) String id) {
		OaNote entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = oaNoteService.get(id);
		}
		if (entity == null){
			entity = new OaNote();
		}
		return entity;
	}
	
	/**
	 * ajax保存便签
	 * @param notes
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "saveNote", method=RequestMethod.POST)
	public String saveNote(String notes) {
			
		try{
			OaNote oaNote = oaNoteService.get(UserUtils.getUser().getId());
			if(oaNote == null){
				
				oaNote = new OaNote();
				oaNote.setId(UserUtils.getUser().getId());
				oaNote.setNotes(notes);
				oaNoteService.save(oaNote);
			}else{
				oaNote.setNotes(notes);
				oaNoteService.update(oaNote);
			}
			return "true";
		}catch(Exception e){
			e.printStackTrace();
		}
		
		return "false";
	}
	
	/**
	 * ajax获取个人便签
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "getNote", method=RequestMethod.POST)
	public String getNote() {
			
		try{
			
			User user = UserUtils.getUser();
			OaNote oaNote = oaNoteService.get(user.getId());
			if(oaNote != null && StringUtils.isNotBlank(oaNote.getNotes())){
				JSONObject j = new JSONObject();
				j.put("notes", oaNote.getNotes());
				return j.toString();
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		
		return "false";
	}

}