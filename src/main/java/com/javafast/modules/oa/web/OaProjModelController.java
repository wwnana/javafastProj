package com.javafast.modules.oa.web;


import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.javafast.common.web.BaseController;
import com.javafast.modules.oa.entity.OaTask;
import com.javafast.modules.oa.service.OaProjModelService;
import com.javafast.modules.oa.service.OaTaskService;

@Controller
@RequestMapping(value = "${adminPath}/oa/oaProjModel")
public class OaProjModelController extends BaseController {
	
	@Autowired
	private OaProjModelService oaProjModelService;
	@Autowired
	private OaTaskService oaTaskService;
	
	/**
	 * 部署模型
	 * @param id    项目id
	 * @param model
	 * @return
	 */
	@RequestMapping(value="startPro")
	public String startPro(String id, Model model,RedirectAttributes redirectAttributes) {
		//根据项目ID查询所有未开始的任务
		List<OaTask> list = oaTaskService.findTaskByStatus(id,"0");
		//获取这一列任务中的procDef名称
		String procDef = list.get(0).getProcDef();
		try {
			if("项目咨询流程".equals(procDef)) {
				String name = oaProjModelService.createProjConsFlowChart(list,id);
				addMessage(redirectAttributes, "部署成功"+name);
			}else if("项目实施流程-可执行方案".equals(procDef)) {
				String name = oaProjModelService.createProjImplFlowChartFst(list,id);
				addMessage(redirectAttributes, "部署成功"+name);
			}else if("项目实施流程-详细方案".equals(procDef)) {
				String name = oaProjModelService.createProjImplFlowChartSec(list,id);
				addMessage(redirectAttributes, "部署成功"+name);
			}else if("项目实施流程-任务计划书反馈".equals(procDef)) {
				String name = oaProjModelService.createProjImplFlowChartThd(list,id);
				addMessage(redirectAttributes, "部署成功"+name);
			}else if("项目实施流程-子系统验收".equals(procDef)) {
				String name = oaProjModelService.createProjImplFlowChartFour(list,id);
				addMessage(redirectAttributes, "部署成功"+name);
			}
		}catch(Exception e) {
			e.getStackTrace();
		}
		return "redirect:" + adminPath + "/oa/oaProject/view?id="+id;
	}
	
}
