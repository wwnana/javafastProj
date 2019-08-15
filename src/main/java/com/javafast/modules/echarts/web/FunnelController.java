package com.javafast.modules.echarts.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.javafast.common.web.BaseController;

/**
 * 漏斗图示例
 * @author GuJianfeng
 *
 */
@Controller
@RequestMapping(value = "${adminPath}/echarts/funnel")
public class FunnelController extends BaseController {

	@RequestMapping(value = {"index", ""})
	public String index(HttpServletRequest request, HttpServletResponse response, Model model) {
		
		Map<String,Object> orientData = new LinkedHashMap<String,Object>();//LinkedHashMap是有序的MAP实现
		orientData.put("1.初步恰接", 100);
		orientData.put("2.需求确定", 80);
		orientData.put("3.方案报价", 60);
		orientData.put("4.合同签订", 20);
		orientData.put("5.赢单", 10);
		request.setAttribute("orientData", orientData);
		
		
		return "modules/echarts/funnel";
	}
}
