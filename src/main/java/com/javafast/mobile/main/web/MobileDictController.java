package com.javafast.mobile.main.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.javafast.common.mapper.JsonMapper;
import com.javafast.modules.sys.utils.DictUtils;

@Controller
@RequestMapping(value = "${adminPath}/mobile/sys/dict")
public class MobileDictController {

	/**
	 * 
	 * @param type
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "getDictList")
	public String getDictList(String type){
		
		return JsonMapper.getInstance().toJson(DictUtils.getDictList(type));
	}
}
